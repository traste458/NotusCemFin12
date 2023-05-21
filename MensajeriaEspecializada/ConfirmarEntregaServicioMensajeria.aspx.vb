Imports ILSBusinessLayer
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class ConfirmarEntregaServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idEstado As Integer
    Private _zonaDataTable As DataTable
    Private _zonaServicioMensajeriaDataTable As DataTable
    Private arrEstadosConfirmacion As New ArrayList
    Private altoVentana As Integer
    Private anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        ObtenerTamanoVentana()
        'CargarTiposDeNovedad()


        If Not IsPostBack Then
            With epNotificador
                .setTitle("Confirmar Entrega de Servicio")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx")
            txtNoRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            arrEstadosConfirmacion = New ArrayList(MetodosComunes.seleccionarConfigValue("ESTADOS_CONFIRMAR_ENTREGA").Split(","))
            Session("arrEstadosConfirmacion") = arrEstadosConfirmacion


            CargaInicial()
            'CargarTiposDeNovedad()
        Else
            arrEstadosConfirmacion = Session("arrEstadosConfirmacion")

            If Session("infoServicioMensajeria") IsNot Nothing Then

                Select Case Session("infoServicioMensajeria").GetType().Name
                    Case "ServicioMensajeria", "ServicioMensajeriaVentaWeb"
                        Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
                        objEncabezado.CargarInformacionGeneralServicio(Session("infoServicioMensajeria"))
                        With phEncabezado
                            .Controls.Clear()
                            .Controls.Add(objEncabezado)
                            .DataBind()
                        End With

                    Case "ServicioMensajeriaVenta"
                        Dim objEncabezado As EncabezadoServicioTipoVenta = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx")
                        objEncabezado.CargarInformacionGeneralServicio(New ServicioMensajeriaVenta(DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).IdServicioMensajeria))
                        With phEncabezado
                            .Controls.Clear()
                            .Controls.Add(objEncabezado)
                            .DataBind()
                        End With

                    Case "ServicioMensajeriaSiembra"
                        Dim objEncabezado As EncabezadoServicioTipoSiembra = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoSiembra.ascx")
                        With phEncabezado
                            .Controls.Clear()
                            .Controls.Add(objEncabezado)
                            .DataBind()
                        End With
                        CalcularNovedades(DirectCast(Session("infoServicioMensajeria"), ServicioMensajeriaSiembra).IdServicioMensajeria)
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")
                End Select
            End If
        End If
    End Sub

    Private Sub lbBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbBuscar.Click
        BuscarRadicado()
    End Sub

    Private Sub lbConfirmarEntrega_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbConfirmarEntrega.Click
        ConfirmarEntrega()
    End Sub

    'Protected Sub ddlZona_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlZona.SelectedIndexChanged
    '    _zonaServicioMensajeriaDataTable = HerramientasMensajeria.ConsultaZonaServicioMensajeria()
    '    Dim vista As DataView = _zonaServicioMensajeriaDataTable.DefaultView()
    '    vista.RowFilter = "idZona=" & ddlZona.SelectedValue

    '    MetodosComunes.CargarDropDown(vista.ToTable(), CType(ddlResponsableEntrega, ListControl))
    'End Sub

    Private Sub lbVerSeriales_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbVerSeriales.Click
        Dim idServicio As Long
        If Session("infoServicioMensajeria") IsNot Nothing Then
            Try
                Select Case Session("infoServicioMensajeria").GetType().Name
                    Case "ServicioMensajeria", "ServicioMensajeriaVentaWeb"
                        idServicio = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).IdServicioMensajeria

                    Case "ServicioMensajeriaSiembra"
                        idServicio = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeriaSiembra).IdServicioMensajeria
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")
                End Select

                Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio:=idServicio)
                Dim dtDatos As DataTable = detalle.GenerarDataTable()
                With gvSeriales
                    .DataSource = dtDatos
                    If dtDatos IsNot Nothing Then .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Serial(es)"
                    .DataBind()
                End With
                MetodosComunes.mergeGridViewFooter(gvSeriales)
                With dlgSerial
                    .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
                    .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
                    .Show()
                End With
            Catch ex As Exception
                epNotificador.showError("Error al tratar de mostrar seriales. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub Link_InitNovedad(ByVal sender As Object, ByVal e As EventArgs)
        Dim idServicio As Integer
        'Try
        '    Dim linkGestionar As ASPxHyperLink = CType(sender, ASPxHyperLink)
        '    Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkGestionar.NamingContainer, GridViewDataItemTemplateContainer)
        '    Dim gvNovedades As ASPxGridView = CType(templateContainer.NamingContainer, ASPxGridView)

        '    idServicio = CInt(gvNovedades.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdServicioMensajeria"))

        '    linkGestionar.ClientSideEvents.Click = linkGestionar.ClientSideEvents.Click.Replace("{0}", idServicio)
        'Catch ex As Exception
        '    miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades en detalle: " & ex.Message)
        'End Try
    End Sub

    Private Sub btnNovedad_Click(sender As Object, e As System.EventArgs) Handles btnNovedad.Click
        CargarTiposDeNovedad()
        CargarSucursalesFinancieras()
        VisualizarNovedades()
    End Sub

    Private Sub VisualizarNovedades()
        Try
            With dlgNovedades
                .Width = Unit.Pixel(Me.anchoVentana * 0.5)
                .Height = Unit.Pixel(Me.altoVentana * 0.5)
                .Show()
            End With
        Catch ex As Exception

        End Try
    End Sub

#End Region

#Region "Métodos"

    Private Sub BuscarRadicado()
        Dim idServicio As Long
        Dim respuesta As New ResultadoProceso
        Dim validaServicio As Boolean


        Try
            phEncabezado.Controls.Clear()

            If CInt(rblTipoServicio.SelectedValue) = Enumerados.TipoServicio.Reposicion _
                Or CInt(rblTipoServicio.SelectedValue) = Enumerados.TipoServicio.VentaWeb Or CInt(rblTipoServicio.SelectedValue) = Enumerados.TipoServicio.CesionContrato _
                Or CInt(rblTipoServicio.SelectedValue) = Enumerados.TipoServicio.CampañaClaroFijo _
                Or CInt(rblTipoServicio.SelectedValue) = Enumerados.TipoServicio.EquiposReparadosST _
                Or CInt(rblTipoServicio.SelectedValue) = Enumerados.TipoServicio.TiendaVirtual Then
                validaServicio = False
            Else
                validaServicio = True
            End If

            If ServicioMensajeria.ExisteNumeroRadicado(CLng(txtNoRadicado.Text), validaServicio) Then
                Dim infoServicio As ServicioMensajeria

                Select Case CInt(rblTipoServicio.SelectedValue)
                    Case Enumerados.TipoServicio.Venta
                        infoServicio = New ServicioMensajeriaVenta(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.Reposicion
                        infoServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.Siembra
                        infoServicio = New ServicioMensajeriaSiembra(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.VentaWeb
                        infoServicio = New ServicioMensajeriaVentaWeb(numeroRadicado:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.ServiciosFinancieros
                        infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM
                        infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.CesionContrato
                        infoServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.VentaCorporativa
                        infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.CampañaClaroFijo
                        infoServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.TiendaVirtual
                        infoServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.EquiposReparadosST
                        infoServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.ServiciosFinancierosBancolombia
                        infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.ServiciosFinancierosDavivienda
                        infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNoRadicado.Text))
                    Case Enumerados.TipoServicio.DaviviendaSamsung
                        infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNoRadicado.Text))
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")
                End Select

                If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
                    btnNovedad.Enabled = True
                    idServicio = infoServicio.IdServicioMensajeria

                    If infoServicio.IdTipoServicio = Enumerados.TipoServicio.Venta Then
                        ''''Venta'''''
                        Dim objEncabezado As EncabezadoServicioTipoVenta = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx")
                        infoServicio = New ServicioMensajeriaVenta(idServicio:=idServicio)
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        With phEncabezado
                            .Controls.Add(objEncabezado)
                            .DataBind()
                        End With

                        With pnlDatosVenta
                            .Enabled = True
                            .Visible = True
                        End With
                        _idEstado = infoServicio.IdEstado
                        Session("infoServicioMensajeria") = infoServicio

                    ElseIf infoServicio.IdTipoServicio = Enumerados.TipoServicio.Siembra Then
                        ''''Siembra''''
                        Dim objEncabezado As EncabezadoServicioTipoSiembra = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoSiembra.ascx")
                        infoServicio = New ServicioMensajeriaSiembra(idServicio:=idServicio)
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        With phEncabezado
                            .Controls.Add(objEncabezado)
                            .DataBind()
                        End With


                        pnlDetalleReposicion.Visible = False
                        With pnlDetalleSiembra
                            .Enabled = True
                            .Visible = True

                            With gvMins
                                .DataSource = infoServicio.MinsColeccion
                                Session("objMins") = .DataSource
                                .DataBind()
                            End With

                            With gvReferencias
                                .DataSource = infoServicio.ReferenciasColeccion
                                Session("objReferencias") = .DataSource
                                .DataBind()
                            End With
                        End With

                        _idEstado = infoServicio.IdEstado
                        Session("infoServicioMensajeria") = infoServicio
                        CalcularNovedades(infoServicio.IdServicioMensajeria)

                    Else
                        ''''Reposición''''
                        Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()

                        With pnlDatosVenta
                            .Enabled = False
                            .Visible = False
                        End With

                        CargarDetalleDeReferencias(idServicio)
                        CargarDetalleDeMsisdn(idServicio)
                        CargarNovedades(idServicio)

                        _idEstado = infoServicio.IdEstado
                        Session("infoServicioMensajeria") = infoServicio
                    End If

                    If respuesta.Valor = 0 Then

                        _zonaDataTable = HerramientasMensajeria.ConsultaZona()
                        CargarInformacionZona(idServicio)

                        pnlGeneral.Visible = True
                        lbConfirmarEntrega.Enabled = CType(Session("arrEstadosConfirmacion"), ArrayList).Contains(_idEstado.ToString())
                        If Not lbConfirmarEntrega.Enabled Then epNotificador.showWarning("El radicado proporcionado NO tiene un estado válido para confirmar entrega. Por favor verifique.")
                    Else
                        pnlGeneral.Enabled = False
                        epNotificador.showWarning(respuesta.Mensaje)
                    End If
                Else
                    epNotificador.showWarning("Imposible obtener la información del radicado [" & txtNoRadicado.Text & "], por favor verifique e intente nuevamente.")
                    pnlGeneral.Visible = False
                End If
            Else
                epNotificador.showWarning("El número de radicado [" & txtNoRadicado.Text & "] ingresado no se encuentra en el sistema, por favor verifique e intente nuevamente.")
                pnlGeneral.Visible = False
            End If
        Catch ex As Exception
            epNotificador.showError("Se generó un error al tratar de buscar el radicado: " & ex.Message)
        End Try
    End Sub

    Private Sub ConfirmarEntrega()
        Dim idServicio As Integer
        Dim resultado As ResultadoProceso
        Dim servicioNEBS As New NotusExpressBancolombiaService.NotusExpressBancolombiaService
        Dim resultMessage As String = "El servicio a sido entregado."

        Try
            If Session("infoServicioMensajeria") IsNot Nothing Then
                Select Case Session("infoServicioMensajeria").GetType().Name
                    Case "ServicioMensajeria"
                        Dim detalleServicio As ServicioMensajeria = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria)
                        With detalleServicio
                            .IdUsuario = CInt(Session("usxp001"))
                        End With

                        resultado = detalleServicio.ConfirmarEntrega()

                        If resultado.Valor = 0 Then
                            epNotificador.showSuccess(resultMessage)
                            pnlGeneral.Visible = False
                            If detalleServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or detalleServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Then
                                resultado = ActualizarGestionVenta(detalleServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregado)
                            ElseIf detalleServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda Then
                                resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, detalleServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                            ElseIf detalleServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung Then
                                resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, detalleServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                            ElseIf detalleServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia Then
                                servicioNEBS.AsignacionNovedad(detalleServicio.IdServicioMensajeria, resultMessage)
                            End If
                        Else
                            epNotificador.showWarning("No es posible actualizar el radicado: " & resultado.Mensaje)
                        End If

                    Case "ServicioMensajeriaVenta"
                        Dim detalleServicio As ServicioMensajeriaVenta = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeriaVenta)
                        With detalleServicio
                            .IdUsuario = CInt(Session("usxp001"))
                            '.IdZona = ddlZona.SelectedValue
                            '.IdResponsableEntrega = ddlResponsableEntrega.SelectedItem.Text.Split("-")(0)
                            .IdMedioPago = ddlMedioPago.SelectedValue
                            .ValorRecaudado = txtValorRecaudo.Text
                            If Not String.IsNullOrEmpty(txtNumeroContrato.Text.Trim) Then .NumeroContrato = txtNumeroContrato.Text
                        End With

                        resultado = detalleServicio.ConfirmarEntrega()
                        If resultado.Valor = 0 Then
                            epNotificador.showSuccess("Radicado actualizado exitosamente.")
                            pnlGeneral.Visible = False
                        Else
                            epNotificador.showWarning("No es posible actualizar el radicado: " & resultado.Mensaje)
                        End If

                    Case "ServicioMensajeriaSiembra"
                        Dim detalleServicio As ServicioMensajeriaSiembra = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeriaSiembra)
                        With detalleServicio
                            .IdUsuario = CInt(Session("usxp001"))
                        End With

                        resultado = detalleServicio.ConfirmarEntrega()
                        If resultado.Valor = 0 Then
                            epNotificador.showSuccess("Radicado actualizado exitosamente.")
                            pnlGeneral.Visible = False
                            EnviarNotificacion()
                        Else
                            epNotificador.showWarning("No es posible actualizar el radicado: " & resultado.Mensaje)
                        End If

                    Case "ServicioMensajeriaVentaWeb"
                        Dim detalleServicio As ServicioMensajeriaVentaWeb = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeriaVentaWeb)
                        With detalleServicio
                            .IdUsuario = CInt(Session("usxp001"))
                        End With

                        resultado = detalleServicio.ConfirmarEntrega()
                        If resultado.Valor = 0 Then
                            epNotificador.showSuccess("Radicado actualizado exitosamente.")
                            pnlGeneral.Visible = False
                        Else
                            epNotificador.showWarning("No es posible actualizar el radicado: " & resultado.Mensaje)
                        End If

                    Case Else
                        epNotificador.showWarning("No es posible entonctrar configuración para el tipo de servicio.: " & resultado.Mensaje)
                End Select
            Else
                epNotificador.showWarning("No se logro cargar la información del servicio, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            epNotificador.showError("Se generó un error al tratar de confirmar el radicado: " & ex.Message)
        End Try
    End Sub

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

    Private Sub CargarInformacionZona(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria

        infoServicio = New ServicioMensajeria(idServicio)
        Try
            If infoServicio.Registrado Then

                If infoServicio.IdZona > 0 Then

                    _zonaServicioMensajeriaDataTable = HerramientasMensajeria.ConsultaZonaServicioMensajeria()

                    Dim vista As DataView = _zonaServicioMensajeriaDataTable.DefaultView()

                    If vista.Count > 0 Then
                        For Each item As DataRow In vista.ToTable().Rows
                            If CInt(item("idResponsableEntrega").ToString()) = infoServicio.IdResponsableEntrega Then
                                Exit For
                            End If
                        Next
                    Else
                        'MetodosComunes.CargarDropDown(_zonaServicioMensajeriaDataTable, CType(ddlResponsableEntrega, ListControl))
                    End If
                End If
            Else
                epNotificador.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                pnlGeneral.Enabled = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar CargarInformacionZona. " & ex.Message)
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

    Private Sub CalcularNovedades(ByVal idServicio As Integer)
        'Se valida si tiene novedades sin gestionar
        Dim objNovedadesAbiertas As New NovedadServicioMensajeriaColeccion(idServicio:=idServicio, idEstadoNovedad:=Enumerados.EstadoNovedadMensajeria.Registrado)
        btnNovedad.Text = "Novedades (" + objNovedadesAbiertas.Count.ToString() + ")"
        If objNovedadesAbiertas.Count > 0 Then btnNovedad.Enabled = False
    End Sub

    Private Sub CargaInicial()
        Try
            ' Se cargan los tipos de Novedad
            'With cmbTipoNovedad
            '    .DataSource = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Confirmacion, _
            '                                                               gestionable:=Enumerados.EstadoBinario.Activo, _
            '                                                               idTipoServicio:=Enumerados.TipoServicio.Siembra)
            '    .TextField = "descripcion"
            '    .ValueField = "idTipoNovedad"
            '    .DataBind()
            'End With
        Catch ex As Exception
            epNotificador.showError("Se generó un error inesperado en la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub EnviarNotificacion()
        Try
            Dim objServicio As ServicioMensajeriaSiembra = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeriaSiembra)
            If objServicio.FechaAgendaEntrega = Date.MinValue Then objServicio.FechaAgendaEntrega = Now

            Dim objMail As New EMailManager(AsuntoNotificacion.Tipo.Notificación_Entrega_Servicio_Siembra, objServicio)
            With objMail
                If Not String.IsNullOrEmpty(objServicio.EmailConsultor) Then .AdicionarDestinatario(objServicio.EmailConsultor)
                .EnviarMail()
            End With

        Catch ex As Exception
            epNotificador.showWarning("No se logró enviar notificación al Consultor: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=5)
            With ddlTipoNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarSucursalesFinancieras()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerSucursalesFinancieras()
            With ddlSucursal
                .DataSource = dtEstado
                .DataTextField = "sucursal"
                .DataValueField = "codigo"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Sucursal", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub lbRegistrar_Click(sender As Object, e As EventArgs) Handles lbRegistrar.Click
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer = 1

        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim novedad As New NovedadServicioMensajeria
            With novedad
                .IdServicioMensajeria = infoServicio.IdServicioMensajeria
                .Observacion = txtObservacionNovedad.Text.Trim
                .IdTipoNovedad = CInt(ddlTipoNovedad.SelectedValue)
                If ddlSucursal.SelectedValue IsNot Nothing AndAlso ddlSucursal.SelectedValue <> "" Then
                    .IdSucursalFinanciera = ddlSucursal.SelectedValue
                End If
                If .IdTipoNovedad > 0 Then
                    resultado = .Registrar(idUsuario)
                    If resultado.Valor = 0 Then
                        epNotificador.showSuccess(resultado.Mensaje)
                        txtObservacionNovedad.Text = ""
                        CargarNovedades(infoServicio.IdServicioMensajeria)
                    Else
                        epNotificador.showError(resultado.Mensaje)
                    End If
                Else
                    epNotificador.showError("No fue posible identificar el tipo de novedad.")
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar la novedad. " & ex.Message)
        End Try
    End Sub

    Private Function ActualizarGestionVenta(ByVal idServicio As Integer, ByVal idEstado As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objGestion As New NotusExpressService.NotusExpressService
        Dim infoWs As New InfoUrlSidService(objGestion, True)
        Dim WSInfoGestion As New ILSBusinessLayer.NotusExpressService.WsGestionVenta
        Dim Wsresultado As New ILSBusinessLayer.NotusExpressService.ResultadoProceso

        With WSInfoGestion
            .IdServicioNotus = idServicio
            .IdEstadoServicioMensajeria = idEstado
            .ObservacionNovedad = "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002"))
            .IdModificador = 1
        End With

        Wsresultado = objGestion.ActualizaGestionVenta(WSInfoGestion)
        resultado.Valor = Wsresultado.Valor
        resultado.Mensaje = Wsresultado.Mensaje
        Return resultado
    End Function

    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function

#End Region


End Class