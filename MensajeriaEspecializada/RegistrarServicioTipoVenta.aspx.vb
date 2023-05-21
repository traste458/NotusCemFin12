Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports System.Text

Public Class RegistrarServicioTipoVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Registro Servicio Tipo Venta")

                Session.Remove("FechasCupoEntrega")

                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()

                CargaInicial()
            End With

        End If
    End Sub

    Private Sub btnGuardar_Click(sender As Object, e As System.EventArgs) Handles btnGuardar.Click
        Dim resultado As New ResultadoProceso
        resultado = ValidarMsisdn()
        If resultado.Valor = 0 Then
            RegistrarServicio()
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If

    End Sub

    Private Sub cmbPlan_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbPlan.Callback
        Try
            'Planes Venta 
            MetodosComunes.CargarComboDX(cmbPlan, New PlanVentaColeccion(idCampania:=cmbCompania.Value).GenerarDataTable(), "idPlan", "nombrePlan")

            'Establecer tooltip
            Dim dv As DataView = CType(DirectCast(cmbPlan.DataSource, DataTable).DefaultView, DataView)
            For Each row As DataRowView In dv
                row("descripcion") = String.Format("<span title = ""{0}""> {1} </span>", row("descripcion"), row("descripcion"))
            Next row
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        Try
            ObtenerValorEquipo()
            CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            e.Result = ASPxCallback.GetRenderResult(lblValorEquipo)
        Catch : End Try
    End Sub

    Private Sub cbCuposEntrega_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbCuposEntrega.Callback
        Dim respuesta As New ResultadoProceso
        Try
            respuesta = ConsultarCapacidadEntrega()
            If respuesta.Valor <> 0 Then
                miEncabezado.showWarning(respuesta.Mensaje)
                dateFechaAgenda.Date = Nothing
            End If
            CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()

            Dim sb As New System.Text.StringBuilder
            Dim hw As New System.Web.UI.HtmlTextWriter(New System.IO.StringWriter(sb))
            dateFechaAgenda.RenderControl(hw)
            CType(source, ASPxCallback).JSProperties("cpControlAgenda") = sb.ToString()
        Catch : End Try
    End Sub

    Private Sub cmbEquipo_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbEquipo.Callback
        If cmbCiudadEntrega.Value IsNot Nothing And cmbPlan.Value IsNot Nothing Then
            'Equipos
            Dim listBodegas As New List(Of Integer)
            For Each bodega As DataRow In DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)
                listBodegas.Add(CInt(bodega("idBodega")))
            Next

            Dim objInventarioVenta As New InventarioSateliteVenta()
            With objInventarioVenta
                .IdCampania = New List(Of Integer)(New Integer() {cmbCompania.Value})
                .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.HANDSETS})
                .IdBodega = listBodegas
                .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})
                If cmbPlan.Value IsNot Nothing Then .IdPlanVenta = New List(Of Integer)(New Integer() {cmbPlan.Value})
            End With

            Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView

            With cmbEquipo
                '20130331: Modificación para visualizar los equipos sin inventario
                dvDatos.RowFilter = "cantidad >= 0"
                .SelectedIndex = -1
                .DataSource = dvDatos.ToTable()
                .DataBind()
            End With
            '***Modificación realizada por José Vélez***
            'Se verifica si el check de requerido está marcado y de ser así, 
            'se le informa al usuario que no hay equipos configurados para la combinación Campaña/Plan seleccionados
            If cbRequerido.Checked AndAlso Not EsNuloOVacio(cmbCompania.Value) AndAlso Not EsNuloOVacio(cmbPlan.Value) Then
                If dvDatos.Count = 0 Then miEncabezado.showWarning("No existen equipos configurados para el Plan seleccionado. Por favor verifique")
            End If
        End If
        CType(sender, ASPxComboBox).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub cmbEquipo_ValueChanged(sender As Object, e As System.EventArgs) Handles cmbEquipo.ValueChanged
        'ObtenerValorEquipo()
    End Sub

    Protected Sub btnAutorizar_Click(sender As Object, e As EventArgs) Handles btnAutorizar.Click
        Try
            Dim objUsuario As New Usuario(txtUsuarioAdmin.Text.Trim, txtClaveAdmin.Text.Trim)
            If objUsuario.IdPerfil > 0 Then
                Dim dvPermiso As DataView = CType(Session("dtInfoPermisosOpcRestringidas"), DataTable).Copy().DefaultView
                dvPermiso.RowFilter = "nombreControl = 'cbRequerido'"

                If dvPermiso.Count > 0 Then
                    dvPermiso.RowFilter += " and idPerfil = " & objUsuario.IdPerfil.ToString
                    If dvPermiso.Count > 0 Then
                        cmbEquipo.ValidationSettings.RequiredField.IsRequired = False
                        cmbEquipo.Text = String.Empty
                        cmbEquipo.SelectedIndex = -1
                        miEncabezado.showSuccess("Las credenciales se establecieron correctamente, por favor registre el servicio.")
                    Else
                        cbRequerido.Checked = True
                        miEncabezado.showWarning("Las credenciales ingresadas no corresponden a un perfil autorizado para realizar la acción.")
                    End If
                End If
            Else
                miEncabezado.showWarning("Las credenciales no son válidas, por favor intente nuevamente.")
            End If
            pcAutorizar.ShowOnPageLoad = False
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar realizar la autorización: " & ex.Message)
        End Try
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
            MetodosComunes.CargarComboDX(cmbCompania, HerramientasMensajeria.ObtieneCampaniasDisponiblesUsuario(idUsuario), "idCampania", "nombre")

            'Forma de Pago
            MetodosComunes.CargarComboDX(cmbFormaPago, HerramientasMensajeria.ObtieneMediosDePago(), "idMedio", "nombre")

            'Clausula
            MetodosComunes.CargarComboDX(cmbClausula, HerramientasMensajeria.ConsultaClausula(), "idClausula", "nombre")

            'Regiones
            Dim dvRegion As DataView = MetodosComunes.getRegiones(True).DefaultView
            dvRegion.RowFilter = "nombreCodigo <> 'DOM'"

            MetodosComunes.CargarComboDX(cmbRegion, dvRegion.ToTable(), "idRegion", "nombreCodigo")

            'Jornada
            MetodosComunes.CargarComboDX(cmbJornada, HerramientasMensajeria.ConsultaJornadaMensajeria(), "idJornada", "nombre")

            'Fecha Agenda
            With dateFechaAgenda
                Dim fechaInicial As Date = Now.AddDays(0)
                Dim fechaFinal As Date = Now.AddDays(CInt(MetodosComunes.seleccionarConfigValue("MAX_DIAS_AGENDAMIENTO_VENTAS_CEM")))

                'Se valida si existen días no hábiles para aumentar las fechas disponibles.
                Dim objDiasNoHabil As New DiasNoHabilesColeccion()
                With objDiasNoHabil
                    .FechaInicial = fechaInicial
                    .FechaFinal = fechaFinal
                    AsignarFechaFinal(.FechaFinal)
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
                .MinDate = fechaInicial
                .MaxDate = fechaFinal
            End With

            'Clases de SIMs 
            MetodosComunes.CargarComboDX(cmbClaseSIM, HerramientasMensajeria.ObtieneClasesSIM(), "idClase", "nombre")
            cbRequerido.Checked = True

            'Se valida si debe exigir autorización para no registrar equipos            
            'Dim ctrl As Control = rpRegistros.FindControl("cbRequerido")
            'If ctrl IsNot Nothing Then
            '    ctrl.Visible = Not EsVisibleOpcionRestringida(ctrl.ID, Nothing)
            '    If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, Nothing)
            '    cmbEquipo.ValidationSettings.RequiredField.IsRequired = ctrl.Visible
            'End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la carga inicial de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarServicio()
        Try
            miEncabezado.clear()
            Dim objServicioMensajeriaVenta As New ServicioMensajeriaVenta()
            With objServicioMensajeriaVenta
                .IdUsuario = CInt(Session("usxp001"))
                .FechaAgenda = dateFechaAgenda.Date
                .IdJornada = cmbJornada.SelectedItem.Value
                .IdEstado = Enumerados.EstadoServicio.Preventa
                .NombreCliente = txtNombresCliente.Text
                .IdentificacionCliente = txtIdentificacionCliente.Text
                .IdCiudad = CInt(cmbCiudadEntrega.SelectedItem.Value)
                .Barrio = txtBarrio.Text
                .Direccion = asDireccion.value
                .TelefonoContacto = txtTelefonoMovil.Text
                .Observacion = memoObservaciones.Text
                .IdCampania = cmbCompania.SelectedItem.Value
                .IdPlanVenta = cmbPlan.Value
                .DireccionEdicion = asDireccion.DireccionEdicion
                .ObservacionDireccion = memoObservacionDireccion.Text
                .TelefonoFijo = txtTelefonoFijo.Text
                .IdMedioPago = cmbFormaPago.SelectedItem.Value

                Session.Remove("dtReferencia")

                .ReferenciasDataTable = ServicioMensajeriaVenta.AgregarReferencia(cmbEquipo.Value, cmbEquipo.Text)
                .MinsDataTable = ServicioMensajeriaVenta.AgregarMINs(cmbEquipo.Value, cmbPlan.Value, txtTelefonoMovil.Text, cmbClausula.Value, cmbClausula.Text, cmbRegion.Value, cbRequerido.Checked)

                .DetalleBloqueoInventario = AdicionarEquipoVenta()

                'Se adiciona el material de la SIM si no se ha manejado equipo
                If Session("dtReferencia") IsNot Nothing AndAlso DirectCast(Session("dtReferencia"), DataTable).Rows.Count > .ReferenciasDataTable.Rows.Count Then
                    .ReferenciasDataTable = DirectCast(Session("dtReferencia"), DataTable)
                End If

                Dim respuesta As ResultadoProceso = .Registrar()
                If respuesta.Valor = 0 Then
                    miEncabezado.showSuccess("Servicio creado correctamente con el identificador No. " & .IdServicioMensajeria)
                    LimpiarFormulario()
                Else
                    miEncabezado.showWarning("Servicio no creado: " & respuesta.Mensaje)
                End If
            End With

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de registrar el servicio: " & ex.Message)
            Session.Remove("dtReferencia")
        End Try
    End Sub

    Private Function AdicionarEquipoVenta() As BloqueoInventario
        Dim objBloqueoInventario As New BloqueoInventario()
        Dim idBloqueo As Integer = 0
        Try
            'Reserva del Equipo
            Dim detalleProductoEquipo As New DetalleProductoBloqueo()
            If cmbEquipo.Value IsNot Nothing Then
                With detalleProductoEquipo
                    .IdProducto = (New MaterialColeccion(cmbEquipo.Value))(0).IdProductoPadre
                    .Material = cmbEquipo.Value
                    .Cantidad = 1
                End With
            End If

            'Reserva de la SIM
            Dim detalleProductoSIM As DetalleProductoBloqueo
            Dim objInventarioVenta As New InventarioSateliteVenta()
            With objInventarioVenta
                .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.SIM_CARDS})
                .IdBodega = New List(Of Integer)(New Integer() {DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")})
                If cmbEquipo.Value IsNot Nothing Then
                    .Material = ServicioMensajeriaVenta.ObtenerMaterialesSIM(materialEquipo:=cmbEquipo.Value)
                    If .Material.Count <= 0 Then
                        Throw New Exception("No se encontró configuración de SIM para el material [" & cmbEquipo.Text & "] disponibles, por favor contacte al personal administrativo del CEM.")
                        Exit Function
                    End If
                Else
                    .Material = ServicioMensajeriaVenta.ObtenerMaterialesSIM(idClaseSIM:=cmbClaseSIM.Value)
                    If .Material.Count <= 0 Then
                        Throw New Exception("No existen materiales de SIM clase [" & cmbClaseSIM.Text & "] disponibles.")
                        Exit Function
                    End If
                End If
                .IdEstado = New List(Of Short)(New Short() {Enumerados.EstadoInventario.LibreUtilizacion})

                Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
                With dvDatos
                    .RowFilter = "cantidad > 0"
                    .Sort = "cantidad desc"
                End With

                If dvDatos.Count > 0 Then
                    detalleProductoSIM = New DetalleProductoBloqueo()
                    With detalleProductoSIM
                        .IdProducto = dvDatos(0).Item("idProducto")
                        .Material = dvDatos(0).Item("material")
                        .Cantidad = 1
                    End With

                    'Se adiciona la referencia al servicio
                    Dim dtReferencia As DataTable = ServicioMensajeriaVenta.CrearEstructuraTablaReferencia()
                    If Not dtReferencia.Rows.Contains(dvDatos(0).Item("material")) Then
                        Dim filaDataRow As DataRow = dtReferencia.NewRow()
                        filaDataRow("material") = dvDatos(0).Item("material")
                        filaDataRow("referencia") = (New MaterialColeccion(dvDatos(0).Item("material")))(0).Referencia
                        filaDataRow("cantidad") = 1
                        dtReferencia.Rows.Add(filaDataRow)
                        dtReferencia.AcceptChanges()
                        Session("dtReferencia") = dtReferencia

                        'Se adiciona el valor de la SIM al valor del equipo
                        Dim objMaterialSim As New MaterialSIMClaseSIMColeccion()
                        With objMaterialSim
                            Dim arrMaterial As New ArrayList
                            arrMaterial.Add(dvDatos(0).Item("material"))
                            .Material = arrMaterial
                            .CargarDatos()
                        End With

                        If objMaterialSim.Count > 0 Then
                            Dim dtMsisdn As DataTable = ServicioMensajeriaVenta.CrearEstructuraTablaMsisdn()
                            If dtMsisdn.Rows.Count > 0 Then
                                dtMsisdn.Rows(0).Item("precioConIVA") = dtMsisdn.Rows(0).Item("precioConIVA") + (objMaterialSim(0).PrecioNormal * (1 + objMaterialSim(0).Iva))
                                dtMsisdn.Rows(0).Item("precioSinIVA") = dtMsisdn.Rows(0).Item("precioSinIVA") + objMaterialSim(0).PrecioNormal
                            End If
                            dtMsisdn.AcceptChanges()
                        End If
                    End If
                Else
                    Throw New Exception("No existen materiales de SIM disponibles para el Equipo/Clase SIM seleccionada.")
                    Exit Function
                End If
            End With

            With objBloqueoInventario
                .IdBodega = DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")
                .FechaRegistro = Nothing
                .IdUsuario = CInt(Session("usxp001"))
                .IdEstado = Enumerados.InventarioBloqueo.Confirmado
                .FechaInicio = Now()
                .FechaFin = Nothing
                .IdUnidadNegocio = Enumerados.UnidadNegocio.MensajeriaEspecializada
                .IdDestinatario = Nothing
                .IdTipoBloqueo = Enumerados.TipoBloqueo.ReservadeInventario
                .Observacion = "Bloqueo generado por Ventas Telefónicas CEM"

                If detalleProductoEquipo.IdProducto > 0 Then .ProductoBloqueoColeccion.Adicionar(detalleProductoEquipo)
                .ProductoBloqueoColeccion.Adicionar(detalleProductoSIM)
            End With
        Catch ex As Exception
            miEncabezado.showError("No se logró realizar la reserva de inventario: " & ex.Message)
        End Try
        Return objBloqueoInventario
    End Function

    Private Function ConsultarCapacidadEntrega() As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Dim objServicio As New ServicioMensajeria
        Dim agendaRestringida As Boolean = True
        Dim arrFechas As New ArrayList
        Try
            'Se realiza la validación de restricciones
            Dim dsRestriccion As DataSet = HerramientasMensajeria.ObtieneRestriccionAgenda()
            If dsRestriccion.Tables.Count > 0 Then
                'Obtiene la jornada actual
                Dim idJornadaActual As Short
                For Each jornada As DataRow In dsRestriccion.Tables(0).Rows
                    Dim horaInicial = jornada("horaInicial")
                    Dim horaFinal = jornada("horaFinal")
                    If Date.Now.TimeOfDay >= horaInicial And Date.Now.TimeOfDay <= horaFinal Then
                        idJornadaActual = jornada("idJornada")
                    End If
                Next
                If idJornadaActual > 0 Then
                    Dim dvDatos As DataView = dsRestriccion.Tables(1).DefaultView
                    With dvDatos
                        .RowFilter = "idJornadaActual=" & idJornadaActual.ToString & " AND idJornadaRestringida=" & cmbJornada.Value.ToString
                        .Sort = "noDias DESC"
                    End With
                    If dvDatos.Count > 0 Then
                        If Now.AddDays(dvDatos(0).Item("noDias")) < dateFechaAgenda.Date Then
                            agendaRestringida = False
                        End If
                    End If

                    With objServicio
                        .IdBodega = DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")
                        .FechaAgenda = dateFechaAgenda.Date
                        .IdJornada = CShort(cmbJornada.Value)
                        .IdTipoServicio = Enumerados.TipoServicio.Venta
                        arrFechas.Add(.IdBodega)
                        arrFechas.Add(.FechaAgenda)
                        arrFechas.Add(.IdJornada)
                    End With
                    If Not agendaRestringida Then
                        resultado = objServicio.ConsultarCapacidad()
                        If resultado.Valor = 0 Then
                            resultado = objServicio.RegistrarCupoEntrega()
                            If resultado.Valor = 0 Then
                                If Session("FechasCupoEntrega") IsNot Nothing Then
                                    Dim arrFechasCambio As ArrayList = Session("FechasCupoEntrega")
                                    objServicio.FechaAgenda = arrFechasCambio(1).ToString
                                    objServicio.IdBodega = arrFechasCambio(0).ToString
                                    objServicio.IdJornada = arrFechasCambio(2).ToString
                                    resultado = objServicio.LiberarCupoEntrega()
                                End If
                                Session("FechasCupoEntrega") = arrFechas
                            End If
                        End If
                    Else
                        resultado.EstablecerMensajeYValor(100, "No se puede asignar la fecha de agenda, ya que no se cumplen las condiciones establecidas para el agendamiento.")
                    End If
                Else
                    resultado.EstablecerMensajeYValor(300, "No se encuentra un Horario hábil para registrar ventas.")
                End If
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(200, ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub LimpiarFormulario()
        Try
            'Establece valores iniciales
            cbRequerido.Checked = True
            cmbEquipo.ValidationSettings.RequiredField.IsRequired = True

            cmbCiudadEntrega.SelectedIndex = -1
            cmbCompania.SelectedIndex = -1
            cmbPlan.SelectedIndex = -1
            cmbEquipo.SelectedIndex = -1
            lblValorEquipo.Text = String.Empty
            txtIdentificacionCliente.Text = String.Empty
            txtNombresCliente.Text = String.Empty
            txtBarrio.Text = String.Empty
            asDireccion.value = String.Empty
            asDireccion.Limpiar()
            memoObservacionDireccion.Text = String.Empty
            txtTelefonoMovil.Text = String.Empty
            txtTelefonoFijo.Text = String.Empty
            cmbFormaPago.SelectedIndex = -1
            cmbClausula.SelectedIndex = -1
            cmbRegion.SelectedIndex = -1
            cmbJornada.SelectedIndex = -1
            dateFechaAgenda.Date = Nothing
            memoObservaciones.Text = String.Empty

            Session.Remove("dtMsisdn")
            Session.Remove("dtReferencia")
        Catch ex As Exception
            miEncabezado.showError("Se generó error al tratar de limpiar el formulario: " & ex.Message)
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

    Public Sub AsignarFechaFinal(ByRef fechaFinal As Date)
        Try
            Dim objDiaNoHabil As New DiasNoHabiles(fechaFinal)
            If objDiaNoHabil.Registrado Then
                fechaFinal = fechaFinal.AddDays(1)
                AsignarFechaFinal(fechaFinal)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar calcular la fecha final de agenda: " & ex.Message)
        End Try
    End Sub

    Public Function ValidarMsisdn() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objServicioMensajeriaVenta As New ServicioMensajeriaVenta()

        With objServicioMensajeriaVenta
            .IdCampania = cmbCompania.SelectedItem.Value
            .TelefonoMovil = txtTelefonoMovil.Text.Trim
            resultado = .VerificarMsisdn()
        End With

        Return resultado
    End Function

#End Region

End Class
