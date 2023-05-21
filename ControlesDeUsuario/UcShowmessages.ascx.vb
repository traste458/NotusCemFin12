Public Class UcShowmessages
    Inherits System.Web.UI.UserControl

#Region "Propiedades"
    Public Event BtSiClick As EventHandler
    Public Event BtNoClick As EventHandler

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub



    Public Sub MensajeSiNo(ByVal Titulo As String, ByVal Mensaje As String, ByVal Acccion As String)
        PanelContSiNo1.Visible = True
        pcUcShowmessages1.HeaderText = Titulo
        lblMensaje1.Text = Mensaje
        lblAccion1.Text = Acccion
        pcUcShowmessages1.ShowOnPageLoad = True

    End Sub

    Public Sub MensajeAceptar(ByVal titulo As String, ByVal mensaje As String)
        PanelContAceptar1.Visible = True
        pcUcShowmessages1.HeaderText = titulo
        lblMensaje1.Text = mensaje
        pcUcShowmessages1.ShowOnPageLoad = True

    End Sub
    Public Sub Cerrar()
        Try

            pcUcShowmessages1.ShowOnPageLoad = False

        Catch ex As Exception
            Throw New Exception(String.Format("", ex.Message), ex)

        End Try

    End Sub


    Private Sub BtonSiClick(ByVal sender As Object, ByVal e As EventArgs) Handles btSi.Click

        ' Desencadenamos el evento
        RaiseEvent BtSiClick(sender, e)

    End Sub

    Private Sub BtonNoClick(ByVal sender As Object, ByVal e As EventArgs) Handles btNO.Click

        ' Desencadenamos el evento
        RaiseEvent BtNoClick(sender, e)

    End Sub


End Class