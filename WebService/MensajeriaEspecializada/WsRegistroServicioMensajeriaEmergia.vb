Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer

''' <summary>
''' Clase que permite establecer los valores necesarios para el registro de un servicio
''' </summary>
''' <remarks></remarks>
Public Class WsRegistroServicioMensajeriaEmergia

#Region "Atributos"

    Private _idServicioMensajeria As Long
    Private _fechaAgenda As Date
    Private _idJornada As Integer
    Private _idCiudad As Integer
    Private _direccion As String
    Private _telefono As String
    Private _telefonoFijo As String
    Private _observacion As String

#End Region

#Region "Propiedades"

    Public Property IdServicioMensajeria As Long
        Get
            Return _idServicioMensajeria
        End Get
        Set(value As Long)
            _idServicioMensajeria = value
        End Set
    End Property

    Public Property FechaAgenda As Date
        Get
            Return _fechaAgenda
        End Get
        Set(value As Date)
            _fechaAgenda = value
        End Set
    End Property

    Public Property IdJornada As Integer
        Get
            Return _idJornada
        End Get
        Set(value As Integer)
            _idJornada = value
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

    Public Property Direccion As String
        Get
            Return _direccion
        End Get
        Set(value As String)
            _direccion = value
        End Set
    End Property

    Public Property Telefono As String
        Get
            Return _telefono
        End Get
        Set(value As String)
            _telefono = value
        End Set
    End Property
    Public Property Observacion() As String
        Get
            Return _observacion
        End Get
        Set(value As String)
            _observacion = value
        End Set
    End Property

    Public Property TelefonoFijo As String
        Get
            Return _telefonoFijo
        End Get
        Set(value As String)
            _telefonoFijo = value
        End Set
    End Property


#End Region

End Class
