Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ReporteIndicadoresSiembra
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Reporte Indicadores Gestión Siembra")
                End With
                CargaInicial()
                MetodosComunes.setGemBoxLicense()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs) Handles btnFiltrar.Click
        DescargarArchivo()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            dateFechaInicio.Date = MetodosComunes.ObtienePrimerDiaDeMes(Now.Date)
            dateFechaFin.Date = MetodosComunes.ObtieneUltimoDiadeMes(Now.Date)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub DescargarArchivo()
        Dim dsDatosReporte As DataSet
        Try
            Dim objIndicadores As New ReporteIndicadoresSiembraBLL()
            With objIndicadores
                If dateFechaInicio.Value IsNot Nothing Then .FechaInicial = dateFechaInicio.Value
                If dateFechaFin.Value IsNot Nothing Then .FechaFinal = dateFechaFin.Value
                dsDatosReporte = .ObtenerReporte()
            End With

            If dsDatosReporte IsNot Nothing AndAlso dsDatosReporte.Tables.Count > 0 Then
                Dim nombreArchivo As String = GenerarArchivoExcel(dsDatosReporte, objIndicadores.NoInventario, objIndicadores.FechaInicial, objIndicadores.FechaFinal)
                If System.IO.File.Exists(nombreArchivo) Then
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo)
                Else
                    miEncabezado.showWarning("Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente")
                End If
            Else
                miEncabezado.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de exportar reporte a Excel. " & ex.Message)
        End Try
    End Sub

    Private Function GenerarArchivoExcel(ByRef dsDatos As DataSet, ByVal cantInventario As Long, ByVal fechaInicio As Date, ByVal fechaFin As Date) As String
        Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaReporteIndicadoresGestionSIEMBRA.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/PlantillaReporteIndicadoresGestionSIEMBRA" & Session("usxp001") & ".xls")

        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim filaActual As Integer = 4
        Dim filaRango As Integer = 1
        Dim numRegistros As Integer = 0

        If File.Exists(rutaPlantilla) Then
            miExcel.LoadXlsx(rutaPlantilla, XlsxOptions.PreserveMakeCopy)
            miHoja = miExcel.Worksheets.ActiveWorksheet

            'Cantidad de Inventario
            miHoja.Cells("C5").Value = cantInventario

            'Fecha Reporte
            miHoja.Cells("B3").Value = fechaInicio.Day.ToString() & " " & MonthName(fechaInicio.Month) & " de " & fechaInicio.Year & " - " & fechaFin.Day.ToString() & " " & MonthName(fechaFin.Month) & " de " & fechaFin.Year

            'Titulos
            numRegistros = miHoja.InsertDataTable(dsDatos.Tables(0), "C6", False)

            'Equipos Prestados
            numRegistros = miHoja.InsertDataTable(dsDatos.Tables(1), "A8", False)

            'Sims Prestadas
            numRegistros = miHoja.InsertDataTable(dsDatos.Tables(2), "A17", False)


            'Planes Activados
            numRegistros = miHoja.InsertDataTable(dsDatos.Tables(3), "A24", False)

            'Paquetes Activados
            numRegistros = miHoja.InsertDataTable(dsDatos.Tables(4), "A32", False)

            If numRegistros = 0 Then miEncabezado.showWarning("No fue posible adicionar datos al archivo. Por favor intente nuevamente.")
        Else
            miEncabezado.showWarning("No se logro cargar la plantilla, por favor contacte al administrador del sistema.")
        End If
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

#End Region

End Class