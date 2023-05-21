Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Public Class CreacionRutasRecoleccionServicioSiembra
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
                .setTitle("Creación Ruta de Recolección Seriales Siembra")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With

            CargarListadoDeResponsables()

            Dim dsDatos As DataSet
            dsDatos = CargarPool()
            If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
                Session("dsOrdenes") = dsDatos
                EnlazarDatos(dsDatos.Tables(0))
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
                EnlazarDatos(dsDatos.Tables(0))
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

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idServicioMensajeria As String = CType(e.Row.DataItem, DataRowView).Item("idServicioMensajeria").ToString

            Dim gvDetalle As GridView = CType(e.Row.FindControl("gvDatosDetalle"), GridView)
            Dim dvDetalle As DataView = CType(Session("dsOrdenes"), DataSet).Tables(1).DefaultView
            dvDetalle.RowFilter = "idServicioMensajeria = " & idServicioMensajeria

            Dim img As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgCollapse"), System.Web.UI.WebControls.Image)
            Dim pnlDetalle As Panel = CType(e.Row.FindControl("pnlDetalle"), Panel)

            img.Attributes.Add("onclick", "javascript:CollapseDetail(this,'" & pnlDetalle.ClientID & "');")

            gvDetalle.DataSource = dvDetalle.ToTable()
            gvDetalle.DataBind()
        End If
    End Sub

    Protected Sub gvDatosDetalle_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)

    End Sub

    Protected Sub gvDatosDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddlEstadoDevolucion As DropDownList = CType(e.Row.FindControl("ddlEstadoDevolucion"), DropDownList)
            CargarEstadosDevolucion(ddlEstadoDevolucion)
        End If
    End Sub

    Private Sub lbGenerarRuta_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbGenerarRuta.Click
        Dim resultadoValidacion As ResultadoProceso = ValidaSeleccionDatos()

        If resultadoValidacion.Valor = 0 Then
            GenerarRuta()
        Else
            epNotificacion.showWarning(resultadoValidacion.Mensaje)
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarListadoDeResponsables(Optional ByVal filtroRapido As String = "")
        Try
            Dim numResponsables As Integer = 0

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

    Private Function CargarPool() As DataSet
        Dim dsDatos As New DataSet()
        Try
            Dim objGenerarPoolRutas As New GenerarCreacionRutas()
            Dim dtDatos As DataTable = objGenerarPoolRutas.GenerarPoolRecoleccionServicioSiembra()

            dsDatos.Tables.Add(dtDatos.DefaultView.ToTable(True, "idServicioMensajeria", "nombreCliente", "identificacion", _
                                                           "nombreAutorizado", "direccion", "telefono", "fechaAgenda"))
            dsDatos.Tables.Add(dtDatos)
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de ítems: " & ex.Message)
        End Try
        Return dsDatos
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            pnlResultados.Visible = True
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            lbGenerarRuta.Visible = CBool(dtDatos.Rows.Count)
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Function ValidaSeleccionDatos() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim cantidadSeleccionados As Integer = 0
            Dim listaJornada As New List(Of String)
            Dim listaFecha As New List(Of String)

            With _dtServicios
                .Columns.Add(New DataColumn("idDetalleSerial", Type.GetType("System.String")))
                .Columns.Add(New DataColumn("idEstadoDevolucion", Type.GetType("System.Integer")))
                .AcceptChanges()
            End With

            For Each fila As GridViewRow In gvDatos.Rows
                Dim objGridView As GridView = CType(fila.FindControl("gvDatosDetalle"), GridView)

                For Each filaDetalle As GridViewRow In objGridView.Rows
                    Dim objCheck As CheckBox = CType(filaDetalle.FindControl("chkSeleccion"), CheckBox)
                    If objCheck.Checked Then
                        Dim objCombo As DropDownList = CType(filaDetalle.FindControl("ddlEstadoDevolucion"), DropDownList)

                        Dim filaServicio As DataRow = _dtServicios.NewRow()
                        filaServicio.Item("idDetalleSerial") = filaDetalle.Cells(ObtenerIdColumna("ID", objGridView)).Text
                        filaServicio.Item("idEstadoDevolucion") = CInt(objCombo.SelectedValue)
                        _dtServicios.Rows.Add(filaServicio)

                        cantidadSeleccionados = cantidadSeleccionados + 1
                    End If
                Next
            Next

            If cantidadSeleccionados > 0 Then
                resultado.EstablecerMensajeYValor(0, "Validación exitosa.")
            Else
                resultado.EstablecerMensajeYValor(1, "Debe seleccionar al menos un Serial para generar la ruta.")
            End If
        Catch ex As Exception
            Throw ex
        End Try

        Return resultado
    End Function

    Private Sub GenerarRuta()
        Dim idUsuario As Integer = 0
        If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
        Try
            Dim objRutaServicio As New RutaServicioMensajeriaSiembra()
            With objRutaServicio
                .IdResponsableEntrega = CInt(ddlMotorizado.SelectedValue)
                .IdEstado = Enumerados.RutaMensajeria.Creada
                .IdUsuarioLog = idUsuario
                .TipoRuta = Enumerados.TipoRutaServicioMensajeria.RecoleccionClienteSiembra
                .ServiciosDatatable = _dtServicios

                Dim resultado As ResultadoProceso = .Registrar()
                If resultado.Valor = 0 Then
                    epNotificacion.showSuccess("Se generó correctamente la orden de recolección número: " + (resultado.Mensaje.Split("-"))(0))
                    BuscarServicios()
                Else
                    epNotificacion.showWarning("No se logro generar la orden de despacho: " + resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificacion.showError("Imposible generar orden: " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarServicios()
        Try
            Dim dsDatos As DataSet
            dsDatos = CargarPool()
            If dsDatos.Tables(0) IsNot Nothing AndAlso dsDatos.Tables(0).Rows.Count > 0 Then
                Session("dsOrdenes") = dsDatos
                EnlazarDatos(dsDatos.Tables(0))
            Else
                EnlazarDatos(dsDatos.Tables(0))
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
            End If
        Catch ex As Exception
            epNotificacion.showError("Imposible realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarEstadosDevolucion(ByRef ddl As DropDownList)
        Try
            With ddl
                .DataSource = HerramientasMensajeria.ConsultarEstado(Enumerados.Entidad.EstadoDevoluciónSiembra)
                .DataValueField = "idEstado"
                .DataTextField = "nombre"
                .DataBind()
            End With
        Catch ex As Exception
            epNotificacion.showError("Se generó un error al intentar cargar estados de devolución: " & ex.Message)
        End Try
    End Sub

#End Region

End Class