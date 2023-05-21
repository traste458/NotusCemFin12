Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text
Imports ILSBusinessLayer.Comunes

Partial Public Class PoolServicios
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _altoVentana As Integer
    Private _anchoVentana As Integer
    Private arrEstadosConfirmacionConReagenda As New ArrayList
#End Region
#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 22058
        Session("usxp009") = 118
        Session("usxp007") = 198
#End If



        Seguridad.ValidarSesion(EO.Web.CallbackPanel.Current)
        epPoolServicios.clear()
        ObtenerTamanoVentana()
        If Not IsPostBack Then
            Try
                Session.Remove("dtInfoPermisosOpcRestringidas")
                Session.Remove("dtInfoRestriccionOpcEstado")
                With epPoolServicios
                    .setTitle("Pool Servicios")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With

                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()
                CargarEstadosPermiteConfirmarConreagenda()
                If Request.QueryString("resOk") IsNot Nothing Then
                    Select Case Request.QueryString("codRes")
                        Case "1"
                            epPoolServicios.showSuccess("El servicio fue confirmado satisfactoriamente.")
                        Case "2"
                            epPoolServicios.showSuccess("El despacho fue cerrado satisfactoriamente.")
                        Case "3"
                            epPoolServicios.showSuccess("El cambio de servicio fue finalizado satisfactoriamente.")
                    End Select
                End If
                CargarEstado()
                CargarBodega()
                CargarCiudad()
                CargarServicio()
                CargarVIP()
                CargaTiposNovedad()

                'Manejo de eventos JS
                txtNuevoRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtMIN.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                rbReactivacionConCambio.Attributes.Add("onClick", "javascript:validaSeleccionReactivacion()")
                rbReactivacionSinCambio.Attributes.Add("onClick", "javascript:validaSeleccionReactivacion()")

                'Se valida la existencia de servicios tipo Venta pendientes.
                Dim nCantidadServicios As Integer = HerramientasMensajeria.ObtieneCantidadServiciosPendientes(Enumerados.TipoServicio.Venta)
                Dim sPerfilesVenta As String = MetodosComunes.seleccionarConfigValue("PERFILES_GESTION_VENTA_TELEFONICA")
                If nCantidadServicios > 0 And sPerfilesVenta.Contains(CStr(Session("usxp009"))) Then
                    lblMensajeVentas.Text = lblMensajeVentas.Text.Replace("[0]", nCantidadServicios.ToString)
                    dlgAvisoVentas.Show()
                End If

                If ExisteRestriccionAutocargadoDatos() Then
                    cusFiltros.Enabled = False
                    Dim dtDatos As DataTable
                    dtDatos = CargarPool()
                    If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                        EnlazarDatos(dtDatos)
                    Else
                        epPoolServicios.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                    End If
                Else
                    cusFiltros.Enabled = True
                End If
                If Integer.Parse(Session("usxp009").ToString) = Enumerados.PerfilesMensajeria.SoloConsulta_Mensajeria_Especializada Then
                    ddlTipoServicio.SelectedValue = Enumerados.TipoServicio.TiendaVirtual
                    ddlTipoServicio.Enabled = False
                End If
            Catch ex As Exception
                gvDatos.DataSource = Nothing : gvDatos.DataBind()
                epPoolServicios.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        BuscarDatos()
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            Dim dtDatos As DataTable = CargarPool() 'CType(Session("dtPoolServicios"), DataTable)
            gvDatos.PageIndex = e.NewPageIndex
            EnlazarDatos(dtDatos)
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try
                Dim idEstado As String = CType(e.Row.DataItem, DataRowView).Item("idEstado").ToString
                Dim urgente As Boolean = CBool(CType(e.Row.DataItem, DataRowView).Item("urgente"))
                Dim reagenda As Boolean = CBool(CType(e.Row.DataItem, DataRowView).Item("reagenda"))
                Dim idTipoServicio As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("idTipoServicio"))
                Dim idServicio As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("idServicioMensajeria").ToString)
                Dim idPerfil As Integer
                If Session("usxp009") IsNot Nothing Then Integer.TryParse(Session("usxp009"), idPerfil)

                ' se verifica si ya tiene activo el chec de reagena
                Dim checkReagenda As WebControls.CheckBox = CType(e.Row.FindControl("CheReagenda"), WebControls.CheckBox)
                Dim fechaAgendaEntrega As Date
                If Not IsDBNull(CType(e.Row.DataItem, DataRowView).Item("fechaAgendaEntrega")) Then fechaAgendaEntrega = CDate(CType(e.Row.DataItem, DataRowView).Item("fechaAgendaEntrega"))

                Dim idCiudadBodega As Integer
                Integer.TryParse(CType(e.Row.DataItem, DataRowView).Item("idCiudadBodega").ToString, idCiudadBodega)


                Dim arrControles() As String = {"lnkConfirma", "lnkDespacho", "lnkAdendoServicio", "lbCambioServicio", _
                                              "lbModificarServicio", "lbAbrirServicio", "lnkAsignarZona", "lbUrgente", _
                                              "lnkEditar", "ibCancelarServicio", "lbReactivar", "lbServicioTecnico", "CheReagenda", _
                                                "lbDevolverVenta", "lbLegalizar", "LbAsignacion", "lbConfirmaCorp", "LnkEditCorp", _
                                                "LbAsignacionP", "lbConfirmaCorpP", "LnkEditCorpP", "LnkCamCorpP", "LnkCamCorp"}

                e.Row.CssClass = "alterColor"

                '#If Not DEBUG Then
                For indice As Integer = 0 To arrControles.Length - 1
                    Dim ctrl As Control = e.Row.FindControl(arrControles(indice))
                    If ctrl IsNot Nothing AndAlso ctrl.ID <> "CheReagenda" Then
                        ctrl.Visible = EsVisibleOpcionRestringida(ctrl.ID, idCiudadBodega, idTipo:=idTipoServicio)
                        If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, idEstado)
                    Else
                        If EsVisibleOpcionRestringida(ctrl.ID, idCiudadBodega) And EsVisibleSegunEstado(ctrl.ID, idEstado) And reagenda = True Then
                            checkReagenda.Enabled = True
                            'checkReagenda.Attributes.Add("onclick", "if (!confirm (' ¿Realmente desea quitar el check de reagendamiento? ')) {return false} ")

                        Else
                            checkReagenda.Enabled = False
                        End If
                    End If
                Next
                '#End If

                'Controla el icono a visualizar cuándo el elemento está marcado como urgente
                If urgente Then
                    CType(e.Row.FindControl("imgUrgente"), System.Web.UI.WebControls.Image).ImageUrl = "../images/emblem-important.png"
                End If

                'Controla la visualización del botón de confirmación dependiendo si tiene el check de reagenda.
                Dim lbConfirma As LinkButton = CType(e.Row.FindControl("lnkConfirma"), LinkButton)
                If reagenda Then
                    checkReagenda.Checked = True

                    If Not CType(Session("arrEstadosConfirmacionConReagenda"), ArrayList).Contains(idEstado) Then
                        If lbConfirma.Visible Then
                            lbConfirma.Visible = False
                        End If
                    End If
                End If

                If fechaAgendaEntrega <> Date.MinValue Then
                    If lbConfirma.Visible Then
                        lbConfirma.Visible = False
                    End If
                End If

                'Se controla la visualización del icono de gestión para Servicio Técnico
                Dim lbServicioTecnico As LinkButton = CType(e.Row.FindControl("lbServicioTecnico"), LinkButton)
                If lbServicioTecnico.Visible And idTipoServicio = Enumerados.TipoServicio.ServicioTecnico Then
                    Dim objDetalleSeriales As New DetalleSerialServicioMensajeriaColeccion(idServicio)
                    If objDetalleSeriales.GenerarDataTable().Select("idEstadoSerial = " & Enumerados.EstadoSerialCEM.ServicioTécnico & " Or idEstadoSerial = " & Enumerados.EstadoSerialCEM.EnRuta).Length = 0 Then
                        lbServicioTecnico.Visible = False
                    End If
                End If

                e.Row.Cells(0).Attributes("rowspan") = "2"
                e.Row.Cells(e.Row.Cells.Count - 1).Attributes("rowspan") = "2"
                'If idTipoServicio = Enumerados.TipoServicio.TiendaVirtual Then
                '    CType(e.Row.FindControl("lbModificarServicio"), LinkButton).Visible = False
                'End If

                'Usuario de solo consulta en servicio mensajeria
                If Integer.Parse(Session("usxp009").ToString) = Enumerados.PerfilesMensajeria.SoloConsulta_Mensajeria_Especializada Then
                    For indice As Integer = 0 To arrControles.Length - 1
                        Dim ctrl As Control = e.Row.FindControl(arrControles(indice))
                        ctrl.Visible = False
                    Next
                    Dim ctrllbVer As Control = e.Row.FindControl("lbVer")
                    ctrllbVer.Visible = True
                End If
            Catch ex As Exception
                epPoolServicios.showError("Se generó un error inesperado al tratar de cargar el Pool: " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        If Not e.CommandName = "Sort" Then

            Dim idServicio As Integer
            Dim idTipoServicio As Integer

            Integer.TryParse(e.CommandArgument.ToString, idServicio)

            If Not e.CommandName = "Page" Then
                Dim obj As WebControl = TryCast(e.CommandSource, WebControl)
                If obj IsNot Nothing Then
                    Dim gvr As GridViewRow = TryCast(obj.NamingContainer, GridViewRow)
                    If gvr IsNot Nothing Then idTipoServicio = gvDatos.DataKeys(gvr.RowIndex).Values("idTipoServicio")
                End If
            End If

            If e.CommandName = "ver" Then
                With dlgVerInformacionServicio
                    .Width = Unit.Pixel(Me._anchoVentana * 0.94999999999999996)
                    .Height = Unit.Pixel(Me._altoVentana * 0.93000000000000005)

                    If idTipoServicio = Enumerados.TipoServicio.Venta Then
                        .ContentUrl = "VerInformacionServicioTipoVenta.aspx?idServicio=" & idServicio.ToString
                    ElseIf idTipoServicio = Enumerados.TipoServicio.Siembra Then
                        .ContentUrl = "VerInformacionServicioTipoSiembra.aspx?idServicio=" & idServicio.ToString
                    ElseIf idTipoServicio = Enumerados.TipoServicio.VentaCorporativa Or idTipoServicio = Enumerados.TipoServicio.VentaCorporativaPrestamo Then
                        .ContentUrl = "VerInformacionServicioTipoVentaCorporativa.aspx?idServicio=" & idServicio.ToString
                    Else
                        .ContentUrl = "VerInformacionServicio.aspx?idServicio=" & idServicio.ToString
                    End If
                    .Show()
                End With

            ElseIf e.CommandName = "adicionarNovedad" Then

            ElseIf e.CommandName = "confirmar" Then
                If idTipoServicio = Enumerados.TipoServicio.Venta Then
                    Response.Redirect("ConfirmacionServicioTipoVenta.aspx?idServicio=" & idServicio.ToString, False)
                ElseIf idTipoServicio = Enumerados.TipoServicio.Siembra Then
                    Response.Redirect("ConfirmacionServicioTipoSiembra.aspx?idServicio=" & idServicio.ToString, False)
                Else
                    Response.Redirect("ConfirmacionServicio.aspx?idServicio=" & idServicio.ToString, False)
                End If

            ElseIf e.CommandName = "despachar" Then
                If idTipoServicio = Enumerados.TipoServicio.Siembra Then
                    Response.Redirect("AlistamientoSerialesSiembra.aspx?idServicio=" & idServicio.ToString, False)
                ElseIf (idTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Or idTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros) Then
                    Response.Redirect("DespacharSerialesServicioFinanciero.aspx?idServicio=" & idServicio.ToString, False)
                Else
                    Response.Redirect("DespacharSerialesServicioMensajeria.aspx?idServicio=" & idServicio.ToString, False)
                End If

            ElseIf e.CommandName = "asignarZona" Then
                Response.Redirect("AsignarZonaServicioMensajeria.aspx?idServicio=" & idServicio.ToString, False)

            ElseIf e.CommandName = "cambioServicio" Then
                Response.Redirect("RegistrarCambioServicio.aspx?idServicio=" & idServicio.ToString, False)

            ElseIf e.CommandName = "modificarServicio" Then
                If idTipoServicio = Enumerados.TipoServicio.Siembra Then
                    Response.Redirect("EditarServicioTipoSiembra.aspx?idServicio=" & idServicio.ToString, False)
                ElseIf idTipoServicio = Enumerados.TipoServicio.Venta Then
                    Response.Redirect("EditarServicioTipoVenta.aspx?idServicio=" & idServicio.ToString, False)
                Else
                    Response.Redirect("EditarServicio.aspx?idServicio=" & idServicio.ToString, False)
                End If

            ElseIf e.CommandName = "marcarUrgente" Then
                MarcarUrgente(idServicio)

            ElseIf e.CommandName = "abrirServicio" Or e.CommandName = "cancelarServicio" Then
                Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)

                Dim bPuedeCancelar As Boolean = HerramientasMensajeria.ValidarNovedadEnProcesoActual(idServicio)

                pnlMensajeRestriccionNovedad.Visible = Not bPuedeCancelar
                txtObservacionModificacion.Text = String.Empty
                hfIdServicio.Value = idServicio.ToString
                lbAbrirServicio.Visible = IIf(e.CommandName = "abrirServicio", True, False)
                pnlEstadoReapertura.Visible = IIf(e.CommandName = "abrirServicio", True, False)
                lbCancelarServicio.Visible = IIf(e.CommandName = "cancelarServicio", True, False)
                CragarEstadoReapertura(objServicio.IdEstado)

                lbAbrirServicio.Enabled = bPuedeCancelar
                lbCancelarServicio.Enabled = bPuedeCancelar

                dlgAbrirServicio.Show()

            ElseIf e.CommandName = "adendoServicio" Then
                DescargarAdendo(idServicio)

            ElseIf e.CommandName = "reactivarServicio" Then
                txtObservacionReactivacion.Text = ""
                hfReactivarIdServicio.Value = idServicio.ToString()
                dlgReactivarServicio.Show()

            ElseIf e.CommandName = "gestionarServicioTecnico" Then
                Response.Redirect("GestionServicioTecnico.aspx?idServicio=" & idServicio.ToString, False)

            ElseIf e.CommandName = "DevolverVenta" Then ' Devolución venta
                hfIdServicio.Value = idServicio.ToString
                dlgDevolverVenta.Show()
            ElseIf e.CommandName = "LegalizarFinanciero" Then
                If (idTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Or idTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or idTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                    txtLegaliza.Text = ""
                    hflegalizaIdServicio.Value = idServicio.ToString
                    dlgLegalizarServicio.Show()
                Else
                    epPoolServicios.showWarning("Funcionalidad exclusiva de servicios financieros.")
                End If

            ElseIf e.CommandName = "asignarSeriales" Then
                If idTipoServicio = Enumerados.TipoServicio.VentaCorporativa Or idTipoServicio = Enumerados.TipoServicio.VentaCorporativaPrestamo Then
                    Response.Redirect("DespacharSerialesServicioCorporativo.aspx?idServicio=" & idServicio.ToString, False)
                End If
            ElseIf e.CommandName = "confirmaServicioCorp" Then
                If idTipoServicio = Enumerados.TipoServicio.VentaCorporativa Or idTipoServicio = Enumerados.TipoServicio.VentaCorporativaPrestamo Then
                    Response.Redirect("ConfirmacionServicioTipoVentaCorporativa.aspx?idServicio=" & idServicio.ToString, False)
                End If
            ElseIf e.CommandName = "editaServicioCorp" Then
                If idTipoServicio = Enumerados.TipoServicio.VentaCorporativa Or idTipoServicio = Enumerados.TipoServicio.VentaCorporativaPrestamo Then
                    Response.Redirect("EditarServicioTipoVentaCorporativa.aspx?idServicio=" & idServicio.ToString, False)
                End If
            ElseIf e.CommandName = "desCamServicioCorp" Then
                If idTipoServicio = Enumerados.TipoServicio.VentaCorporativa Or idTipoServicio = Enumerados.TipoServicio.VentaCorporativaPrestamo Then
                    Response.Redirect("RegistrarCambioServicio.aspx?idServicio=" & idServicio.ToString, False)
                End If
            End If
        End If
    End Sub

    Private Sub DescargarAdendo(ByVal idServicio As Long)
        Try
            Dim rpt As ReporteCrystal

            rpt = New ReporteCrystal("HojaAdendo", Server.MapPath("../MensajeriaEspecializada/Reportes"))

            rpt.agregarParametroDiscreto("@idServicioMensajeria", idServicio)
            Dim ruta As String = rpt.exportar(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat)
            ruta = ruta.Substring(ruta.LastIndexOf("\") + 1)
            Dim RutaRelativa As String = "../MensajeriaEspecializada/Reportes/rptTemp/" & ruta & ""
            Dim js As String = "<script language='javascript' type='text/javascript'>window.open('" & RutaRelativa & "','Hoja_Ruta','status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1');</script>"

            js = String.Format(js, Chr(34))
            cpGeneral.RenderScriptBlock("DescargaAdendo", js, False)
            'Me.ClientScript.RegisterStartupScript(Me.GetType, "Hoja_Adendo", js, False)
        Catch ex As Exception
            epPoolServicios.showError("Error al descargar el adendo.")
        End Try
    End Sub

    Private Sub lbAbrirServicio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAbrirServicio.Click
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hfIdServicio.Value)
                resultado = .Reabrir(idUsuario, txtObservacionModificacion.Text, CInt(ddlEstadoReapertura.SelectedValue))
            End With
            If resultado.Valor = 0 Then
                epPoolServicios.showSuccess("El servicio fue abierto satisfactoriamente.")
                If ddlEstado.SelectedValue <> "0" Then ddlEstado.ClearSelection()
                Dim dtDatos As DataTable = CargarPool()
                If dtDatos IsNot Nothing Then
                    EnlazarDatos(dtDatos)
                End If
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    epPoolServicios.showWarning(resultado.Mensaje)
                Else
                    epPoolServicios.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de abrir servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub lbCancelarServicio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCancelarServicio.Click
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hfIdServicio.Value)
                resultado = .Cancelar(idUsuario, txtObservacionModificacion.Text)
            End With
            If resultado.Valor = 0 Then
                epPoolServicios.showSuccess(resultado.Mensaje)
                If ddlEstado.SelectedValue <> "0" Then ddlEstado.ClearSelection()
                Dim dtDatos As DataTable = CargarPool()
                If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                    EnlazarDatos(dtDatos)
                End If
                'Envio de Gestion a NotusExpressBancolombia
                miServicio = New ServicioMensajeria(CInt(hfIdServicio.Value))
                If (miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (miServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                End If
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    epPoolServicios.showWarning(resultado.Mensaje)
                Else
                    epPoolServicios.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cancelar servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            'If Session("dtPoolServicios") IsNot Nothing Then
            Dim dtDatos As DataTable = CargarPool() 'CType(Session("dtPoolServicios"), DataTable)
            Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
            EnlazarDatos(dtDatos, expOrdenamiento)
            'Else
            'epPoolServicios.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            'End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub lbReactivar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbReactivar.Click
        ReactivarServicio()
    End Sub

    Private Sub lbLegaliza_Click(sender As Object, e As System.EventArgs) Handles lbLegaliza.Click
        LegalizarServicioFinanciero()
    End Sub

    Private Sub cpValidacionNumRadicado_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpValidacionNumRadicado.Execute
        Dim numeroRadicado As Long
        Dim resultado As Boolean
        Try
            If Long.TryParse(e.Parameter, numeroRadicado) Then
                resultado = ServicioMensajeria.ExisteNumeroRadicado(numeroRadicado)
                imgError.Visible = resultado
                If resultado Then txtNuevoRadicado.Text = ""
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de validar número de radicado. " & ex.Message)
        End Try
    End Sub

    Private Sub btnAceptarVentas_Click(sender As Object, e As System.EventArgs) Handles btnAceptarVentas.Click
        Try
            ddlTipoServicio.SelectedValue = Enumerados.TipoServicio.Venta
            ddlEstado.SelectedValue = Enumerados.EstadoServicio.Creado
            BuscarDatos()
        Catch ex As Exception
            epPoolServicios.showError("Se generó un error al tratar de buscar servicios pendientes: " & ex.Message)
        End Try
    End Sub

    Private Sub btnDevolverVenta_Click(sender As Object, e As System.EventArgs) Handles btnDevolverVenta.Click
        DevolverVenta(hfIdServicio.Value)
    End Sub

    Private Sub btnReagenda_Click(sender As Object, e As EventArgs) Handles btnReagenda.Click
        Reagenda()
    End Sub

#End Region
#Region "Procedimientos"

    Private Sub CargarEstado()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional("ddlEstado")
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstado

            With ddlEstado
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idEstado"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Estado", "0"))
                End If
            End With
            Session("ArrEstadoPorDefecto") = HerramientasMensajeria.ObtenerListaEstadosPorDefecto(Enumerados.FuncionalidadMensajeria.PoolGeneralServicios)
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Estados. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarBodega()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultarBodega(idUsuarioConsulta:=CInt(Session("usxp001")))
            With ddlBodega
                .DataSource = dtEstado
                .DataTextField = "bodega"
                .DataValueField = "idbodega"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Bodega", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudad()
        Dim dtEstado As New DataTable
        Dim datos As New Ciudad
        Try
            dtEstado = Ciudad.ObtenerCiudadesPorPais
            With ddlCiudad
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Ciudad", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarServicio()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ConsultaTipoServicio(idUsuarioConsulta:=CInt(Session("usxp001")))
            With ddlTipoServicio
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un tipo de servicio", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal expOrdenamiento As String = "")
        Try
            pnlResultados.Visible = True

            Dim dvDatos As DataView = dtDatos.DefaultView
            If expOrdenamiento.Trim.Length > 0 Then dvDatos.Sort = expOrdenamiento

            With gvDatos
                .DataSource = dvDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            'Session("dtPoolServicios") = dvDatos.ToTable()
            MetodosComunes.mergeGridViewFooter(gvDatos)
            If dtDatos.Rows.Count = 0 Then epPoolServicios.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
        Finally
            If dtDatos IsNot Nothing Then dtDatos.Clear()
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtidServicio.Text = String.Empty
        txtMIN.Text = String.Empty
        ddlCiudad.SelectedIndex = -1
        ddlEstado.SelectedIndex = -1
        ddlBodega.SelectedIndex = -1
        ddlTipoServicio.SelectedIndex = -1
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
    End Sub

    Private Sub CargarRestricciones()
        Try
            Dim arrEstadoConfirmacion As New ArrayList(MetodosComunes.seleccionarConfigValue("CONFIRMAR_POOL_CEM").Split(","))
            Session("arrRestriccionEstadoConfirmacion") = arrEstadoConfirmacion

            Dim arrEstadoAdicion As New ArrayList(MetodosComunes.seleccionarConfigValue("ADICIONAR_NOVEDAD_POOL_CEM").Split(","))
            Session("arrRestriccionEstadoAdicion") = arrEstadoAdicion

            Dim arrEstadoDespacho As New ArrayList(MetodosComunes.seleccionarConfigValue("DESPACHAR_POOL_CEM").Split(","))
            Session("arrRestriccionEstadoDespacho") = arrEstadoDespacho

            Dim arrEstadoModificacion As New ArrayList(MetodosComunes.seleccionarConfigValue("MODIFICAR_SERVICIO_CEM").Split(","))
            Session("arrEstadoModificacion") = arrEstadoModificacion

            Dim arrEstadoEdicionAdminCme As New ArrayList(MetodosComunes.seleccionarConfigValue("ESTADOS_EDITAR_ADMIN_CME").Split(","))
            Session("arrEstadoEdicionAdminCme") = arrEstadoEdicionAdminCme

            Dim arrPerfilConfirmacionCme As New ArrayList(MetodosComunes.seleccionarConfigValue("PERFILES_CONFIRMAR_SERVICIO").Split(","))
            Session("arrPerfilConfirmacionCme") = arrPerfilConfirmacionCme

            Dim arrPerfilEnrutamientoCme As New ArrayList(MetodosComunes.seleccionarConfigValue("PERFILES_ENRUTAMIENTO").Split(","))
            Session("arrPerfilEnrutamientoCme") = arrPerfilEnrutamientoCme

            Dim arrPerfilGestionUrgentes As New ArrayList(MetodosComunes.seleccionarConfigValue("PERFILES_GESTION_URGENTES_CEM").Split(","))
            Session("arrPerfilGestionUrgentes") = arrPerfilGestionUrgentes

        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de Cargar Restricciones. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarVIP()
        Try
            With ddlVIP
                .Items.Insert(0, New ListItem("Seleccione", "0"))
                .Items.Insert(1, New ListItem("Si", "1"))
                .Items.Insert(2, New ListItem("No", "2"))
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de VIP. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

    Private Sub MarcarUrgente(ByVal idServicio As Integer)
        Try
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
            objServicio.Urgente = True

            Dim resultado As ResultadoProceso = objServicio.Actualizar(idUsuario)

            If resultado.Valor = 0 Then
                epPoolServicios.showSuccess("Se realizó marcación de urgente correctamente.")
                BuscarDatos()
            Else
                epPoolServicios.showWarning("No se logro marcar como urgente el servicio: " & resultado.Mensaje)
            End If

        Catch ex As Exception
            epPoolServicios.showError("Error inesperado al intenetar marcar como urgente: " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarDatos()
        Dim dtDatos As New DataTable
        Try
            pnlResultados.Visible = True
            dtDatos = CargarPool()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epPoolServicios.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                pnlResultados.Visible = False
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de generar reporte. " & ex.Message)
        End Try
    End Sub

    Private Sub ReactivarServicio()
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria

            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)

            Dim nuevoRadicado As Long
            Long.TryParse(txtNuevoRadicado.Text, nuevoRadicado)

            With miServicio
                .IdServicioMensajeria = CInt(hfReactivarIdServicio.Value)
                resultado = .Reactivar(idUsuario, txtObservacionReactivacion.Text, Enumerados.EstadoServicio.Creado, nuevoRadicado)
            End With
            If resultado.Valor = 0 Then
                epPoolServicios.showSuccess("El servicio fue reactivado satisfactoriamente.")
                If ddlEstado.SelectedValue <> "0" Then ddlEstado.ClearSelection()
                Dim dtDatos As DataTable = CargarPool()
                If dtDatos IsNot Nothing Then
                    EnlazarDatos(dtDatos)
                End If
                Try
                    If (miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Confirmado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    ElseIf (miServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Confirmado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    End If
                Catch ex As Exception

                End Try
                If resultado.Valor <> 0 Then
                    epPoolServicios.showSuccess("El servicio fue reactivado satisfactoriamente. Pero se ha generado un error al notificar a Notus Express")
                End If
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    epPoolServicios.showWarning(resultado.Mensaje)
                Else
                    epPoolServicios.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de reactivar servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub LegalizarServicioFinanciero()
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeria(CInt(hflegalizaIdServicio.Value))
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hflegalizaIdServicio.Value)
                .IdEstado = Enumerados.EstadoServicio.Entregadoalegalizacion
                resultado = .Actualizar(idUsuario)
            End With
            If resultado.Valor = 0 Then
                If miServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Or miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregadoalegalizacion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregadoalegalizacion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf miServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregadoalegalizacion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                End If

                epPoolServicios.showSuccess("El servicio fue legalizado satisfactoriamente.")
                If ddlEstado.SelectedValue <> "0" Then ddlEstado.ClearSelection()
                Dim dtDatos As DataTable = CargarPool()
                If dtDatos IsNot Nothing Then
                    EnlazarDatos(dtDatos)
                End If
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    epPoolServicios.showWarning(resultado.Mensaje)
                Else
                    epPoolServicios.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de legalizar servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CragarEstadoReapertura(ByVal idEstadoActual As Integer)
        Dim dtEstado As New DataTable
        Try
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstadoReapertura(idEstadoActual)

            With ddlEstadoReapertura
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idEstadoReapertura"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Estado...", "0"))
                End If
            End With
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de Estados. " & ex.Message)
        End Try
    End Sub

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me._altoVentana = CInt(arrAux(0))
                Me._anchoVentana = CInt(arrAux(1))
            End If
        End If
        If Me._altoVentana = 0 Then Me._altoVentana = 600
        If Me._anchoVentana = 0 Then Me._anchoVentana = 800
    End Sub

    Private Sub CargaTiposNovedad()
        Try
            Dim dtNovedades As DataTable = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Confirmacion)
            MetodosComunes.CargarDropDown(dtNovedades, ddlTipoNovedadDevolucion, "Seleccione...", True)
        Catch ex As Exception
            epPoolServicios.showError("Se genero un error cargando los tipos de novedad.")
        End Try
    End Sub

    Private Sub DevolverVenta(idServicio As Integer)
        Try
            Dim resultado As New ResultadoProceso

            'Se registra la novedad de anulación
            Dim objNovedad As New NovedadServicioMensajeria()
            With objNovedad
                .IdServicioMensajeria = idServicio
                .IdUsuario = CInt(Session("usxp001"))
                .Observacion = txtObservacionDevolucion.Text
                .IdTipoNovedad = ddlTipoNovedadDevolucion.SelectedValue
                resultado = .Registrar(CInt(Session("usxp001")))
            End With

            If resultado.Valor = 0 Then
                'Se realiza el cambio de estado del servicio
                Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
                With objServicio
                    .IdEstado = Enumerados.EstadoServicio.DevueltoCallCenter
                    resultado = .Actualizar(CInt(Session("usxp001")))
                End With
                If resultado.Valor = 0 Then
                    epPoolServicios.showSuccess("Servicio devuelto a Call Center Correctamente.")
                    BuscarDatos()
                Else
                    epPoolServicios.showError(resultado.Mensaje)
                End If
            Else
                epPoolServicios.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            epPoolServicios.showError("Se genero un error al intentar devolver la venta al Call Center: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatosReagenda(ByVal idServicioMensajeria)
        lblIdServicio.Text = idServicioMensajeria
        Dim dtNovedades As DataTable = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Reagenda)
        MetodosComunes.CargarDropDown(dtNovedades, ddlNovedadReagenda, "Seleccione...", True)
        dlgReagenda.Show()
    End Sub

    Private Sub Reagenda()
        Dim idServicio As Integer = CInt(lblIdServicio.Text.Trim)
        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Dim resultado As New ResultadoProceso
        Try
            'Se registra la novedad de anulación
            Dim objNovedad As New NovedadServicioMensajeria()
            With objNovedad
                .IdServicioMensajeria = idServicio
                .IdUsuario = CInt(Session("usxp001"))
                .Observacion = txtObservacionReagenda.Text
                .IdTipoNovedad = ddlNovedadReagenda.SelectedValue
                resultado = .Registrar(CInt(Session("usxp001")))
            End With

            If resultado.Valor = 0 Then
                ' Se realiza el levantamiento del check de reagenda del servicio
                Dim objServicio As ServicioMensajeria = New ServicioMensajeria()
                With objServicio
                    .IdServicioMensajeria = idServicio
                    resultado = .ActualizarReagenda(idUsuario, objServicio)
                    If resultado.Valor = 0 Then
                        epPoolServicios.showSuccess("Servicio actualizado correctamente.")
                        BuscarDatos()
                    Else
                        epPoolServicios.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
                    End If
                End With
            End If
        Catch ex As Exception
            epPoolServicios.showError("Se genero un error al intentar quitar el chek de reagenda: " & ex.Message)
        End Try
    End Sub

#End Region
#Region "Funciones"

    Private Function ObtenerDireccionOrdenamiento(ByVal columna As String) As String
        Dim direccionOrdenamiento = "ASC"
        Dim expresionOrdenamiento = TryCast(ViewState("ExpresionOrdenamiento"), String)
        If expresionOrdenamiento IsNot Nothing Then
            If expresionOrdenamiento = columna Then
                Dim ultimaDirection = TryCast(ViewState("DireccionOrdenamiento"), String)
                If ultimaDirection IsNot Nothing AndAlso ultimaDirection = "ASC" Then direccionOrdenamiento = "DESC"
            End If
        End If
        ViewState("DireccionOrdenamiento") = direccionOrdenamiento
        ViewState("ExpresionOrdenamiento") = columna
        Return direccionOrdenamiento
    End Function

    Private Function CargarPool() As DataTable
        Dim dtEstado As New DataTable
        Dim datos As New GenerarPoolServicioMensajeria
        Dim perfilesDigitacionCme As String
        Try
            perfilesDigitacionCme = MetodosComunes.seleccionarConfigValue("PERFILES_DIGITACION_CME")

            Dim arrPerfilDigitacionCme As New ArrayList(perfilesDigitacionCme.Split(","))

            Dim idPerfil As Integer
            If Session("usxp009") IsNot Nothing Then Integer.TryParse(Session("usxp009"), idPerfil)
            Dim idUsuario As Integer = CInt(Session("usxp001"))

            With datos
                If Not String.IsNullOrEmpty(txtidServicio.Text) OrElse Not String.IsNullOrEmpty(txtMIN.Text) _
                    OrElse Not String.IsNullOrEmpty(txtFechaInicial.Value) OrElse _
                    ddlCiudad.SelectedValue <> "0" OrElse ddlBodega.SelectedValue <> "0" OrElse _
                    ddlTipoServicio.SelectedValue <> "0" OrElse ddlEstado.SelectedValue <> "0" _
                    OrElse ddlTieneNovedad.SelectedValue <> "0" OrElse ddlVIP.SelectedValue <> "0" Then

                    If Not String.IsNullOrEmpty(txtidServicio.Text) Then
                        If rblTipoBusqueda.SelectedValue = 1 Then
                            .ListaNumeroRadicado = New ArrayList(txtidServicio.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                        Else
                            .ListaIdServicio = New ArrayList(txtidServicio.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                        End If
                    End If

                    If Not String.IsNullOrEmpty(txtMIN.Text) Then .Msisdn = txtMIN.Text.Trim
                    If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaInicial = CDate(txtFechaInicial.Value)
                    If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaFinal = CDate(txtFechaFinal.Value)
                    If ddlCiudad.SelectedValue > 0 Then .IdCiudad = ddlCiudad.SelectedValue
                    If ddlBodega.SelectedValue > 0 Then .IdBodega = ddlBodega.SelectedValue
                    If ddlTipoServicio.SelectedValue > 0 Then .IdTipoServicio = ddlTipoServicio.SelectedValue
                    If ddlEstado.SelectedValue <> "0" Then .IdEstado = ddlEstado.SelectedValue
                    If ddlTieneNovedad.SelectedValue <> 0 Then .TieneNovedad = ddlTieneNovedad.SelectedValue
                    If ddlVIP.SelectedValue <> "0" Then .ClienteVIP = IIf(ddlVIP.SelectedValue = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                Else
                    If Session("ArrEstadoPorDefecto") IsNot Nothing Then
                        .ListaEstado = Session("ArrEstadoPorDefecto")
                    Else
                        .ListaEstado.Add(Enumerados.EstadoServicio.Creado)
                    End If
                End If
                .IdUsuarioGenerador = idUsuario
            End With
            If arrPerfilDigitacionCme.Contains(idPerfil.ToString) Then ddlCiudad.Enabled = False
            dtEstado = datos.GenerarPool()
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return dtEstado
    End Function

    Protected Sub CheReagenda_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            Dim chkReagenda As WebControls.CheckBox = CType(sender, WebControls.CheckBox)
            'chkReagenda.Attributes.Add("onclick", "return confirm('¿Realmente desea quitar el check de reagendamiento?');")
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim objFila As GridViewRow = CType(chkReagenda.Parent.Parent, GridViewRow)
            Dim idServicioMensajeria As String = objFila.Cells(2).Text
            CargarDatosReagenda(idServicioMensajeria)
        Catch ex As Exception
            epPoolServicios.showError("Se genero un error al actualizar el servicio: " & ex.Message)
        End Try
    End Sub
#End Region
    Private Sub CargarEstadosPermiteConfirmarConreagenda()
        arrEstadosConfirmacionConReagenda = New ArrayList(MetodosComunes.seleccionarConfigValue("ESTADOS_CONFIRMAR_REAGENDA").Split(","))
        Session("arrEstadosConfirmacionConReagenda") = arrEstadosConfirmacionConReagenda
    End Sub
    
    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function

End Class