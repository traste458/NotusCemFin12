Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Web.UI.HtmlControls
Imports DevExpress.Web
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Comunes

Public Class VerInformacionServicioTipoVentaCorporativa
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim idServicio As Integer
        Dim flag As Integer
        Try
            Seguridad.verificarSession(Me)
            miEncabezado1.clear()
            If Not IsPostBack And Not IsCallback Then
                If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
                If Request.QueryString("flag") IsNot Nothing Then Integer.TryParse(Request.QueryString("flag").ToString, flag)
                Dim idUsuario As Integer = 0
                If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
                If idServicio > 0 Then
                    Session("idServicio") = idServicio
                    'With miEncabezado1
                    '    .setTitle("Información Servicio Venta Corporativa")
                    'End With
                    CargarInformacionServicio(idServicio)
                    CargarHistoricoCambioEstado(idServicio, idUsuario)
                Else
                    miEncabezado1.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                End If
                If flag = 1 Then
                    tblCombo.Visible = True
                Else
                    tblCombo.Visible = False
                End If
            End If
        Catch ex As Exception
            miEncabezado1.showError("Se genero un error inesperado al tratar de obtener información del servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub gvRutas_DataBinding(sender As Object, e As System.EventArgs) Handles gvRutas.DataBinding
        If Session("dtRutas") IsNot Nothing Then gvRutas.DataSource = Session("dtRutas")
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim extensionArchivo As String
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            extensionArchivo = Path.GetExtension(CStr(gvDocumentos.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreArchivo"))).ToLower()

            'Link de Visualización de Archivo
            With linkVer
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

                Select Case extensionArchivo
                    Case ".pdf"
                        .ImageUrl = "~/images/pdf.png"
                    Case ".jpg", ".tiff"
                        .ImageUrl = "~/images/Paint.gif"
                    Case Else
                        .ImageUrl = "~/images/view.png"
                End Select
            End With
        Catch ex As Exception
            miEncabezado1.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDocumentos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDocumentos.DataBinding
        If Session("objDatosDocu") IsNot Nothing Then gvDocumentos.DataSource = Session("objDatosDocu")
    End Sub

    Private Sub gvAgendamientos_DataBinding(sender As Object, e As EventArgs) Handles gvAgendamientos.DataBinding
        If Session("objAgenda") IsNot Nothing Then gvAgendamientos.DataSource = Session("objAgenda")
    End Sub

    Private Sub gvNovedades_DataBinding(sender As Object, e As System.EventArgs) Handles gvNovedades.DataBinding
        If Session("objNovedades") IsNot Nothing Then gvNovedades.DataSource = Session("objNovedades")
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(CInt(Session("idServicio")))
        Dim dtDatosPlantilla As DataTable = miServicio.ObtenerSerialesReporteAlistamiento()
        Dim formato As String = cbFormatoExportar.Value
        Dim stArchivo As MemoryStream
        Dim rutaPlantilla As String = Server.MapPath("~") & "\" & "MensajeriaEspecializada\Plantillas\PlantillaAsignacionSeriales.xlsx"

        If Not String.IsNullOrEmpty(formato) Then
            Select Case formato
                Case "xlsx"
                    Dim objExcel As New ExcelManager()
                    With objExcel
                        .ColumnaInicial = 0
                        .FilaInicial = 4
                        .IncluirEncabezado = False
                        stArchivo = .GenerarExcel(dtDatosPlantilla, rutaPlantilla)
                    End With

                    Response.AddHeader("Content-Disposition", "attachment; filename=ReportePlantilla.xlsx")
                    Response.ContentType = "application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    Response.BinaryWrite(stArchivo.ToArray)
                    Response.End()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If

    End Sub

    Private Sub cbFormatoExportarAdendo_ButtonClick(source As Object, e As ButtonEditClickEventArgs) Handles cbFormatoExportarAdendo.ButtonClick
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(CInt(Session("idServicio")))
        Dim objDatos As New MensajeriaEspecializada.ReporteAdendoVentaCorporativa()
        Dim dtDatosAdendo As DataTable = miServicio.ObtenerSerialesReporteAlistamiento()
        Dim ruta As String

        With objDatos
            .DatosReporte = dtDatosAdendo
            .IdServicio = miServicio.IdServicioMensajeria
            .Cliente = miServicio.NombreCliente
            .Nit = miServicio.IdentificacionCliente
            .Ciudad = miServicio.Ciudad
            .Departamento = miServicio.NombreDepartamento
            .Direccion = miServicio.Direccion
            .Telefono = miServicio.TelefonoContacto
            .RepresentanteLegal = miServicio.NombreRepresentanteLegal
            .IdentificacionRepresentanteLegal = miServicio.IdentificacionRepresentanteLegal
            .Fecha = miServicio.FechaRegistro
            resultado = .GenerarReporteExcel()
            If resultado.Valor = 0 Then
                ruta = .RutaArchivo
                MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, ruta)
            Else
                miEncabezado1.showWarning(resultado.Mensaje)
            End If
        End With

    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarInformacionServicio(idServicio As Integer)
        Try
            Dim objServicio As New ServicioMensajeriaVentaCorporativa(idServicio)
            EncabezadoServicioTipoVentaCorporativa.CargarInformacionGeneralServicio(objServicio)


            With gvRutas
                .DataSource = objServicio.InformacionRutas()
                Session("dtRutas") = .DataSource
                .DataBind()
            End With

            EnlazarDocumentos(idServicio)
            EnlazarHistorialAgenda(idServicio)
            CargarNovedades(idServicio)

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedades
                .DataSource = listaNovedad.GenerarDataTable()
                Session("objNovedades") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado1.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDocumentos(idServicio As Integer)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            With objDocumentos
                .IdServicio = idServicio
                .CargarDatos()
            End With

            With gvDocumentos
                .DataSource = objDocumentos
                Session("objDatosDocu") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado1.showError("Se generó un error inesperado al intentar cargar los documentos: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarHistorialAgenda(idServicio As Integer)
        Try
            Dim dtHistorial As DataTable = HerramientasMensajeria.ConsultarHistorialReagenda(idServicio)
            With gvAgendamientos
                .DataSource = dtHistorial
                Session("objAgenda") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado1.showError("Se generó un error inesperado al intentar cargar los documentos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarHistoricoCambioEstado(ByVal idServicio As Integer, ByVal idUsuario As Integer)
        Try
            Dim dtCambioEstado As DataTable = HerramientasMensajeria.ConsultarHistorialCambioEstado(idServicio, idUsuario)
            With gvCambioEstado
                .DataSource = dtCambioEstado
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado1.showError("Error al tratar de obtener el historial de cambio de estado. " & ex.Message)
        End Try
    End Sub

#End Region

End Class