Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports GemBox.Spreadsheet

Public Class NotificacionesCEMReporte
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Reporte Notificaciones CEM")
                End With
                CargarControles()
                MetodosComunes.setGemBoxLicense()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Private Sub cpFiltroCiudad_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltroCiudad.Callback
        Dim filtroRapido As String = ""
        If e.Parameter.Length >= 4 Then
            filtroRapido = e.Parameter
            CargarListadoCiudad(filtroRapido)
        Else
            lblResultadoCiudad.Text = "0 Registro(s) Cargado(s)"
        End If
    End Sub

    Private Sub cpFiltros_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltros.Callback
        Dim parametro As String = e.Parameter
        Select Case parametro
            Case "cargar"
                CargarControles()
            Case Else
                CargarControles(parametro)
        End Select

    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Try
            Dim Param As String = e.Parameters.ToString
            Select Case Param
                Case "reporte"
                    GenerarReporte()
                Case "limpiar"
                    Session.Remove("dtDatos")
                Case Else
                    'EliminarUsuario()
                    Session.Remove("dtDatos")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al generar el proceso: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        If Session("dtDatos") IsNot Nothing Then
            Dim dtDatos As DataTable = Session("dtDatos")
            If dtDatos.Rows.Count > 0 Then
                CType(sender, ASPxGridView).JSProperties("cpDatos") = 1
            Else
                CType(sender, ASPxGridView).JSProperties("cpDatos") = 0
            End If
        Else
            CType(sender, ASPxGridView).JSProperties("cpDatos") = 0
        End If
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        gvDatos.DataSource = Session("dtDatos")
    End Sub

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("NumeroRadicado") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetalle(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar el detalle: " & ex.Message)
        End Try
    End Sub

    Private Sub btnDescarga_Click(sender As Object, e As System.EventArgs) Handles btnDescarga.Click
        GenerarReporteDetalle()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarControles(Optional idCiudad As Integer = -1)
        Try
            '** Cargar Bodegas **
            Dim dtBodega As New DataTable
            dtBodega = HerramientasMensajeria.ConsultarBodega(idCiudad)
            MetodosComunes.CargarComboDX(cmbBodega, dtBodega, "idbodega", "bodega")

            '** Cargar tipo de notificación **
            Dim filtro As New FiltroAsuntoNotificacion
            filtro.IdPerfil = Session("usxp009")
            Dim dt As DataTable = AsuntoNotificacion.ObtenerListado(filtro)
            Session("dtAsunto") = dt
            MetodosComunes.CargarComboDX(cmbTipo, dt, "idAsuntoNotificacion", "nombre")

            '** Cargar Estado **
            Dim dtEstado As New DataTable
            dtEstado = HerramientasMensajeria.ConsultarEstado
            MetodosComunes.CargarComboDX(cmbEstado, dtEstado, "idEstado", "nombre")

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar los controles: " & ex.Message)
        End Try
    End Sub

    Private Sub GenerarReporte()
        Dim dtDatos As New DataTable
        Dim objReporte As New ReporteNotificacionesCEMColeccion

        With objReporte
            If meRadicado.Text.Length > 0 Then
                For Each rad As Object In meRadicado.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                    .NumeroRadicado.Add(rad)
                Next
            End If
            If cmbCiudad.Value > 0 Then .Ciudad.Add(cmbCiudad.Value)
            If cmbBodega.Value > 0 Then .Bodega.Add(cmbBodega.Value)
            If cmbTipo.Value > 0 Then .TipoNotificacion.Add(cmbTipo.Value)
            If cmbEstado.Value > 0 Then .Estado.Add(cmbEstado.Value)
            If dateFechaInicio.Date > Date.MinValue Then .FechaInicio = dateFechaInicio.Date
            If dateFechaFin.Date > Date.MinValue Then .FechaFin = dateFechaFin.Date
            dtDatos = .GenerarDataTable()
        End With

        Session("dtDatos") = dtDatos
        EnlazarDatos(dtDatos)

        If dtDatos.Rows.Count = 0 Then
            miEncabezado.showWarning("<i> No se encontraron resultados, según los filtros establecidos. </i>")
        End If
    End Sub

    Private Sub CargarDetalle(gv As ASPxGridView)
        If Session("NumeroRadicado") IsNot Nothing Then
            Dim dtMateriales As New DataTable
            Dim numeroRadicado As Integer = CLng(Session("NumeroRadicado"))
            dtMateriales = ObtenerMateriales(numeroRadicado)
            Session("dtMateriales") = dtMateriales
            With gv
                .DataSource = Session("dtMateriales")
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador de la distribución, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerMateriales(ByVal numeroRadicado As Long) As DataTable
        Dim dtResultado As New DataTable
        Dim objDetalle As New ReporteNotificacionesCEMDetalleColeccion

        With objDetalle
            .NumeroRadicado.Add(numeroRadicado)
            dtResultado = .GenerarDataTable()
        End With
        Return dtResultado
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        With gvDatos
            .PageIndex = 0
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Private Sub CargarListadoCiudad(ByVal filtro As String)
        If Not String.IsNullOrEmpty(filtro.Trim) Then
            Dim filro As Estructuras.FiltroCiudad
            filro.Nombre = filtro
            filro.IdPais = 170
            Dim dtCiudad As DataTable = Localizacion.Ciudad.ObtenerListado(filro)
            MetodosComunes.CargarComboDX(cmbCiudad, dtCiudad, "idCiudad", "nombre")
        Else
            cmbCiudad.Items.Clear()
        End If
        With cmbCiudad
            lblResultadoCiudad.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            End If
        End With
    End Sub

    Private Sub GenerarReporteDetalle()
        Dim dsDatos As New DataSet
        Dim objReporte As New ReporteDetalladoNotificacionesCEM
        Try
            With objReporte
                If meRadicado.Text.Length > 0 Then
                    For Each rad As Object In meRadicado.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                        .NumeroRadicado.Add(rad)
                    Next
                End If
                If cmbCiudad.Value > 0 Then .Ciudad.Add(cmbCiudad.Value)
                If cmbBodega.Value > 0 Then .Bodega.Add(cmbBodega.Value)
                If cmbTipo.Value > 0 Then .TipoNotificacion.Add(cmbTipo.Value)
                If cmbEstado.Value > 0 Then .Estado.Add(cmbEstado.Value)
                If dateFechaInicio.Date > Date.MinValue Then .FechaInicio = dateFechaInicio.Date
                If dateFechaFin.Date > Date.MinValue Then .FechaFin = dateFechaFin.Date
                dsDatos = .ConsultarReporteDetallado()
            End With
            If dsDatos IsNot Nothing Then
                DescargarReporte(dsDatos)
            Else
                miEncabezado.showWarning("No se encontraron resultados, según los filtros aplicados.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al descargar el reporte: " & ex.Message)
        End Try
    End Sub

    Private Sub DescargarReporte(ByVal dsReporte As DataSet)
        Dim nombreArchivo As String = GenerarArchivoExcel(dsReporte.Tables(0), dsReporte.Tables(1))
        If System.IO.File.Exists(nombreArchivo) Then
            MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo)
        Else
            miEncabezado.showWarning("Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente")
        End If

    End Sub

    Private Function GenerarArchivoExcel(ByVal dtNotificacion As DataTable, ByVal dtDetalle As DataTable) As String
        Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Archivos/PlantillaReporteNotificacionesCEM.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/PlantillaReporteNotificacionesCEM" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja1 As ExcelWorksheet
        Dim miHoja2 As ExcelWorksheet
        Dim numRegistros As Integer = 0
        Dim numDetalle As Integer = 0

        If File.Exists(rutaPlantilla) Then
            miExcel.LoadXlsx(rutaPlantilla, XlsxOptions.PreserveMakeCopy)
            miHoja1 = miExcel.Worksheets.Item(0)
            miHoja2 = miExcel.Worksheets.Item(1)
            'miHoja2 = miExcel.Worksheets.ActiveWorksheet
            numRegistros = miHoja1.InsertDataTable(dtNotificacion, "A5", False)
            numDetalle = miHoja2.InsertDataTable(dtDetalle, "A5", False)
            If numRegistros = 0 Or numDetalle = 0 Then miEncabezado.showWarning("No fue posible adicionar datos al archivo. Por favor intente nuevamente.")
        Else
            miHoja1 = miExcel.Worksheets.Add("Reporte Notificaciones CEM")
            miHoja2 = miExcel.Worksheets.Add("Detalle")
            With miHoja1
                numRegistros = miHoja1.InsertDataTable(dtNotificacion, "A5", True)
            End With
            With miHoja2
                numDetalle = miHoja2.InsertDataTable(dtDetalle, "A5", True)
            End With
        End If
        For index As Integer = 0 To dtNotificacion.Columns.Count - 1
            miHoja1.Columns(index).AutoFitAdvanced(1.1000000000000001)
        Next

        For index As Integer = 0 To dtDetalle.Columns.Count - 1
            miHoja2.Columns(index).AutoFitAdvanced(1.1000000000000001)
        Next

        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

#End Region

End Class