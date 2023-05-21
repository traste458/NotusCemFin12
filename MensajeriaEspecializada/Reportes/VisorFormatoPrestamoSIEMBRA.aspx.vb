Public Class VisorFormatoPrestamoSIEMBRA
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Long
    Private _reImpresion As Boolean

#End Region

#Region "Propiedades"

    Public Property IdServicio As Long
        Get
            Return _idServicio
        End Get
        Set(value As Long)
            _idServicio = value
        End Set
    End Property

    Public Property ReImpresion As Boolean
        Get
            Return _reImpresion
        End Get
        Set(value As Boolean)
            _reImpresion = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Request.QueryString("id") IsNot Nothing AndAlso Request.QueryString("id").Length > 0 Then
                _idServicio = CLng(Request.QueryString("id"))
            End If

            If Request.QueryString("reimpresion") IsNot Nothing Then
                _reImpresion = CLng(Request.QueryString("reimpresion"))
            End If

            rvPicking.Report = CrearReporte(_idServicio, _reImpresion)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Function CrearReporte(ByVal idServicio As Long, ByVal reImpresion As Boolean) As DevExpress.XtraReports.UI.XtraReport
        Dim rptReportePrestamo As New FormatoPrestamoSiembra()
        rptReportePrestamo.EstablecerParemetro(idServicio, reImpresion)

        Return rptReportePrestamo
    End Function

#End Region

End Class