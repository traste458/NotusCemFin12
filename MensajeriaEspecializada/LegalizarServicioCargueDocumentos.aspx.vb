Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.IO
Imports System.Collections.Generic

Public Class LegalizarServicioCargueDocumentos
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idTipoServicio As Integer
    Private _idServicio As Long
    Private _numRadicado As Long
    Private _existeError As Boolean = False

#End Region

#Region "Propiedades"

    Public Property IdTipoServicio As Integer
        Get
            If Session("idTipoServicio") IsNot Nothing Then _idTipoServicio = Session("idTipoServicio")
            Return _idTipoServicio
        End Get
        Set(value As Integer)
            Session("idTipoServicio") = value
            _idTipoServicio = value
        End Set
    End Property

    Public Property IdServicio As Long
        Get
            If Session("idServicio") IsNot Nothing Then _idServicio = Session("idServicio")
            Return _idServicio
        End Get
        Set(value As Long)
            Session("idServicio") = value
            _idServicio = value
        End Set
    End Property

    Public Property Radicado As Long
        Get
            If Session("numRadicado") IsNot Nothing Then _numRadicado = Session("numRadicado")
            Return _numRadicado
        End Get
        Set(value As Long)
            Session("numRadicado") = value
            _numRadicado = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Legalización de Servicios Cargue de Documentos")
            End With
            Session("objDatosDocu") = Nothing
            CargarTipoServicio()
        End If
    End Sub

    Private Sub cpDocumentos_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpDocumentos.Callback
        Try
            Dim arrParametros() As String = e.Parameter.Split("|")
            Select Case arrParametros(0)
                Case "ActualizarDocumentos"
                    For i As Integer = 0 To CType(Session("dtDocumentosReq"), DataTable).Rows.Count - 1
                        CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("cantidadLeida") = 0
                    Next
                    ActualizarDocumentosRequeridos()
                    ValidarInformacion()
                    VisualizarDocumentos(True)
                    CType(sender, ASPxCallbackPanel).JSProperties("cpPosicion") = "abajo"
                Case "consultar"
                    Integer.TryParse(arrParametros(2), IdTipoServicio)
                    Select Case IdTipoServicio
                        Case Enumerados.TipoServicio.Siembra
                            Long.TryParse(arrParametros(1), IdServicio)
                            BuscarServicio(numeroServicio:=IdServicio)
                        Case Enumerados.TipoServicio.VentaWeb
                            Long.TryParse(arrParametros(1), Radicado)
                            BuscarServicio(numeroServicio:=Radicado)
                        Case Enumerados.TipoServicio.VentaCorporativa
                            Long.TryParse(arrParametros(1), IdServicio)
                            BuscarServicio(numeroServicio:=IdServicio)
                        Case Enumerados.TipoServicio.CampañaClaroFijo
                            Long.TryParse(arrParametros(1), IdServicio)
                            BuscarServicio(numeroServicio:=IdServicio)
                        Case Else
                            If rblTipoServicio.Value = 99 Then
                                CType(sender, ASPxCallbackPanel).JSProperties("cpPosicion") = "abajo"
                                Session("rblTipoServicio") = rblTipoServicio.Value
                                Long.TryParse(arrParametros(1), IdServicio)
                                BuscarServicio(numeroServicio:=IdServicio)
                                EnlazarDocumentos(IdServicio)
                                If Session("Existe") = 1 Then
                                    rblTipoServicio.Enabled = False
                                    cmbDescripcion.Enabled = False
                                    txtNumeroServicio.Enabled = False
                                    btnBuscar.Enabled = False
                                Else
                                    rblTipoServicio.Enabled = True
                                    cmbDescripcion.Enabled = True
                                    txtNumeroServicio.Enabled = True
                                    btnBuscar.Enabled = True
                                End If
                            Else
                                miEncabezado.showWarning("No se encontro configuración para el tipo de servicio seleccionado.")
                            End If
                    End Select
                Case "recargarFormulario"
                    Select Case IdTipoServicio
                        Case Enumerados.TipoServicio.Siembra
                            BuscarServicio(numeroServicio:=IdServicio)
                        Case Enumerados.TipoServicio.VentaWeb
                            BuscarServicio(numeroServicio:=Radicado)
                        Case Enumerados.TipoServicio.VentaCorporativa
                            BuscarServicio(numeroServicio:=IdServicio)
                        Case Enumerados.TipoServicio.CampañaClaroFijo
                            BuscarServicio(numeroServicio:=IdServicio)
                        Case Else
                            If Session("rblTipoServicio") = "99" Then
                                BuscarServicio(numeroServicio:=IdServicio)
                                CType(sender, ASPxCallbackPanel).JSProperties("cpPosicion") = "abajo"
                                If Session("objDatosDocu") IsNot Nothing AndAlso CType(Session("objDatosDocu"), DataTable).Rows.Count > 0 Then
                                    With gvDocumentos
                                        .DataSource = CType(Session("objDatosDocu"), DataTable)
                                        .DataBind()
                                    End With
                                End If
                                ActualizaDatosGrilla()
                                ActualizarDocumentosRequeridos()
                                If Session("Existe") = 1 Then
                                    rblTipoServicio.Enabled = False
                                    cmbDescripcion.Enabled = False
                                    txtNumeroServicio.Enabled = False
                                    btnBuscar.Enabled = False
                                Else
                                    rblTipoServicio.Enabled = True
                                    cmbDescripcion.Enabled = True
                                    txtNumeroServicio.Enabled = True
                                    btnBuscar.Enabled = True
                                End If
                            Else
                                miEncabezado.showWarning("No se encontro configuración para el tipo de servicio seleccionado.")
                            End If
                    End Select
                    Threading.Thread.Sleep(1000)
                Case "MesaControl"
                    Select Case IdTipoServicio
                        Case Enumerados.TipoServicio.Siembra
                            MesaControl(IdServicio)
                        Case Enumerados.TipoServicio.VentaWeb
                            MesaControl(Radicado)
                        Case Enumerados.TipoServicio.VentaCorporativa
                            MesaControl(IdServicio)
                        Case Enumerados.TipoServicio.CampañaClaroFijo
                            MesaControl(IdServicio)
                        Case Else
                            If Session("rblTipoServicio") = "99" Then
                                MesaControl(IdServicio)
                                If _existeError Then
                                    VisualizarDocumentos(True)
                                End If
                                CType(sender, ASPxCallbackPanel).JSProperties("cpPosicion") = "arriba"
                            Else
                                miEncabezado.showWarning("No se encontro configuración para el tipo de servicio seleccionado.")
                            End If
                    End Select
                Case "legalizar"
                    Select Case IdTipoServicio
                        Case Enumerados.TipoServicio.Siembra
                            Legalizar(IdServicio)

                        Case Enumerados.TipoServicio.VentaWeb
                            Legalizar(Radicado)

                        Case Enumerados.TipoServicio.VentaCorporativa
                            Legalizar(IdServicio)

                        Case Enumerados.TipoServicio.CampañaClaroFijo
                            Legalizar(IdServicio)
                        Case Else
                            If Session("rblTipoServicio") = "99" Then
                                Legalizar(IdServicio)
                                CType(sender, ASPxCallbackPanel).JSProperties("cpPosicion") = "arriba"
                            Else
                                miEncabezado.showWarning("No se encontro configuración para el tipo de servicio seleccionado.")
                            End If
                    End Select
                Case "Eliminar"
                    EliminarDocumento(arrParametros(1))
                    VisualizarDocumentos(True)
                Case "ConsultarDocumentos"
                    CType(sender, ASPxCallbackPanel).JSProperties("cpPosicion") = "abajo"
                    Long.TryParse(arrParametros(1), IdServicio)
                    ConsultarServicio(numeroServicio:=IdServicio)
                    txtNumeroServicio.Enabled = True
                    btnBuscar.Enabled = True
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar procesar los documentos: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub ucCargueArchivo_FilesUploadComplete(sender As Object, e As FilesUploadCompleteEventArgs) Handles ucCargueArchivo.FilesUploadComplete
        Try
            Dim objDocServicio As New DocumentoServicioMensajeria()
            Dim dt As DataTable
            With objDocServicio
                For i As Integer = 0 To ucCargueArchivo.UploadedFiles.Length - 1
                    If Session("objDatosDocu") Is Nothing Then
                        .NombreArchivo = ucCargueArchivo.UploadedFiles(i).FileName
                        .TipoContenido = ucCargueArchivo.UploadedFiles(i).ContentType
                        .FechaRecepcion = Date.Now.ToShortDateString
                        .Archivo1 = ucCargueArchivo.UploadedFiles(i).FileBytes 'ucCargueArchivo.UploadedFiles(i).FileContent
                        .IdentificadorUnico = Guid.NewGuid().ToString
                        .Tamanio = ucCargueArchivo.UploadedFiles(i).ContentLength
                        .RutaAlmacenamiento = "Archivos\Servicio" & IdServicio.ToString().PadLeft(8, "0")
                        .Extension = ucCargueArchivo.UploadedFiles(i).FileName.ToString.Split(".").GetValue(1)
                        dt = .InsertarArchivo()
                        Session("objDatosDocu") = dt
                    Else
                        dt = CType(Session("objDatosDocu"), DataTable)
                        Dim dr As DataRow = dt.NewRow
                        With dr
                            .Item("IdDocumento") = dt.Rows.Count + 1
                            .Item("NombreArchivo") = ucCargueArchivo.UploadedFiles(i).FileName
                            .Item("TipoContenido") = ucCargueArchivo.UploadedFiles(i).ContentType
                            .Item("FechaRecepcion") = Date.Now.ToShortDateString
                            '.Item("Archivo") = ucCargueArchivo.UploadedFiles(i).FileContent
                            'Dim arrContenido As Byte() = New Byte(ucCargueArchivo.UploadedFiles(i).FileContent.Length - 1) {}
                            .Item("Archivo1") = ucCargueArchivo.UploadedFiles(i).FileBytes
                            .Item("identificadorUnico") = Guid.NewGuid().ToString
                            .Item("Tamanio") = ucCargueArchivo.UploadedFiles(i).ContentLength
                            .Item("RutaAlmacenamiento") = "Archivos\Servicio" & IdServicio.ToString().PadLeft(8, "0")
                            .Item("Extension") = ucCargueArchivo.UploadedFiles(i).FileName.ToString.Split(".").GetValue(1)
                        End With
                        CType(Session("objDatosDocu"), DataTable).Rows.Add(dr)
                        CType(Session("objDatosDocu"), DataTable).AcceptChanges()
                    End If
                Next
            End With
            ucCargueArchivo.Enabled = False
            btnUpload.ClientEnabled = False
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar el archivo: " & ex.Message)
        End Try
        CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim extensionArchivo As String
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            extensionArchivo = Path.GetExtension(CStr(gvDocumentos.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreArchivo"))).ToLower()

            'Link de Visualización de Archivo
            With linkVer
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

                Select Case extensionArchivo
                    Case ".pdf"
                        .ImageUrl = "~/images/pdf.png"
                    Case ".jpg", ".tiff"
                        .ImageUrl = "~/images/Paint.gif"
                    Case Else
                        .ImageUrl = "~/images/view.png"
                End Select
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init_Eliminar(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkEliminar.ClientSideEvents.Click = lnkEliminar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

            If Session("estadoServicio") = Enumerados.EstadoServicio.Legalizado Then
                lnkEliminar.Visible = False
            Else
                lnkEliminar.Visible = True
            End If

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDocumentos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDocumentos.DataBinding
        If Session("objDatosDocu") IsNot Nothing Then gvDocumentos.DataSource = Session("objDatosDocu")
    End Sub

    Private Sub gvDocumentosRequeridos_DataBinding(sender As Object, e As EventArgs) Handles gvDocumentosRequeridos.DataBinding
        If Session("dtDocumentosReq") IsNot Nothing Then gvDocumentosRequeridos.DataSource = Session("dtDocumentosReq")
    End Sub

    Protected Sub Link_Init_Consulta(ByVal sender As Object, ByVal e As EventArgs)
        Dim extensionArchivo As String
        Try
            Dim linkVerConsulta As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVerConsulta.NamingContainer, GridViewDataItemTemplateContainer)

            extensionArchivo = Path.GetExtension(CStr(gvDocumentosConsulta.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreArchivo"))).ToLower()

            'Link de Visualización de Archivo
            With linkVerConsulta
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

                Select Case extensionArchivo
                    Case ".pdf"
                        .ImageUrl = "~/images/pdf.png"
                    Case ".jpg", ".tiff"
                        .ImageUrl = "~/images/Paint.gif"
                    Case Else
                        .ImageUrl = "~/images/view.png"
                End Select
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDocumentosConsulta_DataBinding(sender As Object, e As System.EventArgs) Handles gvDocumentosConsulta.DataBinding
        If Session("objDatosConsulta") IsNot Nothing Then gvDocumentosConsulta.DataSource = Session("objDatosConsulta")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarTipoServicio()
        ' Se cargan los tipos de servicio
        With cmbDescripcion
            .DataSource = New TipoServicioColeccion(activo:=True, esFinanciero:=True).GenerarDataTable()
            .ValueField = "idTipoServicio"
            .TextField = "nombre"
            Session("dtServicios") = .DataSource
            .DataBind()
        End With
    End Sub

    Private Sub BuscarServicio(ByVal numeroServicio As Long)
        Try
            Select Case IdTipoServicio
                Case Enumerados.TipoServicio.Siembra
                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=numeroServicio)
                    If objServicio.Registrado Then
                        VisualizarDocumentos(True)
                        HabilitarModificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Entregado, objServicio.Estado)
                        EnlazarDocumentos(numeroServicio)
                    Else
                        VisualizarDocumentos(False)
                        miEncabezado.showWarning("El número de servicio no se encuentra registrado en el sistema.")
                    End If

                Case Enumerados.TipoServicio.VentaWeb
                    Dim objServicio As New ServicioMensajeriaVentaWeb(numeroRadicado:=numeroServicio)
                    If objServicio.Registrado Then
                        Long.TryParse(objServicio.IdServicioMensajeria, IdServicio)
                        VisualizarDocumentos(True)
                        HabilitarModificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Entregado, objServicio.Estado)
                        EnlazarDocumentos(numeroServicio)
                    Else
                        VisualizarDocumentos(False)
                        miEncabezado.showWarning("El número de radicado no se encuentra registrado en el sistema.")
                    End If

                Case Enumerados.TipoServicio.VentaCorporativa
                    Dim objServicio As New ServicioMensajeriaVentaCorporativa(IdServicio:=numeroServicio)
                    If objServicio.Registrado Then
                        VisualizarDocumentos(True)
                        If objServicio.IdTipoServicio = Enumerados.TipoServicio.VentaCorporativa Then
                            HabilitarModificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Entregado, objServicio.Estado)
                        ElseIf objServicio.IdTipoServicio = Enumerados.TipoServicio.VentaCorporativaPrestamo Then
                            HabilitarModificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Facturado, objServicio.Estado)
                        End If
                        EnlazarDocumentos(numeroServicio)
                    Else
                        VisualizarDocumentos(False)
                        miEncabezado.showWarning("El número de servicio no se encuentra registrado en el sistema.")
                    End If

                Case Enumerados.TipoServicio.CampañaClaroFijo
                    Dim objServicio As New ServicioMensajeria(IdServicio:=numeroServicio)
                    If objServicio.Registrado Then
                        VisualizarDocumentos(True)
                        HabilitarModificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Entregado, objServicio.Estado)
                        EnlazarDocumentos(numeroServicio)
                    Else
                        VisualizarDocumentos(False)
                        miEncabezado.showWarning("El número de servicio no se encuentra registrado en el sistema.")
                    End If
                Case Else
                    If Session("rblTipoServicio") = "99" Then
                        Dim objServicio As New ServicioMensajeria(IdServicio:=numeroServicio)
                        If objServicio.Registrado Then
                            CargarDocumentosRequeridos(numeroServicio)
                            VisualizarDocumentos(True)
                            Session("Existe") = 1
                            Session("estadoServicio") = objServicio.IdEstado
                            HabilitarModificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Entregado Or objServicio.IdEstado = Enumerados.EstadoServicio.RecuperacionMesaControl, objServicio.Estado)
                        Else
                            VisualizarDocumentos(False)
                            Session("Existe") = 0
                            miEncabezado.showWarning("El número de servicio no se encuentra registrado en el sistema.")
                        End If
                    End If
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar buscar radicado: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDocumentosRequeridos(ByVal _numeroServicio As String)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            Dim dtDocumentosReq As DataTable
            With objDocumentos
                .Radicado = _numeroServicio
                dtDocumentosReq = .CargarDocumentosRequeridos()
            End With

            With gvDocumentosRequeridos
                .DataSource = dtDocumentosReq
                Session("dtDocumentosReq") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar los documentos requeridos: " & ex.Message)
        End Try
    End Sub

    Private Sub VisualizarDocumentos(ByVal visualizar As Boolean)
        rpDocumentos.ClientVisible = visualizar
        If Session("rblTipoServicio") = "99" Then
            rpDocumentosRequeridos.ClientVisible = visualizar
        End If
    End Sub

    Private Sub EnlazarDocumentos(numeroServicio As Long)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            Dim dtInformacion As DataTable
            With objDocumentos
                Select Case IdTipoServicio
                    Case Enumerados.TipoServicio.Siembra
                        .IdServicio = numeroServicio
                        .CargarDatos()
                    Case Enumerados.TipoServicio.VentaWeb
                        .Radicado = numeroServicio
                        .CargarDatos()
                    Case Enumerados.TipoServicio.VentaCorporativa
                        .IdServicio = numeroServicio
                        .CargarDatos()
                    Case Enumerados.TipoServicio.CampañaClaroFijo
                        .IdServicio = numeroServicio
                        .CargarDatos()
                    Case Else
                        If Session("rblTipoServicio") = "99" Then
                            .IdServicio = numeroServicio
                            dtInformacion = .GenerarDataTable()
                        End If
                End Select
            End With
            If Session("rblTipoServicio") <> "99" Then
                If objDocumentos.Count > 0 Then
                    With gvDocumentos
                        .DataSource = objDocumentos
                        Session("objDatosDocu") = .DataSource
                        .DataBind()
                    End With
                ElseIf Session("objDatosDocu") IsNot Nothing AndAlso CType(Session("objDatosDocu"), DataTable).Rows.Count > 0 Then
                    With gvDocumentos
                        .DataSource = CType(Session("objDatosDocu"), DataTable)
                        .DataBind()
                    End With
                End If
            Else
                If dtInformacion.Rows.Count > 0 Then
                    With gvDocumentos
                        .DataSource = dtInformacion
                        Session("objDatosDocu") = .DataSource
                        .DataBind()
                    End With
                    ActualizaDatosGrilla()
                ElseIf Session("objDatosDocu") IsNot Nothing AndAlso CType(Session("objDatosDocu"), DataTable).Rows.Count > 0 Then
                    With gvDocumentos
                        .DataSource = CType(Session("objDatosDocu"), DataTable)
                        .DataBind()
                    End With
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar enlazar los documentos: " & ex.Message)
        End Try
    End Sub

    Protected Sub cbProduct_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim cb As ASPxComboBox = TryCast(sender, ASPxComboBox)
        Dim container As GridViewDataItemTemplateContainer = TryCast(cb.NamingContainer, GridViewDataItemTemplateContainer)
        cb.DataSource = CType(Session("dtDocumentosReq"), DataTable)
        cb.ValueField = "idProducto"
        cb.TextField = "nombre"
        cb.DataBind()
    End Sub

    Private Sub MesaControl(ByVal numeroServicio As Long)
        Try
            If Session("rblTipoServicio") = "99" Then
                ValidarInformacionAlmacenamiento()
                If Not _existeError Then
                    Dim objDocumento As New DocumentoServicioMensajeria
                    With objDocumento
                        .TablaArchivos = CType(Session("objDatosDocu"), DataTable)
                        .IdServicio = txtNumeroServicio.Text.Trim
                        .IdUsuarioRecepcion = Session("usxp001")
                        If (Session("estadoServicio") <> Enumerados.EstadoServicio.Legalizado And Session("estadoServicio") <> Enumerados.EstadoServicio.RecuperacionMesaControl) Then
                            .RegistrarDocumentos()
                        Else
                            .ActualizarDocumentos()
                        End If
                    End With
                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=txtNumeroServicio.Text.Trim)
                    Dim respuesta As ResultadoProceso
                    With objServicio
                        respuesta = objServicio.MesaControl(CInt(Session("usxp001")))
                    End With
                    Dim ruta As String = String.Empty
                    Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                    If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                        ruta = rutaAlmacenaArchivo.ConfigKeyValue
                    Else
                        Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                    End If

                    If Not Directory.Exists(ruta) Then
                        Directory.CreateDirectory(ruta)
                    End If

                    If respuesta.Valor = 0 Then
                        If Directory.Exists(ruta & CType(Session("objDatosDocu"), DataTable).Rows(0).Item("RutaAlmacenamiento")) Then
                            Directory.Delete(ruta & CType(Session("objDatosDocu"), DataTable).Rows(0).Item("RutaAlmacenamiento"), True)
                        End If
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar legalizar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub Legalizar(ByVal numeroServicio As Long)
        Try
            Select Case IdTipoServicio
                Case Enumerados.TipoServicio.Siembra
                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=numeroServicio)
                    Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
                    If respuesta.Valor = 0 Then
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If

                Case Enumerados.TipoServicio.VentaWeb
                    Dim objServicio As New ServicioMensajeriaVentaWeb(numeroRadicado:=numeroServicio)
                    Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
                    If respuesta.Valor = 0 Then
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If

                Case Enumerados.TipoServicio.VentaCorporativa
                    Dim objServicio As New ServicioMensajeriaVentaCorporativa(IdServicio:=numeroServicio)
                    Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
                    If respuesta.Valor = 0 Then
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If

                Case Enumerados.TipoServicio.CampañaClaroFijo
                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=numeroServicio)
                    Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
                    If respuesta.Valor = 0 Then
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If
                Case Enumerados.TipoServicio.ServiciosFinancierosDavivienda
                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=numeroServicio)
                    Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
                    If respuesta.Valor = 0 Then
                        respuesta = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, numeroServicio, Enumerados.EstadoServicio.Legalizado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If
                Case Enumerados.TipoServicio.DaviviendaSamsung
                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=numeroServicio)
                    Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
                    If respuesta.Valor = 0 Then
                        respuesta = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, numeroServicio, Enumerados.EstadoServicio.Legalizado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                        miEncabezado.showSuccess(respuesta.Mensaje)
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If
                Case Else
                    If Session("rblTipoServicio") = "99" Then
                        ValidarInformacionAlmacenamiento()
                        If Not _existeError Then
                            Dim objDocumento As New DocumentoServicioMensajeria
                            With objDocumento
                                .TablaArchivos = CType(Session("objDatosDocu"), DataTable)
                                .IdServicio = txtNumeroServicio.Text.Trim
                                .IdUsuarioRecepcion = Session("usxp001")
                                If (Session("estadoServicio") <> Enumerados.EstadoServicio.Legalizado And Session("estadoServicio") <> Enumerados.EstadoServicio.RecuperacionMesaControl) Then
                                    .RegistrarDocumentos()
                                Else
                                    .ActualizarDocumentos()
                                End If
                            End With
                            Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=txtNumeroServicio.Text.Trim)
                            Dim respuesta As ResultadoProceso
                            With objServicio
                                respuesta = objServicio.Legalizar(CInt(Session("usxp001")))
                            End With
                            If respuesta.Valor = 0 Then
                                Dim ruta As String = String.Empty
                                Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                                If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                                    ruta = rutaAlmacenaArchivo.ConfigKeyValue
                                Else
                                    Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                                End If

                                
                                If Directory.Exists(ruta & CType(Session("objDatosDocu"), DataTable).Rows(0).Item("RutaAlmacenamiento")) Then
                                    Directory.Delete(ruta & CType(Session("objDatosDocu"), DataTable).Rows(0).Item("RutaAlmacenamiento"), True)
                                End If
                                miEncabezado.showSuccess(respuesta.Mensaje)
                            Else
                                miEncabezado.showWarning(respuesta.Mensaje)
                            End If
                        End If
                    End If
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar legalizar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub HabilitarModificacion(ByVal habilitar As Boolean, ByVal EstadoActual As String)
        btnLegalizar.ClientEnabled = habilitar
        btnRecuperacion.ClientEnabled = habilitar
        ucCargueArchivo.Enabled = habilitar
        btnUpload.ClientEnabled = habilitar
        If habilitar = False Then
            miEncabezado.showWarning("Este servicio se encuentra en un estado no valido: " + EstadoActual)
        End If
    End Sub

    Private Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function

    Private Sub ActualizarDocumentosRequeridos()
        Try
            Dim grilla As New ASPxGridView
            grilla = gvDocumentos
            Dim dtvalores As New DataTable
            dtvalores.Columns.Add("valor", GetType(Double))
            dtvalores.AcceptChanges()
            Dim drValores As DataRow
            For i As Integer = 0 To grilla.VisibleRowCount - 1
                Dim valTipoProducto As ASPxComboBox = grilla.FindRowCellTemplateControl(i, grilla.Columns("Tipo Producto"), "cmbTipoProd")
                If valTipoProducto.Value IsNot Nothing Then
                    drValores = dtvalores.NewRow
                    drValores.Item("valor") = valTipoProducto.Value
                    dtvalores.Rows.Add(drValores)
                End If
            Next
            For i As Integer = 0 To CType(Session("dtDocumentosReq"), DataTable).Rows.Count - 1
                Dim dr() As DataRow = dtvalores.Select("valor =" & CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("idProducto"))
                If dr.Length > 0 Then
                    CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("cantidadLeida") = CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("cantidadLeida") + dr.Length
                End If
                CType(Session("dtDocumentosReq"), DataTable).AcceptChanges()
            Next
            With gvDocumentosRequeridos
                .DataSource = CType(Session("dtDocumentosReq"), DataTable)
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Actualizar los documentos requeridos: " & ex.Message)
        End Try
    End Sub

    Private Sub ValidarInformacion()
        Try
            Dim grilla As New ASPxGridView
            grilla = gvDocumentos
            Dim drValores As DataRow
            For i As Integer = 0 To grilla.VisibleRowCount - 1
                Dim valnombre As ASPxTextBox = grilla.FindRowCellTemplateControl(i, grilla.Columns("Nombre del Documento"), "txtNombreDocumento")
                Dim valTipoProducto As ASPxComboBox = grilla.FindRowCellTemplateControl(i, grilla.Columns("Tipo Producto"), "cmbTipoProd")
                Dim valDocumento As Integer = i + 1
                Dim dt As DataTable
                dt = CType(Session("objDatosDocu"), DataTable)
                For a As Integer = 0 To dt.Rows.Count - 1
                    If dt.Rows(a).Item("idDocumento") = valDocumento Then
                        dt.Rows(a).Item("NombreDocumento") = valnombre.Text
                        If valTipoProducto.Value IsNot Nothing Then
                            dt.Rows(a).Item("idProducto") = valTipoProducto.Value
                        End If
                        dt.AcceptChanges()
                        Exit For
                    End If
                Next
                Session("objDatosDocu") = dt
            Next
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Validar la Informacion: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarDocumento(ByVal _idDocumento As Integer)
        Try
            ValidarInformacion()
            Dim dt As DataTable
            dt = CType(Session("objDatosDocu"), DataTable)
            For i As Integer = 0 To dt.Rows.Count - 1
                If dt.Rows(i).Item("IdDocumento") = _idDocumento Then
                    dt.Rows(i).Delete()
                    dt.AcceptChanges()
                    Exit For
                End If
            Next
            For a As Integer = 0 To dt.Rows.Count - 1
                dt.Rows(a).Item("IdDocumento") = a + 1
            Next
            With gvDocumentos
                .DataSource = dt
                Session("objDatosDocu") = .DataSource
                .DataBind()
            End With
            ActualizarDocumentosRequeridosEliminacion()
            ActualizaDatosGrilla()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar eliminar el documento: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarDocumentosRequeridosEliminacion()
        Try
            Dim dtValores As DataTable = CType(Session("objDatosDocu"), DataTable)
            For i As Integer = 0 To CType(Session("dtDocumentosReq"), DataTable).Rows.Count - 1
                CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("cantidadLeida") = 0
                Dim dr() As DataRow = dtValores.Select("IdProducto =" & CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("idProducto"))
                If dr.Length > 0 Then
                    CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("cantidadLeida") = CType(Session("dtDocumentosReq"), DataTable).Rows(i).Item("cantidadLeida") + dr.Length
                End If
                CType(Session("dtDocumentosReq"), DataTable).AcceptChanges()
            Next
            With gvDocumentosRequeridos
                .DataSource = CType(Session("dtDocumentosReq"), DataTable)
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Actualizar los documentos requeridos: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizaDatosGrilla()
        Try
            Dim grilla As New ASPxGridView
            Dim valIdProducto As Integer
            grilla = gvDocumentos
            For i As Integer = 0 To grilla.VisibleRowCount - 1
                Dim valnombre As ASPxTextBox = grilla.FindRowCellTemplateControl(i, grilla.Columns("Nombre del Documento"), "txtNombreDocumento")
                Dim valTipoProducto As ASPxComboBox = grilla.FindRowCellTemplateControl(i, grilla.Columns("Tipo Producto"), "cmbTipoProd")
                Dim valIdDocumento As Integer = grilla.GetDataRow(i).Item("idDocumento")
                If grilla.GetDataRow(i).Item("idProducto").ToString.Trim <> "" Then
                    valIdProducto = grilla.GetDataRow(i).Item("idProducto")
                    Dim drProducto() As DataRow = CType(Session("dtDocumentosReq"), DataTable).Select("idProducto = " & valIdProducto)
                    If drProducto.Length > 0 Then
                        valTipoProducto.Value = drProducto(0).Item("idProducto")
                        valTipoProducto.Text = drProducto(0).Item("nombre")
                    End If
                End If

                Dim drDocumento = CType(Session("objDatosDocu"), DataTable).Select("idDocumento = " & valIdDocumento)
                If drDocumento.Length > 0 Then
                    If drDocumento(0).Item("NombreDocumento").ToString.Trim <> "" Then
                        valnombre.Text = drDocumento(0).Item("NombreDocumento")
                    End If
                End If
            Next
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Actualizar los datos de la grilla: " & ex.Message)
        End Try
    End Sub

    Private Sub ValidarInformacionAlmacenamiento()
        Try
            _existeError = False
            For i As Integer = 0 To CType(Session("objDatosDocu"), DataTable).Rows.Count - 1
                Dim valNombre As String = CType(Session("objDatosDocu"), DataTable).Rows(i).Item("NombreDocumento").ToString
                Dim valTipoProducto As String = CType(Session("objDatosDocu"), DataTable).Rows(i).Item("IdProducto").ToString
                If valNombre.Trim = "" Or valTipoProducto = "" Then
                    _existeError = True
                    miEncabezado.showWarning("Falta completar información de los documentos cargados")
                    Exit For
                Else
                    _existeError = False
                End If
            Next
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Validar la Informacion: " & ex.Message)
        End Try
    End Sub

    Private Sub ConsultarServicio(ByVal numeroServicio As Long)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            Dim dtInformacion As DataTable
            With objDocumentos
                .IdServicio = numeroServicio
                .Consulta = 1
                dtInformacion = .GenerarDataTable()
            End With

            If dtInformacion IsNot Nothing And dtInformacion.Rows.Count > 0 Then
                With gvDocumentosConsulta
                    .DataSource = dtInformacion
                    Session("objDatosConsulta") = .DataSource
                    .DataBind()
                End With
                rpDocumentosConsulta.ClientVisible = True
            Else
                miEncabezado.showWarning("No se encontro información para el número de servicio consultado.")
                rpDocumentosConsulta.ClientVisible = False
            End If

        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar enlazar los documentos: " & ex.Message)
        End Try
    End Sub

#End Region

End Class