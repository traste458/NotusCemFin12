Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes
Imports DevExpress.Web
Imports ILSBusinessLayer.Inventario

Public Class EditarServicioFinanciero
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _referenciasDataTable As New DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, True)
        miEncabezado.clear()
        CrearEstructuraDataTable()
        Dim idServicio As Integer
        If Not Me.IsPostBack Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
            If idServicio > 0 Then
                With miEncabezado
                    .setTitle("Modificar Servicio ")
                    .showReturnLink("PoolServiciosNew.aspx")
                End With
                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()
                CargaInicial()
                CargarInformacionGeneralServicio(idServicio)
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "ActualizaServicio"
                    resultado = ActualizarServicio()
                Case "CancelaServicio"
                    resultado = AnularServicio()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Ocurrio un error al generar el registro: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvReferencias_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvReferencias.CustomCallback
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameters.Split(":")
            Select Case arrayAccion(0)
                Case "AgregarReferencia"
                    AgregarReferencia()
                Case "EliminarReferencia"
                    EliminarReferencia(arrayAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Ocurrio un error al generar el registro: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
        Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
        linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
    End Sub

#End Region

#Region "Métodos Privados"

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

    Private Sub CargaInicial()
        Try
            ' Carga Ciuadades
            MetodosComunes.CargarComboDX(cmbCiudad, CType(HerramientasMensajeria.ObtenerCiudadesCem(), DataTable), "idCiudad", "Ciudad")
            'Carga los tipos de servicio
            MetodosComunes.CargarComboDX(cmbTipoServicio, CType(HerramientasMensajeria.ConsultaTipoServicio(), DataTable), "idTipoServicio", "nombre")
            'Cargar Prioridades
            Dim listaPrioridad As New PrioridadMensajeriaColeccion()
            MetodosComunes.CargarComboDX(cmbPrioridad, listaPrioridad.GenerarDataTable, "idPrioridad", "prioridad")
            'Carga Productos 
            Dim lisProductos As New ProductoDocumentoFinancieroColeccion
            MetodosComunes.CargarComboDX(cmbProducto, lisProductos.GenerarDataTable, "Codigo", "Nombre")



        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar configuración. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria
        Try
            infoServicio = New ServicioMensajeria(idServicio)
            If infoServicio.Registrado Then
                With infoServicio
                    miEncabezado.setTitle("Modificar Servicio: " & .IdServicioMensajeria.ToString)
                    cmbTipoServicio.Value = .IdTipoServicio
                    txtServicio.Text = .IdServicioMensajeria.ToString
                    txtEjecutor.Text = .UsuarioEjecutor
                    txtNombres.Text = .NombreCliente
                    txtIdentificacion.Text = .IdentificacionCliente
                    txtContacto.Text = .PersonaContacto
                    cmbCiudad.Value = .IdCiudad
                    txtBarrio.Text = .Barrio
                    txtDireccion.Text = .Direccion
                    txtTelefono.Text = .TelefonoContacto
                    dateFechaAsignacion.Date = .FechaAsignacion
                    dateFechaAsignacion.MinDate = .FechaAsignacion
                    meJustificacion.Text = .Observacion

                    If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                        .ReferenciasColeccion.IdTipoServicio = .IdTipoServicio
                        _referenciasDataTable = .ReferenciasColeccion.GenerarDataTable()

                        Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                        _referenciasDataTable.PrimaryKey = pkMaterial

                        Session("referenciasDataTable") = _referenciasDataTable
                        gvReferencias.DataSource = _referenciasDataTable
                        gvReferencias.DataBind()
                        'hfNumReferencias.Value = _referenciasDataTable.Rows.Count.ToString
                    End If

                    If .IdPrioridad > 0 Then cmbPrioridad.Value = .IdPrioridad

                    dateFechaVencimiento.Date = .FechaVencimientoReserva
                    dateFechaVencimiento.MinDate = Now
                    Session("infoServicioMensajeria") = infoServicio
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CrearEstructuraDataTable()
        'Referencias
        With _referenciasDataTable
            .Columns.Add("material", GetType(String))
            .Columns.Add("referencia", GetType(String))
            .Columns.Add("cantidad", GetType(Integer))
            .AcceptChanges()
        End With
        Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
        _referenciasDataTable.PrimaryKey = pkMaterial
    End Sub

    Private Function ActualizarServicio() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = Request.QueryString("idServicio").ToString
        Dim infoServicio As New ServicioMensajeria

        With infoServicio
            .IdServicioMensajeria = idServicio
            .IdTipoServicio = cmbTipoServicio.Value
            .UsuarioEjecutor = txtEjecutor.Text
            .NombreCliente = txtNombres.Text
            .IdentificacionCliente = txtIdentificacion.Text.Trim
            .PersonaContacto = txtContacto.Text.Trim
            .IdCiudad = cmbCiudad.Value
            .Barrio = txtBarrio.Text.Trim
            .Direccion = txtDireccion.Text.Trim
            .TelefonoContacto = txtTelefono.Text.Trim
            Date.TryParse(dateFechaAsignacion.Date, .FechaAsignacion)
            .Observacion = meJustificacion.Text
            .FechaVencimientoReserva = dateFechaVencimiento.Date
            .IdPrioridad = CInt(cmbPrioridad.Value)
            .ReferenciasDataTable = _referenciasDataTable
            resultado = .Actualizar(CInt(Session("usxp001")))
        End With

        If resultado.Valor = 0 Then
            infoServicio = New ServicioMensajeria(infoServicio.IdServicioMensajeria)

            If (infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or infoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM) Then
                resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, infoServicio.IdServicioMensajeria, infoServicio.IdEstado, meJustificacion.Text.Trim())
            ElseIf (infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, infoServicio.IdServicioMensajeria, infoServicio.IdEstado, meJustificacion.Text.Trim())
            ElseIf (infoServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, infoServicio.IdServicioMensajeria, infoServicio.IdEstado, meJustificacion.Text.Trim())
            End If

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Servicio actualizado correctamente.")
            Else
                miEncabezado.showSuccess("Servicio actualizado correctamente, con inconvenientes en la comunicación con NotusExpressService." & resultado.Mensaje)
            End If
        Else
            miEncabezado.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function AnularServicio() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = Request.QueryString("idServicio").ToString
        Dim infoServicio As New ServicioMensajeria(idServicio)

        With infoServicio
            resultado = .Anular(CInt(Session("usxp001")))
        End With

        If resultado.Valor = 0 Then
            resultado = AnularGestionVenta(idServicio)
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Servicio anulado correctamente.")
            Else
                miEncabezado.showSuccess("Servicio anulado correctamente, con inconvenientes en la comunicación con NotusExpressService." & resultado.Mensaje)
            End If
            rpDetalle.ClientVisible = False
            imgActualiza.ClientVisible = False
            imgCancelar.ClientVisible = False
        Else
            miEncabezado.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
        End If

        Return resultado
    End Function

    Private Function AnularGestionVenta(ByVal idServicio As Integer) As ResultadoProceso
        Dim infoServicio As New ServicioMensajeria(idServicio)
        Dim resultado As New ResultadoProceso
        Dim objGestion As New NotusExpressService.NotusExpressService
        Dim infoWs As New InfoUrlSidService(objGestion, True)
        Dim WSInfoGestion As New ILSBusinessLayer.NotusExpressService.WsGestionVenta
        Dim Wsresultado As New ILSBusinessLayer.NotusExpressService.ResultadoProceso

        With WSInfoGestion
            .IdServicioNotus = idServicio
            .IdEstado = NotusExpressService.EstadosGestionDeVenta.VentaDeclinada
            .ObservacionDeclinar = "Servicio anulado por el proceso de CEM, usuario ejecutor: " & CStr(Session("usxp001"))
            .IdEstadoServicioMensajeria = Enumerados.EstadoServicio.Anulado
            .ObservacionNovedad = meJustificacion.Text.Trim
            .IdModificador = 1
        End With

        Wsresultado = objGestion.ActualizaGestionVenta(WSInfoGestion)
        resultado.Valor = Wsresultado.Valor
        resultado.Mensaje = Wsresultado.Mensaje
        Return resultado
    End Function

    Private Function AgregarReferencia() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miDisponibilidad As New ItemBodegaSatelite
        Dim dtDatos As New DataTable
        Dim idServicio As Integer = Request.QueryString("idServicio").ToString
        Dim infoServicio As New ServicioMensajeria(idServicio)

        With miDisponibilidad
            dtDatos = .InventarioDisponibleServicioFinanciero(idCiudad:=infoServicio.IdCiudad, codigoDocumento:=cmbProducto.Value, idCampania:=infoServicio.IdCampania)
        End With

        If dtDatos.Rows.Count <> 0 Then
            Dim Fila As DataRow() = dtDatos.Select("valor IN ('" & cmbProducto.Value & "')")
            Dim cantidadDisponible As Integer = CInt(Fila(0).Item("cantidadDisponible"))
            Dim cantidadSolicitada As Integer = CInt(txtCantidad.Text)
            If cantidadDisponible >= cantidadSolicitada Then
                RegistrarReferencia(idServicio)
            Else
                miEncabezado.showWarning("No existe disponibilidad suficiente para asignar el producto, cantidad disponible:" & CStr(cantidadDisponible))
            End If
        Else
            miEncabezado.showWarning("No se logró establecer la disponibilidad de documentos, según los parametros establecidos.")
        End If

        Return resultado
    End Function

    Private Function RegistrarReferencia(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim referenciaDetalle As New DetalleMaterialServicioMensajeria()
        Dim infoServicio As New ServicioMensajeria(idServicio)
        With referenciaDetalle
            .IdServicio = infoServicio.IdServicioMensajeria
            .IdTipoServicio = infoServicio.IdTipoServicio
            .Material = CStr(cmbProducto.Value)
            .Cantidad = CInt(txtCantidad.Text)
            .IdUsuarioRegistra = CInt(Session("usxp001"))
            resultado = .Adicionar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess("Modificación éxitosa.")
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        _referenciasDataTable = infoServicio.ReferenciasColeccion.GenerarDataTable()
        gvReferencias.DataSource = _referenciasDataTable
        gvReferencias.DataBind()
        Return resultado
    End Function

    Private Function EliminarReferencia(ByVal idRegistro As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = Request.QueryString("idServicio").ToString
        Dim infoServicio As New ServicioMensajeria(idServicio)
        Dim referenciaDetalle As New DetalleMaterialServicioMensajeria(idRegistro)
        resultado = referenciaDetalle.Eliminar(CInt(Session("usxp001")))
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess("Eliminación éxitosa.")
        End If
        _referenciasDataTable = infoServicio.ReferenciasColeccion.GenerarDataTable()
        gvReferencias.DataSource = _referenciasDataTable
        gvReferencias.DataBind()
        Return resultado
    End Function

    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function

#End Region

End Class