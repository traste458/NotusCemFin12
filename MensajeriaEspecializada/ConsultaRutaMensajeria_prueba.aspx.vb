Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Partial Public Class ConsultaRutaMensajeria_prueba
    Inherits System.Web.UI.Page

#Region "Propiedades"
    Dim rpt As ReporteCrystal
    Private ReadOnly Property IdPerfil() As Integer
        Get
            Dim _idPerfil As Integer
            If Session("usxp009") IsNot Nothing Then
                Integer.TryParse(Session("usxp009").ToString, _idPerfil)
                Return _idPerfil
            Else
                Return 0
            End If
        End Get
    End Property

#End Region

#Region "Eventos"

    Private Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        rpt = New ReporteCrystal("HojaRuta", Server.MapPath("../MensajeriaEspecializada/Reportes"))

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, True)
        epPrincipal.clear()
        Try
            If Not IsPostBack Then
                'Session("usxp009") = 118
                'Session("usxp007") = 150
                epPrincipal.setTitle("Consulta de Rutas")
                epPrincipal.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                CargarListadoDeResponsables()
                CargarDatos()
                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar la pagina. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        BuscarRuta()
    End Sub

    Protected Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim arrControles() As String = {"imgEditarRuta", "imgVerRadicados", "imgVerRuta", "imgVerRutaSerializada"}
            For indice As Integer = 0 To arrControles.Length - 1
                Dim ctrl As Control = e.Row.FindControl(arrControles(indice))
                If ctrl IsNot Nothing Then
                    ctrl.Visible = HerramientasMensajeria.EsVisibleOpcionRestringida(ctrl.ID, -1)
                    If ctrl.Visible Then ctrl.Visible = HerramientasMensajeria.EsVisibleSegunEstado(ctrl.ID, -1)
                End If
            Next

        End If
    End Sub

    Protected Sub btnBorrarFiltro_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBorrarFiltro.Click
        txtIdRuta.Text = String.Empty
        txtFiltroMoto.Text = String.Empty
        ddlEstado.ClearSelection()
        ddlMoto.ClearSelection()
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        ddlMoto.DataSource = New DataTable()
        ddlMoto.DataBind()
        ddlMoto.Items.Insert(0, New ListItem("Filtre el motorizado", "0"))
        lblMoto.Text = "0 Registro(s) Encontrado(s)"
        gvDatos.DataSource = New DataTable()
        gvDatos.EmptyDataText = ""
        gvDatos.DataBind()
        ddlJornada.ClearSelection()
    End Sub

    Protected Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Dim idRuta As Integer
        Dim idTipoRuta As Short

        Try
            If e.CommandName <> "Page" Then
                Long.TryParse(e.CommandArgument.ToString, idRuta)
                Short.TryParse(CType(Session("dtRutas"), DataTable).Select("idRuta=" & idRuta)(0).Item("idTipoRuta"), idTipoRuta)

                If e.CommandName = "VerRadicados" Then
                    Dim dtRadicados As New DataTable
                    dtRadicados = MensajeriaEspecializada.RutaServicioMensajeria.ObtenerRadicadosPorId(idRuta)
                    With gvVerRadicados
                        .DataSource = dtRadicados
                        .DataBind()
                    End With
                    dlgSerial.Show()
                ElseIf e.CommandName = "VerRuta" Then
                    ObtenerDocumentoRuta(idRuta, idTipoRuta)
                ElseIf e.CommandName = "VerRutaSerializada" Then
                    ObtenerDocumentoRuta(idRuta, idTipoRuta, True)
                ElseIf e.CommandName = "EditarRuta" Then
                    Response.Redirect("EditarRutaServicio.aspx?idRuta=" & idRuta, False)
                End If
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de mostrar los radicados. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtRutas") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtRutas"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epPrincipal.showWarning("Imposible recuperar los datos desde memorial, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Delegados"

    Private Sub cpFiltroMoto_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMoto.Execute
        If e.Parameter = "filtrarMoto" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMoto.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeResponsables(filtroRapido)
        End If
        cpFiltroMoto.Update()
    End Sub

#End Region

#Region "Métodos"

    Private Sub CargarDatos()
        Try
            Dim idPerfil As Integer
            CargarEstado()
            CargarJornada()

            If Me.IdPerfil = 118 Then
                CargarCiudad()
                trFiltroCiudad.Visible = True
            Else
                trFiltroCiudad.Visible = False
            End If

            ddlMoto.Items.Insert(0, New ListItem("Filtre el motorizado", "0"))
        Catch ex As Exception
            Throw New Exception("Error al cargar los datos. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarEstado()
        Dim estados As New Comunes.EstadoColeccion()
        estados.IdEntidad = 33
        estados.CargarDatos()
        If estados.Count > 0 Then
            ddlEstado.DataTextField = "Descripcion"
            ddlEstado.DataValueField = "IdEstado"
            ddlEstado.DataSource = estados
            ddlEstado.DataBind()
        End If
        ddlEstado.Items.Insert(0, New ListItem("Seleccione un Estado", "0"))
    End Sub

    Private Sub CargarJornada()
        Dim dtJornada As New DataTable
        dtJornada = HerramientasMensajeria.ConsultaJornadaMensajeria()
        If dtJornada.Rows.Count > 0 Then
            ddlJornada.DataTextField = "nombre"
            ddlJornada.DataValueField = "idJornada"
            ddlJornada.DataSource = dtJornada
            ddlJornada.DataBind()
        End If
        ddlJornada.Items.Insert(0, New ListItem("Seleccione una Jornada", "0"))
    End Sub

    Private Sub CargarCiudad()
        Dim dtCiudades As DataTable = HerramientasMensajeria.ObtenerCiudadesCem()
        If dtCiudades.Rows.Count > 0 Then
            With ddlCiudad
                .DataTextField = "Ciudad"
                .DataValueField = "idCiudad"
                .DataSource = dtCiudades
                .DataBind()
            End With
        End If
        ddlCiudad.Items.Insert(0, New ListItem("Seleccione una Ciudad", "0"))
    End Sub

    Private Sub BuscarRuta()
        Try
            Dim filtro As New MensajeriaEspecializada.RutaServicioMensajeria.FiltroRutaMensajeria
            Dim ciudadSeleccionada As Integer
            If Me.IdPerfil = 118 Then
                Integer.TryParse(ddlCiudad.SelectedValue.ToString(), ciudadSeleccionada)
            Else
                If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007").ToString, ciudadSeleccionada)
            End If

            With filtro
                If txtIdRuta.Text <> "" Then Integer.TryParse(txtIdRuta.Text, .IdRuta)
                If ddlMoto.SelectedValue > 0 Then Integer.TryParse(ddlMoto.SelectedValue.ToString(), .IdResponsableEntrega)
                If Not String.IsNullOrEmpty(txtFechaInicial.Value) Then .FechaCreacionInicial = CDate(txtFechaInicial.Value)
                If Not String.IsNullOrEmpty(txtFechaFinal.Value) Then .FechaCreacionFinal = CDate(txtFechaFinal.Value)
                If ddlJornada.SelectedValue > 0 Then Integer.TryParse(ddlJornada.SelectedValue.ToString(), .IdJornada)
                If ddlEstado.SelectedValue > 0 Then Integer.TryParse(ddlEstado.SelectedValue.ToString(), .IdEstado)
                If ciudadSeleccionada > 0 Then .IdCiudad = ciudadSeleccionada
            End With
            Dim dt As New DataTable()
            dt = MensajeriaEspecializada.RutaServicioMensajeria.ObtenerListado(filtro)
            If Not dt.Rows.Count > 0 Then
                gvDatos.EmptyDataText = "<b>No se encontraron rutas.</b>"
            End If
            EnlazarDatos(dt)

        Catch ex As Exception
            epPrincipal.showError("Error al buscar las rutas. " & ex.Message)
        End Try
    End Sub


    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Session("dtRutas") = dtDatos
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoDeResponsables(Optional ByVal filtroRapido As String = "")
        Try
            Dim numResponsables As Integer = 0
            If filtroRapido.Trim.Length > 0 Then
                Dim dtResponsables As DataTable = ObtenerlistadoDeResponsables(filtroRapido)

                If dtResponsables IsNot Nothing Then
                    With ddlMoto
                        .DataSource = dtResponsables
                        .DataTextField = "responsableEntrega"
                        .DataValueField = "idMotorizado"
                        .DataBind()
                    End With
                    numResponsables = dtResponsables.Rows.Count
                End If

            Else
                If ddlMoto.Items.Count > 0 Then ddlMoto.Items.Clear()
            End If

            lblMoto.Text = numResponsables.ToString & " Registro(s) Encontrado(s)"
            With ddlMoto
                If .Items.Count > 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un responsable", "0"))
                ElseIf .Items.Count = 0 Then
                    .Items.Insert(0, New ListItem("Filtre el motorizado", "0"))
                End If

            End With
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar el listado de responsables. " & ex.Message)
        End Try
    End Sub

    Private Sub ObtenerDocumentoRuta(ByVal idRuta As Long, ByVal idTipoRuta As Short, Optional ByVal serializada As Boolean = False)
        Try


            Select Case idTipoRuta
                Case Enumerados.TipoRutaServicioMensajeria.EntregaCliente
                    'Se identifica los tipos de servicio que contienen las rutas.
                    Dim lisTiposServicio As List(Of Integer) = RutaServicioMensajeria.ObtenerTiposServicioEnRuta(idRuta)

                    If lisTiposServicio(0) = Enumerados.TipoServicio.Venta Then
                        If serializada Then
                            rpt = New ReporteCrystal("HojaRutaSerializada", Server.MapPath("../MensajeriaEspecializada/Reportes"))
                        Else
                            rpt = New ReporteCrystal("HojaRutaTipoVenta", Server.MapPath("../MensajeriaEspecializada/Reportes"))
                        End If
                    Else
                        If serializada Then
                            rpt = New ReporteCrystal("HojaRutaSerializada", Server.MapPath("../MensajeriaEspecializada/Reportes"))
                        Else
                            rpt = New ReporteCrystal("HojaRuta", Server.MapPath("../MensajeriaEspecializada/Reportes"))
                        End If
                    End If

                Case Enumerados.TipoRutaServicioMensajeria.EntregaClienteServicioTecnico
                    rpt = New ReporteCrystal("HojaRuta", Server.MapPath("../MensajeriaEspecializada/Reportes"))

                Case Enumerados.TipoRutaServicioMensajeria.RecoleccionCliente
                    rpt = New ReporteCrystal("HojaRutaRecoleccion", Server.MapPath("../MensajeriaEspecializada/Reportes"))

                Case Enumerados.TipoRutaServicioMensajeria.EntregaProveedorServicioTecnico
                    rpt = New ReporteCrystal("OrdenDespachoServicioTecnico", Server.MapPath("../MensajeriaEspecializada/Reportes"))

                Case Enumerados.TipoRutaServicioMensajeria.RecoleccionProveedorServicioTecnico
                    rpt = New ReporteCrystal("OrdenRecoleccionServicioTecnico", Server.MapPath("../MensajeriaEspecializada/Reportes"))

                Case Enumerados.TipoRutaServicioMensajeria.RecoleccionClienteSiembra
                    rpt = New ReporteCrystal("HojaRutaRecoleccionServicioSiembra", Server.MapPath("../MensajeriaEspecializada/Reportes"))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

            rpt.agregarParametroDiscreto("@idRuta", idRuta)
            rpt.Path = Server.MapPath("../archivos_planos/")
            Dim ruta As String = rpt.exportar(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat)
            ruta = ruta.Substring(ruta.LastIndexOf("\") + 1)
            'Dim RutaRelativa As String = "../Reports/rptTemp/" & ruta & ""

            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "newWindow", "window.open('../archivos_planos/" & ruta & "','Hoja_Ruta', 'status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1'); ", True)
            'Dim js As String = "<script language='javascript' type='text/javascript'>window.open('" & RutaRelativa & "','Hoja_Ruta','status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1');</script>"
            'js = String.Format(js, Chr(34))
            'cpGeneral.RenderScriptBlock("DescargaRuta", js, False)
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Session("dtInfoPermisosOpcRestringidas") = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Session("dtInfoRestriccionOpcEstado") = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Funciones"

    Protected Function ObtenerlistadoDeResponsables(Optional ByVal filtroRapido As String = "") As DataTable
        Dim dvReponsable As DataView
        Dim idCiudad As Integer
        If Me.IdPerfil = 118 Then
            If Session("dtResponsableEntrega") Is Nothing Then Session("dtResponsableEntrega") = HerramientasMensajeria.ConsultarMotorizado()
        Else
            If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007").ToString, idCiudad)
            If Session("dtResponsableEntrega") Is Nothing Then Session("dtResponsableEntrega") = HerramientasMensajeria.ConsultarMotorizado(idCiudad)
        End If


        With CType(Session("dtResponsableEntrega"), DataTable)
            If Not .Columns.Contains("responsableEntrega") Then
                Dim dcAux As New DataColumn("responsableEntrega")
                dcAux.Expression = "identificacion+' - '+nombre"
                .Columns.Add(dcAux)
            End If
            dvReponsable = .DefaultView
        End With
        If filtroRapido.Trim.Length > 2 Then
            dvReponsable.RowFilter = "responsableEntrega LIKE '%" & filtroRapido & "%'"
        Else
            dvReponsable.RowFilter = "idMotorizado = -1"
        End If
        Return dvReponsable.ToTable()
    End Function

#End Region

End Class