Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports DevExpress.Web

Public Class ReactivarServicio
    Inherits System.Web.UI.Page
    Property idServicio As Integer
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            With miEncabezado
                .setTitle("Reactivar Sevicio")
                .showReturnLink("PoolServiciosNew.aspx")
            End With
            If Not IsPostBack Then
                If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
                If idServicio > 0 Then
                    hfReactivarIdServicio.Value = idServicio.ToString
                Else
                    miEncabezado.showError("Se presentó un error al cargar la informacion por favor intente de nuevo: ")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub
    'Private Sub lbReactivar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbReactivar.Click
    '    ReactivarServicio()
    'End Sub
#Region "MetodosPrivados"
    'Private Sub ReactivarServicio()
    '    Try
    '        Dim resultado As ResultadoProceso
    '        Dim miServicio As New ServicioMensajeria

    '        Dim idUsuario As Integer
    '        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)

    '        Dim nuevoRadicado As Long
    '        Long.TryParse(txtNuevoRadicado.Text, nuevoRadicado)

    '        With miServicio
    '            .IdServicioMensajeria = CInt(hfReactivarIdServicio.Value)
    '            resultado = .Reactivar(idUsuario, txtObservacionReactivacion.Text, Enumerados.EstadoServicio.Creado, nuevoRadicado)
    '        End With
    '        If resultado.Valor = 0 Then
    '            miEncabezado.showSuccess("El servicio fue reactivado satisfactoriamente.")
    '        Else
    '            If resultado.Valor = 1 Or resultado.Valor = 10 Then
    '                miEncabezado.showWarning(resultado.Mensaje)
    '            Else
    '                miEncabezado.showError(resultado.Mensaje)
    '            End If
    '        End If
    '    Catch ex As Exception
    '        miEncabezado.showError("Error al tratar de reactivar servicio. " & ex.Message)
    '    End Try
    'End Sub

#End Region

    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "consultarRadicado"
                    Dim resultado As Boolean
                    resultado = ServicioMensajeria.ExisteNumeroRadicado(arryAccion(1))
                    imgError.ClientVisible = resultado
                    If resultado Then
                        txtNuevoRadicado.Text = ""
                        txtNuevoRadicado.ClientVisible = True
                    End If
                    miEncabezado.showError("El número de radicado digitado ya existe. ")
                Case "ReactivarServicio"
                    Try
                        Dim resultado As ResultadoProceso
                        Dim miServicio As New ServicioMensajeria

                        Dim idUsuario As Integer
                        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)

                        Dim nuevoRadicado As Long
                        Long.TryParse(txtNuevoRadicado.Text, nuevoRadicado)

                        With miServicio
                            .IdServicioMensajeria = CInt(hfReactivarIdServicio.Value)
                            resultado = .Reactivar(idUsuario, txtObservacionReactivacion.Text, Enumerados.EstadoServicio.Creado, nuevoRadicado)
                        End With
                        If resultado.Valor = 0 Then
                            miEncabezado.showSuccess("El servicio fue reactivado satisfactoriamente.")
                            lbReactivar.ClientEnabled = False

                            ASPxWebControl.RedirectOnCallback("PoolServiciosNew.aspx")
                        Else
                            If resultado.Valor = 1 Or resultado.Valor = 10 Then
                                miEncabezado.showWarning(resultado.Mensaje)
                            Else
                                miEncabezado.showError(resultado.Mensaje)
                            End If
                        End If
                    Catch ex As Exception
                        miEncabezado.showError("Error al tratar de reactivar servicio. " & ex.Message)
                    End Try
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Private Sub ReactivarServicio(sender As Object)
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria

            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)

            Dim nuevoRadicado As Long
            Long.TryParse(txtNuevoRadicado.Text, nuevoRadicado)

            With miServicio
                .IdServicioMensajeria = CInt(hfReactivarIdServicio.Value)
                resultado = .Reactivar(idUsuario, txtObservacionReactivacion.Text, Enumerados.EstadoServicio.Creado, nuevoRadicado)
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("El servicio fue reactivado satisfactoriamente.")

            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de reactivar servicio. " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
End Class