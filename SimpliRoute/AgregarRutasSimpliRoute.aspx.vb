Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.SimpliRouteEntidad
Imports Newtonsoft.Json

Public Class AgregarRutasSimpliRoute
    Inherits System.Web.UI.Page

    Dim contador As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        Dim ws As New ServicioRest
        'Session("usxp001") = 1

        With miEncabezado
            .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            .setTitle("Sincronizar visitas SimpliRoute")
        End With
    End Sub

    Private Sub btnAsync_Click(sender As Object, e As EventArgs) Handles btnAsync.Click
        limpiarFormulario()
        ConsultarServiciosSinRuta()
    End Sub

    Sub limpiarFormulario()
        btnCrearRuta.Visible = False
        miEncabezado.clear()
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
        gvRadicados.DataSource = Nothing
        gvRadicados.DataBind()
        gvRutas.DataSource = Nothing
        gvRutas.DataBind()
        cpRadicados.ClientVisible = False
        rpRutas.ClientVisible = False
        pcRutas.ClientVisible = False
        cperrores.ClientVisible = False
        gvServis.DataSource = Nothing
        gvServis.DataBind()
        cpServicios.ClientVisible = False
        gvServis.Visible = False
    End Sub

    Public Sub ConsultarServiciosSinRuta()

        Dim dt, dtServicios As DataTable
        Dim dtResult As New ResultadoEntidad
        Dim rt As New RutasSimpleRout
        Dim ws As New ServicioRest
        Dim Resultado, resDrv As New ResultadoProceso
        Dim obj As New Body
        Dim cantidadInicial, cantidadFinal As Integer

        Dim Res As String = ""
        Dim objDriver As New ResponseUsuario
        Dim ResDvr As String = ""
        'Dim url As String = Comunes.ConfigValues.seleccionarConfigValue("URL_WS_SIMPLI_ROUTE")
        Dim rest As New ServicioRest

        rt.IdUsuario = Session("usxp001")
        dt = rt.ConsultarVisitas()
        dt.Columns.Add(New DataColumn("idUsuario", GetType(System.Int64), CInt(Session("usxp001"))))
        dt.AcceptChanges()
        Session("cantEnviada") = dt.Rows.Count
        Session("dtServiciosSinRuta") = dt
        If dt.Rows.Count > 0 Then
            'Envia informacion a WS Interno  - quien es el encargado de gestionar las visitas de simpliRoute
            rest.IdUsuario = CInt(Session("usxp001"))
            rest.Token = Comunes.ConfigValues.seleccionarConfigValue("TOKEN_EXPUESTO_SIMPLIROUTE")

            dtResult = rest.AgregarRutas(dt)

            Session("Result") = dtResult

            If dtResult.Valor = 0 Then
                dtServicios = rt.ConsultarVisitasUsuario
                Session("cantRecibida") = dtServicios.Rows.Count
                cantidadInicial = Session("cantEnviada")
                cantidadFinal = Session("cantRecibida")
                If (cantidadInicial = cantidadFinal) Or (contador = 1) Then
                    If dtServicios.Rows.Count > 0 Then
                        cpServicios.ClientVisible = True
                        gvServis.Visible = True
                        btnCrearRuta.Visible = True
                        gvServis.DataSource = dtServicios
                        gvServis.DataBind()
                        lbCantidad.Text = "Cantidad enviada: " & cantidadInicial & " Cantidad Sincronizada: " & cantidadFinal & " !"
                    Else
                        miEncabezado.showError("Se enviarón. " & cantidadInicial & " servicios. " & "Pero no se encontraron motorizados asignados en simpli route!.")
                    End If
                Else
                    contador = contador + 1
                    ConsultarServiciosSinRuta()
                End If
            End If
            Else
                miEncabezado.showError("No existen registros para sincronizar!.")
        End If
    End Sub

    Private Sub btnCrearRuta_Click(sender As Object, e As EventArgs) Handles btnCrearRuta.Click
        Dim dtError As DataTable
        Dim dtResult As New ResultadoEntidad
        Dim rt As New RutasSimpleRout
        Dim ws As New ServicioRest
        Dim Resultado, resDrv As New ResultadoProceso
        Dim obj As New Body
        Dim Res As String = ""
        Dim objDriver As New ResponseUsuario
        Dim ResDvr As String = ""
        'Dim url As String = Comunes.ConfigValues.seleccionarConfigValue("URL_WS_SIMPLI_ROUTE")
        Dim rest As New ServicioRest

        If Session("Result") IsNot Nothing Then
            With rt
                .IdUsuario = Session("usxp001")
                Resultado = .crearRutasPorMotorizado()
                Session("cantidad") = Resultado.Valor
                Dim totalReg As Integer = Session("cantidad")
                If .DtDatos IsNot Nothing Then
                    cpServicios.ClientVisible = False
                    gvServis.Visible = False
                    pcRutas.ClientVisible = True
                    gvRutas.DataSource = .DtDatos
                    gvRutas.DataBind()
                    rpRutas.ClientVisible = True
                Else
                    miEncabezado.showWarning("no hay registros parar crear rutas!.")
                End If

                dtError = dtResult.ResultadoNovedades
                If dtError IsNot Nothing AndAlso dtError.Rows.Count > 0 Then
                    cperrores.ClientVisible = True
                    gvErrores.DataSource = dtError
                    gvErrores.DataBind()
                    miEncabezado.showError("Verifique el log de errores!.")
                Else
                    miEncabezado.showSuccess("Se sincronizaron, " & totalReg.ToString() & " Registros!.")
                End If
            End With
        Else
            If dtResult.ResultadoNovedades IsNot Nothing Then
                If dtResult.ResultadoNovedades.Rows.Count > 0 Then
                    cperrores.ClientVisible = True
                    gvErrores.DataSource = dtResult.ResultadoNovedades
                    gvErrores.DataBind()
                    miEncabezado.showError("Verifique el log de errores!.")
                End If
            End If
        End If

    End Sub


    Private Sub cpSincroniza_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpSincroniza.Callback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "VerRadicados"
                    Dim dtRadicados As New DataTable
                    dtRadicados = MensajeriaEspecializada.RutaServicioMensajeria.ObtenerRadicadosPorId(arryAccion(1))
                    With gvRadicados
                        .DataSource = dtRadicados
                        .DataBind()
                        cpRadicados.Visible = True
                        cpRadicados.ClientVisible = True
                    End With
                    cpRadicados.ClientVisible = True
                    cpRadicados.Visible = True
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch
        End Try

    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
        Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
        lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
    End Sub


End Class

