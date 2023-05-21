Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports System.Text
Imports GemBox.Spreadsheet
Imports System.IO
Imports GemBox

Public Class CargueInventarioServicioFinancierosSerializado
    Inherits System.Web.UI.Page

#Region "Atributos."

    Private oExcel As ExcelFile
    Private objInventario As CargueInventarioServicioFinaciero

#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Me.IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("::: Cargue Inventario Pod. Financiero ::: ")
                End With
            End If
            If cpGeneral.IsCallback Then
                cmbBodega.DataBind()
                cmbMaterialSerial.DataBind()
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
                Case "consultarCliente"
                    Session.Remove("dtBodegas")
                    Session.Remove("dtMateriales")
                    cmbBodega.SelectedIndex = -1
                    cmbBodega.Items.Clear()
                    cmbBodega.Text = String.Empty
                    cmbMaterialSerial.SelectedIndex = -1
                    cmbMaterialSerial.Items.Clear()
                    cmbMaterialSerial.Text = String.Empty
                    txtSerial.Text = String.Empty
                    Dim dtBodegas As DataTable
                    Dim objBodegasCliente As New CargueInventarioServicioFinaciero()
                    With objBodegasCliente
                        .cedulaCliente = arrAccion(1)
                        dtBodegas = .ConsultarCliente()
                        Session("dtBodegas") = dtBodegas
                    End With
                    If (dtBodegas.Rows.Count < 1) Then
                        miEncabezado.showWarning("El cliente no cuenta con servicios activos para cargue de inventario ")

                    Else
                        With cmbBodega
                            .DataSource = dtBodegas
                            .ValueField = "idBodega"
                            .TextField = "bodega"
                            .DataBind()
                        End With

                    End If
                Case "cargarMateriales"
                    Session.Remove("dtMateriales")
                    Dim dtMateriales As DataTable
                    Dim objBodegasCliente As New CargueInventarioServicioFinaciero()
                    With objBodegasCliente
                        .idBodega = arrAccion(1)
                        .idServicio = arrAccion(2)
                        .cedulaCliente = txtCedulaCliente.Text
                        dtMateriales = .ConsultarMateriales()
                        Session("dtMateriales") = dtMateriales
                    End With
                    If (dtMateriales.Rows.Count < 1) Then
                        cmbMaterialSerial.SelectedIndex = -1
                        cmbMaterialSerial.Items.Clear()
                        cmbMaterialSerial.Text = String.Empty
                        miEncabezado.showWarning("El servicio seleccionado No tiene materiales pendientes de cargar")
                    Else
                        With cmbMaterialSerial
                            .DataSource = dtMateriales
                            .ValueField = "Material"
                            .TextField = "descripcion"
                            .DataBind()
                        End With

                    End If
                Case "cargarSerial"
                    Try
                        Dim arrValor As String()
                        arrValor = cmbBodega.Value.Split("|")
                        Dim objBodegasCliente As New CargueInventarioServicioFinaciero()
                        With objBodegasCliente
                            .idBodega = arrValor(0)
                            .idServicio = arrValor(1)
                            .idUsuario = Session("usxp001")
                            .material = cmbMaterialSerial.Value
                            .serial = txtSerial.Text
                            .RegistrarSerialFinanciero()
                            If .resultado.Valor = 1 Then
                                miEncabezado.showSuccess(.resultado.Mensaje)
                                limpiar()
                            Else
                                miEncabezado.showWarning(.resultado.Mensaje)
                            End If
                        End With
                    Catch ex As Exception
                        miEncabezado.showError("Se generó un error al registrar el serial:" & ex.Message)
                    End Try
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtrener la información:" & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Protected Sub cmbBodega_DataBinding(sender As Object, e As EventArgs) Handles cmbBodega.DataBinding
        If Session("dtBodegas") IsNot Nothing Then
            Dim dt As DataTable
            dt = CType(Session("dtBodegas"), DataTable)
            If dt.Rows.Count > 0 Then
                cmbBodega.DataSource = dt
            End If

        End If
    End Sub
    Protected Sub cmbMaterialSerial_DataBinding(sender As Object, e As EventArgs) Handles cmbMaterialSerial.DataBinding
        If Session("dtMateriales") IsNot Nothing Then
            Dim dt As DataTable
            dt = CType(Session("dtMateriales"), DataTable)
            If dt.Rows.Count > 0 Then
                cmbMaterialSerial.DataSource = dt
            End If
        End If
    End Sub
    Private Sub lbVerArchivo_Click(sender As Object, e As System.EventArgs) Handles lbVerArchivo.Click
        Dim ruta As String
        Try
            Try
                miEncabezado.clear()
                Dim archivo As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/EjemploPlantillaInventarioMasivo.xlsx")
                Dim _archivoEjemplo As String
                _archivoEjemplo = ObtenerDatosReporteExcel(archivo)
                If _archivoEjemplo <> "" Then
                    Dim file As System.IO.FileInfo = New System.IO.FileInfo(_archivoEjemplo)
                    If file.Exists() Then
                        Response.Clear()
                        Response.ClearContent()
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" & file.Name)
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                        Response.ContentEncoding = Encoding.UTF8
                        Response.WriteFile(_archivoEjemplo)
                        Response.End()
                    Else
                        Response.Write("Este archivo no existe.")
                    End If
                End If
            Catch ex As Exception
                miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
            End Try
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de abrir archivo de ejemplo. " & ex.Message)
        End Try
    End Sub
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        ProcesarArchivo()
        'CargarInicial()
        fuArchivo.Focus()
    End Sub
    Private Sub gvErrores_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvErrores.CustomCallback
        Try
            If objInventario Is Nothing Then
                objInventario = Session("objInventario")
            End If
            With gvErrores
                .DataSource = objInventario.EstructuraTablaErrores()
                Session("dtErrores") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
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
#End Region

#Region "Metodos Privados"
    Private Sub limpiar()
        cmbBodega.SelectedIndex = -1
        cmbBodega.Items.Clear()
        cmbBodega.Text = String.Empty
        cmbMaterialSerial.SelectedIndex = -1
        cmbMaterialSerial.Items.Clear()
        cmbMaterialSerial.Text = String.Empty
        txtSerial.Text = String.Empty
        txtCedulaCliente.Text = String.Empty
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
            Session("dtErrores") = Nothing

            If fuArchivo.PostedFile.ContentLength > 0 Then
                Dim nombreArchivo As String = "CargueInventarioPersonalizado_" & fec & "-" & Session("usxp001") & Path.GetExtension(fuArchivo.PostedFile.FileName)

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
                        objInventario = New CargueInventarioServicioFinaciero(oExcel)
                        If objInventario.ValidarEstructura() Then
                            If objInventario.ValidarInformacion() Then
                                resultado = objInventario.RegistrarInventario()
                            Else
                                resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                                MostrarErrores(objInventario.EstructuraTablaErrores)
                            End If
                        Else
                            resultado.EstablecerMensajeYValor(10, "Se encontraron errores en la validación.")
                            MostrarErrores(objInventario.EstructuraTablaErrores)
                        End If
                        Session("objInventario") = objInventario
                    Catch ex As Exception
                        Throw ex
                    End Try
                    miEncabezado.clear()
                    With miEncabezado
                        .setTitle("::: Cargue Inventario Prod. Financiero :::")
                    End With
                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess("Se realizó el cargue de los seriales al inventario satisfactoriamente.")
                    ElseIf resultado.Valor = 10 Or resultado.Valor = 20 Or resultado.Valor = 30 Then
                        miEncabezado.showWarning(resultado.Mensaje)
                        Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('dialogoErrores.ShowWindow();', 100);", True)
                    ElseIf resultado.Valor = 40 Then
                        miEncabezado.showWarning(resultado.Mensaje)
                    Else
                        miEncabezado.showWarning("Se presentaron errores en la carga del archivo, verifique el log de errores.")
                    End If
                    callback.JSProperties("cpResultadoProceso") = resultado.Valor
                Else
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('LoadingPanel.Hide();', 100);", True)
                    miEncabezado.showError("Seleccione los valores requeridos")
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

#End Region

End Class