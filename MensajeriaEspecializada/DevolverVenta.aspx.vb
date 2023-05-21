Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class DevolverVenta
    Inherits System.Web.UI.Page
    Property idServicio As Integer
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                If Request.QueryString("idServicio") IsNot Nothing Then
                    Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
                    hfIdServicio.Value = idServicio.ToString
                    CargaTiposNovedad()
                Else
                    miEncabezado.showError("Se presentó un error al cargar la informacion por favor intente de nuevo: ")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub
    Private Sub btnDevolverVenta_Click(sender As Object, e As System.EventArgs) Handles btnDevolverVenta.Click
        miEncabezado.clear()
        DevolverVenta(hfIdServicio.Value)
    End Sub

    Private Sub DevolverVenta(idServicio As Integer)
        Try
            Dim resultado As New ResultadoProceso

            'Se registra la novedad de anulación
            Dim objNovedad As New NovedadServicioMensajeria()
            With objNovedad
                .IdServicioMensajeria = idServicio
                .IdUsuario = CInt(Session("usxp001"))
                .Observacion = txtObservacionDevolucion.Text
                .IdTipoNovedad = ddlTipoNovedadDevolucion.SelectedValue
                resultado = .Registrar(CInt(Session("usxp001")))
            End With

            If resultado.Valor = 0 Then
                'Se realiza el cambio de estado del servicio
                Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
                With objServicio
                    .IdEstado = Enumerados.EstadoServicio.DevueltoCallCenter
                    resultado = .Actualizar(CInt(Session("usxp001")))
                End With
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess("Servicio devuelto a Call Center Correctamente.")
                    btnDevolverVenta.Enabled = False
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar devolver la venta al Call Center: " & ex.Message)
        End Try
    End Sub
    Private Sub CargaTiposNovedad()
        Try
            Dim dtNovedades As DataTable = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Confirmacion)
            MetodosComunes.CargarDropDown(dtNovedades, ddlTipoNovedadDevolucion, "Seleccione...", True)
        Catch ex As Exception
            miEncabezado.showError("Se genero un error cargando los tipos de novedad.")
        End Try
    End Sub
End Class