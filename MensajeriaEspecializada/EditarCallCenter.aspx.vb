Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class EditarCallCenter
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idCallCenter As Integer

#End Region

#Region "Eventos"

    Private Sub EditarCallCenter_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Session("dtTiposServicios") IsNot Nothing Then
            lbTiposServicios.DataSource = Session("dtTiposServicios")
            lbTiposServicios.DataBind()
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            If Request.QueryString("idCallCenter") IsNot Nothing Then Integer.TryParse(Request.QueryString("idCallCenter").ToString, _idCallCenter)
            If _idCallCenter > 0 Then
                With miEncabezado
                    .setTitle("Modificar Call Center")
                End With
                Session("idCallCenter") = _idCallCenter
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idCallCenter") IsNot Nothing Then _idCallCenter = Session("idCallCenter")
        End If
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        ActualizarCallCenter()
        CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            Dim objCallCenter As New CallCenter(idCallCenter:=_idCallCenter)
            With objCallCenter
                txtNombreCallCenter.Text = .NombreCallCenter
                txtNombreContacto.Text = .NombreContacto
                txtTelefonoContacto.Text = .TelefonoContacto
                cbActivo.Checked = .Activo
            End With

            'Carga los Tipos de Servicios disponibles
            With lbTiposServicios
                .DataSource = New TipoServicioColeccion(activo:=True).GenerarDataTable()
                Session("dtTiposServicios") = .DataSource
                .DataBind()
            End With

            Dim objTipoServicio As New TipoServicioColeccion(idCallCenter:=_idCallCenter)
            For Each itemSel As TipoServicio In objTipoServicio
                For Each item As ListEditItem In lbTiposServicios.Items
                    If item.Value = itemSel.IdTipoServicio Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar obtener la información: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarCallCenter()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objCallCenter As New CallCenter()
            With objCallCenter
                .IdCallCenter = _idCallCenter
                .NombreCallCenter = txtNombreCallCenter.Text.Trim()
                .NombreContacto = txtNombreContacto.Text.Trim()
                .TelefonoContacto = txtTelefonoContacto.Text.Trim()
                .Activo = cbActivo.Checked

                If lbTiposServicios.SelectedValues.Count > 0 Then
                    .ListaIdTiposServicios = New List(Of Integer)
                    For tipoServicio As Integer = 0 To lbTiposServicios.SelectedValues.Count - 1
                        .ListaIdTiposServicios.Add(lbTiposServicios.SelectedValues(tipoServicio))
                    Next
                End If
                resultado = .Actualizar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Call Center actualizado exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar actualizar el registro: " & ex.Message)
        End Try
    End Sub

#End Region

End Class