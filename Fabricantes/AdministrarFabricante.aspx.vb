Imports ILSBusinessLayer
Imports ILSBusinessLayer.Estructuras

Partial Public Class AdministrarFabricante
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        epRegisterNotifier.clear()
        epFindNotifier.clear()
        Try
            If Not Me.IsPostBack Then
                epNotificador.setTitle("Creación, Búsqueda y Actualización de Fabricantes")
                epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarListadoFabricantes()
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudades(ByVal ddl As DropDownList)
        Dim dtDatos As DataTable
        dtDatos = Localizacion.Ciudad.ObtenerListado()
        MetodosComunes.CargarDropDown(dtDatos, CType(ddl, ListControl), "Escoja una Ciudad")
    End Sub

    Private Sub CargarTiposDeProducto()
        Dim dtDatos As DataTable
        Try
            dtDatos = Productos.TipoProducto.ObtenerListado()
            MetodosComunes.CargarDropDown(dtDatos, CType(ddlTipoProducto, ListControl), "Escoja un Tipo de Producto")
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Tipos de Producto. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoFabricantes()
        Dim filtro As New FiltroFabricante
        CargarListadoFabricantes(filtro)
    End Sub

    Private Sub CargarListadoFabricantes(ByVal filtro As FiltroFabricante)
        Dim dtDatos As DataTable
        Try
            dtDatos = Fabricante.ObtenerListado(filtro)
            Dim dcEstado As New DataColumn("descEstado")
            dcEstado.Expression = "IIF(estado=1,'ACTIVO','INACTIVO')"
            dtDatos.Columns.Add(dcEstado)
            Session("dtListaFabricantes") = dtDatos
            EnlazarListadoFabricantes(dtDatos)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Fabricantes. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarListadoFabricantes(ByVal dtDatos As DataTable)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.Sort = "nombre asc"
        With gvFabricante
            .DataSource = dvDatos
            If dvDatos.Count > 0 Then .Columns(0).FooterText = dvDatos.Count.ToString & " Registro(s) Encontrado(s)"
            .DataBind()
        End With
        MetodosComunes.mergeGridViewFooter(gvFabricante)
    End Sub

    Protected Sub lbCrear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCrear.Click
        LimpiarFormularioModificacion()
        btnActualizar.Visible = False
        trEstado.Visible = False
        Try
            CargarCiudades(ddlCiudad)
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de cargar el listado de Ciudades. " & ex.Message)
        End Try
        mpeFormularioModificacion.Show()
    End Sub

    Private Sub LimpiarFormularioModificacion(Optional ByVal limpiarCiudades As Boolean = True)
        txtNombre.Text = ""
        txtDireccion.Text = ""
        txtTelefono.Text = ""
        ddlCiudad.ClearSelection()
        If limpiarCiudades Then ddlCiudad.Items.Clear()
    End Sub

    Private Sub LimpiarFormularioBusqueda()
        txtBuscarNombre.Text = ""
        ddlBuscarCiudad.Items.Clear()
        ddlBuscarEstado.ClearSelection()
        ddlTipoProducto.ClearSelection()
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        LimpiarFormularioModificacion()
        mpeFormularioModificacion.Hide()
    End Sub

    Private Sub gvFabricante_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvFabricante.PageIndexChanging
        If Session("dtListaFabricantes") IsNot Nothing Then
            gvFabricante.PageIndex = e.NewPageIndex
            Dim dtDatos As DataTable = CType(Session("dtListaFabricantes"), DataTable)
            EnlazarListadoFabricantes(dtDatos)
        Else
            epNotificador.showWarning("Imposible recuperar el listado de fabricantes desde la memoria. Por favor genere el listado nuevamente.")
        End If

    End Sub

    Private Sub gvFabricante_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvFabricante.RowCommand
        If e.CommandName = "actualizar" Then
            LimpiarFormularioModificacion()
            btnRegistrar.Visible = False
            btnActualizar.Visible = True
            trEstado.Visible = True
            Dim idFabricante As Integer = CInt(e.CommandArgument)
            Try
                CargarCiudades(ddlCiudad)
                Dim elFabricante As New Fabricante(idFabricante)
                With elFabricante
                    txtNombre.Text = .Nombre
                    txtDireccion.Text = .Direccion
                    txtTelefono.Text = .Telefono
                End With
                With ddlCiudad
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(elFabricante.IdCiudad))
                End With
                Dim idEstado As Byte = IIf(elFabricante.Activo, 1, 2)
                With ddlEstado
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(idEstado))
                End With
                hIdFabricante.Value = idFabricante.ToString
                btnActualizar.Focus()
                mpeFormularioModificacion.Show()
            Catch ex As Exception
                epRegisterNotifier.showError("Error al tratar de cargar datos del fabricante. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        LimpiarFormularioBusqueda()
        CargarCiudades(ddlBuscarCiudad)
        If ddlTipoProducto.Items.Count = 0 Then CargarTiposDeProducto()
        mpeFormularioBusqueda.Show()
    End Sub

    Protected Sub btnCancelarBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelarBuscar.Click
        LimpiarFormularioBusqueda()
        mpeFormularioBusqueda.Hide()
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Dim filtro As New FiltroFabricante
        If txtBuscarNombre.Text.Trim.Length > 0 Then filtro.Nombre = txtBuscarNombre.Text
        With ddlBuscarCiudad
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > 0 Then filtro.IdCiudad = CInt(.SelectedValue)
        End With
        With ddlBuscarEstado
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > -1 Then filtro.Activo = CInt(.SelectedValue)
        End With
        With ddlTipoProducto
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > 0 Then filtro.IdTipoProducto = CInt(.SelectedValue)
        End With
        CargarListadoFabricantes(filtro)
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim elFabricante As New Fabricante
        Dim resultado As Short
        Try
            With elFabricante
                .Nombre = txtNombre.Text.Trim
                .Direccion = txtDireccion.Text.Trim
                .Telefono = txtTelefono.Text.Trim
                .IdCiudad = CInt(ddlCiudad.SelectedValue)
                .IdCreador = IIf(Session("usxp001") IsNot Nothing, CInt(Session("usxp001")), 1)
                resultado = .Registrar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("El Fabricante fue registrado satisfactoriamente.")
                CargarListadoFabricantes()
                LimpiarFormularioModificacion(False)
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("El Fabricante que está tratando de registrar ya existe. Por favor verifique")
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
        Dim elFabricante As New Fabricante
        Dim resultado As Short
        Try
            With elFabricante
                .IdFabricante = CInt(hIdFabricante.Value)
                .Nombre = txtNombre.Text.Trim
                .Direccion = txtDireccion.Text.Trim
                .Telefono = txtTelefono.Text.Trim
                .IdCiudad = CInt(ddlCiudad.SelectedValue)
                .Activo = IIf(ddlEstado.SelectedValue = "1", True, False)
                resultado = .Actualizar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("La información fue actualizada satisfactoriamente.")
                CargarListadoFabricantes()
                LimpiarFormularioModificacion()
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("Ya existe otro fabricante con el nombre especificado. Por favor verifique")
                ElseIf resultado = 3 Then
                    epRegisterNotifier.showWarning("No se puede actualizar la información, por que no se han proporcionado todos los datos requeridos. Por favor verifique")
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