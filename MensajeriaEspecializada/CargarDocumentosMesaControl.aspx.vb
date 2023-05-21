Imports DevExpress.Web
Imports ILSBusinessLayer
Imports System.IO
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class CargarDocumentosMesaControl
    Inherits System.Web.UI.Page
    Dim idServicio As Long
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epPrincipal.clear()
        If Not Me.IsPostBack Then
            epPrincipal.setTitle("::::: Cargue documentos mesa de control :::::")
        End If
        idServicio = Request.QueryString("idServicio")
        If idServicio = 0 Then
            epPrincipal.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
        Else
            ConsultarDocumentos()
        End If

    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        epPrincipal.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")

            Select Case arryAccion(0)
                Case "Eliminarsoporte"
                    EliminarDocumentos(arryAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epPrincipal.showError("Error: " & ex.Message)
            cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try

    End Sub
    Protected Sub LinkDatosEditar_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim hlEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(hlEditar.NamingContainer, GridViewDataItemTemplateContainer)
            Dim ruta As String = templateContainer.KeyValue.ToString.Replace("\", "|-")
            hlEditar.ClientSideEvents.Click = hlEditar.ClientSideEvents.Click.Replace("{0}", ruta)
        Catch ex As Exception
            epPrincipal.showError("No fué posible establecer los parametrospara editar" & "<br><br>" & ex.Message)
            cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub
    Protected Sub btnAgregarSoportes_Click(sender As Object, e As EventArgs) Handles btnAgregarSoportes.Click
        AdicionarSoporte()

    End Sub
  
    Private Sub AdicionarSoporte()
        Try
            If fuArchivos.HasFile Then
                Dim _ruta As String = String.Empty
                Dim rutarelativa As String = String.Empty

                Dim Variable As String = "RUTA_DOCUMENTOS_MESA_CONTROL"
                Try
                    Dim obj As Comunes.ConfigValues = New Comunes.ConfigValues(Variable)
                    If (obj.ConfigKeyValue Is Nothing) Then
                        epPrincipal.showError("No se encontro la configuracion de la ruta Por favor Contactar a IT: " & Variable)
                        Exit Sub
                    End If
                    Dim carater As String = obj.ConfigKeyValue.Substring(obj.ConfigKeyValue.Length - 1)
                    If carater IsNot Nothing Or carater = "\" Then
                        rutarelativa = obj.ConfigKeyValue & "DocumentosMesaControl\Servicio_" & idServicio.ToString() & "\"
                        _ruta = rutarelativa + Guid.NewGuid().ToString() + Path.GetExtension(fuArchivos.FileName)
                    Else
                        rutarelativa = obj.ConfigKeyValue & "\" & "DocumentosMesaControl\Servicio_" & idServicio.ToString() & "\"
                        _ruta = obj.ConfigKeyValue & "\" & "DocumentosMesaControl\Servicio_" & idServicio.ToString() & "\" & Guid.NewGuid().ToString() & Path.GetExtension(fuArchivos.FileName)
                    End If

                Catch ex As Exception
                    epPrincipal.showError("Se generó un error al tratar cargar los archivos: " & "<br><br>" & ex.Message)
                    cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
                End Try
                If Not String.IsNullOrEmpty(_ruta) Then

                    Dim respuesta As ResultadoProceso
                    Dim idUsuario As Integer
                    Try
                        Integer.TryParse(Session("usxp001"), idUsuario)
                        Dim objDocServicio As New DocumentoServicioMensajeria()
                        With objDocServicio
                            .IdServicio = idServicio
                            .NombreDocumento = fuArchivos.FileName
                            .NombreArchivo = Path.GetFileName(_ruta)
                            .RutaAlmacenamiento = "DocumentosMesaControl\Servicio_" & idServicio.ToString() & "\"
                            .TipoContenido = fuArchivos.PostedFile.ContentType
                            .Tamanio = fuArchivos.PostedFile.ContentLength / 1024
                            .IdentificadorUnico = Guid.NewGuid().ToString
                            .Archivo = fuArchivos.FileContent
                            .RutaAlmacenamientoRelativa = rutarelativa
                            .ImagenBytes = fuArchivos.FileBytes
                            respuesta = .RegistrarMesaControl(idUsuario)
                        End With

                        If respuesta.Valor = 0 Then
                            ConsultarDocumentos()
                            epPrincipal.showSuccess(respuesta.Mensaje & "<br><br>")
                            cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
                        Else
                            epPrincipal.showWarning(respuesta.Mensaje)
                        End If
                    Catch ex As Exception
                        epPrincipal.showError("Se generó un error al intentar cargar el archivo: " & ex.Message)
                    End Try
                    cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml()
                End If
            Else
                epPrincipal.showWarning("Ya se ingreso el numero maximo de imagenes.")
                cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
            End If
            If CType(Session("dtSoportes"), DataTable).Rows.Count <= 4 Then
                fuArchivos.Enabled = True
                btnAgregarSoportes.ClientEnabled = True
            Else
                fuArchivos.Enabled = False
                btnAgregarSoportes.ClientEnabled = False
            End If
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al tratar adicionar el archivos: " & "<br><br>" & ex.Message)
            cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
    End Sub
    Private Sub ConsultarDocumentos()
        Try
            Dim objDocServicio As New DocumentoServicioMensajeria()
            Dim dtSoportes As DataTable
            With objDocServicio
                .IdServicio = idServicio
                .IdTipoDocumento = 4
                dtSoportes = .ConsultarArchivosMesaControl()
            End With
            gvSoporte.DataSource = dtSoportes
            gvSoporte.DataBind()
            Session("dtSoportes") = dtSoportes
            gvSoporte.Visible = True

        Catch ex As Exception
            epPrincipal.showError("Error al adicionar el soporte. " & ex.Message & "<br><br>")
            cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
    End Sub

    Private Sub EliminarDocumentos(ByVal idDocumento As Long)
        Dim resultado As New ResultadoProceso
        Dim idUsuario As Integer
        Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            Dim objDocServicio As New DocumentoServicioMensajeria()

            With objDocServicio
                .IdDocumento = idDocumento
                .IdTipoDocumento = 4
                resultado = .EliminarDocumento(idUsuario)
            End With
            If (resultado.Valor = 0) Then
                epPrincipal.showSuccess(resultado.Mensaje & "<br><br>")
                cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
                ConsultarDocumentos()
            Else
                epPrincipal.showError("Error:  " & resultado.Mensaje & "<br><br>")

            End If

        Catch ex As Exception
            epPrincipal.showError("Error al adicionar el soporte. " & ex.Message & "<br><br>")
            cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
        cpGeneral.JSProperties("cpMensaje") = epPrincipal.RenderHtml
    End Sub

End Class