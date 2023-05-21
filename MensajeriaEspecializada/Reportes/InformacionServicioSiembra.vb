Imports LMDataAccessLayer

Public Class InformacionServicioSiembra

#Region "Constructor"

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        ObtieneInfoReporteGeneralServicioSiembraTableAdapter.Connection = New LMDataAccess().ConexionSQL
    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub EstablecerParemetro(ByVal idServicio As Long, Optional reImpresion As Boolean = False)
        Try
            DsServicioSiembra1.Clear()
            ObtieneInfoReporteGeneralServicioSiembraTableAdapter.Fill(DsServicioSiembra1.ObtieneInfoReporteGeneralServicioSiembra, idServicio)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

End Class