Public Class VisorImpresionServicioSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Long

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("id") IsNot Nothing AndAlso Request.QueryString("id").Length > 0 Then
            _idServicio = CLng(Request.QueryString("id"))

            Dim rptReporteServicioSiembra As New InformacionServicioSiembra
            rptReporteServicioSiembra.EstablecerParemetro(_idServicio)

            vsReporte.Reporte = rptReporteServicioSiembra
        End If
    End Sub

#End Region

End Class