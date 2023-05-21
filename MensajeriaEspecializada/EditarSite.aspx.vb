Imports ILSBusinessLayer
Imports ILSBusinessLayer.WMS
Imports System.Collections.Generic
Imports DevExpress.Web

Public Class EditarSite
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idSite As Integer

#End Region

#Region "Eventos"

    Private Sub EditarSite_Init(sender As Object, e As System.EventArgs) Handles Me.Init
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
            If Request.QueryString("idSite") IsNot Nothing Then Integer.TryParse(Request.QueryString("idSite").ToString, _idSite)
            If _idSite > 0 Then
                With miEncabezado
                    .setTitle("Modificar Site")
                End With
                Session("idSite") = _idSite
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idSite") IsNot Nothing Then _idSite = Session("idSite")
        End If
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        ActualizarSite()
        CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
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

            Dim objSite As New Site(idSite:=_idSite)
            With objSite
                txtNombreSite.Text = .Nombre
                cmbCallCenter.Value = .IdCallCenter
                chbEstado.Checked = .Activo
            End With

            'Carga las Bodegas de la Unidad de Negocio
            With lbBodegas
                .DataSource = New BodegaColeccion(idUnidadNegocio:=Enumerados.UnidadNegocio.MensajeriaEspecializada).GenerarDataTable()
                Session("dtBodegas") = .DataSource
                .DataBind()
            End With

            Dim objBodegaSite As New BodegaColeccion(idSite:=_idSite)
            For Each itemSel As Bodega In objBodegaSite
                For Each item As ListEditItem In lbBodegas.Items
                    If item.Value = itemSel.IdBodega Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Carga los usuarios disponibles
            Dim listPerfilesCall As List(Of String) = New List(Of String)(MetodosComunes.seleccionarConfigValue("PERFILES_SITES_CALLCENTER").Split(","))
            With lbUsuarios
                .DataSource = New UsuarioColeccion(listIdPerfil:=listPerfilesCall.ConvertAll(Of Integer)(Function(x) CInt(x))).GenerarDataTable()
                Session("dtUsuarios") = .DataSource
                .DataBind()
            End With

            Dim objUsuarioSite As New UsuarioColeccion(idSite:=_idSite)
            For Each itemSel As Usuario In objUsuarioSite
                For Each item As ListEditItem In lbUsuarios.Items
                    If item.Value = itemSel.IdUsuario Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarSite()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objSite As New Site()
            With objSite
                .IdSite = _idSite
                .IdCallCenter = cmbCallCenter.Value
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

                resultado = .Actualizar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Site actualizado exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar actualizar el registro: " & ex.Message)
        End Try
    End Sub

#End Region

End Class