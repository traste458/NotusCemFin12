Public Class CAC
#Region "Variables"
    Private idCAC, idAuxiliar, idCiudad As Integer
    Private nombreCAC As String
    Private direccion As String
    Private telefonos As String
    Private almacen As String
    Private centro As String
    Private region As String
    Private _idEstado As Boolean
#End Region

#Region "Propiedades"
    Public Property direccionCAC() As String
        Get
            Return direccion
        End Get
        Set(ByVal Value As String)
            direccion = Value
        End Set
    End Property

    Public Property telefonoCAC() As String
        Get
            Return telefonos
        End Get
        Set(ByVal Value As String)
            telefonos = Value
        End Set
    End Property

    Public Property almacenCAC() As String
        Get
            Return almacen
        End Get
        Set(ByVal Value As String)
            almacen = Value
        End Set
    End Property

    Public Property centroCAC() As String
        Get
            Return centro
        End Get
        Set(ByVal Value As String)
            centro = Value
        End Set
    End Property

    Public Property regionCAC() As String
        Get
            Return region
        End Get
        Set(ByVal Value As String)
            region = Value
        End Set
    End Property

    Public Property nombre() As String
        Get
            Return nombreCAC
        End Get
        Set(ByVal Value As String)
            nombreCAC = Value
        End Set
    End Property

    Public Property identificaCAC() As Integer
        Get
            Return idCAC
        End Get
        Set(ByVal Value As Integer)
            idCAC = Value
        End Set
    End Property

    Public Property Auxiliar() As Integer
        Get
            Return idAuxiliar
        End Get
        Set(ByVal Value As Integer)
            idAuxiliar = Value
        End Set
    End Property

    Public Property ciudad() As Integer
        Get
            Return idCiudad
        End Get
        Set(ByVal Value As Integer)
            idCiudad = Value
        End Set
    End Property

    Public Property IdEstado() As Boolean
        Get
            Return _idEstado
        End Get
        Set(ByVal Value As Boolean)
            _idEstado = Value
        End Set
    End Property



#End Region

    Public Function consultarCAC() As DataTable
        Dim sentencia As String, dtDatos As DataTable, baseDatos As New LMDataAccessLayer.LMDataAccess
        Try
            sentencia = "ConsultarCAC"
            If idCAC <> 0 Then baseDatos.agregarParametroSQL("@idCAC", idCAC, SqlDbType.Int)
            If almacen <> "" Then baseDatos.agregarParametroSQL("@almacenCAC", almacen, SqlDbType.Int)
            If centro <> "" Then baseDatos.agregarParametroSQL("@centroCAC", centro, SqlDbType.Int)
            If idCiudad <> 0 Then baseDatos.agregarParametroSQL("@idCiudad", idCiudad, SqlDbType.Int)
            If _idEstado Then baseDatos.agregarParametroSQL("@idEstado", _idEstado, SqlDbType.Bit)
            Return baseDatos.ejecutarDataTable(sentencia, CommandType.StoredProcedure)
        Catch ex As Exception
            Throw New Exception("Error al cargar el CAC: " & ex.Message)
        End Try
    End Function



    Public Sub New()
        _idEstado = True
    End Sub
End Class
