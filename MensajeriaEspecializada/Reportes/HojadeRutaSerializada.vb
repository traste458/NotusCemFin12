Imports LMDataAccessLayer
Public Class HojadeRutaSerializada


#Region "Constructor"

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter.Connection = New LMDataAccess().ConexionSQL
    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub EstablecerParemetro(ByVal idRuta As Long)
        Try
            DsReporteHojadeRuta1.Clear()
            ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter.Fill(DsReporteHojadeRuta1.ObtenerInfoHojaRutaMensajeriaSerializada, idRuta)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region
End Class