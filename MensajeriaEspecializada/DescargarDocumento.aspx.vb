Imports System.IO

Partial Public Class DescargarDocumento
    Inherits System.Web.UI.Page

#Region "Variables"

    Private Shared RutaArchivo As String '= "~\archivos_soportes_declaracion\"
    Private Shared RutaLocal As String '= HttpContext.Current.Server.MapPath(RutaArchivo)

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            MetodosComunes.setGemBoxLicense()
            CargaInicial()
        End If
    End Sub

#End Region

#Region "Metodos"

    ''' <summary>
    ''' Carga los datos del formulario
    ''' </summary>
    ''' <remarks>Envio la informacion del archivo a descargar</remarks>
    Private Sub CargaInicial()

        Dim nombreArchivo As String
        If Request.QueryString("nombreArchivo") IsNot Nothing Then
            nombreArchivo = Request.QueryString("nombreArchivo")
            RutaArchivo = Request.QueryString("rutaArchivo")
            RutaLocal = HttpContext.Current.Server.MapPath("~").TrimEnd("\") & RutaArchivo
            If Not nombreArchivo.Trim.Equals("") Then
                DescargarArchivo(nombreArchivo)
            End If
        End If
    End Sub

    ''' <summary>
    ''' Descarga de un archivo relacionado.
    ''' </summary>
    ''' <param name="archivo">Nombre del archivo a descargar</param>
    ''' <remarks></remarks>
    Private Sub DescargarArchivo(ByVal archivo As String)
        Dim ruta As String = String.Empty
        ruta = RutaLocal & archivo
        Try
            If File.Exists(ruta) Then
                MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, ruta)
            Else
                'Throw New Exception("Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente")
                lblMensaje.Text = "Imposible recuperar el archivo desde su ruta de almacenamiento" & ruta
            End If
        Catch ex As Exception
            lblMensaje.Text = "Error al tratar de exportar resultado. " & ex.Message
        End Try
    End Sub

#End Region

End Class