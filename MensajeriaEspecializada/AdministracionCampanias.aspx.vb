Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports DevExpress.Web

Public Class AdministracionCampanias
    Inherits System.Web.UI.Page

#Region "Eventos"

    Private Sub AdministracionCampanias_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Session("dtPlanes") IsNot Nothing Then
            lbPlanes.DataSource = Session("dtPlanes")
            lbPlanes.DataBind()
        End If
        If Session("dtCallCenters") IsNot Nothing Then
            lbCallCenter.DataSource = Session("dtCallCenters")
            lbCallCenter.DataBind()
        End If
        If Session("dtDocumentos") IsNot Nothing Then
            lbDocumentos.DataSource = Session("dtDocumentos")
            lbDocumentos.DataBind()
        End If
        If Session("dtTiposServicios") IsNot Nothing Then
            lbTiposServicios.DataSource = Session("dtTiposServicios")
            lbTiposServicios.DataBind()
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118
#End If

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración de Campañas")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub gvCampanias_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvCampanias.CustomCallback
        BuscarCampanias()
    End Sub

    Private Sub gvCampanias_DataBinding(sender As Object, e As System.EventArgs) Handles gvCampanias.DataBinding
        gvCampanias.DataSource = Session("dtDatosCampanias")
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        AdicionarCampania()
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

    Private Sub BuscarCampanias()
        Try
            Dim objCampanias As New CampaniaColeccion()
            With objCampanias
                If Not String.IsNullOrEmpty(txtNombreCampaniaFiltro.Text.Trim) Then .NombreCampania = txtNombreCampaniaFiltro.Text.Trim
                .Activo = chbEstadoFiltro.Checked
                .IdClienteExterno = Enumerados.ClienteExterno.COMCEL
            End With

            With gvCampanias
                .DataSource = objCampanias.GenerarDataTable()
                Session("dtDatosCampanias") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        Try
            'Carga los Planes disponibles
            With lbPlanes
                .DataSource = New PlanVentaColeccion(activo:=True).GenerarDataTable()
                Session("dtPlanes") = .DataSource
                .DataBind()
            End With

            'Carga los Call Centers disponibles
            With lbCallCenter
                .DataSource = New CallCenterColeccion(True).GenerarDataTable()
                Session("dtCallCenters") = .DataSource
                .DataBind()
            End With

            ' Carga los Documentos disponibles
            With lbDocumentos
                .DataSource = New DocumentoColeccion(activo:=True).GenerarDataTable()
                Session("dtDocumentos") = .DataSource
                .DataBind()
            End With

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

    Private Sub AdicionarCampania()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objCampania As New Campania()
            With objCampania
                .Nombre = txtNombreCampania.Text.Trim()
                .FechaInicio = dateFechaInicio.Date
                If dateFechaFinal.Date <> Date.MinValue Then .FechaFin = dateFechaFinal.Date
                .Activo = chbEstado.Checked

                If lbPlanes.SelectedValues.Count > 0 Then
                    .ListaPlanes = New List(Of Integer)
                    For plan As Integer = 0 To lbPlanes.SelectedValues.Count - 1
                        .ListaPlanes.Add(lbPlanes.SelectedValues(plan))
                    Next
                End If

                If lbCallCenter.SelectedValues.Count > 0 Then
                    .ListaCallCenters = New List(Of Integer)
                    For callcenter As Integer = 0 To lbCallCenter.SelectedValues.Count - 1
                        .ListaCallCenters.Add(lbCallCenter.SelectedValues(callcenter))
                    Next
                End If

                If lbDocumentos.SelectedValues.Count > 0 Then
                    .ListaDocumentos = New List(Of Short)
                    For doc As Integer = 0 To lbDocumentos.SelectedValues.Count - 1
                        .ListaDocumentos.Add(lbDocumentos.SelectedValues(doc))
                    Next
                End If

                If lbTiposServicios.SelectedValues.Count > 0 Then
                    .ListaTipoServicio = New ArrayList
                    For tipoServicio As Integer = 0 To lbTiposServicios.SelectedValues.Count - 1
                        .ListaTipoServicio.Add(lbTiposServicios.SelectedValues(tipoServicio))
                    Next
                End If

                resultado = .Registrar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Campaña adicionada exitosamente.")
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
            txtNombreCampania.Text = String.Empty
            dateFechaInicio.Value = Nothing
            dateFechaFinal.Value = Nothing
            chbEstado.Checked = True

            lbPlanes.UnselectAll()
            lbCallCenter.UnselectAll()
            lbDocumentos.UnselectAll()
            lbTiposServicios.UnselectAll()
            pcAsociadosCampania.ActiveTabIndex = 0
        Catch : End Try
    End Sub

#End Region

End Class