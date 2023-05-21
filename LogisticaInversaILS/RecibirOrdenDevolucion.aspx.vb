Imports ILSBusinessLayer
Imports ILSBusinessLayer.LogisticaInversa
Imports System.IO

Partial Public Class RecibirOrdenDevolucion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        If Not IsPostBack Then
            EncabezadoPagina1.setTitle("Recibir Orden de Devolución")
            EncabezadoPagina1.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            If Request.QueryString("ok") IsNot Nothing Then
                Dim idDevolucion As String = Request.QueryString("ok").ToString()
                EncabezadoPagina1.showSuccess("Se ha cerrado la devolución No. " & idDevolucion & " satisfactoriamente")
            End If
        End If
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        Dim filtro As New Estructuras.FiltroOrdenRecoleccion

        If rdbOrden.Checked Then
            filtro.IdOrden = txtID.Text
        Else
            filtro.Guia = txtID.Text
        End If
        Dim dt As DataTable = OrdenRecoleccion.ConsultarOrdenes(filtro)

        Dim idClienteLogytech As Integer = MetodosComunes.seleccionarConfigValue("CLIENTE_LOGYTECH")

        If dt.Rows.Count > 0 AndAlso dt.Rows(0)("idDestino") <> idClienteLogytech Then
            EncabezadoPagina1.showWarning("La recolección no tiene destino LOGYTECH MOBILE, el destino es " & dt.Rows(0)("destino") & " por favor verifique")
            Exit Sub
        End If
        If dt.Rows.Count > 0 Then
            Dim devolucion As Devolucion = devolucion.ObtenerPorOrdenRecoleccion(dt.Rows(0)("idOrden"))
            If devolucion.IdDevolucion > 0 Then
                If devolucion.IdEstado = 2 Then
                    EncabezadoPagina1.showWarning("La devolución ya se encuentra cerrada por favor verificar")
                ElseIf devolucion.IdGrupoDevolucion > 0 Then
                    Response.Redirect("LecturaDevolucionLogisticaInversa.aspx?idDevolucion=" & devolucion.IdDevolucion.ToString())
                Else
                    Response.Redirect("CrearOrdenDevolucionLogisticaInversa.aspx?idRecoleccion=" & dt.Rows(0)("idOrden") & "&idDevolucion=" & devolucion.IdDevolucion.ToString())
                End If
            Else
                HiddenFieldWarning.Value = dt.Rows(0)("idOrden")
                HiddenFieldWarning_ModalPopupExtender.Show()
            End If
        Else
            HiddenFieldWarning_DevMnual.Show()
        End If
    End Sub

    Protected Sub lnkCrearDevolucion_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkCrearDevolucion.Click
        Response.Redirect("CrearOrdenDevolucionLogisticaInversa.aspx?idRecoleccion=" & HiddenFieldWarning.Value)
    End Sub

    Protected Sub lnkCrearDevolucionManual_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkCrearDevolucionManual.Click
        Response.Redirect("..devoluciones/devoluciones_crear.asp")
    End Sub

    Private Sub GenerarActa()
        Dim devolucion As Devolucion = devolucion.ObtenerPorOrdenRecoleccion(txtIdRecoleccion.Text)
        Try
            If devolucion.IdDevolucion > 0 AndAlso devolucion.IdEstado > 1 Then
                Dim acta As New ReporteCrystal("ActaDevolucionLogisticaInversa", Server.MapPath("../reports/"))
                acta.agregarParametroDiscreto("@idDevolucion", devolucion.IdDevolucion)
                acta.agregarParametroDiscreto("@idRecoleccion", txtIdRecoleccion.Text)
                Dim ruta As String = acta.exportar(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat)
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "Acta", "window.open ('../reports/rptTemp/" + Path.GetFileName(ruta) + "','Acta', 'status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1'); ", True)
                txtIdRecoleccion.Text = ""
            Else
                EncabezadoPagina1.showWarning("La Recolección no ha sido confirmada o no existe")
            End If
        Catch ex As Exception
            EncabezadoPagina1.showError("Error al tratar de imprimir la devolución")
        End Try
    End Sub

    Protected Sub btnImprimir_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnImprimir.Click
        Me.GenerarActa()
    End Sub
End Class