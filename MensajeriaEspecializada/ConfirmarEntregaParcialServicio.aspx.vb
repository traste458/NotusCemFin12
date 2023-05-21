Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class ConfirmarEntregaParcialServicio
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()

        If Not Me.IsPostBack Then
            With epNotificador
                .setTitle("Confirmar Entrega Parcial - Mensajería Especializada")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            CargarTiposDeNovedad()

            txtNumRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            txtSerial.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
        End If
    End Sub

    Protected Sub btnRecibir_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRecibir.Click
        RecibirSeriales()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub RecibirSeriales()
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objDetalleServicio As New DetalleSerialServicioMensajeria(txtSerial.Text)
            Dim resultado As ResultadoProceso = objDetalleServicio.MarcarDevolucion(idUsuario, CLng(txtNumRadicado.Text))

            If resultado.Valor = 0 Then
                Dim objNovedad As New NovedadServicioMensajeria()
                objNovedad.IdServicioMensajeria = objDetalleServicio.IdServicio
                objNovedad.IdTipoNovedad = ddlNovedad.SelectedValue
                objNovedad.IdUsuario = idUsuario
                objNovedad.Observacion = txtObservacion.Text
                objNovedad.Registrar(idUsuario)

                epNotificador.showSuccess("Se realizó la entrega parcial del registro correctamente.")
                LimpiarCampos()
            Else
                epNotificador.showWarning("No se logro realizar la entrega parcial: " & resultado.Mensaje)
            End If
        Catch ex As Exception
            epNotificador.showError("Imposible realizar la recepción: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=5)
            With ddlNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad...", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarCampos()
        ddlNovedad.SelectedIndex = -1
        txtObservacion.Text = ""
        txtNumRadicado.Text = ""
        txtSerial.Text = ""
        ddlNovedad.Focus()
    End Sub

#End Region

End Class