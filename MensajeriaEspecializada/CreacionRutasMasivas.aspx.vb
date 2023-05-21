Imports DevExpress.Web
Imports ILSBusinessLayer
Imports System.IO
Imports GemBox.Spreadsheet
Imports System.Text
Public Class CreacionRutasMasivas
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private oExcel As ExcelFile
    Dim regExp As New System.Text.RegularExpressions.Regex("([0-9]{15}|[0-9]{17})")
    Dim filaInicial As Integer
    Dim columnaInicial As Integer
    Dim numColumnas As Integer
    Private Property _nombreArchivo As String
    Dim dtInformacionGeneral As New DataTable()
    Dim contador As Integer = 0
#End Region


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        MetodosComunes.setGemBoxLicense()

        'Session("usxp001") = 1

        With miEncabezado
            .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            .setTitle("Crear Rutas Masivas Por Motorizado.")
        End With
    End Sub



    Sub limpiarFormulario()

        miEncabezado.clear()
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
        gvRadicados.DataSource = Nothing
        gvRadicados.DataBind()
        gvRutas.DataSource = Nothing
        gvRutas.DataBind()
        cpRadicados.ClientVisible = False
        rpRutas.ClientVisible = False
        pcRutas.ClientVisible = False
        cperrores.ClientVisible = False
        gvServis.DataSource = Nothing
        gvServis.DataBind()
        cpServicios.ClientVisible = False
        gvServis.Visible = False
    End Sub

    Public Sub ConsultarServiciosSinRuta()


    End Sub




    Private Sub cpSincroniza_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpSincroniza.Callback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "VerRadicados"
                    Dim dtRadicados As New DataTable
                    dtRadicados = MensajeriaEspecializada.RutaServicioMensajeria.ObtenerRadicadosPorId(arryAccion(1))
                    With gvRadicados
                        .DataSource = dtRadicados
                        .DataBind()
                        cpRadicados.Visible = True
                        cpRadicados.ClientVisible = True
                    End With
                    cpRadicados.ClientVisible = True
                    cpRadicados.Visible = True
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch
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
    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
        Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
        lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try

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
                        Throw New ArgumentNullException("Opcion no valida")
                End Select
            Catch ex As Exception
                Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)
            End Try
            If miExcel.Worksheets.Count >= 1 Then
                Dim oWsInfogeneralDevolucion As ExcelWorksheet = miExcel.Worksheets.Item(0)
                dtInformacionGeneral = CrearEstructura()
                numColumnas = oWsInfogeneralDevolucion.CalculateMaxUsedColumns()
                If numColumnas = 2 Then ' se valida el numero de columnas de InfoPedido Pedido
                    Try
                        filaInicial = oWsInfogeneralDevolucion.Cells.FirstRowIndex
                        columnaInicial = oWsInfogeneralDevolucion.Cells.FirstColumnIndex
                        AddHandler oWsInfogeneralDevolucion.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                        oWsInfogeneralDevolucion.ExtractToDataTable(dtInformacionGeneral, oWsInfogeneralDevolucion.Rows.Count, ExtractDataOptions.SkipEmptyRows,
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
                            Dim objGestion As New RegistrarRutasMasivo()
                            With objGestion
                                .IdUsuario = idUsuario
                                Session("dtResultado") = .AgregarRutasMasivasCEM(dtInformacionGeneral)
                                If (.resultado = 1) Then

                                    miEncabezado.showSuccess("La actualización se Ejecuto Correctamente ")
                                    cperrores.ClientVisible = False
                                    pcRutas.ClientVisible = True
                                    With gvRutas
                                        .DataSource = CType(Session("dtResultado"), DataTable)
                                        .DataBind()
                                    End With
                                Else
                                    miEncabezado.showWarning("Se presentaron errores al realizar la actualización por favor verificar el log de errores")
                                    pcRutas.ClientVisible = False
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
                ElseIf numColumnas > 2 Then
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

    Private Function CrearEstructura() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("Radicado", GetType(String))
            dtAux.Columns.Add("IdentificacionMotorizado", GetType(String))

        End With
        Return dtAux
    End Function

    Private Sub ValidarInformacionGeneral(ByVal informacionGeneral As DataTable)
        Dim fila As Integer = 1
        Try
            For Each row As DataRow In informacionGeneral.Rows

                If (IsDBNull(row("Radicado"))) Then
                    RegError(row("Fila"), "El (Radicado) Esta vacio por favor verificar", "")
                ElseIf (row("Radicado").ToString().Length > 18) Then
                    RegError(row("Fila"), "El (Radicado) supera el maximo de caracteres permitido (18)", row("Radicado"))
                ElseIf Not (IsNumeric(row("Radicado"))) Then
                    RegError(row("Fila"), "El (Radicado) Tiene que ser un valor numerico", row("Radicado"))
                End If

                If (IsDBNull(row("IdentificacionMotorizado"))) Then
                    RegError(row("Fila"), "La (IdentificacionMotorizado) Esta vacia por favor verificar", "")
                ElseIf Not (IsNumeric(row("IdentificacionMotorizado"))) Then
                    RegError(row("Fila"), "La (IdentificacionMotorizado) Tiene que ser un valor numerico", row("IdentificacionMotorizado"))
                End If

                fila = fila + 1
            Next

        Catch ex As Exception
            miEncabezado.showError("Error al validar la InfoPedido. " & ex.Message & "<br><br>")
            Exit Sub
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

    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/CreacionRutasMasivas.xlsx")
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

End Class

