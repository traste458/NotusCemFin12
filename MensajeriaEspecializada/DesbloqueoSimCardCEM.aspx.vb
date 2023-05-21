Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Inventario

Partial Public Class DesbloqueoSimCardCEM
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _idUsuario As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Desbloqueo Seriales CEM (ICCID)")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                pnlResultados.Visible = False
                lbBloqueo.Enabled = False
                txtIccid.Focus()
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub lbFiltros_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbFiltros.Click
        BuscarResultados()
    End Sub

    Protected Sub lbQuitarFiltros_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        BorrarControles()
    End Sub

    Protected Sub lbBloqueo_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbBloqueo.Click
        DesbloquearSerial()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarResultados()
        Dim dtDatos As New DataTable
        Try
            pnlResultados.Visible = True
            dtDatos = CargarReporte()
            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                lbBloqueo.Enabled = True
                txtIccid.Enabled = False
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                pnlResultados.Visible = False
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de generar reporte. " & ex.Message)
        End Try
    End Sub

    Private Function CargarReporte() As DataTable
        Dim datos As New DetalleBloqueoSerialServicioMensajeria
        Dim dtEstado As New DataTable

        Try
            With datos
                .Iccid = txtIccid.Text.Trim
            End With
            dtEstado = datos.CargarDatos
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el reporte de bloqueos. " & ex.Message)
        End Try
        Return dtEstado
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            pnlResultados.Visible = True
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Session("dtReporteDevolucion") = dtDatos
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub BorrarControles()
        pnlResultados.Visible = False
        lbBloqueo.Enabled = False
        txtIccid.Text = ""
        txtIccid.Enabled = True
        txtIccid.Focus()
    End Sub

    Private Sub DesbloquearSerial()
        Dim objBloqueoInventario As New BloqueoInventario()
        Dim objDetalleSerial As New DetalleSerialBloqueoColeccion()
        objDetalleSerial.Adicionar(New DetalleSerialBloqueo(txtIccid.Text.Trim))
        Dim resultado As ResultadoProceso = objBloqueoInventario.DesbloquearSerial(objDetalleSerial)
        If resultado.Valor = 0 Then
            epNotificacion.showSuccess("Se realizó el desbloqueo del serial satifactoriamente")
            BorrarControles()
        Else
            epNotificacion.showError(resultado.Mensaje)
        End If
    End Sub

#End Region

End Class