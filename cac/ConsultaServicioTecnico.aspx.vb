Public Partial Class ConsultaServicioTecnico
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
        If Not IsPostBack Then
            Me.cargaInicial()
            hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
        End If
    End Sub

    Private Sub cargaInicial()
        Dim objCAC As New CAC
        Dim dt As DataTable = objCAC.consultarCAC()
        MetodosComunes.cargarDropDown(dt, ddlCAC, "Seleccione un CAC")
        lnkExportar.Visible = False
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Dim query As String = "  SELECT idservicio, serial, fecha, fecha_ingreso, fecha_entrega, fecha_respuesta, fecha_cierre,  " + _
        " serial_reemplazo, estado, idtercero, idcac, idproducto, razon, CAC, centro, almacen, descripcionEstado" + _
        " FROM VI_InfoServicioTecnico  WHERE estado = coalesce(@estado,estado) " + _
        " and idcac = coalesce (@idcac,idcac) " + _
        " and fecha_ingreso between coalesce(@fecha_ingreso1,fecha_ingreso) and coalesce(@fecha_ingreso2,fecha_ingreso) " + _
        " and fecha_entrega between coalesce(@fecha_entrega1,fecha_entrega) and coalesce(@fecha_entrega2,fecha_entrega)"
        Dim arrSeriales As ArrayList
        If txtSerial.Text <> "" Then
            arrSeriales = New ArrayList(txtSerial.Text.Split(vbCrLf))
            For i As Integer = 0 To arrSeriales.Count - 1
                If IsNumeric(arrSeriales(i).ToString.Trim) Then arrSeriales(i) = arrSeriales(i).ToString.Trim()
            Next
            query += " and serial in ('" & Join(arrSeriales.ToArray, "','") & "')"
        End If
        Dim db As New LMDataAccessLayer.LMDataAccess
        With db.SqlParametros
            .Add("@estado", SqlDbType.Int).Value = DBNull.Value
            .Add("@idcac", SqlDbType.Int).Value = DBNull.Value
            .Add("@fecha_ingreso1", SqlDbType.VarChar).Value = DBNull.Value
            .Add("@fecha_ingreso2", SqlDbType.VarChar).Value = DBNull.Value
            .Add("@fecha_entrega1", SqlDbType.VarChar).Value = DBNull.Value
            .Add("@fecha_entrega2", SqlDbType.VarChar).Value = DBNull.Value

            If ddlEstado.SelectedValue <> -1 Then .Item("@estado").Value = ddlEstado.SelectedValue
            If ddlCAC.SelectedValue > 0 Then .Item("@idcac").Value = ddlCAC.SelectedValue
            If txtFechaIngreso1.Text <> "" Then
                .Item("@fecha_ingreso1").Value = CDate(txtFechaIngreso1.Text).ToString("yyyyMMdd")
                .Item("@fecha_ingreso2").Value = CDate(txtFechaIngreso2.Text).ToString("yyyyMMdd")
            End If
            If txtFechaEntrega1.Text <> "" Then
                .Item("@fecha_entrega1").Value = CDate(txtFechaEntrega1.Text).ToString("yyyyMMdd")
                .Item("@fecha_entrega2").Value = CDate(txtFechaEntrega2.Text).ToString("yyyyMMdd")
            End If
        End With
        Dim dt As New DataTable
        Try
            dt = db.ejecutarDataTable(query, CommandType.Text)
            If dt.Rows.Count > 0 Then
                gvDatos.DataSource = dt
                gvDatos.Columns(0).FooterText = dt.Rows.Count.ToString & " Registro(s) Encontrado(s)"
            End If
            gvDatos.DataBind()
            lnkExportar.Visible = (dt.Rows.Count > 0)
        Catch ex As Exception
            lblError.Text = "Error al consultar datos"
        End Try
    End Sub

    Protected Sub lnkExportar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkExportar.Click
        Dim sw As New System.IO.StringWriter
        Dim gridHTML As HtmlTextWriter
        gridHTML = New HtmlTextWriter(sw)
        gvDatos.RenderControl(gridHTML)
        MetodosComunes.exportarDatosAExcel(HttpContext.Current, sw.ToString(), "Seriales en Servicio Técnico", "rs.xls", )
    End Sub

    Private Sub gvDatos_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles gvDatos.ItemDataBound
        If e.Item.ItemType = ListItemType.Footer Then
            For index As Integer = 1 To e.Item.Cells.Count - 1
                e.Item.Cells(index).Visible = False
            Next
            e.Item.Cells(0).ColumnSpan = e.Item.Cells.Count
        End If
    End Sub
End Class