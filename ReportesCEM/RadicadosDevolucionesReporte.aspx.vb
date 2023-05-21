Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports System.Text
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion
Imports GemBox.Spreadsheet
Imports System.Collections.Generic

Partial Public Class RadicadosDevolucionesReporte
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
                    .setTitle("Reporte Radicado Devoluciones")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
            Catch ex As Exception
                epNotificacion.showError("Se presento un error al cargar la página: " & ex.Message)
            End Try
            MetodosComunes.setGemBoxLicense()
            CargarCiudad()
            CargarBodega()
            CargarTipoServicio()
            panelReporte.Style.Add("display", "none")
            panelResultado.Style.Add("display", "block")
        End If
        _idUsuario = CInt(Session("usxp001"))
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

    Private Sub gvDevolucion_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDevolucion.RowCommand
        Dim numeroRadicado As Long
        Try
            Long.TryParse(e.CommandArgument, numeroRadicado)
            Select Case e.CommandName
                Case "VerOcultarDetalle"
                    Dim ibAux As ImageButton = CType(e.CommandSource, ImageButton)
                    Dim auxRow As GridViewRow = CType(ibAux.NamingContainer, GridViewRow)
                    Dim gv As GridView = CType(auxRow.FindControl("gvDatosDetalle"), GridView)
                    Dim pnlDetalle As Panel = CType(auxRow.FindControl("pnlDetalle"), Panel)
                    Dim estatus As String = pnlDetalle.Style.Item("display")

                    If estatus = "none" Then
                        Dim dtDatosDetalle As DataTable = CType(Session("dtDatosDetalle"), DataTable)
                        pnlDetalle.Style.Item("display") = "block"
                        ibAux.ImageUrl = "~/images/contraer.png"
                        EnlazarDetalle(dtDatosDetalle, gv, numeroRadicado)
                    Else
                        gv.DataBind()
                        ibAux.ImageUrl = "~/images/expandir.png"
                        pnlDetalle.Style.Item("display") = "none"
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de procesar comando. " & ex.Message)
        End Try

    End Sub

    Private Sub gvDevolucion_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDevolucion.PageIndexChanging
        e.Cancel = True
        Dim dtDatos As DataTable = Session("dtDatos")
        gvDevolucion.PageIndex = e.NewPageIndex
        EnlazarDatos(dtDatos)
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarCiudad()
        Dim dtEstado As New DataTable
        Dim datos As New Ciudad
        Try
            dtEstado = Ciudad.ObtenerCiudadesPorPais
            With ddlCiudad
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Ciudad", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarBodega()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarBodega
            With ddlBodega
                .DataSource = dtEstado
                .DataTextField = "bodega"
                .DataValueField = "idbodega"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Bodega", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

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
            With gvDevolucion
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count & " Registro(s) encontrado(s)"
                .DataBind()
                .PageIndex = 0
            End With
            MetodosComunes.mergeGridViewFooter(gvDevolucion)
        Catch ex As Exception
        End Try
    End Sub

    Private Sub EnlazarDetalle(ByVal dtDatos As DataTable, ByVal gvDetalle As GridView, ByVal numeroRadicado As Long)
        If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count Then
            Dim dtAux As DataTable = dtDatos
            Dim dvDetalle As DataView = dtAux.DefaultView
            dvDetalle.RowFilter = "numeroRadicado = " & numeroRadicado
            With gvDetalle
                .DataSource = dvDetalle
                .DataBind()
            End With
        Else
            gvDetalle.DataBind()
        End If
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
        Dim reporte As New RadicadosDevoluciones
        Dim dsReporte As DataSet
        Dim dtDatos As DataTable
        Dim dtDatosExtendido As DataTable
        Dim dtDetalle As DataTable

        With reporte
            If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicialAgenda = CDate(txtFechaInicial.Value)
            If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFinalAgenda = CDate(txtFechaFinal.Value)
            If Not String.IsNullOrEmpty(txtFechaInicialDevolucion.Value) Then .FechaInicialDevolucion = CDate(txtFechaInicialDevolucion.Value)
            If Not String.IsNullOrEmpty(txtFechaFinalDevolucion.Value) Then .FechaFinalDevolucion = CDate(txtFechaFinalDevolucion.Value)
            If Not String.IsNullOrEmpty(txtFechaInicialReagendamiento.Value) Then .FechaInicialReagendamiento = CDate(txtFechaInicialReagendamiento.Value)
            If Not String.IsNullOrEmpty(txtFechaFinalReagendamiento.Value) Then .FechaFinalReagendamiento = CDate(txtFechaFinalReagendamiento.Value)
            If Not String.IsNullOrEmpty(txtFechaInicialCierre.Value) Then .FechaInicialCierre = CDate(txtFechaInicialCierre.Value)
            If Not String.IsNullOrEmpty(txtFechaFinalCierre.Value) Then .FechaFinalCierre = CDate(txtFechaFinalCierre.Value)
            If ddlCiudad.SelectedValue > 0 Then .IdCiudad = ddlCiudad.SelectedValue
            If ddlBodega.SelectedValue > 0 Then .IdBodega = ddlBodega.SelectedValue
            If Not String.IsNullOrEmpty(txtMsisdn.Text) Then .Msisdn = txtMsisdn.Text.Trim
            If Not String.IsNullOrEmpty(txtRadicado.Text) Then .Radicado = txtRadicado.Text.Trim
            If Not String.IsNullOrEmpty(txtSerial.Text) Then .Serrial = txtSerial.Text.Trim
            If ddlTipoServicio.SelectedValue > 0 Then .TipoServicio = ddlTipoServicio.SelectedValue
        End With

        dsReporte = reporte.ObtenerReporte

        dtDatos = dsReporte.Tables("dtReporte")
        dtDatosExtendido = dsReporte.Tables("dtReporteExtendido")

        dtDetalle = reporte.ObtenerDetalle


        Session("dtDatos") = dtDatos
        Session("dtDatosExtendido") = dtDatosExtendido
        Session("dtDatosDetalle") = dtDetalle

        Return dtDatos

    End Function

    Private Sub LimpiarControles()
        panelReporte.Style.Add("display", "none")
        panelResultado.Style.Add("display", "none")
        txtFechaFinal.Value = ""
        txtFechaInicial.Value = ""
        txtFechaFinalDevolucion.Value = ""
        txtFechaInicialDevolucion.Value = ""
        txtFechaFinalReagendamiento.Value = ""
        txtFechaInicialReagendamiento.Value = ""
        txtFechaFinalCierre.Value = ""
        txtFechaInicialCierre.Value = ""
        CargarCiudad()
        CargarBodega()
        CargarTipoServicio()
        txtMsisdn.Text = ""
        txtRadicado.Text = ""
        txtSerial.Text = ""
    End Sub

    Private Sub DescargarArchivo()
        Try
            If Session("dtDatosExtendido") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtDatosExtendido"), DataTable)

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
        Dim rutaPlantilla As String = Server.MapPath("~/ReportesCEM/Plantillas/PlantillaReporteRadicadoDevolucion.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/ReporteRadicadoDevolucion" & Session("usxp001") & ".xls")
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
            miHoja = miExcel.Worksheets.Add("Reporte Radicado Devolucion")

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