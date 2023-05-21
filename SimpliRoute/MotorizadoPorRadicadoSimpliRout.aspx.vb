Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.SimpliRouteEntidad
Imports Newtonsoft.Json
Imports Microsoft.VisualBasic
Imports System
Imports DevExpress.Export
Imports DevExpress.Utils
Imports DevExpress.XtraPrinting
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports System.IO

Public Class MotorizadoPorRadicadoSimpliRout
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session("usxp001") = 1

        With miEncabezado
            .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            .setTitle("Motorizados visitas SimpliRoute")
        End With
    End Sub

    Private Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If (txtRadicado.Text <> "") Or (txtRuta.Text <> "") Then
            miEncabezado.clear()
            obtenerMotorizadosPorRadicado()
        Else
            miEncabezado.showError("Diligencie algún dato para continuar con la busqueda.!")
        End If
    End Sub

    Private Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        limpiarFormulario()
    End Sub

    Sub limpiarFormulario()
        txtRadicado.Text = ""
        gvMotorizados.DataSource = Nothing
        gvMotorizados.DataBind()
        miEncabezado.clear()
        txtRuta.Text = ""
    End Sub

    Sub obtenerMotorizadosPorRadicado()
        Dim rt As New RutasSimpleRout
        Dim dt As DataTable

        With rt
            .Id = txtRadicado.Text
            If txtRuta.Text <> "" Then
                .IdRuta = txtRuta.Text
            End If
            dt = .ObtenerMotorizadoPorRadicado()
            If dt.Rows.Count > 0 Then
                gvMotorizados.DataSource = dt
                gvMotorizados.DataBind()
            Else
                limpiarFormulario()
                miEncabezado.showWarning("No se encontrarón rutas asociadas")
            End If
        End With

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