Public Partial Class MensajeModal
    Inherits System.Web.UI.UserControl

    Public Sub showError(ByVal message As String)
        imgMensajeInfo.ImageUrl = "~/images/errorMsg.png"
        lblMensajeInfo.Text = message
        mpeControlMensajeInfo.Show()
    End Sub

    Public Sub showWarning(ByVal message As String)
        imgMensajeInfo.ImageUrl = "~/images/alertMsg.png"
        lblMensajeInfo.Text = message
        mpeControlMensajeInfo.Show()
    End Sub

    Public Sub showSuccess(ByVal message As String)
        imgMensajeInfo.ImageUrl = "~/images/infoMsg.png"
        lblMensajeInfo.Text = message
        mpeControlMensajeInfo.Show()
    End Sub

    Protected Sub btnAceptarMensajeInfo_Click(ByVal sender As Object, ByVal e As EventArgs)
        mpeControlMensajeInfo.Hide()
    End Sub
End Class