Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class AutorizarTramitarMsisdnRepedito
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me, True)
            epNotificacion.clear()

            If Not IsPostBack Then
                epNotificacion.setTitle("Autorizar Tramitar MSISDN Repetido")
                epNotificacion.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub lbAutorizar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAutorizar.Click
        Autorizar()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub Autorizar()
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim resultado As ResultadoProceso = ServicioMensajeria.AutorizaMisdnRepetido(idUsuario, CLng(txtRadicado1.Text), CLng(txtRadicado2.Text))

            If resultado.Valor = 0 Then
                epNotificacion.showSuccess(resultado.Mensaje)
                txtRadicado1.Text = String.Empty
                txtRadicado2.Text = String.Empty
                txtRadicado1.Focus()
            Else
                epNotificacion.showWarning(resultado.Mensaje)
            End If

        Catch ex As Exception
            epNotificacion.showError("Se generó un erro al intentar realizar la autorización: " & ex.Message)
        End Try
    End Sub

#End Region

End Class