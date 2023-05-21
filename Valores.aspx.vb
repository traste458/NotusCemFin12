Public Class Valores
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.VerificarSessionInicio(Me)
    End Sub

End Class