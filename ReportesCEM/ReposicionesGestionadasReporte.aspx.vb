Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports System.Text
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion
Imports GemBox.Spreadsheet
Imports System.Collections.Generic

Partial Public Class ReposicionesGestionadasReporte
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idUsuario As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Reporte Reposiciones Gestionadas")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
            Catch ex As Exception
                epNotificacion.showError("Se presento un error al cargar la página: " & ex.Message)
            End Try
            MetodosComunes.setGemBoxLicense()
            CargarTipoServicio()
            panelReporte.Style.Add("display", "none")
            panelResultado.Style.Add("display", "block")
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        e.Cancel = True
        Dim dtDatos As DataTable = Session("dtDatos")
        gvDatos.PageIndex = e.NewPageIndex
        EnlazarDatos(dtDatos)
    End Sub

    Protected Sub lbFiltrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbFiltrar.Click
        CargarReporte()
    End Sub

    Protected Sub lbBorrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBorrar.Click
        LimpiarControles()
    End Sub

    Protected Sub lbReporte_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbReporte.Click
        DescargarArchivo()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarTipoServicio()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultaTipoServicio
            With ddlTipoServicio
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Tipo Servicio", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de tipos de servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count & " Registro(s) encontrado(s)"
                .DataBind()
                .PageIndex = 0
            End With
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
        End Try
    End Sub

    Private Sub CargarReporte()
        Try
            Dim dtDatos As DataTable
            dtDatos = ConsultarReporte()
            If Not IsNothing(dtDatos) Then
                EnlazarDatos(dtDatos)
            End If
            If dtDatos IsNot Nothing Then
                If dtDatos.Rows.Count > 0 Then
                    panelResultado.Style.Add("display", "block")
                    panelReporte.Style.Add("display", "block")
                Else
                    panelReporte.Style.Add("display", "none")
                    panelResultado.Style.Add("display", "none")
                    epNotificacion.showWarning(" <i> No se encontraron resultados con los filtros aplicados <i>")
                End If
            Else
                epNotificacion.showWarning(" <i> No se encontraron resultados con los filtros aplicados <i>")
            End If
        Catch ex As Exception
            epNotificacion.showError("Se presento un error al consultar los datos. " & ex.Message)
        End Try
    End Sub

    Private Function ConsultarReporte() As DataTable
        Dim reporte As New ReposicionesGestionadas
        Dim dtDatos As DataTable

        With reporte
            If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicialAgenda = CDate(txtFechaInicial.Value)
            If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFinalAgenda = CDate(txtFechaFinal.Value)
            If Not String.IsNullOrEmpty(txtMsisdn.Text) Then .Msisdn = txtMsisdn.Text.Trim
            If Not String.IsNullOrEmpty(txtRadicado.Text) Then .Radicado = txtRadicado.Text.Trim
            If ddlTipoServicio.SelectedValue > 0 Then .idTipoServicio = ddlTipoServicio.SelectedValue

        End With

        dtDatos = reporte.ObtenerReporte
        Session("dtDatos") = dtDatos

        Return dtDatos

    End Function

    Private Sub LimpiarControles()
        panelReporte.Style.Add("display", "none")
        panelResultado.Style.Add("display", "none")
        txtFechaFinal.Value = ""
        txtFechaInicial.Value = ""
        txtMsisdn.Text = ""
        txtRadicado.Text = ""
        CargarTipoServicio()
    End Sub

    Private Sub DescargarArchivo()
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtDatos"), DataTable)

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

    Private Function GenerarArchivoExcel(ByVal dtDatos As DataTable) As String
        Dim rutaPlantilla As String = Server.MapPath("~/ReportesCEM/Plantillas/PlantillaReposicionesGestionadas.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/ReposicionesGestionadas" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim filaActual As Integer = 4
        Dim filaRango As Integer = 1
        Dim auxFecha As Date
        Dim numRegistros As Integer = 0
        If File.Exists(rutaPlantilla) Then
            miExcel.LoadXlsx(rutaPlantilla, XlsxOptions.PreserveMakeCopy)
            miHoja = miExcel.Worksheets.ActiveWorksheet
            numRegistros = miHoja.InsertDataTable(dtDatos, "A4", False)
            If numRegistros = 0 Then epNotificacion.showWarning("No fue posible adicionar datos al archivo. Por favor intente nuevamente.")
        Else
            miHoja = miExcel.Worksheets.Add("Reporte Reposiciones Gestionadas")

            With miHoja

                numRegistros = miHoja.InsertDataTable(dtDatos, "A4", True)
            End With
        End If
        For index As Integer = 0 To dtDatos.Columns.Count - 1
            miHoja.Columns(index).AutoFitAdvanced(1.1)
        Next
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

#End Region

End Class