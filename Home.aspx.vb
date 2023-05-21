Imports System.Collections.Generic
Imports System.Linq
Imports System.Net.Http
Imports System.Text.RegularExpressions
Imports DevExpress.Web
Imports EncryptionClassLibrary.LMEncryption
Imports ILSBusinessLayer
Imports Newtonsoft.Json

Public Class Home
    Inherits System.Web.UI.Page

    Private Property InfoUsuario As Usuario
    Private Property IdSesion As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        IdSesion = Session.SessionID

        If Not Me.IsPostBack Then
            'Dim qs As String = Request.QueryString("is")
            'ValidarInformacionSesion(qs)
            InicializarDatosSesion()
            CargarMenu()
            MetodosComunes.CerrarSesiones(HttpContext.Current)
        End If
    End Sub

    Private Sub InicializarDatosSesion()
        Try
            InfoUsuario = New Usuario()
            Dim Random As New Random()
            Dim httpClient As New HttpClient
            Dim ip As String = MetodosComunes.ObtenerIpDeUsuario()
            If String.IsNullOrEmpty(ip) Then
                ip = "192.168.4." + Random.Next(1, 255).ToString
                Session("usxp014") = ip
            Else
                Session("usxp014") = ip
            End If

            'txtip.Text = ip
            infoIp1.InnerText = "IP: " & ip
            infoIp2.InnerText = "IP: " & ip

            With InfoUsuario

                If Session("usxp001") IsNot Nothing Then .IdUsuario = DirectCast(Session("usxp001"), Integer)
                If Session("usxp002") IsNot Nothing Then .Nombre = Session("usxp002").ToString()
                If Session("usxp003") IsNot Nothing Then .Cliente = Session("usxp003").ToString()
                If Session("usxp004") IsNot Nothing Then .Cargo = Session("usxp004").ToString()
                If Session("usxp005") IsNot Nothing Then .Ciudad = Session("usxp005").ToString()
                If Session("usxp006") IsNot Nothing Then .IdCargo = DirectCast(Session("usxp006"), Integer)
                If Session("usxp007") IsNot Nothing Then .IdCiudad = DirectCast(Session("usxp007"), Integer)
                If Session("usxp008") IsNot Nothing Then .IdCliente = DirectCast(Session("usxp008"), Integer)
                If Session("usxp009") IsNot Nothing Then .IdPerfil = DirectCast(Session("usxp009"), Integer)
                If Session("usxp010") IsNot Nothing Then .Linea = DirectCast(Session("usxp010"), Integer)
                If Session("usxp011") IsNot Nothing Then .NombrePerfil = Session("usxp011").ToString()
                If Session("usxp012") IsNot Nothing Then .IdBodega = DirectCast(Session("usxp012"), Integer)
                If Session("usxp013") IsNot Nothing Then .IdPerfil = DirectCast(Session("usxp013"), Integer)
                If Session("usxp014") IsNot Nothing Then .Mip = Session("usxp014")
                'lblUsuario.Text = InfoUsuario.Nombre & "(" & InfoUsuario.Cargo & ")"
                'lblFecha.Text = Now.ToString("yyyy-MM-dd hh:mm:ss")
                nombreUsuario1.InnerText = InfoUsuario.Nombre
                nombreUsuario2.InnerText = InfoUsuario.Nombre
                perfilUsuario1.InnerText = InfoUsuario.Cargo
                perfilUsuario2.InnerText = InfoUsuario.Cargo
                fechaSesion2.InnerText = Now.ToString("yyyy-MM-dd hh:mm:ss tt")

                Dim variables As String = .IdUsuario.ToString() & ",'" & .Nombre & "','" & .Cliente & "','" &
                                    "','" & .Cargo & "','" & .Ciudad & "'," & .IdCargo.ToString & "," & .IdCiudad.ToString &
                                    "," & .IdCliente.ToString & "," & .IdPerfil.ToString & "," & .Linea & ",'" &
                                    .NombrePerfil & "'," & .IdBodega.ToString() & "," & .IdPerfil.ToString

                Dim script As String = "ActualizarSesionesClasicas(" & variables & ");"

                Page.ClientScript.RegisterStartupScript(Page.GetType(), "ActualizarSesionesClasicas", script, True)

            End With
        Catch ex As Exception
            Session("mensajeError") = "Error al tratar de recuperar datos de sesión. " & ex.Message
            Response.Redirect("~/Login.aspx?err=true", False)
            Context.ApplicationInstance.CompleteRequest()
        End Try

    End Sub

    Private Sub CargarMenu()
        Try
            Dim menusPadre As List(Of MenuTop) = MenusHandler.ObtenerMenusTopPorPerfil(InfoUsuario.IdPerfil)

            If menusPadre IsNot Nothing AndAlso menusPadre.Count > 0 Then
                Dim listaMenus As List(Of MenuGeneral) = ObtenerListaMenusGenerales(True)

                rptMenu.DataSource = menusPadre
                rptMenu.DataBind()

            Else
                Session("mensajeError") = "No fue posible obtener el menú de opciones disponibles para el usuario. Por favor inicie sesión nuevamente"
                Response.Redirect("~/Login.aspx?err=true", False)
                Context.ApplicationInstance.CompleteRequest()
            End If

        Catch ex As Exception
            Session("mensajeError") = "Ocurrió un error al tratar de cargar menú. Por favor inicie sesión nuevamente"
            Response.Redirect("~/Login.aspx?err=true", False)
            Context.ApplicationInstance.CompleteRequest()
        End Try

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Try
            Dim idUsuario As Integer = 0
            Dim idMenu As Integer


            If (txtIrMenu.Text <> "") Then
                idMenu = txtIrMenu.Text

                If Session("usxp001") IsNot Nothing Then idUsuario = CInt(Session("usxp001").ToString)
                Dim url As String = MenusHandler.ObtenerUrlMenu(idMenu, idUsuario)
                If (url <> "") Then
                    frmMain.Attributes.Add("src", url)
                    txtIrMenu.Text = ""
                Else
                    ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>alert('El usuario no cuenta con permisos para ingresar a la opcion.');</script>", False)
                    txtIrMenu.Text = ""
                End If
            End If



        Catch ex As Exception

        End Try
    End Sub
    Private Sub ProcesarCambioPassword()
        'Try
        '    If (Session("usxp001") IsNot Nothing) Then
        '        Dim idUsuario As Integer = Integer.Parse(Session("usxp001").ToString())
        '        Dim passwordActual As String = EncryptionData.getMD5Hash(txtPasswordActual.Text)
        '        Dim nuevoPassword As String = EncryptionData.getMD5Hash(txtNuevoPassword.Text)

        '        Dim resultado As ResultadoProceso = UsuarioPasswordManager.CambiarPassword(idUsuario, passwordActual, nuevoPassword)

        '        cpCambioPassword.JSProperties("cpResultadoCambio") = resultado.Valor
        '        cpCambioPassword.JSProperties("cpMensajeCambio") = resultado.Mensaje

        '    Else
        '        Dim url As String = New System.Uri(Me.Request.Url, Me.ResolveUrl("~/Login.aspx")).AbsoluteUri
        '        url += "?errSess=true"
        '        Session("mensajeError") = "Error al tratar de cambiar Contraseña."
        '        ASPxWebControl.RedirectOnCallback(url)
        '    End If

        'Catch ex As Exception
        '    cpCambioPassword.JSProperties("cpMensajeError") = "Error al tratar de cambiar Contraseña. " & ex.Message
        'End Try
    End Sub

    Private Function ObtenerListaMenusGenerales(Optional ByVal forzarConsulta As Boolean = False) As List(Of MenuGeneral)
        Dim idUsuario As Integer = Integer.Parse(Session("usxp001").ToString)
        Dim listaMenus As New List(Of MenuGeneral)
        Dim nombreCache As String = "ListaMenus_" & IdSesion

        If (Page.Cache(nombreCache) Is Nothing OrElse forzarConsulta) Then
            listaMenus = MenusHandler.ObtenerMenuGeneralDeUsuario(idUsuario)
            Page.Cache(nombreCache) = listaMenus
        Else
            listaMenus = CType(Page.Cache(nombreCache), List(Of MenuGeneral))
        End If

        Return listaMenus

    End Function

    Protected Sub rptMenu_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptMenu.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim menuPadre As MenuTop = CType(e.Item.DataItem, MenuTop)
            Dim auxRepeater As Repeater = CType(e.Item.FindControl("rptMenusHijos"), Repeater)
            Dim listaMenus As List(Of MenuGeneral) = ObtenerListaMenusGenerales()
            Dim menusHijos As List(Of MenuGeneral) = listaMenus.Where(Function(m) m.IdPadre = menuPadre.IdMenu).ToList()

            auxRepeater.DataSource = menusHijos
            auxRepeater.DataBind()

        End If
    End Sub

    Private Sub cpCambioPassword_Callback(sender As Object, e As CallbackEventArgsBase) Handles cpCambioPassword.Callback
        Select Case e.Parameter
            Case "CambioPassword"
                'ProcesarCambioPassword()
                CambiarContrasena()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub CambiarContrasena()
        Dim validarContrasena As New ValidacionContrasena
        Dim modificarContrasena As New CambioContrasena
        Dim resultadoValidacion As String
        Dim InfoCambioPassword As New ValidacionAccesoLogin
        Dim encriptarContrasena As New EncryptionLibrary
        Dim regex As Regex = New Regex("\d+")
        Dim contrasenaEncriptadaNueva As String = EncryptionData.getMD5Hash(txtNuevoPassword.Text.Trim)
        Dim contrasenaEncriptadaVieja As String = EncryptionData.getMD5Hash(txtPasswordActual.Text.Trim)
        Dim identificacion As String
        With InfoCambioPassword
            .PasswordAntiguo = Session("contrasenaActual")
            .PasswordNuevo = txtPasswordActual.Text.Trim
            .ConfirmarPasswordNuevo = txtConfirmarPassword.Text.Trim
        End With
        If txtNuevoPassword.Text.Trim = txtConfirmarPassword.Text.Trim Then
            If modificarContrasena.ValidarUsuarioCambiar(Session("usxp001"), contrasenaEncriptadaVieja) Then
                resultadoValidacion = validarContrasena.validacionContrasena(txtNuevoPassword.Text.Trim.ToString, Session("usxp001"))
                If resultadoValidacion <> "" Then
                    cpCambioPassword.JSProperties("cpResultadoCambio") = 500
                    cpCambioPassword.JSProperties("cpMensajeCambio") = resultadoValidacion
                Else
                    identificacion = modificarContrasena.CambioContrasena(Session("usxp001"), contrasenaEncriptadaNueva)

                    cpCambioPassword.JSProperties("cpResultadoCambio") = 200
                    cpCambioPassword.JSProperties("cpMensajeCambio") = "Contraseña cambiada exitosamente"
                End If
            Else
                cpCambioPassword.JSProperties("cpResultadoCambio") = 500
                cpCambioPassword.JSProperties("cpMensajeCambio") = "La contraseña que desea cambiar no coincide con la que se tenía almacenada"
            End If
        Else
            cpCambioPassword.JSProperties("cpResultadoCambio") = 500
            cpCambioPassword.JSProperties("cpMensajeCambio") = "La contraseña nueva y la confirmación de la contraseña deben coincidir"
        End If
    End Sub
End Class