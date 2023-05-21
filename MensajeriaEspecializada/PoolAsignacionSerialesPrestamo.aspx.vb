Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text

Partial Public Class PoolAsignacionSerialesPrestamo
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        Try
            If Not IsPostBack Then
                With epNotificacion
                    .setTitle("Pool de Asignación de Seriales de Préstamo")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))

                    CargarBodega()
                    CargarCiudad()
                    CargarVIP()
                    CargarPrioridad()

                    Dim dsDatos As DataSet
                    dsDatos = CargarPool()
                    If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
                        Session("dsServiciosPrestamo") = dsDatos
                        EnlazarDatos(dsDatos.Tables(0))
                    Else
                        epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                        EnlazarDatos(dsDatos.Tables(0))
                    End If
                End With
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dsServiciosPrestamo") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dsServiciosPrestamo"), DataSet).Tables(0)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos desde memorial, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dsServiciosPrestamo") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dsServiciosPrestamo"), DataSet).Tables(0)
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
            Dim idServicioMensajeria As String = CType(e.Row.DataItem, DataRowView).Item("idServicioMensajeria").ToString

            Dim gvDetalle As GridView = CType(e.Row.FindControl("gvDatosDetalle"), GridView)

            Dim dvDetalle As DataView = CType(Session("dsServiciosPrestamo"), DataSet).Tables(1).DefaultView
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
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub gvDatosDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try
                Dim txtImeiPrestamo As TextBox = e.Row.FindControl("txtImeiPrestamo")
                txtImeiPrestamo.Enabled = (txtImeiPrestamo.Text = String.Empty)
            Catch : End Try
        End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Session.Remove("dtEstructuraLog")
        Buscar()
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Protected Sub lbAsignarSeriales_Click(ByVal sender As Object, ByVal e As EventArgs)
        AsignarSeriales(sender)
        Buscar()
    End Sub

    Private Sub gvLog_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLog.RowDataBound
        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                If CBool(e.Row.DataItem("tipoError")) Then
                    e.Row.BackColor = Color.LightCoral
                Else
                    e.Row.BackColor = Color.LightGreen
                End If
            End If
        Catch : End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub Buscar()
        With gvLog
            .DataSource = ObtenerEstructuraLog()
            .DataBind()
        End With
        Dim dsDatos As DataSet
        dsDatos = CargarPool()
        If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
            Session("dsServiciosPrestamo") = dsDatos
            EnlazarDatos(dsDatos.Tables(0))
        Else
            epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
            EnlazarDatos(dsDatos.Tables(0))
        End If
    End Sub

    Private Sub CargarBodega()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarBodega
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
            End With

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

    Private Sub CargarPrioridad()
        Try
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaPrioridad(), ddlPrioridad)
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Prioridades. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtidServicio.Text = String.Empty
        ddlCiudad.SelectedIndex = -1
        ddlBodega.SelectedIndex = -1
        ddlVIP.SelectedIndex = -1
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        ddlPrioridad.SelectedIndex = -1

        Dim dsDatos As DataSet
        dsDatos = CargarPool()
        If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
            Session("dsServiciosPrestamo") = dsDatos
            EnlazarDatos(dsDatos.Tables(0))
        Else
            epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
            EnlazarDatos(dsDatos.Tables(0))
        End If
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

    Private Sub AsignarSeriales(ByVal sender As Object)
        Try
            Dim idUsuario As Integer = 0
            Integer.TryParse(Session("usxp001"), idUsuario)

            Dim rowServicio As GridViewRow = CType(CType(sender, LinkButton).NamingContainer, GridViewRow)
            Dim grillaSeriales As GridView = CType(CType(sender, LinkButton).Parent.FindControl("gvDatosDetalle"), GridView)

            Dim numeroRadicado As Long = CLng(rowServicio.Cells(2).Text)

            Session.Remove("dtEstructuraLog")
            For Each fila As GridViewRow In grillaSeriales.Rows
                Dim sItemiReparacion As String = fila.Cells(0).Text
                Dim txtImeiPrestamo As TextBox = CType(fila.FindControl("txtImeiPrestamo"), TextBox)

                If txtImeiPrestamo.Text <> String.Empty And txtImeiPrestamo.Enabled Then
                    Dim objDetalleImei As New DetalleImeiPrestamoServicioMensajeria(numeroRadicado, sItemiReparacion, txtImeiPrestamo.Text)
                    Dim resultado As ResultadoProceso = objDetalleImei.AsignarSerialPrestamo(idUsuario)
                    RegistrarLog(resultado.Mensaje, CBool(IIf(resultado.Valor = 0, False, True)))
                End If
            Next
            With gvLog
                .DataSource = ObtenerEstructuraLog()
                .DataBind()
            End With
            If ObtenerEstructuraLog.Rows.Count > 0 Then
                epNotificacion.showSuccess("Se realizó la asignación de seriales, por favor revise el log de resultados.")
            Else
                epNotificacion.showWarning("No se realizó ninguna asigación, por favor verifique los datos e intente nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Se genero error al tratar de asignar seriales: " & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarLog(ByVal mensaje As String, ByVal esError As Boolean)
        Try
            Dim dtTemp As DataTable = ObtenerEstructuraLog()
            Dim row As DataRow = dtTemp.NewRow()
            row.Item("mensaje") = mensaje
            row.Item("tipoError") = esError
            With dtTemp
                .Rows.Add(row)
                .AcceptChanges()
            End With
            Session("dtEstructuraLog") = dtTemp
        Catch ex As Exception
            epNotificacion.showError("Error al registrar log: " & ex.Message)
        End Try
    End Sub


    Private Function CargarPool() As DataSet
        Dim dsDatos As New DataSet()
        Dim datos As New GenerarPoolAsignacionSerialesPrestamo
        Try
            With datos
                If txtidServicio.Text <> "" Then .NumeroRadicado = CInt(txtidServicio.Text)
                If ddlCiudad.SelectedValue <> "0" Then .IdCiudad = ddlCiudad.SelectedValue
                If ddlBodega.SelectedValue <> "0" Then .IdBodega = ddlBodega.SelectedValue
                If txtFechaInicial.Value <> "" Then .FechaCreacionInicial = CDate(txtFechaInicial.Value)
                If txtFechaFinal.Value <> "" Then .FechaCreacionFinal = CDate(txtFechaFinal.Value)
                If ddlVIP.SelectedValue <> "0" Then .ClienteVIP = IIf(ddlVIP.SelectedValue = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                If ddlPrioridad.SelectedValue <> "0" Then .IdPrioridad = ddlPrioridad.SelectedValue
            End With

            Dim dtDatos As DataTable = datos.GenerarPool()

            dsDatos.Tables.Add(dtDatos.DefaultView.ToTable(True, "idServicioMensajeria", "numeroRadicado", _
                                                           "nombreCliente", "identificacion", "nombreContacto", _
                                                           "direccion", "telefono", "fechaRegistro", "fechaAgenda"))
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

    Private Function ObtenerEstructuraLog() As DataTable
        Try
            If Session("dtEstructuraLog") Is Nothing Then
                Dim dtEstructuraLog As New DataTable()
                Dim dcMensaje As New DataColumn("mensaje", GetType(String))
                Dim dcTipoError As New DataColumn("tipoError", GetType(Boolean))
                With dtEstructuraLog
                    .Columns.Add(dcMensaje)
                    .Columns.Add(dcTipoError)
                    .AcceptChanges()
                End With
                Session("dtEstructuraLog") = dtEstructuraLog
            End If
            Return CType(Session("dtEstructuraLog"), DataTable)
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al tratar de crea la estructura de log: " & ex.Message)
        End Try
    End Function

#End Region

End Class