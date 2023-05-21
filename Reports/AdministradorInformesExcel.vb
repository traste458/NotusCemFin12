Imports ILSBusinessLayer
Imports LMDataAccessLayer
Imports System.IO
Imports GemBox.Spreadsheet

Namespace Reports
    Public Class AdministradorInformesExcel
#Region "Variables Privadas"
        Private _dtDatos As DataTable
        Private _titulo As String
        Private _rutaPlantilla As String
        Private _mensaje As String
        Private _rutaArchivoGenerado As String
        Private _filaInicial As Integer
        Private _columnaInicial As Integer
#End Region

#Region "Propiedades"

        Public ReadOnly Property Titulo() As String
            Get
                Return _titulo
            End Get
        End Property

        Public Property DtDatos() As DataTable
            Get
                Return _dtDatos
            End Get
            Set(ByVal value As DataTable)
                _dtDatos = value
            End Set
        End Property

        Public ReadOnly Property RutaPlantilla() As String
            Get
                Return _rutaPlantilla
            End Get
        End Property

        Public ReadOnly Property Mensaje() As String
            Get
                Return _mensaje
            End Get
        End Property

        Public ReadOnly Property RutaArchivoGenerado() As String
            Get
                Return _rutaArchivoGenerado
            End Get
        End Property

        Public Property FilaInicial() As Integer
            Get
                Return _filaInicial
            End Get
            Set(ByVal value As Integer)
                _filaInicial = value
            End Set
        End Property

        Public Property ColumnaInicial() As Integer
            Get
                Return _columnaInicial
            End Get
            Set(ByVal value As Integer)
                _columnaInicial = value
            End Set
        End Property

#End Region

#Region "Constructores"

        Public Sub New(ByVal titulo As String, ByVal rutaPlantilla As String)
            MyBase.New()
            _titulo = titulo
            _rutaPlantilla = rutaPlantilla
            _mensaje = String.Empty
            MetodosComunes.setGemBoxLicense()
        End Sub

#End Region

#Region "Metodos Publicos"

        Public Function GenerarExcelPlanilla() As Boolean
            Dim retorno As Boolean = True
            Try
                If _rutaPlantilla <> "" AndAlso _rutaPlantilla <> "" Then
                    If _dtDatos IsNot Nothing AndAlso _dtDatos.Rows.Count > 0 Then
                        Dim oExcel As New ExcelFile
                        Dim oWs As ExcelWorksheet = Nothing
                        Dim contexto As HttpContext = HttpContext.Current
                        _rutaPlantilla = contexto.Server.MapPath(_rutaPlantilla)
                        If File.Exists(_rutaPlantilla) Then
                            If _rutaPlantilla.Split(".").GetValue(1).ToString.ToLower.Trim = "xls" Then
                                oExcel.LoadXls(_rutaPlantilla)
                            Else
                                oExcel.LoadXlsx(_rutaPlantilla, XlsxOptions.None)
                            End If
                            oWs = oExcel.Worksheets.ActiveWorksheet
                        Else
                            _mensaje = "La plantilla requerida para el reporte actual no existe. Por favor comuníquese con servicio al cliente Logytech."
                            retorno = False
                        End If
                        If retorno Then
                            oWs.InsertDataTable(_dtDatos, _filaInicial, _columnaInicial, False)
                        End If
                        If oWs IsNot Nothing Then
                            For index As Integer = 0 To _dtDatos.Columns.Count - 1
                                oWs.Columns(index).AutoFitAdvanced(1.1000000000000001)
                            Next
                        End If
                        Dim fullPath As String = contexto.Server.MapPath("~/archivos_planos/" & Titulo)
                        If _rutaPlantilla.Split(".").GetValue(1).ToString.ToLower.Trim = "xls" Then
                            oExcel.SaveXls(fullPath)
                        Else
                            oExcel.SaveXlsx(fullPath)
                        End If

                        If File.Exists(fullPath) Then
                            _rutaArchivoGenerado = fullPath
                        Else
                            _mensaje = "Imposible generar la versión exportable del Reporte. Por favor intente nuevamente"
                            retorno = False
                        End If
                    Else
                        _mensaje = "No se han cargado los datos que deberían ser exportados."
                        retorno = False
                    End If
                    Else
                        _mensaje = "la ruta de la plantilla o nombre del archivo no estan suministrados, por favor verifique."
                        retorno = False
                    End If
            Catch ex As Exception
                _mensaje = ex.Message
                retorno = False
                Throw New ArgumentNullException(ex.Message)
            End Try
            Return retorno
        End Function

#End Region

#Region "Metodos Privados"



#End Region

    End Class
End Namespace
