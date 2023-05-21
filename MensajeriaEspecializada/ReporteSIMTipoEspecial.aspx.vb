Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class ReporteSIMTipoEspecial
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            epNotificacion.clear()

            If Not IsPostBack Then
                With epNotificacion
                    .setTitle("Reporte SIMs Sueltas, Backup y MicroSIMs")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With

                txtFechaInicial.Value = Now.ToString("dd/MM/yyyy")
                txtFechaFinal.Value = Now.ToString("dd/MM/yyyy")

                Dim dtDatos As DataTable
                dtDatos = CargarPool()
                If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                    EnlazarDatos(dtDatos)
                Else
                    epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                End If
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub lbBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbBuscar.Click
        Buscar()
    End Sub

    Private Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbQuitarFiltros.Click
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        Buscar()
    End Sub

    Protected Sub lbGenerarReporte_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGenerarReporte.Click
        GenerarReporte()
    End Sub

    Protected Sub lbReporteControl_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbReporteControl.Click
        GenerarReporteControl()
    End Sub

    Private Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Dim idReporte As Integer
        Try
            Integer.TryParse(e.CommandArgument.ToString, idReporte)
            If e.CommandName = "Exportar" Then
                If Session("dtReporteTipoSIM") IsNot Nothing Then
                    Dim fila As DataRow = CType(Session("dtReporteTipoSIM"), DataTable).Select("idReporte=" & idReporte.ToString())(0)
                    Dim nombreArchivo As String = fila("nombreArchivo").ToString()

                    GestionTipoSIMEspeciales.GenerarRutaArchivo(idReporte, Server.MapPath("ReportesTipoSIM\") & nombreArchivo)
                    Buscar()

                    Dim RutaRelativa As String = "../MensajeriaEspecializada/ReportesTipoSIM/" & nombreArchivo & ""
                    Response.Redirect(RutaRelativa, True)
                Else
                    epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
                End If
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al exportar el archivo: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos"

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal expOrdenamiento As String = "")
        Try
            pnlResultados.Visible = True

            Dim dvDatos As DataView = dtDatos.DefaultView
            If expOrdenamiento.Trim.Length > 0 Then dvDatos.Sort = expOrdenamiento

            With gvDatos
                .DataSource = dvDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Session("dtReporteTipoSIM") = dvDatos.ToTable()
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub Buscar()
        Try
            Dim dtDatos As DataTable
            dtDatos = CargarPool()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                EnlazarDatos(dtDatos)
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible obtener resultados: " & ex.Message)
        End Try
    End Sub

    Private Sub GenerarReporte()
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objTipoSIM As New GestionTipoSIMEspeciales()
            Dim resultado As ResultadoProceso = objTipoSIM.GenerarReporte(idUsuario)
            If resultado.Valor = 0 Then
                epNotificacion.showSuccess(resultado.Mensaje)
            Else
                epNotificacion.showWarning(resultado.Mensaje)
            End If
            Buscar()
        Catch ex As Exception
            epNotificacion.showError("Imposible generar los reportes: " & ex.Message)
        End Try
    End Sub

    Private Sub GenerarReporteControl()
        Try
            Dim nombreArchivo As String = "ReporteDeControl.xls"
            GestionTipoSIMEspeciales.GenerarReporteControl(Server.MapPath("ReportesTipoSIM\") & nombreArchivo)
            Dim RutaRelativa As String = "../MensajeriaEspecializada/ReportesTipoSIM/" & nombreArchivo & ""
            Response.Redirect(RutaRelativa, True)
        Catch ex As Exception
            epNotificacion.showError("Imposible generar reporte de control: " & ex.Message)
        End Try
    End Sub

    Private Function CargarPool() As DataTable
        Dim dtDatos As New DataTable
        Dim datos As New GestionTipoSIMEspeciales()

        Try
            With datos
                If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicio = CDate(txtFechaInicial.Value)
                If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFin = CDate(txtFechaFinal.Value)
            End With
            dtDatos = datos.ObtenerDatos()

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return dtDatos
    End Function

    Private Function ObtenerDireccionOrdenamiento(ByVal columna As String) As String
        Dim direccionOrdenamiento = "ASC"
        Dim expresionOrdenamiento = TryCast(ViewState("ExpresionOrdenamiento"), String)
        If expresionOrdenamiento IsNot Nothing Then
            If expresionOrdenamiento = columna Then
                Dim ultimaDirection = TryCast(ViewState("DireccionOrdenamiento"), String)
                If ultimaDirection IsNot Nothing AndAlso ultimaDirection = "ASC" Then direccionOrdenamiento = "DESC"
            End If
        End If
        ViewState("DireccionOrdenamiento") = direccionOrdenamiento
        ViewState("ExpresionOrdenamiento") = columna
        Return direccionOrdenamiento
    End Function

#End Region

End Class