Imports LMDataAccessLayer
Imports System.IO
Imports GemBox.Spreadsheet
Imports System.Text.RegularExpressions

Partial Public Class ConsultarGarantia
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        epNotificador.clear()
        Seguridad.verificarSession(Me)
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Consultar Información de Garantía")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            pnlResultadoUnicoSerial.Visible = False
            pnlResultadoArchivo.Visible = False
            pnlError.Visible = False
            MetodosComunes.setGemBoxLicense()
        End If

    End Sub

    Private Function ConsultarUnicoSerial(ByVal serial As String) As DataTable
        Dim dbManager As New LMDataAccess
        Dim dtInfo As DataTable
        Try
            With dbManager
                .SqlParametros.Add("@serial", SqlDbType.VarChar, 20).Value = serial
                dtInfo = dbManager.ejecutarDataTable("ConsultarInfoGarantiaUnicoSerial", CommandType.StoredProcedure)
            End With
        Finally
            If dbManager IsNot Nothing Then dbManager.Dispose()
        End Try
        Return dtInfo
    End Function

    Protected Sub btnConsultarSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnConsultarSerial.Click
        Dim dtInfo As DataTable
        pnlResultadoUnicoSerial.Visible = False
        pnlResultadoArchivo.Visible = False
        pnlError.Visible = False
        Try
            dtInfo = ConsultarUnicoSerial(txtSerial.Text.Trim)
            If dtInfo.Rows.Count > 0 Then
                With dtInfo.Rows(0)
                    lblSerial.Text = txtSerial.Text.Trim
                    lblMaterial.Text = .Item("material").ToString
                    lblReferencia.Text = .Item("referencia").ToString
                    Dim fechaAux As Date
                    Date.TryParse(.Item("fechaCargue").ToString, fechaAux)
                    lblFechaCargue.Text = fechaAux.ToString("dd/MM/yyyy")
                    lblInfoGarantia.Text = .Item("infoGarantia").ToString
                End With
                pnlResultadoUnicoSerial.Visible = True
            Else
                epNotificador.showWarning("No se encontró información asociada al serial: " & txtSerial.Text & ". Por favor verifique")
            End If
            txtSerial.Text = ""
        Catch ex As Exception
            epNotificador.showError("Error al tratar de consultar información. " & ex.Message)
        Finally
            If dtInfo IsNot Nothing Then dtInfo.Dispose()
        End Try
    End Sub

    Private Function ConsultarListadoDeSeriales(ByVal arrSerial As ArrayList) As DataTable
        Dim dbManager As New LMDataAccess
        Dim arrAux As New ArrayList
        Dim dtInfo As New DataTable

        Try
            With dbManager
                .SqlParametros.Add("@listadoSerial", SqlDbType.VarChar, 8000)
                For index As Integer = 0 To arrSerial.Count - 1
                    arrAux.Add(arrSerial(index))
                    If (arrAux.Count = 150) Or (arrAux.Count > 0 And (index = arrSerial.Count - 1)) Then
                        .SqlParametros("@listadoSerial").Value = Join(arrAux.ToArray, ",")
                        .llenarDataTable(dtInfo, "ConsultarInfoGarantiaMultiplesSeriales", CommandType.StoredProcedure)
                        arrAux.Clear()
                    End If
                Next
            End With
        Finally
            If dbManager IsNot Nothing Then dbManager.Dispose()
        End Try
        Return dtInfo
    End Function

    Private Function ObtenerSerialesDesdeArchivo(ByVal dtError As DataTable) As ArrayList
        Dim ruta As String = Server.MapPath("~/archivos_planos/ConsultaGarantia" & Session("usxp001") & ".txt")
        Dim fileReader As StreamReader = Nothing
        Dim arrSerial As New ArrayList
        Dim registro As String
        Try
            fuManager.PostedFile.SaveAs(ruta)
            If File.Exists(ruta) Then
                fileReader = File.OpenText(ruta)
                Dim patronRegex As String = "^" & MetodosComunes.seleccionarConfigValue("REGEX_LONGITUD_SERIALES") & "$"
                Dim oRegEx As New Regex(patronRegex)
                Dim numLinea As Integer = 1
                While fileReader.Peek > -1
                    registro = fileReader.ReadLine.Trim
                    If oRegEx.IsMatch(registro) Then
                        arrSerial.Add(registro)
                    Else
                        AdicionarRegistroErroneo(dtError, numLinea, "El serial: " & registro & " no es válido")
                    End If
                    numLinea += 1
                End While
            Else
                Throw New Exception("No se encontró el archivo en el servidor. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            Throw New Exception("Imposible leer datos de archivo. " & ex.Message)
        Finally
            If fileReader IsNot Nothing Then fileReader.Close()
        End Try
        Return arrSerial
    End Function

    Protected Sub btnConsultarArchivo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnConsultarArchivo.Click
        Dim arrSerial As New ArrayList
        Dim dtInfo As New DataTable
        Dim dtError As DataTable = GenerarEstructuraDeTablaError()

        pnlResultadoUnicoSerial.Visible = False
        pnlResultadoArchivo.Visible = False
        pnlError.Visible = False
        Try
            arrSerial = ObtenerSerialesDesdeArchivo(dtError)
            If dtError.Rows.Count = 0 Then
                If arrSerial.Count > 0 Then
                    dtInfo = ConsultarListadoDeSeriales(arrSerial)
                    Session("dtInfoGarantia") = dtInfo
                    EnlazarResultado(dtInfo)
                    pnlResultadoArchivo.Visible = True
                Else
                    epNotificador.showWarning("El archivo proporcionado no contenía seriales válidos. Por favor verifique")
                End If
            Else
                epNotificador.showWarning("El archivo especificado contiene registros no válidos para consulta. Por favor verifique el log de registros erróneos")
                Session("dtListaErrores") = dtError
                EnlazarErrores(dtError)
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de consultar información. " & ex.Message)
        Finally
            If dtInfo IsNot Nothing Then dtInfo.Dispose()
            If arrSerial IsNot Nothing Then arrSerial.Clear()
        End Try
    End Sub

    Private Sub EnlazarResultado(ByVal dtDatos As DataTable)
        With gvResultado
            .DataSource = dtDatos
            If dtDatos.Rows.Count > 0 Then
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Consultado(s)"
            End If
            .DataBind()
        End With
        MetodosComunes.mergeGridViewFooter(gvResultado)
    End Sub

    Private Sub gvResultado_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvResultado.PageIndexChanging
        If Session("dtInfoGarantia") IsNot Nothing Then
            Dim dtInfo As DataTable = CType(Session("dtInfoGarantia"), DataTable)
            Try
                gvResultado.PageIndex = e.NewPageIndex
                EnlazarResultado(dtInfo)
            Catch ex As Exception
                epNotificador.showError("Error al tratar de cambiar página. " & ex.Message)
            End Try
        Else
            epNotificador.showWarning("imposible recuperar los datos desde la memoria. Por favor consulte nuevamente")
        End If
    End Sub

    Private Sub GuardarResultadoEnArchivo(ByVal dtInfo As DataTable, ByVal titulo As String, ByVal ruta As String)
        Dim miExcel As New ExcelFile
        Dim miWs As ExcelWorksheet
        miWs = miExcel.Worksheets.Add("Info. Garantia")
        Dim myStyle As New CellStyle
        With myStyle
            .Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
            .HorizontalAlignment = HorizontalAlignmentStyle.Center
            .Font.Weight = ExcelFont.BoldWeight
            .FillPattern.SetSolid(ColorTranslator.FromHtml("#333399"))
            .Font.Color = Color.White
        End With
        With miWs
            .Cells("A1").Value = titulo
            .Cells("A1").Style.Font.Weight = ExcelFont.BoldWeight
            .Cells("A1").Style.Font.Size = 20 * 14
            .Cells.GetSubrange("A1", "E1").Merged = True
            Dim fila As Integer = 4
            .Cells("A3").Value = "SERIAL"
            .Cells("B3").Value = "MATERIAL"
            .Cells("C3").Value = "REFERENCIA"
            .Cells("D3").Value = "FECHA DE CARGUE"
            .Cells("E3").Value = "INFO. GARANTÍA"
            .Cells.GetSubrange("A3", "E3").Style = myStyle
            Dim fechaAux As Date
            For Each drDato As DataRow In dtInfo.Rows
                With .Cells("A" & fila)
                    .Value = drDato("serial").ToString
                    .Style.Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                End With
                With .Cells("B" & fila)
                    .Value = drDato("material")
                    .Style.Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                    .Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With
                With .Cells("C" & fila)
                    .Value = drDato("referencia")
                    .Style.Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                End With
                With .Cells("D" & fila)
                    If Not IsDBNull(drDato("fechaCargue")) Then .Value = CDate(drDato("fechaCargue")).ToString("dd/MM/yyyy")
                    .Style.Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                    .Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With
                With .Cells("E" & fila)
                    .Value = drDato("infoGarantia").ToString
                    .Style.Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                End With
                fila += 1
            Next
            With myStyle
                .FillPattern.SetSolid(ColorTranslator.FromHtml("#C0C0C0"))
                .Font.Color = ColorTranslator.FromHtml("#000080")
            End With

            For index As Integer = 0 To 4
                .Columns(index).AutoFitAdvanced(1)
            Next
        End With
        miExcel.SaveXls(ruta)
    End Sub

    Protected Sub lbExportar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbExportar.Click
        If Session("dtInfoGarantia") IsNot Nothing Then
            Dim ruta As String = Server.MapPath("~/archivos_planos/ResultadoConsultaGarantiaDeSerial" & Session("usxp001") & ".xls")
            Dim dtInfo As DataTable = CType(Session("dtInfoGarantia"), DataTable)
            Try

                GuardarResultadoEnArchivo(dtInfo, "Información de Garantía de Seriales", ruta)
                If File.Exists(ruta) Then
                    MetodosComunes.forzarDescargaDeArchivo(HttpContext.Current, ruta)
                Else
                    Throw New Exception("Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente")
                End If
            Catch ex As Exception
                epNotificador.showError("Error al tratar de exportar resultado. " & ex.Message)
            End Try
        Else
            epNotificador.showWarning("Imposible recuperar los datos desde la Memoria. Por favor genere el resultado nuevamente")
        End If
    End Sub

    Private Sub EnlazarErrores(ByVal dtError As DataTable)
        With gvErrores
            .DataSource = dtError
            If dtError.Rows.Count > 0 Then .Columns(0).FooterText = dtError.Rows.Count.ToString & " Registro(s) Erróneo(s)"
            .DataBind()
        End With
        MetodosComunes.mergeGridViewFooter(gvErrores)
        pnlError.Visible = True
    End Sub

    Private Sub gvErrores_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvErrores.PageIndexChanging
        If Session("dtListaErrores") IsNot Nothing Then
            Dim dtError As DataTable = CType(Session("dtListaErrores"), DataTable)
            Try
                gvErrores.PageIndex = e.NewPageIndex
                EnlazarErrores(dtError)
            Catch ex As Exception
                epNotificador.showError("Error al tratar de cambiar página. " & ex.Message)
            End Try
        Else
            epNotificador.showWarning("imposible recuperar los datos desde la memoria. Por favor consulte nuevamente")
        End If
    End Sub

    Private Sub AdicionarRegistroErroneo(ByVal dtError As DataTable, ByVal linea As Integer, ByVal mensajeError As String)
        Dim drAux As DataRow
        drAux = dtError.NewRow
        drAux("linea") = linea
        drAux("descripcion") = mensajeError
        dtError.Rows.Add(drAux)
    End Sub

    Private Function GenerarEstructuraDeTablaError() As DataTable
        Dim dtAux As New DataTable
        With dtAux
            .Columns.Add("linea", GetType(Integer))
            .Columns.Add("descripcion", GetType(String))
        End With
        Return dtAux
    End Function
End Class