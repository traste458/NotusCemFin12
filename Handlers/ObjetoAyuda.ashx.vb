Imports System.Web
Imports System.Web.Services
Imports System.Text
Imports ILSBusinessLayer.Comunes

Public Class ObjetoAyuda1
    Implements System.Web.IHttpHandler

#Region "IHttpHandler"

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim idPerfil As Integer = CInt(context.Request("idPerfil"))
        If idPerfil > 0 Then
            Dim strObjeto As String = GenerarObjeto(idPerfil)
            With context
                .Response.ContentType = "text/plain"
                .Response.Output.Write(strObjeto)
            End With
        End If
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

#End Region

#Region "Métodos Privados"

    Private Function GenerarObjeto(ByVal idPerfil As Integer) As String
        Dim sb As New StringBuilder()
        Dim objArchivo As New ArchivoAyudaColeccion()
        With objArchivo
            .IdPerfil = idPerfil
            .CargarDatos()
        End With

        If objArchivo.Count > 0 Then
            With sb
                .AppendLine("<a href='" & HttpContext.Current.Request.ApplicationPath() & objArchivo(0).Ruta & "' title='Ayuda' target='_blank'>")
                .AppendLine(" <img alt='Ayuda' border='0' src='images/HelpPurple.png'>")
                .AppendLine("</a>")
            End With
        End If
        
        Return sb.ToString()
    End Function

#End Region

End Class