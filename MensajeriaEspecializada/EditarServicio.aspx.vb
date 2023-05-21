Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes
Imports System.Text
Imports System.IO
Imports GemBox
Imports GemBox.Spreadsheet
Imports System.Collections.Generic


Partial Public Class EditarServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer
    Private dtError As DataTable
    Private _referenciasDataTable As New DataTable
    Private _minsDataTable As New DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, True)
        epNotificador.clear()
        CrearEstructuraDataTable()
#If DEBUG Then
        Session("usxp001") = 145
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If

        If Not Me.IsPostBack Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, _idServicio)

            If _idServicio > 0 Then
                Dim miServicio As New ServicioMensajeria(_idServicio)
                If miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or miServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Or miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia Then
                    Response.Redirect("EditarServicioFinanciero.aspx?idServicio=" & _idServicio)
                End If
                If miServicio.IdTipoServicio = Enumerados.TipoServicio.Reposicion And miServicio.IdEstado = Enumerados.EstadoServicio.Creado Then
                    pnlInfoArchivo.Visible = True
                Else
                    pnlInfoArchivo.Visible = False
                End If

                epNotificador.setTitle("Modificar Servicio ")
                epNotificador.showReturnLink("PoolServiciosNew.aspx")

                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()

                CargaInicial()
                CargarInformacionGeneralServicio(_idServicio)

                pnlBotonEdicionReferencia.Visible = False
                pnlBotonEdicionMin.Visible = False

                txtNoRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtMsisdn.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtPrecioSinIVA.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtPrecioConIVA.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtCantidad.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")

                txtTelefono.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtExtension.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                rbTelefonoCelular.Attributes.Add("onmousedown", "javascript:validarTelefono()")
                rbTelefonoFijo.Attributes.Add("onmousedown", "javascript:validarTelefono()")

                Session("idServicio") = _idServicio
            Else
                pnlGeneral.Enabled = False
                epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            CargarDatos()
        End If

    End Sub


    Protected Sub lbGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGuardar.Click
        ActualizarRegistro(_idServicio)
    End Sub

    Protected Sub lbAnular_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAnular.Click
        AnularRegistro(_idServicio)
    End Sub


    Private Sub gvReferencias_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvReferencias.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarReferencia(e.CommandArgument.ToString())
            Case "editar"
                IniciarFormularioEdicionReferencia(e.CommandArgument.ToString)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub lbAgregarReferencia_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAgregarReferencia.Click
        AgregarReferencia()
        txtFiltroMaterial.Text = ""
        CargarListadoDeMateriales()
        lbFiltraMaterial.Enabled = True
        lbQuitaFiltromaterial.Enabled = True
        txtFiltroReferencia.Enabled = True
        lbQuitaFiltromaterial_Click(sender, e)
        txtCantidad.Text = ""
    End Sub


    Private Sub gvMINS_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvMINS.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarMIN(e.CommandArgument.ToString())
            Case "editar"
                IniciarFormularioEdicionMin(e.CommandArgument)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub lbAgregarMIN_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAgregarMIN.Click
        AgregarMINs()
        txtMsisdn.Text = ""
        chbActivaEquipoAnterior.Checked = False
        chbComSeguro.Checked = False
        txtPrecioSinIVA.Text = ""
        txtPrecioConIVA.Text = ""
        txtNumeroReserva.Text = ""
        ddlClausula.SelectedIndex = -1
        rblLista28.ClearSelection()
        lbLimpiarFiltroMsisdn_Click(sender, e)
    End Sub


    Protected Sub lbActualizarRef_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarRef.Click
        ActualizarReferencia()
    End Sub

    Protected Sub lbCancelarActRef_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCancelarActRef.Click
        FinalizarModoEdicionReferencia()
    End Sub


    Protected Sub lbActualizarMin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarMin.Click
        ActualizarMINs()
    End Sub

    Protected Sub lbCancelarActMin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCancelarActMin.Click
        FinalizarModoEdicionMin()
    End Sub

#End Region

#Region "Delegados"

    Private Sub cpFiltroMaterial_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMaterial.Execute
        If e.Parameter = "filtrarMaterial" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMaterial.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeMateriales(filtroRapido)
        End If
        cpFiltroMaterial.Update()
    End Sub

    Private Sub CargarListadoDeMateriales(Optional ByVal filtroRapido As String = "")
        Try
            'pnlDetalle.Visible = True
            With ddlMaterial
                If filtroRapido.Trim.Length > 0 Then
                    Dim dtMateriales As DataTable = ObtenerlistadoDeMaterial(filtroRapido)
                    Dim numMateriales As Integer = 0
                    If dtMateriales IsNot Nothing Then
                        .DataSource = dtMateriales
                        .DataTextField = "materialRegion"
                        .DataValueField = "material"
                        .DataBind()
                        Session("dtSubproductos") = dtMateriales
                        numMateriales = dtMateriales.Rows.Count
                    End If
                    lblMateriales.Text = numMateriales.ToString & " Registro(s) Encontrado(s)"
                Else
                    If .Items.Count > 0 Then .Items.Clear()
                    lblMateriales.Text = ""
                End If

                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un material", "0"))
                    'LimpiarDatosFiltrado("material")
                Else
                    Dim material As String
                    material = ddlMaterial.SelectedValue
                    'RefrescarDatosMaterial(material)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Materiales. " & ex.Message)
        Finally
            'RefrescarFormulario()
        End Try
    End Sub

    Protected Function ObtenerlistadoDeMaterial(Optional ByVal filtroRapido As String = "") As DataTable
        Dim miMaterial As New Productos.Subproducto
        Dim dtSubproductos As New DataTable
        Dim dtAux As New DataTable
        Dim strFiltro As String

        If filtroRapido.Trim.Length > 2 Then
            If filtroRapido.Trim.Length > 2 Then strFiltro = "materialRegion like '%" & filtroRapido & "%'"
            dtAux = Productos.Subproducto.ObtenerListado()
            Dim arrCampos As New ArrayList
            arrCampos.AddRange(Split("material|subproducto|materialRegion|tipoUnidad|idTipoUnidad", "|"))
            dtSubproductos = MetodosComunes.getDistinctsFromDataTable(dtAux, arrCampos, strFiltro, " material ASC")

            If ddlMaterial.Items.Count = 2 Then
                ddlMaterial.SelectedIndex = 1
                'RefrescarDatosMaterial(ddlMaterial.SelectedValue)
            End If
            Return dtSubproductos
        End If
    End Function

#End Region

#Region "Métodos"

    Private Sub CargaInicial()
        Try
            'Carga Ciudades
            'MetodosComunes.CargarDropDown(CType(HerramientasMensajeria.ObtenerCiudadesCem(), DataTable), CType(ddlCiudad, ListControl))

            'Carga los tipos de servicio
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaTipoServicio(), ddlTipoServicio)

            'Carga las clausulas
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaClausula(), ddlClausula)

            ddlMaterial.Items.Insert(0, New ListItem("Seleccione un material", "0"))

            'Cargar Prioridades
            Dim listaPrioridad As New PrioridadMensajeriaColeccion()
            With ddlPrioridad
                .DataSource = listaPrioridad.GenerarDataTable()
                .DataTextField = "prioridad"
                .DataValueField = "idPrioridad"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione una Prioridad", "0"))
            End With

        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar configuración. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria
        Try
            infoServicio = New ServicioMensajeria(idServicio)
            If infoServicio.Registrado Then
                With infoServicio
                    epNotificador.setTitle("Modificar Servicio: " & .NumeroRadicado.ToString)
                    ddlTipoServicio.SelectedValue = .IdTipoServicio
                    txtNoRadicado.Text = .NumeroRadicado.ToString
                    txtUsuarioEjecutor.Text = .UsuarioEjecutor
                    txtNombres.Text = .NombreCliente
                    txtIdentificacion.Text = .IdentificacionCliente
                    txtNombresAutorizado.Text = .PersonaContacto
                    ddlCiudad.SelectedValue = .IdCiudad
                    txtBarrio.Text = .Barrio
                    txtDireccion.Text = .Direccion
                    txtTelefono.Text = .TelefonoContacto
                    txtExtension.Text = .ExtensionContacto
                    dpFechaAsignacion.SelectedDate = .FechaAsignacion
                    chbClienteVIP.Checked = .ClienteVIP
                    txtPlanActual.Text = .PlanActual
                    txtObservacion.Text = .Observacion

                    If .TipoTelefono = "CEL" Then
                        rbTelefonoCelular.Checked = True
                        txtTelefono.Enabled = True
                        txtExtension.Enabled = False
                    ElseIf .TipoTelefono = "FIJO" Then
                        rbTelefonoFijo.Checked = True
                        txtTelefono.Enabled = True
                        txtExtension.Enabled = True
                    End If

                    If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                        _referenciasDataTable = .ReferenciasColeccion.GenerarDataTable()

                        Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                        _referenciasDataTable.PrimaryKey = pkMaterial

                        Session("referenciasDataTable") = _referenciasDataTable
                        gvReferencias.DataSource = _referenciasDataTable
                        gvReferencias.DataBind()
                        hfNumReferencias.Value = _referenciasDataTable.Rows.Count.ToString
                    End If

                    If .MinsColeccion IsNot Nothing AndAlso .MinsColeccion.Count > 0 Then
                        _minsDataTable = .MinsColeccion.GenerarDataTable()

                        Session("minsDataTable") = _minsDataTable
                        gvMINS.DataSource = _minsDataTable
                        gvMINS.DataBind()
                        hfNumMsisdn.Value = _minsDataTable.Rows.Count.ToString
                    End If

                    If .IdPrioridad > 0 Then ddlPrioridad.SelectedValue = .IdPrioridad

                    dpFechaVencimientoReserva.SelectedDate = .FechaVencimientoReserva
                    dpFechaVencimientoReserva.MinValidDate = Now
                    MetodosComunes.CargarDropDown(CType(HerramientasMensajeria.ObtenerCiudadesCem(0, , .IdBodega), DataTable), CType(ddlCiudad, ListControl))
                    Session("infoServicioMensajeria") = infoServicio

                    'Opción de anular solamente para el perfil configurado.
                    Dim arrControles() As String = {"lbAnular"}
                    For indice As Integer = 0 To arrControles.Length - 1
                        Dim ctrl As Control = Me.FindControl(arrControles(indice))
                        If ctrl IsNot Nothing Then
                            ctrl.Visible = EsVisibleOpcionRestringida(ctrl.ID, -1)
                            If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, .IdEstado)
                        End If
                    Next
                End With

                'Valida la edición del campo ciudad
                Dim bPuedeModificar As Boolean = PermiteCambioCiudad(infoServicio)
                ddlCiudad.Enabled = bPuedeModificar
                txtBarrio.Enabled = bPuedeModificar
                txtDireccion.Enabled = bPuedeModificar
                'Carga Ciudades


            Else
                epNotificador.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                pnlGeneral.Enabled = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarReferencias()
        Try
            If Session("referenciasDataTable") IsNot Nothing Then _referenciasDataTable = CType(Session("referenciasDataTable"), DataTable)
            'Carga las referencias
            With gvReferencias
                .DataSource = _referenciasDataTable
                .DataBind()
            End With
            If _referenciasDataTable IsNot Nothing Then
                hfNumReferencias.Value = _referenciasDataTable.Rows.Count.ToString()
            Else
                hfNumReferencias.Value = "0"
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de enlazar referencias. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarMines()
        Try
            If Session("minsDataTable") IsNot Nothing Then _minsDataTable = CType(Session("minsDataTable"), DataTable)
            'Carga los MINs
            gvMINS.DataSource = _minsDataTable
            gvMINS.DataBind()

            If _minsDataTable IsNot Nothing Then
                hfNumMsisdn.Value = _minsDataTable.Rows.Count.ToString
            Else
                hfNumMsisdn.Value = "o"
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de enlazar Mines. " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarRegistro(ByVal idServicio As Integer)
        Try
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            With objServicio
                .IdTipoServicio = ddlTipoServicio.SelectedValue
                Long.TryParse(txtNoRadicado.Text, .NumeroRadicado)
                .UsuarioEjecutor = txtUsuarioEjecutor.Text
                .NombreCliente = txtNombres.Text
                .IdentificacionCliente = txtIdentificacion.Text
                .PersonaContacto = txtNombresAutorizado.Text
                .IdCiudad = ddlCiudad.SelectedValue
                .Barrio = txtBarrio.Text
                .Direccion = txtDireccion.Text
                .TelefonoContacto = txtTelefono.Text
                .ExtensionContacto = txtExtension.Text
                .TipoTelefono = CStr(IIf(rbTelefonoCelular.Checked, "CEL", "FIJO"))
                Date.TryParse(dpFechaAsignacion.SelectedDate, .FechaAsignacion)
                .ClienteVIP = chbClienteVIP.Checked
                .PlanActual = txtPlanActual.Text
                .Observacion = txtObservacion.Text
                .FechaVencimientoReserva = dpFechaVencimientoReserva.SelectedDate
                .IdPrioridad = CInt(ddlPrioridad.SelectedValue)

                .ReferenciasDataTable = _referenciasDataTable
                .MinsDataTable = _minsDataTable

                Dim resultado As ResultadoProceso = .Actualizar(idUsuario)
                If resultado.Valor = 0 Then
                    epNotificador.showSuccess("Servicio actualizado correctamente.")
                Else
                    epNotificador.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
                End If
            End With

        Catch ex As Exception
            epNotificador.showError("Se genero un error al actualizar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub AnularRegistro(ByVal idServicio As Integer)
        Try
            Dim objServicio As New ServicioMensajeria(idServicio)
            Dim idUsuario As Integer = 1

            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString(), idUsuario)
            With objServicio
                Dim resultado As ResultadoProceso = .Anular(idUsuario)
                If resultado.Valor = 0 Then
                    epNotificador.showSuccess("Servicio anulado correctamente.")

                    HabilitarPaneles(False)
                Else
                    epNotificador.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Se genero un error al anular el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormularioReferencia()
        txtFiltroMaterial.Text = ""
        CargarListadoDeMateriales()
        txtCantidad.Text = ""
    End Sub

    Private Sub LimpiarFormularioMin()
        txtMsisdn.Text = ""
        txtNumeroReserva.Text = ""
        chbActivaEquipoAnterior.Checked = False
        chbComSeguro.Checked = False
        txtPrecioConIVA.Text = ""
        txtPrecioSinIVA.Text = ""
        ddlClausula.ClearSelection()
    End Sub

    Public Sub IniciarFormularioEdicionReferencia(ByVal material As String)
        Try
            _referenciasDataTable = CType(Session("referenciasDataTable"), DataTable)
            Dim drAux As DataRow = _referenciasDataTable.Rows.Find(material)
            If drAux IsNot Nothing Then
                pnlInfoGeneral.Enabled = False
                pnlBotonEdicionReferencia.Visible = True
                lbAgregarReferencia.Visible = False
                gvReferencias.Enabled = False
                LimpiarFormularioMin()
                pnlInfoMin.Enabled = False
                txtFiltroMaterial.Text = material
                CargarListadoDeMateriales(material)
                With ddlMaterial
                    If .SelectedValue = "0" Then .SelectedIndex = .Items.IndexOf(.Items.FindByValue(material))
                End With
                txtCantidad.Text = drAux("cantidad").ToString
                hfMaterialAct.Value = material
                lbFiltraMaterial.Enabled = False
                lbQuitaFiltromaterial.Enabled = False
                txtFiltroReferencia.Enabled = False
            Else
                epNotificador.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
        End Try
    End Sub

    Public Sub IniciarFormularioEdicionMin(ByVal idRegistro As String)
        Try
            _minsDataTable = CType(Session("minsDataTable"), DataTable)
            Dim drAux As DataRow = _minsDataTable.Select("idRegistro = " & idRegistro)(0)
            If drAux IsNot Nothing Then
                pnlInfoGeneral.Enabled = False
                pnlBotonEdicionMin.Visible = True
                lbAgregarMIN.Visible = False
                gvMINS.Enabled = False
                LimpiarFormularioReferencia()
                pnlInfoReferencia.Enabled = False

                txtMsisdn.Text = drAux("msisdn").ToString
                txtNumeroReserva.Text = drAux("numeroReserva").ToString()
                chbActivaEquipoAnterior.Checked = IIf(drAux("activaEquipoAnterior").ToString.ToUpper = "SI", True, False)
                chbComSeguro.Checked = IIf(drAux("comSeguro").ToString.ToUpper = "SI", True, False)
                txtPrecioConIVA.Text = drAux("precioConIVA").ToString.Split(",").GetValue(0)
                txtPrecioSinIVA.Text = drAux("precioSinIVA").ToString
                With ddlClausula
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(drAux("idClausula")))
                End With
                hfMsisdnAct.Value = idRegistro.ToString

                lbFiltrarMsisdn.Enabled = False
                lbLimpiarFiltroMsisdn.Enabled = False
                txtFiltroMsisdn.Enabled = False

            Else
                epNotificador.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
        End Try
    End Sub

    Public Sub FinalizarModoEdicionReferencia()
        Try
            pnlInfoGeneral.Enabled = True
            pnlBotonEdicionReferencia.Visible = False
            lbAgregarReferencia.Visible = True
            gvReferencias.Enabled = True
            pnlInfoMin.Enabled = True
            txtFiltroMaterial.Text = ""
            CargarListadoDeMateriales()
            txtCantidad.Text = ""
            hfMaterialAct.Value = ""
            txtFiltroReferencia.Enabled = True
            Dim sender As Object
            Dim e As System.EventArgs
            lbQuitaFiltromaterial_Click(sender, e)
            lbFiltraMaterial.Enabled = True
            lbQuitaFiltromaterial.Enabled = True
        Catch ex As Exception
            epNotificador.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
        End Try
    End Sub

    Public Sub FinalizarModoEdicionMin()
        Try
            pnlInfoGeneral.Enabled = True
            pnlBotonEdicionMin.Visible = False
            lbAgregarMIN.Visible = True
            gvMINS.Enabled = True
            pnlInfoReferencia.Enabled = True

            txtMsisdn.Text = ""
            txtNumeroReserva.Text = ""
            chbActivaEquipoAnterior.Checked = False
            chbComSeguro.Checked = False
            txtPrecioConIVA.Text = ""
            txtPrecioSinIVA.Text = ""
            ddlClausula.ClearSelection()
            hfMsisdnAct.Value = ""

            txtFiltroMsisdn.Enabled = True
            Dim sender As Object
            Dim e As System.EventArgs
            lbLimpiarFiltroMsisdn_Click(sender, e)
            lbFiltrarMsisdn.Enabled = True
            lbLimpiarFiltroMsisdn.Enabled = True

        Catch ex As Exception
            epNotificador.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
        End Try
    End Sub

    Private Sub CrearEstructuraDataTable()
        'Referencias
        With _referenciasDataTable
            .Columns.Add("material", GetType(String))
            .Columns.Add("referencia", GetType(String))
            .Columns.Add("cantidad", GetType(Integer))
            .AcceptChanges()
        End With
        Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
        _referenciasDataTable.PrimaryKey = pkMaterial

        'MINs
        With _minsDataTable
            'Dim dcAux As New DataColumn("idMsisdn")
            'With dcAux
            '    .AutoIncrement = True
            '    .AutoIncrementStep = 1
            'End With
            '.Columns.Add(dcAux)
            .Columns.Add("msisdn", GetType(Long))
            .Columns.Add("activaEquipoAnterior", GetType(Boolean))
            .Columns.Add("comSeguro", GetType(Boolean))
            .Columns.Add("precioConIVA", GetType(Long))
            .Columns.Add("precioSinIVA", GetType(Long))
            .Columns.Add("idClausula", GetType(Integer))
            .Columns.Add("clausula", GetType(String))
            .AcceptChanges()
        End With
        Dim pkMin() As DataColumn = {_minsDataTable.Columns("msisdn")}
        _minsDataTable.PrimaryKey = pkMin

    End Sub

    Private Sub CargarDatos()
        Try
            _idServicio = CInt(Session("idServicio"))

            If Session("referenciasDataTable") IsNot Nothing Then _referenciasDataTable = CType(Session("referenciasDataTable"), DataTable)
            If Session("minsDataTable") IsNot Nothing Then _minsDataTable = CType(Session("minsDataTable"), DataTable)

            'Carga las referencias
            gvReferencias.DataSource = _referenciasDataTable
            gvReferencias.DataBind()

            'Carga los MINs
            gvMINS.DataSource = _minsDataTable
            gvMINS.DataBind()

        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar configuración. " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarReferencia()
        Try
            If Not String.IsNullOrEmpty(ddlMaterial.SelectedValue) AndAlso ddlMaterial.SelectedValue <> "0" Then
                If _referenciasDataTable.Rows.Find(ddlMaterial.SelectedValue) Is Nothing Then
                    Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
                    Dim referenciaDetalle As New DetalleMaterialServicioMensajeria()

                    Dim idUsuario As Integer
                    If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

                    With referenciaDetalle
                        .IdServicio = infoServicio.IdServicioMensajeria
                        .IdTipoServicio = ServicioMensajeria.ObtieneIdServicioTipo(_idServicio)
                        .Material = CStr(ddlMaterial.SelectedValue)
                        .Cantidad = CInt(txtCantidad.Text)
                        .IdUsuarioRegistra = idUsuario

                        .Adicionar()
                    End With
                    ' Se verifica si se debe enviar notificación de disponibilidad
                    HerramientasMensajeria.VerificarDisponibilidadMaterial(infoServicio.IdServicioMensajeria, infoServicio.IdServicioTipo)
                    EnviarNotificacion(infoServicio.NumeroRadicado, CStr(ddlMaterial.SelectedValue))

                    Dim detalleMateriales As New DetalleMaterialServicioMensajeriaColeccion(infoServicio.IdServicioMensajeria)

                    If detalleMateriales.Count > 0 Then
                        _referenciasDataTable = detalleMateriales.GenerarDataTable()
                        Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                        _referenciasDataTable.PrimaryKey = pkMaterial

                        Session("referenciasDataTable") = _referenciasDataTable
                    Else
                        Session("referenciasDataTable") = Nothing
                    End If

                    CargarDatos()
                    hfNumReferencias.Value = _referenciasDataTable.Rows.Count.ToString
                Else
                    epNotificador.showError("El material que está intentando adicionar ya fue previamente adicionado. Por favor verifique")
                End If
            End If

        Catch ex As Exception
            epNotificador.showError("Error al tratar de Agregar Referencia. " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarReferencia()
        Dim material As String = hfMaterialAct.Value
        Dim drAux As DataRow
        Dim sender As Object
        Dim e As System.EventArgs
        Try
            drAux = _referenciasDataTable.Rows.Find(material)
            If drAux IsNot Nothing Then
                Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)

                If material.Trim <> ddlMaterial.SelectedValue.Trim Then
                    If _referenciasDataTable.Rows.Find(ddlMaterial.SelectedValue) IsNot Nothing Then
                        epNotificador.showError("El material que está intentando adicionar ya fue previamente adicionado. Debe modificar el registro inicial")
                        Exit Sub
                    End If
                End If

                Dim idUsuario As Integer = 1
                If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

                Dim materialColeccion As New DetalleMaterialServicioMensajeriaColeccion()
                materialColeccion.IdServicioMensajeria = _idServicio
                materialColeccion.Material = drAux("material").ToString()
                materialColeccion.CargarDatos()

                materialColeccion(0).Material = ddlMaterial.SelectedValue
                materialColeccion(0).Cantidad = CInt(txtCantidad.Text)
                materialColeccion(0).IdUsuarioRegistra = idUsuario
                materialColeccion(0).Modificar()

                ' Se verifica si se debe enviar notificación de disponibilidad
                HerramientasMensajeria.VerificarDisponibilidadMaterial(infoServicio.IdServicioMensajeria, infoServicio.IdServicioTipo)
                EnviarNotificacion(infoServicio.NumeroRadicado, CStr(ddlMaterial.SelectedValue))

                Dim detalleMateriales As New DetalleMaterialServicioMensajeriaColeccion(infoServicio.IdServicioMensajeria)
                If detalleMateriales.Count > 0 Then
                    _referenciasDataTable = detalleMateriales.GenerarDataTable()
                    Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                    _referenciasDataTable.PrimaryKey = pkMaterial

                    Session("referenciasDataTable") = _referenciasDataTable
                Else
                    Session("referenciasDataTable") = Nothing
                End If

                EnlazarReferencias()
                FinalizarModoEdicionReferencia()
                lbFiltraMaterial.Enabled = True
                lbQuitaFiltromaterial.Enabled = True
                txtFiltroReferencia.Enabled = True
                lbQuitaFiltromaterial_Click(sender, e)
                epNotificador.showSuccess("La referencia fue actualizada satisfactoriamente.")
            Else
                epNotificador.showError("Imposible encontrar el registro asignado al material. Por favor intente nuevamente")
                lbFiltraMaterial.Enabled = True
                lbQuitaFiltromaterial.Enabled = True
                txtFiltroReferencia.Enabled = True
                lbQuitaFiltromaterial_Click(sender, e)
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de actualizar referencia. " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarReferencia(ByVal material As String)
        Try
            Dim materialColeccion As New DetalleMaterialServicioMensajeriaColeccion()
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then idUsuario = CInt(Session("usxp001"))
            materialColeccion.IdServicioMensajeria = _idServicio
            materialColeccion.Material = material
            materialColeccion.CargarDatos()
            materialColeccion(0).Eliminar(idUsuario)

            Dim infoServicio As ServicioMensajeria = New ServicioMensajeria(_idServicio)
            With infoServicio
                If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                    _referenciasDataTable = .ReferenciasColeccion.GenerarDataTable()

                    Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                    _referenciasDataTable.PrimaryKey = pkMaterial

                    Session("referenciasDataTable") = _referenciasDataTable
                Else
                    _referenciasDataTable = Nothing
                    Session("referenciasDataTable") = _referenciasDataTable
                End If
            End With
            EnlazarReferencias()
            If _referenciasDataTable IsNot Nothing Then
                FinalizarModoEdicionReferencia()
            End If
            epNotificador.showSuccess("La referencia fué eliminada satisfactoriamente.")

        Catch ex As Exception
            epNotificador.showError("Error al tratar de eliminar material. " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarMINs()
        Try
            If Not RegistroMinExiste(_minsDataTable.Select("msisdn=" & txtMsisdn.Text.Trim)) Then

                Dim referenciaDetalle As New DetalleMsisdnEnServicioMensajeria()
                With referenciaDetalle
                    .IdTipoServicio = ServicioMensajeria.ObtieneIdServicioTipo(_idServicio)
                    .MSISDN = CLng(txtMsisdn.Text)
                    If txtNumeroReserva.Text.Trim = "" Then
                        .NumeroReserva = 0
                    Else
                        .NumeroReserva = txtNumeroReserva.Text.Trim
                    End If
                    .ActivaEquipoAnterior = chbActivaEquipoAnterior.Checked
                    .Comseguro = chbComSeguro.Checked
                    .PrecioConIva = CLng(txtPrecioConIVA.Text)
                    .PrecioSinIva = CLng(txtPrecioSinIVA.Text)
                    .IdClausula = CInt(ddlClausula.SelectedValue)

                    .Adicionar()
                End With

                Dim infoServicio As ServicioMensajeria = New ServicioMensajeria(_idServicio)
                With infoServicio
                    If .MinsColeccion IsNot Nothing AndAlso .MinsColeccion.Count > 0 Then
                        _minsDataTable = .MinsColeccion.GenerarDataTable()

                        Session("minsDataTable") = _minsDataTable
                    End If
                End With
                CargarDatos()
                hfNumMsisdn.Value = _minsDataTable.Rows.Count.ToString()
            Else
                epNotificador.showError("El MSISDN que está intentando adicionar ya fue previamente adicionado. Por favor verifique")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de Agregar MINs. " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarMINs()
        Dim msisdn As String = hfMsisdnAct.Value
        Dim drAux As DataRow
        Dim sender As Object
        Dim e As System.EventArgs

        Try
            drAux = _minsDataTable.Select("idRegistro = " & msisdn)(0)
            If drAux IsNot Nothing Then
                Dim drMin() As DataRow = _minsDataTable.Select("msisdn=" & txtMsisdn.Text.Trim)
                If drMin IsNot Nothing AndAlso drMin.Length >= 2 Then
                    epNotificador.showError("El MSISDN que está intentando adicionar ya superó el número de registros permitidos: 2 Registros. Por favor verifique")
                    Exit Sub
                ElseIf drMin IsNot Nothing AndAlso RegistroMinExiste(drMin) Then
                    epNotificador.showError("El registro que está tratando de ingresar ya existe. Por favor verifique")
                End If

                Dim minColeccion As New DetalleMsisdnEnServicioMensajeriaColeccion()
                minColeccion.IdServicioMensajeria = _idServicio
                minColeccion.Msisdn = drAux("msisdn").ToString()
                minColeccion.CargarDatos()



                With minColeccion(0)
                    .MSISDN = CLng(txtMsisdn.Text)
                    .NumeroReserva = txtNumeroReserva.Text
                    .ActivaEquipoAnterior = chbActivaEquipoAnterior.Checked
                    .Comseguro = chbComSeguro.Checked
                    .PrecioConIva = CLng(txtPrecioConIVA.Text)
                    .PrecioSinIva = CLng(txtPrecioSinIVA.Text)
                    .IdClausula = CInt(ddlClausula.SelectedValue)
                    .Modificar()
                End With

                Dim infoServicio As ServicioMensajeria = New ServicioMensajeria(_idServicio)
                With infoServicio
                    If .MinsColeccion IsNot Nothing AndAlso .MinsColeccion.Count > 0 Then
                        _minsDataTable = .MinsColeccion.GenerarDataTable()

                        Dim pkMin() As DataColumn = {_minsDataTable.Columns("msisdn")}
                        _minsDataTable.PrimaryKey = pkMin

                        Session("minsDataTable") = _minsDataTable
                    End If
                End With

                EnlazarMines()
                FinalizarModoEdicionMin()

                lbFiltrarMsisdn.Enabled = True
                lbLimpiarFiltroMsisdn.Enabled = True
                txtFiltroMsisdn.Enabled = True
                lbLimpiarFiltroMsisdn_Click(sender, e)

                lblMensajeFiltroMsisdn.Visible = False

                epNotificador.showSuccess("El Msisdn fue actualizado satisfactoriamente.")
            Else

                lbFiltrarMsisdn.Enabled = True
                lbLimpiarFiltroMsisdn.Enabled = True
                txtFiltroMsisdn.Enabled = True
                lbLimpiarFiltroMsisdn_Click(sender, e)

                epNotificador.showError("Imposible encontrar el registro asignado al Msisdn. Por favor intente nuevamente")
                lblMensajeFiltroMsisdn.Visible = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de actualizar Msisdn. " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarMIN(ByVal idRegistro As String)
        Try
            Dim minColeccion As New DetalleMsisdnEnServicioMensajeriaColeccion()
            minColeccion.IdServicioMensajeria = _idServicio
            minColeccion.IdRegistro = idRegistro
            minColeccion.CargarDatos()
            minColeccion(0).Eliminar()

            Dim infoServicio As ServicioMensajeria = New ServicioMensajeria(_idServicio)
            With infoServicio
                If .MinsColeccion IsNot Nothing AndAlso .MinsColeccion.Count > 0 Then
                    _minsDataTable = .MinsColeccion.GenerarDataTable()

                    Session("minsDataTable") = _minsDataTable
                Else
                    _minsDataTable = Nothing
                    Session("minsDataTable") = _minsDataTable
                End If
            End With
            EnlazarMines()
            If _minsDataTable IsNot Nothing Then
                FinalizarModoEdicionMin()
            End If
            epNotificador.showSuccess("El MIN fue eliminado satisfactoriamente de la lista.")

        Catch ex As Exception
            epNotificador.showError("Error al tratar de eliminar material. " & ex.Message)
        End Try
    End Sub

    Private Sub HabilitarPaneles(ByVal estado As Boolean)
        pnlGeneral.Enabled = estado
        pnlInfoReferencia.Enabled = estado
        pnlInfoMin.Enabled = estado
    End Sub

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

    Private Sub EnviarNotificacion(ByVal listNuemeroRadicado As String, ByVal material As String)
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ObtenerDisponibilidadInventarioParaNotificacion(listNuemeroRadicado)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.RowFilter = "fechaReporteSinDisponibilidad  IS NOT NULL AND material ='" & material & "'"
        Dim dtAux As DataTable = dvDatos.ToTable()

        If dtAux.Rows.Count > 0 Then
            Dim notificador As New NotificacionEventosInventarioCEM
            Dim mensajeInicio As New ConfigValues("MENSAJE_INICIO_CEM")
            Dim mensajeFin As New ConfigValues("MENSAJE_FIN_CEM")
            Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")
            Dim usuarioRespuesta As New ConfigValues("USUARIO_RESPUESTA_CEM")
            Dim arrUsuarioRespuesta As String() = usuarioRespuesta.ConfigKeyValue.Split(",")
            Dim dvAux As DataView = dtDatos.DefaultView
            dvAux.RowFilter = "fechaReporteSinDisponibilidad  IS NOT NULL"
            Dim dtDatosAux As DataTable = dvAux.ToTable()
            Dim Fila As DataRow() = dtDatos.Select("numeroRadicado IN (" & listNuemeroRadicado & ")")
            Dim tipoServicio As String = CStr(Fila(0).Item("tipoServicio"))
            Dim idBodega As String = CInt(Fila(0).Item("idbodega"))
            Dim mensaje As String
            Dim mensajeDetalle As String

            mensaje = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Radicado</td><td><b>Material</td><td><b>Referencia</td><td><b>Cantidad</td><td><b>Bodega</td></tr>"
            For Each drAux As DataRow In dtDatosAux.Rows
                mensaje += "<tr><td>" & drAux("numeroRadicado").ToString & "</td><td>" & drAux("material").ToString & "</td><td>" & drAux("descripcion").ToString & _
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
                .Asunto = "Modificación de radicados para " & tipoServicio & ", sin disponibilidad de Inventario"
                .MailRespuesta = arrUsuarioRespuesta(0)
                .UsuarioRespuesta = arrUsuarioRespuesta(1)
                .NotificacionEvento(mensaje, mensajeDetalle, idBodega)
            End With
        End If

    End Sub

#End Region

#Region "Funciones"

    Public Function RegistroMinExiste(ByVal drMinActual() As DataRow) As Boolean
        If drMinActual.Length > 0 Then
            Dim drAux As DataRow = drMinActual(0)
            Dim activaEquipo As Boolean = IIf(drAux("activaEquipoAnterior").ToString.ToUpper = "SI", True, False)
            Dim comseguro As Boolean = IIf(drAux("comSeguro").ToString.ToUpper = "SI", True, False)
            If drAux("msisdn") = CLng(txtMsisdn.Text) AndAlso activaEquipo = chbActivaEquipoAnterior.Checked _
                AndAlso comseguro = chbComSeguro.Checked AndAlso drAux("precioConIVA") = CLng(txtPrecioConIVA.Text) _
                AndAlso drAux("precioSinIVA") = CLng(txtPrecioSinIVA.Text) AndAlso drAux("idClausula") = CInt(ddlClausula.SelectedValue) Then

                Return True
            Else
                Return False
            End If
        Else
            Return False
        End If
    End Function

    Private Function PermiteCambioCiudad(ByVal objServicio As ServicioMensajeria) As Boolean
        Dim bReturn As Boolean = False

        If EsVisibleOpcionRestringida("objCiudad", -1) And (objServicio.IdEstado = Enumerados.EstadoServicio.Creado And _
            objServicio.IdTipoServicio = Enumerados.TipoServicio.Reposicion) Then

            Dim objSeriales As New DetalleSerialServicioMensajeriaColeccion(objServicio.IdServicioMensajeria)
            If objSeriales.Count > 0 Then
                MetodosComunes.CargarDropDown(CType(HerramientasMensajeria.ObtenerCiudadesCem(idBodega:=objServicio.IdBodega), DataTable), CType(ddlCiudad, ListControl))
                ddlCiudad.SelectedValue = objServicio.IdCiudad
            End If
            bReturn = True
        End If
        Return bReturn
    End Function

#End Region

    Private Sub lbFiltraMaterial_Click(sender As Object, e As System.EventArgs) Handles lbFiltraMaterial.Click

        _referenciasDataTable.DefaultView.RowFilter = "Material = '" & txtFiltroReferencia.Text.Trim & "'"

        If _referenciasDataTable.DefaultView.Count > 0 Then
            gvReferencias.DataSource = _referenciasDataTable.DefaultView
            gvReferencias.DataBind()
            lblfiltroMensajeMaterial.Visible = False
        Else
            lblfiltroMensajeMaterial.Visible = True
            _referenciasDataTable.DefaultView.RowFilter = ""
        End If

    End Sub

    Private Sub lbQuitaFiltromaterial_Click(sender As Object, e As System.EventArgs) Handles lbQuitaFiltromaterial.Click
        txtFiltroReferencia.Text = ""
        lblfiltroMensajeMaterial.Visible = False
        _referenciasDataTable.DefaultView.RowFilter = ""
        gvReferencias.DataSource = _referenciasDataTable
        gvReferencias.DataBind()
    End Sub

    Private Sub lbFiltrarMsisdn_Click(sender As Object, e As System.EventArgs) Handles lbFiltrarMsisdn.Click

        _minsDataTable.DefaultView.RowFilter = "MSISDN = '" & txtFiltroMsisdn.Text.Trim & "'"

        If _minsDataTable.DefaultView.Count > 0 Then
            gvMINS.DataSource = _minsDataTable.DefaultView
            gvMINS.DataBind()
            lblMensajeFiltroMsisdn.Visible = False
        Else
            lblMensajeFiltroMsisdn.Visible = True
            _minsDataTable.DefaultView.RowFilter = ""
        End If

    End Sub

    Private Sub lbLimpiarFiltroMsisdn_Click(sender As Object, e As System.EventArgs) Handles lbLimpiarFiltroMsisdn.Click

        txtFiltroMsisdn.Text = ""
        lblMensajeFiltroMsisdn.Visible = False
        _minsDataTable.DefaultView.RowFilter = ""
        gvMINS.DataSource = _minsDataTable
        gvMINS.DataBind()

    End Sub
#Region "Eventos Cargue de Archivo"

    Private Sub btnSubir_Click(sender As Object, e As System.EventArgs) Handles btnSubir.Click
        epNotificador.clear()
        gvErrores.Visible = False
        gvDetalleArchivo.Visible = False
        lblRegistrosCargados.Text = ""
        CargarArchivo()
    End Sub
    Private Sub CargarArchivo()

        Dim nombreArchivoProceso As String
        Dim NombreValido As Boolean = False

        Try
            If fuArchivoAdjuntarEO.PostedFiles.Length > 0 Then
                Dim objCargueArchivo As New CargueArchivosCEM
                With objCargueArchivo
                    Dim nombreArchivo As String = Path.GetFileNameWithoutExtension(fuArchivoAdjuntarEO.PostedFiles(0).ClientFileName) & Path.GetExtension(fuArchivoAdjuntarEO.PostedFiles(0).ClientFileName)
                    Dim ExpReg As New System.Text.RegularExpressions.Regex("^[a-zA-Z0-9-_ ]+$")
                    NombreValido = (ExpReg.IsMatch(nombreArchivo.Split(".").GetValue(0)))
                    If NombreValido Then
                        nombreArchivoProceso = Server.MapPath("Archivos\") & nombreArchivo
                        System.IO.File.Delete(nombreArchivoProceso)
                        System.IO.File.Move(fuArchivoAdjuntarEO.PostedFiles(0).TempFileName, Server.MapPath("Archivos\") & nombreArchivo)
                        Dim dtDatos As DataTable = EstructuraTabla()
                        EstablecerLicenciaGembox()
                        Dim oExcel As New ExcelFile
                        Dim wsData As ExcelWorksheet
                        Dim fileExtension As String = Path.GetExtension(nombreArchivo)
                        If fileExtension.ToUpper = ".XLS" Then
                            oExcel.LoadXls(nombreArchivoProceso)
                        ElseIf fileExtension.ToUpper = ".XLSX" Then
                            oExcel.LoadXlsx(nombreArchivoProceso, XlsxOptions.None)
                        End If
                        wsData = oExcel.Worksheets(0)
                        ValidarArchivo(wsData, dtDatos)

                        If Not dtError Is Nothing AndAlso dtError.Rows.Count > 0 Then
                            With gvErrores
                                .DataSource = dtError
                                .DataBind()
                            End With
                            gvErrores.Visible = True
                            lblRegistrosCargados.Text = "Registros Cargados: 0"
                        Else
                            gvErrores.Visible = False
                            pnlInfoReferencia.Enabled = False
                            pnlInfoMin.Enabled = False
                            With gvDetalleArchivo
                                .DataSource = dtDatos
                                .DataBind()
                            End With
                            Session("dtDetalleArchivo") = dtDatos
                            hfDetalleArchivo.Value = dtDatos.Rows.Count.ToString
                            lblRegistrosCargados.Text = "Registros Cargados: " & CInt(dtDatos.Rows.Count.ToString)
                            gvDetalleArchivo.Visible = True
                        End If
                        fuArchivoAdjuntarEO.ClearPostedFiles()
                    Else
                        epNotificador.showError("Nombre de archivo no valido para procesar")
                        fuArchivoAdjuntarEO.ClearPostedFiles()
                        Exit Sub
                    End If
                End With
            Else
                epNotificador.showError("Seleccione el archivo a procesar")
                fuArchivoAdjuntarEO.ClearPostedFiles()
            End If

        Catch ex As Exception
            epNotificador.showError("Se generó error procesando archivo: " + ex.Message)
        Finally
            If File.Exists(nombreArchivoProceso) Then File.Delete(nombreArchivoProceso)
        End Try

    End Sub
    Private Function EstructuraTablaError()
        Try
            Dim dt As New DataTable
            With dt.Columns
                .Add(New DataColumn("id", GetType(Integer)))
                .Add(New DataColumn("nombre", GetType(String)))
                .Add(New DataColumn("descripcion", GetType(String)))
            End With
            dt.AcceptChanges()
            Return dt
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Function EstructuraTabla()
        Try
            Dim dt As New DataTable
            With dt.Columns
                .Add(New DataColumn("min", GetType(String)))
                .Add(New DataColumn("clausula", GetType(Integer)))
                .Add(New DataColumn("material", GetType(String)))
                .Add(New DataColumn("referencia", GetType(String)))
                .Add(New DataColumn("envioSim", GetType(String)))
                .Add(New DataColumn("materialSim", GetType(String)))
                .Add(New DataColumn("zonaSim", GetType(String)))
                .Add(New DataColumn("activaEquipo", GetType(String)))
                .Add(New DataColumn("comseguro", GetType(String)))
                .Add(New DataColumn("precioEquipoSinIva", GetType(Integer)))
                .Add(New DataColumn("precioEquipoConIva", GetType(Integer)))
                .Add(New DataColumn("precioSimCardSinIva", GetType(Integer)))
                .Add(New DataColumn("precioSimCardConIva", GetType(Integer)))
            End With
            dt.AcceptChanges()
            Return dt
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Private Sub EstablecerLicenciaGembox()
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
    End Sub
    Private Sub ValidarArchivo(ByVal ws As ExcelWorksheet, ByVal dtDatos As DataTable)
        Dim index As Integer = 1
        Dim errorColumnas As Boolean = False
        Dim indexFila As Integer = 0
        Try
            For Each fila As ExcelRow In ws.Rows
                If fila.AllocatedCells.Count <> dtDatos.Columns.Count Then
                    If fila.Cells(1).Value IsNot Nothing Then
                        AdicionarError(index, "Fila inválida", "El Número de columnas es inválido.")
                        errorColumnas = True
                        Exit For
                    End If
                Else
                    Dim indexColumna As Integer = 0
                    Dim drAux As DataRow
                    drAux = dtDatos.NewRow
                    For Each columna As ExcelCell In fila.AllocatedCells
                        If indexFila > 0 Then
                            If fila.AllocatedCells(indexColumna).Value IsNot Nothing Then
                                drAux(indexColumna) = fila.AllocatedCells(indexColumna).Value
                                indexColumna += 1
                            Else
                                indexColumna += 1
                            End If
                        Else
                            Exit For
                        End If
                    Next
                    If drAux IsNot Nothing And drAux(0) IsNot System.DBNull.Value Then
                        Dim numMin As String = drAux(0).ToString.Trim
                        Dim minExiste As Boolean = False
                        For x As Integer = 0 To dtDatos.Rows.Count - 1
                            If dtDatos.Rows(x).Item("min") = numMin Then
                                If dtError Is Nothing Then
                                    dtError = EstructuraTablaError()
                                End If
                                AdicionarError(dtError.Rows.Count + 1, "Min Repetido", "El MIN " & numMin & " se encuentra repetido.")
                                minExiste = True
                            Else
                                minExiste = False
                            End If
                        Next
                        If Not minExiste Then
                            dtDatos.Rows.Add(drAux)
                        End If
                    End If
                    indexFila = indexFila + 1
                End If
            Next
            If Not errorColumnas Then
                If dtDatos.Rows.Count = 0 Then
                    If dtError Is Nothing Then
                        dtError = EstructuraTablaError()
                    End If
                    AdicionarError(dtError.Rows.Count + 1, "Archivo Sin Datos", "El archivo no tiene datos para procesar.")
                    errorColumnas = True
                End If
            End If

            If Not errorColumnas Then
                validarDatos(dtDatos)
            End If
        Catch ex As Exception
            Throw New Exception("Se generó un error en la validación del archivo, por favor elimine las filas y columnas vacías e intente nuevamente.")
        End Try
    End Sub
    Private Sub validarDatos(ByVal dtDatos As DataTable)
        Dim hayError As Boolean = False
        Dim i As Integer = 0

        If dtError Is Nothing Then
            dtError = EstructuraTablaError()
        End If

        Dim dtMaterial As DataTable = HerramientasMensajeria.ObtenerMateriales()
        Dim dtClausula As DataTable = HerramientasMensajeria.ConsultaClausula()
        Dim dtRegion As DataTable = HerramientasMensajeria.ConsultaRegion()

        For i = 0 To dtDatos.Rows.Count - 1
            If dtDatos.Rows(i).Item("min").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo MIN no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("min").ToString.Trim.Length <> 10 Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El MIN debe ser de 10 caracteres.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("clausula").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo CLAUSULA no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("envioSim").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo ENVIO SIM CARD no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("activaEquipo").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo ACTIVA EQUIPO ANTERIOR no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("comseguro").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo COMSEGURO no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then
                If dtDatos.Rows(i).Item("material").ToString.Trim = "" Or dtDatos.Rows(i).Item("materialSim").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioEquipoSinIva").ToString.Trim = "" Or _
                   dtDatos.Rows(i).Item("precioEquipoConIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardSinIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardConIva").ToString.Trim = "" Then
                    AdicionarError(dtError.Rows.Count + 1, "Campos inválidos", "los campos relacionados con equipo y SimCard no pueden estar vacios.")
                    hayError = True
                End If
            End If
            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "NO" Then
                If dtDatos.Rows(i).Item("material").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioEquipoSinIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioEquipoConIva").ToString.Trim = "" Then
                    AdicionarError(dtError.Rows.Count + 1, "Campos inválidos", "los campos relacionados con el equipo no pueden estar vacios.")
                    hayError = True
                End If
            End If
            If dtDatos.Rows(i).Item("material").ToString.Trim = "" And dtDatos.Rows(i).Item("referencia").ToString.Trim = "" And dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then
                If dtDatos.Rows(i).Item("materialSim").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardSinIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardConIva").ToString.Trim = "" Then
                    AdicionarError(dtError.Rows.Count + 1, "Campos inválidos", "los campos relacionados con la SimCard no pueden estar vacios.")
                    hayError = True
                End If
            End If

            Dim drSelect() As DataRow
            If dtDatos.Rows(i).Item("material").ToString.Trim <> "" Then
                drSelect = dtMaterial.Select("material = '" & dtDatos.Rows(i).Item("material").ToString.Trim & "'")
                If drSelect.Length = 0 Or drSelect Is Nothing Then
                    AdicionarError(dtError.Rows.Count + 1, "Material Equipo no existe", "El material del equipo no existe en el sistema.")
                Else
                    If drSelect(0).Item("idtipoproducto") = 2 Then
                        AdicionarError(dtError.Rows.Count + 1, "Material Equipo inválido", "El material del equipo corresponde a una SimCard.")
                    End If
                End If
            End If

            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then

                drSelect = Nothing
                If dtDatos.Rows(i).Item("materialSim").ToString.Trim <> "" Then
                    drSelect = dtMaterial.Select("material = '" & dtDatos.Rows(i).Item("materialSim").ToString.Trim & "'")
                    If drSelect.Length = 0 Or drSelect Is Nothing Then
                        AdicionarError(dtError.Rows.Count + 1, "Material Simcard no existe", "El material de la Simcard no existe en el sistema.")
                    Else
                        If drSelect(0).Item("idtipoproducto") = 1 Then
                            AdicionarError(dtError.Rows.Count + 1, "Material Simcard inválido", "El Material de la Simcard corresponde a una equipo.")
                        End If
                    End If
                End If
            End If

            If dtDatos.Rows(i).Item("min").ToString.Trim Then
                Dim dtMines As DataTable
                dtMines = HerramientasMensajeria.ObtenerMinesMensajeria()
                drSelect = Nothing
                drSelect = dtMines.Select("msisdn = '" & dtDatos.Rows(i).Item("min").ToString.Trim & "'")
                If drSelect.Length > 0 Then
                    AdicionarError(dtError.Rows.Count + 1, "Min inválido", "El min " & dtDatos.Rows(i).Item("min") & " ya se encuentra registrado en el sistema.")
                End If
            End If

            Dim dr() As DataRow
            dr = dtClausula.Select("idClausula = " & dtDatos.Rows(i).Item("clausula").ToString.Trim)
            If dr.Length = 0 Then
                AdicionarError(dtError.Rows.Count + 1, "Clausula inválida", "el identificador de la clausula " & dtDatos.Rows(i).Item("clausula") & " no existe en el sistema.")
            End If

            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then
                Dim drRegion() As DataRow
                drRegion = dtRegion.Select("nombreRegion like '%" & dtDatos.Rows(i).Item("zonaSim").ToString.Trim & "%'")
                If drRegion.Length = 0 Then
                    AdicionarError(dtError.Rows.Count + 1, "Región inválida", "La región " & dtDatos.Rows(i).Item("zonaSim") & " no existe en el sistema.")
                End If
            End If
        Next
    End Sub

    Private Sub AdicionarError(ByVal id As Integer, ByVal nombre As String, ByVal descripcion As String)
        Try
            If dtError Is Nothing Then
                dtError = EstructuraTablaError()
            End If
            With dtError
                Dim drError As DataRow = .NewRow()
                With drError
                    .Item("id") = id
                    .Item("nombre") = nombre
                    .Item("descripcion") = descripcion
                End With
                .Rows.Add(drError)
                .AcceptChanges()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region
End Class