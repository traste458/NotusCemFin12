Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer

Public Class EncabezadoServicioTipoVentaCorporativa
    Inherits System.Web.UI.UserControl

#Region "Métodos Púbicos"

    Public Function CargarInformacionGeneralServicio(ByRef infoServicio As ServicioMensajeriaVentaCorporativa) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            If Not infoServicio Is Nothing AndAlso infoServicio.Registrado Then
                With infoServicio
                    With infoServicio
                        lblFechaSolicitud.Text = .FechaRegistro
                        lblEstado.Text = .Estado
                        lblCiudad.Text = .Ciudad
                        lblNombreEmpresa.Text = .NombreCliente
                        lblNumeroNit.Text = .IdentificacionCliente
                        lblTelefonoFijo.Text = .TelefonoContacto
                        lblNombreRepresentante.Text = .NombreRepresentanteLegal
                        lblNumeroIdentificacionRepresentante.Text = .IdentificacionRepresentanteLegal
                        lblTelefonoRepresentante.Text = .TelefonoRepresentanteLegal
                        lblPersonaAutorizada.Text = .PersonaContacto
                        lblNumeroIdentificacionAutorizado.Text = .IdentificacionAutorizado
                        lblTelefonoPersonaAutorizada.Text = .TelefonoAutorizado
                        lblCargoPersonaAutorizada.Text = .CargoAutorizado
                        lblBarrio.Text = .Barrio
                        lblDireccion.Text = .Direccion
                        lblObservacionDireccion.Text = .ObservacionDireccion
                        lblGerencia.Text = .NombreGerencia
                        lblCoordinador.Text = .NombreCoordinador
                        lblConsultor.Text = .NombreConsultor
                        If .ClienteClaro Then lblClienteClaro.Text = "Sí" Else lblClienteClaro.Text = "No"
                        lblObservaciones.Text = .Observacion
                        lblJornada.Text = .Jornada
                        If .FechaAgenda <> Date.MinValue Then lblFechaAgenda.Text = .FechaAgenda
                        If .FechaEntrega <> Date.MinValue Then lblFechaEntrega.Text = .FechaEntrega
                        lblFormaPago.Text = .FormaPago
                        lblTipoServicio.Text = .TipoServicio
                        If .FechaConfirmacion <> Date.MinValue Then lblFechaConfirmacion.Text = .FechaConfirmacion
                        lblConfirmadoPor.Text = .ConfirmadoPor
                        If .FechaDespacho <> Date.MinValue Then lblFechaDespacho.Text = .FechaDespacho
                        lblDespachoPor.Text = .DespachoPor
                        lblResponsableEntrega.Text = .ResponsableEntrega
                        lblZona.Text = .Zona
                        lblBodega.Text = .Bodega
                        If .Portacion Then lblPortacion.Text = "Sí" Else lblPortacion.Text = "No"
                        lblIdServicio.Text = .IdServicioMensajeria
                    End With
                End With

            Else

                resultado.EstablecerMensajeYValor(1, "No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior.")
            End If

            With gvReferencias
                .DataSource = infoServicio.DetalleServicio
                Session("objReferencias") = .DataSource
                .DataBind()
            End With

        Catch ex As Exception
            Throw New Exception("Error al tratar de cargar información general del servicio. " & ex.Message)
            resultado.EstablecerMensajeYValor(2, "Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
        Return resultado
    End Function

#End Region

#Region "Métodos Privados"
    Private Sub gvReferencias_DataBinding(sender As Object, e As System.EventArgs) Handles gvReferencias.DataBinding
        If Session("objReferencias") IsNot Nothing Then gvReferencias.DataSource = Session("objReferencias")
    End Sub
#End Region

End Class