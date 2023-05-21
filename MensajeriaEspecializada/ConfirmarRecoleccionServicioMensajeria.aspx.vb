Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes

Public Class ConfirmarRecoleccionServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Confirmación de Recolección de Equipos")
                End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            Select Case CInt(rblTipoServicio.Value)
                Case Enumerados.TipoServicio.Siembra
                    ConfirmarRecoleccionSiembra()

                Case Enumerados.TipoServicio.ServicioTecnico
                    ConfirmarRecoleccionST()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar procesar callback: " + ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub ConfirmarRecoleccionSiembra()
        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Dim numOrden As Long = CLng(txtNumeroServicioOrden.Text)

        Dim respuesta As ResultadoProceso = ServicioMensajeriaSiembra.ConfirmarRecoleccion(idUsuario, numOrden, CInt(txtNumEquiposRecogidos.Text))

        If respuesta.Valor = 0 Then
            miEncabezado.showSuccess(respuesta.Mensaje)

            'Se obtiene la información del servicio
            Dim objDetalleOrden As New DetalleDespachoServicioMensajeriaColeccion(numOrden)
            If objDetalleOrden.Count > 0 Then
                EnviarNotificacion(objDetalleOrden(0).IdServicio)
            End If
            LimpiarFormulario()
        Else
            miEncabezado.showWarning(respuesta.Mensaje)
        End If
    End Sub

    Private Sub ConfirmarRecoleccionST()
        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Dim respuesta As ResultadoProceso = ServicioMensajeria.ConfirmarRecoleccion(idUsuario, CLng(txtNumeroServicioOrden.Text), CInt(txtNumEquiposRecogidos.Text))

        If respuesta.Valor = 0 Then
            miEncabezado.showSuccess(respuesta.Mensaje)
            LimpiarFormulario()
        Else
            miEncabezado.showWarning(respuesta.Mensaje)
        End If
    End Sub

    Private Sub LimpiarFormulario()
        rblTipoServicio.SelectedIndex = -1
        txtNumeroServicioOrden.Text = String.Empty
        txtNumEquiposRecogidos.Text = String.Empty
    End Sub


    Private Sub EnviarNotificacion(numRadicado As Long)
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(numRadicado)
            If objServicio.Registrado AndAlso objServicio.IdTipoServicio = Enumerados.TipoServicio.Siembra Then
                If objServicio.FechaDevolucion = Date.MinValue Then objServicio.FechaDevolucion = Now

                Dim objMail As New EMailManager(AsuntoNotificacion.Tipo.Notificación_Devolución_Servicio_Siembra, objServicio)
                With objMail
                    If Not String.IsNullOrEmpty(objServicio.EmailConsultor) Then .AdicionarDestinatario(objServicio.EmailConsultor)
                    .EnviarMail()
                End With
            End If
        Catch ex As Exception
            miEncabezado.showWarning("No se logró enviar notificación al Consultor: " & ex.Message)
        End Try
    End Sub

#End Region

End Class