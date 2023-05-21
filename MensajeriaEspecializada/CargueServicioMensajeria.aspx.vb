Imports System.IO
Imports GemBox.Spreadsheet
Imports System.Text
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Partial Public Class CargueServicioMensajeria
    Inherits System.Web.UI.Page

#Region "Variables"

    Private Shared rutaArchivo As String = "~\archivos_planos\"
    Private Shared _rutaLocal As String = HttpContext.Current.Server.MapPath(rutaArchivo)

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            epPrincipal.clear()

            If Not IsPostBack Then
                With epPrincipal
                    .setTitle("Cargue Servicio Mensajeria")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                CargaInicial()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar la pagina. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCargar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCargar.Click
        Try
            LimpiarDtErrores()
            LimpiarDtCorrecto()
            CargarArchivo()
        Catch ex As Exception
            epPrincipal.showError("Error la cargar. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Metodos"

    Private Sub CargaInicial()
        Try
            CargarListadoDeTipoArchivo()
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoDeTipoArchivo()
        Try
            Dim dt As New DataTable
            dt = TipoArchivoCargueServicioMensajeria.ObtenerListado()
            With ddlTipoArchivo
                .DataSource = dt
                .DataTextField = "tipoArchivo"
                .DataValueField = "idTipoArchivo"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
        Catch ex As Exception
            Throw New Exception("Error al cargar los tipos de archivos. " & ex.Message)
        End Try
    End Sub

    Private Sub MostrarErrores(ByVal dtErrores As DataTable)
        If Not dtErrores Is Nothing Then
            gvErrores.DataSource = dtErrores
            gvErrores.DataBind()
        End If
    End Sub

    Private Sub MostrarCorrectos(ByVal dtCorrectos As DataTable)
        If Not dtCorrectos Is Nothing Then
            gvCorrectos.DataSource = dtCorrectos
            gvCorrectos.DataBind()
        End If
    End Sub

#End Region

#Region "Metodos para cargue de archivo"

    Private Sub CargarArchivo()
        Dim filePath As String
        Dim dtData As New DataTable
        Dim extension As String = ""
        Dim dtError As DataTable
        Dim dtCorrecto As DataTable

        Try
            filePath = SubirArchivoServidor(extension)
            If filePath.Trim.Length > 0 Then
                If CInt(ddlTipoArchivo.SelectedValue) = TipoArchivo.General Then dtData = ValidarGeneral(extension, filePath)
                If CInt(ddlTipoArchivo.SelectedValue) = TipoArchivo.Corporativo Then dtData = ValidarCoporativo(extension, filePath)

                dtError = EstructuraErrores()
                dtCorrecto = EstructuraResultadoCorrectos()
                If dtError.Rows.Count = 0 Then
                    Dim dtRepetido As New DataTable
                    Dim errores As New Dictionary(Of Integer, String)
                    Dim correctos As New Dictionary(Of Long, String)
                    Dim contador As Integer

                    RegistrarRadicados(errores, correctos)
                    If errores.Count > 0 Then
                        epPrincipal.showWarning("Se presentaron inconvenientes en el cargue. Por favor revisar el log de Resultados.")
                    Else
                        epPrincipal.showSuccess("Se cargaron los servicios correctamente. Por favor revisar el log de Resultados.")
                    End If

                    LimpiarDtErrores()
                    LimpiarDtResultadoCorrectos()

                    'Errores
                    contador = 0
                    For Each elemento As Object In errores.Values
                        contador = contador + 1
                        InsertarError(contador, elemento.ToString())
                    Next
                    dtError = EstructuraErrores()

                    'Correctos
                    contador = 0
                    For Each elemento As Object In correctos.Values
                        contador = contador + 1
                        InsertarCorrecto(contador, elemento.ToString())
                    Next
                    dtCorrecto = EstructuraResultadoCorrectos()

                    MostrarErrores(dtError)
                    MostrarCorrectos(dtCorrecto)
                Else
                    MostrarErrores(dtError)
                End If
            Else
                Throw New Exception("Imposible recuperar la ruta de almacenamento del archivo en el servidor.")
            End If
            ddlTipoArchivo.ClearSelection()
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        Finally
            If dtData IsNot Nothing Then dtData.Dispose()
            If dtError IsNot Nothing Then dtError.Dispose()
        End Try
    End Sub

    Private Function SubirArchivoServidor(ByRef extension As String) As String
        Try
            If fuArchivo.HasFile Then
                If fuArchivo.PostedFile.ContentLength <= 10485760 Then
                    Dim fileExtension As String = Path.GetExtension(Me.fuArchivo.PostedFile.FileName)
                    extension = fileExtension
                    Dim filePath As String = _rutaLocal & "ArchivoCEM_" & Session("user01") & extension
                    fuArchivo.PostedFile.SaveAs(filePath)
                    If File.Exists(filePath) Then
                        Return filePath
                    Else
                        Return ""
                    End If
                Else
                    Throw New Exception("El archivo tiene un peso mayor al permitido que es de 10MB.")
                End If
            Else
                Throw New Exception("No existe ningún archivo a cargar.")
            End If
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try



    End Function

    Private Sub RegistrarRadicados(ByRef errores As Dictionary(Of Integer, String), ByRef correctos As Dictionary(Of Long, String))
        Dim dtRadicados As DataTable
        Dim campos As CamposDtCorrecto
        Try
            dtRadicados = EstructuraCorrecto()
            campos = ObtenerCampos()

            Dim radicadosVerificados As New ArrayList
            Dim objMin As DetalleMsisdnEnServicioMensajeria
            Dim objMinColeccion As DetalleMsisdnEnServicioMensajeriaColeccion
            Dim objServicioMensajeria As MensajeriaEspecializada.CargueServicioMensajeria
            Dim servicios As New List(Of MensajeriaEspecializada.CargueServicioMensajeria)

            For Each filaGeneral As DataRow In dtRadicados.Rows
                If Not radicadosVerificados.Contains(filaGeneral(campos.NumeroRadicado.Caption)) Then
                    objServicioMensajeria = New MensajeriaEspecializada.CargueServicioMensajeria()

                    With objServicioMensajeria
                        .IdUsuario = CInt(Session("usxp001"))
                        .FechaAsignacion = filaGeneral(campos.FechaRegistro.Caption)
                        .UsuarioEjecutor = filaGeneral(campos.UsuarioEjecutor.Caption).ToString()
                        .NombreCliente = filaGeneral(campos.NombreCliente.Caption)
                        .PersonaContacto = filaGeneral(campos.PersonaContacto.Caption)
                        .IdenticacionCliente = filaGeneral(campos.IdentificacionCliente.Caption)
                        .IdCiudad = filaGeneral(campos.CiudadEntrega.Caption)
                        .Barrio = filaGeneral(campos.BarrioEntrega.Caption)
                        .Direccion = filaGeneral(campos.DireccionEntrega.Caption)
                        .TelefonoContacto = filaGeneral(campos.TelefonoContacto.Caption)
                        .ExtensionContacto = ""
                        .TipoTelefono = CStr(IIf((filaGeneral(campos.TelefonoContacto.Caption).ToString().Length = 10), "CEL", "FIJO"))
                        .NumeroRadicado = filaGeneral(campos.NumeroRadicado.Caption)
                        .ClienteVIP = filaGeneral(campos.ClienteVIP.Caption)
                        .PlanActual = filaGeneral(campos.PlanActual.Caption)
                        .Observacion = filaGeneral(campos.Observaciones.Caption)
                        .IdEstado = Enumerados.EstadoServicio.Creado
                        .IdTipoServicio = filaGeneral(campos.TipoServicio.Caption)
                        If Not IsDBNull(filaGeneral(campos.FechaVencimientoReserva.Caption)) AndAlso Not String.IsNullOrEmpty(filaGeneral(campos.FechaVencimientoReserva.Caption)) Then _
                            .FechaVencimientoReserva = filaGeneral(campos.FechaVencimientoReserva.Caption)
                        .IdPrioridad = filaGeneral(campos.Prioridad.Caption)
                        .Adendo = filaGeneral(campos.AdjuntaArchivo.Caption)

                        objMinColeccion = New DetalleMsisdnEnServicioMensajeriaColeccion()
                        For Each filaMin As DataRow In dtRadicados.Select("numeroRadicado=" & objServicioMensajeria.NumeroRadicado.ToString())
                            objMin = New DetalleMsisdnEnServicioMensajeria()
                            objMin.IdTipoServicio = filaMin(campos.TipoServicio.Caption)
                            objMin.MSISDN = filaMin(campos.MinAfectado.Caption)
                            objMin.ActivaEquipoAnterior = filaMin(campos.ActivaEquipoAnterior.Caption)
                            objMin.Comseguro = filaMin(campos.ComSeguro.Caption)
                            objMin.PrecioConIva = filaMin(campos.PrecioConIva.Caption)
                            objMin.PrecioSinIva = filaMin(campos.PrecioSinIva.Caption)
                            objMin.IdClausula = filaMin(campos.Clausula.Caption)
                            objMinColeccion.Adicionar(objMin)
                        Next
                        .MinsDataTable = objMinColeccion.GenerarDataTableDesdeLista()
                        servicios.Add(objServicioMensajeria)
                        radicadosVerificados.Add(filaGeneral(campos.NumeroRadicado.Caption))
                    End With
                End If
            Next
            MensajeriaEspecializada.CargueServicioMensajeria.Registrar(servicios, errores, correctos)
        Catch ex As Exception
            Throw New Exception("Error al registrar los radicados. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Metodos para validar y cargar archivos"

    Private Function ValidarGeneral(ByVal extension As String, ByVal filePath As String) As DataTable
        MetodosComunes.setGemBoxLicense()
        Dim oExcel As New ExcelFile
        Dim wsData As ExcelWorksheet
        Dim dtData As DataTable = EstructuraCorrecto()

        Try
            oExcel.LoadCsv(filePath, CsvType.CommaDelimited)
            If oExcel.Worksheets.Count = 1 Then
                wsData = oExcel.Worksheets.ActiveWorksheet
                With wsData
                    If .Rows.Count > 0 Then
                        Dim numColumnas As Integer = wsData.CalculateMaxUsedColumns
                        Dim firstRowIndex As Integer = 0
                        Dim mensaTitulo As String = ""

                        Dim eRow As ExcelRow
                        For indexRow As Integer = 0 To wsData.Rows.Count - 1
                            eRow = wsData.Rows(indexRow)
                            Dim titulo As String = "cas_id,cas_fecha_registro,cas_fecha_cierre,cas_estado,Usuario_Registra,Usuario_Asignado,cas_observaciones,cas_respuesta,MIN_AC,CUSTCODE_AC,NOM_CLIENTE,PLAN_ACTUAL_AC,BARRIO_AC,TELEFONO_CONTAC,IDENTIFICACI_AC,ACTIVA_EQUIPO,ZONA_AC,DIRECC_AC_FAC,CLIENTE_VIP,COMSEGURO_,ZONA_SIM,PERSONA_CONTACTO_CORP,TELEFONO_CONT_CASA,EQUIPOS_2011,VALOR_EQUIPO_IVA,CIUDAD_ENTREGA_REPO,CIRCULO_AZUL_ACTIVO,CLAUSULA_SOLA"
                            If eRow.AllocatedCells.Count > 0 And EsEncabezadoDatos(eRow, mensaTitulo, titulo) Then
                                Exit For
                            Else
                                Throw New Exception(mensaTitulo)
                            End If
                        Next

                        Dim mensajeError As String
                        Dim tipoCargue As New TipoArchivoCargueServicioMensajeria(CInt(ddlTipoArchivo.SelectedValue))
                        Dim fechaCierre As String = ""
                        Dim barrio As String = ""
                        For rowIndex As Integer = 1 To .Rows.Count - 1
                            If .Rows(rowIndex).Cells(0).Value Is Nothing Then .Rows(rowIndex).Cells(0).Value = ""
                            If Not (.Rows(rowIndex).Cells(0).Value.ToString() = "Thread was being aborted.") Then
                                mensajeError = ""
                                If ValidarFilaGeneral(.Rows(rowIndex), mensajeError) Then
                                    With .Rows(rowIndex)
                                        If Not String.IsNullOrEmpty(.Cells(2).Value) Then fechaCierre = .Cells(2).Value.ToString.Trim()
                                        If Not String.IsNullOrEmpty(.Cells(12).Value) Then barrio = .Cells(12).Value.ToString.Trim()
                                        AdicionarServicio(tipoCargue.IdTipoServicio, .Cells(0).Value.ToString.Trim(), fechaCierre, .Cells(5).Value.ToString.Trim(), _
                                                          .Cells(10).Value.ToString.Trim(), .Cells(9).Value.ToString.Trim(), .Cells(14).Value.ToString.Trim(), barrio, .Cells(17).Value.ToString.Trim(), _
                                                          .Cells(1).Value.ToString.Trim(), .Cells(18).Value.ToString.Trim(), .Cells(11).Value.ToString.Trim(), .Cells(6).Value.ToString.Trim(), .Cells(8).Value.ToString.Trim(), _
                                                          .Cells(15).Value.ToString.Trim(), .Cells(19).Value.ToString.Trim(), .Cells(24).Value.ToString.Trim(), .Cells(27).Value.ToString.Trim(), "No", .Cells(25).Value.ToString.Trim(), .Cells(13).Value.ToString.Trim(), .Cells(21).Value.ToString.Trim())
                                    End With
                                Else
                                    InsertarError(rowIndex + 1, mensajeError)
                                End If
                            End If
                        Next
                    Else
                        Throw New Exception("El archivo especificado no contiene datos. Por favor verifique.")
                    End If
                End With
            Else
                Throw New Exception("El archivo contiene más de una hoja. Por favor verifique.")
            End If
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Function

    Private Function ValidarCoporativo(ByVal extencion As String, ByVal filePath As String) As DataTable
        MetodosComunes.setGemBoxLicense()
        Dim oExcel As New ExcelFile
        Dim wsData As ExcelWorksheet
        Dim dtData As DataTable = EstructuraCorrecto()
        Try
            oExcel.LoadCsv(filePath, CsvType.CommaDelimited)

            If oExcel.Worksheets.Count = 1 Then
                wsData = oExcel.Worksheets.ActiveWorksheet
                With wsData
                    If .Rows.Count > 0 Then
                        Dim numColumnas As Integer = wsData.CalculateMaxUsedColumns
                        Dim firstRowIndex As Integer = 0
                        Dim mensaTitulo As String = ""

                        Dim eRow As ExcelRow
                        For indexRow As Integer = 0 To wsData.Rows.Count - 1
                            eRow = wsData.Rows(indexRow)
                            Dim titulo As String = "cas_id,cas_fecha_registro,cas_fecha_cierre,cas_estado,Usuario_Registra,Usuario_Asignado,cas_observaciones,cas_respuesta,MIN_AC,CUSTCODE_AC,NOM_CLIENTE,BARRIO_AC,TELEFONO_CONTAC,IDENTIFICACI_AC,CLAUSULA,ACTIVA_EQUIPO,CLIENTE_VIP,ZONA_SIM,ZONA_SIM_A,ZONA_SIM_B,ZONA_SIM_D,ZONA_SIM_E,TELEFONO_CONTAC_FIJO,ACTIVA_EQUIPO_2,ACTIVA_EQUIPO_3,ACTIVA_EQUIPO_4,PERSONA_CONTACTO_CORP,MIN_,EQUIPOS_2011,VALOR_EQUIPO_IVA,CONSUL_SAUC_MEDELLIN,CONSUL_SAUC_ARMENIA,CONSUL_SAUC_MANIZALES,CONSUL_SAUC_PEREIRA,ADENDO,CIUDAD_ENTREGA_REPO,DIRECCION_REPO,PERSONA_PERFILAD,CAMBIO_SIM_CARD,CLAUSULA_1_,CLAUSULA_2__,CLAUSULA_3__,CLAUSULA_4___,EQUIPOS_2011_2_,EQUIPOS_2011_3__,EQUIPOS_2011_4_,EQUIPOS_2011_5_,VALOR_EQUIPO_IVA_2,VALOR_EQUIPO_IVA_3,VALOR_EQUIPO_IVA_4,VALOR_EQUIPO_IVA_5,CAMBIO_SIM_CARD_2,CAMBIO_SIM_CARD_3,CAMBIO_SIM_CARD_4,CAMBIO_SIM_CARD_5,CIRCULO_AZUL_1,CIRCULO_AZUL_2,CIRCULO_AZUL_3,CIRCULO_AZUL_4,CIRCULO_AZUL_5,MIN_3_,MIN_4_,MIN_5_,MIN_2_,CONSUL_SAUC_CALI,CONSUL_SAUC_BARRANQU,CONSUL_SAUC_CARTAGENA,CONSUL_SAUC_PASTO,CONSUL_SAUC_IBAGUE,CONSUL_SAUC_BOGOTA,ACTIVA_EQUIPO_5_"
                            If eRow.AllocatedCells.Count > 0 And EsEncabezadoDatos(eRow, mensaTitulo, titulo) Then
                                Exit For
                            Else
                                Throw New Exception(mensaTitulo)
                            End If
                        Next

                        Dim mensajeError As String
                        Dim tipoCargue As New TipoArchivoCargueServicioMensajeria(CInt(ddlTipoArchivo.SelectedValue))
                        Dim fechaCierre As String = ""
                        Dim barrio As String = ""

                        For rowIndex As Integer = 1 To .Rows.Count - 1
                            If .Rows(rowIndex).Cells(0).Value Is Nothing Then .Rows(rowIndex).Cells(0).Value = ""
                            If Not (.Rows(rowIndex).Cells(0).Value.ToString() = "Thread was being aborted.") Then
                                mensajeError = ""
                                If ValidarFilaCoporativo(.Rows(rowIndex), mensajeError) Then
                                    With .Rows(rowIndex)
                                        'Limpiar todas la celdas
                                        For Each celda As ExcelCell In .AllocatedCells
                                            If celda.Value.GetType.FullName = "System.String" Then
                                                celda.Value = celda.Value.ToString().Trim()
                                            End If
                                        Next

                                        If Not String.IsNullOrEmpty(.Cells(2).Value) Then fechaCierre = .Cells(2).Value.ToString.Trim()

                                        If Not String.IsNullOrEmpty(.Cells(11).Value) Then barrio = .Cells(11).Value.ToString.Trim()
                                        AdicionarServicio(tipoCargue.IdTipoServicio.ToString(), .Cells(0).Value.ToString.Trim(), fechaCierre, .Cells(4).Value.ToString.Trim(), _
                                                           .Cells(10).Value.ToString.Trim(), .Cells(9).Value.ToString.Trim(), .Cells(13).Value.ToString.Trim(), barrio, .Cells(36).Value.ToString.Trim(), _
                                                            .Cells(1).Value.ToString.Trim(), .Cells(16).Value.ToString.Trim(), "", .Cells(6).Value.ToString.Trim() _
                                                            , .Cells(27).Value.ToString.Trim(), .Cells(15).Value.ToString.Trim(), .Cells(55).Value.ToString.Trim(), .Cells(29).Value.ToString.Trim(), .Cells(14).Value.ToString.Trim(), _
                                                             .Cells(34).Value.ToString.Trim(), .Cells(35).Value.ToString.Trim(), .Cells(12).Value.ToString.Trim(), .Cells(26).Value.ToString.Trim())

                                        If (Not String.IsNullOrEmpty(.Cells(63).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(23).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(56).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(47).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(39).Value)) Then
                                            AdicionarServicio(tipoCargue.IdTipoServicio.ToString(), .Cells(0).Value.ToString.Trim(), fechaCierre, .Cells(4).Value.ToString.Trim(), _
                                                           .Cells(10).Value.ToString.Trim(), .Cells(9).Value.ToString.Trim(), .Cells(13).Value.ToString.Trim(), barrio, .Cells(36).Value.ToString.Trim(), _
                                                            .Cells(1).Value.ToString.Trim(), .Cells(16).Value.ToString.Trim(), "", .Cells(6).Value.ToString.Trim() _
                                                            , .Cells(63).Value.ToString.Trim(), .Cells(23).Value.ToString.Trim(), .Cells(56).Value.ToString.Trim(), .Cells(47).Value.ToString.Trim(), .Cells(39).Value.ToString.Trim(), _
                                                             .Cells(34).Value.ToString.Trim(), .Cells(35).Value.ToString.Trim(), .Cells(12).Value.ToString.Trim(), .Cells(26).Value.ToString.Trim())
                                        End If

                                        If (Not String.IsNullOrEmpty(.Cells(60).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(24).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(57).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(48).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(40).Value)) Then
                                            AdicionarServicio(tipoCargue.IdTipoServicio.ToString(), .Cells(0).Value.ToString.Trim(), fechaCierre, .Cells(4).Value.ToString.Trim(), _
                                                           .Cells(10).Value.ToString.Trim(), .Cells(9).Value.ToString.Trim(), .Cells(13).Value.ToString.Trim(), barrio, .Cells(36).Value.ToString.Trim(), _
                                                            .Cells(1).Value.ToString.Trim(), .Cells(16).Value.ToString.Trim(), "", .Cells(6).Value.ToString.Trim() _
                                                            , .Cells(60).Value.ToString.Trim(), .Cells(24).Value.ToString.Trim(), .Cells(57).Value.ToString.Trim(), .Cells(48).Value.ToString.Trim(), .Cells(40).Value.ToString.Trim(), _
                                                             .Cells(34).Value.ToString.Trim(), .Cells(35).Value.ToString.Trim(), .Cells(12).Value.ToString.Trim(), .Cells(26).Value.ToString.Trim())
                                        End If

                                        If (Not String.IsNullOrEmpty(.Cells(61).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(25).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(58).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(49).Value.ToString.Trim)) AndAlso (Not String.IsNullOrEmpty(.Cells(41).Value)) Then
                                            AdicionarServicio(tipoCargue.IdTipoServicio.ToString(), .Cells(0).Value.ToString.Trim(), fechaCierre, .Cells(4).Value.ToString.Trim(), _
                                                           .Cells(10).Value.ToString.Trim(), .Cells(9).Value.ToString.Trim(), .Cells(13).Value.ToString.Trim(), barrio, .Cells(36).Value.ToString.Trim(), _
                                                            .Cells(1).Value.ToString.Trim(), .Cells(16).Value.ToString.Trim(), "", .Cells(6).Value.ToString.Trim() _
                                                            , .Cells(61).Value.ToString.Trim(), .Cells(25).Value.ToString.Trim(), .Cells(58).Value.ToString.Trim(), .Cells(49).Value.ToString.Trim(), .Cells(41).Value.ToString.Trim(), _
                                                             .Cells(34).Value.ToString.Trim(), .Cells(35).Value.ToString.Trim(), .Cells(12).Value.ToString.Trim(), .Cells(26).Value.ToString.Trim())
                                        End If

                                        If (Not String.IsNullOrEmpty(.Cells(62).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(70).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(59).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(50).Value)) AndAlso (Not String.IsNullOrEmpty(.Cells(42).Value)) Then
                                            AdicionarServicio(tipoCargue.IdTipoServicio.ToString(), .Cells(0).Value.ToString.Trim(), fechaCierre, .Cells(4).Value.ToString.Trim(), _
                                                           .Cells(10).Value.ToString.Trim(), .Cells(9).Value.ToString.Trim(), .Cells(13).Value.ToString.Trim(), barrio, .Cells(36).Value.ToString.Trim(), _
                                                            .Cells(1).Value.ToString.Trim(), .Cells(16).Value.ToString.Trim(), "", .Cells(6).Value.ToString.Trim() _
                                                            , .Cells(62).Value.ToString.Trim(), .Cells(70).Value.ToString.Trim(), .Cells(59).Value.ToString.Trim(), .Cells(50).Value.ToString.Trim(), .Cells(42).Value.ToString.Trim(), _
                                                             .Cells(34).Value.ToString.Trim(), .Cells(35).Value.ToString.Trim(), .Cells(12).Value.ToString.Trim(), .Cells(26).Value.ToString.Trim())
                                        End If
                                    End With
                                Else
                                    InsertarError(rowIndex + 1, mensajeError)
                                End If
                            End If
                        Next
                    Else
                        Throw New Exception("El archivo especificado no contiene datos. Por favor verifique.")
                    End If
                End With
            Else
                Throw New Exception("El archivo contiene más de una hoja. Por favor verifique.")
            End If
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Function

    Private Function EsEncabezadoDatos(ByVal eRow As ExcelRow, ByRef mensaje As String, ByVal titulo As String) As Boolean
        Dim resultado As Boolean = False
        Dim arrTitulo As New ArrayList(titulo.Split(","))
        Dim contarColumnas As Integer
        For index As Integer = 0 To eRow.AllocatedCells.Count - 1
            If eRow.Cells(index).Value IsNot Nothing Then
                If Not EsNumerico(eRow.Cells(index).Value.ToString) Then
                    contarColumnas += 1
                    If eRow.Cells(index).Value.ToString.ToUpper = arrTitulo(index).ToString.ToUpper Then
                        If contarColumnas = eRow.AllocatedCells.Count Then
                            resultado = True
                            Exit For
                        End If
                    Else
                        mensaje = "El nombre de las columnas no es el correcto, por favor verifique."
                        Exit For
                    End If
                Else
                    mensaje = "El titulo de las columnas no debe ser numerico."
                    Exit For
                End If
            Else
                mensaje = "El titulo de las columnas no debe ser vacio."
                Exit For
            End If
        Next
        Return resultado
    End Function

    Private Function EsNumerico(ByVal cadena As String) As Boolean
        Dim miRegExp As New RegularExpressions.Regex("^[0-9]+$")
        Dim resultado As Boolean = miRegExp.IsMatch(cadena)
        Return resultado
    End Function

    Private Function ValidarFilaGeneral(ByVal eRow As ExcelRow, ByRef mensaje As String) As Boolean
        Dim retorno As Boolean = True
        Dim numeroColumnas As Integer = 0
        With eRow
            numeroColumnas = .AllocatedCells.Count
            If numeroColumnas = 28 Then
                If Not (.Cells(0).Value IsNot Nothing AndAlso .Cells(0).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_id no fue especificado."
                If Not (.Cells(1).Value IsNot Nothing AndAlso .Cells(1).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_fecha_registro no fue especificado."
                'If Not (.Cells(2).Value IsNot Nothing AndAlso .Cells(2).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_fecha_cierre no fue especificado."
                If Not (.Cells(5).Value IsNot Nothing AndAlso .Cells(5).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del Usuario_Asignado no fue especificado."
                If Not (.Cells(6).Value IsNot Nothing AndAlso .Cells(6).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_observaciones no fue especificado."
                If Not (.Cells(8).Value IsNot Nothing AndAlso .Cells(8).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del MIN_AC no fue especificado."
                If Not (.Cells(9).Value IsNot Nothing AndAlso .Cells(9).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CUSTCODE_AC no fue especificado."
                If Not (.Cells(10).Value IsNot Nothing AndAlso .Cells(10).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del NOM_CLIENTE no fue especificado."
                If Not (.Cells(11).Value IsNot Nothing AndAlso .Cells(11).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del PLAN_ACTUAL_AC no fue especificado."
                'If Not (.Cells(12).Value IsNot Nothing AndAlso .Cells(12).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del BARRIO_AC no fue especificado."
                If Not (.Cells(14).Value IsNot Nothing AndAlso .Cells(14).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del IDENTIFICACI_AC no fue especificado."
                If Not (.Cells(15).Value IsNot Nothing AndAlso .Cells(15).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO no fue especificado."
                If Not (.Cells(17).Value IsNot Nothing AndAlso .Cells(17).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del DIRECC_AC_FAC no fue especificado."
                If Not (.Cells(18).Value IsNot Nothing AndAlso .Cells(18).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLIENTE_VIP no fue especificado."
                If Not (.Cells(19).Value IsNot Nothing AndAlso .Cells(19).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del COMSEGURO_ no fue especificado."
                If Not (.Cells(27).Value IsNot Nothing AndAlso .Cells(27).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLAUSULA_SOLA no fue especificado."
                If Not (.Cells(24).Value IsNot Nothing AndAlso .Cells(24).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del VALOR_EQUIPO_IVA no fue especificado."
                If Not (.Cells(25).Value IsNot Nothing AndAlso .Cells(25).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CIUDAD_ENTREGA_REPO no fue especificado."
            Else
                mensaje = " El número de columnas no es correcto."
            End If
        End With
        If mensaje <> "" Then retorno = False
        Return retorno
    End Function

    Private Function ValidarFilaCoporativo(ByVal eRow As ExcelRow, ByRef mensaje As String) As Boolean
        Dim retorno As Boolean = True
        Dim numeroColumnas As Integer = 0
        With eRow
            numeroColumnas = .AllocatedCells.Count
            If numeroColumnas = 71 Then
                If Not (.Cells(0).Value IsNot Nothing AndAlso .Cells(0).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_id no fue especificado."
                If Not (.Cells(1).Value IsNot Nothing AndAlso .Cells(1).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_fecha_registro no fue especificado."
                'If Not (.Cells(2).Value IsNot Nothing AndAlso .Cells(2).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_fecha_cierre no fue especificado."
                If Not (.Cells(4).Value IsNot Nothing AndAlso .Cells(4).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del Usuario_Registra no fue especificado."
                If Not (.Cells(6).Value IsNot Nothing AndAlso .Cells(6).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del cas_observaciones no fue especificado."
                If Not (.Cells(9).Value IsNot Nothing AndAlso .Cells(9).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CUSTCODE_AC no fue especificado."
                If Not (.Cells(10).Value IsNot Nothing AndAlso .Cells(10).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del NOM_CLIENTE no fue especificado."
                'If Not (.Cells(11).Value IsNot Nothing AndAlso .Cells(11).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del BARRIO_AC no fue especificado."
                If Not (.Cells(13).Value IsNot Nothing AndAlso .Cells(13).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del IDENTIFICACI_AC no fue especificado."
                If Not (.Cells(16).Value IsNot Nothing AndAlso .Cells(16).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLIENTE_VIP no fue especificado."
                If Not (.Cells(36).Value IsNot Nothing AndAlso .Cells(36).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del DIRECCION_REPO no fue especificado."
                If Not (.Cells(35).Value IsNot Nothing AndAlso .Cells(35).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CIUDAD_ENTREGA_REPO no fue especificado."

                '***** Valido el primer MIN (8,15,55,29,14) *****
                If (.Cells(27).Value IsNot Nothing AndAlso .Cells(27).Value.ToString.Trim.Length > 0) Or _
                (.Cells(15).Value IsNot Nothing AndAlso .Cells(15).Value.ToString.Trim.Length > 0) Or _
                (.Cells(55).Value IsNot Nothing AndAlso .Cells(55).Value.ToString.Trim.Length > 0) Or _
                (.Cells(29).Value IsNot Nothing AndAlso .Cells(29).Value.ToString.Trim.Length > 0) Or _
                (.Cells(14).Value IsNot Nothing AndAlso .Cells(14).Value.ToString.Trim.Length > 0) Then
                    If Not (.Cells(27).Value IsNot Nothing AndAlso .Cells(27).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del MIN_ no fue especificado."
                    If Not (.Cells(15).Value IsNot Nothing AndAlso .Cells(15).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO no fue especificado."
                    If Not (.Cells(55).Value IsNot Nothing AndAlso .Cells(55).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CIRCULO_AZUL_1 no fue especificado."
                    If Not (.Cells(29).Value IsNot Nothing AndAlso .Cells(29).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del VALOR_EQUIPO_IVA no fue especificado."
                    If Not (.Cells(14).Value IsNot Nothing AndAlso .Cells(14).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLAUSULA no fue especificado."
                End If



                '***** Valido el segundo MIN (27,23,56,47,39) *****
                If (.Cells(63).Value IsNot Nothing AndAlso .Cells(63).Value.ToString.Trim.Length > 0) Or _
                (.Cells(23).Value IsNot Nothing AndAlso .Cells(23).Value.ToString.Trim.Length > 0) Or _
                (.Cells(56).Value IsNot Nothing AndAlso .Cells(56).Value.ToString.Trim.Length > 0) Or _
                (.Cells(47).Value IsNot Nothing AndAlso .Cells(47).Value.ToString.Trim.Length > 0) Or _
                (.Cells(39).Value IsNot Nothing AndAlso .Cells(39).Value.ToString.Trim.Length > 0) Then
                    If Not (.Cells(63).Value IsNot Nothing AndAlso .Cells(63).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del MIN_2 no fue especificado."
                    If Not (.Cells(23).Value IsNot Nothing AndAlso .Cells(23).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO_2 no fue especificado."
                    If Not (.Cells(56).Value IsNot Nothing AndAlso .Cells(56).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CIRCULO_AZUL_2 no fue especificado."
                    If Not (.Cells(47).Value IsNot Nothing AndAlso .Cells(47).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del VALOR_EQUIPO_IVA_2 no fue especificado."
                    If Not (.Cells(39).Value IsNot Nothing AndAlso .Cells(39).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLAUSULA_1_ no fue especificado."
                End If

                '***** Valido el tercero MIN (60,24,57,48,40) *****
                If (.Cells(60).Value IsNot Nothing AndAlso .Cells(60).Value.ToString.Trim.Length > 0) Or _
                (.Cells(24).Value IsNot Nothing AndAlso .Cells(24).Value.ToString.Trim.Length > 0) Or _
                (.Cells(57).Value IsNot Nothing AndAlso .Cells(57).Value.ToString.Trim.Length > 0) Or _
                (.Cells(48).Value IsNot Nothing AndAlso .Cells(48).Value.ToString.Trim.Length > 0) Or _
                (.Cells(40).Value IsNot Nothing AndAlso .Cells(40).Value.ToString.Trim.Length > 0) Then
                    If Not (.Cells(60).Value IsNot Nothing AndAlso .Cells(60).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del MIN_3 no fue especificado."
                    If Not (.Cells(24).Value IsNot Nothing AndAlso .Cells(24).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO_3 no fue especificado."
                    If Not (.Cells(57).Value IsNot Nothing AndAlso .Cells(57).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CIRCULO_AZUL_3 no fue especificado."
                    If Not (.Cells(48).Value IsNot Nothing AndAlso .Cells(48).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del VALOR_EQUIPO_IVA_3 no fue especificado."
                    If Not (.Cells(40).Value IsNot Nothing AndAlso .Cells(40).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLAUSULA_2__ no fue especificado."
                End If

                '***** Valido el cuarto MIN (61,25,58,49,41) *****
                If (.Cells(61).Value IsNot Nothing AndAlso .Cells(61).Value.ToString.Trim.Length > 0) Or _
                (.Cells(25).Value IsNot Nothing AndAlso .Cells(25).Value.ToString.Trim.Length > 0) Or _
                (.Cells(58).Value IsNot Nothing AndAlso .Cells(58).Value.ToString.Trim.Length > 0) Or _
                (.Cells(49).Value IsNot Nothing AndAlso .Cells(49).Value.ToString.Trim.Length > 0) Or _
                (.Cells(41).Value IsNot Nothing AndAlso .Cells(41).Value.ToString.Trim.Length > 0) Then
                    If Not (.Cells(61).Value IsNot Nothing AndAlso .Cells(61).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del MIN_4 no fue especificado."
                    If Not (.Cells(25).Value IsNot Nothing AndAlso .Cells(25).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO_4 no fue especificado."
                    If Not (.Cells(58).Value IsNot Nothing AndAlso .Cells(58).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CIRCULO_AZUL_4 no fue especificado."
                    If Not (.Cells(49).Value IsNot Nothing AndAlso .Cells(49).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del VALOR_EQUIPO_IVA_4 no fue especificado."
                    If Not (.Cells(41).Value IsNot Nothing AndAlso .Cells(41).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLAUSULA_3__ no fue especificado."
                End If

                '***** Valido el quinto MIN (62,70,59,50,42) *****
                If (.Cells(62).Value IsNot Nothing AndAlso .Cells(62).Value.ToString.Trim.Length > 0) Or _
                (.Cells(70).Value IsNot Nothing AndAlso .Cells(70).Value.ToString.Trim.Length > 0) Or _
                (.Cells(59).Value IsNot Nothing AndAlso .Cells(59).Value.ToString.Trim.Length > 0) Or _
                (.Cells(50).Value IsNot Nothing AndAlso .Cells(50).Value.ToString.Trim.Length > 0) Or _
                (.Cells(42).Value IsNot Nothing AndAlso .Cells(42).Value.ToString.Trim.Length > 0) Then
                    If Not (.Cells(62).Value IsNot Nothing AndAlso .Cells(62).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del MIN_5 no fue especificado."
                    If Not (.Cells(70).Value IsNot Nothing AndAlso .Cells(70).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO no fue especificado."
                    If Not (.Cells(59).Value IsNot Nothing AndAlso .Cells(59).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del ACTIVA_EQUIPO_5_ no fue especificado."
                    If Not (.Cells(50).Value IsNot Nothing AndAlso .Cells(50).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del VALOR_EQUIPO_IVA_5 no fue especificado."
                    If Not (.Cells(42).Value IsNot Nothing AndAlso .Cells(42).Value.ToString.Trim.Length > 0) Then mensaje &= " El valor del CLAUSULA_4___ no fue especificado."
                End If
            Else
                mensaje = " El número de columnas no es correcto."
            End If
        End With
        If mensaje <> "" Then retorno = False

        Return retorno
    End Function

    Private Function AdicionarServicio(ByVal tipoServicio As Integer, ByVal numeroRadicado As Long, ByVal fechaVencimientoReserva As String, ByVal usuarioEjecutor As String, _
                                       ByVal nombreCliente As String, ByVal custCode As String, ByVal identificacionCliente As String, ByVal barrioEntrega As String, ByVal direccionEntrega As String, _
                                       ByVal fechaRegistro As String, ByVal clienteVIP As String, ByVal planActual As String, ByVal observaciones As String, _
                                       ByVal minAfectado As String, ByVal activaEquipoAnterior As String, ByVal comSeguro As String, ByVal precioConIva As String, _
                                       ByVal clausula As String, ByVal adjuntaArchivo As String, ByVal ciudad As String, ByVal telefonoContacto As String, ByVal personaContacto As String) As String
        Dim dtDetalle As DataTable
        Dim nuevaFila As DataRow
        Dim campos As CamposDtCorrecto
        Dim mensaje As String = ""

        Try
            dtDetalle = EstructuraCorrecto()

            If Not dtDetalle Is Nothing Then
                nuevaFila = dtDetalle.NewRow()
                campos = ObtenerCampos()
                nuevaFila(campos.TipoServicio.Caption) = tipoServicio
                nuevaFila(campos.NumeroRadicado.Caption) = numeroRadicado
                nuevaFila(campos.Prioridad.Caption) = 2
                nuevaFila(campos.FechaVencimientoReserva.Caption) = fechaVencimientoReserva
                nuevaFila(campos.UsuarioEjecutor.Caption) = usuarioEjecutor
                nuevaFila(campos.NombreCliente.Caption) = nombreCliente
                nuevaFila(campos.PersonaContacto.Caption) = personaContacto
                nuevaFila(campos.CustCode.Caption) = custCode
                nuevaFila(campos.IdentificacionCliente.Caption) = identificacionCliente
                Dim ciudadObj As New CiudadCargueServicioMensajeria(ciudad)
                nuevaFila(campos.CiudadEntrega.Caption) = ciudadObj.IdCiudadEquivalente
                nuevaFila(campos.BarrioEntrega.Caption) = barrioEntrega
                nuevaFila(campos.DireccionEntrega.Caption) = direccionEntrega
                nuevaFila(campos.TelefonoContacto.Caption) = telefonoContacto
                nuevaFila(campos.FechaRegistro.Caption) = fechaRegistro
                nuevaFila(campos.ClienteVIP.Caption) = ObtenerBoolean(clienteVIP)
                nuevaFila(campos.PlanActual.Caption) = planActual
                nuevaFila(campos.Observaciones.Caption) = observaciones
                nuevaFila(campos.MinAfectado.Caption) = minAfectado
                nuevaFila(campos.Material.Caption) = ""
                nuevaFila(campos.ActivaEquipoAnterior.Caption) = ObtenerBoolean(activaEquipoAnterior)
                nuevaFila(campos.ComSeguro.Caption) = ObtenerBoolean(comSeguro)
                Dim precioSinIva As Double
                Dim iva As Integer
                Integer.TryParse(MetodosComunes.seleccionarConfigValue("VALOR_IVA_SERVICIO").ToString(), iva)
                precioConIva = precioConIva.Replace("$", "").Replace(" ", "")
                If precioConIva = "" Or precioConIva = "" Then
                    precioSinIva = 0
                Else
                    precioSinIva = (precioConIva - ((precioConIva * iva) / 100))
                End If
                nuevaFila(campos.PrecioSinIva.Caption) = precioSinIva
                nuevaFila(campos.PrecioConIva.Caption) = precioConIva
                Dim clausulaObj As DictionaryEntry
                clausulaObj = MensajeriaEspecializada.HerramientasMensajeria.ConsultaClausula(clausula)
                nuevaFila(campos.Clausula.Caption) = clausulaObj.Key
                nuevaFila(campos.AdjuntaArchivo.Caption) = ObtenerBoolean(adjuntaArchivo)
                dtDetalle.Rows.Add(nuevaFila)
                mensaje = "Detalle adicionado."
            End If

        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
        Return mensaje
    End Function

    Private Function ObtenerBoolean(ByVal valor As String) As Boolean

        If valor.ToUpper = "NO" Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Function EstructuraCorrecto() As DataTable
        Dim dt As New DataTable()
        Try
            If (Not Session("dtCorrecto") Is Nothing) Then
                dt = CType(Session("dtCorrecto"), DataTable)
            Else
                'TIPO DE SERVICIO (ESTANDARIZADO)	NÚMERO DE RADICADO	PRIORIDAD (ESTANDARIZADA)	FECHA VENCIMIENTO RESERVA	USUARIO EJECUTOR	NOMBRE CLIENTE	CUSTCODE	IDENTIFICACIÓN DEL CLIENTE (NUMERO DE CEDULA O NIT)	CIUDAD ENTREGA (ESTANDARIZADO)	BARRIO ENTREGA	DIRECCIÓN ENTREGA	FECHA DE REGISTRO	CLIENTE VIP (S/N)	PLAN ACTUAL	OBSERVACIONES	MIN AFECTADO	MATERIAL REFERENCIA REQUERIDA	ACTIVA EQUIPO ANTERIOR S/N)	COMSEGURO (S/N)	PRECIO SIN IVA	PRECIO CON IVA	CLAUSULA (ESTANDARIZADO)	ADJUNTA ARCHIVO S/N
                Dim campos As CamposDtCorrecto
                campos = ObtenerCampos()
                campos.CrearCampos()
                With dt.Columns
                    .Add(campos.TipoServicio)
                    .Add(campos.NumeroRadicado)
                    .Add(campos.Prioridad)
                    .Add(campos.FechaVencimientoReserva)
                    .Add(campos.UsuarioEjecutor)
                    .Add(campos.NombreCliente)
                    .Add(campos.PersonaContacto)
                    .Add(campos.CustCode)
                    .Add(campos.IdentificacionCliente)
                    .Add(campos.CiudadEntrega)
                    .Add(campos.BarrioEntrega)
                    .Add(campos.TelefonoContacto)
                    .Add(campos.DireccionEntrega)
                    .Add(campos.FechaRegistro)
                    .Add(campos.ClienteVIP)
                    .Add(campos.PlanActual)
                    .Add(campos.Observaciones)
                    .Add(campos.MinAfectado)
                    .Add(campos.Material)
                    .Add(campos.ActivaEquipoAnterior)
                    .Add(campos.ComSeguro)
                    .Add(campos.PrecioSinIva)
                    .Add(campos.PrecioConIva)
                    .Add(campos.Clausula)
                    .Add(campos.AdjuntaArchivo)
                End With
                Session("dtCorrecto") = dt
            End If
        Catch ex As Exception
            Throw New Exception("Error al obtener la estructura de cargue. " & ex.Message)
        End Try
        Return dt
    End Function

    Protected Shared Function CrearColumnaCorrecto(ByVal titulo As String, ByVal nombre As String, ByVal tipo As Type, ByVal permiteNulo As Boolean, Optional ByVal valorPorDefecto As Object = Nothing) As DataColumn
        Dim columna As New DataColumn()
        Try
            With columna
                .AllowDBNull = permiteNulo
                If (Not valorPorDefecto Is Nothing) Then .DefaultValue = valorPorDefecto
                .DataType = tipo
                .Caption = titulo
                .ColumnName = nombre
            End With
        Catch ex As Exception
            Throw New Exception("Error al crear la columna. " & ex.Message)
        End Try
        Return columna
    End Function

#End Region

#Region "Metodos para manejo de errores"

    Private Function EstructuraErrores() As DataTable
        Dim dt As New DataTable("Errores")
        Try
            If (Session("dtErrores") Is Nothing) Then
                Dim linea As New DataColumn()
                With linea
                    .AllowDBNull = False
                    .DataType = GetType(Integer)
                    .Caption = "Linea"
                    .ColumnName = "linea"
                End With
                dt.Columns.Add(linea)
                Dim descripcion As New DataColumn()
                With descripcion
                    .AllowDBNull = False
                    .DataType = GetType(String)
                    .Caption = "Descripcion"
                    .ColumnName = "descripcion"
                End With
                dt.Columns.Add(descripcion)
                Session("dtErrores") = dt
            Else
                dt = CType(Session("dtErrores"), DataTable)
            End If
        Catch ex As Exception
            Throw New Exception("Error al crear la estructura de errores. " & ex.Message)
        End Try
        Return dt
    End Function

    Private Function EstructuraResultadoCorrectos() As DataTable
        Dim dt As New DataTable("ResultadoCorrectos")
        Try
            If (Session("dtResultadoCorrectos") Is Nothing) Then
                Dim linea As New DataColumn()
                With linea
                    .AllowDBNull = False
                    .DataType = GetType(Integer)
                    .Caption = "Linea"
                    .ColumnName = "linea"
                End With
                dt.Columns.Add(linea)
                Dim descripcion As New DataColumn()
                With descripcion
                    .AllowDBNull = False
                    .DataType = GetType(String)
                    .Caption = "Descripcion"
                    .ColumnName = "descripcion"
                End With
                dt.Columns.Add(descripcion)
                Session("dtResultadoCorrectos") = dt
            Else
                dt = CType(Session("dtResultadoCorrectos"), DataTable)
            End If
        Catch ex As Exception
            Throw New Exception("Error al crear la estructura de Resultado Correctos. " & ex.Message)
        End Try
        Return dt
    End Function

    Private Sub LimpiarDtErrores()
        Try
            Dim dt As New DataTable
            dt = EstructuraErrores()
            dt.Rows.Clear()
        Catch ex As Exception
            Throw New Exception("Error al limpiar la tabla de errores. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarDtResultadoCorrectos()
        Try
            Dim dt As New DataTable
            dt = EstructuraResultadoCorrectos()
            dt.Rows.Clear()
        Catch ex As Exception
            Throw New Exception("Error al limpiar la tabla de errores. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarDtCorrecto()
        Try
            Dim dt As New DataTable
            dt = EstructuraCorrecto()
            dt.Rows.Clear()
        Catch ex As Exception
            Throw New Exception("Error al limpiar la tabla. " & ex.Message)
        End Try
    End Sub

    Private Sub InsertarError(ByVal linea As Integer, ByVal descripcion As String)
        Try
            Dim dt As DataTable
            dt = EstructuraErrores()
            If (Not dt Is Nothing) Then
                Dim nuevaFila As DataRow
                nuevaFila = dt.NewRow()
                nuevaFila("linea") = linea
                nuevaFila("descripcion") = descripcion
                dt.Rows.Add(nuevaFila)
            End If
        Catch ex As Exception
            Throw New Exception("Error al ingresar el error. " & ex.Message)
        End Try
    End Sub

    Private Sub InsertarCorrecto(ByVal linea As Integer, ByVal descripcion As String)
        Try
            Dim dt As DataTable
            dt = EstructuraResultadoCorrectos()
            If (Not dt Is Nothing) Then
                Dim nuevaFila As DataRow
                nuevaFila = dt.NewRow()
                nuevaFila("linea") = linea
                nuevaFila("descripcion") = descripcion
                dt.Rows.Add(nuevaFila)
            End If
        Catch ex As Exception
            Throw New Exception("Error al ingresar el correcto. " & ex.Message)
        End Try
    End Sub

    Private Function ObtenerCampos() As CamposDtCorrecto
        Dim campos As CamposDtCorrecto
        Try
            If (Session("CamposDtCorrecto") Is Nothing) Then
                campos = New CamposDtCorrecto()
                campos.CrearCampos()
                Session("CamposDtCorrecto") = campos
            Else
                campos = CType(Session("CamposDtCorrecto"), CamposDtCorrecto)
            End If
        Catch ex As Exception
            Throw New Exception("Error al obtener los campos. " & ex.Message)
        End Try
        Return campos
    End Function

#End Region

#Region "Estructuras"

    Private Structure CamposDtCorrecto
        Dim TipoServicio As DataColumn
        Dim NumeroRadicado As DataColumn
        Dim Prioridad As DataColumn
        Dim FechaVencimientoReserva As DataColumn
        Dim UsuarioEjecutor As DataColumn
        Dim NombreCliente As DataColumn
        Dim PersonaContacto As DataColumn
        Dim CustCode As DataColumn
        Dim IdentificacionCliente As DataColumn
        Dim CiudadEntrega As DataColumn
        Dim BarrioEntrega As DataColumn
        Dim DireccionEntrega As DataColumn
        Dim TelefonoContacto As DataColumn
        Dim FechaRegistro As DataColumn
        Dim ClienteVIP As DataColumn
        Dim PlanActual As DataColumn
        Dim Observaciones As DataColumn
        Dim MinAfectado As DataColumn
        Dim Material As DataColumn
        Dim ActivaEquipoAnterior As DataColumn
        Dim ComSeguro As DataColumn
        Dim PrecioSinIva As DataColumn
        Dim PrecioConIva As DataColumn
        Dim Clausula As DataColumn
        Dim AdjuntaArchivo As DataColumn

        Public Sub CrearCampos()
            TipoServicio = CrearColumnaCorrecto("TipoServicio", "tipoServicio", GetType(Integer), False)
            NumeroRadicado = CrearColumnaCorrecto("NumeroRadicado", "numeroRadicado", GetType(Long), False)
            Prioridad = CrearColumnaCorrecto("Prioridad", "prioridad", GetType(Integer), False)
            FechaVencimientoReserva = CrearColumnaCorrecto("FechaVencimientoReserva", "fechaVencimientoReserva", GetType(String), True)
            UsuarioEjecutor = CrearColumnaCorrecto("UsuarioEjecutor", "usuarioEjecutor", GetType(String), False)
            NombreCliente = CrearColumnaCorrecto("NombreCliente", "nombreCliente", GetType(String), False)
            PersonaContacto = CrearColumnaCorrecto("PersonaContacto", "personaContacto", GetType(String), False)
            CustCode = CrearColumnaCorrecto("CustCode", "custCode", GetType(String), False)
            IdentificacionCliente = CrearColumnaCorrecto("IdentificacionCliente", "identificacionCliente", GetType(Long), False)
            CiudadEntrega = CrearColumnaCorrecto("CiudadEntrega", "ciudadEntrega", GetType(Integer), False)
            BarrioEntrega = CrearColumnaCorrecto("BarrioEntrega", "barrioEntrega", GetType(String), False)
            DireccionEntrega = CrearColumnaCorrecto("DireccionEntrega", "direccionEntrega", GetType(String), False)
            TelefonoContacto = CrearColumnaCorrecto("TelefonoContacto", "telefonoContacto", GetType(String), True)
            FechaRegistro = CrearColumnaCorrecto("FechaRegistro", "fechaRegistro", GetType(Date), False)
            ClienteVIP = CrearColumnaCorrecto("ClienteVIP", "clienteVIP", GetType(String), False)
            PlanActual = CrearColumnaCorrecto("PlanActual", "planActual", GetType(String), False)
            Observaciones = CrearColumnaCorrecto("Observaciones", "observaciones", GetType(String), False)
            MinAfectado = CrearColumnaCorrecto("MinAfectado", "minAfectado", GetType(Long), False)
            Material = CrearColumnaCorrecto("Material", "material", GetType(String), False)
            ActivaEquipoAnterior = CrearColumnaCorrecto("ActivaEquipoAnterior", "activaEquipoAnterior", GetType(Boolean), False)
            ComSeguro = CrearColumnaCorrecto("ComSeguro", "comSeguro", GetType(Boolean), False)
            PrecioSinIva = CrearColumnaCorrecto("PrecioSinIva", "precioSinIva", GetType(Double), False)
            PrecioConIva = CrearColumnaCorrecto("PrecioConIva", "precioConIva", GetType(Double), False)
            Clausula = CrearColumnaCorrecto("Clausula", "Clausula", GetType(Integer), False)
            AdjuntaArchivo = CrearColumnaCorrecto("AdjuntaArchivo", "adjuntaArchivo", GetType(Boolean), False)
        End Sub

    End Structure

    Private Enum TipoArchivo
        General = 1
        Corporativo = 2
    End Enum

#End Region

End Class