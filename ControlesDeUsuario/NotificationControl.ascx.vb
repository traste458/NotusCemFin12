Public Partial Class NotificationControl
    Inherits System.Web.UI.UserControl

#Region "Controles con ámbito modificado"
    ''' <summary>
    ''' La declaración de los controles se mueve al Code-Behind porque es necesario cambiar el modificador de
    ''' ámbito y si se deja en el Designer, la modificación realizada es borrada por éste último
    ''' </summary>
    ''' <remarks>El modificador de ámbito establecido es "Friend", con el fin de poder manipular
    ''' los controles agregados a la clase, desde la página en la que recide el control de usuario</remarks>

    Protected Friend WithEvents lblTitle As Global.System.Web.UI.WebControls.Label
    Protected Friend WithEvents lblErrorNotifier As Global.System.Web.UI.WebControls.Label
    Protected Friend WithEvents lblSuccessNotifier As Global.System.Web.UI.WebControls.Label
    Protected Friend WithEvents hlRegresar As Global.System.Web.UI.WebControls.HyperLink
    Protected Friend WithEvents pnlRegresar As Global.System.Web.UI.WebControls.Panel

#End Region

    Public Sub Clear()
        lblError.Text = ""
        lblSuccess.Text = ""
        lblWarning.Text = ""
        lblError.Visible = False
        lblSuccess.Visible = False
        lblWarning.Visible = False
    End Sub

    Public Sub MostrarError(ByVal message As String)
        lblError.Visible = True
        lblError.CssClass = "error"
        lblError.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub MostrarAlerta(ByVal message As String)
        lblWarning.Visible = True
        lblWarning.CssClass = "warning"
        lblWarning.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub MostrarOK(ByVal message As String)
        lblSuccess.Visible = True
        lblSuccess.Text = "<ul><li>&nbsp;" & message.Trim & "</li></ul>"
    End Sub

    Public Sub SetTitle(ByVal title As String)
        lblTitle.Visible = True
        lblTitle.Text = title.Trim
        ltDivision.Visible = True
    End Sub

    Public Function GetTitle() As String
        Return lblTitle.Text.Trim
    End Function

    Public Sub ShowReturnLink(ByVal url As String)
        hlRegresar.NavigateUrl = Me.Page.ResolveUrl(url)
        pnlRegresar.Visible = True
    End Sub

    Public Function GetReturnUrl() As String
        Return hlRegresar.NavigateUrl
    End Function

    Public Sub HideReturnLink()
        pnlRegresar.Visible = False
    End Sub

End Class