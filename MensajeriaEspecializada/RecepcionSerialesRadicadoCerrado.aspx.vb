Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes

Public Class RecepcionSerialesRadicadoCerrado
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _objServicio As ServicioMensajeria

#End Region

#Region "Propiedades"

    Public Property InfoServicio As ServicioMensajeria
        Get
            If Session("InfoServicio") IsNot Nothing Then
                _objServicio = Session("InfoServicio")
            Else
                _objServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtServicio.Text.Trim()))
                Session("InfoServicio") = _objServicio
            End If
            Return _objServicio
        End Get
        Set(value As ServicioMensajeria)
            Session("InfoServicio") = value
            _objServicio = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        CargarPermisosOpcionesRestringidas()
        CargarRestriccionesDeOpcionPorEstados()
        EstablecerPermisos()

        If Not IsPostBack And Not IsCallback Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Recepción Seriales Servicio Cerrado")
            End With
            HabilitarLecturaSerial(False)
        Else
            If InfoServicio IsNot Nothing > 0 Then HabilitarLecturaSerial(True)
        End If
    End Sub

    Private Sub cpRecepcion_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRecepcion.Callback
        Try
            Dim numRadicado As Long
            Dim arrParametros() As String = e.Parameter.Split("|")

            Select Case arrParametros(0)
                Case "buscarServicio"
                    Long.TryParse(arrParametros(1), numRadicado)
                    BuscarServicio(numRadicado)

                Case "recibirSerial"
                    RecibirSerial(arrParametros(1).ToString())
                    ManejoControlesActivos()

                Case "cerrarServicio"
                    CerrarServicio(CLng(arrParametros(1).ToString()))
                    ManejoControlesActivos()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Dim listadoEstados As New EstadoColeccion
        Dim dtEstado As New DataTable
        With listadoEstados
            .IdEntidad = 50
            dtEstado = .GenerarDataTable
        End With
        MetodosComunes.CargarComboDX(cmbEstado, dtEstado, "idEstado", "Descripcion")
    End Sub

    Private Sub HabilitarLecturaSerial(ByVal habilitar As Boolean)
        rpSeriales.ClientVisible = habilitar
        rpDetalleSeriales.ClientVisible = habilitar

        txtSerial.ClientEnabled = habilitar
        btnRecibirSerial.ClientEnabled = habilitar

        If habilitar Then
            txtServicio.ClientEnabled = Not habilitar
            btnProcesar.ClientEnabled = Not habilitar
            If (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or InfoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM) Then
                cmbEstado.Focus()
                trEstado.Visible = True
            Else
                trEstado.Visible = False
                txtSerial.Focus()
            End If
        End If
    End Sub

    Private Sub ManejoControlesActivos()
        Dim bControles As Boolean = (Session("InfoServicio") Is Nothing)
        txtServicio.ClientEnabled = bControles
        btnProcesar.ClientEnabled = bControles

        HabilitarLecturaSerial(Not bControles)
    End Sub

    Private Sub BuscarServicio(ByVal numRadicado As Long)
        Try
            InfoServicio = New ServicioMensajeria(numeroRadicado:=numRadicado)
            If InfoServicio.Registrado Then
                If InfoServicio.IdEstado = Enumerados.EstadoServicio.PendienteCierre And InfoServicio.IdTipoServicio <> Enumerados.TipoServicio.ServiciosFinancieros And InfoServicio.IdTipoServicio <> Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Then
                    HabilitarLecturaSerial(True)
                    EnlazarSeriales()
                ElseIf (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or InfoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM) Then
                    If InfoServicio.IdEstado = Enumerados.EstadoServicio.PendienteCierre Then
                        HabilitarLecturaSerial(True)
                        EnlazarSerialesFinanciero()
                    End If
                Else
                    LimpiarFormulario()
                    HabilitarLecturaSerial(False)
                    miEncabezado.showWarning("El radicado no se encuentra en estado Pendiente de Cierre.")
                End If
            Else
                LimpiarFormulario()
                miEncabezado.showWarning("El número de servicio proporcionado no se encuentra registrado en el sistema.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar buscar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub RecibirSerial(ByVal serial As String)
        Dim resultado As ResultadoProceso
        Try
            If InfoServicio.Registrado Then
                If (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or InfoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM) Then
                    resultado = InfoServicio.RecibirSerialCierre(serial, CInt(cmbEstado.Value))
                Else
                    resultado = InfoServicio.RecibirSerialCierre(serial)
                End If

                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)
                    If (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or InfoServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM) Then
                        EnlazarSerialesFinanciero()
                    Else
                        EnlazarSeriales()
                    End If
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                End If
            Else
                miEncabezado.showWarning("No se logro obtener la información del servicio, por favor intente nuevamente.")
            End If
            If Session("InfoServicio") IsNot Nothing Then txtSerial.Focus()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar recibir el serial: " & ex.Message)
        End Try
    End Sub

    Private Sub CerrarServicio(ByVal numRadicado As Long)
        Dim resultado As New ResultadoProceso
        Dim idUsuario As Integer
        Dim idServicio As Integer
        Try
            If InfoServicio.Registrado Then
                idServicio = InfoServicio.IdServicioMensajeria
                Integer.TryParse(Session("usxp001"), idUsuario)
                InfoServicio.IdUsuario = idUsuario
                resultado = InfoServicio.ConfirmarCierre()
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)
                    LimpiarFormulario()
                    If (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, idServicio, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    ElseIf (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, idServicio, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    ElseIf (InfoServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, idServicio, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    End If
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                End If
            Else
                miEncabezado.showWarning("No se logro obtener la información del servicio, por favor intente nuevamente.")
            End If
            txtSerial.Focus()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cerrar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarSeriales()
        Dim dtSeriales As DataTable
        Try
            Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleSerial
                .IdServicio = InfoServicio.IdServicioMensajeria
                .CargarDatos()
                dtSeriales = .GenerarDataTable()
            End With

            'Se enlazan los seriales leidos
            Dim dv As DataView = dtSeriales.DefaultView
            dv.RowFilter = "IdEstadoSerial=" & Enumerados.EstadoSerialCEM.Pendiente_por_ingresar_NC
            With gvInfoSeriales
                .DataSource = dv.ToTable()
                .DataBind()
            End With

            'Se valida si se leyeron todos los seriales para crear la NC
            'If btnRegistrarNC.ClientEnabled Then btnRegistrarNC.ClientEnabled = (dv.Count = dtSeriales.Rows.Count)
            btnRegistrarNC.ClientEnabled = (dv.Count = dtSeriales.Rows.Count)

            'Se valida si se termino la lectura de seriales
            Dim cantSerialesPendientes As Integer = dtSeriales.Compute("COUNT(idDetalle)", "idEstadoSerial=" & Enumerados.EstadoSerialCEM.Pendiente_Reintegro_a_Bodega)
            If cantSerialesPendientes = 0 Then
                miEncabezado.showSuccess("Se recibieron todos los seriales asociados al Servicio, por favor informe para que se genere las Notas Crédito.")

                If Not btnRegistrarNC.ClientEnabled Then
                    LimpiarFormulario()
                Else
                    txtSerial.ClientEnabled = False
                    btnRecibirSerial.ClientEnabled = False
                End If
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub EnlazarSerialesFinanciero()
        Dim dtSeriales As DataTable
        Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
        With objDetalleSerial
            .IdServicio = InfoServicio.IdServicioMensajeria
            .CargarDatos()
            dtSeriales = .GenerarDataTable()
        End With

        'Se enlazan los seriales leidos
        Dim dv As DataView = dtSeriales.DefaultView
        dv.RowFilter = "IdEstadoSerial=" & Enumerados.EstadoSerialCEM.Pendiente_por_ingresar_NC
        With gvInfoSeriales
            .DataSource = dv.ToTable()
            .DataBind()
        End With

        'Se valida si se termino la lectura de seriales
        Dim cantSerialesPendientes As Integer = dtSeriales.Compute("COUNT(idDetalle)", "idEstadoSerial<>" & Enumerados.EstadoSerialCEM.Pendiente_por_ingresar_NC)
        If cantSerialesPendientes = 0 Then
            miEncabezado.showSuccess("Se recibieron todos los seriales asociados al Servicio, por favor informe para que se genere las Notas Crédito.")

            If Not btnRegistrarNC.ClientEnabled Then
                LimpiarFormulario()
            Else
                txtSerial.ClientEnabled = False
                btnRecibirSerial.ClientEnabled = False
            End If
        End If
    End Sub

    Private Sub LimpiarFormulario()
        Session.Remove("InfoServicio")
        txtServicio.Text = String.Empty
        txtSerial.Text = String.Empty

        HabilitarLecturaSerial(False)
        txtServicio.Focus()
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

    Private Sub EstablecerPermisos()
        Dim idEstado As Integer
        Dim idCiudad As Integer
        Try
            Integer.TryParse(Session("usxp007"), idCiudad)

            btnRecibirSerial.ClientEnabled = EsVisibleOpcionRestringida(btnRecibirSerial.ID, idCiudad)
            txtSerial.ClientEnabled = btnRecibirSerial.ClientEnabled
            btnRegistrarNC.ClientEnabled = EsVisibleOpcionRestringida(btnRegistrarNC.ID, idCiudad)
            'If ctrl.ClientVisible Then ctrl.ClientVisible = EsVisibleSegunEstado(ctrl.ID, idEstado)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function

#End Region

End Class