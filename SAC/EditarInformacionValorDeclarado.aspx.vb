Imports ILSBusinessLayer

Partial Public Class EditarInformacionValorDeclarado
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not Me.IsPostBack Then
            With miEncabezado
                .setTitle("Editar valor declarado de material")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub CargaInicial()
        Try
            MetodosComunes.CargarDropDown(AdministradorArchivos.ObtenerListadoCentros, ddlCentro, "Escoja un centro...")
            MetodosComunes.CargarDropDown(AdministradorArchivos.ObtenerListadoMaterialesCentro, ddlMaterial, "Escoja un material...")

            miEncabezado.showReturnLink(MetodosComunes.getUrlFrameBack(Me))

        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error recuperando información de centros y/o materiales: " & ex.Message)
        End Try
    End Sub


    Private Sub ddlCentro_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCentro.SelectedIndexChanged
        Try
            MetodosComunes.CargarDropDown(AdministradorArchivos.ObtenerListadoMaterialesCentro(ddlCentro.SelectedValue), ddlMaterial, "Escoja un material...")
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error filtrando información de materiales de centro: " & ex.Message)
        End Try
    End Sub

    Private Sub ddlMaterial_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMaterial.SelectedIndexChanged
        Dim valor As Integer
        Try
            txtValor.Text = AdministradorArchivos.ObtenerValorDeclaradoActual(ddlCentro.SelectedValue, ddlMaterial.SelectedValue)
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error recuperando información de valor declarado: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarCampos()
        CargaInicial()
        txtValor.Text = ""
    End Sub


    Protected Sub btnEditar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditar.Click
        Try
            AdministradorArchivos.EditarValorDeclarado(ddlCentro.SelectedValue, ddlMaterial.SelectedValue, CDbl(txtValor.Text))
            miEncabezado.showSuccess("Los datos se editaron correctamente")

            LimpiarCampos()

        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la edición de la información: " & ex.Message)
        End Try
    End Sub
End Class