Imports ImageResizer

Public Class ConsultarImagenesDeProducto
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            EnlazarImagenes()
        Catch ex As Exception

        End Try
    End Sub

    Private Function ObtenerImagenes() As DataTable
        Dim dt As DataTable = ILSBusinessLayer.Productos.Producto.ObtenerListadoCompletoDeImagenes()
        If dt IsNot Nothing Then
            dt.Columns.Add("rutaVirtual", GetType(String))
        End If
        Dim nombreArchivo As String
        'Dim laImagen As Bitmap
        Dim rutaArchivos As String = "~/Productos/ImagenDeProducto/" '"C:\ImagenesDeProducto"
        Dim ij As ImageResizer.ImageJob

        EliminarArchivosPrevios(Server.MapPath(rutaArchivos))
        For Each dr As DataRow In dt.Rows
            nombreArchivo = System.Guid.NewGuid.ToString() & System.IO.Path.GetExtension(dr("nombreImagen"))
            Using memoria As New System.IO.MemoryStream(CType(dr("imagen"), Byte()))
                'laImagen = New Bitmap(memoria)
                'laImagen.Save(rutaArchivos & "\" & nombreArchivo)
                ij = New ImageJob(memoria, rutaArchivos & nombreArchivo, New ResizeSettings("width=350&crop=auto"))
                ij.CreateParentDirectory = True
                ij.Build()
            End Using
            dr("rutaVirtual") = rutaArchivos & nombreArchivo
            'ImageBuilder.Current.Build("~/Productos/ImagenDeProducto/" & nombreArchivo, "~/Productos/ImagenDeProducto/" & nombreArchivo, _
            '                           New ResizeSettings("width=350&height=350&crop=auto"))
        Next
        Return dt
    End Function

    Public Function ConvertirArregloDeBytesABitmap(ByVal arregloBytes() As Byte) As Bitmap
        Dim imagenRetorna As Bitmap
        Using memoria As New System.IO.MemoryStream(arregloBytes)
            imagenRetorna = New Bitmap(memoria)
        End Using
        Return imagenRetorna
    End Function

    Private Sub EliminarArchivosPrevios(ByVal rutaArchivos As String)
        Dim infoDirectorio As New System.IO.DirectoryInfo(rutaArchivos)
        For Each archivo As System.IO.FileInfo In infoDirectorio.GetFiles()
            archivo.Delete()
        Next
    End Sub

    Private Sub EnlazarImagenes()
        Dim dt As DataTable = ObtenerImagenes()
        With gvImagenes
            .DataSource = dt
            .DataBind()
        End With
    End Sub

    Private Sub gvImagenes_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvImagenes.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim fila As DataRowView = e.Row.DataItem
            Dim imagen As System.Web.UI.WebControls.Image = e.Row.FindControl("imgProducto")
            imagen.ImageUrl = fila("rutaVirtual")
            imagen.AlternateText = fila("rutaVirtual")
        End If
    End Sub
End Class