Imports System.Collections.Generic
Imports System.IO
Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class PoolCrearVisitasSimpliRoute
    Inherits System.Web.UI.Page

#Region "Propiedades"
    Private Property _nombreArchivo As String
    Dim dtCargue As New DataTable()
    Private oExcel As ExcelFile
    Dim regExp As New System.Text.RegularExpressions.Regex("([0-9]{15}|[0-9]{17})")
    Dim filaInicial As Integer
    Dim columnaInicial As Integer
    Dim numColumnas As Integer

#End Region

#Region "Load"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.miEncabezado.clear()
        Seguridad.verificarSession(Me)
        If Not IsPostBack And Not IsCallback Then
            miEncabezado.setTitle("Pool Crear Visitas")
            Try

                CargarCombos()

            Catch ex As Exception
                miEncabezado.showError("Error al cargar Combos: " & ex.Message)
            End Try
        ElseIf IsCallback Then
            gvDatos.DataBind()
            If ddlBodega.IsCallback OrElse ddlBodega.GridView.IsCallback OrElse Not Me.IsPostBack Then CargarBodegas()
            If ddlTipoServicio.IsCallback OrElse ddlTipoServicio.GridView.IsCallback OrElse Not Me.IsPostBack Then CargarTiposServicio()
            cmbCiudad.DataBind()
            cmbJornada.DataBind()
        End If

        MetodosComunes.setGemBoxLicense()

    End Sub

#End Region

#Region "CallBack"
    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        Dim accion() As String
        accion = e.Parameter.Split("|")
        CType(sender, ASPxCallbackPanel).JSProperties("cpNovedadesCallBack") = ""

        Select Case accion(0)
            Case "1"
                Try
                    CargarServiciosListosParaVisita()
                Catch ex As Exception
                    miEncabezado.showError("Error al consultar los servicios  listos para visitas: " & ex.Message)
                End Try
            Case "2"
                CargarBodegas()
            Case "3"
                LimpiarFiltros()
            Case "4"
                If CType(Session("dtErrores"), DataTable).Rows.Count > 0 Then
                    cperrores.Visible = True
                    gvErrores.DataSource = CType(Session("dtErrores"), DataTable)
                    gvErrores.DataBind()
                    CType(sender, ASPxCallbackPanel).JSProperties("cpNovedadesCallBack") = "MostrarNovedades"
                End If
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select

        cpGeneral.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Dim arrAccion As String()


        Session("ver") = 0
        Try
            If e.Parameters.Length > 0 Then
                Dim dtDatos As New DataTable
                Dim fieldValues As List(Of Object) = gvDatos.GetSelectedFieldValues(New String() {"idServicioMensajeria"})
                dtDatos = ConvertToDataTable(fieldValues)

                CType(sender, ASPxGridView).JSProperties("cpReportesVer") = 0
                arrAccion = e.Parameters.Split("|")
                Select Case arrAccion(1)

                    Case "CrearVisitas"
                        miEncabezado.clear()
                        Dim resultadoProceso As New ResultadoProceso
                        resultadoProceso = ProcesarVisitas(dtDatos)
                        CType(sender, ASPxGridView).JSProperties("cpIdUsuario") = Session("usxp001")
                        If resultadoProceso.Valor = 1 Then
                            miEncabezado.showSuccess("Informacion Procesada")
                        End If

                        If CType(Session("dtErrores"), DataTable).Rows.Count > 0 Then
                            CType(sender, ASPxGridView).JSProperties("cpNovedades") = "MostrarNovedades"
                        End If
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")
                End Select
            End If
            CargarServiciosListosParaVisita()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar datos de visita: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "cargue de pool"
    Private Sub LimpiarFiltros()
        deFechaFinal.Text = ""
        deFechaInicial.Text = ""
        cmbCiudad.SelectedIndex = -1
        cmbJornada.SelectedIndex = -1
        meRadicados.Value = ""

        'cmbBodega.SelectedIndex = -1
        'cmbTipoServicio.SelectedIndex = -1
    End Sub

    Private Sub CargarServiciosListosParaVisita()
        Dim dtDatos As New DataTable
        Dim objRuta As New RutasSimpleRout
        dtDatos = objRuta.ConsultarServiciosListosParaVisita(ObtenerFiltro)
        Session("dtServiciosVisita") = dtDatos
        gvDatos.DataSource = dtDatos
        gvDatos.DataBind()
    End Sub

    Private Function ObtenerFiltro() As ILSBusinessLayer.Estructuras.FiltroConsultaVisitasSimpliRoute
        Dim filtro As New Estructuras.FiltroConsultaVisitasSimpliRoute
        Dim ListaNumeroRadicado As New List(Of Object)

        filtro.FechaInicial = deFechaInicial.Value
        filtro.FechaFinal = deFechaFinal.Value
        filtro.bodega = ddlBodega.GridView().GetSelectedFieldValues("idbodega")
        filtro.tipoServicio = ddlTipoServicio.GridView().GetSelectedFieldValues("idTipoServicio")
        filtro.ciudad = cmbCiudad.Value
        filtro.jornada = cmbJornada.Value

        If meRadicados.Text.Trim().Length > 0 Then
            For Each ped As Object In meRadicados.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries)
                ListaNumeroRadicado.Add(CStr(ped))
            Next
            Dim dtDatos As DataTable = ConvertToDataTable(ListaNumeroRadicado)
            filtro.tbRadicados = dtDatos
        End If
        Return filtro
    End Function


    Private Function ObtenerFiltroMasivo(dtDatos As DataTable) As ILSBusinessLayer.Estructuras.FiltroConsultaVisitasSimpliRoute
        Dim filtro As New Estructuras.FiltroConsultaVisitasSimpliRoute
        Dim ListaNumeroRadicado As New List(Of Object)

        filtro.FechaInicial = deFechaInicial.Value
        filtro.FechaFinal = deFechaFinal.Value
        filtro.bodega = ddlBodega.GridView().GetSelectedFieldValues("idbodega")
        filtro.tipoServicio = ddlTipoServicio.GridView().GetSelectedFieldValues("idTipoServicio")
        filtro.ciudad = cmbCiudad.Value
        filtro.jornada = cmbJornada.Value
        filtro.tbRadicados = dtDatos
        Return filtro
    End Function



#End Region

#Region "cargue inicial"
    Private Sub CargarCombos()
        CargarCiudades()
        CargarBodegas()
        CargarTiposServicio()
        CargarJornada()
    End Sub

    Private Sub CargarCiudades()
        Dim dt As New DataTable
        dt = Ciudad.ObtenerCiudadesPorPais
        Session("cmbCiudades") = dt
        cmbCiudad.DataSource = dt
        cmbCiudad.ValueField = "idCiudad"
        cmbCiudad.TextField = "nombre"
        cmbCiudad.DataBind()
    End Sub

    Protected Sub cmbCiudad_DataBinding(sender As Object, e As EventArgs) Handles cmbCiudad.DataBinding
        If Session("cmbCiudades") IsNot Nothing Then cmbCiudad.DataSource = Session("cmbCiudades")

        cmbCiudad.ValueField = "idCiudad"
        cmbCiudad.TextField = "nombre"
    End Sub

    Private Sub CargarBodegas()
        Dim dt As New DataTable
        dt = HerramientasMensajeria.ConsultarBodega(idCiudad:=CInt(cmbCiudad.Value), idUsuarioConsulta:=CInt(Session("usxp001")))
        Session("cmbBodegas") = dt
        With ddlBodega
            .DataSource = dt
            .DataBind()
        End With

    End Sub

    Protected Sub ddlBodega_DataBinding(sender As Object, e As EventArgs) Handles ddlBodega.DataBinding
        If Session("cmbBodegas") IsNot Nothing Then ddlBodega.DataSource = Session("cmbBodegas")

    End Sub

    Private Sub CargarTiposServicio()
        Dim dt As New DataTable
        dt = HerramientasMensajeria.ConsultarTipoServicioDisponible()
        Session("cmbTipoServicio") = dt
        With ddlTipoServicio
            .DataSource = dt
            .DataBind()
        End With
    End Sub

    Protected Sub ddlTipoServicio_DataBinding(sender As Object, e As EventArgs) Handles ddlTipoServicio.DataBinding
        If Session("cmbTipoServicio") IsNot Nothing Then ddlTipoServicio.DataSource = Session("cmbTipoServicio")

    End Sub

    Private Sub CargarJornada()
        Dim dt As New DataTable
        dt = HerramientasMensajeria.ConsultaJornadaMensajeria()
        Session("cmbJornada") = dt
        cmbJornada.DataSource = dt
        cmbJornada.ValueField = "idJornada"
        cmbJornada.TextField = "nombre"
        cmbJornada.DataBind()
    End Sub

    Protected Sub cmbJornada_DataBinding(sender As Object, e As EventArgs) Handles cmbJornada.DataBinding
        If Session("cmbJornada") IsNot Nothing Then cmbJornada.DataSource = Session("cmbJornada")

        cmbJornada.ValueField = "idJornada"
        cmbJornada.TextField = "nombre"
    End Sub


#End Region

#Region "Metodos Publicos"
    Public Shared Function ConvertToDataTable(Of T)(ByVal list As IList(Of T)) As DataTable
        Dim table As New DataTable()
        table.Columns.Add("idServicio", Type.GetType("System.Int64"))
        For Each item As T In list
            Dim row As DataRow = table.NewRow()
            row("idServicio") = item
            table.Rows.Add(row)
        Next

        Return table
    End Function
#End Region

#Region "Metodos Privados"
    Private Function ProcesarVisitas(listaServicio As DataTable) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try

            Dim rest As New ServicioRest
            Seguridad.verificarSession(Me)
            Dim objServicio As New GenerarPoolServicioMensajeria
            Dim dsDatos As New DataSet
            Dim dtErrores As New DataTable
            Session("dtErrores") = dtErrores
            With objServicio
                .IdUsuarioGenerador = CInt(Session("usxp001"))
                'Obtiene estructura de tabla con informacion de servicios a crear en visita
                dsDatos = .GenerarPoolVisitasSimpliRoute(listaServicio)
                rest.IdUsuario = CInt(Session("usxp001"))
                rest.Token = Comunes.ConfigValues.seleccionarConfigValue("TOKEN_EXPUESTO_SIMPLIROUTE")

                If rest.Token <> "" Then
                    'Envia informacion a WS Interno  - quien es el encargado de gestionar las visitas de simpliRoute
                    dtErrores = rest.CreacionVisita(dsDatos)
                    If dtErrores IsNot Nothing AndAlso dtErrores.Rows.Count > 0 Then
                        Session("dtErrores") = dtErrores
                        resultado.EstablecerMensajeYValor(0, "Listado novedades")
                        miEncabezado.showWarning("Listado novedades generadas")
                    Else
                        resultado.EstablecerMensajeYValor(1, "Se sincronizarón visitas correctamente")
                        miEncabezado.showSuccess("Se sincronizarón visitas correctamente!")
                    End If
                Else
                    resultado.EstablecerMensajeYValor(0, "Se generó un error al intentar generar Visitas: Pendiete Configuarar URL.")
                    miEncabezado.showError("Se generó un error al intentar generar Visitas: Pendiete Configuarar URL.")
                End If

            End With

        Catch ex As Exception
            resultado.EstablecerMensajeYValor(0, "Se generó un error al intentar generar Visitas: " & ex.Message)
            miEncabezado.showError("Se generó un error al intentar generar Visitas: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtServiciosVisita") IsNot Nothing Then gvDatos.DataSource = Session("dtServiciosVisita")
    End Sub

    Private Sub ExtractDataErrorHandler(sender As Object, e As ExtractDataDelegateEventArgs)
        If e.ErrorID = ExtractDataError.WrongType Then
            If Not IsNumeric(e.ExcelValue) And e.ExcelValue = Nothing Then
                e.DataTableValue = Nothing
            Else
                e.DataTableValue = e.ExcelValue.ToString()
            End If

            If e.DataTableValue = Nothing Then
                e.Action = ExtractDataEventAction.SkipRow
            Else
                e.Action = ExtractDataEventAction.Continue
            End If
        End If
    End Sub

    Private Function CrearEstructuraRadicados() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            .Add("numeroRadicado", GetType(Long))
        End With
        Return dtAux
    End Function

#End Region

#Region "Eventos"

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click

        If fuTags.PostedFile.FileName <> "" Then
            Try
                'Limpiar()
                Dim dtCargue As DataTable
                Dim fileExtension As String = Path.GetExtension(fuTags.PostedFile.FileName)
                Dim nombreArchivo As String = Path.GetFileName(fuTags.PostedFile.FileName)

                If (fileExtension <> "") Then
                    fileExtension = fileExtension.ToUpper()
                End If
                Dim resultado As Integer = -1
                Dim idUsuario As Integer = CInt(Session("usxp001"))
                Session.Remove("dtResultado")
                Dim fec As String = DateTime.Now.ToString("yy:mm:dd").Replace(":", ".")

                Dim ruta As String = RUTAALMACENAMIENTOARCHIVOS

                Dim numColumnas As Integer
                Dim totalColumnasxTipo As Integer = 0


                _nombreArchivo = nombreArchivo
                ruta += nombreArchivo
                fuTags.SaveAs(ruta)
                Dim miExcel As New ExcelFile
                Try
                    Select Case fileExtension
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
                If deFechaFinal.Text = "" Then
                    miEncabezado.showError("Pendiente diligenciar fecha inicial ")
                    CargarCombos()
                    Exit Sub
                End If
                If deFechaFinal.Text = "" Then
                    miEncabezado.showError("Pendiente diligenciar fecha final ")
                    CargarCombos()
                    Exit Sub
                End If
                If cmbJornada.Value <= 0 Then
                    miEncabezado.showError("Pendiente seleccionar jornada ")
                    CargarCombos()
                    Exit Sub
                End If

                If miExcel.Worksheets.Count >= 1 Then
                    Dim oWsInfoRadicado As ExcelWorksheet = miExcel.Worksheets.Item(0)
                    totalColumnasxTipo = 1
                    dtCargue = CrearEstructuraRadicados()

                    numColumnas = oWsInfoRadicado.CalculateMaxUsedColumns()

                    If numColumnas = totalColumnasxTipo Then ' se valida el numero de columnas  del archivo cargado
                        Try
                            filaInicial = oWsInfoRadicado.Cells.FirstRowIndex
                            columnaInicial = oWsInfoRadicado.Cells.FirstColumnIndex
                            AddHandler oWsInfoRadicado.ExtractDataEvent, AddressOf ExtractDataErrorHandler

                            oWsInfoRadicado.ExtractToDataTable(dtCargue, oWsInfoRadicado.Rows.Count, ExtractDataOptions.SkipEmptyRows,
                                            oWsInfoRadicado.Rows(filaInicial + 1), oWsInfoRadicado.Columns(columnaInicial))

                            Dim dterrores As New DataTable
                            If Session("dtResultado") IsNot Nothing Then
                                dterrores = Session("dtResultado")
                            End If

                            If dtCargue.Rows.Count <= 0 Then
                                miEncabezado.showError("No se puede procesar, ya que el archivo no contiene informacion")
                                Exit Sub
                            End If

                            If (dterrores IsNot Nothing Or dterrores.Rows.Count < 0) Then

                                Dim dtDatos As New DataTable
                                Dim objRuta As New RutasSimpleRout
                                dtDatos = objRuta.ConsultarServiciosListosParaVisita(ObtenerFiltroMasivo(dtCargue))
                                Session("dtServiciosVisita") = dtDatos
                                gvDatos.DataSource = dtDatos
                                gvDatos.DataBind()

                                miEncabezado.showSuccess("Consultar masiva por radicado realizada correctamente.")
                                CargarCombos()

                            Else
                                With gvErrores
                                    gvErrores.Visible = True
                                    .DataSource = CType(Session("dtResultado"), DataTable)
                                    .DataBind()
                                End With
                            End If

                        Catch ex As Exception
                            miEncabezado.showError("Se genero un error al leer la infomacion de la hoja Información de base cliente:  " & ex.Message)
                            Exit Sub
                        End Try
                    Else
                        miEncabezado.showError("No se puede procesar, ya que la hoja contiene número columnas diferente a las esperadas. Por favor verifique. Número Columnas requeridas:" & totalColumnasxTipo.ToString())
                        Exit Sub
                    End If
                Else
                    miEncabezado.showError("No se puede procesar, ya que el archivo no contiene hojas. Por favor verifique  Numero de Hojas: " & miExcel.Worksheets.Count)
                    Exit Sub
                End If



            Catch ex As Exception
                miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            End Try
        Else
            miEncabezado.showError("Seleccione un archivo por favor !")
        End If
    End Sub

#End Region
End Class

