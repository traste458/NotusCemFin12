Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class EditarHorarioVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idHorario As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            If Request.QueryString("idHorario") IsNot Nothing Then Integer.TryParse(Request.QueryString("idHorario").ToString, _idHorario)
            If _idHorario > 0 Then
                With miEncabezado
                    .setTitle("Modificar Horario")
                End With
                Session("idHorario") = _idHorario
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idHorario") IsNot Nothing Then _idHorario = Session("idHorario")
        End If
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        ActualizarHorario()
        CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Carga las Jornadas
            MetodosComunes.CargarComboDX(cmbJornada, HerramientasMensajeria.ConsultaJornadaMensajeria(), "idJornada", "nombre")

            'Carga la información del horario
            Dim objHorario As New HorarioVenta(idHorario:=_idHorario)
            With objHorario
                cmbJornada.Value = CInt(.IdJornada)
                timeHoraInicio.Value = New DateTime(Date.MinValue.Year, Date.MinValue.Month, Date.MinValue.Day, .HoraInicial.Hours, .HoraInicial.Minutes, .HoraInicial.Seconds)
                timeHoraFin.Value = New DateTime(Date.MinValue.Year, Date.MinValue.Month, Date.MinValue.Day, .HoraFinal.Hours, .HoraFinal.Minutes, .HoraFinal.Seconds)
                chbActivo.Checked = .Activo
            End With
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarHorario()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objHorario As New HorarioVenta()
            With objHorario
                .IdHorario = _idHorario
                .IdJornada = cmbJornada.Value
                .HoraInicial = New TimeSpan(timeHoraInicio.DateTime.Hour, timeHoraInicio.DateTime.Minute, timeHoraInicio.DateTime.Second)
                .HoraFinal = New TimeSpan(timeHoraFin.DateTime.Hour, timeHoraFin.DateTime.Minute, timeHoraFin.DateTime.Second)
                .Activo = chbActivo.Checked

                resultado = .Actualizar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Horario actualizado exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar actualizar el registro: " & ex.Message)
        End Try
    End Sub

#End Region

End Class