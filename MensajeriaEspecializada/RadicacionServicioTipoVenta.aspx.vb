Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Public Class RadicacionServicioTipoVenta
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .setTitle("Radicación de Servicios Tipo Venta")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            CargaInicial()
        End If
    End Sub

    Protected Sub btnBuscarPlanilla_Click(sender As Object, e As EventArgs) Handles btnBuscarPlanilla.Click
        BuscarServicios()
    End Sub

    Protected Sub btnRadicar_Click(sender As Object, e As EventArgs) Handles btnRadicar.Click
        RadicarServicios()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarServicios()
        Try
            Dim objDetalleReferencia As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleReferencia
                .IdEstadoServicio = Enumerados.EstadoServicio.Legalizado
                .PlanillaLegalizacion = txtNoPlanilla.Text.Trim
                .CargarDatos()
            End With

            Dim dtDatos As DataTable = objDetalleReferencia.GenerarDataTable()
            If dtDatos.Rows.Count > 0 Then
                Session("dtDatos") = dtDatos
                With gvDatos
                    .PageIndex = 0
                    .DataSource = dtDatos
                    .DataBind()
                End With
                rpResultado.Visible = True
            Else
                miEncabezado.showWarning("No se encontaron servicios disponibles para radicación asociados a la planilla.")
                LimpiarFormulario()
            End If
        Catch ex As Exception
            miEncabezado.showError("No fué posible obtener los servicios: " & ex.Message)
        End Try
    End Sub

    Private Sub RadicarServicios()
        Try
            Dim dvDatos As DataView = DirectCast(Session("dtDatos"), DataTable).DefaultView
            Dim resultado As ResultadoProceso = ServicioMensajeriaVenta.RadicarServicios(txtNoVolante.Text.Trim, _
                                        CDbl(txtValorTotal.Text), dateFechaRadicacion.Date, dvDatos.ToTable(True, "IdServicio", "NumeroRadicado"))
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                LimpiarFormulario()
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar generar la radicación: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNoPlanilla.Text = String.Empty
        txtNoVolante.Text = String.Empty
        txtValorTotal.Text = String.Empty
        dateFechaRadicacion.Date = Nothing
        rpResultado.Visible = False
        Session.Remove("dtDatos")
    End Sub

    Private Sub CargaInicial()
        Try
            'Se realiza la restricción de la fecha de rdicación
            Dim diasRadicacion As String = MetodosComunes.seleccionarConfigValue("DIAS_RADICACION_VENTA")
            If IsNumeric(diasRadicacion) AndAlso CInt(diasRadicacion) > 0 Then
                With dateFechaRadicacion
                    .MinDate = Now.AddDays(-CInt(diasRadicacion))
                    .MaxDate = Now.AddDays(CInt(diasRadicacion))
                End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al al realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

#End Region

End Class