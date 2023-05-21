Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports DevExpress.Web
Imports System.IO

Public Class ModificacionDocumentosCEM
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Modificación Documentos Servicio")
            End With
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        arrayAccion = e.Parameter.Split(":")
        Try
            Select Case arrayAccion(0)
                Case "BuscarServicio"
                    Session("idServicio") = txtServicio.Text.Trim
                    BuscarDocumentosServicio(CInt(Session("idServicio")))
                Case "CargueServicio"
                    BuscarDocumentosServicio(CInt(Session("idServicio")))
                    miEncabezado.showSuccess(Session("mensaje"))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim extensionArchivo As String
        Dim esEditable As Boolean
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            extensionArchivo = Path.GetExtension(CStr(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreArchivo"))).ToLower()
            esEditable = CBool(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "EsEditable"))
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

            lnkEditar.Visible = esEditable

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("objDatosDocu") IsNot Nothing Then gvDatos.DataSource = Session("objDatosDocu")
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

    Private Sub ucCargueArchivo_FileUploadComplete(sender As Object, e As FileUploadCompleteEventArgs) Handles ucCargueArchivo.FileUploadComplete
        Dim respuesta As New ResultadoProceso
        Dim idUsuario As Integer
        Dim idDocumento As Integer = CInt(Session("idDocumento"))
        Try
            If ucCargueArchivo.HasFile Then
                Integer.TryParse(Session("usxp001"), idUsuario)
                Dim objDocServicio As New DocumentoServicioMensajeria(idDocumento)
                Dim ruta As String = String.Empty
                Dim rutaAlmacenaArchivo As Comunes.ConfigValues = New Comunes.ConfigValues("RUTACARGUEARCHIVOSTRANCITORIOS")
                If (rutaAlmacenaArchivo.ConfigKeyValue IsNot Nothing) Then
                    ruta = rutaAlmacenaArchivo.ConfigKeyValue
                Else
                    Throw New Exception("No fue posible establecer la ruta de almacenamiento de los archivos por favor contacte a IT para configurar en ConfigValues RUTACARGUEARCHIVOSTRANCITORIOS ")
                End If

                Dim rutaEliminar As String = ruta & objDocServicio.RutaAlmacenamiento & "\" & objDocServicio.IdentificadorUnico.ToString()
                With objDocServicio
                    .IdDocumento = idDocumento
                    .NombreArchivo = e.UploadedFile.FileName
                    .RutaAlmacenamiento = "Archivos\Servicio" & idUsuario.ToString().PadLeft(8, "0")
                    .TipoContenido = e.UploadedFile.ContentType
                    .Tamanio = e.UploadedFile.ContentLength
                    .IdentificadorUnico = Guid.NewGuid().ToString
                    .Archivo = e.UploadedFile.FileContent
                    respuesta = .Actualizar(idUsuario)
                End With
                With miEncabezado
                    .setTitle("Modificación Documentos Servicio")
                End With
                If respuesta.Valor = 0 Then
                    Session("mensaje") = respuesta.Mensaje
                    If File.Exists(rutaEliminar) Then
                        File.Delete(rutaEliminar)
                    End If
                Else
                    miEncabezado.showWarning(respuesta.Mensaje)
                End If
            End If
            e.CallbackData = e.UploadedFile.PostedFile.FileName
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
        CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        CType(sender, ASPxUploadControl).JSProperties("cpResultado") = respuesta.Valor
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarDocumentosServicio(ByVal idServicio As Integer)
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(idServicio)

        If miServicio.Registrado Then
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            Dim dtDatos As New DataTable
            With objDocumentos
                .IdServicio = idServicio
                dtDatos = .GenerarDataTable()
            End With

            With gvDatos
                .DataSource = dtDatos
                Session("objDatosDocu") = .DataSource
                .DataBind()
            End With
        Else
            miEncabezado.showWarning("El servicio ingresado no se encuentra registrado.")
        End If

    End Sub

    Private Sub DatosBasicosDocumento(ByVal idDocumento As Integer)
        Dim miDocumento As New DocumentoServicioMensajeria(idDocumento)
        Session("idDocumento") = idDocumento
        With miDocumento
            lblIdDocumento.Text = .IdDocumento
            lblNombreDocumento.Text = .NombreDocumento
            lblNombreArchivo.Text = .NombreArchivo
        End With
    End Sub

#End Region

End Class