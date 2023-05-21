Imports GemBox.Spreadsheet
Imports LMDataAccessLayer

Partial Public Class ReporteSolicitadoRecogido
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Server.ScriptTimeout = 2000
            Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
            lblError.Text = ""
            If Not Me.IsPostBack And Not Anthem.Manager.IsCallBack Then
                MetodosComunes.setGemBoxLicense()
                hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
                getCiudades()
                getCadenas(0)
                getPOS(0, "")
                fechaInicial.Value = Now.AddDays(-(Now.Day - 1)).ToShortDateString
                fechaFinal.Value = Now.ToShortDateString
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de cargar página. " & ex.Message & "<br><br>"
        End Try
    End Sub

    Private Sub getCiudades()
        Dim consulta As New LMDataAccess
        Dim dtCiudades As New DataTable, sqlSelect As String
        ' se encuentra la información de la ciudad
        sqlSelect = " select idciudad, ciudad from ciudades c with(nolock) where exists (select idpos from pos"
        sqlSelect += " with(nolock) where idciudad=c.idciudad) order by ciudad"
        Try
            dtCiudades = consulta.ejecutarDataTable(sqlSelect, CommandType.Text)
            With ddlCiudad
                .DataSource = dtCiudades
                .DataTextField = "ciudad"
                .DataValueField = "idciudad"
                .DataBind()
                .Items.Insert(0, New ListItem("Escoja una Ciudad", "0"))
            End With
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener Ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub getCadenas(ByVal idCiudad As Integer)
        Dim consulta As New LMDataAccess
        Dim dtCadenas As New DataTable, sqlSelect As String
        sqlSelect = "select distinct cadena from pos with(nolock) where idestado = 1 and cadena is not null "
        If idCiudad <> 0 Then
            If idCiudad <> 0 Then consulta.agregarParametroSQL("@idCiudad", idCiudad, SqlDbType.Int)
            sqlSelect += " and idCiudad = @idCiudad "
        End If
        sqlSelect += " order by cadena"

        Try


            ' se encuentra la información de la cadena pero si se selecciona una ciudad se filtra por ella
            dtCadenas = consulta.ejecutarDataTable(sqlSelect, CommandType.Text)
            With ddlCadena
                .DataSource = dtCadenas
                .DataTextField = "cadena"
                .DataValueField = "cadena"
                .DataBind()
                .Items.Insert(0, New ListItem("Escoja una Cadena", "0"))
            End With
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener Cadenas. " & ex.Message)
        End Try

    End Sub

    Private Sub getPOS(ByVal idCiudad As Integer, ByVal cadena As String)
        Dim consulta As New LMDataAccess
        Dim dtPos As New DataTable, sqlSelect As String

        sqlSelect = "select idpos,pos+' ('+idpos2+')' as pos from pos with(nolock) where idestado = 1 and cadena is not null "
        If idCiudad <> 0 Then
            sqlSelect += " and idciudad = @idCiudad "
            consulta.agregarParametroSQL("@idCiudad", idCiudad, SqlDbType.Int)
        End If
        If cadena <> "" And cadena <> "0" Then
            sqlSelect += " and cadena = @cadena "
            consulta.agregarParametroSQL("@cadena", cadena, SqlDbType.VarChar)
        End If
        sqlSelect += " order by pos"

        Try
            ' se encuentra la información del POS pero se se a seleccionado ciudad o 
            ' cadenas se filtra por la selección
            dtPos = consulta.ejecutarDataTable(sqlSelect, CommandType.Text)
            With ddlPOS
                .DataSource = dtPos
                .DataTextField = "pos"
                .DataValueField = "idpos"
                .DataBind()
                .Items.Insert(0, New ListItem("Escoja un POS", "0"))
            End With
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener POS. " & ex.Message)

        End Try
    End Sub

    Private Sub ddlCiudad_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlCiudad.SelectedIndexChanged
        Try
            getCadenas(ddlCiudad.SelectedValue)
            getPOS(ddlCiudad.SelectedValue, ddlCadena.SelectedValue)
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try

    End Sub

    Private Sub ddlCadena_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlCadena.SelectedIndexChanged

        Try
            getPOS(ddlCiudad.SelectedValue, ddlCadena.SelectedValue)
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try

    End Sub


    Protected Sub btnContinuar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinuar.Click
        Dim sentencia, condicion As String, dtDatos As DataTable, consulta As New LMDataAccess, dsReporte As New DataSet
        Try
            condicion = ""
            sentencia = "SELECT idOrden as 'ID Orden',Objeto as 'Objeto de Recolección',pos as 'Punto de Venta',guiaTransportadora as 'Guía Transportadora',fechaCreacion as 'Fecha Creación',fechaRecoleccion as 'Fecha Recolección Transportadora',fechaRecepcionLM as 'Fecha Recepción Bodega',Estado "
            sentencia += " FROM  VI_SolicitudOrdenRecoleccion "
            If ddlPOS.SelectedValue <> 0 Then
                condicion = " where idPos = @idPos"
                consulta.agregarParametroSQL("@idPos", ddlPOS.SelectedValue, SqlDbType.BigInt)
            ElseIf ddlCadena.SelectedValue <> "0" Then
                condicion = " where idPos in (select idPos from pos with(nolock) where cadena = @cadena)"
                consulta.agregarParametroSQL("@cadena", ddlCadena.SelectedValue, SqlDbType.VarChar)
            ElseIf ddlCiudad.SelectedValue <> 0 Then
                condicion = " where idPos in(select idPos from pos with(nolock) where idCiudad = @idciudad)"
                consulta.agregarParametroSQL("@idciudad", ddlCiudad.SelectedValue, SqlDbType.Int)
            End If
            If fechaInicial.Value <> "" And fechaFinal.Value <> "" Then
                If condicion = "" Then
                    condicion = " where "
                Else
                    condicion += " and "
                End If
                condicion += String.Format(" convert(varchar,{0},112) between @fechaInicial and @fechaFinal", IIf(rblTipoFecha.SelectedValue = 1, "fechaCreacion", "fechaRecoleccion"))
                consulta.agregarParametroSQL("@fechaInicial", String.Format("{0:yyyyMMdd}", CDate(fechaInicial.Value)), SqlDbType.VarChar)
                consulta.agregarParametroSQL("@fechaFinal", String.Format("{0:yyyyMMdd}", CDate(fechaFinal.Value)), SqlDbType.VarChar)
            End If
            sentencia += condicion & " ORDER BY idOrden "
            dtDatos = consulta.ejecutarDataTable(sentencia, CommandType.Text)
            dsReporte.Tables.Add(dtDatos)
            sentencia = "select idOrden as 'ID Orden',Objeto as 'Objeto de Recolección',pos as 'Punto de Venta',guiaTransportadora as 'Guía Transportadora',fechaCreacion as 'Fecha Creación',fechaRecoleccion as 'Fecha Recolección Transportadora',fechaRecepcionLM as 'Fecha Recepción Bodega',Estado,serial as Seriales,causa as 'Causa Recolección',devolucion as 'No Devolución'"
            sentencia += "from VI_RecogidoOrdenRecoleccion "
            sentencia += condicion & " ORDER BY idOrden,serial "
            dtDatos = consulta.ejecutarDataTable(sentencia, CommandType.Text)
            dsReporte.Tables.Add(dtDatos)

            dsReporte.Tables(0).TableName = "RECOLECCIONES SOLICITADAS"
            dsReporte.Tables(1).TableName = "RECOGIDO POR TRANSPORTADORA"
            If dsReporte.Tables(0).Rows.Count > 0 Or dsReporte.Tables(1).Rows.Count > 0 Then
                Session.Add("dsReporte", dsReporte)
                lblRes.Visible = True
                lbnDescargar.Visible = True
            Else
                lblError.Text = "No existen órdenes de recolección con los criterios seleccionados"
                lblRes.Visible = False
                lbnDescargar.Visible = False
            End If


        Catch ex As Exception
            lblError.Text = "Error al generar el reporte: " & ex.Message
        End Try
    End Sub

    Protected Sub lbnDescargar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbnDescargar.Click
        Dim dsReporte As DataSet, nombreArchivo, ruta As String
        Try
            nombreArchivo = "ReporteRemisionesTransportadora" & Session("usxp001") & ".xls"
            ruta = Server.MapPath("../Archivos_Planos")
            dsReporte = CType(Session("dsReporte"), DataSet)
            exportarDatosAExcelGemBox(HttpContext.Current, dsReporte, nombreArchivo, ruta)
        Catch ex As Exception
            lblError.Text = ex.Message
        End Try
    End Sub

    Sub exportarDatosAExcelGemBox(ByVal contextHttp As HttpContext, ByVal dsDatos As DataSet, ByVal nombreArchivo As String, ByVal ruta As String)
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet
        Try
            For Each tabla As DataTable In dsDatos.Tables
                If tabla.Rows.Count > 0 Then
                    ws = ef.Worksheets.Add(tabla.TableName)
                    ws.InsertDataTable(tabla, "A3", True)
                    ws.Cells.GetSubrangeAbsolute(0, 0, 0, tabla.Columns.Count - 1).Merged = True
                    With ws.Cells("A1")
                        .Value = tabla.TableName
                        With .Style
                            .Font.Color = Color.Black
                            .Font.Weight = ExcelFont.BoldWeight
                            .Font.Size = 14 * 16
                        End With
                    End With
                    ws.Columns(0).AutoFitAdvanced(1)

                    For i As Integer = 0 To tabla.Columns.Count - 1
                        With ws.Cells(2, i).Style
                            .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                            .Font.Color = Color.White
                            .Font.Weight = ExcelFont.BoldWeight
                            .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                            .HorizontalAlignment = HorizontalAlignmentStyle.Center
                        End With
                    Next
                    estiloColumnaGemBox(ws, "dd/mm/yyyy hh:mm:ss AM/PM", tabla.Rows.Count, "E")
                    estiloColumnaGemBox(ws, "dd/mm/yyyy hh:mm:ss AM/PM", tabla.Rows.Count, "F")
                    estiloColumnaGemBox(ws, "dd/mm/yyyy hh:mm:ss AM/PM", tabla.Rows.Count, "G")
                    ws.Cells.GetSubrangeAbsolute(tabla.Rows.Count + 3, 0, (tabla.Rows.Count + 3), tabla.Columns.Count - 1).Merged = True


                    With ws.Cells("A" & (tabla.Rows.Count + 4).ToString).Style
                        .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                        .Font.Color = Color.DarkBlue
                        .Font.Weight = ExcelFont.BoldWeight
                        .Borders.SetBorders(MultipleBorders.Outside, Color.FromName("black"), LineStyle.Thin)
                        .HorizontalAlignment = HorizontalAlignmentStyle.Center
                    End With
                    ws.Cells("A" & (tabla.Rows.Count + 4).ToString).Value = tabla.Rows.Count & " Registro(s) Encontrado(s)"
                    For index As Integer = 0 To tabla.Columns.Count - 1
                        ws.Columns(index).AutoFitAdvanced(1)
                    Next
                End If
            Next
            ruta += "/" & nombreArchivo
            ef.SaveXls(ruta)
            With contextHttp
                .Response.Clear()
                .Response.ContentType = "application/octet-stream"
                .Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                .Response.Flush()
                .Response.WriteFile(ruta)
            End With

        Catch ex As Exception
            Throw New Exception("Al tratar de exportar a Excel: " & ex.Message & ex.StackTrace)
        End Try
    End Sub
    Sub estiloColumnaGemBox(ByRef ws As ExcelWorksheet, ByVal formatoCelda As String, ByVal numeroFilas As Integer, ByVal columna As String)
        Dim elEstilo As New CellStyle
        For Each celda As ExcelCell In ws.Cells.GetSubrange(columna & "3", columna & (numeroFilas + 3).ToString)
            With celda.Style
                .NumberFormat = formatoCelda
            End With
        Next

    End Sub
End Class

