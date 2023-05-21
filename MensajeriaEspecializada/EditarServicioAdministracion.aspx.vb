Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class EditarServicioAdministracion
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        ObtenerTamanoVentana()
        If Not IsPostBack Then
            With epNotificacion
                .setTitle("Edición de Servicios")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            txtNumeroRadicado.Focus()
            'If Not String.IsNullOrEmpty(txtNumeroRadicado.Text) Then CargarDetalleRadicado()
            pnlEdicionServicio.Visible = False
        End If
    End Sub

    Private Sub lbBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbBuscar.Click
        Dim infoServicio As New ServicioMensajeria(numeroRadicado:=CLng(txtNumeroRadicado.Text))
        If infoServicio.Registrado Then
            If infoServicio.IdTipoServicio = Enumerados.TipoServicio.Reposicion _
                Or infoServicio.IdTipoServicio = Enumerados.TipoServicio.OrdenCompra Then

                If infoServicio.IdEstado <> Enumerados.EstadoServicio.Creado And _
                    infoServicio.IdEstado <> Enumerados.EstadoServicio.Confirmado And _
                    infoServicio.IdEstado <> Enumerados.EstadoServicio.Despachado Then

                    CargarInformacionGeneralServicio(infoServicio.IdServicioMensajeria)
                    CargarDetalleDeReferencias(infoServicio.IdServicioMensajeria)
                    CargarDetalleDeMsisdn(infoServicio.IdServicioMensajeria)
                    CargarNovedades(infoServicio.IdServicioMensajeria)

                    pnlEdicionServicio.Visible = True
                    pnlInfoReposicion.Visible = True
                Else
                    epNotificacion.showWarning("El estado [" & infoServicio.Estado & "] no es válido para la edición.")
                End If
            Else
                epNotificacion.showWarning("El radicado de tipo [" & infoServicio.TipoServicio & "] no es válido para la edición.")
            End If
        Else
            epNotificacion.showWarning("No existe un servicio registrado con el identificador proporcionado.")
        End If
    End Sub

    Private Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Private Sub lbVerSeriales_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbVerSeriales.Click
        Dim idServicio As Integer = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).IdServicioMensajeria
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
            epNotificacion.showError("Error al tratar de mostrar seriales. " & ex.Message)
        End Try
    End Sub

    Private Sub gvListaMsisdn_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvListaMsisdn.RowCommand
        Select Case e.CommandName
            Case "Editar"
                CargarInformacionEdicion(CInt(e.CommandArgument))
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub lbEditarGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbEditarGuardar.Click
        GuardarEdicionSeriales()
    End Sub

#End Region

#Region "Métodos"

    Private Sub LimpiarFiltros()
        txtNumeroRadicado.Text = ""
        txtNumeroRadicado.Enabled = True
        pnlEdicionServicio.Visible = False
        pnlEdicionServicio.Visible = False
        lbBuscar.Enabled = True
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria
        Try
            infoServicio = New ServicioMensajeria(idServicio)

            With infoServicio
                lblNumRadicado.Text = .NumeroRadicado.ToString
                lblCodigoRadicado.Text = "*" & .NumeroRadicado.ToString & "*"
                lblEjecutor.Text = .UsuarioEjecutor
                lblTipoServicio.Text = .TipoServicio
                lblEstado.Text = .Estado
                lblNombreCliente.Text = .NombreCliente
                lblIdentificacion.Text = .IdentificacionCliente
                lblDireccion.Text = .Direccion
                lblBarrio.Text = .Barrio
                lblCiudad.Text = .Ciudad
                lblTelefono.Text = .TelefonoContacto
                If Not String.IsNullOrEmpty(.ExtensionContacto) Then lblExtension.Text = " ext. " & .ExtensionContacto
                lblPersonaContacto.Text = .PersonaContacto
                If .FechaAgenda > Date.MinValue Then lblFechaAgenda.Text = .FechaAgenda.ToShortDateString()
                lblJornada.Text = .Jornada
                If .FechaConfirmacion > Date.MinValue Then lblFechaConfirmacion.Text = .FechaConfirmacion
                lblUsuarioConfirma.Text = .UsuarioConfirmacion
                lblBodega.Text = .Bodega
                lblObservacion.Text = .Observacion
                If .FechaDespacho > Date.MinValue Then lblFechaDespacho.Text = .FechaDespacho
                lblUsuarioDespacho.Text = .UsuarioDespacho
                If .FechaCambioServicio > Date.MinValue Then lblFechaCambioServicio.Text = .FechaCambioServicio
                lblZona.Text = .NombreZona
                lblResponsableEntrega.Text = .ResponsableEntrega
                If .FechaCambioServicio > Date.MinValue Then lblFechaCambioServicio.Text = .FechaCambioServicio
                If .FechaRegistro > Date.MinValue Then lblFechaRegistro.Text = .FechaRegistro
                If .FechaCierre > Date.MinValue Then lblFechaEntrega.Text = .FechaCierre
                lblRegistradoPor.Text = .UsuarioRegistra
                lblPrioridad.Text = .Prioridad
                Session("infoServicioMensajeria") = infoServicio
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
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
            epNotificacion.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleDeMsisdn(ByVal idServicio As Integer)
        Try
            Dim detalleSerial As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim detalleMsisdn As New DetalleMsisdnEnServicioMensajeriaColeccion(idServicio)

            'Dim dsDetalle As New DataSet()
            'With dsDetalle
            '    .Tables.Add(detalleSerial.GenerarDataTable())
            '    .Tables.Add(detalleMsisdn.GenerarDataTable())
            '    .Relations.Add("FK_Msisdn_Serial", dsDetalle.Tables(1).Columns("msisdn"), dsDetalle.Tables(0).Columns("msisdn"))
            '    .Relations("FK_Msisdn_Serial").Nested = True
            'End With

            With gvListaMsisdn
                '.DataSource = detalleMsisdn.GenerarDataTable()
                .DataSource = detalleSerial.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de MSISDNs asignados al servicio. " & ex.Message)
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
            epNotificacion.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
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

    Private Sub CargarInformacionEdicion(ByVal idDetalleSerial As Integer)
        Try
            Dim infoDetalleSerial As New DetalleSerialServicioMensajeriaColeccion(idDetalle:=idDetalleSerial)
            If infoDetalleSerial.Count > 0 Then
                Session("infoDetalleSerial") = DirectCast(infoDetalleSerial(0), DetalleSerialServicioMensajeria)
                lblEditarId.Text = infoDetalleSerial(0).IdDetalle
                txtEditarMsisdn.Text = infoDetalleSerial(0).Msisdn
                txtEditarSerial.Text = infoDetalleSerial(0).Serial
                txtEdicionFactura.Text = infoDetalleSerial(0).Factura
                txtEdicionRemision.Text = infoDetalleSerial(0).Remision

                With dlgEdicionSeriales
                    .Width = Unit.Pixel(Me.anchoVentana * 0.4)
                    .Height = Unit.Pixel(Me.altoVentana * 0.5)
                    .Show()
                End With
            Else
                epNotificacion.showWarning("No se encontró el detalle solicitado.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó error al cargar información: " & ex.Message)
        End Try
    End Sub

    Private Sub GuardarEdicionSeriales()
        Try
            If Session("infoDetalleSerial") IsNot Nothing Then
                Dim objDetalle As DetalleSerialServicioMensajeria = DirectCast(Session("infoDetalleSerial"), DetalleSerialServicioMensajeria)
                Dim idUsuario As Integer = 0
                Dim resultado As New ResultadoProceso()

                If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
                With objDetalle
                    .Factura = txtEdicionFactura.Text
                    .Remision = txtEdicionRemision.Text
                    resultado = .Actualizar(idUsuario)
                End With
                If resultado.Valor = 0 Then
                    CargarDetalleDeMsisdn(objDetalle.IdServicio)
                    epNotificacion.showSuccess("Se realizó la actualización de datos satisfactoriamente.")
                Else
                    epNotificacion.showWarning("No se logro la actualización: " & resultado.Mensaje)
                End If
            Else
                epNotificacion.showWarning("No se logro cargar datos desde la memoria, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó error al guaradar la información: " & ex.Message)
        End Try
    End Sub

#End Region

End Class