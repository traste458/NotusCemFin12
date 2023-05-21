Imports ILSBusinessLayer
Imports ILSBusinessLayer.SAC
Imports LMDataAccessLayer

Partial Public Class ReporteCasosSac
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)

        If Not Me.IsPostBack Then
            epNotificacion.clear()
            MetodosComunes.setGemBoxLicense()
            Session.Remove("dtReporte")
            epNotificacion.setTitle("Reporte Caso SAC")
            epNotificacion.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            Try
                CargarEstados()
                CargarTiposDeCliente()
                CargarClasesDeCaso()
                CargarTiposDeCaso()
            Catch ex As Exception
                'lbDescargar.Enabled = False
                epNotificacion.showError("Error al tratar de cargar filtros de búsqueda. Por favor recargue la página. " & ex.Message)
            End Try
        End If
    End Sub

    Private Sub CargarEstados()
        Dim listaEstados As New EstadoEntidadColeccion
        Try
            With listaEstados
                .IdEntidad = 23
                .CargarDatos()
            End With
            With ddlEstado
                .DataSource = listaEstados
                .DataTextField = "nombre"
                .DataValueField = "idEstado"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Estados. " & ex.Message, ex)
        End Try
        ddlEstado.Items.Insert(0, New ListItem("Seleccione un Estado", "0"))
    End Sub

    Private Sub CargarTiposDeCliente()
        Dim listaTipoClienteSAC As New TipoDeClienteSACColeccion
        Try
            With listaTipoClienteSAC
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlTipoCliente
                .DataSource = listaTipoClienteSAC
                .DataTextField = "descripcion"
                .DataValueField = "idTipoCliente"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Tipos de Cliente. " & ex.Message, ex)
        End Try
        ddlTipoCliente.Items.Insert(0, New ListItem("Seleccione un Tipo de Cliente", "0"))
    End Sub

    Private Sub CargarClasesDeCaso()
        Dim listaClaseCasoSAC As New ClaseDeServicioSACColeccion
        Try
            With listaClaseCasoSAC
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlClaseCaso
                .DataSource = listaClaseCasoSAC
                .DataTextField = "descripcion"
                .DataValueField = "idClase"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Clases de Caso. " & ex.Message, ex)
        End Try
        ddlClaseCaso.Items.Insert(0, New ListItem("Seleccione Clase de Caso", "0"))
    End Sub

    Private Sub CargarTiposDeCaso(Optional ByVal idClase As Integer = 0)
        Try
            If idClase > 0 Then
                Dim listaTipoCaso As New TipoDeServicioSACColeccion
                listaTipoCaso.IdClaseServicio.Add(idClase)
                listaTipoCaso.CargarDatos()
                With ddlTipoCaso
                    .DataSource = listaTipoCaso
                    .DataTextField = "descripcion"
                    .DataValueField = "idTipo"
                    .DataBind()
                End With
            Else
                ddlTipoCaso.Items.Clear()
            End If
        Catch ex As Exception
            Throw New Exception("Imposible cargar el listado de Clientes. " & ex.Message, ex)
        End Try
        ddlTipoCaso.Items.Insert(0, New ListItem("Seleccione un Tipo de Caso", "0"))
    End Sub


    Protected Sub lbDescargar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbDescargar.Click
        Try

            Dim listaCasoSac As New CasoSACColeccion
            Dim idPerfil As Integer
            Integer.TryParse(Session("usxp009").ToString(), idPerfil)
            Dim usuarioUnidad As New SAC.UsuarioPerfilUnidadNegocio(idPerfil)

            With listaCasoSac
                Dim arrRadicados As New ArrayList(MemoRadicado.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                Dim arrNumeroCaso As New ArrayList(txtNoCaso.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
                If arrRadicados.Count > 0 Then .ArrayNumeroRadicado = arrRadicados
                If arrNumeroCaso.Count > 0 Then .ArrayNumerosdeCasos = arrNumeroCaso
                If ddlClaseCaso.SelectedValue <> "0" Then .IdClaseServicio = ddlClaseCaso.SelectedValue
                If ddlTipoCaso.SelectedValue <> "0" Then .IdTipoServicio = ddlTipoCaso.SelectedValue
                If ddlTipoCliente.SelectedValue <> "0" Then .IdTipoCliente = ddlTipoCliente.SelectedValue
                If ddlEstado.SelectedValue <> "0" Then .IdEstado = ddlEstado.SelectedValue
                If txtFechaInicial.Text.Length > 0 AndAlso txtFechaFinal.Text.Length > 0 Then
                    .FechaInicial = txtFechaInicial.Text
                    .FechaFinal = txtFechaFinal.Text
                    .IdTipoFecha = rblTipoFecha.SelectedValue
                End If
                .IdUnidadNegocio = usuarioUnidad.IdUnidadNegocio
                Dim nombrePlantilla As String = Server.MapPath("~/ReportesCEM/Plantillas/ReporteCasosSaCCEM.xlsx")
                Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/" & "ReporteCasoSAC_CEM_" & Session("usxp001") & ".xlsx")
                Session("nombreArchivoExportar") = .CargarReporteCasosSacCem(nombreArchivo, nombrePlantilla)
                .Clear()
            End With
            '***Se almacena la lista vácia, sólo preservando los filtros aplicados para una consulta futura***'


        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener datos." & ex.Message)
        End Try
    End Sub


    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        txtNoCaso.Text = String.Empty
        MemoRadicado.Text = String.Empty
        ddlClaseCaso.ClearSelection()
        ddlTipoCliente.ClearSelection()
        ddlTipoCaso.ClearSelection()
        ddlEstado.ClearSelection()
        txtFechaInicial.Text = ""
        txtFechaFinal.Text = ""
    End Sub


    Protected Sub ddlClaseCaso_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlClaseCaso.SelectedIndexChanged
        Dim idClase As Short
        Short.TryParse(ddlClaseCaso.SelectedValue, idClase)
        CargarTiposDeCaso(idClase)
    End Sub

    Protected Sub btnExportador_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim resultado As New InfoResultado
        If Session("nombreArchivoExportar") IsNot Nothing Then
            resultado = TryCast(Session("nombreArchivoExportar"), InfoResultado)
            If resultado.Valor > 0 Then
                Dim fullnombreArchivo As String = resultado.Mensaje
                Dim nombreMostrar As String = System.IO.Path.GetFileName(fullnombreArchivo)
                MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, fullnombreArchivo, nombreMostrar)
            Else
                epNotificacion.showSuccess(resultado.Mensaje)
            End If
        End If

    End Sub

End Class