Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ReporteServiciosSiembraAbiertos
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Reporte Servicios SIEMBRA Abiertos")
            End With

            CargaInicial()
        End If
    End Sub

    Private Sub gvServicios_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvServicios.CustomCallback
        Try
            CargarDatos()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar la información: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvServicios_DataBinding(sender As Object, e As System.EventArgs) Handles gvServicios.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvServicios.DataSource = Session("dtDatos")
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(ByVal source As Object, ByVal e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                If Not String.IsNullOrEmpty(formato) Then
                    With gveServicios
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
                            gveServicios.WriteXlsToResponse()
                        Case "pdf"
                            With gveServicios
                                .Landscape = True
                                .WritePdfToResponse()
                            End With
                        Case "xlsx"
                            gveServicios.WriteXlsxToResponse()
                        Case "csv"
                            gveServicios.WriteCsvToResponse()
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
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
            CargarDatos()
        Catch ex As Exception
            miEncabezado.showError("Se generó un erro al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatos()
        Dim objReporteMateriales As New ReporteServiciosSiembraAbiertosBLL()
        With objReporteMateriales
            If dateFechaInicio.Value IsNot Nothing Then .FechaInicial = dateFechaInicio.Value
            If dateFechaFin.Value IsNot Nothing Then .FechaFinal = dateFechaFin.Value
            .NumeroDias = seNoDias.Value
        End With

        With gvServicios
            .DataSource = objReporteMateriales.ObtenerReporte()
            Session("dtDatos") = .DataSource
            .DataBind()
        End With
    End Sub

#End Region

End Class