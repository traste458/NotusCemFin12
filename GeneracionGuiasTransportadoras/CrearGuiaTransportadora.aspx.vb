Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports System.Linq
Imports Newtonsoft.Json

Public Class CrearGuiaTransportadora
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If
        Seguridad.verificarSession(Me)

        If Not IsPostBack And Not IsCallback Then
            CargaInicial()
        End If

        If IsPostBack Then
            If (cmbTipoAsignacion.Value = 1) Then
                lblBodegaOrigen.ClientVisible = True
                cmbBodegaOrigen.ClientVisible = True
                lblTipoBodegaDestino.ClientVisible = True
                cmbTipoBodegaDestino.ClientVisible = True
                lblBodegaDestino.ClientVisible = True
                cmbBodegaDestino.ClientVisible = True
            Else
                lblTipoBodegaDestino.ClientVisible = False
                cmbTipoBodegaDestino.ClientVisible = False
                lblBodegaDestino.ClientVisible = False
                cmbBodegaDestino.ClientVisible = False
            End If
        End If
    End Sub

    Private Sub CargaInicial()

        'Dim despacho As New RutaServicioMensajeriaTransportadora
        'despacho.LimpiarDespachosTemporal()


        Dim tipoBodega As New CargueInventarioCemMasivoSerializado
        Dim dtTipoBodega As New DataTable
        dtTipoBodega = tipoBodega.ConsultarTipoBodega
        Session("dtTipoBodega") = dtTipoBodega

        'MetodosComunes.CargarComboDX(cmbTipoBodegaOrigen, dtTipoBodega, "idTipo", "nombre")
        CargarBodegasOrigen()
        MetodosComunes.CargarComboDX(cmbTipoBodegaDestino, dtTipoBodega, "idTipo", "nombre")

        'MetodosComunes.CargarComboDX(ddlUnidades, UnidadEmpaque.ObtenerListado(), "idTipoUnidad", "descripcion")
        Dim CuentasT As New CuentasTransportadoras
        ddlMedioTransporte.DataSource = CuentasT.ListarTipoTransporte
        ddlMedioTransporte.ValueField = "idTipo"
        ddlMedioTransporte.TextField = "nombre"
        ddlMedioTransporte.DataBind()

        CuentasT.numRadicadoTemporalGenerarGuiaXMetodo(0, Session("usxp001"), "LimpiarXUsuario")

        cargarTranspotadoras()
    End Sub
    Private Sub cargarTranspotadoras()
        cmbTransportadora.DataSource = Nothing
        cmbRangoGuias.DataSource = Nothing
        Dim dtTransportadora As DataTable
        ' If cmbTipoAsignacion.Value = 2 Then
        dtTransportadora = ObtenerTransportadoras(listaIdTransportadoras:=MetodosComunes.seleccionarConfigValue("idTransportadorasActivas"))
        'Else
        '    dtTransportadora = ObtenerTransportadoras()
        'End If

        Session("dtTransportadora") = dtTransportadora
        MetodosComunes.CargarComboDX(cmbTransportadora, dtTransportadora, "idtransportadora", "transportadora")

    End Sub
    Private Sub cmbTransportadora_ValueChanged(sender As Object, e As EventArgs) Handles cmbTransportadora.ValueChanged
        CargarCuentasTransportadora(cmbTransportadora.Value, cmbBodegaOrigen.Value)
    End Sub

    Private Sub CargarCuentasTransportadora(ByVal IdTransportadora As Integer, ByVal idBodega As Integer)
        cmbRangoGuias.SelectedIndex = -1
        cmbRangoGuias.DataSource = Nothing
        cmbRangoGuias.DataBind()
        cmbRangoGuias.Items.Clear()

        If IdTransportadora = 0 Or idBodega = 0 Then
            Exit Sub
        End If
        Dim list1 As New List(Of String)
        'list1.AddRange({2, 31}) 'pasarla a configvalue
        Dim idTrasmportadoreasNoBodegas As String = Comunes.ConfigValues.seleccionarConfigValue("ggtTransportadorasConCodigoBodega")
        list1 = (From s In idTrasmportadoreasNoBodegas.Split(",") Select s).ToList()
        If list1.Contains(IdTransportadora) = False Then
            idBodega = 0
        End If
        Dim dt As DataTable = Nothing
        Try
            Dim infoRangos As New CuentasTransportadoras
            With infoRangos
                dt = infoRangos.ObtenerCuentasTransportadora(idTransportadora:=IdTransportadora, idBodega:=idBodega)
            End With
            MetodosComunes.CargarComboDX(cmbRangoGuias, dt, "idcuenta", "Descripcion")
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Private Sub CargarBodegasOrigen()
        Dim dt As DataTable = Nothing
        Try
            dt = ILSBusinessLayer.BodegaSatelite.ObtenerBodegasPorUsuario(Session("usxp001"))
            MetodosComunes.CargarComboDX(cmbBodegaOrigen, dt, "idbodega", "bodega")
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Private Sub cmbTipoBodegaDestino_ValueChanged(sender As Object, e As EventArgs) Handles cmbTipoBodegaDestino.ValueChanged
        CargarBodegasDestino(cmbTipoBodegaDestino.Value)
    End Sub

    Private Sub CargarBodegasDestino(ByVal IdTipoBodega As Integer)
        Dim dt As DataTable = Nothing
        Try
            Dim infoBodegas As New CargueInventarioCemMasivoSerializado
            With infoBodegas
                .idTipoBodega = IdTipoBodega
                dt = infoBodegas.ConsultarBodegasPosicion
            End With

            MetodosComunes.CargarComboDX(cmbBodegaDestino, dt, "idbodega", "bodega")

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub


    Private Sub ValidarRadicado(ByVal Radicado As Long, ByVal IdBodega As Integer)
        miEncabezado.clear()
        Dim validacion As New RutaServicioMensajeriaTransportadora
        Dim dt As New DataTable

        With validacion
            .Radicado = Radicado
            .IdBodegaDestino = IdBodega
            dt = .ValidarRadicado
        End With

        If dt.Rows(0)(0) = 1 Then
            AgregarRadicado(Radicado)
            rpGenerar.Visible = True
            rpRadicados.Visible = True
        Else
            miEncabezado.showError("El número de radicado no esta en un estado valido, o no pertenece a la bodega seleccionada.")
        End If

    End Sub

    Private Function ValidarCamposVacios() As Boolean
        Dim resultado As Boolean = True
        miEncabezado.clear()

        If IsNothing(cmbTipoAsignacion.Value) Then
            miEncabezado.showWarning("Seleccione el tipo de asignación")
            resultado = False
        Else
            If String.IsNullOrEmpty(txtRadicado.Text) Then
                miEncabezado.showWarning("Debe ingresar un radicado")
                resultado = False
            Else
                If cmbTipoAsignacion.Value = 1 Then
                    If IsNothing(cmbTransportadora.Value) Or IsNothing(cmbRangoGuias.Value) Or
                    cmbBodegaOrigen.SelectedIndex < 0 Or IsNothing(cmbTipoBodegaDestino.Value) Or cmbBodegaDestino.SelectedIndex < 0 Or cmbRangoGuias.SelectedIndex < 0 Then
                        resultado = False
                    End If
                Else
                    If IsNothing(cmbTransportadora.Value) Or IsNothing(cmbRangoGuias.Value) Or
                    cmbBodegaOrigen.SelectedIndex < 0 Or cmbRangoGuias.SelectedIndex < 0 Or cmbTransportadora.SelectedIndex < 0 Then
                        resultado = False
                    End If
                End If
            End If

        End If

        'If txtRadicado.Text.Trim.Length = 0 Then
        '    resultado = False
        'End If

        Return resultado
    End Function

    Private Sub CargarDespachosTemporales()
        Session.Remove("dtDatos")
        Dim dt As DataTable = Nothing
        Try
            Dim CuentasT As New CuentasTransportadoras
            Dim resultado As New CuentasTransportadoras.ResultadoRadicadosTemporal

            resultado = CuentasT.ListarnumRadicadoTemporalGenerarGuiaXMetodo(Session("usxp001"))
            Session("dtDatos") = resultado.dtTabla
            gvDatos.DataSource = Session("dtDatos")
            gvDatos.DataBind()

            txtpopValorDeclarado.Text = resultado.ValorDeclarado
            txtpopContenido.Text = resultado.diceContener

            If CType(Session("dtDatos"), DataTable).Rows.Count = 0 Then
                cmbTipoAsignacion.Enabled = True
                cmbTransportadora.Enabled = True
                cmbRangoGuias.Enabled = True
                cmbBodegaDestino.Enabled = True
                cmbBodegaOrigen.Enabled = True
                cmbTipoBodegaDestino.Enabled = True

                txtRadicado.Enabled = True
                btnAgregarRadicado.Enabled = True

                rpGenerar.Visible = False
                rpRadicados.Visible = False
            Else
                rpGenerar.Visible = True
                rpRadicados.Visible = True
                SubControles()
            End If

        Catch ex As Exception
            miEncabezado.showError("Excepción al listar Radicado temporal.")
        End Try
    End Sub

    Private Sub AgregarRadicado(ByVal Radicado As Long)
        Dim dt As DataTable = Nothing
        Dim mensaje As String = ""
        miEncabezado.clear()

        Try
            Dim CuentasT As New CuentasTransportadoras
            mensaje = CuentasT.numRadicadoTemporalGenerarGuiaXMetodo(Radicado, Session("usxp001"), "AgregarNumRadicado")

            If mensaje = "Duplicado" Then
                miEncabezado.showError("El radicado ya existe en la relación")
            End If
        Catch ex As Exception
            miEncabezado.showError(ex.Message)
        End Try
    End Sub
    Private Sub SubControles()
        cmbTipoAsignacion.Enabled = False
        cmbTransportadora.Enabled = False
        cmbRangoGuias.Enabled = False
        cmbBodegaDestino.Enabled = False
        cmbBodegaOrigen.Enabled = False
        cmbTipoBodegaDestino.Enabled = False


        If cmbTipoAsignacion.Value = 2 Then
            txtRadicado.Enabled = False
            btnAgregarRadicado.Enabled = False
        End If
        If cmbTransportadora.Text.ToUpper = "SERVIENTREGA".ToUpper Then
            ddlMedioTransporte.ClientVisible = True
            lblMedioTransporte.ClientVisible = True
            txtnumBolsaSeguridad.ClientVisible = False
            lblnumBolsaSeguridad.ClientVisible = False
        ElseIf cmbTransportadora.Text.ToUpper = "Envia".ToUpper Then
            ddlMedioTransporte.ClientVisible = False
            lblMedioTransporte.ClientVisible = False
            txtnumBolsaSeguridad.ClientVisible = True
            lblnumBolsaSeguridad.ClientVisible = True
        Else
            ddlMedioTransporte.ClientVisible = False
            lblMedioTransporte.ClientVisible = False
            txtnumBolsaSeguridad.ClientVisible = False
            lblnumBolsaSeguridad.ClientVisible = False
        End If

        txtRadicado.Text = ""
    End Sub
    Protected Sub EliminarRadicado(ByVal Radicado As Long)
        Try
            Dim dt As DataTable = Nothing
            Try
                Dim CuentasT As New CuentasTransportadoras
                CuentasT.numRadicadoTemporalGenerarGuiaXMetodo(Radicado, Session("usxp001"), "LimpiarXNumRadicado")
            Catch ex As Exception
                miEncabezado.showError("Excepción al eliminar Radicado temporal.")
            End Try

            CargarDespachosTemporales()
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim Radicado As Long

        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)
            Radicado = CLng(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "numRadicado"))

            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", Radicado)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        cpGeneral.JSProperties("cpMostrarDoc") = Nothing
        cpGeneral.JSProperties("cpMostrarDoc2") = Nothing
        cpGeneral.JSProperties("cpDescargarDoc") = Nothing
        miEncabezado.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "GenerarGuia"


                    If ValidarGeneracionGuia() Then
                        GenerarGuia(sender)
                    Else
                        miEncabezado.showWarning("Existen campos vacíos. Por favor diligéncielos")
                    End If
                Case "AgregarRadicado"
                    If ValidarCamposVacios() Then
                        ValidarRadicado(txtRadicado.Text.Trim, cmbBodegaOrigen.Value)
                    Else
                        miEncabezado.showWarning("Existen campos vacíos. Por favor diligéncielos")
                    End If
                    SubControles()
                    CargarDespachosTemporales()
                Case "EliminarRadicado"
                    EliminarRadicado(arryAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Function ValidarGeneracionGuia() As Boolean
        Dim resultado As Boolean = True
        miEncabezado.clear()

        If txtPeso.Text.Trim.Length = 0 Or txtVolumen.Text.Trim.Length = 0 Or txtCantidad.Text.Trim.Length = 0 Then
            resultado = False
        Else
            resultado = True
        End If

        Return resultado
    End Function
    Private Sub GenerarGuia(sender As Object)
        Dim infoCuentas As New CuentasTransportadoras
        Dim DtoGenerar As New GeneracionGuias.dtoGeneracionGuias
        '  Dim Reultado As New GeneracionGuias.Resultado
        Dim idBodegaRemite As Integer = 0
        If cmbTransportadora.Text.ToUpper = "INTERRAPIDISIMO".ToUpper Then
            idBodegaRemite = cmbBodegaOrigen.Value
        End If
        DtoGenerar.DatoConexion = infoCuentas.ObtenerCuentasTransportadorasXidCuenta(cmbRangoGuias.Value, idBodegaOrigen:=idBodegaRemite)
        DtoGenerar.DatoConexion.idUsuario = Session("usxp001")
        DtoGenerar.DatoConexion.idTransportadora = cmbTransportadora.Value
        DtoGenerar.DatoConexion.numGrupoGuia = 0
        Dim BodDestino, BodOrigen As Integer
        BodDestino = 0
        BodOrigen = 0

        If String.IsNullOrEmpty(cmbBodegaDestino.Value) = False Then
            BodDestino = cmbBodegaDestino.Value
        End If
        If String.IsNullOrEmpty(cmbBodegaOrigen.Value) = False Then
            BodOrigen = cmbBodegaOrigen.Value
        End If
        Dim strMetodo As String = ""
        If cmbTipoAsignacion.Value = 2 Then
            strMetodo = "EntregaCliente"
        Else
            strMetodo = "Traslado"
        End If
        Dim dtoGuiasX(0) As GeneracionGuias.dtoGuias
        DtoGenerar.DatoGuias = dtoGuiasX
        DtoGenerar.DatoGuias(0) = infoCuentas.ObtenerDatosGenerarGuiaXidUsuario(Metodo:=strMetodo, idUsuario:=Session("usxp001"), IdBodegaDestino:=BodDestino, idBodegaRemite:=BodOrigen)
        DtoGenerar.DatoGuias(0).idTipoEnvio = cmbTipoAsignacion.Value
        DtoGenerar.DatoGuias(0).DiceContener = txtpopContenido.Text
        DtoGenerar.DatoGuias(0).Num_ValorDeclaradoTotal = txtpopValorDeclarado.Text
        DtoGenerar.DatoGuias(0).idGuia = 1

        DtoGenerar.DatoGuias(0).Num_VolumenTotal = txtVolumen.Text.Trim
        DtoGenerar.DatoGuias(0).Num_PesoTotal = txtPeso.Text.Trim
        DtoGenerar.DatoGuias(0).NumeroPiezas = txtCantidad.Text.Trim
        DtoGenerar.DatoGuias(0).UnidadEmpaque = "GENERICA" ' ddlUnidades.Text
        DtoGenerar.DatoGuias(0).Des_MedioTransporte = ddlMedioTransporte.Value
        DtoGenerar.DatoGuias(0).NotasGuia50caracteres = txtnumBolsaSeguridad.Text.Trim
        '------------------------------
        'Validar Datos a enviar a transportadora...

        Dim strValidar As String = ""
        strValidar = ValidarDataEnviarTransportadora(DtoGenerar)
        If strValidar <> "" Then
            miEncabezado.showWarning(strValidar)
            CargarDespachosTemporales()
            Exit Sub
        End If
        DtoGenerar.DatoGuias(0).DatoMaterialDetalle = infoCuentas.ObtenerDatosGenerarGuiaDetalleXidUsuario(Session("usxp001"))
        ' Reultado = infoCuentas.GenerarGuia(DtoGenerar)
        DtoGenerar = infoCuentas.GenerarGuia(DtoGenerar)
        If DtoGenerar.EsExitoso = True Then
            'Dim xError As String = ""
            'For x As Integer = 0 To Reultado.Mensaje.Length - 1
            '    If IsNothing(Reultado.Mensaje(x)) Then
            '        Continue For
            '    End If
            '    xError = xError & Reultado.Mensaje(x) & ", "
            'Next
            'If Reultado.Mensaje.Length > 2 Then
            '    xError = xError.Substring(0, xError.Length - 2)
            'End If

            miEncabezado.showSuccess("Se Genero la Guia: " & DtoGenerar.DatoGuias(0).Guia & " con la informacion seleccionada.")
            If String.IsNullOrEmpty(DtoGenerar.DatoGuias(0).Guia) = False Then
                Dim intIdServicio100Digital As Integer = 0
                intIdServicio100Digital = infoCuentas.ggtGuardarDatosGeneracionGuia(DtoGenerar.DatoGuias(0).Guia, DtoGenerar, cmbTipoAsignacion.Value)
                If intIdServicio100Digital > 0 Then
                    HerramientasDelivery.ActualizarEstadoDelivery(intIdServicio100Digital, Enumerados.EstadoServicio.AsignadoRuta, CInt(Session("usxp001")))
                End If
                If DtoGenerar.DatoConexion.NombreTransportadora.ToUpper = "Servientrega".ToUpper Then
                    Dim DtoStiker As New GeneracionGuias.dtoGenerarGuiaStickerServiEntrega
                    DtoStiker.guia = DtoGenerar.DatoGuias(0).Guia
                    DtoStiker.login = DtoGenerar.DatoConexion.login
                    DtoStiker.pwd = DtoGenerar.DatoConexion.pwd
                    DtoStiker.id_CodFacturacion = DtoGenerar.DatoConexion.CodFacturacion
                    Dim Ruta() As Byte
                    Ruta = infoCuentas.GenerarGuiaStickerServiEntrega(DtoStiker, Server.MapPath("./Temp"))

                    If Ruta.Length > 1 Then
                        Try
                            Dim respuestaDoc As New ResultadoProceso
                            respuestaDoc = infoCuentas.ggtRegistrarDocumentoServicioMensajeria(DtoGenerar.DatoConexion.idUsuario, Ruta, DtoGenerar.DatoGuias(0).Guia)
                            If respuestaDoc.Valor = -1 Then
                                miEncabezado.showError(respuestaDoc.Mensaje)
                            Else
                                Dim rutaaaX As String = "../MensajeriaEspecializada/DescargaDocumento.aspx?id=" & respuestaDoc.Valor & "&rutaDocumento=" & respuestaDoc.Mensaje
                                cpGeneral.JSProperties("cpDescargarDoc") = rutaaaX
                            End If
                        Catch ex As Exception

                        End Try
                    End If
                ElseIf DtoGenerar.DatoConexion.NombreTransportadora.ToUpper = "INTERRAPIDISIMO".ToUpper Then
                    Dim DtoStiker As New GeneracionGuias.dtoGenerarGuiaStickerServiEntrega
                    DtoStiker.guia = DtoGenerar.DatoGuias(0).Guia
                    DtoStiker.login = DtoGenerar.DatoConexion.login
                    DtoStiker.pwd = DtoGenerar.DatoConexion.pwd
                    DtoStiker.id_CodFacturacion = DtoGenerar.DatoConexion.CodFacturacion
                    Dim Ruta() As Byte
                    Ruta = infoCuentas.GenerarGuiaStickerInterrapidisimo(DtoStiker, Server.MapPath("./Temp"))

                    If Ruta.Length > 1 Then
                        Try
                            Dim respuestaDoc As New ResultadoProceso
                            respuestaDoc = infoCuentas.ggtRegistrarDocumentoServicioMensajeria(DtoGenerar.DatoConexion.idUsuario, Ruta, DtoGenerar.DatoGuias(0).Guia)
                            If respuestaDoc.Valor = -1 Then
                                miEncabezado.showError(respuestaDoc.Mensaje)
                            Else
                                Dim rutaaaX As String = "../MensajeriaEspecializada/DescargaDocumento.aspx?id=" & respuestaDoc.Valor & "&rutaDocumento=" & respuestaDoc.Mensaje
                                cpGeneral.JSProperties("cpDescargarDoc") = rutaaaX
                            End If
                        Catch ex As Exception

                        End Try
                    End If

                ElseIf DtoGenerar.DatoConexion.NombreTransportadora.ToUpper = "TCC".ToUpper Then
                    Dim Ruta() As Byte
                    Dim Sesultado As String
                    Sesultado = DtoGenerar.DatoGuias(0).GuiaBase64 ' JsonConvert.DeserializeObject(Of String)(DtoGenerar.DatoGuias(0).GuiaBase64)
                    Ruta = Convert.FromBase64String(Sesultado)

                    If Ruta.Length > 1 Then
                        Try
                            Dim respuestaDoc As New ResultadoProceso
                            respuestaDoc = infoCuentas.ggtRegistrarDocumentoServicioMensajeria(DtoGenerar.DatoConexion.idUsuario, Ruta, DtoGenerar.DatoGuias(0).Guia)
                            If respuestaDoc.Valor = -1 Then
                                miEncabezado.showError(respuestaDoc.Mensaje)
                            Else
                                Dim rutaaaX As String = "../MensajeriaEspecializada/DescargaDocumento.aspx?id=" & respuestaDoc.Valor & "&rutaDocumento=" & respuestaDoc.Mensaje
                                cpGeneral.JSProperties("cpDescargarDoc") = rutaaaX
                            End If
                        Catch ex As Exception

                        End Try
                    End If
                ElseIf DtoGenerar.DatoConexion.NombreTransportadora.ToUpper = "Envia".ToUpper Then
                    cpGeneral.JSProperties("cpMostrarDoc") = DtoGenerar.DatoGuias(0).URLGuia
                    Dim rutaURL2 As String
                    rutaURL2 = DtoGenerar.DatoGuias(0).URLGuia.Replace("Guia3", "ISticker_ZEA")
                    cpGeneral.JSProperties("cpMostrarDoc2") = rutaURL2
                End If
                infoCuentas.numRadicadoTemporalGenerarGuiaXMetodo(0, Session("usxp001"), "LimpiarXUsuario")
            End If
        Else
            Dim xError As String = ""
            'For x As Integer = 0 To Reultado.Mensaje.Length - 1
            '    If IsNothing(Reultado.Mensaje(x)) Then
            '        Continue For
            '    End If
            '    xError = xError & Reultado.Mensaje(x) & ", "
            'Next
            'If Reultado.Mensaje.Length > 2 Then
            '    xError = xError.Substring(0, xError.Length - 2) 23514461
            'End If
            xError = DtoGenerar.MensajeError
            If IsNothing(DtoGenerar.DatoGuias) = False Then
                If IsNothing(DtoGenerar.DatoGuias(0).Mensaje) = False Then
                    If DtoGenerar.DatoGuias(0).Mensaje(0).Length > 0 Then
                        xError = DtoGenerar.DatoGuias(0).Mensaje(0)
                    End If
                End If
            End If
            miEncabezado.showWarning("Error al Generar la Guia, " & xError)
        End If
        CargarDespachosTemporales()
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Private Function ValidarDataEnviarTransportadora(ByVal data As GeneracionGuias.dtoGeneracionGuias) As String
        Dim mensaje As String = ""
        mensaje = "Datos Incompletos: "
        If data.DatoGuias(0).DestinatarioNombre.Trim = "" Then
            mensaje = mensaje & "Destinatario Nombre, "
        End If
        If data.DatoGuias(0).DestinatarioDireccion.Trim = "" Then
            mensaje = mensaje & "Destinatario Direccion, "
        End If
        If data.DatoGuias(0).DestinatarioTelefono.Trim = "" Then
            mensaje = mensaje & "Destinatario Telefono, "
        End If
        If data.DatoGuias(0).DestinatarioIdentificacion.Trim = "" Then
            mensaje = mensaje & "Destinatario Identificacion, "
        End If
        If data.DatoGuias(0).DestinatarioCiudad.Trim = "" Then
            mensaje = mensaje & "Destinatario Ciudad Entrega, "
        End If
        If data.DatoGuias(0).RemiteCiudad.Trim = "" Then
            mensaje = mensaje & "Remitente Ciudad Recogida, "
        End If
        If data.DatoGuias(0).NumeroPiezas < 1 Then
            mensaje = mensaje & "Cantidad no puede ser menor a cero, "
        End If
        If data.DatoGuias(0).Num_ValorDeclaradoTotal < 5000 Then
            If data.DatoConexion.NombreTransportadora.ToUpper = "SERVIENTREGA".ToUpper Then
                mensaje = mensaje & "El Valor Declarado debe ser mayor a 5000, "
            ElseIf data.DatoGuias(0).Num_ValorDeclaradoTotal <= 0 Then
                mensaje = mensaje & "El Valor Declarado debe ser mayor a cero, "
            End If
        End If
        If data.DatoGuias(0).Num_PesoTotal <= 0 Then
            mensaje = mensaje & "Peso debe ser mayor a cero, "
        End If
        If data.DatoConexion.idSistemaProceso <= 0 Then
            mensaje = mensaje & "ConfigValue ggtSistemaProceso, No Encontrado"
        End If

        If mensaje = "Datos Incompletos: " Then
            mensaje = ""
        Else
            mensaje = mensaje & "necesarios para generar la Guia."
        End If
        Return mensaje
    End Function

    Private Sub GenerarDespacho()
        Try
            Dim Transportadora As Integer = cmbTransportadora.Value
            Dim RangoGuia As Integer = cmbRangoGuias.Value
            Dim BodegaOrigen As Integer = cmbBodegaOrigen.Value
            Dim BodegaDestino As Integer = cmbBodegaDestino.Value
            Dim Peso As Double = txtPeso.Text.Trim
            Dim Volumen As Double = txtVolumen.Text.Trim
            ' Dim idTipoUnidad As Integer = ddlUnidades.Value
            Dim cantidad As String = txtCantidad.Text.Trim
            Dim NuevoDespacho As Integer = 0

            Dim despacho As New RutaServicioMensajeriaTransportadora
            Dim dt As DataTable = gvDatos.DataSource

            With despacho
                .IdTransportadora = Transportadora
                .IdRangoGuia = RangoGuia  'idRango Guia y/o idCuenta
                .IdBodegaOrigen = BodegaOrigen

                If cmbTipoAsignacion.Value = 1 Then
                    .IdBodegaDestino = BodegaDestino
                Else
                    .IdBodegaDestino = 0
                End If

                .Peso = Peso
                .Volumen = Volumen
                '   .idTipoUnidad = idTipoUnidad
                .cantidad = cantidad
                .idTipoEnvio = cmbTipoAsignacion.Value
                .IdUsuario = Session("usxp001")

                NuevoDespacho = .GuardarDespacho()

                .LimpiarDespachosTemporal()
            End With

            LimpiarControles()

            cargareporte("../ReportesCEM/VisorReporteGuiaTransportadoraCEM.aspx?repo=guia&desp=" & NuevoDespacho.ToString)
            Threading.Thread.Sleep(5000)
            cargarHojaRuta("../ReportesCEM/VisorHojaRutaCEM.aspx?desp=" & NuevoDespacho.ToString)
        Catch ex As Exception
            miEncabezado.showError(ex.Message)
        End Try
    End Sub

    Private Sub cargareporte(ByVal url As String)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Guia", "window.open('" & url & "');", True)
    End Sub

    Private Sub cargarHojaRuta(ByVal url As String)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Remisión", "window.open('" & url & "');", True)
    End Sub

    Private Sub LimpiarControles()
        cmbTipoAsignacion.Enabled = True
        cmbTransportadora.Enabled = True
        cmbRangoGuias.Enabled = True
        cmbBodegaDestino.Enabled = True
        cmbBodegaOrigen.Enabled = True
        cmbTipoBodegaDestino.Enabled = True
        txtRadicado.Enabled = True
        btnAgregarRadicado.Enabled = True
        cmbRangoGuias.SelectedIndex = -1
        cmbBodegaDestino.SelectedIndex = -1
        cmbTipoBodegaDestino.SelectedIndex = -1
        cmbBodegaOrigen.SelectedIndex = -1
        cmbTipoAsignacion.SelectedIndex = -1
        cmbTransportadora.SelectedIndex = -1
        txtRadicado.Text = ""
        txtCantidad.Text = ""
        txtPeso.Text = ""
        txtVolumen.Text = ""
        Dim despacho As New RutaServicioMensajeriaTransportadora
        despacho.LimpiarDespachosTemporal()
        Session.Remove("dtDatos")
        gvDatos.DataSource = Nothing
        gvDatos.DataBind()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        LimpiarControles()
    End Sub

    Protected Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    End Sub

    Protected Sub cmbBodegaOrigen_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbBodegaOrigen.SelectedIndexChanged
        CargarCuentasTransportadora(cmbTransportadora.Value, cmbBodegaOrigen.Value)
    End Sub

    Protected Sub cmbRangoGuias_DataBinding(sender As Object, e As EventArgs) Handles cmbRangoGuias.DataBinding

    End Sub
End Class