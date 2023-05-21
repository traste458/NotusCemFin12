Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Partial Public Class CreacionOrdenDespachoServicio
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
                .setTitle("Creación Ordenes de Despacho")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            CargarProveedores()
            CargarListadoDeResponsables()

            Dim dtDatos As DataTable
            dtDatos = CargarPool()
            Session("dtDatos") = dtDatos
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                EnlazarDatos(dtDatos)
            End If
        End If
    End Sub

    Private Sub cpFiltroMoto_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFiltroMoto.Execute
        If e.Parameter = "filtrarMoto" Then
            Dim filtroRapido As String = ""
            filtroRapido = txtFiltroMoto.Text
            If filtroRapido.Trim.Length < 4 Then filtroRapido = ""
            CargarListadoDeResponsables(filtroRapido)
        End If
        cpFiltroMoto.Update()
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
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un responsable...", "0"))
            End With

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el listado de responsables. " & ex.Message)
        Finally
            'RefrescarFormulario()
        End Try
    End Sub

    Private Sub lbBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbBuscar.Click
        BuscarServicios()
    End Sub

    Private Sub lbGenerarRuta_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbGenerarRuta.Click
        Dim resultadoValidacion As ResultadoProceso = ValidaSeleccionDatos()

        If resultadoValidacion.Valor = 0 Then
            GenerarDespacho()
        Else
            epNotificacion.showWarning(resultadoValidacion.Mensaje)
        End If
    End Sub

#End Region

#Region "Métodos privados"

    Private Sub CargarProveedores()
        Try
            Dim dtDatos As DataTable = HerramientasMensajeria.ObtenerProveedoresST()
            With ddlProveedorServicioTecnico
                .DataSource = dtDatos
                .DataTextField = "nombre"
                .DataValueField = "idProveedor"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un proveedor...", "0"))
            End With
        Catch ex As Exception
            epNotificacion.showError("Se generó un error en la carga de Proveedores. " & ex.Message)
        End Try
    End Sub

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

    Private Sub BuscarServicios()
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

    Private Sub GenerarDespacho()
        Dim idUsuario As Integer = 0
        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            Dim objRutaServicio As New RutaServicioMensajeria()
            With objRutaServicio
                .IdResponsableEntrega = CInt(ddlMotorizado.SelectedValue)
                .IdEstado = Enumerados.RutaMensajeria.Creada
                .IdUsuarioLog = idUsuario
                .TipoRuta = Enumerados.TipoRutaServicioMensajeria.EntregaProveedorServicioTecnico
                .IdProveedorServicioTecnico = CInt(ddlProveedorServicioTecnico.SelectedValue)
                .ServiciosDatatable = _dtServicios

                Dim resultado As ResultadoProceso = .Registrar()
                If resultado.Valor = 0 Then
                    epNotificacion.showSuccess("Se generó correctamente la orden de despacho número: " + (resultado.Mensaje.Split("-"))(0))
                    BuscarServicios()
                Else
                    epNotificacion.showWarning("No se logro generar la orden de despacho: " + resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Imposible generar despacho: " & ex.Message)
        End Try
    End Sub


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

    Private Function CargarPool() As DataTable
        Dim dtPool As New DataTable
        Dim objGenerarPoolRutas As New GenerarCreacionRutas()
        Try
            dtPool = objGenerarPoolRutas.GenerarPoolEnvioServicioTecnico()
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
                    filaServicio.Item("idResponsableEntrega") = ddlMotorizado.SelectedValue
                    filaServicio.Item("nombreResponsableEntrega") = ddlMotorizado.SelectedItem.Text
                    _dtServicios.Rows.Add(filaServicio)

                    cantidadSeleccionados = cantidadSeleccionados + 1
                    If Not listaJornada.Contains(fila.Cells(ObtenerIdColumna("Jornada", gvDatos)).Text) Then listaJornada.Add(fila.Cells(ObtenerIdColumna("Jornada", gvDatos)).Text)
                    If Not listaFecha.Contains(fila.Cells(ObtenerIdColumna("Fecha Agenda", gvDatos)).Text) Then listaFecha.Add(fila.Cells(ObtenerIdColumna("Fecha Agenda", gvDatos)).Text)
                End If
            Next

            If cantidadSeleccionados > 0 Then
                resultado.EstablecerMensajeYValor(0, "Validación exitosa.")
            Else
                resultado.EstablecerMensajeYValor(1, "Debe seleccionar al menos un elemento para generar el despacho.")
            End If
        Catch ex As Exception
            Throw ex
        End Try

        Return resultado
    End Function

#End Region

End Class