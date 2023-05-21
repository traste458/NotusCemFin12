Imports System.IO
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer

Public Class DescargaDeDocumentos
    Inherits System.Web.UI.Page

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("id") IsNot Nothing Then
            Dim id As Long = CLng(Request.QueryString("id"))
            MetodosComunes.setGemBoxLicense()
            Select Case id
                Case "1"
                    ConsutaMaestroProductos()
                    If Session("dtPrducto") IsNot Nothing Then
                        Dim dtReporte As DataTable = CType(Session("dtPrducto"), DataTable)
                        DescargarReporte(dtReporte)
                    End If
                Case "2"
                    If Session("dtDetalleGestionVenta") IsNot Nothing Then
                        Dim dtReporte As DataTable = CType(Session("dtDetalleGestionVenta"), DataTable)
                        DescargarReporteDetalleGestionVenta(dtReporte)
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub ConsutaMaestroProductos()
        Dim infoProducto As New ProductoDocumentoFinancieroColeccion
        Dim dtPrducto As New DataTable
        With infoProducto
            .EsProductoExterno.Add(0)
            .EsProductoExterno.Add(1)
            dtPrducto = .GenerarDataTable
        End With
        Session("dtPrducto") = dtPrducto
    End Sub

    Private Sub DescargarReporte(ByVal dtReporte As DataTable)
        Dim nombreArchivo As String = GenerarArchivoExcelDiferencias(dtReporte)
        If System.IO.File.Exists(nombreArchivo) Then
            MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo)
        End If
    End Sub

    Private Function GenerarArchivoExcelDiferencias(ByVal dtReporte As DataTable)
        Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaProductos.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/PlantillaProductos" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim numRegistros As Integer = 0
        If File.Exists(rutaPlantilla) Then
            miExcel.LoadXlsx(rutaPlantilla, XlsxOptions.PreserveMakeCopy)
            miHoja = miExcel.Worksheets.ActiveWorksheet
            numRegistros = miHoja.InsertDataTable(dtReporte, "A2", False)
            'If numRegistros = 0 Then miEncabezado.showWarning("No fue posible adicionar datos al archivo. Por favor intente nuevamente.")
        Else
            miHoja = miExcel.Worksheets.Add("Maestro de Productos")
            With miHoja
                numRegistros = miHoja.InsertDataTable(dtReporte, "A2", True)
            End With
        End If
        For index As Integer = 0 To dtReporte.Columns.Count - 1
            miHoja.Columns(index).AutoFitAdvanced(1.1)
        Next
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

    Private Sub DescargarReporteDetalleGestionVenta(ByVal dtReporte As DataTable)
        Dim nombreArchivo As String = GenerarArchivoExcelDetalleGestionVenta(dtReporte)
        If System.IO.File.Exists(nombreArchivo) Then
            MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo)
        End If
    End Sub

    Private Function GenerarArchivoExcelDetalleGestionVenta(ByVal dtReporte As DataTable)
        Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaDetalleGestionVenta.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/PlantillaDetalleGestionVenta" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim numRegistros As Integer = 0
        If File.Exists(rutaPlantilla) Then
            miExcel.LoadXlsx(rutaPlantilla, XlsxOptions.PreserveMakeCopy)
            miHoja = miExcel.Worksheets.ActiveWorksheet
            numRegistros = miHoja.InsertDataTable(dtReporte, "A5", False)
            'If numRegistros = 0 Then miEncabezado.showWarning("No fue posible adicionar datos al archivo. Por favor intente nuevamente.")
        Else
            miHoja = miExcel.Worksheets.Add("Gestión de Venta")
            With miHoja
                numRegistros = miHoja.InsertDataTable(dtReporte, "A2", True)
            End With
        End If
        For index As Integer = 0 To dtReporte.Columns.Count - 1
            miHoja.Columns(index).AutoFitAdvanced(1.1)
        Next
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

#End Region

End Class