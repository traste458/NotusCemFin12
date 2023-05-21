Imports ILSBusinessLayer
Imports ILSBusinessLayer.LogisticaInversa
Imports ILSBusinessLayer.Localizacion

Partial Public Class BusquedaOrdenesRecoleccion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            EncabezadoPagina1.setTitle("Consulta de Órdenes de Recolección")
            CargarListadoOrigen()
            CargarListadoDestino()
            'carga la maxima fecha para validar selección 
            CompareValidatorcreacionActual.ValueToCompare = Date.Now.ToShortDateString()
            EncabezadoPagina1.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            Me.CargaInicial()
            If Request.QueryString("ok") IsNot Nothing Then
                EncabezadoPagina1.showSuccess("Se ha creado la orden No." & Request.QueryString("ok").ToString())
            ElseIf Request.QueryString("mod") IsNot Nothing Then
                EncabezadoPagina1.showSuccess("Se ha actualizado la orden No." & Request.QueryString("mod").ToString())
            End If
        End If
    End Sub

    Private Sub CargaInicial()
        Dim dt As DataTable = Ciudad.ObtenerCiudadesPorPais()
        Dim filtroTransportadora As Estructuras.FiltroTransportadora

        filtroTransportadora.Activo = Enumerados.EstadoBinario.Activo
        filtroTransportadora.AplicaLogisticaInversa = 1

        dt = ILSBusinessLayer.Transportadora.ListadoTransportadoras(filtroTransportadora)

        MetodosComunes.CargarDropDown(dt, CType(ddlTransportadora, ListControl))
        trFerchas.Visible = False
        If Session("filtroBusquedaRecoleccion") IsNot Nothing Then
            Me.ConsultarOrdenes(Session("filtroBusquedaRecoleccion"))
        End If
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

    Protected Sub lnkBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkBuscar.Click
        Dim filtro As Estructuras.FiltroOrdenRecoleccion
        With filtro
            If txtIdOrden.Text.Trim <> "" Then .IdOrden = txtIdOrden.Text
            If ddlTransportadora.SelectedValue > 0 Then .IdTransportadora = ddlTransportadora.SelectedValue
            If ddlOrigen.SelectedValue <> 0 Then .IdOrigen = ddlOrigen.SelectedValue
            If ddlDestino.SelectedValue <> 0 Then .IdDestino = ddlDestino.SelectedValue
            If txtOrdensServicio.Text.Trim() <> "" Then .OrdenServicio = txtOrdensServicio.Text
            If txtGuia.Text.Trim() <> "" Then .Guia = txtGuia.Text
            If ddlFecha.SelectedValue > 0 Then
                If txtFechaCreacion1.Text <> "" Then
                    .FechaIncio = txtFechaCreacion1.Text
                    .FechaFin = txtFechaCreacion2.Text
                    .TipoFecha = ddlFecha.SelectedValue
                End If
            End If
        End With
        Me.ConsultarOrdenes(filtro)
    End Sub

    Private Sub gvOrdenes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvOrdenes.RowCommand
        If e.CommandName = "Editar" Then
            Try
                Dim orden As New OrdenRecoleccion(e.CommandArgument)
                If orden.FechaRecoleccionPunto = Date.MinValue Then
                    Response.Redirect("ModificarOrdenRecoleccion.aspx?idOrden=" & e.CommandArgument)
                Else
                    EncabezadoPagina1.showWarning("La orden ha sido cerrada resientemente y no se encuentra activa para su edición")
                End If
            Catch ex As Exception
                EncabezadoPagina1.showError("Error al tratar de obtener los datos de la orden " & ex.Message)
            End Try
        ElseIf e.CommandName = "VerNovedades" Then
            Response.Redirect("NovedadesRecoleccion.aspx?idOrden=" & e.CommandArgument)
        ElseIf e.CommandName = "VerHistorial" Then
            Response.Redirect("VistaLogOrdenRecoleccion.aspx?idOrden=" & e.CommandArgument)
        End If
    End Sub


    Private Sub ConsultarOrdenes(ByVal filtro As Estructuras.FiltroOrdenRecoleccion)
        Dim dt As DataTable = OrdenRecoleccion.ConsultarOrdenes(filtro)
        gvOrdenes.DataSource = dt
        gvOrdenes.DataBind()
        Session("filtroBusquedaRecoleccion") = filtro
    End Sub

    Protected Sub ddlFecha_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlFecha.SelectedIndexChanged
        trFerchas.Visible = (ddlFecha.SelectedIndex > 0)
    End Sub

    Private Sub gvOrdenes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOrdenes.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim fila As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim fecha As Date
            If Date.TryParse(fila("fecharecoleccionpunto").ToString(), fecha) Then
                e.Row.FindControl("imgEditar").Visible = False
            End If
        End If
    End Sub
End Class