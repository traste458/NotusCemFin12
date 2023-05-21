Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ConsultaMaterialCantidadPorRadicado
    Inherits System.Web.UI.Page
#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Consulta la Cantidad de Material solicitada Por Radicado")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))

                End With

            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
        If gvDatosResultado.IsCallback Then CargarDatos()
    End Sub
    Protected Sub GvDatosResultadoDataBinding(sender As Object, e As EventArgs) Handles gvDatosResultado.DataBinding
        gvDatosResultado.DataSource = Session("dtDatos")
    End Sub
    Protected Sub GvDatosResultadoCustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatosResultado.CustomCallback

        Dim valor As String = e.Parameters
        ConsultarRadicados()

        EnlazarDatos(Session("dtDatos"))

    End Sub
    Protected Sub LbLimpiarClick(sender As Object, e As EventArgs) Handles lbLimpiar.Click
        LimpiarFiltro()
    End Sub

    Protected Sub BtnExportarClick(sender As Object, e As EventArgs) Handles btnExportar.Click
        Try
            If Session("dtDatos") IsNot Nothing Then
                exporter.WriteXlsxToResponse("Consulta Radicados")

            Else
                epNotificacion.showError("No se encontraron datos para exportar. Por favor vuelva a generar el reporte")
            End If
        Catch abEx As System.Threading.ThreadAbortException
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de exportar el reporte. " & ex.Message)
        End Try
    End Sub
#End Region
#Region "Médotos Privados"

    Private Sub LimpiarFiltro()
        Try
            MemoRadicado.Text = String.Empty
            Session.Remove("dtDatos")
            EnlazarDatos(New DataTable())

        Catch ex As Exception
            epNotificacion.showError("Error al limpiar filtros: " & ex.Message)
        End Try
    End Sub
    Private Sub CargarDatos()
        Try
            EnlazarDatos(Session("dtDatos"))
        Catch ex As Exception
            epNotificacion.showError("Error al limpiar filtros: " & ex.Message)
        End Try
    End Sub
    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            With gvDatosResultado
                .PageIndex = 0
                .DataSource = dtDatos
                .DataBind()
            End With
        Catch ex As Exception
            epNotificacion.showError("Se generó error al enlazar datos: " & ex.Message)
        End Try
    End Sub
    Private Sub ConsultarRadicados()
        Dim dtDatos As New DataTable
        Const tamanoParticion As Integer = 400
        Dim particiones As Integer = 0
        With gvDatosResultado
            .DataSource = Nothing
            .DataBind()
        End With
        Try
            Dim arrRadicados As New ArrayList(MemoRadicado.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
            particiones = Math.Ceiling((arrRadicados.Count / tamanoParticion))

            For i As Integer = 0 To particiones - 1 Step 1
                Dim arrParticion As ArrayList
                If i <> particiones - 1 Then
                    arrParticion = arrRadicados.GetRange(i * tamanoParticion, tamanoParticion)
                Else
                    arrParticion = arrRadicados.GetRange(i * tamanoParticion, arrRadicados.Count - i * tamanoParticion)
                End If
                HerramientasMensajeria.ObtenerMateriaCantidadPorRadicado(dtDatos, arrParticion)
            Next
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron datos.</i>")
            End If
            Session("dtDatos") = dtDatos
        Catch ex As Exception
            epNotificacion.showError("Error al consultar los Radicados: " & ex.Message)
        End Try
    End Sub
#End Region

End Class