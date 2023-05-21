Imports System.Web
Imports System.Web.Services
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports ILSBusinessLayer.CodeBar39

Public Class Cod39Generator
    Implements System.Web.IHttpHandler

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim code As String = context.Request("code")
        If code IsNot Nothing Then
            Dim img As Image = New Code39(code.ToUpper()).Paint()
            context.Response.ContentType = "image/png"
            Dim b As Byte() = GetImageBytes(img)
            context.Response.OutputStream.Write(b, 0, b.Length)
        End If
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property

    Private Function GetImageBytes(image As Image) As Byte()
        Dim codec As ImageCodecInfo = Nothing

        For Each e As ImageCodecInfo In ImageCodecInfo.GetImageEncoders()
            If e.MimeType = "image/png" Then
                codec = e
                Exit For
            End If
        Next

        Using ep As New EncoderParameters()
            ep.Param(0) = New EncoderParameter(Encoder.Quality, 100L)

            Using ms As New MemoryStream()
                image.Save(ms, codec, ep)
                Return ms.ToArray()
            End Using
        End Using
    End Function

End Class