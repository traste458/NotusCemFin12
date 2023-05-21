Imports ILSBusinessLayer.LogisticaInversa
Partial Public Class NovedadesRecoleccion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Me.CargaInicial(Request.QueryString("idOrden"))
            EncabezadoPagina1.setTitle("Novedades de la Orden de Recolección")
            EncabezadoPagina1.showReturnLink("BusquedaOrdenesRecoleccion.aspx")
        End If
    End Sub

    Private Sub CargaInicial(ByVal idOrden As Integer)

        Dim orden As New OrdenRecoleccion(idOrden)
        With orden
            lblOrigen.Text = .Origen.Nombre
            lblDestino.Text = .Destino.Nombre
            lblObservacion.Text = .Observacion
            lblIdOrden.Text = .IdOrden
            lblTransportadora.Text = .Transportadora
            lblGuia.Text = .Guia
            lblOrdenServicio.Text = .OrdenServicio
            lblValorDeclarado.Text = .ValorDeclarado.ToString("C0")
            .Referencias.Seriales.CargarListaSeriales(.IdOrden)
            .Referencias.CargarListaReferencias(.IdOrden)
            .Accesorios.CargarListaAccesorios(.IdOrden)
        End With

        Dim dt As DataTable = NovedadSerial.ConsultarPorRecoleccion(idOrden)
        gvNovedadesSerial.DataSource = dt
        gvNovedadesSerial.DataBind()

        dt = NovedadCarga.ConsultarPorRecoleccion(idOrden)
        gvNovedadesCarga.DataSource = dt
        gvNovedadesCarga.DataBind()

        gvAccesorios.DataSource = orden.Accesorios.ListaAccesorios
        gvAccesorios.DataBind()

        gvSeriales.DataSource = orden.Referencias.Seriales.ListaSeriales
        gvSeriales.DataBind()
    End Sub

End Class