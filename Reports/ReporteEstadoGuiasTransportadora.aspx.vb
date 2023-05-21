Imports System.Data
Imports System.IO
Imports GemBox.Spreadsheet
'Imports ARBusinessLayer.WsEnvia
Imports BPColSysOP.WSConsultarGuiasDeEnvia


Partial Class ReporteEstadoGuiasTransportadora
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
        lblErrorNovedades.Text = ""
        btnBuscar.Attributes.Add("onclick", "divImagen.style.display='block'")
        If Not Me.IsPostBack And Not Anthem.Manager.IsCallBack Then
            MetodosComunes.setGemBoxLicense()
            hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
            pnlResultado.Visible = False
        End If
    End Sub

    '''<sumary>
    '''Procedimiento que permite conectarse al Web Service Externo y lanzar la consulta solicitada
    '''</sumary>
    Private Sub consultarGuias()
        Dim wsConsultarGuias As New Service1
        Dim proxyAddress, credenciales(), cadenaDeBusqueda, resultString As String

        Try
            pnlResultado.Visible = False
            lbExportar.Visible = False
            cadenaDeBusqueda = getCadenaDeBusqueda()
            If cadenaDeBusqueda.Trim <> "" Then
                'proxyAddress = ConfigurationManager.AppSettings("proxyAddress")
                'credenciales = ConfigurationManager.AppSettings("WSEnviaProxyCredentials").Split("|")
                'If credenciales.Length <> 3 Then Throw New Exception("Imposible recuperar las credenciales de autenticación ante el Proxy")
                'Dim myProxy As New System.Net.WebProxy(proxyAddress)
                'Dim networkCredential As New System.Net.NetworkCredential(credenciales(0), credenciales(1), credenciales(2))
                'myProxy.Credentials = networkCredential
                'wsConsultarGuias.Proxy = myProxy
                resultString = wsConsultarGuias.BuscaGuias(cadenaDeBusqueda)
                If resultString <> "" Then
                    Dim dsResultado As New DataSet, reader As New System.IO.StringReader(resultString)
                    dsResultado.ReadXml(reader)
                    Dim dtResultado As DataTable = dsResultado.Tables("RESULTADO")
                    Dim dtGuias As DataTable = dsResultado.Tables("PRODUCCION")
                    Dim codigoResultado As Integer = CInt(dtResultado.Rows(0).Item("Indicador"))
                    Session("dtNovedades") = dsResultado.Tables("NOVEDADES")
                    If codigoResultado = 0 Or codigoResultado = 5 Then
                        If Not dtGuias Is Nothing Then
                            bindGuias(dtGuias)
                            Session("dtGuias") = dtGuias
                            lbExportar.Visible = True
                            pnlResultado.Visible = True
                        Else
                            lblError.Text = "<i>No se encontraron registros con las características solicitadas.</i><br><br>"
                        End If
                    Else
                        lblError.Text = "Ocurrió un error externo al tratar de consultar Guías. " & _
                            dtResultado.Rows(0).Item("Observacion").ToString & "<br><br>"
                    End If
                End If
            Else
                Throw New Exception("Imposible obtener la cadena de búsqueda.")
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de generar reporte. " & ex.Message & "<br><br>"
        End Try
    End Sub

    '''<sumary>
    '''Procedimiento que permite enlazar las guias obtenidas tras la consulta, al DataGrid respectivo
    '''</sumary>
    Private Sub bindGuias(ByVal dtGuias As DataTable)
        With dgGuias
            If Not Session("dtNovedades") Is Nothing Then _
                                AddHandler .ItemDataBound, AddressOf dgGuias_ItemDataBound
            .DataSource = dtGuias
            .Columns(0).FooterText = dtGuias.Rows.Count.ToString & " Guía(s) Encontrada(s)"
            .DataBind()
        End With
        MetodosComunes.mergeFooter(dgGuias)
    End Sub

    '''<sumary>
    '''Función que permite armar la cadena de búsqueda que se debe pasar como párametro 
    '''a la función BuscaGuias publicada en el Web Service de Envía.
    '''Esta función debe proporcionar como dato obligatorio las credenciales de autenticación 
    '''ante el WS
    '''</sumary>
    Private Function getCadenaDeBusqueda() As String
        Dim dsFiltros As New DataSet, dtAux As DataTable, drAux As DataRow, resultado As String
        Try
            dtAux = New DataTable("Credenciales")
            dtAux.Columns.Add("USUARIO", GetType(String))
            dtAux.Columns.Add("PASSWORD", GetType(String))
            dtAux.Rows.Add(ConfigurationManager.AppSettings("enviaUserCredentials").Split("|"))

            dsFiltros.Tables.Add(dtAux)
            If flFileUploader.Value.Trim <> "" Then
                dsFiltros.Tables.Add(getGuiasFromFile())
            ElseIf txtGuia.Text.Trim <> "" Then
                dtAux = New DataTable("GUIAS")
                dtAux.Columns.Add("Guia", GetType(String))
                drAux = dtAux.NewRow
                drAux("Guia") = txtGuia.Text.Trim
                dtAux.Rows.Add(drAux)
                dsFiltros.Tables.Add(dtAux)
            Else
                If txtCuenta.Text.Trim <> "" Then
                    Dim arrDatosCuenta() As String = txtCuenta.Text.Trim.Split("-")
                    If arrDatosCuenta.Length <> 3 Then Throw New Exception("El campo Cuenta no tiene el formato esperado.")
                    dtAux = New DataTable("CUENTAS")
                    dtAux.Columns.Add("Cod_Regional_Cta", GetType(String))
                    dtAux.Columns.Add("Cod_Oficina_Cta", GetType(String))
                    dtAux.Columns.Add("Cod_Cuenta", GetType(String))
                    drAux = dtAux.NewRow
                    drAux.Item("Cod_Regional_Cta") = arrDatosCuenta(0).Trim
                    drAux.Item("Cod_Oficina_Cta") = arrDatosCuenta(1).Trim
                    drAux.Item("Cod_Cuenta") = arrDatosCuenta(2).Trim
                    dtAux.Rows.Add(drAux)
                    dsFiltros.Tables.Add(dtAux)
                End If
                If fechaInicial.Value <> "" And fechaFinal.Value <> "" Then
                    dtAux = New DataTable("RANGO_FECHAS")
                    dtAux.Columns.Add("Fec_Inicia", GetType(String))
                    dtAux.Columns.Add("Fec_Final", GetType(String))
                    drAux = dtAux.NewRow
                    drAux.Item("Fec_Inicia") = fechaInicial.Value
                    drAux.Item("Fec_Final") = fechaFinal.Value
                    dtAux.Rows.Add(drAux)
                    dsFiltros.Tables.Add(dtAux)
                End If
            End If
            resultado = dsFiltros.GetXml
        Catch ex As Exception
            Throw New Exception("Imposible armar la cadena de búsqueda. " & ex.Message)
        End Try
        Return resultado
    End Function

    '''<sumary>
    '''Función que permite armar la cadena de búsqueda que se debe pasar como párametro 
    '''a la función BuscaGuias publicada en el Web Service de Envía.
    '''Esta función debe proporcionar como dato obligatorio las credenciales de autenticación 
    '''ante el WS
    '''</sumary>
    Private Function getGuiasFromFile() As DataTable
        Dim dtGuias As New DataTable, drGuia As DataRow, srFileManager As StreamReader
        Dim nombreArchivo As String = Server.MapPath("../archivos_planos/ConsultarGuias.txt")

        Try
            flFileUploader.PostedFile.SaveAs(nombreArchivo)
            If File.Exists(nombreArchivo) Then
                dtGuias.TableName = "GUIAS"
                dtGuias.Columns.Add("Guia", GetType(String))
                srFileManager = File.OpenText(nombreArchivo)
                While srFileManager.Peek >= 0
                    drGuia = dtGuias.NewRow
                    drGuia("Guia") = srFileManager.ReadLine().Trim
                    dtGuias.Rows.Add(drGuia)
                End While
            Else
                Throw New Exception("Imposible subir el archivo al Servidor.")
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener guías a consultar desde el archivo. " & ex.Message)
        Finally
            If Not srFileManager Is Nothing Then srFileManager.Close()
        End Try
        Return dtGuias
    End Function

    '''<sumary>
    '''Procedimiento anthem que permite cargar las Novedades asociadas a una Guía específica
    '''</sumary>
    <Anthem.Method()> _
    Public Sub getNovedades(ByVal guia As String)
        Dim dtNovedades As DataTable = CType(Session("dtNovedades"), DataTable)
        Try
            If Not dtNovedades Is Nothing Then
                Dim dwNovedades As DataView = dtNovedades.DefaultView
                dwNovedades.RowFilter = "guia='" & guia & "'"
                dwNovedades.Sort = "fec_novedad desc"
                If dwNovedades.Count > 0 Then
                    With dgNovedades
                        .DataSource = dwNovedades
                        .Columns(0).FooterText = dwNovedades.Count.ToString & " Novedad(es) Encontrada(s)"
                        .DataBind()
                        MetodosComunes.mergeFooter(dgNovedades)
                    End With
                End If
            Else
                Throw New Exception("Imposible recuperar la tabla de Novedades.")
            End If
        Catch ex As Exception
            lblErrorNovedades.Text = "Error al tratar de cargar Novedades. " & ex.Message
        End Try
    End Sub

    Private Sub btnBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        consultarGuias()
        txtGuia.Text = ""
        fechaInicial.Value = ""
        fechaFinal.Value = ""
        txtCuenta.Text = ""
    End Sub

    Private Sub dgGuias_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            Dim dtNovedades As DataTable = CType(Session("dtNovedades"), DataTable)
            If dtNovedades.Select("guia='" & e.Item.Cells(0).Text.Trim & "'").Length > 0 Then
                With CType(e.Item.Cells(14).Controls(1), HyperLink)
                    .Visible = True
                    .NavigateUrl = "javascript:void(0);"
                    .Attributes.Add("onclick", "verNovedades('" & e.Item.Cells(0).Text.Trim & "');")
                End With
            End If
        End If
    End Sub

    Private Sub dgNovedades_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgNovedades.PageIndexChanged
        With CType(source, DataGrid)
            If .Items.Count > 0 Then
                Dim guia As String = .Items(0).Cells(0).Text.Trim
                dgNovedades.CurrentPageIndex = e.NewPageIndex
                getNovedades(guia)
            End If
        End With
    End Sub

    Private Sub dgGuias_PageIndexChanged(ByVal source As System.Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgGuias.PageIndexChanged
        Try
            Dim dtGuias As DataTable = CType(Session("dtGuias"), DataTable)
            If Not dtGuias Is Nothing Then
                dgGuias.CurrentPageIndex = e.NewPageIndex
                bindGuias(dtGuias)
            Else
                Throw New Exception("Imposible recuperar la tabla que contiene la información de las Guías.")
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de cambiar página. " & ex.Message & "<br><br>"
        End Try
    End Sub

    '''<sumary>
    '''Procedimiento que permite generar el reporte actual en un archivo Excel mediante 
    '''el uso de objetos de Autmatización (COM)
    '''</sumary>
    Private Sub generarReporteEnExcel()
        Dim myExcel As ExcelFile
        Dim myWs As ExcelWorksheet
        Dim dtGuias, dtNovedades As DataTable
        Dim nombreArchivo As String = _
            Server.MapPath("../archivos_planos/ReporteEstadoGuias_" & Session("usxp001") & ".xls")
        Try
            myExcel = New ExcelFile
            myWs = myExcel.Worksheets.Add("DETALLE GUIAS")
            establecerEncabezadoHojaDeGuias(myWs)
            dtGuias = CType(Session("dtGuias"), DataTable)
            llenarDatosHojaDeGuias(myWs, dtGuias)
            With myWs
                For index As Integer = 0 To 13
                    .Columns(index).AutoFitAdvanced(1)
                Next
            End With
            '***Si existen novedades, se agrega una hoja adicional al archivo con esta información***
            If Session("dtNovedades") IsNot Nothing Then
                dtNovedades = CType(Session("dtNovedades"), DataTable)
                If dtNovedades.Rows.Count > 0 Then
                    myWs = myExcel.Worksheets.Add("DETALLE NOVEDAES")
                    establecerEncabezadoHojaDeNovedades(myWs)
                    llenarDatosHojaDeNovedades(myWs, dtNovedades)
                    With myWs
                        For index As Integer = 0 To 3
                            .Columns(index).AutoFitAdvanced(1)
                        Next
                    End With
                End If
            End If
            myExcel.SaveXls(nombreArchivo)
        Catch ex As Exception
            lblError.Text = "No fue posible generar el reporte en Excel.<br><br>"
        End Try
    End Sub

    Private Sub llenarDatosHojaDeGuias(ByVal myWs As ExcelWorksheet, ByVal dtGuias As DataTable)
        Dim filaActual As Integer = 2
        Dim auxFecha As Date
        With myWs
            For Each drGuia As DataRow In dtGuias.Rows
                .Cells("A" & filaActual.ToString).Value = drGuia("guia").ToString
                .Cells("B" & filaActual.ToString).Value = drGuia("estado_actual")
                .Cells("C" & filaActual.ToString).Value = drGuia("numero_cuenta")

                .Cells("D" & filaActual.ToString).Style.NumberFormat = "dd-mmm-yyyy"
                .Cells("D" & filaActual.ToString).Style.HorizontalAlignment = HorizontalAlignmentStyle.Center
                If Date.TryParse(drGuia("fec_produccion"), auxFecha) Then
                    .Cells("D" & filaActual.ToString).Value = auxFecha
                End If

                .Cells("E" & filaActual.ToString).Value = drGuia("ciudad_origen")
                .Cells("F" & filaActual.ToString).Value = drGuia("ciudad_destino")
                .Cells("G" & filaActual.ToString).Value = drGuia("nombre_destinatario")
                .Cells("H" & filaActual.ToString).Value = drGuia("direccion_destinatario")

                .Cells("I" & filaActual.ToString).Value = drGuia("num_unidades")
                .Cells("I" & filaActual.ToString).Style.HorizontalAlignment = HorizontalAlignmentStyle.Center

                .Cells("J" & filaActual.ToString).Value = CDbl(drGuia("valor_declarado"))
                .Cells("J" & filaActual.ToString).Style.NumberFormat = "$ #,##0.00"

                .Cells("K" & filaActual.ToString).Value = drGuia("numero_documento").ToString

                .Cells("L" & filaActual.ToString).Value = drGuia("notas")

                If Date.TryParse(drGuia("fec_entrega"), auxFecha) Then
                    .Cells("M" & filaActual.ToString).Value = auxFecha
                End If
                .Cells("M" & filaActual.ToString).Style.NumberFormat = "dd-mmm-yyyy"
                .Cells("M" & filaActual.ToString).Style.HorizontalAlignment = HorizontalAlignmentStyle.Center

                .Cells("N" & filaActual.ToString).Value = drGuia("hora")
                filaActual += 1
            Next
            .Cells("A" & filaActual.ToString).Value = dtGuias.Rows.Count.ToString & " Guía(s) Encontrada(s)"
            Dim myCellRange As CellRange = .Cells.GetSubrange("A" & filaActual.ToString, "N" & filaActual.ToString)
            With myCellRange
                .Merged = True
                With .Style
                    .FillPattern.SetSolid(ColorTranslator.FromHtml("#C0C0C0"))
                    .Font.Color = ColorTranslator.FromHtml("#000080")
                    .Font.Weight = ExcelFont.BoldWeight
                End With
            End With
        End With
    End Sub

    Private Sub llenarDatosHojaDeNovedades(ByVal myWs As ExcelWorksheet, ByVal dtNovedades As DataTable)
        Dim filaActual As Integer = 2
        Dim auxFecha As Date
        With myWs
            For Each drNovedad As DataRow In dtNovedades.Rows
                .Cells("A" & filaActual.ToString).Value = drNovedad("guia")
                .Cells("B" & filaActual.ToString).Value = drNovedad("des_novedad")

                If Date.TryParse(drNovedad("fec_novedad"), auxFecha) Then
                    .Cells("C" & filaActual.ToString).Value = auxFecha
                End If
                .Cells("C" & filaActual.ToString).Style.NumberFormat = "dd-mmm-yyyy"
                .Cells("C" & filaActual.ToString).Style.HorizontalAlignment = HorizontalAlignmentStyle.Center

                .Cells("D" & filaActual.ToString).Value = drNovedad("aclaracion")
                filaActual += 1
            Next
            .Cells("A" & filaActual.ToString).Value = dtNovedades.Rows.Count.ToString & " Novedad(es) Encontrada(s)"
            Dim myCellRange As CellRange = .Cells.GetSubrange("A" & filaActual.ToString, "D" & filaActual.ToString)
            With myCellRange
                .Merged = True
                With .Style
                    .FillPattern.SetSolid(ColorTranslator.FromHtml("#C0C0C0"))
                    .Font.Color = ColorTranslator.FromHtml("#000080")
                    .Font.Weight = ExcelFont.BoldWeight
                End With
            End With
        End With
    End Sub

    Private Sub establecerEncabezadoHojaDeGuias(ByVal oWs As ExcelWorksheet)
        With oWs.Cells
            .Item("A1").Value = "Guía"
            .Item("B1").Value = "Estado Actual"
            .Item("C1").Value = "Número de Cuenta"
            .Item("D1").Value = "Fecha de Producción"
            .Item("E1").Value = "Ciudad Origen"
            .Item("F1").Value = "Ciudad Destino"
            .Item("G1").Value = "Destinatario"
            .Item("H1").Value = "Dirección Destinatario"
            .Item("I1").Value = "Número de Unidades"
            .Item("J1").Value = "Valor Declarado"
            .Item("K1").Value = "Número de Documento"
            .Item("L1").Value = "Notas"
            .Item("M1").Value = "Fecha de Entrega"
            .Item("N1").Value = "Hora de Entrega"
        End With
        Dim myStyle As New CellStyle
        With myStyle
            .Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
            .HorizontalAlignment = HorizontalAlignmentStyle.Center
            .Font.Weight = ExcelFont.BoldWeight
            .FillPattern.SetSolid(ColorTranslator.FromHtml("#333399"))
            .Font.Color = Color.White
        End With
        oWs.Cells.GetSubrange("A1", "N1").Style = myStyle

    End Sub

    Private Sub establecerEncabezadoHojaDeNovedades(ByVal oWs As ExcelWorksheet)
        With oWs.Cells
            .Item("A1").Value = "Guía"
            .Item("B1").Value = "Descripción"
            .Item("C1").Value = "Fecha"
            .Item("D1").Value = "Aclaración"
        End With
        Dim myStyle As New CellStyle
        With myStyle
            .Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
            .HorizontalAlignment = HorizontalAlignmentStyle.Center
            .Font.Weight = ExcelFont.BoldWeight
            .FillPattern.SetSolid(ColorTranslator.FromHtml("#333399"))
            .Font.Color = Color.White
        End With
        oWs.Cells.GetSubrange("A1", "D1").Style = myStyle

    End Sub

    Private Sub lbExportar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbExportar.Click
        Dim nombreArchivo, ruta As String
        Try
            generarReporteEnExcel()
            nombreArchivo = "ReporteEstadoGuias_" & Session("usxp001") & ".xls"
            ruta = Server.MapPath("../archivos_planos/" & nombreArchivo)
            If File.Exists(ruta) Then
                Response.Clear()
                Response.ContentType = "application/octet-stream"
                Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                Response.Flush()
                Response.WriteFile(ruta)
            End If
        Catch ex As Exception
            lblError.Text = "Ha ocurrido un error inesperado. " & ex.Message & "<br><br>"
        End Try
    End Sub
End Class
