Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class LegalizarServicioFinanciero
    Inherits System.Web.UI.Page
    Property idServicio As Integer
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                If Request.QueryString("idServicio") IsNot Nothing Then
                    Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
                    hflegalizaIdServicio.Value = idServicio.ToString

                Else
                    miEncabezado.showError("Se presentó un error al cargar la informacion por favor intente de nuevo: ")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub lbLegaliza_Click(sender As Object, e As System.EventArgs) Handles lbLegaliza.Click
        LegalizarServicioFinanciero()
    End Sub

    Private Sub LegalizarServicioFinanciero()
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeria(CInt(hflegalizaIdServicio.Value))
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hflegalizaIdServicio.Value)
                .IdEstado = Enumerados.EstadoServicio.Entregadoalegalizacion
                resultado = .Actualizar(idUsuario)
            End With
            If resultado.Valor = 0 Then
                If miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancieros Or miServicio.IdTipoServicio = Enumerados.TipoServicio.Servicios_Financieros_Davivienda_AM_PM Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregadoalegalizacion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregadoalegalizacion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf miServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Entregadoalegalizacion, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                End If
                miEncabezado.showSuccess("El servicio fue legalizado satisfactoriamente.")
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de legalizar servicio. " & ex.Message)
        End Try
    End Sub
    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function
End Class