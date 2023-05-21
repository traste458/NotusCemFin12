Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class RegistrarNovedadServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
#If DEBUG Then
        Session("usxp001") = 20821
        Session("usxp009") = 126
        Session("usxp007") = 1
#End If
        If Not IsPostBack Then
            With epNotificador
                .setTitle("Confirmar Entrega de Servicio")
                If Request.QueryString("flag") IsNot Nothing Then
                Else
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End If

                CargaInicial()
            End With
            txtNoRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
        Else

        End If
    End Sub

    Protected Sub lbAdicionarNovedad_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAdicionarNovedad.Click
        AdicionarNovedad()
    End Sub

#End Region

#Region "Métodos"

    Private Sub CargaInicial()
        Try
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ObtenerTiposDeNovedad(Enumerados.ProcesoMensajeria.Entrega), CType(ddlNovedad, ListControl))
        Catch ex As Exception
            epNotificador.showError(ex.Message)
        End Try
    End Sub

    Private Sub AdicionarNovedad()
        Try
            Dim resultado As ResultadoProceso = NovedadServicioMensajeria.RegistrarNovedadEntregaServicio(Convert.ToInt64(txtNoRadicado.Text), ddlNovedad.SelectedValue, Convert.ToInt32(Session("usxp001")))
            If resultado.Valor = 0 Then
                epNotificador.showSuccess("Novedad creada correctamente.")
                LimpiarFormulario()
            Else
                epNotificador.showWarning(resultado.Mensaje)
            End If

        Catch ex As Exception
            epNotificador.showError(ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNoRadicado.Text = ""
        ddlNovedad.SelectedIndex = -1
    End Sub

#End Region

End Class