Imports ILSBusinessLayer

Partial Public Class PoolCargueServicioMensajeria
    Inherits System.Web.UI.Page


#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            epPrincipal.clear()

            If Not IsPostBack Then
                With epPrincipal
                    .setTitle("Pool de Cargue de Servicio Mensajeria")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                CargaInicial()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar la pagina. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Try
            ObtenerDatos()
        Catch ex As Exception
            epPrincipal.showError("Error al realizar el filtro de servicios. " & ex.Message)
        End Try

    End Sub

    Protected Sub btnBorrarFiltro_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBorrarFiltro.Click
        Try
            BorrarFiltro()
        Catch ex As Exception
            epPrincipal.showError(ex.Message)
        End Try
    End Sub

#End Region

#Region "Metodos"

    Private Sub CargaInicial()
        Try
            CargarCiudad()
            CargarServicio()
            ObtenerDatos()
        Catch ex As Exception
            Throw New Exception("Error al realizar el cargue inicial. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarCiudad()
        Try
            Dim dt As New DataTable
            dt = CiudadCargueServicioMensajeria.ObtenerListado()
            With ddlCiudad
                .DataSource = dt
                .DataTextField = "nombre"
                .DataValueField = "idCiudadEquivalente"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
        Catch ex As Exception
            Throw New Exception("Error al cargar la ciudad. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarServicio()
        Dim dtEstado As New DataTable
        Try
            dtEstado = MensajeriaEspecializada.HerramientasMensajeria.ConsultaTipoServicio
            With ddlTipoServicio
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un tipo de servicio", "0"))
                End If
            End With
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
    End Sub
    Private Sub ObtenerDatos()
        Try
            Dim dtPool As New DataTable()
            Dim servicioObj As New MensajeriaEspecializada.CargueServicioMensajeria()
            Integer.TryParse(txtNoRadicado.Text, servicioObj.NumeroRadicado)
            Integer.TryParse(ddlCiudad.SelectedValue.ToString(), servicioObj.IdCiudad)
            Integer.TryParse(ddlTipoServicio.SelectedValue.ToUpper(), servicioObj.IdTipoServicio)
            Integer.TryParse(Session("usxp007").ToString(), servicioObj.IdCiudadBodega)
            dtPool = servicioObj.GenerarPool()
            If Not dtPool.Rows.Count > 0 Then gvDatos.EmptyDataText = "<b>No se encontrario registros</b>"

            gvDatos.DataSource = dtPool
            gvDatos.DataBind()
        Catch ex As Exception
            Throw New Exception("Error al obtener los radicados. " & ex.Message)
        End Try
    End Sub

    Private Sub BorrarFiltro()
        Try
            ddlCiudad.ClearSelection()
            ddlTipoServicio.ClearSelection()
            txtNoRadicado.Text = String.Empty
            gvDatos.DataSource = New DataTable()
            gvDatos.EmptyDataText = ""
            gvDatos.DataBind()
        Catch ex As Exception
            Throw New Exception("Error al borrar los filtros. " & ex.Message)
        End Try
    End Sub

#End Region

    Protected Sub gvDatos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Try
            Dim idServicioGargue As Integer
            Integer.TryParse(e.CommandArgument.ToString, idServicioGargue)
            If e.CommandName = "Completar" Then
                Response.Redirect("EditarCargueServicio.aspx?idServicio=" & idServicioGargue.ToString())
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al realizar la operación. " & ex.Message)
        End Try
    End Sub
End Class