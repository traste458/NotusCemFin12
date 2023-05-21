Partial Class liberarSerial
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Seguridad.verificarSession(Me)
        hlRegresar.NavigateUrl = "../frames_back.asp?idmenu=" & Session("idmenu") & "&posicion=" & Session("posicion")
        lblError.Text = ""
        lblRes.Text = ""
        If Not Me.IsPostBack Then
            If Not Request.QueryString("resultado") Is Nothing Then
                lblRes.Text = "El Serial se Liberó satisfactoriamente.<br><br>"
            End If
        End If
    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        Dim url As String
        url = "liberarSerial2.aspx?serial=" & txtSerial.Text
        url += "&tipo=" & rblTipoSerial.SelectedValue
        Response.Redirect(url, True)
    End Sub
End Class
