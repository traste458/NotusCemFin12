Imports GemBox.Spreadsheet
Imports System.IO
Imports DevExpress.Web
Imports ILSBusinessLayer

Public Class creacionUsuarioMasivo
    Inherits System.Web.UI.Page


#Region "Atributos"

    Private oExcel As ExcelFile

#End Region

#Region "Propiedades"

    Public ReadOnly Property archivoResultado() As Boolean
        Get
            If Session("dtResultado") Is Nothing Then
                Return False
            Else
                Return (CType(Session("dtResultado"), DataTable).Rows.Count > 0)
            End If
        End Get
    End Property

#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 20608  '2009
        Session("usxp009") = 180  '185
        Session("usxp007") = 150
        Session("usxp014") = "192.127.62.1"
#End If
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Creacion Usuarios Masivo")
                End With
                limpiar()
            End If
            MetodosComunes.setGemBoxLicense()

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub btnExportar_Click(sender As Object, e As EventArgs) Handles btnExportar.Click
        gveExportadorErrores.WriteXlsxToResponse("ErroresCambioMaterialSerial")
    End Sub

    Private Sub cperrores_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cperrores.Callback
        Try
            If Not Session("dtResultado") Is Nothing Then
                With gvErrores
                    .DataSource = CType(Session("dtResultado"), DataTable)
                    .DataBind()
                End With
                rpLogErrores.Visible = True
            End If

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Protected Sub gvErrores_DataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        gvErrores.DataSource = CType(Session("dtResultado"), DataTable)
    End Sub
    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try
            miEncabezado.clear()
            Dim filename As String = Server.MapPath("Plantillas/EjemploCreacionDeUsuarioMasivo.xlsx")
            If filename <> "" Then
                Dim file As System.IO.FileInfo = New System.IO.FileInfo(filename)
                If file.Exists Then
                    Response.Clear()
                    Response.AddHeader("Content-Disposition", "attachment; filename=" & file.Name)
                    Response.AddHeader("Content-Length", file.Length.ToString())
                    Response.ContentType = "application/octet-stream"
                    Response.WriteFile(file.FullName)
                    Response.End()

                Else
                    Response.Write("Este archivo no existe.")

                End If

            End If
            Response.Redirect("Plantillas/EjemploCreacionDeUsuarioMasivo.xlsx", False)

        Catch ex As Exception
            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub

#End Region
#Region "Métodos Privados"
    Private Sub upArchivo_FileUploadComplete(sender As Object, e As FileUploadCompleteEventArgs) Handles upArchivo.FileUploadComplete
        Try
            miEncabezado.clear()
            limpiar()
            If upArchivo.HasFile Then
                Dim fileExtension As String = Path.GetExtension(upArchivo.FileName)
                Dim numColumnas As Integer
                Dim resultado As Integer = -1
                Session.Remove("dtResultado")
                Dim dtInformacionGeneral As New DataTable()
                oExcel = New ExcelFile()
                Try
                    If fileExtension.ToUpper = ".XLS" Then
                        oExcel.LoadXls(New MemoryStream(upArchivo.UploadedFiles(0).FileBytes))
                    ElseIf fileExtension.ToUpper = ".XLSX" Then
                        oExcel.LoadXlsx(New MemoryStream(upArchivo.UploadedFiles(0).FileBytes), XlsxOptions.None)
                    End If
                Catch ex As Exception
                    miEncabezado.showError("El archivo que intenta abrir, tiene un formato diferente al especificado por la extensión del archivo, por favor ábralo y guárdelo en el formato correcto: ")
                    CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                    CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                    Exit Sub
                End Try
                Dim oWs As ExcelWorksheet = oExcel.Worksheets.ActiveWorksheet
                numColumnas = oWs.CalculateMaxUsedColumns()
                If numColumnas = 6 Then
                    dtInformacionGeneral = CrearEstructuraDeTabla()
                    Dim filaInicial As Integer = oWs.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWs.Cells.FirstColumnIndex
                    AddHandler oWs.ExtractDataEvent, AddressOf ExtractDataErrorHandler
                    oWs.ExtractToDataTable(dtInformacionGeneral, oWs.Rows.Count, ExtractDataOptions.SkipEmptyRows, oWs.Rows(filaInicial), oWs.Columns(columnaInicial))
                    If Not dtInformacionGeneral.Rows(0).Item(0).ToString().ToLower() = "Nombres y Apellidos".ToLower() Then
                        RegError("0", "", "", "", " ", " ", " ", "Verifique que exista una columna llamada Nombres y Apellidos  y sea la columna 1 en el archivo, la columna actual se llama: " & dtInformacionGeneral.Rows(0).Item(0).ToString())
                    End If
                    If Session("dtResultado") Is Nothing Then
                        dtInformacionGeneral.Rows(0).Delete()
                    Else
                        CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                        Exit Sub
                    End If
                    dtInformacionGeneral.Columns.Add(New DataColumn("Fila"))
                    Dim fil As Integer = 1
                    For Each row As DataRow In dtInformacionGeneral.Rows
                        row("Fila") = fil
                        fil = fil + 1
                    Next
                    ValidarInformacionArchivo(dtInformacionGeneral)
                    If Session("dtResultado") Is Nothing Then
                        Dim cargueSeriales As New CreacionUsuariosMasiva()
                        With cargueSeriales
                            .IdUsuario = CInt(Session("usxp001"))
                            Session("dtResultado") = .CrearUsuarios(dtInformacionGeneral)
                            If .Resultado = 0 Then
                                miEncabezado.showWarning("No se pudo realizar el cambio solicitado por Favor verifique el log de errores")
                                If Not Session("dtResultado") Is Nothing Then
                                    With gvErrores
                                        .DataSource = CType(Session("dtResultado"), DataTable)
                                        .DataBind()
                                    End With
                                End If

                                CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                                CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0

                            Else
                                miEncabezado.showSuccess("El cambio fue realizado correctamente ")
                                CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                                CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 1
                            End If
                        End With

                    Else
                        CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                    End If
                ElseIf numColumnas > 9 Then
                    RegError(" ", "", " ", " ", " ", " ", " ", "No se puede procesar el archivo, ya que contiene más columnas que las esperadas. Por favor verifique")
                    CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                Else
                    RegError(" ", "", " ", " ", " ", " ", " ", "No se puede procesar el archivo, ya que contiene menos columnas que las esperadas. Por favor verifique")
                    CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                End If
            End If

            e.CallbackData = e.UploadedFile.PostedFile.FileName
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
        End Try
    End Sub

    Private Sub limpiar()
        Try
            Session.Remove("ArchivoAdescargar")
            Session.Remove("dtResultado")
            rpLogErrores.Visible = False

        Catch ex As Exception
            miEncabezado.showError("Error Al limpiar los campos . " & ex.Message & "<br><br>")
        End Try
    End Sub
    Private Sub RegError(ByVal lineaArchivo As String, ByVal nombreApellido As String, ByVal Identificacion As String, ByVal Cargo As String, ByVal Ciudad As String, ByVal Usuario As String, ByVal Correo As String, ByVal mensaje As String)
        Try
            Dim dtError As New DataTable
            If Session("dtResultado") Is Nothing Then
                dtError.Columns.Add(New DataColumn("lineaArchivo", GetType(String)))
                dtError.Columns.Add(New DataColumn("nombreApellido", GetType(String)))
                dtError.Columns.Add(New DataColumn("Identificacion", GetType(String)))
                dtError.Columns.Add(New DataColumn("Cargo", GetType(String)))
                dtError.Columns.Add(New DataColumn("Ciudad", GetType(String)))
                dtError.Columns.Add(New DataColumn("Usuario", GetType(String)))
                dtError.Columns.Add(New DataColumn("Correo", GetType(String)))
                dtError.Columns.Add(New DataColumn("descripcion", GetType(String)))
                Session("dtResultado") = dtError
            Else
                dtError = Session("dtResultado")
            End If
            Dim dr As DataRow = dtError.NewRow()
            dr("lineaArchivo") = lineaArchivo
            dr("nombreApellido") = nombreApellido
            dr("Identificacion") = Identificacion
            dr("Cargo") = Cargo
            dr("Ciudad") = Ciudad
            dr("Usuario") = Usuario
            dr("Correo") = Correo
            dr("descripcion") = mensaje
            dtError.Rows.Add(dr)
            Session("dtResultado") = dtError
        Catch ex As Exception
            miEncabezado.showError("Error al registra errores . " & ex.Message & "<br><br>")
        End Try
    End Sub
    Private Function CrearEstructuraDeTabla() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add(New DataColumn("nombreApellido", GetType(String)))
            dtAux.Columns.Add(New DataColumn("Identificacion", GetType(String)))
            dtAux.Columns.Add(New DataColumn("Cargo", GetType(String)))
            dtAux.Columns.Add(New DataColumn("Ciudad", GetType(String)))
            dtAux.Columns.Add(New DataColumn("Usuario", GetType(String)))
            dtAux.Columns.Add(New DataColumn("Correo", GetType(String)))
        End With
        Return dtAux
    End Function

    Private Sub ExtractDataErrorHandler(sender As Object, e As ExtractDataDelegateEventArgs)
        If e.ErrorID = ExtractDataError.WrongType Then
            If Not IsNumeric(e.ExcelValue) And e.ExcelValue = Nothing Then
                e.DataTableValue = Nothing
            Else
                e.DataTableValue = e.ExcelValue.ToString()
            End If

            If e.DataTableValue = Nothing Then
                e.Action = ExtractDataEventAction.SkipRow
            Else
                e.Action = ExtractDataEventAction.Continue
            End If
        End If
    End Sub
    Private Sub ValidarInformacionArchivo(ByVal Dtdatos As DataTable)
        Try
            For Each row As DataRow In Dtdatos.Rows
                If (row("nombreApellido").ToString().Length = 0) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "El Serial es un valor requerido")
                ElseIf (row("nombreApellido").ToString().Length > 50) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "La (Nombre) Supera los caracteres permitidos")
                End If

                If (row("Identificacion").ToString().Length = 0) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "La identificación es Requerida")
                ElseIf (row("Identificacion").ToString().Length > 20) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "La (Nombre) Supera los caracteres permitidos")
                End If
                If (row("Cargo").ToString().Length = 0) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "El cargo es Requerida")
                ElseIf (row("Cargo").ToString()).Length > 50 Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "La (Cargo) Supera los caracteres permitidos")
                End If
                If (row("Ciudad").ToString().Length = 0) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "LA Ciudad es Requerida")
                ElseIf (row("Ciudad").ToString()).Length > 50 Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "La (Ciudad) Supera los caracteres permitidos")
                End If
                If (row("Usuario").ToString().Length = 0) Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "El Usuario es Requerida")
                ElseIf (row("Usuario").ToString()).Length > 20 Then
                    RegError(row("Fila"), row("nombreApellido").ToString(), row("Identificacion").ToString(), row("Cargo").ToString(), row("Ciudad").ToString(), row("Usuario").ToString(), row("Correo").ToString(), "El (Usuario) Supera los caracteres permitidos")
                End If
            Next
        Catch ex As Exception
            miEncabezado.showError("Error al validar la información. " & ex.Message & "<br><br>")
        End Try
    End Sub


#End Region
End Class