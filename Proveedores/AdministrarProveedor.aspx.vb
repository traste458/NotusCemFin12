Imports ILSBusinessLayer
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Enumerados

Partial Public Class AdministrarProveedor
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        epRegisterNotifier.clear()
        epFindNotifier.clear()
        Try
            If Not Me.IsPostBack Then
                epNotificador.setTitle("Creación, Búsqueda y Actualización de Proveedores")
                epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarListadoProveedores()
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

    Private Sub CargarListadoProveedores()
        Dim filtro As New FiltroGeneral
        CargarListadoProveedores(filtro)
    End Sub

    Private Sub CargarListadoProveedores(ByVal filtro As FiltroGeneral)
        Dim dtDatos As DataTable
        Try
            dtDatos = Proveedor.ObtenerListado(filtro)
            Dim dcEstado As New DataColumn("descEstado")
            dcEstado.Expression = "IIF(estado=1,'ACTIVO','INACTIVO')"
            dtDatos.Columns.Add(dcEstado)
            Session("dtListaProveedores") = dtDatos
            EnlazarListadoProveedores(dtDatos)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Proveedores. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarListadoProveedores(ByVal dtDatos As DataTable)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.Sort = "nombre asc"
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
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        LimpiarFormularioModificacion()
        mpeFormularioModificacion.Hide()
    End Sub

    Private Sub gvListado_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvListado.PageIndexChanging
        If Session("dtListaProveedores") IsNot Nothing Then
            gvListado.PageIndex = e.NewPageIndex
            Dim dtDatos As DataTable = CType(Session("dtListaProveedores"), DataTable)
            EnlazarListadoProveedores(dtDatos)
        Else
            epNotificador.showWarning("Imposible recuperar el listado de proveedores desde la memoria. Por favor genere el listado nuevamente.")
        End If

    End Sub

    Private Sub gvListado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvListado.RowCommand
        If e.CommandName = "actualizar" Then
            LimpiarFormularioModificacion()
            btnRegistrar.Visible = False
            btnActualizar.Visible = True
            trEstado.Visible = True
            Dim idProveedor As Integer = CInt(e.CommandArgument)
            Try
                CargarCiudades(ddlCiudad)
                Dim elProveedor As New Proveedor(idProveedor)
                With elProveedor
                    txtNombre.Text = .Nombre
                    txtDireccion.Text = .Direccion
                    txtTelefono.Text = .Telefono
                End With
                With ddlCiudad
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(elProveedor.IdCiudad))
                End With
                Dim idEstado As Byte = IIf(elProveedor.Activo, 1, 2)
                With ddlEstado
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(idEstado))
                End With
                hIdProveedor.Value = idProveedor.ToString
                btnActualizar.Focus()
                mpeFormularioModificacion.Show()
            Catch ex As Exception
                epRegisterNotifier.showError("Error al tratar de cargar datos del proveedor. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        LimpiarFormularioBusqueda()
        CargarCiudades(ddlBuscarCiudad)
        mpeFormularioBusqueda.Show()
    End Sub

    Protected Sub btnCancelarBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelarBuscar.Click
        LimpiarFormularioBusqueda()
        mpeFormularioBusqueda.Hide()
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Dim filtro As New FiltroGeneral
        If txtBuscarNombre.Text.Trim.Length > 0 Then filtro.Nombre = txtBuscarNombre.Text
        With ddlBuscarCiudad
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > 0 Then filtro.IdCiudad = CInt(.SelectedValue)
        End With
        With ddlBuscarEstado
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > -1 Then filtro.Activo = CInt(.SelectedValue)
        End With
        CargarListadoProveedores(filtro)
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim elProveedor As New Proveedor
        Dim resultado As Short
        Try
            With elProveedor
                .Nombre = txtNombre.Text.Trim
                .Direccion = txtDireccion.Text.Trim
                .Telefono = txtTelefono.Text.Trim
                .IdCiudad = CInt(ddlCiudad.SelectedValue)
                .IdCreador = IIf(Session("usxp001") IsNot Nothing, CInt(Session("usxp001")), 1)
                resultado = .Registrar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("El Proveedor fue registrado satisfactoriamente.")
                CargarListadoProveedores()
                LimpiarFormularioModificacion(False)
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("El Proveedor que está tratando de registrar ya existe. Por favor verifique")
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
        Dim elProveedor As New Proveedor
        Dim resultado As Short
        Try
            With elProveedor
                .IdProveedor = CInt(hIdProveedor.Value)
                .Nombre = txtNombre.Text.Trim
                .Direccion = txtDireccion.Text.Trim
                .Telefono = txtTelefono.Text.Trim
                .IdCiudad = CInt(ddlCiudad.SelectedValue)
                .Activo = IIf(ddlEstado.SelectedValue = "1", True, False)
                resultado = .Actualizar()
            End With
            If resultado = 0 Then
                epNotificador.showSuccess("La información fue actualizada satisfactoriamente.")
                CargarListadoProveedores()
                LimpiarFormularioModificacion()
            Else
                If resultado = 1 Then
                    epRegisterNotifier.showWarning("Ya existe otro proveedor con el nombre especificado. Por favor verifique")
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