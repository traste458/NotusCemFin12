Imports System.Net
Imports System.IO

Public Class ASPSessionVar

    Dim oContext As HttpContext
    Dim ASPSessionVarASP As String

    Public Function GetSessionVar(ByVal ASPSessionVar As String) As String
        Dim ASPCookieName As New ArrayList
        Dim ASPCookieValue As New ArrayList
        If Not (GetSessionCookie(ASPCookieName, ASPCookieValue)) Then
            Return ""
        End If

        Dim myRequest As HttpWebRequest = CType(WebRequest.Create(ASPSessionVarASP + "?SessionVar=" + ASPSessionVar), HttpWebRequest)
        For index As Integer = 0 To ASPCookieName.Count - 1
            myRequest.Headers.Add("Cookie: " + ASPCookieName(index) + "=" + ASPCookieValue(index))
        Next

        Dim myResponse As HttpWebResponse = CType(myRequest.GetResponse(), HttpWebResponse)
        Dim receiveStream As Stream = myResponse.GetResponseStream()
        Dim encode As System.Text.Encoding = System.Text.Encoding.GetEncoding("utf-8")
        Dim readStream As StreamReader = New StreamReader(receiveStream, encode)
        Dim sResponse As String = readStream.ReadToEnd()

        myResponse.Close()
        readStream.Close()
        GetSessionVar = sResponse
    End Function

    Private Function GetSessionCookie(ByRef ASPCookieName As ArrayList, ByRef ASPCookieValue As ArrayList) As Boolean
        Dim hayCookies As Boolean = False
        For Each myCookie As String In oContext.Request.Cookies
            If myCookie.StartsWith("ASPSESSION") Then
                ASPCookieName.Add(myCookie)
                ASPCookieValue.Add(oContext.Request.Cookies(myCookie).Value)
                hayCookies = True
            End If
        Next
        Return hayCookies
    End Function

    Public Sub New(ByRef oInContext As HttpContext)
        Dim arregloAux(), urlAux As String
        oContext = oInContext
        ASPSessionVarASP = "servidorVariableSesionASP.asp"

        Dim oURL As System.Uri = oContext.Request.Url
        arregloAux = oURL.AbsolutePath.Split("/")
        If arregloAux.Length > 2 Then
            urlAux = oURL.Scheme & "://" & oURL.Host & ":" & oURL.Port.ToString & "/" & arregloAux(1)
        Else
            urlAux = oURL.Scheme & "://" & oURL.Host & ":" & oURL.Port.ToString
        End If
        ASPSessionVarASP = urlAux & "/" & ASPSessionVarASP
    End Sub

End Class