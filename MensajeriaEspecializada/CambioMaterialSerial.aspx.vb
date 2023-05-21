Imports System.IO
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer

Partial Public Class CambioMaterialSerial
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            epNotificacion.clear()

            If Not IsPostBack Then
                With epNotificacion
                    .setTitle("Cambio de Material")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))

                    CargaInicial()
                End With
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub lbProcesar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbProcesar.Click
        ProcesarArchivo()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub ProcesarArchivo()
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            If fuArchivo.HasFile AndAlso (Not String.IsNullOrEmpty(fuArchivo.PostedFile.FileName)) Then
                Dim dtArchivo As New DataTable
                dtArchivo.Columns.Add(New DataColumn("Mensaje", GetType(String)))

                Dim objCambioMaterial As New CambioMaterialCEM(idUsuario)
                Dim resultado As List(Of ResultadoProceso) = objCambioMaterial.ProcesarArchivo(fuArchivo.PostedFile.InputStream)

                If resultado.Count = 0 Then
                    epNotificacion.showSuccess("Se realizó el cambio de material exitosamente.")
                    pnlErrores.Visible = False
                Else
                    epNotificacion.showWarning("No se logro realizar el cambio de material, por favor verifique el log de resultados e intente nuevamente.")
                    For Each item As ResultadoProceso In resultado
                        registraError(dtArchivo, item.Valor, item.Mensaje)
                    Next
                    pnlErrores.Visible = True
                End If
                gvErrores.DataSource = dtArchivo
                gvErrores.DataBind()
            Else
                Throw New Exception("No se logro obtener el nombre del archivo.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible procesar: " & ex.Message)
        End Try
    End Sub

    Private Sub registraError(ByRef dtDatos As DataTable, ByVal linea As Integer, ByVal mensaje As String)
        Try
            Dim row As DataRow = dtDatos.NewRow()
            row.Item("mensaje") = "Linea " & linea & ": " & mensaje
            dtDatos.Rows.Add(row)
            dtDatos.AcceptChanges()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

End Class