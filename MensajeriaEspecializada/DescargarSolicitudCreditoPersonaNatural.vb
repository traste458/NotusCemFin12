Option Explicit On
Option Strict On

Imports System.Data
Imports System.Drawing
Imports System.Text
Imports System.IO
Imports iTextSharp.text.pdf
Imports System.Xml
Imports LMDataAccessLayer
Imports System.Web


Public Class DescargarSolicitudCreditoPersonaNatural
    Inherits System.Web.UI.Page

#Region "Atributos"
    Private _nombreArchivo As String
    Private _idServicio As String
#End Region

#Region "Propiedades"

    Public Property NombreArchivo As String
        Get
            Return _nombreArchivo
        End Get
        Set(value As String)
            _nombreArchivo = value
        End Set
    End Property

    Public Property IdServicio As String
        Get
            Return _idServicio
        End Get
        Set(value As String)
            _idServicio = value
        End Set
    End Property

#End Region

#Region "Constructores"

    Public Sub New()
        MyBase.New()
    End Sub

#End Region

#Region "Métodos Públicos"

    Public Function ConsultarInformacionPrestamoCliente(idGestionVenta As Integer) As DataSet

        Dim dbManager As New LMDataAccess
        Dim dtDatosCodigoEstrategia As New DataSet
        With dbManager
            .SqlParametros.Add("@idServicio", SqlDbType.Int).Value = idGestionVenta
            dtDatosCodigoEstrategia = .EjecutarDataSet("ConsultaSolicitudCreditoPN", CommandType.StoredProcedure)
        End With
        Return dtDatosCodigoEstrategia
    End Function

#End Region

End Class
