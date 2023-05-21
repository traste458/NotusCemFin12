Imports ILSBusinessLayer

Partial Public Class EditarInformacionRutaTransportadora
    Inherits System.Web.UI.Page

    Dim miInfoRuta As InformacionRutaTransportadora

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)

        miEncabezado.clear()

        If Not Me.IsPostBack Then
            With miEncabezado
                .setTitle("Editar información de transportadoras")
            End With
            CargaInicial()
        Else
            miInfoRuta = Session("miInfoRuta")
        End If
    End Sub

    Private Sub CargaInicial()
        Try
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerCiudadesOrigen, ddlCiudadOrigen, "Escoger ciudad de origen")
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerCiudadesDestino, ddlCiudadDestino, "Escoger ciudad de destino")
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerTransportadoras, ddlTransportadora, "Escoger transportadora")
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerTipoProducto, ddlTipoProducto, "Escoger tipo de producto")
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerTipoDestinatario, ddlTipoDestinatario, "Escoger tipo de destinatario")
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerTipoTransporte, ddlTipoTransporte, "Escoger tipo de transporte")

            If miInfoRuta IsNot Nothing Then
                ddlCiudadOrigen.SelectedValue = miInfoRuta.IdCiudadOrigen
                ddlCiudadDestino.SelectedValue = miInfoRuta.IdCiudadDestino
                ddlTipoDestinatario.SelectedValue = miInfoRuta.IdTipoDestinatario
                ddlTipoProducto.SelectedValue = miInfoRuta.IdTipoProducto
                ddlTipoTransporte.SelectedValue = miInfoRuta.IdTipoTransporte
                ddlTransportadora.SelectedValue = miInfoRuta.IdTransportadora
                txtCodigo.Text = miInfoRuta.Codigo
            End If

            miEncabezado.showReturnLink(MetodosComunes.getUrlFrameBack(Me))

        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la carga de información inicial: " & ex.Message)
        End Try
    End Sub

    Protected Sub ddlCiudadOrigen_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlCiudadOrigen.SelectedIndexChanged
        Try
            MetodosComunes.CargarDropDown(InformacionRutaTransportadora.ObtenerCiudadesDestino(ddlCiudadOrigen.SelectedValue), ddlCiudadDestino, "Escoger ciudad de destino")
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la carga de ciudades destino: " & ex.Message)
        End Try
    End Sub

    Protected Sub ddlCiudadDestino_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlCiudadDestino.SelectedIndexChanged
        Try
            miInfoRuta = New InformacionRutaTransportadora(ddlCiudadOrigen.SelectedValue, ddlCiudadDestino.SelectedValue)
            Session("miInfoRuta") = miInfoRuta

            ddlTipoDestinatario.SelectedValue = miInfoRuta.IdTipoDestinatario
            ddlTipoProducto.SelectedValue = miInfoRuta.IdTipoProducto
            ddlTipoTransporte.SelectedValue = miInfoRuta.IdTipoTransporte
            ddlTransportadora.SelectedValue = miInfoRuta.IdTransportadora
            txtCodigo.Text = miInfoRuta.Codigo
            ddlCiudadOrigen.Enabled = False
            ddlCiudadDestino.Enabled = False
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la carga de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarCampos()
        Session("miInfoRuta") = Nothing
        miInfoRuta = Nothing
        ddlCiudadOrigen.Enabled = True
        ddlCiudadDestino.Enabled = True
        CargaInicial()
        txtCodigo.Text = ""
    End Sub

    Protected Sub btnEditar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditar.Click
        Try
            miInfoRuta.Codigo = txtCodigo.Text.Trim
            miInfoRuta.IdTipoDestinatario = ddlTipoDestinatario.SelectedValue
            miInfoRuta.IdTipoProducto = ddlTipoProducto.SelectedValue
            miInfoRuta.IdTipoTransporte = ddlTipoTransporte.SelectedValue
            miInfoRuta.IdTransportadora = ddlTransportadora.SelectedValue

            miInfoRuta.EditarDatoRutaTransportadora()

            miEncabezado.showSuccess("Los datos fueron editados correctamente")
            LimpiarCampos()
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la edición de la información: " & ex.Message)
        End Try
    End Sub
End Class