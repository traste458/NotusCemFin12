Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Diagnostics
Imports System.IO
Imports System.IO.FileStream

Public Class DescargaRemision
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private idDocumento As Integer
    Private origen As String
    Private ruta As String
    Private nombre As String

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim rutaDocumento As String
        Try
            Integer.TryParse(Request.Params("id"), idDocumento)
            origen = Request.Params("origen")
            ruta = Request.Params("ruta")
            nombre = Request.Params("nombre")

            If idDocumento > 0 Then
                If origen = "RemisionSinHub" Then
                    rutaDocumento = ruta

                    Dim fs As FileStream = New FileStream(ruta + nombre, FileMode.Open, FileAccess.Read)
                    Dim fileData As Byte()
                    ReDim fileData(fs.Length)
                    Dim bytesRead As Long = fs.Read(fileData, 0, CInt(fs.Length))
                    fs.Close()
                    Dim sFileExt As String = Split(nombre, ".")(1)

                    Response.ClearContent()
                    Response.ClearHeaders()

                    Response.AddHeader("Content-Disposition", "attachment; filename=" & nombre.Replace(" ", "_") & "")
                    Response.ContentType = "application/pdf"
                    Response.AddHeader("Content-length", bytesRead.ToString())
                    Response.BinaryWrite(fileData)
                Else
                    Dim objDocumento As New DocumentoServicioMensajeria(idDocumento:=idDocumento)
                    With objDocumento
                        rutaDocumento = Server.MapPath("~/MensajeriaEspecializada/") & .RutaAlmacenamiento & "\" & .IdentificadorUnico.ToString()

                        Response.AddHeader("Content-Disposition", "attachment; filename=" & .NombreArchivo.Replace(" ", "_") & "")
                        Response.ContentType = .TipoContenido
                        Response.TransmitFile(rutaDocumento)
                        Response.End()
                    End With
                End If
            Else
                miEncabezado.showWarning("No se logro obtener el identificador del documento, por favor regrese a la página anterior.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar la página: " & ex.Message)
        End Try
    End Sub

#End Region

End Class