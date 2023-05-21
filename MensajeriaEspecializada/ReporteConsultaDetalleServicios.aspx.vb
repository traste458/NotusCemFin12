Imports DevExpress.Web
Imports System.IO
Imports System.Collections.Generic
Imports ARBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text
Imports ILSBusinessLayer
Imports LumenWorks.Framework.IO.Csv


Public Class ReporteConsultaDetalleServicios
    Inherits System.Web.UI.Page



    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Reporte seriales asociados a servicios")
        End If

        Session("archivo") = fuArchivo.FileName
    End Sub

    Private Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        ObtenerDatosReporte()
    End Sub

    Private Sub ObtenerDatosReporte()
        Dim dtDatos As DataTable
        Try
            Dim archisvosc As String = Session("archivo")
            MetodosComunes.setGemBoxLicense()
            Dim _idUsuario As Integer = Session("usxp001")
            Dim reporte As New ReporteDetalladoServicios
            Dim resultado As New ResultadoProceso
            Dim fecha As String = DateTime.Now.ToString("HH:mm:ss:fff")
            fecha = fecha.Replace(":", "_").ToString()
            Dim ruta As String = Server.MapPath("..\archivos_planos\") & Session("usxp001") & fuArchivo.FileName
            fuArchivo.SaveAs(ruta)
            Dim extencion As String = fuArchivo.PostedFile.FileName.Substring(fuArchivo.PostedFile.FileName.LastIndexOf(".")).ToLower()

            If extencion = ".txt" Then
                Dim db As New LMDataAccessLayer.LMDataAccess
                Try
                    db.SqlParametros.Add("@idUsuario", SqlDbType.Int).Value = _idUsuario
                    db.EjecutarNonQuery("EliminarTransitoriaReporteRadicado", CommandType.StoredProcedure)
                Catch ex As Exception
                    Throw New Exception(ex.Message, ex)
                End Try
                fuArchivo.FileName.ToString()

                dtDatos = FetchFromCSVFileLong(ruta)
                dtDatos.Columns.Add(New DataColumn("IdUsuario", GetType(System.Int32), Session("usxp001")))
                db.InicilizarBulkCopy()
                db.BulkCopy.DestinationTableName = "TransitoriaReporteConsultaSeriales"
                db.BulkCopy.WriteToServer(dtDatos)
            Else
                epNotificador.showError("Imposible determinar el formato del archivo")
                Exit Sub
            End If

            With reporte
                .IdTipo = rdBtnTipoCargue.Value
                .IdUsuario = Session("usxp001")
                .NombreArchivo = Server.MapPath("~/archivos_planos/" & "ReporteConsultaServicios_" & Session("usxp001") & "_" & fecha & ".xlsx")
                .NombrePlantilla = Server.MapPath("~/MensajeriaEspecializada/Plantillas/ReporteConsultaServicios.xlsx")
                .ObtenerReporte()
            End With
            If (reporte.Resultado.Valor > 0) Then
                hdRuta.Set("Ruta", reporte.Resultado.Mensaje)
                btnExportador_Click()
            Else
                hdRuta.Set("Ruta", reporte.Resultado.Valor)
                epNotificador.showWarning(reporte.Resultado.Mensaje.ToString())
            End If
        Catch ex As Exception
            hdRuta.Set("Ruta", "0")
            epNotificador.showError("Error al generar el reporte" & ex.Message)
        End Try
    End Sub

    Protected Sub btnExportador_Click()
        Dim fullnombreArchivo As String = hdRuta.Get("Ruta")
        hdRuta.Set("Ruta", "0")
        If fullnombreArchivo IsNot Nothing Then
            If fullnombreArchivo <> "0" Then
                Dim nombreMostrar As String = System.IO.Path.GetFileName(fullnombreArchivo)
                Response.Clear()
                Response.ClearContent()
                Response.AppendHeader("Content-Disposition", "attachment; filename=" & nombreMostrar)
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                Response.ContentEncoding = Encoding.UTF8
                Response.WriteFile(fullnombreArchivo)
                Response.Flush()
                Response.End()
            Else
                epNotificador.showWarning("La consulta no arrojó registros. Por favor valide los filtros de búsqueda aplicados.")
            End If
        End If
    End Sub

    Public Function FetchFromCSVFileLong(ByVal filePath As String) As DataTable

        Dim hasHeader As Boolean = True
        Dim csvTable As DataTable = New DataTable()

        Using csvReader As CsvReader = New CsvReader(New StreamReader(filePath), hasHeader, vbTab, 1)
            Dim fieldCount As Integer = csvReader.FieldCount
            Dim headers As String() = csvReader.GetFieldHeaders()

            For Each headerLabel As String In headers
                csvTable.Columns.Add(headerLabel, GetType(String))
            Next

            While csvReader.ReadNextRecord()
                Dim newRow As DataRow = csvTable.NewRow()
                For i As Integer = 0 To fieldCount - 1
                    newRow(i) = csvReader(i)
                Next

                csvTable.Rows.Add(newRow)
            End While
        End Using

        Return csvTable
    End Function


End Class