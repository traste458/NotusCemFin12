Imports System.Security.Claims
Imports System.Net.Mail
Imports System.IO
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer
Imports System.Text
Imports System.Text.RegularExpressions
Imports DevExpress.Web
Imports LumenWorks.Framework.IO.Csv
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Estructuras

Public Class CreacionMotorizados
    Inherits System.Web.UI.Page
    Private oExcel As ExcelFile

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 20608  '2009
        Session("usxp009") = 180  '185
        Session("usxp007") = 150
        Session("usxp014") = "192.127.62.1"
#End If

        Seguridad.verificarSession(Me)

        Try
            If Not Me.IsPostBack Then
                With epPrincipal
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administracion De Usuarios Motorizados")
                End With
                gvErrorSeriales.ClientVisible = False
                Session.Remove("dtFabricantes")
                Session.Remove("dtPerfiles")
                Session.Remove("dtDatosCargados")
                Session.Remove("dtUsuariosMotorizado")
                cargarCiudades()
                cargarPerfiles()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar los datos: " & ex.Message)
        End Try

    End Sub

    Protected Sub Link_Init_Eliminar(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idtercero As Integer

            Dim linkDesactivar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkDesactivar.NamingContainer, GridViewDataItemTemplateContainer)
            linkDesactivar.ClientSideEvents.Click = linkDesactivar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            Dim idestado As Integer
            idestado = CInt(templateContainer.Grid.GetRowValues(templateContainer.VisibleIndex, "idEstado").ToString())
            If idestado = 1 Then
                linkDesactivar.Visible = True
            Else
                linkDesactivar.Visible = False
            End If
            idtercero = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtercero"))

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idtercero As Integer

            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idtercero = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtercero"))

            Dim idestado As Integer
            idestado = CInt(templateContainer.Grid.GetRowValues(templateContainer.VisibleIndex, "idEstado").ToString())

            If idestado = 2 Then
                linkEditar.Visible = False
            Else
                linkEditar.Visible = True
            End If

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Protected Sub Link_Init_Activar(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idtercero As Integer

            Dim linkActivar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkActivar.NamingContainer, GridViewDataItemTemplateContainer)
            linkActivar.ClientSideEvents.Click = linkActivar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idtercero = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtercero"))

            Dim idestado As Integer
            idestado = CInt(templateContainer.Grid.GetRowValues(templateContainer.VisibleIndex, "idEstado").ToString())
            If idestado = 2 Then
                linkActivar.Visible = True

            Else
                linkActivar.Visible = False
            End If

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Private Sub cargarCiudades()
        Dim dtCiudades As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtCiudades = objBod.ObtenerCiudadSinBodega()
            Session("dtCiudades") = dtCiudades
            MetodosComunes.CargarComboDXSinSeleccione(cmbCiudades, dtCiudades, "idCiudad", "ciudad")
            MetodosComunes.CargarComboDXSinSeleccione(cmbCiudadEditar, dtCiudades, "idCiudad", "ciudad")
        Catch ex As Exception

        End Try
    End Sub

    Private Sub cargarPerfiles()
        Dim dtPerfiles As New DataTable
        Dim objBod As New CreacionMotorizado
        Try
            Dim idperfilCombo As Comunes.ConfigValues = New Comunes.ConfigValues("PERFILES_CONSULTA_MOTORIZADOS")
            dtPerfiles = objBod.ConsultarPerfiles(idperfilCombo.ConfigKeyValue)
            Session("dtcmbPerfiesEditar") = dtPerfiles
            MetodosComunes.CargarComboDXSinSeleccione(cmbPerfiles, dtPerfiles, "idperfil", "perfil")
            MetodosComunes.CargarComboDXSinSeleccione(cmbPerfilesEditar, dtPerfiles, "idperfil", "perfil")
            MetodosComunes.CargarComboDXSinSeleccione(cmbPerfilesMasivo, dtPerfiles, "idperfil", "perfil")

        Catch ex As Exception

        End Try
    End Sub


    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        epPrincipal.clear()
        Try

            Dim accion As String
            Dim parametro As String
            Dim cadena As String() = e.Parameter.ToString().Split(New Char() {":"})
            accion = cadena(0)
            parametro = cadena(1)
            Select Case accion
                Case "ConsultarInformacion"
                    epPrincipal.clear()
                    cargarDatos()
                Case "desabilitar"
                    Dim objEditar As New CreacionMotorizado
                    epPrincipal.clear()
                    With objEditar
                        .idTercero = Session("IdUsuario")
                        .idUsuario = Session("usxp001")
                        .Observacion = txtObservacion.Text
                        resultado = .DesactivarTercero(.idUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos()
                        pcEditar.ShowOnPageLoad = False
                    ElseIf resultado.Valor = 1 Then
                        epPrincipal.showError(resultado.Mensaje)
                    Else
                        epPrincipal.showError(resultado.Mensaje)
                    End If
                Case "habilitar"
                    Dim objEditar As New CreacionMotorizado
                    epPrincipal.clear()
                    With objEditar
                        .idTercero = Session("IdUsuario")
                        .idUsuario = Session("usxp001")
                        .Observacion = txtObservacion.Text
                        resultado = .HabilitarTercero(.idUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos()
                        pcEditar.ShowOnPageLoad = False
                    ElseIf resultado.Valor = 1 Then

                    Else
                        epPrincipal.showError(resultado.Mensaje)
                    End If
                Case "modificar"
                    Dim objModificar As New CreacionMotorizado
                    epPrincipal.clear()
                    With objModificar
                        .idTercero = Session("idTercero")
                        .idUsuario = Session("usxp001")
                        .NombreCompleto = txtNombreEditar.Text.Trim
                        .Identificacion = txtCedulaEditar.Text.Trim
                        .idperfil = cmbPerfilesEditar.Value
                        .IdCiudad = cmbCiudadEditar.Value
                        .Placa = txtPlaca.Text.Trim
                        .idDriver = CInt(txtIdDriver.Text.Trim())
                        resultado = .ModificarTercero(.idUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos()
                        pcEditarTercero.ShowOnPageLoad = False
                    ElseIf resultado.Valor <> 0 Then
                        EncabezadoPop.showError(resultado.Mensaje)
                        btnCrearUsuario.Visible = False
                    End If
                Case "Crear"
                    Dim objModificar As New CreacionMotorizado
                    Dim idTerceroUsuario As Integer
                    epPrincipal.clear()
                    With objModificar
                        .idTercero = Session("idTercero")
                        .idUsuario = Session("usxp001")
                        .NombreCompleto = txtNombreEditar.Text.Trim
                        .Identificacion = txtCedulaEditar.Text.Trim
                        .idperfil = cmbPerfilesEditar.Value
                        .IdCiudad = cmbCiudadEditar.Value
                        .Placa = txtPlaca.Text.Trim
                        .idDriver = CInt(txtIdDriver.Text.Trim())
                        resultado = .CrearMotorizado(idTerceroUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos(idTerceroUsuario)
                        pcEditarTercero.ShowOnPageLoad = False
                    ElseIf resultado.Valor <> 0 Then
                        EncabezadoPop.showError(resultado.Mensaje)
                        btnModificar.Visible = False
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            cpGeneral.JSProperties("cpMensajePop") = EncabezadoPop.RenderHtml
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub

    Private Sub cargarDatos(Optional ByVal idTerceroCreado As Integer = 0)
        Dim objMatriz As New CreacionMotorizado
        Try
            With objMatriz
                .idperfil = cmbPerfiles.Value
                .IdCiudad = cmbCiudades.Value
                .Identificacion = txtCedula.Text.Trim
                .Usuario = txtUsuario.Text.Trim
                .NombreCompleto = txtNombreApellido.Text.Trim
                .idTerceroCreado = idTerceroCreado
                Session("dtResultados") = .listarUsuarios
            End With
            If Session("dtResultados").Rows.Count > 0 Then
                With gvDetalle
                    .DataSource = CType(Session("dtResultados"), DataTable)
                    .DataBind()
                End With
            Else
                With gvDetalle
                    .DataSource = CType(Session("dtResultados"), DataTable)
                    .DataBind()
                End With
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub


    Private Sub gvDetalle_DataBinding(sender As Object, e As EventArgs) Handles gvDetalle.DataBinding
        If Session("dtResultados") IsNot Nothing Then gvDetalle.DataSource = CType(Session("dtResultados"), DataTable)
    End Sub

    Private Sub pcEditar_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEditar.WindowCallback
        txtObservacion.Text = Nothing
        Dim arrAccion As String()
        Dim parametro As String = e.Parameter.ToString
        arrAccion = e.Parameter.Split(":")
        CargarInformacionUsuario(CInt(arrAccion(0)))
    End Sub

    Private Sub pcEditarTercero_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEditarTercero.WindowCallback
        Try

            Dim accion As String
            Dim idperfilUsuario As Integer
            Dim parametro As String
            Dim cadena As String() = e.Parameter.ToString().Split(New Char() {":"})
            accion = cadena(1)
            parametro = cadena(0)
            'Dim arrAccion As String()
            'Dim parametro As String = e.Parameter.ToString
            'arrAccion = e.Parameter.Split(":")
            Dim objMatriz As New CreacionMotorizado
            Session("idTercero") = CInt(parametro)
            Select Case accion
                Case 1
                    btnCrearUsuario.Visible = False
                    With objMatriz
                        txtNombreEditar.Text = Nothing
                        txtCedulaEditar.Text = Nothing
                        txtPlaca.Text = Nothing
                        txtIdDriver.Text = Nothing
                        .CargarInformacionMotorizado(Session("idTercero"))
                        txtNombreEditar.Text = objMatriz.NombreCompleto
                        txtCedulaEditar.Text = objMatriz.Identificacion
                        txtPlaca.Text = objMatriz.Placa
                        cmbPerfilesEditar.Value = CInt(objMatriz.idperfil)
                        cmbCiudadEditar.Value = objMatriz.IdCiudad
                        txtIdDriver.Value = objMatriz.idDriver
                    End With
                Case 2
                    btnModificar.Visible = False
                    epPrincipal.clear()
                    cmbPerfilesEditar.Value = Nothing
                    cmbCiudadEditar.Value = Nothing
                    txtCedulaEditar.Text = Nothing
                    txtNombreEditar.Text = Nothing
                    txtPlaca.Text = Nothing
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionUsuario(ByVal idUsuarioNotificacion As Integer)
        Dim objMatriz As New CreacionMotorizado
        Session("IdUsuario") = idUsuarioNotificacion
        Try
            With objMatriz
                .idUsuario = idUsuarioNotificacion
                .listarUsuarios()
                txtNombre.Text = .listarUsuarios.Rows(0).Item(2).ToString
                txtIdUsuario.Text = .listarUsuarios.Rows(0).Item(0).ToString
                Dim estado As String = .listarUsuarios.Rows(0).Item(5).ToString
                If estado = "Activo" Then
                    btnAnular.Enabled = True
                    btnReactivar.Visible = False
                Else
                    btnAnular.Visible = False
                    btnReactivar.Enabled = True
                End If
            End With
        Catch ex As Exception
            Throw ex
        End Try

    End Sub


    Protected Sub cbFormatoExportar_ButtonClick(source As Object, e As ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            Dim fecha As DateTime = DateTime.Now
            Dim fec As String = fecha.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim nombre As String = "DatosUsuarios"
            nombre = nombre & "_" & Session("usxp001") & "_" & fec & ".xlsx"
            If Session("dtResultados") IsNot Nothing AndAlso CType(Session("dtResultados"), DataTable).Rows.Count > 0 Then
                Dim gvDetalle As DataView = CType(Session("dtResultados"), DataTable).DefaultView
                Dim dtDatos As DataTable = gvDetalle.ToTable(False, "idtercero", "cedula", "nombre", "usuario", "perfil", "ciudad", "estado", "Placa", "IdDriver")
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, nombre, Server.MapPath("../archivos_planos/" & nombre), )
            Else
                epPrincipal.showError("No se encontraron datos para exportar, por favor intente nuevamente.")
            End If

        Catch ex As Exception
            epPrincipal.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub

    Protected Sub cmbPerfiesEditar_DataBinding(sender As Object, e As EventArgs) Handles cmbPerfilesEditar.DataBinding
        If Session("dtcmbPerfiesEditar") IsNot Nothing Then cmbPerfilesEditar.DataSource = Session("dtcmbPerfiesEditar")
    End Sub

    Protected Sub btnCargarDatos_Click(sender As Object, e As EventArgs) Handles btnCargarDatos.Click
        If upArchivoSerial.FileName = "" Then
            epPrincipal.showError("Debe seleccionar un archivo")
        End If
    End Sub

    Protected Sub upArchivoSerial_FileUploadComplete(sender As Object, e As DevExpress.Web.FileUploadCompleteEventArgs) Handles upArchivoSerial.FileUploadComplete

        If upArchivoSerial.HasFile Then
            ProcesarArchivoSerial(e.UploadedFile)
            aspLabelSerial.Text = e.UploadedFile.FileName.ToString
        Else
            epPrincipal.showWarning("Debe seleccionar el archivo a cargar")
        End If
    End Sub

    Private Sub ProcesarArchivoSerial(upLoadedFile As UploadedFile)
        Try
            Dim objBodegaSatelite As New CreacionMotorizado
            Dim filtro As New FiltrosOrdenRecepcionSatelite
            MetodosComunes.setGemBoxLicense()
            Dim dtMotorizados As New DataTable()
            Dim resultado As New ResultadoProceso
            Dim fec As String = DateTime.Now.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim validacionArchivo As New ResultadoProceso
            epPrincipal.clear()



            If upLoadedFile.ContentLength <= 10485760 Then
                If upLoadedFile.FileName <> "" Then
                    Dim miExcel As New ExcelFile
                    Dim fileExtension As String = Path.GetExtension(upLoadedFile.FileName)
                    If (fileExtension <> "") Then
                        fileExtension = fileExtension.ToUpper()
                    End If

                    Try
                        Select Case fileExtension
                            Case ".XLS"
                                miExcel.LoadXls(upLoadedFile.FileContent)
                            Case ".XLSX"
                                miExcel.LoadXlsx(upLoadedFile.FileContent, XlsxOptions.None)
                            Case Else
                                epPrincipal.showError("Extensión de archivo no permitida.")
                                Exit Select
                        End Select
                    Catch ex As Exception
                        Throw New Exception("El archivo esta incorrecto o no tiene el formato esperado. Por favor verifique: " & ex.Message)
                    End Try

                    If miExcel.Worksheets.Count = 2 Then
                        Dim oWsInfogenera As ExcelWorksheet = miExcel.Worksheets.Item(0)
                        Dim extencion As String = Path.GetExtension(upLoadedFile.FileName).ToLower
                        If extencion = ".xls" Or extencion = ".xlsx" Then
                            If oWsInfogenera.CalculateMaxUsedColumns() <> 5 Then
                                If oWsInfogenera.CalculateMaxUsedColumns() > 5 Then
                                    epPrincipal.showError("El archivo tiene mas columnas de las requeridas: " & oWsInfogenera.CalculateMaxUsedColumns().ToString())
                                Else
                                    epPrincipal.showError("El archivo tiene menos columnas de las requeridas: " & oWsInfogenera.CalculateMaxUsedColumns().ToString())
                                End If
                                Exit Sub
                            End If
                        End If


                        Dim filaInicial As Integer = oWsInfogenera.Cells.FirstRowIndex
                        Dim columnaInicial As Integer = oWsInfogenera.Cells.FirstColumnIndex
                        dtMotorizados = CrearEstructuraInfoMotorizados()

                        AddHandler oWsInfogenera.ExtractDataEvent, AddressOf ExtractDataErrorHandler
                        oWsInfogenera.ExtractToDataTable(dtMotorizados, oWsInfogenera.Rows.Count, ExtractDataOptions.SkipEmptyRows,
                                    oWsInfogenera.Rows(filaInicial + 1), oWsInfogenera.Columns(columnaInicial))

                        dtMotorizados.Columns.Add(New DataColumn("fila"))
                        Dim fil As Integer = 1
                        For Each row As DataRow In dtMotorizados.Rows
                            row("fila") = fil
                            fil = fil + 1
                        Next

                        objBodegaSatelite.idperfil = cmbPerfilesMasivo.Value
                        objBodegaSatelite.idUsuario = Session("usxp001")

                        dtMotorizados.Columns.Add(New DataColumn("IdPerfil", GetType(System.Int64), cmbPerfilesMasivo.Value))
                        dtMotorizados.AcceptChanges()
                        dtMotorizados.Columns.Add(New DataColumn("idUsuario", GetType(System.Int64), Session("usxp001")))
                        dtMotorizados.AcceptChanges()

                        Session("dtDatosCargados") = dtMotorizados




                        If fnValidarDatosCargados() = False Then
                            Exit Sub
                        End If

                        Session("dtUsuariosMotorizado") = objBodegaSatelite.CargarMasivoMotorizado(dtMotorizados)

                        resultado = objBodegaSatelite.resultado

                        If (resultado.Valor = 0) Then
                            epPrincipal.showSuccess(resultado.Mensaje)
                            gvErrorSeriales.ClientVisible = False
                        Else
                            epPrincipal.showWarning(resultado.Mensaje)
                            gvErrorSeriales.ClientVisible = True
                            gvErrorSeriales.DataSource = CType(Session("dtUsuariosMotorizado"), DataTable)
                            gvErrorSeriales.DataBind()
                        End If
                    End If
                Else
                    epPrincipal.showError("Debe seleccionar un archivo")
                End If

            End If
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
        'Try
    End Sub

    Private Sub ValidarInformacionArchivo(ByVal dtMotorizados As DataTable)
        For Each row As DataRow In dtMotorizados.Rows
            If Not (IsNumeric(row("idDriver"))) Then
                ''gvErrorSeriales(row("Fila"), "El (Correo) tiene formato inválido por favor verificar")
            End If
        Next
    End Sub

    Private Function CrearEstructuraInfoMotorizados() As DataTable
        Dim dtAux As New DataTable

        With dtAux.Columns
            dtAux.Columns.Add("NombreCompleto", GetType(String))
            dtAux.Columns.Add("Identificacion", GetType(String))
            dtAux.Columns.Add("Placa", GetType(String))
            dtAux.Columns.Add("Ciudad", GetType(String))
            dtAux.Columns.Add("idDriver", GetType(Integer))
        End With
        Return dtAux
    End Function

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

    Function fnValidarDatosCargados() As Boolean
        Dim xrows() As DataRow = CType(Session("dtDatosCargados"), DataTable).Select("NombreCompleto is null or Identificacion is null or Placa is null or idDriver is null")
        If xrows.Length > 0 Then
            epPrincipal.showWarning("se encontro un campo vacio en el archivo, por favor valdiar")
            Return False
        End If
        Return True
    End Function

End Class