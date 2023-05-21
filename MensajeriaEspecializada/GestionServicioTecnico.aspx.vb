Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports Gestion = ILSBusinessLayer.GestionServicioTecnico

Partial Public Class GestionServicioTecnico
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _valorSiNo As ListItemCollection

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            With epNotificacion
                .setTitle("Gestión de Servicio Técnico")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With

            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With

            If idServicio > 0 Then
                Dim dtServicioRuta As DataTable = HerramientasMensajeria.ObtenerInfoRadicadosEnRutasActivas(idServicio:=idServicio)
                If dtServicioRuta.Rows.Count = 0 Then
                    _valorSiNo = New ListItemCollection
                    With _valorSiNo
                        .Add(New ListItem("Seleccione...", "0"))
                        .Add(New ListItem("Si", "1"))
                        .Add(New ListItem("No", "2"))
                    End With
                    Session("valorSiNo") = _valorSiNo

                    CargarInformacionGeneralServicio(idServicio)
                    CargarDetalleSeriales(idServicio)
                    CargarNovedades(idServicio)
                    CargarTiposDeNovedad()
                Else
                    pnlGeneral.Enabled = False
                    epNotificacion.showWarning("El radicado se ecuentra asociado a una ruta activa, por favor verifique e intente nuevamente.")
                End If
            Else
                pnlGeneral.Enabled = False
                epNotificacion.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            _valorSiNo = CType(Session("valorSiNo"), ListItemCollection)
        End If
    End Sub

    Private Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Select Case e.CommandName
            Case "gestion"
                Dim idDetalleSerial As Long = CLng(e.CommandArgument)
                MostrarDialogoGestiones(idDetalleSerial)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim idDetalle As Integer = gvDatos.DataKeys(e.Row.DataItemIndex).Value
                Dim drSeriales As DataRow = CType(gvDatos.DataSource, DataTable).Select("idDetalle = " & idDetalle.ToString())(0)

                Dim nCosto As Integer = 0
                Dim nAceptaCosto As Integer = 0
                Dim dFechaEntregaST As Date = Date.MinValue

                If Not IsDBNull(drSeriales("generaCosto")) Then
                    nCosto = IIf(CBool(drSeriales("generaCosto")), 1, 2)
                End If

                If Not IsDBNull(drSeriales("clienteAceptaCosto")) Then
                    nAceptaCosto = IIf(CBool(drSeriales("clienteAceptaCosto")), 1, 2)
                End If

                If Not IsDBNull(drSeriales("fechaEntregaServicioTecnico")) Then
                    dFechaEntregaST = CDate(drSeriales("fechaEntregaServicioTecnico"))
                End If

                Dim txtODS As TextBox = CType(e.Row.FindControl("txtODS"), TextBox)
                With txtODS
                    If Not IsDBNull(drSeriales("ordenServicio")) AndAlso Not String.IsNullOrEmpty(drSeriales("ordenServicio")) Then .Text = drSeriales("ordenServicio").ToString()
                    .Enabled = String.IsNullOrEmpty(.Text)
                End With

                Dim ddlCosto As DropDownList = CType(e.Row.FindControl("ddlCosto"), DropDownList)
                With ddlCosto
                    .DataSource = _valorSiNo
                    .DataBind()
                    .SelectedIndex = nCosto
                End With

                Dim ddlAceptaCosto As DropDownList = CType(e.Row.FindControl("ddlAceptaCosto"), DropDownList)
                With ddlAceptaCosto
                    .DataSource = _valorSiNo
                    .DataBind()
                    .SelectedIndex = nAceptaCosto
                End With

                Dim dpFechaEntrega As EO.Web.DatePicker = CType(e.Row.FindControl("dpFechaEntrega"), EO.Web.DatePicker)
                If dFechaEntregaST <> Date.MinValue Then
                    dpFechaEntrega.SelectedDate = dFechaEntregaST
                End If
                dpFechaEntrega.MinValidDate = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).FechaRegistro
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al enlazar seriales: " & ex.Message)
        End Try
    End Sub

    Private Sub ibActualizarSeriales_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ibActualizarSeriales.Click
        ActualizarSeriales()
    End Sub

    Private Sub lbGuardarGestion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbGuardarGestion.Click
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objGestion As New Gestion()
            With objGestion
                .IdDetalleSerial = CLng(lbIdDetalleSerial.Text)
                .Observacion = txtObservacion.Text
                .IdUsuario = idUsuario
                .Fecha = Now
                .Registrar(idUsuario)
            End With

            MostrarDialogoGestiones(objGestion.IdDetalleSerial)
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de guaradra la gestión: " & ex.Message)
        End Try
    End Sub

    Private Sub lbAdicionarNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAdicionarNovedad.Click
        dlgNovedad.Show()
    End Sub

    Private Sub lbRegistrarNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRegistrarNovedad.Click
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
                .ComentarioEspecifico = ""
                resultado = .Registrar(idUsuario)

                If resultado.Valor = 0 Then
                    epNotificacion.showSuccess(resultado.Mensaje)
                    txtObservacionNovedad.Text = ""
                    CargarNovedades(infoServicio.IdServicioMensajeria)
                Else
                    epNotificacion.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de registrar la novedad. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria
        Try
            infoServicio = New ServicioMensajeria(idServicio)
            If infoServicio.Registrado Then
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
            Else
                epNotificacion.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                pnlGeneral.Enabled = False
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleSeriales(ByVal idServicio As Integer)
        Try
            Dim detalleSeriales As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleSeriales.GenerarDataTable()
            With gvDatos
                .DataSource = dtAux
                .DataBind()
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
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

    Private Sub ActualizarSeriales()
        Dim idUsuario As Integer = 0
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            For Each fila As GridViewRow In gvDatos.Rows
                Dim idSerial As Integer = CInt(fila.Cells(0).Text)
                Dim txtODS As TextBox = CType(fila.FindControl("txtODS"), TextBox)
                Dim ddlCosto As DropDownList = CType(fila.FindControl("ddlCosto"), DropDownList)
                Dim ddlAceptaCosto As DropDownList = CType(fila.FindControl("ddlAceptaCosto"), DropDownList)
                Dim dpFechaEntrega As EO.Web.DatePicker = CType(fila.FindControl("dpFechaEntrega"), EO.Web.DatePicker)

                Dim objDetallSerial As New DetalleSerialServicioMensajeria(idSerial)
                With objDetallSerial
                    If txtODS.Enabled AndAlso txtODS.Text <> String.Empty Then
                        .OrdenServicio = txtODS.Text
                        .IdEstadoSerial = Enumerados.EstadoSerialCEM.ServicioTécnico
                    End If
                    If ddlCosto.SelectedIndex <> 0 Then .GeneraCosto = IIf(ddlCosto.SelectedIndex = 1, Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                    If ddlAceptaCosto.SelectedIndex <> 0 Then .ClienteAceptaCosto = IIf(ddlAceptaCosto.SelectedIndex = 1, Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                    If dpFechaEntrega.SelectedDate <> Date.MinValue Then .FechaEntregaServicioTecnico = dpFechaEntrega.SelectedDate

                    .Actualizar(idUsuario)
                End With
            Next

            CargarDetalleSeriales(idServicio)
            If CType(gvDatos.DataSource, DataTable).Select("ordenServicio IS NULL").Length = 0 Then
                Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
                With objServicio
                    If .IdEstado <> Enumerados.EstadoServicio.ServicioTecnico Then
                        .IdEstado = Enumerados.EstadoServicio.ServicioTecnico
                        .Actualizar(idUsuario)
                        CargarInformacionGeneralServicio(idServicio)
                    End If
                End With
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al actualizar seriales: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarGestiones(ByVal dtGestiones As DataTable)
        Try
            With gvGestiones
                .DataSource = dtGestiones
                .DataBind()
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al enlazar gestiones: " & ex.Message)
        End Try
    End Sub

    Private Sub MostrarDialogoGestiones(ByVal idDetalleSerial As Long)
        Try
            Dim objGestiones As New GestionServicioTecnicoColeccion(idDetalleSerial)
            EnlazarGestiones(objGestiones.GenerarDataTable())

            lbIdDetalleSerial.Text = idDetalleSerial
            txtObservacion.Text = String.Empty

            dlgAdicionarGestion.Show()
        Catch ex As Exception
            epNotificacion.showError("Error al mostrar Gestiones: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTiposDeNovedad()
        Dim dtTipoNovedad As New DataTable
        Try
            dtTipoNovedad = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.GestiónServicioTécnico)
            With ddlTipoNovedad
                .DataSource = dtTipoNovedad
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad...", "0"))
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

#End Region

End Class