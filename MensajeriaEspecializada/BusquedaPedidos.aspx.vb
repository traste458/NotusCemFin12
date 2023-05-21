Imports ILSBusinessLayer.Pedidos
Imports DevExpress.Web
Imports ILSBusinessLayer

Public Class BusquedaPedidosGenerales
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            CType(sender, ASPxCallbackPanel).JSProperties.Remove("cpLimpiarFiltros")
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            'Session("causal") = cmbCausal.Value
            Select Case arrayAccion(0)
                Case "ConsultarPedido"
                    Dim resultado As ResultadoProceso
                    Dim _consultaDetalle As New Pedido
                    With _consultaDetalle
                        resultado = .ComprobarReferencia(tbNumeroPedido.Text, rblReferencia.Value)
                        If resultado.Valor <> 1 Then
                            Session("numEntrega") = resultado.Valor
                            ASPxWebControl.RedirectOnCallback(VirtualPathUtility.ToAbsolute("~/TrazabilidadPedidos/TrazabilidadPedidos.aspx"))
                        Else
                            epNotificador.showWarning("El numero de referencia que ingreso no extiste, por favor verifique.")
                        End If

                    End With
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        Catch ex As Exception
            epNotificador.showError(ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epNotificador.RenderHtml()
    End Sub

End Class