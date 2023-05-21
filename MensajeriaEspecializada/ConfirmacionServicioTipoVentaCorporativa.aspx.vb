Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports ILSBusinessLayer.Productos
Imports System.Text
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes

Public Class ConfirmacionServicioTipoVentaCorporativa
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer
    Private _referenciasDataTable As New DataTable
    Private _minsDataTable As New DataTable
    Private infoServicioMensajeria As ServicioMensajeriaSiembra
    Private _Equipos As DataTable
    Private _disponibilidad As Boolean = True

#End Region

#Region "Propiedades"

    Public Property IdServicio As Integer
        Get
            If Session("idServicio") IsNot Nothing Then _idServicio = Session("idServicio")
            Return _idServicio
        End Get
        Set(value As Integer)
            Session("idServicio") = value
            _idServicio = value
        End Set
    End Property

    Public Property Equipos As DataTable
        Get
            If _Equipos Is Nothing Then EstructuraEquipos()
            Return _Equipos
        End Get
        Set(value As DataTable)
            _Equipos = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack And Not IsCallback Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, IdServicio)
            If _idServicio > 0 Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Confirmación Servicio Venta Corporativa")
                End With
                CargaInicial(IdServicio)
                CargarNovedades()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                rpEdidatServicio.Enabled = False
            End If
        End If
    End Sub

    Private Sub gvNovedades_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvNovedades.CustomCallback
        Dim respuesta As ResultadoProceso
        Try
            Dim arrParametros() As String = e.Parameters.Split("|")
            Select Case arrParametros(0)
                Case "registrar"
                    btnAdicionarNovedad.Enabled = False
                    Dim objNovedad As New NovedadServicioMensajeria()
                    With objNovedad
                        .IdTipoNovedad = cmbTipoNovedad.Value
                        .IdServicioMensajeria = IdServicio
                        .Observacion = memoObservacionesNovedad.Text
                        respuesta = .Registrar(CInt(Session("usxp001")))
                        If respuesta.Valor = 0 Then
                            VerificarCambioEstado(IdServicio)
                            miEncabezado.showSuccess("Novedad registrada satisfactoriamente.")
                            respuesta = EnviarNotificacion(IdServicio)
                        Else
                            miEncabezado.showError(respuesta.Mensaje)
                        End If
                        btnAdicionarNovedad.Enabled = True
                    End With
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=IdServicio)
            With gvNovedades
                .DataSource = objNovedades
                Session("objNovedades") = .DataSource
                .DataBind()
            End With
            pcNovedades.ShowOnPageLoad = True
            CargarNovedades()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar las novedades: " + ex.Message)
            btnAdicionarNovedad.Enabled = True
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvNovedades_DataBinding(sender As Object, e As System.EventArgs) Handles gvNovedades.DataBinding
        If Session("objNovedades") IsNot Nothing Then gvNovedades.DataSource = Session("objNovedades")
    End Sub

    Protected Sub LinkDisponibilidad_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            'La visualización es visible para todos
            Dim _tieneDisponibilidad As Integer = -1 = CInt(gvEquipos.GetRowValuesByKeyValue(templateContainer.KeyValue, "cantidadDisponible"))
            Dim ctrl As ASPxHyperLink = templateContainer.FindControl("lnkDisponibilidad")
            If _tieneDisponibilidad < 0 Then
                miEncabezado.showWarning("<i>No se puede confirmar el servicio, puesto que una o más referencias no tiene disponibilidad de inventario</i>")
                btnConfirmar.ClientEnabled = False
                _disponibilidad = False
                ctrl.ImageUrl = "~/images/BallRed.gif"
                ctrl.ToolTip = "El material no cuenta con disponibilidad suficiente Por favor valide la disponibilidad del inventario."
            Else
                ctrl.ImageUrl = "~/images/BallGreen.gif"
            End If

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs) Handles btnConfirmar.Click
        Dim fecha As Date = Now.AddDays(0)
        Dim fechaFormat As Date = fecha.ToString("yyyy/MM/dd")
        If dateFechaAgenda.Date >= fechaFormat Then
            ConfirmarServicio()
        Else
            miEncabezado.showWarning("Por favor verifique le la fecha de agenda sea superior a la fecha actual.")
        End If
    End Sub

    Private Sub gvEquipos_DataBinding(sender As Object, e As System.EventArgs) Handles gvEquipos.DataBinding
        If Session("objEquipos") IsNot Nothing Then gvEquipos.DataSource = Session("objEquipos")
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        Dim respuesta As New ResultadoProceso
        Try
            respuesta = ConsultarCapacidadEntrega()
            If CInt(respuesta.Valor) <> 0 Then
                miEncabezado.showWarning(respuesta.Mensaje)
                dateFechaAgenda.Date = Nothing
                CType(source, ASPxCallback).JSProperties("cpControlAgenda") = 1
            Else
                CType(source, ASPxCallback).JSProperties("cpControlAgenda") = 0
            End If
            CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch : End Try
    End Sub

    Private Sub rpConfServicio_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles rpConfServicio.Callback
        Dim resultado As ResultadoProceso
        Dim infoServicio As ServicioMensajeriaSiembra
        Dim idUsuario As Integer
        Try
            Select Case e.Parameter
                Case "novedades"
                    CargarNovedades()
                    CType(sender, ASPxCallbackPanel).JSProperties.Remove("cpMensaje")
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar actualizar el servicio: " + ex.Message)
        End Try
    End Sub

    Protected Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        Dim resultado As New ResultadoProceso
        resultado = ActualizarServicio(IdServicio)
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess("El servicio fue actualizado satisfactoriamente. ")
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeriaVentaCorporativa
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            infoServicio = New ServicioMensajeriaVentaCorporativa(idServicio)

            Session("idCiudad") = infoServicio.IdCiudad
            'Jornada
            MetodosComunes.CargarComboDX(cmbJornada, HerramientasMensajeria.ConsultaJornadaMensajeria(), "idJornada", "nombre")

            'Fecha Agenda
            With dateFechaAgenda
                Dim fechaInicial As Date = Now.AddDays(0)

                'Se valida si existen días no hábiles para aumentar las fechas disponibles.
                Dim objDiasNoHabil As New DiasNoHabilesColeccion()
                With objDiasNoHabil
                    .FechaInicial = fechaInicial
                    .Estado = True
                    .CargarDatos()
                    If .Count > 0 Then
                        Dim fechas As String = String.Empty
                        For Each dia As DiasNoHabiles In objDiasNoHabil
                            fechas = fechas & dia.Fecha.ToString("yyyyMMdd") & "|"
                        Next
                        hfFechasNoDisponibles.Set("fechas", fechas)
                    Else
                        hfFechasNoDisponibles.Set("fechas", String.Empty)
                    End If
                End With
                .MinDate = fechaInicial
            End With

            If infoServicio.Registrado Then
                With infoServicio
                    Session("infoServicioMensajeria") = infoServicio
                    CargarInformacionGeneralServicio(infoServicio)
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                rpEdidatServicio.Enabled = False
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByRef infoServicio As ServicioMensajeriaVentaCorporativa)
        Try
            If Not infoServicio Is Nothing AndAlso infoServicio.Registrado Then
                With infoServicio
                    With infoServicio
                        lblFechaSolicitud.Text = .FechaRegistro
                        lblEstado.Text = .Estado
                        lblCiudad.Text = .Ciudad
                        lblNombreEmpresa.Text = .NombreCliente
                        lblNumeroNit.Text = .IdentificacionCliente
                        lblTelefonoFijo.Text = .TelefonoContacto
                        lblNombreRepresentante.Text = .NombreRepresentanteLegal
                        lblNumeroIdentificacionRepresentante.Text = .IdentificacionRepresentanteLegal
                        lblTelefonoRepresentante.Text = .TelefonoRepresentanteLegal
                        'lblPersonaAutorizada.Text = .PersonaContacto
                        txtPersonaAutorizada.Text = .PersonaContacto
                        'lblNumeroIdentificacionAutorizado.Text = .IdentificacionAutorizado
                        txtIdentificacionAutorizado.Text = .IdentificacionAutorizado
                        lblTelefonoPersonaAutorizada.Text = .TelefonoAutorizado
                        'lblCargoPersonaAutorizada.Text = .CargoAutorizado
                        txtCargoPersonaAutorizada.Text = .CargoAutorizado
                        'lblBarrio.Text = .Barrio
                        txtBarrio.Text = .Barrio
                        'lblDireccion.Text = .Direccion
                        asDireccion.value = .Direccion
                        lblObservacionDireccion.Text = .ObservacionDireccion
                        lblGerencia.Text = .NombreGerencia
                        lblCoordinador.Text = .NombreCoordinador
                        lblConsultor.Text = .NombreConsultor
                        If .ClienteClaro Then lblClienteClaro.Text = "Sí" Else lblClienteClaro.Text = "No"
                        lblFormaPago.Text = .FormaPago
                        lblTipoServicio.Text = .TipoServicio
                        lblFechaConfirmacion.Text = .FechaConfirmacion
                        lblFechaEntrega.Text = .FechaEntrega
                        lblConfirmadoPor.Text = .ConfirmadoPor
                        lblFechaDespacho.Text = .FechaDespacho
                        lblDespachoPor.Text = .DespachoPor
                        lblResponsableEntrega.Text = .ResponsableEntrega
                        lblZona.Text = .Zona
                        lblBodega.Text = .Bodega
                        lblIdServicio.Text = .IdServicioMensajeria
                        dateFechaAgenda.Date = .FechaAgenda
                        If .IdJornada <> 0 Then
                            cmbJornada.SelectedIndex = .IdJornada
                        Else
                            cmbJornada.Text = String.Empty
                        End If
                        memoObservaciones.Text = .Observacion
                        lblIdBodega.Text = .IdBodega

                        If .DetalleMaterialServicio IsNot Nothing AndAlso .DetalleMaterialServicio.Count > 0 Then
                            For Each ref As DetalleMaterialServicioMensajeriaTipoVentaCorporativaColeccion In .DetalleMaterialServicio
                                AdicionarEquipo(ref.Material, ref.DescripcionMaterial, ref.Cantidad, ref.FechaDevolucion, ref.CantidadDisponible, ref.CantidadLeida)
                                'If (ref.Cantidad - ref.CantidadLeida) > 0 Then
                                '    gvEquipos.Columns.Item("Disponibilidad").Visible = True
                                'End If
                            Next
                            CargarEquipos()
                        End If

                    End With
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior.")
            End If

        Catch ex As Exception
            Throw New Exception("Error al tratar de cargar información general del servicio. " & ex.Message)
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarNovedades()
        Try
            'Se valida si tiene novedades sin gestionar
            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=IdServicio, idEstadoNovedad:=Enumerados.EstadoNovedadMensajeria.Registrado)
            If _disponibilidad Then
                btnConfirmar.ClientEnabled = (objNovedades.Count = 0)
            End If
            btnNovedad.Text = "Gestión Novedades (" + objNovedades.Count.ToString() + ")"
            CargarListaNovedad()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la Cargar de Novedades de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListaNovedad()
        ' Se cargan los tipos de Novedad
        With cmbTipoNovedad
            .DataSource = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Confirmacion,
                                                                       idTipoServicio:=Enumerados.TipoServicio.Venta)
            .TextField = "descripcion"
            .ValueField = "idTipoNovedad"
            .DataBind()
        End With
    End Sub

    Public Sub VerificarCambioEstado(ByRef idServicio As Integer)
        Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
        If objServicio.IdEstado = Enumerados.EstadoServicio.Creado Then
            With objServicio
                .IdServicioMensajeria = idServicio
                .IdEstado = Enumerados.EstadoServicio.GestionadoConNovedadEnContacto
                .Actualizar(CInt(Session("usxp001")))
            End With
        End If
    End Sub

    Private Function AdicionarEquipo(ByVal material As String, referencia As String, ByVal cantidad As Integer, ByVal fechaDevolucion As Date, ByVal cantidadDisponible As Integer, ByVal cantidadLeida As Integer) As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        If Not Equipos.Rows.Contains(material) Then
            Dim filaEquipo As DataRow = Equipos.NewRow()
            With filaEquipo
                .Item("material") = material
                .Item("referencia") = referencia
                .Item("cantidad") = cantidad
                .Item("cantidadLeida") = cantidadLeida
                .Item("fechaDevolucion") = fechaDevolucion
                .Item("cantidadDisponible") = cantidadDisponible

            End With
            Equipos.Rows.Add(filaEquipo)
        Else
            respuesta.EstablecerMensajeYValor(1, "El material [" + material + "] ya se encuentra seleccionado, por favor verifique e intente nuevamente.")
        End If
        Return respuesta
    End Function

    Private Sub CargarEquipos()
        With gvEquipos
            .DataSource = Equipos
            Session("objEquipos") = .DataSource
            .DataBind()
        End With
    End Sub

    Private Sub EstructuraEquipos()
        Try
            _Equipos = New DataTable()
            With _Equipos
                .Columns.Add(New DataColumn("material", GetType(String)))
                .Columns.Add(New DataColumn("referencia", GetType(String)))
                .Columns.Add(New DataColumn("cantidad", GetType(Integer)))
                .Columns.Add(New DataColumn("cantidadLeida", GetType(Integer)))
                .Columns.Add(New DataColumn("fechaDevolucion", GetType(Date)))
                .Columns.Add(New DataColumn("cantidadDisponible", GetType(Integer)))

                .PrimaryKey = New DataColumn() {Equipos.Columns("material")}
            End With
            _Equipos.AcceptChanges()
            Session("dtEquipos") = _Equipos
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub ConfirmarServicio()
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim infoServicio As ServicioMensajeriaVentaCorporativa
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeriaVentaCorporativa(CInt(Request.QueryString("idServicio")))
            With infoServicio
                .Observacion = memoObservaciones.Text.Trim
                .FechaAgenda = dateFechaAgenda.Date
                .IdJornada = cmbJornada.Value
                .IdCiudad = .IdCiudad
                .IdUsuarioConfirmacion = idUsuario
                resultado = .Confirmar()

                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess("Se realizó la confirmación del Servicio Satisfactoriamente.")
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                End If

            End With
        Catch ex As Exception
            miEncabezado.showWarning("Se generó un error la tratar de confirmar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Function ConsultarCapacidadEntrega() As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Dim objServicio As New ServicioMensajeria
        Dim agendaRestringida As Boolean = True
        Dim arrFechas As New ArrayList
        Try
            'Se realiza la validación de restricciones
            'Dim dsRestriccion As DataSet = HerramientasMensajeria.ObtieneRestriccionAgenda()
            'If dsRestriccion.Tables.Count > 0 Then
            '    'Obtiene la jornada actual
            '    Dim idJornadaActual As Short
            '    For Each jornada As DataRow In dsRestriccion.Tables(0).Rows
            '        Dim horaInicial = jornada("horaInicial")
            '        Dim horaFinal = jornada("horaFinal")
            '        If Date.Now.TimeOfDay >= horaInicial And Date.Now.TimeOfDay <= horaFinal Then
            '            idJornadaActual = jornada("idJornada")
            '        End If
            '    Next
            'If idJornadaActual > 0 Then
            '    Dim dvDatos As DataView = dsRestriccion.Tables(1).DefaultView
            '    With dvDatos
            '        .RowFilter = "idJornadaActual=" & idJornadaActual.ToString & " AND idJornadaRestringida=" & cmbJornada.Value.ToString
            '        .Sort = "noDias DESC"
            '    End With
            '    If dvDatos.Count > 0 Then
            '        If Now.AddDays(dvDatos(0).Item("noDias")) < dateFechaAgenda.Date Then
            '            agendaRestringida = False
            '        End If
            '    End If

            With objServicio
                .IdCiudad = CInt(Session("idCiudad"))
                '.IdBodega = lblIdBodega.Text
                .FechaAgenda = dateFechaAgenda.Date
                .IdJornada = CShort(cmbJornada.Value)
                .IdTipoServicio = Enumerados.TipoServicio.VentaCorporativa
                arrFechas.Add(.IdBodega)
                arrFechas.Add(.FechaAgenda)
                arrFechas.Add(.IdJornada)
            End With
            'If Not agendaRestringida Then
            resultado = objServicio.ConsultarCapacidad()
            If resultado.Valor = 0 Then
                resultado = objServicio.RegistrarCupoEntrega()
                If resultado.Valor = 0 Then
                    If Session("FechasCupoEntrega") IsNot Nothing Then
                        Dim arrFechasCambio As ArrayList = Session("FechasCupoEntrega")
                        objServicio.FechaAgenda = arrFechasCambio(1).ToString
                        objServicio.IdBodega = arrFechasCambio(0).ToString
                        objServicio.IdJornada = arrFechasCambio(2).ToString
                        resultado = objServicio.LiberarCupoEntrega()
                    End If
                    Session("FechasCupoEntrega") = arrFechas
                End If
            End If
            'Else
            'resultado.EstablecerMensajeYValor(100, "No se puede asignar la fecha de agenda, ya que no se cumplen las condiciones establecidas para el agendamiento.")
            'End If
            'Else
            'resultado.EstablecerMensajeYValor(300, "No se encuentra un Horario hábil para registrar ventas.")
            'End If
            'End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(200, ex.Message)
        End Try
        Return resultado
    End Function

    Private Function EnviarNotificacion(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim resultadoMensaje As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(idServicio)
        Dim correo As String = miServicio.EmailConsultor
        Dim notificador As New NotificadorGeneralEventos
        Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")

        resultadoMensaje = HerramientasMensajeria.MensajeNotificacionConfirmacionVentaCorporativa(idServicio)

        If resultadoMensaje.Valor = 0 Then
            With notificador
                .InicioMensaje = resultadoMensaje.Mensaje
                .FirmaMensaje = firmaMensaje.ConfigKeyValue
                .Titulo = "Notificación Entrega de Venta Corporativa"
                .Asunto = "Notificación Novedad Entrega de Venta Corporativa con el identificador:  " & idServicio
                resultado = .NotificacionEvento(usuarioUnicoNotificacion:=correo)
            End With
        End If
        Return resultado
    End Function

    Private Function ActualizarServicio(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa

        With miServicio
            .IdServicioMensajeria = idServicio
            .IdUsuario = CInt(Session("usxp001"))
            .Direccion = asDireccion.value
            .DireccionEdicion = asDireccion.DireccionEdicion
            .PersonaContacto = txtPersonaAutorizada.Text
            .IdentificacionAutorizado = txtIdentificacionAutorizado.Text.Trim
            .CargoAutorizado = txtCargoPersonaAutorizada.Text
            .Barrio = txtBarrio.Text
            resultado = .Editar()
        End With
        Return resultado
    End Function

#End Region

End Class