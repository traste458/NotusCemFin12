Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes
Imports System.Data.OleDb
Imports Microsoft.Office.Interop

Public Class CargueServiciosVentaWebPorArchivo
    Inherits System.Web.UI.Page

#Region "Constantes"

    Public Const NumHojas As Short = 2
    Public Const NumColInfoGeneral As Short = 16
    Public Const NumColReferencias As Short = 3

#End Region

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
                    .setTitle("Carga Masiva de Servicios tipo Venta Web")
                End With
                Limpiar()
            End If
            MetodosComunes.setGemBoxLicense()

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub CargarInformacion(ByVal sender As Object, ByVal e As FileUploadCompleteEventArgs)
        Try
            Limpiar()
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

    Protected Sub btnEjemplo_Click(sender As Object, e As EventArgs) Handles btnEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/ReportesCEM/Plantillas/Ejemplo_Cargue_Masivo_de_Servicios_Ventas_WEB.xlsx")
            If filename <> "" Then
                Dim file As FileInfo = New FileInfo(Server.MapPath(filename))
                If file.Exists Then
                    Response.Clear()
                    Response.AddHeader("Content-Disposition", "attachment; filename=" & file.Name)
                    Response.AddHeader("Content-Length", file.Length.ToString())
                    Response.ContentType = "application/octet-stream"
                    Response.WriteFile(file.FullName)
                    Response.Flush()
                Else
                    Response.Write("This file does not exist.")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Limpiar()
    End Sub

    Protected Sub BtProcesarClick(sender As Object, e As EventArgs) Handles btProcesar.Click
        Try
            rpLogErrores.Visible = False
            rpResultado.Visible = False
            Dim retorno As Boolean = ExtraeDatos(Session("FilePath"), Session("Extension"), True)
            If (Not retorno) Then
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

    Private Function ExtraeDatos(ByVal FilePath As String, ByVal Extension As String, ByVal isHDR As Boolean) As Boolean
        Dim retorno As Boolean
        Dim idUsuario As Integer
        Try
            Session.Remove("dtError")
            Integer.TryParse(Session("usxp001"), idUsuario)

            Dim dtInformacionGeneral As New DataTable()
            Dim dtDetalleReferencias As New DataTable()
            Dim miExcel As New ExcelFile
            Dim resultado As Integer = -1

            Dim numColumnas As Integer
            Try
                Select Case Extension
                    Case ".xls"
                        miExcel.LoadXls(FilePath)
                    Case ".xlsx"
                        miExcel.LoadXlsx(FilePath, XlsxOptions.None)
                    Case Else
                        Throw New Exception("El archivo con extensión: " & Extension & " no es válido.")
                End Select
            Catch ex As Exception
                Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)
            End Try

            If miExcel.Worksheets.Count = NumHojas Then
                Dim oWsInfoGeneral As ExcelWorksheet = miExcel.Worksheets.Item(0)
                Dim oWsReferenciasEquipos As ExcelWorksheet = miExcel.Worksheets.Item(1)

                dtInformacionGeneral = CrearEstructuraInfoGeneral()
                dtDetalleReferencias = CrearEstructuraReferenciasEquipos()

                numColumnas = oWsInfoGeneral.CalculateMaxUsedColumns()
                If numColumnas = NumColInfoGeneral Then
                    Dim filaInicial As Integer = oWsInfoGeneral.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWsInfoGeneral.Cells.FirstColumnIndex

                    AddHandler oWsInfoGeneral.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                    oWsInfoGeneral.ExtractToDataTable(dtInformacionGeneral, oWsInfoGeneral.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                           oWsInfoGeneral.Rows(filaInicial + 1), oWsInfoGeneral.Columns(columnaInicial))

                ElseIf numColumnas > NumColInfoGeneral Then
                    RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Información General", "0")
                Else
                    RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Información General", "0")
                End If

                numColumnas = oWsReferenciasEquipos.CalculateMaxUsedColumns()
                If numColumnas = NumColReferencias Then
                    Dim filaInicial As Integer = oWsReferenciasEquipos.Cells.FirstRowIndex
                    Dim columnaInicial As Integer = oWsReferenciasEquipos.Cells.FirstColumnIndex

                    AddHandler oWsReferenciasEquipos.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                    oWsReferenciasEquipos.ExtractToDataTable(dtDetalleReferencias, oWsReferenciasEquipos.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                           oWsReferenciasEquipos.Rows(filaInicial + 1), oWsReferenciasEquipos.Columns(columnaInicial))

                ElseIf numColumnas > NumColReferencias Then
                    RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Detalle de Referencias Equipos", "0")
                Else
                    RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Detalle de Referencias Equipos", "0")
                End If

            ElseIf miExcel.Worksheets.Count > NumHojas Then
                RegError(0, "No se puede procesar el archivo, ya que contiene más Hojas que las esperadas. Por favor verifique", "", "0")
            Else
                RegError(0, "No se puede procesar el archivo, ya que contiene menos Hojas que las esperadas. Por favor verifique", "", "0")
            End If

            If Session("dtError") Is Nothing Then
                For Each row As DataRow In dtInformacionGeneral.Rows
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
                retorno = False
            Else
                Dim cargueRadicados As New CargueMasivoVentasWeb(dtDetalleReferencias, dtInformacionGeneral)
                Dim respuesta As ResultadoProceso = cargueRadicados.Cargar(idUsuario)
                Session("dtError") = cargueRadicados.DatosResultado

                If (respuesta.Valor = 0) Then
                    lbReferencias.Text = dtDetalleReferencias.Rows.Count
                    lbInfogeneral.Text = dtInformacionGeneral.Rows.Count
                    With gvRadidadoscargado
                        .DataSource = CType(Session("dtError"), DataTable)
                        .DataBind()
                    End With
                    retorno = True
                    btProcesar.ClientEnabled = False
                    rpLogErrores.Visible = False
                    rpResultado.Visible = True
                Else
                    rpLogErrores.Visible = True
                    With gvErrores
                        .DataSource = CType(Session("dtError"), DataTable)
                        .DataBind()
                    End With
                    rpResultado.Visible = False
                    rpLogErrores.Visible = True
                    btProcesar.ClientEnabled = True

                    retorno = False
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

    Private Sub ValidarDetalleReferencias(ByVal detalleReferencias As DataTable)
        Dim fila As Integer = 1
        Try
            If (detalleReferencias.Columns.Count <> 3) Then
                RegError(0, "La hoja (Detalle de Referencias Equipos) tiene que tener 3 columnas por favor verificar el archivo", "Detalle de Referencias Equipos", "")
            End If

            For Each row As DataRow In detalleReferencias.Rows

                If Not (IsNumeric(row("NUMERO DE RADICADO"))) Then
                    RegError(fila, "El (Numero Radicado) tiene caracteres no validos por favor verificar", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsNumeric(row("MATERIAL"))) Then
                    RegError(fila, "El (material) tiene valores no validos por favor verificar", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
                ElseIf (Convert.ToInt64(row("MATERIAL").ToString()) <= 0) Then
                    RegError(fila, "El (material) (0) no es un material valido", "Detalle de Referencias Equipos", row("NUMERO DE RADICADO").ToString())
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
        Dim fila As Integer = 1
        Try
            Dim Exp As New Comunes.ConfigValues("EXPREG_CARGUERADICADOS")
            If (Exp.ConfigKeyValue Is Nothing) Then
                miEncabezado.showError("Por favor póngase en contacto con el área IT Development ya que hace falta el parámetro de configuración de la expresión regular <br><br>")
                RegError(0, "Por favor póngase en contacto con el área IT Development ya que hace falta el parámetro de configuración de la expresión regular ", "Información General", "")
                Exit Sub
            End If
            Dim miRegExp As New System.Text.RegularExpressions.Regex(Exp.ConfigKeyValue)
            If (informacionGeneral.Columns.Count <> NumColInfoGeneral) Then
                RegError(0, "La hoja (Información General) tiene que tener " & NumColInfoGeneral.ToString() & "columnas por favor verificar el archivo", "Información General", "")
            End If

            For Each row As DataRow In informacionGeneral.Rows
                If (IsDBNull(row("TIPO DE SERVICIO"))) Then
                    RegError(fila, "El (Tipo de Servicio) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("TIPO DE SERVICIO").ToString().Length > 50) Then
                    RegError(fila, "El (Tipo de Servicio) supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                End If

                If Not (IsNumeric(row("NUMERO DE RADICADO"))) Then
                    RegError(fila, "El (Número Radicado) tiene caracteres no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsNumeric(row("PRIORIDAD"))) Then
                    RegError(fila, "La (PRIORIDAD) No es valida por favor verificar(ALTA,MEDIA,BAJA)", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDate(row("FECHA MAXIMA ENTREGA"))) Then
                    RegError(fila, "La columna (fecha máxima entrega) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDBNull(row("CADENA"))) Then
                    If (row("CADENA").ToString().Length > 50) Then
                        RegError(fila, "La (CADENA) Supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("CADENA").ToString())) Then
                        RegError(fila, "La (CADENA) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                End If
                If (IsDBNull(row("NOMBRE CLIENTE"))) Then
                    RegError(fila, "La (NOMBRE CLIENTE) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("NOMBRE CLIENTE").ToString().Length > 255) Then
                    RegError(fila, "El (NOMBRE CLIENTE) supera el maximo de caracteres permitido (255)", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf Not (miRegExp.IsMatch(row("NOMBRE CLIENTE").ToString())) Then
                    RegError(fila, "EL (NOMBRE CLIENTE) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDBNull(row("PERSONA AUTORIZADA"))) Then
                    If (row("PERSONA AUTORIZADA").ToString().Length > 155) Then
                        RegError(fila, "La (PERSONA AUTORIZADA ) Supera el maximo de caracteres permitido (155)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("PERSONA AUTORIZADA").ToString())) Then
                        RegError(fila, "La (PERSONA AUTORIZADA) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                End If
                If Not (IsDBNull(row("IDENTIFICACION"))) Then
                    If (row("IDENTIFICACION").ToString().Length > 50) Then
                        RegError(fila, "La (IDENTIFICACION) Supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("IDENTIFICACION").ToString())) Then
                        RegError(fila, "La (IDENTIFICACION) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                End If
                If (IsDBNull(row("CIUDAD"))) Then
                    RegError(fila, "La (Ciudad) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("CIUDAD").ToString().Length > 100) Then
                    RegError(fila, "la (Ciudad) supera el maximo de caracteres permitido (100)", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If (IsDBNull(row("DEPARTAMENTO"))) Then
                    RegError(fila, "El (Departamento) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("DEPARTAMENTO").ToString().Length > 100) Then
                    RegError(fila, "El (Departamento) supera el maximo de caracteres permitido (100)", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDBNull(row("BARRIO"))) Then
                    If (row("BARRIO").ToString().Length > 50) Then
                        RegError(fila, "La (BARRIO) Supera el maximo de caracteres permitido (50)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("BARRIO").ToString())) Then
                        RegError(fila, "EL (BARRIO) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("BARRIO").ToString())) Then
                        RegError(fila, "EL (BARRIO) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                End If
                If (IsDBNull(row("DIRECCION"))) Then
                    RegError(fila, "La (Direccion) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("DIRECCION").ToString().Length > 255) Then
                    RegError(fila, "la (Direccion) supera el maximo de caracteres permitido (255)", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf Not (miRegExp.IsMatch(row("DIRECCION").ToString())) Then
                    RegError(fila, "La (DIRECCION) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                End If

                If (IsDBNull(row("TELEFONO"))) Then
                    RegError(fila, "El (Numero de Telefono) es obligatorio", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("TELEFONO").ToString().Length <> 7 And row("TELEFONO").ToString().Length <> 10) Then
                    RegError(fila, "El (Numero de Telefono) no es valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If (IsDBNull(row("TIPO DE TELEFONO"))) Then
                    RegError(fila, "El (Tipo Telefono) no es valida por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                ElseIf (row("TIPO DE TELEFONO").ToString().Length > 5) Then
                    RegError(fila, "la (Tipo Telefono) supera el maximo de caracteres permitido (5)", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDate(row("FECHA DE ASIGNACION"))) Then
                    RegError(fila, "La columna (fecha Asignacion) tiene valores no valido por favor verificar", "Información General", row("NUMERO DE RADICADO").ToString())
                End If
                If Not (IsDBNull(row("OBSERVACIONES (OPCIONAL)"))) Then
                    If (row("OBSERVACIONES (OPCIONAL)").ToString().Length > 1024) Then
                        RegError(fila, "la (Observacion) supera el maximo de caracteres permitido (1024)", "Información General", row("NUMERO DE RADICADO").ToString())
                    ElseIf Not (miRegExp.IsMatch(row("OBSERVACIONES (OPCIONAL)").ToString())) Then
                        RegError(fila, "La (OBSERVACIONES (OPCIONAL)) tiene caracteres no permitidos por favor verificar ", "Información General", row("NUMERO DE RADICADO").ToString())
                    End If
                End If
                fila = fila + 1
            Next
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

    Private Sub Limpiar()
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
            .Add("TIPO DE SERVICIO", GetType(String))
            .Add("PRIORIDAD", GetType(String))
            .Add("CADENA", GetType(String))
            .Add("IDENTIFICACION", GetType(String))
            .Add("CIUDAD", GetType(String))
            .Add("DEPARTAMENTO", GetType(String))
            .Add("DIRECCION", GetType(String))
            .Add("FECHA DE ASIGNACION", GetType(String))
            .Add("NUMERO DE RADICADO", GetType(String))
            .Add("FECHA MAXIMA ENTREGA", GetType(String))
            .Add("NOMBRE CLIENTE", GetType(String))
            .Add("PERSONA AUTORIZADA", GetType(String))
            .Add("BARRIO", GetType(String))
            .Add("TELEFONO", GetType(String))
            .Add("TIPO DE TELEFONO", GetType(String))
            .Add("OBSERVACIONES (OPCIONAL)", GetType(String))
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

#End Region

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)

    End Sub
End Class