Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Enumerados
Imports System.IO
Imports DevExpress.Web
Imports System.Collections.Generic

Partial Public Class BuscarActualizarProducto
    Inherits System.Web.UI.Page

#Region "Constantes"

    Const MAX_TAMANIO_IMAGENES As Integer = 10485760

#End Region

#Region "Atributos"

    Private _folderTempImage As String

#End Region

#Region "Propiedades"

    Public Property FolderTempImage As String
        Get
            If Session("_folderTempImage") IsNot Nothing Then _folderTempImage = Session("_folderTempImage")
            Return _folderTempImage
        End Get
        Set(value As String)
            _folderTempImage = value
            Session("_folderTempImage") = _folderTempImage
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        epRegisterNotifier.clear()
        epFindNotifier.clear()
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Búsqueda y/o Actualización de Productos")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            CargarListadoProducto()
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
                If trTecnologia.Visible Then
                    Dim idProducto As Integer
                    Integer.TryParse(hIdProducto.Value, idProducto)
                    Dim miProducto As New Producto(idProducto)
                    If miProducto.IdTecnologia > 0 Then
                        With ddlTecnologia
                            .SelectedIndex = .Items.IndexOf(.Items.FindByValue(miProducto.IdTecnologia))
                        End With
                    End If
                Else
                    ddlTecnologia.ClearSelection()
                End If
                elTipoProducto = Nothing
            Catch ex As Exception
                epNotificador.showError("Error al tratar de validar datos relacionados con el Tipo de Producto seleccionado. " & ex.Message)
            End Try
        Else
            trTecnologia.Visible = True
            ddlUnidadEmpaque.ClearSelection()
        End If
        mpeFormularioModificacion.Show()
    End Sub

    Private Sub gvListado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvListado.RowCommand
        Dim idProducto As Integer = CInt(e.CommandArgument)

        If e.CommandName = "actualizar" Then
            CargarTiposDeProducto(ddlTipoProducto)
            CargarFabricantes(ddlFabricante)
            CargarTecnologias(ddlTecnologia)
            CargarUnidadEmpaque(ddlUnidadEmpaque)

            Try
                Dim miProducto As New Producto(idProducto)
                With miProducto
                    txtCodigo.Text = .Codigo
                    txtNombre.Text = .Nombre
                    txthomologacion.Text = .CodigoHomologacion
                End With
                With ddlTipoProducto
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(miProducto.IdTipoProducto))
                End With
                With ddlFabricante
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(miProducto.IdFabricante))
                End With
                Dim miTipoProducto As New TipoProducto(miProducto.IdTipoProducto)
                trTecnologia.Visible = miTipoProducto.AplicaTecnologia
                If miTipoProducto.AplicaTecnologia Then
                    With ddlTecnologia
                        .SelectedIndex = .Items.IndexOf(.Items.FindByValue(miProducto.IdTecnologia))
                    End With
                End If
                If miTipoProducto.IdTipoProducto = Enumerados.TipoProductoMaterial.MATERIA_POP_PUBLICIDAD _
                    Or miTipoProducto.IdTipoProducto = Enumerados.TipoProductoMaterial.PAPELERIA Then
                    trRequiereConsecutivo.Visible = True
                Else
                    trRequiereConsecutivo.Visible = False
                End If
                With ddlUnidadEmpaque
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(miProducto.IdTipoUnidad))
                End With
                Dim idEstado As Byte = IIf(miProducto.Activo, 1, 2)
                With ddlEstado
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(idEstado))
                End With
                EnlazarProveedoresRelacinados(miProducto.InfoProveedor)
                Session("dtProductoProveedor") = miProducto.InfoProveedor.Copy
                CargarListaProveedores(ddlProveedor)
                hIdProducto.Value = idProducto.ToString
                btnRegistrar.Focus()
                mpeFormularioModificacion.Show()
            Catch ex As Exception
                epRegisterNotifier.showError("Error al tratar de cargar datos del producto. " & ex.Message)
            End Try

        ElseIf e.CommandName = "visualizar" Then
            Try
                FolderTempImage = "\POP\Archivos\" & Guid.NewGuid().ToString()
                If Not Directory.Exists(Server.MapPath("~") & FolderTempImage) Then
                    Directory.CreateDirectory(Server.MapPath("~") & FolderTempImage)
                    Directory.CreateDirectory(Server.MapPath("~") & FolderTempImage & "\Small")
                End If

                Dim miProducto As New Producto(idProducto)
                For Each imgProd As Producto.ImagenProducto In miProducto.ListaImagenes
                    Dim objImagen As New Imagen()
                    With objImagen
                        .ArregloByte_Imagen(imgProd.imagen, Server.MapPath("~") & FolderTempImage & "\" & imgProd.nombreImagen, imgProd.contenType)
                        .ArregloByte_ImagenThumbnail(imgProd.imagen, Server.MapPath("~") & FolderTempImage & "\Small\" & imgProd.nombreImagen, imgProd.contenType)
                    End With
                Next

                isImagenes.ImageSourceFolder = "~" & FolderTempImage
                mpeVisualizacionImagen.Show()
            Catch ex As Exception
                epRegisterNotifier.showError("Error al trata de visualizar imagenes: " & ex.Message)
            End Try
        End If
    End Sub

    Private Sub gvListado_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListado.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try
                Dim idTipoProduto As String = CType(e.Row.DataItem, DataRowView).Item("idTipoProducto").ToString
                Dim ibImagen As ImageButton = CType(e.Row.FindControl("ibImagen"), ImageButton)

                If idTipoProduto = Enumerados.TipoProductoMaterial.MATERIA_POP_PUBLICIDAD _
                    Or idTipoProduto = Enumerados.TipoProductoMaterial.PAPELERIA Then
                    ibImagen.Visible = True
                Else
                    ibImagen.Visible = False
                End If

            Catch ex As Exception
                epNotificador.showError("Error al tratar de enlazar datos. " & ex.Message)
            End Try
        End If
    End Sub

    Private Sub gvListado_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvListado.PageIndexChanging
        If Session("dtListaProducto") IsNot Nothing Then
            gvListado.PageIndex = e.NewPageIndex
            Dim dtDatos As DataTable = CType(Session("dtListaProducto"), DataTable)
            EnlazarListadoProducto(dtDatos)
        Else
            epNotificador.showWarning("Imposible recuperar el listado de productos desde la memoria. Por favor genere el listado nuevamente.")
        End If

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
                    CargarListaProveedores(ddlProveedor)
                End If
            Catch ex As Exception
                epRegisterNotifier.showError("Error al tratar de quitar proveedor. " & ex.Message)
            Finally
                If dtProveedor IsNot Nothing Then dtProveedor.Dispose()
            End Try
            mpeFormularioModificacion.Show()
        End If
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        LimpiarFormularioModificacion()
        mpeFormularioModificacion.Hide()
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
                CargarListaProveedores(ddlProveedor)
            Else
                Throw New Exception("Imposible recuperar el listado de proveedores desde la memoria principal.")
            End If
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar adicionar proveedor al producto. " & ex.Message)
        End Try
        mpeFormularioModificacion.Show()
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        If ddlBuscarTipoProducto.Items.Count = 0 Then CargarTiposDeProducto(ddlBuscarTipoProducto)
        If ddlBuscarFabricante.Items.Count = 0 Then CargarFabricantes(ddlBuscarFabricante)
        If ddlBuscarTecnologia.Items.Count = 0 Then CargarTecnologias(ddlBuscarTecnologia)
        'CargarUnidadEmpaque(ddlBuscarUnidadEmpaque)
        If ddlBuscarProveedor.Items.Count = 0 Then CargarListaProveedores(ddlBuscarProveedor, False)
        mpeFormularioBusqueda.Show()
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Try
            AplicarFiltros()
        Catch ex As Exception
            epNotificador.showError("Error al tratar de buscar datos. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelarBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelarBuscar.Click
        LimpiarFormularioBusqueda()
        AplicarFiltros()
        LiberarItemsBusqueda()
        mpeFormularioBusqueda.Hide()
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim miProducto As New Producto
        mpeFormularioModificacion.Show()
        Try
            If Session("dtProductoProveedor") IsNot Nothing Then
                Dim dtProveedor As DataTable = CType(Session("dtProductoProveedor"), DataTable)
                Dim idProveedor As Integer
                Dim resultado As Short
                dtProveedor.AcceptChanges()
                With miProducto
                    Integer.TryParse(hIdProducto.Value, .IdProducto)
                    .Codigo = txtCodigo.Text.Trim
                    .Nombre = txtNombre.Text.Trim
                    .CodigoHomologacion = txthomologacion.Text
                    .IdTipoProducto = CShort(ddlTipoProducto.SelectedValue)
                    .IdFabricante = CInt(ddlFabricante.SelectedValue)
                    .IdTecnologia = CInt(ddlTecnologia.SelectedValue)
                    .IdTipoUnidad = CShort(ddlUnidadEmpaque.SelectedValue)
                    .Activo = IIf(ddlEstado.SelectedValue = "1", True, False)
                    .AjustarInfoProveedor(dtProveedor)


                    'Imagenes del producto
                    If Session("imagenesProducto") IsNot Nothing Then
                       .ListaImagenes = Session("imagenesProducto")
                    End If

                    resultado = .Actualizar()
                    If resultado = 0 Then
                        epNotificador.showSuccess("El Producto fue registrado satisfactoriamente. ")
                        mpeFormularioModificacion.Hide()
                        LimpiarFormularioModificacion()
                        CargarListadoProducto()
                    Else
                        If resultado = 1 Then
                            epRegisterNotifier.showWarning("Ya existe un Producto con el nombre especificado. Por favor verifique")
                        ElseIf resultado = 3 Then
                            epRegisterNotifier.showWarning("No se puede registrar la información, porque no se han proporcionado todos los datos requeridos. Por favor verifique")
                        Else
                            epRegisterNotifier.showError("Ocurrió un error inesperado al registrar la información. Por favor intente nuevamente")
                        End If
                    End If
                End With
            Else
                epRegisterNotifier.showWarning("No se ha especificado ningún proveedor para el producto o el listado seleccionado fue borrado de memoria. Por favor verifique")
            End If
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de actualizar información. " & ex.Message)
        End Try
    End Sub

    Private Sub btnCerrarVisualizar_Click(sender As Object, e As System.EventArgs) Handles btnCerrarVisualizar.Click
        Try
            isImagenes.ImageSourceFolder = Nothing
            'Se eliminan las imagenes temporales
            If Directory.Exists(Server.MapPath("~") & FolderTempImage) Then Directory.Delete(Server.MapPath("~") & FolderTempImage, True)
            mpeVisualizacionImagen.Hide()
        Catch : End Try
    End Sub

    Private Sub ucImagenes_FilesUploadComplete(sender As Object, e As DevExpress.Web.FilesUploadCompleteEventArgs) Handles ucImagenes.FilesUploadComplete
        Try
            If ucImagenes.HasFile Then
                Dim imagenes As UploadedFile() = ucImagenes.UploadedFiles
                Dim ListaImagenes As List(Of Producto.ImagenProducto) = New List(Of Producto.ImagenProducto)
                Dim tamanioTotal As Integer = 0

                For indexImg As Integer = 0 To imagenes.Length - 1
                    Dim objImg As Producto.ImagenProducto
                    With objImg
                        .imagen = imagenes(indexImg).FileBytes
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

    Private Sub CargarTiposDeProducto(ByVal ddl As DropDownList)
        Dim lcTipoProducto As ListControl = ddl
        Try
            Dim filtro As New FiltroTipoProducto
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = TipoProducto.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja un Tipo de Producto...")
            End Using
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de cargar Tipos de Producto. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTecnologias(ByVal ddl As DropDownList)
        Dim lcTipoProducto As ListControl = ddl
        Try
            Dim filtro As New FiltroTecnologia
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = Tecnologia.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja una Tecnología...")
            End Using
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de cargar Fabricantes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarFabricantes(ByVal ddl As DropDownList)
        Dim lcTipoProducto As ListControl = ddl
        Try
            Dim filtro As New FiltroFabricante
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = Fabricante.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja un Fabricante...")
            End Using
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de cargar Fabricantes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarUnidadEmpaque(ByVal ddl As DropDownList)
        Dim lcTipoProducto As ListControl = ddl
        Try
            Dim filtro As New FiltroUnidadEmpaque
            filtro.Activo = EstadoBinario.Activo
            Using dtDatos As DataTable = UnidadEmpaque.ObtenerListado(filtro)
                MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja una Unidad de Empaque...")
            End Using
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de cargar Unidad de Empaque. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListaProveedores(ByVal ddl As DropDownList, Optional ByVal almacenarEnSesion As Boolean = True)
        Dim dtDatos As DataTable
        Dim lcTipoProducto As ListControl = ddl
        Try
            If almacenarEnSesion Then
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
                If Session("dtProductoProveedor") IsNot Nothing Then
                    Dim dtProductoProveedor As DataTable = CType(Session("dtProductoProveedor"), DataTable)
                    ExcluirProveedorAdicionado(dtProductoProveedor)
                End If
            Else
                Dim filtro As New FiltroGeneral
                filtro.Activo = EstadoBinario.Activo
                dtDatos = Proveedor.ObtenerListado(filtro)
            End If
            MetodosComunes.CargarDropDown(dtDatos, lcTipoProducto, "Escoja un Proveedor...")
        Catch ex As Exception
            epRegisterNotifier.showError("Error al tratar de cargar Proveedores. " & ex.Message)
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

    Private Sub AdicionarProveedor(ByVal dtProveedorAdicionado As DataTable)
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
        For Each drAux As DataRow In dtProveedorAdicionado.Rows
            dtProveedor.ImportRow(drAux)
        Next
        EnlazarProveedoresRelacinados(dtProveedor)
        Session("dtProductoProveedor") = dtProveedor
        hfNumProveedores.Value = dtProveedor.Rows.Count.ToString
    End Sub

    Private Sub EnlazarProveedoresRelacinados(ByVal dtProveedor As DataTable)
        With dgProveedor
            If dtProveedor IsNot Nothing AndAlso dtProveedor.Rows.Count > 0 Then
                .DataSource = dtProveedor
                .Columns(0).FooterText = dtProveedor.Rows.Count.ToString & " Proveedor(es) Relacionado(s)"
                hfNumProveedores.Value = dtProveedor.Rows.Count.ToString
            Else
                hfNumProveedores.Value = "0"
            End If
            .DataBind()
        End With
        MetodosComunes.mergeFooter(dgProveedor)
    End Sub

    Private Sub ExcluirProveedorAdicionado(ByVal dtProveedorAdicionado As DataTable)
        Dim drProveedor As DataRow
        Try
            Using dtProveedor As DataTable = CType(Session("dtProveedor"), DataTable)
                For Each drAux As DataRow In dtProveedorAdicionado.Rows
                    drProveedor = dtProveedor.Rows.Find(drAux("idProveedor"))
                    If drProveedor IsNot Nothing Then drProveedor.Delete()
                Next
            End Using
        Catch ex As Exception
            epNotificador.showError("Error al tratar de quitar proveedor. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoProducto()
        Dim filtro As New FiltroProducto
        filtro.SeparadorProveedor = "<br>"
        CargarListadoProducto(filtro)
    End Sub

    Private Sub CargarListadoProducto(ByVal filtro As FiltroProducto)
        Dim dtDatos As DataTable
        Try
            If filtro.SeparadorProveedor Is Nothing OrElse filtro.SeparadorProveedor.Trim.Length > 0 Then filtro.SeparadorProveedor = "<br>"
            dtDatos = Producto.ObtenerListado(filtro)
            Dim dcEstado As New DataColumn("descEstado")
            dcEstado.Expression = "IIF(estado=1,'ACTIVO','INACTIVO')"
            dtDatos.Columns.Add(dcEstado)
            Session("dtListaProducto") = dtDatos
            EnlazarListadoProducto(dtDatos)
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Productos. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarListadoProducto(ByVal dtDatos As DataTable)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.Sort = "nombre asc"
        With gvListado
            .DataSource = dvDatos
            If dvDatos.Count > 0 Then .Columns(0).FooterText = dvDatos.Count.ToString & " Registro(s) Encontrado(s)"
            .DataBind()
        End With
        MetodosComunes.mergeGridViewFooter(gvListado)
    End Sub

    Private Sub LimpiarFormularioModificacion()
        txtCodigo.Text = ""
        txtNombre.Text = ""
        txthomologacion.Text = ""
        ddlTipoProducto.Items.Clear()
        ddlFabricante.Items.Clear()
        ddlProveedor.Items.Clear()
        ddlTecnologia.Items.Clear()
        ddlUnidadEmpaque.Items.Clear()
        Session.Remove("dtProveedor")
        Session.Remove("dtProductoProveedor")
    End Sub

    Private Sub LimpiarFormularioBusqueda()
        txtBuscarCodigo.Text = ""
        txtBuscarNombre.Text = ""
        txthomologacion.Text = ""
        ddlBuscarTipoProducto.ClearSelection()
        ddlBuscarFabricante.ClearSelection()
        ddlBuscarTecnologia.ClearSelection()
        'ddlBuscarUnidadEmpaque.ClearSelection()
        ddlBuscarProveedor.ClearSelection()
        ddlBuscarEstado.ClearSelection()
    End Sub

    Private Sub LiberarItemsBusqueda()
        ddlBuscarTipoProducto.Items.Clear()
        ddlBuscarFabricante.Items.Clear()
        ddlBuscarTecnologia.Items.Clear()
        'ddlBuscarUnidadEmpaque.Items.Clear()
        ddlBuscarProveedor.Items.Clear()
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

    Private Sub AplicarFiltros()
        Dim filtro As New FiltroProducto
        With filtro
            If txtBuscarCodigo.Text.Trim.Length > 0 Then .Codigo = txtBuscarCodigo.Text.Trim
            If txtBuscarNombre.Text.Trim.Length > 0 Then .Nombre = txtBuscarNombre.Text.Trim
            If ddlBuscarTipoProducto.SelectedValue <> "0" Then .IdTipoProducto = CShort(ddlBuscarTipoProducto.SelectedValue)
            If ddlBuscarFabricante.SelectedValue <> "0" Then .IdFabricante = CInt(ddlBuscarFabricante.SelectedValue)
            If ddlBuscarTecnologia.SelectedValue <> "0" Then .IdTecnologia = CInt(ddlBuscarTecnologia.SelectedValue)
            If ddlBuscarProveedor.SelectedValue <> "0" Then .IdProveedor = CInt(ddlBuscarProveedor.SelectedValue)

        End With
        'If txtBuscarDescripcion.Text.Trim.Length > 0 Then filtro.Descripcion = txtBuscarDescripcion.Text
        With ddlBuscarEstado
            If .SelectedValue.Trim.Length > 0 AndAlso CInt(.SelectedValue) > -1 Then filtro.Activo = CInt(.SelectedValue)
        End With
        CargarListadoProducto(filtro)
    End Sub

#End Region

End Class