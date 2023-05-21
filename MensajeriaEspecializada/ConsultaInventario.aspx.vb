Imports System.Text
Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.Productos
Imports System.Collections.Generic
Imports LMDataAccessLayer
Imports ILSBusinessLayer.Comunes

Public Class ConsultaInventario1
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _validarFiltros As Boolean

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        ddlBodega.GridView.Width = ddlBodega.Width
        miEncabezado.clear()
        Try
            If Not IsPostBack Then
                With miEncabezado
                    .setTitle("Consulta de Inventario")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                MetodosComunes.setGemBoxLicense()
                Dim cv As New ConfigValues("NUMEROMAXEXPORTAR_SERIALESBODEGASATELITE")
                Session.Remove("NumeroMaximoregistros")
                If cv IsNot Nothing AndAlso cv.ConfigKeyValue IsNot Nothing AndAlso cv.ConfigKeyValue.Trim.Length > 0 Then
                    Session("NumeroMaximoregistros") = cv.ConfigKeyValue
                Else
                    Session("NumeroMaximoregistros") = 0
                End If
                CargarCiudad()
                CargarBodega()
                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()
                MostrarOcultarControlesDeDescargue()
                pnlExportar.ClientVisible = False
            End If
            If ddlBodega.IsCallback OrElse ddlBodega.GridView.IsCallback OrElse Not Me.IsPostBack Then CargarBodega()
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Protected Sub ddlCiudad_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCiudad.SelectedIndexChanged
        CargarBodega()
    End Sub

    Protected Sub cmbMaterial_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbMaterial.Callback
        CargarMaterial(String.Empty)
    End Sub

    Private Sub cpFiltroMaterial_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltroMaterial.Callback
        CargarMaterial(e.Parameter)
    End Sub

    Protected Sub btBuscar_Click(sender As Object, e As EventArgs) Handles btBuscar.Click
        Try
            Buscar()
        Catch ex As Exception
            miEncabezado.showError("Imposible obtener resultados: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDatos_PageIndexChanging(sender As Object, e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtInventario") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtInventario"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                miEncabezado.showWarning("Imposible recuperar los datos desde memoria, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDatos_Sorting(sender As Object, e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dtInventario") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtInventario"), DataTable)
                Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
                EnlazarDatos(dtDatos, expOrdenamiento)
            Else
                miEncabezado.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbExportar_Click(sender As Object, e As EventArgs) Handles lbExportar.Click
        Exportar()
    End Sub

    Protected Sub lbExportarSerializado_Click(sender As Object, e As EventArgs) Handles lbExportarSerializado.Click
        ExportarSerializado()
    End Sub

    Protected Sub btnExportador_Click(sender As Object, e As EventArgs)
        Dim nunMaxRegis As Int32 = CType(Session("NumeroMaximoregistros"), Int32)
        If Session("CantidadRegistros") IsNot Nothing AndAlso CType(Session("CantidadRegistros"), Int32) > nunMaxRegis Then
            miEncabezado.showWarning("No es posible exportar la información, supera el número de registros permitidos " & nunMaxRegis & " por favor seleccione otro filtro ")
        Else
            Dim resultado As New InfoResultado
            If Session("nombreArchivoExportar") IsNot Nothing Then
                resultado = TryCast(Session("nombreArchivoExportar"), InfoResultado)
                If resultado.Valor > 0 Then
                    Dim fullnombreArchivo As String = resultado.Mensaje
                    Dim nombreMostrar As String = System.IO.Path.GetFileName(fullnombreArchivo)
                    Response.Clear()
                    Response.ClearContent()
                    Response.AppendHeader("Content-Disposition", "attachment; filename=" & nombreMostrar)
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.WriteFile(fullnombreArchivo)
                    Response.Flush()
                    Response.End()
                    'MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, fullnombreArchivo, nombreMostrar)
                Else
                    miEncabezado.showSuccess(resultado.Mensaje)
                End If
            End If
        End If

    End Sub

    Protected Sub btQuitarFiltros_Click(sender As Object, e As EventArgs) Handles btQuitarFiltros.Click
        miEncabezado.clear()
        ddlCiudad.SelectedIndex = 0
        cmbMaterial.SelectedIndex = 0
        ddlBodega.GridView.Selection.UnselectAll()
        txtMaterial.Text = String.Empty
        cmbMaterial.SelectedIndex = 0
        CargarBodega()
        gvDatos.DataSource = Nothing
        gvDatos.DataBind()
        pnlExportar.ClientVisible = False
    End Sub

#End Region

#Region "Métodos"

    Private Sub CargarBodega()
        Dim dtBodega As New DataTable
        Try
            dtBodega = HerramientasMensajeria.ConsultarBodega(idCiudad:=CInt(ddlCiudad.Value), idUsuarioConsulta:=CInt(Session("usxp001")))
            With ddlBodega
                .DataSource = dtBodega
                .DataBind()

            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudad()
        Dim dtCiudad As New DataTable
        Dim datos As New Ciudad
        Try
            dtCiudad = HerramientasMensajeria.ObtenerCiudadesCem(ciudadesCercanas:=Enumerados.EstadoBinario.Inactivo)
            With ddlCiudad
                .DataSource = dtCiudad
                .TextField = "Ciudad"
                .ValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListEditItem("Seleccione...", Nothing))
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try
    End Sub


    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

    Private Sub MostrarOcultarControlesDeDescargue()

        Dim arrControles() As String = {"lbExportarSerializado", "lbExportar"}
        For indice As Integer = 0 To arrControles.Length - 1
            Dim ctrl As Control = Me.rpFiltro.FindControl(arrControles(indice))
            If ctrl IsNot Nothing Then
                ctrl.Visible = EsVisibleOpcionRestringida(ctrl.ID, -1)
                If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, -1)
            End If
        Next
        cusFiltro.Enabled = EsVisibleOpcionRestringida("vFiltros", -1)
        'Session("validarFiltros") = _validarFiltros
    End Sub



    Private Sub CargarMaterial(pMaterial As String)
        Try
            Dim dtMaterial As New DataTable
            dtMaterial = Subproducto.ObtenerListadoComboMaterial(pMaterial)
            With cmbMaterial
                .DataSource = dtMaterial
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListEditItem("Seleccione un Material...", "0"))
                End If

            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener los materiales " & ex.Message)
        End Try
    End Sub

    Private Sub Buscar()
        Try
            Dim listaBodegas As List(Of Object) = ddlBodega.GridView().GetSelectedFieldValues("idbodega")
            Dim objConsulta As New ConsultaInventarioSatelite()
            If ddlCiudad.Value <> "0" Then objConsulta.IdCiudad = CInt(ddlCiudad.Value)
            If listaBodegas IsNot Nothing AndAlso listaBodegas.Count > 0 Then objConsulta.ListaBodega.AddRange(listaBodegas)
            If cmbMaterial.Value IsNot Nothing Then objConsulta.Material = cmbMaterial.Value
            objConsulta.IdEstado = Enumerados.EstadoInventario.LibreUtilizacion
            objConsulta.idUsuario = CInt(Session("usxp001"))
            Dim cantidadRegistros As Int32 = 0
            Dim dtDatos As DataTable = objConsulta.GenerarDataTable(False, cantidadRegistros)
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
                If cantidadRegistros > 0 Then Session("CantidadRegistros") = cantidadRegistros
                pnlExportar.ClientVisible = True
            Else
                EnlazarDatos(dtDatos)
                pnlExportar.ClientVisible = False
                miEncabezado.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
            End If

        Catch ex As Exception
            miEncabezado.showError("Imposible obtener resultados de búsqueda: " & ex.Message)
        End Try
    End Sub
    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal expOrdenamiento As String = "")
        Try
            Dim dvDatos As DataView = dtDatos.DefaultView
            If expOrdenamiento.Trim.Length > 0 Then dvDatos.Sort = expOrdenamiento

            With gvDatos
                .DataSource = dvDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            If Not _validarFiltros Then Session("dtInventario") = dvDatos.ToTable()
            MetodosComunes.mergeGridViewFooter(gvDatos)
            If dtDatos.Rows.Count = 0 Then miEncabezado.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub
    Private Function ObtenerDireccionOrdenamiento(ByVal columna As String) As String
        Dim direccionOrdenamiento = "ASC"
        Dim expresionOrdenamiento = TryCast(ViewState("ExpresionOrdenamiento"), String)
        If expresionOrdenamiento IsNot Nothing Then
            If expresionOrdenamiento = columna Then
                Dim ultimaDirection = TryCast(ViewState("DireccionOrdenamiento"), String)
                If ultimaDirection IsNot Nothing AndAlso ultimaDirection = "ASC" Then direccionOrdenamiento = "DESC"
            End If
        End If
        ViewState("DireccionOrdenamiento") = direccionOrdenamiento
        ViewState("ExpresionOrdenamiento") = columna
        Return direccionOrdenamiento
    End Function
    Private Sub Exportar()
        Try
             If Session("dtInventario") IsNot Nothing AndAlso CType(Session("dtInventario"), DataTable).Rows.Count > 0 Then
                Dim dvDatos As DataView = CType(Session("dtInventario"), DataTable).DefaultView
                Dim dtDatos As DataTable = dvDatos.ToTable(False, "bodega", "centro", "almacen", "material", "subproducto", "cantidad", "reserva", "cantidadDisponible", "cantidadSolicitada")
                Dim arrayNombre As New ArrayList
                With arrayNombre
                    .Add("Bodega")
                    .Add("Centro")
                    .Add("Almacen")
                    .Add("Material")
                    .Add("Subproducto")
                    .Add("Cantidad En Inventario")
                    .Add("Cantidad Reservada")
                    .Add("Cantidad Disponible")
                    .Add("Cantidad Solicitada")
                End With
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, "INVENTARIO", "Inventario.xls", Server.MapPath("../archivos_planos/Inventario.xls"), arrayNombre, True)
            Else
                miEncabezado.showWarning("No se encontraron datos para exportar, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Imposible realizar la exportación: " & ex.Message)
        End Try
    End Sub
    Private Sub ExportarSerializado()
        Try
            miEncabezado.clear()
            Dim listaBodegas As List(Of Object) = ddlBodega.GridView().GetSelectedFieldValues("idbodega")
            Dim objConsulta As New ConsultaInventarioSatelite()
            If ddlCiudad.Value <> "0" Then objConsulta.IdCiudad = CInt(ddlCiudad.Value)
            If listaBodegas IsNot Nothing AndAlso listaBodegas.Count > 0 Then objConsulta.ListaBodega.AddRange(listaBodegas)
            If cmbMaterial.Value IsNot Nothing Then objConsulta.Material = cmbMaterial.Value
            objConsulta.IdEstado = Enumerados.EstadoInventario.LibreUtilizacion
            Dim nunMaxRegis As Int32 = CType(Session("NumeroMaximoregistros"), Int32)

            If Session("CantidadRegistros") IsNot Nothing AndAlso CType(Session("CantidadRegistros"), Int32) > nunMaxRegis Then
                miEncabezado.showWarning("No es posible exportar la información, supera el número de registros permitidos  " & nunMaxRegis & " por favor seleccione otro filtro ")
            Else
                objConsulta.NombreArchivo = Server.MapPath("~/archivos_planos/" & "ReporteInventarioSateliteSerializado_" & Session("usxp001") & ".xlsx")
                objConsulta.NombrePlantilla = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlanrillaInventarioSateliteSerializado.xlsx")
                Dim dvDatos As DataView = objConsulta.GenerarDataTable(True, 0).DefaultView
                Session.Remove("nombreArchivoExportar")
                Session("nombreArchivoExportar") = objConsulta.Resultado

            End If
        Catch ex As Exception
            miEncabezado.showError("Imposible realizar la exportación serializada: " & ex.Message)
        End Try
    End Sub


#End Region

End Class