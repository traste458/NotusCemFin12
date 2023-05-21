Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports DevExpress.Web
Imports System.Linq
Imports System.Web.UI.WebControls

Public Class AdministracionCambiodeEstadosMasivosCEM
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        Try
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle(":: Administración Cambios de Estado Servicio CEM ::")
                End With
                CargaInicial()
            End If
            If cpPrincipal.IsCallback Then
                CargaInicial()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            Dim lnkMdifica As ASPxHyperLink = templateContainer.FindControl("lnkEditar")
        Catch ex As Exception
            miEncabezado.showError("No fué posible estableser la opciones de edicion: " & ex.Message)
        End Try
    End Sub

    Private Sub gvConfEstadoMasivo_DataBinding(sender As Object, e As System.EventArgs) Handles gvConfEstadoMasivo.DataBinding
        If Session("dtEstadosTipoServicio") IsNot Nothing Then gvConfEstadoMasivo.DataSource = Session("dtEstadosTipoServicio")
    End Sub

    Protected Sub cmEstadosActualCEM_DataBinding(sender As Object, e As EventArgs) Handles cmEstadosActualCEM.DataBinding
        If Session("dtEstados") IsNot Nothing Then cmEstadosActualCEM.DataSource = Session("dtEstados")
    End Sub
    Protected Sub cmEstadosFinalCEM_DataBinding(sender As Object, e As EventArgs) Handles cmEstadosFinalCEM.DataBinding
        If Session("dtEstados") IsNot Nothing Then cmEstadosFinalCEM.DataSource = Session("dtEstados")
    End Sub
    Protected Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        Try

            Dim objCambioEstado As New AdministraciondeCambiodeEstadosCEM()
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "consultaEstadosServicios"
                    consultarEstadosTipoServicio()
                Case "ActualizarCambiodeestado"
                    If (arryAccion(1) IsNot Nothing) Then
                        CargarConfiguracionEstado(arryAccion(1))
                    Else
                        imgEdita.ToolTip = "Guardar Registro"
                    End If

                Case "RegistarCambiodeestado"
                    imgEdita.ToolTip = "Guardar Registro"
                    Dim resultado As New ResultadoProceso
                    With objCambioEstado
                        .IdRegistero = hfidRegistro.Get("IdRegistero")
                        .IdTipoServicio = ddlTipoServicio.Value
                        .IdEstadoInicial = cmEstadosActualCEM.Value
                        .IdEstadoFinal = cmEstadosFinalCEM.Value
                        .ValidaDisponibilidad = cbValidaDisponibilidad.Checked
                        .ValidaCupos = cbValidaCupos.Checked
                        .CargaInventario = cbRetornaseralesInventario.Checked
                        .LiberaDisponibilidadInventario = cbLiberaCuposBloqueados.Checked
                        .IdUsuario = CInt(Session("usxp001"))
                        resultado = .RegistrarConfiguracionCambioEstado()
                    End With
                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess(resultado.Mensaje)
                        consultarEstadosTipoServicio()
                    Else
                        miEncabezado.showError(resultado.Mensaje)
                    End If
                Case "CrearNuevocambioestado"
                    hfidRegistro.Set("IdRegistero", "0")
                    cmEstadosActualCEM.SelectedIndex = 0
                    cmEstadosFinalCEM.SelectedIndex = 0
                    cbValidaDisponibilidad.Checked = 0
                    cbValidaCupos.Checked = 0
                    cbRetornaseralesInventario.Checked = 0
                    cbLiberaCuposBloqueados.Checked = 0
                    pcEditar.Width = 700
                    pcEditar.Height = 300
                    pcEditar.ShowOnPageLoad = True
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    'Protected Sub cmEstadosCEM_DataBinding(sender As Object, e As EventArgs) Handles cmEstadosCEM.DataBinding
    '    If Session("dtipoServicio") IsNot Nothing Then cmEstadosCEM.DataSource = Session("dtipoServicio")
    'End Sub
#End Region

#Region "Métodos Privados"

    Private Sub consultarEstadosTipoServicio()
        Dim objCambioEstado As New AdministraciondeCambiodeEstadosCEM()
        Dim dtEstadosTipoServicio As New DataTable
        With objCambioEstado
            .IdTipoServicio = ddlTipoServicio.Value
            .IdUsuario = CInt(Session("usxp001"))
            dtEstadosTipoServicio = .ConsultarEstadosServicios()
            Session("dtEstadosTipoServicio") = dtEstadosTipoServicio
            With gvConfEstadoMasivo
                .DataSource = dtEstadosTipoServicio
                .DataBind()
            End With
        End With
    End Sub

    Private Sub CargarConfiguracionEstado(ByVal idRegistro As Integer)
        Dim objCambioEstado As New AdministraciondeCambiodeEstadosCEM()
        imgEdita.ToolTip = "Actualizar Registro"
        Dim dtResultado As New DataTable
        With objCambioEstado
            .IdRegistero = idRegistro
            .IdUsuario = CInt(Session("usxp001"))
            .IdTipoServicio = ddlTipoServicio.Value
            dtResultado = .ConsultarEstadosServicios()
        End With
        If dtResultado.Rows.Count = 1 Then
            Dim row As DataRow = dtResultado.Rows(dtResultado.Rows.Count - 1)
            hfidRegistro.Set("IdRegistero", CUInt(row("idRegistro")))
            cmEstadosActualCEM.Value = row("idEstadoInicial")
            cmEstadosFinalCEM.Value = row("idEstadoFinal")
            cbValidaDisponibilidad.Checked = CBool(row("ValidaDisponibilidad"))
            cbValidaCupos.Checked = CBool(row("ValidaCupos"))
            cbRetornaseralesInventario.Checked = CBool(row("CargaInventario"))
            cbLiberaCuposBloqueados.Checked = CBool(row("LiberaDisponibilidadInventario"))
            pcEditar.Width = 700
            pcEditar.Height = 300
            pcEditar.ShowOnPageLoad = True
        Else
            miEncabezado.showError("Se genero un error al cargar el registro verifique nuevamente ")

        End If
    End Sub
    Private Sub CargaInicial()
        Try

            'Carga los tipos de servicio
            Dim dtipoServicio As New DataTable
            Dim objCambioEstado As New AdministraciondeCambiodeEstadosCEM()
            objCambioEstado.IdUsuario = CInt(Session("usxp001"))
            dtipoServicio = objCambioEstado.ConsultaTipoServicio
            Session("dtipoServicio") = dtipoServicio
            With ddlTipoServicio
                .DataSource = dtipoServicio
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListEditItem("Seleccione...", Nothing))
                End If
            End With
            'Estados de Devolución
            If Session("dtEstados") Is Nothing Then
                Session("dtEstados") = HerramientasMensajeria.ConsultarEstado(Enumerados.Entidad.ServicioMensajeria)
            End If

            If Session("dtEstados") IsNot Nothing Then

                With cmEstadosActualCEM
                    .DataSource = Session("dtEstados")
                    .DataBind()
                    If .Items.Count <> 1 Then
                        .Items.Insert(0, New ListEditItem("Seleccione...", Nothing))
                    End If
                End With
                With cmEstadosFinalCEM
                    .DataSource = Session("dtEstados")
                    .DataBind()
                    If .Items.Count <> 1 Then
                        .Items.Insert(0, New ListEditItem("Seleccione...", Nothing))
                    End If
                End With

            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar configuración. " & ex.Message)
        End Try
    End Sub
#End Region




End Class