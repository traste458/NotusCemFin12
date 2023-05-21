Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class ReporteAutomarcado
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()

        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Resporte Automarcado")
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

            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try

        End If
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtReporteAutomarcar") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtReporteAutomarcar"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos desde memoria, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Dim idAutomarcado As Integer
        Try
            Integer.TryParse(e.CommandArgument.ToString, idAutomarcado)

            If e.CommandName = "Exportar" Then
                If Session("dtReporteAutomarcar") IsNot Nothing Then
                    Dim fila As DataRow = CType(Session("dtReporteAutomarcar"), DataTable).Select("idAutomarcado=" & idAutomarcado.ToString())(0)
                    Dim nombreArchivo As String = fila("nombreArchivo").ToString()

                    GestionAutomarcado.GenerarRutaArchivo(idAutomarcado, Server.MapPath("ReportesAutomarcado\") & nombreArchivo)
                    Buscar()

                    Dim RutaRelativa As String = "../MensajeriaEspecializada/ReportesAutomarcado/" & nombreArchivo & ""
                    Response.Redirect(RutaRelativa, True)
                Else
                    epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
                End If
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al exportar el archivo: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dtReporteAutomarcar") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtReporteAutomarcar"), DataTable)
                Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
                EnlazarDatos(dtDatos, expOrdenamiento)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Buscar()
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        Buscar()
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
            Session("dtReporteAutomarcar") = dvDatos.ToTable()
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

    Private Function CargarPool() As DataTable
        Dim dtEstado As New DataTable
        Dim datos As New GestionAutomarcado()

        Try
            With datos
                If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicio = CDate(txtFechaInicial.Value)
                If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFin = CDate(txtFechaFinal.Value)
            End With
            dtEstado = datos.ObtenerDatos()

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return dtEstado
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