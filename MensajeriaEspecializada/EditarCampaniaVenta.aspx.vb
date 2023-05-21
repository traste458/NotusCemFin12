Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class EditarCampaniaVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idCampania As Integer

#End Region

#Region "Eventos"

    Private Sub EditarCampaniaVenta_Init(sender As Object, e As System.EventArgs) Handles Me.Init
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

        If Not IsPostBack Then
            If Request.QueryString("idCampania") IsNot Nothing Then Integer.TryParse(Request.QueryString("idCampania").ToString, _idCampania)
            If _idCampania > 0 Then
                With miEncabezado
                    .setTitle("Modificar Campaña de Venta")
                End With
                Session("idCampania") = _idCampania
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idCampania") IsNot Nothing Then _idCampania = Session("idCampania")
        End If
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        ActualizarCampania()
        CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            Dim objCampania As New Campania(idCampania:=_idCampania)
            With objCampania
                txtNombreCampania.Text = .Nombre
                dateFechaInicio.Value = .FechaInicio
                If .FechaFin <> Date.MinValue Then dateFechaFin.Value = .FechaFin
                cbActivo.Checked = .Activo
            End With

            'Carga los Planes disponibles y los valores asociados
            With lbPlanes
                .DataSource = New PlanVentaColeccion(activo:=True).GenerarDataTable()
                Session("dtPlanes") = .DataSource
                .DataBind()
            End With

            Dim objPlanCampania As New PlanVentaColeccion(idCampania:=_idCampania)
            For Each itemSel As PlanVenta In objPlanCampania
                For Each item As ListEditItem In lbPlanes.Items
                    If item.Value = itemSel.IdPlan Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Carga los Call Centers disponibles y valores asociados
            With lbCallCenter
                .DataSource = New CallCenterColeccion(activo:=True).GenerarDataTable()
                Session("dtCallCenters") = .DataSource
                .DataBind()
            End With

            Dim objCallCampania As New CallCenterColeccion(idCampania:=_idCampania)
            For Each itemSel As CallCenter In objCallCampania
                For Each item As ListEditItem In lbCallCenter.Items
                    If item.Value = itemSel.IdCallCenter Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Carga los Documentos disponibles
            With lbDocumentos
                .DataSource = New DocumentoColeccion(activo:=True).GenerarDataTable()
                Session("dtDocumentos") = .DataSource
                .DataBind()
            End With

            Dim objDocumentoCampania As New DocumentoColeccion(idCampania:=_idCampania)
            For Each itemSel As Documento In objDocumentoCampania
                For Each item As ListEditItem In lbDocumentos.Items
                    If item.Value = itemSel.IdDocumento Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Carga los Tipos de Servicios disponibles
            With lbTiposServicios
                .DataSource = New TipoServicioColeccion(activo:=True).GenerarDataTable()
                Session("dtTiposServicios") = .DataSource
                .DataBind()
            End With

            Dim objTipoServicio As New TipoServicioColeccion(activo:=True, idCampania:=_idCampania)
            For Each itemSel As TipoServicio In objTipoServicio
                For Each item As ListEditItem In lbTiposServicios.Items
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

    Private Sub ActualizarCampania()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objCampania As New Campania()
            With objCampania
                .IdCampania = _idCampania
                .Nombre = txtNombreCampania.Text.Trim()
                .FechaInicio = dateFechaInicio.Date
                If dateFechaFin.Date <> Date.MinValue Then .FechaFin = dateFechaFin.Date
                .Activo = cbActivo.Checked

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
                resultado = .Actualizar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Campaña actualizada exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar actualizar el registro: " & ex.Message)
        End Try
    End Sub

#End Region

End Class