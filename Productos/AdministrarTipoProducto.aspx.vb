Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Enumerados
Imports ILSBusinessLayer.Estructuras

Partial Public Class AdministrarTipoProducto
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        epRegisterNotifier.clear()
        epFindNotifier.clear()
        Try
            If Not Me.IsPostBack Then
                epNotificador.setTitle("Creación, Búsqueda y Actualización de Tipos de Producto")
                epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarUnidadesEmpaque(ddlUnidadEmpaque)
                CargarListadoDeTiposDeProducto()
            End If

        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarUnidadesEmpaque(ByVal ddl As DropDownList)
        Try
            Dim dtDatos As DataTable
            dtDatos = UnidadEmpaque.ObtenerListado()
            MetodosComunes.CargarDropDown(dtDatos, CType(ddl, ListControl), "Escoja una Unidad")
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Unidades de Empaque. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoDeTiposDeProducto()
        Dim filtro As New FiltroTipoProducto
        CargarListadoDeTiposDeProducto(filtro)
    End Sub

    Private Sub CargarListadoDeTiposDeProducto(ByVal filtro As FiltroTipoProducto)
        Dim dtDatos As DataTable
        Try
            dtDatos = TipoProducto.ObtenerListado(filtro)
            Dim dcAux As DataColumn
            dcAux = New DataColumn("descEstado")
            dcAux.Expression = "IIF(estado=1,'ACTIVO','INACTIVO')"
            dtDatos.Columns.Add(dcAux)
            dcAux = New DataColumn("descInstruccionable")
            dcAux.Expression = "IIF(instruccionable=1,'SI','NO')"
            dtDatos.Columns.Add(dcAux)
            dcAux = New DataColumn("descAplicaTecnologia")
            dcAux.Expression = "IIF(aplicaTecnologia=1,'SI','NO')"
            dtDatos.Columns.Add(dcAux)
            Session("dtListaTiposDeProducto") = dtDatos
            EnlazarListadoTiposDeProducto(dtDatos)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Proveedores. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarListadoTiposDeProducto(ByVal dtDatos As DataTable)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.Sort = "idTipoProducto asc"
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
        txtIdTipoProducto.Text = ""
        txtDescripcion.Text = ""
        ddlInstruccionable.ClearSelection()
        ddlUnidadEmpaque.ClearSelection()
        ddlEstado.ClearSelection()
        ddlAplicaTecnologia.ClearSelection()
    End Sub

    Private Sub LimpiarFormularioBusqueda()
        txtBuscarId.Text = ""
        txtBuscarDescripcion.Text = ""
        ddlBuscarInstruccionable.ClearSelection()
        ddlBuscarEstado.ClearSelection()
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        LimpiarFormularioModificacion()
        mpeFormularioModificacion.Hide()
    End Sub

    Private Sub gvListado_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvListado.PageIndexChanging
        If Session("dtListaTiposDeProducto") IsNot Nothing Then
            gvListado.PageIndex = e.NewPageIndex
            Dim dtDatos As DataTable = CType(Session("dtListaTiposDeProducto"), DataTable)
            EnlazarListadoTiposDeProducto(dtDatos)
        Else
            epNotificador.showWarning("Imposible recuperar el listado de tipos de producto desde la memoria. Por favor genere el listado nuevamente.")
        End If

    End Sub

    Private Sub gvListado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvListado.RowCommand
        If e.CommandName = "actualizar" Then
            LimpiarFormularioModificacion()
            btnRegistrar.Visible = False
            btnActualizar.Visible = True
            trEstado.Visible = True
            Dim idTipoProducto As Integer = CInt(e.CommandArgument)
            Try
                Dim elTipoProducto As New TipoProducto(idTipoProducto)
                With elTipoProducto
                    txtIdTipoProducto.Text = .IdTipoProducto
                    txtDescripcion.Text = .Descripcion
                End With
                Dim instruccionable As Byte = IIf(elTipoProducto.Instruccionable, 1, 2)
                With ddlInstruccionable
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(instruccionable))
                End With
                With ddlUnidadEmpaque
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(elTipoProducto.IdTipoUnidad))
                End With
                Dim aplicaTecnologia As Byte = IIf(elTipoProducto.AplicaTecnologia, 1, 2)
                With ddlAplicaTecnologia
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(aplicaTecnologia))
                End With
                Dim idEstado As Byte = IIf(elTipoProducto.Activo, 1, 2)
                With ddlEstado
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(idEstado))
                End With
                hIdTipoProducto.Value = idTipoProducto.ToString
                btnActualizar.Focus()
                mpeFormularioModificacion.Show()
            Catch ex As Exception
                epRegisterNotifier.showError("Error al tratar de cargar datos del tipo de producto. " & ex.Message)
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
        Dim filtro As New FiltroTipoProducto
        If txtBuscarDescripcion.Text.Trim.Length > 0 Then filtro.Descripcion = txtBuscarDescripcion.Text
        With ddlBuscarInstruccionable
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > 0 Then filtro.Instruccionable = CInt(.SelectedValue)
        End With
        With ddlBuscarEstado
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > -1 Then filtro.Activo = CInt(.SelectedValue)
        End With
        CargarListadoDeTiposDeProducto(filtro)
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim elTipoProducto As New TipoProducto
        Dim resultado As Short
        Try
            With elTipoProducto
                .IdTipoProducto = CShort(txtIdTipoProducto.Text)
                .Descripcion = txtDescripcion.Text.Trim
                .Instruccionable = IIf(ddlInstruccionable.SelectedValue = "1", True, False)
                .IdTipoUnidad = CShort(ddlUnidadEmpaque.SelectedValue)
                .AplicaTecnologia = IIf(ddlAplicaTecnologia.SelectedValue = "1", True, False)
                resultado = .Registrar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("El Tipo de Producto fue registrado satisfactoriamente.")
                CargarListadoDeTiposDeProducto()
                LimpiarFormularioModificacion()
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("Ya existe un Tipo de Producto con el identificador especificado. Por favor verifique")
                ElseIf resultado = 2 Then
                    epRegisterNotifier.showWarning("Ya existe un Tipo de Producto con la descripción especificada. Por favor verifique")
                ElseIf resultado = 4 Then
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
        Dim elTipoProducto As New TipoProducto
        Dim resultado As Short
        Try
            With elTipoProducto
                .IdTipoProducto = CShort(hIdTipoProducto.Value)
                .Descripcion = txtDescripcion.Text.Trim
                .Instruccionable = IIf(ddlInstruccionable.SelectedValue = "1", True, False)
                .IdTipoUnidad = CShort(ddlUnidadEmpaque.SelectedValue)
                .AplicaTecnologia = IIf(ddlAplicaTecnologia.SelectedValue = "1", True, False)
                .Activo = IIf(ddlEstado.SelectedValue = "1", True, False)
                resultado = .Actualizar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("El Tipo de Producto fue actualizado satisfactoriamente.")
                CargarListadoDeTiposDeProducto()
                LimpiarFormularioModificacion()
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("Ya existe un Tipo de Producto con la descripción especificada. Por favor verifique")
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