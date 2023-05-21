Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.Inventario
Imports System.Collections.Generic
Imports System.Text
Imports ILSBusinessLayer.Productos
Imports System.Linq
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer.WMS

Public Class RegistrarServicioTipoVentaCorporativo
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private Shared infoEstados As InfoEstadoRestriccionCEM
    Private _PersonasGerencia As DataTable
    Private oExcel As ExcelFile
    Private objMines As CargueArchivoMinesCorporativo
    Private objSoloSim As CargueArchivoMinesCorporativoSoloSim
    Private Const PageSizeSessionKey As String = "ed5e843d-cff7-47a7-815e-832923f7fb09"
    Private _nombreArchivo As String

#End Region

#Region "Propiedades"

    Public Property PersonasGerencia As DataTable
        Get
            If _PersonasGerencia Is Nothing Then PersonalEnGerencia()
            Return _PersonasGerencia
        End Get
        Set(value As DataTable)
            _PersonasGerencia = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not (Page.IsCallback) Then

            Seguridad.verificarSession(Me)

        End If

#If DEBUG Then
        Session("usxp001") = 42535
        Session("usxp009") = 165
        Session("usxp007") = 944
#End If

        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Registro Servicio Venta Corporativa")
            End With
            CancelarRegistro()
        End If
        If cmbMaterial.IsCallback Then CargarMateriales()

        MetodosComunes.setGemBoxLicense()
        CargaInicial()
        CargarMinesTemporales()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim msisdn As String
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            Dim lnkEliminar As ASPxHyperLink = templateContainer.FindControl("lnkEliminar")

            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            msisdn = CStr(gvMateriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "msisdn"))

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al generar los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub LinkDoc_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim extensionArchivo As String
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            extensionArchivo = Path.GetExtension(CStr(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "nombreArchivo"))).ToLower()
            Dim lnkVisualizar As ASPxHyperLink = templateContainer.FindControl("lnkVer")
            Dim lnkEditar As ASPxHyperLink = templateContainer.FindControl("lnkEditar")

            'Link de Visualización de Archivo
            With lnkVisualizar
                Select Case extensionArchivo
                    Case ".pdf"
                        .ImageUrl = "~/images/DxPdf.png"
                    Case ".jpg", ".tiff"
                        .ImageUrl = "~/images/Paint.gif"
                    Case Else
                        .ImageUrl = "~/images/DxSearch16.png"
                End Select
            End With

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        arrayAccion = e.Parameter.Split(":")
        Try
            Select Case arrayAccion(0)
                Case "RegistrarServicio"
                    resultado = ValidarRegistroServicio()
                    If resultado.Valor = 0 Then
                        Dim idServicio As Integer
                        resultado = RegistrarServicio(idServicio)
                        If resultado.Valor = 20 Then
                            miEncabezado.showSuccess(resultado.Mensaje)
                            EnviarNotificacion(resultado.Mensaje, idServicio)
                            CargarMinesTemporales()
                            CargaInicial()
                            With dateFechaSolicitud
                                .Date = Now.Date
                                .ClientEnabled = False
                            End With
                            rblPortacion.Value = 0
                        Else
                            miEncabezado.showWarning(resultado.Mensaje)
                        End If
                    End If
                Case "CancelarRegistro"
                    resultado = CancelarRegistro()
                    CargarMinesTemporales()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        CType(sender, ASPxCallbackPanel).JSProperties("cpResultado") = resultado.Valor
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try
            Dim tipo As Integer = rblTipoSolicitud.Value
            Dim idBodega As Integer = cmbBodega.Value
            Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
            Session("idValor") = tipo
            Dim validacionArchivo As New ResultadoProceso
            If idBodega > 0 Then
                If fuArchivo.PostedFile.ContentLength <= 10485760 Then
                    If fuArchivo.PostedFile.FileName <> "" Then
                        Dim ruta As String = "\\Colbogsacde001\Portales\ArchivosTemporale\"
                        Dim nombreArchivo As String = "CargueMasivo_" & Session("usxp001") & fec & Path.GetExtension(fuArchivo.PostedFile.FileName)
                        _nombreArchivo = nombreArchivo
                        ruta += nombreArchivo
                        fuArchivo.SaveAs(ruta)
                        Dim extencion As String = Path.GetExtension(fuArchivo.PostedFile.FileName).ToLower
                        If extencion = ".xls" Or extencion = ".xlsx" Then
                            Select Case tipo
                                Case "1"
                                    validacionArchivo = ProcesarArchivoEquipoSim(ruta, idBodega)
                                Case "2"
                                    validacionArchivo = ProcesarArchivoSoloSim(ruta, idBodega)
                                Case Else
                                    Throw New ArgumentNullException("Opcion no valida")
                            End Select
                            hdIdServicio.Set("valor", validacionArchivo.Valor)
                            If validacionArchivo.Valor = 0 Then
                                miEncabezado.showSuccess(validacionArchivo.Mensaje)
                            Else
                                miEncabezado.showWarning(validacionArchivo.Mensaje)
                            End If
                            ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>Procesar()</script>", False)
                        Else
                            miEncabezado.showError("Tipo de archivo incorrecto. Se espera un archivo con extensión .XLS")
                            Exit Sub
                        End If
                    Else
                        miEncabezado.showError("Debe seleccionar un archivo")
                    End If
                Else
                    miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB.")
                End If
            Else
                miEncabezado.showWarning("Antes de cargar el archivo debe seleccionar una bodega.")
                cmbBodega.Focus()
            End If
            CargarDireccion()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
    End Sub

    Private Sub btnEspecial_Click(sender As Object, e As EventArgs) Handles btnEspecial.Click
        Dim respuesta As ResultadoProceso
        Dim idUsuario As Integer
        Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            If fuEspecial.PostedFile.ContentLength <= 10485760 Then
                If fuEspecial.PostedFile.FileName <> "" Then
                    Dim extencion As String = Path.GetExtension(fuEspecial.PostedFile.FileName).ToLower
                    If extencion = ".pdf" Or extencion = ".msg" Then
                        Dim objDocServicio As New DocumentoTemporalServicioMensajeria()
                        With objDocServicio
                            .NombreDocumento = "Soportes de Precios Especiales : " & Session("usxp002")
                            .NombreArchivo = fuEspecial.PostedFile.FileName
                            .RutaAlmacenamiento = "Archivos\Servicio" & idUsuario.ToString().PadLeft(8, "0")
                            .TipoContenido = fuEspecial.PostedFile.ContentType
                            .Tamanio = fuEspecial.PostedFile.ContentLength
                            .IdentificadorUnico = Guid.NewGuid()
                            .Archivo = fuEspecial.FileContent
                            respuesta = .RegistrarDocumentosTemporales(idUsuario, Enumerados.TipoDocumento.SoportesdePreciosEspeciales)
                            hdIdServicio.Set("valor", respuesta.Valor)
                        End With
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>ProcesarEspecial()</script>", False)
                    Else
                        miEncabezado.showError("Tipo de archivo incorrecto. Se espera un archivo con extensión .pdf o .msg")
                    End If
                Else
                    miEncabezado.showError("Debe seleccionar un archivo")
                End If
            Else
                miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB.")
            End If
            CargarDireccion()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
    End Sub

    Private Sub btnPago_Click(sender As Object, e As EventArgs) Handles btnPago.Click
        Dim respuesta As ResultadoProceso
        Dim idUsuario As Integer
        Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            If fuPago.PostedFile.ContentLength <= 10485760 Then
                If fuPago.PostedFile.FileName <> "" Then
                    Dim extencion As String = Path.GetExtension(fuPago.PostedFile.FileName).ToLower
                    If extencion = ".pdf" Or extencion = ".msg" Then
                        Dim objDocServicio As New DocumentoTemporalServicioMensajeria()
                        With objDocServicio
                            .NombreDocumento = "Soportes de Pago : " & Session("usxp002")
                            .NombreArchivo = fuPago.PostedFile.FileName
                            .RutaAlmacenamiento = "Archivos\Servicio" & idUsuario.ToString().PadLeft(8, "0")
                            .TipoContenido = fuPago.PostedFile.ContentType
                            .Tamanio = fuPago.PostedFile.ContentLength
                            .IdentificadorUnico = Guid.NewGuid()
                            .Archivo = fuPago.FileContent
                            respuesta = .RegistrarDocumentosTemporales(idUsuario, Enumerados.TipoDocumento.SoportesdePago)
                            hdIdServicio.Set("valor", respuesta.Valor)
                        End With
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>ProcesarEspecial()</script>", False)
                    Else
                        miEncabezado.showError("Tipo de archivo incorrecto. Se espera un archivo con extensión .pdf o .msg")
                    End If
                Else
                    miEncabezado.showError("Debe seleccionar un archivo")
                End If
            Else
                miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB.")
            End If
            CargarDireccion()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
    End Sub

    Private Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        Dim respuesta As ResultadoProceso
        Dim idUsuario As Integer
        Dim idDocumento As Integer = CInt(Session("idDocumento"))
        Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            If fuActualizar.PostedFile.ContentLength <= 10485760 Then
                If fuActualizar.PostedFile.FileName <> "" Then
                    Dim extencion As String = Path.GetExtension(fuActualizar.PostedFile.FileName).ToLower
                    If extencion = ".pdf" Or extencion = ".msg" Then
                        Dim objDocServicio As New DocumentoTemporalServicioMensajeria(idDocumento)
                        Dim rutaEliminar As String = HttpContext.Current.Server.MapPath(objDocServicio.RutaAlmacenamiento) & "\" & objDocServicio.IdentificadorUnico.ToString()
                        With objDocServicio
                            .IdRegistro = idDocumento
                            .NombreArchivo = fuActualizar.PostedFile.FileName
                            .RutaAlmacenamiento = "Archivos\Servicio" & idUsuario.ToString().PadLeft(8, "0")
                            .TipoContenido = fuActualizar.PostedFile.ContentType
                            .Tamanio = fuActualizar.PostedFile.ContentLength
                            .IdentificadorUnico = Guid.NewGuid()
                            .Archivo = fuActualizar.FileContent
                            respuesta = .Actualizar(idUsuario)
                            hdIdServicio.Set("valor", respuesta.Valor)
                        End With
                        If respuesta.Valor = 0 Then
                            Session("mensaje") = respuesta.Mensaje
                            If File.Exists(rutaEliminar) Then
                                File.Delete(rutaEliminar)
                            End If
                        Else
                            miEncabezado.showWarning(respuesta.Mensaje)
                        End If
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>ProcesarEspecial()</script>", False)
                    Else
                        miEncabezado.showError("Tipo de archivo incorrecto. Se espera un archivo con extensión .pdf o .msg")
                    End If
                Else
                    miEncabezado.showError("Debe seleccionar un archivo")
                End If
            Else
                miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB.")
            End If
            CargarDireccion()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
    End Sub

    Private Sub dialogoEditar_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles dialogoEditar.WindowCallback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        arrayAccion = e.Parameter.Split(":")
        Try
            Select Case arrayAccion(0)
                Case "Inicial"
                    DatosBasicosDocumento(arrayAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al iniciar el callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub dialogoEditarMin_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles dialogoEditarMin.WindowCallback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        arrayAccion = e.Parameter.Split(":")
        Try
            Select Case arrayAccion(0)
                Case "Inicial"
                    DatosBasicosMin(arrayAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al iniciar el callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub btnXlsxExport_Click(ByVal sender As Object, ByVal e As EventArgs)
        gveErrores.WriteXlsxToResponse()
    End Sub

    Private Sub gvErrores_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvErrores.CustomCallback
        Try
            Dim param As String = e.Parameters
            Select Case param
                Case "erroresRegistro"
                    With gvErrores
                        .DataSource = Session("dtErrores")
                        .DataBind()
                    End With
                Case Else
                    Dim valor As String = Session("idValor")
                    If valor = 1 Then
                        If objMines Is Nothing Then
                            objMines = Session("objMines")
                        End If
                        With gvErrores
                            .DataSource = objMines.EstructuraTablaErrores()
                            Session("dtErrores") = .DataSource
                            .DataBind()
                        End With
                    ElseIf valor = 2 Then
                        If objSoloSim Is Nothing Then
                            objSoloSim = Session("objSoloSim")
                        End If
                        With gvErrores
                            .DataSource = objSoloSim.EstructuraTablaErrores()
                            Session("dtErrores") = .DataSource
                            .DataBind()
                        End With
                    End If
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Private Sub gvErrores_DataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        If Session("dtErrores") IsNot Nothing Then gvErrores.DataSource = Session("dtErrores")
    End Sub

    Private Sub gvMateriales_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gvMateriales.CustomCallback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        arrayAccion = e.Parameters.Split(":")
        Select Case arrayAccion(0)
            Case "cargaInicial"
                CargarMinesTemporales()
            Case "Eliminar"
                resultado = EliminarMsisdn(arrayAccion(1))
                If resultado.Valor = 0 Then
                    CargarMinesTemporales()
                End If
            Case "EditarMin"
                EditarMinesTemporales(arrayAccion(1))
                CargarMinesTemporales()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvMateriales_DataBinding(sender As Object, e As EventArgs) Handles gvMateriales.DataBinding
        If Session("dtMines") IsNot Nothing Then gvMateriales.DataSource = Session("dtMines")
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Dim arrayAccion As String()
        Try
            arrayAccion = e.Parameters.Split(":")
            Select Case arrayAccion(0)
                Case "CargueDocumentos"
                    CargarDocumentosTemporales()
                Case "Eliminar"
                    EliminarDocumentosTemporales(arrayAccion(1))
                    CargarDocumentosTemporales()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al generar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtDocumento") IsNot Nothing Then gvDatos.DataSource = Session("dtDocumento")
    End Sub

    Protected Sub Chk_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim msisdn As String
        Try
            Dim chkPic As CheckBox = CType(sender, CheckBox)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(chkPic.NamingContainer, GridViewDataItemTemplateContainer)
            msisdn = gvMateriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "msisdn")

            Dim chkSeleccion As CheckBox = templateContainer.FindControl("chkSeleccion")
            chkSeleccion.CssClass = chkSeleccion.CssClass.Replace("{0}", msisdn)
            chkSeleccion.ID = msisdn

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub PersonalEnGerencia()
        Try
            _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
            Session("dtPersonasGerencia") = _PersonasGerencia
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub CargaInicial()
        Dim idUsuario As Integer
        Try

            Integer.TryParse(Session("usxp001"), idUsuario)

            'Fecha de Registro
            With dateFechaSolicitud
                .Date = Now.Date
                .ClientEnabled = False
            End With

            '*** Cargar la bodega ***
            If Session("dtBodega") Is Nothing Then
                Session("dtBodega") = HerramientasMensajeria.ConsultarBodega(idUsuarioConsulta:=idUsuario)
            End If
            MetodosComunes.CargarComboDX(cmbBodega, CType(Session("dtBodega"), DataTable), "idbodega", "bodega")
            With cmbBodega
                If .Items.Count = 1 Then
                    .SelectedIndex = 1
                End If
            End With

            'Se cargan las Ciudades
            Dim dtCiudad As DataTable = HerramientasMensajeria.ObtenerCiudadesCem(idCiudadPadre:=CInt(Session("usxp007")))
            With cmbCiudadEntrega
                .DataSource = dtCiudad
                Session("dtCiudades") = .DataSource
                .DataBind()
                If dtCiudad.Rows.Count = 1 Then
                    .SelectedIndex = 0
                Else
                    .SelectedItem = cmbCiudadEntrega.Items.FindByValue(CStr(Session("usxp007")))
                End If
                .Focus()
            End With

            'Se cargan las formas de pago
            Dim dtFormaPago As DataTable = HerramientasMensajeria.ObtenerFormaPago
            With cmbFormaPago
                .DataSource = dtFormaPago
                .ValueField = "idFormaPago"
                .TextField = "FormaPago"
                .DataBind()
            End With

            ' Se cargan los tipos de identificacion
            MetodosComunes.CargarComboDX(cmbTipoIdentificacion, CType(HerramientasMensajeria.ObtieneTiposIdentificacion, DataTable), "idTipo", "descripcion")

            'Gerencias y Ejecutivos
            Dim dvPersonasGerencia As DataView = PersonasGerencia.DefaultView
            dvPersonasGerencia.RowFilter = "idPersona = " & idUsuario.ToString

            If dvPersonasGerencia.Count > 0 Then
                Dim Fila As DataRow() = PersonasGerencia.Select("idPersona IN (" & idUsuario.ToString & ")")
                Dim mail As String = CStr(Fila(0).Item("email"))
                If mail <> "Sin mail" Then
                    With cmbGerencia
                        .DataSource = dvPersonasGerencia.ToTable()
                        .ValueField = "idGerencia"
                        .TextField = "gerencia"
                        .SelectedIndex = 0
                        .ClientEnabled = False
                        .DataBind()
                    End With

                    With cmbCoordinador
                        .DataSource = dvPersonasGerencia.ToTable()
                        .ValueField = "idPersonaPadre"
                        .TextField = "personaPadre"
                        .SelectedIndex = 0
                        .ClientEnabled = False
                        .DataBind()
                    End With

                    With cmbConsultor
                        .DataSource = dvPersonasGerencia.ToTable()
                        .ValueField = "idPersona"
                        .TextField = "persona"
                        .SelectedIndex = 0
                        .ClientEnabled = False
                        .DataBind()
                    End With
                Else
                    imgRegistro.ClientVisible = False
                    miEncabezado.showWarning("El usuario actual no cuenta con un correo electronico configurado, no es posible continuar con el registro.")
                End If
            Else
                imgRegistro.ClientVisible = False
                miEncabezado.showWarning("El usuario actual no se encuentra configurado en la Jerarquía de Personal SIEMBRA, por favor contacte al administrador.")
            End If

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al cargar los datos iniciales: " & ex.Message)
        End Try
    End Sub

    Private Function ProcesarArchivoEquipoSim(ByVal ruta As String, ByVal idBodega As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            objMines = New CargueArchivoMinesCorporativo(oExcel)
            If objMines.ValidarEstructura(ruta) Then
                If objMines.ValidarInformacion(idBodega) Then
                    resultado = objMines.RegistrarMsisdnTemporales()
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        'uploader.SaveAs(Server.MapPath("~") & rutaAlmacenamiento & identificador.ToString())
                    End If
                Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                End If
            Else
                resultado.EstablecerMensajeYValor(10, "Estructura inválida en el archivo proporcionado")
            End If
            Session("objMines") = objMines
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(300, "Se generó un error al cargar el archivo: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Function ProcesarArchivoSoloSim(ByVal ruta As String, ByVal idBodega As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            objSoloSim = New CargueArchivoMinesCorporativoSoloSim(oExcel)
            If objSoloSim.ValidarEstructura(ruta) Then
                If objSoloSim.ValidarInformacion(idBodega) Then
                    Dim identificador As Guid = Guid.NewGuid()
                    'Dim uploader As UploadedFile = upArchivo.UploadedFiles(0)
                    Dim rutaAlmacenamiento As String = "\\Colbogsacde001\Portales\ArchivosTemporale\"
                    resultado = objSoloSim.RegistrarMsisdnTemporales()
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        'uploader.SaveAs(Server.MapPath("~") & rutaAlmacenamiento & identificador.ToString())
                    End If
                Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                End If
            Else
                resultado.EstablecerMensajeYValor(10, "Estructura inválida en el archivo proporcionado")
            End If
            Session("objSoloSim") = objSoloSim
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(300, "Se generó un error al cargar el archivo: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub CargarMinesTemporales()
        Dim dtMines As DataTable = HerramientasMensajeria.ObtenerMsisdnTemporales(CInt(Session("usxp001")))
        Session("dtMines") = dtMines
        With gvMateriales
            .DataSource = dtMines
            .DataBind()
        End With
    End Sub

    Private Function EliminarMsisdn(ByVal msisdn As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objMin As New CargueArchivoMinesCorporativo(oExcel)

        With objMin
            Dim arrMsisdn As String() = msisdn.Split(",")
            Dim listMsisdn As New List(Of String)
            For Each min As String In arrMsisdn
                listMsisdn.Add(CStr(min))
            Next
            resultado = .EliminarMsisdnTemporal(listMsisdn)
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function ValidarRegistroServicio() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim dtErrores As New DataTable
        Dim miRegistro As New ServicioMensajeriaVentaCorporativa

        With miRegistro
            .IdUsuario = CInt(Session("usxp001"))
            .IdCiudad = CInt(cmbCiudadEntrega.Value)
            resultado = .ValidarRegistroServicio(dtErrores, CInt(cmbFormaPago.Value))
        End With
        Session("dtErrores") = dtErrores
        Return resultado
    End Function

    Private Function RegistrarServicio(ByRef idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        infoEstados = New InfoEstadoRestriccionCEM(Enumerados.TipoServicio.VentaCorporativa, _
                                                       Enumerados.ProcesoMensajeria.Registro, _
                                                       Enumerados.ProcesoMensajeria.Registro, 0)

        Dim objServicioCorporativo As New ServicioMensajeriaVentaCorporativa()

        If Not String.IsNullOrEmpty(memoDireccion.value) Then
            With objServicioCorporativo
                .IdUsuario = CInt(Session("usxp001"))
                .FechaRegistro = dateFechaSolicitud.Date
                .FechaAsignacion = Now.Date
                .IdEstado = infoEstados.IdEstadoSiguiente
                .IdCiudad = cmbCiudadEntrega.Value
                .NombreCliente = txtNombreEmpresa.Text
                .IdentificacionCliente = txtIdentificacionCliente.Text
                .TelefonoContacto = txtTelefonoFijo.Text
                .NombreRepresentanteLegal = txtNombreRepresentante.Text
                .TelefonoRepresentanteLegal = txtTelefonoMovilRepresentante.Text
                .IdentificacionRepresentanteLegal = txtIdentificacionRepresentante.Text
                .PersonaContacto = txtPersonaAutorizada.Text
                .IdentificacionAutorizado = txtIdentificacionAutorizado.Text
                .CargoAutorizado = txtCargoPersonaAutorizada.Text
                .TelefonoAutorizado = txtTelefonoAutorizado.Text
                .Direccion = memoDireccion.value
                .DireccionEdicion = memoDireccion.DireccionEdicion
                .ObservacionDireccion = memoObservacionDireccion.Text
                .Barrio = txtBarrio.Text
                .IdGerencia = cmbGerencia.Value
                .IdCoordinador = cmbCoordinador.Value
                .IdConsultor = cmbConsultor.Value
                .ClienteClaro = rblClienteClaro.Value
                .IdFormaPago = CInt(cmbFormaPago.Value)
                .Observacion = memoObservaciones.Text
                .IdBodega = cmbBodega.Value
                .portacion = rblPortacion.Value
                resultado = .Registrar()
                If resultado.Valor = 20 Then
                    idServicio = .IdServicioMensajeria
                End If
            End With
        Else
            resultado.EstablecerMensajeYValor(11, "La dirección del servicio es requerida para registrar el servicio.")
        End If

        Return resultado
    End Function

    Private Function CancelarRegistro() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa

        With miServicio
            .IdUsuario = CInt(Session("usxp001"))
            resultado = .CancelarRegistro()
        End With

        Return resultado
    End Function

    Private Sub EnviarNotificacion(ByVal mensaje As String, ByVal idServicio As Integer)
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(idServicio)
        Dim notificador As New NotificacionEventosInventarioCEM
        Dim mensajeInicio As String = mensaje
        Dim mensajeFin As New ConfigValues("MENSAJE_FIN_CEM_CORPORATIVO")
        Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")
        Dim idBodega As Integer = miServicio.IdBodega

        With notificador
            .TipoNotificacion = AsuntoNotificacion.Tipo.Notificación_Creación_Servicio_Corporativo
            .InicioMensaje = mensajeInicio
            .FinMensaje = mensajeFin.ConfigKeyValue
            .FirmaMensaje = firmaMensaje.ConfigKeyValue
            .Titulo = "Notificación Creación Servicio Venta Corporativa"
            .Asunto = "Creación de servicio de tipo Venta Corporativa, con el identificador:  " & idServicio
            .NotificacionEvento(idBodega:=idBodega)
        End With
    End Sub

    Private Sub CargarDocumentosTemporales()
        Dim miDocumento As New DocumentoTemporalServicioMensajeria
        Dim dtDatos As New DataTable
        dtDatos = miDocumento.ConsultarDocumentosTemporales(CInt(Session("usxp001")), 0)
        Session("dtDocumento") = dtDatos
        With gvDatos
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Private Sub DatosBasicosDocumento(ByVal idDocumento As Integer)
        Dim miDocumento As New DocumentoTemporalServicioMensajeria(idDocumento)
        Session("idDocumento") = idDocumento
        With miDocumento
            lblIdDocumento.Text = .IdRegistro
            lblNombreDocumento.Text = .NombreDocumento
            lblNombreArchivo.Text = .NombreArchivo
        End With
    End Sub

    Private Sub DatosBasicosMin(ByVal msisdn As String)
        Dim miMsisdn As New MsisdnTemporalServicioMensajeria(msisdn, CInt(Session("usxp001")))

        ' Se cargan las regiones
        MetodosComunes.CargarComboDX(cmbRegion, CType(HerramientasMensajeria.ConsultaRegion(), DataTable), "idRegion", "codigo")

        With miMsisdn
            lblMsisdn.Text = .msisdn
            txtValorUnitario.Text = .PrecioUnitario
            If .PrecioEspecial.IndexOf("s") <> -1 Or .PrecioEspecial.IndexOf("S") <> -1 Then
                cmbPrecio.Value = 1
            Else
                cmbPrecio.Value = 2
            End If
            cmbRegion.Value = .IdRegion

            If Not String.IsNullOrEmpty(.MaterialEquipo) Then
                trEquipo.Visible = True
                trSim.Visible = False
                CargarMateriales()
                cmbMaterial.Value = .MaterialEquipo

                If .RequiereSim.IndexOf("s") <> -1 Or .RequiereSim.IndexOf("S") <> -1 Then
                    cmbRequiereSIM.Value = 1
                Else
                    cmbRequiereSIM.Value = 2
                End If
            Else
                trEquipo.Visible = False
                If Not String.IsNullOrEmpty(.TipoSim) Then
                    trSim.Visible = True
                    MetodosComunes.CargarComboDX(cmbTipoSim, CType(HerramientasMensajeria.ObtieneClasesSIM(), DataTable), "idClase", "nombre")
                    cmbTipoSim.Value = .IdTipoSim
                End If
            End If

        End With
    End Sub

    Private Sub EliminarDocumentosTemporales(ByVal idDocumento As Integer)
        Dim resultado As New ResultadoProceso
        Dim miDocumento As New DocumentoTemporalServicioMensajeria(idDocumento)
        Dim rutaEliminar As String = HttpContext.Current.Server.MapPath(miDocumento.RutaAlmacenamiento) & "\" & miDocumento.IdentificadorUnico.ToString()
        With miDocumento
            .IdRegistro = idDocumento
            resultado = .Eliminar()
        End With

        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
            If File.Exists(rutaEliminar) Then
                File.Delete(rutaEliminar)
            End If
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If

    End Sub

    Private Sub EditarMinesTemporales(ByVal msisdn As String)
        Dim miMsisdn As New MsisdnTemporalServicioMensajeria
        Dim resultado As New ResultadoProceso

        With miMsisdn
            .msisdn = msisdn
            .IdUsuario = CInt(Session("usxp001"))
            .IdRegion = cmbRegion.Value
            .PrecioUnitario = txtValorUnitario.Text.Trim
            .PrecioEspecial = cmbPrecio.Text
            If cmbTipoSim.Value > 0 Then .IdTipoSim = cmbTipoSim.Value
            If Not String.IsNullOrEmpty(cmbMaterial.Value) Then .MaterialEquipo = cmbMaterial.Value
            If Not String.IsNullOrEmpty(cmbRequiereSIM.Text) Then .RequiereSim = cmbRequiereSIM.Text
            resultado = .Actualizar()
        End With

        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If

    End Sub

    Private Sub CargarMateriales()
        Dim listaMaterial As New Productos.MaterialColeccion
        Dim dtMaterial As DataTable
        If Session("dtMateriales") Is Nothing Then
            With listaMaterial
                .IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                dtMaterial = .GenerarDataTable()
                Session("dtMateriales") = dtMaterial
            End With
        Else
            dtMaterial = Session("dtMateriales")
        End If
        MetodosComunes.CargarComboDX(cmbMaterial, dtMaterial, "Material", "ReferenciaCliente")
    End Sub

    Private Sub CargarDireccion()
        If Not String.IsNullOrEmpty(memoDireccion.DireccionEdicion) Then
            Dim direccion As String = memoDireccion.DireccionEdicion
            memoDireccion.value = direccion.Replace("|", " ")
            memoDireccion.DireccionEdicion = memoDireccion.DireccionEdicion
        End If
    End Sub

#End Region

End Class