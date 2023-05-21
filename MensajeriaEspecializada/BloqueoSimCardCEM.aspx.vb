Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario

Partial Public Class BloqueoSimCardCEM
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _idUsuario As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Bloqueo Seriales CEM (ICCID)")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                txtIccid.Focus()
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub lbBloqueo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBloqueo.Click
        ValidarDatos()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub ValidarDatos()
        Dim resultado As New List(Of ResultadoProceso)
        Dim validar As New DetalleBloqueoSerialServicioMensajeria
        Dim idBodega As Integer
        Try
            With validar
                .Iccid = txtIccid.Text.Trim
                .NumeroRadicado = txtRadicado.Text.Trim
            End With
            resultado = validar.ValidarDatos
            If resultado.Count = 0 Then
                idBodega = validar.IdBodega
                BloquearSerial(idBodega)
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    mensajeRespuesta = mensaje.Mensaje
                Next
                epNotificacion.showError(mensajeRespuesta)
            End If
        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error al validar los datos:" & ex.Message)
        End Try
    End Sub

    Private Sub BloquearSerial(ByVal idBodega As Integer)
        Dim objBloqueoInventario As New BloqueoInventario()

        Try
            With objBloqueoInventario
                .IdBodega = idBodega
                .FechaRegistro = Nothing
                .IdUsuario = _idUsuario
                .IdEstado = Enumerados.InventarioBloqueo.Confirmado
                .FechaInicio = Now()
                .FechaFin = Nothing
                .IdUnidadNegocio = Enumerados.UnidadNegocio.MensajeriaEspecializada
                .IdDestinatario = Nothing
                .IdTipoBloqueo = Enumerados.TipoBloqueo.ReservadeInventario
                .Observacion = "Bloqueo generado por activación en poliedro"
            End With

            Dim detalleSerial As New DetalleSerialBloqueo
            detalleSerial.Serial = txtIccid.Text.Trim
            objBloqueoInventario.SerialBloqueoColeccion.Adicionar(detalleSerial)
            Dim resultado As ResultadoProceso = objBloqueoInventario.Registrar()
            If resultado.Valor = 0 Then
                RegistrarBloqueoServicio(objBloqueoInventario.IdBloqueo)
            Else
                epNotificacion.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            epNotificacion.showError("Se presentaron errores al realizar el bloqueo del serial: " & ex.Message)
        End Try

    End Sub

    Private Sub LimpiarControles()
        txtIccid.Text = ""
        txtRadicado.Text = ""
        txtIccid.Focus()
    End Sub

    Private Sub RegistrarBloqueoServicio(ByVal idBloqueo As Integer)
        Dim resultado As New List(Of ResultadoProceso)
        Dim registrar As New DetalleBloqueoSerialServicioMensajeria
        Try
            With registrar
                .Iccid = txtIccid.Text.Trim
                .NumeroRadicado = txtRadicado.Text.Trim
                .IdBloqueo = idBloqueo
            End With
            resultado = registrar.RegistrarDatos
            If resultado.Count = 0 Then
                epNotificacion.showSuccess("Se realizo el bloqueo del ICCID satifactoriamente")
                LimpiarControles()
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    mensajeRespuesta = mensaje.Mensaje
                Next
                epNotificacion.showError(mensajeRespuesta)
            End If
        Catch ex As Exception
            epNotificacion.showError("Se presentaron errores al registrar el bloqueo del servicio: " & ex.Message)
        End Try
    End Sub

#End Region

End Class