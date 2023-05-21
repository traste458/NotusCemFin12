Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class RetransmintirRutaOfficetrack
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            With miEncabezado
                .setTitle("Retransmitir idRuta Officetrack")
            End With
        End If
    End Sub

    Private Sub cpPanel_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPanel.Callback
        Dim objruta As New RutaServicioMensajeria
        Dim respuesta As ResultadoProceso = objruta.RegitrarOfficeTrackIdRuta(CLng(txtidRuta.Text))
        If respuesta.Valor = 0 Then
            miEncabezado.showSuccess(respuesta.Mensaje)
        ElseIf respuesta.Valor = 10 Then
            miEncabezado.showWarning(respuesta.Mensaje)
        Else
            miEncabezado.showWarning(respuesta.Mensaje)
        End If
        cpPanel.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub


End Class