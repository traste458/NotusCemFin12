Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class RecepcionSerialesPrestamoServicio
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epEncabezado.clear()
        If Not IsPostBack Then
            With epEncabezado
                .setTitle("Recepción de seriales préstamo de Servicio Técnico")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
        End If
    End Sub

    Private Sub lbProcesarRadicado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbProcesarRadicado.Click
        ProcesarRadicado()
    End Sub

    Private Sub lbRecibirImei_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRecibirImei.Click
        RecibirIMEIPrestamo()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub ProcesarRadicado()
        Try
            EnlazarImeis()
        Catch ex As Exception
            epEncabezado.showError("Error al procesar radicado: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarImeis()
        Try
            Dim dtImeis As DataTable = GeneraEstructuraIMEIS()
            Dim dvImeis As DataView = dtImeis.DefaultView
            With dvImeis
                .RowFilter = "idEstadoSerial=6 AND requierePrestamoEquipo=1"
            End With

            If dtImeis.Rows.Count > 0 Then
                If (dvImeis.Count > 0) Then
                    With gvIMEIS
                        .DataSource = dvImeis.ToTable()
                        .DataBind()
                    End With

                    pnlRadicado.Enabled = False
                    txtImei.Text = String.Empty
                    pnlRegistarImei.Visible = True
                    pnlImeis.Visible = True
                Else
                    pnlRadicado.Enabled = True
                    txtNumeroRadicado.Text = String.Empty
                    pnlRegistarImei.Visible = False
                    pnlImeis.Visible = False
                    epEncabezado.showWarning("Se realizó la recepción total de los seriales de préstamo.")
                End If
            Else
                pnlRadicado.Enabled = True
                txtNumeroRadicado.Text = String.Empty
                pnlRegistarImei.Visible = False
                pnlImeis.Visible = False
                epEncabezado.showWarning("No se encontraron IMEIs de préstamo relacionados al radicado ingresado.<br />Por favor verifique el número y estado del radicado.")
            End If
        Catch ex As Exception
            epEncabezado.showError("Error al tratar de enlazar IMEIS: " & ex.Message)
        End Try
    End Sub

    Private Sub RecibirIMEIPrestamo()
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleSerial
                .NumeroRadicado = CLng(txtNumeroRadicado.Text)
                .SerialPrestamo = txtImei.Text
                .CargarDatos()
            End With

            If objDetalleSerial.Count > 0 Then
                Dim objDetalleBloqueoSerial As New Inventario.DetalleSerialBloqueoColeccion()
                With objDetalleBloqueoSerial
                    .Adicionar(New Inventario.DetalleSerialBloqueo(txtImei.Text))
                End With

                Dim objBloqueo As New Inventario.BloqueoInventario()
                With objBloqueo
                    Dim resultado As ResultadoProceso = .DesbloquearSerial(objDetalleBloqueoSerial)
                    If resultado.Valor = 0 Then
                        For Each serial As DetalleSerialServicioMensajeria In objDetalleSerial
                            serial.IdEstadoSerial = Enumerados.EstadoSerialCEM.SerialPrestamoLiberado
                            serial.Actualizar(idUsuario)
                        Next
                        epEncabezado.showSuccess(resultado.Mensaje)
                        EnlazarImeis()
                    Else
                        epEncabezado.showWarning(resultado.Mensaje)
                    End If
                End With
            Else
                epEncabezado.showWarning("El serial [" & txtImei.Text & "] no se encuentra relacionado al radicado.")
            End If
        Catch ex As Exception
            epEncabezado.showError("Se generó error al recibir el IMEI: " & ex.Message)
        End Try
    End Sub


    Private Function GeneraEstructuraIMEIS() As DataTable
        Dim dtDatos As New DataTable()
        Try
            Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleSerial
                .NumeroRadicado = CLng(txtNumeroRadicado.Text)
                .idEstadoServicio = Enumerados.EstadoServicio.Entregado
                .CargarDatos()
            End With
            dtDatos = objDetalleSerial.GenerarDataTable()
            Session("dtDatos") = dtDatos
        Catch ex As Exception
            epEncabezado.showError("Error al generar estructura: " & ex.Message)
        End Try
        Return dtDatos
    End Function

#End Region

End Class