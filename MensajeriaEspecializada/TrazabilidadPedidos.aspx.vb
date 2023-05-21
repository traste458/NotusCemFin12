Imports ILSBusinessLayer.Pedidos
Imports DevExpress.Web
Imports ILSBusinessLayer

Public Class TrazabilidadPedidos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            epNotificador.setTitle("Trazabilidad del Servicio")
            'ConsultarInformacion()
        End If
        If pgInfoProducto.IsCallback OrElse cpGeneral.IsCallback Then pgInfoProducto.DataBind()
    End Sub

    Private Sub ConsultarInformacion()
        Try
            Dim dtPedido As New Pedido
            Dim resultado As ResultadoProceso
            Dim row As DataRow
            ' If Session("numEntrega") IsNot Nothing Then
            With dtPedido
                .IdPedido = txtIdServicio.Value
                resultado = .ObtenerTrazabilidadPedido()
                Session("dtDetalle") = .DtDatos
                Session("dtDetalleGeneral") = .DtDetalle
                Session("dtInfoGeneral") = .DtGeneral
            End With


            If CType(Session("dtDetalleGeneral"), DataTable).Rows.Count > 0 Then
                For Each row In CType(Session("dtDetalleGeneral"), DataTable).Rows
                    lbFechaEnvio.Text = row("FechaEnvio").ToString
                    lbFechaEntrega.Text = row("FechaReal").ToString
                    lborigen.Text = row("Origen").ToString
                    lbDestino.Text = row("Destino").ToString
                    lbEstado.Text = row("Estado").ToString
                    Select Case row("idEstado").ToString
                        Case 101
                            imgEstado.ImageUrl = "~/images/TrackingCreado.png"
                        Case 102, 113
                            imgEstado.ImageUrl = "~/images/TrackingDespachado.png"
                        Case 111
                            imgEstado.ImageUrl = "~/images/Tracking En Transito.png"
                        Case 112
                            imgEstado.ImageUrl = "~/images/Tracking Pendiente Entrega.png"
                        Case 103, 104
                            imgEstado.ImageUrl = "~/images/TrackingEntregado.png"
                        Case Else
                            imgEstado.ImageUrl = "~/images/TrackingCreado.png"
                    End Select
                Next
            End If

            If CType(Session("dtDetalle"), DataTable) IsNot Nothing AndAlso CType(Session("dtDetalle"), DataTable).Rows.Count > 0 Then
                gridEncabezado.DataSource = CType(Session("dtDetalle"), DataTable)
                gridEncabezado.DataBind()
            Else
                Session("dtDetalle") = Nothing
                gridEncabezado.DataSource = Nothing
                gridEncabezado.DataBind()
            End If

            CargarInformacionGeneral(CType(Session("dtInfoGeneral"), DataTable))
            EnlazarDetalleInfoProducto(True)
            'End If
        Catch ex As Exception
            epNotificador.showError("Se genero un error al tratar de obtener la información: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim arrayAccion As String()
            arrayAccion = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue().ToString.Split(" - ")

            If Session("numEntrega") IsNot Nothing Then
                TryCast(sender, ASPxGridView).DataSource = ConsultarInformacionDetalle(Session("numEntrega"), Trim(arrayAccion(0)))
            End If
        Catch ex As Exception
            epNotificador.showError("Se presento un error al cargar el detalle material de la Instrucción. " & ex.Message)
        End Try
    End Sub

    Private Function ConsultarInformacionDetalle(ByVal numeroEntrega As Long, ByVal Fecha As String) As DataTable
        Dim dttable As New DataTable
        Try
            Dim dtPedido As New Pedido

            dttable = dtPedido.ConsultarTrazabilidadPedidos(numeroEntrega, Fecha)
        Catch ex As Exception
            epNotificador.showError("Se genero un error al tratar de obtener la información: " & ex.Message)
        End Try
        Return dttable
    End Function

    Private Sub CargarInformacionGeneral(dtDatosGenerales As DataTable)
        Try
            Dim dr As DataRow

            dr = dtDatosGenerales.NewRow

            For Each dr In dtDatosGenerales.Rows
                lbNumeroDocumento.Text = dr("numeroEntrega").ToString
                lblPedido.Text = dr("idPedido").ToString
                lblGuia.Text = dr("guia").ToString
                lblTransportadora.Text = dr("transportadora").ToString
                lbPeso.Text = dr("peso").ToString
                lbUnidades.Text = dr("numeroPiezas").ToString
                lbRemitente.Text = dr("remitente").ToString
                lbTelRemitente.Text = dr("telefonoRemitente").ToString
                lbDestinatario.Text = dr("destinatario").ToString
                lbTelDestinatario.Text = dr("telefonoDestinatario").ToString
                lbDirDestinatario.Text = dr("direccionDestinatario").ToString
                lbProceso.Text = dr("proceso").ToString

            Next
        Catch ex As Exception

        End Try
    End Sub

    Private Sub EnlazarDetalleInfoProducto(Optional ByVal forzarConsulta As Boolean = False)
        Try
            Dim dtDatos As DataTable

            If Session("detalleInfoProducto") Is Nothing OrElse forzarConsulta Then
                Dim detalle As New DetalleMaterialesEntrega
                With detalle
                    .NumeroEntrega = txtIdServicio.Value
                    .CargarDatos()
                    dtDatos = .Detalle()
                End With
                Session("detalleInfoProducto") = dtDatos
            Else
                dtDatos = CType(Session("detalleInfoProducto"), DataTable)
            End If

            With pgInfoProducto
                .DataSource = dtDatos
                .DataBind()
            End With

        Catch ex As Exception
            epNotificador.showError("Error al tratar de consultar información de productos del pedido.")
        End Try
    End Sub

    Private Sub pgInfoProducto_DataBinding(sender As Object, e As EventArgs) Handles pgInfoProducto.DataBinding
        If Session("detalleInfoProducto") IsNot Nothing Then pgInfoProducto.DataSource = CType(Session("detalleInfoProducto"), DataTable)
    End Sub

    Protected Sub btnBuscarTrazabilidad_ServerClick(sender As Object, e As EventArgs)
        ConsultarInformacion()
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "limpiar", "$('#txtIdServicio').val('');", True)
    End Sub
End Class