Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Partial Public Class CreacionRutasEntregaServicioST
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _dtServicios As New DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()

        If Not IsPostBack Then
            With epNotificacion
                .setTitle("Creación de Rutas")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With

            CargaInicial()
            CargarListadoDeResponsables()

            Dim dtDatos As DataTable
            dtDatos = CargarPool()
            Session("dtDatos") = dtDatos
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
            End If
        Else

        End If
    End Sub

    Protected Sub lbGenerarRuta_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGenerarRuta.Click
        Dim resultadoValidacion As ResultadoProceso = ValidaSeleccionDatos()

        If resultadoValidacion.Valor = 0 Then
            GenerarRutas()
        Else
            epNotificacion.showWarning(resultadoValidacion.Mensaje)
        End If
    End Sub

    Public Sub OnCheckChangedEvent(ByVal sender As Object, ByVal e As EventArgs)
        'Dim c As CheckBox = DirectCast(sender, CheckBox)
        'Dim row As GridViewRow = CType(c.NamingContainer, GridViewRow)
        'Dim wineID As String = DirectCast(c, Control).ID
        'Dim ddl As DropDownList = CType(row.FindControl("ddlNovedad"), DropDownList)
        'Dim tb As TextBox = CType(row.FindControl("txtNuevoMSISDN"), TextBox)
        'If c.Checked Then
        '    ddl.Visible = True
        '    tb.Visible = True
        '    btnBuscar.Visible = True
        'Else
        '    ddl.Visible = False
        '    tb.Visible = False
        'End If
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        BuscarRutas()
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtDatos"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos desde memoria, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim urgente As Boolean = CBool(CType(e.Row.DataItem, DataRowView).Item("urgente"))

            'Controla el icono a visualizar cuándo el elemento está marcado como urgente
            If urgente Then
                CType(e.Row.FindControl("imgUrgente"), System.Web.UI.WebControls.Image).ImageUrl = "../images/emblem-important.png"
            End If
        End If
    End Sub

#End Region

#Region "Delegados"

    Private Sub cpFiltroMoto_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMoto.Execute
        If e.Parameter = "filtrarMoto" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMoto.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeResponsables(filtroRapido)
        End If
        cpFiltroMoto.Update()
    End Sub

    Private Sub CargarListadoDeResponsables(Optional ByVal filtroRapido As String = "")
        Try
            Dim numResponsables As Integer = 0
            'pnlDetalle.Visible = True
            If filtroRapido.Trim.Length > 0 Then
                Dim dtResponsables As DataTable = ObtenerlistadoDeResponsables(filtroRapido)

                With ddlMotorizado
                    .DataSource = dtResponsables
                    .DataTextField = "responsableEntrega"
                    .DataValueField = "idMotorizado"
                    .DataBind()
                End With

                numResponsables = dtResponsables.Rows.Count
            Else
                If ddlMotorizado.Items.Count > 0 Then ddlMotorizado.Items.Clear()
            End If

            lblMoto.Text = numResponsables.ToString & " Registro(s) Encontrado(s)"

            With ddlMotorizado
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un responsable", "0"))
            End With

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el listado de responsables. " & ex.Message)
        Finally
            'RefrescarFormulario()
        End Try
    End Sub

#End Region

#Region "Métodos"

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            pnlResultados.Visible = True
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            lbGenerarRuta.Visible = CBool(dtDatos.Rows.Count)
            Session("dtPoolCreacionRutas") = dtDatos
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        Try
            CargarJornadas()
        Catch ex As Exception
            epNotificacion.showError("Se generó un error en la carga inicial de valores. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarJornadas()
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ConsultaJornadaMensajeria()
            With ddlJornada
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idJornada"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja una Jornada", "0"))
            End With

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el listado de Jornadas. " & ex.Message)
        End Try
    End Sub

    Private Sub GenerarRutas()
        Dim idUsuario As Integer = 1
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            'Se genera una ruta por cada responsbale de entrega
            Dim dtResponsables As DataTable = _dtServicios.DefaultView().ToTable(True, "idResponsableEntrega", "nombreResponsableEntrega")
            Dim dtLog As DataTable = CrearEstructuraLogRutas()

            For Each responsable As DataRow In dtResponsables.Rows
                Dim idResponsable As Integer = CInt(responsable("idResponsableEntrega").ToString())

                Dim objRutaServicio As New RutaServicioMensajeria()
                objRutaServicio.IdResponsableEntrega = idResponsable
                objRutaServicio.IdEstado = Enumerados.RutaMensajeria.Creada
                objRutaServicio.IdUsuarioLog = idUsuario
                objRutaServicio.TipoRuta = Enumerados.TipoRutaServicioMensajeria.EntregaClienteServicioTecnico

                Dim servicioView As DataView = _dtServicios.DefaultView()
                With servicioView
                    .RowFilter = "idResponsableEntrega = " & idResponsable.ToString()
                    Using servicioDataTable As DataTable = .ToTable()
                        objRutaServicio.ServiciosDatatable = servicioDataTable
                    End Using
                End With

                Dim resultado As ResultadoProceso = objRutaServicio.Registrar()
                If resultado.Valor = 0 Then
                    Dim filaLog As DataRow = dtLog.NewRow()
                    filaLog("idRuta") = (resultado.Mensaje.Split("-"))(0)
                    filaLog("responsable") = responsable("nombreResponsableEntrega").ToString()
                    dtLog.Rows.Add(filaLog)
                    dtLog.AcceptChanges()

                    epNotificacion.showSuccess("Rutas creadas correctamente.")
                Else
                    epNotificacion.showWarning("Error al crear la ruta del usuario: " & idResponsable)
                End If
            Next
            gvLog.DataSource = dtLog
            gvLog.DataBind()
            EnlazarDatos(CargarPool())

        Catch ex As Exception
            epNotificacion.showError("Imposible generar rutas: " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarRutas()
        Try
            Dim dtDatos As DataTable
            dtDatos = CargarPool()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                EnlazarDatos(dtDatos)
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        txtFechaInicial.Value = ""
        txtFechaFinal.Value = ""
        ddlJornada.SelectedIndex = 0
        txtFiltroMoto.Text = ""
        CargarListadoDeResponsables()
        BuscarRutas()
    End Sub

#End Region

#Region "Funciones"

    Private Function CargarPool() As DataTable
        Dim dtPool As New DataTable
        Dim objGenerarPoolRutas As New GenerarCreacionRutas()

        Try
            If ddlJornada.SelectedValue > 0 Then objGenerarPoolRutas.IdJornada = ddlJornada.SelectedValue
            If Not String.IsNullOrEmpty(txtFechaInicial.Value) AndAlso Not String.IsNullOrEmpty(txtFechaFinal.Value) Then
                objGenerarPoolRutas.FechaAgendaInicial = CDate(txtFechaInicial.Value)
                objGenerarPoolRutas.FechaAgendaFinal = CDate(txtFechaFinal.Value)
            End If
            If ddlMotorizado.SelectedIndex > -1 Then objGenerarPoolRutas.IdTercero = ddlMotorizado.SelectedValue

            dtPool = objGenerarPoolRutas.GenerarPoolEntregaServicioTecnico
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de ítems." & ex.Message)
        End Try

        Return dtPool
    End Function

    Private Function ValidaSeleccionDatos() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim cantidadSeleccionados As Integer = 0
            Dim listaJornada As New List(Of String)
            Dim listaFecha As New List(Of String)

            _dtServicios.Columns.Add(New DataColumn("idServicio", Type.GetType("System.String")))
            _dtServicios.Columns.Add(New DataColumn("idResponsableEntrega", Type.GetType("System.String")))
            _dtServicios.Columns.Add(New DataColumn("nombreResponsableEntrega", Type.GetType("System.String")))

            Dim columnaSecuencias As New DataColumn("secuencia", GetType(Integer))
            columnaSecuencias.AutoIncrementSeed = 1
            columnaSecuencias.AutoIncrementStep = 1
            columnaSecuencias.AutoIncrement = True
            _dtServicios.Columns.Add(columnaSecuencias)

            _dtServicios.AcceptChanges()

            For Each fila As GridViewRow In gvDatos.Rows
                Dim objCheck As CheckBox = CType(fila.FindControl("chkSeleccion"), CheckBox)
                If objCheck.Checked Then
                    Dim filaServicio As DataRow = _dtServicios.NewRow()
                    filaServicio.Item("idServicio") = fila.Cells(ObtenerIdColumna("ID", gvDatos)).Text
                    filaServicio.Item("idResponsableEntrega") = fila.Cells(ObtenerIdColumna("Id Resp.", gvDatos)).Text
                    filaServicio.Item("nombreResponsableEntrega") = fila.Cells(ObtenerIdColumna("Resp. Entrega", gvDatos)).Text
                    _dtServicios.Rows.Add(filaServicio)

                    cantidadSeleccionados = cantidadSeleccionados + 1
                    If Not listaJornada.Contains(fila.Cells(ObtenerIdColumna("Jornada", gvDatos)).Text) Then listaJornada.Add(fila.Cells(ObtenerIdColumna("Jornada", gvDatos)).Text)
                    If Not listaFecha.Contains(fila.Cells(ObtenerIdColumna("Fecha Agenda", gvDatos)).Text) Then listaFecha.Add(fila.Cells(ObtenerIdColumna("Fecha Agenda", gvDatos)).Text)
                End If
            Next

            If cantidadSeleccionados > 0 Then
                If listaFecha.Count > 1 Then
                    resultado.EstablecerMensajeYValor(3, "Solamente se permite crear rutas para una  única fecha de agendamiento.")
                Else
                    If listaJornada.Count > 1 Then
                        resultado.EstablecerMensajeYValor(2, "Solamente se permite crear rutas para una Jornada.")
                    Else
                        resultado.EstablecerMensajeYValor(0, "Validación exitosa.")
                    End If
                End If
            Else
                resultado.EstablecerMensajeYValor(1, "Debe seleccionar al menos un elemento para generar la ruta.")
            End If
        Catch ex As Exception
            Throw
        End Try

        Return resultado
    End Function

    Private Function CrearEstructuraLogRutas() As DataTable
        Dim dtLog As New DataTable

        dtLog.Columns.Add("idRuta", GetType(Integer))
        dtLog.Columns.Add("responsable", GetType(String))

        Return dtLog
    End Function

    Protected Function ObtenerlistadoDeResponsables(Optional ByVal filtroRapido As String = "") As DataTable
        Dim dvReponsable As DataView
        Dim idCiudad As Integer

        If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007").ToString, idCiudad)
        If Session("dtResponsableEntrega") Is Nothing Then Session("dtResponsableEntrega") = HerramientasMensajeria.ConsultarMotorizado(idCiudad)

        With CType(Session("dtResponsableEntrega"), DataTable)
            If Not .Columns.Contains("responsableEntrega") Then
                Dim dcAux As New DataColumn("responsableEntrega")
                dcAux.Expression = "identificacion+' - '+nombre"
                .Columns.Add(dcAux)
            End If
            dvReponsable = .DefaultView
        End With
        If filtroRapido.Trim.Length > 2 Then
            dvReponsable.RowFilter = "responsableEntrega LIKE '%" & filtroRapido & "%'"
        Else
            dvReponsable.RowFilter = "idMotorizado = -1"
        End If
        Return dvReponsable.ToTable()

    End Function

#End Region

End Class