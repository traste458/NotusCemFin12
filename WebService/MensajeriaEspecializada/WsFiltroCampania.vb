Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer

''' <summary>
''' Clase que permite establecer los filtros establecidos para la cosulta de Campañas 
''' </summary>
''' <remarks></remarks>
Public Class WsFiltroCampania

#Region "Atributos (Filtros de Búsqueda)"

    Private _idCampania As Integer
    Private _nombreCampania As String
    Private _listIdTipoServicio As ArrayList
    Private _idTipoServicio As Enumerados.TipoServicio
    Private _activo As Nullable(Of Boolean)
    Private _idClienteExterno As Integer
    Private _idEmpresa As Integer

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

    Public Property NombreCampania As String
        Get
            Return _nombreCampania
        End Get
        Set(value As String)
            _nombreCampania = value
        End Set
    End Property

    Public Property Activo As Nullable(Of Boolean)
        Get
            Return _activo
        End Get
        Set(value As Nullable(Of Boolean))
            _activo = value
        End Set
    End Property

    Public Property ListaTipoServicio As ArrayList
        Get
            If _listIdTipoServicio Is Nothing Then _listIdTipoServicio = New ArrayList
            Return _listIdTipoServicio
        End Get
        Set(value As ArrayList)
            _listIdTipoServicio = value
        End Set
    End Property

    Public Property IdTipoServicio As Enumerados.TipoServicio
        Get
            Return _idTipoServicio
        End Get
        Set(value As Enumerados.TipoServicio)
            _idTipoServicio = value
        End Set
    End Property

    Public Property IdClienteExterno As Integer
        Get
            Return _idClienteExterno
        End Get
        Set(value As Integer)
            _idClienteExterno = value
        End Set
    End Property

    Public Property IdEmpresa As Integer
        Get
            Return _idEmpresa
        End Get
        Set(value As Integer)
            _idEmpresa = value
        End Set
    End Property

#End Region

End Class
