Imports System.Data.SqlClient

Partial Class cambiarFacturaPostPago
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
        lblError.Text = ""
        hlRegresar.NavigateUrl = "../frames_back.asp?idmenu=" & Session("idmenu") & "&posicion=" & Session("posicion")
    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        With rblTipoCambio
            If .SelectedValue = 1 Then
                Server.Transfer("cambioPlan.aspx", True)
            Else
                If .SelectedValue = 2 Then
                    Server.Transfer("cambiodeFecha.aspx", True)
                Else
                    If .SelectedValue = 3 Then
                        Server.Transfer("elminarFacturaPostPago.aspx", True)
                    End If
                End If
            End If
        End With
    End Sub
End Class
