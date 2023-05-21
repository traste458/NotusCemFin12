Imports System.Text
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes
Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO

Public Class DespacharSerialesServicioCorporativo
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
#If DEBUG Then
        Session("usxp001") = 43532
        Session("usxp009") = 147
        Session("usxp007") = 150
#End If

        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Despachar Seriales - Servicio Mensajer&iacute;a")
                Dim idServicio As Integer
                With Request
                    If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
                End With
                If idServicio > 0 Then
                    Dim infoServicio As New ServicioMensajeria(idServicio:=idServicio)
                    Dim respuesta As New ResultadoProceso
                    If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
                        Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
                        infoServicio = New ServicioMensajeria(idServicio:=idServicio)
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()
                        Session("infoServicioMensajeria") = infoServicio
                        Session("idServicio") = idServicio
                        CargarDetalleDeReferencias(idServicio)
                        AgenteServicio()
                    Else
                        miEncabezado.showWarning("No fué posible encontrar los datos del servicio.")
                        rpLectura.ClientVisible = False
                    End If
                Else
                    miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                    rpLectura.ClientVisible = False
                End If
            End With
            MetodosComunes.setGemBoxLicense()
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "Registrar"
                    Dim valor As Integer = CInt(arrayAccion(1))
                    If valor = 1 Then
                        resultado = RegistrarSerial()
                        AgenteServicio()
                    Else
                        resultado = DesvincularSerial()
                        AgenteServicio()
                    End If
                Case "Cerrar"
                    CerrarDespacho()
                Case "AgenteServicio"
                    AgenteServicio()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Ocurrio un error al generar el registro: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcSeriales_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcSeriales.WindowCallback
        VerSeriales()
    End Sub

    Private Sub pcNovedades_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcNovedades.WindowCallback
        Dim param As String = e.Parameter
        Select Case param
            Case "Inicial"
                CargaInicialNovedad()
                cmbNovedad.Focus()
            Case "Registra"
                RegistrarNovedad()
                cmbNovedad.Focus()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvHistorico_DataBinding(sender As Object, e As EventArgs) Handles gvHistorico.DataBinding
        Dim dtDatos As DataTable = Session("dtReferencias")
        If Session("dtReferencias") IsNot Nothing Then gvHistorico.DataSource = Session("dtReferencias")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Function CargarDetalleDeReferencias(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio:=idServicio, verAgrupado:=1)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            Session("dtReferencias") = dtAux
            With gvHistorico
                .DataSource = dtAux
                .DataBind()
            End With
            CargarMaterialesLectura(detalleReferencia)
            resultado.EstablecerMensajeYValor(0, "Cargue de referencias exitoso.")
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(1, "Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub CargarMaterialesLectura(ByVal detalleReferencia As DetalleMaterialServicioMensajeriaColeccion)
        Dim dtMateriales As DataTable = detalleReferencia.GenerarDataTable()
        'Dim dtMateriales As DataTable = Session("dtReferencias")
        Dim dtValor As DataTable = dtMateriales.Copy
        Dim dvValor As DataView = dtValor.DefaultView
        Dim dvDatos As DataView = dtMateriales.DefaultView
        dvDatos.RowFilter = "EsSerializado = 1 AND Cantidad > CantidadLeida"
        dvValor.RowFilter = "EsSerializado = 1"
        Dim dtAux As DataTable = dvDatos.ToTable()
        Dim dtAux1 As DataTable = dvValor.ToTable()
        If dtAux.Rows.Count = 0 Then
            tdCierra.Visible = True
            cbActivo.ClientVisible = True
        Else
            tdCierra.Visible = False
            cbActivo.ClientVisible = False
        End If
    End Sub

    Private Function RegistrarSerial() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim infoServicio As New ServicioMensajeriaVentaCorporativa(idServicio)

        resultado = infoServicio.LeerSerial(txtSerial.Text.Trim, Session("usxp001"))
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        CargarDetalleDeReferencias(idServicio)
        txtSerial.Text = ""
        txtSerial.Focus()
        Return resultado
    End Function

    Private Function DesvincularSerial() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim infoSerial As New DetalleSerialServicioMensajeria(idServicio, serial:=txtSerial.Text.Trim)
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)

        If infoSerial.Registrado Then
            If infoSerial.IdServicio = infoServicio.IdServicioMensajeria Then
                resultado = infoSerial.Eliminar(CInt(Session("usxp001")))
            Else
                miEncabezado.showWarning("El serial proporcionado no está asociado al servicio actual. Por favor verifique")
            End If
        Else
            miEncabezado.showWarning("El serial proporcionado para desvincular no ha sido despachado. Por favor verifique")
        End If

        If resultado.Valor = 0 Then
            resultado.Mensaje = "Serial desvinculado satisfactoriamente."
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        CargarDetalleDeReferencias(idServicio)
        txtSerial.Text = ""
        txtSerial.Focus()
        Return resultado
    End Function

    Private Function CerrarDespacho() As ResultadoProceso
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Dim resultado As New ResultadoProceso
        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)
            With infoServicio
                .IdUsuarioCierre = idUsuario
                If Not String.IsNullOrEmpty(txtGuia.Text) Then .NumeroGuia = txtGuia.Text.Trim
                If cmbTransportadora.Value > 0 Then .IdTransportadora = cmbTransportadora.Value
                resultado = .CerrarDespacho()
                If resultado.Valor = 0 Then
                    rpLectura.ClientVisible = False
                    miEncabezado.showSuccess(resultado.Mensaje)
                    resultado = EnviarNotificacion(idServicio)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cerrar el despacho." & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub VerSeriales()
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Try
            Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalle.GenerarDataTable()
            With gvSeriales
                .DataSource = dtDatos
                .DataBind()
            End With
            CargarDetalleDeReferencias(idServicio)
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de mostrar seriales. " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicialNovedad()
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        Dim dtEstado As New DataTable
        dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=4)
        MetodosComunes.CargarComboDX(cmbNovedad, dtEstado, "idTipoNovedad", "descripcion")

        CargarNovedades(infoServicio.IdServicioMensajeria)

    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub RegistrarNovedad()
        Dim resultado As ResultadoProceso
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        Dim novedad As New NovedadServicioMensajeria
        With novedad
            .IdServicioMensajeria = infoServicio.IdServicioMensajeria
            .Observacion = meJustificacion.Text.Trim
            .IdTipoNovedad = CInt(cmbNovedad.Value)
            resultado = .Registrar(CInt(Session("usxp001")))
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                meJustificacion.Text = ""
                cmbNovedad.SelectedIndex = -1
                CargaInicialNovedad()
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        End With
    End Sub

    Private Function EnviarNotificacion(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(idServicio)
        Dim cliente As String = miServicio.NombreCliente
        Dim nit As String = miServicio.IdentificacionCliente
        Dim fecha As String = miServicio.FechaRegistro
        Dim correo As String = miServicio.EmailConsultor
        'If correo Is Nothing Then
        '    correo = "jorge.contreras@logytechmobile.com"
        'End If
        Dim dtDatos As DataTable = miServicio.ObtenerSerialesReporteAlistamiento()
        Dim notificador As New NotificadorGeneralEventos
        Dim mensajeInicio As New ConfigValues("MENSAJE_INICIO_CORPORATIVO_ALSTSERIAL")
        Dim mensajeFin As New ConfigValues("MENSAJE_FIN_CORPORATIVO_ALSTSERIAL")
        Dim firmaMensaje As New ConfigValues("FIRMA_MENSAJE")
        Dim ruta As String
        ObtenerReporteSeriales(ruta, dtDatos, idServicio, cliente, nit, fecha)

        With notificador
            .InicioMensaje = mensajeInicio.ConfigKeyValue
            .FinMensaje = mensajeFin.ConfigKeyValue
            .FirmaMensaje = firmaMensaje.ConfigKeyValue
            .AdjuntosURL.Add(ruta)
            .Titulo = "Notificación Alistamiento de seriales Venta Corporativa"
            .Asunto = "Alistamiento de seriales para el servicio de tipo Venta Corporativa, con el identificador:  " & idServicio
            resultado = .NotificacionEvento(usuarioUnicoNotificacion:=correo)
        End With

        Return resultado
    End Function

    Private Sub ObtenerReporteSeriales(ByRef ruta As String, ByVal dtReporte As DataTable, ByVal idServicio As Integer, ByVal cliente As String, ByVal nit As String, ByVal fecha As String)
        'ruta = GenerarArchivoExcel(dtReporte, idServicio, cliente)
        Dim resultado As New ResultadoProceso
        Dim objDatos As New MensajeriaEspecializada.ReporteAdendoVentaCorporativa
        Dim miServicio As New ServicioMensajeriaVentaCorporativa(CInt(idServicio))
        With objDatos
            .DatosReporte = dtReporte
            .IdServicio = idServicio
            .Cliente = cliente
            .Nit = nit
            .Ciudad = miServicio.Ciudad
            .Departamento = miServicio.NombreDepartamento
            .Direccion = miServicio.Direccion
            .Telefono = miServicio.TelefonoContacto
            .RepresentanteLegal = miServicio.NombreRepresentanteLegal
            .IdentificacionRepresentanteLegal = miServicio.IdentificacionRepresentanteLegal
            .Fecha = miServicio.FechaRegistro
            resultado = .GenerarReporteExcel()
            If resultado.Valor = 0 Then
                ruta = .RutaArchivo
            End If
        End With
    End Sub

    Private Function GenerarArchivoExcel(ByVal dtReporte As DataTable, ByVal idServicio As Integer, ByVal cliente As String)
        Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaAsignacionSeriales.xlsx")
        Dim nombreArchivo As String = Server.MapPath("~/archivos_planos/PlantillaAsignacionSeriales" & Session("usxp001") & ".xls")
        Dim miExcel As New ExcelFile
        Dim miHoja As ExcelWorksheet
        Dim numRegistros As Integer = 0
        If File.Exists(rutaPlantilla) Then
            miExcel.LoadXlsx(rutaPlantilla, XlsxOptions.PreserveMakeCopy)
            miHoja = miExcel.Worksheets.ActiveWorksheet
            miHoja.Cells("B4").Value = idServicio
            miHoja.Cells("B5").Value = cliente
            numRegistros = miHoja.InsertDataTable(dtReporte, "A8", False)
        Else
            miHoja = miExcel.Worksheets.Add("Seriales Asignados")
            With miHoja
                .Cells("A1").Value = "Id Servicio: " & idServicio
                .Cells("A2").Value = "Nombre Cliente: " & cliente
                numRegistros = miHoja.InsertDataTable(dtReporte, "A4", True)
            End With
        End If
        For index As Integer = 0 To dtReporte.Columns.Count - 1
            miHoja.Columns(index).AutoFitAdvanced(1.1)
        Next
        miExcel.SaveXls(nombreArchivo)
        Return nombreArchivo
    End Function

    Private Sub AgenteServicio()
        Dim dtTransportadora As New DataTable
        If Session("dtTransportadora") Is Nothing Then
            Dim objTransp As New TransportadoraColeccion()
            With objTransp
                .Estado = True
                dtTransportadora = .GenerarDataTable()
                Session("dtTransportadora") = dtTransportadora
            End With
        Else
            dtTransportadora = Session("dtTransportadora")
        End If
        MetodosComunes.CargarComboDX(cmbTransportadora, dtTransportadora, "IdTransportadora", "Nombre")
    End Sub

#End Region

End Class