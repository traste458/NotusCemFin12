Imports System.Text
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes
Imports DevExpress.Web

Public Class LiberarServicio
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            With miEncabezado
                .setTitle("Liberación - Servicio de Mensajer&iacute;a")
            End With
            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With
            If idServicio > 0 Then
                Dim infoServicio As New ServicioMensajeriaVentaCorporativa(idServicio:=idServicio)
                Dim resultado As New ResultadoProceso
                If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
                    hdServicio.Set("idServicio", infoServicio.IdServicioMensajeria)
                    CargarInformacionServicio(infoServicio)
                Else
                    miEncabezado.showWarning("No fué posible encontrar los datos del servicio.")
                End If
            End If
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "LiberarServicio"
                    LiberarServicio()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcNovedades_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcNovedades.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "verNovedades"
                    CargaInicialNovedad()
                    cmbNovedad.Focus()
                Case "Registra"
                    RegistrarNovedad()
                    cmbNovedad.Focus()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarInformacionServicio(ByVal infoServicio As ServicioMensajeriaVentaCorporativa)
        lblIdServicio.Text = infoServicio.IdServicioMensajeria
        lblEstado.Text = infoServicio.Estado
        lblCliente.Text = infoServicio.NombreCliente
        lblTipoServicio.Text = infoServicio.TipoServicio
    End Sub

    Private Sub CargaInicialNovedad()
        Dim dtEstado As New DataTable
        dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.LiberacionServicio)
        MetodosComunes.CargarComboDX(cmbNovedad, dtEstado, "idTipoNovedad", "descripcion")
        CargarNovedades(hdServicio.Get("idServicio"))
    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub RegistrarNovedad()
        Dim resultado As ResultadoProceso
        Dim novedad As New NovedadServicioMensajeria
        With novedad
            .IdServicioMensajeria = hdServicio.Get("idServicio")
            .Observacion = meJustificacion.Text.Trim
            .IdTipoNovedad = CInt(cmbNovedad.Value)
            resultado = .Registrar(CInt(Session("usxp001")))
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                meJustificacion.Text = ""
                cmbNovedad.SelectedIndex = -1
                CargaInicialNovedad()
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        End With
    End Sub

    Private Sub LiberarServicio()
        Dim resultado As New ResultadoProceso
        Dim objServicio As New ServicioMensajeriaVentaCorporativa
        With objServicio
            .IdServicioMensajeria = hdServicio.Get("idServicio")
            .IdUsuario = CInt(Session("usxp001"))
            resultado = .LiberarServicio()
        End With

        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If

    End Sub

#End Region

End Class