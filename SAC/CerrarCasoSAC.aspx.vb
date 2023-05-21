Imports ILSBusinessLayer.SAC
Imports ILSBusinessLayer

Partial Public Class CerrarCasoSAC
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epGeneral.clear()
        If Not Me.IsPostBack Then
            epGeneral.setTitle("Finalizar Caso de Servicio Al Cliente")
            epGeneral.showReturnLink("BuscarCasoSAC.aspx?filtrar=true")
            trValorCobro.Visible = False
            trResponsableCobro.Visible = False
            Try
                If Request.QueryString("idCaso") IsNot Nothing Then
                    With dpFechaRespuesta
                        .MaxValidDate = Now
                    End With
                    Dim idCaso As Integer
                    Integer.TryParse(Request.QueryString("idCaso"), idCaso)
                    CargarInformacionGeneralDelCaso(idCaso)
                    hIdCaso.Value = idCaso.ToString
                    CargarGestiones()
                    CargarListaGeneradorInconformidad()
                    'CargarHoras()
                    CargarResponsablesDeCobro()
                Else
                    epGeneral.showWarning("Imposible recuperar el identificador del caso. Por favor regrese a la página anterior e intente nuevamente.")
                End If
            Catch ex As Exception
                epGeneral.showError("Error al tratar de cargar datos. " & ex.Message)
            End Try
        End If
    End Sub

    Private Sub CargarInformacionGeneralDelCaso(ByVal idCaso As Integer)

        Try
            Dim infoCaso As New CasoSAC(idCaso)
            If infoCaso.Registrado Then
                With infoCaso
                    lblNoCaso.Text = .Consecutivo
                    lblCliente.Text = .Cliente
                    lblClaseCaso.Text = .ClaseDeServicio
                    lblTipoCaso.Text = .TipoDeServicio
                    lblFechaRecepcion.Text = .FechaDeRecepcion
                    lblRemitente.Text = .Remitente
                    lblTramitador.Text = .Tramitador
                    lblEstado.Text = .Estado
                    If .FechaRespuesta > Date.MinValue Then lblFechaRespuesta.Text = .FechaRespuesta
                    lblDescripcion.Text = .Descripcion
                    lblObservacion.Text = .Observacion
                End With
                Session("CasoSACGestionar") = infoCaso
            Else
                epGeneral.showWarning("Imposible recuperar la información general del caso. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener información general del caso. " & ex.Message, ex)
        End Try
    End Sub

    Private Sub CargarGestiones()
        Try
            Dim elCaso As CasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Dim infoGestion As InfoGestionCasoSACColeccion = elCaso.DetalleGestion
            Dim dtDatos As DataTable = Nothing
            If elCaso.DetalleGestion.Count > 0 Then
                ltAux.Visible = False
                dtDatos = elCaso.DetalleGestion.GenerarDataTable()
                Dim fechaAux As Date
                Date.TryParse(dtDatos.Compute("MAX(FechaDeGestion)", "").ToString, fechaAux)
                With dpFechaRespuesta
                    If fechaAux > Date.MinValue Then .MinValidDate = fechaAux Else .MinValidDate = CDate(lblFechaRecepcion.Text)
                    hfMaxFechaGestion.Value = .MinValidDate.ToString("MM/dd/yyyy HH:mm:ss")
                End With
            Else
                ltAux.Visible = True
            End If
            EnlazarInfoGestion(dtDatos)

        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Gestiones del Caso registradas. " & ex.Message)
        End Try
    End Sub

    'Private Sub CargarHoras()
    '    With ddlHora
    '        For index As Integer = 0 To 23
    '            .Items.Add(New ListItem(index.ToString("00"), index))
    '        Next
    '        .ClearSelection()
    '    End With
    '    With ddlMinutos
    '        For index As Integer = 0 To 59
    '            .Items.Add(New ListItem(index.ToString("00"), index))
    '        Next
    '        .ClearSelection()
    '    End With
    'End Sub

    Private Sub CargarListaGeneradorInconformidad()
        Dim listaGenerador As New GeneradorInconformidadSACColeccion
        Try
            With listaGenerador
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlGeneradorInconformidad
                .DataSource = listaGenerador
                .DataTextField = "descripcion"
                .DataValueField = "idGenerador"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione Generador", "0"))
            End With
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de posibles Generadores de la Inconformidad. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarResponsablesDeCobro()
        Try
            Dim listaResponsable As New ResponsableCobroCasoSACColeccion
            With listaResponsable
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlResponsableCobro
                .DataSource = listaResponsable
                .DataTextField = "Nombre"
                .DataValueField = "IdResponsable"
                .DataBind()
            End With
            ddlResponsableCobro.Items.Insert(0, New ListItem("Seleccione un Responsable de Cobro", "0"))
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Gestiones del Caso registradas. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarInfoGestion(ByVal dtDatos As DataTable)
        With repInfoGestion
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Private Sub repInfoGestion_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repInfoGestion.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Try
                Dim idGestion As Integer = CType(e.Item.DataItem, DataRowView).Item("IdGestion")
                Dim listaRespuesta As New RespuestaGestionCasoSACColeccion(idGestion)
                If listaRespuesta.Count > 0 Then
                    Dim gvAux As GridView = e.Item.FindControl("gvRespuestaRegistrada")
                    If gvAux IsNot Nothing Then
                        With gvAux
                            .DataSource = listaRespuesta.GenerarDataTable()
                            .DataBind()
                        End With
                    End If
                End If
            Catch ex As Exception
                epGeneral.showError("Error al tratar de enlazar el listado de archivos de respuesta de cada gestión. " & ex.Message)
            End Try

        End If
    End Sub

    Protected Sub gvRespuestaRegistrada_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim requiereArchivo As Boolean
            Boolean.TryParse(CType(e.Row.DataItem, DataRowView).Item("requiereArchivo").ToString, requiereArchivo)
            Dim ibAux As ImageButton = CType(e.Row.FindControl("ibDescargar"), ImageButton)
            If requiereArchivo Then
                smAjaxManager.RegisterPostBackControl(ibAux)
            Else
                ibAux.Visible = False
            End If
        End If
    End Sub

    Protected Sub gvRespuestaRegistrada_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Select Case e.CommandName.ToLower
            Case "descargar"
                Try
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, e.CommandArgument)
                Catch ex As Exception
                    epGeneral.showError("Error al tratar de descargar archivo de respuesta." & ex.Message)
                End Try
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Protected Sub ddlGeneroCobro_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlGeneroCobro.SelectedIndexChanged
        Try
            Dim generoCobro As Boolean = CBool(ddlGeneroCobro.SelectedValue)
            txtValorCobro.Text = ""
            ddlResponsableCobro.ClearSelection()
            If generoCobro Then
                trValorCobro.Visible = True
                trResponsableCobro.Visible = True
            Else
                trValorCobro.Visible = False
                trResponsableCobro.Visible = False
            End If

        Catch ex As Exception
            epGeneral.showError("Error al tratar de validar selección. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCerrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCerrar.Click
        Try
            Dim miCaso As CasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Dim resultado As New ResultadoProceso
            Dim idUsuario As Integer
            Dim listaSerial As New SerialSACColeccion
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            If idUsuario = 0 Then idUsuario = 1
            With miCaso
                .Respuesta = txtRespuesta.Text.Trim
                .FechaRespuesta = dpFechaRespuesta.SelectedDate
                .IdGeneradorInconformidad = ddlGeneradorInconformidad.SelectedValue
                .GeneroCobro = CBool(ddlGeneroCobro.SelectedValue)
                If .GeneroCobro Then
                    .ValorCobro = txtValorCobro.Text
                    .IdResponsableCobro = ddlResponsableCobro.SelectedValue
                End If
                .IdUsuarioCierra = idUsuario
                resultado = .CerrarCaso()
            End With
            If resultado.Valor = 0 Then
                Response.Redirect("VisualizarInfoCasoSAC.aspx?idCaso=" & hIdCaso.Value & "&showResult=true")
            Else
                Select Case resultado.Valor
                    Case 2
                        epGeneral.showError(resultado.Mensaje)
                    Case Else
                        epGeneral.showWarning(resultado.Mensaje)
                End Select
            End If
        Catch ex As Exception
            epGeneral.showError("Error al tratar de registrar caso. " & ex.Message)
        End Try
    End Sub
End Class