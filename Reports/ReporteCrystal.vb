Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports System.Configuration
Imports System.Web

Public Class ReporteCrystal
    Implements IDisposable

#Region "varibles"
    Private nombre As String
    Private namefile As String
    Private parameterField As ParameterField
    Private report As ReportDocument
    Private reportPath As String
    Private _Path As String = String.Empty
    Private exportPath As String
    Private serverDB As String
    Private dataBaseName As String
    Private userDB As String
    Private passwordDB As String
    Private formato As ExportFormatType
    Private _idUsuario As String
    Protected disposed As Boolean = False
#End Region

#Region "Constructores y Destructores"

    Public Sub New()
        MyBase.New()
        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.Session("usxp001") IsNot Nothing Then
            Integer.TryParse(HttpContext.Current.Session("usxp001").ToString, _idUsuario)
        End If
    End Sub

    Public Sub New(ByVal NombreReporte As String, ByVal Path As String, Optional ByVal dsDatos As Object = Nothing)
        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.Session("usxp001") IsNot Nothing Then
            Integer.TryParse(HttpContext.Current.Session("usxp001").ToString, _idUsuario)
        End If
        Dim dbManager As New LMDataAccessLayer.LMDataAccess
        reportPath = Path
        exportPath = reportPath & "\rptTemp\"
        report = New ReportDocument()
        Try
            With dbManager.InformacionDeConexion
                serverDB = .NombreServidor
                dataBaseName = .NombreBaseDatos
                userDB = .NombreUsuario
                passwordDB = .Password
            End With
        Finally
            dbManager.CerrarConexion()
        End Try
        nombre_ = NombreReporte
        If dsDatos Is Nothing Then
            Me.cargarReporte(nombre)
        Else
            Me.cargarReporte(nombre, dsDatos)
        End If
    End Sub

    Protected Overridable Overloads Sub Dispose(ByVal disposing As Boolean)
        If Not Me.disposed Then
            If disposing AndAlso report IsNot Nothing Then
                report.Close()
                report.Dispose()
            End If
        End If
        Me.disposed = True
    End Sub

#End Region

#Region "propiedades"

    Public Property reportSource() As ReportDocument
        Get
            Return report
        End Get
        Set(ByVal value As ReportDocument)
            report = value
        End Set
    End Property

    Public Property Path() As String
        Get
            Return _Path
        End Get
        Set(ByVal value As String)
            _Path = value
        End Set
    End Property

    Public Property nombre_() As String
        Get
            Return nombre
        End Get
        Set(ByVal value As String)
            nombre = value
            namefile = nombre & ".rpt"
        End Set
    End Property

    Public Property idUsuario() As String
        Get
            Return _idUsuario
        End Get
        Set(ByVal value As String)
            _idUsuario = value
        End Set
    End Property

    Public ReadOnly Property Parametros() As ParameterFields
        Get
            Return report.ParameterFields
        End Get
    End Property


#End Region

#Region "Metodos"
    ''' <summary>
    ''' agrega un parametro por el cual se va a filtrar el reporte
    ''' </summary>
    ''' <param name="nombreParametro">el nombre del parametro debe ser el mismo nombre que se definió en el rpt</param>
    ''' <param name="valor">valor por el cual se va a filtrar</param>
    ''' <remarks></remarks>
    Public Sub agregarParametroDiscreto(ByVal nombreParametro As String, ByVal valor As Object)
        Dim parametro As New ParameterDiscreteValue
        parametro.Value = valor
        parameterField = report.ParameterFields(nombreParametro)
        parameterField.CurrentValues.Add(parametro)
    End Sub

    ''' <summary>
    ''' Agrega varios parametros para filtrar el reporte
    ''' </summary>
    ''' <param name="nombreParametro">el nombre del parametro debe ser el mismo nombre que se definió en el rpt</param>
    ''' <param name="arrValores">rango de valores que va a tener el parametro</param>
    ''' <remarks></remarks>
    Public Sub agregarParametroDiscreto(ByVal nombreParametro As String, ByVal arrValores As ArrayList)
        Dim parametro As New ParameterDiscreteValue
        parameterField = report.ParameterFields(nombreParametro)
        'parameterField.Name = nombreParametro
        For Each valor As Object In arrValores
            parametro.Value = valor
            parameterField.CurrentValues.Add(parametro)
        Next
    End Sub

    Public Sub LimpiarValoresDeParametrosDiscretos(Optional ByVal nombreParametro As String = Nothing)
        If Not String.IsNullOrEmpty(nombreParametro) Then
            If report.ParameterFields.Contains(nombreParametro) AndAlso report.ParameterFields(nombreParametro) IsNot Nothing _
                AndAlso report.ParameterFields(nombreParametro).HasCurrentValue Then report.ParameterFields(nombreParametro).CurrentValues.Clear()
        Else
            For Each parametro As ParameterField In reportSource.ParameterFields
                If parametro IsNot Nothing AndAlso parametro.HasCurrentValue Then parametro.CurrentValues.Clear()
            Next
        End If
    End Sub

    ''' <summary>
    ''' establece un origen de datos especifico para el reporte
    ''' </summary>
    ''' <param name="NombreReporte">nombre del archivo .RPT</param>
    ''' <param name="dsDatos">Origen de datos con el que se va a cargar el reporte</param>
    ''' <remarks>el archivo .RPT debe tener la estructura del dataset predefinida a través de un archivo .xsd</remarks>
    Public Sub cargarReporte(ByVal NombreReporte As String, Optional ByVal dsDatos As Object = Nothing)
        Dim path As String = reportPath & "\" & namefile
        report.Load(path)
        Dim subreporte As ReportDocument
        Dim obj_subreporte As SubreportObject
        report.DataSourceConnections(0).SetConnection(serverDB, dataBaseName, userDB, passwordDB)

        If dsDatos Is Nothing Then
            report.DataSourceConnections(0).SetConnection(serverDB, dataBaseName, userDB, passwordDB)
        Else
            report.SetDataSource(dsDatos)
            'se debe conectar el header
            obj_subreporte = TryCast(report.ReportDefinition.ReportObjects(0), SubreportObject)
            If obj_subreporte IsNot Nothing Then
                subreporte = obj_subreporte.OpenSubreport(obj_subreporte.SubreportName)
                subreporte.DataSourceConnections(0).SetConnection(serverDB, dataBaseName, userDB, passwordDB)
            End If
        End If
    End Sub

    ''' <summary>
    ''' Exporta el reporte a un tipo de archivo especifico
    ''' </summary>
    ''' <param name="FormatoDocumento">tipo de archivo al que se va a exportar el informe</param>
    ''' <returns>dirección donde se almacenó el informe exportado</returns>
    ''' <remarks></remarks>
    Public Function exportar(ByVal FormatoDocumento As ExportFormatType, Optional ByVal forzarLiebarcion As Boolean = True) As String
        formato = FormatoDocumento
        Dim url As String
        Dim fecha As DateTime = DateTime.Now
        Dim fec As String = fecha.ToString("HH:mm:ss:fff").Replace(":", "_")

        nombre = nombre & "_" & _idUsuario & "_" & fec
        If _Path Is String.Empty Then
            url = exportPath & nombre & getExtensionArchivo()
        Else
            url = _Path & nombre & getExtensionArchivo()
        End If

        With report
            .ExportToDisk(formato, url)
            If forzarLiebarcion Then
                .Close()
                .Dispose()
            End If
        End With

        Return url
    End Function

    Private Function getExtensionArchivo() As String
        Select Case formato
            Case ExportFormatType.Excel
                Return ".xls"
            Case ExportFormatType.WordForWindows
                Return ".doc"
            Case Else
                Return ".pdf"
        End Select
    End Function

    Public Overloads Sub Dispose() Implements IDisposable.Dispose
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub

    Protected Overrides Sub Finalize()
        Dispose(False)
        MyBase.Finalize()
    End Sub

#End Region


End Class
