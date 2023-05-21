Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.Inventario
Imports System.Collections.Generic
Imports System.Text
Imports ILSBusinessLayer.Productos
Imports System.Linq
Imports System.Web.Services
Imports System.IO
Imports GemBox.Spreadsheet
Public Class RegistrarServicioTipoSiembraNew
    Inherits System.Web.UI.Page

#Region "Atributos"

    Dim dtInformacionGeneral As New DataTable()
    Dim dtDetalleMines As New DataTable()
    Private _PersonasGerencia As DataTable
    Private _nombreArchivo As String
    Private objMines As CargueArchivoMinesSiembra
    Private Shared infoEstados As InfoEstadoRestriccionCEM
    Private oExcel As ExcelFile
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
    Property Ciudades As DataTable


#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not (Page.IsCallback) Then
            Seguridad.verificarSession(Me)
        End If

#If DEBUG Then
        Session("usxp001") = 33533
        Session("usxp009") = 140
        Session("usxp007") = 150
#End If

        Session("datos") = True



        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Registro Servicio SIEMBRA")
            End With

            CargaInicial()
            LimpiarFormulario()
            MetodosComunes.setGemBoxLicense()
            Cargarregistro()
        Else
            If Session("dtPersonasGerencia") IsNot Nothing Then _PersonasGerencia = Session("dtPersonasGerencia")
            If Session("dtCiudades") IsNot Nothing Then _Ciudades = Session("dtCiudades")

        End If

        If cmbEquipo.IsCallback Then cmbEquipo.DataBind()
        If cmbCiudadEntrega.IsCallback Then cmbCiudadEntrega.DataBind()
    End Sub
    <WebMethod()> _
    Public Shared Function KeepActiveSession() As Boolean

        If HttpContext.Current.Session("datos") IsNot Nothing Then
            Return True
        Else
            Return False
        End If

    End Function
    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        Dim resultado As ResultadoProceso
        Try
            revArchivo.IsValid = True
            rfvArchivo.IsValid = True
            Dim arrParametros() As String = e.Parameter.Split("|")

            Select Case arrParametros(0)
                Case "registrar"
                    Dim objServicioSiembra As New CargueArchivoMinesSiembra()
                    With objServicioSiembra
                        ._idUsuario = CInt(Session("usxp001"))
                        ._idciudad = cmbCiudadEntrega.Value
                        ._NombreEmpresa = txtNombreEmpresa.Text
                        ._NIT = txtIdentificacionCliente.Text
                        ._TelefonoFijoEmpresa = txtTelefonoFijo.Text
                        ._Ext = txtExtTelefonoFijo.Text
                        ._NombreRepresentanteLegal = txtNombreRepresentante.Text
                        ._TelefonoCelularRepresentante = txtTelefonoMovilRepresentante.Text
                        ._NumeroCedulaRepresentante = txtIdentificacionRepresentante.Text
                        ._NombrepersonaAutorizada = txtPersonaAutorizada.Text
                        ._NumeroCedulaAutorizado = txtIdentificacionAutorizado.Text
                        ._CargoPersonaAutorizada = txtCargoPersonaAutorizada.Text
                        ._TelefonoPersonaAutorizada = txtTelefonoAutorizado.Text
                        ._Direccion = textDireccion.Text
                        ._Observacion = memoObservaciones.Text
                        ._Barrio = txtBarrio.Text
                        .IdGerencia = cmbGerencia.Value
                        .IdCoordinador = cmbCoordinador.Value
                        .IdConsultor = cmbConsultor.Value
                        ._ClienteClaro = rblClienteClaro.Value
                        If (gvCombinacionEquipos.VisibleRowCount > 0) Then
                            .RegistrarServicioSiembra()
                        Else
                            resultado.EstablecerMensajeYValor(1, "No se han registrado equipos para la solicitud en cuestión")
                        End If

                        If ._EstadoValidacion = 1 Then
                            miEncabezado.showSuccess("Servicio registrado satisfactoriamente con el identificador: [" & .IdServicioMensajeria & "]")
                            revArchivo.IsValid = True
                            rfvArchivo.IsValid = True
                            LimpiarFormulario()
                            limpiarFormulariobd()
                        Else
                            Dim dt = ._estructuraTablaErrores
                            If dt.Rows.Count > 0 Then
                                rpLogErrores.Visible = True
                                With gvErrores
                                    .DataSource = dt
                                    .DataBind()
                                End With
                            End If
                        End If
                    End With

                Case "editarEquipo"
                    CargarDatosMin(arrParametros(1))
                Case "limpiarFormulario"
                    revArchivo.IsValid = True
                    rfvArchivo.IsValid = True
                    LimpiarFormulario()
                    limpiarFormulariobd()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar registrar el servicio: " + ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvCombinacionEquipos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvCombinacionEquipos.CustomCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrParametros() As String = e.Parameters.Split("|")
            Select Case arrParametros(0)
                Case "registrar"
                    resultado = AdicionarEquipo()

                Case "eliminar"
                    resultado = EliminarEquipo(arrParametros(1))

                Case "actualizar"
                    resultado = ActualizarEquipo()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

            If resultado.Valor <> 0 Then
                miEncabezado.showWarning(resultado.Mensaje)
            Else
                miEncabezado.showSuccess(resultado.Mensaje)
                CType(sender, ASPxGridView).JSProperties("cpMensajeEquipoError") = 0
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error procesando equipos: " + ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub btnExportar_Click(sender As Object, e As EventArgs) Handles btnExportar.Click
        gveExportador.WriteXlsxToResponse("ErroresCargueRadicadosSiembra")
    End Sub
    Protected Sub GvErroresDataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        If gvErrores.DataSource Is Nothing AndAlso Session("dtError") IsNot Nothing Then gvErrores.DataSource = CType(Session("dtError"), DataTable)
    End Sub
    Protected Sub gvCombinacionEquipos_DataBinding(sender As Object, e As EventArgs) Handles gvCombinacionEquipos.DataBinding
        If gvCombinacionEquipos.DataSource Is Nothing AndAlso Session("dtmsisdn") IsNot Nothing Then gvCombinacionEquipos.DataSource = CType(Session("dtmsisdn"), DataTable)
    End Sub

    Protected Sub Link_InitEquipo(ByVal sender As Object, ByVal e As EventArgs)
        Dim msisdn As String
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            msisdn = CStr(gvCombinacionEquipos.GetRowValuesByKeyValue(templateContainer.KeyValue, "_msisdn"))

            'Link de Eliminación
            With lnkEliminar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With

            'Link Edicón el picking
            Dim linkEdicion As ASPxHyperLink = templateContainer.FindControl("lnkEditar")
            With linkEdicion
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", msisdn)
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades de Equipos: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_InitSim(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            Dim arrKey() As String = templateContainer.KeyValue.ToString().Split("|")

            'Link de Eliminación
            With lnkEliminar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", arrKey(0))
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{1}", arrKey(1))
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades de Sims: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_InitMsisdn(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            'Link de Eliminación
            With lnkEliminar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades de Mins: " & ex.Message)
        End Try
    End Sub

    Private Sub cmbClaseSim_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cmbClaseSim.Callback

        If e.Parameter = "CargarTodas" Then
            CargarTodosLosTiposDeSim()
        Else
            If Not String.IsNullOrEmpty(e.Parameter) Then EstablecerTipoSim(e.Parameter)
        End If
        CType(sender, ASPxComboBox).JSProperties("cpTipoSeleccionado") = cmbClaseSim.Value
        CType(sender, ASPxComboBox).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub cbCiudad_OnItemsRequestedByFilterCondition_SQL(source As Object, e As ListEditItemsRequestedByFilterConditionEventArgs)
        Dim dtmateriales As New DataTable
        Dim objMaterialesSiembra As New MaterialSiembraColeccion()
        dtmateriales = objMaterialesSiembra.CargarMaterialesCombo(e.Filter, e.BeginIndex + 1, e.EndIndex + 1)
        Session("dtmaterialesSiembra") = dtmateriales
        With cmbEquipo
            .DataSource = dtmateriales
            .DataBind()
        End With

        With cmbEquipo
            lblResultadoMaterial.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedIndex = -1
            End If
        End With

    End Sub
    Protected Sub cbCiudad_OnItemRequestedByValue_SQL(source As Object, e As ListEditItemRequestedByValueEventArgs)
        If e.Value = Nothing Then
            Return
        End If
        If Session("dtmaterialesSiembra") IsNot Nothing Then
            Dim data As DataTable = Session("dtmaterialesSiembra")

            Dim query = From r In data Where r.Field(Of String)("Material") = e.Value Select r

            'Dim tdata As DataTable = DirectCast(query, System.Data.EnumerableRowCollection(Of System.Data.DataRow)).CopyToDataTable
            Dim tdata As DataTable = CopyToDataTableOverride(query)
            If tdata.Rows.Count = 0 Then
                Return
            ElseIf tdata.Rows.Count > 1 Then
                With cmbEquipo
                    .DataSource = tdata
                    .DataBind()
                End With
            Else
                With cmbEquipo
                    .DataSource = tdata
                    .DataBind()
                End With

            End If

        End If
        With cmbEquipo
            lblResultadoMaterial.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedIndex = -1
            End If
        End With

    End Sub
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Try
            revArchivo.IsValid = True
            rfvArchivo.IsValid = True
            Dim ext As String = ".ttt"
            ext = System.IO.Path.GetExtension(fuArchivo.PostedFile.FileName)
            If (ext <> "") Then
                ext = ext.ToUpper()
            End If
             Dim Numerohojas As Integer
            If Not Session("dtError") Is Nothing Then
                Session.Remove("dtError")
            End If
            rpLogErrores.Visible = False
            With gvErrores
                .DataSource = Session("dtError")
                .DataBind()
            End With
            Dim idUsuario = CInt(Session("usxp001"))
            Dim numeroFials As Integer
            Dim numColumnas As Integer
            Dim isValidFile As Boolean = False
                AspTexMensajeArchivo.ForeColor = System.Drawing.Color.Green
                AspTexMensajeArchivo.Text = "El archivo ha subido correctamente."
                Dim validacionArchivo As New ResultadoProceso
                If fuArchivo.PostedFile.ContentLength <= 10485760 Then
                    If fuArchivo.PostedFile.FileName <> "" Then
                        Dim fecha As DateTime = DateTime.Now
                        Dim fec As String = fecha.ToString("HH:mm:ss:fff").Replace(":", "_")
                    Dim ruta As String = "\\Colbogsacde001\Portales\ArchivosTemporale\"
                        Dim nombreArchivo As String = "CargueMasivo_" & fec & "-" & Session("usxp001") & Path.GetExtension(fuArchivo.PostedFile.FileName)
                        _nombreArchivo = nombreArchivo
                        ruta += nombreArchivo
                        fuArchivo.SaveAs(ruta)
                        Dim miWs As ExcelWorksheet
                        Dim miExcel As New ExcelFile
                        Try
                            Select Case ext
                                Case ".XLS"
                                    miExcel.LoadXls(ruta)
                                Case ".XLSX"
                                    miExcel.LoadXlsx(ruta, XlsxOptions.None)
                                Exit Select
                            Case Else
                                Throw New ArgumentNullException("Archivo no valido")
                        End Select
                        Catch ex As Exception
                            Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)
                        End Try

                        Numerohojas = miExcel.Worksheets.Count
                    If miExcel.Worksheets.Count >= 2 Then
                        Dim oWsInfogenera As ExcelWorksheet = miExcel.Worksheets.Item(0)
                        Dim resultado As Integer = -1
                        Dim oWsDetalleMines As ExcelWorksheet = miExcel.Worksheets.Item(1)
                        dtInformacionGeneral = CrearEstructuraInfoGeneral()
                        dtDetalleMines = CrearEstructuraMines()
                        numColumnas = oWsInfogenera.CalculateMaxUsedColumns()
                        numeroFials = oWsInfogenera.Rows.Count
                        If numColumnas = 17 Then ' se valida el numero de columnas de Información General
                            If numeroFials = 2 Then  ' se valida el numero de filas de Información General
                                numColumnas = oWsDetalleMines.CalculateMaxUsedColumns()
                                numeroFials = oWsDetalleMines.Rows.Count
                                Dim filaInicial As Integer = 0
                                Dim columnaInicial As Integer = 0
                                If numColumnas = 7 Then ' se valida el numero de columnas de Detalle de Mines
                                    If numeroFials > 1 Then ' se valida el numero de filas de Detalle de Mines
                                        Try
                                            filaInicial = oWsInfogenera.Cells.FirstRowIndex
                                            columnaInicial = oWsInfogenera.Cells.FirstColumnIndex
                                            AddHandler oWsInfogenera.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                                            oWsInfogenera.ExtractToDataTable(dtInformacionGeneral, oWsInfogenera.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                                                   oWsInfogenera.Rows(filaInicial + 1), oWsInfogenera.Columns(columnaInicial))

                                        Catch ex As Exception
                                            miEncabezado.showError("Se genero un error al leer la infomacion de la hoja Información General  " & ex.Message & "<br><br>")
                                            Throw New Exception("Se genero un error al leer la infomacion de la hoja Información General  " & ex.Message)
                                            Exit Sub
                                        End Try
                                        Try
                                            filaInicial = oWsDetalleMines.Cells.FirstRowIndex
                                            columnaInicial = oWsDetalleMines.Cells.FirstColumnIndex
                                            AddHandler oWsDetalleMines.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                                            oWsDetalleMines.ExtractToDataTable(dtDetalleMines, oWsDetalleMines.Rows.Count, ExtractDataOptions.SkipEmptyRows, _
                                                                   oWsDetalleMines.Rows(filaInicial + 1), oWsDetalleMines.Columns(columnaInicial))
                                        Catch ex As Exception
                                            miEncabezado.showError("Se genero un error al leer la infomacion de la hoja Detalle de Mines  " & ex.Message & "<br><br>")
                                            Throw New Exception("Se genero un error al leer la infomacion de la hoja Detalle de Mines  " & ex.Message)
                                            Exit Sub
                                        End Try
                                        Try
                                            ValidarDetalleMines(dtDetalleMines)
                                            ValidarInformacionGeneral(dtInformacionGeneral)
                                        Catch ex As Exception
                                            miEncabezado.showError("Se genero un error al ralizar la validacion del archivo:" & ex.Message & "<br><br>")
                                            Throw New Exception("Se genero un error al ralizar la validacion del archivo: " & ex.Message)
                                            Exit Sub
                                        End Try
                                        If Not Session("dtError") Is Nothing Then

                                            rpLogErrores.Visible = True
                                            With gvErrores
                                                .DataSource = CType(Session("dtError"), DataTable)
                                                .DataBind()
                                            End With
                                            rpLogErrores.Visible = True
                                        Else
                                            Dim cargeradicado As New CargueArchivoMinesSiembra()
                                            With cargeradicado
                                                ._idUsuario = idUsuario
                                                .CargarRadicado(dtDetalleMines, dtInformacionGeneral, idUsuario, resultado)
                                                Session("dtError") = ._estructuraTablaErrores
                                                If (._EstadoValidacion = 1) Then
                                                    btnGuardar.ClientEnabled = True
                                                    Cargarregistro()
                                                Else
                                                    rpLogErrores.Visible = True
                                                    With gvErrores
                                                        .DataSource = CType(Session("dtError"), DataTable)
                                                        .DataBind()
                                                    End With
                                                    Cargarregistro()
                                                End If
                                            End With


                                        End If

                                    Else
                                        RegError(0, "No se puede procesar, ya que la hoja contiene menos Registos que las esperado: " & numeroFials & " Registros permitidos minimo 2", "Detalle de Mines", "0")
                                    End If

                                ElseIf numColumnas > 7 Then
                                    RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Detalle de Mines", "0")
                                Else
                                    RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Detalle de Mines", "0")
                                End If

                            ElseIf numeroFials > 2 Then
                                RegError(0, "No se puede procesar, ya que la hoja contiene más Registros de los permitidos: " & numeroFials & "; registros permitidos 2", "Información General", "0")
                            Else
                                RegError(0, "No se puede procesar, ya que la hoja contiene menos Registos que las esperado: " & numeroFials & "; Registros permitidos 2", "Información General", "0")
                            End If

                        ElseIf numColumnas > 16 Then
                            RegError(0, "No se puede procesar, ya que la hoja contiene más columnas que las esperadas. Por favor verifique", "Información General", "0")
                        Else
                            RegError(0, "No se puede procesar, ya que la hoja contiene menos columnas que las esperadas. Por favor verifique", "Información General", "0")
                        End If


                    ElseIf Numerohojas > 3 Then
                        RegError(0, "No se puede procesar el archivo, ya que contiene más Hojas que las esperadas. Por favor verifique", "numero de hojas: " & Numerohojas, "0")
                    Else
                        RegError(0, "No se puede procesar el archivo, ya que contiene menos Hojas que las esperadas. Por favor verifique", "numero de hojas: " & Numerohojas, "0")
                    End If

                        If Not Session("dtError") Is Nothing Then
                            Dim dt As DataTable = CType(Session("dtError"), DataTable)
                            If dt.Rows.Count > 0 Then
                                rpLogErrores.Visible = True
                                With gvErrores
                                    .DataSource = CType(Session("dtError"), DataTable)
                                    .DataBind()
                                End With

                            End If
                        End If
                    Else
                        miEncabezado.showError("Debe seleccionar un archivo")
                    End If
                Else
                    miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB. El Archivo Actual pesa: " & fuArchivo.PostedFile.ContentLength)
                End If

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al Procesar el archivo: " & ex.Message & "<br><br>")
        End Try
    End Sub
    Private Sub cmbEquipo_DataBound(sender As Object, e As EventArgs) Handles cmbEquipo.DataBound
        If cmbEquipo.DataSource Is Nothing AndAlso Session("dtmaterialesSiembra") IsNot Nothing Then cmbEquipo.DataSource = CType(Session("dtmaterialesSiembra"), DataTable)
    End Sub

    Protected Sub cmbCiudadEntrega_DataBinding(sender As Object, e As EventArgs) Handles cmbCiudadEntrega.DataBinding
        If cmbCiudadEntrega.DataSource Is Nothing AndAlso Session("dtCiudades") IsNot Nothing Then
            cmbCiudadEntrega.DataSource = CType(Session("dtCiudades"), DataTable)
            cmbCiudadEntrega.SelectedItem = cmbCiudadEntrega.Items.FindByValue(CStr(Session("usxp007")))
        End If


    End Sub
    Protected Sub ButtonVerEjemplo_Click(sender As Object, e As EventArgs) Handles ButtonVerEjemplo.Click
        Try
            Dim filename As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaRegistroSiembraPorArchivo.xlsx")
            If filename <> "" Then
                Dim file As System.IO.FileInfo = New System.IO.FileInfo(filename)
                If file.Exists Then
                    Response.Clear()
                    Response.AddHeader("Content-Disposition", "attachment; filename=" & file.Name)
                    Response.AddHeader("Content-Length", file.Length.ToString())
                    Response.ContentType = "application/octet-stream"
                    Response.WriteFile(file.FullName)
                    Response.End()

                Else
                    Response.Write("Este archivo no existe.")

                End If

            End If
            Response.Redirect(filename, False)

        Catch ex As Exception
            miEncabezado.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub cargarCiudades()
        'Se cargan las Ciudades
        Dim dtCiudad As DataTable = HerramientasMensajeria.ObtenerCiudadesCem(idCiudadPadre:=CInt(Session("usxp007")))
        With cmbCiudadEntrega
            .DataSource = dtCiudad
            Session("dtCiudades") = .DataSource
            .DataBind()
            If dtCiudad.Rows.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedItem = cmbCiudadEntrega.Items.FindByValue(CStr(Session("usxp007")))
            End If
        End With
    End Sub

    Private Sub CargaInicial()
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            'Fecha de Registro
            With dateFechaSolicitud
                .Date = Now.Date
                .ClientEnabled = False
            End With

            cargarCiudades()
            'Gerencias y Ejecutivos
            Dim dvPersonasGerencia As DataView = PersonasGerencia.DefaultView
            dvPersonasGerencia.RowFilter = "idPersona = " & idUsuario.ToString

            If dvPersonasGerencia.Count > 0 Then
                With cmbGerencia
                    .DataSource = dvPersonasGerencia.ToTable()
                    .ValueField = "idGerencia"
                    .TextField = "gerencia"
                    .SelectedIndex = 0
                    .ClientEnabled = False
                    .DataBind()
                End With

                With cmbCoordinador
                    .DataSource = dvPersonasGerencia.ToTable()
                    .ValueField = "idPersonaPadre"
                    .TextField = "personaPadre"
                    .SelectedIndex = 0
                    .ClientEnabled = False
                    .DataBind()
                End With

                With cmbConsultor
                    .DataSource = dvPersonasGerencia.ToTable()
                    .ValueField = "idPersona"
                    .TextField = "persona"
                    .SelectedIndex = 0
                    .ClientEnabled = False
                    .DataBind()
                End With
                btnUpload.ClientEnabled = True
            Else
                btnUpload.ClientEnabled = False
                miEncabezado.showWarning("El usuario actual no se encuentra configurado en la Jerarquía de Personal SIEMBRA, por favor contacte al administrador.")
            End If

            'Clase SIM
            Session("dtClaseSim") = HerramientasMensajeria.ObtieneClasesSIM()


            'Fecha devolución Equipo
            With dateFechaDevolucionEquipo
                .MinDate = Now.Date.AddDays(1)
            End With


            'Plan MSISDN
            Dim objPlanes As New PlanVentaColeccion(activo:=True)
            With cmbPlan
                .DataSource = objPlanes
                .TextField = "NombrePlan"
                .ValueField = "IdPlan"
                .DataBind()
            End With

            'Paquete MSISDN
            Dim objPaquetes As New PaqueteVentaColeccion(activo:=True)
            With cmbPaquete
                .DataSource = objPaquetes
                .TextField = "Nombre"
                .ValueField = "IdPaquete"
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de realizar la carga inicial de datos: " & ex.Message)
        End Try
    End Sub
    Private Sub PersonalEnGerencia()
        _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
        Session("dtPersonasGerencia") = _PersonasGerencia
    End Sub

    Private Function AdicionarEquipo() As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        Try
            Dim objCargueMines As New MsisdnEnServicioSiembraColeccion()
            With objCargueMines
                ._idUsuario = CInt(Session("usxp001"))
                ._tipo = rblTipo.Value
                ._msisdn = txtMsisdn.Value
                If cmbPlan.Value IsNot Nothing AndAlso cmbPlan.Value <> 0 Then
                    ._idPlan = cmbPlan.Value
                    ._nombrePlan = cmbPlan.Text
                End If
                If cmbPaquete.Value IsNot Nothing AndAlso cmbPaquete.Value <> 0 Then
                    ._idPaquete = cmbPaquete.Value
                    ._Paquete = cmbPaquete.Text
                End If
                ._fechaDevolucion = dateFechaDevolucionEquipo.Date
                ._material = cmbEquipo.Value
                ._Descripcionmaterial = cmbEquipo.Text
                If cmbClaseSim.Value IsNot Nothing AndAlso cmbClaseSim.Value <> 0 Then 'And cmbRegion.Value IsNot Nothing  
                    ._idTipoSim = cmbClaseSim.Value
                    ._tipoSim = cmbClaseSim.Text
                End If
                .AdicionarMsisdn()
                If ._resultado = 1 Then
                    respuesta.EstablecerMensajeYValor(0, "El MSISDN [" + txtMsisdn.Value + "] fue adicionado correctamente.")
                    CargarEquipos()

                Else
                    respuesta.EstablecerMensajeYValor(1, "El MSISDN [" + txtMsisdn.Value + "] ya se encuentra seleccionado, por favor verifique e intente nuevamente.")
                End If

            End With
        Catch ex As Exception
            respuesta.EstablecerMensajeYValor(2, "Se generó un error inesperado: " & ex.Message)
        End Try
        Return respuesta
    End Function

    Private Function ActualizarEquipo() As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        Try
            Dim objCargueMines As New MsisdnEnServicioSiembraColeccion()
            With objCargueMines
                ._idUsuario = CInt(Session("usxp001"))
                ._idRegistro = Session("idRegistro")
                ._tipo = rblTipo.Value
                ._msisdn = txtMsisdn.Value
                If cmbPlan.Value IsNot Nothing AndAlso cmbPlan.Value <> 0 Then
                    ._idPlan = cmbPlan.Value
                    ._nombrePlan = cmbPlan.Text
                End If
                If cmbPaquete.Value IsNot Nothing AndAlso cmbPaquete.Value <> 0 Then
                    ._idPaquete = cmbPaquete.Value
                    ._Paquete = cmbPaquete.Text
                End If
                ._fechaDevolucion = dateFechaDevolucionEquipo.Date
                ._material = cmbEquipo.Value
                ._Descripcionmaterial = cmbEquipo.Text
                If cmbClaseSim.Value IsNot Nothing AndAlso cmbClaseSim.Value <> 0 Then 'And cmbRegion.Value IsNot Nothing  
                    ._idTipoSim = cmbClaseSim.Value
                    ._tipoSim = cmbClaseSim.Text
                End If
                .EditarMsisdn()
                If (._resultado = 1) Then
                    CargarEquipos()
                    EstablecerBotonesActualizarEquipos(False)
                    respuesta.EstablecerMensajeYValor(0, "El MSISDN [" + txtMsisdn.Value + "] fue actualizado correctamente.")
                    Session.Remove("idRegistro")
                End If

            End With

        Catch ex As Exception
            respuesta.EstablecerMensajeYValor(2, "Se generó un error inesperado: " & ex.Message)
        End Try
        Return respuesta
    End Function

    Private Function EliminarEquipo(ByVal msisdn As String) As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        Try
            Dim objCargueMines As New MsisdnEnServicioSiembraColeccion()
            With objCargueMines
                ._idUsuario = CInt(Session("usxp001"))
                ._msisdn = msisdn
                .EliminarMsisdn()
                If (._resultado = 1) Then
                    respuesta.EstablecerMensajeYValor(0, "Se elimino el MSISDN [" + msisdn + "], ya que no se encuentra registrado.")
                    CargarEquipos()
                End If
            End With
        Catch ex As Exception
            Throw ex
        End Try
        Return respuesta
    End Function

    Private Sub CargarEquipos()

        Dim objMsisdn As New MsisdnEnServicioSiembraColeccion(CInt(Session("usxp001")))
        With gvCombinacionEquipos
            .DataSource = objMsisdn
            .DataBind()
        End With
    End Sub

    Private Sub LimpiarFormulario()
        Try
            Session.Remove("dtEquipos")
            Session.Remove("dtError")
            rpLogErrores.Visible = False
            btnGuardar.ClientEnabled = True
            dateFechaSolicitud.Date = Now.Date
            txtNombreEmpresa.Text = String.Empty
            txtIdentificacionCliente.Text = String.Empty
            txtTelefonoFijo.Text = String.Empty
            txtExtTelefonoFijo.Text = String.Empty
            txtNombreRepresentante.Text = String.Empty
            txtTelefonoMovilRepresentante.Text = String.Empty
            txtIdentificacionRepresentante.Text = String.Empty
            txtPersonaAutorizada.Text = String.Empty
            txtIdentificacionAutorizado.Text = String.Empty
            txtCargoPersonaAutorizada.Text = String.Empty
            txtTelefonoAutorizado.Text = String.Empty
            textDireccion.Text = String.Empty
            txtBarrio.Text = String.Empty
            rblClienteClaro.SelectedIndex = -1
            memoObservaciones.Text = String.Empty

            'Equipos
            cmbEquipo.SelectedIndex = -1
            dateFechaDevolucionEquipo.Date = Nothing

            'Sims
            'cmbRegion.SelectedIndex = -1
            cmbClaseSim.SelectedIndex = -1

            'Msisdn
            txtMsisdn.Text = String.Empty
            cmbPlan.SelectedIndex = -1
            cmbPaquete.SelectedIndex = -1
            rblTipo.Value = Nothing
            txtMsisdn.ClientEnabled = False
            dateFechaDevolucionEquipo.ClientEnabled = False
            btnAdicionarCombinacion.ClientEnabled = False
            CargaInicial()
        Catch ex As Exception
            miEncabezado.showError(ex.Message)

        End Try
    End Sub



    Private Sub EstablecerTipoSim(material As String)
        Dim objMaterialTipoSim As New MaterialEquipoClaseSIMColeccion()
        With objMaterialTipoSim
            .Material = New ArrayList From {material}
            .IdCiuda = cmbCiudadEntrega.Value
            .CargarDatos()
        End With

        If objMaterialTipoSim.Count > 0 Then
            If Session("dtClaseSim") Is Nothing Then Session("dtClaseSim") = HerramientasMensajeria.ObtieneClasesSIM()
            Dim dvAux As DataView = CType(Session("dtClaseSim"), DataTable).DefaultView
            dvAux.RowFilter = "IdClase=" & objMaterialTipoSim(0).IdClase.ToString
            Dim valor1 As String = dvAux.Item(0)(1)
            dvAux.RowFilter = ""
            With cmbClaseSim
                .DataSource = Session("dtClaseSim")
                .ValueField = "idClase"
                .TextField = "nombre"
                .DataBind()
            End With
            Session("nombreRegion") = objMaterialTipoSim(0).nombreRegion.ToString
            Session("idRegion") = objMaterialTipoSim(0).idRegion.ToString
            cmbClaseSim.SelectedIndex = cmbClaseSim.Items.IndexOf(cmbClaseSim.Items.FindByText(valor1))
        Else
            cmbClaseSim.ClientEnabled = True
            miEncabezado.showWarning("No se encontró configuración de tipo de SIM para el material seleccionado. Por favor solicitar al personal administrativo de CEM realizar la configuración correspondiente")
        End If
    End Sub

    Private Sub CargarTodosLosTiposDeSim()
        If Session("dtClaseSim") Is Nothing Then Session("dtClaseSim") = HerramientasMensajeria.ObtieneClasesSIM()
        Dim dtAux As DataTable = CType(Session("dtClaseSim"), DataTable)
        cmbClaseSim.ClientEnabled = True
        With cmbClaseSim
            .DataSource = dtAux
            .ValueField = "idClase"
            .TextField = "nombre"
            .DataBind()
        End With

    End Sub

    Private Sub limpiarFormulariobd()
        Try
            Dim objCargueMines As New MsisdnEnServicioSiembraColeccion()
            With objCargueMines
                ._idUsuario = CInt(Session("usxp001"))
                .EliminarRegistrosTransitorias()
                CargarEquipos()
                rpLogErrores.Visible = False
            End With
        Catch ex As Exception
            Throw ex
        End Try

    End Sub
    Private Sub CargarDatosMin(msisdn As String)
        CargarTodosLosTiposDeSim()
        Dim objCargueMines As New MsisdnEnServicioSiembraColeccion()
        With objCargueMines
            ._idUsuario = CInt(Session("usxp001"))
            ._msisdn = msisdn
            .ConsultarMsisdn()
            ControlarCambioCombinacion(._tipo)
            rblTipo.Value = ._tipo.ToString()
            Session("idRegistro") = ._idRegistro
            txtMsisdn.Text = msisdn
            dateFechaDevolucionEquipo.Date = ._fechaDevolucion
            If ._idPlan > 0 Then
                cmbPlan.Value = ._idPlan
            End If
            If ._idPaquete > 0 Then
                cmbPaquete.Value = ._idPaquete
            End If

            If Not IsDBNull(._material) AndAlso Not String.IsNullOrEmpty(._material) Then
                CargarListadoMateriales(._material)
                cmbEquipo.Value = ._material
            End If
            cmbClaseSim.Value = Convert.ToInt32(._idTipoSim)
        End With
        EstablecerBotonesActualizarEquipos(True)
        miEncabezado.showWarning("Por favor realice la edición de los datos y presione el botón Actualizar.")
    End Sub
    Private Sub EstablecerBotonesActualizarEquipos(habilitar As Boolean)
        btnAdicionarCombinacion.ClientVisible = Not habilitar
        btnEdicionCombinacion.ClientVisible = habilitar
        btnCancelarEdicion.ClientVisible = habilitar
    End Sub

    Private Sub ControlarCambioCombinacion(ByVal tipo As String)
        Select Case tipo
            Case "0" 'Equipo y SIm
                cmbPlan.ClientEnabled = True
                cmbPaquete.ClientEnabled = True
                cmbEquipo.ClientEnabled = True
                cmbClaseSim.ClientEnabled = False
                lblResultadoMaterial.Text = ""
            Case "1" 'Solo Equipo
                cmbPlan.ClientEnabled = False
                cmbPaquete.ClientEnabled = False
                cmbEquipo.ClientEnabled = True
                cmbClaseSim.ClientEnabled = False
                lblResultadoMaterial.Text = ""

            Case "2"
                cmbPlan.ClientEnabled = True
                cmbPaquete.ClientEnabled = True
                cmbEquipo.ClientEnabled = False
                cmbClaseSim.ClientEnabled = True
                lblResultadoMaterial.Text = ""
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub CargarListadoMateriales(filtroRapido As String)
        If Not String.IsNullOrEmpty(filtroRapido.Trim) Then
            Dim objMaterialesSiembra As New MaterialSiembraColeccion(filtroRapido:=filtroRapido)

            With cmbEquipo
                .DataSource = objMaterialesSiembra
                'Session("dtmaterialesSiembra") = .DataSource
                .DataBind()
            End With
        Else
            cmbEquipo.Items.Clear()
        End If

        With cmbEquipo
            lblResultadoMaterial.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedIndex = -1
            End If
        End With
    End Sub
    Public Function CopyToDataTableOverride(Of T As DataRow)(ByVal Source As EnumerableRowCollection(Of T)) As DataTable
        If Source.Count = 0 Then
            Return New DataTable
        Else
            Return DataTableExtensions.CopyToDataTable(Of DataRow)(Source)
        End If

    End Function
    Private Sub RegError(ByVal linea As Integer, ByVal descripcion As String, ByVal hoja As String, Optional ByVal Radicado As String = "")
        Try
            Dim dtError As New DataTable
            If Session("dtError") Is Nothing Then
                dtError.Columns.Add(New DataColumn("lineaArchivo"))
                dtError.Columns.Add(New DataColumn("Hoja"))
                dtError.Columns.Add(New DataColumn("descripcion"))
                dtError.Columns.Add(New DataColumn("Radicado", GetType(String)))
                Session("dtError") = dtError
            Else
                dtError = Session("dtError")
            End If
            Dim dr As DataRow = dtError.NewRow()
            dr("lineaArchivo") = linea
            dr("Hoja") = hoja
            dr("Radicado") = Radicado
            dr("descripcion") = descripcion
            dtError.Rows.Add(dr)
            Session("dtError") = dtError
        Catch ex As Exception
            miEncabezado.showError("Error al registra errores . " & ex.Message & "<br><br>")
        End Try
    End Sub

    Private Sub ExtractDataErrorHandler(ByVal sender As Object, ByVal e As ExtractDataDelegateEventArgs)
        If e.ErrorID = ExtractDataError.WrongType Then
            If e.ExcelValue Is Nothing Then
                e.DataTableValue = DBNull.Value
            Else
                e.DataTableValue = e.ExcelValue.ToString()
            End If
            e.Action = ExtractDataEventAction.Continue
        End If
    End Sub

    Private Function CrearEstructuraInfoGeneral() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("CiudadEntrega", GetType(String))
            dtAux.Columns.Add("Departamento", GetType(String))
            dtAux.Columns.Add("NombreEmpresa", GetType(String))
            dtAux.Columns.Add("NIT", GetType(String))
            dtAux.Columns.Add("TelefonoFijoEmpresa", GetType(String))
            dtAux.Columns.Add("Ext", GetType(String))
            dtAux.Columns.Add("NombreRepresentanteLegal", GetType(String))
            dtAux.Columns.Add("NumeroCedulaRepresentante", GetType(String))
            dtAux.Columns.Add("TelefonoCelularRepresentante", GetType(String))
            dtAux.Columns.Add("NombrepersonaAutorizada", GetType(String))
            dtAux.Columns.Add("NumeroCedulaAutorizado", GetType(String))
            dtAux.Columns.Add("CargoPersonaAutorizada", GetType(String))
            dtAux.Columns.Add("TelefonoPersonaAutorizada", GetType(String))
            dtAux.Columns.Add("Direccion", GetType(String))
            dtAux.Columns.Add("Barrio", GetType(String))
            dtAux.Columns.Add("ClienteClaro", GetType(String))
            dtAux.Columns.Add("OBSERVACIONES", GetType(String))

        End With
        Return dtAux
    End Function
    Private Function CrearEstructuraMines() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            dtAux.Columns.Add("MSISDN", GetType(String))
            dtAux.Columns.Add("tipo", GetType(String))
            dtAux.Columns.Add("FechaDevolucion", GetType(String))
            dtAux.Columns.Add("Plan", GetType(String))
            dtAux.Columns.Add("Paquete", GetType(String))
            dtAux.Columns.Add("Equipo", GetType(String))
            dtAux.Columns.Add("TipoSIM", GetType(String))

        End With
        Return dtAux
    End Function

    Private Sub ValidarInformacionGeneral(ByVal informacionGeneral As DataTable)
        Dim fila As Integer = 1
        Try
            Dim Exp As New Comunes.ConfigValues("EXPREG_CARGUERADICADOSSIEMBRA")
            If (Exp.ConfigKeyValue Is Nothing) Then
                miEncabezado.showError("Por favor póngase en contacto con el área IT Development ya que hace falta el parámetro de configuración de la expresión regular <br><br>")
                RegError(0, "Por favor póngase en contacto con el área IT Development ya que hace falta el parámetro de configuración de la expresión regular ", "Información General", "")
                Exit Sub
            Else

                Dim miRegExp As New System.Text.RegularExpressions.Regex(Exp.ConfigKeyValue)
                If (informacionGeneral.Columns.Count <> 17) Then
                    RegError(0, "La hoja (Información General) tiene que tener 16 columnas por favor verificar el archivo", "Información General", "")
                End If
                For Each row As DataRow In informacionGeneral.Rows
                    If (IsDBNull(row("CiudadEntrega"))) Then
                        RegError(fila, "La (CiudadEntrega) tiene valores no valido o esta vacio por favor verificar", "Información General", "")
                    ElseIf (row("CiudadEntrega").ToString().Length > 100) Then
                        RegError(fila, "La (CiudadEntrega) supera el maximo de caracteres permitido (100)", "Información General", row("CiudadEntrega"))
                    ElseIf Not (miRegExp.IsMatch(row("CiudadEntrega").ToString())) Then
                        RegError(fila, "La (CiudadEntrega) tiene caractere no permitidos", "Información General", row("CiudadEntrega"))
                    End If

                    If (IsDBNull(row("Departamento"))) Then
                        RegError(fila, "El (Departamento) tiene valores no valido o esta vacio por favor verificar", "Información General", "")
                    ElseIf (row("NombreEmpresa").ToString().Length > 70) Then
                        RegError(fila, "El (NombreEmpresa) supera el maximo de caracteres permitido (70)", "Información General", row("NombreEmpresa"))
                    ElseIf Not (miRegExp.IsMatch(row("Departamento").ToString())) Then
                        RegError(fila, "El (NombreEmpresa) tiene caracteres no permitidos ", "Información General", row("NombreEmpresa"))
                    End If

                    If (IsDBNull(row("NombreEmpresa"))) Then
                        RegError(fila, "El (NombreEmpresa) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("NombreEmpresa").ToString().Length > 255) Then
                        RegError(fila, "El (NombreEmpresa) supera el maximo de caracteres permitido (255)", "Información General", row("NombreEmpresa"))
                    ElseIf Not (miRegExp.IsMatch(row("NombreEmpresa").ToString())) Then
                        RegError(fila, "El (NombreEmpresa) tiene valores no permintidos ", "Información General", row("NombreEmpresa"))
                    End If

                    If (IsDBNull(row("NIT"))) Then
                        RegError(fila, "El (NIT) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("NIT").ToString().Length > 50) Then
                        RegError(fila, "El (Nit) supera el maximo de caracteres permitido (50)", "Información General", row("NIT"))
                    ElseIf Not (IsNumeric(row("NIT"))) Then
                        RegError(fila, "El (Nit) Tiene que ser un valor numerico", "Información General", row("NIT"))
                    End If

                    If (IsDBNull(row("TelefonoFijoEmpresa"))) Then
                        RegError(fila, "El (TelefonoFijoEmpresa) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("TelefonoFijoEmpresa").ToString().Length > 50) Then
                        RegError(fila, "El (TelefonoFijoEmpresa) supera el maximo de caracteres permitido (50)", "Información General", row("TelefonoFijoEmpresa"))
                    ElseIf Not (IsNumeric(row("TelefonoFijoEmpresa"))) Then
                        RegError(fila, "El (TelefonoFijoEmpresa) Tiene que ser un valor numerico", "Información General", row("TelefonoFijoEmpresa"))
                    End If

                    If (IsDBNull(row("Ext"))) Then
                        RegError(fila, "La (Ext) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("Ext").ToString().Length > 10) Then
                        RegError(fila, "La (Ext) supera el maximo de caracteres permitido (10)", "Información General", row("Ext"))
                    ElseIf Not (IsNumeric(row("TelefonoFijoEmpresa"))) Then
                        RegError(fila, "La (Ext) Tiene que ser un valor numerico", "Información General", row("Ext"))
                    End If

                    If (IsDBNull(row("NombreRepresentanteLegal"))) Then
                        RegError(fila, "La (Nombre Representante Legal) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("NombreRepresentanteLegal").ToString().Length > 255) Then
                        RegError(fila, "el (NombreRepresentanteLegal) supera el maximo de caracteres permitido (255)", "Información General", row("NombreRepresentanteLegal"))
                    ElseIf Not (miRegExp.IsMatch(row("NombreRepresentanteLegal").ToString())) Then
                        RegError(fila, "El Nombre Representante Legal tiene caracteres no permitidos por favor verificar ", "Información General", row("NombreRepresentanteLegal"))
                    End If

                    If (IsDBNull(row("NumeroCedulaRepresentante"))) Then
                        RegError(fila, "El (NumeroCedulaRepresentante) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("NumeroCedulaRepresentante").ToString().Length > 50) Then
                        RegError(fila, "El (NumeroCedulaRepresentante) supera el maximo de caracteres permitido (50)", "Información General", row("NumeroCedulaRepresentante"))
                    ElseIf Not (miRegExp.IsMatch(row("NumeroCedulaRepresentante").ToString())) Then
                        RegError(fila, "El NumeroCedulaRepresentante tiene caracteres no permitidos por favor verificar ", "Información General", row("NumeroCedulaRepresentante"))
                    ElseIf Not (IsNumeric(row("NumeroCedulaRepresentante"))) Then
                        RegError(fila, "El NumeroCedulaRepresentante Tiene que ser un valor numerico", "Información General", row("NumeroCedulaRepresentante"))
                    End If

                    If (IsDBNull(row("TelefonoCelularRepresentante"))) Then
                        RegError(fila, "El (TelefonoCelularRepresentante) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("TelefonoCelularRepresentante").ToString().Length <> 10) Then
                        RegError(fila, "El (TelefonoCelularRepresentante) no cumple con el numero de caracteres permitido (10)", "Información General", row("TelefonoCelularRepresentante"))
                    ElseIf Not (miRegExp.IsMatch(row("TelefonoCelularRepresentante").ToString())) Then
                        RegError(fila, "El TelefonoCelularRepresentante tiene caracteres no permitidos por favor verificar ", "Información General", row("TelefonoCelularRepresentante"))
                    ElseIf Not (IsNumeric(row("TelefonoCelularRepresentante"))) Then
                        RegError(fila, "El TelefonoCelularRepresentante tiene que ser un valor numerico ", "Información General", row("TelefonoCelularRepresentante"))
                    End If

                    If (IsDBNull(row("NombrepersonaAutorizada"))) Then
                        RegError(fila, "El (NombrepersonaAutorizada) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("NombrepersonaAutorizada").ToString().Length > 255) Then
                        RegError(fila, "El (NombrepersonaAutorizada) supera el maximo de caracteres permitido (255)", "Información General", row("NombrepersonaAutorizada"))
                    ElseIf Not (miRegExp.IsMatch(row("NombrepersonaAutorizada").ToString())) Then
                        RegError(fila, "El NombrepersonaAutorizada tiene caracteres no permitidos por favor verificar ", "Información General", row("NombrepersonaAutorizada"))
                    End If

                    If (IsDBNull(row("NumeroCedulaAutorizado"))) Then
                        RegError(fila, "El (NumeroCedulaAutorizado) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("NumeroCedulaAutorizado").ToString().Length > 255) Then
                        RegError(fila, "El (NumeroCedulaAutorizado) supera el maximo de caracteres permitido (255)", "Información General", row("NumeroCedulaAutorizado"))
                    ElseIf Not (miRegExp.IsMatch(row("NumeroCedulaAutorizado").ToString())) Then
                        RegError(fila, "El NumeroCedulaAutorizado tiene caracteres no permitidos por favor verificar ", "Información General", row("NumeroCedulaAutorizado"))
                    ElseIf Not (IsNumeric(row("NumeroCedulaAutorizado"))) Then
                        RegError(fila, "El NumeroCedulaAutorizado tiene que ser un valor numerico ", "Información General", row("NumeroCedulaAutorizado"))
                    End If


                    If (IsDBNull(row("CargoPersonaAutorizada"))) Then
                        RegError(fila, "El (CargoPersonaAutorizada) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("CargoPersonaAutorizada").ToString().Length > 100) Then
                        RegError(fila, "El (CargoPersonaAutorizada) supera el maximo de caracteres permitido (100)", "Información General", row("CargoPersonaAutorizada"))
                    ElseIf Not (miRegExp.IsMatch(row("CargoPersonaAutorizada").ToString())) Then
                        RegError(fila, "El CargoPersonaAutorizada tiene caracteres no permitidos por favor verificar ", "Información General", row("CargoPersonaAutorizada"))
                    End If

                    If (IsDBNull(row("TelefonoPersonaAutorizada"))) Then
                        RegError(fila, "El (TelefonoPersonaAutorizada) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("TelefonoPersonaAutorizada").ToString().Length <> 10) Then
                        RegError(fila, "El (TelefonoPersonaAutorizada) no cumple con el numero de caracteres permitidos (10)", "Información General", row("TelefonoPersonaAutorizada"))
                    ElseIf Not (miRegExp.IsMatch(row("TelefonoPersonaAutorizada").ToString())) Then
                        RegError(fila, "El TelefonoPersonaAutorizada tiene caracteres no permitidos por favor verificar ", "Información General", row("TelefonoPersonaAutorizada"))
                    ElseIf Not (IsNumeric(row("TelefonoPersonaAutorizada"))) Then
                        RegError(fila, "El TelefonoPersonaAutorizada tiene que ser un valor numerico", "Información General", row("TelefonoPersonaAutorizada"))
                    End If


                    If (IsDBNull(row("Direccion"))) Then
                        RegError(fila, "La (Direccion) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("Direccion").ToString().Length > 255) Then
                        RegError(fila, "la (Direccion) supera el maximo de caracteres permitido (255)", "Información General", row("Direccion"))
                    ElseIf Not (miRegExp.IsMatch(row("Direccion").ToString())) Then
                        RegError(fila, "La Direccion tiene caracteres no permitidos por favor verificar ", "Información General", row("Direccion"))
                    End If
                    If (IsDBNull(row("Barrio"))) Then
                        RegError(fila, "El (Barrio) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf (row("Barrio").ToString().Length > 250) Then
                        RegError(fila, "El (Barrio) supera el maximo de caracteres permitido (250)", "Información General", row("Barrio"))
                    ElseIf Not (miRegExp.IsMatch(row("Barrio").ToString())) Then
                        RegError(fila, "El Barrio tiene caracteres no permitidos por favor verificar ", "Información General", row("Barrio"))
                    End If

                    If (IsDBNull(row("ClienteClaro"))) Then
                        RegError(fila, "El (ClienteClaro) tiene valores no valido por favor verificar", "Información General", "")
                    ElseIf Not IsNumeric(row("ClienteClaro")) Then
                        RegError(fila, "El Valor de (ClienteClaro) es un valor no numerico, El valor permitido es (1 o 0)", "Información General", row("ClienteClaro"))
                    ElseIf (CInt(row("ClienteClaro")) <> 1 And CInt(row("ClienteClaro")) <> 0) Then
                        RegError(fila, "El Valor de (ClienteClaro) es un valor no permitido, valores permitidos (1 o 0)", "Información General", row("ClienteClaro"))
                    End If
                    If Not (IsDBNull(row("OBSERVACIONES"))) Then
                        If (row("OBSERVACIONES").ToString().Length > 1024) Then
                            RegError(fila, "la (Observacion) supera el maximo de caracteres permitido (1024)", "Información General", "")
                        ElseIf Not (miRegExp.IsMatch(row("OBSERVACIONES"))) Then
                            RegError(fila, "La OBSERVACIONES tiene caracteres no permitidos por favor verificar ", "Información General", row("OBSERVACIONES"))
                        End If

                    End If
                    fila = fila + 1
                Next
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al validar la Información General. " & ex.Message & "<br><br>")
            Exit Sub
        End Try
    End Sub


    Private Sub ValidarDetalleMines(ByVal detalleMines As DataTable)
        Dim fila As Integer = 1
        Try
            If (detalleMines.Columns.Count <> 7) Then
                RegError(0, "La Hoja (Detalle de Mines) tiene que tener 9 columnas por favor verificar el archivo", "Detalle de Mines", "")
            End If
            For Each row As DataRow In detalleMines.Rows

                If (IsDBNull(row("MSISDN"))) Then
                    RegError(fila, "El (MSISDN) Esta vacio por favor verificar", "Detalle de Mines", "")
                ElseIf (row("MSISDN").ToString().Trim().Length <> 10) Then
                    RegError(fila, "El tamaño del (MSISDN) no es valido debe tener 10 caracteres", "Detalle de Mines", row("MSISDN").ToString())
                ElseIf (row("MSISDN").ToString.Substring(0, 1) <> "3") Then
                    RegError(fila, "El (MSISDN) tiene que iniciar con 3  ", "Detalle de Mines", row("MSISDN").ToString())
                ElseIf Not IsNumeric(row("MSISDN")) Then
                    RegError(fila, "El (MSISDN) tiene que ser un valor numerico ", "Detalle de Mines", row("MSISDN").ToString())
                End If
                If (IsDBNull(row("tipo"))) Then
                    RegError(fila, "El (tipo) Esta vacio no validos por favor verificar", "Detalle de Mines", "")
                ElseIf Not IsNumeric(row("tipo")) Then
                    RegError(fila, "El Valor de (tipo) es un valor no numerico, El valor permitido es (0 1 2)", "Información General", row("MSISDN"))
                ElseIf (CInt(row("tipo")) <> 1 And CInt(row("tipo")) <> 0 And CInt(row("tipo")) <> 2) Then
                    RegError(fila, "El Valor de (tipo) es un valor no permitido, valores permitidos (0 1 2)", "Información General", row("MSISDN"))
                ElseIf (CInt(row("tipo")) = 0 And CInt(row("tipo")) = 2) Then
                    If (IsDBNull(row("Plan"))) Then
                        RegError(fila, "El (Plan) Esta vacio no validos por favor verificar", "Detalle de Mines", "")
                    End If
                ElseIf (CInt(row("tipo")) = 1) Then
                    If Not (IsDBNull(row("Plan"))) Then
                        RegError(fila, "El (Plan) tiene que estar vacio para el tipo (Solo Equipo), por favor verificar", "Detalle de Mines", "")
                    End If
                End If

                If (IsDBNull(row("FechaDevolucion"))) Then
                    RegError(fila, "El (FechaDevolucion) Esta vacio no validos por favor verificar", "Detalle de Mines", "")
                ElseIf Not (IsDate(row("FechaDevolucion"))) Then
                    RegError(fila, "La columna (FechaDevolucion) tiene valores no valido por favor verificar", "Detalle de Mines", row("FechaDevolucion"))
                End If
               
                fila = fila + 1
            Next
        Catch ex As Exception
            RegError(fila, "Error al validar Detalle de Mines.", "Información General", ex.Message)
            miEncabezado.showError("Error al validar Detalle de Mines. " & ex.Message & "<br><br>")
            Exit Sub
        End Try

    End Sub
    Private Sub Cargarregistro()
        Dim objServicioSiembra As New CargueArchivoMinesSiembra()
        With objServicioSiembra
            ._idUsuario = CInt(Session("usxp001"))
            .CargarDatos()
        End With

        With objServicioSiembra
            If ._estructuraTablaErrores IsNot Nothing Then
                Dim dt = ._estructuraTablaErrores
                Session("dtError") = dt
                If dt.Rows.Count > 0 Then
                    With gvErrores
                        .DataSource = dt
                        .DataBind()
                    End With
                    rpLogErrores.Visible = True
                End If
                If cmbCiudadEntrega.DataSource Is Nothing Then
                    cargarCiudades()
                End If
                cmbCiudadEntrega.Value = Convert.ToInt32(._idciudad)
              
                txtNombreEmpresa.Text = ._NombreEmpresa
                txtIdentificacionCliente.Text = ._NIT
                txtTelefonoFijo.Text = ._TelefonoFijoEmpresa
                txtExtTelefonoFijo.Text = ._Ext
                txtNombreRepresentante.Text = ._NombreRepresentanteLegal
                txtTelefonoMovilRepresentante.Text = ._TelefonoCelularRepresentante
                txtIdentificacionRepresentante.Text = ._NumeroCedulaRepresentante
                txtPersonaAutorizada.Text = ._NombrepersonaAutorizada
                txtIdentificacionAutorizado.Text = ._NumeroCedulaAutorizado
                txtCargoPersonaAutorizada.Text = ._CargoPersonaAutorizada
                txtTelefonoAutorizado.Text = ._TelefonoPersonaAutorizada
                textDireccion.Text = ._Direccion
                memoObservaciones.Text = ._Observacion
                txtBarrio.Text = ._Barrio
                rblClienteClaro.Value = IIf(._ClienteClaro, "1", "0")
                If (objServicioSiembra._minsColeccion.Count > 0) Then
                    With gvCombinacionEquipos
                        .DataSource = objServicioSiembra._minsColeccion
                        .DataBind()
                        Session("dtmsisdn") = .DataSource
                    End With
                End If

            End If

        End With
    End Sub

#End Region
End Class