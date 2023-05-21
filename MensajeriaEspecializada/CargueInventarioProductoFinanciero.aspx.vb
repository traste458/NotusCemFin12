Imports System.IO
Imports GemBox
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer
'Imports ILSBusinessLayer.Papeleria
Imports DevExpress.Web

Public Class CargueInventarioProductoFinanciero
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private oExcel As ExcelFile
    Private objFinancieroSerializado As CargueProductoFinancieroSerializado
    Private objProducto As InventarioCargueProductoFinanciero
    Private objFinanciero As CargueProductoFinanciero

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Me.IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración Inventario Financiero")
                End With
            Else
                If Session("objFinancieroSerializado") IsNot Nothing Then objFinancieroSerializado = Session("objFinancieroSerializado")
                If Session("objFinanciero") IsNot Nothing Then objFinanciero = Session("objFinanciero")
                If Session("objProducto") IsNot Nothing Then objFinanciero = Session("objProducto")
            End If
            MetodosComunes.setGemBoxLicense()
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim arrayAccion As String()
        arrayAccion = e.Parameter.Split(":")
        Select Case arrayAccion(0)
            Case "Tipo"
                Session("idValor") = arrayAccion(1)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try
            Dim valor As String = Session("idValor")
            Dim validacionArchivo As New ResultadoProceso
            Dim fileExtension As String = Path.GetExtension(fuArchivo.PostedFile.FileName)
            Dim _nombreArchivo As String
            oExcel = New ExcelFile()
            Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim ruta As String = String.Empty
            Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
            If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                ruta = rutaAlmacenaArchivo.ConfigKeyValue & "Cargues\"
            Else
                Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
            End If

            If Not Directory.Exists(ruta) Then
                Directory.CreateDirectory(ruta)
            End If

            Dim nombreArchivo As String = String.Format("CargueCambiodeMateriales_{0}-{1}{2}", fec, Session("usxp001"), Path.GetExtension(fuArchivo.PostedFile.FileName))
            _nombreArchivo = nombreArchivo
            ruta += nombreArchivo
            fuArchivo.SaveAs(ruta)
                If fileExtension.ToUpper = ".XLS" Then
                oExcel.LoadXls(ruta)
                ElseIf fileExtension.ToUpper = ".XLSX" Then
                oExcel.LoadXlsx(ruta, XlsxOptions.None)
                End If
                Select Case valor
                    Case "0"
                        validacionArchivo = ProcesarArchivoSerializado()
                    Case "1"
                        validacionArchivo = ProcesarArchivo()
                    Case "2"
                    validacionArchivo = ProcesarArchivoProducto()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

                With miEncabezado
                    .setTitle("Administración Inventario Financiero")
                End With
                If validacionArchivo.Valor = 0 Then
                    miEncabezado.showSuccess("Se realizó la carga de inventario, satisfactoriamente.")
                ElseIf validacionArchivo.Valor = 10 Or validacionArchivo.Valor = 20 Or validacionArchivo.Valor = 30 Then
                    miEncabezado.showWarning(validacionArchivo.Mensaje)
                ElseIf validacionArchivo.Valor = 40 Then
                    miEncabezado.showSuccess(validacionArchivo.Mensaje)
                Else
                    miEncabezado.showWarning(validacionArchivo.Mensaje)
                End If
            cpGeneral.JSProperties("cpResultadoProceso") = validacionArchivo.Valor

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
        cpGeneral.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvErrores_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvErrores.CustomCallback
        Try
            Dim valor As String = Session("idValor")
            If valor = 0 Then
                If objFinancieroSerializado Is Nothing Then
                    objFinancieroSerializado = Session("objFinancieroSerializado")
                End If
                With gvErrores
                    .DataSource = objFinancieroSerializado.EstructuraTablaErrores()
                    Session("dtErrores") = .DataSource
                    .DataBind()
                End With
            ElseIf valor = 1 Then
                If objFinanciero Is Nothing Then
                    objFinanciero = Session("objFinanciero")
                End If
                With gvErrores
                    .DataSource = objFinanciero.EstructuraTablaErrores()
                    Session("dtErrores") = .DataSource
                    .DataBind()
                End With
            ElseIf valor = 2 Then
                If objProducto Is Nothing Then
                    objProducto = Session("objProducto")
                End If
                With gvErrores
                    .DataSource = objProducto.EstructuraTablaErrores()
                    Session("dtErrores") = .DataSource
                    .DataBind()
                End With
            End If

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Private Sub gvErrores_DataBinding(sender As Object, e As System.EventArgs) Handles gvErrores.DataBinding
        If Session("dtErrores") IsNot Nothing Then gvErrores.DataSource = Session("dtErrores")
    End Sub

    Protected Sub btnXlsxExport_Click(ByVal sender As Object, ByVal e As EventArgs)
        gvErrores.DataSource = Session("dtErrores")
        gveErrores.WriteXlsxToResponse()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Function ProcesarArchivoSerializado() As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Try
            objFinancieroSerializado = New CargueProductoFinancieroSerializado(oExcel)
            If objFinancieroSerializado.ValidarEstructura() Then
                If objFinancieroSerializado.ValidarInformacion() Then
                    Dim identificador As Guid = Guid.NewGuid()
                    Dim ruta As String = String.Empty
                    Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                    If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                        ruta = rutaAlmacenaArchivo.ConfigKeyValue
                    Else
                        Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                    End If

                    'Dim uploader As UploadedFile = upArchivo.UploadedFiles(0)
                    Dim rutaAlmacenamiento As String = ruta & "Cargues\"
                    resultado = objFinancieroSerializado.CargarInventario()
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        fuArchivo.SaveAs(rutaAlmacenamiento & identificador.ToString())

                    End If
                Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                End If
            Else
                resultado.EstablecerMensajeYValor(10, "Estructura inválida en el archivo proporcionado")
            End If
            Session("objFinancieroSerializado") = objFinancieroSerializado
        Catch ex As Exception
            Throw ex
        End Try
        Return resultado
    End Function

    Private Function ProcesarArchivo() As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Try
            objFinanciero = New CargueProductoFinanciero(oExcel)
            If objFinanciero.ValidarEstructura() Then
                If objFinanciero.ValidarInformacion() Then
                    Dim identificador As Guid = Guid.NewGuid()
                    'Dim uploader As UploadedFile = upArchivo.UploadedFiles(0)
                    Dim ruta As String = String.Empty
                    Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                    If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                        ruta = rutaAlmacenaArchivo.ConfigKeyValue
                    Else
                        Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                    End If
                    Dim rutaAlmacenamiento As String = ruta & "Cargues\"
                    resultado = objFinanciero.CargarInventario()
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        fuArchivo.SaveAs(rutaAlmacenamiento & identificador.ToString())
                        'uploader.SaveAs(rutaAlmacenamiento & identificador.ToString())
                    End If
                Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                End If
            Else
                resultado.EstablecerMensajeYValor(10, "Estructura inválida en el archivo proporcionado")
            End If
            Session("objFinanciero") = objFinanciero
        Catch ex As Exception
            Throw ex
        End Try
        Return resultado
    End Function

    Private Function ProcesarArchivoProducto() As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Try
            objProducto = New InventarioCargueProductoFinanciero(oExcel)
            If objProducto.ValidarEstructura() Then
                If objProducto.ValidarInformacion() Then
                    Dim identificador As Guid = Guid.NewGuid()
                    'Dim uploader As UploadedFile = upArchivo.UploadedFiles(0)
                    Dim ruta As String = String.Empty
                    Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                    If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                        ruta = rutaAlmacenaArchivo.ConfigKeyValue
                    Else
                        Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                    End If
                    Dim rutaAlmacenamiento As String = ruta & "Cargues\"
                    resultado = objProducto.CargarInventario()
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        'uploader.SaveAs(rutaAlmacenamiento & identificador.ToString())
                        fuArchivo.SaveAs(rutaAlmacenamiento & identificador.ToString())
                        objProducto.ObtenerInventarioProductoFinanciero()
                    End If
                Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                End If
            Else
                resultado.EstablecerMensajeYValor(10, "Estructura inválida en el archivo proporcionado")
            End If
            Session("objProducto") = objProducto
        Catch ex As Exception
            Throw ex
        End Try
        Return resultado
    End Function

#End Region
End Class