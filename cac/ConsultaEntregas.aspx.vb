Public Partial Class ConsultaEntregas
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
        If Not IsPostBack Then
            Me.cargaInicial()
            hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
        End If
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Dim query As String = " SELECT    identrega, serial, idproducto, idsubproducto, estado, fechaRegistro, idcac, " + _
        " cac, centro, almacen, descripcionEstado, idsubproducto2, subproducto,idtipoentrega, tipoentrega " + _
        " FROM VI_SerialesEntregasCAC WHERE estado = coalesce(@estado,estado) " + _
        " and idcac = coalesce (@idcac,idcac)  and idtipoentrega= coalesce(@idtipoentrega,idtipoentrega) " + _
        " and isnull(fechaRegistro,0) between coalesce(@fechaRegistro1,isnull(fecha_devolucion,0)) and coalesce(@fechaRegistro2,isnull(fechaRegistro,0)) "
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
            .Add("@estado", SqlDbType.SmallInt).Value = DBNull.Value
            .Add("@idcac", SqlDbType.Int).Value = DBNull.Value
            .Add("@fechaRegistro1", SqlDbType.VarChar).Value = DBNull.Value
            .Add("@fechaRegistro2", SqlDbType.VarChar).Value = DBNull.Value
            .Add("@idtipoentrega", SqlDbType.Int).Value = DBNull.Value

            If ddlEstado.SelectedValue <> -1 Then .Item("@estado").Value = ddlEstado.SelectedValue
            If ddlCAC.SelectedValue > 0 Then .Item("@idcac").Value = ddlCAC.SelectedValue
            If txtFecha1.Text <> "" Then
                .Item("@fechaRegistro1").Value = CDate(txtFecha1.Text).ToString("yyyyMMdd")
                .Item("@fechaRegistro2").Value = CDate(txtFecha2.Text).ToString("yyyyMMdd")
            End If
            If ddlTipoEntrega.SelectedValue > 0 Then .Item("@idtipoentrega").Value = ddlTipoEntrega.SelectedValue
        End With
        Dim dt As New DataTable
        dt = db.ejecutarDataTable(query, CommandType.Text)
        If dt.Rows.Count > 0 Then
            gvDatos.DataSource = dt
            gvDatos.Columns(0).FooterText = dt.Rows.Count.ToString & " Registro(s) Encontrado(s)"

        End If
        gvDatos.DataBind()
        lnkExportar.Visible = (dt.Rows.Count > 0)
    End Sub

    Private Sub cargaInicial()
        Dim objCAC As New CAC
        Dim dt As DataTable = objCAC.consultarCAC()
        MetodosComunes.cargarDropDown(dt, ddlCAC, "Seleccione un CAC")
        lnkExportar.Visible = False

        Dim db As New LMDataAccessLayer.LMDataAccess
        Dim query As String = "select idtipoentrega, tipoentrega from tipoentregas where estado = 1"
        dt = db.ejecutarDataTable(query, CommandType.Text)
        MetodosComunes.cargarDropDown(dt, ddlTipoEntrega, "Seleccioe un tipo de entrega...")

    End Sub

    Protected Sub lnkExportar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkExportar.Click
        Dim sw As New System.IO.StringWriter
        Dim gridHTML As HtmlTextWriter
        gridHTML = New HtmlTextWriter(sw)
        gvDatos.RenderControl(gridHTML)
        MetodosComunes.exportarDatosAExcel(HttpContext.Current, sw.ToString(), "Consulta de Seriales por Prestamo y Siembra", "rs.xls", )
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