Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports iTextSharp.text.pdf
Imports System.Collections.Generic
Imports System.IO

Public Class PoolServiciosNew
    Inherits System.Web.UI.Page
    Private oExcel As ExcelFile
    Private _contenidoTablaCliente As String
    Private _rutaOrigenArchivo As String = String.Empty
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118

        Session("usxp007") = 150
#End If
        Seguridad.verificarSession(Me)
        Try
            If Not IsDBNull(Session("usxp001")) Then
                If Session("usxp001") <> 20608 Or Session("usxp001") <> 20099 Then

                End If
            End If
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Pool Servicios")
                End With
                Session.Remove("dtServicios")
                Session.Remove("dtTipoServidio")
                Session.Remove("dtEstado")
                Session.Remove("dtCiudad")
                Session.Remove("dtBodega")
                Session.Remove("dtTransportadora")
                CargaInicial()
            End If

            If Request.QueryString("resOk") IsNot Nothing Then
                Select Case Request.QueryString("codRes")
                    Case "1"
                        miEncabezado.showSuccess("El servicio fue confirmado satisfactoriamente.")
                    Case "2"
                        miEncabezado.showSuccess("El despacho fue cerrado satisfactoriamente.")
                    Case "3"
                        miEncabezado.showSuccess("El cambio de servicio fue finalizado satisfactoriamente.")
                    Case Else
                        miEncabezado.showSuccess("Se presentó un error al cargar la página:")
                End Select
            End If

        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try

    End Sub

    Protected Sub Page_init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        CargaInicial()
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
                Case "ConsultaVentaCliente"
                    resultadoBusqueda = ConsultaAutocomplete(arrAccion(1))
                Case "VerDocsMC"
                    resultadoBusqueda = VerDocumentosMesaC(arrAccion(1))
                Case "GuardarRechazoDocumentos"
                    resultadoBusqueda = GuardarRechazoDocMC(arrAccion(1), arrAccion(2))
                Case "AprobarDocumentos"
                    resultadoBusqueda = AprobarDocumentosMC(arrAccion(1))
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

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "consultar"
                    resultado = ConsultarServicios()

                    If resultado.Valor = 1 Then
                        miEncabezado.showError(resultado.Mensaje)
                    End If

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
                Case "ObtenerDatosTransportador"
                    ObtenerDatosTransportador(arryAccion(1), sender)
                Case "exportarPool"
                    Try
                        If Session("dtServicios") IsNot Nothing AndAlso CType(Session("dtServicios"), DataTable).Rows.Count > 0 Then
                            Dim dvDatos As DataView = CType(Session("dtServicios"), DataTable).DefaultView
                            Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "empresa", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaAsignacion", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "responsableEntrega", "tieneNovedad", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "barrio", "direccion", "telefonoContacto", "reagenda", "observacion")
                            MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, "Inventario.xls", Server.MapPath("../archivos_planos/Inventario.xls"), )
                        Else
                            miEncabezado.showWarning("No se encontraron datos para exportar, por favor intente nuevamente.")
                        End If

                    Catch ex As Exception
                        miEncabezado.showError("Error inesperado al intenetar Exportar el Pool: " & ex.Message)
                    End Try
                Case "ImprimirFormulario"
                    GenerarYDescargarSolicitudCredito(CType(arryAccion(1), Integer))
                    CargaInicial()
                Case "NotificarVencimiento"
                    miEncabezado.clear()
                    NotificarVencimientoServicios(arryAccion(1), sender)
                Case "AsignarTransportadorDelivery"
                    AsignarTransportadorDelivery(arryAccion(1), sender)
                Case "NotificarNoCobertura"
                    NotificarNoCobertura(arryAccion(1), sender)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        CType(sender, ASPxCallbackPanel).JSProperties("cpRutaArchivo") = _rutaOrigenArchivo
    End Sub

    Public Function GenerarYDescargarSolicitudCredito(ByVal idServicio As Integer) As Boolean
        Try

            Dim formulario As New DescargarSolicitudCreditoPersonaNatural()
            Dim dtDatosVenta As New DataSet
            dtDatosVenta = formulario.ConsultarInformacionPrestamoCliente(idServicio)
            Dim fecha = CStr(Date.Now).Replace("/", "_").Replace(":", "_").Replace(" ", "_")
            Dim pdfTemplate As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/DAVSolicitudCreditoPersonaNatural.pdf")
            Dim newFile As String = Server.MapPath("~/MensajeriaEspecializada/TemporalPlanillaRadicacionBanco/SolicitudCreditoPersonaNatural_" & idServicio & "__" & fecha & ".pdf")
            Dim pdfReader As New PdfReader(pdfTemplate)
            Dim pdfStamper As New PdfStamper(pdfReader, New FileStream(newFile, FileMode.Create))
            Dim pdfFormFields As AcroFields = pdfStamper.AcroFields

            If (dtDatosVenta IsNot Nothing AndAlso dtDatosVenta.Tables(0).Rows.Count > 0) Then
                ' Asigna los campos
                pdfFormFields.SetField("Nombres_2", dtDatosVenta.Tables(0).Rows(0).Item("nombres").ToString())
                pdfFormFields.SetField("Primer apellido_2", dtDatosVenta.Tables(0).Rows(0).Item("primerApellido").ToString())
                pdfFormFields.SetField("Segundo apellido_2", dtDatosVenta.Tables(0).Rows(0).Item("segundoApellido").ToString())
                pdfFormFields.SetField("TIPO IDEN PRIMER", dtDatosVenta.Tables(0).Rows(0).Item("tipo_identificacion").ToString())
                pdfFormFields.SetField("No identificación_3", dtDatosVenta.Tables(0).Rows(0).Item("numeroIdentificacion").ToString())

                pdfFormFields.SetField("COD OFICINA", dtDatosVenta.Tables(0).Rows(0).Item("codOficina1").ToString())

                'pdfFormFields.SetField("Nombre_oficina", dtDatosVenta.Tables(0).Rows(0).Item("nombreOficina").ToString())
                'pdfFormFields.SetField("Codsucursal", dtDatosVenta.Tables(0).Rows(0).Item("Ciudad").ToString())
                pdfFormFields.SetField("Agente vendedor", dtDatosVenta.Tables(0).Rows(0).Item("agente_vendedor").ToString())
                pdfFormFields.SetField("Código estrategia", dtDatosVenta.Tables(0).Rows(0).Item("codigoEstrategia").ToString())
                pdfFormFields.SetField("HERRAMIENTA", dtDatosVenta.Tables(0).Rows(0).Item("herramienta").ToString())

                '2.INFORMACIÓN DEL SOLICITANTE TITULAR

                pdfFormFields.SetField("1. Nombres", dtDatosVenta.Tables(0).Rows(0).Item("nombres").ToString())
                pdfFormFields.SetField("1. Primer apellido", dtDatosVenta.Tables(0).Rows(0).Item("primerApellido").ToString())
                pdfFormFields.SetField("1. segundo apellido", dtDatosVenta.Tables(0).Rows(0).Item("segundoApellido").ToString())
                pdfFormFields.SetField("GÉNERO", dtDatosVenta.Tables(0).Rows(0).Item("sexo").ToString())
                pdfFormFields.SetField("1. TIPO IDEN PRIMER", dtDatosVenta.Tables(0).Rows(0).Item("tipo_identificacion").ToString())
                pdfFormFields.SetField("1. No identificacion", dtDatosVenta.Tables(0).Rows(0).Item("numeroIdentificacion").ToString())

                '2.1 Localizacion
                pdfFormFields.SetField("Dirección residencia", dtDatosVenta.Tables(0).Rows(0).Item("direccionResidencia").ToString())
                pdfFormFields.SetField("Ciudad_3", dtDatosVenta.Tables(0).Rows(0).Item("Ciudad").ToString())
                pdfFormFields.SetField("Tel fijo_2", dtDatosVenta.Tables(0).Rows(0).Item("telefonoResidencia").ToString())
                pdfFormFields.SetField("Celular_2", dtDatosVenta.Tables(0).Rows(0).Item("celular").ToString())
                pdfFormFields.SetField("Tel fijo_3", dtDatosVenta.Tables(0).Rows(0).Item("telefonoAdicional").ToString())
                pdfFormFields.SetField("Email", dtDatosVenta.Tables(0).Rows(0).Item("email").ToString())

                '3.INFORMACIÓN OTRO SOLICITANTE
                pdfFormFields.SetField("DESCIPCION ACTIVOS", dtDatosVenta.Tables(0).Rows(0).Item("descripcion_activos").ToString())
                pdfFormFields.SetField("ACT OTROS", dtDatosVenta.Tables(0).Rows(0).Item("total_activos").ToString())
                pdfFormFields.SetFieldProperty("TOTAL ACTIVOS", "flags", PdfFormField.FLAGS_PRINT, Nothing)
                pdfFormFields.SetField("TOTAL ACTIVOS", pdfFormFields.GetField("ACT OTROS").ToString())
                pdfFormFields.SetField("PAS OTROS", dtDatosVenta.Tables(0).Rows(0).Item("total_pasivos").ToString())
                pdfFormFields.SetField("DESCIPCION PASIVOS", dtDatosVenta.Tables(0).Rows(0).Item("descripcion_pasivos").ToString())
                pdfFormFields.SetFieldProperty("TOTAL PASIVOS", "flags", PdfFormField.FLAGS_READONLY, Nothing)
                pdfFormFields.SetField("TOTAL PASIVOS", dtDatosVenta.Tables(0).Rows(0).Item("total_pasivos").ToString())
                pdfFormFields.SetField("FIRMAS ID", dtDatosVenta.Tables(0).Rows(0).Item("tipo_identificacion").ToString())
                pdfFormFields.SetField("FIRMAS DOC", dtDatosVenta.Tables(0).Rows(0).Item("numeroIdentificacion").ToString())

                '4. DECLARACION ENTREVISTA CLIENTE
                pdfFormFields.SetField("Teléfono final", dtDatosVenta.Tables(0).Rows(0).Item("telefono_final").ToString())
                pdfFormFields.SetField("Cargo final", dtDatosVenta.Tables(0).Rows(0).Item("cargo_final").ToString())
                pdfFormFields.SetField("Área final", dtDatosVenta.Tables(0).Rows(0).Item("area_final").ToString())
                pdfFormFields.SetField("Tipo de identificación final", dtDatosVenta.Tables(0).Rows(0).Item("tipo_identificacion").ToString())

            End If

            pdfFormFields.SetFieldProperty("TC", "flags", PdfFormField.FLAGS_READONLY, Nothing)
            pdfFormFields.SetFieldProperty("TC", "flags", PdfFormField.FLAGS_PRINT, Nothing)
            pdfFormFields.SetFieldProperty("TipoTC_Visa", "flags", PdfFormField.FLAGS_READONLY, Nothing)
            pdfFormFields.SetFieldProperty("TipoTC_Visa", "flags", PdfFormField.FLAGS_PRINT, Nothing)
            'TARJETA DE CREDITO
            If (dtDatosVenta IsNot Nothing AndAlso dtDatosVenta.Tables(1).Rows.Count > 0) Then
                pdfFormFields.SetField("TC", dtDatosVenta.Tables(1).Rows(0).Item("tipo_credito").ToString())
                pdfFormFields.SetField("TipoTC_Visa", dtDatosVenta.Tables(1).Rows(0).Item("subproducto").ToString())
                pdfFormFields.SetField("Cupo solicitado TC", dtDatosVenta.Tables(1).Rows(0).Item("valorCupo").ToString())
                If (dtDatosVenta.Tables(1).Rows.Count > 1) Then

                    pdfFormFields.SetField("2DO TC", dtDatosVenta.Tables(1).Rows(1).Item("tipo_credito").ToString())
                    pdfFormFields.SetFieldProperty("TipoTC_Diners", "flags", PdfFormField.FLAGS_READONLY, Nothing)
                    pdfFormFields.SetFieldProperty("TipoTC_Diners", "flags", PdfFormField.FLAGS_PRINT, Nothing)
                    pdfFormFields.SetField("2DO TipoTC_Diners", dtDatosVenta.Tables(1).Rows(1).Item("subproducto").ToString())
                    pdfFormFields.SetField("2DO Cupo solicitado TC", dtDatosVenta.Tables(1).Rows(1).Item("valorCupo").ToString())
                    If (dtDatosVenta.Tables(1).Rows.Count > 2) Then

                        pdfFormFields.SetField("3ER TC", dtDatosVenta.Tables(1).Rows(2).Item("tipo_credito").ToString())
                        pdfFormFields.SetField("3ER TipoTC_Visa", dtDatosVenta.Tables(1).Rows(2).Item("subproducto").ToString())
                        pdfFormFields.SetField("3ER Cupo solicitado TC", dtDatosVenta.Tables(1).Rows(2).Item("valorCupo").ToString())
                        If (dtDatosVenta.Tables(1).Rows.Count > 3) Then

                            pdfFormFields.SetField("4TO TC", dtDatosVenta.Tables(1).Rows(3).Item("tipo_credito").ToString())
                            pdfFormFields.SetField("4TO TipoTC_Visa", dtDatosVenta.Tables(1).Rows(3).Item("subproducto").ToString())
                            pdfFormFields.SetField("4TO Cupo solicitado TC", dtDatosVenta.Tables(1).Rows(3).Item("valorCupo").ToString())
                            If (dtDatosVenta.Tables(1).Rows.Count > 4) Then

                                pdfFormFields.SetField("5TO TC", dtDatosVenta.Tables(1).Rows(4).Item("tipo_credito").ToString())
                                pdfFormFields.SetField("5TO TipoTC_Visa", dtDatosVenta.Tables(1).Rows(4).Item("subproducto").ToString())
                                pdfFormFields.SetField("5TO Cupo solicitado TC", dtDatosVenta.Tables(1).Rows(4).Item("valorCupo").ToString())
                            End If
                        End If
                    End If
                End If
            End If

            'CREDIEXPRESS FIJO
            If (dtDatosVenta.Tables(2).Rows.Count > 0) Then
                pdfFormFields.SetFieldProperty("PP CREDIEXPRESS FIJO", "flags", PdfFormField.FLAGS_PRINT, Nothing)
                pdfFormFields.SetField("PP CREDIEXPRESS FIJO", dtDatosVenta.Tables(2).Rows(0).Item("producto").ToString())
                pdfFormFields.SetFieldProperty("CUPO CREDIEXPRESS FIJO", "flags", PdfFormField.FLAGS_PRINT, Nothing)
                pdfFormFields.SetField("CUPO CREDIEXPRESS FIJO", dtDatosVenta.Tables(2).Rows(0).Item("valorCupo").ToString())
                If (dtDatosVenta.Tables(2).Rows.Count > 1) Then
                    pdfFormFields.SetFieldProperty("2DO PP CREDIEXPRESS FIJ", "flags", PdfFormField.FLAGS_PRINT, Nothing)
                    pdfFormFields.SetField("2DO PP CREDIEXPRESS FIJO", dtDatosVenta.Tables(2).Rows(1).Item("producto").ToString())
                    pdfFormFields.SetFieldProperty("2DO CUPO CREDIEXPRESS FIJO", "flags", PdfFormField.FLAGS_PRINT, Nothing)
                    pdfFormFields.SetField("2DO CUPO CREDIEXPRESS FIJO", dtDatosVenta.Tables(2).Rows(1).Item("valorCupo").ToString())
                End If
            End If

            'MessageBox.Show(sTmp, "Terminado");
            ' Cambia la propiedad para que no se pueda editar el PDF
            pdfStamper.FormFlattening = False
            ' Cierra el PDF
            ' pdfStamper.SetFullCompression()
            ' pdfStamper.Writer.SetFullCompression()
            pdfStamper.JavaScript = "this.calculateNow();"
            pdfStamper.Close()
            _rutaOrigenArchivo = newFile
        Catch ex As Exception
            Dim vg_mensaje As String
            vg_mensaje = "Error Diligenciado Fomulario, Registro No. " & 22222222222.ToString() & " - " & ex.Message.ToString()
            Return False
        End Try

        Return True
    End Function



    Private Sub NotificarNoCobertura(ByVal idDelivery As Integer, sender As Object)
        Try
            Dim resultado As New ResultadoProceso
            Dim idUsuario As Integer = CInt(Session("usxp001"))

            resultado = HerramientasDelivery.ActualizarEstadoDelivery(idDelivery, Enumerados.EstadoServicio.NoCobertura, CInt(Session("usxp001")))
            If resultado.Valor = 0 Then
                miEncabezado.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
            Else
                resultado = ConsultarServicios()
                miEncabezado.showSuccess("Actualizacion de estado correctamente.")
            End If

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de notificar no cobertura del servicio. " & ex.Message)
        End Try
    End Sub

    Private Sub ObtenerDatosTransportador(ByVal idTercero As Integer, sender As Object)
        Try
            Dim dtTransportador As New DataTable
            Dim transportadorDelivery As New TransportadorDelivery
            With transportadorDelivery
                .idTercero = idTercero
                dtTransportador = .ObtenerDatosTransportador()
            End With

            Dim rowTransportador As DataRow = dtTransportador.Rows(0)
            If Not IsDBNull(rowTransportador.Item("placa")) Then CType(sender, ASPxCallbackPanel).JSProperties("cpPlaca") = rowTransportador.Item("placa")

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de reactivar servicio. " & ex.Message)
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
        Dim empresa As String
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            idEstado = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idEstado"))
            idTipoServicio = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idTipoServicio"))
            idCiudadBodega = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idCiudad"))
            opcionesPermitidas = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "permisosOpciones")
            reagenda = CBool(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "reagenda"))

            If Not IsDBNull(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "empresa")) Then
                empresa = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "empresa")
            End If


            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{1}", idTipoServicio)

            Dim lnkNotificar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer1 As GridViewDataItemTemplateContainer = CType(lnkNotificar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkNotificar.ClientSideEvents.Click = lnkNotificar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

            If idTipoServicio = Enumerados.TipoServicio.Siembra Then
                lnkNotificar.ClientVisible = True
            Else
                lnkNotificar.ClientVisible = False
            End If

            Dim ctrlVer As ASPxHyperLink = templateContainer.FindControl("lbVer")
            ctrlVer.ClientVisible = True

            Dim controles() As String = opcionesPermitidas.ToString.Split("|")

            Dim arrControles() As String = {"lnkConfirma", "lnkDespacho", "lnkAdendoServicio", "lbCambioServicio",
                                           "lbModificarServicio", "lbAbrirServicio", "lnkAsignarZona", "lbUrgente",
                                           "lnkEditar", "ibCancelarServicio", "lbReactivar", "lbServicioTecnico", "CheReagenda",
                                             "lbDevolverVenta", "LbAsignacion", "lbConfirmaCorp", "LnkEditCorp",
                                             "LbAsignacionP", "lbConfirmaCorpP", "LnkEditCorpP", "LnkCamCorpP", "LnkCamCorp", "lnkPdfFormulario"}
            Dim existeControl As Integer

            For indice As Integer = 0 To arrControles.Length - 1
                existeControl = Array.IndexOf(controles, arrControles(indice))
                If existeControl <> -1 Then


                    If (controles(existeControl)) <> "CheReagenda" Then
                        Dim ctrl As ASPxHyperLink = templateContainer.FindControl(arrControles(indice))
                        ctrl.ClientVisible = True
                    ElseIf ((controles(existeControl) = "CheReagenda") And reagenda = True) Then
                        Dim ctrl As ASPxCheckBox = templateContainer.FindControl(arrControles(indice))
                        ctrl.ClientVisible = True
                        ctrl.Checked = reagenda
                    ElseIf ((controles(existeControl) = "CheReagenda") And reagenda = False) Then
                        Dim ctrl As ASPxCheckBox = templateContainer.FindControl(arrControles(indice))
                        ctrl.ClientVisible = False
                        ctrl.Checked = reagenda
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

    Protected Sub cmbTipoServicio_DataBinding(sender As Object, e As EventArgs) Handles cmbTipoServicio.DataBinding
        If cmbTipoServicio.DataSource Is Nothing AndAlso Session("dtTipoServidio") IsNot Nothing Then
            cmbTipoServicio.DataSource = CType(Session("dtTipoServidio"), DataTable)

        End If
    End Sub
    Protected Sub cmbEstado_DataBinding(sender As Object, e As EventArgs) Handles cmbEstado.DataBinding
        If cmbEstado.DataSource Is Nothing AndAlso Session("dtEstado") IsNot Nothing Then
            cmbEstado.DataSource = CType(Session("dtEstado"), DataTable)

        End If
    End Sub
    Protected Sub cmbCiudad_DataBinding(sender As Object, e As EventArgs) Handles cmbCiudad.DataBinding
        If cmbCiudad.DataSource Is Nothing AndAlso Session("dtCiudad") IsNot Nothing Then
            cmbCiudad.DataSource = CType(Session("dtCiudad"), DataTable)

        End If
    End Sub
    Protected Sub cmbBodega_DataBinding(sender As Object, e As EventArgs) Handles cmbBodega.DataBinding
        If cmbBodega.DataSource Is Nothing AndAlso Session("dtBodega") IsNot Nothing Then
            cmbBodega.DataSource = CType(Session("dtBodega"), DataTable)

        End If
    End Sub
    Protected Sub cmbTransportadora_DataBinding(sender As Object, e As EventArgs) Handles cmbTransportadora.DataBinding
        If cmbTransportadora.DataSource Is Nothing AndAlso Session("dtTransportadora") IsNot Nothing Then
            cmbTransportadora.DataSource = CType(Session("dtTransportadora"), DataTable)

        End If
    End Sub
#End Region
#Region "MetodosPrivados"
    Private Sub CargaInicial()
        '*** Cargar Estados ***
        Dim dtEstado As New DataTable
        Dim dtBodega As New DataTable
        Dim dtCiudad As New DataTable
        Dim dtTransportadora As New DataTable
        Dim dtTipoServidio As New DataTable

        If Session("dtEstado") Is Nothing Then
            dtEstado = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional("cmbEstado")
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstado
            Session("dtEstado") = dtEstado
            MetodosComunes.CargarComboDX(cmbEstado, CType(Session("dtEstado"), DataTable), "idEstado", "nombre")
        Else
            cmbEstado.DataBind()
        End If


        '*** Cargar la bodega ***
        If Session("dtBodega") Is Nothing Then
            dtBodega = HerramientasMensajeria.ConsultarBodega(idUsuarioConsulta:=CInt(Session("usxp001")))
            Session("dtBodega") = dtBodega
            MetodosComunes.CargarComboDX(cmbBodega, CType(Session("dtBodega"), DataTable), "idbodega", "bodega")
        Else
            cmbBodega.DataBind()
        End If


        '*** Cargar Ciudades ***
        If Session("dtCiudad") Is Nothing Then
            dtCiudad = Ciudad.ObtenerCiudadesPorPais
            Session("dtCiudad") = dtCiudad
            MetodosComunes.CargarComboDX(cmbCiudad, CType(Session("dtCiudad"), DataTable), "idCiudad", "nombre")
        Else
            cmbCiudad.DataBind()
        End If


        '*** Cargar transportadoras ***
        If Session("dtTransportadora") Is Nothing Then
            Dim transportadorDelivery As New TransportadorDelivery
            dtTransportadora = transportadorDelivery.ObtenerInformacionTransportadoras
            Session("dtTransportadora") = dtTransportadora
            MetodosComunes.CargarComboDX(cmbTransportadora, CType(Session("dtTransportadora"), DataTable), "idtercero", "nombre")

        End If


        '*** Cargar tipo servicio ***
        If Session("dtTipoServidio") Is Nothing Then
            dtTipoServidio = HerramientasMensajeria.ConsultaTipoServicio(idUsuarioConsulta:=CInt(Session("usxp001")))
            Session("dtTipoServidio") = dtTipoServidio
            MetodosComunes.CargarComboDX(cmbTipoServicio, CType(Session("dtTipoServidio"), DataTable), "idTipoServicio", "nombre")
        Else
            cmbTipoServicio.DataBind()
        End If

        '*** Cargar tipo servicio ***
        If Session("dtNovedad") Is Nothing Then
            Dim dtNovedades As DataTable = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Reagenda)
            Session("dtNovedad") = dtNovedades
            MetodosComunes.CargarDropDown(CType(Session("dtNovedad"), DataTable), ddlNovedadReagenda, "Seleccione...", True)
        End If


    End Sub
    Private Function ConsultarServicios(Optional ByVal idServicio As Integer = 0) As ResultadoProceso

        Dim resultado As New ResultadoProceso
        Dim perfilesDigitacionCme As String
        Try
            perfilesDigitacionCme = MetodosComunes.seleccionarConfigValue("PERFILES_DIGITACION_CME")
            Dim arrPerfilDigitacionCme As New ArrayList(perfilesDigitacionCme.Split(","))
            Dim idPerfil As Integer
            If Session("usxp009") IsNot Nothing Then Integer.TryParse(Session("usxp009"), idPerfil)
            Dim idUsuario As Integer = CInt(Session("usxp001"))

            Dim objServicio As New GenerarPoolServicioMensajeria
            With objServicio
                If idServicio = 0 Then


                    If mePedidos.Text.Trim().Length = 0 And TextBMin.Text = "" And TextBIdentificaion.Text.Trim = "" Then
                        If (dateFechaInicio.Date = Date.MinValue Or dateFechaFin.Date = Date.MinValue) And (dateFechaRegistroInicio.Date = Date.MinValue Or dateFechaRegistroFin.Date = Date.MinValue) Then
                            resultado.Valor = 1
                            resultado.Mensaje = "Seleccione por lo menos filtro de fecha."
                            Return resultado
                        End If
                    End If


                    If mePedidos.Text.Trim().Length > 0 Then
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
                    If cmbCiudad.Value > 0 Then .IdCiudad = cmbCiudad.Value
                    If cmbEstado.Value > 0 Then .IdEstado = cmbEstado.Value
                    If cmbBodega.Value > 0 Then .IdBodega = cmbBodega.Value
                    If cmbTipoServicio.Value > 0 Then .IdTipoServicio = cmbTipoServicio.Value
                    If cmbVIP.Value <> "2" And cmbVIP.Value IsNot Nothing Then .ClienteVIP = IIf(cmbVIP.Value = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                    If cmbTieneNovedad.Value <> "0" And cmbTieneNovedad.Value IsNot Nothing Then .TieneNovedad = IIf(cmbTieneNovedad.Value = "1", Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                    If dateFechaInicio.Date > Date.MinValue Then .FechaInicial = dateFechaInicio.Date
                    If dateFechaFin.Date > Date.MinValue Then .FechaFinal = dateFechaFin.Date
                    If dateFechaRegistroInicio.Date > Date.MinValue Then .FechaCreacionInicial = dateFechaRegistroInicio.Date
                    If dateFechaRegistroFin.Date > Date.MinValue Then .FechaCreacionFinal = dateFechaRegistroFin.Date

                    If TextBMin.Text <> "" And TextBMin.Text IsNot Nothing Then .Msisdn = TextBMin.Text
                    If TextBIdentificaion.Text <> "" And TextBIdentificaion.Text IsNot Nothing Then .Identificaion = TextBIdentificaion.Text
                    If txtSeudocodigo.Text <> "" And txtSeudocodigo.Text IsNot Nothing Then .SeudoCodigo = txtSeudocodigo.Text

                Else
                    .ListaIdServicio.Add(CStr(idServicio))
                End If
                .IdUsuarioGenerador = CInt(Session("usxp001"))
                Session("dtServicios") = .GenerarPoolnew()
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
        lbAbrirServicio.ClientVisible = IIf(opcion = "AbrirServicio", True, False)
        pnlEstadoReapertura.Visible = IIf(opcion = "AbrirServicio", True, False)
        ddlEstadoReapertura.Visible = IIf(opcion = "AbrirServicio", True, False)
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
                .IdServicioMensajeria = idServicio
                resultado = .Reabrir(idUsuario, txtObservacionModificacion.Text, CInt(ddlEstadoReapertura.Value))
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

    Private Sub NotificarVencimientoServicios(idServicio As Integer, sender As Object)
        Try
            Dim objNotificacion As New NotificacionAlertasSiembra()
            Dim resultado As ResultadoProceso = objNotificacion.EnviarNotificaciones(idServicio)
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de Notificar el vencimiento del servicio. " & ex.Message)
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
                .IdServicioMensajeria = idServicio
                resultado = .Cancelar(idUsuario, txtObservacionModificacion.Text)
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                resul = ConsultarServicios()
                txtObservacionModificacion.Text = ""
                'Envio de Gestion a NotusExpressBancolombia
                miServicio = New ServicioMensajeria(CInt(idServicio))
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

            MetodosComunes.CargarComboDX(ddlEstadoReapertura, dtEstado, "idEstadoReapertura", "nombre")

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
                Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "empresa", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaAsignacion", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "responsableEntrega", "tieneNovedad", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "barrio", "direccion", "telefonoContacto", "reagenda", "observacion")
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, "Inventario.xls", Server.MapPath("../archivos_planos/Inventario.xls"), )
            Else
                miEncabezado.showWarning("No se encontraron datos para exportar, por favor intente nuevamente.")
            End If

        Catch ex As Exception
            miEncabezado.showError("Error inesperado al intenetar Exportar el Pool: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
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
                Dim dtDatos As DataTable = dvDatos.ToTable(False, "idServicioMensajeria", "numeroRadicado", "empresa", "idTipoServicio", "tipoServicio", "fechaRegistro", "fechaAgenda", "fechaRegistroAgenda", "fechaAsignacion", "usuarioEjecutor", "nombreConsultor", "idJornada", "jornada", "idEstado", "estado", "fechaConfirmacion", "idResponsableEntrega", "responsableEntrega", "tieneNovedad", "nombreCliente", "personaContacto", "idCiudad", "ciudadCliente", "idBodega", "bodega", "barrio", "direccion", "telefonoContacto", "reagenda", "observacion")
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

    Private Sub AsignarTransportadorDelivery(ByVal idDelivery As Integer, sender As Object)

        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Dim idRuta As Integer = 0
        Dim resultado As New ResultadoProceso
        Try
            Dim transportadorDelivery As New TransportadorDelivery()
            With transportadorDelivery
                If cmbTipoTransporte.Value = "trMotorizado" Then
                    .idTercero = cmbMotorizado.Value
                    .placaTransportador = txtPlacaMotorizado.Text
                ElseIf cmbTipoTransporte.Value = "trTransportadora" Then
                    .idTercero = cmbTransportadora.Value
                    .cedulaTransportador = txtCedulaTransportadora.Text
                    .nombreTransportador = txtNombreTransportadora.Text
                    .placaTransportador = txtPlacaTransportadora.Text
                    .numeroGuia = txtNumeroGuia.Text
                End If
                .idDelivery = idDelivery
                .idUsuario = idUsuario

                If .idTercero IsNot Nothing Then
                    resultado = .AsignarTransportadorDelivery()
                    idRuta = resultado.Valor

                    If resultado.Valor > 0 Then
                        resultado = HerramientasDelivery.ActualizarEstadoDelivery(idDelivery, Enumerados.EstadoServicio.AsignadoRuta, CInt(Session("usxp001")))
                        If resultado.Valor = 0 Then
                            miEncabezado.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
                        Else
                            Dim UrlReporte As String = "Reportes/VisorHojaRuta.aspx?id=" & idRuta

                            If TypeOf sender Is ASPxCallbackPanel Then
                                CType(sender, ASPxCallbackPanel).JSProperties("cpUrlReporte") = UrlReporte
                            ElseIf TypeOf sender Is ASPxGridView Then
                                CType(sender, ASPxGridView).JSProperties("cpUrlReporte") = UrlReporte
                            End If

                            resultado = ConsultarServicios()
                            miEncabezado.showSuccess("Actualizacion de estado correctamente.")
                        End If
                    Else
                        miEncabezado.showWarning("Se generó un inconveniente: " & resultado.Mensaje)
                    End If
                Else
                    miEncabezado.showWarning("Se generó un inconveniente: Por favor seleccione el transportador para asignar transporte")
                End If
            End With

        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar asignar transportador: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub cmbMotorizado_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbMotorizado.Callback
        CargarTransportador(String.Empty)
    End Sub

    Private Sub cpFiltroMotorizado_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltroMotorizado.Callback
        CargarTransportador(e.Parameter)
    End Sub

    Private Sub CargarTransportador(ptransportador As String)
        Try
            Dim arrParametro As String()
            arrParametro = ptransportador.Split(":")

            Dim dtTransportador As New DataTable
            dtTransportador = HerramientasDelivery.ObtenerListadoComboTransportador(arrParametro(0), arrParametro(1))
            With cmbMotorizado
                .DataSource = dtTransportador
                .DataBind()
                If .Items.Count <> 1 Then
                    .Items.Insert(0, New ListEditItem("Seleccione un Transportador...", "0"))
                End If

            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener los transportador " & ex.Message)
        End Try
    End Sub
    Private Function ConsultaAutocomplete(ByVal operacion As Integer) As String
        Dim objVenta As New GenerarPoolServicioMensajeria
        Dim dtDataVenta As New DataTable
        Dim filtroBusqueda As String

        If (operacion = 1) Then
            filtroBusqueda = txtCedulaRadiacado.Value
        ElseIf (operacion = 2) Then
            filtroBusqueda = txtCampaniaEstrategia.Value
        End If

        Try
            dtDataVenta = objVenta.ConsultaAutocomplete(operacion, filtroBusqueda)

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()
            Dim row As Dictionary(Of String, Object)
            For Each dr As DataRow In dtDataVenta.Rows
                row = New Dictionary(Of String, Object)()
                For Each col As DataColumn In dtDataVenta.Columns
                    row.Add(col.ColumnName, dr(col))
                Next
                rows.Add(row)
            Next
            Return operacion & "|" & serializer.Serialize(rows)
        Catch ex As Exception
            Return ex.ToString()
        End Try
    End Function

    Private Function VerDocumentosMesaC(ByVal idRadicado As Integer) As String
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim dtMC As New DataTable
        Dim filtroBusqueda As String
        Dim tmpB64Imagenes As String = String.Empty

        Try
            With objDocumentos
                .IdRadicado = idRadicado
                dtMC = objDocumentos.ConsultaDocumentosMC()
            End With

            Dim posicion = 0
            For Each dr As DataRow In dtMC.Rows
                tmpB64Imagenes += dtMC.Rows(posicion)(3).ToString() & "|"
                posicion += +1
            Next

            'For Each dr As DataRow In dtMC.Rows
            '    row = New Dictionary(Of String, Object)()
            '    For Each col As DataColumn In dtMC.Columns
            '        row.Add(col.ColumnName, dr(col))
            '    Next
            '    rows.Add(row)
            'Next
            'Return serializer.Serialize(rows) & "|-1"
            Return "-1|" & tmpB64Imagenes
        Catch ex As Exception
            Return ex.ToString()
        End Try
    End Function

    Private Sub ProcesarArchivo()
        Try
            'Session("idCampania") = cmbCampania.Value
            Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim ruta As String
            Dim resultado As New ResultadoProceso
            'Dim idCampania As Integer = CInt(Session("idCampania"))
            Session("dtErrores") = Nothing
            Dim numeroColumnasErrores As Integer

            Dim nombreArchivo As String = "CargueMaestroCliente_" & fec & "-" & Path.GetExtension(fuArchivo.PostedFile.FileName)
            If Not (fuArchivo.PostedFile.FileName Is Nothing) Then
                Dim fileExtension As String = Path.GetExtension(fuArchivo.PostedFile.FileName)
                ruta = Server.MapPath("~/MensajeriaEspecializada/Archivos/" & nombreArchivo)
                Try
                    fuArchivo.SaveAs(ruta)
                Catch ex As Exception
                    miEncabezado.showError("Se genero un error al guardar el archivo: " & ex.Message)
                    Exit Sub
                End Try
                oExcel = New ExcelFile
                If fileExtension.ToUpper = ".XLS" Then
                    oExcel.LoadXls(ruta)
                ElseIf fileExtension.ToUpper = ".XLSX" Then
                    oExcel.LoadXlsx(ruta, XlsxOptions.None)
                End If

                Try
                    'objCliente = New CargueClientes(oExcel)
                    '  If objCliente.ValidarEstructura() Then
                    'If objCliente.ValidarInformacion(idCampania) Then
                    Dim identificador As Guid = Guid.NewGuid()
                    'Dim uploader As UploadedFile = fuArchivo.
                    Dim rutaAlmacenamiento As String = "\GestionComercial\ClientesCargados\"
                    ' resultado = objCliente.CrearClientes(CInt(idCampania), fuArchivo.FileName, fuArchivo.FileBytes.Length, rutaAlmacenamiento)
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        fuArchivo.SaveAs(Server.MapPath("~") & rutaAlmacenamiento & identificador.ToString())
                    End If
                    'Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                    'MostrarErrores(objCliente.EstructuraTablaErrores)
                    '  End If
                    ' Else
                    'MostrarErrores(objCliente.EstructuraTablaErrores)
                    'numeroColumnasErrores = objCliente.EstructuraTablaErrores.Rows.Count
                    If (numeroColumnasErrores > 0) Then
                        ' resultado.EstablecerMensajeYValor(10, "Se encontraron errores en la validación. " & objCliente.EstructuraTablaErrores.Rows(numeroColumnasErrores - 1)(2).ToString())
                    Else
                        resultado.EstablecerMensajeYValor(10, "Se encontraron errores en la validación.")
                    End If

                    'End If
                    'Session("objCliente") = objCliente
                Catch ex As Exception
                    Throw ex
                End Try
                'miEncabezado.clear()
                With miEncabezado
                    .setTitle("Administración Clientes")
                End With
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess("Se realizó la carga de clientes, satisfactoriamente.")
                ElseIf resultado.Valor = 10 Or resultado.Valor = 20 Or resultado.Valor = 30 Then
                    miEncabezado.showError(resultado.Mensaje)
                    'Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('dialogoErrores.ShowWindow();', 100);", True)
                ElseIf resultado.Valor = 40 Then
                    miEncabezado.showError(resultado.Mensaje)
                Else
                    miEncabezado.showError("Se presentaron errores en la carga del archivo, verifique el log de errores.")
                End If
                'callback.JSProperties("cpResultadoProceso") = resultado.Valor
            Else
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('LoadingPanel.Hide();', 100);", True)
                miEncabezado.showError("Seleccione los valores requeridos")
            End If

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "MyScript", "setTimeout ('LoadingPanel.Hide();', 100);", True)
            ' miEncabezado.showError(_mensajeGenerico)

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
        'callback.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub


    Private Sub AdicionarSoporte()
        Try
            If fuArchivo.HasFile Then
                Dim _ruta As String
                Dim Variable As String = "RUTA_DOCUMENTOS_MESA_CONTROL"
                Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Archivos")
                Try
                    Dim obj As Comunes.ConfigValues = New Comunes.ConfigValues(Variable)
                    _ruta = obj.ConfigKeyValue + "\" + Guid.NewGuid().ToString() + Path.GetExtension(fuArchivo.FileName)
                Catch ex As Exception
                    'epPrincipal.showError("Se generó un error al tratar cargar la ruta: " & "<br><br>" & ex.Message)
                    'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
                End Try
                If Not String.IsNullOrEmpty(_ruta) Then
                    fuArchivo.SaveAs(_ruta)
                    RegistrarSoporte(_ruta, fuArchivo.PostedFile.ContentType, Guid.NewGuid().ToString() + Path.GetExtension(fuArchivo.FileName))
                End If
            Else
                'epPrincipal.showWarning("Ya se ingreso el numero maximo de imagenes.")
                'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
            End If
            'If CType(Session("dtSoportes"), DataTable).Rows.Count <= 4 Then
            '    fuArchivo.Enabled = True
            '    btnAgregarSoportes.Enabled = True
            'Else
            '    fuArchivo.Enabled = False
            '    btnAgregarSoportes.Enabled = False
            'End If
        Catch ex As Exception
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('" & ex.Message & "', 'rojo')", True)
            'epPrincipal.showError("Se generó un error al tratar adicionar el archivos: " & "<br><br>" & ex.Message)
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
    End Sub

    Private Sub RegistrarSoporte(ByVal ruta As String, ByVal tipoImagen As String, ByVal nombre As String)
        '_contenidoTablaCliente = hdfContenidoTablaResultado.Value

        Try
            Dim img As System.Web.UI.WebControls.Image
            Dim fs As System.IO.Stream = fuArchivo.PostedFile.InputStream
            Dim br As New System.IO.BinaryReader(fs)
            Dim bytes As Byte() = br.ReadBytes(CType(fs.Length, Integer))
            Dim base64String As String = Convert.ToBase64String(bytes, 0, bytes.Length)
            Dim resultado As ResultadoProceso
            Dim objDocumentos As New GenerarPoolServicioMensajeria
            Dim dtDocum As DataTable

            With objDocumentos
                .IdRadicado = hdfIdRadicado.Value
                .NombreDocumento = nombre
                .ByteDocumento = "data:" & tipoImagen & ";base64," & base64String
                .RutaDocumento = ruta
                resultado = objDocumentos.GuardarDocumentoMC()
            End With

            Dim dtSoportes As New DataTable

            If Session("dtSoportes") IsNot Nothing Then
                If (Session("dtSoportes").Rows(0)(0).split("_")(0) <> hdfIdRadicado.Value) Then
                    Session("dtSoportes") = Nothing
                End If
            End If


            If Session("dtSoportes") Is Nothing Then
                dtSoportes.Columns.Add(New DataColumn("nombre", System.Type.GetType("System.String")))
                dtSoportes.Columns.Add(New DataColumn("ruta"))
                dtSoportes.Columns.Add(New DataColumn("tipoDocumento"))

                Dim pkColumn(0) As DataColumn
                With dtSoportes.Columns
                    pkColumn(0) = .Item("ruta")
                End With
                dtSoportes.PrimaryKey = pkColumn
                Dim dr As DataRow = dtSoportes.NewRow()
                dr("ruta") = ruta
                dr("nombre") = hdfIdRadicado.Value & "_" & nombre
                dr("tipoDocumento") = tipoImagen
                dtSoportes.Rows.Add(dr)
                Session("dtSoportes") = dtSoportes
                gvSoporte.DataSource = dtSoportes
                gvSoporte.DataBind()
                img = gvSoporte.Rows(0).FindControl("imgImagenSubida")
                img.ImageUrl = "data:image/png;base64," & base64String
            Else
                Dim drAux As DataRow
                dtSoportes = Session("dtSoportes")
                drAux = dtSoportes.Rows.Find(ruta)
                If drAux IsNot Nothing Then
                    'epPrincipal.showError(" Ya existe un soporte con el mismo nombre")
                Else



                    Dim dr As DataRow = dtSoportes.NewRow()
                    dr("ruta") = ruta
                    dr("nombre") = hdfIdRadicado.Value & "_" & nombre
                    dr("tipoDocumento") = tipoImagen
                    dtSoportes.Rows.Add(dr)
                    Session("dtSoportes") = dtSoportes
                    gvSoporte.DataSource = dtSoportes
                    gvSoporte.DataBind()

                    Dim tmp As Integer = 0
                    For Each dr1 As DataRow In dtSoportes.Rows
                        img = gvSoporte.Rows(tmp).FindControl("imgImagenSubida")
                        With objDocumentos
                            .NombreDocumento = dtSoportes.Rows(tmp)(0).ToString().Split("_")(1)
                            dtDocum = objDocumentos.ConsultaDocumentosMC()
                            img.ImageUrl = dtDocum.Rows(0)(3).ToString()
                            tmp += +1
                        End With
                    Next
                End If

            End If
            gvSoporte.Visible = True
            miEncabezado.showSuccess("El soporte se adiciono de forma correcta: " & "<br><br>")
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        Catch ex As Exception
            'epPrincipal.showError("Error al adicionar el soporte. " & ex.Message & "<br><br>")
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml

        End Try

        Session("TablaResultadoAutocomplete") = hdfContenidoTablaResultado

    End Sub



    Private Function GuardarRechazoDocMC(ByVal IdCausal As Integer, ByVal ServicioObs As String) As String

        Dim objRechazo As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objRechazo
            .IdRadicado = Integer.Parse(ServicioObs.Split("|")(0))
            .IdCausalDevolucion = IdCausal
            .ObservacionesDevolucionDocs = ServicioObs.Split("|")(1)
            .IdUsuarioGenerador = 1
            resultado = .GuardarRechazoMC()
        End With
        Return "-3|" & resultado.Mensaje & "_" & resultado.Valor
    End Function

    Private Function AprobarDocumentosMC(ByVal idServicio As Integer) As String
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objDocumentos
            .DocRecuperacion = 1
            .IdRadicado = idServicio
            resultado = .GuardarRechazoMC()
        End With

        Return "-4|" & resultado.Mensaje
    End Function

    Protected Sub btnAgregarSoportes_Click(sender As Object, e As EventArgs)
        AdicionarSoporte()
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "prueba", "LlenarTabla();", True)
    End Sub
End Class