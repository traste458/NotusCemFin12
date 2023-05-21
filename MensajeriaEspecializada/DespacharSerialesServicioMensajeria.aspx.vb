Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes

Partial Public Class DespacharSerialesServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        ObtenerTamanoVentana()
        If Not Me.IsPostBack Then
            With epNotificador
                .setTitle("Despachar Seriales - Servicio de Mensajer&iacute;a")
                .showReturnLink("PoolServiciosNew.aspx")
            End With

            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With
            If idServicio > 0 Then
                CargarDatosParaProcesarRestricciones()

                Dim infoServicio As New ServicioMensajeria(idServicio:=idServicio)
                If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
                    Dim respuesta As New ResultadoProceso

                    If infoServicio.IdTipoServicio = Enumerados.TipoServicio.Venta Or infoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Then
                        Dim objEncabezado As EncabezadoServicioTipoVenta = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx")
                        infoServicio = New ServicioMensajeriaVenta(idServicio:=idServicio)
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()
                        Session("infoServicioMensajeria") = infoServicio

                        VisualizarDocumentosAsociados(idServicio)
                    ElseIf infoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Or infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or
                           infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia Or infoServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung Or
                           infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda Or Enumerados.TipoServicio.MercadoNaturalFeria Then
                        Response.Redirect("DespacharSerialesServicioFinanciero.aspx?idServicio=" & idServicio)
                    Else
                        Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()
                        Session("infoServicioMensajeria") = infoServicio
                    End If

                    If respuesta.Valor = 0 Then
                        Dim value As New ConfigValues("EXPREG_PERMISO_TIPO_SERVICIO")
                        Dim oExpReg As String = value.ConfigKeyValue
                        If oExpReg.IndexOf(infoServicio.IdTipoServicio) <> -1 Then
                            CargarTiposDeNovedad()
                            CargarTransportadoras()
                            CargarNovedades(idServicio)
                            pnlLectura.Visible = False
                            pnlEliminacion.Visible = False
                            lbCerrar.Enabled = True
                            lbVerSeriales.Visible = False
                            lbAdicionarReferencia.Visible = False
                            cbEntegaAgente.Visible = False
                        Else
                            CargarDetalleDeReferencias(idServicio)
                            CargarDetalleDeMsisdn(idServicio)
                            CargarTiposDeNovedad()
                            CargarTransportadoras()
                            CargarNovedades(idServicio)
                        End If
                    Else
                        pnlGeneral.Enabled = False
                        epNotificador.showWarning(respuesta.Mensaje)
                    End If
                Else
                    epNotificador.showWarning("No fué posible encontrar los datos del servicio.")
                End If
            Else
                pnlGeneral.Enabled = False
                epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Dim idUsuario As Integer
        Dim resultado As ResultadoProceso
        Dim bValidarRegion As Boolean
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)

            Select Case infoServicio.IdTipoServicio
                Case Enumerados.TipoServicio.VentaWeb
                    bValidarRegion = False
                Case Else
                    bValidarRegion = True
            End Select

            resultado = infoServicio.LeerSerial(txtSerial.Text.Trim, idUsuario, bValidarRegion)
            If resultado.Valor = 0 Then
                CargarDetalleDeReferencias(idServicio)
                epNotificador.showSuccess(resultado.Mensaje)
            Else
                epNotificador.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar serial. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbCerrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCerrar.Click
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Dim idUsuario As Integer
        Dim resultado As ResultadoProceso
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)
            With infoServicio
                .IdUsuarioCierre = idUsuario
                If Not String.IsNullOrEmpty(txtNumeroGuia.Text) Then .NumeroGuia = txtNumeroGuia.Text
                If ddlTransportadora.SelectedValue <> "-1" Then .IdTransportadora = ddlTransportadora.SelectedValue

                resultado = .CerrarDespacho()
                If resultado.Valor = 0 Then
                    Response.Redirect("PoolServiciosNew.aspx?resOk=true&codRes=2", False)
                    epNotificador.showSuccess(resultado.Mensaje)
                    pnlGeneral.Enabled = False
                Else
                    epNotificador.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Imposible cerrar despacho. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbVerSeriales_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbVerSeriales.Click
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Try
            Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalle.GenerarDataTable()
            With gvSeriales
                .DataSource = dtDatos
                If dtDatos IsNot Nothing Then .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Serial(es)"
                .DataBind()
            End With
            MetodosComunes.mergeGridViewFooter(gvSeriales)
            With dlgSerial
                .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
                .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
                .Show()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de mostrar seriales. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnEliminarSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEliminarSerial.Click
        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            Dim infoSerial As New DetalleSerialServicioMensajeria(idServicio:=infoServicio.IdServicioMensajeria, serial:=txtSerialEliminar.Text.Trim)
            Dim resultado As ResultadoProceso
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            If infoSerial.Registrado Then
                If infoSerial.IdServicio = infoServicio.IdServicioMensajeria Then
                    resultado = infoSerial.Eliminar(idUsuario)
                    If resultado.Valor = 0 Then
                        txtSerialEliminar.Text = ""
                        CargarDetalleDeReferencias(infoServicio.IdServicioMensajeria)
                        epNotificador.showSuccess("El serial fue desviculado satisfactoriamente.")
                    End If
                Else
                    epNotificador.showWarning("El serial proporcionado no está asociado al servicio actual. Por favor verifique")
                End If
            Else
                epNotificador.showWarning("El serial proporcionado para desvincular no ha sido despachado. Por favor verifique")
            End If

        Catch ex As Exception
            epNotificador.showError("Error al tratar de desvicular serial del despacho. ")
        End Try
    End Sub

    Private Sub gvListaReferencias_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvListaReferencias.RowCommand
        Try
            Dim idMaterialServicio As Integer = CInt(e.CommandArgument)
            Dim detalleReferencia As DetalleMaterialServicioMensajeriaColeccion = CType(Session("detalleReferenciaDesp"), DetalleMaterialServicioMensajeriaColeccion)
            Dim infoMaterial As DetalleMaterialServicioMensajeria = detalleReferencia.ItemPorIdentificador(idMaterialServicio)

            If e.CommandName = "eliminar" Then
                EliminarMaterial(infoMaterial)
            ElseIf e.CommandName = "editar" Then
                ddlMaterial.Enabled = False
                txtFiltroMaterial.Enabled = False
                pnlBotonEdicionReferencia.Visible = True
                lbRegistrarReferencia.Visible = False
                With infoMaterial
                    txtFiltroMaterial.Text = .Material
                    CargarListadoDeMateriales(.Material)
                    txtCantidad.Text = .Cantidad
                    txtCantidadLeida.Text = .CantidadLeida
                    hfMaterialAct.Value = .IdMaterialServicio
                End With

                With dlgEdicionReferencia
                    .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
                    .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
                    .Show()
                End With
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de evaluar comando. Por favor intente nuevamente")
        End Try
    End Sub

    Private Sub cpFiltroMaterial_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMaterial.Execute
        If e.Parameter = "filtrarMaterial" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMaterial.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeMateriales(filtroRapido)
        End If
    End Sub

    Private Sub lbActualizarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbActualizarRef.Click
        Try
            Dim detalleReferencia As DetalleMaterialServicioMensajeriaColeccion = CType(Session("detalleReferenciaDesp"), DetalleMaterialServicioMensajeriaColeccion)
            Dim infoMaterial As DetalleMaterialServicioMensajeria = detalleReferencia.ItemPorIdentificador(CInt(hfMaterialAct.Value))
            Dim indiceMaterial As Integer = detalleReferencia.IndiceDe(ddlMaterial.SelectedValue)
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then idUsuario = CInt(Session("usxp001"))

            If indiceMaterial <> -1 AndAlso detalleReferencia(indiceMaterial).IdMaterialServicio <> infoMaterial.IdMaterialServicio Then
                epNotificador.showWarning("Ya existe otro registro con el material seleccionado. Por favor verifique")
            Else
                Dim resultado As ResultadoProceso
                With infoMaterial
                    .Cantidad = CInt(txtCantidad.Text)
                    .IdUsuarioRegistra = idUsuario
                    resultado = .Modificar()
                    If resultado.Valor = 0 Then
                        epNotificador.showSuccess("El material fue actualizado satisfactoriamente")
                        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
                        CargarDetalleDeReferencias(infoServicio.IdServicioMensajeria)
                    Else
                        epNotificador.showError(resultado.Mensaje)
                    End If
                End With
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de actualizar referencia. " & ex.Message)
        End Try
    End Sub

    Private Sub gvListaReferencias_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaReferencias.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try
                Dim cantidadLeida As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("CantidadLeida"))
                Dim cantidadPedida As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("Cantidad"))
                Dim idEstado As Integer = CType(Session("infoServicioMensajeria"), ServicioMensajeria).IdEstado
                Dim ibEliminar As ImageButton = CType(e.Row.FindControl("ibEliminar"), ImageButton)
                Dim ibEditar As ImageButton = CType(e.Row.FindControl("ibEditar"), ImageButton)
                Dim arrEstadoActMaterial As ArrayList = CType(Session("arrEstadoActMaterial"), ArrayList)

                ibEliminar.Visible = Not CBool(cantidadLeida)
                ibEditar.Visible = arrEstadoActMaterial.Contains(idEstado.ToString)

                If cantidadLeida > 0 AndAlso cantidadLeida = cantidadPedida Then
                    e.Row.BackColor = Color.Aquamarine
                Else
                    e.Row.BackColor = Nothing
                End If
            Catch ex As Exception
                epNotificador.showError("Error al tratar de aplicar restricciones. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbAdicionarReferencia_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAdicionarReferencia.Click
        Try
            ddlMaterial.Enabled = True
            txtFiltroMaterial.Enabled = True
            pnlBotonEdicionReferencia.Visible = False
            lbRegistrarReferencia.Visible = True
            CargarListadoDeMateriales()
            txtFiltroMaterial.Text = ""
            txtCantidadLeida.Text = "0"
            txtCantidad.Text = ""

            With dlgEdicionReferencia
                .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
                .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
                .Show()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de inicializar formulario de registro de referencias. " & ex.Message)
        End Try
    End Sub

    Private Sub lbRegistrarReferencia_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRegistrarReferencia.Click
        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            Dim detalleReferencia As DetalleMaterialServicioMensajeriaColeccion = CType(Session("detalleReferenciaDesp"), DetalleMaterialServicioMensajeriaColeccion)
            Dim infoMaterial As New DetalleMaterialServicioMensajeria
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then idUsuario = CInt(Session("usxp001"))

            If detalleReferencia.IndiceDe(ddlMaterial.SelectedValue) <> -1 Then
                epNotificador.showWarning("El material que está tratando de adicionar ya existe en el listado. Por favor verifique")
            Else
                Dim resultado As ResultadoProceso
                With infoMaterial
                    .IdServicio = infoServicio.IdServicioMensajeria
                    .Material = ddlMaterial.SelectedValue
                    .Cantidad = CInt(txtCantidad.Text)
                    .IdUsuarioRegistra = idUsuario
                    resultado = .Adicionar()
                    If resultado.Valor = 0 Then
                        epNotificador.showSuccess("El material fue actualizado satisfactoriamente")
                        CargarDetalleDeReferencias(infoServicio.IdServicioMensajeria)
                    Else
                        epNotificador.showError(resultado.Mensaje)
                    End If
                End With
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de adicionar referencia. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbMostrarFormNovedad_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbMostrarFormNovedad.Click
        ddlTipoNovedad.ClearSelection()
        txtObservacionNovedad.Text = ""
        With dlgNovedad
            .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
            .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
            .Show()
        End With
    End Sub

    Private Sub lbRegistrarNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRegistrarNovedad.Click
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer = 1

        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim novedad As New NovedadServicioMensajeria
            With novedad
                .IdServicioMensajeria = infoServicio.IdServicioMensajeria
                .Observacion = txtObservacionNovedad.Text.Trim
                .IdTipoNovedad = CInt(ddlTipoNovedad.SelectedValue)
                resultado = .Registrar(idUsuario)

                If resultado.Valor = 0 Then
                    epNotificador.showSuccess(resultado.Mensaje)
                    txtObservacionNovedad.Text = ""
                    CargarNovedades(infoServicio.IdServicioMensajeria)
                Else
                    epNotificador.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar la novedad. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvListaMsisdn_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaMsisdn.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imagen As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgBloquear"), System.Web.UI.WebControls.Image)
            Dim bloquear As Boolean = CBool(CType(e.Row.DataItem, DataRowView).Item("bloquear"))
            If Not bloquear Then
                imagen.ImageUrl = "~/images/BallGreen.gif"
            Else
                imagen.ImageUrl = "~/images/BallRed.gif"
            End If
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub VisualizarDocumentosAsociados(idServicio As Integer)
        Try
            Dim dtDocumentos As DataTable = ServicioMensajeriaVenta.ObtenerDocumentosAsociados(idServicio)
            If dtDocumentos IsNot Nothing AndAlso dtDocumentos.Rows.Count > 0 Then
                Dim strMensaje As New StringBuilder
                For Each doc As DataRow In dtDocumentos.Rows
                    strMensaje.Append("- " & doc("nombre"))
                    If doc("recibo") = "1" Then
                        strMensaje.Append("&nbsp;<img src=" & Chr(34) & "../images/recibir.png" & Chr(34) & " style=" & Chr(34) & "width: 16px; height: 16px" & Chr(34) & "/>")
                    End If
                    If doc("entrega") = "1" Then
                        strMensaje.Append("&nbsp;<img src=" & Chr(34) & "../images/enviar.png" & Chr(34) & " style=" & Chr(34) & "width: 16px; height: 16px" & Chr(34) & "/>")
                    End If
                    strMensaje.Append("</br>")
                Next
                ClientScript.RegisterStartupScript(Me.GetType(), "Mensaje", "MostrarDocumentos('Documentos Asociados','" & strMensaje.ToString() & "')", True)
            End If
        Catch : End Try
    End Sub

    Private Sub CargarDetalleDeReferencias(ByVal idServicio As Integer)
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            With gvListaReferencias
                .DataSource = dtAux
                .DataBind()
            End With
            Session("detalleReferenciaDesp") = detalleReferencia

            Dim detserial As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtdetserial As DataTable = detserial.GenerarDataTable()
            'Configurar validador de Serial
            ConfigurarValidacionSerial(detalleReferencia)

            Dim cantPedida As Integer
            Dim cantLeida As Integer
            Dim hayPendiente As Boolean = True
            If dtAux IsNot Nothing AndAlso dtAux.Rows.Count > 0 Then
                Integer.TryParse(dtAux.Compute("SUM(cantidad)", "").ToString, cantPedida)
                Integer.TryParse(dtAux.Compute("SUM(cantidadLeida)", "").ToString, cantLeida)

                Dim drs() As DataRow = dtAux.Select("CantidadLeida=0 OR CantidadLeida < Cantidad")
                If drs IsNot Nothing AndAlso drs.Length = 0 Then hayPendiente = False
            End If
            lbVerSeriales.Visible = CBool(cantLeida)

            If Not hayPendiente Then
                pnlLectura.Enabled = False
                Dim infoSerivicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
                If infoSerivicio.IdEstado = 101 Then
                    epNotificador.showWarning("Ya se leyó la totalidad de seriales requeridos. Por favor proceda a cerrar el despacho.")
                    lbCerrar.Enabled = True
                Else
                    lbCerrar.Enabled = False
                End If
            Else

                If Session("infoServicioMensajeria").IdTipoServicio = Enumerados.TipoServicio.ServicioTecnico Then
                    If dtdetserial IsNot Nothing AndAlso dtdetserial.Rows.Count > 0 Then
                        Dim rows() As DataRow = dtdetserial.Select("requierePrestamoEquipo = 'True'")
                        If rows.Length = 0 Then
                            lbCerrar.Enabled = True
                            'lbVerSeriales.Enabled = True
                            lbVerSeriales.Visible = True
                            lbAdicionarReferencia.Enabled = False
                            pnlLectura.Enabled = False
                            pnlEliminacion.Enabled = False
                        Else
                            lbCerrar.Enabled = False
                            lbAdicionarReferencia.Enabled = True
                            pnlLectura.Enabled = True
                            pnlEliminacion.Enabled = True
                            lbVerSeriales.Visible = False
                        End If
                    End If
                Else

                    lbCerrar.Enabled = False
                    pnlLectura.Enabled = CBool(cantPedida)
                    pnlEliminacion.Enabled = CBool(cantLeida)
                End If
                If cantPedida = 0 Then epNotificador.showWarning("El servicio no tiene referencias asignadas. No se puede proceder con el despacho")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleDeMsisdn(ByVal idServicio As Integer)
        Try
            Dim detalleMsisdn As New DetalleMsisdnEnServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalleMsisdn.GenerarDataTable()
            With gvListaMsisdn
                .DataSource = dtDatos
                .DataBind()
            End With
            Dim drAux() As DataRow = dtDatos.Select("bloquear=1")
            If drAux.Length > 0 Then
                lbCerrar.Enabled = False
                epNotificador.showWarning("<i>Uno o mas mines ya fueron adicionados a un radicado activo.</i>")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de MSISDNs asignados al servicio. " & ex.Message)
        End Try

    End Sub

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me.altoVentana = CInt(arrAux(0))
                Me.anchoVentana = CInt(arrAux(1))
            End If
        End If
    End Sub

    Private Sub EliminarMaterial(ByVal infoMaterial As DetalleMaterialServicioMensajeria)
        Try
            Dim idUsuario As Integer = 1
            If Session("usxp01") IsNot Nothing Then idUsuario = CInt(Session("usxp001"))
            If infoMaterial.Registrado Then
                Dim resultado As ResultadoProceso = infoMaterial.Eliminar(idUsuario)
                If resultado.Valor = 0 Then
                    epNotificador.showSuccess("El material fue eliminado satisfactoriamente")
                    Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
                    CargarDetalleDeReferencias(infoServicio.IdServicioMensajeria)
                Else
                    epNotificador.showError(resultado.Mensaje)
                End If
            Else
                epNotificador.showWarning("Imposible recuperar información del material. Por favor intente nuevamente.")
            End If

        Catch ex As Exception
            epNotificador.showError("Error al tratar de eliminar material. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoDeMateriales(Optional ByVal filtroRapido As String = "")
        If Not String.IsNullOrEmpty(filtroRapido.Trim) Then
            Dim dtMaterial As DataTable = ObtenerListaMateriales(filtroRapido)
            With ddlMaterial
                .DataSource = dtMaterial
                .DataTextField = "referenciaCompuesta"
                .DataValueField = "material"
                .DataBind()
            End With
        Else
            ddlMaterial.Items.Clear()
        End If
        With ddlMaterial
            lblMateriales.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un Material", "0"))
        End With
    End Sub

    Private Function ObtenerListaMateriales(ByVal filtro As String) As DataTable
        Dim listaMaterial As New Productos.MaterialColeccion
        Dim dtMaterial As DataTable
        With listaMaterial
            .FiltroRapido = filtro
            dtMaterial = .GenerarDataTable()
        End With
        Dim dcAux As New DataColumn("referenciaCompuesta")
        dcAux.Expression = "material + ' - '+ referencia"
        dtMaterial.Columns.Add(dcAux)
        Return dtMaterial
    End Function

    Private Sub CargarDatosParaProcesarRestricciones()
        Try
            Dim arrEstadoActMaterial As New ArrayList(MetodosComunes.seleccionarConfigValue("ESTADOS_PERMTIDOS_ACT_MATERIAL_SME").Split(","))
            Session("arrEstadoActMaterial") = arrEstadoActMaterial
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar datos para aplicar restricciones. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=4)
            With ddlTipoNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarTransportadoras()
        Dim objTransp As New TransportadoraColeccion()
        With objTransp
            .Estado = True
            .CargarDatos()
        End With

        With ddlTransportadora
            .DataTextField = "Nombre"
            .DataValueField = "IdTransportadora"
            .DataSource = objTransp
            .DataBind()
            .Items.Insert(0, New ListItem("Seleccione...", "-1"))
        End With
    End Sub

    Private Sub ConfigurarValidacionSerial(detalleReferencia As DetalleMaterialServicioMensajeriaColeccion)
        Dim listExpresion As New List(Of String)
        Dim expresion As String

        If detalleReferencia IsNot Nothing AndAlso detalleReferencia.Count > 0 Then
            Dim listProductos As New List(Of Integer)
            For Each referencia As DetalleMaterialServicioMensajeria In detalleReferencia
                listProductos.Add(referencia.IdProducto)
            Next

            Dim objConfigSerial As New ConfiguracionLecturaSerialColeccion()
            With objConfigSerial
                .ListaProducto = listProductos
                .CargarDatos()
            End With

            If objConfigSerial.Count > 0 And listProductos.Count > 0 Then
                revSerial.ValidationExpression = "^(" & objConfigSerial.ObtenerExpresionRegular() & ")$"
            End If
        End If
    End Sub

#End Region

End Class