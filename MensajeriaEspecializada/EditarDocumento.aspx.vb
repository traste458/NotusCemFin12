Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class EditarDocumento
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idDocumento As Short

#End Region

#Region "Eventos"

    Private Sub EditarDocumento_Init(sender As Object, e As System.EventArgs) Handles Me.Init
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
            If Request.QueryString("idDocumento") IsNot Nothing Then Integer.TryParse(Request.QueryString("idDocumento").ToString, _idDocumento)
            If _idDocumento > 0 Then
                With miEncabezado
                    .setTitle("Modificar Documento")
                End With
                Session("idDocumento") = _idDocumento
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idDocumento") IsNot Nothing Then _idDocumento = Session("idDocumento")
        End If
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        ActualizarDocumento()
        CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            Dim objDocumento As New Documento(idDocumento:=_idDocumento)
            With objDocumento
                txtNombreDocumento.Text = .Nombre
                memoObservacion.Text = .Observacion
                chbActivo.Checked = .Activo
                chbRecibo.Checked = .Recibo
                chbEntrega.Checked = .Entrega
            End With

            'Carga las unidades de negocio disponibles y valores asociados
            With lbUnidadNegocio
                .DataSource = New UnidadNegocioColeccion(activo:=True).GenerarDataTable()
                Session("dtUnidadNegocio") = .DataSource
                .DataBind()
            End With

            Dim objUnidadNegDocumento As New UnidadNegocioColeccion(idDocumento:=_idDocumento)
            For Each itemSel As UnidadNegocio In objUnidadNegDocumento
                For Each item As ListEditItem In lbUnidadNegocio.Items
                    If item.Value = itemSel.IdUnidadNegocio Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Carga los tipos de servicio disponibles
            With lbTipoServicio
                .DataSource = New TipoServicioColeccion(activo:=True, idUnidadNegocio:=Enumerados.UnidadNegocio.MensajeriaEspecializada).GenerarDataTable()
                Session("dtTipoServicio") = .DataSource
                .DataBind()
            End With

            Dim objTipoServicioDocumento As New TipoServicioColeccion(idDocumento:=_idDocumento, idUnidadNegocio:=Enumerados.UnidadNegocio.MensajeriaEspecializada)
            For Each itemSel As TipoServicio In objTipoServicioDocumento
                For Each item As ListEditItem In lbTipoServicio.Items
                    If item.Value = itemSel.IdTipoServicio Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarDocumento()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objDocumento As New Documento()
            With objDocumento
                .IdDocumento = _idDocumento
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

                resultado = .Actualizar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Documento actualizado exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar actualizar el registro: " & ex.Message)
        End Try
    End Sub

#End Region

End Class