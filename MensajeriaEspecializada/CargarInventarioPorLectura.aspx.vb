Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports GemBox.Spreadsheet

Partial Public Class CargarInventarioPorLectura
    Inherits System.Web.UI.Page


#Region "Atributos (Campos)"

    Private _idUsuario As Integer
    Private _dtDatos As DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Cargue de Inventario CEM por lectura de seriales")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                MetodosComunes.setGemBoxLicense()
                _dtDatos = CargarInventarioCEM.ObtenerEstructuraDatosLectura()
                Session("dtDatos") = _dtDatos
                pnlErrores.Visible = False
                pnlRegistro.Visible = False
                lbDescargar.Visible = False
                lbGuardar.Visible = False
                lbCerrar.Enabled = False
                pnlLectura.Visible = False
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        Else
            _dtDatos = CType(Session("dtDatos"), DataTable)
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click

        lblSerial.Text = txtSerial.Text
        CapturarSerial(txtSerial.Text.Trim)
        CargarDatosEntrega()

        If lblCantidad.Text = lblLectura.Text Then
            lbCerrar.Enabled = True
            txtSerial.Enabled = False
            btnRegistrar.Enabled = False
            epNotificacion.showSuccess("Ya se leyo la totalidad de seriales, por favor proceda con el cierre del inventario.")
            lblCantidad.ForeColor = Color.Green
        Else
            lblCantidad.ForeColor = Color.Red
        End If
        LipiarControles()
        txtSerial.Focus()
    End Sub

    Protected Sub lbCerrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCerrar.Click

        Dim flagExito As Boolean = CargarInventarioCEM.CargarLecturaCEM(_dtDatos, _idUsuario)
        pnlLectura.Visible = False
        pnlRegistro.Visible = True
        lbDescargar.Visible = True
        
    End Sub

    Protected Sub lbDescargar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbDescargar.Click
        Dim dtDatos As New DataTable
        dtDatos = CargarInventarioCEM.DescargarSerialesLeidos(txtEntrega.Text.Trim)
        Session("dtDatos") = dtDatos
        Try
            If Session("dtDatos") IsNot Nothing Then
                dtDatos = CType(Session("dtDatos"), DataTable)
                Dim nombreArchivo As String = GenerarArchivoExcel(dtDatos)
                If System.IO.File.Exists(nombreArchivo) Then
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, nombreArchivo, True)
                Else
                    epNotificacion.showWarning("Imposible recuperar el archivo desde su ruta de almacenamiento. Por favor intente nuevamente")
                End If
            Else
                epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de exportar reporte a Excel. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnSubir_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubir.Click
        Try
            If fuArchivo.PostedFile.FileName <> "" Then
                Dim ruta As String = Server.MapPath("..\archivos_planos\") & Session("usxp001") & fuArchivo.FileName
                fuArchivo.SaveAs(ruta)
                Dim extencion As String = fuArchivo.PostedFile.FileName.Substring(fuArchivo.PostedFile.FileName.LastIndexOf(".")).ToLower()
                Dim dtDatos As New DataTable
                If extencion = ".txt" Then
                    dtDatos = Me.LeerZmmak(ruta)
                Else
                    epNotificacion.showError("Imposible determinar el formato del archivo")
                    Exit Sub
                End If
                If Session("dtError") Is Nothing Then
                    Dim flagExito As Boolean = CargarInventarioCEM.CargarZMMAK(dtDatos, _idUsuario)
                    pnlErrores.Visible = False
                    lbGuardar.Visible = True
                    fuArchivo.Enabled = False
                    epNotificacion.showSuccess("Se realizo la validación de " + dtDatos.Rows.Count.ToString + " registos del archivo ZMMAK correctamente, por favor proceda con el cargue del Inventario")
                Else
                    epNotificacion.showWarning("Se encontraron diferencias al subir el archivo ZMMAK, por favor verifique el log de resultados")
                    gvErrores.DataSource = CType(Session("dtError"), DataTable)
                    gvErrores.DataBind()
                    pnlErrores.Visible = True
                End If
            Else
                epNotificacion.showError("Debe seleccionar un archivo")
            End If

        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error al subir el archivo al servidor: " & ex.Message)
        End Try
    End Sub

    Protected Sub lbGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGuardar.Click
        CargarInventario()
    End Sub

    Protected Sub lbCrear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCrear.Click
        CrearBuscarOrden()
    End Sub


#End Region

#Region "Métodos Privados"

    Private Sub LipiarControles()
        txtSerial.Text = ""
    End Sub

    Private Sub CapturarSerial(ByVal serial As String)
        Dim resultado As New List(Of ResultadoProceso)
        Dim registrarSerial As New CargarInventarioCEM

        With registrarSerial
            .NumeroEntrega = txtEntrega.Text.Trim
            .Serial = serial
            .IdUsuario = _idUsuario
        End With
        resultado = registrarSerial.RegistrarSerial
        If resultado.Count = 0 Then
            epNotificacion.showSuccess("Serial registrado satifactoriamente")
        Else
            Dim mensajeRespuesta As String
            For Each mensaje As ResultadoProceso In resultado
                mensajeRespuesta = mensaje.Mensaje
            Next
            epNotificacion.showError(mensajeRespuesta)
        End If
    End Sub

    Private Function GenerarArchivoExcel(ByVal dtDatos As DataTable) As String
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/SerialesLeidos_" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim filaActual As Integer = 5
        miHoja = miExcel.Worksheets.Add("Seriales Leidos")
        With miHoja
            .Cells("A4").Value = "Serial"
            .Cells("B4").Value = "Entrega"

            Dim myStyle As New CellStyle
            With myStyle
                .Borders.SetBorders(MultipleBorders.Outside, Color.Black, LineStyle.Thin)
                .HorizontalAlignment = HorizontalAlignmentStyle.Center
                .Font.Weight = ExcelFont.BoldWeight
                .FillPattern.SetSolid(ColorTranslator.FromHtml("#333399"))
                .Font.Color = Color.White
            End With
            .Cells.GetSubrange("A4", "B4").Style = myStyle
            For Each drVenta As DataRow In dtDatos.Rows
                .Cells("A" & filaActual.ToString).Value = drVenta("Serial").ToString
                .Cells("B" & filaActual.ToString).Value = drVenta("Entrega").ToString
                filaActual += 1
            Next
            Dim myCellRange As CellRange = .Cells.GetSubrange("A" & filaActual.ToString, "B" & filaActual.ToString)
            With myCellRange
                .Merged = True
                With .Style
                    .FillPattern.SetSolid(ColorTranslator.FromHtml("#C0C0C0"))
                    .Font.Color = ColorTranslator.FromHtml("#000080")
                    .Font.Weight = ExcelFont.BoldWeight
                End With
            End With
            For index As Integer = 0 To dtDatos.Columns.Count - 1
                .Columns(index).AutoFitAdvanced(1)
            Next
            With .Cells("A1")
                .Value = epNotificacion.getTitle()
                .Style.Font.Weight = ExcelFont.BoldWeight
                .Style.Font.Size = 20 * 14
            End With
        End With
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

    Private Function LeerZmmak(ByVal ruta As String) As DataTable
        Dim lectorArchivo As StreamReader = Nothing
        Dim linea As String
        Dim arregloDatos() As String
        Dim numLinea As Integer = 1
        Dim dtDatos As DataTable = CargarInventarioCEM.ObtenerEstructuraDatos

        Session.Remove("dtError")
        If ruta <> "" Then
            Try
                lectorArchivo = File.OpenText(ruta)
                Do
                    linea = lectorArchivo.ReadLine
                    If linea <> "" Then
                        arregloDatos = linea.Split("|")
                        If arregloDatos.Length <> 14 Then
                            RegError(numLinea, "Formato no esperado para determinar el serial a actualizar")
                        Else
                            Dim flag As Boolean = True
                            If arregloDatos(10).Trim() = "" Then RegError(numLinea, "Se esperaba un serial", "") : flag = False
                            If arregloDatos(8).Trim() = "" Then RegError(numLinea, "Se esperaba una entrega", arregloDatos(8)) : flag = False
                            If arregloDatos(0).Trim() = "" Then RegError(numLinea, "Se esperaba una entrega", arregloDatos(0)) : flag = False
                            If flag Then Me.AgregarSerialesArchivo(arregloDatos(10), arregloDatos(0), arregloDatos(8), numLinea, dtDatos)
                        End If
                    ElseIf linea = "" AndAlso dtDatos.Rows.Count = 0 Then
                        RegError(numLinea, "Formato no esperado para determinar el serial a actualizar")
                    End If
                    numLinea += 1
                Loop Until (linea = "")
            Catch ex As Exception
                Throw New Exception("Error al tratar de leer los datos del archivo. " & ex.Message)
            Finally
                If Not lectorArchivo Is Nothing Then lectorArchivo.Close()
            End Try
        End If
        Return dtDatos
    End Function

    Private Sub RegError(ByVal linea As Integer, ByVal descripcion As String, Optional ByVal serial As String = "")
        Dim dtError As New DataTable
        If Session("dtError") Is Nothing Then
            dtError.Columns.Add(New DataColumn("lineaArchivo"))
            dtError.Columns.Add(New DataColumn("descripcion"))
            dtError.Columns.Add(New DataColumn("serial", GetType(String)))
            Session("dtError") = dtError
        Else
            dtError = Session("dtError")
        End If
        Dim dr As DataRow = dtError.NewRow()
        dr("lineaArchivo") = linea
        dr("serial") = serial
        dr("descripcion") = descripcion
        dtError.Rows.Add(dr)
        Session("dtError") = dtError
    End Sub

    Private Sub AgregarSerialesArchivo(ByVal serial As String, ByVal entrega As String, ByVal material As String, ByVal lineaArchivo As Integer, ByVal dtDatos As DataTable)
        If dtDatos.Select("serial='" & serial & "'").Length = 0 Then
            Dim dr As DataRow = dtDatos.NewRow
            dr("serial") = serial
            dr("entrega") = entrega
            dr("material") = material
            dr("lineaArchivo") = lineaArchivo
            dtDatos.Rows.Add(dr)
        Else
            RegError(lineaArchivo, "El serial se encuentra varias veces en el archivo", serial)
        End If
    End Sub

    Private Sub CargarInventario()
        Try
            Dim resultado As New List(Of ResultadoProceso)
            Dim cargar As New CargarInventarioCEM
            Dim dtLog As New DataTable()
            dtLog.Columns.Add("Diferencias Encontradas", Type.GetType("System.String"))
            With cargar
                .IdUsuario = _idUsuario
                .NumeroEntrega = txtEntrega.Text.Trim
            End With
            resultado = cargar.CargarInventarioLectura
            If resultado.Count = 0 Then
                epNotificacion.showSuccess("Se realizo el cargue del inventario satifactoriamente.")
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    Dim filaLog As DataRow = dtLog.NewRow()
                    filaLog(0) = mensaje.Mensaje
                    dtLog.Rows.Add(filaLog)
                Next
                epNotificacion.showWarning("Se presentaron diferencias al realizar el cargue del inventario, por favor verifique el Log de resultados")
                dtLog.AcceptChanges()
                gvErrores.DataSource = dtLog
                gvErrores.DataBind()
                lbGuardar.Visible = False
                pnlErrores.Visible = True
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el inventario. " & ex.Message)
        End Try
    End Sub

    Private Sub CrearBuscarOrden()
        Try
            Dim resultado As New List(Of ResultadoProceso)
            Dim ordenRecepcion As New CargarInventarioCEM
            With ordenRecepcion
                .NumeroEntrega = txtEntrega.Text.Trim
                .Cantidad = txtCantidad.Text.Trim
                .IdUsuario = _idUsuario
            End With
            resultado = ordenRecepcion.CrearOrdenRecepcion
            If resultado.Count = 0 Then
                epNotificacion.showSuccess("Se creo la orden de recpción satifactoriamente, por favor inicie la lectura de seriales")
                txtEntrega.Enabled = False
                txtCantidad.Enabled = False
                lbCrear.Enabled = False
                pnlLectura.Visible = True
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    mensajeRespuesta = mensaje.Valor
                    If mensajeRespuesta = "1" Then
                        epNotificacion.showWarning("La entrega: " & txtEntrega.Text.Trim & " ya se encuentra creada, por favor verifique si la totalidad de seriales ya se encuenntran leidos")
                        CargarDatosEntrega()
                        If lblCantidad.Text = lblLectura.Text Then
                            lbCerrar.Enabled = True
                            txtSerial.Enabled = False
                            btnRegistrar.Enabled = False
                            epNotificacion.showSuccess("Ya se leyo la totalidad de seriales, por favor proceda con el cierre del inventario.")
                            lblCantidad.ForeColor = Color.Green
                        Else
                            lblCantidad.ForeColor = Color.Red
                        End If
                        txtEntrega.Enabled = False
                        txtCantidad.Enabled = False
                        pnlLectura.Visible = True
                        lbCrear.Enabled = False
                    End If
                Next
            End If
        Catch ex As Exception
            epNotificacion.showError("Se genero un error al buscar orden de recepción: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatosEntrega()
        Dim resultado As New List(Of ResultadoProceso)
        Dim datosEntrega As New CargarInventarioCEM

        With datosEntrega
            .NumeroEntrega = txtEntrega.Text.Trim
        End With
        resultado = datosEntrega.CargarEntrega
        If resultado.Count = 0 Then
            lblCantidad.Text = datosEntrega.CantidadLeida
            lblLectura.Text = datosEntrega.Cantidad

        Else
            Dim mensajeRespuesta As String
            For Each mensaje As ResultadoProceso In resultado
                mensajeRespuesta = mensaje.Mensaje
            Next
            epNotificacion.showError(mensajeRespuesta)
        End If
    End Sub

#End Region

End Class