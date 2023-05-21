Imports System.Threading
Imports EncryptionClassLibrary.LMEncryption
Imports ILSBusinessLayer
Imports Newtonsoft.Json

Public Class AuthController
    Inherits System.Web.UI.Page
    Private Property InfoUsuario As Usuario

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim qs As String = Request.QueryString("is")
            ValidarInformacionSesion(qs)
        Catch taEx As ThreadAbortException
        Catch ex As Exception
            Session("mensajeError") = "Error al tratar de recuperar datos de sesión. " & ex.Message
            Response.Redirect("~/Login.aspx?err=true", False)
        End Try
    End Sub

    Private Sub ValidarInformacionSesion(qs As String)
        Dim infoSesion As New InformacionSesion

        Try
            If Not String.IsNullOrEmpty(qs) Then
                Dim enc As New SymmetricEncryption(SymmetricEncryption.Provider.DES)
                Dim dataDesencriptar As New EncryptionData() With {.Base64 = Server.UrlDecode(qs)}

                enc.Key.Text = "3ncryt3rk3y"
                Dim datos As String = enc.Decrypt(dataDesencriptar).Text

                infoSesion = JsonConvert.DeserializeObject(Of InformacionSesion)(datos)

                If infoSesion IsNot Nothing AndAlso infoSesion.IdUsuario <> 0 Then
                    Me.InfoUsuario = New Usuario(infoSesion.IdUsuario)

                    If InfoUsuario IsNot Nothing AndAlso InfoUsuario.Registrado Then
                        If DateDiff(DateInterval.Minute, infoSesion.FechaSesion, Now) <= 20 Then

                            With InfoUsuario
                                Session("usxp001") = .IdUsuario
                                Session("usxp002") = .Nombre
                                Session("usxp003") = .Cliente
                                Session("usxp004") = .Cargo
                                Session("usxp005") = .Ciudad
                                Session("usxp006") = .IdCargo
                                Session("usxp007") = .IdCiudad
                                Session("usxp008") = .IdCliente
                                Session("usxp009") = .IdPerfil
                                Session("usxp010") = .Linea
                                Session("usxp011") = .NombrePerfil
                                Session("usxp012") = .IdBodega
                                Session("usxp013") = .IdPerfil
                                Session("usxp014") = .Mip
                            End With
                            's001: s1, s002: s2, s003: s3, s004: s4, s005: s5, s006: s6, s007: s7,
                            's008:                       s8, s009: s9, s010: s10, s011: s11, s012: s12, s013: s13
                            Try
                                If InfoUsuario.IdPerfil = 8 Then
                                    Dim param As String
                                    With InfoUsuario
                                        param = $"?s001={ .IdUsuario}&s002={ .Nombre}&s003={ .Cliente}&s004={ .Cargo}" &
                                            $"&s005={ .Ciudad}&s006={ .IdCargo}&s007={ .IdCiudad}&s008={ .IdCliente}" &
                                            $"&s009={ .IdPerfil}&s010={ .Linea}&s011={ .NombrePerfil}&s012={ .IdBodega}" &
                                            $"&s013={ .IdPerfil}&s014={ .Mip}&redirectTo=inventarios/frames.htm"
                                    End With
                                    Response.Redirect("~/ActualizaSesiones.asp" & param, True)
                                Else
                                    Response.Redirect("~/Home.aspx", True)
                                End If


                            Catch taEx As ThreadAbortException
                            End Try
                        Else
                            Session("mensajeError") = "Los datos de sesión recuperados ya no son válidos. Por favor autenticarse nuevamente"
                            Response.Redirect("~/Login.aspx?err=true", False)
                        End If
                    Else
                        Session("mensajeError") = "Imposible recuperar los datos del usuario. Por favor intente nuevamente"
                        Response.Redirect("~/Login.aspx?err=true", False)
                    End If
                Else
                    Session("mensajeError") = "Imposible recuperar los datos de la sesión de usuario. Por favor intente nuevamente"
                    Response.Redirect("~/Login.aspx?err=true", False)
                End If
            End If
        Catch taEx As ThreadAbortException
        Catch ex As Exception
            Session("mensajeError") = "Error al tratar de recuperar datos de sesión. " & ex.Message
            Response.Redirect("~/Login.aspx?err=true", False)
        End Try
    End Sub

End Class