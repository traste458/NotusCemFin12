Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class EditarCargueServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer
    Private Idservicio As Integer

    Private _minsDataTable As New DataTable
    Private _referenciasDataTable As New DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        ObtenerTamanoVentana()
        If Not IsPostBack Then
            Idservicio = Request.QueryString("Idservicio")
            miEncabezado.setTitle("Editar Servicios Cargados ")
            dpFechaVencimientoReserva.VisibleDate = Now
            dpFechaVencimientoReserva.MinValidDate = Now
            CargaInicial()
            pnlBotonEdicionReferencia.Visible = False
            pnlBotonEdicionMin.Visible = False
            txtFiltroMaterial.Focus()
        Else
            EnlazarMines()
        End If
    End Sub

    Protected Sub lbAgregarReferencia_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAgregarReferencia.Click
        AgregarReferencia()
    End Sub

    Protected Sub lbAgregarMIN_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAgregarMIN.Click
        AgregarMINs()
    End Sub

    Private Sub gvReferencias_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvReferencias.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarMaterial(e.CommandArgument.ToString())
            Case "editar"
                IniciarFormularioEdicionReferencia(e.CommandArgument.ToString)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvMINS_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvMINS.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarMin(CInt(e.CommandArgument))
            Case "editar"
                IniciarFormularioEdicionMin(CInt(e.CommandArgument))
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Protected Sub lbActualizarRef_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarRef.Click
        Dim dtReferencia As DataTable = CType(Session("referenciasDataTable"), DataTable)
        Dim material As String = hfMaterialAct.Value
        Dim drAux As DataRow
        Try
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()
            drAux = dtReferencia.Rows.Find(material)
            If drAux IsNot Nothing Then
                If material.Trim <> ddlMaterial.SelectedValue.Trim Then
                    If dtReferencia.Rows.Find(ddlMaterial.SelectedValue) IsNot Nothing Then
                        miEncabezado.showError("El material que está intentando adicionar ya fue previamente adicionado. Debe modificar el registro inicial")
                        Exit Sub
                    End If
                End If
                drAux("material") = ddlMaterial.SelectedValue
                drAux("referencia") = ddlMaterial.SelectedItem.Text
                drAux("cantidad") = txtCantidad.Text
                drAux.AcceptChanges()
                dtReferencia.AcceptChanges()
                Session("referenciasDataTable") = dtReferencia
                EnlazarReferencias()
                FinalizarModoEdicionReferencia()
                miEncabezado.showSuccess("La referencia fue actualizada satisfactoriamente.")
            Else
                miEncabezado.showError("Imposible encontrar el registro asignado al material. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de actualizar referencia. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbCancelarActRef_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCancelarActRef.Click
        FinalizarModoEdicionReferencia()
    End Sub

    Protected Sub lbCancelarActMin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCancelarActMin.Click
        FinalizarModoEdicionMin()
    End Sub

    Protected Sub lbActualizarMin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarMin.Click
        Dim dtMsisdn As DataTable = CType(Session("minsDataTable"), DataTable)
        Dim idMsisdn As Integer = CInt(hfMsisdnAct.Value)
        Dim drAux As DataRow
        Try
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            drAux = dtMsisdn.Rows.Find(idMsisdn)
            If drAux IsNot Nothing Then
                Dim drMin() As DataRow = dtMsisdn.Select("msisdn=" & txtMsisdn.Text.Trim)
                If drMin IsNot Nothing AndAlso drMin.Length >= 2 Then
                    miEncabezado.showError("El MSISDN que está intentando adicionar ya superó el número de registros permitidos: 2 Registros. Por favor verifique")
                    Exit Sub
                ElseIf drMin IsNot Nothing AndAlso RegistroMinExiste(drMin) Then
                    miEncabezado.showError("El registro que está tratando de ingresar ya existe. Por favor verifique")
                End If

                drAux("msisdn") = CLng(txtMsisdn.Text)
                drAux("activaEquipoAnterior") = chbActivaEquipoAnterior.Checked
                drAux("comSeguro") = chbComSeguro.Checked
                drAux("precioConIVA") = CLng(txtPrecioConIVA.Text)
                drAux("precioSinIVA") = CLng(txtPrecioSinIVA.Text)
                drAux("idClausula") = CInt(ddlClausula.SelectedValue)
                drAux("clausula") = ddlClausula.SelectedItem.Text
                drAux.AcceptChanges()
                dtMsisdn.AcceptChanges()

                Session("minsDataTable") = dtMsisdn
                EnlazarMines()
                FinalizarModoEdicionMin()

                miEncabezado.showSuccess("El Msisdn fue actualizado satisfactoriamente.")
            Else
                miEncabezado.showError("Imposible encontrar el registro asignado al Msisdn. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de actualizar Msisdn. " & ex.Message)
        End Try
    End Sub

    Private Sub lbGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbGuardar.Click
        RegistrarServicio()
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
        If Not String.IsNullOrEmpty(filtroRapido.Trim) Then
            Dim dtMaterial As DataTable = ObtenerListaMateriales(filtroRapido)
            With ddlMaterial
                .DataSource = dtMaterial
                .DataTextField = "referenciaCompuesta"
                .DataValueField = "material"
                .DataBind()
            End With
        Else
            ddlMaterial.Items.Clear()
        End If
        With ddlMaterial
            lblMateriales.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un Material", "0"))
        End With
    End Sub

    Private Function ObtenerListaMateriales(ByVal filtro As String) As DataTable
        Dim listaMaterial As New Productos.MaterialColeccion
        Dim dtMaterial As DataTable
        With listaMaterial
            .FiltroRapido = filtro
            dtMaterial = .GenerarDataTable()
        End With
        Dim dcAux As New DataColumn("referenciaCompuesta")
        dcAux.Expression = "material + ' - '+ referencia"
        dtMaterial.Columns.Add(dcAux)
        Return dtMaterial
    End Function

#End Region

#Region "Métodos"

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me.altoVentana = CInt(arrAux(0))
                Me.anchoVentana = CInt(arrAux(1))
            End If
        End If
    End Sub
    Private Sub Cargainicial()
        Dim infoServicio As MensajeriaEspecializada.CargueServicioMensajeria
        Try
            infoServicio = New MensajeriaEspecializada.CargueServicioMensajeria(Idservicio)
            If infoServicio.Registrado Then
                With infoServicio
                    txtTipoServicio.Text = .TipoServicio.ToString
                    txtNoRadicado.Text = .NumeroRadicado.ToString
                    txtUsuarioEjecutor.Text = .UsuarioEjecutor
                    txtNombres.Text = .NombreCliente
                    txtIdentificacion.Text = .IdenticacionCliente
                    txtNombresAutorizado.Text = .PersonaContacto
                    txtCiudad.Text = .ciudad
                    If .barrio.tostring.trim <> "" Then
                        txtBarrio.Text = .Barrio
                    Else
                        txtBarrio.Enabled = True
                    End If
                    txtDireccion.Text = .Direccion
                    txtTelefono.Text = .TelefonoContacto
                    txtExtension.Text = .ExtensionContacto
                    txtFechaAsignacion.Text = .FechaAsignacion
                    chbClienteVIP.Checked = .ClienteVIP
                    txtPlanActual.Text = .PlanActual
                    txtObservacion.Text = .Observacion

                    If .TipoTelefono = "CEL" Then
                        rbTelefonoCelular.Checked = True
                    ElseIf .TipoTelefono = "FIJO" Then
                        rbTelefonoFijo.Checked = True
                    End If
                    If .IdPrioridad > 0 Then txtPrioridad.Text = .Prioridad
                    Session("infoServicioMensajeria") = infoServicio
                    '------------------------------------------------------------------
                    _minsDataTable = infoServicio.MinsColeccion.GenerarDataTable

                    Dim pkMsisdn() As DataColumn = {_minsDataTable.Columns("idMsisdn")}
                    _minsDataTable.PrimaryKey = pkMsisdn

                    Session("minsDataTable") = _minsDataTable
                    gvMINS.DataSource = _minsDataTable
                    gvMINS.DataBind()
                    hfNumMsisdn.Value = _minsDataTable.Rows.Count.ToString

                    'Carga las clausulas
                    MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaClausula(), ddlClausula)
                    habilitarPaneles()

                    Session("referenciasDataTable") = Nothing

                    If .Adendo Then
                        pnlInfoMin.Enabled = True
                        lblMensajeBloqueo.Visible = False
                        lbAgregarMIN.Visible = True
                    Else
                        pnlInfoMin.Enabled = False
                        lblMensajeBloqueo.Visible = True
                        lbAgregarMIN.Visible = False
                    End If

                    With ddlMaterial
                        lblMateriales.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
                        .Items.Insert(0, New ListItem("Seleccione un Material", "0"))
                    End With
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarMines()
        Try
            Dim dtMsisdn As DataTable = Session("minsDataTable")
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()

            'Carga los MINs
            With gvMINS
                .DataSource = dtMsisdn
                .DataBind()
            End With
            hfNumMsisdn.Value = dtMsisdn.Rows.Count.ToString
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar Mines. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarReferencias()
        Try
            Dim dtReferencia As DataTable = Session("referenciasDataTable")
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()
            'Carga las referencias
            With gvReferencias
                .DataSource = dtReferencia
                .DataBind()
            End With
            hfNumReferencias.Value = dtReferencia.Rows.Count.ToString
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar referencias. " & ex.Message)
        End Try
    End Sub

    Private Function CrearEstructuraTablaMsisdn() As DataTable
        Dim dtMsisdn As New DataTable
        With dtMsisdn
            Dim dcAux As New DataColumn("idMsisdn")
            With dcAux
                .AutoIncrement = True
                .AutoIncrementStep = 1
            End With
            .Columns.Add(dcAux)
            .Columns.Add("msisdn", GetType(Long))
            .Columns.Add("activaEquipoAnterior", GetType(Boolean))
            .Columns.Add("comSeguro", GetType(Boolean))
            .Columns.Add("precioConIVA", GetType(Long))
            .Columns.Add("precioSinIVA", GetType(Long))
            .Columns.Add("idClausula", GetType(Integer))
            .Columns.Add("clausula", GetType(String))
            .AcceptChanges()
        End With
        Dim pkMin() As DataColumn = {dtMsisdn.Columns("idMsisdn")}
        dtMsisdn.PrimaryKey = pkMin
        Return dtMsisdn
    End Function

    Private Function CrearEstructuraTablaReferencia() As DataTable
        Dim dtReferencia As New DataTable
        With dtReferencia
            .Columns.Add("material", GetType(String))
            .Columns.Add("referencia", GetType(String))
            .Columns.Add("cantidad", GetType(Integer))
            .AcceptChanges()
        End With
        Dim pkMaterial() As DataColumn = {dtReferencia.Columns("material")}
        dtReferencia.PrimaryKey = pkMaterial
        Return dtReferencia
    End Function

    Private Sub AgregarReferencia()
        Dim dtReferencia As DataTable = Session("referenciasDataTable")
        Try
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()
            If Not String.IsNullOrEmpty(ddlMaterial.SelectedValue) AndAlso ddlMaterial.SelectedValue <> "0" Then
                If dtReferencia.Rows.Find(ddlMaterial.SelectedValue) Is Nothing Then
                    Dim filaDataRow As DataRow = dtReferencia.NewRow()
                    filaDataRow("material") = CStr(ddlMaterial.SelectedValue)
                    filaDataRow("referencia") = ddlMaterial.SelectedItem.Text
                    filaDataRow("cantidad") = CInt(txtCantidad.Text)

                    dtReferencia.Rows.Add(filaDataRow)
                    dtReferencia.AcceptChanges()

                    Session("referenciasDataTable") = dtReferencia
                    EnlazarReferencias()
                    LimpiarFormularioReferencia()
                Else
                    miEncabezado.showError("El material que está intentando adicionar ya fue previamente adicionado. Por favor verifique")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Agregar Referencia. " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarMINs()
        Dim dtMsisdn As DataTable = Session("minsDataTable")
        Try
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            Dim drAux() As DataRow = dtMsisdn.Select("msisdn=" & txtMsisdn.Text.Trim)
            If drAux IsNot Nothing AndAlso drAux.Length < 2 Then
                If Not RegistroMinExiste(drAux) Then
                    Dim max_id As Integer = dtMsisdn.Compute("max(idMsisdn)", "")
                    Dim filaDataRow As DataRow = dtMsisdn.NewRow()
                    filaDataRow("idMsisdn") = max_id + 1
                    filaDataRow("msisdn") = CLng(txtMsisdn.Text)
                    filaDataRow("activaEquipoAnterior") = chbActivaEquipoAnterior.Checked
                    filaDataRow("comSeguro") = chbComSeguro.Checked
                    filaDataRow("precioConIVA") = CLng(txtPrecioConIVA.Text)
                    filaDataRow("precioSinIVA") = CLng(txtPrecioSinIVA.Text)
                    filaDataRow("idClausula") = CInt(ddlClausula.SelectedValue)
                    filaDataRow("clausula") = ddlClausula.SelectedItem.Text
                    filaDataRow("cargadoMSISDN") = 0
                    dtMsisdn.Rows.Add(filaDataRow)
                    dtMsisdn.AcceptChanges()

                    Session("minsDataTable") = dtMsisdn
                    EnlazarMines()
                    LimpiarFormularioMin()
                Else
                    miEncabezado.showError("El registro que está tratando de ingresar ya existe. Por favor verifique")
                End If
            Else
                miEncabezado.showError("El MSISDN que está intentando adicionar ya superó el número de registros permitidos: 2 Registros. Por favor verifique")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Agregar MINs. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormularioReferencia()
        txtFiltroMaterial.Text = ""
        CargarListadoDeMateriales()
        txtCantidad.Text = ""
    End Sub

    Private Sub LimpiarFormularioMin()
        txtMsisdn.Text = ""
        chbActivaEquipoAnterior.Checked = False
        chbComSeguro.Checked = False
        txtPrecioConIVA.Text = ""
        txtPrecioSinIVA.Text = ""
        ddlClausula.ClearSelection()
    End Sub

    Private Sub EliminarMaterial(ByVal material As String)
        Try
            Dim dtReferencia As DataTable = CType(Session("referenciasDataTable"), DataTable)
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()

            Dim drAux As DataRow = dtReferencia.Rows.Find(material)
            If drAux IsNot Nothing Then
                dtReferencia.Rows.Remove(drAux)
                dtReferencia.AcceptChanges()
                miEncabezado.showSuccess("El material fue eliminado satisfactoriamente de la lista.")
                Session("referenciasDataTable") = dtReferencia
                EnlazarReferencias()
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar material. " & ex.Message)
        End Try
    End Sub

    Public Sub IniciarFormularioEdicionReferencia(ByVal material As String)
        Try
            Dim dtReferencia As DataTable = CType(Session("referenciasDataTable"), DataTable)
            Dim drAux As DataRow = dtReferencia.Rows.Find(material)
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
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
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
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarMin(ByVal idMsisdn As Integer)
        Try
            Dim dtMsisdn As DataTable = Session("minsDataTable")
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            Dim drAux As DataRow = dtMsisdn.Rows.Find(idMsisdn)
            If drAux IsNot Nothing Then
                dtMsisdn.Rows.Remove(drAux)
                dtMsisdn.AcceptChanges()
                miEncabezado.showSuccess("El Msisdn fue eliminado satisfactoriamente de la lista.")
                Session("minsDataTable") = dtMsisdn
                EnlazarMines()
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar Msisdn. " & ex.Message)
        End Try
    End Sub

    Public Sub IniciarFormularioEdicionMin(ByVal idMsisdn As Integer)
        Try
            Dim dtMsisdn As DataTable = CType(Session("minsDataTable"), DataTable)
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            Dim drAux As DataRow = dtMsisdn.Rows.Find(idMsisdn)
            If drAux IsNot Nothing Then
                pnlInfoGeneral.Enabled = False
                pnlBotonEdicionMin.Visible = True
                lbAgregarMIN.Visible = False
                gvMINS.Enabled = False
                LimpiarFormularioReferencia()
                pnlInfoReferencia.Enabled = False

                txtMsisdn.Text = drAux("msisdn").ToString
                chbActivaEquipoAnterior.Checked = drAux("activaEquipoAnterior")
                chbComSeguro.Checked = drAux("comSeguro")
                txtPrecioConIVA.Text = drAux("precioConIVA").ToString
                txtPrecioSinIVA.Text = drAux("precioSinIVA").ToString
                With ddlClausula
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(drAux("idClausula")))
                End With
                hfMsisdnAct.Value = idMsisdn.ToString
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
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
            chbActivaEquipoAnterior.Checked = False
            chbComSeguro.Checked = False
            txtPrecioConIVA.Text = ""
            txtPrecioSinIVA.Text = ""
            ddlClausula.ClearSelection()
            hfMsisdnAct.Value = ""
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
        End Try
    End Sub

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

    Private Sub gvMINS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMINS.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If CBool(CType(e.Row.DataItem, DataRowView).Item("cargadoMSISDN")) Then
                CType(e.Row.FindControl("ibEliminar"), ImageButton).Visible = False
                CType(e.Row.FindControl("ibEditar"), ImageButton).Visible = False
                'Else
                e.Row.Cells(1).Text = IIf(CBool(CType(e.Row.DataItem, DataRowView).Item("activaEquipoAnterior")), "SI", "NO")
                e.Row.Cells(2).Text = IIf(CBool(CType(e.Row.DataItem, DataRowView).Item("comSeguro")), "SI", "NO")
            End If
        End If
    End Sub

    Private Sub RegistrarServicio()
        Try
            miEncabezado.clear()
            If CType(Session("referenciasDataTable"), DataTable) IsNot Nothing Then
                If CType(Session("referenciasDataTable"), DataTable).Rows.Count > 0 Then
                    Dim objServicio As MensajeriaEspecializada.CargueServicioMensajeria = CType(Session("infoServicioMensajeria"), MensajeriaEspecializada.CargueServicioMensajeria)
                    With objServicio
                        Idservicio = .IdServicioMensajeria
                        .IdUsuario = CInt(Session("usxp001")) '1 'TODO:Usuario de sesión
                        .FechaAsignacion = CDate(txtFechaAsignacion.Text)
                        .UsuarioEjecutor = txtUsuarioEjecutor.Text
                        .NombreCliente = txtNombres.Text
                        .PersonaContacto = txtNombresAutorizado.Text
                        .IdenticacionCliente = txtIdentificacion.Text
                        .IdCiudad = txtCiudad.Text
                        .Barrio = txtBarrio.Text.Trim
                        .Direccion = txtDireccion.Text
                        .TelefonoContacto = txtTelefono.Text
                        .ExtensionContacto = txtExtension.Text
                        .TipoTelefono = CStr(IIf(rbTelefonoCelular.Checked, "CEL", "FIJO"))
                        .NumeroRadicado = CInt(txtNoRadicado.Text)
                        .ClienteVIP = chbClienteVIP.Checked
                        .PlanActual = txtPlanActual.Text
                        .Observacion = txtObservacion.Text
                        .IdEstado = Enumerados.EstadoServicio.Creado
                        .IdTipoServicio = .IdTipoServicio
                        .FechaVencimientoReserva = dpFechaVencimientoReserva.SelectedDate
                        .IdPrioridad = .IdPrioridad
                        .IdBodega = .IdBodega

                        .ReferenciasDataTable = Session("referenciasDataTable")
                        .MinsDataTable = Session("minsDataTable")

                        Dim respuesta As ResultadoProceso = .Registrar()
                        If respuesta.Valor = 0 Then
                            Dim objCargueServicioMensajeria As New MensajeriaEspecializada.CargueServicioMensajeria()
                            With objCargueServicioMensajeria
                                .IdServicioMensajeria = Idservicio
                                .ActualizaCargueArchivo()
                            End With
                            deshabilitarPaneles()
                            miEncabezado.showSuccess("Servicio creado correctamente para el radicado No. " & .NumeroRadicado)
                        Else
                            miEncabezado.showWarning("Servicio no creado: " & respuesta.Mensaje)
                        End If
                    End With
                Else
                    miEncabezado.showWarning("Debe agregar materiales para poder crear el servicio")
                End If
            Else
                miEncabezado.showWarning("Debe agregar materiales para poder crear el servicio")
            End If

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Registrar Servicio. " & ex.Message)
        End Try
    End Sub



    Private Sub habilitarPaneles()
        pnlInfoGeneral.Enabled = True
        pnlInfoReferencia.Enabled = True
        pnlInfoMin.Enabled = True
        pnlBotones.Enabled = True
        pnlBotonEdicionReferencia.Enabled = True
        pnlBotonEdicionMin.Enabled = True
    End Sub

    Private Sub deshabilitarPaneles()
        'pnlInfoGeneral.Enabled = False
        pnlInfoReferencia.Enabled = False
        pnlInfoMin.Enabled = False
        pnlBotones.Enabled = False
        pnlBotonEdicionReferencia.Enabled = False
        pnlBotonEdicionMin.Enabled = False
    End Sub

#End Region

End Class