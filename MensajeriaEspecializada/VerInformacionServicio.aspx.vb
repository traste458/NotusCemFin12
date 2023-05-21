Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class VerInformacionServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        ObtenerTamanoVentana()
        If Not Me.IsPostBack Then
            Dim idUsuario As Integer = 0
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim urlOrigen As String = ""
            If Request.UrlReferrer IsNot Nothing Then urlOrigen = System.IO.Path.GetFileName(Request.UrlReferrer.ToString)

            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With

            If idServicio > 0 Then
                Dim infoServicio As New ServicioMensajeria(idServicio:=idServicio)
                UCNotificacionGuia.NumeroGuia = infoServicio.NumeroGuia
                Dim respuesta As ResultadoProceso = esmInformacion.CargarInformacionGeneralServicio(infoServicio)
                If respuesta.Valor = 0 Then
                    If Not infoServicio Is Nothing Then
                        'Se visualiza la información específica de cada tipo de servicio
                        Select Case infoServicio.IdTipoServicio
                            Case Enumerados.TipoServicio.Reposicion
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.VentaWeb
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.OrdenCompra
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.CesionContrato
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.ServicioTecnico
                                pnlInfoServicioTecnico.Visible = True
                            Case Enumerados.TipoServicio.Portacion
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.ServiciosFinancieros, Enumerados.TipoServicio.ServiciosFinancierosDavivienda, Enumerados.TipoServicio.MercadoNaturalFeria
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.ServiciosFinancierosBancolombia
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.CampañaClaroFijo
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.TiendaVirtual
                                pnlInfoReposicion.Visible = True
                            Case Enumerados.TipoServicio.EquiposReparadosST
                                pnlInfoReposicion.Visible = True
                                pnlInfoServicioTecnico.Visible = True
                            Case Else
                                pnlInfoReposicion.Visible = True
                                pnlInfoServicioTecnico.Visible = True
                        End Select
                    End If
                    OfficeTrackInfo.CargarInformacionOfficeTrack(idServicio)
                    CargarDetalleDeReferencias(idServicio)
                    CargarDetalleDeMsisdn(idServicio)
                    CargarNovedades(idServicio)
                    CargarDetalleSerialesST(idServicio)
                    CargarHistorialReagenda(idServicio)
                    CargarHistoricoCambioEstado(idServicio, idUsuario)
                    CargarDocumentos(idServicio)
                    CargarRechazados(idServicio)
                Else
                    pnlGeneral.Enabled = False
                    epNotificador.showWarning(respuesta.Mensaje)
                End If
            Else
                pnlGeneral.Enabled = False
                epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If
    End Sub

    Protected Sub lbVerSeriales_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbVerSeriales.Click
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Try
            Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalle.GenerarDataTable()
            With gvSeriales
                .DataSource = dtDatos
                If dtDatos IsNot Nothing Then .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Serial(es)"
                .DataBind()
            End With
            MetodosComunes.mergeGridViewFooter(gvSeriales)
            With dlgSerial
                .Width = Unit.Pixel(Me.anchoVentana * 0.7)
                .Height = Unit.Pixel(Me.altoVentana * 0.7)
                .Show()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de mostrar seriales. " & ex.Message)
        End Try
    End Sub

    Private Sub gvListaReferencias_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaReferencias.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imagen As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgDisponibilidad"), System.Web.UI.WebControls.Image)
            Dim tieneDisponibilidad = CBool(CType(e.Row.DataItem, DataRowView).Item("TieneDisponibilidad"))
            If tieneDisponibilidad Then
                imagen.ImageUrl = "~/images/BallGreen.gif"
            Else
                imagen.ImageUrl = "~/images/BallRed.gif"
            End If
        End If
    End Sub

    Private Sub gvListaMsisdn_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaMsisdn.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imagen As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgLista28"), System.Web.UI.WebControls.Image)
            Dim blista28 = CBool(CType(e.Row.DataItem, DataRowView).Item("Lista28"))

            If blista28 Then
                imagen.ImageUrl = "~/images/si.png"
            Else
                imagen.ImageUrl = "~/images/transparent_16.gif"
            End If
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarDetalleDeReferencias(ByVal idServicio As Integer)
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            With gvListaReferencias
                .DataSource = dtAux
                .DataBind()
            End With
            Dim cantLeida As Integer
            Integer.TryParse(dtAux.Compute("SUM(cantidadLeida)", "").ToString, cantLeida)
            lbVerSeriales.Visible = CBool(cantLeida)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleDeMsisdn(ByVal idServicio As Integer)
        Try
            Dim detalleMsisdn As New DetalleMsisdnEnServicioMensajeriaColeccion(idServicio)
            With gvListaMsisdn
                .DataSource = detalleMsisdn.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de MSISDNs asignados al servicio. " & ex.Message)
        End Try

    End Sub
    Private Sub CargarRechazados(idServicio As Integer)
        Try
            Dim obj As New GenerarPoolServicioMensajeria()
            obj.IdServicioMensajeria = idServicio
            With gvHistorialRechazo
                .DataSource = obj.ConsultaCausalesRechazoMCdt()
                .DataBind()
            End With
        Catch ex As Exception

            epNotificador.showError("Error al tratar de obtener el listado de Rechazos mesa de control. " & ex.Message)
        End Try

    End Sub
    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me.altoVentana = CInt(arrAux(0))
                Me.anchoVentana = CInt(arrAux(1))
            End If
        End If
    End Sub

    Private Sub CargarDetalleSerialesST(ByVal idServicio As Integer)
        Try
            Dim detalleSerial As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            With gvSerialesPrestamo
                .DataSource = detalleSerial.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de MSISDNs asignados al servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarHistorialReagenda(ByVal idServicio As Integer)
        Try
            Dim dtHistorial As DataTable = HerramientasMensajeria.ConsultarHistorialReagenda(idServicio)
            With gvHistorialReagenda
                .DataSource = dtHistorial
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el historial de reagenda. " & ex.Message)
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
            epNotificador.showError("Error al tratar de obtener el historial de cambio de estado. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDocumentos(ByVal idServicio As Integer)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            With objDocumentos
                .IdServicio = idServicio
                Session("objDatosDocu") = .CargarDocumentos '.GenerarDataTable()
            End With

            With gvDocumentos
                .DataSource = Session("objDatosDocu")
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Se generó un error inesperado al intentar cargar los documentos: " & ex.Message)
        End Try



    End Sub

#End Region

    Private Sub gvDocumentos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDocumentos.RowCommand
        If Not e.CommandName = "Sort" Then
            Dim idDocumento As Integer
            Integer.TryParse(e.CommandArgument.ToString, idDocumento)
            If e.CommandName = "verDocumento" Then
                Dim esURL As String = ""
                If IsNothing(Session("objDatosDocu")) = False Then
                    If CType(Session("objDatosDocu"), DataTable).Rows.Count > 0 Then
                        Dim xrow() As DataRow = CType(Session("objDatosDocu"), DataTable).Select("idDocumento=" & idDocumento)
                        If xrow.Length > 0 Then
                            If xrow(0).Item("urlArchivo").ToString.Length > 0 Then
                                esURL = xrow(0).Item("urlArchivo").ToString
                            End If
                        End If
                    End If
                End If
                'Response.Redirect("DescargaDocumento.aspx?id=" & idDocumento, False)
                If esURL = "" Then
                    ClientScript.RegisterStartupScript(Me.GetType(), "descargarDocumento", "DescargarDocumento(" & idDocumento & ")", True)
                Else
                    ClientScript.RegisterStartupScript(Me.GetType(), "urlDoc", "window.open('" & esURL & "','_blank')", True)
                End If
            End If

        End If
    End Sub
End Class