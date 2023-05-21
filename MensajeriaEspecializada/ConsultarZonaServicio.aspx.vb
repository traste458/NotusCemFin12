Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer

Partial Public Class ConsultarZonaServicio
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            epPoolServicios.clear()
            If Not IsPostBack Then
                With epPoolServicios
                    .setTitle("Consultar Asignación de Rutas")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    pnlResultados.Visible = False
                End With
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de cargar la pagina. " & ex.Message)
        End Try
    End Sub

    Private Function BuscarZona() As DataTable
        Dim dtEstado As New DataTable
        Dim datos As New ReporteZonaServicio
        Try
            With datos
                If Not String.IsNullOrEmpty(txtNumeroRadicado.Text) Then .NumeroRadicado = txtNumeroRadicado.Text.Trim
            End With
            dtEstado = datos.ConsultarZona
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return dtEstado
    End Function

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Dim dtDatos As New DataTable
        Try
            pnlResultados.Visible = True
            dtDatos = BuscarZona()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epPoolServicios.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                pnlResultados.Visible = False
            End If
        Catch ex As Exception
            epPoolServicios.showError("Error al tratar de generar reporte. " & ex.Message)
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
            Session("dtZonaServicios") = dtDatos
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbQuitarFiltros_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Private Sub LimpiarFiltros()
        txtNumeroRadicado.Text = String.Empty
        pnlResultados.Visible = False
    End Sub

End Class