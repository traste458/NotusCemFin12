Imports LMDataAccessLayer

Public Class FormatoPrestamoSiembra

#Region "Cosntructor"

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        ObtieneInfoFormatoPrestamoSiembraTableAdapter.Connection = New LMDataAccess().ConexionSQL
    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub EstablecerParemetro(ByVal idServicio As Long, ByVal reImpresion As Boolean)
        Try
            DsReportePrestamoSiembra1.Clear()

            ObtieneInfoFormatoPrestamoSiembraTableAdapter.Fill(DsReportePrestamoSiembra1.ObtieneInfoFormatoPrestamoSiembra, idServicio, reImpresion)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

End Class