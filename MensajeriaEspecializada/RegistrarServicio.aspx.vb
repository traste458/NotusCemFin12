Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports System.Text
Imports System.IO
Imports GemBox
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer.Comunes


Partial Public Class RegistrarServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer
    Private dtError As DataTable
    Private Shared infoEstados As InfoEstadoRestriccionCEM

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        imgError.Visible = False
        ObtenerTamanoVentana()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Registro de Servicio")
            End With

            With dpFechaVencimientoReserva
                .VisibleDate = Now
                .MinValidDate = Now
            End With
            With dpFechaAsignacion
                .VisibleDate = Now
                .MaxValidDate = Now
            End With

            Session.Remove("equiposDataTable")

            LimpiarFormulario()
            CargaInicial()
            CargarTiposDeNovedad()
            pnlBotonEdicionReferencia.Visible = False
            pnlBotonEdicionMin.Visible = False
            pnlBotonEdicionEquipo.Visible = False
            ddlTipoServicio.Focus()
        End If
    End Sub

    Protected Sub ddlTipoServicio_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlTipoServicio.SelectedIndexChanged
        Try
            'Manejo de Controles
            dpFechaVencimientoReserva.Enabled = True
            rfvFechaVencimiento.Enabled = True

            'Manejo de Paneles
            pnlReposicion.Visible = False
            pnlServicioTecnico.Visible = False

            Select Case ddlTipoServicio.SelectedValue
                Case Enumerados.TipoServicio.Reposicion
                    pnlReposicion.Visible = True
                    pnlInfoArchivo.Visible = True

                    chbClienteVIP.Enabled = True
                    txtPlanActual.Enabled = True

                    revtxtNoRadicado.ValidationExpression = "[0-9]{7,9}"
                    revtxtNoRadicado.ErrorMessage = "El radicado debe ser numérico con logitud de 7 a 9 d&iacute;gitos"

                Case Enumerados.TipoServicio.OrdenCompra, Enumerados.TipoServicio.Portacion
                    pnlReposicion.Visible = True
                    pnlInfoArchivo.Visible = False
                    'chbClienteVIP.Enabled = True
                    'txtPlanActual.Enabled = True

                Case Enumerados.TipoServicio.ServicioTecnico
                    pnlServicioTecnico.Visible = True
                    dpFechaVencimientoReserva.Enabled = False
                    rfvFechaVencimiento.Enabled = False
                    'AnularReservasInventario()

                    'chbClienteVIP.Enabled = True
                    'txtPlanActual.Enabled = True

                Case Enumerados.TipoServicio.Venta
                    Response.Redirect("RegistrarServicioTipoVenta.aspx", True)

                Case Enumerados.TipoServicio.Siembra
                    Response.Redirect("RegistrarServicioTipoSiembra.aspx", True)

                Case Enumerados.TipoServicio.VentaWeb
                    Response.Redirect("CargueServiciosVentaWebPorArchivo.aspx", True)
                    ''pnlReposicion.Visible = True
                    ''pnlInfoArchivo.Visible = False
                    ''pnlInfoMin.Visible = False

                    ''chbClienteVIP.Enabled = False
                    ''txtPlanActual.Enabled = False

                    ''revtxtNoRadicado.ValidationExpression = "[0-9]{7,15}"
                    ''revtxtNoRadicado.ErrorMessage = "El radicado debe ser numérico con logitud de 7 a 15 d&iacute;gitos"
                    'Case Enumerados.TipoServicio.ServiciosFinancieros
                    '    pnlInfoGeneral.Visible = False
                    '    miEncabezado.showWarning("Este tipo de servicio no es aceptado para registrar desde NotusILS.")
                Case Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM
                    pnlInfoGeneral.Visible = False
                    miEncabezado.showWarning("Este tipo de servicio no es aceptado para registrar desde NotusILS.")

                Case Enumerados.TipoServicio.ServiciosFinancierosBancolombia
                    pnlInfoGeneral.Visible = False
                    miEncabezado.showWarning("Este tipo de servicio no es aceptado para registrar desde NotusILS.")
                Case Enumerados.TipoServicio.MercadoNaturalFeria
                    pnlInfoGeneral.Visible = False
                    miEncabezado.showWarning("Este tipo de servicio no es aceptado para registrar desde NotusILS.")

                Case Enumerados.TipoServicio.VentaCorporativa
                    Response.Redirect("RegistrarServicioTipoVentaCorporativo.aspx", True)

                Case Enumerados.TipoServicio.CampañaClaroFijo, Enumerados.TipoServicio.TiendaVirtual
                    pnlReposicion.Visible = True
                    pnlInfoArchivo.Visible = False

                    chbClienteVIP.Enabled = True
                    txtPlanActual.Enabled = True

                Case Enumerados.TipoServicio.EquiposReparadosST
                    Response.Redirect("CreaciónServicioServicioTecnico.aspx", True)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de seleccionar tipo de servicio: " & ex.Message)
        End Try
    End Sub

#Region "Eventos Reposiciones y Ordenes de Compra"

    Protected Sub lbAgregarReferencia_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAgregarReferencia.Click
        AgregarReferencia()
    End Sub

    Protected Sub lbAgregarMIN_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAgregarMIN.Click
        AgregarMINs()
    End Sub

    Protected Sub lbGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGuardar.Click
        RegistrarServicio()
    End Sub

    Private Sub gvReferencias_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvReferencias.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarMaterial(e.CommandArgument.ToString())
            Case "editar"
                IniciarFormularioEdicionReferencia(e.CommandArgument.ToString)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvMINS_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvMINS.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarMin(CInt(e.CommandArgument))
            Case "editar"
                IniciarFormularioEdicionMin(CInt(e.CommandArgument))
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub cpValidacionNumRadicado_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpValidacionNumRadicado.Execute
        Dim numeroRadicado As Long
        Dim resultado As Boolean
        Try
            If Long.TryParse(e.Parameter, numeroRadicado) Then
                resultado = ServicioMensajeria.ExisteNumeroRadicado(numeroRadicado)
                imgError.Visible = resultado
                If resultado Then miEncabezado.showWarning("El número de radicado digitado ya existe.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de validar número de radicado. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbActualizarRef_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarRef.Click
        Dim dtReferencia As DataTable = CType(Session("referenciasDataTable"), DataTable)
        Dim material As String = hfMaterialAct.Value
        Dim drAux As DataRow
        Try
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()
            drAux = dtReferencia.Rows.Find(material)
            If drAux IsNot Nothing Then
                If material.Trim <> ddlMaterial.SelectedValue.Trim Then
                    If dtReferencia.Rows.Find(ddlMaterial.SelectedValue) IsNot Nothing Then
                        miEncabezado.showError("El material que está intentando adicionar ya fue previamente adicionado. Debe modificar el registro inicial")
                        Exit Sub
                    End If
                End If
                drAux("material") = ddlMaterial.SelectedValue
                drAux("referencia") = ddlMaterial.SelectedItem.Text
                drAux("cantidad") = txtCantidad.Text
                drAux.AcceptChanges()
                dtReferencia.AcceptChanges()
                Session("referenciasDataTable") = dtReferencia
                EnlazarReferencias()
                FinalizarModoEdicionReferencia()
                miEncabezado.showSuccess("La referencia fue actualizada satisfactoriamente.")
            Else
                miEncabezado.showError("Imposible encontrar el registro asignado al material. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de actualizar referencia. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbCancelarActRef_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCancelarActRef.Click
        FinalizarModoEdicionReferencia()
    End Sub

    Protected Sub lbCancelarActMin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCancelarActMin.Click
        FinalizarModoEdicionMin()
    End Sub

    Protected Sub lbActualizarMin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarMin.Click
        Dim dtMsisdn As DataTable = CType(Session("minsDataTable"), DataTable)
        Dim idMsisdn As Integer = CInt(hfMsisdnAct.Value)
        Dim drAux As DataRow
        Try
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            drAux = dtMsisdn.Rows.Find(idMsisdn)
            If drAux IsNot Nothing Then
                Dim drMin() As DataRow = dtMsisdn.Select("msisdn=" & txtMsisdn.Text.Trim)
                If drMin IsNot Nothing AndAlso drMin.Length >= 2 Then
                    miEncabezado.showError("El MSISDN que está intentando adicionar ya superó el número de registros permitidos: 2 Registros. Por favor verifique")
                    Exit Sub
                ElseIf drMin IsNot Nothing AndAlso RegistroMinExiste(drMin) Then
                    miEncabezado.showError("El registro que está tratando de ingresar ya existe. Por favor verifique")
                End If

                drAux("msisdn") = CLng(txtMsisdn.Text)
                drAux("numeroReserva") = txtNumeroReserva.Text
                drAux("activaEquipoAnterior") = chbActivaEquipoAnterior.Checked
                drAux("comSeguro") = chbComSeguro.Checked
                drAux("precioConIVA") = CLng(txtPrecioConIVA.Text)
                drAux("precioSinIVA") = CLng(txtPrecioSinIVA.Text)
                drAux("idClausula") = CInt(ddlClausula.SelectedValue)
                drAux("clausula") = ddlClausula.SelectedItem.Text
                drAux("lista28") = CBool(rblLista28.SelectedValue)
                drAux.AcceptChanges()
                dtMsisdn.AcceptChanges()

                Session("minsDataTable") = dtMsisdn
                EnlazarMines()
                FinalizarModoEdicionMin()

                miEncabezado.showSuccess("El Msisdn fue actualizado satisfactoriamente.")
            Else
                miEncabezado.showError("Imposible encontrar el registro asignado al Msisdn. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de actualizar Msisdn. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbAdicionarNovedad_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAdicionarNovedad.Click
        Dim dtNovedad As DataTable
        Try
            If Session("dtNovedad") Is Nothing Then Session("dtNovedad") = CrearEstructuraTablaNovedad()
            dtNovedad = CType(Session("dtNovedad"), DataTable)
            Dim drNovedad As DataRow = dtNovedad.NewRow
            drNovedad("idTipoNovedad") = ddlTipoNovedad.SelectedValue
            drNovedad("tipoNovedad") = ddlTipoNovedad.SelectedItem.Text
            drNovedad("observacion") = txtObservacionNovedad.Text
            dtNovedad.Rows.Add(drNovedad)
            ddlTipoNovedad.ClearSelection()
            txtObservacionNovedad.Text = String.Empty
            miEncabezado.showSuccess("Novedad adicionada correctamente.")
            EnlazarNovedades(dtNovedad)
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de adicionar novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub lbMostrarFormNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbMostrarFormNovedad.Click
        Try
            ddlTipoNovedad.ClearSelection()
            'txtComentarioEspecifico.Text = ""
            txtObservacionNovedad.Text = ""
            With dlgNovedad
                .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
                .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
                .Show()
            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de mostrar formulario de adición de novedades.")
        End Try
    End Sub

#End Region

#Region "Eventos Servicio Técnico"

    Private Sub lbAgregarEquipo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAgregarEquipo.Click
        AgregarEquipo()
    End Sub

    Private Sub gvEquipos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEquipos.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarEquipo(e.CommandArgument.ToString())
            Case "editar"
                IniciarFormularioEdicionEquipo(e.CommandArgument.ToString)
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvEquiposPrestamo_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEquiposPrestamo.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarEquipoPrestamo(e.CommandArgument.ToString())
            Case Else
                Throw New ArgumentNullException("Opcion no valida")

        End Select
    End Sub

    Public Sub gvReservasNoConfirmadas_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Select Case e.CommandName
            Case "utilizar"
                EnlazarEquiposPrestamo(CInt(e.CommandArgument.ToString()))
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Public Sub gvReservasNoConfirmadas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ibUtilizar As ImageButton = DirectCast(e.Row.FindControl("ibUtilizar"), ImageButton)
            Dim idBloqueo As Integer = CInt(e.Row.Cells(0).Text)
            'ibUtilizar.Attributes.Add("onmouseover", "javascript:showDescription($(this),'" & ibUtilizar.ClientID & "')")

            If Session("detalleBloqueos") IsNot Nothing Then
                Dim rowsDetalle As DataRow() = DirectCast(Session("detalleBloqueos"), DataTable).Select("idBloqueo=" & idBloqueo)
                If rowsDetalle.Length > 0 Then
                    Dim strMensaje As New StringBuilder
                    For Each row As DataRow In rowsDetalle
                        With strMensaje
                            .AppendLine("Material: " & row("material") & "-" & row("subproducto") & ",  Cantidad: " & row("cantidad") & vbCrLf)
                        End With
                    Next
                    ibUtilizar.ToolTip = strMensaje.ToString()
                End If
            End If
        End If
    End Sub

    Private Sub lbActualizarEquipo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbActualizarEquipo.Click
        ActualizarEquipo()
    End Sub

    Private Sub lbCancelarActEquipo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCancelarActEquipo.Click
        FinalizarModoEdicionEquipo()
    End Sub

    Protected Sub lbAdicionarEquipoPrestamo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAdicionarEquipoPrestamo.Click
        AdicionarEquipoPrestamo()
    End Sub

#End Region

#Region "Eventos Cargue de Archivo"

    Private Sub btnSubir_Click(sender As Object, e As System.EventArgs) Handles btnSubir.Click
        miEncabezado.clear()
        gvErrores.Visible = False
        gvDetalleArchivo.Visible = False
        lblRegistrosCargados.Text = ""
        CargarArchivo()
    End Sub

#End Region

#End Region

#Region "Delegados"

    Private Sub cpFiltroMaterial_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMaterial.Execute
        If e.Parameter = "filtrarMaterial" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMaterial.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeMateriales(filtroRapido)
        End If
        cpFiltroMaterial.Update()
    End Sub

    Private Sub cpFiltroMaterialPrestamo_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMaterialPrestamo.Execute
        If e.Parameter = "filtrarMaterialPrestamo" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMaterialPrestamo.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeMaterialesPrestamo(filtroRapido)
        End If
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
            If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un Material...", "0"))
        End With
    End Sub

    Private Sub CargarListadoDeMaterialesPrestamo(Optional ByVal filtroRapido As String = "")
        If Not String.IsNullOrEmpty(filtroRapido.Trim) Then
            Dim dtMaterial As DataTable = ObtenerListaMaterialesPrestamo(filtroRapido)
            With ddlMaterialPrestamo
                .DataSource = dtMaterial
                .DataTextField = "referenciaCompuesta"
                .DataValueField = "materialCompuesto"
                .DataBind()
            End With
        Else
            ddlMaterialPrestamo.Items.Clear()
        End If
        With ddlMaterialPrestamo
            lblMateriales.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un Material...", "0"))
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

    Private Function ObtenerListaMaterialesPrestamo(ByVal filtro As String) As DataTable
        Dim dtMaterial As DataTable
        Dim objInventarioPrestamo As New InventarioSatelitePrestamo()
        With objInventarioPrestamo
            .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})
            .FiltroRapido = filtro
            dtMaterial = .ObtieneInventarioPrestamoAgrupado()
        End With

        Dim dcAux As New DataColumn("referenciaCompuesta")
        dcAux.Expression = "material + ' - '+ referencia + ' - Cant. [' + cantidad + ']'"
        dtMaterial.Columns.Add(dcAux)

        Dim dcAux2 As New DataColumn("materialCompuesto")
        dcAux2.Expression = "material + '|' + idProducto + '|' + idBodega"
        dtMaterial.Columns.Add(dcAux2)

        Return dtMaterial
    End Function

#End Region

#Region "Métodos"

    Private Sub CargaInicial()
        Try
            'Carga Ciudades
            MetodosComunes.CargarDropDown(CType(HerramientasMensajeria.ObtenerCiudadesCem(), DataTable), CType(ddlCiudad, ListControl))

            'Carga los tipos de servicio
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaTipoServicio(True), ddlTipoServicio)

            'Carga las clausulas
            MetodosComunes.CargarDropDown(HerramientasMensajeria.ConsultaClausula(), ddlClausula)

            ddlMaterial.Items.Insert(0, New ListItem("Seleccione un material", "0"))

            'Cargar Prioridades
            Dim listaPrioridad As New PrioridadMensajeriaColeccion()
            With ddlPrioridad
                .DataSource = listaPrioridad.GenerarDataTable()
                .DataTextField = "prioridad"
                .DataValueField = "idPrioridad"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione una Prioridad", "0"))
            End With

            CargarListadoDeMaterialesPrestamo()

            txtTelefono.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            txtExtension.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            rbTelefonoCelular.Attributes.Add("onmousedown", "javascript:validarTelefono()")
            rbTelefonoFijo.Attributes.Add("onmousedown", "javascript:validarTelefono()")
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar configuración. " & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarServicio()
        Try
            miEncabezado.clear()

            infoEstados = New InfoEstadoRestriccionCEM(CInt(ddlTipoServicio.SelectedValue), _
                                                       Enumerados.ProcesoMensajeria.Registro, _
                                                       Enumerados.ProcesoMensajeria.Registro, 0)

            Dim objServicioMensajeria As New ServicioMensajeria()
            With objServicioMensajeria
                .IdUsuario = CInt(Session("usxp001"))
                .FechaAsignacion = dpFechaAsignacion.SelectedDate
                .UsuarioEjecutor = txtUsuarioEjecutor.Text.Trim
                .NombreCliente = txtNombres.Text.Trim
                .PersonaContacto = txtNombresAutorizado.Text.Trim
                .IdentificacionCliente = txtIdentificacion.Text.Trim
                .IdCiudad = CInt(ddlCiudad.SelectedValue)
                .Barrio = txtBarrio.Text.Trim
                .Direccion = txtDireccion.Text.Trim
                .TelefonoContacto = txtTelefono.Text.Trim
                .ExtensionContacto = txtExtension.Text.Trim
                .TipoTelefono = CStr(IIf(rbTelefonoCelular.Checked, "CEL", "FIJO"))
                .NumeroRadicado = CLng(txtNoRadicado.Text.Trim)
                .ClienteVIP = chbClienteVIP.Checked
                .PlanActual = txtPlanActual.Text.Trim
                .Observacion = txtObservacion.Text.Trim
                .IdEstado = infoEstados.IdEstadoSiguiente
                .IdTipoServicio = CInt(ddlTipoServicio.SelectedValue)
                .FechaVencimientoReserva = dpFechaVencimientoReserva.SelectedDate
                .IdPrioridad = CInt(ddlPrioridad.SelectedValue)

                If Session("dtEquipoPrestamo") IsNot Nothing AndAlso DirectCast(Session("dtEquipoPrestamo"), DataTable).Rows.Count > 0 Then
                    .IdReserva = CInt(DirectCast(Session("dtEquipoPrestamo"), DataTable).Rows(0).Item("idBloqueo"))
                End If

                .ReferenciasDataTable = Session("referenciasDataTable")
                .MinsDataTable = Session("minsDataTable")
                .TablaNovedad = Session("dtNovedad")
                .ImeisDataTable = Session("equiposDataTable")
                .tablaDetalleArchivo = Session("dtDetalleArchivo")

                Dim respuesta As ResultadoProceso = .Registrar()
                If respuesta.Valor = 0 Then
                    miEncabezado.showSuccess("Servicio creado correctamente para el radicado No. " & .NumeroRadicado)

                    'Se realiza confirmación de la reserva
                    Dim objBloqueo As New BloqueoInventario(idBloqueo:=.IdReserva)
                    With objBloqueo
                        .IdEstado = Enumerados.InventarioBloqueo.Confirmado
                        .Actualizar()
                    End With
                    LimpiarFormulario()

                    ' Se verifica si se debe enviar notificación de disponibilidad
                    EnviarNotificacion(.NumeroRadicado)
                Else
                    miEncabezado.showWarning("Servicio no creado: " & respuesta.Mensaje)
                End If

            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Registrar Servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        Try
            pnlReposicion.Visible = False
            pnlServicioTecnico.Visible = False

            ddlTipoServicio.ClearSelection()
            dpFechaAsignacion.SelectedDates.Clear()
            txtUsuarioEjecutor.Text = ""
            txtNombres.Text = ""
            txtNombresAutorizado.Text = ""
            txtIdentificacion.Text = ""
            ddlCiudad.ClearSelection()
            txtBarrio.Text = ""
            txtDireccion.Text = ""
            txtTelefono.Text = ""
            txtNoRadicado.Text = ""
            chbClienteVIP.Checked = False
            txtPlanActual.Text = ""
            txtObservacion.Text = ""
            ddlPrioridad.ClearSelection()
            dpFechaVencimientoReserva.SelectedDates.Clear()

            LimpiarFormularioReferencia()
            LimpiarFormularioMin()
            LimpiarFormularioEquipo()
            LimpiarFormularioEquipoPrestamo()

            Session.Remove("referenciasDataTable")
            With gvReferencias
                .DataSource = Nothing
                .DataBind()
            End With

            Session.Remove("minsDataTable")
            With gvMINS
                .DataSource = Nothing
                .DataBind()
            End With

            Session.Remove("dtNovedad")
            With gvNovedad
                .DataSource = Nothing
                .DataBind()
            End With

            Session.Remove("dtDetalleArchivo")
            With gvDetalleArchivo
                .DataSource = Nothing
                .DataBind()
            End With

            Session.Remove("equiposDataTable")
            With gvEquipos
                .DataSource = Nothing
                .DataBind()
            End With

            With gvInventarioPrestamo
                .DataSource = Nothing
                .DataBind()
            End With

            Session.Remove("dtEquipoPrestamo")
            With gvEquiposPrestamo
                .DataSource = Nothing
                .DataBind()
            End With

            Session.Remove("dtDatos")
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de limpiar campos.")
        End Try
    End Sub

    Private Sub EstablecerLicenciaGembox()
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
    End Sub

    Private Sub EnviarNotificacion(ByVal listNuemeroRadicado As String)
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ObtenerDisponibilidadInventarioParaNotificacion(listNuemeroRadicado)
        Dim dvDatos As DataView = dtDatos.DefaultView
        dvDatos.RowFilter = "fechaReporteSinDisponibilidad  IS NOT NULL"
        Dim dtAux As DataTable = dvDatos.ToTable()

        If dtAux.Rows.Count > 0 Then
            Dim notificador As New NotificacionEventosInventarioCEM
            Dim mensajeInicio As New ConfigValues("MENSAJE_INICIO_CEM")
            Dim mensajeFin As New ConfigValues("MENSAJE_FIN_CEM")
            Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")
            Dim usuarioRespuesta As New ConfigValues("USUARIO_RESPUESTA_CEM")
            Dim arrUsuarioRespuesta As String() = usuarioRespuesta.ConfigKeyValue.Split(",")
            Dim Fila As DataRow() = dtAux.Select("numeroRadicado IN (" & listNuemeroRadicado & ")")
            Dim tipoServicio As String = CStr(Fila(0).Item("tipoServicio"))
            Dim idBodega As String = CInt(Fila(0).Item("idbodega"))
            Dim mensaje As String
            Dim mensajeDetalle As String

            mensaje = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Radicado</td><td><b>Material</td><td><b>Referencia</td><td><b>Cantidad</td><td><b>Bodega</td></tr>"
            For Each drAux As DataRow In dtAux.Rows
                mensaje += "<tr><td>" & drAux("numeroRadicado").ToString & "</td><td>" & drAux("material").ToString & "</td><td>" & drAux("descripcion").ToString & _
                "</td><td>" & drAux("cantidad").ToString & "</td><td>" & drAux("bodega").ToString & "</td></tr>"
            Next
            mensaje += "</table>"

            mensajeDetalle = "<table border='1' cellpadding='5' cellspacing='0' bordercolor='#f0f0f0'><tr bgcolor='#dddddd'><td><b>Serial</td><td><b>Material</td><td><b>Centro</td><td><b>Almacén</td><td><b>Observaciones</td></tr>"
            mensajeDetalle += "</table>"

            With notificador
                .TipoNotificacion = AsuntoNotificacion.Tipo.SinDisponibilidadInventario
                .InicioMensaje = mensajeInicio.ConfigKeyValue
                .FinMensaje = mensajeFin.ConfigKeyValue
                .FirmaMensaje = firmaMensaje.ConfigKeyValue
                .Titulo = "Notificación Disponibilidad de Inventario"
                .Asunto = "Solicitud de radicados para " & tipoServicio & ", sin disponibilidad de Inventario"
                .MailRespuesta = arrUsuarioRespuesta(0)
                .UsuarioRespuesta = arrUsuarioRespuesta(1)
                .NotificacionEvento(mensaje, mensajeDetalle, idBodega)
            End With
        End If

    End Sub

#Region "Métodos Reposiciones y Ordenes de Compra"

    Private Sub EnlazarMines()
        Try
            Dim dtMsisdn As DataTable = Session("minsDataTable")
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()

            'Carga los MINs
            With gvMINS
                .DataSource = dtMsisdn
                .DataBind()
            End With
            hfNumMsisdn.Value = dtMsisdn.Rows.Count.ToString
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar Mines. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarReferencias()
        Try
            Dim dtReferencia As DataTable = Session("referenciasDataTable")
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()
            'Carga las referencias
            With gvReferencias
                .DataSource = dtReferencia
                .DataBind()
            End With
            hfNumReferencias.Value = dtReferencia.Rows.Count.ToString
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar referencias. " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarReferencia()
        Dim dtReferencia As DataTable = Session("referenciasDataTable")
        Try
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()
            If Not String.IsNullOrEmpty(ddlMaterial.SelectedValue) AndAlso ddlMaterial.SelectedValue <> "0" Then
                If dtReferencia.Rows.Find(ddlMaterial.SelectedValue) Is Nothing Then
                    Dim filaDataRow As DataRow = dtReferencia.NewRow()
                    filaDataRow("material") = CStr(ddlMaterial.SelectedValue)
                    filaDataRow("referencia") = ddlMaterial.SelectedItem.Text
                    filaDataRow("cantidad") = CInt(txtCantidad.Text)

                    dtReferencia.Rows.Add(filaDataRow)
                    dtReferencia.AcceptChanges()

                    Session("referenciasDataTable") = dtReferencia
                    EnlazarReferencias()
                    LimpiarFormularioReferencia()
                Else
                    miEncabezado.showError("El material que está intentando adicionar ya fue previamente adicionado. Por favor verifique")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Agregar Referencia. " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarMINs()
        Dim dtMsisdn As DataTable = Session("minsDataTable")
        Try
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            Dim drAux() As DataRow = dtMsisdn.Select("msisdn=" & txtMsisdn.Text.Trim)
            If drAux IsNot Nothing AndAlso drAux.Length < 2 Then
                If Not RegistroMinExiste(drAux) Then
                    Dim filaDataRow As DataRow = dtMsisdn.NewRow()
                    filaDataRow("msisdn") = CLng(txtMsisdn.Text)
                    filaDataRow("activaEquipoAnterior") = chbActivaEquipoAnterior.Checked
                    filaDataRow("comSeguro") = chbComSeguro.Checked
                    filaDataRow("precioConIVA") = CLng(txtPrecioConIVA.Text)
                    filaDataRow("precioSinIVA") = CLng(txtPrecioSinIVA.Text)
                    filaDataRow("idClausula") = CInt(ddlClausula.SelectedValue)
                    filaDataRow("clausula") = ddlClausula.SelectedItem.Text
                    filaDataRow("numeroReserva") = txtNumeroReserva.Text
                    filaDataRow("lista28") = CBool(rblLista28.SelectedValue)

                    dtMsisdn.Rows.Add(filaDataRow)
                    dtMsisdn.AcceptChanges()

                    Session("minsDataTable") = dtMsisdn
                    EnlazarMines()
                    LimpiarFormularioMin()
                Else
                    miEncabezado.showError("El registro que está tratando de ingresar ya existe. Por favor verifique")
                End If
            Else
                miEncabezado.showError("El MSISDN que está intentando adicionar ya superó el número de registros permitidos: 2 Registros. Por favor verifique")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Agregar MINs. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormularioReferencia()
        txtFiltroMaterial.Text = ""
        CargarListadoDeMateriales()
        txtCantidad.Text = ""
    End Sub

    Private Sub LimpiarFormularioMin()
        txtMsisdn.Text = ""
        chbActivaEquipoAnterior.Checked = False
        chbComSeguro.Checked = False
        txtPrecioConIVA.Text = ""
        txtPrecioSinIVA.Text = ""
        ddlClausula.ClearSelection()
        txtNumeroReserva.Text = ""
        rblLista28.ClearSelection()
    End Sub

    Private Sub EliminarMaterial(ByVal material As String)
        Try
            Dim dtReferencia As DataTable = CType(Session("referenciasDataTable"), DataTable)
            If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()

            Dim drAux As DataRow = dtReferencia.Rows.Find(material)
            If drAux IsNot Nothing Then
                dtReferencia.Rows.Remove(drAux)
                dtReferencia.AcceptChanges()
                miEncabezado.showSuccess("El material fue eliminado satisfactoriamente de la lista.")
                Session("referenciasDataTable") = dtReferencia
                EnlazarReferencias()
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar material. " & ex.Message)
        End Try
    End Sub

    Public Sub IniciarFormularioEdicionReferencia(ByVal material As String)
        Try
            Dim dtReferencia As DataTable = CType(Session("referenciasDataTable"), DataTable)
            Dim drAux As DataRow = dtReferencia.Rows.Find(material)
            If drAux IsNot Nothing Then
                pnlInfoGeneral.Enabled = False
                pnlBotonEdicionReferencia.Visible = True
                lbAgregarReferencia.Visible = False
                gvReferencias.Enabled = False
                LimpiarFormularioMin()
                pnlInfoMin.Enabled = False

                txtFiltroMaterial.Text = material
                CargarListadoDeMateriales(material)
                With ddlMaterial
                    If .SelectedValue = "0" Then .SelectedIndex = .Items.IndexOf(.Items.FindByValue(material))
                End With
                txtCantidad.Text = drAux("cantidad").ToString
                hfMaterialAct.Value = material
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
        End Try
    End Sub

    Public Sub FinalizarModoEdicionReferencia()
        Try
            pnlInfoGeneral.Enabled = True
            pnlBotonEdicionReferencia.Visible = False
            lbAgregarReferencia.Visible = True
            gvReferencias.Enabled = True
            pnlInfoMin.Enabled = True
            txtFiltroMaterial.Text = ""
            CargarListadoDeMateriales()
            txtCantidad.Text = ""
            hfMaterialAct.Value = ""
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarMin(ByVal idMsisdn As Integer)
        Try
            Dim dtMsisdn As DataTable = Session("minsDataTable")
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            Dim drAux As DataRow = dtMsisdn.Rows.Find(idMsisdn)
            If drAux IsNot Nothing Then
                dtMsisdn.Rows.Remove(drAux)
                dtMsisdn.AcceptChanges()
                miEncabezado.showSuccess("El Msisdn fue eliminado satisfactoriamente de la lista.")
                Session("minsDataTable") = dtMsisdn
                EnlazarMines()
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar Msisdn. " & ex.Message)
        End Try
    End Sub

    Public Sub IniciarFormularioEdicionMin(ByVal idMsisdn As Integer)
        Try
            Dim dtMsisdn As DataTable = CType(Session("minsDataTable"), DataTable)
            If dtMsisdn Is Nothing Then dtMsisdn = CrearEstructuraTablaMsisdn()
            Dim drAux As DataRow = dtMsisdn.Rows.Find(idMsisdn)
            If drAux IsNot Nothing Then
                pnlInfoGeneral.Enabled = False
                pnlBotonEdicionMin.Visible = True
                lbAgregarMIN.Visible = False
                gvMINS.Enabled = False
                LimpiarFormularioReferencia()
                pnlInfoReferencia.Enabled = False

                txtMsisdn.Text = drAux("msisdn").ToString
                txtNumeroReserva.Text = drAux("numeroReserva").ToString
                chbActivaEquipoAnterior.Checked = drAux("activaEquipoAnterior")
                chbComSeguro.Checked = drAux("comSeguro")
                txtPrecioConIVA.Text = drAux("precioConIVA").ToString
                txtPrecioSinIVA.Text = drAux("precioSinIVA").ToString
                With ddlClausula
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(drAux("idClausula")))
                End With
                rblLista28.SelectedValue = IIf(CBool(drAux("lista28")), "1", "0")
                hfMsisdnAct.Value = idMsisdn.ToString
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
        End Try
    End Sub

    Public Sub FinalizarModoEdicionMin()
        Try
            pnlInfoGeneral.Enabled = True
            pnlBotonEdicionMin.Visible = False
            lbAgregarMIN.Visible = True
            gvMINS.Enabled = True
            pnlInfoReferencia.Enabled = True

            txtMsisdn.Text = ""
            txtNumeroReserva.Text = ""
            chbActivaEquipoAnterior.Checked = False
            chbComSeguro.Checked = False
            txtPrecioConIVA.Text = ""
            txtPrecioSinIVA.Text = ""
            ddlClausula.ClearSelection()
            rblLista28.ClearSelection()
            hfMsisdnAct.Value = ""
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
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

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=1)
            With ddlTipoNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad", "0"))
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarNovedades(ByVal dtNovedad As DataTable)
        Try
            With gvNovedad
                .DataSource = dtNovedad
                .DataBind()
            End With
            Session("dtNovedad") = dtNovedad
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar lista de novedades. " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarNovedad(ByVal idNovedad As Integer)
        Try
            Dim dtNovedad As DataTable = CType(Session("dtNovedad"), DataTable)
            Dim drAux As DataRow = dtNovedad.Rows.Find(idNovedad)
            If drAux IsNot Nothing Then
                dtNovedad.Rows.Remove(drAux)
                dtNovedad.AcceptChanges()
                miEncabezado.showSuccess("La novedad fue eliminada satisfactoriamente de la lista.")
                Session("dtNovedad") = dtNovedad
                EnlazarNovedades(dtNovedad)
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub gvNovedad_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNovedad.RowCommand
        If e.CommandName = "eliminar" Then
            EliminarNovedad(CInt(e.CommandArgument.ToString))
        End If
    End Sub

    Private Sub gvMINS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMINS.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(2).Text = IIf(CBool(CType(e.Row.DataItem, DataRowView).Item("activaEquipoAnterior")), "SI", "NO")
            e.Row.Cells(3).Text = IIf(CBool(CType(e.Row.DataItem, DataRowView).Item("comSeguro")), "SI", "NO")
        End If
    End Sub


    Private Function CrearEstructuraTablaNovedad() As DataTable
        Dim dtAux As New DataTable
        Dim dcAux As New DataColumn("idNovedad")
        With dcAux
            .AutoIncrement = True
            .AutoIncrementStep = 1
        End With
        With dtAux
            .Columns.Add(dcAux)
            .Columns.Add("idTipoNovedad", GetType(Integer))
            .Columns.Add("tipoNovedad", GetType(String))
            .Columns.Add("observacion", GetType(String))
        End With
        Dim pk() As DataColumn = {dtAux.Columns("idNovedad")}
        dtAux.PrimaryKey = pk
        Return dtAux
    End Function

    Public Function RegistroMinExiste(ByVal drMinActual() As DataRow) As Boolean
        If drMinActual.Length > 0 Then
            Dim drAux As DataRow = drMinActual(0)
            Dim activaEquipo As Boolean = IIf(drAux("activaEquipoAnterior").ToString.ToUpper = "SI", True, False)
            Dim comseguro As Boolean = IIf(drAux("comSeguro").ToString.ToUpper = "SI", True, False)
            If drAux("msisdn") = CLng(txtMsisdn.Text) AndAlso activaEquipo = chbActivaEquipoAnterior.Checked _
                AndAlso comseguro = chbComSeguro.Checked AndAlso drAux("precioConIVA") = CLng(txtPrecioConIVA.Text) _
                AndAlso drAux("precioSinIVA") = CLng(txtPrecioSinIVA.Text) AndAlso drAux("idClausula") = CInt(ddlClausula.SelectedValue) Then

                Return True
            Else
                Return False
            End If
        Else
            Return False
        End If
    End Function

    Private Function CrearEstructuraTablaMsisdn() As DataTable
        Dim dtMsisdn As New DataTable
        With dtMsisdn
            Dim dcAux As New DataColumn("idMsisdn")
            With dcAux
                .AutoIncrement = True
                .AutoIncrementStep = 1
            End With
            .Columns.Add(dcAux)
            .Columns.Add("msisdn", GetType(Long))
            .Columns.Add("activaEquipoAnterior", GetType(Boolean))
            .Columns.Add("comSeguro", GetType(Boolean))
            .Columns.Add("precioConIVA", GetType(Long))
            .Columns.Add("precioSinIVA", GetType(Long))
            .Columns.Add("idClausula", GetType(Integer))
            .Columns.Add("clausula", GetType(String))
            .Columns.Add("numeroReserva", GetType(String))
            .Columns.Add("lista28", GetType(Boolean))
            .AcceptChanges()
        End With
        Dim pkMin() As DataColumn = {dtMsisdn.Columns("idMsisdn")}
        dtMsisdn.PrimaryKey = pkMin
        Return dtMsisdn
    End Function

    Private Function CrearEstructuraTablaReferencia() As DataTable
        Dim dtReferencia As New DataTable
        With dtReferencia
            .Columns.Add("material", GetType(String))
            .Columns.Add("referencia", GetType(String))
            .Columns.Add("cantidad", GetType(Integer))
            .AcceptChanges()
        End With
        Dim pkMaterial() As DataColumn = {dtReferencia.Columns("material")}
        dtReferencia.PrimaryKey = pkMaterial
        Return dtReferencia
    End Function

#End Region

#Region "Métodos Cargue de Archivos"

    Private Sub CargarArchivo()

        Dim nombreArchivoProceso As String
        Dim NombreValido As Boolean = False

        Try
            If fuArchivoAdjuntarEO.PostedFiles.Length > 0 Then
                Dim objCargueArchivo As New CargueArchivosCEM
                With objCargueArchivo
                    Dim nombreArchivo As String = Path.GetFileNameWithoutExtension(fuArchivoAdjuntarEO.PostedFiles(0).ClientFileName) & Path.GetExtension(fuArchivoAdjuntarEO.PostedFiles(0).ClientFileName)
                    Dim ExpReg As New System.Text.RegularExpressions.Regex("^[a-zA-Z0-9-_ ]+$")
                    NombreValido = (ExpReg.IsMatch(nombreArchivo.Split(".").GetValue(0)))
                    If NombreValido Then
                        nombreArchivoProceso = Server.MapPath("Archivos\") & nombreArchivo
                        System.IO.File.Delete(nombreArchivoProceso)
                        System.IO.File.Move(fuArchivoAdjuntarEO.PostedFiles(0).TempFileName, Server.MapPath("Archivos\") & nombreArchivo)
                        Dim dtDatos As DataTable = EstructuraTabla()
                        EstablecerLicenciaGembox()
                        Dim oExcel As New ExcelFile
                        Dim wsData As ExcelWorksheet
                        Dim fileExtension As String = Path.GetExtension(nombreArchivo)
                        If fileExtension.ToUpper = ".XLS" Then
                            oExcel.LoadXls(nombreArchivoProceso)
                        ElseIf fileExtension.ToUpper = ".XLSX" Then
                            oExcel.LoadXlsx(nombreArchivoProceso, XlsxOptions.None)
                        End If
                        wsData = oExcel.Worksheets(0)
                        ValidarArchivo(wsData, dtDatos)

                        If Not dtError Is Nothing AndAlso dtError.Rows.Count > 0 Then
                            With gvErrores
                                .DataSource = dtError
                                .DataBind()
                            End With
                            gvErrores.Visible = True
                            lblRegistrosCargados.Text = "Registros Cargados: 0"
                        Else
                            gvErrores.Visible = False
                            pnlInfoReferencia.Enabled = False
                            pnlInfoMin.Enabled = False
                            With gvDetalleArchivo
                                .DataSource = dtDatos
                                .DataBind()
                            End With
                            Session("dtDetalleArchivo") = dtDatos
                            hfDetalleArchivo.Value = dtDatos.Rows.Count.ToString
                            lblRegistrosCargados.Text = "Registros Cargados: " & CInt(dtDatos.Rows.Count.ToString)
                            gvDetalleArchivo.Visible = True
                        End If
                        fuArchivoAdjuntarEO.ClearPostedFiles()
                    Else
                        miEncabezado.showError("Nombre de archivo no valido para procesar")
                        fuArchivoAdjuntarEO.ClearPostedFiles()
                        Exit Sub
                    End If
                End With
            Else
                miEncabezado.showError("Seleccione el archivo a procesar")
                fuArchivoAdjuntarEO.ClearPostedFiles()
            End If

        Catch ex As Exception
            miEncabezado.showError("Se generó error procesando archivo: " + ex.Message)
        Finally
            If File.Exists(nombreArchivoProceso) Then File.Delete(nombreArchivoProceso)
        End Try

    End Sub

    Private Function EstructuraTabla()
        Try
            Dim dt As New DataTable
            With dt.Columns
                .Add(New DataColumn("min", GetType(String)))
                .Add(New DataColumn("clausula", GetType(Integer)))
                .Add(New DataColumn("material", GetType(String)))
                .Add(New DataColumn("referencia", GetType(String)))
                .Add(New DataColumn("envioSim", GetType(String)))
                .Add(New DataColumn("materialSim", GetType(String)))
                .Add(New DataColumn("zonaSim", GetType(String)))
                .Add(New DataColumn("activaEquipo", GetType(String)))
                .Add(New DataColumn("comseguro", GetType(String)))
                .Add(New DataColumn("precioEquipoSinIva", GetType(Integer)))
                .Add(New DataColumn("precioEquipoConIva", GetType(Integer)))
                .Add(New DataColumn("precioSimCardSinIva", GetType(Integer)))
                .Add(New DataColumn("precioSimCardConIva", GetType(Integer)))
                '.Add(New DataColumn("precioTotalSinIva", GetType(Double)))
                '.Add(New DataColumn("precioTotalConIva", GetType(Double)))
            End With
            dt.AcceptChanges()
            Return dt
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Function EstructuraTablaError()
        Try
            Dim dt As New DataTable
            With dt.Columns
                .Add(New DataColumn("id", GetType(Integer)))
                .Add(New DataColumn("nombre", GetType(String)))
                .Add(New DataColumn("descripcion", GetType(String)))
            End With
            dt.AcceptChanges()
            Return dt
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Sub ValidarArchivo(ByVal ws As ExcelWorksheet, ByVal dtDatos As DataTable)
        Dim index As Integer = 1
        Dim errorColumnas As Boolean = False
        Dim indexFila As Integer = 0
        Try
            For Each fila As ExcelRow In ws.Rows
                If fila.AllocatedCells.Count <> dtDatos.Columns.Count Then
                    If fila.Cells(1).Value IsNot Nothing Then
                        AdicionarError(index, "Fila inválida", "El Número de columnas es inválido.")
                        errorColumnas = True
                        Exit For
                    End If
                Else
                    Dim indexColumna As Integer = 0
                    Dim drAux As DataRow
                    drAux = dtDatos.NewRow
                    For Each columna As ExcelCell In fila.AllocatedCells
                        If indexFila > 0 Then
                            If fila.AllocatedCells(indexColumna).Value IsNot Nothing Then
                                drAux(indexColumna) = fila.AllocatedCells(indexColumna).Value
                                indexColumna += 1
                            Else
                                indexColumna += 1
                            End If
                        Else
                            Exit For
                        End If
                    Next
                    If drAux IsNot Nothing And drAux(0) IsNot System.DBNull.Value Then
                        Dim numMin As String = drAux(0).ToString.Trim
                        Dim minExiste As Boolean = False
                        For x As Integer = 0 To dtDatos.Rows.Count - 1
                            If dtDatos.Rows(x).Item("min") = numMin Then
                                If dtError Is Nothing Then
                                    dtError = EstructuraTablaError()
                                End If
                                AdicionarError(dtError.Rows.Count + 1, "Min Repetido", "El MIN " & numMin & " se encuentra repetido.")
                                minExiste = True
                            Else
                                minExiste = False
                            End If
                        Next
                        If Not minExiste Then
                            dtDatos.Rows.Add(drAux)
                        End If
                    End If
                    indexFila = indexFila + 1
                End If
            Next
            If Not errorColumnas Then
                If dtDatos.Rows.Count = 0 Then
                    If dtError Is Nothing Then
                        dtError = EstructuraTablaError()
                    End If
                    AdicionarError(dtError.Rows.Count + 1, "Archivo Sin Datos", "El archivo no tiene datos para procesar.")
                    errorColumnas = True
                End If
            End If

            If Not errorColumnas Then
                validarDatos(dtDatos)
            End If
        Catch ex As Exception
            Throw New Exception("Se generó un error en la validación del archivo, por favor elimine las filas y columnas vacías e intente nuevamente.")
        End Try
    End Sub

    Private Sub validarDatos(ByVal dtDatos As DataTable)
        Dim hayError As Boolean = False
        Dim i As Integer = 0

        If dtError Is Nothing Then
            dtError = EstructuraTablaError()
        End If

        Dim dtMaterial As DataTable = HerramientasMensajeria.ObtenerMateriales()
        Dim dtClausula As DataTable = HerramientasMensajeria.ConsultaClausula()
        Dim dtRegion As DataTable = HerramientasMensajeria.ConsultaRegion()

        For i = 0 To dtDatos.Rows.Count - 1
            If dtDatos.Rows(i).Item("min").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo MIN no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("min").ToString.Trim.Length <> 10 Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El MIN debe ser de 10 caracteres.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("clausula").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo CLAUSULA no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("envioSim").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo ENVIO SIM CARD no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("activaEquipo").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo ACTIVA EQUIPO ANTERIOR no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("comseguro").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo COMSEGURO no puede estar vacio.")
                hayError = True
            End If
            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then
                If dtDatos.Rows(i).Item("material").ToString.Trim = "" Or dtDatos.Rows(i).Item("materialSim").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioEquipoSinIva").ToString.Trim = "" Or _
                   dtDatos.Rows(i).Item("precioEquipoConIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardSinIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardConIva").ToString.Trim = "" Then
                    AdicionarError(dtError.Rows.Count + 1, "Campos inválidos", "los campos relacionados con equipo y SimCard no pueden estar vacios.")
                    hayError = True
                End If
            End If
            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "NO" Then
                If dtDatos.Rows(i).Item("material").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioEquipoSinIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioEquipoConIva").ToString.Trim = "" Then
                    AdicionarError(dtError.Rows.Count + 1, "Campos inválidos", "los campos relacionados con el equipo no pueden estar vacios.")
                    hayError = True
                End If
            End If
            If dtDatos.Rows(i).Item("material").ToString.Trim = "" And dtDatos.Rows(i).Item("referencia").ToString.Trim = "" And dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then
                If dtDatos.Rows(i).Item("materialSim").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardSinIva").ToString.Trim = "" Or dtDatos.Rows(i).Item("precioSimCardConIva").ToString.Trim = "" Then
                    AdicionarError(dtError.Rows.Count + 1, "Campos inválidos", "los campos relacionados con la SimCard no pueden estar vacios.")
                    hayError = True
                End If
            End If

            Dim drSelect() As DataRow
            If dtDatos.Rows(i).Item("material").ToString.Trim <> "" Then
                drSelect = dtMaterial.Select("material = '" & dtDatos.Rows(i).Item("material").ToString.Trim & "'")
                If drSelect.Length = 0 Or drSelect Is Nothing Then
                    AdicionarError(dtError.Rows.Count + 1, "Material Equipo no existe", "El material del equipo no existe en el sistema.")
                Else
                    If drSelect(0).Item("idtipoproducto") = 2 Then
                        AdicionarError(dtError.Rows.Count + 1, "Material Equipo inválido", "El material del equipo corresponde a una SimCard.")
                    End If
                End If
            End If

            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then

                drSelect = Nothing
                If dtDatos.Rows(i).Item("materialSim").ToString.Trim <> "" Then
                    drSelect = dtMaterial.Select("material = '" & dtDatos.Rows(i).Item("materialSim").ToString.Trim & "'")
                    If drSelect.Length = 0 Or drSelect Is Nothing Then
                        AdicionarError(dtError.Rows.Count + 1, "Material Simcard no existe", "El material de la Simcard no existe en el sistema.")
                    Else
                        If drSelect(0).Item("idtipoproducto") = 1 Then
                            AdicionarError(dtError.Rows.Count + 1, "Material Simcard inválido", "El Material de la Simcard corresponde a una equipo.")
                        End If
                    End If
                End If
            End If

            If dtDatos.Rows(i).Item("min").ToString.Trim Then
                Dim dtMines As DataTable
                dtMines = HerramientasMensajeria.ObtenerMinesMensajeria()
                drSelect = Nothing
                drSelect = dtMines.Select("msisdn = '" & dtDatos.Rows(i).Item("min").ToString.Trim & "'")
                If drSelect.Length > 0 Then
                    AdicionarError(dtError.Rows.Count + 1, "Min inválido", "El min " & dtDatos.Rows(i).Item("min") & " ya se encuentra registrado en el sistema.")
                End If
            End If

            Dim dr() As DataRow
            dr = dtClausula.Select("idClausula = " & dtDatos.Rows(i).Item("clausula").ToString.Trim)
            If dr.Length = 0 Then
                AdicionarError(dtError.Rows.Count + 1, "Clausula inválida", "el identificador de la clausula " & dtDatos.Rows(i).Item("clausula") & " no existe en el sistema.")
            End If

            If dtDatos.Rows(i).Item("envioSim").ToString.Trim.ToUpper = "SI" Then
                Dim drRegion() As DataRow
                drRegion = dtRegion.Select("nombreRegion like '%" & dtDatos.Rows(i).Item("zonaSim").ToString.Trim & "%'")
                If drRegion.Length = 0 Then
                    AdicionarError(dtError.Rows.Count + 1, "Región inválida", "La región " & dtDatos.Rows(i).Item("zonaSim") & " no existe en el sistema.")
                End If
            End If
        Next
    End Sub

    Private Sub AdicionarError(ByVal id As Integer, ByVal nombre As String, ByVal descripcion As String)
        Try
            If dtError Is Nothing Then
                dtError = EstructuraTablaError()
            End If
            With dtError
                Dim drError As DataRow = .NewRow()
                With drError
                    .Item("id") = id
                    .Item("nombre") = nombre
                    .Item("descripcion") = descripcion
                End With
                .Rows.Add(drError)
                .AcceptChanges()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

#Region "Métodos Servicio Técnico"

    Private Sub AgregarEquipo()
        Dim dtEquipo As DataTable = Session("equiposDataTable")
        Try
            If dtEquipo Is Nothing Then dtEquipo = CrearEstructuraTablaEquipo()
            If dtEquipo.Select("imei=" & txtImei.Text & " OR msisdn=" & txtMsisdnST.Text).Length = 0 Then
                Dim filaDataRow As DataRow = dtEquipo.NewRow()
                filaDataRow("imei") = txtImei.Text
                filaDataRow("prestamo") = cbRequierePrestamo.Checked
                filaDataRow("msisdn") = CLng(txtMsisdnST.Text)

                dtEquipo.Rows.Add(filaDataRow)
                dtEquipo.AcceptChanges()

                Session("equiposDataTable") = dtEquipo
                EnlazarEquipos()
                LimpiarFormularioEquipo()
            Else
                miEncabezado.showError("El IMEI y/o el MSISDN que está intentando adicionar ya fue previamente adicionado. Por favor verifique.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error la tratar de agregar el equipo: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarEquipos()
        Try
            Dim dtEquipo As DataTable = Session("equiposDataTable")
            If dtEquipo Is Nothing Then dtEquipo = CrearEstructuraTablaEquipo()

            With gvEquipos
                .DataSource = dtEquipo
                .DataBind()
            End With

            If dtEquipo.Select("prestamo = 1").Length > 0 Then
                pnlInventarioEquiposPrestamo.Visible = True
                If Session("dtEquipoPrestamo") Is Nothing OrElse DirectCast(Session("dtEquipoPrestamo"), DataTable).Rows.Count = 0 Then
                    MostrarReservasNoConfirmadas()
                    'EnlazarInventarioPrestamo()
                End If
            Else
                pnlInventarioEquiposPrestamo.Visible = False
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar equipos: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormularioEquipo()
        txtImei.Text = ""
        cbRequierePrestamo.Checked = False
        txtMsisdnST.Text = ""
    End Sub

    Private Sub LimpiarFormularioEquipoPrestamo()
        txtFiltroMaterialPrestamo.Text = ""
        CargarListadoDeMaterialesPrestamo()
        txtCantidadPrestamo.Text = ""
    End Sub

    Private Sub EliminarEquipo(ByVal imei As String)
        Try
            Dim dtEquipo As DataTable = Session("equiposDataTable")
            If dtEquipo Is Nothing Then dtEquipo = CrearEstructuraTablaEquipo()

            Dim drAux As DataRow = dtEquipo.Rows.Find(imei)
            If drAux IsNot Nothing Then
                dtEquipo.Rows.Remove(drAux)
                dtEquipo.AcceptChanges()
                miEncabezado.showSuccess("El equipo fue eliminado satisfactoriamente de la lista.")
                Session("equiposDataTable") = dtEquipo
                EnlazarEquipos()
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar equipo: " & ex.Message)
        End Try
    End Sub

    Private Sub IniciarFormularioEdicionEquipo(ByVal imei As String)
        Try
            Dim dtEquipo As DataTable = Session("equiposDataTable")
            Dim drAux As DataRow = dtEquipo.Rows.Find(imei)
            If drAux IsNot Nothing Then
                pnlInfoGeneral.Enabled = False
                pnlBotonEdicionEquipo.Visible = True
                lbAgregarEquipo.Visible = False
                gvEquipos.Enabled = False
                LimpiarFormularioEquipo()

                txtImei.Text = imei
                cbRequierePrestamo.Checked = CBool(drAux("prestamo"))
                txtMsisdnST.Text = drAux("msisdn").ToString
                hfEquipoAct.Value = imei
            Else
                miEncabezado.showError("Imposible recuperar la información del item seleccionado. Por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de inicializar formulario de edición. " & ex.Message)
        End Try
    End Sub

    Private Sub FinalizarModoEdicionEquipo()
        Try
            pnlInfoGeneral.Enabled = True
            pnlBotonEdicionEquipo.Visible = False
            lbAgregarEquipo.Visible = True
            gvEquipos.Enabled = True
            txtImei.Text = ""
            cbRequierePrestamo.Checked = False
            txtMsisdnST.Text = ""
            hfEquipoAct.Value = ""
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de finalizar modo de edición. " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarEquipo()
        Dim dtEquipo As DataTable = CType(Session("equiposDataTable"), DataTable)
        Dim imei As String = hfEquipoAct.Value
        Dim drAux As DataRow
        Try
            If dtEquipo Is Nothing Then dtEquipo = CrearEstructuraTablaEquipo()
            drAux = dtEquipo.Rows.Find(imei)
            If drAux IsNot Nothing Then
                If imei.Trim <> txtImei.Text.Trim Then
                    If dtEquipo.Rows.Find(txtImei.Text.Trim) IsNot Nothing Then
                        miEncabezado.showError("El IMEI que está intentando adicionar ya fue previamente adicionado. Debe modificar el registro inicial.")
                        Exit Sub
                    End If
                End If

                drAux("imei") = txtImei.Text
                drAux("prestamo") = CBool(cbRequierePrestamo.Checked)
                drAux("msisdn") = txtMsisdnST.Text
                drAux.AcceptChanges()
                dtEquipo.AcceptChanges()
                Session("equiposDataTable") = dtEquipo
                EnlazarEquipos()
                FinalizarModoEdicionEquipo()
                miEncabezado.showSuccess("El IMEI fue actualizado satisfactoriamente.")
            Else
                miEncabezado.showError("Imposible encontrar el registro asignado al IMEI. Por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de actualizar Equipo: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarInventarioPrestamo()
        Try
            Dim objInventarioPrestamo As New InventarioSatelitePrestamo()
            With objInventarioPrestamo
                .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})
            End With

            Dim dtDatos As DataTable = objInventarioPrestamo.ObtieneInventarioPrestamoAgrupado()
            Session("dtDatos") = dtDatos
            With gvInventarioPrestamo
                .DataSource = dtDatos
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar Inventario de Prestamo: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarEquiposPrestamo(ByVal idBloqueo As Integer)
        Try
            Dim objBloqueoDetalle As New DetalleProductoBloqueoColeccion()
            With objBloqueoDetalle
                .IdBloqueo = New List(Of Integer)(New Integer() {idBloqueo})
                .CargarDatos()
            End With

            With gvEquiposPrestamo
                .DataSource = objBloqueoDetalle.GenerarDataTable()
                .DataBind()
                Session("dtEquipoPrestamo") = DirectCast(.DataSource, DataTable)
            End With
            LimpiarFormularioEquipoPrestamo()
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de enlazar equipos de Prestamo: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarEquipoPrestamo()
        Try
            Dim idBloqueo As Integer = 0
            Dim objBloqueoInventario As BloqueoInventario
            Dim idMaterial As String() = ddlMaterialPrestamo.SelectedValue.Split("|")

            If Session("dtEquipoPrestamo") IsNot Nothing AndAlso DirectCast(Session("dtEquipoPrestamo"), DataTable).Rows.Count > 0 Then
                Dim dtAux As DataTable = DirectCast(Session("dtEquipoPrestamo"), DataTable)
                idBloqueo = CInt(dtAux.Rows(0).Item("idBloqueo"))

                objBloqueoInventario = New BloqueoInventario(idBloqueo:=idBloqueo)
            Else
                Dim idBodega As Integer = CInt(idMaterial(2))

                objBloqueoInventario = New BloqueoInventario()
                With objBloqueoInventario
                    .IdBodega = idBodega
                    .FechaRegistro = Nothing
                    .IdUsuario = CInt(Session("usxp001"))
                    .IdEstado = Enumerados.InventarioBloqueo.Temporal
                    .FechaInicio = Now()
                    .FechaFin = Nothing
                    .IdUnidadNegocio = Enumerados.UnidadNegocio.MensajeriaEspecializada
                    .IdDestinatario = Nothing
                    .IdTipoBloqueo = Enumerados.TipoBloqueo.ReservadeInventario
                    .Observacion = "Bloqueo generado por préstamo de Servicio Técnico"

                    Dim resultadoBloqueo As ResultadoProceso = .Registrar()
                    If resultadoBloqueo.Valor = 0 Then
                        idBloqueo = .IdBloqueo
                    Else
                        miEncabezado.showWarning("No se generó la reserva: " & resultadoBloqueo.Mensaje)
                        Exit Sub
                    End If
                End With
            End If

            If idBloqueo <> 0 Then
                Dim objDetalleProductoBloqueo As New DetalleProductoBloqueo
                With objDetalleProductoBloqueo
                    .IdProducto = idMaterial(1)
                    .Material = idMaterial(0)
                    .Cantidad = CInt(txtCantidadPrestamo.Text)
                End With

                objBloqueoInventario.ProductoBloqueoColeccion.Adicionar(objDetalleProductoBloqueo)
                Dim resultado As ResultadoProceso = objBloqueoInventario.Registrar()
                If resultado.Valor = 0 Then
                    EnlazarEquiposPrestamo(idBloqueo)
                Else
                    miEncabezado.showWarning("No se generó la reserva: " & resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de agregar equipo de préstamo: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarEquipoPrestamo(ByVal idBloqueoProducto As Integer)
        Try
            Dim registro As DataRow() = DirectCast(Session("dtEquipoPrestamo"), DataTable).Select("idBloqueoDetalleProducto=" & idBloqueoProducto)
            If registro.Length > 0 Then
                Dim detalleBloqueoProducto As New DetalleProductoBloqueoColeccion()
                With detalleBloqueoProducto
                    .IdBloqueo = New List(Of Integer)(New Integer() {CInt(registro(0).Item("idBloqueo"))})
                    .IdProducto = New List(Of Integer)(New Integer() {CInt(registro(0).Item("idProducto"))})
                    .CargarDatos()
                End With

                Dim objBloqueo As New BloqueoInventario()
                With objBloqueo
                    Dim resultado As ResultadoProceso = .DesbloquearProducto(detalleBloqueoProducto)
                    If resultado.Valor = 0 Then
                        EnlazarEquiposPrestamo(CInt(registro(0).Item("idBloqueo")))
                        miEncabezado.showSuccess("Reserva eliminada correctamente.")
                    Else
                        miEncabezado.showWarning("No se logro eliminar la reserva: " & resultado.Mensaje)
                    End If
                End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de eliminar bloqueo: " & ex.Message)
        End Try
    End Sub

    Private Sub MostrarReservasNoConfirmadas()
        Try
            Dim objBloqueoPrestamo As New BloqueoInventarioColeccion()
            With objBloqueoPrestamo
                .IdUsuario = CInt(Session("usxp001"))
                .IdEstado = Enumerados.InventarioBloqueo.Temporal
                .CargarDatos()
            End With
            If objBloqueoPrestamo.Count > 0 Then

                'Se carga la informacón del detalle del Bloqueo
                Dim listBloqueo As New List(Of Integer)
                For Each bloqueo As BloqueoInventario In objBloqueoPrestamo
                    listBloqueo.Add(bloqueo.IdBloqueo)
                Next

                Dim objDetalleBloqueo As New DetalleProductoBloqueoColeccion()
                With objDetalleBloqueo
                    .IdBloqueo = listBloqueo
                    .CargarDatos()
                    Session("detalleBloqueos") = .GenerarDataTable()
                End With

                With gvReservasNoConfirmadas
                    .DataSource = objBloqueoPrestamo.GenerarDataTable()
                    .DataBind()
                End With

                dlgRecuperarReserva.Show()
            End If
        Catch ex As Exception
            miEncabezado.showError("Erro al obtener reservas no confirmadas: " & ex.Message)
        End Try
    End Sub

    Private Function CrearEstructuraTablaEquipo() As DataTable
        Dim dtEquipo As New DataTable
        With dtEquipo
            .Columns.Add("imei", GetType(String))
            .Columns.Add("prestamo", GetType(Boolean))
            .Columns.Add("msisdn", GetType(Long))
            .AcceptChanges()
        End With
        Dim pkMaterial() As DataColumn = {dtEquipo.Columns("imei")}
        dtEquipo.PrimaryKey = pkMaterial
        Return dtEquipo
    End Function

#End Region

#End Region

End Class