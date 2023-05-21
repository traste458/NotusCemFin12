Imports System.IO
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer

Public Class AdministrarCapacidadesDeEntregaMasivo
    Inherits System.Web.UI.Page

#Region "Atributos"

    Public RUTAALMACENAMIENTOARCHIVOS As String

    Private oExcel As ExcelFile
    Dim regExp As New System.Text.RegularExpressions.Regex("([0-9]{15}|[0-9]{17})")
    Dim filaInicial As Integer
    Dim columnaInicial As Integer
    Dim numColumnas As Integer
    Private Property _nombreArchivo As String
    Dim dtInformacionCapacidad As New DataTable()
#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
#If DEBUG Then
            Session("usxp001") = 1
            Session("usxp009") = 1
            Session("usxp007") = 1
#End If

            If Not IsPostBack Or Not IsCallback Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Cargue Capacidad Entrega Masivo")
                End With

                Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                RUTAALMACENAMIENTOARCHIVOS = rutaAlmacenaArchivo.ConfigKeyValue
                If Not Directory.Exists(RUTAALMACENAMIENTOARCHIVOS) Then
                    Directory.CreateDirectory(RUTAALMACENAMIENTOARCHIVOS)
                End If

            End If

            MetodosComunes.setGemBoxLicense()

        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try

    End Sub


    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try
            'If fuArchivo.PostedFile.FileName Then

            Dim nombreTipoBase As String = ""
            Dim fileExtension As String = Path.GetExtension(fuArchivo.PostedFile.FileName)
            Dim nombreArchivo As String = Path.GetFileName(fuArchivo.PostedFile.FileName)

            If (fileExtension <> "") Then
                fileExtension = fileExtension.ToUpper()
            End If
            Dim resultado As Integer = -1
            Dim idUsuario As Integer = CInt(Session("usxp001"))
            Session.Remove("dtResultado")
            Dim fec As String = DateTime.Now.ToString("yy:mm:dd").Replace(":", ".")

            Dim ruta As String = RUTAALMACENAMIENTOARCHIVOS
            Dim numColumnas As Integer

            Dim miExcel As New ExcelFile
            Try
                Select Case fileExtension
                    Case ".XLS"
                        miExcel.LoadXls(fuArchivo.FileContent)
                    Case ".XLSX"
                        miExcel.LoadXlsx(fuArchivo.FileContent, XlsxOptions.None)
                        Exit Select
                    Case Else
                        Throw New ArgumentNullException("Archivo no valido")
                End Select
            Catch ex As Exception
                Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)
            End Try
            If miExcel.Worksheets.Count >= 1 Then
                Dim oWsInfogeneralPedido As ExcelWorksheet = miExcel.Worksheets.Item(0)
                dtInformacionCapacidad = CrearEstructuraInfoCapacidad()

                numColumnas = oWsInfogeneralPedido.CalculateMaxUsedColumns()
                If numColumnas = 6 Then ' se valida el numero de columnas  del archivo cargado de acuerdo al tipo de base
                    Try
                        filaInicial = oWsInfogeneralPedido.Cells.FirstRowIndex
                        columnaInicial = oWsInfogeneralPedido.Cells.FirstColumnIndex
                        AddHandler oWsInfogeneralPedido.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                        oWsInfogeneralPedido.ExtractToDataTable(dtInformacionCapacidad, oWsInfogeneralPedido.Rows.Count, ExtractDataOptions.SkipEmptyRows,
                                               oWsInfogeneralPedido.Rows(filaInicial + 3), oWsInfogeneralPedido.Columns(columnaInicial))

                        dtInformacionCapacidad.Columns.Add(New DataColumn("Fila"))
                        Dim fil As Integer = filaInicial + 4
                        For Each row As DataRow In dtInformacionCapacidad.Rows
                            row("Fila") = fil
                            fil = fil + 1
                        Next
                        dtInformacionCapacidad.Columns.Add(New DataColumn("IdUsuario", GetType(System.Int32), idUsuario))

                        dtInformacionCapacidad.AcceptChanges()



                        'ValidarInformacionGeneralArchivo(dtInformacionCapacidad)
                        Dim dterrores As New DataTable
                        If Session("dtResultado") IsNot Nothing Then
                            dterrores = Session("dtResultado")
                        End If

                        If (dterrores IsNot Nothing Or dterrores.Rows.Count < 0) Then
                            Dim objCambioEstado As New CapacidadEntrega()
                            With objCambioEstado
                                .NombreEquipo = System.Net.Dns.GetHostName
                                .IdUsuario = idUsuario
                                Session("dtResultado") = .RegistrarCapacidadEntregaMasivo(dtInformacionCapacidad, resultado)
                                If resultado = 0 Then
                                    miEncabezado.showSuccess("La base fue cargada corectamente" & "<br><br>")
                                Else
                                    pcErrores.ShowOnPageLoad = True
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
                        miEncabezado.showError("Se genero un error al leer la infomacion de la hoja Información del pedido:  " & ex.Message)
                        Exit Sub
                    End Try
                Else
                    miEncabezado.showError("No se puede procesar, ya que la hoja contiene número columnas diferente a las esperadas. Por favor verifique. Número Columnas requeridas: 6")
                    Exit Sub
                End If
            Else
                miEncabezado.showError("No se puede procesar, ya que el archivo no contiene hojas. Por favor verifique  Numero de Hoyas: " & miExcel.Worksheets.Count)
                Exit Sub
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
    End Sub


#End Region


#Region "Metodos privados"

    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try

            Dim filename As String

            filename = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaCapacidadEntregaMasivo.xlsx")

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

    Private Function CrearEstructuraInfoCapacidad() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("Fecha", GetType(Date))
            dtAux.Columns.Add("IdJornada", GetType(Integer))
            dtAux.Columns.Add("NumeroTurnos", GetType(Integer))
            dtAux.Columns.Add("Agrupacion", GetType(Integer))
            dtAux.Columns.Add("Bodega", GetType(Integer))
            dtAux.Columns.Add("Empresa", GetType(String))
        End With
        Return dtAux
    End Function

#End Region

End Class