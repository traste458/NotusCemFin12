
Partial Public Class Loader
    Inherits System.Web.UI.UserControl

    Public ReadOnly Property Dialogo() As EO.Web.Dialog
        Get
            Dim ctrl As Control = Me.FindControl("dlgWait")
            If ctrl IsNot Nothing Then
                Return CType(ctrl, EO.Web.Dialog)
            Else
                Return Nothing
            End If
        End Get
    End Property

End Class