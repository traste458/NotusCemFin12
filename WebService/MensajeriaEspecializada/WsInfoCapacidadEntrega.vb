Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer

''' <summary>
''' Clase que permite establecer los datos necesarios para consultar las capacidades de entrega de agendamiento CEM
''' </summary>
''' <remarks></remarks>
Public Class WsInfoCapacidadEntrega

#Region "Atributos"

    Private _idEmpresa As Integer
    Private _idRegistro As Integer
    Private _idBodega As Integer
    Private _idCiudad As Integer
    Private _fechaInicial As Date
    Private _fechaFinal As Date
    Private _idJornada As Integer
    Private _idAgrupacion As Integer
    Private _idCampania As Integer

#End Region

#Region "Propiedades"

    Public Property IdRegistro() As Integer
        Get
            Return _idRegistro
        End Get
        Set(ByVal value As Integer)
            _idRegistro = value
        End Set
    End Property

    Public Property IdEmpresa() As Integer
        Get
            Return _idEmpresa
        End Get
        Set(ByVal value As Integer)
            _idEmpresa = value
        End Set
    End Property

    Public Property IdBodega() As Integer
        Get
            Return _idBodega
        End Get
        Set(ByVal value As Integer)
            _idBodega = value
        End Set
    End Property

    Public Property IdCiudad() As Integer
        Get
            Return _idCiudad
        End Get
        Set(ByVal value As Integer)
            _idCiudad = value
        End Set
    End Property

    Public Property FechaInicial() As Date
        Get
            Return _fechaInicial
        End Get
        Set(ByVal value As Date)
            _fechaInicial = value
        End Set
    End Property

    Public Property FechaFinal() As Date
        Get
            Return _fechaFinal
        End Get
        Set(ByVal value As Date)
            _fechaFinal = value
        End Set
    End Property

    Public Property IdJornada() As Integer
        Get
            Return _idJornada
        End Get
        Set(ByVal value As Integer)
            _idJornada = value
        End Set
    End Property

    Public Property IdAgrupacion() As Integer
        Get
            Return _idAgrupacion
        End Get
        Set(ByVal value As Integer)
            _idAgrupacion = value
        End Set
    End Property

    Public Property IdCampania As Integer
        Get
            Return _idCampania
        End Get
        Set(value As Integer)
            _idCampania = value
        End Set
    End Property

#End Region

End Class
