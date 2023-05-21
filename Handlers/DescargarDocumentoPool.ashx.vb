Imports System.Web
Imports System.Web.Services

Public Class DescargarDocumentoPool
    Implements System.Web.IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim rutaArchivoOrigen As String
        Dim fecha As Date = Date.Now

        rutaArchivoOrigen = context.Request.QueryString("rutaArchivoOrigen")

        Herramientas.ForzarDescargaDeArchivo(HttpContext.Current, rutaArchivoOrigen, "FormatoSolicitudCreditoPNFIN_" + CStr(fecha) + ".pdf")


    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class