Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer
Imports System.Text

Public Class CargueMasivoInventarioFinancieroCEM
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
            If Not IsPostBack Or Not IsCallback Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Cargue Masivo de seriales CEM Financiero")
                End With
            End If
            MetodosComunes.setGemBoxLicense()

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
            Dim filename As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaCargueMasivoInventarioFinancieroCEM.xlsx")
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
            'If fuArchivo.PostedFile.FileName Then
            Dim fileExtension As String = Path.GetExtension(fuArchivo.PostedFile.FileName)
            If (fileExtension <> "") Then
                fileExtension = fileExtension.ToUpper()
            End If
            Dim resultado As Integer = -1
            Dim idUsuario As Integer = CInt(Session("usxp001"))
            Session.Remove("dtResultado")
            Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim ruta As String = String.Empty
            ''''''-----------------
            Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
            If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                ruta = rutaAlmacenaArchivo.ConfigKeyValue & "Cargues\"
            Else
                miEncabezado.showError("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                Exit Sub
            End If
            If Not Directory.Exists(ruta) Then
                Directory.CreateDirectory(ruta)
            End If
            ''''''''''------------
            Dim nombreArchivo As String = "CargueCambiodeMateriales_" & fec & "-" & Session("usxp001") & Path.GetExtension(fuArchivo.PostedFile.FileName)
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
                If numColumnas = 4 Then ' se valida el numero de columnas de InfoPedido Pedido
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

                        Dim dterrores As New DataTable
                        ValidarInformacionGeneral(dtInformacionGeneral)
                        If Session("dtResultado") IsNot Nothing Then
                            dterrores = Session("dtResultado")
                        End If

                        If (dterrores Is Nothing Or dterrores.Rows.Count < 1) Then
                            Dim objGestion As New CargueMasivoInventarioFinanciero()
                            With objGestion
                                .IdUsuario = idUsuario
                                Session("dtResultado") = .CargueMasivoInventarioFinanciero(dtInformacionGeneral)
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
                ElseIf numColumnas > 4 Then
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


            'CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            'CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            'CType(sender, ASPxUploadControl).JSProperties("cpResultadoProceso") = 0
        End Try
    End Sub
    Private Sub ValidarInformacionGeneral(ByVal informacionGeneral As DataTable)
        Dim fila As Integer = 1
        Try


            For Each row As DataRow In informacionGeneral.Rows

                If (IsDBNull(row("consecutivo"))) Then
                    RegError(row("Fila"), "El (Serial) Esta vacio por favor verificar", "")
                ElseIf (row("consecutivo").ToString().Length > 25) Then
                    RegError(row("Fila"), "El (Serial) supera el maximo de caracteres permitido (18)", row("Serial"))
                ElseIf Not (IsNumeric(row("consecutivo"))) Then
                    RegError(row("Fila"), "El (Serial) Tiene que ser un valor numerico", row("Serial"))
                End If

                If (IsDBNull(row("codigoProducto"))) Then
                    RegError(row("Fila"), " El (Material) Esta vacio por favor verificar", "")
                ElseIf (row("codigoProducto").ToString().Length > 20) Then
                    RegError(row("Fila"), "El (Material) supera el maximo de caracteres permitido (20)", row("Material"))
                End If


                If (IsDBNull(row("bodega"))) Then
                    RegError(row("Fila"), "La (bodega) Esta vacio por favor verificar", "")
                ElseIf (row("bodega").ToString().Length > 70) Then
                    RegError(row("Fila"), "La (bodega) supera el maximo de caracteres permitido (70)", row("bodega"))

                End If
                If (IsDBNull(row("TipoServicio"))) Then
                    RegError(row("Fila"), "El (Tipo de Servicio) Esta vacio por favor verificar", "")
                ElseIf (row("TipoServicio").ToString().Length > 50) Then
                    RegError(row("Fila"), "La (Tipo de Servicio) supera el maximo de caracteres permitido (50)", row("TipoServicio"))

                End If

                fila = fila + 1
            Next

        Catch ex As Exception
            RegError(0, " Se genero un error en la validacion del archivo verifique la estructura " & ex.Message, "")
            miEncabezado.showError("Error al validar la InfoPedido. " & ex.Message & "<br><br>")
            Exit Sub
        End Try
    End Sub

#End Region
#Region "Métodos Privados"

    Private Sub Limpiar()
        Try
            miEncabezado.clear()
            Session.Remove("dtResultado")
            cperrores.ClientVisible = False

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
            dtAux.Columns.Add("consecutivo", GetType(String))
            dtAux.Columns.Add("codigoProducto", GetType(String))
            dtAux.Columns.Add("bodega", GetType(String))
            dtAux.Columns.Add("TipoServicio", GetType(String))
        End With
        Return dtAux
    End Function

#End Region

End Class