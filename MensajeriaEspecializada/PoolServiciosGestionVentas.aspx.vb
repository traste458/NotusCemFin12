Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario

Public Class PoolServiciosGestionVentas
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
#If DEBUG Then
        Session("usxp001") = 33972
        Session("usxp009") = 133
#End If
        miEncabezado.clear()
        CargarPermisosOpcionesRestringidas()
        CargarRestriccionesDeOpcionPorEstados()
        meIdentificador.Focus()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Pool Gestión de Ventas")
            End With

            CargaInicial()
        End If
    End Sub

    Private Sub gvDatos_CustomButtonCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs) Handles gvDatos.CustomButtonCallback
        If e.ButtonID = "anular" Then
            pcAnular.ShowOnPageLoad = True
        ElseIf e.ButtonID = "novedades" Then

        ElseIf e.ButtonID = "editar" Then

        End If
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        If IsCallback And Not String.IsNullOrEmpty(e.Parameters) Then
            Dim parameters() As String = e.Parameters.Split(":"c)
            Select Case parameters(1)
                Case "confirmar"
                    ConfirmarVenta(CInt(parameters(0)))
                Case "anular"
                    AnularPreventa(CInt(parameters(0)))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        End If
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        gvDatos.DataSource = Session("dtDatos")
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback

    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Dim param As String = e.Parameter
        Select Case param
            Case "BusquedaGeneral"
                BuscarRegistros()
                resultado.Valor = 10
            Case "BusquedaDetallada"
                resultado = DescargarDetallado()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        CType(sender, ASPxCallbackPanel).JSProperties("cpResultado") = resultado.Valor
    End Sub

    Protected Sub btnAnular_Click(sender As Object, e As EventArgs) Handles btnAnular.Click
        AnularPreventa(hfIdServicioAnular.Value)
        pcAnular.ShowOnPageLoad = False
    End Sub

    Protected Sub btnAdicionarNovedad_Click(sender As Object, e As EventArgs) Handles btnAdicionarNovedad.Click
        AdicionarNovedad(hfIdServicioNovedad.Value)
        pcNovedad.ShowOnPageLoad = False
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idEstado As String
        Dim idCiudadBodega As Integer
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            'La visualización es visible para todos
            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idEstado = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idEstado"))
            idCiudadBodega = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idCiudad"))

            Dim arrControles() As String = {"lnkAutorizarPreventa", "lnkAnular", "lnkNovedad", "lnkEditar"}
            For indice As Integer = 0 To arrControles.Length - 1
                Dim ctrl As ASPxHyperLink = templateContainer.FindControl(arrControles(indice))
                ctrl.Visible = False
                If ctrl IsNot Nothing Then
                    ctrl.Visible = EsVisibleOpcionRestringida(ctrl.ID, idCiudadBodega)
                    If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, idEstado)
                    ctrl.ClientSideEvents.Click = ctrl.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
                End If
            Next
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveDatos
                .FileName = "Pool Gestión de Ventas"
                .ReportHeader = "Pool Gestión de Ventas" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            Select Case formato
                Case "xls"
                    gveDatos.WriteXlsToResponse()
                Case "pdf"
                    With gveDatos
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveDatos.WriteXlsxToResponse()
                Case "csv"
                    gveDatos.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Carga de las Ciudades
            MetodosComunes.CargarComboDX(cmbCiudadEntrega, HerramientasMensajeria.ObtenerCiudadesCem(ciudadesCercanas:=Enumerados.EstadoBinario.Activo), "idCiudad", "Ciudad")

            'Carga de Estados
            CargarEstado()

            Dim dtNovedades As DataTable = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Preventa)
            'Carga los Tipos de Novedad del Proceso
            MetodosComunes.CargarComboDX(cmbTipoNovedadAnular, dtNovedades, "idTipoNovedad", "descripcion")
            MetodosComunes.CargarComboDX(cmbTipoNovedadNovedad, dtNovedades, "idTipoNovedad", "descripcion")

        Catch ex As Exception
            miEncabezado.showError("Se genero un error al tratar de realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarRegistros()
        Try
            Dim objPool As New GenerarPoolGestionVentas()
            With objPool
                If meIdentificador.Text.Length > 0 Then
                    If rblTipoIdentificador.Value = 0 Then
                        For Each ser As Object In meIdentificador.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                            .ListIdServicio.Add(CStr(ser))
                        Next
                    Else
                        For Each msi As Object In meIdentificador.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                            .ListMsisdn.Add(CStr(msi))
                        Next
                    End If
                End If
                If cmbCiudadEntrega.Value > 0 Then .IdCiudad = cmbCiudadEntrega.Value
                If Not String.IsNullOrEmpty(txtIdentificacionCliente.Text) Then .IdentificacionCliente = txtIdentificacionCliente.Text
                If Not String.IsNullOrEmpty(txtNombreCliente.Text) Then .NombreCliente = txtNombreCliente.Text
                If dateFechaInicio.Date <> Date.MinValue Then .FechaRegistroInicio = dateFechaInicio.Date
                If dateFechaFin.Date <> Date.MinValue Then .FechaRegistroFin = dateFechaFin.Date
                If datePreventaInicio.Date > Date.MinValue Then .FechaAprobacionInicio = datePreventaInicio.Date
                If datePreventaFin.Date > Date.MinValue Then .FechaAprobacionFin = datePreventaFin.Date
                If dateAnulaInicio.Date > Date.MinValue Then .FechaAnulacionInicio = dateAnulaInicio.Date
                If dateAnulaFin.Date > Date.MinValue Then .FechaAnulacionFin = dateAnulaFin.Date

                'Estados Disponibles del Pool
                If cmbEstado.Value IsNot Nothing Then
                    .IdListaEstado = New List(Of Integer)(New Integer() {cmbEstado.Value})
                Else
                    Dim listEstados As New List(Of Integer)
                    For Each estado As DataRow In DirectCast(Session("dtEstado"), DataTable).Rows
                        listEstados.Add(CInt(estado("idEstado")))
                    Next
                    .IdListaEstado = listEstados
                End If
            End With

            Dim dtDatos As DataTable = objPool.GenerarPool()
            Session("dtDatos") = dtDatos

            With gvDatos
                .PageIndex = 0
                .DataSource = dtDatos
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la búsqueda: " + ex.Message)
        End Try
    End Sub

    Private Function DescargarDetallado() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim dtDetalleGestionVenta As New DataTable
        Dim objDetalle As New GestionVentasDetallado

        With objDetalle
            If meIdentificador.Text.Length > 0 Then
                If rblTipoIdentificador.Value = 0 Then
                    For Each ser As Object In meIdentificador.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                        .ListIdServicio.Add(CStr(ser))
                    Next
                Else
                    For Each msi As Object In meIdentificador.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                        .ListMsisdn.Add(CStr(msi))
                    Next
                End If
            End If
            If cmbCiudadEntrega.Value > 0 Then .IdCiudad = cmbCiudadEntrega.Value
            If Not String.IsNullOrEmpty(txtIdentificacionCliente.Text) Then .IdentificacionCliente = txtIdentificacionCliente.Text
            If Not String.IsNullOrEmpty(txtNombreCliente.Text) Then .NombreCliente = txtNombreCliente.Text
            If dateFechaInicio.Date <> Date.MinValue Then .FechaRegistroInicio = dateFechaInicio.Date
            If dateFechaFin.Date <> Date.MinValue Then .FechaRegistroFin = dateFechaFin.Date
            If datePreventaInicio.Date > Date.MinValue Then .FechaAprobacionInicio = datePreventaInicio.Date
            If datePreventaFin.Date > Date.MinValue Then .FechaAprobacionFin = datePreventaFin.Date
            If dateAnulaInicio.Date > Date.MinValue Then .FechaAnulacionInicio = dateAnulaInicio.Date
            If dateAnulaFin.Date > Date.MinValue Then .FechaAnulacionFin = dateAnulaFin.Date

            'Estados Disponibles del Pool
            If cmbEstado.Value IsNot Nothing Then
                .IdListaEstado = New List(Of Integer)(New Integer() {cmbEstado.Value})
            Else
                Dim listEstados As New List(Of Integer)
                For Each estado As DataRow In DirectCast(Session("dtEstado"), DataTable).Rows
                    listEstados.Add(CInt(estado("idEstado")))
                Next
                .IdListaEstado = listEstados
            End If
            dtDetalleGestionVenta = .GenerarReporte()
        End With
        If dtDetalleGestionVenta.Rows.Count > 0 Then
            resultado.Valor = 0
        Else
            resultado.Valor = 1
            miEncabezado.showWarning("No se encontraron resultados, según los filtros aplicados.")
        End If
        Session("dtDetalleGestionVenta") = dtDetalleGestionVenta

        Return resultado
    End Function

    Private Sub ConfirmarVenta(idServicio As Integer)
        Try
            Dim resultado As New ResultadoProceso
            resultado = ValidarFecha(idServicio)
            If resultado.Valor = 0 Then
                Dim objVenta As New ServicioMensajeriaVenta(idServicio)
                With objVenta
                    .IdEstado = Enumerados.EstadoServicio.Creado
                    resultado = .Actualizar(CInt(Session("usxp001")))
                End With

                If resultado.Valor = 0 Then
                    smPrincipal.MensajeAceptar("Confirmación", resultado.Mensaje)
                    BuscarRegistros()
                    miEncabezado.showSuccess("Preventa Autorizada Satisfactoriamente.")
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                End If
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de confirmar la preventa: " & ex.Message)
        End Try
    End Sub

    Private Sub AnularPreventa(idServicio As Integer)
        Try
            Dim resultado As New ResultadoProceso

            'Se registra la novedad de anulación
            Dim objNovedad As New NovedadServicioMensajeria()
            With objNovedad
                .IdServicioMensajeria = idServicio
                .IdUsuario = CInt(Session("usxp001"))
                .Observacion = memoObservacionAnular.Text
                .IdTipoNovedad = cmbTipoNovedadAnular.Value
                resultado = .Registrar(CInt(Session("usxp001")))
            End With

            If resultado.Valor = 0 Then
                'Se realiza el cambio de estado del servicio

                Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
                With objServicio
                    .IdEstado = Enumerados.EstadoServicio.Anulado
                    resultado = .AnularServicioVenta(CInt(Session("usxp001")))
                End With
                If resultado.Valor = 0 Then
                    'Se realiza la liberación de la reserva
                    Dim objInventario As New BloqueoInventario(idBloqueo:=objServicio.IdReserva)
                    With objInventario
                        .IdEstado = Enumerados.InventarioBloqueo.Anulado
                        resultado = .Actualizar()
                        'If resultado.Valor <> 0 Then miEncabezado.showWarning("No se logro liberar la reserva de inventario: " & resultado.Mensaje)
                    End With

                    'Se realiza la liberación del Cupo de Agenda
                    resultado = objServicio.LiberarCupoEntrega()
                    'If resultado.Valor <> 0 Then miEncabezado.showWarning("No se logro liberar el cupo de entrega: " & resultado.Mensaje)

                    miEncabezado.showSuccess("Servicio anulado exitosamente.")
                    BuscarRegistros()
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de anular la preventa: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarNovedad(idServicio As Integer)
        Try
            Dim resultado As New ResultadoProceso

            'Se registra la novedad
            Dim objNovedad As New NovedadServicioMensajeria()
            With objNovedad
                .IdServicioMensajeria = idServicio
                .IdUsuario = CInt(Session("usxp001"))
                .Observacion = memoObservacionNovedad.Text
                .IdTipoNovedad = cmbTipoNovedadNovedad.Value
                resultado = .Registrar(CInt(Session("usxp001")))
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Novedad adicionada correctamente.")
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al tratar de adicionar la novedad: " & ex.Message)
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

    Private Sub CargarEstado()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional("cmbEstado")
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstado()
            MetodosComunes.CargarComboDX(cmbEstado, dtEstado, "idEstado", "nombre")
            Session("dtEstado") = dtEstado
        Catch ex As Exception
            miEncabezado.showError("Error al intentar obtener estados: " & ex.Message)
        End Try
    End Sub

    Private Function ValidarFecha(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeria(idServicio)
        Dim fechaAgenda As Date = miServicio.FechaAgenda
        Dim idJornada As Integer = miServicio.IdJornada
        Dim idJornadaActual As Short
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
            End If
        End With
        If fechaAgenda >= fechaInicial AndAlso fechaAgenda <= fechaFinal Then
            resultado.Valor = 0
        Else
            Dim fechaFormat As Date = fechaInicial.ToString("yyyy/MM/dd")
            Dim dsRestriccion As DataSet = HerramientasMensajeria.ObtieneRestriccionAgenda()

            If dsRestriccion.Tables.Count > 0 Then
                'Obtiene la jornada actual
                For Each jornada As DataRow In dsRestriccion.Tables(0).Rows
                    Dim horaInicial = jornada("horaInicial")
                    Dim horaFinal = jornada("horaFinal")
                    If Date.Now.TimeOfDay >= horaInicial And Date.Now.TimeOfDay <= horaFinal Then
                        idJornadaActual = jornada("idJornada")
                    End If
                Next
            End If
            If fechaAgenda = fechaFormat AndAlso idJornada > idJornadaActual Then
                resultado.EstablecerMensajeYValor(11, "No se puede autorizar el servicio, fecha y jornada de agenda que está aprobando no cumple con los parámetros establecidos para la campaña")
            Else
                resultado.EstablecerMensajeYValor(10, "No se puede autorizar el servicio, la fecha y jornada de agenda estan vencidas")
            End If

        End If

        Return resultado
    End Function

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