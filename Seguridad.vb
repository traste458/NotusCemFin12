Imports System.Web.HttpContext
Imports EncryptionClassLibrary
Imports System.IO
Imports EncryptionClassLibrary.LMEncryption

Public Class Seguridad

    Public Sub New()
    End Sub

    Public Shared Sub verificarSession(ByVal pagina As System.Web.UI.Page)
        Try

            If Not String.IsNullOrEmpty(pagina.Session("funcionalidadExterna")) Then

                Dim objEncryp As New LMEncryption.SymmetricEncryption(LMEncryption.SymmetricEncryption.Provider.TripleDES, True)

                Dim parametrosEncriptados As New EncryptionData
                parametrosEncriptados.Text = pagina.Session("funcionalidadExterna").ToString

                While parametrosEncriptados.Text.IndexOf("%") >= 0
                    parametrosEncriptados.Text = parametrosEncriptados.Text.Replace("%", " ")
                End While

                While parametrosEncriptados.Text.IndexOf("¬") >= 0
                    parametrosEncriptados.Text = parametrosEncriptados.Text.Replace("¬", Chr(9))
                End While

                Dim parametrosDesencriptados As New EncryptionData
                Dim parametros As String
                Dim arrParamentros As String()
                Dim key As New EncryptionData

                key.Text = "LogyEncrypt.12345"
                parametrosDesencriptados = objEncryp.Decrypt(parametrosEncriptados, key)
                parametros = parametrosDesencriptados.toString

                'parametros = parametrosEncriptados.Text
                arrParamentros = parametros.Split("¬")

                pagina.Session("usxp001") = arrParamentros(0)
                HttpContext.Current.Session("usxp001") = arrParamentros(0)
                pagina.Session("usxp009") = arrParamentros(1)
                HttpContext.Current.Session("usxp009") = arrParamentros(1)
                pagina.Session("usxp007") = arrParamentros(2)

            End If


#If DEBUG Then
            'pagina.Session("usxp001") = 22058 '22058 '22059
            'HttpContext.Current.Session("usxp001") = 22058 '22058 '22059
            'pagina.Session("usxp002") = "ADMINISTRADOR MENSAJERIA ESPECIALIZADA"
            'HttpContext.Current.Session("usxp002") = "ADMINISTRADOR MENSAJERIA ESPECIALIZADA"
            'pagina.Session("usxp009") = 118 '118
            'HttpContext.Current.Session("usxp009") = 118 '118
            'pagina.Session("usxp007") = 198
#End If
            'Solo valida la sesión si no se encuentra en modo Releases
            If pagina.IsCallback Then
                If pagina.Session("usxp001") Is Nothing Then
                    DevExpress.Web.ASPxWebControl.RedirectOnCallback("../login.asp")
                End If
            Else
#If Not DEBUG Then

            If pagina.Session("usxp001") Is Nothing OrElse pagina.Session("usxp001").ToString.Trim = "" Then
                Dim myScriptManager As ScriptManager = ScriptManager.GetCurrent(pagina)
                If myScriptManager Is Nothing OrElse (Not myScriptManager.IsInAsyncPostBack) Then
                    With pagina.Response
                        .Write("<SCRIPT LANGUAGE='JavaScript'>")
                        .Write("alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. Por favor ingrese de nuevo.');")
                        .Write("window.top.location.href= '../login.asp';")
                        .Write("</SCRIPT>")
                        .Redirect(pagina.ResolveUrl("~/login.asp?errSess=true"))
                    End With
                Else
                    Dim script As String = "alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. " & _
                        " Por favor ingrese de nuevo.');" & vbCrLf & "window.top.location.href= '../login.asp';"
                    myScriptManager.RegisterStartupScript(pagina, pagina.GetType, "validacionSeguridad", script, True)
                End If
            End If

#End If

            End If


        Catch tAbEx As System.Threading.ThreadAbortException
        Catch ex As Exception
            Throw New Exception("Error al tratar de validar Sesion 1. " & ex.Message)
        End Try
    End Sub

    Public Shared Sub ValidarSesion(Optional ByVal cp As EO.Web.CallbackPanel = Nothing)
        Dim pagina As Page = CType(HttpContext.Current.Handler, Page)

        If Not String.IsNullOrEmpty(pagina.Session("funcionalidadExterna")) Then

            Dim objEncryp As New LMEncryption.SymmetricEncryption(LMEncryption.SymmetricEncryption.Provider.TripleDES, True)

            Dim parametrosEncriptados As New EncryptionData
            parametrosEncriptados.Text = pagina.Session("funcionalidadExterna").ToString

            While parametrosEncriptados.Text.IndexOf("%") >= 0
                parametrosEncriptados.Text = parametrosEncriptados.Text.Replace("%", " ")
            End While

            While parametrosEncriptados.Text.IndexOf("¬") >= 0
                parametrosEncriptados.Text = parametrosEncriptados.Text.Replace("¬", Chr(9))
            End While

            Dim parametrosDesencriptados As New EncryptionData
            Dim parametros As String
            Dim arrParamentros As String()
            Dim key As New EncryptionData

            key.Text = "LogyEncrypt.12345"
            parametrosDesencriptados = objEncryp.Decrypt(parametrosEncriptados, key)
            parametros = parametrosDesencriptados.toString

            'parametros = parametrosEncriptados.Text
            arrParamentros = parametros.Split("¬")

            pagina.Session("usxp001") = arrParamentros(0)
            HttpContext.Current.Session("usxp001") = arrParamentros(0)
            pagina.Session("usxp009") = arrParamentros(1)
            HttpContext.Current.Session("usxp009") = arrParamentros(1)
            pagina.Session("usxp007") = arrParamentros(2)

        End If


#If DEBUG Then
        ''pagina.Session("usxp001") = 22058 '22059
        ''HttpContext.Current.Session("usxp001") = 22058 '22059
        ''pagina.Session("usxp009") = 118 '118
        ''HttpContext.Current.Session("usxp009") = 118 '118
        ''pagina.Session("usxp007") = 198
#End If

        Try
#If Not DEBUG Then
            If pagina.Session("usxp001") Is Nothing OrElse pagina.Session("usxp001").ToString.Trim = "" Then
                If cp IsNot Nothing AndAlso cp.IsCallback Then
                    Dim script As String = "alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. " & _
                                " Por favor ingrese de nuevo.');" & vbCrLf & "window.top.location.href= '../login.asp';"
                    cp.RenderScriptBlock("cerrarSesion", script, True)
                    cp.Redirect(pagina.ResolveUrl("~/login.asp"))
                Else
                    Dim myScriptManager As ScriptManager = ScriptManager.GetCurrent(pagina)
                    If myScriptManager Is Nothing OrElse (Not myScriptManager.IsInAsyncPostBack) Then
                        With pagina.Response
                            .Write("<SCRIPT LANGUAGE='JavaScript'>")
                            .Write("alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. Por favor ingrese de nuevo.');")
                            .Write("window.top.location.href= '../login.asp';")
                            .Write("</SCRIPT>")
                            .Redirect(pagina.ResolveUrl("~/login.asp?errSess=true"), False)
                        End With
                    Else
                        Dim script As String = "alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. " & _
                            " Por favor ingrese de nuevo.');" & vbCrLf & "window.top.location.href= '../login.asp';"
                        myScriptManager.RegisterStartupScript(pagina, pagina.GetType, "validacionSeguridad", script, True)
                    End If
                End If
            End If
#End If
        Catch tAbEx As System.Threading.ThreadAbortException
        Catch ex As Exception
            Throw New Exception("Error al tratar de validar Sesion. " & ex.Message)
        End Try
    End Sub

    Public Shared Sub verificarSession(ByVal pagina As System.Web.UI.Page, ByVal esCallBack As Boolean)
        Try

            If Not String.IsNullOrEmpty(pagina.Session("funcionalidadExterna")) Then

                Dim objEncryp As New LMEncryption.SymmetricEncryption(LMEncryption.SymmetricEncryption.Provider.TripleDES, True)

                Dim parametrosEncriptados As New EncryptionData
                parametrosEncriptados.Text = pagina.Session("funcionalidadExterna").ToString

                While parametrosEncriptados.Text.IndexOf("%") >= 0
                    parametrosEncriptados.Text = parametrosEncriptados.Text.Replace("%", " ")
                End While

                While parametrosEncriptados.Text.IndexOf("¬") >= 0
                    parametrosEncriptados.Text = parametrosEncriptados.Text.Replace("¬", Chr(9))
                End While

                Dim parametrosDesencriptados As New EncryptionData
                Dim parametros As String
                Dim arrParamentros As String()
                Dim key As New EncryptionData

                key.Text = "LogyEncrypt.12345"
                parametrosDesencriptados = objEncryp.Decrypt(parametrosEncriptados, key)
                parametros = parametrosDesencriptados.toString

                'parametros = parametrosEncriptados.Text
                arrParamentros = parametros.Split("¬")

                pagina.Session("usxp001") = arrParamentros(0)
                HttpContext.Current.Session("usxp001") = arrParamentros(0)
                pagina.Session("usxp009") = arrParamentros(1)
                HttpContext.Current.Session("usxp009") = arrParamentros(1)
                pagina.Session("usxp007") = arrParamentros(2)

            End If


#If DEBUG Then
            'pagina.Session("usxp001") = 22058 '22059
            'HttpContext.Current.Session("usxp001") = 22058 '22059
            'pagina.Session("usxp009") = 118 '118
            'HttpContext.Current.Session("usxp009") = 118 '118
            'pagina.Session("usxp007") = 198
#End If

#If Not DEBUG Then
            If Not esCallBack Then
                verificarSession(pagina)
            Else
                If pagina.Session("usxp001") Is Nothing OrElse pagina.Session("usxp001").ToString = "" Then
                    Anthem.Manager.Register(pagina)
                    Dim script As String
                    script = "<script language='javascript'>"
                    script += "alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. "
                    script += " Por favor ingrese de nuevo.');" & vbCrLf
                    script += "window.top.location.href= '../login.asp';" & vbCrLf
                    script += "</script>"
                    pagina.Session.Abandon()
                    Anthem.Manager.RegisterStartupScript(pagina.GetType, "finDeSesion", script)
                End If
            End If
#End If

        Catch ex As Exception
            Throw New Exception("Error al tratar validar Sesion. " & ex.Message)
        End Try
    End Sub
Public Shared Sub VerificarSessionInicio(ByVal pagina As System.Web.UI.Page)
        Try
            If pagina.Session("usxp001") Is Nothing OrElse pagina.Session("usxp001").ToString.Trim = "" Then

                Dim url As String = VirtualPathUtility.ToAbsolute("~/Login.aspx?errSess=true")

                If pagina.IsCallback Then
                    DevExpress.Web.ASPxWebControl.RedirectOnCallback(url)
                    Exit Sub
                Else
                    Dim myScriptManager As ScriptManager = ScriptManager.GetCurrent(pagina)
                    If myScriptManager Is Nothing OrElse (Not myScriptManager.IsInAsyncPostBack) Then
                        With pagina.Response
                            .Write("<SCRIPT LANGUAGE='JavaScript'>")
                            .Write("alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. Por favor ingrese de nuevo.');")
                            .Write("window.top.location.href= '" & url & "';")
                            .Write("</SCRIPT>")
                            .Redirect(url)
                        End With
                    Else
                        Dim script As String = "alert('ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. " &
                            " Por favor ingrese de nuevo.');" & vbCrLf & "window.top.location.href= '" & url & "';"
                        ScriptManager.RegisterStartupScript(pagina, pagina.GetType, "validacionSeguridad", script, True)
                    End If
                End If
            Else
                Dim sessionid As String = pagina.Session.SessionID

                If pagina.Cache(sessionid) Is Nothing Then
                    pagina.Cache(sessionid) = pagina.Session("usxp001")
                ElseIf pagina.Cache(sessionid & "2") Is Nothing And pagina.Cache(sessionid) <> pagina.Session("usxp001") Then
                    pagina.Cache(sessionid & "2") = pagina.Session("usxp001")
                End If
            End If

            '#End If

        Catch tAbEx As System.Threading.ThreadAbortException
        Catch ex As Exception
            DevExpress.Web.ASPxWebControl.RedirectOnCallback(VirtualPathUtility.ToAbsolute("~/Login.aspx?errSess=true"))
            Throw New Exception("Error al tratar de validar Sesion 1. " & ex.Message)
        End Try
    End Sub

End Class
