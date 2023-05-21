Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class PoolEntregasDavivienda
    Inherits System.Web.UI.Page

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            With epNotificador
                .setTitle("Pool Verificación Entregas")
            End With
            deFechaInicio.MaxDate = Date.Today
            deFechaFin.MaxDate = Date.Today
            'CargaInicial()
            'Verificar()
        Catch ex As Exception
            epNotificador.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub




    Protected Sub btnConsultar_Click(sender As Object, e As EventArgs) Handles btnConsultar.Click
        Try
            If deFechaInicio Is Nothing Or deFechaFin Is Nothing Then
                epNotificador.showError("Debe Seleccionar Las Fechas Para Generar Las Consultas")
            End If
            CargaInformeGestionVenta()
        Catch ex As Exception
            epNotificador.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        deFechaInicio.Date = Nothing
        deFechaFin.Date = Nothing
        If gvReporte.Settings.ShowHeaderFilterButton Then gvReporte.FilterExpression = String.Empty
        gvReporte.DataSource = Nothing
        gvReporte.DataBind()
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            ObtenerDatosReporte()
            Dim formato As String = cbFormatoExportar.Value
            If Not String.IsNullOrEmpty(formato) Then
                With gveExportador
                    .FileName = "GestionEntregas" + DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString()
                    .Landscape = False
                    With .Styles.Default.Font
                        .Name = "Arial"
                        .Size = FontUnit.Point(10)
                    End With
                    .DataBind()
                End With
                Select Case formato
                    Case "xls"
                        gveExportador.WriteXlsToResponse()
                    Case "pdf"
                        With gveExportador
                            .Landscape = True
                            .WritePdfToResponse()
                        End With
                    Case "xlsx"
                        gveExportador.WriteXlsxToResponse()
                    Case "csv"
                        gveExportador.WriteCsvToResponse()
                    Case Else
                        Throw New ArgumentNullException("Archivo no valido")
                End Select
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de exportar datos. ")
        End Try
    End Sub

#End Region

#Region "Metodos Privados"

    Public Sub ObtenerDatosReporte(Optional ByVal forzarConsulta As Boolean = False)
        Dim dtDatos As DataTable
        Dim FechaInicial As String
        Dim FechaFinal As String

        If Session("dtPoolEntregas") Is Nothing OrElse forzarConsulta Then
            Dim infoReferido As New ILSBusinessLayer.CrearCargueRealceDavivienda 'GestionComercial.GestionDeVenta
            With infoReferido

                FechaInicial = deFechaInicio.Date.Year
                If deFechaInicio.Date.Month < 10 Then FechaInicial = FechaInicial & "0"
                FechaInicial = FechaInicial & deFechaInicio.Date.Month
                If deFechaInicio.Date.Day < 10 Then FechaInicial = FechaInicial & "0"
                FechaInicial = FechaInicial & deFechaInicio.Date.Day

                FechaFinal = deFechaFin.Date.Year
                If deFechaFin.Date.Month < 10 Then FechaFinal = FechaFinal & "0"
                FechaFinal = FechaFinal & deFechaFin.Date.Month
                If deFechaFin.Date.Day < 10 Then FechaFinal = FechaFinal & "0"
                FechaFinal = FechaFinal & deFechaFin.Date.Day

                dtDatos = .ObtenerEntregaPoolDavivienda(FechaInicial, FechaFinal)

            End With
        Else
            dtDatos = Session("dtPoolEntregas")
        End If

        If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
            'pnlResultado.Visible = True
            EnlazarDatos(dtDatos)
        Else
            epNotificador.showWarning("No se encontraron datos según los filtros aplicados.")
        End If
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        With gvReporte
            .DataSource = dtDatos
            .KeyFieldName = "idGestionVenta"
            .DataBind()
        End With
        Session("dtReporteEntregas") = dtDatos
    End Sub

    Private Sub CargaInformeGestionVenta()
        Try
            Dim dtVenta As New DataTable
            Dim objVenta As New ILSBusinessLayer.CrearCargueRealceDavivienda
            Dim FechaInicial As String
            Dim FechaFinal As String

            FechaInicial = deFechaInicio.Date.Year
            If deFechaInicio.Date.Month < 10 Then FechaInicial = FechaInicial & "0"
            FechaInicial = FechaInicial & deFechaInicio.Date.Month
            If deFechaInicio.Date.Day < 10 Then FechaInicial = FechaInicial & "0"
            FechaInicial = FechaInicial & deFechaInicio.Date.Day

            FechaFinal = deFechaFin.Date.Year
            If deFechaFin.Date.Month < 10 Then FechaFinal = FechaFinal & "0"
            FechaFinal = FechaFinal & deFechaFin.Date.Month
            If deFechaFin.Date.Day < 10 Then FechaFinal = FechaFinal & "0"
            FechaFinal = FechaFinal & deFechaFin.Date.Day

            With objVenta
                dtVenta = .ObtenerEntregaPoolDavivienda(FechaInicial, FechaFinal)
            End With

            Session("dtPoolEntregas") = dtVenta
            gvReporte.DataBind()

        Catch ex As Exception
            epNotificador.showError("Se generó un error al cargar los datos " & ex.Message)
        End Try
    End Sub

    Private Sub gvPoolVentas_DataBinding(sender As Object, e As EventArgs) Handles gvReporte.DataBinding
        If Session("dtPoolEntregas") Is Nothing Then
        Else
            gvReporte.DataSource = Session("dtPoolEntregas")
        End If
    End Sub

#End Region

End Class