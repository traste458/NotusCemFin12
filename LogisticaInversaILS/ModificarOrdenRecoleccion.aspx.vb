Imports ILSBusinessLayer.LogisticaInversa
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports System.IO
Partial Public Class ModificarOrdenRecoleccion
    Inherits System.Web.UI.Page
    Private ReadOnly Property idUsuario() As Integer
        Get
            If Session("usxp001") Is Nothing Then Session("usxp001") = 1
            Return Session("usxp001")
        End Get

    End Property

    Private ReadOnly Property ContieneReferencias() As Boolean
        Get
            Dim dt As DataTable = Session("dtReferencias")
            If dt Is Nothing Then
                Return False
            Else
                dt.DefaultView.RowStateFilter = DataViewRowState.CurrentRows
                If dt.DefaultView.Count = 0 Then
                    Return False
                Else
                    Return True
                End If
            End If
        End Get
    End Property

    Private ReadOnly Property contieneAccesorios() As Boolean
        Get
            Dim dt As DataTable = Session("dtAccesorios")
            If dt Is Nothing Then
                Return False
            Else
                dt.DefaultView.RowStateFilter = DataViewRowState.CurrentRows
                If dt.DefaultView.Count = 0 Then
                    Return False
                Else
                    Return True
                End If
            End If
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        Seguridad.verificarSession(Me)
        gvErrores.DataBind()
        If Not IsPostBack Then
            Session("usxp001") = 1
            EncabezadoPagina1.setTitle("Modificación de Órdenes de Recolección")
            EncabezadoPagina1.showReturnLink("BusquedaOrdenesRecoleccion.aspx")
            CargarListadoOrigen()
            CargarListadoDestino()
            Dim regEx As String = MetodosComunes.seleccionarConfigValue("REGEX_LONGITUD_SERIALES")
            RegularExpressionValidatorSerial.ValidationExpression = regEx
            If Request.QueryString("idOrden") IsNot Nothing Then
                CargaInicial(Request.QueryString("idOrden"))
            Else
                EncabezadoPagina1.showError("No se han podido cargar los datos de la órden")
            End If
        End If
    End Sub

    Private Sub CargaInicial(ByVal idOrden As Integer)
        gvMateriales.DataBind()
        Dim dt As DataTable = Ciudad.ObtenerCiudadesPorPais()
        Dim filtroTransportadoras As Estructuras.FiltroTransportadora

        filtroTransportadoras.Activo = Enumerados.EstadoBinario.Activo
        filtroTransportadoras.AplicaLogisticaInversa = 1

        dt = ILSBusinessLayer.Transportadora.ListadoTransportadoras(filtroTransportadoras)
        MetodosComunes.CargarDropDown(dt, CType(ddlTransportadora, ListControl))
        dt = ILSBusinessLayer.Productos.Producto.ObtenerListado()
        MetodosComunes.CargarDropDown(dt, CType(ddlProductos, ListControl))
        Me.ObtenerMateriales(0)
        pnlSeriales.Visible = False
        Session("OrdenRecoleccion") = Nothing
        Session("dtReferencias") = Nothing
        Session("dtAccesorios") = Nothing
        Session("dtSeriales") = Nothing
        Dim objCiu As Ciudad
        Try
            Dim orden As New OrdenRecoleccion(idOrden)
            With orden
                objCiu = New Ciudad(.Origen.IdCiudad)
                ddlOrigen.Items.Add(New ListItem(.Origen.Centro & " - " & .Origen.Almacen & " - " & .Origen.CodigoCliente & " - " & .Origen.Nombre & " - " & .Origen.Direccion & " - " & objCiu.Nombre, .IdOrigen))
                objCiu = New Ciudad(.Destino.IdCiudad)
                ddlDestino.Items.Add(New ListItem(.Destino.Centro & " - " & .Destino.Almacen & " - " & .Destino.CodigoCliente & " - " & .Destino.Nombre & " - " & .Destino.Direccion & " - " & objCiu.Nombre, .IdDestino))
                ddlOrigen.SelectedValue = .IdOrigen
                ddlDestino.SelectedValue = .IdDestino
                hfIdOrigen.Value = .IdOrigen
                hfIdDestino.Value = .IdDestino
                lblIdOrden.Text = .IdOrden
                ddlTransportadora.SelectedValue = .IdTransportadora
                txtGuia.Text = .Guia
                txtOrdenServicio.Text = .OrdenServicio
                txtValorDeclarado.Text = .ValorDeclarado.ToString()
                .Referencias.Seriales.CargarListaSeriales(.IdOrden)
                .Referencias.CargarListaReferencias(.IdOrden)
                .Accesorios.CargarListaAccesorios(.IdOrden)
                Me.CargarGridAccesorios(.Accesorios.ListaAccesorios)
                Me.CargarGridMateriales(.Referencias.ListaReferencias)
                Session("OrdenRecoleccion") = orden
                Session("dtReferencias") = .Referencias.ListaReferencias
                Session("dtAccesorios") = .Accesorios.ListaAccesorios
                Session("dtSeriales") = .Referencias.Seriales.ListaSeriales
            End With
        Catch ex As Exception
            EncabezadoPagina1.showError("Error al tratar de obtener los datos de la´orden de recolección")
        End Try

    End Sub

#Region "MANEJO DE DESTINOS"

    Private Sub cpFiltro_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroOrigen.Execute, cpFiltroDestino.Execute
        Dim filtroRapido As String = ""
        Select Case e.Parameter
            Case "filtrarOrigen"
                filtroRapido = txtFiltroOrigen.Text
                If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
                CargarListadoOrigen(filtroRapido)
            Case "filtrarDestino"
                filtroRapido = txtFiltroDestino.Text
                If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
                CargarListadoDestino(filtroRapido)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub CargarListadoDeDestinatarios(ByVal filtroRapido As String, ByVal ddl As DropDownList, ByVal opcionInicial As String)
        Try
            With ddl
                If filtroRapido.Trim.Length > 0 Then
                    Dim dtOrigen As DataTable = ObtenerListaDestinatario(filtroRapido)
                    If dtOrigen IsNot Nothing Then
                        .DataSource = dtOrigen
                        .DataTextField = "nombreCompuesto"
                        .DataValueField = "idCliente"
                        .DataBind()
                    End If
                Else
                    If .Items.Count > 0 Then .Items.Clear()
                End If
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem(opcionInicial, "0"))
            End With
        Catch ex As Exception
            EncabezadoPagina1.showError("Error al tratar de cargar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoOrigen(Optional ByVal filtro As String = "")
        CargarListadoDeDestinatarios(filtro, ddlOrigen, "Escoja un Origen")
    End Sub

    Private Sub CargarListadoDestino(Optional ByVal filtro As String = "")
        CargarListadoDeDestinatarios(filtro, ddlDestino, "Escoja un Destino")
    End Sub

    Private Function ObtenerListaDestinatario(ByVal filtroRapido As String) As DataTable
        Dim dt As DataTable
        Dim filtro As New Cliente.FiltroCliente
        filtro.filtroRapido = filtroRapido
        dt = Cliente.Consultar(filtro)
        If dt IsNot Nothing Then
            Dim dcAux As New DataColumn("nombreCompuesto")
            dcAux.Expression = "ISNULL(centro+'-'+almacen,ISNULL(idcliente2,''))+' - '+cliente+' '+direccion+' '+ ciudad"
            dt.Columns.Add(dcAux)
        End If
        Return dt
    End Function

#End Region

#Region "MANEJO DE REFERENCIAS"

    Protected Sub ddlProductos_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlProductos.SelectedIndexChanged
        Me.ObtenerMateriales(ddlProductos.SelectedValue)
    End Sub

    Protected Sub ddlMaterial_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlMaterial.SelectedIndexChanged
        If ddlMaterial.SelectedIndex > 0 Then
            Dim objSub As New ILSBusinessLayer.Productos.Subproducto(ddlMaterial.SelectedValue)
            ddlProductos.SelectedValue = objSub.IdProducto
        End If
    End Sub

    Protected Sub lnkAgregarReferencia_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkAgregarReferencia.Click
        Dim dtReferencias As DataTable
        If Session("dtReferencias") Is Nothing Then
            dtReferencias = OrdenRecoleccionDetalle.ObtenerEstructuraDeDatos
            Session("dtReferencias") = dtReferencias
        Else
            dtReferencias = Session("dtReferencias")
        End If
        Me.AgregarReferencia(dtReferencias)
        Me.LimpiarAgregarReferencias()
    End Sub

    Private Sub gvMateriales_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvMateriales.RowCommand
        Select Case e.CommandName
            Case "Eliminar"
                Me.EliminarMaterial(e.CommandArgument)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvMateriales_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles gvMateriales.SelectedIndexChanging
        gvMateriales.SelectedIndex = e.NewSelectedIndex
        If Session("dtSeriales") IsNot Nothing Then
            Dim dtSeriales As DataTable = Session("dtSeriales")
            dtSeriales.DefaultView.RowFilter = "material='" & gvMateriales.SelectedValue.ToString() & "' "
            Session("dtSeriales") = dtSeriales
            CargarGridSeriales(dtSeriales)
            lblSerialesLeidos.Text = dtSeriales.DefaultView.Count
        End If
        pnlSeriales.Visible = True
        pnlLectura.Visible = True
    End Sub

#Region "Metodos Referencias"

    Private Sub AgregarReferencia(ByVal dtReferencias As DataTable, Optional ByVal detalle As OrdenRecoleccionDetalle = Nothing)
        Dim ref As DataRow() = dtReferencias.Select("material='" & ddlMaterial.SelectedValue & "' ")
        Dim dr As DataRow = dtReferencias.NewRow()
        If ref.Length = 0 Then
            If detalle Is Nothing Then
                dr("material") = ddlMaterial.SelectedValue
                dr("idProducto") = ddlProductos.SelectedValue
                dr("cantidad") = txtCantidad.Text
                dr("referencia") = ddlMaterial.SelectedItem.Text
                dtReferencias.Rows.Add(dr)
                Me.CargarGridMateriales(dtReferencias)
            Else
                Dim material As New ILSBusinessLayer.Productos.Subproducto(detalle.Material)
                dr("material") = detalle.Material
                dr("idProducto") = material.IdProducto
                dr("cantidad") = detalle.Cantidad
                dr("referencia") = material.Subproducto
                dtReferencias.Rows.Add(dr)
            End If
        Else
            EncabezadoPagina1.showWarning("La referencia ya se encuentra agregada en esta recolección")
        End If

    End Sub

    Private Sub ObtenerMateriales(ByVal idProducto As Integer)
        Dim dtSubproductos As DataTable
        If idProducto = 0 Then
            dtSubproductos = ILSBusinessLayer.Productos.Subproducto.ObtenerListado()
        Else
            Dim filtro As New ILSBusinessLayer.Estructuras.FiltroSubproducto
            filtro.IdProducto = idProducto
            dtSubproductos = ILSBusinessLayer.Productos.Subproducto.ObtenerListado(filtro)
        End If

        Dim columna As New DataColumn("referencia", GetType(String), "material+'-'+subproducto")
        dtSubproductos.Columns.Add(columna)
        MetodosComunes.CargarDropDown(dtSubproductos, CType(ddlMaterial, ListControl))
        Session("auxDtSubproducto") = dtSubproductos
        Me.BindDdlMaterial(ddlMaterial, dtSubproductos)
    End Sub

    Protected Sub FiltrarMaterial(ByVal sender As Object, ByVal e As EventArgs) Handles txtFiltroMaterial.TextChanged
        Dim txtObjFiltro As TextBox = CType(sender, TextBox)
        Dim dtMateriales As DataTable
        If Session("auxDtSubproducto") IsNot Nothing Then
            dtMateriales = HttpContext.Current.Session("auxDtSubproducto")
            If txtObjFiltro.Text.Length > 3 Then
                Dim filtro As String = "  referencia like '%" + txtObjFiltro.Text + "%'  "
                dtMateriales.DefaultView.RowFilter = filtro
            Else
                dtMateriales.DefaultView.RowFilter = ""
            End If
            Me.BindDdlMaterial(ddlMaterial, dtMateriales)
        End If
    End Sub

    Private Sub BindDdlMaterial(ByVal ddl As DropDownList, ByVal dt As DataTable)
        With ddl
            .DataSource = dt
            .DataValueField = "material"
            .DataTextField = "referencia"
            .DataBind()
            .Items.Insert(0, New ListItem("Seleccione...", "0"))
        End With

    End Sub

    Private Sub LimpiarAgregarReferencias()
        ddlProductos.ClearSelection()
        ddlMaterial.ClearSelection()
        txtCantidad.Text = ""
        pnlSeriales.Visible = False
        gvMateriales.SelectedIndex = -1
        txtFiltroMaterial.Text = ""
    End Sub

    Private Sub EliminarMaterial(ByVal material As String)
        Dim dtReferencias As DataTable = Session("dtReferencias")
        Dim filas As DataRow() = dtReferencias.Select("material='" & material & "' ")
        If filas IsNot Nothing Then
            filas(0).Delete()
            Me.CargarGridMateriales(dtReferencias)
            Dim dtSeriales As DataTable = Session("dtSeriales")
            Dim rowSeriales As DataRow() = dtSeriales.Select("material='" & material & "' ")
            For Each fila As DataRow In rowSeriales
                fila.Delete()
            Next
            Me.CargarGridMateriales(dtReferencias)
            pnlSeriales.Visible = False
            gvMateriales.SelectedIndex = -1
        End If
    End Sub

    Private Sub CargarGridMateriales(ByVal dtReferencias As DataTable)
        gvMateriales.DataSource = dtReferencias
        gvMateriales.DataBind()
        UpdatePanelMateriales.Update()
    End Sub

    Private Sub ActualizarCantidadReferencia()
        Dim dtReferencias As DataTable = Session("dtReferencias")
        Dim dtSeriales As DataTable = Session("dtSeriales")
        dtSeriales.DefaultView.RowFilter = "material='" & gvMateriales.SelectedValue.ToString & "' "
        Dim fila As DataRow = dtReferencias.Select("material='" & gvMateriales.SelectedValue.ToString() & "' ")(0)
        fila("cantidad") = dtSeriales.DefaultView.Count
        Session("dtReferencias") = dtReferencias
        Me.CargarGridMateriales(dtReferencias)

    End Sub

#End Region
#End Region

#Region "MANEJO DE SERIALES"

    Protected Sub lnkAgregarSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkAgregarSerial.Click
        Dim dtSeriales As DataTable
        If Session("dtSeriales") Is Nothing Then
            dtSeriales = OrdenRecoleccionSerial.ObtenerEstructuraDeDatos
            dtSeriales.Columns.Add(New DataColumn("material", GetType(String)))
            Session("dtSeriales") = dtSeriales
        Else
            dtSeriales = Session("dtSeriales")
        End If
        Me.AgregarSeriales(dtSeriales)
        lblSerialesLeidos.Text = dtSeriales.DefaultView.Count
        Me.LimpiarAgregarSeriales()
    End Sub

    Private Sub gvSeriales_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSeriales.RowCommand
        Select Case e.CommandName
            Case "Eliminar"
                Me.EliminarSerial(e.CommandArgument)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Protected Sub lnkVerTodos_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkVerTodos.Click
        If Session("dtSeriales") IsNot Nothing Then
            Dim dtSeriales As DataTable = Session("dtSeriales")
            If lnkVerTodos.CommandName = "ver" Then
                dtSeriales.DefaultView.RowFilter = ""
                Me.CargarGridSeriales(dtSeriales)
                pnlSeriales.Visible = True
                pnlLectura.Visible = False
                gvSeriales.Columns(gvSeriales.Columns.Count - 1).Visible = False
                lnkVerTodos.CommandName = "ocultar"
                lnkVerTodos.Text = "<img src='../images/arrow_up2.gif' border='0' alt='Ocultar Seriales'>&nbsp;Ocultar Seriales"
            Else
                pnlSeriales.Visible = False
                lnkVerTodos.CommandName = "ver"
                lnkVerTodos.Text = "<img src='../images/arrow_down2.gif' border='0' alt='Ver todos los Seriales'>&nbsp;Ver todos los Seriales"
            End If
        End If


    End Sub

#Region "Metodos seriales"
    Private Sub LimpiarAgregarSeriales()
        txtSerial.Text = ""
        chbxCajaAbierta.Checked = False
    End Sub

    Private Sub AgregarSeriales(ByVal dtSeriales As DataTable)
        Dim dr As DataRow = dtSeriales.NewRow()
        If dtSeriales.Select("serial='" & txtSerial.Text & "' ").Length = 0 Then
            dr("Serial") = txtSerial.Text
            dr("CajaVacia") = chbxCajaAbierta.Checked
            dr("material") = CType(gvMateriales.Rows(gvMateriales.SelectedIndex).Cells(0).Controls(0), LinkButton).Text
            dtSeriales.Rows.Add(dr)
            Me.CargarGridSeriales(dtSeriales)
            ActualizarCantidadReferencia()
        Else
            EncabezadoPagina1.showWarning("El serial " & txtSerial.Text & " ya se encuentra leido en esta recolección")
        End If
    End Sub

    Private Sub CargarGridSeriales(ByVal dtSeriales As DataTable)
        gvSeriales.DataSource = dtSeriales
        gvSeriales.DataBind()
        gvSeriales.Columns(gvSeriales.Columns.Count - 1).Visible = True
    End Sub

    Private Sub EliminarSerial(ByVal serial As String)
        Dim dtSeriales As DataTable = Session("dtSeriales")
        Dim filas As DataRow() = dtSeriales.Select("serial='" & serial & "' ")
        If filas IsNot Nothing Then
            filas(0).Delete()
            Session("dtSeriales") = dtSeriales
            Me.CargarGridSeriales(dtSeriales)
            ActualizarCantidadReferencia()
        End If
    End Sub

#End Region
#End Region

#Region "MANEJO DE ACCESORIOS"

    Protected Sub lnkAgregarAccesorio_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkAgregarAccesorio.Click
        Dim dtAccesorios As DataTable
        If Session("dtAccesorios") Is Nothing Then
            dtAccesorios = OrdenRecoleccionAccesorio.ObtenerEstructuraDeDatos
            dtAccesorios.Columns("idAccesorio").AutoIncrement = True
            dtAccesorios.Columns("idAccesorio").AutoIncrementSeed = 1
            dtAccesorios.Columns("idAccesorio").AutoIncrementStep = 1
            Session("dtAccesorios") = dtAccesorios
        Else
            dtAccesorios = Session("dtAccesorios")
        End If
        Me.AgregarAccesorio(dtAccesorios)
        txtCantidadAccesorio.Text = ""
        txtAccesorio.Text = ""
    End Sub

    Private Sub AgregarAccesorio(ByVal dtAccesorios As DataTable)
        Dim dr As DataRow = dtAccesorios.NewRow()
        dr("articulo") = txtAccesorio.Text
        dr("cantidadPedida") = txtCantidadAccesorio.Text
        dtAccesorios.Rows.Add(dr)
        Me.CargarGridAccesorios(dtAccesorios)
    End Sub

    Private Sub EliminarAccesorio(ByVal idAccesorio As Integer)
        Dim dtAccesorios As DataTable = Session("dtAccesorios")
        Dim filas As DataRow() = dtAccesorios.Select("IdAccesorio=" & idAccesorio.ToString())
        If filas IsNot Nothing Then
            filas(0).Delete()
            Me.CargarGridAccesorios(dtAccesorios)
        End If
    End Sub

    Private Sub CargarGridAccesorios(ByVal dtAccesorios As DataTable)
        gvAccesorios.DataSource = dtAccesorios
        gvAccesorios.DataBind()
    End Sub

    Private Sub gvAccesorios_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvAccesorios.RowCommand
        Select Case e.CommandName
            Case "Eliminar"
                Me.EliminarAccesorio(e.CommandArgument)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub
#End Region

#Region "Carga de datos por archivo plano"
    Private Sub lnkCargarSeriales_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkCargarSeriales.Click
        If FileUploadSeriales.PostedFile.FileName <> "" Then
            Dim TargetPath = Server.MapPath("../archivos_planos/") & Session("usxp001").ToString() & FileUploadSeriales.FileName
            FileUploadSeriales.PostedFile.SaveAs(TargetPath)
            CargarSeriales(TargetPath)
        End If
    End Sub

    Public Sub CargarSeriales(ByVal ruta As String)
        Dim strLine As String
        Dim arrSerial As ArrayList
        Dim dtSeriales As DataTable
        Dim dtReferencias As DataTable
        Dim fila As DataRow
        Dim lector As New StreamReader(ruta)

        Try
            dtSeriales = CType(Session("dtSeriales"), DataTable)
            If Not dtSeriales.Columns.Contains("lineaArchivo") Then dtSeriales.Columns.Add(New DataColumn("lineaArchivo", GetType(Integer)))
            If Not dtSeriales.Columns.Contains("idUsuario") Then dtSeriales.Columns.Add(New DataColumn("idUsuario", GetType(Integer)))
            dtReferencias = CType(Session("dtReferencias"), DataTable)

            'carga los seriales del archivo plano a un dadatable
            strLine = lector.ReadLine
            Dim lineaArchivo As Integer
            Dim dtErrores As New DataTable
            dtErrores.Columns.Add(New DataColumn("lineaArchivo"))
            dtErrores.Columns.Add(New DataColumn("mensajeError"))
            dtErrores.Columns.Add(New DataColumn("serial"))
            Do While Not strLine Is Nothing
                lineaArchivo += 1
                arrSerial = New ArrayList(strLine.Split(","))
                If arrSerial.Count = 3 Then
                    fila = dtSeriales.NewRow
                    If Not IsNumeric(arrSerial(0)) Then registrarErrorEnArchivo(lineaArchivo, "El Serial debe ser numérico", dtErrores)
                    If dtSeriales.Select("serial='" + arrSerial(0) + "'").Length > 0 Then
                        registrarErrorEnArchivo(lineaArchivo, "El Serial ya se encuentra cargado", dtErrores)
                    Else
                        fila("serial") = arrSerial(0)
                        fila("material") = arrSerial(1)
                        '  fila("referencia") = arrSerial(2)
                        fila("cajaVacia") = CBool(arrSerial(2))
                        fila("lineaArchivo") = lineaArchivo
                        fila("idUsuario") = Session("usxp001")
                        dtSeriales.Rows.Add(fila)
                    End If
                Else

                End If
                strLine = lector.ReadLine
            Loop
            lector.Close()
            If dtErrores.Rows.Count = 0 Then
                arrSerial = New ArrayList
                arrSerial.Add("material")
                'obtiene los materiales agregados
                Dim dtAuxRef As DataTable = MetodosComunes.getDistinctsFromDataTable(dtSeriales, arrSerial)
                Dim detalleorden As OrdenRecoleccionDetalle

                For Each auxFila As DataRow In dtAuxRef.Rows
                    Dim ref As DataRow() = dtReferencias.Select("material='" & auxFila("material") & "' ")
                    If ref.Length > 0 Then
                        ref(0)("cantidad") = dtSeriales.Select("material='" & auxFila("material") & "' ").Length
                    Else
                        fila = dtSeriales.Select("material='" & auxFila("material") & "' ")(0)
                        detalleorden = New OrdenRecoleccionDetalle
                        detalleorden.Material = fila("material")
                        '  detalleorden.Referencia = fila("referencia")
                        detalleorden.Cantidad = dtSeriales.Select("material='" & auxFila("material") & "' ").Length
                        'agrega los materiales encontrados
                        Me.AgregarReferencia(dtReferencias, detalleorden)
                    End If
                Next

                Session("dtSeriales") = dtSeriales
                Session("dtReferencias") = dtReferencias
                Dim ordSerial As New OrdenRecoleccionSerial()
                ordSerial.ListaSeriales = dtSeriales
                Dim flagCorrectos As Boolean = ordSerial.ValidarSerialesRecoleccion(idUsuario, lblIdOrden.Text)
                If flagCorrectos Then
                    Me.CargarGridMateriales(dtReferencias)
                    lnkVerTodos.Visible = True
                Else
                    If dtReferencias IsNot Nothing Then dtReferencias.Rows.Clear()
                    If dtSeriales IsNot Nothing Then dtSeriales.Rows.Clear()
                    EncabezadoPagina1.showWarning("Los registros en el archivo no cumplen con algunas validaciónes")
                    cargarGridErrores(ordSerial.ErroresValidacion)
                End If
            Else
                EncabezadoPagina1.showWarning("El archivo no tiene el formato de columnas esperado")
                cargarGridErrores(dtErrores)
            End If
        Catch ex As Exception
            If dtReferencias IsNot Nothing Then dtReferencias.Rows.Clear()
            If dtSeriales IsNot Nothing Then dtSeriales.Rows.Clear()
            EncabezadoPagina1.showError("Error al cargar archivo: " & ex.Message)
        Finally
            lector.Dispose()
        End Try
    End Sub

    Private Sub registrarErrorEnArchivo(ByVal lineaArchivo As Integer, ByVal mensajeError As String, ByVal dtErrores As DataTable)
        Dim dr As DataRow = dtErrores.NewRow
        dr("lineaArchivo") = lineaArchivo
        dr("mensajeError") = mensajeError
        dtErrores.Rows.Add(dr)
    End Sub

    Private Sub cargarGridErrores(ByVal dtErrores As DataTable)
        gvErrores.DataSource = dtErrores
        gvErrores.DataBind()
    End Sub
#End Region

    Private Sub lnkActualizar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkActualizar.Click
        Dim dtReferencias As DataTable = Session("dtReferencias")
        Dim dtAccesorios As DataTable = Session("dtAccesorios")
        Dim dtSeriales As DataTable = Session("dtSeriales")
        Dim orden As OrdenRecoleccion = Session("OrdenRecoleccion")
        If Me.ContieneReferencias Or Me.contieneAccesorios Then
            'datos generales de la orden
            orden.IdTransportadora = ddlTransportadora.SelectedValue
            orden.Guia = txtGuia.Text
            orden.OrdenServicio = txtOrdenServicio.Text
            orden.IdOrigen = ddlOrigen.SelectedValue
            orden.IdDestino = ddlDestino.SelectedValue
            Long.TryParse(txtValorDeclarado.Text, orden.ValorDeclarado)
            Try
              
                Dim ordSerial As New OrdenRecoleccionSerial()
                ordSerial.ListaSeriales = dtSeriales
                Dim flagCorrectos As Boolean = ordSerial.ValidarSerialesRecoleccion(idUsuario, orden.IdOrden)
                If flagCorrectos Then
                    orden.Actualizar()
                    Response.Redirect("BusquedaOrdenesRecoleccion.aspx?mod=" & orden.IdOrden.ToString(), False)
                Else
                    EncabezadoPagina1.showWarning("Los registros en el archivo no cumplen con algunas validaciónes")
                    cargarGridErrores(ordSerial.ErroresValidacion)
                End If
            Catch ex As Exception
                If ex.Message = "1" Then
                    EncabezadoPagina1.showWarning("ya existe una orden de recolección con esa orden de servicio")
                    cargarGridErrores(orden.Referencias.Seriales.ErroresValidacion)
                Else
                    EncabezadoPagina1.showError("Error al tratar de registrar la orden")
                End If
            End Try
        Else
            EncabezadoPagina1.showWarning("La recolección  debe tener al menos referencias o accesorios")
        End If
    End Sub
End Class