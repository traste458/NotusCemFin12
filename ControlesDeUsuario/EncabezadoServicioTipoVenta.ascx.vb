Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports ILSBusinessLayer.CodeBar39

Public Class EncabezadoServicioTipoVenta
    Inherits System.Web.UI.UserControl

#Region "Métodos Púbicos"

    Public Function CargarInformacionGeneralServicio(ByRef infoServicio As ServicioMensajeriaVenta) As ResultadoProceso
        Dim resultado As New ResultadoProceso

        Try
            If Not infoServicio Is Nothing AndAlso infoServicio.Registrado Then
                With infoServicio
                    With infoServicio
                        lblIdServicio.Text = .IdServicioMensajeria
                        imgBarCode.ImageUrl = "../Handlers/Cod39Generator.ashx?code=" & .IdServicioMensajeria.ToString()
                        lblEstado.Text = .Estado
                        lblCiudadEntrega.Text = .Ciudad
                        lblCampania.Text = .NombreCampania
                        lblPlan.Text = .NombrePlanVenta
                        lblCFM.Text = .CfmPlan.ToString("c", New Globalization.CultureInfo("es-CO", False))
                        lblIdentificacionCliente.Text = .IdentificacionCliente
                        lblNombresCliente.Text = .NombreCliente
                        lblBarrio.Text = .Barrio
                        lblDireccion.Text = .Direccion
                        lblObservacionDireccion.Text = .ObservacionDireccion
                        lblTelefonoMovil.Text = .TelefonoContacto
                        lblTelefonoFijo.Text = .TelefonoFijo
                        lblFormaPago.Text = .NombreMedioPago
                        lblJornada.Text = .Jornada
                        If Not .FechaAgenda.Equals(Date.MinValue) Then
                            lblFechaAgenda.Text = .FechaAgenda.ToShortDateString()
                        End If
                        lblObservaciones.Text = .Observacion
                        lblFechaCreacion.Text = .FechaRegistro
                        If Not .FechaConfirmacion.Equals(Date.MinValue) Then
                            lblFechaConfirmacion.Text = .FechaConfirmacion
                        End If

                    End With

                    resultado = CargarDetalleDeReferencias(.IdServicioMensajeria)
                    resultado = CargarDetalleDeMsisdn(.IdServicioMensajeria)
                End With
            Else
                rpRegistros.Enabled = False
                rpEquipos.Enabled = False
                rpMins.Enabled = False

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

    Private Function CargarDetalleDeReferencias(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            With gvListaReferencias
                .DataSource = dtAux
                .DataBind()
            End With
            resultado.EstablecerMensajeYValor(0, "Cargue de referencias exitoso.")
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(1, "Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Function CargarDetalleDeMsisdn(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim detalleMsisdn As New DetalleMsisdnEnServicioMensajeriaColeccion(idServicio)
            With gvListaMsisdn
                .DataSource = detalleMsisdn.GenerarDataTable()
                .DataBind()
            End With
            resultado.EstablecerMensajeYValor(0, "Cargue de MSISDNs exitoso.")
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(1, "Error al tratar de obtener el listado de MSISDNs asignados al servicio.  " & ex.Message)
        End Try
        Return resultado
    End Function

#End Region

End Class