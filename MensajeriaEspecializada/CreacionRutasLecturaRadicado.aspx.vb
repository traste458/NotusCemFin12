Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic
Imports System.Text

Public Class CreacionRutasLecturaRadicado
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idAgenteServicio As Integer
    Private _idZona As Short
    Private _listRadicados As List(Of ServicioMensajeria)
    Private _dtCiudadesCercanas As DataTable
    Private arrEstadosCrearruta As New ArrayList
    Private arrTiposServicioCrearruta As New ArrayList
#End Region

#Region "Propiedades"

    Public Property AgenteServicio As Integer
        Get
            If Session("idAgenteServicio") IsNot Nothing Then _idAgenteServicio = Session("idAgenteServicio")
            Return _idAgenteServicio
        End Get
        Set(value As Integer)
            _idAgenteServicio = value
            Session("idAgenteServicio") = _idAgenteServicio
        End Set
    End Property

    Public Property Zona As Short
        Get
            If Session("idZona") IsNot Nothing Then _idZona = Session("idZona")
            Return _idZona
        End Get
        Set(value As Short)
            _idZona = value
            Session("idZona") = _idZona
        End Set
    End Property

    Public Property Radicados As List(Of ServicioMensajeria)
        Get
            If Session("listRadicado") IsNot Nothing Then
                _listRadicados = Session("listRadicado")
            ElseIf _listRadicados Is Nothing Then
                _listRadicados = New List(Of ServicioMensajeria)
            End If

            Return _listRadicados
        End Get
        Set(value As List(Of ServicioMensajeria))
            _listRadicados = value
            Session("listRadicado") = _listRadicados
        End Set
    End Property

    Public Property CiudadesCercanas As DataTable
        Get
            If Session("dtCiudadesCercanas") IsNot Nothing Then _dtCiudadesCercanas = Session("dtCiudadesCercanas")
            Return _dtCiudadesCercanas
        End Get
        Set(value As DataTable)
            _dtCiudadesCercanas = value
            Session("dtCiudadesCercanas") = _dtCiudadesCercanas
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118

        Session("usxp007") = 150
#End If
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack And Not IsCallback Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Creación de Ruta de Entrega")
                LimpiarFormulario()
            End With
            CargarListas()
            CiudadesCercanas = HerramientasMensajeria.ObtenerCiudadesCem()
        End If
    End Sub

    Private Sub cpLectura_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpLectura.Callback
        Try
            Dim arrParametros() As String = e.Parameter.Split("|")

            Select Case arrParametros(0)
                Case "buscarMotorizado"
                    BuscarMotorizado()

                Case "radicado"
                    VincularRadicado(CLng(arrParametros(1)))
                    txtRadicado.Focus()

                Case "desvincular"
                    DesvincularRadicado(CLng(arrParametros(1)))
                    txtDesvincularRadicado.Focus()

                Case "registrarRuta"
                    RegistrarRuta()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            ManejoControlesActivos()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar la ruta: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarListas()
        Dim dtZonas As DataTable = HerramientasMensajeria.ConsultaZona()
        MetodosComunes.CargarComboDX(cmbZona, dtZonas, "idZona", "nombre")
    End Sub

    Private Sub BuscarMotorizado()
        Try
            Dim objTerceros As New Usuario(identificacion:=txtIdentificacion.Text)

            If objTerceros.IdUsuario > 0 Then
                If objTerceros.IdPerfil = Enumerados.PerfilesMensajeria.Motorizado_Mensajeria_Especializada Then
                    'Se valida que el motorizado pertenezca a la bodega
                    Dim dvCiudad As DataView = CiudadesCercanas.DefaultView
                    dvCiudad.RowFilter = "idCiudad=" & objTerceros.IdCiudad.ToString()

                    If dvCiudad.Count > 0 Then
                        AgenteServicio = objTerceros.IdUsuario
                        Zona = cmbZona.Value

                        rpRadicados.ClientVisible = True
                        txtRadicado.Focus()
                    Else
                        miEncabezado.showWarning("El agente de servicio no pertenece a la bodega actual, por favor verifique e intente nuevamente.")
                    End If
                Else
                    miEncabezado.showWarning("El usuario con la identificación proporcionada no tiene perfil válido para asignarle ruta.")
                End If
            Else
                miEncabezado.showWarning("No se encontró información de un Agente de Servicio con el número de identificación proporcionado.")
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub VincularRadicado(numRadicado As Long)
        Try
            Dim objServicio As New ServicioMensajeria(numeroRadicado:=numRadicado)
            If objServicio.Registrado Then
                'Se valida la bodega del radicado
                Dim dvCiudades As DataView = CiudadesCercanas.DefaultView
                dvCiudades.RowFilter = "idCiudad=" & objServicio.IdCiudad
                If dvCiudades.Count > 0 Then
                    arrTiposServicioCrearruta = New ArrayList(MetodosComunes.seleccionarConfigValue("TIPO_SERVICIO_CREACION_RUTA_RADICADO").Split(","))
                    If (arrTiposServicioCrearruta.Contains(objServicio.IdTipoServicio.ToString())) Then
                        'If objServicio.IdTipoServicio = Enumerados.TipoServicio.Reposicion Or objServicio.IdTipoServicio = Enumerados.TipoServicio.CampañaClaroFijo Then
                        arrEstadosCrearruta = New ArrayList(MetodosComunes.seleccionarConfigValue("ESTADOS_CREACION_RUTA_RADICADO").Split(","))
                        If arrEstadosCrearruta.Contains(objServicio.IdEstado.ToString()) Then
                            AdicionarRadicado(objServicio)
                            EnlazarRadicados()
                        Else
                            miEncabezado.showWarning("El Servicio con el número de radicado: [" & numRadicado.ToString() & "] no se encuentra en estado válido para asignarlo a la ruta.")
                        End If
                    Else
                        miEncabezado.showWarning("El Servicio con el número de radicado: [" & numRadicado.ToString() & "] no es de tipo Reposición.")
                    End If
                Else
                    miEncabezado.showWarning("El Servicio con el número de radicado: [" & numRadicado.ToString() & "] no pertence a la Bodega actual.")
                End If
            Else
                miEncabezado.showWarning("No se encontró el Servicio con el número de radicado: [" & numRadicado.ToString() & "]")
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub AdicionarRadicado(objServicio As ServicioMensajeria)
        Dim bValido As Boolean
        Dim fechaAgenda As New Date
        Dim idJornada As Short

        Try
            If Radicados.Count > 0 Then
                For Each radicado As ServicioMensajeria In Radicados
                    If fechaAgenda = Date.MinValue Or idJornada = 0 Then
                        fechaAgenda = radicado.FechaAgenda
                        idJornada = radicado.IdJornada
                        Exit For
                    End If
                Next

                bValido = Not (objServicio.FechaAgenda <> fechaAgenda Or objServicio.IdJornada <> idJornada)
                If bValido Then
                    Radicados.Add(objServicio)
                    Session("listRadicado") = Radicados
                    miEncabezado.showSuccess("El Servicio con número de radicado: [" & objServicio.NumeroRadicado & "] se adiciono a la lista satisfactoriamente.")
                Else
                    miEncabezado.showWarning("El Servicio con número de radicado: [" & objServicio.NumeroRadicado & "] no se adiciono ya que no cumple con las condiciones de Fecha y Jornada de la lista de radicados.")
                End If
            Else
                Radicados.Add(objServicio)
                Session("listRadicado") = Radicados
                miEncabezado.showSuccess("El Servicio con número de radicado: [" & objServicio.NumeroRadicado & "] se adiciono a la lista satisfactoriamente.")
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub EnlazarRadicados()
        Try
            With gvRadicados
                .DataSource = Radicados
                .DataBind()
            End With
            btnCrearRuta.ClientEnabled = (Radicados.Count > 0)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtIdentificacion.Text = String.Empty
        txtIdentificacion.Focus()
        cmbZona.SelectedIndex = -1
        txtRadicado.Text = String.Empty

        Session.Remove("idAgenteServicio")
        Session.Remove("idZona")
        Session.Remove("listRadicado")
        Radicados = Nothing
        EnlazarRadicados()
    End Sub

    Private Sub DesvincularRadicado(numRadicado As Long)
        Dim objServicio As ServicioMensajeria
        Try
            For Each radicado As ServicioMensajeria In Radicados
                If radicado.NumeroRadicado = numRadicado Then
                    objServicio = radicado
                    Exit For
                End If
            Next
            If objServicio IsNot Nothing Then
                Radicados.Remove(objServicio)
                Session("listRadicado") = Radicados

                EnlazarRadicados()
                miEncabezado.showSuccess("El servicio con número de radicado [" & numRadicado & "] se desvinculo satisfactoriamente.")
            Else
                miEncabezado.showWarning("El servicio con número de radicado [" & numRadicado & "] no se encuentra registrado en la lista de servicios actual.")
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub ManejoControlesActivos()
        Dim bControles As Boolean = (Session("idAgenteServicio") Is Nothing)

        txtIdentificacion.ClientEnabled = bControles
        cmbZona.ClientEnabled = bControles
        btnProcesarRuta.ClientEnabled = bControles
    End Sub

    Private Sub RegistrarRuta()
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)
            Dim objRutaServicio As New RutaServicioMensajeriaRadicado()
            With objRutaServicio
                .IdResponsableEntrega = AgenteServicio
                .IdEstado = Enumerados.RutaMensajeria.Creada
                .IdUsuarioLog = idUsuario
                .TipoRuta = Enumerados.TipoRutaServicioMensajeria.EntregaCliente
                .IdZona = Zona
                .ListaServicios = ObtenerListaServicios()

                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                LimpiarFormulario()
                cargareporte("Reportes/VisorHojaRuta.aspx?id=" & objRutaServicio.IdRuta.ToString())
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al registrar la ruta, " & ex.Message)
        End Try
    End Sub
    Private Sub cargareporte(ByVal url As String)
        pcHojaRuta.ContentUrl = url
        pcHojaRuta.Modal = True
        pcHojaRuta.ShowHeader = True
        pcHojaRuta.ShowOnPageLoad = True
    End Sub

    Private Function ObtenerListaServicios() As List(Of Long)
        Dim listServicios As New List(Of Long)
        If Radicados.Count > 0 Then
            For Each radicado As ServicioMensajeria In Radicados
                listServicios.Add(radicado.IdServicioMensajeria)
            Next
        End If
        Return listServicios
    End Function

#End Region

End Class