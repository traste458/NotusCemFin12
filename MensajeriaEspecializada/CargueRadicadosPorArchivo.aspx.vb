Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes
Imports System.Data.OleDb
Imports Microsoft.Office.Interop

Public Class CargueRadicadosPorArchivo
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private oExcel As ExcelFile
    Private Const UploadDirectory As String = "~\archivos_planos\"

#End Region

#Region "Propiedades"

    Public ReadOnly Property ContieneErrores() As Boolean
        Get
            If Session("dtError") Is Nothing Then
                Return False
            Else
                Return (CType(Session("dtError"), DataTable).Rows.Count > 0)
            End If
        End Get
    End Property


#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()

            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Carga masiva de radicados")
                End With
                limpiar()
            End If
            MetodosComunes.setGemBoxLicense()

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub CargarInformacion(ByVal sender As Object, ByVal e As FileUploadCompleteEventArgs)
        Try
            limpiar()
            SavePostedFile(e.UploadedFile)
            e.CallbackData = e.UploadedFile.FileName
            Dim sb As New System.Text.StringBuilder
            Dim hw As New System.Web.UI.HtmlTextWriter(New System.IO.StringWriter(sb))
            rpLogErrores.RenderControl(hw)
            CType(sender, ASPxUploadControl).JSProperties("cprpLogErrores") = sb.ToString()
        Catch ex As Exception
            miEncabezado.showError("Error al Cargar el archivo. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub GvErroresDataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        gvErrores.DataSource = Session("dtError")
    End Sub

    Protected Sub GvRadidadoscargadoDataBinding(sender As Object, e As EventArgs) Handles gvRadidadoscargado.DataBinding
        gvRadidadoscargado.DataSource = Session("dtError")
    End Sub

    Protected Sub ASPxButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ASPxButtonVerEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/ReportesCEM/Plantillas/Cargue_masivo_de_radicados.xlsx")
            If filename <> "" Then
                Dim file As System.IO.FileInfo = New System.IO.FileInfo(filename)
                If file.Exists Then
                    Response.Clear()
                    Response.AddHeader("Content-Disposition", "attachment; filename=" & file.Name)
                    Response.AddHeader("Content-Length", file.Length.ToString())
                    Response.ContentType = "application/octet-stream"
                    Response.WriteFile(file.FullName)
                    Response.End()

                Else
                    Response.Write("This file does not exist.")

                End If

            End If
            Response.Redirect("~/ReportesCEM/Plantillas/Cargue_masivo_de_radicados.xlsx", False)

        Catch ex As Exception
            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        limpiar()
    End Sub

    Protected Sub BtProcesarClick(sender As Object, e As EventArgs) Handles btProcesar.Click
        Try

            rpLogErrores.Visible = False
            rpResultado.Visible = False
            Dim retorno As Boolean
            retorno = ExtraedatosX(Session("FilePath"), Session("Extension"), "Yes")
            If (retorno = False) Then
                rpResultado.Visible = False
                rpLogErrores.Visible = True
            Else
                rpLogErrores.Visible = False
                rpResultado.Visible = True

            End If
            btProcesar.ClientEnabled = False
        Catch ex As Exception
            miEncabezado.showError("Error Al Procesar la informacion . " & ex.Message & "<br><br>")
        End Try

    End Sub

    Protected Sub btnExportar_Click(sender As Object, e As EventArgs) Handles btnExportar.Click
        gveExportador.WriteXlsxToResponse("ErroresCargueRadicados")
    End Sub

    Private Sub ExtractDataErrorHandler(ByVal sender As Object, ByVal e As ExtractDataDelegateEventArgs)
        If e.ErrorID = ExtractDataError.WrongType Then
            If e.ExcelValue Is Nothing Then
                e.DataTableValue = DBNull.Value
            Else
                e.DataTableValue = e.ExcelValue.ToString()
            End If
            e.Action = ExtractDataEventAction.Continue
        End If
    End Sub

    Protected Sub btnExportarResul_Click(sender As Object, e As EventArgs) Handles btnExportarResul.Click
        gveExportadorResultado.WriteXlsxToResponse("ResultadoCargueRadicados")
    End Sub
#End Region

#Region "Métodos Privados"

    Private Function SavePostedFile(ByVal uploadedFile As UploadedFile) As String
        Try
            Dim retorno As String
            If (Not uploadedFile.IsValid) Then
                Return String.Empty
            End If
            miEncabezado.clear()
            Session.Remove("dtError")
            Session.Remove("Extension")
            Session.Remove("FilePath")
            If ucCargueArchivoRadicados.HasFile Then
                Dim fileName As String = Path.Combine(MapPath(UploadDirectory), ucCargueArchivoRadicados.PostedFile.FileName)
                Session("Extension") = Path.GetExtension(ucCargueArchivoRadicados.PostedFile.FileName)
                Session("FilePath") = Server.MapPath(UploadDirectory) & ucCargueArchivoRadicados.FileName
                ucCargueArchivoRadicados.SaveAs(Server.MapPath(UploadDirectory) & ucCargueArchivoRadicados.FileName)
                btProcesar.ClientEnabled = True

            End If

            Return retorno
        Catch ex As Exception
            miEncabezado.showError("Error al Cargar el archivo. " & ex.Message & "<br><br>")
        End Try
    End Function

    Private Function ExtraedatosX(ByVal FilePath As String, ByVal Extension As String, ByVal isHDR As String) As Boolean
        Try
            Session.Remove("dtError")
            miEncabezado.clear()
            Dim dtInformacionGeneral As New DataTable()
            Dim dtDetalleMines As New DataTable()
            Dim dtDetalleReferencias As New DataTable()
            Dim miWs As ExcelWorksheet
            Dim miExcel As New ExcelFile
            Dim retorno As Boolean
            Dim resultado As Integer = -1
            Dim idUsuario As Integer
            Dim Numerohojas As Integer
            Dim numColumnas As Integer
            idUsuario = CInt(Session("usxp001"))
            Dim conStr As String = ""
            Try
                Select Case Extension
                    Case ".xls"
                        miExcel.LoadXls(FilePath)
                    Case ".xlsx"
                        miExcel.LoadXlsx(FilePath, XlsxOptions.None)
                        Exit Select
                    Case Else
                        Throw New ArgumentNullException("Archivo no valido")
                End Select
            Catch ex As Exception
                Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)

            End Try


            If miExcel.Worksheets.Count = 3 Then
                Dim oWsInfogenera As ExcelWorksheet = miExcel.Worksheets.Item(0)
                Dim oWsDetalleMines As ExcelWorksheet = miExcel.Worksheets.Item(1)
                Dim oWsReferenciasEquipos As ExcelWorksheet = miExcel.Worksheets.Item(2)
                dtInformacionGeneral = CrearEstructuraInfoGeneral()
                dtDetalleMines = CrearEstructuraMines()
                dtDetalleReferencias = CrearEstructuraReferenciasEquipos()
                numColumnas = oWsInfogenera.CalculateMaxUsedColumns()
                If numColumnas = 18 Then
                    Dim filaInicial As Integer = oWsInfogenera.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWsInfogenera.Cells.FirstColumnIndex

                    'Manage ExtractDataError.WrongType error
                    AddHandler oWsInfogenera.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                    oWsInfogenera.ExtractToDataTable(dtInformacionGeneral, oWsInfogenera.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                           oWsInfogenera.Rows(filaInicial + 1), oWsInfogenera.Columns(columnaInicial))

                ElseIf numColumnas > 18 Then
                    RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Información General", "0")
                Else
                    RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Información General", "0")
                End If

                numColumnas = oWsDetalleMines.CalculateMaxUsedColumns()
                If numColumnas = 9 Then
                    Dim filaInicial As Integer = oWsDetalleMines.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWsDetalleMines.Cells.FirstColumnIndex

                    'Manage ExtractDataError.WrongType error
                    AddHandler oWsDetalleMines.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                    oWsDetalleMines.ExtractToDataTable(dtDetalleMines, oWsDetalleMines.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                           oWsDetalleMines.Rows(filaInicial + 1), oWsDetalleMines.Columns(columnaInicial))

                ElseIf numColumnas > 8 Then
                    RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Detalle de Mines", "0")
                Else
                    RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Detalle de Mines", "0")
                End If
                numColumnas = oWsReferenciasEquipos.CalculateMaxUsedColumns()
                If numColumnas = 3 Then
                    Dim filaInicial As Integer = oWsReferenciasEquipos.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWsReferenciasEquipos.Cells.FirstColumnIndex

                    'Manage ExtractDataError.WrongType error
                    AddHandler oWsReferenciasEquipos.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                    oWsReferenciasEquipos.ExtractToDataTable(dtDetalleReferencias, oWsReferenciasEquipos.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                           oWsReferenciasEquipos.Rows(filaInicial + 1), oWsReferenciasEquipos.Columns(columnaInicial))

                ElseIf numColumnas > 3 Then
                    RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Detalle de Referencias Equipos", "0")
                Else
                    RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Detalle de Referencias Equipos", "0")
                End If

            ElseIf Numerohojas > 3 Then
                RegError(0, "No se puede procesar el archivo, ya que contiene más Hojas que las esperadas. Por favor verifique", "", "0")
            Else
                RegError(0, "No se puede procesar el archivo, ya que contiene menos Hojas que las esperadas. Por favor verifique", "", "0")
            End If

            If Session("dtError") Is Nothing Then
                For Each row As DataRow In dtDetalleMines.Rows

                    Select Case row("ACTIVA EQUIPO ANTERIOR (S/N) - OPCIONAL").ToString().ToUpper().Trim()
                        Case "S", "SI", "SÍ", "1"
                            row("ACTIVA EQUIPO ANTERIOR (S/N) - OPCIONAL") = "True"
                        Case "N", "NO", "0", "", " "
                            row("ACTIVA EQUIPO ANTERIOR (S/N) - OPCIONAL") = "False"
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select

                    Select Case row("COMSEGURO (S/N) - OPCIONAL").ToString().ToUpper().Trim()
                        Case "S", "SI", "SÍ", "1"
                            row("COMSEGURO (S/N) - OPCIONAL") = "True"
                        Case "N", "NO", "0", "", " "
                            row("COMSEGURO (S/N) - OPCIONAL") = "False"
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select

                Next
                For Each row As DataRow In dtInformacionGeneral.Rows
                    Select Case row("CLIENTE VIP (S/N)").ToString().ToUpper().Trim()
                        Case "S", "SI", "SÍ", "1"
                            row("CLIENTE VIP (S/N)") = "True"
                        Case "N", "NO", "0"
                            row("CLIENTE VIP (S/N)") = "False"
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select

                    Select Case row("TIPO DE TELEFONO").ToString().ToUpper().Trim()
                        Case "CELULAR"
                            row("TIPO DE TELEFONO") = "CEL"
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")

                    End Select
                    Select Case row("PRIORIDAD").ToString().ToUpper().Trim()
                        Case "ALTA"
                            row("PRIORIDAD") = "1"
                        Case "MEDIA"
                            row("PRIORIDAD") = "2"
                        Case "BAJA"
                            row("PRIORIDAD") = "3"
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select

                Next

                ValidarDetalleMines(dtDetalleMines)
                ValidarDetalleReferencias(dtDetalleReferencias)
                ValidarInformacionGeneral(dtInformacionGeneral)


            End If

            If Not Session("dtError") Is Nothing Then

                rpLogErrores.Visible = True
                With gvErrores
                    .DataSource = CType(Session("dtError"), DataTable)
                    .DataBind()
                End With
                rpLogErrores.Visible = True
                btProcesar.ClientEnabled = True
                retorno = "False"
            Else
                Dim cargeradicados As New CargueMasivoRadicados()
                Session("dtError") = cargeradicados.CargarRadicados(dtDetalleMines, dtDetalleReferencias, dtInformacionGeneral, idUsuario, resultado)
                If (resultado = 1) Then
                    lbReferencias.Text = dtDetalleReferencias.Rows.Count
                    lbMines.Text = dtDetalleMines.Rows.Count
                    lbInfogeneral.Text = dtInformacionGeneral.Rows.Count
                    With gvRadidadoscargado
                        .DataSource = CType(Session("dtError"), DataTable)
                        .DataBind()
                    End With
                    retorno = "True"
                    btProcesar.ClientEnabled = False
                    rpLogErrores.Visible = False
                    rpResultado.Visible = True
                    ' Se verifica si se debe enviar notificación de disponibilidad
                    EnviarNotificacion(CInt(Session("usxp001")))
                Else
                    rpLogErrores.Visible = True
                    With gvErrores
                        .DataSource = CType(Session("dtError"), DataTable)
                        .DataBind()
                    End With
                    rpResultado.Visible = False
                    rpLogErrores.Visible = True
                    btProcesar.ClientEnabled = True

                    retorno = "False"
                End If
            End If

            Return retorno
        Catch ex As Exception
            miEncabezado.showError("Error al procesar el archivo. " & ex.Message & "<br><br>")
        End Try
    End Function

    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        Return

    End Sub

    Private Sub ValidarDetalleMines(ByVal detalleMines As DataTable)
        Try
            If (detalleMines.Columns.Count <> 9) Then
                RegError(0, "La Hoja (Detalle de Mines) tiene que tener 9 columnas por favor verificar el archivo", "Detalle de Mines", "")
            End If
            Dim fila As Integer = 1
            For Each row As DataRow In detalleMines.Rows

                If Not (IsNumeric(row("NUMERO DE RADICADO"))) Then
                    RegError(fila, "El (Numero Radicado) tiene valores no validos por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsNumeric(row("MIN"))) Then
                    RegError(fila, "El (msisdn) tiene valores no validos por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("MIN").ToString().Trim().Length <> 10) Then
                    RegError(fila, "El tamaño del (msisdn) no es valido debe tener 10 caracteres", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                If (row("ACTIVA EQUIPO ANTERIOR (S/N) - OPCIONAL").ToString() <> "True" And row("ACTIVA EQUIPO ANTERIOR (S/N) - OPCIONAL").ToString() <> "False") Then
                    RegError(fila, "La columna (activa Equipo Anterior) tiene valores no validos por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                If (row("COMSEGURO (S/N) - OPCIONAL").ToString() <> "True" And row("COMSEGURO (S/N) - OPCIONAL").ToString() <> "False") Then
                    RegError(fila, "La columna (comSeguro) tiene valores no validos los permitidos son (S o N), por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDBNull(row("NUMERO DE RESERVA - OPCIONAL"))) Then
                    If Not (IsNumeric(row("NUMERO DE RESERVA - OPCIONAL"))) Then
                        RegError(fila, "El (Numero Reserva) tiene valores no validos por favor verificar", row("NUMERO DE RADICADO").ToString(), "Detalle de Mines")
                    End If
                End If
                If Not (IsNumeric(row("PRECIO SIN IVA"))) Then
                    RegError(fila, "El (Precio Sin IVA) tiene valores no validos por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsNumeric(row("PRECIO CON IVA"))) Then
                    RegError(fila, "El (Precio Con IVA) tiene valores no validos por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                If (IsDBNull(row("CLAUSULA"))) Then
                    RegError(fila, "la (Clausula) tiene valores no validos por favor verificar", "Detalle de Mines", row("NUMERO DE RADICADO").ToString())
                End If
                fila = fila + 1
            Next
        Catch ex As Exception
            miEncabezado.showError("Error al validar Detalle de Mines. " & ex.Message & "<br><br>")
        End Try

    End Sub

    Private Sub ValidarDetalleReferencias(ByVal detalleReferencias As DataTable)
        Try
            Dim Exp As New Comunes.ConfigValues("EXPREG_CARGUERADICADOS")
            Dim miRegExp As New System.Text.RegularExpressions.Regex(Exp.ConfigKeyValue)
            If (detalleReferencias.Columns.Count <> 3) Then
                RegError(0, "La hoja (Detalle de Referencias Equipos) tiene que tener 3 columnas por favor verificar el archivo", "Detalle de Referencias Equipos", "")
            End If
            Dim fila As Integer = 1
            For Each row As DataRow In detalleReferencias.Rows

                If Not (IsNumeric(row("NUMERO DE RADICADO"))) Then
                    RegError(fila, "El (Numero Radicado) tiene caracteres no validos por favor verificar", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (miRegExp.IsMatch(row("MATERIAL").ToString())) Then
                    RegError(fila, "El (material) tiene valores no validos por favor verificar", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
                    ' If (Convert.ToInt64(row("MATERIAL").ToString()) <= 0) Then
                    'RegError(fila, "El (material) (0) no es un material valido", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsNumeric(row("CANTIDAD"))) Then
                    RegError(fila, "La (cantidad) no es valida por favor verificar", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
                End If
                fila = fila + 1
            Next
        Catch ex As Exception
            miEncabezado.showError("Error al validar Detalle de Referencias Equipos. " & ex.Message & "<br><br>")
        End Try

    End Sub

    Private Sub ValidarInformacionGeneral(ByVal informacionGeneral As DataTable)
        Try
            Dim Exp As New Comunes.ConfigValues("EXPREG_CARGUERADICADOS")
            If (Exp.ConfigKeyValue Is Nothing) Then
                miEncabezado.showError("Por favor póngase en contacto con el área IT Development ya que hace falta el parámetro de configuración de la expresión regular <br><br>")
                RegError(0, "Por favor póngase en contacto con el área IT Development ya que hace falta el parámetro de configuración de la expresión regular ", "Información General", "")
                Exit Sub
            Else

                Dim miRegExp As New System.Text.RegularExpressions.Regex(Exp.ConfigKeyValue)
                If (informacionGeneral.Columns.Count <> 18) Then
                    RegError(0, "La hoja (Información General) tiene que tener 18 columnas por favor verificar el archivo", "Información General", "")
                End If
                Dim fila As Integer = 1
                For Each row As DataRow In informacionGeneral.Rows
                    If (IsDBNull(row("TIPO DE SERVICIO"))) Then
                        RegError(fila, "El (Tipo de Servicio) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("TIPO DE SERVICIO").ToString().Length > 50) Then
                        RegError(fila, "El (Tipo de Servicio) supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If

                    If Not (IsNumeric(row("NUMERO DE RADICADO"))) Then
                        RegError(fila, "El (Numero Radicado) tiene caracteres no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If Not (IsNumeric(row("PRIORIDAD"))) Then
                        RegError(fila, "La (PRIORIDAD) No es valida por favor verificar(ALTA,MEDIA,BAJA)", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If Not (IsDate(row("FECHA VENCIMIENTO RESERVA"))) Then
                        RegError(fila, "La columna (fecha Vencimiento Reserva) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If Not (IsDBNull(row("USUARIO EJECUTOR (OPCIONAL)"))) Then
                        If (row("USUARIO EJECUTOR (OPCIONAL)").ToString().Length > 50) Then
                            RegError(fila, "El (USUARIO EJECUTOR) Supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                        ElseIf Not (miRegExp.IsMatch(row("USUARIO EJECUTOR (OPCIONAL)").ToString())) Then
                            RegError(fila, "El (USUARIO EJECUTOR (OPCIONAL)) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If

                    End If
                    If (IsDBNull(row("NOMBRE CLIENTE"))) Then
                        RegError(fila, "La (NOMBRE CLIENTE) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("NOMBRE CLIENTE").ToString().Length > 255) Then
                        RegError(fila, "El (NOMBRE CLIENTE) supera el maximo de caracteres permitido (255)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("NOMBRE CLIENTE").ToString())) Then
                        RegError(fila, "El (NOMBRE CLIENTE) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If

                    If Not (IsDBNull(row("PERSONA AUTORIZADA (OPCIONAL)"))) Then
                        If (row("PERSONA AUTORIZADA (OPCIONAL)").ToString().Length > 155) Then
                            RegError(fila, "La (PERSONA AUTORIZADA ) Supera el maximo de caracteres permitido (155)", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If
                        If Not (miRegExp.IsMatch(row("PERSONA AUTORIZADA (OPCIONAL)").ToString())) Then
                            RegError(fila, "El nombre de la (PERSONA AUTORIZADA ) tiene caracteres no permitidos por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If
                    End If
                    If Not (IsDBNull(row("IDENTIFICACION CLIENTE (OPCIONAL)"))) Then
                        If (row("IDENTIFICACION CLIENTE (OPCIONAL)").ToString().Length > 50) Then
                            RegError(fila, "La (IDENTIFICACION CLIENTE) Supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                        ElseIf Not (miRegExp.IsMatch(row("IDENTIFICACION CLIENTE (OPCIONAL)").ToString())) Then
                            RegError(fila, "El (USUARIO EJECUTOR (OPCIONAL)) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If
                    End If
                    If (IsDBNull(row("CIUDAD"))) Then
                        RegError(fila, "La (Ciudad) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("CIUDAD").ToString().Length > 100) Then
                        RegError(fila, "la (Ciudad) supera el maximo de caracteres permitido (100)", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If Not (IsDBNull(row("BARRIO (OPCIONAL)"))) Then
                        If (row("BARRIO (OPCIONAL)").ToString().Length > 50) Then
                            RegError(fila, "La (BARRIO) Supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                        ElseIf Not (miRegExp.IsMatch(row("BARRIO (OPCIONAL)").ToString())) Then
                            RegError(fila, "El BARRIO (OPCIONAL) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If
                    End If
                    If (IsDBNull(row("DIRECCION"))) Then
                        RegError(fila, "La (Direccion) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("DIRECCION").ToString().Length > 255) Then
                        RegError(fila, "la (Direccion) supera el maximo de caracteres permitido (255)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("DIRECCION").ToString())) Then
                        RegError(fila, "La DIRECCION tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If (IsDBNull(row("TELEFONO"))) Then
                        RegError(fila, "El (Numero de Telefono) es obligatorio", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("TELEFONO").ToString().Length <> 7 And row("TELEFONO").ToString().Length <> 10) Then
                        RegError(fila, "El (Numero de Telefono) no es valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("TELEFONO").ToString())) Then
                        RegError(fila, "El TELEFONO tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If (IsDBNull(row("TIPO DE TELEFONO"))) Then
                        RegError(fila, "El (Tipo Telefono) no es valida por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("TIPO DE TELEFONO").ToString().Length > 5) Then
                        RegError(fila, "la (Tipo Telefono) supera el maximo de caracteres permitido (5)", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If Not (IsDate(row("FECHA DE ASIGNACION"))) Then
                        RegError(fila, "La columna (fecha Asignacion) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf (row("FECHA DE ASIGNACION").ToString().Length < 10) Then
                        RegError(fila, "La columna (fecha Asignacion) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If (row("CLIENTE VIP (S/N)").ToString() <> "True" And row("CLIENTE VIP (S/N)").ToString() <> "False") Then
                        RegError(fila, "La columna (cliente VIP) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                    If Not (IsDBNull(row("PLAN ACTUAL (OPCIONAL)"))) Then
                        If (row("PLAN ACTUAL (OPCIONAL)").ToString().Length > 255) Then
                            RegError(fila, "la (Plan actual) supera el maximo de caracteres permitido (255)", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If
                    End If
                    If Not (IsDBNull(row("OBSERVACIONES (OPCIONAL)"))) Then
                        If (row("OBSERVACIONES (OPCIONAL)").ToString().Length > 1024) Then
                            RegError(fila, "la (Observacion) supera el maximo de caracteres permitido (1024)", "Información General", row("NUMERO DE RADICADO").ToString())
                        ElseIf Not (miRegExp.IsMatch(row("OBSERVACIONES (OPCIONAL)"))) Then
                            RegError(fila, "La OBSERVACIONES(OPCIONAL) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                        End If

                    End If
                    fila = fila + 1
                Next
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al validar la Información General. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Private Sub RegError(ByVal linea As Integer, ByVal descripcion As String, ByVal hoja As String, Optional ByVal Radicado As String = "")
        Try
            Dim dtError As New DataTable
            If Session("dtError") Is Nothing Then
                dtError.Columns.Add(New DataColumn("lineaArchivo"))
                dtError.Columns.Add(New DataColumn("Hoja"))
                dtError.Columns.Add(New DataColumn("descripcion"))
                dtError.Columns.Add(New DataColumn("Radicado", GetType(String)))
                Session("dtError") = dtError
            Else
                dtError = Session("dtError")
            End If
            Dim dr As DataRow = dtError.NewRow()
            dr("lineaArchivo") = linea
            dr("Hoja") = hoja
            dr("Radicado") = Radicado
            dr("descripcion") = descripcion
            dtError.Rows.Add(dr)
            Session("dtError") = dtError
        Catch ex As Exception
            miEncabezado.showError("Error al registra errores . " & ex.Message & "<br><br>")
        End Try
    End Sub

    Private Sub limpiar()
        Try
            Session.Remove("dtError")
            Session.Remove("Extension")
            Session.Remove("FilePath")
            rpLogErrores.Visible = False
            rpResultado.Visible = False
        Catch ex As Exception
            miEncabezado.showError("Error Al limpiar los campos . " & ex.Message & "<br><br>")
        End Try
    End Sub

    Private Function CrearEstructuraInfoGeneral() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("TIPO DE SERVICIO", GetType(String))
            dtAux.Columns.Add("NUMERO DE RADICADO", GetType(String))
            dtAux.Columns.Add("PRIORIDAD", GetType(String))
            dtAux.Columns.Add("FECHA VENCIMIENTO RESERVA", GetType(String))
            dtAux.Columns.Add("USUARIO EJECUTOR (OPCIONAL)", GetType(String))
            dtAux.Columns.Add("NOMBRE CLIENTE", GetType(String))
            dtAux.Columns.Add("PERSONA AUTORIZADA (OPCIONAL)", GetType(String))
            dtAux.Columns.Add("IDENTIFICACION CLIENTE (OPCIONAL)", GetType(String))
            dtAux.Columns.Add("CIUDAD", GetType(String))
            dtAux.Columns.Add("DEPARTAMENTO", GetType(String))
            dtAux.Columns.Add("BARRIO (OPCIONAL)", GetType(String))
            dtAux.Columns.Add("DIRECCION", GetType(String))
            dtAux.Columns.Add("TELEFONO", GetType(String))
            dtAux.Columns.Add("TIPO DE TELEFONO", GetType(String))
            dtAux.Columns.Add("FECHA DE ASIGNACION", GetType(String))
            dtAux.Columns.Add("CLIENTE VIP (S/N)", GetType(String))
            dtAux.Columns.Add("PLAN ACTUAL (OPCIONAL)", GetType(String))
            dtAux.Columns.Add("OBSERVACIONES (OPCIONAL)", GetType(String))

        End With
        Return dtAux
    End Function

    Private Function CrearEstructuraMines() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("NUMERO DE RADICADO", GetType(String))
            dtAux.Columns.Add("MIN", GetType(String))
            dtAux.Columns.Add("ACTIVA EQUIPO ANTERIOR (S/N) - OPCIONAL", GetType(String))
            dtAux.Columns.Add("COMSEGURO (S/N) - OPCIONAL", GetType(String))
            dtAux.Columns.Add("NUMERO DE RESERVA - OPCIONAL", GetType(String))
            dtAux.Columns.Add("PRECIO SIN IVA", GetType(String))
            dtAux.Columns.Add("PRECIO CON IVA", GetType(String))
            dtAux.Columns.Add("CLAUSULA", GetType(String))
            dtAux.Columns.Add("LISTA 28 -OPCIONAL", GetType(String))

        End With
        Return dtAux
    End Function

    Private Function CrearEstructuraReferenciasEquipos() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("NUMERO DE RADICADO", GetType(String))
            dtAux.Columns.Add("MATERIAL", GetType(String))
            dtAux.Columns.Add("CANTIDAD", GetType(String))


        End With
        Return dtAux
    End Function

    Private Sub EnviarNotificacion(ByVal idUsuario As Integer)
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ObtenerDisponibilidadInventarioParaNotificacion(flagMasivo:=1, idUsuario:=idUsuario)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.RowFilter = "fechaReporteSinDisponibilidad  IS NOT NULL"
        Dim dtAux As DataTable = dvDatos.ToTable()

        If dtAux.Rows.Count > 0 Then
            Dim dtBodega As DataTable = dvDatos.ToTable(True, "idbodega")
            Dim notificador As New NotificacionEventosInventarioCEM
            Dim mensajeInicio As New ConfigValues("MENSAJE_INICIO_CEM")
            Dim mensajeFin As New ConfigValues("MENSAJE_FIN_CEM")
            Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")
            Dim usuarioRespuesta As New ConfigValues("USUARIO_RESPUESTA_CEM")
            Dim arrUsuarioRespuesta As String() = usuarioRespuesta.ConfigKeyValue.Split(",")

            For Each dr As DataRow In dtBodega.Rows
                Dim filtroBodega As Integer = CInt(dr(0))
                Dim Fila As DataRow() = dtAux.Select("idbodega=" & filtroBodega)
                Dim dvNovedad As DataView = dtAux.DefaultView
                dvNovedad.RowFilter = "idBodega = " & filtroBodega
                Dim dtNovedad As DataTable = dvNovedad.ToTable
                Dim tipoServicio As String = CStr(Fila(0).Item("tipoServicio"))
                Dim idBodega As Integer = CInt(Fila(0).Item("idbodega"))
                Dim mensaje As String
                Dim mensajeDetalle As String

                mensaje = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Radicado</td><td><b>Material</td><td><b>Referencia</td><td><b>Cantidad</td><td><b>Bodega</td></tr>"
                For Each drAux As DataRow In dtNovedad.Rows
                    mensaje += "<tr><td>" & drAux("numeroRadicado").ToString & "</td><td>" & drAux("material").ToString & "</td><td>" & drAux("descripcion").ToString & _
                    "</td><td>" & drAux("cantidad").ToString & "</td><td>" & drAux("bodega").ToString & "</td></tr>"
                Next
                mensaje += "</table>"

                mensajeDetalle = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Serial</td><td><b>Material</td><td><b>Centro</td><td><b>Almacén</td><td><b>Observaciones</td></tr>"
                mensajeDetalle += "</table>"

                With notificador
                    .TipoNotificacion = AsuntoNotificacion.Tipo.SinDisponibilidadInventario
                    .InicioMensaje = mensajeInicio.ConfigKeyValue
                    .FinMensaje = mensajeFin.ConfigKeyValue
                    .FirmaMensaje = firmaMensaje.ConfigKeyValue
                    .Titulo = "Notificación Disponibilidad de Inventario"
                    .Asunto = "Creación de radicados para " & tipoServicio & ", sin disponibilidad de Inventario"
                    .MailRespuesta = arrUsuarioRespuesta(0)
                    .UsuarioRespuesta = arrUsuarioRespuesta(1)
                    .NotificacionEvento(mensaje, mensajeDetalle, idBodega)
                End With
            Next

        End If

    End Sub

#End Region

End Class