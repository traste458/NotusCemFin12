Public Class VisorHojadeRutaSerTipoVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idRuta As Long

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("id") IsNot Nothing AndAlso Request.QueryString("id").Length > 0 Then
            _idRuta = CLng(Request.QueryString("id"))

            Dim rptHojadeRuta As New HojadeRuta
            rptHojadeRuta.EstablecerParemetro(_idRuta)

            vsReporte.Reporte = rptHojadeRuta
        End If
    End Sub

#End Region

End Class