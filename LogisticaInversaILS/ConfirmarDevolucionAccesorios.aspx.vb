Imports ILSBusinessLayer.LogisticaInversa

Partial Public Class ConfirmarDevolucionAccesorios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        If Not IsPostBack Then
            EncabezadoPagina1.setTitle("Confirmación de Accesorios en devolución")
            If Request.QueryString("idOrden") IsNot Nothing Then
                EncabezadoPagina1.showReturnLink("LecturaDevolucionLogisticaInversa.aspx?idDevolucion=" & Request.QueryString("idDevolucion"))
                Me.CargaInicial(Request.QueryString("idOrden"))
                hfIdDevolucion.Value = Request.QueryString("idDevolucion")
            End If
        End If
    End Sub

    Private Sub CargaInicial(ByVal idOrden As Integer)
        Dim orden As New OrdenRecoleccion(idOrden)
        With orden
            .Accesorios.CargarListaAccesorios(.IdOrden)
            Me.CargarGridAccesorios(.Accesorios.ListaAccesorios)
            Session("orden") = orden
        End With
    End Sub
#Region "MANEJO DE ACCESORIOS"

    Private Sub CargarGridAccesorios(ByVal dtAccesorios As DataTable)
        gvAccesorios.DataSource = dtAccesorios
        gvAccesorios.DataBind()
    End Sub

    Private Sub gvAccesorios_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAccesorios.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim fila As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim txtCantidadEntregada As TextBox = CType(e.Row.FindControl("txtCantidadEntregada"), TextBox)
            If fila("cantidadEntregada") = 0 Then txtCantidadEntregada.Text = ""
        End If
    End Sub

#End Region

    Protected Sub btnConfirmarTop_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnConfirmarTop.Click, btnConfirmar.Click
        Dim orden As OrdenRecoleccion = Session("orden")
        Try
            With orden.Accesorios
                For i As Integer = 0 To .ListaAccesorios.Rows.Count - 1
                    .ListaAccesorios.Rows(i)("cantidadEntregada") = CType(gvAccesorios.Rows(i).FindControl("txtCantidadEntregada"), TextBox).Text
                Next
                .ConfirmarAccesorios()
            End With
            Response.Redirect("LecturaDevolucionLogisticaInversa.aspx?idDevolucion=" & hfIdDevolucion.Value, False)
        Catch
            EncabezadoPagina1.showError("Error al confirmar Accesorios")
        End Try

    End Sub
End Class