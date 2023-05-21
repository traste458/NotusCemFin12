Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes

Public Class ReporteServiciosPorCallCenter
    Inherits System.Web.UI.Page

#Region "Atributos"


#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Reporte Servicios por CallCenter")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim param As String = e.Parameter
        Select Case param
            Case "BusquedaGeneral"
                GenerarReporte()
                CargaInicial()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        gvDatos.DataSource = Session("dtDatos")
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveDatos
                .FileName = "Reporte Servicios por CallCenter"
                '.ReportHeader = "Reporte Servicios por CallCenter" & vbCrLf & vbCrLf
                '.ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            Select Case formato
                Case "xls"
                    gveDatos.WriteXlsToResponse()
                Case "pdf"
                    With gveDatos
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveDatos.WriteXlsxToResponse()
                Case "csv"
                    gveDatos.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Dim idUsuario As Integer = 0
        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

        'Carga los CallCenter
        Dim dtCall As DataTable = HerramientasMensajeria.ObtenerCallCenter(idUsuario)
        Session("dtCiudad") = dtCall
        MetodosComunes.CargarComboDX(cmbCallCenter, dtCall, "idCallCenter", "nombre")
    End Sub

    Private Sub GenerarReporte()
        Dim reporte As New ServiciosPorCallCenterReporte
        Dim dtReporte As New DataTable
        Dim resultado As New ResultadoProceso
        Try
            With reporte
                If cmbCallCenter.Value > 0 Then .IdCallCenter = cmbCallCenter.Value
                If dateFechaInicio.Date > Date.MinValue Then .FechaInicio = dateFechaInicio.Date
                If dateFechaFin.Date > Date.MinValue Then .FechaFinal = dateFechaFin.Date
                dtReporte = .GenerarReporte()
            End With

            If dtReporte.Rows.Count > 0 Then
                Session("dtDatos") = dtReporte
                EnlazarReporte(dtReporte)
            Else
                resultado.EstablecerMensajeYValor(1, "<i> No se encontraron resultados de acuerdo a los filtros aplicados. </i>")
            End If

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al generar el reporte: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarReporte(ByVal dtDatos As DataTable)
        With gvDatos
            .PageIndex = 0
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

#End Region

End Class