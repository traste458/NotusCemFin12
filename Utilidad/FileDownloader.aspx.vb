Public Partial Class FileDownloader
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Dim fileName As String = ""
            Dim filePath As String = ""

            If Request.QueryString("fileName") IsNot Nothing Then fileName = Server.UrlDecode(Request.QueryString("fileName"))
            If Request.QueryString("filePath") IsNot Nothing Then filePath = Server.UrlDecode(Request.QueryString("filePath"))

            If filePath.Length > 0 Then
                MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, filePath, fileName)
            End If
        End If
    End Sub

End Class