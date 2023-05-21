Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion

Partial Public Class CreaciondeClientes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        If Not IsPostBack Then
            If Request.QueryString("ok") IsNot Nothing Then epNotificador.showSuccess("Se ha creado el cliente satisfactoriamente")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            epNotificador.setTitle("Creación de Clientes")
            Try
                Me.CargaInicial()
            Catch ex As Exception
                epNotificador.showError("Error al tratar de cargar datos iniciales. " & ex.Message)
            End Try
        End If
    End Sub

    Private Sub CargaInicial()
        Dim dt As DataTable = InformacionRutaTransportadora.ObtenerTipoDestinatario()
        MetodosComunes.CargarDropDown(dt, CType(ddlCanal, DropDownList))
        dt = Ciudad.ObtenerCiudadesPorPais()
        MetodosComunes.CargarDropDown(dt, CType(ddlCiudad, DropDownList))

        Dim perfilAdm As String = MetodosComunes.seleccionarConfigValue("PERFILES_DEVOLUCIONES")
        Dim arrPerfilAdm As New ArrayList()
        If perfilAdm IsNot Nothing Then arrPerfilAdm.AddRange(perfilAdm.Split(","))

        If arrPerfilAdm IsNot Nothing AndAlso arrPerfilAdm.Contains(CInt(Session("usxp009"))) Then
            trDealer.Visible = False
            Dim liAux As ListItem = ddlCanal.Items.FindByValue(6)
            If liAux IsNot Nothing Then ddlCanal.Items.Remove(liAux)
        End If
    End Sub

    Protected Sub btnCliente_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCliente.Click
        Dim objCliente As New Cliente
        With objCliente
            .CodigoCliente = txtCodigoCliente.Text
            .Centro = txtCentro.Text
            .Almacen = txtAlmacen.Text
            .Nombre = txtNombreCliente.Text
            .Nit = txtNit.Text
            .IdTipoDestinatario = ddlCanal.SelectedValue
            .IdCiudad = ddlCiudad.Text
            .Direccion = txtDireccion.Text
            .Telefonos = txtTelefono.Text
            .Gerente = txtGerente.Text
            .Email = txtEmail.Text
            .Dealer = txtDealer.Text
        End With
        Try
            objCliente.Crear()
            Response.Redirect("CreaciondeClientes.aspx?ok=1", False)
        Catch ex As Exception
            If ex.Message = "1" Then
                epNotificador.showWarning("El Cliente ya existe")
            Else
                epNotificador.showError("Error al tratar de crear el cliente")
            End If
        End Try
    End Sub

    Private Sub ddlCiudad_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCiudad.SelectedIndexChanged
        If ddlCiudad.SelectedValue > 0 Then
            Dim objCiudad As New Ciudad(ddlCiudad.SelectedValue)
            lblRegion.Text = objCiudad.region
        Else
            lblRegion.Text = ""
        End If
    End Sub
End Class