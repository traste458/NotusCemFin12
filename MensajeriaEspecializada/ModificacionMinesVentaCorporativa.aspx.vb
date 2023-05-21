Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.WMS
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class ModificacionMinesVentaCorporativa
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .setTitle("Detalle - Servicio Mensajer&iacute;a")
            End With
            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With
            If idServicio > 0 Then
                hdIdServicio.Set("idServicio", idServicio)
                CargarDetalleServicio(idServicio)
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            Dim lnkBloqueo As ASPxHyperLink = templateContainer.FindControl("lnkBloqueo")
            Dim lnkFacturar As ASPxHyperLink = templateContainer.FindControl("lnkFacturar")

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("objReferencias") IsNot Nothing Then gvDatos.DataSource = Session("objReferencias")
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "editar"
                    resultado = EditarServicio(arryAccion(1))
                    If resultado.Valor = 0 Then
                        CargarDetalleServicio(hdIdServicio.Get("idServicio"))
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcGeneral_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcGeneral.WindowCallback
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "inicial"
                    txtMsisdn.Text = arryAccion(1)
                    hdIdServicio.Set("Msisdn", arryAccion(1))
                    lblIdServicio.Text = hdIdServicio.Get("idServicio")
                    CargarDetalleServicio(hdIdServicio.Get("idServicio"))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarDetalleServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeriaVentaCorporativa
        infoServicio = New ServicioMensajeriaVentaCorporativa(idServicio)
        With gvDatos
            .DataSource = infoServicio.DetalleServicio
            Session("objReferencias") = .DataSource
            .DataBind()
        End With
    End Sub

    Private Function EditarServicio(ByVal msisdnAnt As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objDetalle As New ServicioMensajeriaVentaCorporativa(hdIdServicio.Get("idServicio"))
        With objDetalle
            resultado = .EditarMsisdn(txtMsisdn.Text.Trim, msisdnAnt)
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

#End Region

    
End Class