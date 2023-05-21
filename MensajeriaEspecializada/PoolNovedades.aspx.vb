Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text
Imports ILSBusinessLayer.Comunes
Imports System.IO

Partial Public Class PoolNovedades
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim idServicioReq As Integer
        Try
            Seguridad.verificarSession(Me)
            epNotificacion.clear()

            If Not IsPostBack Then
                With epNotificacion
                    .setTitle("Pool de Novedades")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With

                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()

                CargarBodega()
                CargarCiudad()
                CargarVIP()
                CargarUrgente()
                CargarPrioridad()
                CargarEstadoNovedad()
                CargarServicio()
            End If

            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, idServicioReq)
            If idServicioReq > 0 Then
                LimpiarFiltros()
                rblTipoBusqueda.SelectedValue = 2
                txtidServicio.Text = idServicioReq.ToString()
                BuscarServicios()
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al gtratar de cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dsNovedades") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dsNovedades"), DataSet).Tables(0)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos desde memorial, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idServicioMensajeria As String = CType(e.Row.DataItem, DataRowView).Item("idServicioMensajeria").ToString

            Dim gvDetalle As GridView = CType(e.Row.FindControl("gvDatosDetalle"), GridView)

            Dim dvDetalle As DataView = CType(Session("dsNovedades"), DataSet).Tables(1).DefaultView
            dvDetalle.RowFilter = "idServicioMensajeria = " & idServicioMensajeria

            Dim img As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgCollapse"), System.Web.UI.WebControls.Image)
            Dim pnlDetalle As Panel = CType(e.Row.FindControl("pnlDetalle"), Panel)

            img.Attributes.Add("onclick", "javascript:CollapseDetail(this,'" & pnlDetalle.ClientID & "');")

            gvDetalle.DataSource = dvDetalle.ToTable()
            gvDetalle.DataBind()
        End If
    End Sub

    Protected Sub gvDatosDetalle_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Try
            Dim idNovedad As Integer
            Integer.TryParse(e.CommandArgument.ToString, idNovedad)

            If e.CommandName = "solucionar" Then
                hfIdNovedad.Value = idNovedad
                txtObservacionSolucion.Text = ""
                txtObservacionSolucion.Enabled = True
                lbSolucionarNovedad.Enabled = True
                dlgSolucionarNovedad.Show()

            ElseIf e.CommandName = "visualizar" Then
                Dim colGestion As New GestionNovedadServicioMensajeriaColeccion(idNovedad:=idNovedad)
                Dim dtGestion As DataTable = colGestion.GenerarDataTable()

                Dim sbDescripcion As New StringBuilder()
                For Each registro As DataRow In dtGestion.Rows
                    sbDescripcion.AppendLine("- " & registro("observacion").ToString())
                Next
                txtObservacionSolucion.Text = sbDescripcion.ToString()

                txtObservacionSolucion.Enabled = False
                lbSolucionarNovedad.Enabled = False
                dlgSolucionarNovedad.Show()
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub gvDatosDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try
                Dim gvNovedades As GridView = CType(sender, GridView)
                Dim image As ImageButton = CType(e.Row.FindControl("imgSolucionar"), ImageButton)
                Dim idNovedad As Integer = gvNovedades.DataKeys(e.Row.DataItemIndex).Value
                Dim drNovedades() As DataRow = CType(gvNovedades.DataSource, DataTable).Select("idNovedad = " & idNovedad.ToString())

                If CInt(drNovedades(0).Item("idEstado")) = Enumerados.EstadoNovedadMensajeria.Solucionada Then
                    image.ImageUrl = "../images/view.png"
                    image.CommandName = "visualizar"
                    image.ToolTip = "Visualizar"
                End If
            Catch : End Try
        End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        BuscarServicios()
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dsNovedades") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dsNovedades"), DataSet).Tables(0)
                Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
                EnlazarDatos(dtDatos, expOrdenamiento)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub lbSolucionarNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbSolucionarNovedad.Click
        RegistrarSolucion()
    End Sub

    Private Sub lbExportar_Click(sender As Object, e As System.EventArgs) Handles lbExportar.Click
        If Session("dsNovedades") IsNot Nothing Then
            ExportarNovedades()
        End If
    End Sub

#End Region

#Region "Procedimientos"

    Private Sub CargarBodega()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarBodega(idUsuarioConsulta:=CInt(Session("usxp001")))
            With ddlBodega
                .DataSource = dtEstado
                .DataTextField = "bodega"
                .DataValueField = "idbodega"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Bodega...", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudad()
        Dim dtCiudad As New DataTable
        Dim datos As New Ciudad
        Dim idCiudad As Integer

        Try
            If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007"), idCiudad)

            dtCiudad = HerramientasMensajeria.ObtenerCiudadesCem()
            With ddlCiudad
                .DataSource = dtCiudad
                .DataTextField = "Ciudad"
                .DataValueField = "idCiudad"
                .DataBind()

                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Ciudad...", "0"))
                End If
                .SelectedValue = idCiudad
                .Enabled = False
            End With

            Dim arrControles() As String = {"ddlCiudad"}
            For indice As Integer = 0 To arrControles.Length - 1
                Dim ctrl As Control = Me.FindControl(arrControles(indice))
                If ctrl IsNot Nothing Then
                    CType(ctrl, DropDownList).Enabled = EsVisibleOpcionRestringida(ctrl.ID, idCiudad)
                End If
            Next

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarVIP()
        Try
            With ddlVIP
                .Items.Insert(0, New ListItem("Seleccione...", "0"))
                .Items.Insert(1, New ListItem("Si", "1"))
                .Items.Insert(2, New ListItem("No", "2"))
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de VIP. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarUrgente()
        Try
            With ddlUrgente
                .Items.Insert(0, New ListItem("Seleccione...", "0"))
                .Items.Insert(1, New ListItem("Si", "1"))
                .Items.Insert(2, New ListItem("No", "2"))
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Urgentes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarPrioridad()
        Try
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaPrioridad(), ddlPrioridad)
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Prioridades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarEstadoNovedad()
        Try
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultarEstado(Enumerados.Entidad.NovedadMensajeria), ddlEstadoNovedad)
            ddlEstadoNovedad.SelectedIndex = 1
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Estados de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarServicio()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultaTipoServicio(idUsuarioConsulta:=CInt(Session("usxp001")))
            With ddlTipoServicio
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un tipo de servicio...", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal expOrdenamiento As String = "")
        Try
            pnlResultados.Visible = True

            Dim dvDatos As DataView = dtDatos.DefaultView
            If expOrdenamiento.Trim.Length > 0 Then dvDatos.Sort = expOrdenamiento

            With gvDatos
                .DataSource = dvDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtidServicio.Text = String.Empty
        ddlCiudad.SelectedIndex = -1
        ddlBodega.SelectedIndex = -1
        ddlVIP.SelectedIndex = -1
        ddlUrgente.SelectedIndex = -1
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        ddlPrioridad.SelectedIndex = -1
        ddlTipoServicio.SelectedIndex = -1
        ddlEstadoNovedad.SelectedIndex = -1
    End Sub

    Private Sub RegistrarSolucion()
        Try
            Dim resultado As ResultadoProceso
            Dim idUsuario As Integer = 1

            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)

            Dim miNovedad As New NovedadServicioMensajeria(hfIdNovedad.Value)
            miNovedad.IdEstado = Enumerados.EstadoNovedadMensajeria.Solucionada
            resultado = miNovedad.Actualizar(idUsuario)

            If resultado.Valor = 0 Then
                Dim miGestionNovedad As New GestionNovedadServicioMensajeria()
                miGestionNovedad.IdNovedad = hfIdNovedad.Value
                miGestionNovedad.Observacion = txtObservacionSolucion.Text
                Dim resultadoGestion As ResultadoProceso = miGestionNovedad.Registrar(idUsuario)

                If resultadoGestion.Valor = 0 Then
                    epNotificacion.showSuccess(resultadoGestion.Mensaje)
                Else
                    epNotificacion.showError(resultadoGestion.Mensaje)
                End If


                Dim dsDatos As DataSet
                dsDatos = CargarPool()
                If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
                    Session("dsNovedades") = dsDatos
                    EnlazarDatos(dsDatos.Tables(0))
                Else
                    epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                    EnlazarDatos(dsDatos.Tables(0))
                End If
            Else
                epNotificacion.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible marcar como solucionado: " & ex.Message)
        End Try
    End Sub

    Public Sub BuscarServicios()
        Dim dsDatos As DataSet
        Try
            dsDatos = CargarPool()
            If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
                Session("dsNovedades") = dsDatos
                EnlazarDatos(dsDatos.Tables(0))
                lbExportar.Enabled = True
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                EnlazarDatos(dsDatos.Tables(0))
                lbExportar.Enabled = False
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al realizar la búsqueda de Servicios: " & ex.Message)
        End Try
    End Sub

    Private Sub ExportarNovedades()
        Dim stArchivo As MemoryStream
        Try
            Dim objExcel As New ExcelManager()
            With objExcel
                .IncluirEncabezado = False
                stArchivo = .GenerarExcelAgrupado(ObtenerInformacionReporte(Session("dsNovedades")), "IdServicioMensajeria")
            End With

            Response.AddHeader("Content-Disposition", "attachment; filename=ReportePoolDeNovedades.xlsx")
            Response.ContentType = "application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            Response.BinaryWrite(stArchivo.ToArray)
            Response.End()

        Catch ex As Exception
            epNotificacion.showError("Se generó un error al exportar los Servicios: " & ex.Message)
        End Try
    End Sub

    Private Function ObtenerInformacionReporte(ByVal datos As DataSet) As DataSet
        Dim dsRespuesta As New DataSet
        Dim dtDetalle As DataTable = datos.Tables(1).Copy()

        With dsRespuesta
            .Tables.Add(datos.Tables(0).Copy())
            .Tables.Add(dtDetalle.DefaultView.ToTable(False, "IdServicioMensajeria", "TipoNovedad", "UsuarioRegistra", "FechaRegistro", "Estado", "Observacion", "ComentarioEspecifico").Copy())
        End With

        Return dsRespuesta
    End Function

#End Region

#Region "Funciones"

    Private Function CargarPool() As DataSet
        Dim dsDatos As New DataSet()
        Try
            Dim detalleNovedades As New NovedadServicioMensajeriaColeccion()
            If Not String.IsNullOrEmpty(txtidServicio.Text) Then
                If rblTipoBusqueda.SelectedValue = 1 Then
                    detalleNovedades.ListaNumeroRadicado = New ArrayList(txtidServicio.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                Else
                    detalleNovedades.ListaIdServicio = New ArrayList(txtidServicio.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                End If
            End If
            If ddlCiudad.SelectedValue <> "0" Then detalleNovedades.IdCiudad = ddlCiudad.SelectedValue
            If ddlBodega.SelectedValue <> "0" Then detalleNovedades.IdBodega = ddlBodega.SelectedValue
            If txtFechaInicial.Value <> "" Then detalleNovedades.FechaAgendaInicio = CDate(txtFechaInicial.Value)
            If txtFechaFinal.Value <> "" Then detalleNovedades.FechaAgendaFin = CDate(txtFechaFinal.Value)
            If ddlVIP.SelectedValue <> "0" Then detalleNovedades.ClienteVIP = IIf(ddlVIP.SelectedValue = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
            If ddlUrgente.SelectedValue <> "0" Then detalleNovedades.Urgente = IIf(ddlUrgente.SelectedValue = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
            If ddlPrioridad.SelectedValue <> "0" Then detalleNovedades.IdPrioridad = ddlPrioridad.SelectedValue
            If ddlEstadoNovedad.SelectedValue <> "0" Then detalleNovedades.IdEstadoNovedad = ddlEstadoNovedad.SelectedValue
            If ddlTipoServicio.SelectedValue <> "0" Then detalleNovedades.IdTipoServicio = ddlTipoServicio.SelectedValue
            detalleNovedades.IdUsuarioConsulta = CInt(Session("usxp001"))
            Dim dtDatos As DataTable = detalleNovedades.GenerarDataTable()

            dsDatos.Tables.Add(dtDatos.DefaultView.ToTable(True, "idServicioMensajeria", "numeroRadicado", _
                                                           "nombreCliente", "identificacion", "nombreContacto", _
                                                           "direccion", "telefono", "fechaAgenda", "tipoServicio", "consultor"))
            dsDatos.Tables.Add(dtDatos)

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Novedades. " & ex.Message)
        End Try

        Return dsDatos
    End Function

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

#End Region

End Class