Imports GemBox.Spreadsheet
Imports System.IO
Imports System.Data.SqlClient
Partial Class ReporteRemision

    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
        lblError.Text = ""
        Dim remisiones As String
        Try
            If Not IsPostBack Then
                remisiones = CType(Session("remisiones"), String)
                cargarReporte(remisiones)
                cargarNovedadesEnSesion(remisiones)
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de cargar Página. " & ex.Message
        End Try

    End Sub

#Region "Carga los datos de la Remisiones según su consulta"

    Private Sub cargarReporte(ByVal remisiones As String)
        Dim sentencia, fechaInicial, fechaFinal As String, dtDatos As New DataTable
        Dim arregloParametro As New ArrayList, parametro As System.Data.SqlClient.SqlParameter

        Try
            fechaInicial = Request.QueryString("fechaInicial")
            fechaFinal = Request.QueryString("fechaFinal")
            sentencia = "select res.remision,isnull((select pos from pos with(nolock) where idpos = infoEn.idpos),'')  as pos," & _
            " ins_fec as fechaRegistro,res.fecha as fechaDespacho,isnull(guia_transp,'') as numGuia,(select fechaEntregaTransportadora" & _
            " from HistorialConfirmacionEntrega where remision=res.remision) as fechaTrans,fecha_LLegada as fechaPDV,(select count(0)" & _
            " from HistorialNovedadEntrega with(nolock) where remision=res.remision) as historial from viRemisiones res  with(nolock)" & _
            " inner join InformacionRemisionEntrega infoEn with(nolock) on infoEn.remision = res.remision "
            If remisiones <> "" Then
                sentencia += " where res.remision in (" & remisiones & ")"
            Else
                If fechaInicial <> "" And fechaFinal <> "" Then
                    sentencia += " where convert(varchar,res.ins_fec,112) between @fechaInicial and @fechaFinal"
                    parametro = New System.Data.SqlClient.SqlParameter("@fechaInicial", SqlDbType.VarChar)
                    parametro.Value = String.Format("{0:yyyyMMdd}", CDate(fechaInicial))
                    arregloParametro.Add(parametro)
                    parametro = New System.Data.SqlClient.SqlParameter("@fechaFinal", SqlDbType.VarChar)
                    parametro.Value = String.Format("{0:yyyyMMdd}", CDate(fechaFinal))
                    arregloParametro.Add(parametro)
                End If
            End If
            dtDatos = MetodosComunes.consultaBaseDatos(sentencia, arregloParametro)
            If dtDatos.Rows.Count > 0 Then
                Session("datosReporte") = dtDatos
                dgResultado.DataSource = dtDatos
                dgResultado.Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                dgResultado.DataBind()
                MetodosComunes.mergeFooter(dgResultado)
                lbExportar.Visible = True
            Else
                lblError.Text = "<i>No se encontró ninguna remisión con los criterios de búsqueda proporcionados</i>"
            End If
        Catch ex As Exception
            Throw New Exception("Imposible obtener la información de las Remisiones. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Movimiento en la grilla dgResultado"
    'definición de los estado en la grilla según las fecha de la grilla y sus novedades
    Private Sub dgResultado_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgResultado.ItemDataBound
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            If e.Item.Cells(8).Text <> 0 Then
                CType(e.Item.Cells(9).Controls(1), ImageButton).Visible = True
            End If
            If e.Item.Cells(5).Text.Replace("&nbsp;", "") = "" And e.Item.Cells(6).Text.Replace("&nbsp;", "") = "" Then e.Item.Cells(7).Text = "Transito"
            If e.Item.Cells(5).Text.Replace("&nbsp;", "") <> "" And e.Item.Cells(6).Text.Replace("&nbsp;", "") = "" Then e.Item.Cells(7).Text = "Confirmado Transportadora"
            If e.Item.Cells(5).Text.Replace("&nbsp;", "") = "" And e.Item.Cells(6).Text.Replace("&nbsp;", "") <> "" Then e.Item.Cells(7).Text = "Confirmado PDV"
            If e.Item.Cells(5).Text.Replace("&nbsp;", "") <> "" And e.Item.Cells(6).Text.Replace("&nbsp;", "") <> "" Then e.Item.Cells(7).Text = "Recibido"
        End If
    End Sub

    'se existe la novedad se consulta y muestra la información
    Private Sub dgResultado_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgResultado.EditCommand
        'Dim sentencia As String, dtDatos As DataTable, parametro As System.Data.SqlClient.SqlParameter, arreglo As New ArrayList
        Try
            If Not Session("dtListadoNovedadesConsulta") Is Nothing Then
                Dim dtNovedad As DataTable = CType(Session("dtListadoNovedadesConsulta"), DataTable)
                Dim dwNovedad As DataView = dtNovedad.DefaultView
                dwNovedad.RowFilter = "remision=" & e.Item.Cells(0).Text.Trim
                With dgNovedades
                    .DataSource = dwNovedad
                    .Columns(0).FooterText = dwNovedad.Count.ToString & " Registro(s) Encontrado(s)"
                    .DataBind()
                End With
                MetodosComunes.mergeFooter(dgNovedades)
            Else
                lblError.Text = "Imposible recuperar el listado de Novedades. Por favor vuelva a cargar la página"
            End If
            ''parametro = New System.Data.SqlClient.SqlParameter("@remision", SqlDbType.Int)
            ''parametro.Value = Integer.Parse(e.Item.Cells(0).Text)
            ''arreglo.Add(parametro)
            ''sentencia = "select remision,(select descripcion from NovedadTransporte with(nolock) where codigoNovedad ="
            ''sentencia += "(select codigoNovedad from DetalleHistorialNovedadEntrega with(nolock) where idHistorialNovedadEntrega = "
            ''sentencia += "his.idHistorialNovedadEntrega )) as novedad,convert(varchar,fechaNovedadTransportadora,103) as fechaNovedad,"
            ''sentencia += "convert(varchar,fechaRegistroNovedad,103) as fechaRegistro,his.observacion,(select nombreApellido from UsuarioWebService "
            ''sentencia += " with(nolock) where idUsuario = his.idUsuarioRegistra) as registrado from HistorialNovedadEntrega his with(nolock)"
            ''sentencia += " where remision = @remision"
            ''dtDatos = MetodosComunes.consultaBaseDatos(sentencia, arreglo)
            ''If dtDatos.Rows.Count > 0 Then
            ''    With dgNovedades
            ''        .DataSource = dtDatos
            ''        .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
            ''        .DataBind()
            ''    End With
            ''    MetodosComunes.mergeFooter(dgNovedades)
            ''Else

            ''End If
        Catch ex As Exception
            lblError.Text = "Error al consultar el historial de las novedades. " & ex.Message
        End Try
    End Sub

    'movimientos de la paginación de la grilla
    Private Sub dgResultado_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgResultado.PageIndexChanged
        If Not CType(Session("datosReporte"), DataTable) Is Nothing Then
            With dgResultado
                .CurrentPageIndex = e.NewPageIndex
                .DataSource = CType(Session("datosReporte"), DataTable)
                .Columns(0).FooterText = CType(Session("datosReporte"), DataTable).Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            MetodosComunes.mergeFooter(dgResultado)
        Else
            lblError.Text = "Imposible recuperar la información de las remisiones."
        End If
    End Sub
#End Region

    Private Sub cargarNovedadesEnSesion(ByVal remisiones As String)
        Dim dtNovedad As New DataTable
        Dim sqlConexion As SqlConnection, sqlAdaptador As SqlDataAdapter
        Dim sqlQuery, fechaInicial, fechaFinal As String


        With Request.QueryString
            If Not .Item("fechaInicial") Is Nothing Then fechaInicial = .Item("fechaInicial").Trim
            If Not .Item("fechaFinal") Is Nothing Then fechaFinal = .Item("fechaFinal").Trim
        End With
        sqlQuery = "select remision,(select descripcion from NovedadTransporte with(nolock) where codigoNovedad=det.codigoNovedad)" & _
        " as novedad,fechaNovedadTransportadora as fechaNovedad,fechaRegistroNovedad as fechaRegistro,his.observacion,(select" & _
        " nombreApellido from UsuarioWebService with(nolock) where idUsuario=his.idUsuarioRegistra) as registrado from" & _
        " HistorialNovedadEntrega his with(nolock) inner join DetalleHistorialNovedadEntrega det with(nolock) on" & _
        " his.idHistorialNovedadEntrega=det.idHistorialNovedadEntrega where remision in "
        'sqlQuery = "select remision,(select descripcion from NovedadTransporte with(nolock) where codigoNovedad=(select codigoNovedad" & _
        '    " from DetalleHistorialNovedadEntrega with(nolock) where idHistorialNovedadEntrega=his.idHistorialNovedadEntrega))" & _
        '    " as novedad,convert(varchar,fechaNovedadTransportadora,103) as fechaNovedad,convert(varchar,fechaRegistroNovedad,103)" & _
        '    " as fechaRegistro,his.observacion,(select nombreApellido from UsuarioWebService with(nolock) where idUsuario=" & _
        '    " his.idUsuarioRegistra) as registrado from HistorialNovedadEntrega his with(nolock) where remision in "
        If remisiones.Trim <> "" Then
            sqlQuery += "(" & remisiones & ")"
        ElseIf fechaInicial <> "" And fechaFinal <> "" Then
            sqlQuery += "(select remision from viRemisiones as res with(nolock) where convert(varchar,res.ins_fec,112)"
            sqlQuery += " between @fechaInicial and @fechaFinal)"
        Else
            sqlQuery = "(select remision from viRemisiones as res with(nolock))"
        End If
        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlAdaptador, sqlQuery)
            If fechaInicial <> "" And fechaFinal <> "" Then
                With sqlAdaptador.SelectCommand.Parameters
                    .Add("@fechaInicial", SqlDbType.VarChar, 10).Value = String.Format("{0:yyyyMMdd}", CDate(fechaInicial))
                    .Add("@fechaFinal", SqlDbType.VarChar, 10).Value = String.Format("{0:yyyyMMdd}", CDate(fechaFinal))
                End With
            End If
            sqlAdaptador.Fill(dtNovedad)
            Session("dtListadoNovedadesConsulta") = dtNovedad
        Catch ex As Exception
            lblError.Text = "Ocurrió un error al tratar de cargar el listado de Novedades. Por favor intente realizar el procedimiento nuevamente."
        End Try
    End Sub

    Private Sub lbExportar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbExportar.Click
        Dim nombreArchivo, ruta As String
        Try
            If Not Session("dtListadoNovedadesConsulta") Is Nothing Then
                Dim dtNovedad As DataTable = CType(Session("dtListadoNovedadesConsulta"), DataTable)
                nombreArchivo = "ReporteRemisionesNovedades_" & Session("usxp001") & ".xls"
                ruta = Server.MapPath("../archivos_planos/" & nombreArchivo)
                lblError.Text = ruta & "<br>"
                generarReporteEnExcel(nombreArchivo, dtNovedad)
                If File.Exists(ruta) Then
                    Response.Clear()
                    Response.ContentType = "application/octet-stream"
                    Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                    Response.Flush()
                    Response.WriteFile(ruta)
                End If
            Else
                lblError.Text = "Imposible recuperar el listado de Novedades. Por favor vuelva a cargar la página"
            End If
        Catch ex As Exception
            lblError.Text = "Error al Exprotar a Excel los datos. " & ex.Message
        End Try
    End Sub

#Region "Exportación a Excel"

    Private Sub generarReporteEnExcel(ByRef nombreArchivo As String, Optional ByVal dtNovedad As DataTable = Nothing)
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Dim excelFile As New ExcelFile, dtRemisiones As DataTable, novedad, ruta As String
        Dim ws As ExcelWorksheet, filaActual As Integer
        nombreArchivo = "ReporteRemisionesNovedades_" & Session("usxp001") & ".xls"
        ruta = Server.MapPath("../archivos_planos/") & nombreArchivo
        Try
            ws = excelFile.Worksheets.Add("REMISIONES NOVEDADES")
            setHeaderAndFormatToRemisionesSheet(ws)
            dtRemisiones = CType(Session("datosReporte"), DataTable)
            filaActual = 2
            For Each drRemision As DataRow In dtRemisiones.Rows
                If drRemision("fechaTrans").ToString = "" And drRemision("fechaPDV").ToString = "" Then novedad = "Transito"
                If drRemision("fechaTrans").ToString <> "" And drRemision("fechaPDV").ToString = "" Then novedad = "Confirmado Transportadora"
                If drRemision("fechaTrans").ToString = "" And drRemision("fechaPDV").ToString <> "" Then novedad = "Confirmado PDV"
                If drRemision("fechaTrans").ToString <> "" And drRemision("fechaPDV").ToString <> "" Then novedad = "Recibido"
                ws.Cells("A" & filaActual.ToString).Value = drRemision("remision").ToString
                ws.Cells("B" & filaActual.ToString).Value = drRemision("pos").ToString
                If drRemision("fechaRegistro").ToString <> "" Then
                    With ws.Cells("C" & filaActual.ToString)
                        .Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                        '.Style.NumberFormat = "dd/MM/yyyy hh:mm:ss AM/PM"
                        .Value = String.Format("{0:dd/MM/yyyy hh:mm tt}", drRemision("fechaRegistro"))
                    End With
                End If
                If drRemision("fechaDespacho").ToString <> "" Then
                    With ws.Cells("D" & CStr(filaActual))
                        .Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                        '.Style.NumberFormat = "dd/MM/yyyy"
                        .Value = String.Format("{0:dd/MM/yyyy}", drRemision("fechaDespacho"))
                    End With
                End If
                ws.Cells("E" & filaActual.ToString).Value = drRemision("numGuia").ToString
                If drRemision("fechaTrans").ToString <> "" Then
                    With ws.Cells("F" & filaActual.ToString)
                        .Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                        '.Style.NumberFormat = "dd/MM/yyyy hh:mm:ss AM/PM"
                        .Value = String.Format("{0:dd/MM/yyyy hh:mm tt}", drRemision("fechaTrans"))
                    End With
                End If
                If drRemision("fechaPDV").ToString <> "" Then
                    With ws.Cells("G" & filaActual.ToString)
                        .Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                        .Value = String.Format("{0:dd/MM/yyyy hh:mm tt}", drRemision("fechaPDV"))
                    End With
                End If
                ws.Cells("H" & filaActual.ToString).Value = novedad
                For Each cell As ExcelCell In ws.Cells.GetSubrange("A" & CStr(filaActual), "H" & CStr(filaActual))
                    cell.Style.Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                Next
                filaActual += 1
            Next
            ws.Cells("A" & filaActual.ToString).Value = dtRemisiones.Rows.Count.ToString & " Remision(es) Encontrada(s)"
            ws.Cells.GetSubrangeAbsolute(filaActual - 1, 0, filaActual - 1, 7).Merged = True
            With ws.Cells("A" & filaActual.ToString).Style
                .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                .Font.Color = Color.DarkBlue
                .Font.Weight = ExcelFont.BoldWeight
                .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
            End With
            For i As Integer = 0 To 7
                ws.Columns(i).AutoFitAdvanced(1)
            Next
            If Not dtNovedad Is Nothing Then
                If dtNovedad.Rows.Count > 0 Then
                    ws = excelFile.Worksheets.Add("DETALLE NOVEDADES")
                    setHeaderAndFormatToNovedadesSheet(ws)
                    filaActual = 2
                    For Each drNovedad As DataRow In dtNovedad.Rows
                        ws.Cells("A" & filaActual.ToString).Value = drNovedad("remision")
                        ws.Cells("B" & filaActual.ToString).Value = drNovedad("novedad")
                        With ws.Cells("C" & filaActual.ToString)
                            .Value = drNovedad("fechaNovedad")
                            .Style.NumberFormat = "dd/mm/yyyy hh:mm AM/PM"
                        End With
                        ws.Cells("D" & filaActual.ToString).Value = drNovedad("registrado")
                        For i As Integer = 0 To 3
                            With ws.Cells(filaActual - 1, i).Style
                                .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                            End With
                        Next
                        filaActual += 1
                    Next
                    For index As Byte = 0 To 3
                        ws.Columns(index).AutoFitAdvanced(1)
                    Next
                    ws.Cells("A" & filaActual.ToString).Value = dtNovedad.Rows.Count.ToString & " Novedad(es) Encontrada(s)"
                    ws.Cells.GetSubrangeAbsolute(filaActual - 1, 0, filaActual - 1, 3).Merged = True
                    With ws.Cells("A" & filaActual.ToString).Style
                        .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                        .Font.Color = Color.DarkBlue
                        .Font.Weight = ExcelFont.BoldWeight
                        .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                    End With
                End If
            End If
            excelFile.SaveXls(ruta)
        Catch ex As Exception
            lblError.Text = "No fue posible generar el reporte en Excel.<br><br>" & ex.Message & ex.StackTrace
        Finally
            ws.Delete()
        End Try
    End Sub

#Region "arreglo de las hojas de Excel"

    Private Sub setHeaderAndFormatToNovedadesSheet(ByRef oWs As ExcelWorksheet)
        oWs.Cells("A1").Value = "Remisión"
        oWs.Cells("B1").Value = "Novedad"
        oWs.Cells("C1").Value = "Fecha de la Novedad"
        oWs.Cells("D1").Value = "Registrado Por"

        For i As Integer = 0 To 3
            With oWs.Cells(0, i).Style
                .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                .Font.Color = Color.White
                .Font.Weight = ExcelFont.BoldWeight
                .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                .HorizontalAlignment = HorizontalAlignmentStyle.Center
            End With

        Next
    End Sub

    Private Sub setHeaderAndFormatToRemisionesSheet(ByRef oWs As ExcelWorksheet)
        oWs.Cells("A1").Value = "Remisión"
        oWs.Cells("B1").Value = "Punto Destino"
        oWs.Cells("C1").Value = "Fecha Registro"
        oWs.Cells("D1").Value = "Fecha Despacho"
        oWs.Cells("E1").Value = "Número de Precinto"
        oWs.Cells("F1").Value = "Fecha Entrega Transportadora"
        oWs.Cells("G1").Value = "Fecha Entrega PDV"
        oWs.Cells("H1").Value = "Estado Remisión"
        For i As Integer = 0 To 7
            With oWs.Cells(0, i).Style
                .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                .Font.Color = Color.White
                .Font.Weight = ExcelFont.BoldWeight
                .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                .HorizontalAlignment = HorizontalAlignmentStyle.Center
            End With
        Next
    End Sub

#End Region

#End Region

End Class

