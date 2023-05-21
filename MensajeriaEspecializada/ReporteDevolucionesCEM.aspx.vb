Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports GemBox.Spreadsheet

Partial Public Class ReporteDevolucionesCEM
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Reporte Devoluciones CEM")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                MetodosComunes.setGemBoxLicense()
                pnlResultados.Visible = False
                CargarMotorizado()
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbQuitarFiltros_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Protected Sub lbBuscar_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Dim dtDatos As New DataTable
        Try
            pnlResultados.Visible = True
            'cpdatosReporte.Update()
            dtDatos = CargarReporte()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
                lbDescargar.Visible = True
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                pnlResultados.Visible = False
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de generar reporte. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbDescargar_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbDescargar.Click
        Try
            If Session("dtReporteDevolucion") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtReporteDevolucion"), DataTable)

                Dim nombreArchivo As String = GenerarArchivoExcel(dtDatos)
                If System.IO.File.Exists(nombreArchivo) Then
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo)
                Else
                    epNotificacion.showWarning("Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente")
                End If
            Else
                epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de exportar reporte a Excel. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub LimpiarFiltros()
        txtNumeroRadicado.Text = ""
        txtFechaFinal.Value = ""
        txtFechaInicial.Value = ""
        pnlResultados.Visible = False
        lbDescargar.Visible = False
    End Sub

    Private Function CargarReporte() As DataTable
        Dim datos As New DevolucionCEM
        Dim dtEstado As New DataTable

        Try
            With datos
                If Not String.IsNullOrEmpty(txtNumeroRadicado.Text) Then .NumeroRadicado = txtNumeroRadicado.Text.Trim
                If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicial = CDate(txtFechaInicial.Value)
                If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFinal = CDate(txtFechaFinal.Value)
                .IdMororizado = ddlMotorizado.SelectedValue
            End With
            dtEstado = datos.CargarReporte
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el reporte de devoluciones. " & ex.Message)
        End Try
        Return dtEstado
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            pnlResultados.Visible = True
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Session("dtReporteDevolucion") = dtDatos
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Function GenerarArchivoExcel(ByVal dtDatos As DataTable) As String
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/ReporteSerialesActivacion_" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim filaActual As Integer = 5
        Dim auxFecha As Date
        miHoja = miExcel.Worksheets.Add("Reporte de seriale para enviar a Activación")
        With miHoja
            .Cells("A4").Value = "Serial"
            .Cells("B4").Value = "NumeroRadicado"
            .Cells("C4").Value = "FechaDevolucion"
            .Cells("D4").Value = "Motorizado"

            Dim myStyle As New CellStyle
            With myStyle
                .Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                .HorizontalAlignment = HorizontalAlignmentStyle.Center
                .Font.Weight = ExcelFont.BoldWeight
                .FillPattern.SetSolid(ColorTranslator.FromHtml("#333399"))
                .Font.Color = Color.White
            End With
            .Cells.GetSubrange("A4", "D4").Style = myStyle
            For Each drVenta As DataRow In dtDatos.Rows
                .Cells("A" & filaActual.ToString).Value = drVenta("Serial").ToString
                .Cells("B" & filaActual.ToString).Value = drVenta("NumeroRadicado").ToString
                .Cells("C" & filaActual.ToString).Value = drVenta("FechaDevolucion").ToString
                .Cells("D" & filaActual.ToString).Value = drVenta("Motorizado").ToString
                filaActual += 1
            Next
            Dim myCellRange As CellRange = .Cells.GetSubrange("A" & filaActual.ToString, "D" & filaActual.ToString)
            With myCellRange
                .Merged = True
                With .Style
                    .FillPattern.SetSolid(ColorTranslator.FromHtml("#C0C0C0"))
                    .Font.Color = ColorTranslator.FromHtml("#000080")
                    .Font.Weight = ExcelFont.BoldWeight
                End With
            End With
            For index As Integer = 0 To 25
                .Columns(index).AutoFitAdvanced(1)
            Next
            With .Cells("A1")
                .Value = epNotificacion.getTitle()
                .Style.Font.Weight = ExcelFont.BoldWeight
                .Style.Font.Size = 20 * 14
            End With
        End With
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

    Private Sub CargarMotorizado()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarMotorizado
            With ddlMotorizado
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idMotorizado"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Motorizado", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion .showError("Error al tratar de obtener el listado de Motorizados. " & ex.Message)
        End Try
    End Sub


#End Region

End Class