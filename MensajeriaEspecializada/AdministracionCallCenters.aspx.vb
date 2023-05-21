Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class AdministracionCallCenters
    Inherits System.Web.UI.Page

#Region "Eventos"

    Private Sub AdministracionCallCenters_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Session("dtTiposServicios") IsNot Nothing Then
            lbTiposServicios.DataSource = Session("dtTiposServicios")
            lbTiposServicios.DataBind()
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración de Call Centers")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub gvCallCenters_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvCallCenters.CustomCallback
        BuscarCallCenters()
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvCallCenters_DataBinding(sender As Object, e As System.EventArgs) Handles gvCallCenters.DataBinding
        gvCallCenters.DataSource = Session("dtDatosCalls")
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        AdicionarCallCenter()
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
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

#End Region

#Region "Métodos Privados"

    Private Sub BuscarCallCenters()
        Try
            Dim objCalls As New CallCenterColeccion()
            With objCalls
                If Not String.IsNullOrEmpty(txtNombreCallFiltro.Text.Trim) Then .NombreCallCenter = txtNombreCallFiltro.Text.Trim
                .Activo = chbEstadoFiltro.Checked
            End With

            With gvCallCenters
                .DataSource = objCalls.GenerarDataTable()
                Session("dtDatosCalls") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarCallCenter()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objCallCenter As New CallCenter()
            With objCallCenter
                .NombreCallCenter = txtNombreCallCenter.Text.Trim()
                .NombreContacto = txtNombreContacto.Text.Trim()
                .TelefonoContacto = txtTelefonoContacto.Text.Trim()
                .Activo = chbActivo.Checked
                If lbTiposServicios.SelectedValues.Count > 0 Then
                    .ListaIdTiposServicios = New List(Of Integer)
                    For tipoServicio As Integer = 0 To lbTiposServicios.SelectedValues.Count - 1
                        .ListaIdTiposServicios.Add(lbTiposServicios.SelectedValues(tipoServicio))
                    Next
                End If
                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Call Center adicionado exitosamente.")
                LimpiarFormulario()
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar crear el call center: " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        Try
            'Carga los Tipos de Servicios disponibles
            With lbTiposServicios
                .DataSource = New TipoServicioColeccion(activo:=True).GenerarDataTable()
                Session("dtTiposServicios") = .DataSource
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("No fué posible realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        Try
            txtNombreCallCenter.Text = String.Empty
            txtNombreContacto.Text = String.Empty
            txtTelefonoContacto.Text = String.Empty
            chbActivo.Checked = True
            lbTiposServicios.UnselectAll()
        Catch : End Try
    End Sub

#End Region

End Class