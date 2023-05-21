Imports ILSBusinessLayer

Partial Public Class DefinicionCreacionQueja
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim idPerfil As Integer
            Integer.TryParse(Session("usxp009").ToString(), idPerfil)
            Dim usuarioUnidad As New SAC.UsuarioPerfilUnidadNegocio(idPerfil)
            Dim unidadObj As New ModuloUnidadNegocio(4, usuarioUnidad.IdUnidadNegocio)
            Response.Redirect(unidadObj.Url)
        Catch ex As Exception
            EncabezadoPagina1.showError("Error la dirigir a la pagina de creación. " & ex.Message)
        End Try
    End Sub

End Class