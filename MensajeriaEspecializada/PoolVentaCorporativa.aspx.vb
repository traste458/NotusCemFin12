Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.WMS
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion
Imports DevExpress.Web

Public Class PoolVentaCorporativa
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Pool Gestión de Servicios Venta Corporativa")
                End With
                CargarPermisosOpcionesRestringidas()
                CargarRestriccionesDeOpcionPorEstados()
                CargaInicial()
            End If
            If cmbCiudad.IsCallback Then
                CargaInicial()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idEstado As Integer
        Dim idTipoServicio As Integer
        Dim idCiudadBodega As Integer
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idEstado = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdEstado"))
            idTipoServicio = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdTipoServicio"))
            idCiudadBodega = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdCiudad"))
            Dim lnkBloqueo As ASPxHyperLink = templateContainer.FindControl("lnkBloqueo")
            Dim lnkFacturar As ASPxHyperLink = templateContainer.FindControl("lnkFacturar")
            Dim lnkEditarMin As ASPxHyperLink = templateContainer.FindControl("lnkEditarMin")
            Dim lnkEditarMinP As ASPxHyperLink = templateContainer.FindControl("lnkEditarMinP")
            Dim lnkLiberar As ASPxHyperLink = templateContainer.FindControl("lnkLiberar")

            If Session("usxp009") = 165 Then
                Select Case idTipoServicio
                    Case Enumerados.TipoServicio.VentaCorporativa
                        If idEstado = Enumerados.EstadoServicio.SerialesAsignados Then
                            lnkBloqueo.Visible = True
                        Else
                            lnkBloqueo.Visible = False
                        End If
                    Case Enumerados.TipoServicio.VentaCorporativaPrestamo
                        If idEstado = Enumerados.EstadoServicio.Entregado Then
                            lnkBloqueo.Visible = True
                        Else
                            lnkBloqueo.Visible = False
                        End If
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")
                End Select
            Else
                lnkBloqueo.Visible = False
            End If

            Dim arrControles() As String = {"lnkFacturar", "lnkEditarMin", "lnkEditarMinP", "lnkLiberar"}
            For indice As Integer = 0 To arrControles.Length - 1
                Dim ctrl As ASPxHyperLink = templateContainer.FindControl(arrControles(indice))
                ctrl.Visible = False
                If ctrl IsNot Nothing Then
                    ctrl.Visible = EsVisibleOpcionRestringida(ctrl.ID, idCiudadBodega, idTipoServicio)
                    If ctrl.Visible Then ctrl.Visible = EsVisibleSegunEstado(ctrl.ID, idEstado)
                    ctrl.ClientSideEvents.Click = ctrl.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
                End If
            Next

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select arryAccion(0)
                Case "consultar"
                    resultado = ConsultarServicios()
                    CargaInicial()
                Case "bloquearServicio"
                    resultado = BloquearServicio(arryAccion(1))
                    If resultado.Valor = 0 Then
                        ConsultarServicios()
                    End If
                    CargaInicial()
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtServicios") IsNot Nothing Then gvDatos.DataSource = CType(Session("dtServicios"), DataTable)
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveDatos
                .FileName = "Pool Gestión de Servicios"
                .ReportHeader = "Pool Gestión de Servicios" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            Select Case formato
                Case "xls"
                    gveDatos.WriteXlsToResponse()
                Case "pdf"
                    With gveDatos
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveDatos.WriteXlsxToResponse()
                Case "csv"
                    gveDatos.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            If Session("dtInfoPermisosOpcRestringidas") Is Nothing Then
                Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
                Session("dtInfoPermisosOpcRestringidas") = dtPermisos
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            If Session("dtInfoRestriccionOpcEstado") Is Nothing Then
                Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
                Session("dtInfoRestriccionOpcEstado") = dtRestriccion
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        '*** Cargar Estados ***
        Dim dtEstado As New DataTable
        Dim dtBodega As New DataTable
        Dim dtCiudad As New DataTable
        Dim dtTipoServidio As New DataTable

        If Session("dtEstado") Is Nothing Then
            dtEstado = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional("cmbEstado")
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstado
            Session("dtEstado") = dtEstado
        End If
        MetodosComunes.CargarComboDX(cmbEstado, CType(Session("dtEstado"), DataTable), "idEstado", "nombre")

        '*** Cargar la bodega ***
        If Session("dtBodega") Is Nothing Then
            dtBodega = HerramientasMensajeria.ConsultarBodega(idUsuarioConsulta:=CInt(Session("usxp001")))
            Session("dtBodega") = dtBodega
        End If
        MetodosComunes.CargarComboDX(cmbBodega, CType(Session("dtBodega"), DataTable), "idbodega", "bodega")

        '*** Cargar Ciudades ***
        If Session("dtCiudad") Is Nothing Then
            dtCiudad = Ciudad.ObtenerCiudadesPorPais
            Session("dtCiudad") = dtCiudad
        End If
        MetodosComunes.CargarComboDX(cmbCiudad, CType(Session("dtCiudad"), DataTable), "idCiudad", "nombre")

        '*** Cargar tipo servicio ***
        If Session("dtTipoServidio") Is Nothing Then
            dtTipoServidio = HerramientasMensajeria.ConsultaTipoServicio(idUsuarioConsulta:=CInt(Session("usxp001")))
            Session("dtTipoServidio") = dtTipoServidio
        End If
        MetodosComunes.CargarComboDX(cmbTipoServicio, CType(Session("dtTipoServidio"), DataTable), "idTipoServicio", "nombre")

    End Sub

    Private Function ConsultarServicios(Optional ByVal idServicio As Integer = 0) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objServicio As New ServicioMensajeriaVentaCorporativaColeccion
        With objServicio
            If idServicio = 0 Then
                If mePedidos.Text.Length > 0 Then
                    If rblTipoServicio.Value = 0 Then
                        For Each ped As Object In mePedidos.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                            .ListaIdServicio.Add(CStr(ped))
                        Next
                    Else
                        For Each ped As Object In mePedidos.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                            .ListaRadicado.Add(CStr(ped))
                        Next
                    End If
                End If
                If cmbCiudad.Value > 0 Then .ListaIdCiudad.Add(CInt(cmbCiudad.Value))
                If cmbEstado.Value > 0 Then .ListaIdEstado.Add(CInt(cmbEstado.Value))
                If cmbBodega.Value > 0 Then .ListaIdBodega.Add(CInt(cmbBodega.Value))
                If cmbTipoServicio.Value > 0 Then .ListaIdTipoServicio.Add(CInt(cmbTipoServicio.Value))
                If dateFechaInicio.Date > Date.MinValue Then .FechaInicial = dateFechaInicio.Date
                If dateFechaFin.Date > Date.MinValue Then .FechaFinal = dateFechaFin.Date
            Else
                .ListaIdServicio.Add(CStr(idServicio))
            End If
            .IdUsuarioConsulta = CInt(Session("usxp001"))
            Session("dtServicios") = .GenerarDataTable()
        End With
        With gvDatos
            .DataSource = CType(Session("dtServicios"), DataTable)
            .DataBind()
        End With
        Return resultado
    End Function

    Private Function BloquearServicio(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objServicio As New ServicioMensajeriaVentaCorporativa()
        With objServicio
            .IdUsuario = CInt(Session("usxp001"))
            .IdServicioMensajeria = idServicio
            .IdEstado = Enumerados.EstadoServicio.Asignadoaresponsable
            .IdPersonaBackOficce = CInt(Session("usxp001"))
            resultado = .Editar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

#End Region

End Class