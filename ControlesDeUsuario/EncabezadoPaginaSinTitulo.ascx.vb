Partial Public Class EncabezadoPaginaSinTitulo
    Inherits System.Web.UI.UserControl

#Region "Eventos"

    Private Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init

    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub clear()
        lblError.Text = ""
        lblSuccess.Text = ""
        lblWarning.Text = ""
        lblError.Visible = False
        lblSuccess.Visible = False
        lblWarning.Visible = False
    End Sub

    Public Sub showError(ByVal message As String)
        lblError.Visible = True
        lblError.CssClass = "error"
        lblError.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub showWarning(ByVal message As String)
        lblWarning.Visible = True
        lblWarning.CssClass = "warning"
        lblWarning.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub showSuccess(ByVal message As String)
        lblSuccess.Visible = True
        lblSuccess.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Function RenderHtml() As String
        Dim sb As New System.Text.StringBuilder
        Dim sw As New System.IO.StringWriter(sb)
        Dim hw As New System.Web.UI.HtmlTextWriter(sw)
        Me.RenderControl(hw)

        Return sb.ToString
    End Function

#End Region

End Class