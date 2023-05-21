Imports ILSBusinessLayer.LogisticaInversa
Partial Public Class DetalleLogRecoleccion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            EncabezadoPagina1.showReturnLink("VistaLogOrdenRecoleccion.aspx?idOrden=" + Request.QueryString("idOrden"))
            EncabezadoPagina1.setTitle("Detalle de Historial de Modificaciones de Orden de Recolección")
            Me.CargaInicial(Request.QueryString("idHistorial"))
        End If
    End Sub

    Private Sub CargaInicial(ByVal idHistorial As Integer)
        Dim dt As DataTable = OrdenRecoleccionDetalle.ObtenerLog(idHistorial)
        Dim dtSeriales As DataTable = OrdenRecoleccionSerial.ObtenerLog(idHistorial)
        gvMateriales.DataSource = dt
        gvMateriales.DataBind()


        gvSeriales.DataSource = dtSeriales
        gvSeriales.DataBind()
        Session("dtSeriales") = dtSeriales

        dt = OrdenRecoleccionAccesorio.ObtenerLog(idHistorial)
        gvAccesorios.DataSource = dt
        gvAccesorios.DataBind()

        lnkVerTodos.Visible = False
    End Sub

    Protected Sub gvMateriales_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles gvMateriales.SelectedIndexChanged
        Dim dtSeriales As DataTable = Session("dtSeriales")
        If dtSeriales IsNot Nothing Then
            dtSeriales.DefaultView.RowFilter = "material='" + gvMateriales.SelectedValue + "'"
            gvSeriales.DataSource = dtSeriales
            gvSeriales.DataBind()
            lnkVerTodos.Visible = (dtSeriales.Rows.Count > 0)
        End If
    End Sub

    Protected Sub lnkVerTodos_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkVerTodos.Click
        Dim dtSeriales As DataTable = Session("dtSeriales")
        dtSeriales.DefaultView.RowFilter = ""
        gvSeriales.DataSource = dtSeriales
        gvSeriales.DataBind()
        lnkVerTodos.Visible = False
    End Sub
End Class