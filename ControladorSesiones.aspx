<%@ Page Language="vb" AutoEventWireup="false" %>
<%
    Dim idMenu, posicion, url As String
    Try
        If Not Request.QueryString("sASP") Is Nothing AndAlso Request.QueryString("sASP") <> "" Then
            Dim arrSesionesASP() As String
            arrSesionesASP = Request.QueryString("sASP").Split(";")
            Session("usxp001") = arrSesionesASP(0)
            Session("usxp002") = arrSesionesASP(1)
            Session("usxp003") = arrSesionesASP(2)
            Session("usxp004") = arrSesionesASP(3)
            Session("usxp005") = arrSesionesASP(4)
            Session("usxp006") = arrSesionesASP(5)
            Session("usxp007") = arrSesionesASP(6)
            Session("usxp008") = arrSesionesASP(7)
            Session("usxp009") = arrSesionesASP(8)
            Session("usxp0010") = arrSesionesASP(9)
            Session("usxp0012") = arrSesionesASP(10)
            Session("usxp0013") = arrSesionesASP(8)
        End If
        Dim key As String, arrKeys As New ArrayList, arrSessionEliminar As New ArrayList
        For index As Integer = 1 To 13
            arrKeys.Add("usxp" & String.Format("{0:000}", index))
        Next
        For Each key In Session.Keys
            If arrKeys.IndexOf(key) = -1 Then arrSessionEliminar.Add(key)
        Next
        If arrSessionEliminar.Count <> 0 Then
            For index As Integer = 0 To arrSessionEliminar.Count - 1
                Session.Remove(arrSessionEliminar(index).ToString)
            Next
        End If
        If Not Request.QueryString("toFormGo") Is Nothing AndAlso Request.QueryString("toFormGo") <> "" Then
            idMenu = Request.Form("idmenu")
            url = "framesGo.asp?idmenu=" & idMenu
        Else
            idMenu = Request.QueryString("idmenu")
            posicion = Request.QueryString("posicion")
            Session("idmenu") = idMenu
            Session("posicion") = posicion
            url = "frames_back.asp?idmenu=" & idMenu & "&posicion=" & posicion & "&control=1"
        End If
    Finally
        GC.Collect()
    End Try
    Response.Redirect(url)
%>
