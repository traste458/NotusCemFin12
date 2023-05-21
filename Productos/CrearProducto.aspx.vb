Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Enumerados
Imports ILSBusinessLayer.Estructuras
Imports DevExpress.Web
Imports System.Collections.Generic
Imports System.IO

Partial Public Class CrearProducto
    Inherits System.Web.UI.Page

#Region "Constantes"

    Const MAX_TAMANIO_IMAGENES As Integer = 10485760

#End Region

#Region "Atributos"
    Private resultadoValor As Integer
    Private resultadoMensaje As String
#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        Try
            If Not Me.IsPostBack Then
                epNotificador.setTitle("Creación de Productos")
                epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarTiposDeProducto()
                CargarFabricantes()
                CargarTecnologias()
                CargarUnidadEmpaque()
                CargarListaProveedores()
                trRequiereConsecutivo.Visible = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Protected Sub ibAdicionar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdicionar.Click
        Dim drAux As DataRow
        Try
            If Session("dtProveedor") IsNot Nothing Then
                Dim dtProveedor As DataTable = CType(Session("dtProveedor"), DataTable)
                drAux = dtProveedor.Rows.Find(ddlProveedor.SelectedValue)
                If drAux IsNot Nothing Then drAux.Delete()
                Dim idProveedor As Integer = CInt(ddlProveedor.SelectedValue)
                Dim nombreProveedor As String = ddlProveedor.SelectedItem.Text
                AdicionarProveedor(idProveedor, nombreProveedor)
                CargarListaProveedores()
            Else
                Throw New Exception("Imposible recuperar el listado de proveedores desde la memoria principal.")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar adicionar proveedor al producto. " & ex.Message)
        End Try
    End Sub

    Private Sub dgProveedor_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgProveedor.ItemCommand
        If e.CommandName = "quitar" Then
            Dim idProveedor As Integer = CInt(e.CommandArgument)
            Dim drAux As DataRow
            Dim dtProveedor As DataTable = CType(Session("dtProductoProveedor"), DataTable)
            Try
                drAux = dtProveedor.Rows.Find(idProveedor)
                If drAux IsNot Nothing Then
                    dtProveedor.Rows.Remove(drAux)
                    hfNumProveedores.Value = dtProveedor.Rows.Count
                    EnlazarProveedoresRelacinados(dtProveedor)
                    ReestablecerProveedor(idProveedor)
                    CargarListaProveedores()
                End If
            Catch ex As Exception
                epNotificador.showError("Error al tratar de quitar proveedor. " & ex.Message)
            Finally
                If dtProveedor IsNot Nothing Then dtProveedor.Dispose()
            End Try
        End If
    End Sub

    Protected Sub ddlTipoProducto_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlTipoProducto.SelectedIndexChanged
        Dim idTipoProducto As Short
        Short.TryParse(ddlTipoProducto.SelectedValue, idTipoProducto)
        If idTipoProducto <> 0 Then
            Try
                Dim elTipoProducto As New TipoProducto(idTipoProducto)
                With ddlUnidadEmpaque
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(elTipoProducto.IdTipoUnidad))
                End With
                trTecnologia.Visible = elTipoProducto.AplicaTecnologia
                If trTecnologia.Visible Then ddlTecnologia.ClearSelection()
                If elTipoProducto.IdTipoProducto = Enumerados.TipoProductoMaterial.MATERIA_POP_PUBLICIDAD _
                    Or elTipoProducto.IdTipoProducto = Enumerados.TipoProductoMaterial.PAPELERIA Then
                    trRequiereConsecutivo.Visible = True
                Else
                    trRequiereConsecutivo.Visible = False
                End If
                elTipoProducto = Nothing
            Catch ex As Exception
                epNotificador.showError("Error al tratar de validar datos relacionados con el Tipo de Producto seleccionado. " & ex.Message)
            End Try
        Else
            trTecnologia.Visible = True
            ddlUnidadEmpaque.ClearSelection()
        End If
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim resultado As Short
        Dim miProducto As New Producto

        Try
            If Session("dtProductoProveedor") IsNot Nothing Then
                Dim dtProveedor As DataTable = CType(Session("dtProductoProveedor"), DataTable)
                dtProveedor.AcceptChanges()
                With miProducto
                    .Codigo = txtCodigo.Text.Trim
                    .Nombre = txtNombre.Text.Trim
                    .IdTipoProducto = CShort(ddlTipoProducto.SelectedValue)
                    .IdFabricante = CInt(ddlFabricante.SelectedValue)
                    .IdTecnologia = CInt(ddlTecnologia.SelectedValue)
                    .IdTipoUnidad = CShort(ddlUnidadEmpaque.SelectedValue)
                    If Not EsNuloOVacio(txtCodigoHomologacion.Text) Then .CodigoHomologacion = txtCodigoHomologacion.Text.Trim.ToUpper
                    Dim idProveedor As Integer
                    For Each drProveedor As DataRow In dtProveedor.Rows
                        idProveedor = CInt(drProveedor("idProveedor"))
                        .AdicionarProveedor(idProveedor)
                    Next

                    'Imagenes del producto
                    If Session("imagenesProducto") IsNot Nothing Then
                        .ListaImagenes = Session("imagenesProducto")
                    End If

                    resultado = .Registrar()
                    If resultado = 0 Then
                        If .IdTipoProducto = 1 Or .IdTipoProducto = 2 Then .NotificarCreacionDeProducto()

                        epNotificador.showSuccess("El Producto fue registrado satisfactoriamente" & IIf(Len(.Codigo) > 0, ", con el identificador " & .Codigo, ""))
                        LimpiarCampos()
                    Else
                        If resultado = 1 Then
                            epNotificador.showWarning("El Producto especificado ya existe. Por favor verifique")
                        ElseIf resultado = 3 Then
                            epNotificador.showWarning("No se puede registrar la información, porque no se han proporcionado todos los datos requeridos. Por favor verifique")
                        Else
                            epNotificador.showError("Ocurrió un error inesperado al registrar la información. Por favor intente nuevamente")
                        End If
                    End If
                End With
            Else
                epNotificador.showWarning("No se ha especificado ningún proveedor para el producto o el listado seleccionado fue borrado de memoria. Por favor verifique")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar información. " & ex.Message)
        End Try
    End Sub

    Private Sub ucImagenes_FilesUploadComplete(sender As Object, e As DevExpress.Web.FilesUploadCompleteEventArgs) Handles ucImagenes.FilesUploadComplete
        Dim imageResize As ImageResizer.ImageJob
        Try
            If ucImagenes.HasFile Then
                Dim imagenes As UploadedFile() = ucImagenes.UploadedFiles
                Dim ListaImagenes As List(Of Producto.ImagenProducto) = New List(Of Producto.ImagenProducto)
                Dim tamanioTotal As Integer = 0

                For indexImg As Integer = 0 To imagenes.Length - 1
                    Dim objImg As Producto.ImagenProducto
                    With objImg
                        Dim msImagenOrigen As New MemoryStream(imagenes(indexImg).FileBytes)
                        Dim msImagenDestino As New MemoryStream()

                        Dim settings As New ImageResizer.ResizeSettings()
                        With settings
                            .Width = 450
                            .Height = 450
                            .Mode = ImageResizer.FitMode.Max
                        End With
                        imageResize = New ImageResizer.ImageJob(msImagenOrigen, msImagenDestino, settings).Build()

                        Dim biteArray As Byte() = New Byte(msImagenDestino.Length) {}
                        msImagenDestino.Position = 0
                        msImagenDestino.Read(biteArray, 0, msImagenDestino.Length)

                        .imagen = biteArray
                        .contenType = imagenes(indexImg).ContentType
                        .nombreImagen = imagenes(indexImg).FileName
                        .tamanio = imagenes(indexImg).ContentLength
                        tamanioTotal += imagenes(indexImg).ContentLength
                    End With
                    ListaImagenes.Add(objImg)
                Next

                If tamanioTotal > MAX_TAMANIO_IMAGENES Then
                    e.ErrorText = String.Format("El tamaño total de las imagenes cargadas {0} bytes supera el máximo permitido {1} bytes", tamanioTotal, MAX_TAMANIO_IMAGENES)
                Else
                    Session("imagenesProducto") = ListaImagenes
                    e.CallbackData = String.Format("{0} imagen(es) cargadas", ucImagenes.UploadedFiles.Length)
                End If
            End If
        Catch ex As Exception
            e.ErrorText = "Se generó un error al tratar cargar los archivos: " & ex.Message
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarTiposDeProducto()
        Dim lcTipoProducto As ListControl = ddlTipoProducto
        Try
            Dim filtro As New FiltroTipoProducto
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = TipoProducto.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja un Tipo de Producto...")
            End Using
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar Tipos de Producto. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTecnologias()
        Dim lcTipoProducto As ListControl = ddlTecnologia
        Try
            Dim filtro As New FiltroTecnologia
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = Tecnologia.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja una Tecnología...")
            End Using
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar Fabricantes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarFabricantes()
        Dim lcTipoProducto As ListControl = ddlFabricante
        Try
            Dim filtro As New FiltroFabricante
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = Fabricante.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja un Fabricante...")
            End Using
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar Fabricantes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarUnidadEmpaque()
        Dim lcTipoProducto As ListControl = ddlUnidadEmpaque
        Try
            Dim filtro As New FiltroUnidadEmpaque
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = UnidadEmpaque.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja una Unidad de Empaque...")
            End Using
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar Unidad de Empaque. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListaProveedores()
        Dim dtDatos As DataTable
        Dim lcTipoProducto As ListControl = ddlProveedor
        Try
            If Session("dtProveedor") Is Nothing Then
                Dim filtro As New FiltroGeneral
                filtro.Activo = EstadoBinario.Activo
                dtDatos = Proveedor.ObtenerListado(filtro)
                Dim pkColumn(0) As DataColumn
                pkColumn(0) = dtDatos.Columns("idProveedor")
                dtDatos.PrimaryKey = pkColumn
                Session("dtProveedor") = dtDatos
            Else
                dtDatos = CType(Session("dtProveedor"), DataTable)
            End If
            MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja un Proveedor...")
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar Proveedores. " & ex.Message)
            If dtDatos IsNot Nothing Then dtDatos.Dispose()
        End Try
    End Sub

    Private Sub AdicionarProveedor(ByVal idProveedor As Integer, ByVal nombre As String)
        Dim dtProveedor As DataTable
        If Session("dtProductoProveedor") Is Nothing Then
            dtProveedor = New DataTable
            Dim pkColumn(0) As DataColumn
            With dtProveedor.Columns
                .Add("idProveedor", GetType(Integer))
                .Add("nombre", GetType(String))
                pkColumn(0) = .Item("idProveedor")
            End With
            dtProveedor.PrimaryKey = pkColumn
        Else
            dtProveedor = CType(Session("dtProductoProveedor"), DataTable)
        End If
        Dim drAux As DataRow = dtProveedor.NewRow
        drAux("idProveedor") = idProveedor
        drAux("nombre") = nombre
        dtProveedor.Rows.Add(drAux)
        EnlazarProveedoresRelacinados(dtProveedor)
        Session("dtProductoProveedor") = dtProveedor
        hfNumProveedores.Value = dtProveedor.Rows.Count.ToString
    End Sub

    Private Sub EnlazarProveedoresRelacinados(ByVal dtProveedor As DataTable)
        With dgProveedor
            If dtProveedor IsNot Nothing AndAlso dtProveedor.Rows.Count > 0 Then
                .DataSource = dtProveedor
                .Columns(0).FooterText = dtProveedor.Rows.Count.ToString & " Proveedor(es) Relacionado(s)"
            End If
            .DataBind()
        End With
        MetodosComunes.mergeFooter(dgProveedor)
    End Sub

    Private Sub ReestablecerProveedor(ByVal idProveedor As Integer)
        Dim dtAux As DataTable = CType(Session("dtProveedor"), DataTable).Clone
        For Each drAux As DataRow In CType(Session("dtProveedor"), DataTable).Rows
            If drAux.RowState = DataRowState.Deleted Then
                drAux.RejectChanges()
                If CInt(drAux("idProveedor")) = idProveedor Then
                    Exit For
                Else
                    drAux.Delete()
                End If
            End If
        Next
    End Sub

    Private Sub LimpiarCampos()
        ddlTipoProducto.ClearSelection()
        txtCodigo.Text = ""
        txtNombre.Text = ""
        ddlFabricante.ClearSelection()
        ddlTecnologia.ClearSelection()
        ddlUnidadEmpaque.ClearSelection()
        Session.Remove("dtProveedor")
        Session.Remove("dtProductoProveedor")
        Session.Remove("imagenesProducto")
        CargarListaProveedores()
        EnlazarProveedoresRelacinados(Nothing)
    End Sub

#End Region

End Class
