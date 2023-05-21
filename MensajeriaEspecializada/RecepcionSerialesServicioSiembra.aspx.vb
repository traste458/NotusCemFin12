Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class RecepcionSerialesServicioSiembra
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
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Recepción Seriales Servicio SIEMBRA")
            End With
            HabilitarLecturaSerial(False)
        Else
            If IdServicio > 0 Then HabilitarLecturaSerial(True)
        End If
    End Sub

    Private Sub cpRecepcion_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRecepcion.Callback
        Try
            Dim arrParametros() As String = e.Parameter.Split("|")

            Select Case arrParametros(0)
                Case "buscarServicio"
                    Integer.TryParse(arrParametros(1), IdServicio)
                    BuscarServicio(CLng(arrParametros(1)))

                Case "recibirSerial"
                    RecibirSerial(arrParametros(1).ToString())

                Case "cerrarServicio"
                    CerrarServicio(CLng(arrParametros(1).ToString()))
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

    Private Sub BuscarServicio(ByVal idServicio As Long)
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(idServicio:=idServicio)
            If objServicio.Registrado Then
                If objServicio.IdTipoServicio = Enumerados.TipoServicio.Siembra Then
                    HabilitarLecturaSerial(True)
                    miEncabezado.showSuccess("Por favor inicie la lectura de seriales.")
                Else
                    HabilitarLecturaSerial(False)
                    miEncabezado.showWarning("El número de servicio no corresponde a un servicio de tipo Siembra.")
                End If
            Else
                HabilitarLecturaSerial(False)
                miEncabezado.showWarning("El número de servicio proporcionado no se encuentra registrado en el sistema.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar buscar el servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub HabilitarLecturaSerial(ByVal habilitar As Boolean)
        rpSeriales.ClientVisible = habilitar
        rpDetalleSeriales.ClientVisible = habilitar
        If habilitar Then
            txtSerial.Focus()

            Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleSerial
                .IdServicio = IdServicio
                .IdEstadoSerial = Enumerados.EstadoSerialCEM.EnTransitoABodega
                .CargarDatos()
            End With

            With gvSeriales
                .DataSource = objDetalleSerial
                .DataBind()
            End With

            'Detalle de los seriales del Servicio
            Dim objInfoDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objInfoDetalleSerial
                .IdServicio = IdServicio
                .CargarDatos()
            End With

            With gvInfoSeriales
                .DataSource = objInfoDetalleSerial
                .DataBind()
            End With

            'Se valida si se puede cerrar el servicio
            Dim cantSeriales As Integer
            Dim cantNoConf As Integer
            Dim cantConfRecibidos As Integer


            Dim dtSeriales As DataTable = objInfoDetalleSerial.GenerarDataTable()
            cantSeriales = dtSeriales.Rows.Count
            cantNoConf = dtSeriales.Compute("Count(IdDetalle)", "IdEstadoDevolucion <> 206")
            cantConfRecibidos = dtSeriales.Compute("Count(IdDetalle)", "IdEstadoSerial = 9 AND IdEstadoDevolucion = 206")

            btnCerrarServicio.ClientEnabled = (cantConfRecibidos + cantNoConf >= cantSeriales)
        End If
    End Sub

    Private Sub RecibirSerial(ByVal serial As String)
        Dim resultado As ResultadoProceso
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(IdServicio:=IdServicio)
            resultado = objServicio.RecibirSerial(serial)

            If resultado.Valor = 0 Or resultado.Valor = 10 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                HabilitarLecturaSerial(True)
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar recibir el serial: " & ex.Message)
        End Try
    End Sub

    Private Sub CerrarServicio(ByVal idServicio As Long)
        Dim idUsuario As Integer
        Dim resultado As New ResultadoProceso
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            Dim obServicio As New ServicioMensajeriaSiembra(idServicio:=idServicio)
            With obServicio
                .IdEstado = Enumerados.EstadoServicio.Cerrado
                .IdUsuarioCierre = idUsuario
                .FechaCierre = Date.Now
                resultado = .Actualizar(idUsuario)
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Servicio cerrado de forma exitosa.")
                HabilitarLecturaSerial(False)
            Else
                miEncabezado.showWarning("No fue posible realizar el cierre del servicio: " & resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

#End Region

End Class