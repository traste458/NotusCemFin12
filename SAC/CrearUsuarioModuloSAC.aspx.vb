Imports ARBusinessLayer
Imports ARBusinessLayer.SAC
Imports ILSBusinessLayer.SAC
Imports ILSBusinessLayer
Partial Public Class CrearUsuarioModuloSAC
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epGeneral.clear()
        If Not Me.IsPostBack Then
            epGeneral.setTitle("Crear Usuario de Módulo SAC")
        End If

    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGuardar.Click
        Try
            Dim miUsuario As New UsuarioModuloSAC
            Dim resultado As New ResultadoProceso
            With miUsuario
                .Nombre = txtNombre.Text.Trim
                .EMail = txtEmail.Text.Trim
                resultado = .Registrar()
                If resultado.Valor = 0 Then
                    epGeneral.showSuccess("El usuario se registro satisfactoriamente")
                    LimpiarCampos()
                Else
                    If resultado.Valor = 1 Then
                        epGeneral.showWarning(resultado.Mensaje)
                    Else
                        epGeneral.showError(resultado.Mensaje)
                    End If
                End If
            End With
        Catch ex As Exception
            epGeneral.showError("Error al tratar de registrar datos de usuario. " & ex.Message)
        End Try
    End Sub

    Public Sub LimpiarCampos()
        txtNombre.Text = ""
        txtEmail.Text = ""
    End Sub
End Class