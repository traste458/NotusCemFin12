Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Text
Imports System.IO
Imports GemBox
Imports GemBox.Spreadsheet
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes

Partial Public Class RegistrarCambioServicio
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private idServicio As Integer
    Private altoVentana As Integer
    Private anchoVentana As Integer
    Private dtError As DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        ObtenerTamanoVentana()
        txtIccid.Enabled = False
        txtImei.Enabled = False

        For index As Integer = 0 To rblTipoLectura.Items.Count - 1
            rblTipoLectura.Items(index).Attributes.Add("onclick", "javascript: ValidarTipoLectura(this.value);")
        Next

        If Not Me.IsPostBack Then
            With epNotificador
                .setTitle("Despachar Seriales - Servicio de Mensajer&iacute;a")
                .showReturnLink("PoolServiciosNew.aspx")
            End With

            With Request
                If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
            End With
            If idServicio > 0 Then
                Session("idServicio") = idServicio
                Dim infoServicio As New ServicioMensajeria(idServicio:=idServicio)
                If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
                    Dim respuesta As New ResultadoProceso

                    If infoServicio.IdTipoServicio = Enumerados.TipoServicio.Venta Then
                        Dim objEncabezado As EncabezadoServicioTipoVenta = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx")
                        infoServicio = New ServicioMensajeriaVenta(idServicio:=idServicio)
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()

                        'Se habilita el ingreso del número de contrato
                        txtNumeroContrato.Enabled = True
                        rfvtxtNumeroContrato.Enabled = True

                        'Se deshabilita la solicitud de tipo de sim
                        rblTipoSim.Visible = False
                        cuTipoSim.Enabled = False

                        Session("infoServicioMensajeria") = infoServicio
                    Else
                        Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()
                        Session("infoServicioMensajeria") = infoServicio
                    End If

                    If respuesta.Valor = 0 Then
                        CargarDetalleDeReferencias(idServicio)
                        CargarDetalleDeMsisdn(idServicio)
                        CargarTiposDeNovedad()
                        CargarNovedades(idServicio)
                        Session("infoServicioMensajeria") = infoServicio
                    Else
                        pnlGeneral.Enabled = False
                        epNotificador.showWarning(respuesta.Mensaje)
                    End If
                Else
                    epNotificador.showWarning("No fué posible encontrar los datos del servicio.")
                End If
            Else
                pnlGeneral.Enabled = False
                epNotificador.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Page.Request.Params("__EVENTTARGET") = "miPostBack" Then
                Dim dat As String = Page.Request.Params("__EVENTARGUMENT").ToString()
                Me.ValidarSiExisteMsisdn(dat)

            End If

            If Session("idServicio") IsNot Nothing Then idServicio = Session("idServicio")
            If Session("infoServicioMensajeria") IsNot Nothing Then CargarEncabezado(CType(Session("infoServicioMensajeria"), IServicioMensajeria))
        End If
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        If Me.IsValid Then
            Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
            Dim idUsuario As Integer
            Dim resultado As ResultadoProceso

            Try
                If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
                Dim infoServicio As New CambioServicio
                With infoServicio
                    .IdServicioMensajeria = idServicio
                    .Imei = txtImei.Text.Trim
                    .Iccid = txtIccid.Text.Trim
                    .Msisdn = txtMsisdn.Text.Trim
                    .Factura = txtFacturaLectura.Text.Trim
                    .Remision = txtRemsioLectura.Text.Trim
                    .HayNovedad = rblNovedadLectura.SelectedValue
                    Integer.TryParse(rblTipoSim.SelectedValue, .IdTipoSIM)
                    .NumeroCambioServicio = txtNumCambio.Text.Trim
                End With

                epNotificador.showWarning("Ya se leyó la totalidad de seriales requeridos. Por favor proceda Finalizar el proceso de Cambio de servicio.")
                pnlLectura.Enabled = False
                lbCerrar.Enabled = True
                resultado = infoServicio.RegistrarCambioDeServicio
                If resultado.Valor = 0 Then
                    CargarDetalleDeReferencias(idServicio)
                    epNotificador.showSuccess(resultado.Mensaje)
                    txtImei.Text = ""
                    txtIccid.Text = ""
                    txtMsisdn.Text = ""
                    txtRemsioLectura.Text = ""
                    txtFacturaLectura.Text = ""
                    rblTipoLectura.ClearSelection()
                    lbCargueArchivo.Enabled = False
                    txtNumCambio.Text = ""
                Else
                    epNotificador.showError(resultado.Mensaje)
                    lbCargueArchivo.Enabled = True
                End If
            Catch ex As Exception
                epNotificador.showError("Imposible finalizar proceso de cambios de servicio. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub lbCerrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCerrar.Click
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Dim idUsuario As Integer
        Dim resultado As ResultadoProceso
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)
            With infoServicio
                resultado = .FinalizarCambioServicio(txtObservacion.Text.Trim, idUsuario)
                If resultado.Valor = 0 Then
                    Response.Redirect("PoolServiciosNew.aspx?resOk=true&codRes=3", False)

                    epNotificador.showSuccess(resultado.Mensaje)
                    pnlGeneral.Enabled = False
                Else
                    epNotificador.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Imposible finalizar proceso de cambios de servicio. " & ex.Message)
        End Try

    End Sub

    Protected Sub lbVerSeriales_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbVerSeriales.Click
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Try
            Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalle.GenerarDataTable()
            With gvSeriales
                .DataSource = dtDatos
                If dtDatos IsNot Nothing Then .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Serial(es)"
                .DataBind()
            End With
            MetodosComunes.mergeGridViewFooter(gvSeriales)
            With dlgSerial
                .Width = Unit.Pixel(Me.anchoVentana * 0.69999999999999996)
                .Height = Unit.Pixel(Me.altoVentana * 0.69999999999999996)
                .Show()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de mostrar seriales. " & ex.Message)
        End Try
    End Sub

    Private Sub lbAdicionarMin_Click(sender As Object, e As System.EventArgs) Handles lbAdicionarMin.Click
        Try
            With dlgAdicionarMIN
                .Width = Unit.Pixel(Me.anchoVentana * 0.5)
                .Height = Unit.Pixel(Me.anchoVentana * 0.5)
                .Show()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de mostrar Adición de MINs. " & ex.Message)
        End Try
    End Sub

    Private Sub dlgSerial_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles dlgSerial.Unload
        Dim a = rblTipoLectura.Items.Count
    End Sub

    Protected Sub lbMostrarFormNovedad_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbMostrarFormNovedad.Click
        ddlTipoNovedad.ClearSelection()
        txtObservacionNovedad.Text = ""
        With dlgNovedad
            .Width = Unit.Pixel(Me.anchoVentana * 0.5)
            .Height = Unit.Pixel(Me.altoVentana * 0.29999999999999999)
            .Show()
        End With
    End Sub

    Private Sub lbRegistrarNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRegistrarNovedad.Click
        Dim resultado As ResultadoProceso
        Dim idUsuario As Integer = 1

        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim novedad As New NovedadServicioMensajeria
            With novedad
                .IdServicioMensajeria = infoServicio.IdServicioMensajeria
                .Observacion = txtObservacionNovedad.Text.Trim
                .IdTipoNovedad = CInt(ddlTipoNovedad.SelectedValue)
                resultado = .Registrar(idUsuario)

                If resultado.Valor = 0 Then
                    epNotificador.showSuccess(resultado.Mensaje)
                    txtObservacionNovedad.Text = String.Empty
                    CargarNovedades(infoServicio.IdServicioMensajeria)
                Else
                    epNotificador.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar la novedad. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvListaMsisdn_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListaMsisdn.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imagen As System.Web.UI.WebControls.Image = CType(e.Row.FindControl("imgBloquear"), System.Web.UI.WebControls.Image)
            Dim bloquear = CBool(CType(e.Row.DataItem, DataRowView).Item("bloquear"))
            If Not bloquear Then
                imagen.ImageUrl = "~/images/BallGreen.gif"
            Else
                imagen.ImageUrl = "~/images/BallRed.gif"
            End If
        End If
    End Sub

    Private Sub lbVerNovedad_Click(sender As Object, e As System.EventArgs) Handles lbVerNovedad.Click
        CargarNovedades(Session("idServicio"))
        With dlgNovedades
            .Width = Unit.Pixel(Me.anchoVentana * 0.29999999999999999)
            .Height = Unit.Pixel(Me.altoVentana * 0.25)
            .Show()
        End With
    End Sub

    Private Sub lbAgregarMIN_Click(sender As Object, e As System.EventArgs) Handles lbAgregarMIN.Click
        AgregarMINs()
        txtMsisdn.Text = ""
        'TODO: Jonnathan Niño: Mejoras CEM: Validar si aplica solo para Ventas WEB, de lo contrario se debe habilitar y controlar el tipo de servicio
        'chbActivaEquipoAnterior.Checked = False
        'chbComSeguro.Checked = False
        'txtPrecioSinIVA.Text = ""
        'txtPrecioConIVA.Text = ""
        'txtNumeroReserva.Text = ""
        'ddlClausula.SelectedIndex = -1
        'rblLista28.ClearSelection()
    End Sub

    Protected Sub CustomValidatorMsisdn_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidatorMsisdn.ServerValidate
        Dim valor As String = args.Value

        If Session("dtListaMsisdn") IsNot Nothing Then
            Dim dtListaMsisdn As DataTable = Session("dtListaMsisdn")
            Dim fila() As DataRow

            fila = dtListaMsisdn.Select("MSISDN = '" & valor & "'")
            If fila.Length = 0 Then
                txtMsisdn.Focus()
                args.IsValid = False
            Else
                args.IsValid = True
            End If
        End If

    End Sub

#End Region

#Region "Métodos Privados"

    Private Function CargarEncabezado(infoServicio As ServicioMensajeria) As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        If infoServicio.IdTipoServicio = Enumerados.TipoServicio.Venta Then
            Dim objEncabezado As EncabezadoServicioTipoVenta = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx")
            infoServicio = New ServicioMensajeriaVenta(idServicio:=idServicio)
            respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
            phEncabezado.Controls.Add(objEncabezado)
            phEncabezado.DataBind()

            'Se habilita el ingreso del número de contrato
            txtNumeroContrato.Enabled = True
            rfvtxtNumeroContrato.Enabled = True

            'Se deshabilita la solicitud de tipo de sim
            rblTipoSim.Style.Add("display", "none")
            cuTipoSim.Enabled = False

            Session("infoServicioMensajeria") = infoServicio
        Else
            Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
            respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
            phEncabezado.Controls.Add(objEncabezado)
            phEncabezado.DataBind()

            If infoServicio.IdTipoServicio = Enumerados.TipoServicio.VentaWeb Then
                'Se deshabilita la solicitud de tipo de sim
                rblTipoSim.Style.Add("display", "none")
                cuTipoSim.Enabled = False

                'Se habilita el ingreso del número cambio de servicio
                txtNumCambio.Enabled = False
                rfvNumCambio.Enabled = False
            End If

            Session("infoServicioMensajeria") = infoServicio
        End If
        Return respuesta
    End Function

    Private Sub CargarDetalleDeReferencias(ByVal idServicio As Integer)
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            With gvListaReferencias
                .DataSource = dtAux
                .DataBind()
            End With

            'Configurar validador de Serial
            ConfigurarValidacionSerial(detalleReferencia)

            Dim cantPedida As Integer
            Dim cantCambio As Integer
            Integer.TryParse(dtAux.Compute("SUM(cantidad)", "").ToString, cantPedida)
            Integer.TryParse(dtAux.Compute("SUM(cantidadCambio)", "").ToString, cantCambio)
            Session("cantidadPedida") = cantPedida
            If cantCambio >= cantPedida Then
                epNotificador.showWarning("Ya se leyó la totalidad de seriales requeridos. Por favor proceda Finalizar el proceso de Cambio de servicio.")
                pnlLectura.Enabled = False
                lbCerrar.Enabled = True
                lbCargueArchivo.Enabled = False
                CargarDatosArchivo(idServicio)
            Else
                lbCerrar.Enabled = False
                pnlLectura.Enabled = True
                lbCargueArchivo.Enabled = True
                lbCargueArchivo.Enabled = True
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarDetalleDeMsisdn(ByVal idServicio As Integer)
        Try
            Session.Remove("dtListaMsisdn")
            Dim detalleMsisdn As New DetalleMsisdnEnServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalleMsisdn.GenerarDataTable()
            Session("dtListaMsisdn") = dtDatos
            With gvListaMsisdn
                .DataSource = dtDatos
                .DataBind()
            End With
            Dim drAux() As DataRow = dtDatos.Select("bloquear=1")
            If drAux.Length > 0 Then
                lbCerrar.Enabled = False
                btnRegistrar.Enabled = False
                epNotificador.showWarning("<i>Uno o mas mines ya fueron adicionados a un radicado activo.</i>")
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de MSISDNs asignados al servicio. " & ex.Message)
        End Try

    End Sub

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me.altoVentana = CInt(arrAux(0))
                Me.anchoVentana = CInt(arrAux(1))
            End If
        End If
    End Sub

    Private Sub CargarTiposDeNovedad()
        Dim dtEstado As New DataTable
        Try
            dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=4)
            With ddlTipoNovedad
                .DataSource = dtEstado
                .DataTextField = "descripcion"
                .DataValueField = "idTipoNovedad"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatosArchivo(ByVal idServicio As Integer)
        Try
            Dim datos As New DetalleSerialServicioMensajeria()
            Dim dtDatosArchivo As DataTable = datos.CargarDatosArchivo(idServicio)
            With gvDatosCargados
                .DataSource = dtDatosArchivo
                .DataBind()
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de registros cargados. " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarMINs()
        Try
            'TODO: Jonnathan Niño: Mejoras CEM: Validar si se aceptan mins repetidos
            'If Not RegistroMinExiste(_minsDataTable.Select("msisdn=" & txtMsisdn.Text.Trim)) Then
            Dim referenciaDetalle As New DetalleMsisdnEnServicioMensajeria()
            With referenciaDetalle
                .IdTipoServicio = ServicioMensajeria.ObtieneIdServicioTipo(idServicio)
                .MSISDN = CLng(txtMsisdnNuevo.Text)


                'TODO: Jonnathan Niño: Mejoras CEM: Validar si aplica solo para ventas Eb, de lo contrario habilitar y controlar el tipo de servicio,.
                'If txtNumeroReserva.Text.Trim = "" Then
                '    .NumeroReserva = 0
                'Else
                '    .NumeroReserva = txtNumeroReserva.Text.Trim
                'End If
                '.ActivaEquipoAnteriorTexto = chbActivaEquipoAnterior.Checked
                '.ComseguroTexto = chbComSeguro.Checked
                '.PrecioConIva = CLng(txtPrecioConIVA.Text)
                '.PrecioSinIva = CLng(txtPrecioSinIVA.Text)
                '.IdClausula = CInt(ddlClausula.SelectedValue)
                '.Lista28 = CBool(rblLista28.SelectedValue)
                .Adicionar()
            End With

            CargarDetalleDeMsisdn(idServicio)
            'Else
            'epNotificador.showError("El MSISDN que está intentando adicionar ya fue previamente adicionado. Por favor verifique")
            'End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de Agregar MINs. " & ex.Message)
        End Try
    End Sub

    Private Sub ConfigurarValidacionSerial(detalleReferencia As DetalleMaterialServicioMensajeriaColeccion)
        Dim listExpresion As New List(Of String)

        If detalleReferencia IsNot Nothing AndAlso detalleReferencia.Count > 0 Then
            Dim listProductos As New List(Of Integer)
            For Each referencia As DetalleMaterialServicioMensajeria In detalleReferencia
                listProductos.Add(referencia.IdProducto)
            Next

            Dim objConfigSerial As New ConfiguracionLecturaSerialColeccion()
            With objConfigSerial
                .ListaProducto = listProductos
                .CargarDatos()
            End With

            If objConfigSerial.Count > 0 And listProductos.Count > 0 Then
                revIccid.ValidationExpression = "^(" & objConfigSerial.ObtenerExpresionRegular() & ")$"
                revImei.ValidationExpression = "^(" & objConfigSerial.ObtenerExpresionRegular() & ")$"
            End If
        End If
    End Sub

    Private Function ValidarSiExisteMsisdn(ByVal msisdn As String)
        If Session("dtListaMsisdn") IsNot Nothing Then
            Dim dtListaMsisdn As DataTable = Session("dtListaMsisdn")
            Dim fila() As DataRow

            fila = dtListaMsisdn.Select("MSISDN = '" & msisdn & "'")
            If fila.Length = 0 Then
                txtMsisdn.Focus()
                CustomValidatorMsisdn.IsValid = False
            Else
                CustomValidatorMsisdn.IsValid = True
            End If
        End If
    End Function

#End Region

#Region "Métodos Cargue de Archivos"

    Private Sub lbCargueArchivo_Click(sender As Object, e As System.EventArgs) Handles lbCargueArchivo.Click
        ddlTipoNovedad.ClearSelection()
        txtObservacionNovedad.Text = ""
        fuArchivoAdjuntarEO.ClearPostedFiles()
        lblConfirmacion.Text = ""
        lblConfirmacion.Visible = False
        divArchivo.Style("height") = "0px"
        gvErrores.Visible = False
        With dlgArchivo
            .Width = Unit.Pixel(Me.anchoVentana * 0.29999999999999999)
            .Height = Unit.Pixel(Me.altoVentana * 0.25)
            .Show()
        End With
    End Sub

    Private Sub btnRegistrarArchivo_Click(sender As Object, e As System.EventArgs) Handles btnRegistrarArchivo.Click
        epNotificador.clear()
        lblConfirmacion.Text = ""
        lblConfirmacion.Visible = False
        divArchivo.Style("height") = "0px"
        gvErrores.Visible = False
        CargarArchivo()
    End Sub

    Private Sub btnCancelarArchivo_click(sender As Object, e As System.EventArgs) Handles btnCancelarArchivo.Click
        Try
            CargarDetalleDeReferencias(CInt(Request.QueryString("idServicio")))
        Catch ex As Exception
            epNotificador.showError("Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarArchivo()

        Dim nombreArchivoProceso As String
        Dim NombreValido As Boolean = False

        Try
            If fuArchivoAdjuntarEO.PostedFiles.Length > 0 Then
                If fuArchivoAdjuntarEO.PostedFiles(0).Length <= 10485760 Then

                    lblConfirmacion.Visible = False
                    Dim objCargueArchivo As New CargueArchivosCEM
                    With objCargueArchivo
                        Dim nombreArchivo As String = Path.GetFileNameWithoutExtension(fuArchivoAdjuntarEO.PostedFiles(0).ClientFileName) & Path.GetExtension(fuArchivoAdjuntarEO.PostedFiles(0).ClientFileName)

                        Dim ExpReg As New System.Text.RegularExpressions.Regex("^[a-zA-Z0-9-_ ]+$")
                        NombreValido = (ExpReg.IsMatch(nombreArchivo.Split(".").GetValue(0)))
                        If NombreValido Then

                            nombreArchivoProceso = Server.MapPath("Archivos\") & nombreArchivo
                            System.IO.File.Delete(nombreArchivoProceso)
                            System.IO.File.Move(fuArchivoAdjuntarEO.PostedFiles(0).TempFileName, Server.MapPath("Archivos\") & nombreArchivo)

                            Dim dtDatos As DataTable = EstructuraTabla()
                            EstablecerLicenciaGembox()
                            Dim oExcel As New ExcelFile
                            Dim wsData As ExcelWorksheet
                            Dim fileExtension As String = Path.GetExtension(nombreArchivo)
                            If fileExtension.ToUpper = ".XLS" Then
                                oExcel.LoadXls(nombreArchivoProceso)
                            ElseIf fileExtension.ToUpper = ".XLSX" Then
                                oExcel.LoadXlsx(nombreArchivoProceso, XlsxOptions.None)
                            End If
                            wsData = oExcel.Worksheets(0)
                            ValidarArchivo(wsData, dtDatos)

                            fuArchivoAdjuntarEO.ClearPostedFiles()

                            If Not dtError Is Nothing AndAlso dtError.Rows.Count > 0 Then
                                divArchivo.Style("height") = "150px"
                                With gvErrores
                                    .DataSource = dtError
                                    .DataBind()
                                End With
                                gvErrores.Visible = True
                                dlgArchivo.Show()
                            Else
                                Dim resul As Integer
                                resul = CargarRegistros(dtDatos)
                                divArchivo.Style("height") = "0px"
                                If resul = 0 Then
                                    'lblConfirmacion.Text = "Los cambios de servicio fueron registrados satisfactoriamente."
                                    'lblConfirmacion.ForeColor = Color.Blue
                                    'lblConfirmacion.Visible = True
                                    btnRegistrarArchivo.Enabled = False
                                    lbCargueArchivo.Enabled = False
                                    pnlLectura.Enabled = False
                                    lbCerrar.Enabled = True
                                    CargarDetalleDeReferencias(CInt(Request.QueryString("idServicio")))
                                    CargarDatosArchivo(CInt(Request.QueryString("idServicio")))
                                Else
                                    If dtError Is Nothing Then
                                        dtError = EstructuraTablaError()
                                    End If
                                    Select Case resul
                                        Case 1
                                            lblConfirmacion.Text = "El Imei proporcionado no figura como despachado en el servicio actual"
                                        Case 2
                                            lblConfirmacion.Text = "El Iccid proporcionado no figura como despachado en el servicio actual"
                                        Case Else
                                            lblConfirmacion.Text = "Ocurrió un error inesperado al registrar cambio de servicio. Por favor intente nuevamente."
                                    End Select
                                    lblConfirmacion.ForeColor = Color.Red
                                    dlgArchivo.Show()
                                End If
                                gvErrores.Visible = False
                                lblConfirmacion.Visible = True
                            End If
                        Else
                            fuArchivoAdjuntarEO.ClearPostedFiles()
                            lblConfirmacion.Text = "Nombre de archivo no valido"
                            lblConfirmacion.ForeColor = Color.Red
                            lblConfirmacion.Visible = True
                            dlgArchivo.Show()
                        End If
                    End With
                Else
                    fuArchivoAdjuntarEO.ClearPostedFiles()
                    lblConfirmacion.Text = "Extensión o peso del archivo no permitida"
                    lblConfirmacion.ForeColor = Color.Red
                    lblConfirmacion.Visible = True
                    dlgArchivo.Show()
                End If
            Else
                lblConfirmacion.Text = "Seleccione el archivo a procesar"
                lblConfirmacion.ForeColor = Color.Red
                lblConfirmacion.Visible = True
                dlgArchivo.Show()
            End If
        Catch ex As Exception
            epNotificador.showError("Se generó error procesando archivo: " + ex.Message)
        Finally
            If File.Exists(nombreArchivoProceso) Then File.Delete(nombreArchivoProceso)
        End Try

    End Sub

    Private Function EstructuraTabla()
        Try
            Dim dt As New DataTable
            With dt.Columns
                .Add(New DataColumn("min", GetType(Decimal)))
                .Add(New DataColumn("imei", GetType(String)))
                .Add(New DataColumn("remisionImei", GetType(String)))
                .Add(New DataColumn("facturaImei", GetType(String)))
                .Add(New DataColumn("iccid", GetType(Decimal)))
                .Add(New DataColumn("remisionIccid", GetType(String)))
                .Add(New DataColumn("facturaIccid", GetType(String)))
                .Add(New DataColumn("tipoSim", GetType(Integer)))
            End With
            dt.AcceptChanges()
            Return dt
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Function EstructuraTablaError()
        Try
            Dim dt As New DataTable
            With dt.Columns
                .Add(New DataColumn("id", GetType(Integer)))
                .Add(New DataColumn("nombre", GetType(String)))
                .Add(New DataColumn("descripcion", GetType(String)))
            End With
            dt.AcceptChanges()
            Return dt
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Sub ValidarArchivo(ByVal ws As ExcelWorksheet, ByVal dtDatos As DataTable)
        Dim index As Integer = 1
        Dim errorColumnas As Boolean = False
        Dim indexFila As Integer = 0
        Try
            For Each fila As ExcelRow In ws.Rows
                If fila.AllocatedCells.Count <> dtDatos.Columns.Count Then
                    If fila.Cells(1).Value IsNot Nothing Then
                        AdicionarError(index, "Fila inválida", "El Número de columnas es inválido.")
                        errorColumnas = True
                        Exit For
                    End If
                Else
                    Dim indexColumna As Integer = 0
                    Dim drAux As DataRow
                    drAux = dtDatos.NewRow
                    For Each columna As ExcelCell In fila.AllocatedCells
                        If indexFila > 0 Then
                            If indexColumna = 0 Or indexColumna = 1 Or indexColumna = 4 Or indexColumna = 7 Then
                                If fila.AllocatedCells(indexColumna).Value Is Nothing Then
                                    drAux(indexColumna) = 0
                                Else
                                    If fila.AllocatedCells(indexColumna).Value.ToString.Trim = "" Then
                                        drAux(indexColumna) = 0
                                    Else
                                        If IsNumeric(fila.AllocatedCells(indexColumna).Value.ToString().Trim()) Then
                                            drAux(indexColumna) = fila.AllocatedCells(indexColumna).Value.ToString().Trim()
                                        Else
                                            AdicionarError(dtError.Rows.Count + 1, "El valor no es un valor numérico:", fila.AllocatedCells(indexColumna).Value.ToString())
                                        End If
                                    End If
                                End If
                            Else
                                If fila.AllocatedCells(indexColumna).Value IsNot Nothing Then
                                    drAux(indexColumna) = fila.AllocatedCells(indexColumna).Value.ToString().Trim()
                                End If
                            End If

                            indexColumna += 1
                        Else
                            Exit For
                        End If
                    Next
                    If drAux IsNot Nothing And drAux(0) IsNot System.DBNull.Value Then
                        Dim numMin As String = drAux(0).ToString.Trim
                        Dim minExiste As Boolean = False
                        Dim drdatos() As DataRow
                        drdatos = dtDatos.Select("min = '" & numMin & "'")
                        If drdatos.Length > 0 Then
                            If drdatos(0).Item("tipoSim") <> 2 Then
                                If drdatos(0).Item("imei") = drAux(1) And drAux(1) <> 0 Then
                                    AdicionarError(dtError.Rows.Count + 1, "Min Repetido", "El Msisdn " & numMin & " ya se encuentra asociado a un Imei del mismo radicado.")
                                    minExiste = True
                                End If
                                If drdatos(0).Item("iccid") = drAux(4) And drAux(4) <> 0 Then
                                    AdicionarError(dtError.Rows.Count + 1, "Min Repetido", "El Msisdn " & numMin & " ya se encuentra asociado a un Iccid del mismo radicado.")
                                    minExiste = True
                                End If
                            Else
                                minExiste = False
                            End If
                        End If
                        If Not minExiste Then
                            dtDatos.Rows.Add(drAux)
                        End If
                    End If
                    indexFila = indexFila + 1
                End If
            Next

            If dtDatos.Rows.Count > 0 And dtDatos IsNot Nothing Then
                If Not errorColumnas Then
                    validarDatos(dtDatos)
                End If
            Else
                If dtError Is Nothing Then
                    dtError = EstructuraTablaError()
                End If
                AdicionarError(dtError.Rows.Count + 1, "Archivo Vacio", "El archivo no contiene datos.")
            End If

        Catch ex As Exception
            Throw New Exception("Se generó un error en la validación del archivo, por favor elimine las filas y columnas vacías e intente nuevamente.")
        End Try
    End Sub

    Private Sub ValidarDatos(ByVal dtDatos As DataTable)
        Dim i As Integer = 0

        If dtError Is Nothing Then
            dtError = EstructuraTablaError()
        End If

        For i = 0 To dtDatos.Rows.Count - 1
            If dtDatos.Rows(i).Item("min").ToString.Trim = "0" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El campo MIN no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("imei").ToString.Trim = "0" And dtDatos.Rows(i).Item("remisionImei").ToString.Trim <> "" And dtDatos.Rows(i).Item("facturaImei").ToString.Trim <> "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo IMEI no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("imei").ToString.Trim <> "0" And dtDatos.Rows(i).Item("remisionImei").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo REMISION_IMEI no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("imei").ToString.Trim <> "0" And dtDatos.Rows(i).Item("facturaImei").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo FACTURA_IMEI no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("iccid").ToString.Trim = "0" And dtDatos.Rows(i).Item("remisionIccid").ToString.Trim <> "" And dtDatos.Rows(i).Item("facturaIccid").ToString.Trim <> "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo ICCID no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("iccid").ToString.Trim <> "0" And dtDatos.Rows(i).Item("remisionIccid").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo REMISION_ICCID no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("iccid").ToString.Trim <> "0" And dtDatos.Rows(i).Item("facturaIccid").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo FACTURA_ICCID no puede estar vacio.")
            End If

            If dtDatos.Rows(i).Item("iccid").ToString.Trim <> "0" And dtDatos.Rows(i).Item("tipoSim").ToString.Trim = "" Then
                AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "el campo TIPO_SIM no puede estar vacio.")
            End If

            Dim resultado As ResultadoProceso
            Dim infoServicio As New CambioServicio
            If dtDatos.Rows(i).Item("imei").ToString.Trim <> "0" Then
                With infoServicio
                    .IdServicioMensajeria = CInt(Request.QueryString("idServicio"))
                    .Imei = dtDatos.Rows(i).Item("imei").ToString.Trim
                End With
                resultado = infoServicio.validarSerialServicio
                If resultado.Valor = 1 Then
                    AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El Imei " + dtDatos.Rows(i).Item("imei").ToString.Trim + "proporcionado no figura como despachado en el servicio actual")
                End If
            End If
            resultado = Nothing
            If dtDatos.Rows(i).Item("iccid").ToString.Trim <> "0" Then
                With infoServicio
                    .IdServicioMensajeria = CInt(Request.QueryString("idServicio"))
                    .Iccid = dtDatos.Rows(i).Item("iccid").ToString.Trim
                End With
                resultado = infoServicio.validarSerialServicio
                If resultado.Valor = 1 Then
                    AdicionarError(dtError.Rows.Count + 1, "Campo inválido", "El iccid " + dtDatos.Rows(i).Item("iccid").ToString.Trim + "proporcionado no figura como despachado en el servicio actual")
                End If
            End If
        Next
    End Sub

    Private Sub AdicionarError(ByVal id As Integer, ByVal nombre As String, ByVal descripcion As String)
        Try
            If dtError Is Nothing Then
                dtError = EstructuraTablaError()
            End If
            With dtError
                Dim drError As DataRow = .NewRow()
                With drError
                    .Item("id") = id
                    .Item("nombre") = nombre
                    .Item("descripcion") = descripcion
                End With
                .Rows.Add(drError)
                .AcceptChanges()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub EstablecerLicenciaGembox()
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
    End Sub

    Private Function CargarRegistros(ByVal dt As DataTable)

        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Dim idUsuario As Integer
        Dim resultado As ResultadoProceso
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim i As Integer = 0

            For i = 0 To dt.Rows.Count - 1
                Dim infoServicio As New CambioServicio
                With infoServicio
                    .IdServicioMensajeria = idServicio
                    .Msisdn = dt.Rows(i).Item("min").ToString
                    .Imei = dt.Rows(i).Item("imei").ToString
                    .FacturaImei = dt.Rows(i).Item("facturaImei").ToString
                    .RemisionImei = dt.Rows(i).Item("remisionImei").ToString
                    .Iccid = dt.Rows(i).Item("Iccid").ToString
                    .FacturaIccid = dt.Rows(i).Item("facturaIccid").ToString
                    .RemisionIccid = dt.Rows(i).Item("remisionIccid").ToString
                    .HayNovedad = rblNovedadLectura.SelectedValue
                    .IdTipoSIM = dt.Rows(i).Item("tipoSim").ToString
                End With
                resultado = infoServicio.RegistrarCambioDeServicioArchivo
                If resultado.Valor <> 0 Then
                    epNotificador.showError(resultado.Mensaje)
                    Exit For
                End If
            Next
        Catch ex As Exception
            epNotificador.showError("Imposible finalizar proceso de cambios de servicio. " & ex.Message)
        End Try
        Return resultado.Valor
    End Function

#End Region

End Class