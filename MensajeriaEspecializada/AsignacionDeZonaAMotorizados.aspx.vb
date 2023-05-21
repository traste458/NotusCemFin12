Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports DevExpress.Web
Imports ILSBusinessLayer.Localizacion
Imports System.Linq
Imports GemBox.Spreadsheet
Imports System.IO

Public Class AsignacionDeZonaAMotorizados
    Inherits System.Web.UI.Page

#Region "Propiedades"


    Private oExcel As ExcelFile
    Dim regExp As New System.Text.RegularExpressions.Regex("([0-9]{15}|[0-9]{17})")

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        'ddlZona.GridView.Width = ddlZona.Width
        miEncabezado.clear()
        MetodosComunes.setGemBoxLicense()
        Try
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración de Zona a Motorizados ")
                End With
            End If
            CargarCiudad()
            CargarZona()
            CargarTipoServicio()
            If cpPrincipal.IsCallback Then
                If Session("dtusuario") IsNot Nothing Then cmbUsuario.DataSource = Session("dtusuario")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub
#End Region

#Region "Métodos Privados"
    Public Function CopyToDataTableOverride(Of T As DataRow)(ByVal Source As EnumerableRowCollection(Of T)) As DataTable
        If Source.Count = 0 Then
            Return New DataTable
        Else
            Return DataTableExtensions.CopyToDataTable(Of DataRow)(Source)
        End If
    End Function
#End Region

#Region "Eventos"
    Protected Sub cmbUsuario_DataBinding(sender As Object, e As EventArgs) Handles cmbUsuario.DataBinding
        If Session("dtusuario") IsNot Nothing Then cmbUsuario.DataSource = Session("dtusuario")
    End Sub
    Protected Sub cmbUsuario_OnItemsRequestedByFilterCondition_SQL(source As Object, e As ListEditItemsRequestedByFilterConditionEventArgs)
        Dim dtusuario As New DataTable
        Dim objUsuario As New AdministracionZonaUsuario()
        dtusuario = objUsuario.CargarUsuariosParaAsignacionZona(e.Filter, e.BeginIndex + 1, e.EndIndex + 1)
        Session("dtusuario") = dtusuario
        With cmbUsuario
            .DataSource = dtusuario
            .DataBind()
        End With
        With cmbUsuario
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            End If
        End With

    End Sub

    Protected Sub cmbUsuario_OnItemRequestedByValue_SQL(source As Object, e As ListEditItemRequestedByValueEventArgs)
        If e.Value = Nothing Then
            Return
        End If
        If Session("dtusuario") IsNot Nothing Then
            Dim data As DataTable = Session("dtusuario")
            Dim query = From r In data Where r.Field(Of String)("Usuario") = e.Value Select r
            Dim tdata As DataTable = CopyToDataTableOverride(query)
            If tdata.Rows.Count = 0 Then
                Return
            ElseIf tdata.Rows.Count > 1 Then
                With cmbUsuario
                    .DataSource = tdata
                    .DataBind()
                End With
            Else
                With cmbUsuario
                    .DataSource = tdata
                    .DataBind()
                End With
            End If
        End If
        With cmbUsuario
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedIndex = -1
            End If
        End With
    End Sub

    Protected Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        Try
            Dim dtZona As New DataTable
            Dim dtTipoServicio As New DataTable
            Dim objZona As New AdministracionZonaUsuario()
            Dim objTipoServicio As New AdministracionZonaUsuario()
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "ConsultarUsuario"
                    LimpiarCampos()
                    With objZona
                        dtZona = objZona.ConsultarZona(arryAccion(1).ToString())
                        Dim rows As DataRow
                        With ddlZona
                            .DataSource = dtZona
                            .DataBind()
                            For Each rows In dtZona.Rows
                                txtMsisdn.Value = rows(5)
                                txtPlaca.Value = rows(6)
                                ddlCiudad.Value = Convert.ToInt32(rows(4))
                                If Convert.ToBoolean(rows(1)) Then
                                    .GridView.Selection.SetSelection((Convert.ToInt32(rows(0)) - 1), 1)
                                End If
                            Next
                        End With
                    End With
                    With objTipoServicio
                        dtTipoServicio = objTipoServicio.ConsultarTipoServicio(arryAccion(1).ToString())
                        Dim rowsts As DataRow
                        With ddlTipoServicio
                            .DataSource = dtTipoServicio
                            .DataBind()
                            For Each rowsts In dtTipoServicio.Rows
                                If Convert.ToBoolean(rowsts(0)) Then
                                    .GridView.Selection.SetSelection((Convert.ToInt32(rowsts(1)) - 1), 1)
                                End If
                            Next



                        End With
                    End With
                Case "ActualizarUsuario"
                    'If (cmbUsuario = "") Then
                    With objZona
                        dtZona = objZona.ModificacionMotorizado(arryAccion(1).ToString(), arryAccion(2).ToString(), arryAccion(3).ToString(), arryAccion(4).ToString(), arryAccion(5).ToString(), arryAccion(6).ToString())
                        With ddlZona
                            .DataSource = dtZona
                            .DataBind()

                        End With
                        miEncabezado.showSuccess("El Usuario ha sido actualizado")
                    End With
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub CargarCiudad()
        Dim dtCiudad As New DataTable
        Dim datos As New Ciudad
        Try
            dtCiudad = HerramientasMensajeria.ObtenerCiudadesCem(ciudadesCercanas:=Enumerados.EstadoBinario.Inactivo)
            With ddlCiudad
                .DataSource = dtCiudad
                .TextField = "Ciudad"
                .ValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListEditItem("Seleccione...", Nothing))
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try


    End Sub

    Private Sub CargarZona()
        Dim dtZona As New DataTable
        Dim objZona As New AdministracionZonaUsuario()
        Try
            dtZona = objZona.ConsultarZona(1)
            With ddlZona
                .DataSource = dtZona
                .DataBind()

            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de las zonas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTipoServicio()
        Dim dtTipoServicio As New DataTable
        Dim objTipoServicio As New AdministracionZonaUsuario()
        Try
            dtTipoServicio = objTipoServicio.ConsultarTipoServicio(1)
            With ddlTipoServicio
                .DataSource = dtTipoServicio
                .DataBind()

            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de los tipos de sevicios. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarCampos()
        txtMsisdn.Value = ""
        ddlCiudad.SelectedIndex = -1
        ddlZona.Value = ""
        ddlTipoServicio.Value = ""
        txtPlaca.Value = ""
    End Sub

    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaActualizarZonasMotorizados.xlsx")
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

                If numColumnas = 7 Then
                    dtUsuarioEjecutor = CrearEstructuraDeTabla()
                    Dim filaInicial As Integer = oWs.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWs.Cells.FirstColumnIndex


                    AddHandler oWs.ExtractDataEvent, AddressOf ExtractDataErrorHandler
                    oWs.ExtractToDataTable(dtUsuarioEjecutor, oWs.Rows.Count, ExtractDataOptions.SkipEmptyRows, oWs.Rows(filaInicial), oWs.Columns(columnaInicial))

                    If dtUsuarioEjecutor.Rows(0).Item(0).ToString().ToUpper() <> "IDENTIFICACION" Then
                        RegError("0", "Verifique que exista una columna llamada IDENTIFICACION  y sea la columna 1 en el archivo, la columna actual se llama: " & dtUsuarioEjecutor.Rows(0).Item(0).ToString(), "")
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
                        'If IsNumeric(row("IDENTIFICACION")) Then
                        row("Fila") = fil
                        fil = fil + 1
                        'Else
                        'RegError(fil, "La identificación tiene caracteres no validos o no cumple con la longitud requerida" & dtUsuarioEjecutor.Rows(0).Item(0).ToString(), dtUsuarioEjecutor.Rows(0).Item(0).ToString())

                        'End If
                    Next
                    If Session("dtResultado") Is Nothing Then

                        dtUsuarioEjecutor.Columns.Add(New DataColumn("idUsuario", GetType(System.Int64), idUsuario))
                        Dim dcfecha As New DataColumn("fechaCierre", GetType(System.DateTime))
                        Dim cargueZonaMotorizado As New actualizacionZonaMotorizadoPorArchivo()
                        Session("dtResultado") = cargueZonaMotorizado.AcualizarZonaMotorizadoPorArchivo(dtUsuarioEjecutor, idUsuario, resultado)
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
            dtAux.Columns.Add(New DataColumn("IDENTIFICACION", GetType(String)))
            dtAux.Columns.Add(New DataColumn("CIUDAD", GetType(String)))
            dtAux.Columns.Add(New DataColumn("DEPARTAMENTO", GetType(String)))
            dtAux.Columns.Add(New DataColumn("TELEFONO", GetType(String)))
            dtAux.Columns.Add(New DataColumn("PLACA", GetType(String)))
            dtAux.Columns.Add(New DataColumn("ZONAS", GetType(String)))
            dtAux.Columns.Add(New DataColumn("TIPOSERVICIOS", GetType(String)))
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

#End Region

End Class