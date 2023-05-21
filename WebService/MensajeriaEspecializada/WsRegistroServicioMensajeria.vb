Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer

''' <summary>
''' Clase que permite establecer los valores necesarios para el registro de un servicio
''' </summary>
''' <remarks></remarks>
Public Class WsRegistroServicioMensajeria

#Region "Atributos"

    Private _idServicioMensajeria As Long
    Private _fechaAgenda As Date
    Private _idJornada As Integer
    Private _idEmpresa As Integer
    Private _idEstado As Enumerados.EstadoServicio
    Private _nombre As String
    Private _identicacion As String
    Private _idCiudad As Integer
    Private _direccion As String
    Private _telefono As String
    Private _telefonoFijo As String
    Private _idCampania As Integer
    Private _idTipoServicio As Integer
    Private _listProductos As List(Of Integer)
    Private _listTipoServicio As List(Of String)
    Private _listCupoProducto As List(Of String)
    Private _actividadLaboral As String
    Private _observacion As String
    Private _codOficinaCliente As String

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

    Public Property IdEmpresa As Integer
        Get
            Return _idEmpresa
        End Get
        Set(value As Integer)
            _idEmpresa = value
        End Set
    End Property

    Public Property IdEstado As Enumerados.EstadoServicio
        Get
            Return _idEstado
        End Get
        Set(value As Enumerados.EstadoServicio)
            _idEstado = value
        End Set
    End Property

    Public Property Nombre As String
        Get
            Return _nombre
        End Get
        Set(value As String)
            _nombre = value
        End Set
    End Property

    Public Property Identicacion As String
        Get
            Return _identicacion
        End Get
        Set(value As String)
            _identicacion = value
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

    Public Property IdCampania As Integer
        Get
            Return _idCampania
        End Get
        Set(value As Integer)
            _idCampania = value
        End Set
    End Property

    Public Property IdTipoServicio As Integer
        Get
            Return _idTipoServicio
        End Get
        Set(value As Integer)
            _idTipoServicio = value
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

    Public Property ListTipoServicio As List(Of String)
        Get
            If _listTipoServicio Is Nothing Then _listTipoServicio = New List(Of String)
            Return _listTipoServicio
        End Get
        Set(value As List(Of String))
            _listTipoServicio = value
        End Set
    End Property

    Public Property ListCupoProducto As List(Of String)
        Get
            If _listCupoProducto Is Nothing Then _listCupoProducto = New List(Of String)
            Return _listCupoProducto
        End Get
        Set(value As List(Of String))
            _listCupoProducto = value
        End Set
    End Property

    Public Property ActividadLaboral() As String
        Get
            Return _actividadLaboral
        End Get
        Set(value As String)
            _actividadLaboral = value
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

    Public Property CodOficinaCliente As String
        Get
            Return _codOficinaCliente
        End Get
        Set(value As String)
            _codOficinaCliente = value
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

    Public Property NombresCompleto As String
    Public Property PrimerApellido As String
    Public Property SegundoApellido As String
    Public Property CodigoEstrategiaComercial As String
    Public Property Sexo As String
    Public Property Celular As String
    Public Property TelefonoAdicional As String
    Public Property CodigoAgenteVendedor As String
    Public Property Correo As String


#End Region

End Class
