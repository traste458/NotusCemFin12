Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class DevolucionParcialServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()

        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Devolución de Radicados con Entrega Parcial")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                CargarTiposDeNovedad()
                txtNumeroRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbRegistrar.Click
        RegistrarDevolucion()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub RegistrarDevolucion()
        Dim resultado As New ResultadoProceso
        Dim objDevolucionCEM As New DevolucionCEM
        Dim _idUsuario As Integer
        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), _idUsuario)
        Try
            With objDevolucionCEM
                .NumeroRadicado = txtNumeroRadicado.Text.Trim
                .IdNovedad = ddlNovedad.SelectedValue
                .IdUsuario = _idUsuario
            End With
            resultado = objDevolucionCEM.RegistrarDevolucionParcial()
            If resultado.Valor = 0 Then
                epNotificacion.showSuccess("Se realizo el registro de la devolución satifactoriamente.")
                LimpiarFiltros()
            Else
                epNotificacion.showWarning(resultado.Mensaje)
                LimpiarFiltros()
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar registrar la devolución: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtNumeroRadicado.Text = ""
        ddlNovedad.SelectedIndex = -1
        txtNumeroRadicado.Focus()
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
            epNotificacion.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

#End Region

End Class