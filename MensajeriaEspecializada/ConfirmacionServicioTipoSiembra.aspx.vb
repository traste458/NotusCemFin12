Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer

Public Class ConfirmacionServicioTipoSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer

    Private _PersonasGerencia As DataTable
    Private _Ciudades As DataTable
    Private _Equipos As DataTable
    Private _Sims As DataTable

    Private Shared infoEstados As InfoEstadoRestriccionCEM

#End Region

#Region "Propiedades"

    Public Property Equipos As DataTable
        Get
            If _Equipos Is Nothing Then EstructuraEquipos()
            Return _Equipos
        End Get
        Set(value As DataTable)
            _Equipos = value
        End Set
    End Property

    Public Property Ciudades As DataTable
        Get
            Return _Ciudades
        End Get
        Set(value As DataTable)
            _Ciudades = value
        End Set
    End Property

    Public Property Sims As DataTable
        Get
            If _Sims Is Nothing Then EstructuraSIMs()
            Return _Sims
        End Get
        Set(value As DataTable)
            _Sims = value
        End Set
    End Property

    Public Property PersonasGerencia As DataTable
        Get
            If _PersonasGerencia Is Nothing Then PersonalEnGerencia()
            Return _PersonasGerencia
        End Get
        Set(value As DataTable)
            _PersonasGerencia = value
        End Set
    End Property

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

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, IdServicio)
            If _idServicio > 0 Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Confirmación Servicio SIEMBRA")
                End With
                CargaInicial()
                CargarNovedades()
                CargarInformacionGeneralServicio(_idServicio)
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                rpConfirmacionSiembra.Enabled = False
            End If
        Else
            If Session("dtCiudades") IsNot Nothing Then _Ciudades = Session("dtCiudades")
            If Session("dtPersonasGerencia") IsNot Nothing Then _PersonasGerencia = Session("dtPersonasGerencia")
        End If
    End Sub

    Protected Sub Link_InitEquipo(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            'Link de Eliminación
            With lnkEliminar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades de Equipos: " & ex.Message)
        End Try
    End Sub

    Private Sub cpConfirmacion_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpConfirmacion.Callback
        Dim resultado As ResultadoProceso
        Dim infoServicio As ServicioMensajeriaSiembra
        Dim idUsuario As Integer
        Try
            Select Case e.Parameter
                Case "novedades"
                    CargarNovedades()
                    CType(sender, ASPxCallbackPanel).JSProperties.Remove("cpMensaje")

                Case Else
                    Integer.TryParse(Session("usxp001"), idUsuario)
                    infoServicio = New ServicioMensajeriaSiembra(IdServicio)
                    If infoServicio.Registrado Then
                        With infoServicio
                            .FechaRegistro = dateFechaSolicitud.Date
                            .IdCiudad = cmbCiudadEntrega.Value
                            .NombreCliente = txtNombreEmpresa.Text
                            .IdentificacionCliente = txtIdentificacionCliente.Text
                            .TelefonoContacto = txtTelefonoFijo.Text
                            .ExtensionContacto = txtExtTelefonoFijo.Text
                            .NombreRepresentanteLegal = txtNombreRepresentante.Text
                            .TelefonoRepresentanteLegal = txtTelefonoMovilRepresentante.Text
                            .IdentificacionRepresentanteLegal = txtIdentificacionRepresentante.Text
                            .PersonaContacto = txtPersonaAutorizada.Text
                            .IdentificacionAutorizado = txtIdentificacionAutorizado.Text
                            .CargoAutorizado = txtCargoPersonaAutorizada.Text
                            .TelefonoAutorizado = txtTelefonoAutorizado.Text
                            .Direccion = memoDireccion.value
                            .DireccionEdicion = memoDireccion.DireccionEdicion
                            .ObservacionDireccion = memoObservacionDireccion.Text
                            .Barrio = txtBarrio.Text
                            .IdGerencia = cmbGerencia.Value
                            .IdCoordinador = cmbCoordinador.Value
                            .IdConsultor = cmbConsultor.Value
                            .ClienteClaro = rblClienteClaro.Value
                            .Observacion = memoObservaciones.Text
                            .FechaAgenda = dateFechaAgenda.Date
                            .IdJornada = cmbJornada.Value
                            .IdUsuarioConfirmacion = idUsuario

                            resultado = .Confirmar()

                            If resultado.Valor = 0 Then
                                miEncabezado.showSuccess("Se realizó la confirmación del Servicio Satisfactoriamente.")
                            Else
                                miEncabezado.showWarning(resultado.Mensaje)
                                CargarInformacionGeneralServicio(_idServicio)
                            End If
                        End With
                    Else
                        miEncabezado.showError("No se logro obtener la información del servicio actual, por favor intente nuevamente.")
                    End If
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar actualizar el servicio: " + ex.Message)
        End Try
    End Sub

    Private Sub cbCuposEntrega_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbCuposEntrega.Callback
        Dim respuesta As New ResultadoProceso
        Try
            respuesta = ConsultarCapacidadEntrega()
            If respuesta.Valor <> 0 Then
                miEncabezado.showWarning(respuesta.Mensaje)
                dateFechaAgenda.Date = Nothing
                CType(source, ASPxCallback).JSProperties("cpControlAgenda") = 0
            End If
            CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch : End Try
    End Sub

    Private Sub gvNovedades_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvNovedades.CustomCallback
        Dim respuesta As ResultadoProceso
        Try
            Dim arrParametros() As String = e.Parameters.Split("|")
            Select Case arrParametros(0)
                Case "registrar"
                    Dim objNovedad As New NovedadServicioMensajeria()
                    With objNovedad
                        .IdTipoNovedad = cmbTipoNovedad.Value
                        .IdServicioMensajeria = IdServicio
                        .Observacion = memoObservacionesNovedad.Text
                        respuesta = .Registrar(CInt(Session("usxp001")))

                        CType(sender, ASPxGridView).JSProperties("cpMensajeRespuesta") = respuesta.Valor
                    End With
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=IdServicio)
            With gvNovedades
                .DataSource = objNovedades
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar las novedades: " + ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub LinkDisponibilidad_Init(ByVal sender As Object, ByVal e As EventArgs)
         Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            'La visualización es visible para todos
            Dim tieneDisponibilidad As Integer = CInt(gvEquipos.GetRowValuesByKeyValue(templateContainer.KeyValue, "cantidadDisponible"))
            Dim ctrl As ASPxHyperLink = templateContainer.FindControl("lnkDisponibilidad")
            If tieneDisponibilidad < 0 Then
                miEncabezado.showWarning("<i>No se puede confirmar el servicio, puesto que una o más referencias no tiene disponibilidad de inventario</i>")
                btnConfirmar.ClientEnabled = False
                ctrl.ImageUrl = "~/images/BallRed.gif"
                ctrl.ToolTip = "El material no cuenta con disponibilidad suficiente Por favor valide la disponibilidad del inventario."
            Else
                ctrl.ImageUrl = "~/images/BallGreen.gif"
            End If

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Fecha de Registro
            With dateFechaSolicitud
                .Date = Now.Date
                .ClientEnabled = False
            End With

            'Se cargan las Ciudades
            With cmbCiudadEntrega
                .DataSource = HerramientasMensajeria.ObtenerCiudadesCem(idCiudadPadre:=CInt(Session("usxp007")))
                Session("dtCiudades") = .DataSource
                .DataBind()
            End With

            'Gerencias y Ejecutivos
            Dim dvPersonasGerencia As DataView = PersonasGerencia.DefaultView
            With cmbGerencia
                .DataSource = dvPersonasGerencia.ToTable()
                .ValueField = "idGerencia"
                .TextField = "gerencia"
                .ClientEnabled = False
                .DataBind()
            End With

            With cmbCoordinador
                .DataSource = dvPersonasGerencia.ToTable()
                .ValueField = "idPersonaPadre"
                .TextField = "personaPadre"
                .ClientEnabled = False
                .DataBind()
            End With

            With cmbConsultor
                .DataSource = dvPersonasGerencia.ToTable()
                .ValueField = "idPersona"
                .TextField = "persona"
                .ClientEnabled = False
                .DataBind()
            End With

            'Fecha Agenda
            With dateFechaAgenda
                Dim fechaInicial As Date = Now.AddDays(0)
                Dim fechaFinal As Date = Now.AddDays(CInt(MetodosComunes.seleccionarConfigValue("MAX_DIAS_AGENDAMIENTO_VENTAS_CEM")))

                'Se valida si existen días no hábiles para aumentar las fechas disponibles.
                Dim objDiasNoHabil As New DiasNoHabilesColeccion()
                With objDiasNoHabil
                    .FechaInicial = fechaInicial
                    .FechaFinal = fechaFinal
                    AsignarFechaFinal(.FechaFinal)
                    .Estado = True
                    .CargarDatos()
                    If .Count > 0 Then
                        .FechaFinal = .FechaFinal.AddDays(.Count)
                        Dim fechas As String = String.Empty
                        For Each dia As DiasNoHabiles In objDiasNoHabil
                            fechas = fechas & dia.Fecha.ToString("yyyyMMdd") & "|"
                        Next
                        hfFechasNoDisponibles.Set("fechas", fechas)
                    Else
                        hfFechasNoDisponibles.Set("fechas", String.Empty)
                    End If
                    If .FechaFinal > fechaFinal Then fechaFinal = .FechaFinal
                End With
                .MinDate = fechaInicial
                .MaxDate = fechaFinal
            End With

            'Jornadas
            Dim dtDatos As DataTable = ConsultaJornadaMensajeria()
            With cmbJornada
                .DataSource = dtDatos
                .TextField = "nombre"
                .ValueField = "idJornada"
                .DataBind()
            End With

            ' Se cargan los tipos de Novedad
            With cmbTipoNovedad
                .DataSource = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Confirmacion, _
                                                                           gestionable:=Enumerados.EstadoBinario.Activo, _
                                                                           idTipoServicio:=Enumerados.TipoServicio.Siembra)
                .TextField = "descripcion"
                .ValueField = "idTipoNovedad"
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la carga inicial de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarNovedades()
        Try
            'Se valida si tiene novedades sin gestionar
            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=IdServicio, idEstadoNovedad:=Enumerados.EstadoNovedadMensajeria.Registrado)
            btnConfirmar.ClientEnabled = (objNovedades.Count = 0)
            btnNovedad.Text = "Gestión Novedades (" + objNovedades.Count.ToString() + ")"
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la Cargar de Novedades de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeriaSiembra
        Try
            infoServicio = New ServicioMensajeriaSiembra(idServicio)
            With infoServicio
                miEncabezado.setTitle("Confirmación de Servicio SIEMBRA: " & .IdServicioMensajeria.ToString)

                dateFechaSolicitud.Date = .FechaRegistro
                lblEstado.Text = .Estado
                cmbCiudadEntrega.Value = .IdCiudad.ToString()
                txtNombreEmpresa.Text = .NombreCliente
                txtIdentificacionCliente.Text = .IdentificacionCliente
                txtTelefonoFijo.Text = .TelefonoContacto
                txtExtTelefonoFijo.Text = .ExtensionContacto
                txtNombreRepresentante.Text = .NombreRepresentanteLegal
                txtTelefonoMovilRepresentante.Text = .TelefonoRepresentanteLegal
                txtIdentificacionRepresentante.Text = .IdentificacionRepresentanteLegal
                txtPersonaAutorizada.Text = .PersonaContacto
                txtIdentificacionAutorizado.Text = .IdentificacionAutorizado
                txtCargoPersonaAutorizada.Text = .CargoAutorizado
                txtTelefonoAutorizado.Text = .TelefonoAutorizado
                memoDireccion.value = .Direccion
                memoDireccion.DireccionEdicion = .DireccionEdicion
                memoObservacionDireccion.Text = .ObservacionDireccion
                txtBarrio.Text = .Barrio
                cmbGerencia.Value = .IdGerencia
                cmbCoordinador.Value = .IdCoordinador
                cmbConsultor.Value = .IdConsultor
                rblClienteClaro.Value = IIf(.ClienteClaro, 1, 0).ToString()
                memoObservaciones.Text = .Observacion

                If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                    For Each ref As DetalleMaterialServicioMensajeria In .ReferenciasColeccion
                        AdicionarEquipo(ref.Material, ref.DescripcionMaterial, ref.Cantidad, ref.FechaDevolucion, ref.CantidadDisponible)
                    Next
                    CargarEquipos()
                End If
            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Function AdicionarEquipo(ByVal material As String, referencia As String, ByVal cantidad As Integer, ByVal fechaDevolucion As Date, ByVal cantidadDisponible As Integer) As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        If Not Equipos.Rows.Contains(material) Then
            Dim filaEquipo As DataRow = Equipos.NewRow()
            With filaEquipo
                .Item("material") = material
                .Item("referencia") = referencia
                .Item("cantidad") = cantidad
                .Item("fechaDevolucion") = fechaDevolucion
                .Item("cantidadDisponible") = cantidadDisponible
            End With
            Equipos.Rows.Add(filaEquipo)
        Else
            Dim dr() As DataRow

            dr = Equipos.Select("material ='" & material & "'")
            If Not dr Is Nothing Then
                'Fila encontrada

                dr(0)("cantidad") = DirectCast(dr(0)("cantidad"), Integer) + CInt(cantidad)

            End If
            'respuesta.EstablecerMensajeYValor(1, "El material [" + material + "] ya se encuentra seleccionado, por favor verifique e intente nuevamente.")
        End If
        Return respuesta
    End Function

    Private Sub CargarEquipos()
        With gvEquipos
            .DataSource = Equipos
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

    Private Sub EstructuraSIMs()
        Try
            _Sims = New DataTable()
            With _Sims
                .Columns.Add(New DataColumn("idClaseSim", GetType(Integer)))
                .Columns.Add(New DataColumn("nombreClase", GetType(String)))
                .Columns.Add(New DataColumn("idRegion", GetType(Integer)))
                .Columns.Add(New DataColumn("nombreRegion", GetType(String)))
                .Columns.Add(New DataColumn("cantidad", GetType(Integer)))
                .Columns.Add(New DataColumn("fechaDevolucion", GetType(Date)))

                .PrimaryKey = New DataColumn() {Sims.Columns("idClaseSim"), Sims.Columns("idRegion")}
            End With
            _Sims.AcceptChanges()
            Session("dtSims") = _Sims
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub EstructuraEjecutivos()
        Try
            'TODO: Cambio funcionalidad relación de gerencias
            'Dim objEjecutivos As New GerenciaClienteEjecutivoColeccion()
            '_Ejecutivos = objEjecutivos.GenerarDataTable()
            'Session("dtEjecutivos") = _Ejecutivos
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub AsignarFechaFinal(ByRef fechaFinal As Date)
        Try
            Dim objDiaNoHabil As New DiasNoHabiles(fechaFinal)
            If objDiaNoHabil.Registrado Then
                fechaFinal = fechaFinal.AddDays(1)
                AsignarFechaFinal(fechaFinal)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar calcular la fecha final de agenda: " & ex.Message)
        End Try
    End Sub

    Private Function ConsultarCapacidadEntrega() As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Dim objServicio As New ServicioMensajeria
        Dim agendaRestringida As Boolean = True
        Dim arrFechas As New ArrayList
        Try
            'Se realiza la validación de restricciones
            Dim dsRestriccion As DataSet = HerramientasMensajeria.ObtieneRestriccionAgenda()
            If dsRestriccion.Tables.Count > 0 Then
                'Obtiene la jornada actual
                Dim idJornadaActual As Short
                For Each jornada As DataRow In dsRestriccion.Tables(0).Rows
                    Dim horaInicial = jornada("horaInicial")
                    Dim horaFinal = jornada("horaFinal")
                    If Date.Now.TimeOfDay >= horaInicial And Date.Now.TimeOfDay <= horaFinal Then
                        idJornadaActual = jornada("idJornada")
                    End If
                Next
                If idJornadaActual > 0 Then
                    Dim dvDatos As DataView = dsRestriccion.Tables(1).DefaultView
                    With dvDatos
                        .RowFilter = "idJornadaActual=" & idJornadaActual.ToString & " AND idJornadaRestringida=" & cmbJornada.Value.ToString
                        .Sort = "noDias DESC"
                    End With
                    If dvDatos.Count > 0 Then
                        If Now.AddDays(dvDatos(0).Item("noDias")) < dateFechaAgenda.Date Then
                            agendaRestringida = False
                        End If
                    End If

                    With objServicio
                        .IdServicioMensajeria = IdServicio
                        .IdBodega = Ciudades.Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")
                        .FechaAgenda = dateFechaAgenda.Date
                        .IdJornada = CShort(cmbJornada.Value)
                        .IdTipoServicio = Enumerados.TipoServicio.Siembra
                        arrFechas.Add(.IdBodega)
                        arrFechas.Add(.FechaAgenda)
                        arrFechas.Add(.IdJornada)
                    End With
                    If Not agendaRestringida Then
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
                    Else
                        resultado.EstablecerMensajeYValor(100, "No se puede asignar la fecha de agenda, ya que no se cumplen las condiciones establecidas para el agendamiento.")
                    End If
                Else
                    resultado.EstablecerMensajeYValor(300, "No se encuentra un Horario hábil para registrar ventas.")
                End If
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(200, ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub PersonalEnGerencia()
        Try
            _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
            Session("dtPersonasGerencia") = _PersonasGerencia
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

   
End Class