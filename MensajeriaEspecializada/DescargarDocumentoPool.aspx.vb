Imports System.Web
Imports System.Web.Services

Public Class DescargarDocumentoPool1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            MetodosComunes.setGemBoxLicense()
            CargaInicial()
        End If
    End Sub

    Private Sub CargaInicial()
        Dim rutaArchivoOrigen As String
        Dim fecha As Date = Date.Now

        rutaArchivoOrigen = Context.Request.QueryString("rutaArchivoOrigen")
        Herramientas.ForzarDescargaDeArchivo(HttpContext.Current, rutaArchivoOrigen, "FormatoSolicitudCreditoPNFIN_" + CStr(fecha) + ".pdf")

    End Sub

End Class