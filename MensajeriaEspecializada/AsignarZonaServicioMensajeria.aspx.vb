Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports LMDataAccessLayer

Partial Public Class AsignarZonaServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idCiudad As Integer = 0
    Private _zonaDataTable As DataTable
    Private _zonaServicioMensajeriaDataTable As DataTable

    Private _tipoServicio As Integer
    Private _cedulaMotorizado As String

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()

        If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007"), _idCiudad)

        If Not Me.IsPostBack Then
            With epNotificador
                .setTitle("Asignar Zona - Servicio de Mensajer&iacute;a")
                .showReturnLink("PoolServiciosNew.aspx")
            End With

            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With

            If idServicio > 0 Then
                CargarInformacionGeneralServicio(idServicio)
                CargarDetalleDeReferencias(idServicio)

                _zonaDataTable = HerramientasMensajeria.ConsultaZona()
                CargarInformacionZona(idServicio)
            Else
                pnlGeneral.Enabled = False
                epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If        
    End Sub

    Protected Sub ddlZona_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlZona.SelectedIndexChanged
        _zonaServicioMensajeriaDataTable = HerramientasMensajeria.ConsultaZonaServicioMensajeria(Convert.ToInt32(ddlZona.SelectedValue), idCiudad:=_idCiudad)
        Dim vista As DataView = _zonaServicioMensajeriaDataTable.DefaultView()
        vista.RowFilter = "idZona=" & ddlZona.SelectedValue

        MetodosComunes.CargarDropDown(vista.ToTable(), CType(ddlRecurso, ListControl), "", True, "cedula", "nombreResponsable")
    End Sub

    Protected Sub lbGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGuardar.Click
        Dim enumeracion As New Enumerados.TipoServicio
        Dim resultado As New ResultadoProceso
        Dim idUsuario As Integer = 1
        Dim asm As New ActualizacionServicioMensajeria
        'notusEBS.AsignarMotorizado(, , )

        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

        Dim idServicio As Integer = Request.QueryString("idServicio")
        Dim arrValue As String() = ddlRecurso.SelectedItem.Text.Split("-")
        Dim idZona As Integer = CInt(ddlZona.SelectedValue)
        CargarInformacionGeneralServicio(idServicio)

        _cedulaMotorizado = ddlRecurso.SelectedValue
                        'se quita line que coloco ricardo Tienda virtual
                        '.SqlParametros.Add("@idEstado", SqlDbType.Int).Value = Enumerados.EstadoServicio.AsignadoRuta

        If String.IsNullOrEmpty(_cedulaMotorizado) Or _cedulaMotorizado = "0" Then
            epNotificador.showWarning("Debe seleccion un motorizado.")
            Return
        End If


        resultado = asm.ActualizaServicioMensajeria(idServicio, CInt(arrValue(0)), idZona,
                                        idUsuario, _cedulaMotorizado, arrValue(1), _tipoServicio)

        If resultado.Valor = 1 Then
            epNotificador.showSuccess(resultado.Mensaje)

        Else
            epNotificador.showError(resultado.Mensaje)
        End If

        'If _tipoServicio = enumeracion.ServiciosFinancierosBancolombia Then
        '    notusEBS.AsignarMotorizado(idServicio, arrValue(0), arrValue(1))
        'End If

        'Try
        '    If ddlZona.SelectedValue <> "0" Then
        '        'TODO: Cambiar funcionalidad, utilizar la calse
        '        Using dbManager As New LMDataAccess
        '            With dbManager
        '                Dim arrValue As String() = ddlRecurso.SelectedItem.Text.Split("-")

        '                .SqlParametros.Add("@idServicioMensajeria", SqlDbType.Int).Value = CInt(Request.QueryString("idServicio"))

        '                If ddlRecurso.SelectedValue <> "0" Then .SqlParametros.Add("@idResponsableEntrega", SqlDbType.Int).Value = CInt(arrValue(0))
        '                .SqlParametros.Add("@idZona", SqlDbType.Int).Value = CInt(ddlZona.SelectedValue)
        '                .SqlParametros.Add("@idUsuarioLog", SqlDbType.Int).Value = idUsuario
        '                'se quita line que coloco ricardo Tienda virtual
        '                '.SqlParametros.Add("@idEstado", SqlDbType.Int).Value = Enumerados.EstadoServicio.AsignadoRuta

        '                .EjecutarNonQuery("ActualizaServicioMensajeria", CommandType.StoredProcedure)
        '                'notusEBS.AsignarMotorizado();
        '                epNotificador.showSuccess("Asignación de zona y recurso realizada correctamente.")
        '            End With
        '        End Using
        '    Else
        '        epNotificador.showWarning("Debe seleccionar una Zona para el servicio.")
        '    End If
        'Catch ex As Exception
        '    epNotificador.showError("Error al tratar de asignar datos. " & ex.Message)
        'End Try

    End Sub

#End Region

#Region "Métodos"

    Private Sub CargarInformacionGeneralServicio(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria
        Try
            infoServicio = New ServicioMensajeria(idServicio)
            If infoServicio.Registrado Then
                With infoServicio
                    lblNumRadicado.Text = .NumeroRadicado.ToString
                    lblEjecutor.Text = .UsuarioEjecutor
                    lblTipoServicio.Text = .TipoServicio

                    _tipoServicio = .IdTipoServicio

                    lblNombreCliente.Text = .NombreCliente
                    lblIdentificacion.Text = .IdentificacionCliente
                    lblDireccion.Text = .Direccion
                    lblBarrio.Text = .Barrio
                    lblCiudad.Text = .Ciudad
                    lblTelefono.Text = .TelefonoContacto
                    lblPersonaContacto.Text = .PersonaContacto
                    If .FechaAgenda > Date.MinValue Then lblFechaAgenda.Text = .FechaAgenda.ToShortDateString()
                    lblJornada.Text = .Jornada
                    If .FechaConfirmacion > Date.MinValue Then lblFechaConfirmacion.Text = .FechaConfirmacion.ToShortDateString()
                    lblUsuarioConfirma.Text = .UsuarioConfirmacion
                    lblBodega.Text = .Bodega
                    lblObservacion.Text = .Observacion
                    Session("infoServicioMensajeria") = infoServicio
                End With
            Else
                epNotificador.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                pnlGeneral.Enabled = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar información general del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleDeReferencias(ByVal idServicio As Integer)
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            With gvListaReferencias
                .DataSource = dtAux
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionZona(ByVal idServicio As Integer)
        Dim infoServicio As ServicioMensajeria

        infoServicio = New ServicioMensajeria(idServicio)
        Try
            If infoServicio.Registrado Then

                MetodosComunes.CargarDropDown(_zonaDataTable, CType(ddlZona, ListControl))
                If infoServicio.IdZona > 0 Then
                    ddlZona.SelectedValue = infoServicio.IdZona

                    _zonaServicioMensajeriaDataTable = HerramientasMensajeria.ConsultaZonaServicioMensajeria(idCiudad:=_idCiudad)

                    Dim vista As DataView = _zonaServicioMensajeriaDataTable.DefaultView()
                    vista.RowFilter = "idZona=" & ddlZona.SelectedValue

                    If vista.Count > 0 Then
                        MetodosComunes.CargarDropDown(vista.ToTable(), CType(ddlRecurso, ListControl), "", True, "cedula", "nombreResponsable")

                        For Each item As DataRow In vista.ToTable().Rows
                            If CInt(item("idResponsableEntrega").ToString()) = infoServicio.IdResponsableEntrega Then
                                ddlRecurso.SelectedValue = item("idZonaServicio").ToString()
                                Exit For
                            End If
                        Next
                    Else
                        MetodosComunes.CargarDropDown(_zonaServicioMensajeriaDataTable, CType(ddlRecurso, ListControl), "", True, "cedula", "nombreResponsable")
                    End If
                End If

            Else
                epNotificador.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior")
                pnlGeneral.Enabled = False
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar CargarInformacionZona. " & ex.Message)
        End Try
    End Sub

#End Region

    'Protected Sub ddlRecurso_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRecurso.SelectedIndexChanged
    '    _cedulaMotorizado = ddlRecurso.SelectedValue
    'End Sub
End Class