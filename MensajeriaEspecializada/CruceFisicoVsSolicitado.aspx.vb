Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports System.Text
Imports GemBox.Spreadsheet
Imports System.IO
Imports GemBox

Public Class CruceFisicoVsSolicitado
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private oExcel As ExcelFile
    Private objCruce As ILSBusinessLayer.CruceFisicoVsSolicitado

#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Me.IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("::: Cruce Fisico Vs. Solicitado ::: ")
                End With
            End If
            GemBox.Spreadsheet.SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Catch ex As Exception
            miEncabezado.showError("Error al cargar la opción. " & ex.Message & "<br><br>")
        End Try
    End Sub
    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            miEncabezado.clear()
            Dim resultado As New ResultadoProceso
            Dim arrAccion As String()
            arrAccion = e.Parameter.Split("|")
            Select Case arrAccion(0)
                Case "filtrarDatos"
                    CargarDatos()
                    rpConsulta.ClientVisible = True
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtrener la información:" & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    'Private Sub lbVerArchivo_Click(sender As Object, e As System.EventArgs) Handles lbVerArchivo.Click
    '    Try
    '        Try
    '            miEncabezado.clear()
    '            Dim archivo As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/EjemploCruceFisicoVsSolicitado.xlsx")
    '            Dim _archivoEjemplo As String
    '            _archivoEjemplo = ObtenerDatosReporteExcel(archivo)
    '            If _archivoEjemplo <> "" Then
    '                Dim file As System.IO.FileInfo = New System.IO.FileInfo(_archivoEjemplo)
    '                If file.Exists() Then
    '                    Response.Clear()
    '                    Response.ClearContent()
    '                    Response.AppendHeader("Content-Disposition", "attachment; filename=" & file.Name)
    '                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    '                    Response.ContentEncoding = Encoding.UTF8
    '                    Response.WriteFile(_archivoEjemplo)
    '                    Response.End()
    '                Else
    '                    Response.Write("Este archivo no existe.")
    '                End If
    '            End If
    '        Catch ex As Exception
    '            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
    '        End Try
    '    Catch ex As Exception
    '        miEncabezado.showError("Error al tratar de abrir archivo de ejemplo. " & ex.Message)
    '    End Try
    'End Sub
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        ProcesarArchivo()
        fuArchivo.Focus()
    End Sub
    Private Sub gvErrores_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvErrores.CustomCallback
        Try
            If objCruce Is Nothing Then
                objCruce = Session("objCruce")
            End If
            With gvErrores
                .DataSource = objCruce.EstructuraTablaErrores()
                Session("dtErrores") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub
    Private Sub gvDetalleCruzados_DataBinding(sender As Object, e As System.EventArgs) Handles gvDetalleCruzados.DataBinding
        If Session("dtCruzados") IsNot Nothing Then gvDetalleCruzados.DataSource = Session("dtCruzados")
    End Sub
    Private Sub gvDetalleNoCruzados_DataBinding(sender As Object, e As System.EventArgs) Handles gvDetalleNoCruzados.DataBinding
        If Session("dtNoCruzados") IsNot Nothing Then gvDetalleNoCruzados.DataSource = Session("dtNoCruzados")
    End Sub
    Private Sub gvConsulta_DataBinding(sender As Object, e As EventArgs) Handles gvConsulta.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvConsulta.DataSource = Session("dtDatos")
    End Sub
    Private Sub gvErrores_DataBinding(sender As Object, e As System.EventArgs) Handles gvErrores.DataBinding
        If Session("dtErrores") IsNot Nothing Then gvErrores.DataSource = Session("dtErrores")
    End Sub
    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("dtErrores") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                If Not String.IsNullOrEmpty(formato) Then
                    With gveErrores
                        .FileName = "ReporteErrores"
                        .ReportHeader = "Reporte Errores" & vbCrLf & vbCrLf
                        .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                        .Landscape = False
                        With .Styles.Default.Font
                            .Name = "Arial"
                            .Size = FontUnit.Point(10)
                        End With
                        .DataBind()
                    End With
                    gvErrores.SettingsDetail.ExportMode = GridViewDetailExportMode.Expanded
                    Select Case formato
                        Case "xls"
                            gveErrores.WriteXlsToResponse()
                        Case "pdf"
                            With gveErrores
                                .Landscape = True
                                .WritePdfToResponse()
                            End With
                        Case "xlsx"
                            gveErrores.WriteXlsxToResponse()
                        Case "csv"
                            gveErrores.WriteCsvToResponse()
                        Case Else
                            Throw New ArgumentNullException("Archivo no valido")
                    End Select
                End If
            Else
                miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al exportar los datos: " & ex.Message)
        End Try
    End Sub
    Private Sub cbFormatoExportarCruzados_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportarCruzados.ButtonClick
        Dim formato As String = cbFormatoExportarCruzados.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveExportadorCruzados
                .FileName = "ReporteSerialesCruzadosFisicoVsSolicitado"
                .ReportHeader = "Reporte de Seriales Cruzados Fisico Vs Solicitado" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            gvDetalleCruzados.SettingsDetail.ExportMode = GridViewDetailExportMode.Expanded

            Select Case formato
                Case "xls"
                    gveExportadorCruzados.WriteXlsToResponse()
                Case "pdf"
                    With gveExportadorCruzados
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveExportadorCruzados.WriteXlsxToResponse()
                Case "csv"
                    gveExportadorCruzados.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub
    Private Sub cbFormatoExportarNoCruzados_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportarNoCruzados.ButtonClick
        Dim formato As String = cbFormatoExportarNoCruzados.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveExportadorNoCruzados
                .FileName = "ReporteSerialesNoCruzadosFisicoVsSolicitado"
                .ReportHeader = "Reporte de Seriales No Cruzados Fisico Vs Solicitado" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            gvDetalleNoCruzados.SettingsDetail.ExportMode = GridViewDetailExportMode.Expanded

            Select Case formato
                Case "xls"
                    gveExportadorNoCruzados.WriteXlsToResponse()
                Case "pdf"
                    With gveExportadorNoCruzados
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveExportadorNoCruzados.WriteXlsxToResponse()
                Case "csv"
                    gveExportadorNoCruzados.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub
    Private Sub cbFormatoExportarConsulta_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportarConsulta.ButtonClick
        Dim formato As String = cbFormatoExportarConsulta.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveExportadorConsulta
                .FileName = "ConsultaSerialesFisicoVsSolicitado"
                .ReportHeader = "Reporte de Seriales Fisico Vs Solicitado" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            gvConsulta.SettingsDetail.ExportMode = GridViewDetailExportMode.Expanded

            Select Case formato
                Case "xls"
                    gveExportadorConsulta.WriteXlsToResponse()
                Case "pdf"
                    With gveExportadorConsulta
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveExportadorConsulta.WriteXlsxToResponse()
                Case "csv"
                    gveExportadorConsulta.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub
#End Region

#Region "Metodos Privados"
    Private Sub limpiar()
        cmbEstado.SelectedIndex = -1
        cmbEstado.Text = ""
        txtSerial.Text = String.Empty
    End Sub
    Private Function ObtenerDatosReporteExcel(pNombrePlantilla)
        Dim pNombreArchivo As String = Server.MapPath("~/archivos_planos/" & "PlantillaInventarioMasivo_" & Guid.NewGuid().ToString() & ".xlsx")
        Try
            Dim oExcel As New ExcelFile
            Dim oWs As ExcelWorksheet

            oExcel.LoadXlsx(pNombrePlantilla, XlsxOptions.None)

            'Productos
            Dim dtProducto As DataTable
            Dim objProducto As New ProductoComercialColeccion
            dtProducto = objProducto.GenerarDataTable
            Session("dtProducto") = dtProducto
            If CType(Session("dtProducto"), DataTable) IsNot Nothing Then
                oWs = oExcel.Worksheets("CodigosProductos")
                For i As Integer = 0 To CType(Session("dtProducto"), DataTable).Rows.Count - 1
                    oWs.Cells(i + 1, 0).Value = CType(Session("dtProducto"), DataTable).Rows(i).Item("Codigo")
                    oWs.Cells(i + 1, 1).Value = CType(Session("dtProducto"), DataTable).Rows(i).Item("ProductoExterno")
                Next
            End If
            Session("dtProducto") = Nothing

            oExcel.SaveXlsx(pNombreArchivo)
        Catch ex As Exception
            miEncabezado.showError("Error obteniendo datos archivo de Ejemplo. " & ex.Message)
        End Try
        Return pNombreArchivo
    End Function
    Private Sub ProcesarArchivo()
        Try
            Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim ruta As String
            Dim resultado As New ResultadoProceso
            Dim _result As New Integer
            Session("dtErrores") = Nothing

            If fuArchivo.PostedFile.ContentLength > 0 Then
                Dim nombreArchivo As String = "CruceFisicoVsSolicitado_" & fec & "-" & Session("usxp001") & Path.GetExtension(fuArchivo.PostedFile.FileName)

                If Not (fuArchivo.PostedFile.FileName Is Nothing) Then
                    Dim fileExtension As String = Path.GetExtension(fuArchivo.PostedFile.FileName)
                    ruta = Server.MapPath("~/MensajeriaEspecializada/Archivos/" & nombreArchivo)
                    Try
                        fuArchivo.SaveAs(ruta)
                    Catch ex As Exception
                        miEncabezado.showError("Se genero un error al guardar el archivo: " & ex.Message)
                        Exit Sub
                    End Try
                    oExcel = New ExcelFile
                    If fileExtension.ToUpper = ".XLS" Then
                        oExcel.LoadXls(ruta)
                    ElseIf fileExtension.ToUpper = ".XLSX" Then
                        oExcel.LoadXlsx(ruta, XlsxOptions.None)
                    End If

                    Try
                        objCruce = New ILSBusinessLayer.CruceFisicoVsSolicitado(oExcel)
                        If objCruce.ValidarEstructura() Then
                            resultado = objCruce.ValidarInformacion()
                        Else
                            resultado.EstablecerMensajeYValor(10, "Se encontraron errores en la validación de la estructura y los datos.")
                            MostrarErrores(objCruce.EstructuraTablaErrores)
                        End If
                        Session("objCruce") = objCruce
                    Catch ex As Exception
                        Throw ex
                    End Try
                    miEncabezado.clear()
                    With miEncabezado
                        .setTitle("::: Cruce Fisico Vs. Solicitado :::")
                    End With
                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess("Se realizó el cruce de la informacion satisfactoriamente.")
                        llenarGridView()
                    ElseIf resultado.Valor = 10 Then
                        miEncabezado.showError(resultado.Mensaje)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "MostrarErrores();", True)
                    Else
                        miEncabezado.showError("Se presento un error al realizar el cruce de la informacion, por favor intentelo nuevamente..")
                    End If
                    callback.JSProperties("cpResultadoProceso") = resultado.Valor
                Else
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('LoadingPanel.Hide();', 100);", True)
                    miEncabezado.showError("Seleccione archivo requerido")
                End If
            Else
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('LoadingPanel.Hide();', 100);", True)
                miEncabezado.showError("Seleccione archivo a procesar.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
        callback.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Private Sub MostrarErrores(ByVal dtErrores As DataTable)
        gvErrores.DataSource = dtErrores
        Session("dtErrores") = dtErrores
        gvErrores.DataBind()
    End Sub
    Private Sub llenarGridView()
        Try
            If objCruce Is Nothing Then
                objCruce = Session("objCruce")
            End If

            With gvDetalleCruzados
                .DataSource = objCruce.DsDatos.Tables(0)
                Session("dtCruzados") = .DataSource
                .DataBind()
            End With

            With gvDetalleNoCruzados
                .DataSource = objCruce.DsDatos.Tables(1)
                Session("dtNoCruzados") = .DataSource
                .DataBind()
            End With

            rdResultadoCruze.ClientVisible = True
            rdResultadoNoCruze.ClientVisible = True

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar las vistas donde se mostrara la informacion, " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatos()
        Try
            objCruce = New ILSBusinessLayer.CruceFisicoVsSolicitado()
            Dim dtDatos As New DataTable
            With objCruce
                If txtSerial.Text <> "" Then .Serial = txtSerial.Text.Trim
                If cmbEstado.SelectedIndex <> -1 Then .IdEstado = cmbEstado.Value

                If deFechaInicio.Value <> Date.MinValue And deFechaFin.Value <> Date.MinValue Then
                    .FechaIni = deFechaInicio.Value
                    .fechaFin = deFechaFin.Value
                End If

                dtDatos = .ObtenerDatosConsultaCruceFisicoVsSolicitado
                Session("dtDatos") = dtDatos

                With gvConsulta
                    .DataSource = Session("dtDatos")
                    .DataBind()
                End With
            End With
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar los datos, " & ex.Message)
        End Try


    End Sub

#End Region


End Class