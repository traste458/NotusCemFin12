Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.WMS
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class AdministracionSites
    Inherits System.Web.UI.Page

#Region "Eventos"

    Private Sub AdministracionSites_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Session("dtBodegas") IsNot Nothing Then
            lbBodegas.DataSource = Session("dtBodegas")
            lbBodegas.DataBind()
        End If

        If Session("dtUsuarios") IsNot Nothing Then
            lbUsuarios.DataSource = Session("dtUsuarios")
            lbUsuarios.DataBind()
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración de Sites")
            End With
            CargaInicial()
        End If
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

    Private Sub gvSites_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvSites.CustomCallback
        BuscarSites()
    End Sub

    Private Sub gvSites_DataBinding(sender As Object, e As System.EventArgs) Handles gvSites.DataBinding
        gvSites.DataSource = Session("dtDatosSites")
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        AdicionarSite()
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Carga los call centers activos
            With cmbCallCenter
                .DataSource = New CallCenterColeccion(activo:=True).GenerarDataTable()
                .TextField = "NombreCallCenter"
                .ValueField = "IdCallCenter"
                .DataBind()
            End With

            'Carga las Bodegas de la Unidad de Negocio
            With lbBodegas
                .DataSource = New BodegaColeccion(idUnidadNegocio:=Enumerados.UnidadNegocio.MensajeriaEspecializada).GenerarDataTable()
                Session("dtBodegas") = .DataSource
                .DataBind()
            End With

            'Carga los usuarios disponibles
            Dim listPerfilesCall As List(Of String) = New List(Of String)(MetodosComunes.seleccionarConfigValue("PERFILES_SITES_CALLCENTER").Split(","))
            With lbUsuarios
                .DataSource = New UsuarioColeccion(listIdPerfil:=listPerfilesCall.ConvertAll(Of Integer)(Function(x) CInt(x))).GenerarDataTable()
                Session("dtUsuarios") = .DataSource
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("No fue posible realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarSites()
        Try
            Dim objSites As New SiteColeccion()
            With objSites
                If Not String.IsNullOrEmpty(txtNombreSiteFiltro.Text.Trim()) Then .Nombre = txtNombreSiteFiltro.Text.Trim()
                .Activo = chbEstadoFiltro.Checked
            End With

            With gvSites
                .DataSource = objSites.GenerarDataTable()
                Session("dtDatosSites") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarSite()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objSite As New Site()
            With objSite
                .IdCallCenter = CInt(cmbCallCenter.Value)
                .Nombre = txtNombreSite.Text.Trim()
                .Activo = chbEstado.Checked

                If lbBodegas.SelectedValues.Count > 0 Then
                    .ListaBodegas = New List(Of Integer)
                    For bodega As Integer = 0 To lbBodegas.SelectedValues.Count - 1
                        .ListaBodegas.Add(lbBodegas.SelectedValues(bodega))
                    Next
                End If

                If lbUsuarios.SelectedValues.Count > 0 Then
                    .ListaUsuarios = New List(Of Integer)
                    For user As Integer = 0 To lbUsuarios.SelectedValues.Count - 1
                        .ListaUsuarios.Add(lbUsuarios.SelectedValues(user))
                    Next
                End If

                resultado = .Registrar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Site adicionado exitosamente.")
                LimpiarFormulario()
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar crear el Site: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        Try
            txtNombreSite.Text = String.Empty
            cmbCallCenter.Value = Nothing
            chbEstado.Checked = True
            lbBodegas.UnselectAll()
            lbUsuarios.UnselectAll()
            pcAsociados.ActiveTabIndex = 0
        Catch : End Try
    End Sub

#End Region

End Class