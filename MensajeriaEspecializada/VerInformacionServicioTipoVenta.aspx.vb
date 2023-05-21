Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text

Public Class VerInformacionServicioTipoVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private altoVentana As Integer
    Private anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        ObtenerTamanoVentana()
        If Not Me.IsPostBack Then
            Dim urlOrigen As String = ""
            If Request.UrlReferrer IsNot Nothing Then urlOrigen = System.IO.Path.GetFileName(Request.UrlReferrer.ToString)
            Dim idUsuario As Integer = 0
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim idServicio As Integer
            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With

            If idServicio > 0 Then
                Dim infoServicio As New ServicioMensajeriaVenta(idServicio:=idServicio)
                If Not infoServicio Is Nothing AndAlso infoServicio.Registrado Then
                    Dim respuesta As ResultadoProceso = evEncabezado.CargarInformacionGeneralServicio(infoServicio)
                    If respuesta.Valor <> 0 Then
                        epNotificador.showWarning(respuesta.Mensaje)
                    End If
                    VisualizarDocumentosAsociados(infoServicio.IdServicioMensajeria)
                    CargarNovedades(infoServicio.IdServicioMensajeria)
                    CargarHistorialReagenda(idServicio)
                    CargarHistoricoCambioEstado(idServicio, idUsuario)
                Else
                    epNotificador.showWarning("No existe un servicio registrado con el identificador proporcionado. Por favor regrese a la página anterior.")
                End If
            Else
                epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        End If
    End Sub

    Private Sub gvAgendamientos_DataBinding(sender As Object, e As EventArgs) Handles gvAgendamientos.DataBinding
        If Session("objAgenda") IsNot Nothing Then gvAgendamientos.DataSource = Session("objAgenda")
    End Sub

    Protected Sub gvNovedades_DataBinding(sender As Object, e As EventArgs) Handles gvNovedades.DataBinding
        If Session("objNovedades") IsNot Nothing Then gvNovedades.DataSource = Session("objNovedades")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me.altoVentana = CInt(arrAux(0))
                Me.anchoVentana = CInt(arrAux(1))
            End If
        End If
    End Sub

    Private Sub VisualizarDocumentosAsociados(idServicio As Integer)
        Try
            Dim dtDocumentos As DataTable = ServicioMensajeriaVenta.ObtenerDocumentosAsociados(idServicio)
            If dtDocumentos IsNot Nothing AndAlso dtDocumentos.Rows.Count > 0 Then
                Dim strMensaje As New StringBuilder
                For Each doc As DataRow In dtDocumentos.Rows
                    strMensaje.Append("- " & doc("nombre"))
                    If doc("recibo") = "1" Then
                        strMensaje.Append("&nbsp;<img src=" & Chr(34) & "../images/recibir.png" & Chr(34) & " style=" & Chr(34) & "width: 16px; height: 16px" & Chr(34) & "/>")
                    End If
                    If doc("entrega") = "1" Then
                        strMensaje.Append("&nbsp;<img src=" & Chr(34) & "../images/enviar.png" & Chr(34) & " style=" & Chr(34) & "width: 16px; height: 16px" & Chr(34) & "/>")
                    End If
                    strMensaje.Append("</br>")
                Next
                ClientScript.RegisterStartupScript(Me.GetType(), "Mensaje", "MostrarDocumentos('Documentos Asociados','" & strMensaje.ToString() & "')", True)
            End If
        Catch : End Try
    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)

            With gvNovedades
                .DataSource = listaNovedad.GenerarDataTable()
                Session("objNovedades") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarHistorialReagenda(ByVal idServicio As Integer)
        Try
            Dim dtHistorial As DataTable = HerramientasMensajeria.ConsultarHistorialReagenda(idServicio)
            With gvAgendamientos
                .DataSource = dtHistorial
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el historial de reagenda. " & ex.Message)
        End Try
    End Sub
    Private Sub CargarHistoricoCambioEstado(ByVal idServicio As Integer, ByVal idUsuario As Integer)
        Try
            Dim dtCambioEstado As DataTable = HerramientasMensajeria.ConsultarHistorialCambioEstado(idServicio, idUsuario)
            With gvCambioEstado
                .DataSource = dtCambioEstado
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el historial de cambio de estado. " & ex.Message)
        End Try
    End Sub

#End Region

End Class