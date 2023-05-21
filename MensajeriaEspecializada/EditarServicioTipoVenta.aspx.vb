Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports System.Text

Public Class EditarServicioTipoVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer

    Private _referenciasDataTable As New DataTable
    Private _minsDataTable As New DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, _idServicio)
            If _idServicio > 0 Then
                Session("idServicio") = _idServicio
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Modificar Venta")
                End With

                'Limpia variables de sesión
                Session.Remove("fechas")
                Session.Remove("dtReferencia")
                Session.Remove("dtCampaniasVenta")
                Session.Remove("dtListaPlanes")

                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()

                CargaInicial()
                CargarInformacionGeneralServicio(_idServicio)
                VisualizarDocumentosAsociados(_idServicio)
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                rpEdidatServicio.Enabled = False
            End If
        End If
    End Sub

    Private Sub cmbCompania_DataBinding(sender As Object, e As EventArgs) Handles cmbCompania.DataBinding
        If cmbCompania.DataSource Is Nothing Then cmbCompania.DataSource = Session("dtCampaniasVenta")
    End Sub

    Private Sub cmbCompania_ValueChanged(sender As Object, e As System.EventArgs) Handles cmbCompania.ValueChanged
        Try
            'Planes Venta
            MetodosComunes.CargarComboDX(cmbPlan, New PlanVentaColeccion(idCampania:=cmbCompania.Value).GenerarDataTable(), "idPlan", "nombrePlan")

            cmbEquipo.Items.Clear()
            cmbEquipo.ClientEnabled = cbRequerido.Checked

            If cmbCiudadEntrega.Value IsNot Nothing Then
                CargarEquipos()
                ''Equipos
                'Dim listBodegas As New List(Of Integer)
                'For Each bodega As DataRow In DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)
                '    listBodegas.Add(CInt(bodega("idBodega")))
                'Next

                'Dim objInventarioVenta As New InventarioSateliteVenta()
                'With objInventarioVenta
                '    .IdCampania = New List(Of Integer)(New Integer() {cmbCompania.Value})
                '    .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.HANDSETS})
                '    .IdBodega = listBodegas
                'End With


                'If cbRequerido.Checked Then
                '    cmbEquipo.ClientEnabled = True
                '    Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
                '    dvDatos.RowFilter = "cantidad > 0"
                '    With cmbEquipo
                '        .DataSource = dvDatos
                '        .DataBind()
                '    End With
                'Else
                '    cmbEquipo.ClientEnabled = False
                'End If
            End If
            cmbCompania.DataBind()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de cargar datos asociados a la campaña: " & ex.Message)
        End Try
    End Sub

    Private Sub cmbCiudadEntrega_ValueChanged(sender As Object, e As System.EventArgs) Handles cmbCiudadEntrega.ValueChanged

    End Sub

    Protected Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        Dim resultado As New ResultadoProceso
        resultado = ValidarMsisdn
        If resultado.Valor = 0 Then
            Actualizar()
        Else
            miEncabezado.showWarning(resultado.Mensaje)
            asDireccion.value = Session("direccion")
        End If

    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        Dim respuesta As New ResultadoProceso
        Try
            If e.Parameter = "ValidarCupos" Then
                If cmbJornada.Value <> "0" AndAlso dateFechaAgenda.Date > Date.MinValue Then
                    respuesta = ConsultarCapacidadEntrega()
                    If respuesta.Valor <> 0 Then miEncabezado.showWarning(respuesta.Mensaje)
                    CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                End If
            End If
            e.Result = ASPxCallback.GetRenderResult(lblValorEquipo)
        Catch : End Try
    End Sub

    Protected Sub cmbCiudadEntrega_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbCiudadEntrega.SelectedIndexChanged
        ValidarCambioBodega()
    End Sub

    Private Sub cmbPlan_DataBinding(sender As Object, e As EventArgs) Handles cmbPlan.DataBinding
        If cmbPlan.DataSource Is Nothing Then cmbPlan.DataSource = Session("dtListaPlanes")
    End Sub

    'Protected Sub cmbCompania_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbCompania.SelectedIndexChanged
    '    Try
    '        'Planes Venta
    '        MetodosComunes.CargarComboDX(cmbPlan, New PlanVentaColeccion(idCampania:=cmbCompania.Value).GenerarDataTable(), "idPlan", "nombrePlan")

    '        If cmbCiudadEntrega.Value IsNot Nothing Then
    '            'Equipos
    '            Dim listBodegas As New List(Of Integer)
    '            For Each bodega As DataRow In DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)
    '                listBodegas.Add(CInt(bodega("idBodega")))
    '            Next

    '            Dim objInventarioVenta As New InventarioSateliteVenta()
    '            With objInventarioVenta
    '                .IdCampania = New List(Of Integer)(New Integer() {cmbCompania.Value})
    '                .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.HANDSETS})
    '                .IdBodega = listBodegas
    '            End With

    '            Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
    '            dvDatos.RowFilter = "cantidad > 0"
    '            With cmbEquipo
    '                .SelectedIndex = -1
    '                .DataSource = dvDatos.ToTable()
    '                .DataBind()
    '            End With
    '        End If
    '    Catch ex As Exception
    '        miEncabezado.showError("Se generó un error al tratar de cargar datos asociados a la campaña: " & ex.Message)
    '    End Try
    'End Sub

    Protected Sub cmbPlan_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbPlan.SelectedIndexChanged
        CargarEquipos()
        cmbPlan.DataBind()
        cmbCompania.DataBind()
    End Sub

    Protected Sub btnAutorizar_Click(sender As Object, e As EventArgs) Handles btnAutorizar.Click
        Try
            Dim objUsuario As New Usuario(txtUsuarioAdmin.Text.Trim, txtClaveAdmin.Text.Trim)
            If objUsuario.IdPerfil > 0 Then
                Dim dvPermiso As DataView = CType(Session("dtInfoPermisosOpcRestringidas"), DataTable).Copy().DefaultView
                dvPermiso.RowFilter = "nombreControl = 'cbRequerido'"

                If dvPermiso.Count > 0 Then
                    dvPermiso.RowFilter += " AND idPerfil = " & objUsuario.IdPerfil.ToString
                    If dvPermiso.Count > 0 Then
                        cmbEquipo.ValidationSettings.RequiredField.IsRequired = False
                        miEncabezado.showSuccess("Las credenciales se establecieron correctamente, por favor registre el servicio.")
                        cmbEquipo.ClientEnabled = True
                    Else
                        cbRequerido.Checked = True
                        miEncabezado.showWarning("Las credenciales ingresadas no corresponden a un perfil autorizado para realizar la acción.")
                    End If
                End If
                CargarEquipos()
            Else
                miEncabezado.showWarning("Las credenciales no son válidas, por favor intente nuevamente.")
            End If
            pcAutorizar.ShowOnPageLoad = False
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar realizar la autorización: " & ex.Message)
        End Try
    End Sub

    Private Sub cmbEquipo_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbEquipo.Callback
        CargarEquipos()
        With cmbEquipo
            .ClientEnabled = True
            .SelectedIndex = -1
        End With
        cmbPlan.DataBind()
        cmbCompania.DataBind()
    End Sub

    Private Sub cmbEquipo_ValueChanged(sender As Object, e As System.EventArgs) Handles cmbEquipo.ValueChanged
        ObtenerValorEquipo()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            Dim idUsuario As Integer = 0
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            'Carga de las Ciudades
            Dim dtCiudad As DataTable = HerramientasMensajeria.ObtenerCiudadesCallCenter(idUsuario, Nothing, Enumerados.EstadoBinario.Activo)
            Session("dtCiudad") = dtCiudad
            MetodosComunes.CargarComboDX(cmbCiudadEntrega, dtCiudad, "idCiudad", "Ciudad")

            'Carga las campañas
            CargarYEnlazarCampanias()

            'Forma de Pago
            MetodosComunes.CargarComboDX(cmbFormaPago, HerramientasMensajeria.ObtieneMediosDePago(), "idMedio", "nombre")

            'Clausula
            MetodosComunes.CargarComboDX(cmbClausula, HerramientasMensajeria.ConsultaClausula(), "idClausula", "nombre")

            'Regiones
            MetodosComunes.CargarComboDX(cmbRegion, MetodosComunes.getRegiones(True), "idRegion", "nombreCodigo")

            'Jornada
            MetodosComunes.CargarComboDX(cmbJornada, HerramientasMensajeria.ConsultaJornadaMensajeria(), "idJornada", "nombre")

            'Clases de SIMs 
            MetodosComunes.CargarComboDX(cmbClaseSIM, HerramientasMensajeria.ObtieneClasesSIM(), "idClase", "nombre")

            'Fecha Agenda
            With dateFechaAgenda
                Dim fechaInicial As Date = Now.AddDays(0)
                Dim fechaFinal As Date = Now.AddDays(CInt(MetodosComunes.seleccionarConfigValue("MAX_DIAS_AGENDAMIENTO_VENTAS_CEM")))

                'Se valida si existen días no hábiles para aumentar las fechas disponibles.
                Dim objDiasNoHabil As New DiasNoHabilesColeccion()
                With objDiasNoHabil
                    .FechaInicial = fechaInicial
                    .FechaFinal = fechaFinal
                    .Estado = True
                    .CargarDatos()
                    If .Count > 0 Then
                        fechaFinal = fechaFinal.AddDays(.Count)
                        Dim fechas As String = String.Empty
                        For Each dia As DiasNoHabiles In objDiasNoHabil
                            fechas = fechas & dia.Fecha.ToString("yyyyMMdd") & "|"
                        Next
                        hfFechasNoDisponibles.Set("fechas", fechas)
                    Else
                        hfFechasNoDisponibles.Set("fechas", String.Empty)
                    End If
                End With
                '.MinDate = Now.AddDays(-1)
                .MinDate = fechaInicial
                .MaxDate = fechaFinal
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la carga inicial de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer, Optional flag As Integer = 0)
        Dim infoServicio As ServicioMensajeriaVenta
        Try
            infoServicio = New ServicioMensajeriaVenta(idServicio)
            If infoServicio.Registrado Then
                With infoServicio
                    miEncabezado.setTitle("Modificar Servicio: " & .IdServicioMensajeria.ToString)

                    cmbCiudadEntrega.Value = .IdCiudad
                    cmbCompania.Value = .IdCampania

                    'Se cargan los planes a partir de la campaña
                    CargarPlanes(.IdCampania)

                    cmbPlan.Value = .IdPlanVenta
                    txtIdentificacionCLiente.Text = .IdentificacionCliente
                    txtNombresCliente.Text = .NombreCliente
                    txtBarrio.Text = .Barrio

                    'Se carga la dirección
                    asDireccion.value = .Direccion
                    Session("direccion") = .Direccion
                    asDireccion.DireccionEdicion = .DireccionEdicion

                    memoObservacionDireccion.Text = .ObservacionDireccion
                    txtTelefonoMovil.Text = .TelefonoContacto
                    txtTelefonoFijo.Text = .TelefonoFijo
                    cmbFormaPago.Value = CInt(.IdMedioPago)
                    cmbJornada.Value = CInt(.IdJornada)

                    dateFechaAgenda.Date = .FechaAgenda
                    memoObservaciones.Text = .Observacion

                    If flag = 0 Then
                        If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                            'Almacena las referencias actuales
                            Dim dtTempReferencias As DataTable = CrearEstructuraTablaReferencia()
                            For Each referencia As DetalleMaterialServicioMensajeria In .ReferenciasColeccion
                                Dim filaDataRow As DataRow = dtTempReferencias.NewRow()
                                filaDataRow("material") = referencia.Material
                                filaDataRow("referencia") = referencia.DescripcionMaterial
                                filaDataRow("cantidad") = 1
                                dtTempReferencias.Rows.Add(filaDataRow)
                                dtTempReferencias.AcceptChanges()
                                Session("dtReferencia") = dtTempReferencias
                            Next

                            .ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                            .ReferenciasColeccion.CargarDatos()

                            If .ReferenciasColeccion.Count > 0 Then
                                cmbEquipo.Value = .ReferenciasColeccion(0).Material
                            Else
                                cmbEquipo.ValidationSettings.RequiredField.IsRequired = False
                                cmbEquipo.ClientEnabled = False
                                cbRequerido.Checked = False
                            End If

                            _referenciasDataTable = .ReferenciasColeccion.GenerarDataTable()
                            Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                            _referenciasDataTable.PrimaryKey = pkMaterial

                            'Se establece el valor de la clase de sim por defecto
                            .ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.SIM_CARDS
                            .ReferenciasColeccion.CargarDatos()
                            If .ReferenciasColeccion.Count > 0 Then
                                Dim objClaseSIM As New MaterialSIMClaseSIMColeccion()
                                With objClaseSIM
                                    Dim arrMaterial As New ArrayList
                                    arrMaterial.Add(infoServicio.ReferenciasColeccion(0).Material)
                                    .Material = arrMaterial
                                    .CargarDatos()
                                End With
                                If objClaseSIM.Count > 0 Then
                                    cmbClaseSIM.Value = objClaseSIM(0).IdClase
                                End If
                            End If
                        End If
                    End If
                    If .MinsColeccion IsNot Nothing AndAlso .MinsColeccion.Count > 0 Then
                        If .MinsColeccion.Count > 0 Then
                            cmbClausula.Value = CInt(.MinsColeccion(0).IdClausula)
                            cmbRegion.Value = CInt(.MinsColeccion(0).IdRegion)
                        End If
                        _minsDataTable = .MinsColeccion.GenerarDataTable()
                    End If
                    infoServicio = New ServicioMensajeriaVenta(idServicio)
                    Session("infoServicioMensajeria") = infoServicio
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                rpEdidatServicio.Enabled = False
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarPlanes(ByVal idCampania As Integer)
        Try
            'Planes Venta
            Dim lista As New PlanVentaColeccion(idCampania:=cmbCompania.Value)
            Dim dt As DataTable = lista.GenerarDataTable()
            MetodosComunes.CargarComboDX(cmbPlan, dt, "idPlan", "nombre")
            Session("dtListaPlanes") = dt

            If cmbCiudadEntrega.Value IsNot Nothing Then
                CargarEquipos()
                ''Equipos
                'Dim listBodegas As New List(Of Integer)
                'For Each bodega As DataRow In DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)
                '    listBodegas.Add(CInt(bodega("idBodega")))
                'Next

                'Dim objInventarioVenta As New InventarioSateliteVenta()
                'With objInventarioVenta
                '    .IdCampania = New List(Of Integer)(New Integer() {cmbCompania.Value})
                '    .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.HANDSETS})
                '    .IdBodega = listBodegas
                'End With
                'With cmbEquipo
                '    Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
                '    dvDatos.RowFilter = "cantidad > 0"

                '    .SelectedIndex = -1
                '    .DataSource = dvDatos.ToTable()
                '    .DataBind()
                'End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de cargar los planes: " & ex.Message)
        End Try
    End Sub

    Private Sub Actualizar()
        Dim resultado As New ResultadoProceso
        Dim registroValido As Boolean = True
        Try
            Dim dtCiudad As DataTable = Session("dtCiudad")
            Dim drFilaCiudad As DataRow() = dtCiudad.Select("idCiudad=" & cmbCiudadEntrega.Value)
            Dim idBodega As String = drFilaCiudad(0).Item("idBodega").ToString

            If Session("infoServicioMensajeria") IsNot Nothing Then
                Dim infoServicio As ServicioMensajeriaVenta = Session("infoServicioMensajeria")
                Dim infoServicioSim As ServicioMensajeriaVenta = Session("infoServicioMensajeria")

                'Se valida cambio de fecha de agenda
                If infoServicio.FechaAgenda <> dateFechaAgenda.Date Then
                    infoServicio.FechaAgenda = dateFechaAgenda.Date
                    infoServicio.IdJornada = cmbJornada.Value
                    infoServicio.IdTipoServicio = Enumerados.TipoServicio.Venta
                    resultado = infoServicio.ConsultarCapacidad()

                    If resultado.Valor <> 0 Then registroValido = False
                End If

                If registroValido Then
                    With infoServicio
                        .IdCiudad = cmbCiudadEntrega.Value
                        .IdCampania = cmbCompania.Value
                        .IdPlanVenta = cmbPlan.Value
                        .IdentificacionCliente = txtIdentificacionCLiente.Value
                        .NombreCliente = txtNombresCliente.Value
                        .Barrio = txtBarrio.Text
                        .Direccion = asDireccion.value
                        .DireccionEdicion = asDireccion.DireccionEdicion
                        .ObservacionDireccion = memoObservacionDireccion.Text
                        .TelefonoContacto = txtTelefonoMovil.Value
                        .TelefonoFijo = txtTelefonoFijo.Value
                        .IdMedioPago = cmbFormaPago.Value
                        .IdJornada = cmbJornada.Value
                        .FechaAgenda = dateFechaAgenda.Date
                        .Observacion = memoObservaciones.Text

                        'Se realizar la reserva del cupo de entrega
                        infoServicio.RegistrarCupoEntrega()

                        'Se actualiza el MSISDN
                        If infoServicio.MinsColeccion.Count > 0 AndAlso _
                                (infoServicio.MinsColeccion(0).MSISDN <> txtTelefonoMovil.Text _
                                 Or (infoServicio.ReferenciasColeccion.Count > 0 AndAlso infoServicio.ReferenciasColeccion(0).Material <> cmbEquipo.Value) _
                                 Or infoServicio.MinsColeccion(0).IdRegion <> cmbRegion.Value) Then
                            'Si está seleccionado un equipo se realiza el cambio.
                            If cmbEquipo.Value IsNot Nothing Then
                                resultado = ModificarMsisdn()
                            End If
                        End If

                        If resultado.Valor = 0 Then
                            If idBodega = infoServicio.IdBodega Then
                                'Se realiza actualización del Inventario
                                If infoServicio.ReferenciasColeccion IsNot Nothing AndAlso (infoServicio.ReferenciasColeccion.Count > 0 Or cbRequerido.Checked) Then
                                    infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                                    infoServicio.ReferenciasColeccion.CargarDatos()
                                    If infoServicio.ReferenciasColeccion.Count > 0 Then

                                        If cmbEquipo.Value IsNot Nothing AndAlso infoServicio.ReferenciasColeccion(0).Material <> cmbEquipo.Value Then
                                            ' Se valida el material de la Sim Card
                                            Dim colClase As New MaterialEquipoClaseSIMColeccion
                                            Dim arrMateriales As New ArrayList
                                            With colClase
                                                arrMateriales.Add(cmbEquipo.Value)
                                                arrMateriales.Add(infoServicio.ReferenciasColeccion(0).Material)
                                                .Material.AddRange(arrMateriales)
                                                .CargarDatos()
                                            End With

                                            ' Si la clase de sim es diferente, se cambia el material del bloqueo y del detalle.
                                            If colClase.Count = 2 AndAlso colClase(0).IdClase <> colClase(1).IdClase Then
                                                Dim objInventarioVenta As New InventarioSateliteVenta()
                                                Dim materialIccid, idProductoIccid As String
                                                Dim nuevoMaterial As List(Of String)

                                                nuevoMaterial = ServicioMensajeriaVenta.ObtenerMaterialesSIM(cmbEquipo.Value)

                                                If nuevoMaterial.Count > 0 Then
                                                    With objInventarioVenta
                                                        .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.SIM_CARDS})
                                                        .IdBodega = New List(Of Integer)(New Integer() {infoServicio.IdBodega})
                                                        .Material = ServicioMensajeriaVenta.ObtenerMaterialesSIM(cmbEquipo.Value)
                                                        .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})
                                                    End With

                                                    Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
                                                    With dvDatos
                                                        .RowFilter = "cantidad > 0"
                                                        .Sort = "cantidad desc"
                                                    End With
                                                    materialIccid = dvDatos(0).Item("material")
                                                    idProductoIccid = dvDatos(0).Item("idProducto")
                                                    If dvDatos.Count > 0 Then
                                                        If infoServicioSim.ReferenciasColeccion IsNot Nothing AndAlso infoServicioSim.ReferenciasColeccion.Count > 0 Then
                                                            infoServicioSim.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.SIM_CARDS
                                                            infoServicioSim.ReferenciasColeccion.CargarDatos()

                                                            'Se realiza la actualización de las sim asociadas
                                                            Dim objDetalleMaterialSim As New DetalleMaterialServicioMensajeria(infoServicioSim.ReferenciasColeccion(0).IdMaterialServicio)
                                                            With objDetalleMaterialSim
                                                                .Material = materialIccid
                                                                .IdUsuarioRegistra = CInt(Session("usxp001"))
                                                                resultado = .Modificar()
                                                            End With

                                                            If resultado.Valor = 0 Then
                                                                ' Se realiza la libreación de la reserva anterior
                                                                Dim colProductoIccid As New DetalleProductoBloqueoColeccion()
                                                                With colProductoIccid
                                                                    .IdBloqueo = New List(Of Integer)(New Integer() {infoServicioSim.IdReserva})
                                                                    .IdProducto = New List(Of Integer)(New Integer() {infoServicioSim.ReferenciasColeccion(0).IdProducto})
                                                                    .CargarDatos()
                                                                End With

                                                                ' Se adiciona el nuevo bloqueo
                                                                Dim objBloqueoIccid As New BloqueoInventario(idBloqueo:=infoServicioSim.IdReserva)
                                                                resultado = objBloqueoIccid.DesbloquearProducto(colProductoIccid)
                                                                If resultado.Valor = 0 Then
                                                                    Dim detalleProducto As New DetalleProductoBloqueo()
                                                                    With detalleProducto
                                                                        .IdProducto = idProductoIccid
                                                                        .Material = materialIccid
                                                                        .Cantidad = 1
                                                                    End With
                                                                    objBloqueoIccid.ProductoBloqueoColeccion.Adicionar(detalleProducto)
                                                                    resultado = objBloqueoIccid.Registrar()
                                                                Else
                                                                    miEncabezado.showError(resultado.Mensaje)
                                                                    Exit Sub
                                                                End If
                                                            Else
                                                                miEncabezado.showError(resultado.Mensaje)
                                                                Exit Sub
                                                            End If
                                                        Else
                                                            miEncabezado.showWarning("Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
                                                            Exit Sub
                                                        End If
                                                    Else
                                                        miEncabezado.showWarning("No se puede realizar la actualización del equipo, no se encontraron materiales de Sim Card disponibles para el equipo seleccionado")
                                                        Exit Sub
                                                    End If
                                                Else
                                                    miEncabezado.showWarning("No se puede realizar la actualización del equipo, no se encontraron materiales de Sim Card disponibles para el equipo seleccionado")
                                                    Exit Sub
                                                End If
                                            End If

                                            ' Si el resultado del registro de la sim es exitoso, se procede con el desbloqueo y registro de los teléfonos
                                            If resultado.Valor = 0 Then
                                                'Se realiza la actualización de las equipos asociados
                                                infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                                                infoServicio.ReferenciasColeccion.CargarDatos()
                                                Dim objDetalleMaterial As New DetalleMaterialServicioMensajeria(infoServicio.ReferenciasColeccion(0).IdMaterialServicio)
                                                With objDetalleMaterial
                                                    .Material = cmbEquipo.Value
                                                    .IdUsuarioRegistra = CInt(Session("usxp001"))
                                                    resultado = .Modificar()
                                                End With
                                                If resultado.Valor = 0 Then
                                                    ' Se realiza la libreación de la reserva anterior
                                                    Dim colProducto As New DetalleProductoBloqueoColeccion()
                                                    With colProducto
                                                        .IdBloqueo = New List(Of Integer)(New Integer() {infoServicio.IdReserva})
                                                        .IdProducto = New List(Of Integer)(New Integer() {infoServicio.ReferenciasColeccion(0).IdProducto})
                                                        .CargarDatos()
                                                    End With

                                                    ' Se adiciona el nuevo bloqueo
                                                    Dim objBloqueo As New BloqueoInventario(idBloqueo:=infoServicio.IdReserva)
                                                    resultado = objBloqueo.DesbloquearProducto(colProducto)
                                                    If resultado.Valor = 0 Then
                                                        Dim detalleProducto As New DetalleProductoBloqueo()
                                                        With detalleProducto
                                                            .IdProducto = (New MaterialColeccion(cmbEquipo.Value))(0).IdProductoPadre
                                                            .Material = cmbEquipo.Value
                                                            .Cantidad = 1
                                                        End With

                                                        objBloqueo.ProductoBloqueoColeccion.Adicionar(detalleProducto)
                                                        resultado = objBloqueo.Registrar()
                                                    Else
                                                        miEncabezado.showError(resultado.Mensaje)
                                                        Exit Sub
                                                    End If
                                                Else
                                                    miEncabezado.showError(resultado.Mensaje)
                                                    Exit Sub
                                                End If
                                            Else
                                                miEncabezado.showError(resultado.Mensaje)
                                                Exit Sub
                                            End If
                                        ElseIf IsNothing(cmbEquipo.Value) Then
                                            resultado = DesvincularEquipo(infoServicio)
                                        End If
                                    Else
                                        If cmbEquipo.Value IsNot Nothing Then
                                            resultado = RegistrarEquipo(infoServicio)
                                        End If
                                    End If
                                End If
                            Else
                                resultado = LiberarBloqueosPorCamibioBodega(idBodega)
                            End If
                        End If

                        If resultado.Valor = 0 Then
                            .IdReserva = infoServicio.IdReserva
                            resultado = .Actualizar(CInt(Session("usxp001")))
                            If resultado.Valor = 0 Then
                                miEncabezado.showSuccess("Se realizó la actualización satisfactoriamente. ")
                            Else
                                miEncabezado.showError(resultado.Mensaje)
                            End If
                        Else
                            miEncabezado.showError(resultado.Mensaje)
                        End If
                    End With
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                End If
            Else
                miEncabezado.showWarning("Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de actualizar el registro: " & ex.Message)
        End Try
    End Sub

    Private Function RegistrarEquipo(ByRef infoServicio As ServicioMensajeriaVenta) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim dtReferencia As DataTable
        Try
            If infoServicio IsNot Nothing Then
                If dtReferencia Is Nothing Then dtReferencia = CrearEstructuraTablaReferencia()

                If cmbEquipo.Value IsNot Nothing Then
                    'Dim filaDataRow As DataRow = dtReferencia.NewRow()
                    'filaDataRow("material") = CStr(cmbEquipo.Value)
                    'filaDataRow("referencia") = cmbEquipo.Text
                    'filaDataRow("cantidad") = 1

                    'dtReferencia.Rows.Add(filaDataRow)
                    'dtReferencia.AcceptChanges()
                    'infoServicio.ReferenciasDataTable = dtReferencia
                    'Session("dtReferencia") = dtReferencia

                    'Se realiza el bloqueo del nuevo material
                    Dim objProductoNuevo As New DetalleProductoBloqueo()
                    With objProductoNuevo
                        .IdBloqueo = infoServicio.IdReserva
                        .IdProducto = (New MaterialColeccion(cmbEquipo.Value))(0).IdProductoPadre
                        .Material = cmbEquipo.Value
                        .Cantidad = 1
                    End With
                    Dim objBloqueo As New BloqueoInventario(infoServicio.IdReserva)
                    With objBloqueo
                        .ProductoBloqueoColeccion.Adicionar(objProductoNuevo)
                        resultado = .Registrar()
                    End With

                    'Se realaciona el material al servicio
                    If resultado.Valor = 0 Then
                        Dim objDetalleReferencia As New DetalleMaterialServicioMensajeria()
                        With objDetalleReferencia
                            .IdServicio = infoServicio.IdServicioMensajeria
                            .Material = cmbEquipo.Value
                            .Cantidad = 1
                            .IdUsuarioRegistra = CInt(Session("usxp001"))
                            resultado = .Adicionar()
                        End With

                        If resultado.Valor = 0 Then
                            resultado.EstablecerMensajeYValor(0, "Equipo adicionado correctamente.")
                        End If
                    End If
                Else
                    resultado.EstablecerMensajeYValor(1, "No se logro registrar el equipo.")
                End If
            Else
                resultado.EstablecerMensajeYValor(2, "Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar registrar el equipo: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Function ModificarMsisdn() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            If Session("infoServicioMensajeria") IsNot Nothing Then
                Dim infoServicio As ServicioMensajeriaVenta = Session("infoServicioMensajeria")
                Dim objMaterialVenta As New MaterialEnPlanVentaColeccion(cmbEquipo.Value, cmbPlan.Value)
                Dim objDetalleMsisdn As New DetalleMsisdnEnServicioMensajeriaTipoVenta(infoServicio.MinsColeccion(0).IdRegistro)

                With objDetalleMsisdn
                    .MSISDN = CLng(txtTelefonoMovil.Text.Trim)
                    .IdClausula = CInt(cmbClausula.Value)
                    .PrecioSinIva = objMaterialVenta(0).PrecioVentaEquipo
                    .PrecioConIva = objMaterialVenta(0).PrecioVentaEquipo + objMaterialVenta(0).IvaEquipo
                    .IdRegion = CInt(cmbRegion.Value)
                    resultado = .Modificar()
                End With
                If resultado.Valor = 0 Then
                    resultado.EstablecerMensajeYValor(0, "Se realizó la actualización exitosamente.")
                End If
            Else
                miEncabezado.showWarning("Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(1, ex.Message)
        End Try
        Return resultado
    End Function

    Private Function ConsultarCapacidadEntrega() As ResultadoProceso
        Dim resultado As ResultadoProceso
        Dim objServicio As New ServicioMensajeria
        Dim arrFechas As New ArrayList

        Try
            If Session("infoServicioMensajeria") IsNot Nothing Then
                With objServicio
                    .IdBodega = DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")
                    .FechaAgenda = dateFechaAgenda.Date
                    .IdJornada = CShort(cmbJornada.Value)
                    arrFechas.Add(.IdBodega)
                    arrFechas.Add(.FechaAgenda)
                    arrFechas.Add(.IdJornada)
                    .IdTipoServicio = Enumerados.TipoServicio.Venta
                End With
                resultado = objServicio.ConsultarCapacidad()
                If resultado.Valor = 0 Then
                    btnActualizar.ClientEnabled = True
                    resultado = objServicio.RegistrarCupoEntrega()
                    If resultado.Valor = 0 Then
                        If Session("fechas") Is Nothing Then
                            objServicio.FechaAgenda = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).FechaAgenda
                            objServicio.IdBodega = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).IdBodega
                            objServicio.IdJornada = DirectCast(Session("infoServicioMensajeria"), ServicioMensajeria).IdJornada
                            resultado = objServicio.LiberarCupoEntrega()
                        Else
                            Dim arrFechasCambio As ArrayList = Session("Fechas")
                            objServicio.FechaAgenda = arrFechasCambio(1).ToString
                            objServicio.IdBodega = arrFechasCambio(0).ToString
                            objServicio.IdJornada = arrFechasCambio(2).ToString
                            resultado = objServicio.LiberarCupoEntrega()
                        End If
                        Session("Fechas") = arrFechas
                    End If
                End If
            Else
                resultado.EstablecerMensajeYValor(100, "Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(200, ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub ValidarCambioBodega()
        Try
            If Session("infoServicioMensajeria") IsNot Nothing AndAlso Session("dtCiudad") IsNot Nothing Then
                Dim infoServicio As ServicioMensajeriaVenta = Session("infoServicioMensajeria")
                Dim dtCiudad = Session("dtCiudad")
                Dim drl As DataRow() = dtCiudad.Select("idCiudad=" & cmbCiudadEntrega.Value)
                Dim idBodega As String = drl(0).Item("idBodega").ToString

                If idBodega <> infoServicio.IdBodega Then
                    Dim idUsuario As Integer = 0
                    If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
                    'Carga las campañas
                    cmbCompania.Value = Nothing
                    MetodosComunes.CargarComboDX(cmbCompania, HerramientasMensajeria.ObtieneCampaniasDisponiblesUsuario(idUsuario), "idCampania", "nombre")
                    cmbPlan.Value = Nothing
                    cmbEquipo.Value = Nothing
                End If

            Else
                miEncabezado.showWarning("Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
            End If
        Catch ex As Exception
            miEncabezado.showWarning("Se presento un error al validar el cambio de bodega. " & ex.Message)
        End Try
    End Sub

    Private Function LiberarBloqueosPorCamibioBodega(ByVal idBodega As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            If Session("infoServicioMensajeria") IsNot Nothing Then
                Dim infoServicio As ServicioMensajeriaVenta = Session("infoServicioMensajeria")

                ' Se adiciona el obtiene el material de la sim 
                Dim objInventarioVenta As New InventarioSateliteVenta()
                Dim materialIccid, idProductoIccid As String
                Dim nuevoMaterial As List(Of String)

                nuevoMaterial = ServicioMensajeriaVenta.ObtenerMaterialesSIM(cmbEquipo.Value)

                If nuevoMaterial.Count > 0 Then

                    ' Se realiza la libreación de la reserva anterior
                    infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                    infoServicio.ReferenciasColeccion.CargarDatos()
                    Dim colProducto As New DetalleProductoBloqueoColeccion()
                    With colProducto
                        .IdBloqueo = New List(Of Integer)(New Integer() {infoServicio.IdReserva})
                        .IdProducto = New List(Of Integer)(New Integer() {infoServicio.ReferenciasColeccion(0).IdProducto})
                        .CargarDatos()
                    End With

                    ' Se adiciona el nuevo bloqueo télefono
                    Dim objBloqueo As New BloqueoInventario(idBloqueo:=infoServicio.IdReserva)
                    resultado = objBloqueo.DesbloquearProducto(colProducto)

                    If resultado.Valor = 0 Then
                        Dim detalleProducto As New DetalleProductoBloqueo()
                        With detalleProducto
                            .IdProducto = (New MaterialColeccion(cmbEquipo.Value))(0).IdProductoPadre
                            .Material = cmbEquipo.Value
                            .Cantidad = 1
                        End With

                        objBloqueo.ProductoBloqueoColeccion.Adicionar(detalleProducto)
                        objBloqueo.IdBodega = idBodega
                        resultado = objBloqueo.Registrar()

                        If resultado.Valor = 0 Then
                            With objInventarioVenta
                                .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.SIM_CARDS})
                                .IdBodega = New List(Of Integer)(New Integer() {idBodega})
                                .Material = ServicioMensajeriaVenta.ObtenerMaterialesSIM(cmbEquipo.Value)
                                .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})
                            End With

                            Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
                            With dvDatos
                                .RowFilter = "cantidad > 0"
                                .Sort = "cantidad desc"
                            End With
                            materialIccid = dvDatos(0).Item("material")
                            idProductoIccid = dvDatos(0).Item("idProducto")

                            If dvDatos.Count > 0 Then

                                ' Se realiza la libreación de la reserva anterior
                                infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.SIM_CARDS
                                infoServicio.ReferenciasColeccion.CargarDatos()
                                Dim colProductoIccid As New DetalleProductoBloqueoColeccion()
                                With colProductoIccid
                                    .IdBloqueo = New List(Of Integer)(New Integer() {infoServicio.IdReserva})
                                    .IdProducto = New List(Of Integer)(New Integer() {infoServicio.ReferenciasColeccion(0).IdProducto})
                                    .CargarDatos()
                                End With
                                ' Se adiciona el nuevo bloqueo de la Sim

                                Dim objBloqueoIccid As New BloqueoInventario(idBloqueo:=infoServicio.IdReserva)
                                resultado = objBloqueoIccid.DesbloquearProducto(colProductoIccid)
                                With detalleProducto
                                    .IdProducto = idProductoIccid
                                    .Material = materialIccid
                                    .Cantidad = 1
                                End With
                                objBloqueoIccid.ProductoBloqueoColeccion.Adicionar(detalleProducto)
                                objBloqueoIccid.IdBodega = idBodega
                                resultado = objBloqueoIccid.Registrar()
                            Else
                                resultado.EstablecerMensajeYValor(1, "No se pudo determinar cantidades disponibles para la Sim. ")
                                Return resultado
                                Exit Function
                            End If
                            If resultado.Valor = 0 Then
                                'Se cambia la bodega de la reserva
                                With objBloqueo
                                    .IdBodega = idBodega
                                    resultado = .Actualizar()
                                End With

                                ' Se actualiza las referencias del servicio
                                ' Télefonos
                                infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                                infoServicio.ReferenciasColeccion.CargarDatos()
                                Dim objDetalleMaterial As New DetalleMaterialServicioMensajeria(infoServicio.ReferenciasColeccion(0).IdMaterialServicio)
                                With objDetalleMaterial
                                    .Material = cmbEquipo.Value
                                    .IdUsuarioRegistra = CInt(Session("usxp001"))
                                    resultado = .Modificar()
                                End With

                                'Sim
                                infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.SIM_CARDS
                                infoServicio.ReferenciasColeccion.CargarDatos()
                                Dim objDetalleMaterialIccd As New DetalleMaterialServicioMensajeria(infoServicio.ReferenciasColeccion(0).IdMaterialServicio)
                                With objDetalleMaterialIccd
                                    .Material = materialIccid
                                    .IdUsuarioRegistra = CInt(Session("usxp001"))
                                    resultado = .Modificar()
                                End With
                            Else
                                Return resultado
                                Exit Function
                            End If
                        Else
                            Return resultado
                            Exit Function
                        End If
                    Else
                        Return resultado
                        Exit Function
                    End If
                Else
                    miEncabezado.showError("No se puede realizar la actualización del equipo, no se encontraron materiales de Sim Card disponibles para el equipo seleccionado")
                End If
            Else
                miEncabezado.showWarning("Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al Liberar los bloqueos por cambio de bodega. " & ex.Message)
        End Try
        Return resultado
    End Function

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

    Private Sub CargarEquipos()
        Try
            'Se filtra la información de los equipos
            Dim objInventarioVenta As New InventarioSateliteVenta()
            With objInventarioVenta
                .IdCampania = New List(Of Integer)(New Integer() {cmbCompania.Value})
                .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.HANDSETS})
                .IdPlanVenta = New List(Of Integer)(New Integer() {cmbPlan.Value})
                .IdBodega = New List(Of Integer)(New Integer() {DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")})
                .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})
            End With

            Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
            dvDatos.RowFilter = "cantidad >= 0"
            With cmbEquipo
                .SelectedIndex = -1
                .DataSource = dvDatos.ToTable()
                .DataBind()
                .ClientEnabled = True
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de seleccionar el plan: " & ex.Message)
        End Try
    End Sub

    Private Function CrearEstructuraTablaReferencia() As DataTable
        Dim dtReferencia As New DataTable
        If Session("dtReferencia") IsNot Nothing Then
            dtReferencia = Session("dtReferencia")
        Else
            With dtReferencia
                .Columns.Add("material", GetType(String))
                .Columns.Add("referencia", GetType(String))
                .Columns.Add("cantidad", GetType(Integer))
                .AcceptChanges()
            End With
            Dim pkMaterial() As DataColumn = {dtReferencia.Columns("material")}
            dtReferencia.PrimaryKey = pkMaterial
        End If
        Return dtReferencia
    End Function

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

    Private Sub ObtenerValorEquipo()
        Try
            Dim objMaterialVenta As New MaterialEnPlanVentaColeccion(cmbEquipo.Value, cmbPlan.Value)
            If objMaterialVenta.Count > 0 Then
                Dim sbTextoValor As New StringBuilder()
                With sbTextoValor
                    .Append("Valor equipo: [")
                    .Append(objMaterialVenta(0).PrecioVentaEquipo.ToString("c", New Globalization.CultureInfo("es-CO", True)))
                    .Append("], IVA: [")
                    .Append(objMaterialVenta(0).IvaEquipo.ToString("c", New Globalization.CultureInfo("es-CO", True)))
                    .Append("], Total:[")
                    .Append((objMaterialVenta(0).PrecioVentaEquipo + objMaterialVenta(0).IvaEquipo).ToString("c", New Globalization.CultureInfo("es-CO", True)))
                    .Append("]")
                End With
                lblValorEquipo.Text = sbTextoValor.ToString()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtener el valor del equipo: " & ex.Message)
        End Try
    End Sub

    Private Function DesvincularEquipo(ByRef infoServicio As ServicioMensajeriaVenta) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            If infoServicio.ReferenciasColeccion IsNot Nothing AndAlso infoServicio.ReferenciasColeccion.Count > 0 Then
                infoServicio.ReferenciasColeccion.IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                infoServicio.ReferenciasColeccion.CargarDatos()
                If infoServicio.ReferenciasColeccion.Count > 0 Then
                    'Se obtiene el valor de la referencia a desvincular
                    Dim objDetalleBloqueo As New DetalleProductoBloqueoColeccion()
                    With objDetalleBloqueo
                        .IdBloqueo = New List(Of Integer)(New Integer() {infoServicio.IdReserva})
                        .IdProducto = New List(Of Integer)(New Integer() {infoServicio.ReferenciasColeccion(0).IdProducto})
                        .CargarDatos()
                    End With

                    'Se desvincula la referencia
                    resultado = infoServicio.ReferenciasColeccion(0).Eliminar(CInt(Session("usxp001")))

                    'Se libera el bloqueo
                    If resultado.Valor = 0 Then
                        'Se descuenta el valor del equipo a la linea
                        Dim objMaterialPlan As New MaterialEnPlanVentaColeccion(infoServicio.ReferenciasColeccion(0).Material, infoServicio.IdPlanVenta)
                        If infoServicio.MinsColeccion.Count > 0 And objMaterialPlan.Count > 0 Then
                            With infoServicio.MinsColeccion(0)
                                .PrecioConIva = .PrecioConIva - (objMaterialPlan(0).PrecioVentaEquipo + objMaterialPlan(0).IvaEquipo)
                                .PrecioSinIva = .PrecioSinIva - objMaterialPlan(0).PrecioVentaEquipo
                                .Modificar()
                            End With
                        End If
                        infoServicio.ReferenciasColeccion.Remover(infoServicio.ReferenciasColeccion(0))

                        Dim objBloqueo As New BloqueoInventario(idBloqueo:=infoServicio.IdReserva)
                        resultado = objBloqueo.DesbloquearProducto(objDetalleBloqueo)
                    End If
                End If
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(100, ex.Message)
        End Try
        Return resultado
    End Function

    Public Function ValidarMsisdn() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        If Session("infoServicioMensajeria") IsNot Nothing Then
            Dim infoServicio As ServicioMensajeriaVenta = Session("infoServicioMensajeria")
            With infoServicio
                .IdServicioMensajeria = infoServicio.IdServicioMensajeria
                .IdCampania = cmbCompania.Value
                .TelefonoMovil = txtTelefonoMovil.Text.Trim
                resultado = .VerificarMsisdn()
            End With
        Else
            miEncabezado.showWarning("Imposible recuperar la información del servicio, por favor intentelo de nuevo.")
        End If

        Return resultado
    End Function

#End Region

    Private Sub CargarYEnlazarCampanias()
        
        Dim dt As DataTable

        If Session("dtCampaniasVenta") Is Nothing Then
            Dim idUsuario As Integer = 0
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            dt = HerramientasMensajeria.ObtieneCampaniasDisponiblesUsuario(idUsuario)
            Session("dtCampaniasVenta") = dt
        Else
            dt = CType(Session("dtCampaniasVenta"), DataTable)
        End If
        MetodosComunes.CargarComboDX(cmbCompania, dt, "idCampania", "nombre")

    End Sub

End Class