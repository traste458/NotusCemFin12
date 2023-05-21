Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class EditarRutaServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _numRegistros As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, True)
        epNotificacion.clear()

        If Not IsPostBack Then
            epNotificacion.setTitle("Modificar rutas Servicio Mensajería")
            epNotificacion.showReturnLink("ConsultaRutaMensajeria.aspx")

            Dim idRuta As Integer
            If Request.QueryString("idRuta") IsNot Nothing Then
                If Integer.TryParse(Request.QueryString("idRuta").ToString, idRuta) Then BuscarRutas(idRuta)
                txtIdRuta.Text = idRuta
            End If

            txtIdRuta.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            txtRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
        Else
            _numRegistros = CInt(Session("numRegistros"))
        End If
    End Sub

    Protected Sub lbBuscarRuta_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscarRuta.Click
        If txtIdRuta.Text = "" Then
            epNotificacion.showWarning("Por favor digite en número de la ruta. ")
        Else
            BuscarRutas(CInt(txtIdRuta.Text))
        End If
    End Sub

    Protected Sub lbAgregarRadicado_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbAgregarRadicado.Click
        If txtRadicado.Text = "" Or txtIdRuta.Text = "" Then
            epNotificacion.showWarning("Por favor digite en número de radicado y/o la ruta.")
        Else
            AdicionarElemento(CLng(txtRadicado.Text), CInt(txtIdRuta.Text))
        End If
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.DataItemIndex = 0 Then
            With CType(e.Row.FindControl("btnSubir"), ImageButton)
                .ImageUrl = "../images/transparent_16.gif"
                .Enabled = False
            End With
        End If

        If _numRegistros > 0 AndAlso e.Row.DataItemIndex = _numRegistros - 1 Then
            With CType(e.Row.FindControl("btnBajar"), ImageButton)
                .ImageUrl = "../images/transparent_16.gif"
                .Enabled = False
            End With
        End If
    End Sub

    Private Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Select Case e.CommandName
            Case "eliminar"
                EliminarElemento(CInt(e.CommandArgument))
            Case "subir"
                SubirElemento(CInt(e.CommandArgument), CInt(lblIdRuta.Text))
            Case "bajar"
                BajarElemento(CInt(e.CommandArgument), CInt(lblIdRuta.Text))
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Protected Sub lbActualizarResponsable_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbActualizarResponsable.Click
        CambiarResponsable()
    End Sub

#End Region

#Region "Métodos"

    Private Sub BuscarRutas(ByVal idRuta As Integer)
        Try
            Dim detalleRutaServicio As New RutaServicioMensajeria(idRuta)
            With detalleRutaServicio
                If .Registrado And .IdEstado = Enumerados.RutaMensajeria.Creada Then
                    lblIdRuta.Text = .IdRuta
                    lblResponsableEntrega.Text = .NombreResponsable
                    lblEstado.Text = .NombreEstado
                    lblFechaCreacion.Text = .FechaCreacion
                    If .FechaSalida <> Date.MinValue Then
                        lblFechaSalida.Text = .FechaSalida
                    Else
                        lblFechaSalida.Text = ""
                    End If
                    If .FechaCierre <> Date.MinValue Then
                        lblFechaCierre.Text = .FechaCierre
                    Else
                        lblFechaCierre.Text = ""
                    End If

                    Dim detalleRuta As New DetalleRutaServicioMensajeria()
                    With detalleRuta
                        detalleRuta.IdRuta = idRuta

                        Dim dtDatos As DataTable = detalleRuta.ObtenerDatos()
                        _numRegistros = dtDatos.Rows.Count
                        Session("numRegistros") = _numRegistros

                        gvDatos.DataSource = dtDatos
                        gvDatos.DataBind()
                    End With

                    With ddlResponsable
                        .DataSource = ObtenerlistadoDeResponsables("")
                        .DataTextField = "responsableEntrega"
                        .DataValueField = "idtercero"
                        .DataBind()
                    End With
                    If (CType(ddlResponsable.DataSource, DataTable).Select("idtercero=" & .IdResponsableEntrega.ToString()).Length > 0) Then
                        ddlResponsable.SelectedValue = .IdResponsableEntrega
                    Else
                        ddlResponsable.Items.Insert(0, New ListItem("Seleccione...", -1))
                    End If

                    MostrarOcultarPaneles(True)
                Else
                    epNotificacion.showWarning("El número de ruta [" & idRuta & "] no se encuentra en un estado válido para ser modificada.")
                    MostrarOcultarPaneles(False)
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarElemento(ByVal idElemento As Integer)
        Try
            Dim detalleRutaServicio As New DetalleRutaServicioMensajeria(idElemento)
            Dim resultado As ResultadoProceso = detalleRutaServicio.Desvincular(CInt(Session("usxp001")))

            If resultado.Valor = 0 Then
                epNotificacion.showSuccess("Se eliminó de la ruta correctamente el elemento.")
                BuscarRutas(detalleRutaServicio.IdRuta)
            Else
                epNotificacion.showSuccess("Imposible eliminar elemento de ruta: " & resultado.Mensaje)
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó un erro inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarElemento(ByVal radicado As Long, ByVal idRuta As Integer)
        Try
            Dim detalleRutaServicio As New DetalleRutaServicioMensajeria()
            Dim resultado As ResultadoProceso = detalleRutaServicio.Adicionar(radicado, idRuta, CInt(Session("usxp001")))

            If resultado.Valor = 0 Then
                epNotificacion.showSuccess("Se adicionó a la ruta correctamente el elemento.")
                BuscarRutas(idRuta)
            Else
                epNotificacion.showWarning("Imposible adicionar elemento a ruta: " & resultado.Mensaje)
            End If

        Catch ex As Exception
            epNotificacion.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub SubirElemento(ByVal idElemento As Integer, ByVal idRuta As Integer)
        Try
            Dim detalleRuta As New DetalleRutaServicioMensajeria()
            Dim resultado As ResultadoProceso = detalleRuta.MoverSecuecia(idElemento, Enumerados.MovimientoSecuencia.Subir)

            If resultado.Valor = 0 Then
                epNotificacion.showSuccess("Movimiento realizado exitosamente.")
                BuscarRutas(idRuta)
            Else
                epNotificacion.showWarning(resultado.Mensaje)
            End If

        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub BajarElemento(ByVal idElemento As Integer, ByVal idRuta As Integer)
        Try
            Dim detalleRuta As New DetalleRutaServicioMensajeria()
            Dim resultado As ResultadoProceso = detalleRuta.MoverSecuecia(idElemento, Enumerados.MovimientoSecuencia.Bajar)

            If resultado.Valor = 0 Then
                epNotificacion.showSuccess("Movimiento realizado exitosamente.")
                BuscarRutas(idRuta)
            Else
                epNotificacion.showWarning(resultado.Mensaje)
            End If

        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub CambiarResponsable()
        Try
            If ddlResponsable.SelectedIndex <> -1 Then
                Dim objRutaServicio As New RutaServicioMensajeria(CInt(lblIdRuta.Text))
                objRutaServicio.IdResponsableEntrega = ddlResponsable.SelectedValue

                Dim resultado As ResultadoProceso = objRutaServicio.Actualizar()
                If resultado.Valor = 0 Then
                    epNotificacion.showSuccess("Responsable de entrega modificado exitosamente.")
                    BuscarRutas(CInt(lblIdRuta.Text))
                Else
                    epNotificacion.showWarning("Error al modificar responsable: " & resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            epNotificacion.showError("Error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub MostrarOcultarPaneles(ByVal visible As Boolean)
        pnlDetalle.Visible = visible
        pnlAdicionARadicado.Visible = visible
        pnlModificarResponsable.Visible = visible
    End Sub

#End Region

#Region "Funciones"

    Protected Function ObtenerlistadoDeResponsables(Optional ByVal filtroRapido As String = "") As DataTable
        Dim miMaterial As New Productos.Subproducto
        Dim dtResponsables As New DataTable
        Dim dtAux As New DataTable
        Dim strFiltro As String

        If filtroRapido.Trim.Length > 2 Then strFiltro = "responsableEntrega LIKE '%" & filtroRapido & "%'"
        dtAux = HerramientasMensajeria.ConsultaZonaServicioMensajeria()
        Dim arrCampos As New ArrayList
        arrCampos.AddRange(Split("responsable|cedula|idtercero|responsableEntrega", "|"))
        dtResponsables = MetodosComunes.getDistinctsFromDataTable(dtAux, arrCampos, strFiltro, " responsable DESC")

        Return dtResponsables
    End Function

#End Region

End Class