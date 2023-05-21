Imports System.Web
Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports System.Net
Imports iTextSharp.text.pdf

Public Class CargarArchivosServidor
    Implements System.Web.IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        If context.Request.Files.Count > 0 Then

            Dim files As HttpFileCollection = context.Request.Files
            Dim fname As String
            Dim archivoFu As HttpPostedFile = files(0)
            'Dim fs As System.IO.Stream = archivoFu.InputStream
            'Dim br As New System.IO.BinaryReader(fs)
            'Dim bytes As Byte() = br.ReadBytes(CType(fs.Length, Integer))
            'Dim base64String As String = Convert.ToBase64String(bytes, 0, bytes.Length)
            Dim resultado As ResultadoProceso
            Dim objDocumentos As New GenerarPoolServicioMensajeria
            Dim origen As String = context.Request.QueryString("origen")
            Dim nombre As String = archivoFu.FileName
            Dim obj As Comunes.ConfigValues = New Comunes.ConfigValues("RUTA_DOCUMENTOS_MESA_CONTROL")

            'comprime pdf
            'Dim pdfFile As String = "D:\1025455698.pdf"
            'Dim reader As New PdfReader(pdfFile)
            'Dim stamper As New PdfStamper(reader, New FileStream(pdfFile, FileMode.Create), PdfWriter.VERSION_1_5)
            'stamper.FormFlattening = True
            'stamper.SetFullCompression()
            'stamper.Close()


            For i As Integer = 0 To files.Count - 1
                Dim file As HttpPostedFile = files(i)

                If HttpContext.Current.Request.Browser.Browser.ToUpper() = "IE" OrElse HttpContext.Current.Request.Browser.Browser.ToUpper() = "INTERNETEXPLORER" Then
                    Dim testfiles As String() = file.FileName.Split(New Char() {"\"c})
                    fname = testfiles(testfiles.Length - 1)
                Else
                    fname = file.FileName
                End If
                'fname = Path.Combine(context.Server.MapPath("~/MensajeriaEspecializada/Archivos"), fname)
                fname = obj.ConfigKeyValue & "\" & fname.Replace(" ", String.Empty)

                file.SaveAs(fname)

                Try
                    If (origen = "RadicarDocumento") Then
                        With objDocumentos
                            .IdRadicado = context.Request.QueryString("idRadicado")
                            .NombreDocumento = file.FileName.Replace(" ", String.Empty)
                            '.ByteDocumento = "data:" & archivoFu.ContentType & ";base64," & base64String
                            .RutaDocumento = fname
                            resultado = objDocumentos.GuardarDocumentoMC()
                        End With
                    ElseIf (origen = "DestruirDocumento") Then
                        With objDocumentos
                            .IdRadicado = context.Request.QueryString("idRadicado")
                            .NombreDocumento = file.FileName.Replace(" ", String.Empty)
                            '.ByteDocumento = "data:" & archivoFu.ContentType & ";base64," & base64String
                            .RutaDocumento = fname
                            .ObservacionesDevolucionDocs = context.Request.QueryString("obsDestruccion")
                            .IdUsuarioGenerador = Integer.Parse(context.Request.QueryString("idUsuario"))

                            .ValidarPasoDestruccion = False
                            .IdEstado = Enumerados.EstadoServicio.DestruccionDocumentosMC
                            resultado = objDocumentos.GuardarDocumentoMC()
                            resultado = .PasoDestruccionDoc()
                        End With

                    End If

                    context.Response.ContentType = "text/plain"
                    context.Response.Write(resultado.Mensaje)
                Catch ex As Exception
                    context.Response.ContentType = "text/plain"
                    context.Response.Write(ex.ToString())
                End Try
            Next

        ElseIf Not String.IsNullOrEmpty(context.Request.QueryString("origen")) Then
            If context.Request.QueryString("origen") = "DescargarDocMC" Then
                Dim dtMC As New DataTable
                Dim idRadicado As Integer = context.Request.QueryString("idRadicado")
                Dim nombreDocumento As String = context.Request.QueryString("nombreDoc")
                Dim objDocumentos As New GenerarPoolServicioMensajeria

                With objDocumentos
                    .IdRadicado = idRadicado
                    .NombreDocumento = nombreDocumento
                    dtMC = objDocumentos.ConsultaDocumentosMC()
                End With
                MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, dtMC.Rows(0).Item("DMCrutaDocumento").ToString(), dtMC.Rows(0).Item("DMCnombreDocumento").ToString())
            End If
        Else
            context.Response.ContentType = "text/plain"
            context.Response.Write("Aún no ha escogido un documento|rojo")
        End If

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class