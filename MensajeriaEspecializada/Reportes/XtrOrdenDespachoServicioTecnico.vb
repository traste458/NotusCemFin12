Imports LMDataAccessLayer
Public Class XtrOrdenDespachoServicioTecnico


#Region "Constructor"

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        ObtenerInfoHojaRutaMensajeriaTableAdapter.Connection = New LMDataAccess().ConexionSQL
        ObtieneInfoRutaDespachoServicioTecnicoTableAdapter.Connection = New LMDataAccess().ConexionSQL
        ObtieneRutaProveedorServicioTecnicoTableAdapter.Connection = New LMDataAccess().ConexionSQL

    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub EstablecerParemetro(ByVal idRuta As Long)
        Try
            dsOrdenDespachoServicioTecnico.Clear()
            ObtenerInfoHojaRutaMensajeriaTableAdapter.Fill(dsOrdenDespachoServicioTecnico.ObtenerInfoHojaRutaMensajeria, idRuta)
            ObtieneInfoRutaDespachoServicioTecnicoTableAdapter.Fill(DsOrdenDespachoServicioTecnico.ObtieneInfoRutaDespachoServicioTecnico, idRuta)
            ObtieneRutaProveedorServicioTecnicoTableAdapter.Fill(DsOrdenDespachoServicioTecnico.ObtieneRutaProveedorServicioTecnico, idRuta)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region
End Class