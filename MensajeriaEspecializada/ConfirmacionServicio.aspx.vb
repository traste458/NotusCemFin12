Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes
Imports System.Linq

Partial Public Class ConfirmacionServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118
#End If
        Try
            epNotificador.clear()
            ObtenerTamanoVentana()
            If Not Me.IsPostBack Then
                With epNotificador
                    .setTitle("Confirmaci&oacute;n de Servicio de Mensajer&iacute;a")
                    If Request.UrlReferrer IsNot Nothing Then
                        .showReturnLink(Page.ResolveUrl(Request.UrlReferrer.ToString))
                    Else
                        .showReturnLink("PoolServiciosNew.aspx")
                    End If
                End With

                AsignarRestriccionDeFechas()

                Dim idServicio As Integer
                With Request
                    If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
                End With
                'btnConfirmar.Enabled = False
                If idServicio > 0 Then
                    CargarJornadas()
                    CargarInformacionGeneralServicio(idServicio)
                    CargarDetalleDeReferencias(idServicio)
                    CargarDetalleDeMsisdn(idServicio)
                    CargarNovedades(idServicio)
                    CargarDetalleSerialesST(idServicio)
                    HabilitarControles()
                Else
                    pnlGeneral.Enabled = False
                    epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                End If

                txtTelefono.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtExtension.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                rbTelefonoCelular.Attributes.Add("onmousedown", "javascript:validarTelefono()")
                rbTelefonoFijo.Attributes.Add("onmousedown", "javascript:validarTelefono()")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar página. " & ex.Message)
        End Try

    End Sub

    Private Function VerificarPerfiles() As ResultadoProceso

        Dim resultado As New ResultadoProceso
        Dim idPerfil As Integer = Session("usxp009")
        Dim perfilHabilitado As New ConfigValues("PERFILES_NOVEDADES_CALL")
        Dim arrPerfil() As String

        arrPerfil = perfilHabilitado.ConfigKeyValue.Split(",")
        For i As Integer = 0 To arrPerfil.Count - 1
            If arrPerfil(i) = idPerfil Then
                resultado.EstablecerMensajeYValor(1, "Habilitado Novedad Call")
                Exit For
            Else
                resultado.EstablecerMensajeYValor(0, "Habilitado Novedad")
            End If
        Next
        Return resultado
    End Function

    Protected Sub HabilitarControles()
        Dim perfilHabilitado As New ResultadoProceso
        perfilHabilitado = VerificarPerfiles()

        If perfilHabilitado.Valor = 1 Then
            btnAdicionarNovedad.Text = "Registrar Novedades Call"
            ddlTipoNovedadCall.Visible = True
            CargarTiposDeNovedadCall()
        Else
            btnAdicionarNovedad.Text = "Registrar Novedad"
            ddlTipoNovedad.Visible = True
            CargarTiposDeNovedad()
        End If
    End Sub
    Protected Sub btnConfirmar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnConfirmar.Click
        Try
            Dim resultado As ResultadoProceso
            Dim idUsuario As Integer = 0
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(CInt(Request.QueryString("idServicio")))
            With infoServicio
                .Direccion = txtDireccion.Text.Trim.ToUpper
                .Barrio = txtBarrio.Text.Trim.ToUpper
                .TelefonoContacto = txtTelefono.Text.Trim
                .TipoTelefono = IIf(rbTelefonoCelular.Checked, "CEL", "FIJO")
                .PersonaContacto = txtPersonaContacto.Text.Trim.ToUpper
                .Observacion = txtObservacion.Text.Trim
                .FechaAgenda = dpFechaAgenda.SelectedDate
                .IdJornada = CShort(ddlJornada.SelectedValue)
                .IdUsuarioConfirmacion = idUsuario
                .MedioEnvioCH = rblMedoEnvioCH.SelectedValue
                If Not String.IsNullOrEmpty(txtCorreoEnvioCH.Text) Then .CorreoEnvioCH = txtCorreoEnvioCH.Text

                If .IdEstado = Enumerados.EstadoServicio.Creado Then
                    resultado = .Confirmar()
                Else
                    resultado = .Actualizar(idUsuario)
                End If

                If resultado.Valor = 0 Then
                    Response.Redirect("PoolServiciosNew.aspx?resOk=true&codRes=1", False)
                    epNotificador.showSuccess(resultado.Mensaje)
                    pnlGeneral.Enabled = False
                Else
                    If resultado.Valor = 3 Then CargarDetalleDeReferencias(infoServicio.IdServicioMensajeria)
                    epNotificador.showError(resultado.Mensaje)
                End If
            End With

        Catch ex As Exception
            epNotificador.showError("Imposible confirmar el servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub lbRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRegistrar.Click
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer
        Dim comentario As String
        Dim value As New ConfigValues("TIPO_NOVEDAD_NOTIFICACION")
        Dim cadena As String = value.ConfigKeyValue
        Dim servicioNEBS As New NotusExpressBancolombiaService.NotusExpressBancolombiaService()

        Try
            Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim novedad As New NovedadServicioMensajeria
            Dim idTipoDeNovedad As Integer = 0
            Dim TipoDeNovedad As String = ""

            Dim perfilHabilitado As New ResultadoProceso
            perfilHabilitado = VerificarPerfiles()

            If perfilHabilitado.Valor = 1 Then
                idTipoDeNovedad = CInt(ddlTipoNovedadCall.SelectedValue)
                TipoDeNovedad = CStr(ddlTipoNovedadCall.SelectedItem.Text.Trim)

            Else
                idTipoDeNovedad = CInt(ddlTipoNovedad.SelectedValue)
                TipoDeNovedad = CStr(ddlTipoNovedad.SelectedItem.Text.Trim)
            End If


            With novedad
                .IdServicioMensajeria = idServicio
                .Observacion = txtObservacionNovedad.Text.Trim
                .IdTipoNovedad = idTipoDeNovedad
                comentario = TipoDeNovedad
                '.ComentarioEspecifico = txtComentarioEspecifico.Text.Trim
                resultado = .Registrar(idUsuario)

                If resultado.Valor = 0 Then
                    epNotificador.showSuccess(resultado.Mensaje)
                    'txtComentarioEspecifico.Text = ""
                    txtObservacionNovedad.Text = String.Empty
                    CargarNovedades(idServicio)
                    If cadena.IndexOf(comentario) <> -1 Then
                        ' Se verifica si se debe enviar notificación de disponibilidad
                        Dim objServicio As New ServicioMensajeria(idServicio)
                        Dim idServicioTipo As Long = CLng(objServicio.IdServicioTipo)
                        HerramientasMensajeria.VerificarDisponibilidadMaterial(idServicio, idServicioTipo)
                        EnviarNotificacion(objServicio.NumeroRadicado)
                    End If
                Else
                    epNotificador.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar la novedad. " & ex.Message)
        End Try
    End Sub


    Protected Sub btnAdicionarNovedad_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAdicionarNovedad.Click
        Try
            Dim perfilHabilitado As New ResultadoProceso
            perfilHabilitado = VerificarPerfiles()

            If perfilHabilitado.Valor = 1 Then
                ddlTipoNovedadCall.ClearSelection()
            Else
                ddlTipoNovedad.ClearSelection()
            End If
            'txtComentarioEspecifico.Text = ""
            txtObservacionNovedad.Text = String.Empty
            With dlgNovedad
                .Width = Unit.Pixel(Me.anchoVentana * 0.7)
                .Height = Unit.Pixel(Me.altoVentana * 0.7)
                .Show()
            End With

        Catch ex As Exception
            epNotificador.showError("Error al tratar de mostrar formulario de adición de novedades.")
        End Try
    End Sub

    Private Sub gvListaReferencias_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaReferencias.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imagen As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgDisponibilidad"), System.Web.UI.WebControls.Image)
            Dim tieneDisponibilidad As Boolean = CBool(CType(e.Row.DataItem, DataRowView).Item("TieneDisponibilidad"))
            If tieneDisponibilidad Then
                imagen.ImageUrl = "~/images/BallGreen.gif"
            Else
                imagen.ImageUrl = "~/images/BallRed.gif"
            End If
        End If
    End Sub

    Protected Sub gvListaMsisdn_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaMsisdn.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imagen As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgBloquear"), System.Web.UI.WebControls.Image)
            Dim bloquear As Boolean = CBool(CType(e.Row.DataItem, DataRowView).Item("bloquear"))
            If Not bloquear Then
                imagen.ImageUrl = "~/images/BallGreen.gif"
            Else
                imagen.ImageUrl = "~/images/BallRed.gif"
            End If
        End If
    End Sub

    Private Sub cpInfoCapacidad_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroJornada.Execute, cpFiltroFecha.Execute
        If ddlJornada.SelectedValue <> "0" AndAlso dpFechaAgenda.SelectedDate > Date.MinValue Then
            ConsultarCapacidadEntrega()
        Else
            btnConfirmar.Enabled = False
        End If
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
                    lblEjecutor.Text = .UsuarioEjecutor
                    lblTipoServicio.Text = .TipoServicio
                    lblNombreCliente.Text = .NombreCliente
                    lblIdentificacion.Text = .IdentificacionCliente
                    txtDireccion.Text = .Direccion
                    txtBarrio.Text = .Barrio
                    lblCiudad.Text = .Ciudad
                    txtTelefono.Text = .TelefonoContacto
                    txtPersonaContacto.Text = .PersonaContacto
                    txtObservacion.Text = .Observacion

                    If .TipoTelefono = "CEL" Then
                        rbTelefonoCelular.Checked = True
                        txtTelefono.Enabled = False
                        txtExtension.Enabled = False
                    ElseIf .TipoTelefono = "FIJO" Then
                        rbTelefonoFijo.Checked = True
                        txtTelefono.Enabled = False
                        txtExtension.Enabled = True
                    End If

                    Session("infoServicioMensajeria") = infoServicio
                End With

                'Se visualiza la información específica de cada tipo de servicio
                Select Case infoServicio.IdTipoServicio
                    Case Enumerados.TipoServicio.Reposicion, Enumerados.TipoServicio.ServiciosFinancieros, Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM, Enumerados.TipoServicio.ServiciosFinancierosDavivienda
                        pnlInfoReposicion.Visible = True
                    Case Enumerados.TipoServicio.Portacion
                        pnlInfoReposicion.Visible = True
                    Case Enumerados.TipoServicio.OrdenCompra
                        pnlInfoReposicion.Visible = True
                    Case Enumerados.TipoServicio.ServicioTecnico
                        pnlInfoServicioTecnico.Visible = True
                    Case Enumerados.TipoServicio.CampañaClaroFijo
                        pnlInfoReposicion.Visible = True
                    Case Enumerados.TipoServicio.TiendaVirtual
                        pnlInfoReposicion.Visible = True
                    Case Enumerados.TipoServicio.EquiposReparadosST
                        pnlInfoServicioTecnico.Visible = True
                        trCorreo.Visible = False
                    Case Enumerados.TipoServicio.VentaWeb
                        pnlInfoReposicion.Visible = True
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")

                End Select
            Else
                epNotificador.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                pnlGeneral.Enabled = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleDeReferencias(ByVal idServicio As Integer)
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalleReferencia.GenerarDataTable()
            With gvListaReferencias
                .DataSource = detalleReferencia.GenerarDataTable()
                .DataBind()
            End With
            Dim drAux() As DataRow = dtDatos.Select("tieneDisponibilidad=false and productoFinNoSerializado=true")
            If drAux.Length > 0 Then
                btnConfirmar.Enabled = False
                epNotificador.showWarning("<i>No se puede confirmar el servicio, puesto que una o más referencias no tiene disponibilidad de inventario</i>")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarDetalleDeMsisdn(ByVal idServicio As Integer)
        Try
            Dim detalleMsisdn As New DetalleMsisdnEnServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalleMsisdn.GenerarDataTable()
            With gvListaMsisdn
                .DataSource = dtDatos
                .DataBind()
            End With
            Dim drAux() As DataRow = dtDatos.Select("bloquear=1")
            If drAux.Length > 0 Then
                btnConfirmar.Enabled = False
                epNotificador.showWarning("<i>Uno o mas mines ya fueron adicionados a un radicado activo.</i>")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de MSISDNs asignados al servicio. " & ex.Message)
        End Try

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

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
            With gvNovedadST
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub




    Private Sub CargarJornadas()
        Try
            Dim dtDatos As DataTable = ConsultaJornadaMensajeria()
            With ddlJornada
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idJornada"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja una Jornada", "0"))
            End With

        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Jornadas. " & ex.Message)
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

    Private Sub AsignarRestriccionDeFechas()
        Dim diasRestriccion As String
        Dim numDias As Integer
        Try
            dpFechaAgenda.VisibleDate = Now
            diasRestriccion = MetodosComunes.seleccionarConfigValue("NUM_DIAS_RESTRICCION_AGENDAMIENTO")
            Integer.TryParse(diasRestriccion, numDias)
            If numDias = 0 Then numDias = 2
            With dpFechaAgenda
                .MinValidDate = Now
                .MaxValidDate = Now.AddDays(numDias)
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de asignar restricción de fechas." & ex.Message)
        End Try
    End Sub

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=2)
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

    Private Sub CargarTiposDeNovedadCall()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=17)
            With ddlTipoNovedadCall
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


    Private Sub ConsultarCapacidadEntrega()
        Dim resultado As ResultadoProceso
        Dim consultar As New ServicioMensajeria(idServicio:=CInt(Request.QueryString("idServicio")))

        With consultar
            .FechaAgenda = dpFechaAgenda.SelectedDate
            .IdJornada = CShort(ddlJornada.SelectedValue)
            .IdEmpresa = consultar.IdEmpresa
        End With
        resultado = consultar.ConsultarCapacidad
        If resultado.Valor = 0 Then
            lblCuposDisponibles.Text = resultado.Mensaje
            btnConfirmar.Enabled = True
        Else
            lblCuposDisponibles.Text = "No hay cupos de servicio de entrega disponibles."
            btnConfirmar.Enabled = False
            Select Case resultado.Valor
                Case 1, 2, 10
                    epNotificador.showWarning(resultado.Mensaje)
                Case Else
                    epNotificador.showError(resultado.Mensaje)
            End Select
        End If
    End Sub

    Private Sub EnviarNotificacion(ByVal listNuemeroRadicado As String)
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ObtenerDisponibilidadInventarioParaNotificacion(listNuemeroRadicado)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.RowFilter = "fechaReporteSinDisponibilidad  IS NOT NULL"
        Dim dtAux As DataTable = dvDatos.ToTable()

        If dtAux.Rows.Count > 0 Then
            Dim notificador As New NotificacionEventosInventarioCEM
            Dim mensajeInicio As New ConfigValues("MENSAJE_INICIO_CEM")
            Dim mensajeFin As New ConfigValues("MENSAJE_FIN_CEM")
            Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")
            Dim usuarioRespuesta As New ConfigValues("USUARIO_RESPUESTA_CEM")
            Dim arrUsuarioRespuesta As String() = usuarioRespuesta.ConfigKeyValue.Split(",")
            Dim Fila As DataRow() = dtAux.Select("numeroRadicado IN (" & listNuemeroRadicado & ")")
            Dim tipoServicio As String = CStr(Fila(0).Item("tipoServicio"))
            Dim idBodega As String = CInt(Fila(0).Item("idbodega"))
            Dim mensaje As String
            Dim mensajeDetalle As String

            mensaje = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Radicado</td><td><b>Material</td><td><b>Referencia</td><td><b>Cantidad</td><td><b>Bodega</td></tr>"
            For Each drAux As DataRow In dtAux.Rows
                mensaje += "<tr><td>" & drAux("numeroRadicado").ToString & "</td><td>" & drAux("material").ToString & "</td><td>" & drAux("descripcion").ToString &
                "</td><td>" & drAux("cantidad").ToString & "</td><td>" & drAux("bodega").ToString & "</td></tr>"
            Next
            mensaje += "</table>"

            mensajeDetalle = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Serial</td><td><b>Material</td><td><b>Centro</td><td><b>Almacén</td><td><b>Observaciones</td></tr>"
            mensajeDetalle += "</table>"

            With notificador
                .TipoNotificacion = AsuntoNotificacion.Tipo.SinDisponibilidadInventario
                .InicioMensaje = mensajeInicio.ConfigKeyValue
                .FinMensaje = mensajeFin.ConfigKeyValue
                .FirmaMensaje = firmaMensaje.ConfigKeyValue
                .Titulo = "Notificación Disponibilidad de Inventario"
                .Asunto = "Confirmación de radicados para " & tipoServicio & ", sin disponibilidad de Inventario"
                .MailRespuesta = arrUsuarioRespuesta(0)
                .UsuarioRespuesta = arrUsuarioRespuesta(1)
                .NotificacionEvento(mensaje, mensajeDetalle, idBodega)
            End With
        End If

    End Sub

#End Region

End Class