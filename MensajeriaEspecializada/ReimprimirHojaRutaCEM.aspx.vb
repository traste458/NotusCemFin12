Imports System.Collections.Generic
Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ReimprimirHojaRutaCEM
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargueInicial()
        End If
    End Sub

    Private Sub CargueInicial()
        Dim dtTransportadora As DataTable = ObtenerTransportadoras()
        Session("dtTransportadora") = dtTransportadora
        MetodosComunes.CargarComboDX(cmbTransportadora, dtTransportadora, "idtransportadora", "transportadora")

        dateInicio.Date = New Date(Now.Year, Now.Month, 1)
        dateFin.Date = Date.Now
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim IdDespacho As Long

        Try
            Dim linkImprimir As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkImprimir.NamingContainer, GridViewDataItemTemplateContainer)
            IdDespacho = CLng(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdDespacho"))

            linkImprimir.ClientSideEvents.Click = linkImprimir.ClientSideEvents.Click.Replace("{0}", IdDespacho)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub BuscarDespachos()
        Dim dt As DataTable = Nothing

        Try
            Dim infoBodegas As New RutaServicioMensajeriaTransportadora
            With infoBodegas
                .IdTransportadora = IIf(cmbTransportadora.Value = "", 0, cmbTransportadora.Value)
                .Guia = txtGuia.Text.Trim
                .Radicado = IIf(txtRadicado.Text.Trim = "", 0, txtRadicado.Text.Trim)
                .FechaInicio = dateInicio.Date
                .FechaFin = dateFin.Date

                dt = .BuscarDespachos()
                Session("listaDatos") = dt

                gvDatos.DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Excepción al eliminar Radicado temporal.")
        End Try
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("listaDatos") IsNot Nothing Then gvDatos.DataSource = CType(Session("listaDatos"), DataTable)
    End Sub

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("IdDespacho") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetalle(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al consultar el detalle de la venta: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalle(gv As ASPxGridView)
        If Session("IdDespacho") IsNot Nothing Then
            Dim dt As New DataTable
            Dim IdDespacho As Integer = Integer.Parse(Session("IdDespacho"))

            Dim info As New RutaServicioMensajeriaTransportadora
            With info
                .IdDespacho = IdDespacho
                .listIdDetalle.Add(IdDespacho)

                dt = .ObtenerDetalleDespacho()

                gv.DataSource = dt
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador de la gestión, por favor intente nuevamente.")
        End If
    End Sub


    Private Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        BuscarDespachos()
    End Sub

    Private Sub btnEjecucion_ServerClick(sender As Object, e As EventArgs) Handles btnEjecucion.ServerClick
        Dim IdDespacho As Integer = hidDespacho.Value
        cargareporte("../ReportesCEM/VisorReporteGuiaTransportadoraCEM.aspx?repo=guia&desp=" & IdDespacho.ToString)
        Threading.Thread.Sleep(5000)
        cargarHojaRuta("../ReportesCEM/VisorHojaRutaCEM.aspx?desp=" & IdDespacho.ToString)
    End Sub

    Private Sub cargareporte(ByVal url As String)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Reporte", "window.open('" & url & "');", True)
    End Sub

    Private Sub cargarHojaRuta(ByVal url As String)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Remisión", "window.open('" & url & "');", True)
    End Sub

End Class