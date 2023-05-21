Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer
Imports System.Text
Imports ILSBusinessLayer.MensajeriaEspecializada
Public Class ActualizarInformacionServicioMensajeriaMasivo
    Inherits System.Web.UI.Page


#Region "Atributos"

    Private oExcel As ExcelFile
    Dim regExp As New System.Text.RegularExpressions.Regex("([0-9]{15}|[0-9]{17})")
    Dim filaInicial As Integer
    Dim columnaInicial As Integer
    Dim numColumnas As Integer
    Private Property _nombreArchivo As String
    Dim dtInformacionGeneral As New DataTable()
#End Region

#Region "Propiedades"

    Public ReadOnly Property archivoResultado() As Boolean
        Get
            If Session("dtResultado") Is Nothing Then
                Return False
            Else
                Return (CType(Session("dtResultado"), DataTable).Rows.Count > 0)
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
                    .setTitle("Registrar Novedades Servicio")
                End With
                'cargarTiposdeCambios()
            End If
            MetodosComunes.setGemBoxLicense()
            If cbPrincipal.IsCallback Then
                'cmbTipoCambio.DataBind()
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar página. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Protected Sub btnExportar_Click(sender As Object, e As EventArgs) Handles btnExportar.Click
        gveExportadorErrores.WriteXlsxToResponse("ErroresPlantillaPedisomasivos")
    End Sub


    Protected Sub gvErrores_DataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        gvErrores.DataSource = CType(Session("dtResultado"), DataTable)
    End Sub
    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaCambiosMasivosCamposServicioMensajeria.xlsx")
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
                    Response.Write("Este archivo no existe.")

                End If

            End If
            Response.Redirect(filename, False)

        Catch ex As Exception
            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub


    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
        Limpiar()
    End Sub
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try
            Limpiar()
            miEncabezado.clear()
            If Not (cmbTipoCambio.Value Is Nothing Or fuArchivo.PostedFile.FileName Is Nothing) Then
                'If fuArchivo.PostedFile.FileName Then
                Dim fileExtension As String = Path.GetExtension(fuArchivo.PostedFile.FileName)
                If (fileExtension <> "") Then
                    fileExtension = fileExtension.ToUpper()
                End If
                Dim resultado As Integer = -1
                Dim idUsuario As Integer = CInt(Session("usxp001"))
                Session.Remove("dtResultado")
                Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
                Dim ruta As String = HerramientasFuncionales.RUTAALMACENAMIENTOARCHIVOS & "Cargues\"
                Dim nombreArchivo As String = "CargueMasivoNovedades_" & fec & "-" & Session("usxp001") & Path.GetExtension(fuArchivo.PostedFile.FileName)
                _nombreArchivo = nombreArchivo
                ruta += nombreArchivo
                fuArchivo.SaveAs(ruta)
                Dim miWs As ExcelWorksheet
                Dim miExcel As New ExcelFile
                Try
                    Select Case fileExtension
                        Case ".XLS"
                            miExcel.LoadXls(ruta)
                        Case ".XLSX"
                            miExcel.LoadXlsx(ruta, XlsxOptions.None)
                            Exit Select
                        Case Else
                            Throw New ArgumentNullException("Archivo no valido")
                    End Select
                Catch ex As Exception
                    Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)
                End Try
                If miExcel.Worksheets.Count >= 1 Then
                    Dim oWsInfogeneralDevolucion As ExcelWorksheet = miExcel.Worksheets.Item(0)
                    dtInformacionGeneral = CrearEstructura()
                    numColumnas = oWsInfogeneralDevolucion.CalculateMaxUsedColumns()
                    If numColumnas = 6 Then ' se valida el numero de columnas de InfoPedido Pedido
                        Try
                            filaInicial = oWsInfogeneralDevolucion.Cells.FirstRowIndex
                            columnaInicial = oWsInfogeneralDevolucion.Cells.FirstColumnIndex
                            AddHandler oWsInfogeneralDevolucion.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                            oWsInfogeneralDevolucion.ExtractToDataTable(dtInformacionGeneral, oWsInfogeneralDevolucion.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                                   oWsInfogeneralDevolucion.Rows(filaInicial + 1), oWsInfogeneralDevolucion.Columns(columnaInicial))
                            dtInformacionGeneral.Columns.Add(New DataColumn("Fila"))
                            Dim fil As Integer = 2
                            For Each row As DataRow In dtInformacionGeneral.Rows
                                row("Fila") = fil
                                fil = fil + 1
                            Next
                            dtInformacionGeneral.Columns.Add(New DataColumn("idUsuario", GetType(System.Int64), idUsuario))
                            dtInformacionGeneral.AcceptChanges()
                            dtInformacionGeneral.Columns.Add(New DataColumn("idActualizacion", GetType(System.Int64), cmbTipoCambio.Value))
                            dtInformacionGeneral.AcceptChanges()
                            Dim dterrores As New DataTable
                            ValidarInformacionGeneral(dtInformacionGeneral)
                            If Session("dtResultado") IsNot Nothing Then
                                dterrores = Session("dtResultado")
                            End If

                            If (dterrores Is Nothing Or dterrores.Rows.Count < 1) Then
                                Dim objGestion As New ActualizarInformacionServicioMensajeriaArchivo()
                                With objGestion
                                    .IdUsuario = idUsuario
                                    Session("dtResultado") = .ActualizarInformacionServicioMensajeria(dtInformacionGeneral)
                                    If (.resultado = 1) Then
                                        miEncabezado.showSuccess("La actualización se Ejecuto Correctamente ")
                                    Else
                                        miEncabezado.showWarning("Se presentaron errores al realizar la actualización por favor verificar el log de errores")
                                        cperrores.ClientVisible = True
                                        With gvErrores
                                            .DataSource = CType(Session("dtResultado"), DataTable)
                                            .DataBind()
                                        End With
                                    End If
                                End With

                            Else
                                cperrores.ClientVisible = True
                                With gvErrores
                                    .DataSource = CType(Session("dtResultado"), DataTable)
                                    .DataBind()
                                End With
                            End If


                        Catch ex As Exception
                            miEncabezado.showError("Se genero un error al leer la infomacion del archivo:  " & ex.Message)
                            Exit Sub
                        End Try
                    ElseIf numColumnas > 6 Then
                        miEncabezado.showError("No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique: " & numColumnas.ToString())
                        Exit Sub
                    Else
                        miEncabezado.showError("No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique: " & numColumnas.ToString())
                        Exit Sub
                    End If
                Else
                    miEncabezado.showError("No se puede procesar, ya que el archivo no contiene hojas. Por favor verifique  Numero de Hojas: " & miExcel.Worksheets.Count)
                    Exit Sub
                End If
            Else
                miEncabezado.showError("Seleccione los valores requeridos")
            End If


            'CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            'CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            'CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
        End Try
    End Sub
    Private Sub ValidarInformacionGeneral(ByVal informacionGeneral As DataTable)
        Dim fila As Integer = 2
        Try


            For Each row As DataRow In informacionGeneral.Rows

                If (IsDBNull(row("NumeroRadicado"))) Then
                    RegError(row("Fila"), "El (Radicado) Esta vacio por favor verificar", "")
                ElseIf (row("NumeroRadicado").ToString().Length > 18) Then
                    RegError(row("Fila"), "El (Numero Radicado) supera el maximo de caracteres permitido (18)", row("Radicado"))
                ElseIf Not (IsNumeric(row("NumeroRadicado"))) Then
                    RegError(row("Fila"), "El (NumeroRadicado) Tiene que ser un valor numerico", row("Radicado"))
                End If

                If (IsDBNull(row("Valor1"))) Then
                    RegError(row("Fila"), "El (Valor1) Esta vacio por favor verificar", "")
                End If

                fila = fila + 1
            Next

        Catch ex As Exception
            miEncabezado.showError("Error al validar la InfoPedido. " & ex.Message & "<br><br>")
            Exit Sub
        End Try
    End Sub
    'Protected Sub cmbTipoCambio_DataBinding(sender As Object, e As EventArgs) Handles cmbTipoCambio.DataBinding
    '    If cmbTipoCambio.DataSource Is Nothing AndAlso Session("dtTiposdeCambios") IsNot Nothing Then
    '        cmbTipoCambio.DataSource = CType(Session("dtTiposdeCambios"), DataTable)
    '        'cmbCiudadEntrega.SelectedItem = cmbCiudadEntrega.Items.FindByValue(CStr(Session("usxp007")))
    '    End If
    'End Sub
#End Region
#Region "Métodos Privados"

    Private Sub cargarTiposdeCambios()
        '*** Cargar tipo servicio ***
        Dim dtTiposdeCambios As New DataTable()
        If Session("dtTiposdeCambios") Is Nothing Then
            dtTiposdeCambios = HerramientasMensajeria.ConsultaCamposActualizarServicioMensajeria()
            Session("dtTiposdeCambios") = dtTiposdeCambios
            With cmbTipoCambio
                .DataSource = dtTiposdeCambios
                .DataBind()
            End With
        End If
    End Sub

    Private Sub Limpiar()
        Try
            miEncabezado.clear()
            Session.Remove("dtResultado")
            cperrores.ClientVisible = False
            cmbTipoCambio.DataBind()
        Catch ex As Exception
            miEncabezado.showError("Error Al limpiar los campos . " & ex.Message & "<br><br>")
            'CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
        End Try
    End Sub
    Private Sub RegError(ByVal linea As Integer, ByVal descripcion As String, Optional ByVal pedido As String = "")
        Try
            Dim dtError As New DataTable
            If Session("dtResultado") Is Nothing Then
                dtError.Columns.Add(New DataColumn("Fila"))
                dtError.Columns.Add(New DataColumn("Mensaje"))
                Session("dtResultado") = dtError
            Else
                dtError = Session("dtResultado")
            End If
            Dim dr As DataRow = dtError.NewRow()
            dr("Fila") = linea
            dr("Mensaje") = descripcion
            dtError.Rows.Add(dr)
            Session("dtResultado") = dtError
        Catch ex As Exception
            miEncabezado.showError("Error al registra errores . " & ex.Message & "<br><br>")
        End Try
    End Sub

    Private Sub ExtractDataErrorHandler(sender As Object, e As ExtractDataDelegateEventArgs)
        If e.ErrorID = ExtractDataError.WrongType Then
            If Not IsNumeric(e.ExcelValue) And e.ExcelValue = Nothing Then
                e.DataTableValue = Nothing
            Else
                e.DataTableValue = e.ExcelValue.ToString()
            End If

            If e.DataTableValue = Nothing Then
                e.Action = ExtractDataEventAction.SkipRow
            Else
                e.Action = ExtractDataEventAction.Continue
            End If
        End If
    End Sub
    Private Function CrearEstructura() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("NumeroRadicado", GetType(Decimal))
            dtAux.Columns.Add("Valor1", GetType(String))
            dtAux.Columns.Add("Valor2", GetType(String))
            dtAux.Columns.Add("Valor3", GetType(String))
            dtAux.Columns.Add("Valor4", GetType(String))
            dtAux.Columns.Add("Valor5", GetType(String))
            End With
        Return dtAux
    End Function

#End Region

   
End Class