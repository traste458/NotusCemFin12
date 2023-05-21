Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.Inventario
Imports System.Collections.Generic
Imports System.Text
Imports ILSBusinessLayer.Productos

Public Class EditarServicioTipoSiembra
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

        Try
            If Not IsPostBack Then
                If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, IdServicio)
                If _idServicio > 0 Then
                    With miEncabezado
                        .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                        .setTitle("Edición de Servicio SIEMBRA")
                    End With
                    CargaInicial()
                    CargarInformacionGeneralServicio(_idServicio)
                Else
                    miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                    rpRegistroSiembra.Enabled = False
                End If
            Else
                If Session("dtPersonasGerencia") IsNot Nothing Then _PersonasGerencia = Session("dtPersonasGerencia")
                If Session("dtCiudades") IsNot Nothing Then _Ciudades = Session("dtCiudades")
                If Session("dtEquipos") IsNot Nothing Then _Equipos = Session("dtEquipos")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
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

    Protected Sub Link_InitSim(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            Dim arrKey() As String = templateContainer.KeyValue.ToString().Split("|")

            'Link de Eliminación
            With lnkEliminar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", arrKey(0))
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{1}", arrKey(1))
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades de Sims: " & ex.Message)
        End Try
    End Sub

    Private Sub cpEdicion_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpEdicion.Callback
        Dim resultado As ResultadoProceso
        Dim infoServicio As ServicioMensajeriaSiembra
        Try
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
                    .IdConsultor = cmbGerencia.Value
                    .ClienteClaro = rblClienteClaro.Value
                    .Observacion = memoObservaciones.Text

                    resultado = .Actualizar(CInt(Session("usxp001")))

                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess("Se realizó la actualización del Servicio Satisfactoriamente.")
                    Else
                        miEncabezado.showWarning(resultado.Mensaje)
                    End If
                End With
            Else
                miEncabezado.showError("No se logro obtener la información del servicio actual, por favor inntente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar actualizar el servicio: " + ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
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

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub EstructuraEquipos()
        Try
            _Equipos = New DataTable()
            With _Equipos
                .Columns.Add(New DataColumn("material", GetType(String)))
                .Columns.Add(New DataColumn("referencia", GetType(String)))
                .Columns.Add(New DataColumn("cantidad", GetType(Integer)))
                .Columns.Add(New DataColumn("fechaDevolucion", GetType(Date)))

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

    Private Sub PersonalEnGerencia()
        Try
            _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
            Session("dtPersonasGerencia") = _PersonasGerencia
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeriaSiembra
        Try
            infoServicio = New ServicioMensajeriaSiembra(idServicio)
            With infoServicio
                miEncabezado.setTitle("Edición de Servicio SIEMBRA: " & .IdServicioMensajeria.ToString)

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

                'Se carga la jerarquía de gerencia
                Dim dvPersonasGerencia As DataView = PersonasGerencia.DefaultView
                dvPersonasGerencia.RowFilter = "idPersona = " & .IdConsultor.ToString()

                If dvPersonasGerencia.Count > 0 Then
                    With cmbGerencia
                        .DataSource = dvPersonasGerencia.ToTable()
                        .ValueField = "idGerencia"
                        .TextField = "gerencia"
                        .SelectedIndex = 0
                        .ClientEnabled = False
                        .DataBind()
                    End With

                    With cmbCoordinador
                        .DataSource = dvPersonasGerencia.ToTable()
                        .ValueField = "idPersonaPadre"
                        .TextField = "personaPadre"
                        .SelectedIndex = 0
                        .ClientEnabled = False
                        .DataBind()
                    End With

                    With cmbConsultor
                        .DataSource = dvPersonasGerencia.ToTable()
                        .ValueField = "idPersona"
                        .TextField = "persona"
                        .SelectedIndex = 0
                        .ClientEnabled = False
                        .DataBind()
                    End With
                    cmbGerencia.Value = .IdGerencia
                    cmbCoordinador.Value = .IdCoordinador
                    cmbConsultor.Value = .IdConsultor
                End If
                
                rblClienteClaro.Value = IIf(.ClienteClaro, 1, 0).ToString()
                memoObservaciones.Text = .Observacion

                If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                    For Each ref As DetalleMaterialServicioMensajeria In .ReferenciasColeccion
                        AdicionarEquipo(ref.Material, ref.DescripcionMaterial, ref.Cantidad)
                    Next
                    CargarEquipos()
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Function AdicionarEquipo(ByVal material As String, referencia As String, ByVal cantidad As Integer) As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        If Not Equipos.Rows.Contains(material) Then
            Dim filaEquipo As DataRow = Equipos.NewRow()
            With filaEquipo
                .Item("material") = material
                .Item("referencia") = referencia
                .Item("cantidad") = cantidad
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
            .DataBind()
        End With
    End Sub

#End Region

End Class