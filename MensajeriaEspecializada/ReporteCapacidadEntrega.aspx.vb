Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports LMDataAccessLayer
Imports System.Text
Imports DevExpress.Web

Partial Public Class ReporteCapacidadesDeEntrega
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            'Seguridad.verificarSession(Me)
            MetodosComunes.setGemBoxLicense()
            miEncabezado.clear()
            If Not Me.IsPostBack Then
                miEncabezado.setTitle("Reporte Capacidades de Entrega")
                miEncabezado.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarJornadas(ddlJornada)
                CargarClientes(ddlCliente)
                CargarAgrupaciones(ddlAgrupacion)
                CargarBodega()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarJornadas(ByVal ddl As DropDownList)
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaJornadaMensajeria()
            With ddl
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idJornada"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja una Jornada...", "0"))
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar el listado de Jornadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarClientes(ByVal ddl As DropDownList)
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaClientesEmpresa()
            With ddl
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idEmpresa"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja un Cliente...", "0"))
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar el listado de clientes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarAgrupaciones(ddl As DropDownList)
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaAgrupacionServicio()
            With ddl
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idAgrupacion"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione una agrupación...", "0"))
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar el listado de Agrupaciones. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        ddlJornada.ClearSelection()
        ddlAgrupacion.ClearSelection()
        ddlBodega.ClearSelection()
        gvdatos.DataSource = Nothing
        gvdatos.DataBind()
        dateFechaInicio.Value = String.Empty
        dateFechaFin.Value = String.Empty
    End Sub

    Protected Sub btnExportador_Click(sender As Object, e As EventArgs)
        Dim resultado As New InfoResultado
        If Session("nombreArchivoExportar") IsNot Nothing Then
            resultado = TryCast(Session("nombreArchivoExportar"), InfoResultado)
            If resultado.Valor > 0 Then
                Dim fullnombreArchivo As String = resultado.Mensaje
                Dim nombreMostrar As String = System.IO.Path.GetFileName(fullnombreArchivo)
                Response.Clear()
                Response.ClearContent()
                Response.AppendHeader("Content-Disposition", "attachment; filename=" & nombreMostrar)
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                Response.ContentEncoding = Encoding.UTF8
                Response.WriteFile(fullnombreArchivo)
                Response.Flush()
                Response.End()
                'MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, fullnombreArchivo, nombreMostrar)
            Else
                miEncabezado.showSuccess(resultado.Mensaje)
            End If
        End If
    End Sub
#End Region

    Protected Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        Dim infoCapacidad As New InfoCapacidadEntregaServicioMensajeriaColeccion
        Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PantillaReporteCapacidadEntrega.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/" & "ReporteCapacidadEntrega" & Session("usxp001") & ".xlsx")
        Try
            Dim dt As DataTable
            With infoCapacidad
                If (dateFechaInicio.Value IsNot Nothing) Then
                    .FechaInicial = CDate(dateFechaInicio.Value)
                End If
                If (dateFechaFin.Value IsNot Nothing) Then
                    .FechaFinal = CDate(dateFechaFin.Value)
                End If
                .IdJornada = ddlJornada.SelectedValue
                .IdAgrupacion = ddlAgrupacion.SelectedValue
                .IdEmpresa = ddlCliente.SelectedValue
                .IdBodega = ddlBodega.SelectedValue
                Session.Remove("nombreArchivoExportar")
                Session.Remove("dtDatos")
                Dim resultado As New InfoResultado
                resultado = .ReporteCapacidadesEntrega(nombreArchivo, rutaPlantilla)
                dt = .ReporteCapacidadesEntrega()
                Session("dtDatos") = dt
               
                Session("nombreArchivoExportar") = resultado
                If Session("nombreArchivoExportar") IsNot Nothing Then
                    miEncabezado.showSuccess("Se encontraron: " & resultado.Valor & " Registros")
                    gvdatos.ClientVisible = True
                    With gvdatos
                        .DataSource = dt
                        .DataBind()
                    End With
                    CType(sender, ASPxCallbackPanel).JSProperties("cpResultadoProceso") = 1
                    btnExportador.ClientVisible = True
                Else
                    gvdatos.ClientVisible = False
                    miEncabezado.showWarning("No se encontraron registros con el filtro utilizados " & resultado.Mensaje)
                    CType(sender, ASPxCallbackPanel).JSProperties("cpResultadoProceso") = 0
                End If

            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Exportar el archivo: " & ex.Message)
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = 0
        End Try
    End Sub
    Private Sub gvdatos_DataBinding(sender As Object, e As EventArgs) Handles gvdatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvdatos.DataSource = CType(Session("dtDatos"), DataTable)
    End Sub
    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        LimpiarFormulario()
    End Sub
    Private Sub CargarBodega()
        Dim dtBodega As New DataTable
        Try
            dtBodega = HerramientasMensajeria.ConsultarBodega()
            With ddlBodega
                .DataSource = dtBodega
                .DataTextField = "bodega"
                .DataValueField = "idbodega"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione una Bodega...", "0"))
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

End Class