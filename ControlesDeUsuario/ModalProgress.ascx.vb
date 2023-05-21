Public Partial Class ModalProgress
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub mostrar()
        ModalProgress.Show()
    End Sub

    Public Sub ocultar()
        ModalProgress.Hide()
    End Sub

End Class