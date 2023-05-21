Imports ILSBusinessLayer
Imports ILSBusinessLayer.SAC

Partial Public Class BuscarCasoSAC
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epGeneral.clear()
        txtFechaInicial.Text = Request.Form("txtFechaInicial")
        txtFechaFinal.Text = Request.Form("txtFechaFinal")
        If Not Me.IsPostBack Then
            Session.Remove("dtReporte")
            epGeneral.setTitle("Buscar Caso de Servicio Al Cliente")
            epGeneral.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            Try
                CargarEstados()
                CargarTiposDeCliente()
                CargarClientes()
                CargarClasesDeCaso()
                CargarTiposDeCaso()
                CargarListadoRemitentes()
                CargarListaGeneradorInconformidad()
                CargarListaTramitadores()
                pnlReporte.Visible = False
            Catch ex As Exception
                lbBuscar.Enabled = False
                epGeneral.showError("Error al tratar de cargar filtros de búsqueda. Por favor recargue la página. " & ex.Message)
            End Try
            If Request.QueryString("filtrar") IsNot Nothing Then
                If Session("objListaCasos") IsNot Nothing Then
                    Dim dtDatos As DataTable = ObtenerDatosAplicandoFiltrosEnMemoria()
                    EnlazarDatos(dtDatos)
                End If
            End If
        End If
    End Sub

    Private Sub CargarEstados()
        Dim listaEstados As New EstadoEntidadColeccion
        Try
            With listaEstados
                .IdEntidad = 23
                .CargarDatos()
            End With
            With ddlEstado
                .DataSource = listaEstados
                .DataTextField = "nombre"
                .DataValueField = "idEstado"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Estados. " & ex.Message, ex)
        End Try
        ddlEstado.Items.Insert(0, New ListItem("Seleccione un Estado", "0"))
    End Sub

    Private Sub CargarTiposDeCliente()
        Dim listaTipoClienteSAC As New TipoDeClienteSACColeccion
        Try
            With listaTipoClienteSAC
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlTipoCliente
                .DataSource = listaTipoClienteSAC
                .DataTextField = "descripcion"
                .DataValueField = "idTipoCliente"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Tipos de Cliente. " & ex.Message, ex)
        End Try
        ddlTipoCliente.Items.Insert(0, New ListItem("Seleccione un Tipo de Cliente", "0"))
    End Sub

    Private Sub CargarClientes(Optional ByVal idTipoCliente As Integer = 0)
        Try
            If idTipoCliente > 0 Then
                Dim listaCliente As New ClienteSACColeccion
                listaCliente.IdTipo.Add(idTipoCliente)
                listaCliente.CargarDatos()
                With ddlCliente
                    .DataSource = listaCliente
                    .DataTextField = "nombre"
                    .DataValueField = "idCliente"
                    .DataBind()
                End With
            Else
                ddlCliente.Items.Clear()
            End If
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Clientes. " & ex.Message)
        End Try
        ddlCliente.Items.Insert(0, New ListItem("Seleccione un Cliente", "0"))
    End Sub

    Private Sub CargarClasesDeCaso()
        Dim listaClaseCasoSAC As New ClaseDeServicioSACColeccion
        Try
            With listaClaseCasoSAC
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlClaseCaso
                .DataSource = listaClaseCasoSAC
                .DataTextField = "descripcion"
                .DataValueField = "idClase"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Clases de Caso. " & ex.Message, ex)
        End Try
        ddlClaseCaso.Items.Insert(0, New ListItem("Seleccione Clase de Caso", "0"))
    End Sub

    Private Sub CargarTiposDeCaso(Optional ByVal idClase As Integer = 0)
        Try
            If idClase > 0 Then
                Dim listaTipoCaso As New TipoDeServicioSACColeccion
                listaTipoCaso.IdClaseServicio.Add(idClase)
                listaTipoCaso.CargarDatos()
                With ddlTipoCaso
                    .DataSource = listaTipoCaso
                    .DataTextField = "descripcion"
                    .DataValueField = "idTipo"
                    .DataBind()
                End With
            Else
                ddlTipoCaso.Items.Clear()
            End If
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Clientes. " & ex.Message, ex)
        End Try
        ddlTipoCaso.Items.Insert(0, New ListItem("Seleccione un Tipo de Caso", "0"))
    End Sub

    Private Sub CargarListadoRemitentes()
        Dim listaRemitente As New UsuarioModuloSACColeccion
        Try
            With listaRemitente
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlRemitente
                .DataSource = listaRemitente
                .DataTextField = "nombre"
                .DataValueField = "idUsuario"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de posibles Remitentes. " & ex.Message, ex)
        End Try
        ddlRemitente.Items.Insert(0, New ListItem("Seleccione Remitente", "0"))
    End Sub

    Private Sub CargarListaGeneradorInconformidad()
        Dim listaGenerador As New GeneradorInconformidadSACColeccion
        Try
            With listaGenerador
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlGeneradorInconformidad
                .DataSource = listaGenerador
                .DataTextField = "descripcion"
                .DataValueField = "idGenerador"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de posibles Generadores de la Inconformidad. " & ex.Message, ex)
        End Try
        ddlGeneradorInconformidad.Items.Insert(0, New ListItem("Seleccione Generador", "0"))
    End Sub

    Private Sub CargarListaTramitadores()
        Dim listaTramitador As New UsuarioTramitadorCasoSACColeccion
        Try
            With listaTramitador
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlTramitador
                .DataSource = listaTramitador
                .DataTextField = "nombre"
                .DataValueField = "idUsuario"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de posibles Tramitadores. " & ex.Message)
        End Try
        ddlTramitador.Items.Insert(0, New ListItem("Seleccione Tramitador", "0"))
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Try
            Dim dtReporte As New DataTable
            Dim dtDatos As DataTable = ObtenerDatos(dtReporte)
            Session("dtReporte") = dtReporte
            If Not dtReporte Is Nothing AndAlso dtReporte.Rows.Count > 0 Then
                pnlReporte.Visible = True
            Else
                pnlReporte.Visible = False
            End If
            If dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
                Session("dtListaCasos") = dtDatos
            Else
                repCaso.DataSource = Nothing
                repCaso.DataBind()
                epGeneral.showWarning("<i>No se encontraron datos de acuerdo con los filtros aplicados.</i>")
            End If
        Catch ex As Exception
            epGeneral.showError("Error al tratar de obtener datos." & ex.Message)
        End Try
    End Sub

    Private Function ObtenerDatos(Optional ByRef dt As DataTable = Nothing) As DataTable
        Dim dtDatos As DataTable
        Dim listaCasoSAC As New CasoSACColeccion
        With listaCasoSAC
            If txtNoCaso.Text.Trim.Length > 0 Then .Consecutivo = txtNoCaso.Text.Trim
            If txtNoRadicado.Text.Trim.Length > 0 Then Integer.TryParse(txtNoRadicado.Text.Trim, .ConsecutivoServicio)
            If txtMin.Text.Trim.Length > 0 Then .MinFiltro = txtMin.Text.Trim
            If ddlClaseCaso.SelectedValue <> "0" Then .IdClaseServicio = ddlClaseCaso.SelectedValue
            If ddlTipoCaso.SelectedValue <> "0" Then .IdTipoServicio = ddlTipoCaso.SelectedValue
            If ddlTipoCliente.SelectedValue <> "0" Then .IdTipoCliente = ddlTipoCliente.SelectedValue
            If ddlCliente.SelectedValue <> "0" Then .IdCliente = ddlCliente.SelectedValue
            If ddlRemitente.SelectedValue <> "0" Then .IdRemitente = ddlRemitente.SelectedValue
            If ddlGeneradorInconformidad.SelectedValue <> "0" Then .IdGeneradorInconformidad = ddlGeneradorInconformidad.SelectedValue
            If ddlTramitador.SelectedValue <> "0" Then .IdTramitador = ddlTramitador.SelectedValue
            If ddlEstado.SelectedValue <> "0" Then .IdEstado = ddlEstado.SelectedValue
            If txtFechaInicial.Text.Length > 0 AndAlso txtFechaFinal.Text.Length > 0 Then
                .FechaInicial = txtFechaInicial.Text
                .FechaFinal = txtFechaFinal.Text
                .IdTipoFecha = rblTipoFecha.SelectedValue
            End If
            .CargarDatos()
            dtDatos = .GenerarDataTable()
            If Not dt Is Nothing Then dt = .ObtenerDatosReporteCEM()
            .Clear()
        End With
        '***Se almacena la lista vácia, sólo preservando los filtros aplicados para una consulta futura***'
        Session("objListaCasos") = listaCasoSAC
        Return dtDatos
    End Function

    Private Function ObtenerDatosAplicandoFiltrosEnMemoria() As DataTable
        Dim dtDatos As New DataTable
        Try
            If Session("objListaCasos") IsNot Nothing Then
                Dim listaCasosSAC As CasoSACColeccion = CType(Session("objListaCasos"), CasoSACColeccion)
                With listaCasosSAC
                    .CargarDatos()
                    dtDatos = .GenerarDataTable()
                    .Clear()
                End With
            End If
        Catch ex As Exception
            epGeneral.showError("Error al tratar de obtener datos desde memoria. Por favor recargue la página. " & ex.Message)
        End Try
        Return dtDatos
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        With repCaso
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Private Sub repCaso_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repCaso.ItemCommand
        Select Case e.CommandName.ToLower
            Case "ver"
                Response.Redirect("VisualizarInfoCasoSAC.aspx?idCaso=" & e.CommandArgument.ToString)
            Case "editar"
                Response.Redirect("RegistraGestionCasoSAC.aspx?idCaso=" & e.CommandArgument.ToString)
            Case "editarcaso"
                Response.Redirect("EdicionCasoSACCEM.aspx?idCaso=" & e.CommandArgument.ToString)
            Case "finalizar"
                Response.Redirect("CerrarCasoSAC.aspx?idCaso=" & e.CommandArgument.ToString)
            Case Else
                Throw New ArgumentNullException("Archivo no valido")
        End Select
    End Sub

    Private Sub repCaso_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repCaso.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim idEstado As Short = CType(e.Item.DataItem, DataRowView).Item("IdEstado")
            Dim ibEditar As ImageButton = CType(e.Item.FindControl("ibEditar"), ImageButton)
            Dim ibEditarCaso As ImageButton = CType(e.Item.FindControl("ibEditarCaso"), ImageButton)
            Dim ibFinalizar As ImageButton = CType(e.Item.FindControl("ibFinalizar"), ImageButton)
            If ibEditar IsNot Nothing AndAlso ibFinalizar IsNot Nothing Then
                ibEditar.Visible = IIf(idEstado <> 72, True, False)
                ibEditarCaso.Visible = IIf(idEstado = 71, True, False)
                ibFinalizar.Visible = IIf(idEstado = 71, True, False)
            End If
        End If
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        txtNoCaso.Text = ""
        txtNoRadicado.Text = ""
        txtMin.Text = ""
        ddlClaseCaso.ClearSelection()
        ddlTipoCliente.ClearSelection()
        ddlTipoCaso.ClearSelection()
        ddlCliente.ClearSelection()
        ddlRemitente.ClearSelection()
        ddlGeneradorInconformidad.ClearSelection()
        ddlTramitador.ClearSelection()
        ddlEstado.ClearSelection()
        txtFechaInicial.Text = ""
        txtFechaFinal.Text = ""
    End Sub

    Protected Sub ddlTipoCliente_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlTipoCliente.SelectedIndexChanged
        Dim idTipoCliente As Short
        Short.TryParse(ddlTipoCliente.SelectedValue, idTipoCliente)
        CargarClientes(idTipoCliente)
    End Sub

    Protected Sub ddlClaseCaso_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlClaseCaso.SelectedIndexChanged
        Dim idClase As Short
        Short.TryParse(ddlClaseCaso.SelectedValue, idClase)
        CargarTiposDeCaso(idClase)
    End Sub

    Protected Sub lbDescargarReporte_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbDescargarReporte.Click
        Try
            Dim dtReporte As DataTable
            dtReporte = CType(Session("dtReporte"), DataTable)
            If Not dtReporte Is Nothing AndAlso dtReporte.Rows.Count > 0 Then
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtReporte, "Quejar y Reclamos CEM", "quejasyreclamoscem.xls", Server.MapPath("..\archivos_planos\quejasyreclamoscem.xls"))
            End If
        Catch ex As Exception
            epGeneral.showError("Error al descargar el reporte. " & ex.Message)
        End Try
    End Sub
End Class