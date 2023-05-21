Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class RegistroSalidaLlegadaRuta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _tipoRegistro As Short

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()

#If DEBUG Then
        Session("usxp001") = 34203
        Session("usxp009") = 139
        Session("usxp007") = 150
#End If

        If Not IsPostBack Then
            If Request.QueryString("tipo") IsNot Nothing Then
                _tipoRegistro = CShort(Request.QueryString("tipo"))
                Session("tipoRegistro") = _tipoRegistro

                'txtIdentificacion.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
                txtIdRuta.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            Else
                epNotificacion.showWarning("Imposible obtener el tipo de registro, por favor intente nuevamente.")
                pnlPrincipal.Enabled = False
            End If
        Else
            _tipoRegistro = Session("tipoRegistro")
        End If

        With epNotificacion
            .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            If _tipoRegistro = 1 Then
                .setTitle("Registro de Salida de Rutas.")
            ElseIf _tipoRegistro = 2 Then
                .setTitle("Registro de Llegada de Rutas.")
            End If
        End With
    End Sub

    Protected Sub lbRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbRegistrar.Click
        RegistrarMovimiento()
    End Sub

#End Region

#Region "Métodos"

    Private Sub RegistrarMovimiento()
        Try
            Dim detalleRuta As New RutaServicioMensajeria(CInt(txtIdRuta.Text))
            Dim idUsuario As Integer = 1

            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            ' If detalleRuta.IdentificacionResponsable = txtIdentificacion.Text Then
            Select Case _tipoRegistro
                    Case 1 'Salida
                        With detalleRuta
                            .IdEstado = Enumerados.RutaMensajeria.Reparto
                            .IdUsuarioLog = idUsuario
                            .FechaSalida = Now()
                            .TipoRuta = detalleRuta.TipoRuta
                        End With

                        Dim resultado As ResultadoProceso = detalleRuta.Actualizar()
                        If resultado.Valor = 0 Then
                            epNotificacion.showSuccess("Se registro correctamente la Salida de la ruta: " & txtIdRuta.Text)
                            LimpiarFormulario()
                        Else
                            epNotificacion.showWarning("Imposible registrar salida de ruta: " & resultado.Mensaje)
                        End If

                    Case 2 'Llegada
                        detalleRuta.IdEstado = Enumerados.RutaMensajeria.Cerrado
                        detalleRuta.IdUsuarioLog = idUsuario
                        detalleRuta.FechaCierre = Now()

                        Dim resultado As ResultadoProceso = detalleRuta.Actualizar()
                        If resultado.Valor = 0 Then
                            epNotificacion.showSuccess("Se registro correctamente la Llegada de la ruta: " & txtIdRuta.Text)
                            LimpiarFormulario()
                        Else
                            epNotificacion.showWarning("Imposible registrar llegada de ruta: " & resultado.Mensaje)
                        End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
                'Else
            'epNotificacion.showWarning("El número de ruta ingresado, no se encuentra asignado al responsable seleccionado.")
            'End If
        Catch ex As Exception
            epNotificacion.showError("Imposible registrar el movimiento: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        Try
            'txtIdentificacion.Text = ""
            txtIdRuta.Text = ""
            'txtIdentificacion.Focus()
        Catch : End Try
    End Sub

#End Region

End Class