Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class RecepcionEquiposServicioTecnico
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epEncabezado.clear()
        If Not IsPostBack Then
            With epEncabezado
                .setTitle("Recepción de equipos de Servicio Técnico")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
        End If
    End Sub

    Private Sub lbProcesarRadicado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbProcesarRadicado.Click
        ProcesarRadicado()
    End Sub

    Private Sub gvIMEIS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvIMEIS.RowDataBound
        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                If CInt(e.Row.DataItem("idEstadoSerial")) = 0 Then
                    e.Row.BackColor = Color.LightCoral
                Else
                    e.Row.BackColor = Color.LightGreen
                End If
            End If
        Catch : End Try
    End Sub

    Private Sub lbRecibirImei_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRecibirImei.Click
        CargarImeis()
    End Sub

    Private Sub lbGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbGuardar.Click
        Guardar()
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
            Dim dtInfoRadicadoRuta As DataTable = HerramientasMensajeria.ObtenerInfoRadicadosEnRutasActivas(numRadicado:=CLng(txtNumeroRadicado.Text))

            If dtInfoRadicadoRuta.Rows.Count = 0 Then
                If dtImeis.Rows.Count > 0 Then
                    If (dtImeis.Select("idEstadoSerial=0").Length > 0) Then
                        Dim dtDatosRecepcion As DataTable = HerramientasMensajeria.ObtenerInfoEquiposRecibidosST(numRadicado:=CLng(txtNumeroRadicado.Text))
                        lbImeisRecibidos.Text = dtDatosRecepcion.Rows(0).Item("cantidadRecibida").ToString()

                        With gvIMEIS
                            .DataSource = dtImeis
                            .DataBind()
                        End With

                        pnlRadicado.Enabled = False
                        txtImei.Text = String.Empty
                        pnlRegistarImei.Visible = True
                        pnlImeis.Visible = True
                    Else
                        Guardar()
                    End If
                Else
                    pnlRadicado.Enabled = True
                    txtNumeroRadicado.Text = String.Empty
                    pnlRegistarImei.Visible = False
                    pnlImeis.Visible = False
                    epEncabezado.showWarning("No se encontraron IMEIs relacionados al radicado ingresado.<br />Por favor verifique el número y estado del radicado.")
                End If
            Else
                epEncabezado.showWarning("El radicado [" & txtNumeroRadicado.Text & "] se ecuentra asociado a una ruta activa, por favor verifique e intente nuevamente.")
            End If
        Catch ex As Exception
            epEncabezado.showError("Error al tratar de enlazar IMEIS: " & ex.Message)
        End Try
    End Sub

    Private Sub Guardar()
        Try
            Dim idUsuario As Integer = 0
            Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objServicio As New ServicioMensajeria(numeroRadicado:=CLng(txtNumeroRadicado.Text))
            With objServicio
                .IdEstado = Enumerados.EstadoServicio.RecibidoCliente
                .Actualizar(idUsuario)
            End With

            'Se registra novedad automática, cuándo la cantidad de equipos recibidos no es igual a la registrada.
            epEncabezado.clear()
            
            If (CType(Session("dtDatos"), DataTable).Select("recibido=1").Length < CType(Session("dtDatos"), DataTable).Rows.Count) Then
                Dim objNovedad As New NovedadServicioMensajeria()
                With objNovedad
                    .IdServicioMensajeria = New ServicioMensajeria(numeroRadicado:=CLng(txtNumeroRadicado.Text)).IdServicioMensajeria
                    .Observacion = "La cantidad recibida de IMEIs para reparación, es inferior a la cantidad registrada en el radicado."
                    .IdTipoNovedad = Enumerados.TipoNovedadMensajeria.RecepcionIncompletaST
                    .Registrar(idUsuario)
                End With
                epEncabezado.showWarning("Se realizó la recepción de los IMEIs, se generó novedad automática.")
            Else
                epEncabezado.showSuccess("Se realizó correctamente la recepción de los IMEIs asociados al Servicio Técnico.")
            End If

            pnlRadicado.Enabled = True
            pnlRegistarImei.Visible = False
            pnlImeis.Visible = False
        Catch ex As Exception
            epEncabezado.showError("Error al guardar recepción: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarImeis()
        Dim idUsuario As Integer = 0
        Dim resultado As New ResultadoProceso()
        Dim dtDatos As New DataTable()

        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            If Session("dtDatos") IsNot Nothing Then
                dtDatos = CType(Session("dtDatos"), DataTable)
            Else
                dtDatos = GeneraEstructuraIMEIS()
            End If

            Dim drImeis As DataRow() = dtDatos.Select("Serial='" & txtImei.Text & "'")
            If drImeis.Length > 0 Then
                If CInt(drImeis(0).Item("idEstadoSerial").ToString()) = 0 Then
                    Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
                    With objDetalleSerial
                        .IdDetalle = CLng(drImeis(0).Item("idDetalle").ToString())
                        .CargarDatos()
                    End With

                    objDetalleSerial(0).IdEstadoSerial = Enumerados.EstadoSerialCEM.RecibidoCliente
                    resultado = objDetalleSerial(0).Actualizar(idUsuario)

                    If resultado.Valor = 0 Then
                        EnlazarImeis()
                        epEncabezado.showSuccess("Se recibio correctamente el IMEI.")
                    Else
                        epEncabezado.showWarning("El IMEI ingresado no se logro registrar: " & resultado.Mensaje)
                    End If
                Else
                    epEncabezado.showWarning("El IMEI ingresado ya se encuentra recibido.")
                End If
            Else
                epEncabezado.showWarning("El IMEI ingresado no se encuentra relacionado al Servicio Técnico.")
            End If
        Catch ex As Exception
            epEncabezado.showError("Error al cargar IMEIs: " & ex.Message)
        End Try
    End Sub


    Private Function GeneraEstructuraIMEIS() As DataTable
        Dim dtDatos As New DataTable()
        Try
            Dim objDetalleSerial As New DetalleSerialServicioMensajeriaColeccion()
            With objDetalleSerial
                .NumeroRadicado = CLng(txtNumeroRadicado.Text)
                .idEstadoServicio = Enumerados.EstadoServicio.Transito
                .CargarDatosRadicadoEstado()
            End With
            dtDatos = objDetalleSerial.GenerarDataTable()

            'Se crea el campo recibido a partir del idEstadoSerial
            With dtDatos
                .Columns.Add(New DataColumn("recibido", GetType(Boolean)))
                .Columns("recibido").ReadOnly = False
                For Each fila As DataRow In .Rows
                    fila("recibido") = (CInt(fila("idEstadoSerial")) = 1)
                Next
                .AcceptChanges()
            End With

            Session("dtDatos") = dtDatos
        Catch ex As Exception
            epEncabezado.showError("Error al generar estructura: " & ex.Message)
        End Try
        Return dtDatos
    End Function

#End Region

End Class