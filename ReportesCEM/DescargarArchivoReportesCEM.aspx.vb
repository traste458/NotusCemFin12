Public Class DescargarArchivoReportesCEM
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            MetodosComunes.setGemBoxLicense()
            CargaInicial()
        End If


    End Sub
    Private Sub CargaInicial()

        Dim nombreArchivo As String
        If Request.QueryString("nombreArchivo") IsNot Nothing Then
            nombreArchivo = Request.QueryString("nombreArchivo")
            If Not String.IsNullOrEmpty(nombreArchivo) Then
                If System.IO.File.Exists(nombreArchivo) Then
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo, True)
                Else
                    Throw New Exception("")
                    lblMensaje.Text = "Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente"
                End If
            End If


        End If
    End Sub
End Class