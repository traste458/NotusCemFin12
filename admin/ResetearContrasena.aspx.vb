Imports System.Text.RegularExpressions
Imports EncryptionClassLibrary.LMEncryption
Imports ILSBusinessLayer

Public Class ResetearContrasena
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            miEncabezado.clear()
            If Not Me.IsPostBack Then
                If Not String.IsNullOrEmpty(Request.QueryString("token")) Then
                    Dim token As String = Request.QueryString("token")

                    With miEncabezado
                        .setTitle("Cambiar Contraseña")
                    End With

                    Dim minimaLongitud As Comunes.ConfigValues = New Comunes.ConfigValues("minLongitud")

                    lblMessage.Text = "Su contraseña debe contener al menos:" & minimaLongitud.ConfigKeyValue.ToString & " caracteres"

                    Session.Remove("contrasenaActual")
                    Session.Remove("idUsuario")
                    Session.Remove("recuperacionContrasena")

                    ValidarToken(token)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la página: " & ex.Message)
        End Try

    End Sub

    Private Function ValidarToken(token As String) As Boolean
        Dim recuperacion As New RecuperacionContrasena
        Dim tokenValido As Integer

        With recuperacion
            tokenValido = .ValidarContrasena(token)
            Session("contrasenaActual") = .ContrasenaActual
            Session("idUsuario") = .IdUsuario
        End With

        If tokenValido = 0 Then
            Session("recuperacionContrasena") = 7
            Response.Redirect("~/Login.aspx", False)
        End If

    End Function

    Protected Sub btnContrasena_Click(sender As Object, e As EventArgs) Handles btnContrasena.Click
        Dim validarContrasena As New ValidacionContrasena
        Dim modificarContrasena As New CambioContrasena
        Dim resultadoValidacion As String
        Dim InfoCambioPassword As New ValidacionAccesoLogin
        Dim encriptarContrasena As New EncryptionLibrary
        Dim regex As Regex = New Regex("\d+")
        Dim contrasenaEncriptadaNueva As String = EncryptionData.getMD5Hash(txtNuevaContrasena.Text.Trim)
        Dim contrasenaEncriptadaVieja As String = Session("contrasenaActual") 'EncryptionData.getMD5Hash(CambioContrasena.CurrentPassword.Trim)
        Dim identificacion As String
        With InfoCambioPassword
            .PasswordAntiguo = Session("contrasenaActual")
            .PasswordNuevo = txtNuevaContrasena.Text.Trim
            .ConfirmarPasswordNuevo = txtConfirmarContrasena.Text.Trim
        End With
        If txtNuevaContrasena.Text.Trim = txtConfirmarContrasena.Text.Trim Then
            If modificarContrasena.ValidarUsuarioCambiar(Session("idUsuario"), contrasenaEncriptadaVieja) Then
                resultadoValidacion = validarContrasena.validacionContrasena(txtNuevaContrasena.Text.Trim.ToString, Session("idUsuario"))
                If resultadoValidacion <> "" Then
                    miEncabezado.showError(resultadoValidacion)
                Else
                    identificacion = modificarContrasena.CambioContrasena(Session("idUsuario"), contrasenaEncriptadaNueva)

                    Session("recuperacionContrasena") = 4
                    Response.Redirect("~/Login.aspx")
                End If
            Else
                miEncabezado.showError("La contraseña que desea cambiar no coincide con la que se tenía almacenada")
            End If
        Else
            miEncabezado.showError("La contraseña nueva y la confirmación de la contraseña deben coincidir")
        End If
    End Sub
End Class