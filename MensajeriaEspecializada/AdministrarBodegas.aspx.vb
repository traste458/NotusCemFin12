Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports LMDataAccessLayer
Imports ILSBusinessLayer.AlmacenBodega
Imports ILSBusinessLayer.OMS
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Productos
Imports System.Web.Services
Imports ILSBusinessLayer
Imports DevExpress.Web

Public Class AdministrarBodegas
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administrar Bodegas")
            End With
            Session.Remove("dtBodega")
            Session.Remove("dtTipoBodega")

            If Session("dtBodega") Is Nothing Then
                Dim objRinventario As New AlmacenBodega
                Dim dtBodega As DataTable
                dtBodega = objRinventario.ConsultarBodega()
                Session("dtBodega") = dtBodega
            End If
            MetodosComunes.CargarComboDX(cmbBodega, CType(Session("dtBodega"), DataTable), "idBodega", "bodega")

            If Session("dtTipoBodega") Is Nothing Then
                Dim objRinventario As New AlmacenBodega
                Dim dtTipoBodega As DataTable
                dtTipoBodega = objRinventario.ConsultarTipoBodega()
                Session("dtTipoBodega") = dtTipoBodega
            End If
            MetodosComunes.CargarComboDX(cmbTipoBodega, CType(Session("dtTipoBodega"), DataTable), "idTipo", "nombre")
        End If
    End Sub

    Protected Sub cmbBodega_DataBinding(sender As Object, e As EventArgs) Handles cmbBodega.DataBinding
        If cmbBodega.DataSource Is Nothing AndAlso Session("dtBodega") IsNot Nothing Then
            cmbBodega.DataSource = CType(Session("dtBodega"), DataTable)
        End If
    End Sub

    Protected Sub cmbTipoBodega_DataBinding(sender As Object, e As EventArgs) Handles cmbTipoBodega.DataBinding
        If cmbTipoBodega.DataSource Is Nothing AndAlso Session("dtTipoBodega") IsNot Nothing Then
            cmbTipoBodega.DataSource = CType(Session("dtTipoBodega"), DataTable)
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "ConsultarInformacion"
                    miEncabezado.clear()
                    cargarDatos()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub

    Private Sub cargarDatos()
        Dim objRinventario As New AlmacenBodega
        Try
            With objRinventario
                .IdTipoBodega = cmbTipoBodega.Value
                .IdBodega = cmbBodega.Value
                Session("dtResultados") = .ListarBodegas
            End With
            If Session("dtResultados").Rows.Count > 0 Then
                With gvDetalle
                    .DataSource = CType(Session("dtResultados"), DataTable)
                    .DataBind()
                End With
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Private Sub lbAñadir_Click(sender As Object, e As EventArgs) Handles lbAñadir.Click
        Response.Redirect("CrearBodega.aspx")
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idBodega As Integer

            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

            idBodega = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idbodega"))

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub


    Protected Sub LinkDatos_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idBodega As Integer

            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

            idBodega = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idbodega"))

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub


    Protected Sub cbExportDetalle_ButtonClick(source As Object, e As ButtonEditClickEventArgs) Handles cbExportDetalle.ButtonClick

        Dim obj As New AlmacenBodega

        Try
            Session("dtReporte") = obj.ObtenerReporteCiudadCercana(cmbBodega.Value, cmbTipoBodega.Value)

            With gvDatos
                .DataSource = CType(Session("dtReporte"), DataTable)
                .DataBind()
            End With


            If Session("dtReporte") IsNot Nothing Then
                If Not String.IsNullOrEmpty(cbExportDetalle.Value) Then
                    With gvDetalleExporter
                        .FileName = "Reporte Bodega Ciudad Cercana"
                        .ReportHeader = "Reporte Lectura Procesada " & "_" & vbCrLf & vbCrLf
                        .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                        .Landscape = False

                        With .Styles.Default.Font
                            .Name = "Arial"
                            .Size = FontUnit.Point(10)
                        End With
                        .DataBind()
                    End With

                    Select Case cbExportDetalle.Value
                        Case "xls"
                            gvDetalleExporter.WriteXlsToResponse()
                        Case "xlsx"
                            gvDetalleExporter.WriteXlsxToResponse()
                        Case "csv"
                            gvDetalleExporter.WriteCsvToResponse()
                        Case Else
                            Throw New ArgumentNullException("Archivo no valido")
                    End Select
                End If
            Else
                miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al tratar de exportar la información: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDetalle_DataBinding(sender As Object, e As EventArgs) Handles gvDetalle.DataBinding
        If Not (Me.Session("dtResultados") Is Nothing) Then
            Me.gvDetalle.DataSource = CType(CType(Me.Session("dtResultados"), DataTable), Object)
        End If

    End Sub
End Class