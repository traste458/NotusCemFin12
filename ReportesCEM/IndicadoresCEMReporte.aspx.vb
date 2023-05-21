Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports LMDataAccessLayer

Public Class IndicadoresCEMReporte1
    Inherits System.Web.UI.Page


#Region "Atributos"

    Private _idUsuario As Integer

#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Reporte Indicadores CEM")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
            Catch ex As Exception
                epNotificacion.showError("Se presento un error al cargar la página: " & ex.Message)
            End Try
            MetodosComunes.setGemBoxLicense()
            CargarTipoServicio()
            CargarEstado()

        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

#End Region


#Region "Métodos Privados"

    Private Sub CargarTipoServicio()
        Try
            Dim dt As New DataTable
            dt = HerramientasMensajeria.ConsultaTipoServicioActivos()
            MetodosComunes.CargarComboDX(ddlTipoServicio, dt, "idTipoServicio", "nombre")
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de tipos de servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarEstado()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarEstado
            MetodosComunes.CargarComboDX(cmbEstado, dtEstado, "idEstado", "nombre")
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de estados. " & ex.Message)
        End Try
    End Sub
    Private Function ConsultarReporte() As InfoResultado
        Dim reporte As New IndicadoresCEM
        Dim resul As New InfoResultado

        With reporte
            If Not String.IsNullOrEmpty(deFechaInicialAgenda.Value) Then .FechaInicialAgenda = CDate(deFechaInicialAgenda.Value)
            If Not String.IsNullOrEmpty(deFechaFinalAgenda.Value) Then .FechaFinalAgenda = CDate(deFechaFinalAgenda.Value)
            If Not String.IsNullOrEmpty(txtMsisdn.Text) Then .Msisdn = txtMsisdn.Text.Trim
            If Not String.IsNullOrEmpty(txtFechaCreacionInicial.Value) Then .FechaCreacionInicial = CDate(txtFechaCreacionInicial.Value)
            If Not String.IsNullOrEmpty(txtFechaCreacionFinal.Value) Then .FechaCreacionFinal = CDate(txtFechaCreacionFinal.Value)

            If Not String.IsNullOrEmpty(txtRadicado.Text) Then .Radicado = txtRadicado.Text.Trim
            If ddlTipoServicio.Value > 0 Then .IdTipoServicio = ddlTipoServicio.Value
            If cmbEstado.Value > 0 Then .IdEstado = cmbEstado.Value

        End With
        Dim fecha As String = DateTime.Now.ToString("HH:mm:ss:fff")
        fecha = fecha.Replace(":", "_").ToString()
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/" & "ReporteIndicadores_" & "_" & fecha & ".xlsx")
        Dim nombrePlantilla As String = Server.MapPath("~/ReportesCEM/Plantillas/PlantillaReporteIndicadoresCEM.xlsx")

        resul = reporte.ObtenerReporteIndicadoresCEM(nombreArchivo, nombrePlantilla)
        Return resul
    End Function


    Protected Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        Dim resultado As New ResultadoProceso
        Dim resul As New InfoResultado
        cpPrincipal.JSProperties("cpNombreArchivo") = ""
        cpPrincipal.JSProperties("cpMensaje") = ""
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)

                Case "DescargarReporteIndicadoresCEM"
                    resul = ConsultarReporte()
                    If resul.Valor > 0 Then
                        cpPrincipal.JSProperties("cpNombreArchivo") = resul.Mensaje
                    Else
                        epNotificacion.showWarning("No se encontraron registros con los filtros de búsqueda ")
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        cpPrincipal.JSProperties("cpMensaje") = epNotificacion.RenderHtml()
    End Sub

#End Region
End Class