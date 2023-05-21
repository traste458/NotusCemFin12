Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion

Partial Public Class PoolDisponibleAutomarcado
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
                .setTitle("Disponibilidad de Servicios para Automarcado")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With

            CargarCiudad()
            txtRadicado.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")

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

    Private Sub lbMarcarDisponible_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbMarcarDisponible.Click
        Dim resultadoValidacion As ResultadoProceso = ValidaSeleccionDatos()

        If resultadoValidacion.Valor = 0 Then
            MarcarDisponibles()
        Else
            epNotificacion.showWarning(resultadoValidacion.Mensaje)
        End If
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtDatos"), DataTable)
                gvDatos.PageIndex = e.NewPageIndex
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos desde memorial, Por favor recargue la p&aacute;gina")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDatos.Sorting
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim dtDatos As DataTable = CType(Session("dtDatos"), DataTable)
                Dim expOrdenamiento As String = e.SortExpression & " " & ObtenerDireccionOrdenamiento(e.SortExpression)
                EnlazarDatos(dtDatos, expOrdenamiento)
            Else
                epNotificacion.showWarning("Imposible recuperar los datos del reporte desde la memoria. Por favor genere el reporte nuevamente.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar ordenar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub lbBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbBuscar.Click
        Buscar()
    End Sub

    Private Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbQuitarFiltros.Click
        txtFechaCreacionFinal.Value = ""
        txtFechaCreacionInicial.Value = ""
        txtRadicado.Text = ""
        ddlCiudad.SelectedIndex = -1
        Buscar()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarCiudad()
        Dim dtCiudad As New DataTable
        Dim datos As New Ciudad
        Dim idCiudadUsuario As Integer
        Try
            dtCiudad = Ciudad.ObtenerCiudadesPorPais
            With ddlCiudad
                .DataSource = dtCiudad
                .DataTextField = "nombre"
                .DataValueField = "idCiudad"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione una Ciudad", "0"))
                End If

                If Session("usxp007") IsNot Nothing Then Integer.TryParse(Session("usxp007"), idCiudadUsuario)
                ddlCiudad.SelectedValue = idCiudadUsuario
                ddlCiudad.Enabled = False
            End With
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal expOrdenamiento As String = "")
        Try
            pnlResultados.Visible = True

            Dim dvDatos As DataView = dtDatos.DefaultView
            If expOrdenamiento.Trim.Length > 0 Then dvDatos.Sort = expOrdenamiento

            With gvDatos
                .DataSource = dvDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Session("dtDatos") = dvDatos.ToTable()
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub MarcarDisponibles()
        Dim idUsuario As Integer = 1
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            For Each servicio As DataRow In _dtServicios.Rows
                Dim objServicio As New ServicioMensajeria(CInt(servicio("idServicio")))
                objServicio.DisponibleAutomarcado = True
                objServicio.Actualizar(idUsuario)
            Next
            epNotificacion.showSuccess("Se realizó la marcación exitosamente.")
            Buscar()
        Catch ex As Exception
            epNotificacion.showError("Imposible generar disponibilidad: " & ex.Message)
        End Try
    End Sub

    Private Sub Buscar()
        Dim dtDatos As DataTable
        dtDatos = CargarPool()
        Session("dtDatos") = dtDatos
        If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
            EnlazarDatos(dtDatos)
        Else
            epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos.</i>")
            EnlazarDatos(dtDatos)
        End If
    End Sub

    Private Function CargarPool() As DataTable

        Dim dtEstado As New DataTable
        Dim datos As New GenerarPoolServicioMensajeria()

        Try
            With datos
                If Not String.IsNullOrEmpty(txtRadicado.Text) Then .NumeroRadicado = txtRadicado.Text.Trim
                If Not String.IsNullOrEmpty(txtFechaCreacionInicial.Value) Then .FechaCreacionInicial = CDate(txtFechaCreacionInicial.Value)
                If Not String.IsNullOrEmpty(txtFechaCreacionFinal.Value) Then .FechaCreacionFinal = CDate(txtFechaCreacionFinal.Value)
                If ddlCiudad.SelectedValue > 0 Then .IdCiudad = ddlCiudad.SelectedValue
                .DisponibleAutomarcado = Enumerados.EstadoBinario.Inactivo
                .IdEstado = Enumerados.EstadoServicio.Creado
                .TieneNovedad = Enumerados.EstadoBinario.Inactivo
            End With
            dtEstado = datos.GenerarPoolDisponibleAutomarcado()

        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return dtEstado
    End Function

    Private Function ValidaSeleccionDatos() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim cantidadSeleccionados As Integer = 0

            _dtServicios.Columns.Add(New DataColumn("idServicio", Type.GetType("System.String")))

            For Each fila As GridViewRow In gvDatos.Rows
                Dim objCheck As CheckBox = CType(fila.FindControl("chkSeleccion"), CheckBox)
                If objCheck.Checked Then
                    Dim filaServicio As DataRow = _dtServicios.NewRow()
                    filaServicio.Item("idServicio") = fila.Cells(ObtenerIdColumna("ID", gvDatos)).Text
                    _dtServicios.Rows.Add(filaServicio)

                    cantidadSeleccionados = cantidadSeleccionados + 1
                End If
            Next

            If cantidadSeleccionados > 0 Then
                resultado.EstablecerMensajeYValor(0, "Validación exitosa.")
            Else
                resultado.EstablecerMensajeYValor(1, "Debe seleccionar al menos un elemento.")
            End If

        Catch ex As Exception
            Throw ex
        End Try

        Return resultado
    End Function

    Private Function ObtenerDireccionOrdenamiento(ByVal columna As String) As String
        Dim direccionOrdenamiento As String = "ASC"
        Dim expresionOrdenamiento As String = TryCast(ViewState("ExpresionOrdenamiento"), String)
        If expresionOrdenamiento IsNot Nothing Then
            If expresionOrdenamiento = columna Then
                Dim ultimaDirection As String = TryCast(ViewState("DireccionOrdenamiento"), String)
                If ultimaDirection IsNot Nothing AndAlso ultimaDirection = "ASC" Then direccionOrdenamiento = "DESC"
            End If
        End If
        ViewState("DireccionOrdenamiento") = direccionOrdenamiento
        ViewState("ExpresionOrdenamiento") = columna
        Return direccionOrdenamiento
    End Function

#End Region

End Class