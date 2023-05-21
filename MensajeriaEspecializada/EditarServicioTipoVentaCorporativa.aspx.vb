Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario
Imports ILSBusinessLayer.Productos
Imports System.Text
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes

Public Class EditarServicioTipoVentaCorporativa
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
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack And Not IsCallback Then
            If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, IdServicio)
            If _idServicio > 0 Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Edición Servicio Venta Corporativa")
                End With
                CargaInicial(IdServicio)
                CargarNovedades(IdServicio)
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If

    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim arrayAccion As String()
        Dim resultado As New ResultadoProceso
        arrayAccion = e.Parameter.Split(":")
        Try
            Select Case arrayAccion(0)
                Case "ActualizarServicio"
                    resultado = ActualizarServicio(IdServicio)
                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess("El servicio fue actualizado satisfactoriamente. ")
                    Else
                        miEncabezado.showWarning(resultado.Mensaje)
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        CType(sender, ASPxCallbackPanel).JSProperties("cpResultado") = resultado.Valor
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeriaVentaCorporativa
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            infoServicio = New ServicioMensajeriaVentaCorporativa(idServicio)

            If infoServicio.Registrado Then
                With infoServicio
                    Session("infoServicioMensajeria") = infoServicio
                    CargarInformacionGeneralServicio(infoServicio)
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            'Se valida si tiene novedades sin gestionar
            Dim objNovedades As New NovedadServicioMensajeriaColeccion(IdServicio:=idServicio, idEstadoNovedad:=Enumerados.EstadoNovedadMensajeria.Registrado, idProceso:=Enumerados.ProcesoMensajeria.Confirmacion)
            imgRegistro.ClientVisible = (objNovedades.Count = 0)
            divMensaje.Visible = (objNovedades.Count <> 0)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la Cargar de Novedades de datos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionGeneralServicio(ByRef infoServicio As ServicioMensajeriaVentaCorporativa)
        Try
            If Not infoServicio Is Nothing AndAlso infoServicio.Registrado Then
                With infoServicio
                    With infoServicio
                        If .FechaRegistro > Date.MinValue Then
                            lblFechaSolicitud.Text = .FechaRegistro
                        End If
                        lblEstado.Text = .Estado
                        lblCiudad.Text = .Ciudad
                        lblNombreEmpresa.Text = .NombreCliente
                        lblNumeroNit.Text = .IdentificacionCliente
                        lblTelefonoFijo.Text = .TelefonoContacto
                        lblNombreRepresentante.Text = .NombreRepresentanteLegal
                        lblNumeroIdentificacionRepresentante.Text = .IdentificacionRepresentanteLegal
                        lblTelefonoRepresentante.Text = .TelefonoRepresentanteLegal
                        txtPersonaAutorizada.Text = .PersonaContacto
                        txtIdentificacionAutorizado.Text = .IdentificacionAutorizado
                        lblTelefonoPersonaAutorizada.Text = .TelefonoAutorizado
                        txtCargoPersonaAutorizada.Text = .CargoAutorizado
                        txtBarrio.Text = .Barrio
                        asDireccion.value = .Direccion
                        Session("direccion") = .Direccion
                        asDireccion.DireccionEdicion = .DireccionEdicion
                        lblObservacionDireccion.Text = .ObservacionDireccion
                        lblGerencia.Text = .NombreGerencia
                        lblCoordinador.Text = .NombreCoordinador
                        lblConsultor.Text = .NombreConsultor
                        If .ClienteClaro Then lblClienteClaro.Text = "Sí" Else lblClienteClaro.Text = "No"
                        lblFormaPago.Text = .FormaPago
                        lblTipoServicio.Text = .TipoServicio
                        If .FechaConfirmacion > Date.MinValue Then
                            lblFechaConfirmacion.Text = .FechaConfirmacion
                        End If
                        If .FechaEntrega > Date.MinValue Then
                            lblFechaEntrega.Text = .FechaEntrega
                        End If
                        lblConfirmadoPor.Text = .ConfirmadoPor
                        lblFechaDespacho.Text = .FechaDespacho
                        lblDespachoPor.Text = .DespachoPor
                        lblResponsableEntrega.Text = .ResponsableEntrega
                        lblZona.Text = .Zona
                        lblBodega.Text = .Bodega
                        lblIdServicio.Text = .IdServicioMensajeria
                        If .FechaAgenda > Date.MinValue Then
                            lblFechaAgenda.Text = .FechaAgenda
                        End If
                        lblJornadaEntrega.Text = .Jornada
                    End With
                End With
            Else
                miEncabezado.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior.")
            End If

        Catch ex As Exception
            Throw New Exception("Error al tratar de cargar información general del servicio. " & ex.Message)
            miEncabezado.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Function ActualizarServicio(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa

        With miServicio
            .IdServicioMensajeria = idServicio
            .IdUsuario = CInt(Session("usxp001"))
            .Direccion = asDireccion.value
            .DireccionEdicion = asDireccion.DireccionEdicion
            .PersonaContacto = txtPersonaAutorizada.Text
            .IdentificacionAutorizado = txtIdentificacionAutorizado.Text.Trim
            .CargoAutorizado = txtCargoPersonaAutorizada.Text
            .Barrio = txtBarrio.Text
            resultado = .Editar()
        End With
        Return resultado
    End Function

#End Region

End Class