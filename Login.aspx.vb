Imports EncryptionClassLibrary.LMEncryption
Imports ILSBusinessLayer
Imports Newtonsoft.Json

Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then

            Dim resp As String = Session("recuperacionContrasena")

            Select Case resp
                Case 1
                    MostrarSuccessEnCliente("Recuperacion Contraseña", "El correo para la recuperación de contraseña ha sido enviado a la direccion de correo registrada")
                Case 2
                    MostrarErrorEnCliente("Recuperacion Contraseña", "El número de identificación que se encuentra ingresando no está registrada en el sistema")
                Case 3
                    MostrarErrorEnCliente("Recuperacion Contraseña", "Se espera un valor numerico con cédula")
                Case 4
                    MostrarSuccessEnCliente("Recuperacion Contraseña", "Cambio de contraseña exitoso")
                Case 6
                    MostrarErrorEnCliente("Recuperacion Contraseña", "El correo electrónico del usuario tiene un formato incorrecto")
                Case 7
                    MostrarErrorEnCliente("Recuperacion Contraseña", "La solicitud de recuperación de contraseña ha expirado, debe generar una nueva solicitud")
                Case Else
                    Session("recuperacionContrasena") = 5
            End Select

            Dim sessionid As String = Me.Session.SessionID

            If Request.QueryString("err") IsNot Nothing Then
                If Boolean.Parse(Request.QueryString("err").ToString()) Then
                    MostrarErrorEnCliente("Error..!", Session("mensajeError"))
                End If
            ElseIf Request.QueryString("errSess") IsNot Nothing Then
                If Request.QueryString("errSess").ToString() = "true" Then
                    ' textoError.Text = 
                    MostrarErrorEnCliente("Error..!", " Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. Por favor ingrese de nuevo.")
                ElseIf Request.QueryString("errSess").ToString() = "NuevoUser" Then
                    ' textoError.Text = 
                    MostrarErrorEnCliente("Error..!", "Acaba de iniciar Sesión con un usuario diferente, solo puede tener abierta la aplicación con un mismo usuario Cierre el explorador y ingrese nuevamente.")
                End If

            End If
            MetodosComunes.CerrarSesiones(HttpContext.Current)
        End If
    End Sub

    Protected Sub btnIngresar_Click(sender As Object, e As EventArgs) Handles btnIngresar.Click
        Dim usuario As String = txtUsuario.Value
        Dim pwd As String = EncryptionData.getMD5Hash(txtPassword.Value)
        Dim ip As String = MetodosComunes.ObtenerIpDeUsuario()
        Dim sessionId As String = Session.SessionID

        ValidarAutenticacionUsuario(pwd, usuario)
    End Sub

    Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs) Handles btnConfirmar.Click
        If captcha.IsValid Then
            pcCaptcha.ShowOnPageLoad = False
            Response.Redirect(Request.RawUrl)
        End If
    End Sub

    Protected Sub recuperarContrasena_VerifyingUser(sender As Object, e As EventArgs)
        Dim recuperacion As New RecuperarContrasena

        Dim resulRecuperacion As Integer = recuperacion.recuperacionContrasena(recuperarContrasena.UserName)

        If resulRecuperacion = 1 Then
            PopRecuperarContrasena.ShowOnPageLoad = False
            Session("recuperacionContrasena") = 1
            Response.Redirect(Request.RawUrl)
        ElseIf resulRecuperacion = 6 Then
            Session("recuperacionContrasena") = 6
            Response.Redirect(Request.RawUrl)
        Else
            Session("recuperacionContrasena") = 2
            Response.Redirect(Request.RawUrl)
        End If
    End Sub

    Private Sub MostrarErrorEnCliente(titulo As String, mensaje As String)
        Dim script As String = $"MostrarError('{titulo}','{mensaje}');"

        Page.ClientScript.RegisterStartupScript(Page.GetType(), "MostrarMensajeError", script, True)
    End Sub

    Private Sub MostrarSuccessEnCliente(titulo As String, mensaje As String)
        Dim script As String = $"MostrarSuccess('{titulo}','{mensaje}');"

        Page.ClientScript.RegisterStartupScript(Page.GetType(), "MostrarMensajeSuccess", script, True)
    End Sub

    Private Sub ValidarAutenticacionUsuario(password As String, usuario As String)
        Dim infoAutenticacion As New ValidacionAccesoLogin
        Dim encriptarContrasna As New EncryptionLibrary
        Dim numeroIngresos As Integer
        Dim identificacion As String = 0
        Dim PerfilExterno As Integer = 0

        Try

            Dim ip As String = MetodosComunes.ObtenerIpDeUsuario()
            Dim infoUsuario As Usuario = AutenticadorUsuario.AutenticarCredenciales(usuario, password, ip)

            If infoUsuario IsNot Nothing AndAlso infoUsuario.Registrado Then

                Dim url As String = GenerarUrlRedireccion(infoUsuario.PoolAplicacion)
                Dim ub As New UriBuilder(url)
                Dim qsp As Specialized.NameValueCollection = HttpUtility.ParseQueryString(String.Empty)

                Dim qs As String = GenerarQuerystring(infoUsuario)

                qsp("is") = qs

                ub.Query = qsp.ToString

                Response.Redirect(ub.ToString(), False)
                Context.ApplicationInstance.CompleteRequest()
            Else

                numeroIngresos = infoAutenticacion.ValidarcantidadIngresos(usuario)

                Select Case numeroIngresos
                    Case 1
                        MostrarErrorEnCliente("Autenticación Fallida..!", "El usuario y la contraseña no coinciden, por favor intentar nuevamente")
                    Case 2
                        form1.Attributes("class") = form1.Attributes("class").Replace("validate-form", "").Trim()
                        pcCaptcha.ShowOnPageLoad = True
                    Case 3
                        MostrarErrorEnCliente("Autenticación Fallida..!", "Si vuelve a tener un ingreso fallido su usuario será bloqueado")
                    Case 4
                        If infoAutenticacion.BolqueoDeUsuarioPorIntentosFallidos(usuario) Then
                            infoAutenticacion.NotificacionUsuarioBloqueoPorIntentosFallidos(usuario)
                            MostrarErrorEnCliente("Autenticación Fallida..!", "Se ha detectado un movimiento extraño con su usuario, por lo que debe realizar la recuperación de la contraseña")
                        End If

                    Case 5
                        MostrarErrorEnCliente("Autenticación Fallida..!", "El usuario y la contraseña no coinciden, por favor intentar nuevamente")
                    Case Else
                        MostrarErrorEnCliente("Autenticación Fallida..!", "El usuario y la contraseña no coinciden o no se encuentra regisrado, por favor intentar nuevamente")
                End Select
            End If

            'End If
        Catch ex As Exception

        End Try
    End Sub

    Private Function GenerarUrlRedireccion(poolAplicacionUsuario As String) As String
        Dim url As String = ""
        Dim cambiarPool As Boolean = False

        Try
            Dim host As String = Request.Headers("Host")
            Dim contienePuerto As Boolean = host.Contains(":")
            Dim baseUrl As String = Page.Request.Url.Scheme & "://" & IIf(contienePuerto, Request.Url.Authority, Request.Url.Host)

            Dim serverName As String = Request.ServerVariables("SERVER_NAME").ToString()
            Dim auxUrl As String = Request.ServerVariables("URL").ToString()
            cambiarPool = IIf(String.IsNullOrEmpty(poolAplicacionUsuario), False, Not auxUrl.Contains(poolAplicacionUsuario))

            Dim dominio As String = ConfigurationManager.AppSettings("dominio").ToString

            If Not String.IsNullOrEmpty(dominio) Then
                If Not serverName.Contains("localhost") Then
                    baseUrl = baseUrl.Replace("http://", "https://")
                    Dim ipGateway As String = ConfigurationManager.AppSettings("ipGateway").ToString
                    Dim ipRemota As String = Request.ServerVariables("REMOTE_ADDR").ToString
                    Dim protocolo As String = "https"

                    If ipRemota <> ipGateway And Not serverName.Contains(dominio) Then

                        If Request.ServerVariables("HTTPS").ToString.ToUpper <> "OFF" Then
                            protocolo = "https"
                        End If

                        If contienePuerto Then
                            Dim puerto As String = Request.ServerVariables("SERVER_PORT").ToString
                            If (Not String.IsNullOrEmpty(puerto)) Then
                                puerto = ":" & puerto
                            End If

                            baseUrl = protocolo & "://" & serverName & "." & dominio & puerto
                        Else
                            baseUrl = protocolo & "://" & serverName & "." & dominio
                        End If
                    End If
                End If
            End If

            If cambiarPool Then
                url = baseUrl.TrimEnd("/") & "/" & poolAplicacionUsuario.TrimEnd("/") & "/AuthController.aspx"
            Else
                If (Page.Request.Url.Segments.Length > 2) Then
                    url = baseUrl.TrimEnd("/") & "/" & Page.Request.Url.Segments(1).TrimEnd("/") & "/AuthController.aspx"
                Else
                    url = baseUrl.TrimEnd("/") & "/AuthController.aspx"
                End If
            End If
        Catch ex As Exception
            If cambiarPool Then
                url = New Uri(Page.Request.Url, Page.ResolveUrl("~/" & poolAplicacionUsuario & "/AuthController.aspx")).AbsoluteUri
            Else
                url = New Uri(Page.Request.Url, Page.ResolveUrl("~/AuthController.aspx")).AbsoluteUri
            End If
        End Try

        Return url
    End Function

    Private Function GenerarQuerystring(infoUsuario As Usuario) As String
        Dim enc As New SymmetricEncryption(SymmetricEncryption.Provider.DES)
        Dim infoSesion As New InformacionSesion With {
            .IdUsuario = infoUsuario.IdUsuario,
            .FechaSesion = Now
        }

        Dim dataEncriptar As New EncryptionData()
        enc.Key.Text = "3ncryt3rk3y"

        dataEncriptar.Text = JsonConvert.SerializeObject(infoSesion)

        Dim datosEncriptados As String = enc.Encrypt(dataEncriptar).Base64
        Dim qs As String = Server.UrlEncode(datosEncriptados)

        Return qs
    End Function

    Protected Sub lbRecuperarContrasena_Click(sender As Object, e As EventArgs) Handles lbRecuperarContrasena.Click
        PopRecuperarContrasena.ShowOnPageLoad = True
    End Sub
End Class