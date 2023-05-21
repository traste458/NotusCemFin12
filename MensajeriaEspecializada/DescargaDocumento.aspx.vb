Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports System.IO
Imports System.Web

Public Class DescargaDocumento
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private idDocumento As Integer
    Private _strArchivo As Stream

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim rutaDocumento As String = ""
        Dim flag As Integer = 0

        Try
            If Request.QueryString("rutaDocumento") IsNot Nothing Then
                rutaDocumento = Request.QueryString("rutaDocumento")
                If Request.QueryString("id") IsNot Nothing Then
                    flag = Request.QueryString("id")
                End If
            End If
            If rutaDocumento.Length > 0 Then
                Response.AddHeader("Content-Disposition", "attachment; filename=GuiaGeneradaDoc" & flag & ".pdf")
                Response.ContentType = "application/pdf"
                Response.TransmitFile(rutaDocumento)
                Response.Flush()
                Exit Sub
            End If

            Dim ruta As String = String.Empty
            Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
            If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                ruta = rutaAlmacenaArchivo.ConfigKeyValue
            Else
                Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
            End If

            If Not Directory.Exists(ruta) Then
                Directory.CreateDirectory(ruta)
            End If

            Integer.TryParse(Request.Params("id"), idDocumento)
            If Request.QueryString("flag") IsNot Nothing Then
                flag = Request.QueryString("flag")
            End If
            If idDocumento > 0 And flag = 0 Then
                Dim objDocumento As New DocumentoServicioMensajeria
                With objDocumento
                    Dim dr() As DataRow
                    If Session("objDatosDocu") IsNot Nothing AndAlso CType(Session("objDatosDocu"), DataTable).Rows.Count > 0 Then
                        dr = CType(Session("objDatosDocu"), DataTable).Select("idDocumento = " & idDocumento)
                    ElseIf Session("objDatosConsulta") IsNot Nothing AndAlso CType(Session("objDatosConsulta"), DataTable).Rows.Count > 0 Then
                        dr = CType(Session("objDatosConsulta"), DataTable).Select("idDocumento = " & idDocumento)
                    End If

                    If dr.Length > 0 Then
                        _strArchivo = Nothing

                        If Not Directory.Exists(ruta & dr(0).Item("RutaAlmacenamiento")) Then
                            Directory.CreateDirectory(ruta & dr(0).Item("RutaAlmacenamiento"))
                        End If
                        If Not File.Exists(ruta & dr(0).Item("RutaAlmacenamiento") & "\" & dr(0).Item("nombreArchivo")) Then
                            Dim rutaGuardar As String = ruta & dr(0).Item("RutaAlmacenamiento") & "\" & dr(0).Item("nombreArchivo")
                            Dim fs As FileStream = New FileStream(rutaGuardar, FileMode.CreateNew)
                            fs.Write(dr(0).Item("Archivo1"), 0, dr(0).Item("Archivo1").Length)
                            fs.Flush()
                            fs.Close()
                        End If
                        rutaDocumento = ruta & dr(0).Item("RutaAlmacenamiento") & "\" & dr(0).Item("nombreArchivo")
                        Response.AddHeader("Content-Disposition", "attachment; filename=" & dr(0).Item("NombreArchivo").Replace(" ", "_") & "")
                        Response.ContentType = dr(0).Item("TipoContenido")
                        Response.TransmitFile(rutaDocumento)
                        Response.Flush()


                    Else
                        miEncabezado.showError("No existe el archivo para visualizar")
                    End If
                End With
            ElseIf idDocumento > 0 And flag <> 0 Then
                Dim objDocumento As New DocumentoTemporalServicioMensajeria(idRegistro:=idDocumento)
                With objDocumento
                    rutaDocumento = ruta & .RutaAlmacenamiento & "\" & .IdentificadorUnico.ToString()

                    Response.AddHeader("Content-Disposition", "attachment; filename=" & .NombreArchivo.Replace(" ", "_") & "")
                    Response.ContentType = .TipoContenido
                    Response.TransmitFile(rutaDocumento)
                    Response.End()
                End With
            Else
                miEncabezado.showWarning("No se logro obtener el identificador del documento, por favor regrese a la página anterior.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar la página: " & ex.Message)
        End Try
    End Sub

#End Region

End Class