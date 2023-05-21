Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ReporteMaterialServicioSiembra
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Reporte Materiales SIEMBRA")
            End With

            CargaInicial()
        End If
    End Sub

    Private Sub gvMateriales_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvMateriales.CustomCallback
        Try
            CargarDatos()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar la información: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvMateriales_DataBinding(sender As Object, e As System.EventArgs) Handles gvMateriales.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvMateriales.DataSource = Session("dtDatos")
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(ByVal source As Object, ByVal e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                If Not String.IsNullOrEmpty(formato) Then
                    With gveMateriales
                        .FileName = "Reporte_Materiales_SIEMBRA_" + Now.Year.ToString() + Now.Month.ToString() + Now.Day.ToString()
                        .ReportHeader = "Reporte de Materiales SIEMBRA" & vbCrLf
                        .ReportFooter = "Logytech Mobile S.A.S"
                        .Landscape = False
                        With .Styles.Default.Font
                            .Name = "Arial"
                            .Size = FontUnit.Point(10)
                        End With
                        .DataBind()
                    End With
                    Select Case formato
                        Case "xls"
                            gveMateriales.WriteXlsToResponse()
                        Case "pdf"
                            With gveMateriales
                                .Landscape = True
                                .WritePdfToResponse()
                            End With
                        Case "xlsx"
                            gveMateriales.WriteXlsxToResponse()
                        Case "csv"
                            gveMateriales.WriteCsvToResponse()
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

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            dateFechaInicio.Date = MetodosComunes.ObtienePrimerDiaDeMes(Now.Date)
            dateFechaFin.Date = MetodosComunes.ObtieneUltimoDiadeMes(Now.Date)

            CargarDatos()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatos()
        Dim objReporteMateriales As New ReporteMaterialesSiembraBLL()
        With objReporteMateriales
            If dateFechaInicio.Value IsNot Nothing Then .FechaInicial = dateFechaInicio.Value
            If dateFechaFin.Value IsNot Nothing Then .FechaFinal = dateFechaFin.Value
        End With

        With gvMateriales
            .DataSource = objReporteMateriales.ObtenerReporte()
            Session("dtDatos") = .DataSource
            .DataBind()
        End With
    End Sub

#End Region

End Class