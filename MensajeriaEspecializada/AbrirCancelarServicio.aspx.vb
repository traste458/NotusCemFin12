Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports System.Net
Imports System.IO

Public Class AbrirCancelarServicio
    Inherits System.Web.UI.Page
    Property idServicio As Integer
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()

            With miEncabezado
                .setTitle(Request.QueryString("idOpcion"))
                .showReturnLink("PoolServiciosNew.aspx")
            End With
            If Not IsPostBack Then
                If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
                If idServicio > 0 And Request.QueryString("idOpcion") IsNot Nothing Then
                    hfIdServicio.Value = idServicio.ToString
                    AbrirCancelarServicio(Request.QueryString("idOpcion"), idServicio)
                Else
                    miEncabezado.showError("Se presentó un error al cargar la informacion por favor intente de nuevo: ")
                End If
            End If

        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub
    Private Sub lbAbrirServicio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAbrirServicio.Click
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hfIdServicio.Value)
                resultado = .Reabrir(idUsuario, txtObservacionModificacion.Text, CInt(ddlEstadoReapertura.SelectedValue))
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("El servicio fue abierto satisfactoriamente.")
                Server.Transfer("PoolServiciosNew.aspx", True)
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de abrir servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub lbCancelarServicio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCancelarServicio.Click
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hfIdServicio.Value)
                resultado = .Cancelar(idUsuario, txtObservacionModificacion.Text)
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                'Envio de Gestion a NotusExpressBancolombia
                miServicio = New ServicioMensajeria(CInt(hfIdServicio.Value))
                If (miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (miServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                End If

                Server.Transfer("PoolServiciosNew.aspx", True)
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)

                Else
                    miEncabezado.showError(resultado.Mensaje)

                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cancelar servicio. " & ex.Message)
        End Try
    End Sub

    ' Acceder a una página Web usando WebRequest y WebResponse
    Sub leerPaginaWeb(ByVal laUrl As String)

        ' Cear la solicitud de la URL.
        Dim request As WebRequest = WebRequest.Create(laUrl)

        ' Obtener la respuesta.
        Dim response As WebResponse = request.GetResponse()

        ' Abrir el stream de la respuesta recibida.
        Dim reader As New StreamReader(response.GetResponseStream())

        ' Leer el contenido.
        Dim res As String = reader.ReadToEnd()

        ' Mostrarlo.
        Console.WriteLine(res)

        ' Cerrar los streams abiertos.
        reader.Close()
        response.Close()
    End Sub
#End Region
#Region "MetodosPrivados"

    Private Sub AbrirCancelarServicio(opcion As String, idServicio As Integer)
        Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)

        Dim bPuedeCancelar As Boolean = HerramientasMensajeria.ValidarNovedadEnProcesoActual(idServicio)

        pnlMensajeRestriccionNovedad.Visible = Not bPuedeCancelar
        txtObservacionModificacion.Text = String.Empty
        hfIdServicio.Value = idServicio.ToString
        lbAbrirServicio.Visible = IIf(opcion = "abrirServicio", True, False)
        pnlEstadoReapertura.Visible = IIf(opcion = "abrirServicio", True, False)
        lbCancelarServicio.Visible = IIf(opcion = "cancelarServicio", True, False)
        CragarEstadoReapertura(objServicio.IdEstado)
        lbAbrirServicio.Enabled = bPuedeCancelar
        lbCancelarServicio.Enabled = bPuedeCancelar

    End Sub
    Private Sub CragarEstadoReapertura(ByVal idEstadoActual As Integer)
        Dim dtEstado As New DataTable
        Try
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstadoReapertura(idEstadoActual)

            With ddlEstadoReapertura
                .DataSource = dtEstado
                .DataTextField = "nombre"
                .DataValueField = "idEstadoReapertura"
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListItem("Seleccione un Estado...", "0"))
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Estados. " & ex.Message)
        End Try
    End Sub
    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function
#End Region

End Class