Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion

Partial Public Class ActualizarClientes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            If Request.QueryString("ok") IsNot Nothing Then EncabezadoPagina1.showSuccess("Se ha creado el cliente satisfactoriamente")
            EncabezadoPagina1.showReturnLink("BuscarClientes.aspx")
            EncabezadoPagina1.setTitle("Actualización de Clientes")
            If Request.QueryString("idCliente") IsNot Nothing Then
                Me.CargaInicial(Request.QueryString("idCliente"))
            End If
        End If
    End Sub

    Private Sub CargaInicial(ByVal idCliente As Integer)
        Dim dt As DataTable = InformacionRutaTransportadora.ObtenerTipoDestinatario()
        MetodosComunes.CargarDropDown(dt, CType(ddlCanal, DropDownList))
        dt = Ciudad.ObtenerCiudadesPorPais()
        MetodosComunes.CargarDropDown(dt, CType(ddlCiudad, DropDownList))

        Dim obCliente As New Cliente(idCliente)
        Session("cliente") = obCliente
        With obCliente
            txtNombreCliente.Text = .Nombre
            txtNit.Text = .Nit
            ddlCanal.SelectedValue = .IdTipoDestinatario
            txtCodigoCliente.Text = .CodigoCliente
            txtCentro.Text = .Centro
            txtAlmacen.Text = .Almacen
            ddlCiudad.SelectedValue = .IdCiudad
            lblRegion.Text = .Region
            txtDireccion.Text = .Direccion
            txtTelefono.Text = .Telefonos
            txtGerente.Text = .Gerente
            txtEmail.Text = .Email
            txtDealer.Text = .Dealer
            If .Estado Then
                rdbActivo.Checked = True
            Else
                rdbInactivo.Checked = True
            End If
        End With

    End Sub

    Private Sub ddlCiudad_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCiudad.SelectedIndexChanged
        If ddlCiudad.SelectedValue > 0 Then
            Dim objCiudad As New Ciudad(ddlCiudad.SelectedValue)
            lblRegion.Text = objCiudad.Region
        Else
            lblRegion.Text = ""
        End If
    End Sub

    Protected Sub btnCliente_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCliente.Click
        Dim obCliente As Cliente = Session("cliente")
        With obCliente
            .Nombre = txtNombreCliente.Text.Trim
            .Nit = txtNit.Text.Trim
            .IdTipoDestinatario = ddlCanal.SelectedValue
            .CodigoCliente = txtCodigoCliente.Text.Trim
            .Centro = txtCentro.Text.Trim
            .Almacen = txtAlmacen.Text.Trim
            .IdCiudad = ddlCiudad.SelectedValue
            .Region = lblRegion.Text.Trim
            .Direccion = txtDireccion.Text.Trim
            .Telefonos = txtTelefono.Text.Trim
            .Gerente = txtGerente.Text.Trim
            .Email = txtEmail.Text.Trim
            .Estado = rdbActivo.Checked
            .Dealer = txtDealer.Text.Trim
        End With
        Try
            obCliente.Actualizar()
            Response.Redirect("BuscarClientes.aspx?ok=1", False)
        Catch ex As Exception
            EncabezadoPagina1.showError("Error al tratar de actualizar cliente. " & ex.Message)
        End Try

    End Sub

End Class