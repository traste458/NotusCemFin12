Imports System.Text
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes
Imports DevExpress.Web
Imports System.IO

Public Class FacturacionVentaCorporativa
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                '.showReturnLink("PoolServiciosNew.aspx")
                .setTitle("Facturar - Servicio Mensajer&iacute;a")
                Dim idServicio As Integer
                With Request
                    If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
                End With
                If idServicio > 0 Then
                    ValidarDatosServicio(idServicio)
                Else
                    miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                    rpDocumentos.ClientVisible = False
                End If
            End With
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "Registrar"
                    resultado = RegistrarFacturacion()
                Case "CancelarRegistro"
                    CancelarRegistro()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Ocurrio un error al generar el registro: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcNovedades_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcNovedades.WindowCallback
        Dim param As String = e.Parameter
        Select Case param
            Case "Inicial"
                CargaInicialNovedad()
                cmbNovedad.Focus()
            Case "Registra"
                RegistrarNovedad()
                cmbNovedad.Focus()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub btnSoportes_Click(sender As Object, e As EventArgs) Handles btnSoportes.Click
        Dim respuesta As ResultadoProceso
        Dim idUsuario As Integer
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            If fuSoportes.PostedFile.ContentLength <= 10485760 Then
                If fuSoportes.PostedFile.FileName <> "" Then
                    Dim extencion As String = Path.GetExtension(fuSoportes.PostedFile.FileName).ToLower
                    If extencion = ".pdf" Then
                        Dim objDocServicio As New DocumentoTemporalServicioMensajeria()
                        With objDocServicio
                            .NombreDocumento = "Soportes de Factura : " & Session("usxp002")
                            .NombreArchivo = fuSoportes.PostedFile.FileName
                            .RutaAlmacenamiento = "Archivos\Servicio" & idServicio.ToString()
                            .TipoContenido = fuSoportes.PostedFile.ContentType
                            .Tamanio = fuSoportes.PostedFile.ContentLength
                            .IdentificadorUnico = Guid.NewGuid()
                            .Archivo = fuSoportes.FileContent
                            .PedidoSAP = txtPedidoSAP.Text
                            .DocumentoSAP = txtDocumentoSAP.Text
                            respuesta = .RegistrarDocumentosTemporales(idUsuario, Enumerados.TipoDocumento.Soportesdefactura, idServicio)
                            hdIdServicio.Set("valor", respuesta.Valor)
                        End With
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>Procesar()</script>", False)
                    Else
                        miEncabezado.showError("Tipo de archivo incorrecto. Se espera un archivo con extensión .pdf o .msg")
                    End If
                Else
                    miEncabezado.showError("Debe seleccionar un archivo")
                End If
            Else
                miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB.")
            End If
            ValidarDatosServicio(idServicio, True)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
    End Sub

    Private Sub gvFacturas_DataBinding(sender As Object, e As EventArgs) Handles gvFacturas.DataBinding
        If Session("dtDocumento") IsNot Nothing Then gvFacturas.DataSource = Session("dtDocumento")
    End Sub

    Private Sub gvFacturas_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gvFacturas.CustomCallback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        Try
            arrayAccion = e.Parameters.Split(":")
            Select Case arrayAccion(0)
                Case "CargueDocumentos"
                    CargarDocumentosTemporales(Session("idServicio"))
                    If Session("mensaje") IsNot Nothing Then miEncabezado.showWarning(Session("mensaje"))
                Case "eliminarDetalle"
                    resultado = EliminarFacturas(arrayAccion(1))
                    If resultado.Valor = 0 Then
                        CargarDocumentosTemporales(Session("idServicio"))
                        miEncabezado.showSuccess(resultado.Mensaje)
                    Else
                        miEncabezado.showWarning(resultado.Mensaje)
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al generar el callback: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idRegistro As String
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            Dim lnkEliminar As ASPxHyperLink = templateContainer.FindControl("lnkEliminar")

            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idRegistro = CStr(gvFacturas.GetRowValuesByKeyValue(templateContainer.KeyValue, "idRegistro"))

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al generar los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub ValidarDatosServicio(ByVal idServicio As Integer, Optional ByVal flag As Boolean = False)
        Dim infoServicio As New ServicioMensajeriaVentaCorporativa(idServicio:=idServicio)
        Dim respuesta As New ResultadoProceso
        If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
            If infoServicio.IdPersonaBackOficce = Session("usxp001") Then
                Dim objEncabezado As EncabezadoServicioTipoVentaCorporativa = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVentaCorporativa.ascx")
                infoServicio = New ServicioMensajeriaVentaCorporativa(idServicio:=idServicio)
                respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                phEncabezado.Controls.Add(objEncabezado)
                phEncabezado.DataBind()
                Session("infoServicioMensajeria") = infoServicio
                Session("idServicio") = idServicio
                txtPedidoSAP.Focus()
                If Not flag Then
                    CancelarRegistro()
                End If
                CargarDocumentosTemporales(idServicio)
            Else
                miEncabezado.showWarning("El servicio esta asignado a un usuario diferente al ususario actual.")
                rpDocumentos.ClientVisible = False
            End If
        Else
            miEncabezado.showWarning("No fué posible encontrar los datos del servicio.")
            rpDocumentos.ClientVisible = False
        End If
    End Sub

    Private Function RegistrarFacturacion() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim miServicio As New ServicioMensajeriaVentaCorporativa

        With miServicio
            .IdServicioMensajeria = idServicio
            .IdUsuario = CInt(Session("usxp001"))
            resultado = .FacturarServicio()
        End With

        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
            rpDocumentos.ClientVisible = False
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If

        Return resultado
    End Function

    Private Sub CargaInicialNovedad()
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim dtEstado As New DataTable
        dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=4)
        MetodosComunes.CargarComboDX(cmbNovedad, dtEstado, "idTipoNovedad", "descripcion")

        CargarNovedades(idServicio)

    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub RegistrarNovedad()
        Dim resultado As ResultadoProceso
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim novedad As New NovedadServicioMensajeria
        With novedad
            .IdServicioMensajeria = idServicio
            .Observacion = meJustificacion.Text.Trim
            .IdTipoNovedad = CInt(cmbNovedad.Value)
            resultado = .Registrar(CInt(Session("usxp001")))
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                meJustificacion.Text = ""
                cmbNovedad.SelectedIndex = -1
                CargaInicialNovedad()
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        End With
    End Sub

    Private Function CancelarRegistro() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa

        With miServicio
            .IdUsuario = CInt(Session("usxp001"))
            .IdServicioMensajeria = CInt(Session("idServicio"))
            resultado = .CancelarRegistro()
        End With

        Return resultado
    End Function

    Private Sub CargarDocumentosTemporales(ByVal idServicio As Integer)
        Dim miDocumento As New DocumentoTemporalServicioMensajeria
        Dim dtDocumento As New DataTable
        dtDocumento = miDocumento.ConsultarDocumentosTemporales(CInt(Session("usxp001")), idServicio)
        Session("dtDocumento") = dtDocumento
        With gvFacturas
            .DataSource = dtDocumento
            .DataBind()
        End With
    End Sub

    Private Function EliminarFacturas(ByVal idRegistro As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objDocServicio As New DocumentoTemporalServicioMensajeria(idRegistro)
        Dim rutaEliminar As String = HttpContext.Current.Server.MapPath(objDocServicio.RutaAlmacenamiento) & "\" & objDocServicio.IdentificadorUnico.ToString()

        With objDocServicio
            resultado = .EliminarFacturasTemporal(idRegistro)
        End With
        If resultado.Valor = 0 Then
            If File.Exists(rutaEliminar) Then
                File.Delete(rutaEliminar)
            End If
        End If
        Return resultado
    End Function

#End Region

End Class