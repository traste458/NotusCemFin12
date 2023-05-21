Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports ILSBusinessLayer
Imports System.Collections.Generic

Public Class AdministracionDocumentos
    Inherits System.Web.UI.Page

#Region "Eventos"

    Private Sub AdministracionDocumentos_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Session("dtUnidadNegocio") IsNot Nothing Then
            lbUnidadNegocio.DataSource = Session("dtUnidadNegocio")
            lbUnidadNegocio.DataBind()
        End If
        If Session("dtTipoServicio") IsNot Nothing Then
            lbTipoServicio.DataSource = Session("dtTipoServicio")
            lbTipoServicio.DataBind()
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración de Documentos")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub gvDocumentos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDocumentos.CustomCallback
        BuscarDocumentos()
    End Sub

    Private Sub gvDocumentos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDocumentos.DataBinding
        gvDocumentos.DataSource = Session("dtDatosDocumentos")
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)

            'La visualización es visible para todos
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        AdicionarDocumento()
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarDocumentos()
        Try
            Dim objDocumentos As New DocumentoColeccion()
            With objDocumentos
                If Not String.IsNullOrEmpty(txtNombreDocumentoFiltro.Text.Trim) Then .NombreDocumento = txtNombreDocumentoFiltro.Text.Trim
                .Activo = chbEstadoFiltro.Checked
            End With

            With gvDocumentos
                .DataSource = objDocumentos.GenerarDataTable()
                Session("dtDatosDocumentos") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        Try
            'Carga las unidades de negocio disponibles
            With lbUnidadNegocio
                .DataSource = New UnidadNegocioColeccion(activo:=True).GenerarDataTable()
                Session("dtUnidadNegocio") = .DataSource
                .DataBind()
            End With

            'Carga los tipos de servicio disponibles
            With lbTipoServicio
                .DataSource = New TipoServicioColeccion(activo:=True, idUnidadNegocio:=Enumerados.UnidadNegocio.MensajeriaEspecializada).GenerarDataTable()
                Session("dtTipoServicio") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarDocumento()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objDocumento As New Documento()
            With objDocumento
                .Nombre = txtNombreDocumento.Text.Trim()
                .Observacion = memoObservacion.Text.Trim()
                .Activo = chbActivo.Checked
                .Recibo = chbRecibo.Checked
                .Entrega = chbEntrega.Checked

                If lbUnidadNegocio.SelectedValues.Count > 0 Then
                    .ListaUnidadesNegocio = New List(Of Integer)
                    For unidad As Integer = 0 To lbUnidadNegocio.SelectedValues.Count - 1
                        .ListaUnidadesNegocio.Add(lbUnidadNegocio.SelectedValues(unidad))
                    Next
                End If

                If lbTipoServicio.SelectedValues.Count > 0 Then
                    .ListaTipoServicio = New List(Of Integer)
                    For tipo As Integer = 0 To lbTipoServicio.SelectedValues.Count - 1
                        .ListaTipoServicio.Add(lbTipoServicio.SelectedValues(tipo))
                    Next
                End If

                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Documento adicionado exitosamente.")
                LimpiarFormulario()
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar crear la campaña: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        Try
            txtNombreDocumento.Text = String.Empty
            memoObservacion.Text = String.Empty
            chbActivo.Checked = True
            chbRecibo.Checked = False
            chbEntrega.Checked = False

            lbUnidadNegocio.UnselectAll()
            lbTipoServicio.UnselectAll()
        Catch : End Try
    End Sub

#End Region

End Class