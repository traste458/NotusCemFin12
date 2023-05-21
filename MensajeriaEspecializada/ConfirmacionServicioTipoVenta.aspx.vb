Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports System.Text
Imports DevExpress.Web

Public Class ConfirmacionServicioTipoVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer

    Private _referenciasDataTable As New DataTable
    Private _minsDataTable As New DataTable

#End Region

#Region "Propiedades"

    Public Property IdServicio As Integer
        Get
            If Session("idServicio") IsNot Nothing Then _idServicio = Session("idServicio")
            Return _idServicio
        End Get
        Set(value As Integer)
            Session("idServicio") = value
            _idServicio = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, IdServicio)
            If _idServicio > 0 Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Confirmar Venta")
                End With

                CargaInicial()
                CargarInformacionGeneralServicio(_idServicio)
                CargarListaNovedad()
                VisualizarDocumentosAsociados(_idServicio)
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                rpEdidatServicio.Enabled = False
            End If
        End If
    End Sub

    Private Sub cmbCompania_ValueChanged(sender As Object, e As System.EventArgs) Handles cmbCompania.ValueChanged
        CargarPlanes(cmbCompania.Value)
    End Sub

    Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs) Handles btnConfirmar.Click
        Dim fecha As Date = Now.AddDays(0)
        Dim fechaFormat As Date = fecha.ToString("yyyy/MM/dd")
        If dateFechaAgenda.Date >= fechaFormat And dateFechaAgenda.Date <= DateTime.Now.AddDays(8) Then
            ConfirmarServicio()
        Else
            miEncabezado.showWarning("Por favor verifique le la fecha de agenda sea superior a la fecha actual y que no sobrepase los 8 dias.")
        End If

    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            Dim idUsuario As Integer = 0
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            'Carga las campañas
            MetodosComunes.CargarComboDX(cmbCompania, HerramientasMensajeria.ObtieneCampaniasDisponiblesUsuario(0), "idCampania", "nombre")

            'Forma de Pago
            MetodosComunes.CargarComboDX(cmbFormaPago, HerramientasMensajeria.ObtieneMediosDePago(), "idMedio", "nombre")

            'Clausula
            MetodosComunes.CargarComboDX(cmbClausula, HerramientasMensajeria.ConsultaClausula(), "idClausula", "nombre")

            'Regiones
            MetodosComunes.CargarComboDX(cmbRegion, MetodosComunes.getRegiones(True), "idRegion", "nombreCodigo")

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

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la carga inicial de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeriaVenta
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            infoServicio = New ServicioMensajeriaVenta(idServicio)

            If infoServicio.Registrado Then
                With infoServicio
                    miEncabezado.setTitle("Confirmar Servicio: " & .IdServicioMensajeria.ToString)
                    Session("infoServicioMensajeria") = infoServicio

                    'Se cargan los valores de las Ciudades disponibles
                    Dim dtCiudad As DataTable = HerramientasMensajeria.ObtenerCiudadesCem(ciudadesCercanas:=Enumerados.EstadoBinario.Activo, idBodega:= .IdBodega) '.ObtenerCiudadesCallCenter(idUsuario:=idUsuario, ciudadesCercanas:=Enumerados.EstadoBinario.Activo, idBodega:=.IdBodega)
                    Session("dtCiudad") = dtCiudad
                    MetodosComunes.CargarComboDX(cmbCiudadEntrega, dtCiudad, "idCiudad", "Ciudad")
                    cmbCiudadEntrega.Value = .IdCiudad
                    cmbCompania.Value = CInt(.IdCampania)

                    'Se cargan los planes a partir de la campaña
                    CargarPlanes(.IdCampania)

                    cmbPlan.Value = .IdPlanVenta
                    txtIdentificacionCLiente.Text = .IdentificacionCliente
                    txtNombresCliente.Text = .NombreCliente
                    txtBarrio.Text = .Barrio

                    'Se carga la dirección
                    asDireccion.value = .Direccion
                    asDireccion.DireccionEdicion = .DireccionEdicion

                    memoObservacionDireccion.Text = .ObservacionDireccion
                    txtTelefonoMovil.Text = .TelefonoContacto
                    txtTelefonoFijo.Text = .TelefonoFijo
                    cmbFormaPago.Value = CInt(.IdMedioPago)
                    cmbJornada.Value = CInt(.IdJornada)

                    dateFechaAgenda.Date = .FechaAgenda
                    memoObservaciones.Text = .Observacion

                    If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                        Dim copyReferencias As DetalleMaterialServicioMensajeriaColeccion = .ReferenciasColeccion
                        With copyReferencias
                            .IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
                            .CargarDatos()
                        End With
                        If copyReferencias.Count > 0 Then
                            cmbEquipo.Value = .ReferenciasColeccion(0).Material
                        Else
                            cmbEquipo.ValidationSettings.RequiredField.IsRequired = False
                        End If

                        _referenciasDataTable = .ReferenciasColeccion.GenerarDataTable()
                        Dim pkMaterial() As DataColumn = {_referenciasDataTable.Columns("material")}
                        _referenciasDataTable.PrimaryKey = pkMaterial
                    End If

                    If .MinsColeccion IsNot Nothing AndAlso .MinsColeccion.Count > 0 Then
                        If .MinsColeccion.Count > 0 Then
                            cmbClausula.Value = CInt(.MinsColeccion(0).IdClausula)
                        End If
                        _minsDataTable = .MinsColeccion.GenerarDataTable()
                    End If
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
            MetodosComunes.CargarComboDX(cmbPlan, New PlanVentaColeccion(idCampania:=cmbCompania.Value).GenerarDataTable(), "idPlan", "nombrePlan")

            If cmbCiudadEntrega.Value IsNot Nothing Then
                'Equipos
                Dim listBodegas As New List(Of Integer)
                'TODO: Obtener las bodegas asociadas a la Ciudad de la Sesión
                'For Each bodega As DataRow In DirectCast(Session("dtCiudad"), DataTable).Select("idCiudad=" & cmbCiudadEntrega.Value)
                '    listBodegas.Add(CInt(bodega("idBodega")))
                'Next

                Dim infoServicio As ServicioMensajeriaVenta = CType(Session("infoServicioMensajeria"), ServicioMensajeriaVenta)

                Dim objInventarioVenta As New InventarioSateliteVenta()
                With objInventarioVenta
                    .IdCampania = New List(Of Integer)(New Integer() {cmbCompania.Value})
                    .IdTipoProducto = New List(Of Integer)(New Integer() {Enumerados.TipoProductoMaterial.HANDSETS})
                    .IdBodega = listBodegas
                    If infoServicio.ReferenciasColeccion.Count > 0 Then .IdProducto = New List(Of Integer)(New Integer() {infoServicio.ReferenciasColeccion(0).IdProducto})
                End With
                With cmbEquipo
                    Dim dvDatos As DataView = DirectCast(objInventarioVenta.ObtieneInventarioVentaAgrupado(), DataTable).DefaultView
                    dvDatos.RowFilter = "cantidad > 0"

                    .SelectedIndex = -1
                    .DataSource = dvDatos.ToTable()
                    .DataBind()
                End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de cargar los planes: " & ex.Message)
        End Try
    End Sub

    Private Sub ConfirmarServicio()
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim infoServicio As ServicioMensajeriaVenta = CType(Session("infoServicioMensajeria"), ServicioMensajeriaVenta)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(CInt(Request.QueryString("idServicio")))
            With infoServicio
                .IdCiudad = cmbCiudadEntrega.Value
                .Direccion = asDireccion.value
                .DireccionEdicion = asDireccion.DireccionEdicion
                .Barrio = txtBarrio.Text.Trim.ToUpper
                .TelefonoContacto = txtTelefonoMovil.Text.Trim
                .TelefonoFijo = txtTelefonoFijo.Text.Trim
                .Observacion = memoObservaciones.Text.Trim
                .ObservacionDireccion = memoObservacionDireccion.Text
                .FechaAgenda = dateFechaAgenda.Date
                .IdJornada = cmbJornada.Value
                .IdUsuarioConfirmacion = idUsuario
                .IdMedioPago = cmbFormaPago.Value

                .Material = cmbEquipo.Value

                If .IdEstado = Enumerados.EstadoServicio.Creado Or .IdEstado = Enumerados.EstadoServicio.GestionadoConNovedadEnContacto Then
                    resultado = .Confirmar()
                Else
                    resultado = .Actualizar(idUsuario)
                End If

                If resultado.Valor = 0 Then
                    Response.Redirect("PoolServiciosNew.aspx?resOk=true&codRes=1", False)
                    miEncabezado.showSuccess(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            miEncabezado.showWarning("Se generó un error la tratar de confirmar el servicio: " & ex.Message)
        End Try
    End Sub

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

    Private Sub CargarListaNovedad()
        ' Se cargan los tipos de Novedad
        With cmbTipoNovedad
            .DataSource = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Confirmacion,
                                                                       idTipoServicio:=Enumerados.TipoServicio.Venta)
            .TextField = "descripcion"
            .ValueField = "idTipoNovedad"
            .DataBind()
        End With
    End Sub

    Private Sub gvNovedades_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvNovedades.CustomCallback
        Dim respuesta As ResultadoProceso
        Try
            Dim arrParametros() As String = e.Parameters.Split("|")
            Select Case arrParametros(0)
                Case "registrar"
                    Dim objNovedad As New NovedadServicioMensajeria()
                    With objNovedad
                        .IdTipoNovedad = cmbTipoNovedad.Value
                        .IdServicioMensajeria = IdServicio
                        .Observacion = memoObservacionesNovedad.Text
                        respuesta = .Registrar(CInt(Session("usxp001")))
                        If respuesta.Valor = 0 Then
                            VerificarCambioEstado(IdServicio)
                            miEncabezado.showSuccess("Novedad registrada satisfactoriamente.")
                        Else
                            miEncabezado.showError(respuesta.Mensaje)
                        End If
                    End With
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=_idServicio)
            With gvNovedades
                .DataSource = objNovedades
                .DataBind()
            End With
            pcNovedades.ShowOnPageLoad = True
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar las novedades: " + ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Public Sub VerificarCambioEstado(ByRef idServicio As Integer)
        Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
        If objServicio.IdEstado = Enumerados.EstadoServicio.Creado Then
            With objServicio
                .IdServicioMensajeria = idServicio
                .IdEstado = Enumerados.EstadoServicio.GestionadoConNovedadEnContacto
                .Actualizar(CInt(Session("usxp001")))
            End With
        End If

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

#End Region

End Class