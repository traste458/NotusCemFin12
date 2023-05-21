Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class ConsultaServiciosSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _PersonasGerencia As DataTable

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
#If DEBUG Then
        Session("usxp001") = 45253
        Session("usxp009") = 114
        Session("usxp007") = 150
#End If

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Consulta de Servicios SIEMBRA")
            End With
            CargarPermisosOpcionesRestringidas()
            CargarRestriccionesDeOpcionPorEstados()

            CargaInicial()
        End If
    End Sub

    Private Sub gvServicios_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvServicios.CustomCallback
        Dim idUsuario As Integer = 0
        Try
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
            Dim arrParametros() As String = e.Parameters.Split("|")

            Select Case arrParametros(0)
                Case "consultar"
                    Dim objServiciosSiembra As New ServicioMensajeriaSiembraColeccion()
                    With objServiciosSiembra
                        Dim arrServicios() As String = txtidServicio.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                        If arrServicios.Length > 0 Then
                            .ListServicioMensajeria = New List(Of Integer)
                            For i As Integer = 0 To arrServicios.Length - 1
                                .ListServicioMensajeria.Add(CInt(arrServicios(i)))
                            Next
                        End If
                        .IdEstado = cmbEstado.Value
                        .FechaRegistroInicio = dateFechaInicio.Date
                        .FechaRegistroFin = dateFechaFin.Date
                        .IdGerencia = cmbGerencia.Value
                        .IdCoordiandor = cmbCoordinador.Value
                        .IdConsultor = cmbConsultor.Value
                        .CargarDatos()
                    End With

                    With gvServicios
                        .DataSource = objServiciosSiembra
                        Session("objServiciosSiembra") = objServiciosSiembra
                        .DataBind()
                    End With

                Case "crearOrdenRecoleccion"
                    Dim objRutaServicio As New RutaServicioMensajeriaSiembra()
                    With objRutaServicio
                        .IdEstado = Enumerados.RutaMensajeria.Creada
                        .IdUsuarioLog = idUsuario
                        .TipoRuta = Enumerados.TipoRutaServicioMensajeria.RecoleccionClienteSiembra
                        .ServiciosDatatable = ObtenerDetalleSerial(arrParametros(1).Split(","))

                        Dim resultado As ResultadoProceso = .Registrar()
                        If resultado.Valor = 0 Then
                            miEncabezado.showSuccess("Se generó correctamente la orden de recolección número: " + (resultado.Mensaje.Split("-"))(0))
                        Else
                            miEncabezado.showWarning("No se logro generar la orden de despacho: " + resultado.Mensaje)
                        End If
                    End With
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar la búsqueda " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvServicios_DataBinding(sender As Object, e As System.EventArgs) Handles gvServicios.DataBinding
        If Session("objServiciosSiembra") IsNot Nothing Then gvServicios.DataSource = Session("objServiciosSiembra")
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idEstado As Integer
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            idEstado = CInt(gvServicios.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdEstado"))

            'Link de Visualización de detalle
            With linkVer
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With

            Dim arrControles() As String = {"lnkProgramarRecoleccion", "lnkNuevoServicio"}
            For indice As Integer = 0 To arrControles.Length - 1
                Dim ctrl As ASPxHyperLink = templateContainer.FindControl(arrControles(indice))
                With ctrl
                    .Visible = EsVisibleOpcionRestringida(.ID, 0, idTipo:=Enumerados.TipoServicio.Siembra)
                    If .Visible Then .Visible = EsVisibleSegunEstado(.ID, idEstado)
                    .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
                End With
            Next
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvSeriales_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvSeriales.CustomCallback
        Try
            Dim idUsuario As Integer
            Integer.TryParse(Session("usxp001"), idUsuario)
            Dim arrParametro() As String = e.Parameters.Split("|")
            Select Case arrParametro(0)
                Case "consulta"
                    Dim objRutas As New GenerarCreacionRutas()
                    With objRutas
                        .IdServicioMensajeria = CInt(arrParametro(1))
                    End With

                    With gvSeriales
                        .DataSource = objRutas.GenerarPoolRecoleccionServicioSiembra()
                        Session("gvSeriales") = .DataSource
                        .DataBind()
                    End With

                Case "cambioEstado"
                    Dim arrValores() As String = arrParametro(1).Split(",")
                    Dim objDetalleSerial As New DetalleSerialServicioMensajeria(idDetalle:=arrValores(0))
                    With objDetalleSerial
                        .IdEstadoDevolucion = CInt(arrValores(1))
                        .Actualizar(idUsuario)
                    End With

                Case "cambioFechaDevolucion"
                    Dim arrValores() As String = arrParametro(1).Split(",")
                    Dim objMin As New DetalleMsisdnEnServicioMensajeria(idServicio:=arrValores(0), msisdn:=arrValores(1))
                    With objMin
                        .FechaDevolucion = Date.ParseExact(arrValores(2), "yyyyMMdd", System.Globalization.DateTimeFormatInfo.InvariantInfo) 'arrValores(2)
                        .Modificar()
                    End With
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al tratar de visualizar seriales: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub cmbEstadoDevolucion_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idDetalle As Integer
        Dim objDetalleSerial As DetalleSerialServicioMensajeria
        Try
            Dim cmbEstadoDevolucion As ASPxComboBox = CType(sender, ASPxComboBox)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(cmbEstadoDevolucion.NamingContainer, GridViewDataItemTemplateContainer)

            idDetalle = CInt(gvSeriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "idDetalle"))

            MetodosComunes.CargarComboDX(cmbEstadoDevolucion, Session("dtEstadoDevolucion"), "idEstado", "nombre")
            cmbEstadoDevolucion.ClientSideEvents.SelectedIndexChanged = cmbEstadoDevolucion.ClientSideEvents.SelectedIndexChanged.Replace("{0}", templateContainer.KeyValue)

            objDetalleSerial = New DetalleSerialServicioMensajeria(idDetalle:=idDetalle)
            If objDetalleSerial.IdEstadoDevolucion > 0 Then
                cmbEstadoDevolucion.Value = objDetalleSerial.IdEstadoDevolucion.ToString()
            Else
                cmbEstadoDevolucion.Value = Enumerados.EstadoDevolucionSerial.Conforme
            End If
        Catch ex As Exception
            miEncabezado.showError("No fué posible cargar estados de devolución: " & ex.Message)
        End Try
    End Sub

    Protected Sub dateFechaDevolucion_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idDetalle As Integer
        Dim fechaDevolucion As Date
        Dim idServicioTipo As Integer
        Dim idServicioMensajeria As Integer
        Dim msisdn As String
        Try
            Dim dateFechaDevolucion As ASPxDateEdit = CType(sender, ASPxDateEdit)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(dateFechaDevolucion.NamingContainer, GridViewDataItemTemplateContainer)

            idDetalle = CInt(gvSeriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "idDetalle"))
            fechaDevolucion = CDate(gvSeriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "fechaDevolucion"))
            msisdn = gvSeriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "msisdn")
            idServicioTipo = gvSeriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "idServicioTipo")
            idServicioMensajeria = gvSeriales.GetRowValuesByKeyValue(templateContainer.KeyValue, "idServicioMensajeria")

            With dateFechaDevolucion
                .MinDate = Date.Now
                .MaxDate = DateAdd(DateInterval.Year, 1, Date.Now)
                .Date = fechaDevolucion
            End With

            dateFechaDevolucion.ClientSideEvents.DateChanged = dateFechaDevolucion.ClientSideEvents.DateChanged.Replace("{0}", idServicioMensajeria)
            dateFechaDevolucion.ClientSideEvents.DateChanged = dateFechaDevolucion.ClientSideEvents.DateChanged.Replace("{1}", msisdn)
        Catch ex As Exception
            miEncabezado.showError("No fué posible cargar fechas de devolución: " & ex.Message)
        End Try
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(ByVal source As Object, ByVal e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("objServiciosSiembra") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                If Not String.IsNullOrEmpty(formato) Then
                    With gveServicios
                        .FileName = "Reporte_Servicios_SIEMBRA_" + Now.Year.ToString() + Now.Month.ToString() + Now.Day.ToString()
                        .ReportHeader = "Reporte de Servicios SIEMBRA" & vbCrLf
                        .ReportFooter = "Logytech Mobile S.A.S"
                        .Landscape = False
                        With .Styles.Default.Font
                            .Name = "Arial"
                            .Size = FontUnit.Point(10)
                        End With
                        .DataBind()
                    End With
                    Select Case formato
                        Case "xls"
                            gveServicios.WriteXlsToResponse()
                        Case "pdf"
                            With gveServicios
                                .Landscape = True
                                .WritePdfToResponse()
                            End With
                        Case "xlsx"
                            gveServicios.WriteXlsxToResponse()
                        Case "csv"
                            gveServicios.WriteCsvToResponse()
                        Case Else
                            Throw New ArgumentNullException("Archivo no valido")
                    End Select
                End If
            Else
                miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al exportar los datos: " & ex.Message)
        End Try
    End Sub

    Private Sub cmbCoordinador_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbCoordinador.Callback
        Try
            Dim dvPersonal As DataView = PersonasGerencia.DefaultView
            Dim dvPersonalconsultor As DataView = PersonasGerencia.DefaultView
            dvPersonal.RowFilter = "personaPadre IS NOT NULL AND idperfil= 142 AND idGerencia = " & e.Parameter
            dvPersonalconsultor.RowFilter = "personaPadre IS NOT NULL AND idperfil= 140 AND idGerencia = " & e.Parameter
            CargarCoordinador(dvPersonal.ToTable(True, "idPersonaPadre", "personaPadre"))
            CargarConsultor(dvPersonalconsultor.ToTable(True, "idPersona", "persona"))
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub cmbConsultor_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbConsultor.Callback
        Try
            Dim dvPersonal As DataView = PersonasGerencia.DefaultView
            dvPersonal.RowFilter = "idperfil= 140 AND idPersonaPadre = " & e.Parameter

            CargarConsultor(dvPersonal.ToTable(True, "idPersona", "persona"))
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub gvMateriales_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvMateriales.CustomCallback
        Try
            Dim objServicioSiembra As New ServicioMensajeriaSiembra(idServicio:=e.Parameters)
            With gvMateriales
                .DataSource = objServicioSiembra.InformacionMSISDNMateriales()
                .DataBind()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Function ObtenerDetalleSerial(detalleSerial As String()) As DataTable
        Dim dtDatos As New DataTable
        Try
            dtDatos.Columns.Add(New DataColumn("idDetalleSerial", GetType(Integer)))
            For i As Integer = 0 To detalleSerial.Length - 1
                Dim rowSerial As DataRow = dtDatos.NewRow()
                rowSerial("idDetalleSerial") = detalleSerial(i)
                dtDatos.Rows.Add(rowSerial)

                If Not dtDatos.Columns.Contains("idServicio") Then
                    Dim objDetalle As New DetalleSerialServicioMensajeria(CInt(detalleSerial(i)))
                    dtDatos.Columns.Add(New DataColumn("idServicio", GetType(Integer), objDetalle.IdServicio))
                End If
            Next
            dtDatos.AcceptChanges()
        Catch ex As Exception
            Throw ex
        End Try
        Return dtDatos
    End Function

#End Region

#Region "Propiedades"

    Public Property PersonasGerencia As DataTable
        Get
            If _PersonasGerencia Is Nothing Then PersonalEnGerencia()
            Return _PersonasGerencia
        End Get
        Set(value As DataTable)
            _PersonasGerencia = value
        End Set
    End Property

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Carga de estados
            Dim dtEstado As New DataTable

            dtEstado = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional("ddlEstado")
            If dtEstado Is Nothing OrElse dtEstado.Rows.Count = 0 Then dtEstado = HerramientasMensajeria.ConsultarEstado

            With cmbEstado
                .DataSource = dtEstado
                .TextField = "nombre"
                .ValueField = "idEstado"
                .DataBind()
            End With


            'Gerencias y Ejecutivos
            Dim objGerencias As New GerenciaClienteColeccion()
            With objGerencias
                .Activo = True
                .CargarDatos()
            End With

            With cmbGerencia
                .DataSource = objGerencias
                .ValueField = "IdGerencia"
                .TextField = "Nombre"
                .DataBind()
            End With

            Dim dvPersonasGerencia As DataView = PersonasGerencia.DefaultView
            Dim dvPersonasConsultor As DataView = PersonasGerencia.DefaultView
            dvPersonasGerencia.RowFilter = "personaPadre IS NOT NULL AND idperfil= 142"
            dvPersonasGerencia.Sort = "persona DESC"
            dvPersonasConsultor.Sort = "personaPadre DESC"
            dvPersonasConsultor.RowFilter = "personaPadre IS NOT NULL AND idperfil= 140"
            CargarCoordinador(dvPersonasGerencia.ToTable(True, "idPersonaPadre", "personaPadre"))
            CargarConsultor(dvPersonasConsultor.ToTable())

            'Estados de Devolución
            Session("dtEstadoDevolucion") = HerramientasMensajeria.ConsultarEstado(Enumerados.Entidad.EstadoDevoluciónSiembra)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Sub PersonalEnGerencia()
        Try
            _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
            Session("dtPersonasGerencia") = _PersonasGerencia
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub CargarCoordinador(dtDatos As DataTable)
        With cmbCoordinador
            .DataSource = dtDatos
            .ValueField = "idPersonaPadre"
            .TextField = "personaPadre"
            .DataBind()
        End With
    End Sub

    Private Sub CargarConsultor(dtDatos As DataTable)
        With cmbConsultor
            .DataSource = dtDatos
            .ValueField = "idPersona"
            .TextField = "persona"
            .DataBind()
        End With
    End Sub

    Private Sub CargarPermisosOpcionesRestringidas()
        Try
            Dim dtPermisos As DataTable = HerramientasMensajeria.ObtenerInfoPermisosOpcionesRestringidas()
            Session("dtInfoPermisosOpcRestringidas") = dtPermisos
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar información de permisos sobre opciones restringidas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarRestriccionesDeOpcionPorEstados()
        Try
            Dim dtRestriccion As DataTable = HerramientasMensajeria.ObtenerInfoRestriccionEstadoOpcionFuncional()
            Session("dtInfoRestriccionOpcEstado") = dtRestriccion
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar restricciones de opciones por estados. " & ex.Message)
        End Try
    End Sub

#End Region

    Protected Sub gvSeriales_DataBinding(sender As Object, e As EventArgs) Handles gvSeriales.DataBinding
        If gvSeriales.DataSource Is Nothing Then
            If Not Session("gvSeriales") Is Nothing Then
                gvSeriales.DataSource = Session("gvSeriales")
            End If
        End If
        
    End Sub

End Class
