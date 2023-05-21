Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer

Public Class EncabezadoServicioMensajeria
    Inherits System.Web.UI.UserControl

#Region "Métodos Púbicos"

    Public Function CargarInformacionGeneralServicio(ByRef infoServicio As ServicioMensajeria) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            If Not infoServicio Is Nothing AndAlso infoServicio.Registrado Then
                With infoServicio
                    lblNumRadicado.Text = .NumeroRadicado.ToString
                    lblCodigoRadicado.Text = "*" & .NumeroRadicado.ToString & "*"
                    lblEjecutor.Text = .UsuarioEjecutor
                    lblTipoServicio.Text = .TipoServicio
                    lblEstado.Text = .Estado
                    lblNombreCliente.Text = .NombreCliente
                    lblIdentificacion.Text = .IdentificacionCliente
                    lblDireccion.Text = .Direccion
                    lblBarrio.Text = .Barrio
                    lblCiudad.Text = .Ciudad
                    lblTelefono.Text = .TelefonoContacto
                    If Not String.IsNullOrEmpty(.ExtensionContacto) Then lblExtension.Text = " ext. " & .ExtensionContacto
                    lblPersonaContacto.Text = .PersonaContacto
                    If .FechaAgenda > Date.MinValue Then lblFechaAgenda.Text = .FechaAgenda.ToShortDateString()
                    lblJornada.Text = .Jornada
                    If .FechaConfirmacion > Date.MinValue Then lblFechaConfirmacion.Text = .FechaConfirmacion
                    lblUsuarioConfirma.Text = .UsuarioConfirmacion
                    lblBodega.Text = .Bodega
                    lblObservacion.Text = .Observacion
                    If .FechaDespacho > Date.MinValue Then lblFechaDespacho.Text = .FechaDespacho
                    lblUsuarioDespacho.Text = .UsuarioDespacho
                    If .FechaCambioServicio > Date.MinValue Then lblFechaCambioServicio.Text = .FechaCambioServicio
                    lblZona.Text = .NombreZona
                    lblResponsableEntrega.Text = .ResponsableEntrega
                    If .FechaCambioServicio > Date.MinValue Then lblFechaCambioServicio.Text = .FechaCambioServicio
                    If .FechaRegistro > Date.MinValue Then lblFechaRegistro.Text = .FechaRegistro
                    If .FechaCierre > Date.MinValue Then lblFechaEntrega.Text = .FechaCierre
                    lblRegistradoPor.Text = .UsuarioRegistra
                    lblPrioridad.Text = .Prioridad
                    If .MedioEnvioCH <> String.Empty Then lblMedioEnvioCH.Text = IIf(.MedioEnvioCH = "F", "Físico", "Correo Electrónico")
                    lblCorreoElectronicoCH.Text = .CorreoEnvioCH
                    lblClienteVIP.Text = IIf(.ClienteVIP, "VIP", "")
                    lblActividadLaboral.Text = .ActividadLaboral
                    lblCampania.Text = .Campania
                    lbFactura.Text = .FacturaCambioServicio
                    resultado.EstablecerMensajeYValor(0, "Proceso éxitoso.")
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

End Class