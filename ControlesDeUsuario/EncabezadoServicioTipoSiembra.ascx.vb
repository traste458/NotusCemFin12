Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer

Public Class EncabezadoServicioTipoSiembra
    Inherits System.Web.UI.UserControl

#Region "Métodos Púbicos"

    Public Function CargarInformacionGeneralServicio(ByRef infoServicio As ServicioMensajeriaSiembra) As ResultadoProceso
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
                        lblObservacionDireccion.Text = .Observacion
                        lblGerencia.Text = .NombreGerencia
                        lblCoordinador.Text = .NombreCoordinador
                        lblConsultor.Text = .NombreConsultor
                        lblClienteClaro.Text = IIf(.ClienteClaro, "Sí", "No")
                        lblObservaciones.Text = .Observacion
                        lblJornada.Text = .Jornada
                        If .FechaAgenda <> Date.MinValue Then lblFechaAgenda.Text = .FechaAgenda
                    End With
                End With
            Else

                resultado.EstablecerMensajeYValor(1, "No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior.")
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de cargar información general del servicio. " & ex.Message)
            resultado.EstablecerMensajeYValor(2, "Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
        Return resultado
    End Function

#End Region

#Region "Métodos Privados"


#End Region

End Class