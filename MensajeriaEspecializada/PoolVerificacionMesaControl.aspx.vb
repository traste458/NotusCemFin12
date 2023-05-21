Imports DevExpress.Web
Imports Microsoft.VisualBasic
Imports System
Imports DevExpress.Export
Imports DevExpress.Utils
Imports DevExpress.XtraPrinting
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports System.IO
Imports GemBox.Spreadsheet

Public Class PoolVerificacionMesaControl
    Inherits System.Web.UI.Page
    Private oExcel As ExcelFile
    Private _contenidoTablaCliente As String
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)



#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If
        Try
            If Not IsDBNull(Session("usxp001")) Then
                If Session("usxp001") <> 20608 Or Session("usxp001") <> 20099 Then

                End If
            End If
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("::::: Pool Verificacion Mesa de Control  :::::")
                End With
                Session.Remove("dtServicios")
                CargaInicial()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try

    End Sub
    Protected Sub gvDatos_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Dim resultadoBusqueda As String = String.Empty
        Try
            Dim resultado As New ResultadoProceso
            Dim arrAccion As String()

            arrAccion = e.Parameters.Split(":")
            gvDatos.FocusedRowIndex = arrAccion(1)
            Select Case arrAccion(0)
                Case "adendoServicio"
                    DescargarAdendo(arrAccion(1))
                Case "CheckALL"
                    Dim gridView As DevExpress.Web.ASPxGridView = CType(sender, DevExpress.Web.ASPxGridView)
                    If e.Parameters.StartsWith("CheckALL") Then

                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtrener la información:" & ex.Message)
        End Try

        If (String.IsNullOrEmpty(resultadoBusqueda)) Then
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Else
            CType(sender, ASPxGridView).JSProperties("cpBusquedaVta") = resultadoBusqueda
        End If

    End Sub
    Private Sub cpPopEstado_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPopEstado.Callback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "CargarCausal"
                    CargarComboCausal(arryAccion(1))
                Case "GuardarNovedad"
                    GuardarNovedad()
                    Session("dtCausal") = Nothing
                    causales.DataSource = Nothing
                    causales.DataBind()
                    mNovedadEs.Text = ""
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()

    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Dim arryAccion As String()
        arryAccion = e.Parameter.Split(":")
        Try
            Select Case arryAccion(0)
                Case "consultar"
                    resultado = ConsultarServicios()
                    CargaInicial()
                Case "marcarUrgente"
                    MarcarUrgente(arryAccion(1), sender)
                Case "QuitarCheckReagenda"
                    QuitarCheckReagenda(arryAccion(1), sender)
                Case "ReactivarServicio"
                    miEncabezado.clear()
                    CargarReactivarServicio(arryAccion(1), sender)
                Case "AbrirServicio"
                    miEncabezado.clear()
                    AbrirServicio("AbrirServicio", arryAccion(1), sender)

                Case "cancelarServicio"
                    miEncabezado.clear()
                    CancelarServicio("cancelarServicio", arryAccion(1), sender)

                Case "consultarRadicado"
                    Dim resultadoacti As Boolean
                    resultadoacti = ServicioMensajeria.ExisteNumeroRadicado(arryAccion(1))
                    imgError.ClientVisible = resultadoacti
                    If resultadoacti Then
                        txtNuevoRadicado.Text = ""
                        txtObservacionReactivacion.Text = ""
                        rbReactivacion.Value = 0
                        txtNuevoRadicado.ClientVisible = True
                    End If
                    miEncabezado.showError("El número de radicado digitado ya existe. ")
                Case "exportarPool"
                    Try
                        If Session("dtServicios") IsNot Nothing AndAlso CType(Session("dtServicios"), DataTable).Rows.Count > 0 Then
                            Dim dvDatos As DataView = CType(Session("dtServicios"), DataTable).DefaultView
                            Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaAsignacion", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "responsableEntrega", "tieneNovedad", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "barrio", "direccion", "telefonoContacto", "reagenda", "observacion")
                            MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, "Inventario.xls", Server.MapPath("../archivos_planos/Inventario.xls"), )
                        Else
                            miEncabezado.showWarning("No se encontraron datos para exportar, por favor intente nuevamente.")
                        End If

                    Catch ex As Exception
                        miEncabezado.showError("Error inesperado al intenetar Exportar el Pool: " & ex.Message)
                    End Try
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        If arryAccion(0) <> "consultar" And arryAccion(1) <> 2 Then
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End If
    End Sub

    Private Sub GuardarNovedad()
        Dim res As ResultadoProceso
        Dim origen As Integer = Integer.Parse(hdnIdOrigen("origen"))
        Dim idServicio As Integer = Integer.Parse(hdnIdNovedad("idServicio"))
        Dim novedades As String = ""
        Dim observacion As String = mNovedadEs.Text

        Dim idUsuario As Integer = CInt(Session("usxp001"))
        For Each lst As Object In causales.GridView().GetSelectedFieldValues("idCausal")
            novedades &= lst.ToString & ","

        Next
        If String.IsNullOrEmpty(novedades) Then
            miEncabezado.showWarning("seleccionar al menos 1 causal.")
            Return
        End If
        Dim novedadObj As New NovedadServicioMensajeria
        With novedadObj
            .IdServicioMensajeria = idServicio
            .OrigenCausal = origen
            .Causales = novedades
            .Observacion = observacion
        End With
        res = novedadObj.RegistrarRechazo(idUsuario)
        If res.Valor = 0 Then
            miEncabezado.showSuccess(res.Mensaje)
        Else
            miEncabezado.showError(res.Mensaje)
        End If
    End Sub
    Private Sub GuardarDevolucion(idServicio As Integer)
        Dim servicio As New ServicioMensajeria(idServicio)
        Dim res As New ResultadoProceso
        Try
            res = servicio.DevolucionMTI()
            If res.Valor = 0 Then
                ConsultarServicios()
                CargaInicial()
                miEncabezado.showSuccess(res.Mensaje)
            Else
                miEncabezado.showError(res.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al cambiar estado devolucion: " & ex.Message)
        End Try
    End Sub
    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtServicios") IsNot Nothing Then gvDatos.DataSource = CType(Session("dtServicios"), DataTable)
    End Sub
    Protected Sub LinkDatosCheck_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idTipoServicio As Integer
        Try
            Dim lnkAgregar As ASPxCheckBox = CType(sender, ASPxCheckBox)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            idTipoServicio = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idTipoServicio"))
            lnkAgregar.ClientSideEvents.CheckedChanged = lnkAgregar.ClientSideEvents.CheckedChanged.Replace("{0}", templateContainer.KeyValue)
            lnkAgregar.ClientSideEvents.CheckedChanged = lnkAgregar.ClientSideEvents.CheckedChanged.Replace("{1}", idTipoServicio)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades de reagenda: " & ex.Message)
        End Try
    End Sub
    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idEstado As Integer
        Dim idTipoServicio As Integer
        Dim idCiudadBodega As Integer
        Dim opcionesPermitidas As String
        Dim reagenda As Boolean
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            idEstado = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idEstado"))
            idTipoServicio = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idTipoServicio"))
            idCiudadBodega = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idCiudad"))
            opcionesPermitidas = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "permisosOpciones")
            reagenda = CBool(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "reagenda"))
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{1}", idTipoServicio)

            Dim controles() As String = opcionesPermitidas.ToString.Split("|")

            Dim arrControles() As String = {"lnkCargarArchivo", "lnkEstados", "lnkDevoluconMTI", ""}
            Dim existeControl As Integer

            For indice As Integer = 0 To arrControles.Length - 1
                existeControl = Array.IndexOf(controles, arrControles(indice))
                If existeControl <> -1 Then

                    If (controles(existeControl)) <> "ChckeEnviarabanco" Then
                        Dim ctrl As ASPxHyperLink = templateContainer.FindControl(arrControles(indice))
                        ctrl.ClientVisible = True
                    ElseIf ((controles(existeControl) = "ChckeEnviarabanco")) Then
                        Dim ctrl As ASPxCheckBox = templateContainer.FindControl(arrControles(indice))
                        ctrl.ClientVisible = True
                    Else
                        Dim ctrl As ASPxHyperLink = templateContainer.FindControl(arrControles(indice))
                        ctrl.ClientVisible = False
                    End If

                End If
            Next
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub LinkDatos_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idTipoServicio As Integer
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            idTipoServicio = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idTipoServicio"))
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{1}", idTipoServicio)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub LinkidServicio_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub


#End Region

#Region "MetodosPrivados"
    Private Sub CargaInicial()
        '*** Cargar Estados ***
        Dim dtEstado As New DataTable
        Dim dtBodega As New DataTable
        Dim dtCiudad As New DataTable
        Dim dtTipoServidio As New DataTable

        If Session("dtEstado") Is Nothing Then
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstadoMesaControl
            Session("dtEstado") = dtEstado
        End If
        MetodosComunes.CargarComboDX(cmbEstado, CType(Session("dtEstado"), DataTable), "idEstado", "nombre")


    End Sub
    Private Function ConsultarServicios(Optional ByVal idServicio As Integer = 0) As ResultadoProceso

        Dim resultado As New ResultadoProceso
        Try
            Dim idPerfil As Integer
            If Session("usxp009") IsNot Nothing Then Integer.TryParse(Session("usxp009"), idPerfil)
            Dim idUsuario As Integer = CInt(Session("usxp001"))

            Dim objServicio As New GenerarPoolServicioMensajeria
            With objServicio
                If idServicio = 0 Then
                    If mePedidos.Text.Length > 0 Then
                        If rblTipoServicio.Value = 0 Then
                            For Each ped As Object In mePedidos.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                                .ListaIdServicio.Add(CStr(ped))
                            Next
                        Else
                            For Each ped As Object In mePedidos.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                                .ListaNumeroRadicado.Add(CStr(ped))
                            Next
                        End If
                    End If
                    If cmbEstado.Value > 0 Then .IdEstado = cmbEstado.Value
                    If dateFechaInicio.Date > Date.MinValue Then .FechaInicial = dateFechaInicio.Date
                    If dateFechaFin.Date > Date.MinValue Then .FechaFinal = dateFechaFin.Date
                    If TextBIdentificaion.Text <> "" And TextBIdentificaion.Text IsNot Nothing Then .Identificaion = TextBIdentificaion.Text


                Else
                    .ListaIdServicio.Add(CStr(idServicio))
                End If
                .IdUsuarioGenerador = CInt(Session("usxp001"))
                Session("dtServicios") = .GenerarPoolneMesaControl()
            End With
            With gvDatos
                .DataSource = CType(Session("dtServicios"), DataTable)
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de servicios. " & ex.Message)
        End Try
        Return resultado
    End Function
    Private Sub AbrirCancelarServicio(opcion As String, idServicio As Integer)
        Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)

        Dim bPuedeCancelar As Boolean = HerramientasMensajeria.ValidarNovedadEnProcesoActual(idServicio)

        pnlMensajeRestriccionNovedad.Visible = Not bPuedeCancelar
        txtObservacionModificacion.Text = String.Empty
        hfIdServicio.Value = idServicio.ToString
        lbAbrirServicio.ClientVisible = IIf(opcion = "abrirServicio", True, False)
        pnlEstadoReapertura.Visible = IIf(opcion = "abrirServicio", True, False)
        ddlEstadoReapertura.Visible = IIf(opcion = "abrirServicio", True, False)
        lbCancelarServicio.ClientVisible = IIf(opcion = "cancelarServicio", True, False)
        CragarEstadoReapertura(objServicio.IdEstado)
        If (bPuedeCancelar = True) Then
            pnlMensajeRestriccionNovedad.Visible = False
        Else
            pnlMensajeRestriccionNovedad.Visible = True
        End If
        lbAbrirServicio.Enabled = bPuedeCancelar
        lbCancelarServicio.Enabled = bPuedeCancelar

    End Sub
    Private Sub AbrirServicio(opcion As String, idServicio As Integer, sender As Object)
        Try
            Dim resultado As ResultadoProceso
            Dim resul As ResultadoProceso
            Dim miServicio As New ServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hfIdServicio.Value)
                resultado = .Reabrir(idUsuario, txtObservacionModificacion.Text, CInt(ddlEstadoReapertura.SelectedValue))
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("El servicio fue abierto satisfactoriamente.")
                txtObservacionModificacion.Text = ""
                resul = ConsultarServicios()
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de abrir servicio. " & ex.Message)
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Private Sub CancelarServicio(opcion As String, idServicio As Integer, sender As Object)
        Try
            Dim resultado As ResultadoProceso
            Dim resul As ResultadoProceso
            Dim miServicio As New ServicioMensajeria
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            With miServicio
                .IdServicioMensajeria = CInt(hfIdServicio.Value)
                resultado = .Cancelar(idUsuario, txtObservacionModificacion.Text)
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                resul = ConsultarServicios()
                txtObservacionModificacion.Text = ""
                'Envio de Gestion a NotusExpressBancolombia
                miServicio = New ServicioMensajeria(CInt(hfIdServicio.Value))
                If (miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressBancolombia, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (miServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                ElseIf (miServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                    resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, miServicio.IdServicioMensajeria, Enumerados.EstadoServicio.Cerrado, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                End If
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)

                Else
                    miEncabezado.showError(resultado.Mensaje)

                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cancelar servicio. " & ex.Message)
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function
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

    Private Sub DescargarAdendo(ByVal idServicio As Long)
        Try
            Dim rpt As ReporteCrystal

            rpt = New ReporteCrystal("HojaAdendo", Server.MapPath("../MensajeriaEspecializada/Reportes"))

            rpt.agregarParametroDiscreto("@idServicioMensajeria", idServicio)
            Dim ruta As String = rpt.exportar(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat)
            If Not File.Exists(ruta) Then Throw New Exception("Imposible generar archivo del Adendo. Por favor intente nuevamente")
            ruta = Path.GetFileName(ruta)
            ruta = Me.ResolveClientUrl("~/MensajeriaEspecializada/Reportes/rptTemp/" & ruta)
            If Not String.IsNullOrEmpty(ruta) Then gvDatos.JSProperties.Add("cpDescargarArchivo", ruta)

        Catch ex As Exception
            miEncabezado.showError("Error al descargar el adendo.")
        End Try
    End Sub
    Private Sub MarcarUrgente(ByVal idServicio As Integer, sender As Object)
        Try
            Dim idUsuario As Integer = 1
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim objServicio As New ServicioMensajeria(idServicio:=idServicio)
            objServicio.Urgente = True

            Dim resultado As ResultadoProceso = objServicio.Actualizar(idUsuario)

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Se realizó marcación de urgente correctamente.")
            Else
                miEncabezado.showWarning("No se logro marcar como urgente el servicio: " & resultado.Mensaje)
            End If

        Catch ex As Exception
            miEncabezado.showError("Error inesperado al intenetar marcar como urgente: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub ExportarPool(sender As Object)
        Try
            If Session("dtServicios") IsNot Nothing AndAlso CType(Session("dtServicios"), DataTable).Rows.Count > 0 Then
                Dim dvDatos As DataView = CType(Session("dtServicios"), DataTable).DefaultView
                'Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaAsignacion", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "responsableEntrega", "tieneNovedad", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "barrio", "direccion", "telefonoContacto", "reagenda", "observacion")
                Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaRecepcionMesaControl", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "telefonoContacto", "reagenda", "observacion")
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, "Inventario.xls", Server.MapPath("../archivos_planos/Inventario.xls"), )
            Else
                miEncabezado.showWarning("No se encontraron datos para exportar, por favor intente nuevamente.")
            End If

        Catch ex As Exception
            miEncabezado.showError("Error inesperado al intenetar Exportar el Pool: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub


    Private Sub CargarComboCausal(origen As Integer)
        causales.Text = ""
        causales.DataSource = Nothing
        causales.DataBind()
        causales.GridView.Selection.UnselectAll()
        Dim dt As DataTable
        Dim causalesObj As New GenerarPoolServicioMensajeria()
        dt = causalesObj.ConsultaCausales(origen)
        Session("dtCausal") = dt
        causales.DataSource = dt
        causales.DataBind()
        causales.KeyFieldName = "idCausal"
    End Sub
#End Region

    Private Sub CargarReactivarServicio(ByVal idServicio As Integer, sender As Object)
        Try
            Dim resultado As ResultadoProceso
            Dim miServicio As New ServicioMensajeria

            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)

            Dim nuevoRadicado As Long
            Long.TryParse(txtNuevoRadicado.Text, nuevoRadicado)

            With miServicio
                .IdServicioMensajeria = idServicio
                resultado = .Reactivar(idUsuario, txtObservacionReactivacion.Text, Enumerados.EstadoServicio.Creado, nuevoRadicado)
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("El servicio fue reactivado satisfactoriamente.")
                lbReactivar.ClientEnabled = False
                resultado = ConsultarServicios()
                pcReactivarServicio.ShowOnPageLoad = True
                Dim script As String = String.Format("<script type=""text/javascript""> HidePopUp(); </script>")
                ClientScript.RegisterStartupScript(Type.GetType("System.String"), "key", script)


                pcReactivarServicio.CloseAction = DevExpress.Web.CloseAction.CloseButton
            Else
                If resultado.Valor = 1 Or resultado.Valor = 10 Then
                    miEncabezado.showWarning(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de reactivar servicio. " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub QuitarCheckReagenda(ByVal idServicio As Integer, sender As Object)

        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Dim resultado As New ResultadoProceso
        Try
            'Se registra la novedad de anulación
            Dim objNovedad As New NovedadServicioMensajeria()
            With objNovedad
                .IdServicioMensajeria = idServicio
                .IdUsuario = idUsuario
                .Observacion = txtObservacionReagenda.Text
                .IdTipoNovedad = ddlNovedadReagenda.SelectedValue
                resultado = .Registrar(idUsuario)
            End With

            If resultado.Valor = 0 Then
                ' Se realiza el levantamiento del check de reagenda del servicio
                Dim objServicio As ServicioMensajeria = New ServicioMensajeria()
                With objServicio
                    .IdServicioMensajeria = idServicio
                    resultado = .ActualizarReagenda(idUsuario, objServicio)
                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess("Servicio actualizado correctamente.")
                        resultado = ConsultarServicios()
                    Else
                        miEncabezado.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
                    End If
                End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar quitar el chek de reagenda: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(source As Object, e As ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            Dim fecha As DateTime = DateTime.Now
            Dim fec As String = fecha.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim nombre As String = "PooldeServicios"
            nombre = nombre & "_" & Session("usxp001") & "_" & fec & ".xlsx"
            If Session("dtServicios") IsNot Nothing AndAlso CType(Session("dtServicios"), DataTable).Rows.Count > 0 Then
                Dim dvDatos As DataView = CType(Session("dtServicios"), DataTable).DefaultView
                Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaRecepcionMesaControl", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "telefonoContacto", "reagenda", "observacion")
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, nombre, Server.MapPath("../archivos_planos/" & nombre), )
            Else
                miEncabezado.showWarning("No se encontraron datos para exportar, por favor intente nuevamente.")
            End If

        Catch ex As Exception
            miEncabezado.showError("Error inesperado al intenetar Exportar el Pool: " & ex.Message)
        End Try
    End Sub

    Protected Sub pcAbrirCancelarServicio_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcAbrirCancelarServicio.WindowCallback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "AbrirServicio"
                    AbrirCancelarServicio("AbrirServicio", arryAccion(1))
                Case "cancelarServicio"
                    AbrirCancelarServicio("cancelarServicio", arryAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub LstCausal_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim values As String = ""
        For Each item As ListEditItem In sender.items
            If item.Selected Then
                values &= item.Value.ToString() & ","
            End If
        Next

    End Sub

    Protected Sub LstCausal_DataBinding(sender As Object, e As EventArgs) Handles causales.DataBinding
        If sender.DataSource Is Nothing Then sender.DataSource = Session("dtCausal")
    End Sub
End Class