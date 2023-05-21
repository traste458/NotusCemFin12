Imports ILSBusinessLayer

Partial Public Class ReporteDeTransmisionesTransportadoras
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Seguridad.verificarSession(Me)
        epNotificador.clear()
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Reporte de Transmisiones")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
        End If
    End Sub

    Private Sub CargarListadoTransportadoras()

        Try

        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de transportadoras. " & ex.Message)
        End Try
    End Sub

End Class