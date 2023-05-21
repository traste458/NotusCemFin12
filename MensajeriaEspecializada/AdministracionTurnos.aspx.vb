Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class AdministracionTurnos
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración de Horarios")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub gvTurnos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvTurnos.CustomCallback
        BuscarHorarios()
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvTurnos_DataBinding(sender As Object, e As System.EventArgs) Handles gvTurnos.DataBinding
        gvTurnos.DataSource = Session("dtDatosHorarios")
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)

            'La visualización es visible para todos
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        AdicionarTurno()
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarHorarios()
        Try
            Dim objHorarios As New HorarioVentaColeccion()
            With objHorarios
                If cmbJornadaFiltro.Value IsNot Nothing Then .IdJornada = cmbJornadaFiltro.Value
                .Activo = chbEstadoFiltro.Checked
            End With

            With gvTurnos
                .DataSource = objHorarios.GenerarDataTable()
                Session("dtDatosHorarios") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        Try
            'Jornadas
            MetodosComunes.CargarComboDX(cmbJornada, HerramientasMensajeria.ConsultaJornadaMensajeria(), "idJornada", "nombre")
            MetodosComunes.CargarComboDX(cmbJornadaFiltro, HerramientasMensajeria.ConsultaJornadaMensajeria(), "idJornada", "nombre")
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar los valores iniciales: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarTurno()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objHorario As New HorarioVenta()
            With objHorario
                .IdJornada = cmbJornada.Value
                .HoraInicial = New TimeSpan(timeHoraInicio.DateTime.Hour, timeHoraInicio.DateTime.Minute, timeHoraInicio.DateTime.Second)
                .HoraFinal = New TimeSpan(timeHoraFin.DateTime.Hour, timeHoraFin.DateTime.Minute, timeHoraFin.DateTime.Second)
                .Activo = chbActivo.Checked

                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Horario adicionado exitosamente.")
                LimpiarFormulario()
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar crear el Horario: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        Try
            cmbJornada.Value = Nothing
            timeHoraInicio.Value = Nothing
            timeHoraFin.Value = Nothing
            chbActivo.Checked = True
        Catch : End Try
    End Sub

#End Region

End Class