Public Class ucViewReportDevExpress
    Inherits System.Web.UI.UserControl

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

#End Region

#Region "Propiedades"

    Public Property Reporte As DevExpress.XtraReports.UI.XtraReport
        Set(value As DevExpress.XtraReports.UI.XtraReport)
            rvReporte.Report = value
        End Set
        Get
            Return rvReporte.Report
        End Get
    End Property

#End Region

End Class