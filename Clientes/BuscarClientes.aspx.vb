Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion

Partial Public Class BuscarClientes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            If Request.QueryString("ok") IsNot Nothing Then EncabezadoPagina1.showSuccess("Se ha Actualizado el cliente satisfactoriamente")
            EncabezadoPagina1.setTitle("Consulta de Clientes")
            Me.CargaInicial()
        End If
    End Sub

    Private Sub CargaInicial()
        Dim dt As DataTable = InformacionRutaTransportadora.ObtenerTipoDestinatario()
        MetodosComunes.CargarDropDown(dt, CType(ddlCanal, DropDownList))
        dt = Ciudad.ObtenerCiudadesPorPais()
        MetodosComunes.CargarDropDown(dt, CType(ddlCiudad, DropDownList))
        dt = Region.ObtenerTodas()
        MetodosComunes.CargarDropDown(dt, CType(ddlRegion, DropDownList))
    End Sub

    Protected Sub btnCliente_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCliente.Click
        Dim filtro As New Cliente.FiltroCliente
        With filtro
            If txtNombreCliente.Text <> "" Then .cliente = txtNombreCliente.Text
            If txtNit.Text <> "" Then .nit = txtNit.Text
            If txtCodigoCliente.Text <> "" Then .CodigoCliente = txtCodigoCliente.Text
            If txtCentro.Text <> "" Then .centro = txtCentro.Text
            If txtAlmacen.Text <> "" Then .almacen = txtAlmacen.Text
            If ddlCanal.SelectedValue > 0 Then .idTipoDestinatario = ddlCanal.SelectedValue
            If ddlCiudad.SelectedValue > 0 Then .idCiudad = ddlCiudad.SelectedValue
            If ddlRegion.SelectedValue > 0 Then .idRegion = ddlRegion.SelectedValue
        End With

        Dim dt As DataTable = Cliente.Consultar(filtro)
        gvClientes.DataSource = dt
        gvClientes.DataBind()

    End Sub

    Private Sub gvClientes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvClientes.RowCommand
        If e.CommandName = "Editar" Then
            Response.Redirect("ActualizarClientes.aspx?idCliente=" & e.CommandArgument)
        End If
    End Sub
End Class