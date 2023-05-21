Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes

Partial Public Class DevolucionServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _idUsuario As Integer
    Private _altoVentana As Integer
    Private _anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        ObtenerTamanoVentana()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Devolución de Radicados CEM")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                CargarTiposDeNovedad()
                CargarSucursalesFinancieras()
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub lbRegistrar_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbRegistrar.Click
        RegistrarDevolucion()
    End Sub

    Private Sub lbNovedad_Click(sender As Object, e As EventArgs) Handles lbNovedad.Click
        With dlgVerInformacionServicio
            .Width = Unit.Pixel(Me._anchoVentana * 0.65000000000000002)
            .Height = Unit.Pixel(Me._altoVentana * 0.63000000000000012)
            .ContentUrl = "RegistrarNovedadServicioMensajeria.aspx?flag=1"
            .Show()
        End With
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=7)
            With ddlNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad", "0"))
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarSucursalesFinancieras()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerSucursalesFinancieras()
            With ddlSucursal
                .DataSource = dtEstado
                .DataTextField = "sucursal"
                .DataValueField = "codigo"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Sucursal", "0"))
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarDevolucion()
        Dim resultado As New List(Of ResultadoProceso)
        Dim registrar As New DevolucionCEM
        Dim result As New ResultadoProceso
        Dim objServicio As New ServicioMensajeria(numeroRadicado:=txtNumeroRadicado.Text.Trim)
        Dim servicioNEBS As New NotusExpressBancolombiaService.NotusExpressBancolombiaService
        Dim resultMessage As String = "Se realizó el registro de la devolución satisfactoriamente."

        Try
            With registrar
                If rblTipoBusqueda.SelectedValue = 1 Then
                    .NumeroRadicado = txtNumeroRadicado.Text.Trim
                Else
                    .IdServicio = txtNumeroRadicado.Text.Trim
                End If

                If Not EsNuloOVacio(txtRuta.Text) Then .NumeroRuta = txtRuta.Text.Trim
                .IdNovedad = ddlNovedad.SelectedValue
                .IdUsuario = _idUsuario
                .CodigoSucursal = ddlSucursal.SelectedValue
            End With
            resultado = registrar.RegistrarDevolucion
            If (objServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                servicioNEBS.AsignacionNovedad(CInt(txtNumeroRadicado.Text), resultMessage)
            End If

            If resultado.Count = 0 Then
                epNotificacion.showSuccess(resultMessage)
                LimpiarFiltros()
                EnviarNotificacion(registrar.NumeroRadicado)
                If (objServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                    result = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, objServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Devolucion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (objServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda) Then
                    result = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, objServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Devolucion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (objServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                    result = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, objServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Devolucion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                End If
            Else
                Dim mensajeRespuesta As String = String.Empty
                For Each mensaje As ResultadoProceso In resultado
                    mensajeRespuesta &= mensaje.Mensaje & "<br />"
                Next
                epNotificacion.showWarning(mensajeRespuesta)
                LimpiarFiltros()
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar registrar la devolución: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtNumeroRadicado.Text = ""
        txtRuta.Text = ""
        ddlNovedad.SelectedIndex = -1
    End Sub

    Private Sub EnviarNotificacion(numRadicado As Long)
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(numRadicado)
            If objServicio.Registrado AndAlso objServicio.IdTipoServicio = Enumerados.TipoServicio.Siembra Then
                Dim objMail As New EMailManager(AsuntoNotificacion.Tipo.Notificación_Devolución_Servicio_Siembra, objServicio)
                With objMail
                    If Not String.IsNullOrEmpty(objServicio.EmailConsultor) Then .AdicionarDestinatario(objServicio.EmailConsultor)
                    .EnviarMail()
                End With
            End If
        Catch ex As Exception
            epNotificacion.showWarning("No se logró enviar notificación al Consultor: " & ex.Message)
        End Try
    End Sub

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me._altoVentana = CInt(arrAux(0))
                Me._anchoVentana = CInt(arrAux(1))
            End If
        End If
        If Me._altoVentana = 0 Then Me._altoVentana = 600
        If Me._anchoVentana = 0 Then Me._anchoVentana = 800
    End Sub

    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function

#End Region

End Class