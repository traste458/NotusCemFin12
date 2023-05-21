Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion

Partial Public Class PoolRutasActivas
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _altoVentana As Integer
    Private _anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        ObtenerTamanoVentana()
        Try
            If Not IsPostBack Then
                With epNotificacion
                    .setTitle("Pool Rutas Activas")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With

                CargarJornadas()
                CargarCiudad()
                CargarEstado()

                txtRuta.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")

                Dim dtDatos As DataTable = CargarPool()
                If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                    Session("dtRutas") = dtDatos
                    EnlazarDatos(dtDatos)
                Else
                    epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                    EnlazarDatos(dtDatos)
                End If
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó un error a tratar de cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtRutas") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtRutas"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos desde memoria, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dtRutas") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtRutas"), DataTable)
                Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
                EnlazarDatos(dtDatos, expOrdenamiento)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            'Dim idRuta As String = CType(e.Row.DataItem, DataRowView).Item("idRuta").ToString

            'Dim gvDetalle As GridView = CType(e.Row.FindControl("gvDatosDetalle"), GridView)

            'Dim dvDetalle As DataView = CType(Session("dtRutas"), DataTable).DefaultView
            'dvDetalle.RowFilter = "idRuta = " & idRuta

            'Dim img As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgCollapse"), System.Web.UI.WebControls.Image)
            'Dim pnlDetalle As Panel = CType(e.Row.FindControl("pnlDetalle"), Panel)

            'img.Attributes.Add("onclick", "javascript:CollapseDetail(this,'" & pnlDetalle.ClientID & "');")

            'gvDetalle.DataSource = dvDetalle.ToTable()
            'gvDetalle.DataBind()
        End If
    End Sub

    Private Sub gvDatos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Dim idRuta As Integer
        Try
            Integer.TryParse(e.CommandArgument, idRuta)

            Select Case e.CommandName
                Case "VerOcultarDetalleRuta"
                    Dim ibAux As ImageButton = CType(e.CommandSource, ImageButton)
                    Dim auxRow As GridViewRow = CType(ibAux.NamingContainer, GridViewRow)
                    Dim gv As GridView = CType(auxRow.FindControl("gvDatosDetalle"), GridView)
                    Dim pnlDetalle As Panel = CType(auxRow.FindControl("pnlDetalle"), Panel)
                    Dim status As String = pnlDetalle.Style.Item("display")

                    If status = "none" Then
                        pnlDetalle.Style.Item("display") = "block"
                        ibAux.ImageUrl = "~/images/contraer.png"
                        EnlazarDetalleRuta(gv, idRuta)
                    Else
                        gv.DataBind()
                        ibAux.ImageUrl = "~/images/expandir.png"
                        pnlDetalle.Style.Item("display") = "none"
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de procesar comando. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDatosDetalle_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Try
            Dim idServicio As Integer
            Dim idTipoServicio As Integer
            Integer.TryParse(e.CommandArgument.ToString, idServicio)
            Integer.TryParse(New ServicioMensajeria(idServicio).IdTipoServicio, idTipoServicio)

            Select Case e.CommandName
                Case "ver"
                    With dlgVerInformacionServicio
                        .Width = Unit.Pixel(Me._anchoVentana * 0.95)
                        .Height = Unit.Pixel(Me._altoVentana * 0.93)

                        If idTipoServicio = Enumerados.TipoServicio.Venta Then
                            .ContentUrl = "VerInformacionServicioTipoVenta.aspx?idServicio=" & idServicio.ToString
                        ElseIf idTipoServicio = Enumerados.TipoServicio.Siembra Then
                            .ContentUrl = "VerInformacionServicioTipoSiembra.aspx?idServicio=" & idServicio.ToString
                        Else
                            .ContentUrl = "VerInformacionServicio.aspx?idServicio=" & idServicio.ToString
                        End If
                        .Show()
                    End With
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub gvDatosDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        'If e.Row.RowType = DataControlRowType.DataRow Then
        '    Try
        '    Catch : End Try
        'End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Buscar()
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        Try
            txtFechaAgendaInicial.Value = ""
            txtFechaAgendaFinal.Value = ""
            txtFechaCreacionInicial.Value = ""
            txtFechaCreacionFinal.Value = ""
            txtRuta.Text = ""
            ddlJornada.SelectedIndex = -1
            ddlCiudad.SelectedIndex = -1
            ddlEstado.SelectedIndex = -1

            Dim dtDatos As DataTable = CargarPool()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                Session("dtRutas") = dtDatos
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                EnlazarDatos(dtDatos)
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible limpiar filtros: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos"

    Private Sub CargarJornadas()
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaJornadaMensajeria()
            With ddlJornada
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idJornada"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja una Jornada", "0"))
            End With

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el listado de Jornadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarEstado()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarEstado(Enumerados.Entidad.RutaMensajeria)
            With ddlEstado
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idEstado"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Estado...", "0"))
                End If
            End With
            Session("ArrEstadoPorDefecto") = HerramientasMensajeria.ObtenerListaEstadosPorDefecto(Enumerados.FuncionalidadMensajeria.PoolRutasActivas)
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Estados. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudad()
        Dim dtCiudad As New DataTable
        Dim datos As New Ciudad
        Try
            dtCiudad = Ciudad.ObtenerCiudadesPorPais
            With ddlCiudad
                .DataSource = dtCiudad
                .DataTextField = "nombre"
                .DataValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Ciudad...", "0"))
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
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
            Session("dtRutas") = dvDatos.ToTable()
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub Buscar()
        Try
            Dim dtDatos As DataTable = CargarPool()

            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                Session("dtRutas") = dtDatos
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                EnlazarDatos(dtDatos)
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible realizar búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Function CargarPool() As DataTable
        Dim dtDatos As New DataTable()
        Try
            Dim filtro As New RutaServicioMensajeria.FiltroRutaMensajeria

            If Not String.IsNullOrEmpty(txtFechaAgendaInicial.Value) And Not String.IsNullOrEmpty(txtFechaAgendaFinal.Value) Then
                filtro.FechaAgendaInicial = CDate(txtFechaAgendaInicial.Value)
                filtro.FechaAgendaFinal = CDate(txtFechaAgendaFinal.Value)
            End If
            If Not String.IsNullOrEmpty(txtFechaCreacionInicial.Value) And Not String.IsNullOrEmpty(txtFechaCreacionFinal.Value) Then
                filtro.FechaCreacionInicial = CDate(txtFechaCreacionInicial.Value)
                filtro.FechaCreacionFinal = CDate(txtFechaCreacionFinal.Value)
            End If
            If ddlJornada.SelectedValue <> "" Then filtro.IdJornada = ddlJornada.SelectedValue
            If ddlCiudad.SelectedValue <> "0" Then filtro.IdCiudad = ddlCiudad.SelectedValue
            If ddlEstado.SelectedValue <> "0" Then
                filtro.IdEstado = ddlEstado.SelectedValue
            ElseIf Session("ArrEstadoPorDefecto") IsNot Nothing Then
                filtro.ListaEstado = Session("ArrEstadoPorDefecto")
            End If
            If Not String.IsNullOrEmpty(txtRuta.Text) Then filtro.IdRuta = CInt(txtRuta.Text)

            dtDatos = RutaServicioMensajeria.ObtenerListado(filtro)
        Catch ex As Exception
            Throw ex
        End Try

        Return dtDatos
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

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me._altoVentana = CInt(arrAux(0))
                Me._anchoVentana = CInt(arrAux(1))
            End If
        End If
    End Sub

    Private Sub EnlazarDetalleRuta(ByVal gvDetalle As GridView, ByVal idRuta As Long)
        Try
            Dim dtDatosDetalle = RutaServicioMensajeria.ObtenerRadicadosPorId(idRuta)
            With gvDetalle
                .DataSource = dtDatosDetalle
                .DataBind()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

End Class