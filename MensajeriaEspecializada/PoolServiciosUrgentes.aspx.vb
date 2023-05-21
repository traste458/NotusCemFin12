Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class PoolServiciosUrgentes
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epPoolServicios.clear()
        If Not IsPostBack Then
            Try
                With epPoolServicios
                    .setTitle("Pool Servicios Urgentes")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                CargarEstado()
                CargarBodega()
                CargarCiudad()
                CargarServicio()
                CargarVIP()

                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()

                Dim dtDatos As DataTable
                dtDatos = CargarPool()
                If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                    EnlazarDatos(dtDatos)
                Else
                    epPoolServicios.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                End If
            Catch ex As Exception
                epPoolServicios.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        Else

        End If
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        BuscarDatos()
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtPoolServicios") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtPoolServicios"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epPoolServicios.showWarning("Imposible recuperar los datos desde memorial, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Dim idServicio As Integer
        Integer.TryParse(e.CommandArgument.ToString, idServicio)

        If e.CommandName = "ver" Then
            Response.Redirect("VerInformacionServicio.aspx?idServicio=" & idServicio.ToString, False)
        ElseIf e.CommandName = "adicionarNovedad" Then
            Dim objServicio As New ServicioMensajeria(idServicio)
            Session("infoServicioMensajeria") = objServicio

            txtObservacionNovedad.Text = ""
            CargarNovedades(idServicio)

            CargarTiposDeNovedad(objServicio.IdEstado)
            dlgAdicionarNovedad.Show()
        ElseIf e.CommandName = "modificarServicio" Then
            Response.Redirect("EditarServicio.aspx?idServicio=" & idServicio.ToString, False)
        End If
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idEstado As String = CType(e.Row.DataItem, DataRowView).Item("idEstado").ToString

            Dim arrControles() As String = {"lbVer", "lbAdicionarNovedad", "lbModificarServicio"}

            For indice As Integer = 0 To arrControles.Length - 1
                Dim ctrl As Control = e.Row.FindControl(arrControles(indice))
                If ctrl IsNot Nothing Then
                    ctrl.Visible = EsVisibleOpcionRestringida(ctrl.ID, -1)
                    If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, idEstado)
                End If
            Next
        End If
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dtPoolServicios") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtPoolServicios"), DataTable)
                Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
                EnlazarDatos(dtDatos, expOrdenamiento)
            Else
                epPoolServicios.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub lbAgregarNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAgregarNovedad.Click
        RegistrarNovedad()
    End Sub

#End Region

#Region "Métodos"

    Private Sub CargarEstado()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarEstado
            With ddlEstado
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idEstado"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Estado", "0"))
                End If
            End With
            Session("ArrEstadoPorDefecto") = HerramientasMensajeria.ObtenerListaEstadosPorDefecto(Enumerados.FuncionalidadMensajeria.PoolGeneralServiciosUrgentes)
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Estados. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarBodega()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarBodega
            With ddlBodega
                .DataSource = dtEstado
                .DataTextField = "bodega"
                .DataValueField = "idbodega"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Bodega", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudad()
        Dim dtEstado As New DataTable
        Dim datos As New Ciudad
        Try
            dtEstado = Ciudad.ObtenerCiudadesPorPais
            With ddlCiudad
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Ciudad", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarServicio()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultaTipoServicio
            With ddlTipoServicio
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un tipo de servicio", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal expOrdenamiento As String = "")
        Try
            pnlResultados.Visible = True

            Dim dvDatos As DataView = dtDatos.DefaultView
            If expOrdenamiento.Trim.Length > 0 Then dvDatos.Sort = expOrdenamiento

            With gvDatos
                .DataSource = dvDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Session("dtPoolServicios") = dvDatos.ToTable()
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtidServicio.Text = String.Empty
        ddlCiudad.SelectedIndex = -1
        ddlEstado.SelectedIndex = -1
        ddlBodega.SelectedIndex = -1
        ddlCampana.SelectedIndex = -1
        ddlTipoServicio.SelectedIndex = -1
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        BuscarDatos()
    End Sub

    Private Sub CargarVIP()
        Try
            With ddlVIP
                .Items.Insert(0, New ListItem("Seleccione", "0"))
                .Items.Insert(1, New ListItem("Si", "1"))
                .Items.Insert(2, New ListItem("No", "2"))
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de VIP. " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarDatos()
        Dim dtDatos As New DataTable
        Try
            pnlResultados.Visible = True
            dtDatos = CargarPool()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epPoolServicios.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                pnlResultados.Visible = False
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de generar reporte. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTiposDeNovedad(ByVal idEstado As Integer)
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idEstado:=idEstado)
            With ddlTipoNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad", "0"))
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarNovedad()
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
                resultado = .Registrar(idUsuario)
                If resultado.Valor = 0 Then
                    epPoolServicios.showSuccess(resultado.Mensaje)
                    txtObservacionNovedad.Text = ""
                    CargarNovedades(infoServicio.IdServicioMensajeria)
                Else
                    epPoolServicios.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de registrar la novedad. " & ex.Message)
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
            epPoolServicios.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Funciones"

    Private Function CargarPool() As DataTable
        Dim dtEstado As New DataTable
        Dim datos As New GenerarPoolServicioMensajeria()

        Try
            With datos

                If Not String.IsNullOrEmpty(txtidServicio.Text) OrElse Not String.IsNullOrEmpty(txtFechaInicial.Value) OrElse _
                    ddlCiudad.SelectedValue <> "0" OrElse ddlBodega.SelectedValue <> "0" OrElse _
                    ddlTipoServicio.SelectedValue <> "0" OrElse ddlEstado.SelectedValue <> "0" _
                    OrElse ddlTieneNovedad.SelectedValue <> "0" OrElse ddlVIP.SelectedValue <> "0" Then

                    If Not String.IsNullOrEmpty(txtidServicio.Text) Then .NumeroRadicado = txtidServicio.Text.Trim
                    If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicial = CDate(txtFechaInicial.Value)
                    If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFinal = CDate(txtFechaFinal.Value)
                    If ddlCiudad.SelectedValue > 0 Then .IdCiudad = ddlCiudad.SelectedValue
                    If ddlBodega.SelectedValue > 0 Then .IdBodega = ddlBodega.SelectedValue
                    If ddlTipoServicio.SelectedValue > 0 Then .IdTipoServicio = ddlTipoServicio.SelectedValue
                    If ddlEstado.SelectedValue <> "0" Then .IdEstado = ddlEstado.SelectedValue
                    If ddlTieneNovedad.SelectedValue <> 0 Then .TieneNovedad = ddlTieneNovedad.SelectedValue
                    If ddlVIP.SelectedValue <> "0" Then .ClienteVIP = IIf(ddlVIP.SelectedValue = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                Else
                    If Session("ArrEstadoPorDefecto") IsNot Nothing Then
                        .ListaEstado = Session("ArrEstadoPorDefecto")
                    End If
                End If

                .Urgente = Enumerados.EstadoBinario.Activo
            End With
            dtEstado = datos.GenerarPool()

        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return dtEstado
    End Function

    Private Function ObtenerDireccionOrdenamiento(ByVal columna As String) As String
        Dim direccionOrdenamiento = "ASC"
        Dim expresionOrdenamiento = TryCast(ViewState("ExpresionOrdenamiento"), String)
        If expresionOrdenamiento IsNot Nothing Then
            If expresionOrdenamiento = columna Then
                Dim ultimaDirection = TryCast(ViewState("DireccionOrdenamiento"), String)
                If ultimaDirection IsNot Nothing AndAlso ultimaDirection = "ASC" Then direccionOrdenamiento = "DESC"
            End If
        End If
        ViewState("DireccionOrdenamiento") = direccionOrdenamiento
        ViewState("ExpresionOrdenamiento") = columna
        Return direccionOrdenamiento
    End Function

#End Region

End Class