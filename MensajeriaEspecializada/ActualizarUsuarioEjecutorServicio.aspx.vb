Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer

Public Class ActualizarUsuarioEjecutorServicio
    Inherits System.Web.UI.Page


#Region "Atributos"

    Private oExcel As ExcelFile
    Dim regExp As New System.Text.RegularExpressions.Regex("([0-9]{15}|[0-9]{17})")
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
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Or Not IsCallback Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Actualizar Usuario Ejecutor")
                End With
            End If
            MetodosComunes.setGemBoxLicense()

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub btnExportar_Click(sender As Object, e As EventArgs) Handles btnExportar.Click
        gveExportadorErrores.WriteXlsxToResponse("ErroresCargueCierreCicloDevolucion")
    End Sub

    Private Sub CperroresCallback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cperrores.Callback
        Try

            If Session("dtResultado") Is Nothing Then
                miEncabezado.showSuccess("El Cambio se Ejecuto Correctamente")
            Else
                With gvErrores
                    .DataSource = CType(Session("dtResultado"), DataTable)
                    .DataBind()
                End With
                rpLogErrores.Visible = True
            End If
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Protected Sub gvErrores_DataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        gvErrores.DataSource = CType(Session("dtResultado"), DataTable)
    End Sub
    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaActualizarUsuarioEjecutor.xlsx")
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
            Response.Redirect(filename, False)

        Catch ex As Exception
            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub

#End Region
#Region "Métodos Privados"
    Private Sub upArchivo_FileUploadComplete(sender As Object, e As DevExpress.Web.FileUploadCompleteEventArgs) Handles upArchivo.FileUploadComplete
        Try
            Limpiar()
            If upArchivo.HasFile Then
                Dim fileExtension As String = Path.GetExtension(upArchivo.FileName)
                Dim numColumnas As Integer
                Dim resultado As Integer = -1
                Dim idUsuario As Integer = CInt(Session("usxp001"))
                Session.Remove("dtResultado")
                Dim dtUsuarioEjecutor As New DataTable()
                oExcel = New ExcelFile()
                oExcel.CsvParseNumbersDuringLoad = False
                Try
                    If fileExtension.ToUpper = ".XLS" Then
                        oExcel.LoadXls(New MemoryStream(upArchivo.UploadedFiles(0).FileBytes))
                    ElseIf fileExtension.ToUpper = ".XLSX" Then
                        oExcel.LoadXlsx(New MemoryStream(upArchivo.UploadedFiles(0).FileBytes), XlsxOptions.None)
                    ElseIf fileExtension.ToUpper = ".TXT" Then
                        oExcel.LoadCsv(New MemoryStream(upArchivo.UploadedFiles(0).FileBytes), CsvType.CommaDelimited)
                    End If
                Catch ex As Exception
                    miEncabezado.showError("El archivo que intenta abrir, tiene un formato diferente al especificado por la extensión del archivo, por favor ábralo y guárdelo en el formato correcto: ")
                    CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                    CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                    Exit Sub
                End Try
                Dim oWs As ExcelWorksheet = oExcel.Worksheets.ActiveWorksheet
                numColumnas = oWs.CalculateMaxUsedColumns()

                If numColumnas = 2 Then
                    dtUsuarioEjecutor = CrearEstructuraDeTabla()
                    Dim filaInicial As Integer = oWs.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWs.Cells.FirstColumnIndex


                    AddHandler oWs.ExtractDataEvent, AddressOf ExtractDataErrorHandler
                    oWs.ExtractToDataTable(dtUsuarioEjecutor, oWs.Rows.Count, ExtractDataOptions.SkipEmptyRows, oWs.Rows(filaInicial), oWs.Columns(columnaInicial))

                    If dtUsuarioEjecutor.Rows(0).Item(0).ToString().ToUpper() <> "RADICADO" Then
                        RegError("0", "Verifique que exista una columna llamada Radicado  y sea la columna 1 en el archivo, la columna actual se llama: " & dtUsuarioEjecutor.Rows(0).Item(0).ToString(), "")
                    End If
                    If Session("dtResultado") Is Nothing Then
                        dtUsuarioEjecutor.Rows(0).Delete()
                    Else
                        CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                        Exit Sub
                    End If

                    dtUsuarioEjecutor.Columns.Add(New DataColumn("Fila"))
                    Dim fil As Integer = 1
                    For Each row As DataRow In dtUsuarioEjecutor.Rows
                        If IsNumeric(row("RADICADO")) Then
                            row("Fila") = fil
                            fil = fil + 1
                        Else
                            RegError(fil, "El radicado tiene caracteres no validos o no cumple con la longitud requerida" & dtUsuarioEjecutor.Rows(0).Item(0).ToString(), dtUsuarioEjecutor.Rows(0).Item(0).ToString())

                        End If
                    Next
                    If Session("dtResultado") Is Nothing Then

                        dtUsuarioEjecutor.Columns.Add(New DataColumn("idUsuario", GetType(System.Int64), idUsuario))
                        Dim dcfecha As New DataColumn("fechaCierre", GetType(System.DateTime))
                        Dim cargueRadicado As New ActualizarUsuarioEjecutorServicioCem()
                        Session("dtResultado") = cargueRadicado.AcualizarUsuarioEjecutor(dtUsuarioEjecutor, idUsuario, resultado)
                        If (resultado = 0) Then
                            With gvErrores
                                .DataSource = CType(Session("dtResultado"), DataTable)
                                .DataBind()
                            End With
                            miEncabezado.showSuccess("La actualizacion se Ejecuto Correctamente ")
                            CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 1

                        Else
                            With gvErrores
                                .DataSource = CType(Session("dtResultado"), DataTable)
                                .DataBind()
                            End With
                            miEncabezado.showError("No se pudo realizar la actualización por favor verificar el log de errores : ")
                            CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                        End If

                    Else
                        CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                    End If


                Else
                    RegError(" ", "No se puede procesar el archivo, ya que contiene menos columnas que las esperadas. Por favor verifique", "")
                    CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
                End If

            End If

            e.CallbackData = e.UploadedFile.PostedFile.FileName
            CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
        End Try
    End Sub

    Private Sub Limpiar()
        Try
            miEncabezado.clear()
            Session.Remove("dtResultado")
             rpLogErrores.Visible = False


        Catch ex As Exception
            miEncabezado.showError("Error Al limpiar los campos . " & ex.Message & "<br><br>")
            'CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
        End Try
    End Sub
    Private Sub RegError(ByVal vFila As String, ByVal vMensaje As String, ByVal vSerial As String)
        Try
            Dim dtError As New DataTable
            If Session("dtResultado") Is Nothing Then
                dtError.Columns.Add(New DataColumn("Fila", GetType(String)))
                dtError.Columns.Add(New DataColumn("Mensaje", GetType(String)))
                dtError.Columns.Add(New DataColumn("Radicado", GetType(String)))
                Session("dtResultado") = dtError
            Else
                dtError = Session("dtResultado")
            End If
            Dim dr As DataRow = dtError.NewRow()
            dr("Fila") = vFila
            dr("Mensaje") = vMensaje
            dr("Radicado") = vSerial
            dtError.Rows.Add(dr)
            Session("dtResultado") = dtError
        Catch ex As Exception
            miEncabezado.showError("Error al registra errores . " & ex.Message & "<br><br>")
        End Try
    End Sub
    Private Function CrearEstructuraDeTabla() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add(New DataColumn("RADICADO", GetType(String)))
            dtAux.Columns.Add(New DataColumn("Ejecutor", GetType(String)))
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
#End Region

    Protected Sub gvErrores_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvErrores.CustomCallback
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
    End Sub

    Protected Sub gvErrores_CustomDataCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomDataCallbackEventArgs) Handles gvErrores.CustomDataCallback
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
    End Sub

End Class