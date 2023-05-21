Imports NotusExpressBusinessLayer
Imports System.IO
Imports System.Text
Imports DevExpress.Web.ASPxPivotGrid
Imports DevExpress.Data.Filtering
Imports GemBox.Spreadsheet
Imports DevExpress.Web

Module Herramientas

    Public propiedadDeBusqueda As String

    Public Sub ForzarDescargaDeArchivo(ByVal rutaArchivo As String, Optional ByVal nombreMostrarArchivo As String = "")
        Dim infoArchivo As FileInfo
        Dim contextoHttp As HttpContext = HttpContext.Current

        Try
            If EsNuloOVacio(nombreMostrarArchivo) Then nombreMostrarArchivo = Path.GetFileName(rutaArchivo)

            infoArchivo = New FileInfo(rutaArchivo)
            If infoArchivo.Exists Then
                Dim myFile As New FileStream(rutaArchivo, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)
                Dim binaryReader As New BinaryReader(myFile)
                Dim startBytes As Long = 0
                Dim lastUpdateTiemStamp As String = File.GetLastWriteTimeUtc(rutaArchivo).ToString("r")
                Dim encodedData As String = HttpUtility.UrlEncode(nombreMostrarArchivo, Encoding.UTF8) + lastUpdateTiemStamp

                With contextoHttp.Response
                    .Clear()
                    .Buffer = False
                    .ContentType = "application/octet-stream"
                    .AddHeader("Content-Disposition", "attachment; filename=" & nombreMostrarArchivo)
                    .AddHeader("Content-Length", (infoArchivo.Length - startBytes).ToString())
                    If infoArchivo.Length > 10485760 Then
                        .AddHeader("Accept-Ranges", "bytes")
                        .AppendHeader("Last-Modified", lastUpdateTiemStamp)
                        .AppendHeader("ETag", Chr(34) & encodedData & Chr(34))
                        .AddHeader("Connection", "Keep-Alive")
                        '.ContentEncoding = Encoding.UTF8
                        binaryReader.BaseStream.Seek(startBytes, SeekOrigin.Begin)
                        Dim maxCount As Integer = CInt(Math.Ceiling((infoArchivo.Length - startBytes + 0.0) / 1024))
                        Dim index As Integer
                        While index < maxCount And .IsClientConnected
                            .BinaryWrite(binaryReader.ReadBytes(1024))
                            .Flush()
                            index += 1
                        End While
                    Else
                        .WriteFile(rutaArchivo)
                        .Flush()
                    End If
                    .End()
                End With
            End If
        Catch ex As System.Threading.ThreadAbortException
        End Try
    End Sub

    Public Sub MergeFooter(ByRef dgAux As DataGrid, Optional ByVal cellSpanIndex As Integer = 0, _
        Optional ByVal celdaInicial As Integer = 1, Optional ByVal celdaFinal As Integer = 0)
        If dgAux.Items.Count > 0 Then
            Dim numIndex As Integer = 1
            If dgAux.AllowPaging = True Then numIndex = 2
            Dim footer As DataGridItem = _
                CType(dgAux.Controls(0).Controls(dgAux.Controls(0).Controls.Count - numIndex), DataGridItem)
            Dim maxIndex As Integer = IIf(celdaFinal <> 0, celdaFinal, footer.Cells.Count - 1)
            For index As Integer = celdaInicial To maxIndex
                footer.Cells(index).Visible = False
            Next
            footer.Cells(cellSpanIndex).ColumnSpan = footer.Cells.Count
        End If
    End Sub

    Public Sub MergeGridViewFooter(ByRef gvAux As GridView, Optional ByVal cellSpanIndex As Integer = 0, _
       Optional ByVal celdaInicial As Integer = 1, Optional ByVal celdaFinal As Integer = 0)
        If gvAux.Rows.Count > 0 Then
            Dim numIndex As Integer = 1
            If gvAux.AllowPaging = True Then numIndex = 2
            Dim footer As GridViewRow = _
                CType(gvAux.Controls(0).Controls(gvAux.Controls(0).Controls.Count - numIndex), GridViewRow)
            Dim maxIndex As Integer = IIf(celdaFinal <> 0, celdaFinal, footer.Cells.Count - 1)
            For index As Integer = celdaInicial To maxIndex
                footer.Cells(index).Visible = False
            Next
            footer.Cells(cellSpanIndex).ColumnSpan = footer.Cells.Count
        End If
    End Sub

    Public Sub LimpiarFiltrosPivotGrid(pg As ASPxPivotGrid)
        If pg.Prefilter IsNot Nothing Then pg.Prefilter.Criteria = Nothing
        For Each field As DevExpress.Web.ASPxPivotGrid.PivotGridField In pg.Fields
            field.FilterValues.Clear()
        Next
    End Sub

    Public Sub ConstruirCriteriosDeFiltradoPivotGrid(pivot As ASPxPivotGrid, e As DevExpress.Web.ASPxPivotGrid.PivotFieldEventArgs)
        Dim prefilter As CriteriaOperator = TryCast(pivot.Prefilter.Criteria, CriteriaOperator)
        Dim rootGroup As GroupOperator = TryCast(prefilter, GroupOperator)
        If Object.ReferenceEquals(rootGroup, Nothing) Then
            rootGroup = New GroupOperator(GroupOperatorType.And)
            If (Not Object.ReferenceEquals(prefilter, Nothing)) Then
                rootGroup.Operands.Add(prefilter)
            End If
        End If
        If rootGroup.OperatorType = GroupOperatorType.Or Then
            rootGroup = New GroupOperator(GroupOperatorType.And, rootGroup)
        End If
        propiedadDeBusqueda = e.Field.ID
        Dim op As InOperator = TryCast(rootGroup.Operands.Find(AddressOf BuscarCriterioDeFiltrado), InOperator)
        If e.Field.FilterValues.IsEmpty Then
            If (Not Object.ReferenceEquals(op, Nothing)) Then
                rootGroup.Operands.Remove(op)
            End If
        Else
            If Object.ReferenceEquals(op, Nothing) Then
                op = New InOperator(New OperandProperty(e.Field.ID))
                rootGroup.Operands.Add(op)
            End If
            op.Operands.Clear()
            For Each val As Object In e.Field.FilterValues.ValuesIncluded
                op.Operands.Add(New OperandValue(val))
            Next val
        End If
        If rootGroup.Operands.Count > 0 Then
            pivot.Prefilter.Criteria = rootGroup
        Else
            pivot.Prefilter.Criteria = Nothing
        End If
    End Sub

    Public Function BuscarCriterioDeFiltrado(ByVal item As CriteriaOperator) As Boolean
        Dim binOp As InOperator = TryCast(item, InOperator)
        If Object.ReferenceEquals(binOp, Nothing) Then
            Return False
        End If
        Dim prop As OperandProperty = TryCast(binOp.LeftOperand, OperandProperty)
        If Object.ReferenceEquals(prop, Nothing) Then
            Return False
        End If
        Return prop.PropertyName = propiedadDeBusqueda
    End Function

    Public Sub ForzarDescargaDeArchivo(ByVal contextoHttp As HttpContext, ByVal rutaArchivo As String)
        Dim infoArchivo As FileInfo
        infoArchivo = New FileInfo(rutaArchivo)
        If infoArchivo.Exists Then
            Dim nombreArchivo As String = Path.GetFileName(rutaArchivo)
            ForzarDescargaDeArchivo(contextoHttp, rutaArchivo, nombreArchivo)
        End If
    End Sub

    Public Function ObtenerTexto(valor As Object) As String
        Dim resultado As String
        If valor Is Nothing Then
            resultado = ""
        Else
            resultado = valor.ToString.Trim
        End If
        Return resultado
    End Function

    Public Sub CargarLicenciaGembox()
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
    End Sub

    Public Function EsNuloOVacio(ByVal cadena As Object) As Boolean
        If cadena IsNot Nothing AndAlso cadena.ToString.Trim.Length > 0 Then
            Return False
        Else
            Return True
        End If
    End Function

    Public Sub ForzarDescargaDeArchivo(ByVal contextoHttp As HttpContext, ByVal rutaArchivo As String, _
                                      ByVal nombreMostrarArchivo As String)
        Dim infoArchivo As FileInfo
        Try

            infoArchivo = New FileInfo(rutaArchivo)
            If infoArchivo.Exists Then
                Dim startBytes As Long = 0
                With contextoHttp.Response
                    .Clear()
                    .Buffer = False
                    .ContentType = "application/octet-stream"
                    .AddHeader("Content-Disposition", "attachment; filename=" & nombreMostrarArchivo)
                    .AddHeader("Content-Length", (infoArchivo.Length - startBytes).ToString())
                    If infoArchivo.Length > 104857 Then
                        Dim myFile As New FileStream(rutaArchivo, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)
                        Dim binaryReader As New BinaryReader(myFile)
                        Dim lastUpdateTiemStamp As String = File.GetLastWriteTimeUtc(rutaArchivo).ToString("r")
                        Dim encodedData As String = HttpUtility.UrlEncode(nombreMostrarArchivo, Encoding.UTF8) + lastUpdateTiemStamp
                        .AddHeader("Accept-Ranges", "bytes")
                        .AppendHeader("Last-Modified", lastUpdateTiemStamp)
                        .AppendHeader("ETag", Chr(34) & encodedData & Chr(34))
                        .AddHeader("Connection", "Keep-Alive")
                        '.ContentEncoding = Encoding.UTF8
                        binaryReader.BaseStream.Seek(startBytes, SeekOrigin.Begin)
                        Dim maxCount As Integer = CInt(Math.Ceiling((infoArchivo.Length - startBytes + 0.0) / 1024))
                        Dim index As Integer
                        While index < maxCount And .IsClientConnected
                            .BinaryWrite(binaryReader.ReadBytes(1024))
                            .Flush()
                            index += 1
                        End While
                    Else
                        .WriteFile(rutaArchivo)
                        If .IsClientConnected Then .Flush()
                    End If
                    If .IsClientConnected Then .End()
                End With
            End If
        Catch ex As System.Threading.ThreadAbortException
        End Try
    End Sub


#Region "Métodos proceso archivos excel"
    Public Function LeerArchivoExcel2010yPasarloaDataSet(ByVal rutaArchivo As String,
                                                        ByVal cabeceras As String,
                                                        ByVal dtDatos As DataTable,
                                                        ByVal permitirCeldasNulas As Boolean) As DataTable
        Dim miExcel As New ExcelFile
        Dim miWs As ExcelWorksheet
        Dim hayDatos As Boolean

        Try
            If Path.GetExtension(rutaArchivo) = ".xls" Then
                miExcel.LoadXls(rutaArchivo)
            ElseIf Path.GetExtension(rutaArchivo) = ".xlsx" Then
                miExcel.LoadXlsx(rutaArchivo, XlsxOptions.None)
            End If

            Dim colcolumnas As String() = cabeceras.Split(New Char() {"|"c})

            Dim cantidadColumnas As Integer = colcolumnas.Length

            Dim nombreColumnaInicial As String = colcolumnas(0)

            If miExcel.Worksheets.Count > 0 Then
                miWs = miExcel.Worksheets(0)
                Dim cabeceradelArchivo = ObtenerCabecera(miWs, cantidadColumnas)

                If cabeceradelArchivo.ToUpper() <> cabeceras.ToUpper() Then Throw New Exception("los nombres de campos de la cabecera del archivo no coinciden")

                Dim x As Integer = 0
                If miWs.Rows.Count > 1 Then
                    For index As Integer = 1 To miWs.Rows.Count - 1
                        With miWs.Rows
                            hayDatos = HayDatosEnFila(.Item(index))
                            If hayDatos Then
                                If .Item(index).AllocatedCells.Count > 0 Then
                                    Dim celda As CellRange
                                    celda = .Item(index).Cells
                                    Dim col As String
                                    Dim f As Integer = 0
                                    Dim filaActual As DataRow
                                    filaActual = dtDatos.NewRow
                                    For Each col In colcolumnas
                                        If celda(f).Value = Nothing Then
                                            If permitirCeldasNulas = False Then
                                                Throw New Exception("Las celdas no pueden estar vacias en la fila : " & index.ToString())
                                            Else
                                                Try
                                                    filaActual(col) = String.Empty
                                                Catch ex As Exception
                                                    Throw New Exception("Error asignando datos a fila : " & ex.Message)
                                                End Try
                                            End If
                                        Else
                                            filaActual(col) = celda(f).Value.ToString.Trim
                                        End If
                                        f = f + 1
                                    Next
                                    dtDatos.Rows.Add(filaActual)
                                End If
                            End If
                        End With
                    Next
                Else
                    Throw New Exception("El archivo no tiene el formato requerido. Por favor verifique")
                End If
            Else
                Throw New Exception("El archivo especificado no contiende Hojas. Por favor verifique ")
            End If
        Catch ex As Exception
            Throw New Exception("Imposible obtener datos del archivo. " & ex.Message)
        End Try
        Return dtDatos
    End Function
    Public Sub setGemBoxLicense()
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
    End Sub
    Private Function ObtenerCabecera(miWs As GemBox.Spreadsheet.ExcelWorksheet, cantidadColumnas As Integer) As String
        Dim cabecera As String = String.Empty
        Dim hayDatos As Boolean
        If miWs.Rows.Count > 1 Then
            For index As Integer = 0 To 0
                With miWs.Rows
                    hayDatos = HayDatosEnFila(.Item(index))
                    If hayDatos Then
                        If .Item(index).AllocatedCells.Count > 0 Then
                            Dim i As Integer = 0
                            Dim celda As CellRange
                            celda = .Item(index).Cells
                            Dim f As Integer = 0
                            While (f <= cantidadColumnas - 1)
                                If celda(f).Value = Nothing Then Throw New Exception("Problemas con las cabeceras, el número no coincide :" & index.ToString() & " Cabecer incorrecta " & cabecera)
                                cabecera = cabecera & "|" & celda(f).Value.ToString.Trim()
                                f = f + 1
                            End While
                        End If
                    End If
                End With
            Next
        Else
            Throw New Exception("El archivo no tiene el formato requerido. Por favor verifique")
        End If
        Return cabecera.Substring(1, cabecera.Length - 1)
    End Function
    Public Function HayDatosEnFila(ByVal infoFila As ExcelRow) As Boolean
        Dim resultado As Boolean = False
        For index As Integer = 0 To infoFila.AllocatedCells.Count
            If infoFila.AllocatedCells(index).Value IsNot Nothing AndAlso Not String.IsNullOrEmpty(infoFila.AllocatedCells(index).Value.ToString) Then
                resultado = True
                Exit For
            End If
        Next
        Return resultado
    End Function
#End Region
  


#Region "Métodos Utiles DevExpress.Web"

    Public Sub CargarComboDX(ByRef control As ASPxComboBox, ByRef dataSource As DataTable, Optional valueField As String = Nothing, Optional textField As String = Nothing)
        With control
            .DataSource = dataSource
            If valueField IsNot Nothing Then
                .ValueField = valueField
            Else
                .ValueField = dataSource.Columns(0).ColumnName
            End If

            If textField IsNot Nothing Then
                .TextField = textField
            Else
                .TextField = dataSource.Columns(1).ColumnName
            End If

            .DataBind()
        End With
    End Sub

    Public Sub ColocarItemAdicionalOpcional(combo As DevExpress.Web.ASPxComboBox, itemValor As Integer, itemLetra As String)
        If combo.Items.Count >= 0 Then
            combo.Items.Insert(0, New DevExpress.Web.ListEditItem(itemLetra, itemValor))
        End If
        If combo.Items.Count = 2 Then
            combo.SelectedIndex = 1
        Else
            combo.SelectedIndex = 0
        End If
    End Sub

    Friend Sub OcultarColumnaenLayout(forma As ASPxFormLayout, columnas As String)
        Dim parts As String() = columnas.Split(New Char() {"|"c})
        For Each grupo As DevExpress.Web.LayoutGroup In forma.Items
            For Each item As DevExpress.Web.LayoutItem In grupo.Items
                Dim part As String
                For Each part In parts
                    If item.Caption = part Then
                        item.CssClass = "invisible"
                    End If
                Next
            Next
        Next
    End Sub
    Friend Sub VisualizarColumnaenLayout(forma As ASPxFormLayout, columnas As String)
        Dim parts As String() = columnas.Split(New Char() {"|"c})
        For Each grupo As DevExpress.Web.LayoutGroup In forma.Items
            For Each item As DevExpress.Web.LayoutItem In grupo.Items
                Dim part As String
                For Each part In parts
                    If item.Caption = part Then
                        item.CssClass = "visible"
                    End If
                Next
            Next
        Next
    End Sub

#End Region

End Module
