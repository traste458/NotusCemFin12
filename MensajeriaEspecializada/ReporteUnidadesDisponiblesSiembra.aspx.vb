Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ReporteUnidadesDisponiblesSiembra
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Reporte Unidades Disponibles SIEMBRA")
                End With
                CargarFiltros()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        BuscarRegistros()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(ByVal source As Object, ByVal e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                If Not String.IsNullOrEmpty(formato) Then

                    With gveDatos
                        .FileName = "Reporte_Inventario_Disponible_Siembra_" + Now.Year.ToString() + Now.Month.ToString() + Now.Day.ToString()
                        .ReportHeader = "Reporte Inventario Disponible SIEMBRA" & vbCrLf
                        .ReportFooter = "Logytech Mobile S.A.S"
                        .Landscape = False

                        With .Styles
                            .Default.Font.Size = FontUnit.Point(10)
                            .Default.Font.Name = "Arial"

                            .Title.HorizontalAlign = HorizontalAlign.Center
                            .Title.Font.Size = FontUnit.Point(20)
                            .Title.Font.Bold = True
                            .Title.Font.Name = "Arial"

                            .Header.HorizontalAlign = HorizontalAlign.Center
                            .Header.Font.Size = FontUnit.Point(15)
                            .Header.Font.Bold = True
                            .Header.Font.Name = "Arial"

                            .Footer.HorizontalAlign = HorizontalAlign.Center

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

    Private Sub BuscarRegistros()
        Try
            Dim objReporte As New ReporteUnidadesDisponiblesSiembraBLL
            With objReporte
                If cmbCiudad.Value > 0 Then .IdCiudad = cmbCiudad.Value
            End With

            With gvDatos
                .DataSource = objReporte.ObtenerReporte()
                Session("dtDatos") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al buscar los registros: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarFiltros()
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            'Se cargan las Ciudades
            Dim dtCiudad As DataTable = HerramientasMensajeria.ObtenerCiudadesCem()
            With cmbCiudad
                .DataSource = dtCiudad
                Session("dtCiudades") = .DataSource
                .DataBind()
                If dtCiudad.Rows.Count = 1 Then .SelectedIndex = 0
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de cargar los filtros:" & ex.Message)
        End Try
    End Sub

#End Region

End Class