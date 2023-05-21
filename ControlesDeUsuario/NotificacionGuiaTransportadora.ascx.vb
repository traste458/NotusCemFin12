Imports ILSBusinessLayer
Imports System.Collections.Generic
Imports DevExpress.Web
Imports System.IO
Imports Microsoft.Azure.Storage.Blob

Public Class NotificacionGuiaTransportadora
    Inherits System.Web.UI.UserControl

    Public Property NumeroGuia As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim oSoporte As New SoporteNotificacionTransportadora
            Dim numGuia As String = NumeroGuia

            If numGuia IsNot Nothing Then
                Dim listaSoportes As New List(Of SoporteNotificacionEntidad)
                listaSoportes = oSoporte.ObtenerSoporte(numGuia)

                If listaSoportes.Count > 0 Then
                    With gvSoporteNotificacion
                        .DataSource = listaSoportes
                        .DataBind()
                    End With
                Else
                    With gvSoporteNotificacion
                        .DataSource = Nothing
                        .DataBind()
                    End With
                End If
            Else
                With gvSoporteNotificacion
                    .DataSource = Nothing
                    .DataBind()
                End With
            End If
        End If

    End Sub

    Protected Sub gvSoporteNotificacion_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSoporteNotificacion.RowCommand

        Dim descarga As Boolean = False
        Try
            Dim oGestion As New GestionArchivosAzureStorage
            Dim rutaAzureArchivo As String = e.CommandArgument.ToString()
            descarga = oGestion.DescargarArchivoPorRuta(rutaAzureArchivo)

            If Not descarga Then
                Throw New Exception("No se realizó descarga del archivo.")
            End If
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

End Class