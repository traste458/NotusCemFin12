Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer

''' <summary>
''' Clase que permite establecer los diferentes parametros de consulta para inventario de documentación
''' </summary>
''' <remarks></remarks>
Public Class WsInfoDisponibilidad

#Region "Atributos"

    Private _idCampania As Integer
    Private _codigoDocumento As String
    Private _idCiudad As Integer
    Private _listProductos As List(Of Integer)

#End Region

#Region "Propiedades"

    Public Property IdCampania As Integer
        Get
            Return _idCampania
        End Get
        Set(value As Integer)
            _idCampania = value
        End Set
    End Property

    Public Property CodigoDocumento As String
        Get
            Return _codigoDocumento
        End Get
        Set(value As String)
            _codigoDocumento = value
        End Set
    End Property

    Public Property IdCiudad As Integer
        Get
            Return _idCiudad
        End Get
        Set(value As Integer)
            _idCiudad = value
        End Set
    End Property

    Public Property ListProductos As List(Of Integer)
        Get
            If _listProductos Is Nothing Then _listProductos = New List(Of Integer)
            Return _listProductos
        End Get
        Set(value As List(Of Integer))
            _listProductos = value
        End Set
    End Property

#End Region

End Class
