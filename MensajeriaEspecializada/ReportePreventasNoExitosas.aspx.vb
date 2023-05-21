Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes

Public Class ReportePreventasNoExitosas
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
                .setTitle("Reporte Preventas No Exitosas")
            End With
            CargaInicial()
            rpExportal.Visible = False
            rpResultadoBusqueda.Visible = False
        End If
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs) Handles btnFiltrar.Click
        GenerarReporte()
    End Sub

    Protected Sub btnXlsExport_Click(sender As Object, e As EventArgs) Handles btnXlsExport.Click
        If Session("dtDatos") IsNot Nothing Then
            EnlazarReporte(DirectCast(Session("dtDatos"), DataTable))
            gveDatos.WriteXlsToResponse()
        Else
            miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
        End If
        
    End Sub

    Protected Sub btnXlsxExport_Click(sender As Object, e As EventArgs) Handles btnXlsxExport.Click
        If Session("dtDatos") IsNot Nothing Then
            EnlazarReporte(DirectCast(Session("dtDatos"), DataTable))
            gveDatos.WriteXlsxToResponse()
        Else
            miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
        End If
        
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        LimpiarControles()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        gvDatos.DataSource = Session("dtDatos")
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
        Dim reporte As New PreventasNoExitosasReporte
        Dim dtReporte As New DataTable
        Dim idEstados As New ConfigValues("ESTADOS_REPORTE_PREVENTAS_NO")
        Dim resultado As New ResultadoProceso
        Try
            With reporte
                If cmbCallCenter.Value > 0 Then .IdCallCenter = cmbCallCenter.Value
                .IdEstados = idEstados.ConfigKeyValue
                If dateFechaInicio.Date > Date.MinValue Then .FechaInicio = dateFechaInicio.Date
                If dateFechaFin.Date > Date.MinValue Then .FechaFinal = dateFechaFin.Date
                dtReporte = .GenerarReporte
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
        rpExportal.Visible = True
        rpResultadoBusqueda.Visible = True
    End Sub

    Private Sub LimpiarControles()
        Session.Remove("dtDatos")
        rpExportal.Visible = False
        rpResultadoBusqueda.Visible = False
        CargaInicial()
        cmbCallCenter.Value = Nothing
        dateFechaInicio.Text = ""
        dateFechaFin.Text = ""
    End Sub

#End Region

End Class