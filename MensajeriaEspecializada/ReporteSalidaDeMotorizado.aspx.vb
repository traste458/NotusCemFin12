Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports LMDataAccessLayer
Public Class ReporteSalidaDeMotirados
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
                    .setTitle("Reporte Salida De Motorizados")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
            Catch ex As Exception
                epNotificacion.showError("Se presento un error al cargar la página: " & ex.Message)
            End Try
            MetodosComunes.setGemBoxLicense()
            CargarCiudades()
            CargarBodegas()

        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

#End Region


#Region "Métodos Privados"

    Private Sub CargarCiudades()
        Try
            Dim dt As New DataTable
            dt = HerramientasMensajeria.ObtenerCiudadesCem()
            MetodosComunes.CargarComboDX(ddlCiudad, dt, "idCiudad", "Ciudad")
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarBodegas()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarBodega()
            MetodosComunes.CargarComboDX(cmbBodegas, dtEstado, "idbodega", "bodega")
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub
    Private Function ConsultarReporte() As InfoResultado
        Dim reporte As New IndicadoresCEM
        Dim resul As New InfoResultado

        With reporte
            If Not String.IsNullOrEmpty(txtRadicado.Text) Then .Radicado = txtRadicado.Text.Trim
            If Not String.IsNullOrEmpty(txtDocResponsable.Text) Then .Msisdn = txtDocResponsable.Text.Trim
            If Not String.IsNullOrEmpty(deFechaInicialAgenda.Value) Then .FechaInicialAgenda = CDate(deFechaInicialAgenda.Value)
            If Not String.IsNullOrEmpty(deFechaFinalAgenda.Value) Then .FechaFinalAgenda = CDate(deFechaFinalAgenda.Value)
            If Not String.IsNullOrEmpty(txtFechaAsignacionInicial.Value) Then .FechaCreacionInicial = CDate(txtFechaAsignacionInicial.Value)
            If Not String.IsNullOrEmpty(txtFechaAsignacionFinal.Value) Then .FechaCreacionFinal = CDate(txtFechaAsignacionFinal.Value)
            If Not String.IsNullOrEmpty(txtFechaTransitoInicial.Value) Then .FechaCreacionInicial = CDate(txtFechaTransitoInicial.Value)
            If Not String.IsNullOrEmpty(txtFechaTransitoFinal.Value) Then .FechaCreacionFinal = CDate(txtFechaTransitoFinal.Value)
            If ddlCiudad.Value > 0 Then .IdTipoServicio = ddlCiudad.Value
            If cmbBodegas.Value > 0 Then .IdEstado = cmbBodegas.Value

        End With
        Dim fecha As String = DateTime.Now.ToString("HH:mm:ss:fff")
        fecha = fecha.Replace(":", "_").ToString()
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/" & "ReporteSalidaMotorizados_" & "_" & fecha & ".xlsx")
        Dim nombrePlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/ReporteSalidaMotorizados.xlsx")

        resul = reporte.ObtenerReporteSalidaMotorizado(nombreArchivo, nombrePlantilla)
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

                Case "DescargarReporteMotorizados"
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