Imports ILSBusinessLayer.SAC
Imports ILSBusinessLayer

Partial Public Class VisualizarInfoCasoSAC
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epGeneral.clear()
        If Not Me.IsPostBack Then
            epGeneral.setTitle("Información Caso de Servicio Al Cliente")
            epGeneral.showReturnLink("BuscarCasoSAC.aspx?filtrar=true")
            Try
                If Request.QueryString("idCaso") IsNot Nothing Then
                    If Request.QueryString("showResult") IsNot Nothing Then epGeneral.showSuccess("El caso fue cerrado satisfactoriamente")
                    Dim idCaso As Integer
                    Integer.TryParse(Request.QueryString("idCaso"), idCaso)
                    CargarInformacionGeneralDelCaso(idCaso)
                    hIdCaso.Value = idCaso.ToString
                    CargarGestiones()
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
                    lblGenInconformidad.Text = .GeneradorInconformidad
                    lblClaseCaso.Text = .ClaseDeServicio
                    lblTipoCaso.Text = .TipoDeServicio
                    lblFechaRecepcion.Text = .FechaDeRecepcion
                    lblRemitente.Text = .Remitente
                    lblTramitador.Text = .Tramitador
                    lblEstado.Text = .Estado
                    lblGeneroCobro.Text = IIf(.GeneroCobro, "Si", "No")
                    If .GeneroCobro Then
                        lblValorCobro.Text = .ValorCobro
                        lblResponsableCobro.Text = .ResponsableCobro
                    End If
                    If .FechaRespuesta > Date.MinValue Then lblFechaRespuesta.Text = .FechaRespuesta
                    If .FechaCierre > Date.MinValue Then lblFechaCierre.Text = .FechaCierre
                    lblUsuarioCierra.Text = .UsuarioCierra
                    lblDescripcion.Text = .Descripcion
                    lblRespuesta.Text = .Respuesta
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
            Else
                ltAux.Visible = True

            End If
            EnlazarInfoGestion(dtDatos)
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

End Class