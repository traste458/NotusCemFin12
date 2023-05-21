Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports System.IO

Public Class GestionDocumentosServicioSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer

#End Region

#Region "Propiedades"

    Public Property IdServicio As Integer
        Get
            If Session("idServicio") IsNot Nothing Then _idServicio = Session("idServicio")
            Return _idServicio
        End Get
        Set(value As Integer)
            Session("idServicio") = value
            _idServicio = value
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
                .setTitle("Gestión Documentos Servicio SIEMBRA")
            End With
        End If
    End Sub

    Private Sub cpDocumentos_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpDocumentos.Callback
        Try
            Dim arrParametros() As String = e.Parameter.Split("|")
            Select Case arrParametros(0)
                Case "consultar"
                    Integer.TryParse(arrParametros(1), IdServicio)
                    BuscarServicio(IdServicio)

                Case "recargarFormulario"
                    txtNombreDocumento.Text = String.Empty
                    BuscarServicio(idServicio:=IdServicio)
                    Threading.Thread.Sleep(1000)

                Case "reimprimir"
                    ReimprimirFormatoPrestamo(IdServicio)
                    BuscarServicio(idServicio:=IdServicio)

                Case "legalizar"
                    Legalizar(IdServicio)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar procesar los documentos: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub ucCargueArchivo_FileUploadComplete(sender As Object, e As DevExpress.Web.FileUploadCompleteEventArgs) Handles ucCargueArchivo.FileUploadComplete
        Dim respuesta As ResultadoProceso
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)
            Dim objDocServicio As New DocumentoServicioMensajeria()
            With objDocServicio
                .IdServicio = IdServicio
                .NombreDocumento = txtNombreDocumento.Value
                .NombreArchivo = e.UploadedFile.FileName
                .RutaAlmacenamiento = "Archivos\Servicio" & IdServicio.ToString().PadLeft(8, "0")
                .TipoContenido = e.UploadedFile.ContentType
                .Tamanio = e.UploadedFile.ContentLength
                .IdentificadorUnico = Guid.NewGuid().ToString
                .Archivo = e.UploadedFile.FileContent
                respuesta = .Registrar(idUsuario)
            End With

            If respuesta.Valor = 0 Then
                miEncabezado.showSuccess(respuesta.Mensaje)
            Else
                miEncabezado.showWarning(respuesta.Mensaje)
            End If
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

    Private Sub gvDocumentos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDocumentos.DataBinding
        If Session("objDatosDocu") IsNot Nothing Then gvDocumentos.DataSource = Session("objDatosDocu")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarServicio(ByVal idServicio As Integer)
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(idServicio:=idServicio)
            If objServicio.Registrado Then
                VisualizarDocumentos(True)
                HabilitarMOdificacion(objServicio.IdEstado = Enumerados.EstadoServicio.Entregado)
                EnlazarDocumentos(idServicio)
            Else
                VisualizarDocumentos(False)
                miEncabezado.showWarning("El número de servicio no se encuentra registrado en el sistema.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar buscar servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub VisualizarDocumentos(ByVal visualizar As Boolean)
        rpDocumentos.ClientVisible = visualizar
        rpFormatos.ClientVisible = visualizar
    End Sub

    Private Sub EnlazarDocumentos(idServicio As Integer)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            With objDocumentos
                .IdServicio = idServicio
                .CargarDatos()
            End With

            With gvDocumentos
                .DataSource = objDocumentos
                Session("objDatosDocu") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar los documentos: " & ex.Message)
        End Try
    End Sub

    Private Sub ReimprimirFormatoPrestamo(ByVal idServicio As Integer)
        Dim resultado As ResultadoProceso
        Try
            With pcDocumentoCierre
                .ContentUrl = "~/MensajeriaEspecializada/Reportes/VisorFormatoPrestamoSIEMBRA.aspx?id=" & idServicio.ToString & "&reImpresion=1"
                .ShowOnPageLoad = True
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al cerrar el despacho: " & ex.Message)
        End Try
    End Sub

    Private Sub Legalizar(ByVal idServicio As Integer)
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(idServicio:=idServicio)
            Dim respuesta As ResultadoProceso = objServicio.Legalizar(CInt(Session("usxp001")))
            If respuesta.Valor = 0 Then
                miEncabezado.showSuccess(respuesta.Mensaje)
            Else
                miEncabezado.showWarning(respuesta.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar legalizar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub HabilitarMOdificacion(ByVal habilitar As Boolean)
        btnLegalizar.ClientEnabled = habilitar
        ucCargueArchivo.Enabled = habilitar
        txtNombreDocumento.Enabled = habilitar
        btnUpload.ClientEnabled = habilitar
    End Sub

#End Region

End Class