Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes
Imports DevExpress.XtraPrinting
Imports System.IO
Imports DevExpress.XtraPivotGrid
Imports DevExpress.Web.ASPxPivotGrid

Public Class ReporteGeneralTiendaVirtual
    Inherits System.Web.UI.Page
#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Reporte General Tienda Virtual")
                End With
                CargarFiltros()
            End If
            If Session("dtDatos") IsNot Nothing Then pivotGrid.DataSource = Session("dtDatos")
            UpdatePivotGridFieldLayout()
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Private Sub UpdatePivotGridFieldLayout()
        pivotGrid.BeginUpdate()
        pivotGrid.Fields("Ciudad").Area = DevExpress.XtraPivotGrid.PivotArea.RowArea
        pivotGrid.Fields("Mes").Area = DevExpress.XtraPivotGrid.PivotArea.RowArea
        pivotGrid.Fields("Año").Area = DevExpress.XtraPivotGrid.PivotArea.RowArea
        pivotGrid.Fields("Cadena").Area = DevExpress.XtraPivotGrid.PivotArea.RowArea
        pivotGrid.Fields("Estado").Area = DevExpress.XtraPivotGrid.PivotArea.RowArea
        pivotGrid.Fields("Radicado").Area = DevExpress.XtraPivotGrid.PivotArea.RowArea
        pivotGrid.Fields("cantidad").Area = DevExpress.XtraPivotGrid.PivotArea.DataArea
        pivotGrid.EndUpdate()
    End Sub


    'Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
    '    BuscarRegistros()
    'End Sub

    'Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
    '    If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    'End Sub

    Private Sub pivotGrid_CustomCallback(sender As Object, e As DevExpress.Web.ASPxPivotGrid.PivotGridCustomCallbackEventArgs) Handles pivotGrid.CustomCallback
        BuscarRegistros()
        pivotGrid.RetrieveFields()
        UpdatePivotGridFieldLayout()
        CType(sender, ASPxPivotGrid).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pivotGrid_DataBinding(sender As Object, e As EventArgs) Handles pivotGrid.DataBinding
        If Session("dtDatos") IsNot Nothing Then pivotGrid.DataSource = Session("dtDatos")
    End Sub

    Private Sub pivotGrid_FieldFilterChanged(sender As Object, e As DevExpress.Web.ASPxPivotGrid.PivotFieldEventArgs) Handles pivotGrid.FieldFilterChanged
        UpdatePivotGridFieldLayout()
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(ByVal source As Object, ByVal e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                Dim stArchivo As MemoryStream
                Dim rutaPlantilla As String = Server.MapPath("~") & "\" & "MensajeriaEspecializada\Plantillas\Reporte_Ventas_Web.xlsx"

                If Not String.IsNullOrEmpty(formato) Then
                    Select Case formato
                        Case "xlsx"
                            Dim objExcel As New ExcelManager()
                            With objExcel
                                .ColumnaInicial = 0
                                .FilaInicial = 3
                                .IncluirEncabezado = False
                                stArchivo = .GenerarExcel(Session("dtDatos"), rutaPlantilla)
                            End With

                            Response.AddHeader("Content-Disposition", "attachment; filename=Reporte_Ventas_Web.xlsx")
                            Response.ContentType = "application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                            Response.BinaryWrite(stArchivo.ToArray)
                            Response.End()
                        Case Else
                            Throw New ArgumentNullException("Archivo no valido")
                    End Select
                End If
            Else
                miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al exportar los datos: " & ex.Message)
        End Try
    End Sub

    Private Sub cbFormatoExportarPantalla_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportarPantalla.ButtonClick
        Dim nombreArchivo As String = "Reporte General Ventas Web (Información de Pantalla)"
        Select Case cbFormatoExportarPantalla.Value
            Case "pdf"
                pgeExportador.ExportPdfToResponse(nombreArchivo)
            Case "xls"
                pgeExportador.ExportXlsToResponse(nombreArchivo)
            Case "xlsx"
                pgeExportador.ExportToXlsx(nombreArchivo)
            Case "cvs"
                pgeExportador.ExportCsvToResponse(nombreArchivo)
            Case Else
                Throw New ArgumentNullException("Archivo no valido")
        End Select
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarRegistros()
        Try
            Dim objReporte As New ILSBusinessLayer.MensajeriaEspecializada.ReporteGeneralVentasTiendaVirtual
            Dim dtDatos As DataTable
            With objReporte
                If cmbEstado.Value > 0 Then .IdEstado = cmbEstado.Value
                .ListaNumeroRadicado = New ArrayList(memoRadicado.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                .ListaMsisdn = New ArrayList(memoMSISDN.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                .Cadena = txtCadena.Text
                .FechaEntregaInicio = deFechaInicio.Date
                .FechaEntregaFin = deFechaFin.Date
                .FechaRegistroInicio = deFechaInicioRegistro.Date
                .FechaRegistroFin = deFechaFinRegistro.Date
                .IdUsuario = CInt(Session("usxp001"))
            End With

            'With gvDatos
            '    .DataSource = objReporte.ObtenerReporte()
            '    Session("dtDatos") = .DataSource
            '    .DataBind()
            'End With
            With pivotGrid
                Session("dtDatos") = objReporte.ObtenerReporte()
                .DataSource = Session("dtDatos")
                dtDatos = Session("dtDatos")
                .DataBind()
            End With

            If dtDatos.Rows.Count = 0 Then
                miEncabezado.showWarning("No se encontraron registros, según los filtros aplicados.")
            End If

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al buscar los registros: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarFiltros()
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            'Estados
            Dim objEstados As New EstadoColeccion
            With objEstados
                .IdEntidad = Enumerados.Entidad.ServicioMensajeria
                .CargarDatos()
            End With

            With cmbEstado
                .TextField = "Descripcion"
                .ValueField = "IdEstado"
                .DataSource = objEstados
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de cargar los filtros:" & ex.Message)
        End Try
    End Sub

#End Region

End Class