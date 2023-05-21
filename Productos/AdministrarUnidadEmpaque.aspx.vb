Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Enumerados

Partial Public Class AdministrarUnidadEmpaque
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        epRegisterNotifier.clear()
        epFindNotifier.clear()
        Try
            If Not Me.IsPostBack Then
                epNotificador.setTitle("Creación, Búsqueda y Actualización de Unidades de Empaque")
                epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarListadoUnidadEmpaque()
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoUnidadEmpaque()
        Dim filtro As New FiltroUnidadEmpaque
        CargarListadoUnidadEmpaque(filtro)
    End Sub

    Private Sub CargarListadoUnidadEmpaque(ByVal filtro As FiltroUnidadEmpaque)
        Dim dtDatos As DataTable
        Try
            dtDatos = UnidadEmpaque.ObtenerListado(filtro)
            Dim dcEstado As New DataColumn("descEstado")
            dcEstado.Expression = "IIF(estado=1,'ACTIVO','INACTIVO')"
            dtDatos.Columns.Add(dcEstado)
            Session("dtListaUnidadesEmpaque") = dtDatos
            EnlazarListadoUnidadEmpaque(dtDatos)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Unidades de Empaque. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarListadoUnidadEmpaque(ByVal dtDatos As DataTable)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.Sort = "idTipoUnidad asc"
        With gvListado
            .DataSource = dvDatos
            If dvDatos.Count > 0 Then .Columns(0).FooterText = dvDatos.Count.ToString & " Registro(s) Encontrado(s)"
            .DataBind()
        End With
        MetodosComunes.mergeGridViewFooter(gvListado)
    End Sub

    Protected Sub lbCrear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCrear.Click
        LimpiarFormularioModificacion()
        btnActualizar.Visible = False
        trEstado.Visible = False
        mpeFormularioModificacion.Show()
    End Sub

    Private Sub LimpiarFormularioModificacion()
        txtDescripcion.Text = ""
    End Sub

    Private Sub LimpiarFormularioBusqueda()
        txtBuscarDescripcion.Text = ""
        ddlBuscarEstado.ClearSelection()
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        LimpiarFormularioModificacion()
        mpeFormularioModificacion.Hide()
    End Sub

    Private Sub gvListado_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvListado.PageIndexChanging
        If Session("dtListaUnidadesEmpaque") IsNot Nothing Then
            gvListado.PageIndex = e.NewPageIndex
            Dim dtDatos As DataTable = CType(Session("dtListaUnidadesEmpaque"), DataTable)
            EnlazarListadoUnidadEmpaque(dtDatos)
        Else
            epNotificador.showWarning("Imposible recuperar el listado de unidades de empaque desde la memoria. Por favor genere el listado nuevamente.")
        End If

    End Sub

    Private Sub gvListado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvListado.RowCommand
        If e.CommandName = "actualizar" Then
            LimpiarFormularioModificacion()
            btnRegistrar.Visible = False
            btnActualizar.Visible = True
            trEstado.Visible = True
            Dim idTipoUnidad As Integer = CInt(e.CommandArgument)
            Try
                Dim elTipoUnidad As New UnidadEmpaque(idTipoUnidad)
                With elTipoUnidad
                    txtDescripcion.Text = .Descripcion
                End With
                Dim idEstado As Byte = IIf(elTipoUnidad.Activo, 1, 2)
                With ddlEstado
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(idEstado))
                End With
                hIdTipoUnidad.Value = idTipoUnidad.ToString
                btnActualizar.Focus()
                mpeFormularioModificacion.Show()
            Catch ex As Exception
                epRegisterNotifier.showError("Error al tratar de cargar datos de la unidad de empaque. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        mpeFormularioBusqueda.Show()
    End Sub

    Protected Sub btnCancelarBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelarBuscar.Click
        LimpiarFormularioBusqueda()
        AplicarFiltros()
        mpeFormularioBusqueda.Hide()
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        AplicarFiltros()
    End Sub

    Private Sub AplicarFiltros()
        Dim filtro As New FiltroUnidadEmpaque
        If txtBuscarDescripcion.Text.Trim.Length > 0 Then filtro.Descripcion = txtBuscarDescripcion.Text
        With ddlBuscarEstado
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > -1 Then filtro.Activo = CInt(.SelectedValue)
        End With
        CargarListadoUnidadEmpaque(filtro)
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim laUnidadEmpaque As New UnidadEmpaque
        Dim resultado As Short
        Try
            With laUnidadEmpaque
                .Descripcion = txtDescripcion.Text.Trim
                resultado = .Registrar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("La Unidad de Empaque fue registrada satisfactoriamente.")
                CargarListadoUnidadEmpaque()
                LimpiarFormularioModificacion()
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("Ya existe una Unidad de Empaque con la descripción especificada. Por favor verifique")
                ElseIf resultado = 3 Then
                    epRegisterNotifier.showWarning("No se puede registrar la información, por que no se han proporcionado todos los datos requeridos. Por favor verifique")
                Else
                    epRegisterNotifier.showError("Ocurrió un error inesperado al registrar la información. Por favor intente nuevamente")
                End If
                mpeFormularioModificacion.Show()
            End If
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de registrar datos. " & ex.Message)
            mpeFormularioModificacion.Show()
        End Try
    End Sub

    Protected Sub btnActualizar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnActualizar.Click
        Dim laUnidadEmpaque As New UnidadEmpaque
        Dim resultado As Short
        Try
            With laUnidadEmpaque
                .IdTipoUnidad = CShort(hIdTipoUnidad.Value)
                .Descripcion = txtDescripcion.Text.Trim
                .Activo = IIf(ddlEstado.SelectedValue = "1", True, False)
                resultado = .Actualizar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("La Unidad de Empaque fue actualizada satisfactoriamente.")
                CargarListadoUnidadEmpaque()
                LimpiarFormularioModificacion()
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("Ya existe una Unidad de Empaque con la descripción especificada. Por favor verifique")
                ElseIf resultado = 3 Then
                    epRegisterNotifier.showWarning("No se puede registrar la información, por que no se han proporcionado todos los datos requeridos. Por favor verifique")
                Else
                    epRegisterNotifier.showError("Ocurrió un error inesperado al registrar la información. Por favor intente nuevamente")
                End If
                mpeFormularioModificacion.Show()
            End If
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de registrar datos. " & ex.Message)
            mpeFormularioModificacion.Show()
        End Try
    End Sub

End Class