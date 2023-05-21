Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class VerImagenSoporteMesaControl
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim idDocumento As Integer = Request.QueryString("idDocumento")
        Session("idDocumento") = idDocumento
        If Not String.IsNullOrEmpty(idDocumento) Then

            ObtenerImagen(idDocumento)
        Else
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "alerta", "alert('No se encontro el archivo'); pcVerImagen.Hide();", True)
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('pcVerImagen.Hide();', 10);", True)

        End If
    End Sub
    Private Sub ObtenerImagen(ByVal idDocumento As Integer)
        Dim imagenMS As MemoryStream
        Dim TipoImagen As String
        Dim RutaArchivo As String
        Dim NombreArchivo As String
        Dim imagen As Byte()
        Dim rutarelativa As String = String.Empty

        Dim Variable As String = "RUTA_DOCUMENTOS_MESA_CONTROL"
        Try
            Dim obj As Comunes.ConfigValues = New Comunes.ConfigValues(Variable)
            If (obj.ConfigKeyValue Is Nothing) Then
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "alerta", "alert('No se encontro la configuracion de la ruta Por favor Contactar a IT: '" & Variable & "'); pcVerImagen.Hide();", True)
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('pcVerImagen.Hide();', 10);", True)

                Exit Sub
            End If
            Dim carater As String = obj.ConfigKeyValue.Substring(obj.ConfigKeyValue.Length - 1)
            If carater IsNot Nothing Or carater = "\" Then
                rutarelativa = obj.ConfigKeyValue
            Else
                rutarelativa = obj.ConfigKeyValue & "\"

            End If

        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "alerta", "alert('Se generó un error al tratar cargar los archivos: <br><br>'" & ex.Message & "'); pcVerImagen.Hide();", True)
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('pcVerImagen.Hide();', 10);", True)
        End Try

        Dim objDocumento As New DocumentoServicioMensajeria(idDocumento)
        With objDocumento
            RutaArchivo = rutarelativa & .RutaAlmacenamiento & .NombreArchivo

        End With


        If (File.Exists(RutaArchivo)) Then
            Dim fs As FileStream = New FileStream(RutaArchivo, FileMode.Open, FileAccess.Read)
            Dim biteArray As Byte() = New Byte(fs.Length) {}

            fs.Position = 0
            fs.Read(biteArray, 0, fs.Length)
            imagen = biteArray
            NombreArchivo = Path.GetFileName(RutaArchivo)
            'TipoImagen = "application/octet-stream"
            TipoImagen = objDocumento.TipoContenido
            If Not imagen Is Nothing Then
                imagenMS = New MemoryStream(imagen, 0, imagen.Length)
                MetodosComunes.ForzarDescargaDeArchivoStream(imagenMS, NombreArchivo, TipoImagen, True)
            Else
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "alerta", "alert('No se encontro el archivo'); pcVerImagen.Hide();", True)
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('pcVerImagen.Hide();', 10);", True)
            End If
        Else
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "alerta", "alert('No se encontro el archivo'); pcVerImagen.Hide();", True)
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('pcVerImagen.Hide();', 10);", True)
        End If
    End Sub
End Class