Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text
Imports ILSBusinessLayer

Public Class ReporteCargueInventarioServicioFinanciero
    Inherits System.Web.UI.Page
#Region "Atributos"
    Private _cantidadRegistros As Integer
    Private _RutaArchivo As String
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Reporte Cargue Inventario Servicio Financiero Tarjetas")
        End If
    End Sub
    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            CType(sender, ASPxCallbackPanel).JSProperties.Remove("cpMensaje")
            Select Case e.Parameter
                Case "DescargarReporte"
                    ObtenerDatosReporte(sender)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epNotificador.showError("Error al tratar de manejar CallBack. Reporte General Servicios Siembra " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epNotificador.RenderHtml()
    End Sub

#Region "Métodos Privados"
    Private Sub ObtenerDatosReporte(sender As Object)
        Try
            MetodosComunes.setGemBoxLicense()
            Dim reporte As New ReporteCargueInventarioServicioFinancieros
            Dim resultado As New ResultadoProceso
            Dim fecha As String = DateTime.Now.ToString("HH:mm:ss:fff")
            fecha = fecha.Replace(":", "_").ToString()
            With reporte
                .FechaRegistroInicio = deFechaLecturaInicial.Date
                .FechaRegistroFin = deFechaLecturaFinal.Date
                .IdUsuario = Session("usxp001")
                .NombreArchivo = Server.MapPath("~/archivos_planos/" & "ReporteCargueInventarioServicioFinancieroTarjetas_" & Session("usxp001") & "_" & fecha & ".xlsx")
                .NombrePlantilla = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaReporteCargueInventarioServicioFinanciero.xlsx")
                .ObtenerReporte()
            End With
            If (reporte.Resultado.Valor > 0) Then
                hdRuta.Set("Ruta", reporte.Resultado.Mensaje)
            Else
                hdRuta.Set("Ruta", reporte.Resultado.Valor)
                epNotificador.showWarning(reporte.Resultado.Mensaje.ToString())
                CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epNotificador.RenderHtml()
            End If
        Catch ex As Exception
            hdRuta.Set("Ruta", "0")
            epNotificador.showError("Error al generar el reporte" & ex.Message)
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epNotificador.RenderHtml()
        End Try
    End Sub
#End Region
    Protected Sub btnExportador_Click(sender As Object, e As EventArgs)
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

End Class