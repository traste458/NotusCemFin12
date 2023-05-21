Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports DevExpress.Web

Public Class AlistamientoSerialesSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idServicio As Integer

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
        Dim respuesta As ResultadoProceso
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()

            If Not IsPostBack And Not IsCallback Then
                If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, IdServicio)
                If _idServicio > 0 Then
                    With miEncabezado
                        .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                        .setTitle("Alistamiento Servicio SIEMBRA: " + _idServicio.ToString())
                    End With

                    Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=_idServicio)
                    esEncabezado.CargarInformacionGeneralServicio(objServicio)

                    CargaInicial()
                    CargarDetalleMins(objServicio.MinsColeccion)
                Else
                    miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                    rpMins.Enabled = False
                    tblMenuFlotante.Style.Add("display", "none")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado procesando la página: " + ex.Message)
        End Try
    End Sub

    Private Sub cpLectura_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpLectura.Callback
        Dim idUsuario As Integer
        Try
            Dim arrParametros() As String = e.Parameter.Split("|")
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Select Case arrParametros(0)
                Case "min"
                    ValidarMin(arrParametros(1))

                Case "registrar"
                    RegistrarSeriales(arrParametros(1), idUsuario)

                Case "desvincular"
                    DesvincularSerial(arrParametros(1).Trim, idUsuario)

                Case "despachar"
                    CerrarDespacho(idUsuario)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar Leer seriales: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim msisdn As String = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()

            Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleSerial
                .IdServicio = IdServicio
                .Msisdn = msisdn
                .CargarDatos()
            End With
            TryCast(sender, ASPxGridView).DataSource = objDetalleSerial
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar el detalle de la Distribución. " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_InitDetalle(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades en detalle: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_InitNovedad(ByVal sender As Object, ByVal e As EventArgs)
        Dim idServicio As Integer
        Try
            Dim linkGestionar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkGestionar.NamingContainer, GridViewDataItemTemplateContainer)
            Dim gvNovedades As ASPxGridView = CType(templateContainer.NamingContainer, ASPxGridView)

            idServicio = CInt(gvNovedades.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdServicioMensajeria"))

            linkGestionar.ClientSideEvents.Click = linkGestionar.ClientSideEvents.Click.Replace("{0}", idServicio)
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades en detalle: " & ex.Message)
        End Try
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

                        CType(sender, ASPxGridView).JSProperties("cpMensajeRespuesta") = respuesta.Valor
                    End With
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select

            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=IdServicio)
            With gvNovedades
                .DataSource = objNovedades
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar las novedades: " + ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvMins_DataBinding(sender As Object, e As System.EventArgs) Handles gvMins.DataBinding
        If Session("objMins") IsNot Nothing Then gvMins.DataSource = Session("objMins")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            ' Se cargan los tipos de Novedad
            With cmbTipoNovedad
                .DataSource = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Alistamiento, _
                                                                           gestionable:=Enumerados.EstadoBinario.Activo, _
                                                                           idTipoServicio:=Enumerados.TipoServicio.Siembra)
                .TextField = "descripcion"
                .ValueField = "idTipoNovedad"
                .DataBind()
            End With

            ' Se desabilitan en principio las cajas de lectura de seriales
            HabilitarLecturaMin(True)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la carga inicial de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleMins(ByRef infoMins As DetalleMsisdnEnServicioMensajeriaColeccion, Optional ByVal msisdn As String = Nothing)
        Dim dtAux As DataTable
        Dim cantPedidaTotal As Integer
        Dim cantLeidaTotal As Integer
        Try
            With gvMins
                .DataSource = infoMins.GenerarDataTable()
                Session("objMins") = .DataSource
                .DataBind()
            End With

            'Se valida si tiene novedades sin gestionar
            Dim objNovedadesAbiertas As New NovedadServicioMensajeriaColeccion(IdServicio:=IdServicio, idEstadoNovedad:=Enumerados.EstadoNovedadMensajeria.Registrado)
            btnDespachar.ClientEnabled = (objNovedadesAbiertas.Count = 0)
            btnNovedad.Text = "Novedades (" + objNovedadesAbiertas.Count.ToString() + ")"

            'Se valida si se realizó la lectura TOTAL de seriales
            dtAux = DirectCast(Session("objMins"), DataTable)
            Integer.TryParse(dtAux.Compute("SUM(cantidadMaterial)", "").ToString, cantPedidaTotal)
            Integer.TryParse(dtAux.Compute("SUM(cantidadMaterialLeida)", "").ToString, cantLeidaTotal)

            If cantLeidaTotal > 0 AndAlso cantLeidaTotal >= cantPedidaTotal Then
                miEncabezado.showSuccess("Ya se leyó la totalidad de seriales requeridos. Por favor proceda a cerrar el despacho.")
                HabilitarLecturaMin(True)
                txtDesvincularSerial.ClientEnabled = True
                btnDesvincularSerial.ClientEnabled = True
                btnDespachar.ClientEnabled = Not (objNovedadesAbiertas.Count > 0)
            Else
                'Se valida si se realizó la lectura total de MSISDN
                If msisdn IsNot Nothing Then
                    Dim dvDataMin As DataView = DirectCast(Session("objMins"), DataTable).Copy().DefaultView
                    dvDataMin.RowFilter = "MSISDN='" + msisdn + "'"
                    dtAux = dvDataMin.ToTable()

                    Integer.TryParse(dtAux.Compute("SUM(cantidadMaterial)", "").ToString, cantPedidaTotal)
                    Integer.TryParse(dtAux.Compute("SUM(cantidadMaterialLeida)", "").ToString, cantLeidaTotal)

                    If cantLeidaTotal > 0 AndAlso cantLeidaTotal >= cantPedidaTotal Then
                        miEncabezado.showWarning("Ya se leyó la totalidad de seriales requeridos para el MSISDN [" & msisdn & "]")
                        HabilitarLecturaMin(True)
                    Else
                        HabilitarLecturaMin(False)
                    End If
                End If
                btnDespachar.ClientEnabled = False
            End If
            If cantPedidaTotal = 0 Then miEncabezado.showWarning("El servicio no tiene referencias asignadas. No se puede proceder con el despacho.")
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub ValidarMin(ByVal msisdn As String)
        Dim dtAux As DataTable
        Dim cantPedida As Integer
        Dim cantLeida As Integer
        Try
            dtAux = DirectCast(Session("objMins"), DataTable).Copy()
            If dtAux.Select("MSISDN='" + msisdn + "'").Length > 0 Then
                Dim dvTemp As DataView = dtAux.DefaultView
                dvTemp.RowFilter = "msisdn=" + msisdn
                dtAux = dvTemp.ToTable()

                Integer.TryParse(dtAux.Compute("SUM(cantidadMaterial)", "").ToString, cantPedida)
                Integer.TryParse(dtAux.Compute("SUM(cantidadMaterialLeida)", "").ToString, cantLeida)

                If cantLeida = cantPedida Then
                    miEncabezado.showWarning("Ya se realizó la lectura de los seriales del MSISDN [" + msisdn + "], seleccione otro por favor.")
                    HabilitarLecturaMin(True)
                Else
                    miEncabezado.showSuccess("Por favor inicie la la lectura de los seriales del MSISDN [" + msisdn + "].")
                    HabilitarLecturaMin(False)
                End If
            Else
                miEncabezado.showWarning("El MSISDN [" + msisdn + "] no se encuentra asociado al servicio, por favor verifique.")
                HabilitarLecturaMin(True)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub RegistrarSeriales(ByVal serial As String, ByVal idUsuario As Integer)
        Dim resultado As ResultadoProceso
        Try
            Dim infoServicio As New ServicioMensajeriaSiembra(IdServicio:=IdServicio)
            resultado = infoServicio.LeerSerial(serial, idUsuario, msisdn:=txtMin.Value, validaRegion:=True)

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                CargarDetalleMins(New DetalleMsisdnEnServicioMensajeriaColeccion(IdServicio:=IdServicio), msisdn:=txtMin.Value)
            Else
                miEncabezado.showWarning(resultado.Mensaje)
                HabilitarLecturaMin(False)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar registrar serial: " + ex.Message)
        End Try
    End Sub

    Private Sub HabilitarLecturaMin(habilitar As Boolean)
        txtMin.ClientEnabled = habilitar
        btnAdicionarMin.ClientEnabled = habilitar
        txtLecturaSerial.ClientEnabled = Not habilitar
        btnRegistrarSerial.ClientEnabled = Not habilitar
        txtDesvincularSerial.ClientEnabled = Not habilitar
        btnDesvincularSerial.ClientEnabled = Not habilitar

        If habilitar Then
            txtLecturaSerial.Text = String.Empty
            txtDesvincularSerial.Text = String.Empty
            txtMin.Focus()
        Else
            txtLecturaSerial.Focus()
        End If
    End Sub

    Private Sub DesvincularSerial(ByVal serial As String, ByVal idUsuario As Integer)
        Dim resultado As ResultadoProceso
        Try
            Dim infoSerial As New DetalleSerialServicioMensajeria(IdServicio:=IdServicio, serial:=serial)
            If infoSerial.Registrado AndAlso infoSerial.IdServicio = IdServicio Then
                resultado = infoSerial.Eliminar(idUsuario)
                If resultado.Valor = 0 Then
                    CargarDetalleMins(New DetalleMsisdnEnServicioMensajeriaColeccion(IdServicio:=IdServicio))
                    miEncabezado.showSuccess("El serial fue desviculado satisfactoriamente.")
                    HabilitarLecturaMin(True)
                End If
            Else
                miEncabezado.showWarning("El serial proporcionado no está asociado al servicio actual. Por favor verifique")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar desvincular el serial: " & ex.Message)
        End Try
    End Sub

    Private Sub CerrarDespacho(ByVal idUsuario As Integer)
        Dim resultado As ResultadoProceso
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)
            Dim infoServicio As ServicioMensajeriaSiembra = New ServicioMensajeriaSiembra(IdServicio:=IdServicio)
            With infoServicio
                .IdUsuarioCierre = idUsuario
                resultado = .CerrarDespacho()

                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)

                    'Se desabilitan todas las acciones
                    tblMenuFlotante.Disabled = True
                    With pcDocumentoCierre
                        .ContentUrl = "~/MensajeriaEspecializada/Reportes/VisorFormatoPrestamoSIEMBRA.aspx?id=" & IdServicio.ToString
                        .ShowOnPageLoad = True
                    End With
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al cerrar el despacho: " & ex.Message)
        End Try
    End Sub

#End Region

End Class