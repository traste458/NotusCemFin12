Partial Public Class EncabezadoPagina
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
        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('" & message.Trim & "', 'rojo')", True)

        lblError.Visible = True
        lblError.CssClass = "error"
        lblError.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub showWarning(ByVal message As String)
        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "advertencia", "alert('" & message.Trim & "', 'amarillo')", True)
        lblWarning.Visible = True
        lblWarning.CssClass = "warning"
        lblWarning.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub showSuccess(ByVal message As String)
        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "exito", "alert('" & message.Trim & "', 'verde')", True)
        lblSuccess.Visible = True
        lblSuccess.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub showInfo(ByVal message As String)
        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "informativo", "alert('" & message.Trim & "', 'azul')", True)
    End Sub

    Public Sub setTitle(ByVal title As String)
        lblTitle.Visible = True
        lblTitle.Text = title.Trim
        ltDivision.Visible = True
    End Sub

    Public Sub showReturnLink(ByVal url As String)
        hlRegresar.NavigateUrl = Me.Page.ResolveUrl(url)
        pnlRegresar.Visible = True
    End Sub

    Public Sub hideReturnLink()
        pnlRegresar.Visible = False
    End Sub

    Public Function RenderHtml() As String
        Dim sb As New System.Text.StringBuilder
        Dim sw As New System.IO.StringWriter(sb)
        Dim hw As New System.Web.UI.HtmlTextWriter(sw)
        Me.RenderControl(hw)

        Return sb.ToString
    End Function

    Public Function getTitle() As String
        Return lblTitle.Text.Trim
    End Function

    Public Function GetReturnUrl() As String
        Return hlRegresar.NavigateUrl
    End Function

#End Region

End Class