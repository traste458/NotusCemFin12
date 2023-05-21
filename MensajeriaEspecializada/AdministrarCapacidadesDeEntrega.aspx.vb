Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class AdministrarCapacidadesDeEntrega
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Administrar Capacidades de Entrega")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            dpFecha.Value = Now.ToShortDateString
            rvfecha.MinimumValue = Now.ToShortDateString
            rvfecha.MaximumValue = Now.AddDays(30).ToShortDateString
            'dpFecha.MinValidDate = Now
            'dpFecha.MaxValidDate = Now.AddDays(30)
            txtFechaInicial.Value = Now.ToShortDateString
            txtFechaFinal.Value = Now.AddDays(15).ToShortDateString
            CargarJornadas(ddlJornada)
            CargarClientes(ddlcliente)
            CargarAgrupaciones(ddlAgrupacion)
            ConsultarRegistros()
        End If
    End Sub

    Protected Sub lbRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbRegistrar.Click
        Dim resultado As New ResultadoProceso
        Try
            Dim infoCapacidad As New InfoCapacidadEntregaServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With infoCapacidad
                .Fecha = Date.Parse(dpFecha.Value)
                .IdJornada = CInt(ddlJornada.SelectedValue)
                .IdEmpresa = CShort(ddlcliente.SelectedValue)
                .CantidadServicios = CInt(txtNumServicios.Text.Trim)
                .IdUsuarioRegistra = idUsuario
                .IdAgrupacion = CShort(ddlAgrupacion.SelectedValue)
                resultado = .Registrar()
                If resultado.Valor = 0 Then
                    epNotificador.showSuccess(resultado.Mensaje)
                    LimpiarFormulario()
                    ConsultarRegistros()
                Else
                    Select Case resultado.Valor
                        Case 1 To 2
                            epNotificador.showWarning(resultado.Mensaje)
                        Case Else
                            epNotificador.showError(resultado.Mensaje)
                    End Select
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar información de capacidad de servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub gvInfoCapacidades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvInfoCapacidades.RowCommand
        Dim idRegistro As Integer
        Try
            Dim info As InfoCapacidadEntregaServicioMensajeria
            If Integer.TryParse(e.CommandArgument.ToString, idRegistro) Then
                info = CType(Session("infoCapacidad"), InfoCapacidadEntregaServicioMensajeriaColeccion).ItemPorIdentificador(idRegistro)
            End If
            If e.CommandName = "editar" Then
                If ddlJornadaEdicion.Items.Count = 0 Then CargarJornadas(ddlJornadaEdicion)
                LimpiarFormularioEdicion()
                If info IsNot Nothing Then
                    lblFecha.Text = info.Fecha.ToShortDateString
                    With ddlJornadaEdicion
                        .SelectedIndex = .Items.IndexOf(.Items.FindByValue(info.IdJornada))
                    End With
                    txtNumServiciosEdicion.Text = info.CantidadServicios
                    lblNumServiciosUtilizados.Text = info.CantidadServiciosUtilizados
                    hfIdInfoCapacidad.Value = idRegistro
                    dlgModificar.Show()
                Else
                    epNotificador.showError("Imposible recuperar la información desde la memoria. Por favor recargue el listado.")
                End If
            ElseIf e.CommandName = "eliminar" Then
                EliminarRegistro(info)
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de procesar comando. " & ex.Message)
        End Try

    End Sub

    Private Sub gvInfoCapacidades_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInfoCapacidades.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ibEliminar As ImageButton = CType(e.Row.FindControl("ibEliminar"), ImageButton)
            Dim cantidadServicios As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("cantidadServicios"))
            Dim cantidadServiciosUtilizados As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("cantidadServiciosUtilizados"))
            If ibEliminar IsNot Nothing Then
                ibEliminar.Visible = IIf(cantidadServiciosUtilizados > 0 And cantidadServicios = cantidadServiciosUtilizados, False, True)
            End If
        End If
    End Sub

    Private Sub lbActualizar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbActualizar.Click
        Dim resultado As New ResultadoProceso
        Try
            Dim infoCapacidad As InfoCapacidadEntregaServicioMensajeria = CType(Session("infoCapacidad"), InfoCapacidadEntregaServicioMensajeriaColeccion).ItemPorIdentificador(hfIdInfoCapacidad.Value)
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With infoCapacidad
                .IdJornada = CInt(ddlJornadaEdicion.SelectedValue)
                .CantidadServicios = CInt(txtNumServiciosEdicion.Text.Trim)
                resultado = .Actualizar(idUsuario)
                If resultado.Valor = 0 Then
                    epNotificador.showSuccess(resultado.Mensaje)
                    LimpiarFormularioEdicion()
                    ConsultarRegistros()
                Else
                    Select Case resultado.Valor
                        Case 1 To 4
                            epNotificador.showWarning(resultado.Mensaje)
                        Case Else
                            epNotificador.showError(resultado.Mensaje)
                    End Select
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de actualizar información de capacidad de servicio. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarJornadas(ByVal ddl As DropDownList)
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaJornadaMensajeria()
            With ddl
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idJornada"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja una Jornada...", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Jornadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarClientes(ByVal ddl As DropDownList)
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaClientesEmpresa()
            With ddl
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idEmpresa"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja un Cliente...", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de clientes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarAgrupaciones(ddl As DropDownList)
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaAgrupacionServicio()
            With ddl
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idAgrupacion"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione una agrupación...", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Agrupaciones. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        dpFecha.Value = Now.ToShortDateString
        ddlJornada.ClearSelection()
        txtNumServicios.Text = ""

        txtFechaInicial.Value = Now.ToShortDateString
        txtFechaFinal.Value = Now.AddDays(15).ToShortDateString
    End Sub

    Protected Sub lbConsultar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbConsultar.Click
        ConsultarRegistros()
    End Sub

    Private Sub ConsultarRegistros()
        Dim infoCapacidad As New InfoCapacidadEntregaServicioMensajeriaColeccion
        Dim idCiudad As Integer
        Dim dtDatos As DataTable
        If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007").ToString, idCiudad)
        Try
            With infoCapacidad
                .IdCiudad = idCiudad
                .IdEmpresa = CShort(ddlcliente.SelectedValue)
                .FechaInicial = CDate(txtFechaInicial.Value)
                .FechaFinal = CDate(txtFechaFinal.Value)
                dtDatos = .GenerarDataTable()
            End With
            Session("infoCapacidad") = infoCapacidad
            EnlazarDatos(dtDatos)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de consultar registros. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            With gvInfoCapacidades
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            MetodosComunes.mergeGridViewFooter(gvInfoCapacidades)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormularioEdicion()
        lblFecha.Text = ""
        ddlJornadaEdicion.ClearSelection()
        txtNumServiciosEdicion.Text = ""
        lblNumServiciosUtilizados.Text = ""
    End Sub

    Private Sub EliminarRegistro(ByVal infoCapacidad As InfoCapacidadEntregaServicioMensajeria)
        Dim resultado As New ResultadoProceso
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With infoCapacidad
                resultado = .Eliminar(idUsuario)
                If resultado.Valor = 0 Then
                    epNotificador.showSuccess(resultado.Mensaje)
                    LimpiarFormularioEdicion()
                    ConsultarRegistros()
                Else
                    Select Case resultado.Valor
                        Case 1 To 4
                            epNotificador.showWarning(resultado.Mensaje)
                        Case Else
                            epNotificador.showError(resultado.Mensaje)
                    End Select
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de eliminar información de capacidad de servicio. " & ex.Message)
        End Try
    End Sub

#End Region

End Class