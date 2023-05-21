﻿Imports LMDataAccessLayer
Public Class HojadeRutaSerTipoVenta

#Region "Constructor"

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        ObtenerInfoHojaRutaMensajeriaTableAdapter.Connection = New LMDataAccess().ConexionSQL
    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub EstablecerParemetro(ByVal idRuta As Long)
        Try
            dsReporteHojadeRuta.Clear()
            ObtenerInfoHojaRutaMensajeriaTableAdapter.Fill(dsReporteHojadeRuta.ObtenerInfoHojaRutaMensajeria, idRuta)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

End Class