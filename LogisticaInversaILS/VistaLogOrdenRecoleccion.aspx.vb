Imports ILSBusinessLayer.LogisticaInversa
Partial Public Class VistaLogOrdenRecoleccion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            EncabezadoPagina1.setTitle("Historial de modificaciones de orden de recolección")
            Me.CargaInicial(Request.QueryString("idOrden"))
            EncabezadoPagina1.showReturnLink("BusquedaOrdenesRecoleccion.aspx")
        End If
    End Sub

    Private Sub CargaInicial(ByVal idOrden As Integer)
        If idOrden > 0 Then
            Dim dt As DataTable = OrdenRecoleccion.ObtenerLog(idOrden)
            gvLogRecoleccion.DataSource = dt
            gvLogRecoleccion.DataBind()
        Else
            EncabezadoPagina1.showError("No se han podido obtener el identificador de la recolección")
        End If

    End Sub

  
    Private Sub gvLogRecoleccion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvLogRecoleccion.SelectedIndexChanged
        Response.Redirect("DetalleLogRecoleccion.aspx?idHistorial=" & gvLogRecoleccion.SelectedValue & "&idOrden=" & Request.QueryString("idOrden"))
    End Sub
End Class