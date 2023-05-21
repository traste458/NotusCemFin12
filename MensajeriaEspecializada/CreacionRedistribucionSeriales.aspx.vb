Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Proveedor
Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer.Recibos
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Localizacion
Imports DevExpress.Web.ASPxPivotGrid
Imports System.Text

Public Class CreacionRedistribucionSeriales
    Inherits System.Web.UI.Page


#Region "Atributos"
    Private excel As ExcelFile
    Private rutaArchivo As String
    Private dtErrorArchivo, dtArchivo As DataTable
#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epPrincipal.clear()
        Try
            If Not Me.IsPostBack Then
                cmbOrigen.Focus()
                epPrincipal.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                Session.Remove("dtServiciosAdicionados")
                epPrincipal.setTitle("Creación Redistribución Seriales")
                CargarDatos()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        epPrincipal.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")

            Select Case arryAccion(1)
                Case "100" ''Guardar orden
                    Dim resultado As ResultadoProceso
                    CType(sender, ASPxCallbackPanel).JSProperties("cpCreacionServicio") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0

                    resultado = GuardarOrden()

                    If resultado.Valor = 1 Then
                        Session("mensaje") = resultado.Mensaje
                        epPrincipal.showSuccess(resultado.Mensaje)
                        LimpiarCamposOrden()
                        LimpiarCamposProducto()

                        txtObservaciones.Text = ""
                        cmbOrigen.Enabled = True
                        cmbDestino.Enabled = True
                        cmbOrigen.SelectedIndex = -1
                        cmbDestino.SelectedIndex = -1

                        'DescargarRemision(CInt(Session("idRuta")), "RemisionSinHub", Session("ruta"), Session("nombreArchivo"))

                        CType(sender, ASPxCallbackPanel).JSProperties("cpCreacionServicio") = 1
                        CType(sender, ASPxCallbackPanel).JSProperties("cpIdRuta") = CInt(Session("idRuta"))
                        CType(sender, ASPxCallbackPanel).JSProperties("cpRuta") = Session("ruta")
                        CType(sender, ASPxCallbackPanel).JSProperties("cpNombre") = Session("nombreArchivo")

                    ElseIf resultado.Valor = 2 Then
                        epPrincipal.showWarning(resultado.Mensaje)
                    Else
                        LimpiarCamposOrden()
                        LimpiarCamposProducto()

                        txtObservaciones.Text = ""
                        cmbOrigen.Enabled = True
                        cmbDestino.Enabled = True
                        cmbOrigen.SelectedIndex = -1
                        cmbDestino.SelectedIndex = -1
                        epPrincipal.showError(resultado.Mensaje)
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "CargarArchivo", "<script>CargarArchivo()</script>", False)
                    End If
                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                Case "200" 'Guardar producto
                    Dim resultado As New ResultadoProceso
                    If CType(Session("SerialValido"), Integer) = 1 Then
                        resultado = GuardarSerial()
                        If resultado.Valor = 1 Then
                            epPrincipal.showSuccess(resultado.Mensaje)
                            EnlazarReporte(gridProductos, Session("dtServiciosAdicionados"))
                        ElseIf resultado.Valor = 2 Then
                            epPrincipal.showWarning(resultado.Mensaje)
                        Else
                            epPrincipal.showError(resultado.Mensaje)
                        End If
                        LimpiarCamposProducto()
                        CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                        CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                        CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                        CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0
                    Else
                        CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                        CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                        CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                        CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0
                    End If
                Case "300" 'Filtrar Modelos
                    'cmbModelo.SelectedIndex = -1
                    'CargarModelo(cmbMarca.Value)
                    'CargarMarca()
                    'CargarFallas()

                    cmbOrigen.Enabled = False
                    cmbDestino.Enabled = False

                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                    CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0
                Case "400" 'Validar que existe el serial en el inventario del CE
                    If txtSerialNew.Text.Trim <> "" Then
                        Dim resultado As ResultadoProceso
                        If cmbOrigen.Value <> cmbDestino.Value Then
                            If cmbOrigen.Value IsNot Nothing Then
                                resultado = ValidarSerial()
                                If resultado.Valor = 1 Then
                                    epPrincipal.clear()
                                    btnGuardarProducto.Enabled = True
                                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 0
                                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                                    Session("SerialValido") = 1
                                    HabilitarCampos()
                                    cmbOrigen.Enabled = False
                                    cmbDestino.Enabled = False
                                ElseIf resultado.Valor <> 1 Then
                                    epPrincipal.showWarning(resultado.Mensaje)
                                    btnGuardarProducto.Enabled = False
                                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                                    Session("SerialValido") = 0
                                    DeshabilitarCampos()
                                    cmbOrigen.Enabled = True
                                    cmbDestino.Enabled = True
                                End If
                                CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                                CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0
                                CType(sender, ASPxCallbackPanel).JSProperties("cpCreacionServicio") = 0
                            Else
                                epPrincipal.showWarning("Debe Seleccinar el punto de origen")
                                btnGuardarProducto.Enabled = False
                                Session("SerialValido") = 0
                                CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                                CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                                DeshabilitarCampos()
                            End If
                        Else
                            epPrincipal.showWarning("La bodega de destino no puede ser la misma bodega de origen")
                            txtSerialNew.Text = ""
                            btnGuardarProducto.Enabled = False
                            Session("SerialValido") = 0
                            CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                            CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                            DeshabilitarCampos()
                        End If
                    End If
                Case "500"
                    If CType(Session("dtServiciosAdicionados"), DataTable).Rows.Count = 0 Then
                        cmbOrigen.Enabled = True
                        cmbDestino.Enabled = True
                    Else
                        cmbOrigen.Enabled = False
                        cmbDestino.Enabled = False
                    End If

                    If CType(Session("resultado"), ResultadoProceso).Valor = 1 Then
                        epPrincipal.showSuccess("El producto fue eliminado correctamente")
                    Else
                        epPrincipal.showSuccess("No hay productos para eliminar")
                    End If

                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 1
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                    CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0
                Case "Fallas"
                    Dim dtfallastmp As New DataTable
                    dtfallastmp = CType(Session("dtFalla"), DataTable)
                    Dim fila() As DataRow = CType(Session("dtServiciosAdicionados"), DataTable).Select("idProducto = " & CInt(arryAccion(0)))

                    Dim cadena As String
                    cadena = fila(0).Item("idFallas").ToString.Trim
                    dtfallastmp.DefaultView.RowFilter = "idFalla IN (" & cadena & ")"
                    Dim dt As DataTable = dtfallastmp.DefaultView.ToTable

                    Session("dtFallasTmp") = dt

                    With gvFallas
                        .DataSource = CType(Session("dtFallasTmp"), DataTable)
                        .DataBind()
                    End With

                    CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 1
                    CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                Case "Accesorios"
                    Dim dtAccesoriostmp As New DataTable
                    dtAccesoriostmp = CType(Session("dtAccesorios"), DataTable)
                    Dim fila() As DataRow = CType(Session("dtServiciosAdicionados"), DataTable).Select("idProducto = " & CInt(arryAccion(0)))

                    Dim cadena As String
                    cadena = fila(0).Item("idAccesorio").ToString.Trim
                    dtAccesoriostmp.DefaultView.RowFilter = "idAccesorio IN (" & cadena & ")"
                    Dim dt As DataTable = dtAccesoriostmp.DefaultView.ToTable

                    Session("dtAccesoriosTmp") = dt

                    With gvAccesorios
                        .DataSource = CType(Session("dtAccesoriosTmp"), DataTable)
                        .DataBind()
                    End With

                    CType(sender, ASPxCallbackPanel).JSProperties("cpFalla") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpAccesorios") = 1
                    CType(sender, ASPxCallbackPanel).JSProperties("cpSubir") = 0
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 1
                Case "800"
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMostrarMensaje") = 0
                    epPrincipal.clear()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            If CType(Session("SerialValido"), Integer) = 1 Then
                'CargarFallas()
                'CargarAccesorios()
            End If
            If Session("dtServiciosAdicionados") IsNot Nothing AndAlso CType(Session("dtServiciosAdicionados"), DataTable).Rows.Count > 0 Then
                cmbOrigen.ClientEnabled = False
                cmbDestino.ClientEnabled = False
            End If
        Catch ex As Exception
            epPrincipal.showError("Error: " & ex.Message)
        End Try

    End Sub

    Private Sub gridProductos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gridProductos.CustomCallback
        epPrincipal.clear()
        Try
            If Not String.IsNullOrEmpty(e.Parameters) Then
                Dim parameters() As String = e.Parameters.Split(":"c)
                Select Case parameters(1)
                    Case "eliminar"
                        Dim resultado As ResultadoProceso
                        resultado = EliminarProductos(CInt(parameters(0)))
                        If resultado.Valor = 1 Then
                            EnlazarReporte(gridProductos, Session("dtServiciosAdicionados"))
                            epPrincipal.showSuccess(resultado.Mensaje)
                        ElseIf e.Parameters = "-100" Then
                            EnlazarReporte(gridProductos, Session("dtServiciosAdicionados"))
                        Else
                            epPrincipal.showError(resultado.Mensaje)
                        End If
                    Case Else
                        Throw New ArgumentNullException("Opcion no valida")
                End Select

            End If
        Catch ex As Exception
            epPrincipal.showError("Error: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpGrMensaje") = epPrincipal.RenderHtml
    End Sub

    Private Sub gridProductos_DataBinding(sender As Object, e As EventArgs) Handles gridProductos.DataBinding
        gridProductos.DataSource = Session("dtServiciosAdicionados")
    End Sub

    Private Sub gridErrores_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gridErrores.CustomCallback
        MetodosComunes.EnlazarReporte(gridErrores, Session("dtErrores"))
    End Sub

    Private Sub gridErrores_DataBinding(sender As Object, e As EventArgs) Handles gridErrores.DataBinding
        gridErrores.DataSource = Session("dtErrores")
    End Sub

    Private Sub gvFallas_DataBinding(sender As Object, e As EventArgs) Handles gvFallas.DataBinding
        gvFallas.DataSource = Session("dtFallasTmp")
    End Sub

    Private Sub gvAccesorios_DataBinding(sender As Object, e As EventArgs) Handles gvAccesorios.DataBinding
        gvAccesorios.DataSource = Session("dtAccesoriosTmp")
    End Sub

    Private Sub lbEjemplo_Click(sender As Object, e As EventArgs) Handles lbEjemplo.Click
        Try
            epPrincipal.clear()
            Dim archivo As String = Server.MapPath("~/MensajeriaEspecializada/Plantillas/PlantillaDetalleRedistribucionSerialesCE.xlsx")
            Dim _archivoEjemplo As String
            _archivoEjemplo = ObtenerDatosReporteExcel(archivo)
            If _archivoEjemplo <> "" Then
                Dim file As System.IO.FileInfo = New System.IO.FileInfo(_archivoEjemplo)
                If file.Exists() Then
                    Response.Clear()
                    Response.ClearContent()
                    Response.AppendHeader("Content-Disposition", "attachment; filename=" & file.Name)
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.WriteFile(_archivoEjemplo)
                    Response.End()
                Else
                    Response.Write("Este archivo no existe.")
                End If
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al Abrir el archivo de Ejemplo. " & ex.Message & "<br><br>")
        End Try
    End Sub

    Private Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Dim dtCambioOrigen As New DataTable

        If cmbOrigen.Value = 0 Or cmbDestino.Value = 0 Then
            epPrincipal.showError("Se debe seleccionar el origen y el destino antes de realizar el cargue del archivo")
        ElseIf cmbOrigen.Value = cmbDestino.Value Then
            epPrincipal.showError("El origen y el destino no deben ser los mismos.")
        Else

            cmbOrigen.Enabled = False
            cmbDestino.Enabled = False

            Dim resultado As New ResultadoProceso
            CargarLicenciaGembox()

            resultado = CargarArchivo()
            If resultado.Valor = 1 Then
                epPrincipal.showSuccess(resultado.Mensaje)
                dtCambioOrigen = Session("dtServiciosAdicionados")
                dtCambioOrigen.Columns(0).ColumnName = "idProducto"
                'dtCambioOrigen.Columns(5).DataType = GetType(String)
                dtCambioOrigen.Columns.Add("bodegaOrigen").DataType = GetType(String)

                Dim x As Integer = 0
                For Each row As DataRow In dtCambioOrigen.Rows
                    dtCambioOrigen.Rows(x)("bodegaOrigen") = cmbOrigen.Text
                    x += 1
                Next

                EnlazarReporte(gridProductos, dtCambioOrigen)
            Else
                cmbOrigen.Enabled = True
                cmbDestino.Enabled = True
                epPrincipal.showError("Se presentaron errores en la validación, " & resultado.Mensaje)
            End If
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "CargarArchivo", "<script>CargarArchivo()</script>", False)
        End If


    End Sub

#End Region

#Region "Métodos públicos"

#End Region

#Region "Métodos privados"

    Private Sub CargarDatos()
        Try
            CargarBodegasTraslado()
            'CInt(Session("usxp001")) Toma el usuario que está en sesión.
            'CargarMarca()
            'CargarTipoElemento()
            'CargarColor()
            'CargarAccesorios()
            'CargarFallas()
            'CargarTipoContenedor()

        Catch ex As Exception
            epPrincipal.showError("Error al cargar los datos: " & ex.ToString)
        End Try
    End Sub

    Private Sub CargarBodegasTraslado()
        Dim dtBodegas As DataTable
        Try
            Dim objCentroExperiencia As New CentroExperiencia
            With objCentroExperiencia
                dtBodegas = .ObtenerBoedegasTraslado()
            End With
            If dtBodegas.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbOrigen, dtBodegas, "idbodega", "bodega")
                MetodosComunes.CargarComboDX(cmbDestino, dtBodegas, "idbodega", "bodega")

                If dtBodegas.Rows.Count = 1 Then
                    cmbOrigen.SelectedIndex = 0
                    cmbOrigen.Enabled = False
                    cmbDestino.SelectedIndex = 0
                    cmbDestino.Enabled = False
                Else
                    cmbOrigen.Enabled = True
                    cmbDestino.Enabled = True
                End If

            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar el Origen: " & ex.Message)
        End Try
    End Sub

    'Private Sub CargarMarca()
    '    Dim dtMarca As DataTable
    '    Try
    '        Dim objMarca As New Marca
    '        With objMarca
    '            .Redistribucion = 1
    '            dtMarca = .ObtenerListado
    '            Session("dtMarca") = dtMarca
    '        End With
    '        If dtMarca.Rows.Count > 0 Then
    '            'MetodosComunes.CargarComboDX(cmbMarca, dtMarca, "idMarca", "nombre")
    '        End If
    '    Catch ex As Exception
    '        epPrincipal.showError("Error al cargar las marcas: " & ex.Message)
    '    End Try
    'End Sub

    'Private Sub CargarColor()
    '    Dim dtColor As DataTable
    '    Try
    '        Dim objColor As New Colores
    '        objColor.IdEstado = 1
    '        dtColor = objColor.ObtenerColores
    '        Session("dtColor") = dtColor
    '        If dtColor.Rows.Count > 0 Then
    '            'MetodosComunes.CargarComboDX(cmbColor, dtColor, "idColor", "color")
    '        End If
    '    Catch ex As Exception
    '        epPrincipal.showError("Error al cargar los colores: " & ex.Message)
    '    End Try
    'End Sub

    'Private Sub CargarAccesorios()
    'Dim dtAccesorio As DataTable
    'Try
    'Se cargan los accesorios existentes en el sistema
    '    Dim objListBox As ASPxListBox = DirectCast(cmbAccesoriosdd.FindControl("lbAccesoriosdd"), ASPxListBox)
    '    With objListBox
    '        .Items.Clear()
    '        Dim objAccesorio As New AccesorioEquipo
    '        dtAccesorio = objAccesorio.ObtenerAccesorios
    '        Session("dtAccesorios") = dtAccesorio
    '        .Items.Add("(Todos)", 0)
    '        For Each row As DataRow In dtAccesorio.Rows
    '            .Items.Add(row("nombre"), row("idAccesorio"))
    '        Next
    '    End With
    'Catch ex As Exception
    '    epPrincipal.showError("Error al cargar los accesorios de equipo: " & ex.Message)
    'End Try
    'End Sub

    'Private Sub CargarTipoElemento()
    '    Dim dtTipoElemento As DataTable
    '    Try
    '        Dim objTipoElemento As New TipoElemento
    '        dtTipoElemento = objTipoElemento.ObtenerTipoElemento

    '        Session("dtTipoElemento") = dtTipoElemento

    '        If dtTipoElemento.Rows.Count > 0 Then
    '            'MetodosComunes.CargarComboDX(cmbTipoElemento, dtTipoElemento, "idTipoElemento", "nombre")
    '        End If
    '    Catch ex As Exception
    '        epPrincipal.showError("Error al cargar los tipo producto: " & ex.Message)
    '    End Try
    'End Sub

    'Private Sub CargarModelo(idMarca As Integer)
    '    Dim dtModelo As DataTable
    '    Try
    '        Dim objModelo As New Modelo
    '        objModelo.IdMarca = idMarca
    '        dtModelo = objModelo.ObtenerModelo

    '        Session("dtModelo") = dtModelo

    '        If dtModelo.Rows.Count > 0 Then
    '            'MetodosComunes.CargarComboDX(cmbModelo, dtModelo, "idModelo", "modelo")
    '        End If
    '    Catch ex As Exception
    '        epPrincipal.showError("Error al cargar los accesorios de equipo: " & ex.Message)
    '    End Try
    'End Sub

    'Private Sub CargarFallas()
    'Dim dtFalla As DataTable
    'Try
    '    'Se cargan las Fallas existentes en el sistema
    '    Dim objListBox As ASPxListBox = DirectCast(cmbFallas.FindControl("lbFalla"), ASPxListBox)
    '    With objListBox
    '        .Items.Clear()
    '        Dim objFalla As New FallaRecepcionEquipo
    '        dtFalla = objFalla.ObtenerFallas
    '        Session("dtFalla") = dtFalla
    '        .Items.Add("(Todos)", 0)
    '        For Each row As DataRow In dtFalla.Rows
    '            .Items.Add(row("nombre"), row("idFalla"))
    '        Next
    '    End With
    'Catch ex As Exception
    '    epPrincipal.showError("Error al cargar las fallas: " & ex.Message)
    'End Try
    'End Sub

    'Private Sub CargarTipoContenedor()
    '    Dim dtContenedor As DataTable
    '    Try
    '        Dim objContenedor As New TipoContenedor
    '        dtContenedor = objContenedor.ObtenerTipoContenedor

    '        Session("dtContenedor") = dtContenedor

    '        If dtContenedor.Rows.Count > 0 Then
    '            'MetodosComunes.CargarComboDX(cmbTipoContenedor, dtContenedor, "idContenedor", "nombre")
    '        End If
    '    Catch ex As Exception
    '        epPrincipal.showError("Error al cargar los tipos de contenedor: " & ex.Message)
    '    End Try
    'End Sub

    Private Function ValidarSerial() As ResultadoProceso
        Dim resultado As ResultadoProceso
        Try
            Dim objRedistribucion As New RedistribucionSerialesCE
            With objRedistribucion
                .IdOrigen = cmbOrigen.Value
                .Serial = txtSerialNew.Text.Trim
                resultado = .ValidarSerialInventarioOrigen
            End With
        Catch ex As Exception
            epPrincipal.showError("Error validando el número de la orden: " & ex.ToString)
        End Try
        Return resultado
    End Function

    Private Function GuardarSerial() As ResultadoProceso
        Dim dtServiciosAdicionados As DataTable
        Dim resultado As New ResultadoProceso

        Dim dtPrdSerial As DataTable
        Dim objProducto As New CentroExperiencia
        With objProducto
            dtPrdSerial = .ObtenerInformacionProdSerial(txtSerialNew.Text, Integer.Parse(cmbOrigen.Value))
        End With


        epPrincipal.clear()
        Try
            If Session("dtServiciosAdicionados") IsNot Nothing Then
                dtServiciosAdicionados = Session("dtServiciosAdicionados")
            Else
                dtServiciosAdicionados = CrearEstructuraServiciosAdicionados()
            End If

            Dim fila() As DataRow = dtServiciosAdicionados.Select("serial = '" & txtSerialNew.Text.Trim & "'")

            If fila.Length > 0 Then
                resultado.EstablecerMensajeYValor(2, "El serial ya se encuentra registrado")
            Else
                Dim drAux As DataRow
                drAux = dtServiciosAdicionados.NewRow
                drAux("idProducto") = dtServiciosAdicionados.Rows.Count + 1
                drAux("serial") = txtSerialNew.Value
                drAux("Producto") = dtPrdSerial.Rows(0)(0).ToString()
                drAux("codigo") = dtPrdSerial.Rows(0)(1).ToString()
                drAux("bodegaOrigen") = dtPrdSerial.Rows(0)(3).ToString()
                drAux("idOrigen") = cmbOrigen.Value
                drAux("idDestino") = cmbDestino.Value
                dtServiciosAdicionados.Rows.Add(drAux)
                Session("dtServiciosAdicionados") = dtServiciosAdicionados
                resultado.EstablecerMensajeYValor(1, "Serial agregado correctamente")
                cmbDestino.ClientEnabled = False
                cmbOrigen.ClientEnabled = False
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(500, "Error al agregar el serial: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub EnlazarReporte(ByVal grid As Object, ByVal dtDatos As DataTable)
        With grid
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)
            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

            Dim linkVerFallas As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer1 As GridViewDataItemTemplateContainer = CType(linkVerFallas.NamingContainer, GridViewDataItemTemplateContainer)
            linkVerFallas.ClientSideEvents.Click = linkVerFallas.ClientSideEvents.Click.Replace("{0}", templateContainer1.KeyValue)

            Dim linkVerAccesorios As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer2 As GridViewDataItemTemplateContainer = CType(linkVerAccesorios.NamingContainer, GridViewDataItemTemplateContainer)
            linkVerAccesorios.ClientSideEvents.Click = linkVerAccesorios.ClientSideEvents.Click.Replace("{0}", templateContainer2.KeyValue)

        Catch ex As Exception
            epPrincipal.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Function EliminarProductos(ByVal identificador As Integer) As ResultadoProceso
        Dim dtServiciosAdicionados As DataTable
        Dim resultado As New ResultadoProceso
        Try
            If Session("dtServiciosAdicionados") IsNot Nothing Then
                dtServiciosAdicionados = Session("dtServiciosAdicionados")
            End If

            Dim fila() As DataRow = dtServiciosAdicionados.Select("idProducto = " & identificador)

            If fila.Length > 0 Then
                dtServiciosAdicionados.Rows.Remove(fila(0))

                Session("dtServiciosAdicionados") = dtServiciosAdicionados
                resultado.EstablecerMensajeYValor(1, "El producto fue eliminado correctamente")
            Else
                resultado.EstablecerMensajeYValor(2, "No hay productos para eliminar")
            End If

            Session("resultado") = resultado

        Catch ex As Exception
            resultado.EstablecerMensajeYValor(500, "Error al tratar de eliminar el producto: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Function GuardarOrden() As ResultadoProceso

        Dim resultado As New ResultadoProceso
        Dim objServicioHub As New RedistribucionSerialesCE
        Dim respuesta As Boolean
        Dim dtServiciosAdicionados As DataTable

        If Session("dtServiciosAdicionados") IsNot Nothing Then
            dtServiciosAdicionados = Session("dtServiciosAdicionados")
        Else
            dtServiciosAdicionados = CrearEstructuraServiciosAdicionados()
        End If

        If dtServiciosAdicionados.Rows.Count > 0 Then
            With objServicioHub
                Dim dtDetalleServicios As DataTable = Session("dtServiciosAdicionados")
                .IdOrigen = cmbOrigen.Value
                .IdDestino = cmbDestino.Value
                .Observacion = txtObservaciones.Text.Trim
                .IdCreador = Session("usxp001")
                .LogonUser = Server.MachineName
                .AdicionarDetalle(dtDetalleServicios)
                resultado = .Crear()
                Session("idRuta") = .IdRuta
                Session("guia") = .NumGuia
            End With
            If resultado.Valor = 1 Then
                resultado.EstablecerMensajeYValor(1, "La orden de traslado de seriales entre las bodegas " + cmbOrigen.Text + " y " + cmbDestino.Text + " fue creada con número de guía " & Session("guia") & ".")
                VerRemision()
            Else
                resultado.EstablecerMensajeYValor(0, resultado.Mensaje)
            End If
        Else
            resultado.EstablecerMensajeYValor(2, "Por favor ingrese el detalle de los seriales")
            txtSerialNew.Focus()
        End If
        Return resultado
    End Function

    Private Sub LimpiarCamposOrden()
        Session("dtServiciosAdicionados") = Nothing
        EnlazarReporte(gridProductos, Nothing)
    End Sub

    Private Sub LimpiarCamposProducto()
        txtSerialNew.Value = ""
        'cmbMarca.SelectedIndex = -1
        'cmbModelo.SelectedIndex = -1
        'cmbColor.SelectedIndex = -1
        'cmbTipoElemento.SelectedIndex = -1
        'Dim objListBox As ASPxListBox = DirectCast(cmbFallas.FindControl("lbFalla"), ASPxListBox)
        'objListBox.Items.Clear()
        'cmbFallas.Value = Nothing
        'Dim objListBoxAcc As ASPxListBox = DirectCast(cmbAccesoriosdd.FindControl("lbAccesoriosdd"), ASPxListBox)
        'objListBoxAcc.Items.Clear()
        'cmbAccesoriosdd.Value = Nothing
        'cmbTipoContenedor.SelectedIndex = -1
        'txtIdContenedor.Text = ""
    End Sub

    Private Sub CargarDatos(ByVal idOrdenCompra As Integer)

        Dim objOrdenCompra As New Recibos.OrdenCompra(idOrdenCompra)

        With objOrdenCompra

            EnlazarReporte(gridProductos, .Detalle)
        End With

    End Sub

    Public Sub gridProductos_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs) Handles gridProductos.RowUpdating
        Try
            Dim valorNuevo As Integer
            Dim valorNuevoSerial As String
            Dim valorViejo As Integer
            Dim idProducto As Integer
            Dim dtServiciosAdicionados As DataTable

            If Session("dtServiciosAdicionados") IsNot Nothing Then
                dtServiciosAdicionados = Session("dtServiciosAdicionados")
            Else
                dtServiciosAdicionados = CrearEstructuraServiciosAdicionados()
            End If

            If dtServiciosAdicionados.Rows.Count > 0 Then
                valorNuevo = e.NewValues(0)
                valorNuevoSerial = e.NewValues(1)
                valorViejo = e.OldValues(0)
                idProducto = e.Keys(0)

                For i As Integer = 0 To dtServiciosAdicionados.Rows.Count - 1
                    If idProducto = dtServiciosAdicionados.Rows(i).Item("idProducto") Then
                        If valorNuevoSerial = "" Then
                            dtServiciosAdicionados.Rows(i).Item("cantidad") = valorNuevo
                        Else
                            dtServiciosAdicionados.Rows(i).Item("cantidad") = 1
                        End If

                        dtServiciosAdicionados.Rows(i).Item("serial") = valorNuevoSerial
                    End If
                Next
                Session("dtServiciosAdicionados") = dtServiciosAdicionados
                gridProductos.DataBind()
            Else
                epPrincipal.showWarning("No se pudo actualizar el producto")
            End If
            epPrincipal.showSuccess("Cantidad actualizada correctamente")
            gridProductos.CancelEdit()
        Catch ex As Exception
            epPrincipal.showError("Error al actualizar la cantidad")
        End Try
        CType(sender, ASPxGridView).JSProperties("cpCaMensaje") = epPrincipal.RenderHtml
        e.Cancel = True
    End Sub

    Private Sub DeshabilitarCampos()
        Try
            txtSerialNew.Enabled = True
            'cmbMarca.Enabled = False
            'cmbModelo.Enabled = False
            'cmbColor.Enabled = False
            'cmbTipoElemento.Enabled = False
            'cmbFallas.Enabled = False
            'cmbAccesoriosdd.Enabled = False
            'cmbTipoContenedor.Enabled = False
            'txtIdContenedor.Enabled = False
            btnGuardarProducto.Enabled = False
            btnGuardar.Enabled = False
        Catch ex As Exception
            epPrincipal.showError("Error al deshabilitar los campos: " & ex.ToString)
        End Try
    End Sub

    Private Sub HabilitarCampos()
        Try
            'cmbMarca.Enabled = True
            'cmbModelo.Enabled = True
            txtSerialNew.Enabled = True
            'cmbColor.Enabled = True
            'cmbTipoElemento.Enabled = True
            'cmbFallas.Enabled = True
            'cmbAccesoriosdd.Enabled = True
            'cmbTipoContenedor.Enabled = True
            'txtIdContenedor.Enabled = True
            btnGuardarProducto.Enabled = True
            btnGuardar.Enabled = True
        Catch ex As Exception
            epPrincipal.showError("Error al habilitar los campos: " & ex.ToString)
        End Try
    End Sub

    Private Function ObtenerDatosReporteExcel(pNombrePlantilla)
        Dim pNombreArchivo As String = Server.MapPath("~/archivos_planos/" & "PlantillaDetalleRedistribucionSerialesCE_" & Guid.NewGuid().ToString() & ".xlsx")
        'Try

        CargarLicenciaGembox()

            Dim oExcel As New ExcelFile
            Dim ObtenerDatosReporteExceloExcel As New ExcelFile
            Dim oWs As ExcelWorksheet

            oExcel.LoadXlsx(pNombrePlantilla, XlsxOptions.None)

        'Marca
            '    Dim dtMarca As DataTable
            '    Dim objMarca As New Marca
            '    objMarca.ServicioVIP = 1
            '    dtMarca = objMarca.ObtenerListado
            '    Session("dtMarca") = dtMarca
            '    If CType(Session("dtMarca"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("Marca")
            '        For i As Integer = 0 To CType(Session("dtMarca"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtMarca"), DataTable).Rows(i).Item("idMarca")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtMarca"), DataTable).Rows(i).Item("nombre")
            '        Next
            '    End If
            '    Session("dtMarca") = Nothing

            '    'Modelo
            '    Dim dtModelo As DataTable
            '    Dim objModelo As New Modelo
            '    dtModelo = objModelo.ObtenerModelo

            '    Session("dtModelo") = dtModelo
            '    If CType(Session("dtModelo"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("Modelo")
            '        For i As Integer = 0 To CType(Session("dtModelo"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtModelo"), DataTable).Rows(i).Item("idModelo")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtModelo"), DataTable).Rows(i).Item("modelo")
            '        Next
            '    End If

            '    'Color
            '    If CType(Session("dtColor"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("Color")
            '        For i As Integer = 0 To CType(Session("dtColor"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtColor"), DataTable).Rows(i).Item("idColor")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtColor"), DataTable).Rows(i).Item("color")
            '        Next
            '    End If

            '    'Tipo Elemento
            '    If CType(Session("dtTipoElemento"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("TipoElemento")
            '        For i As Integer = 0 To CType(Session("dtTipoElemento"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtTipoElemento"), DataTable).Rows(i).Item("idTipoElemento")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtTipoElemento"), DataTable).Rows(i).Item("nombre")
            '        Next
            '    End If

            '    'Fallas
            '    If CType(Session("dtFalla"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("Fallas")
            '        For i As Integer = 0 To CType(Session("dtFalla"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtFalla"), DataTable).Rows(i).Item("idFalla")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtFalla"), DataTable).Rows(i).Item("nombre")
            '        Next
            '    End If

            '    'Accesorios
            '    If CType(Session("dtAccesorios"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("Accesorios")
            '        For i As Integer = 0 To CType(Session("dtAccesorios"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtAccesorios"), DataTable).Rows(i).Item("idAccesorio")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtAccesorios"), DataTable).Rows(i).Item("nombre")
            '        Next
            '    End If

            '    'Tipo Contenedor
            '    If CType(Session("dtContenedor"), DataTable) IsNot Nothing Then
            '        oWs = oExcel.Worksheets("TipoContenedor")
            '        For i As Integer = 0 To CType(Session("dtContenedor"), DataTable).Rows.Count - 1
            '            oWs.Cells(i + 1, 0).Value = CType(Session("dtContenedor"), DataTable).Rows(i).Item("idContenedor")
            '            oWs.Cells(i + 1, 1).Value = CType(Session("dtContenedor"), DataTable).Rows(i).Item("nombre")
            '        Next
            '    End If
            '    oExcel.SaveXlsx(pNombreArchivo)
            'Catch ex As Exception
            '    epPrincipal.showError("Error obteniendo datos archivo de Ejemplo. " & ex.Message)
            'End Try
            Return pNombreArchivo
    End Function

    Private Function CargarArchivo() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try

            If (fUploadArchivo.HasFile) Then
                rutaArchivo = Server.MapPath("~/archivos_planos/OC" & Session("usxp001"))
                fUploadArchivo.SaveAs(rutaArchivo & fUploadArchivo.FileName)
                Session("rutaArchivo") = rutaArchivo & fUploadArchivo.FileName

                Dim fileExtension As String = Path.GetExtension(fUploadArchivo.FileName)
                excel = New ExcelFile()

                If fileExtension.ToUpper = ".XLS" Then
                    excel.LoadXls(rutaArchivo & fUploadArchivo.FileName)
                ElseIf fileExtension.ToUpper = ".XLSX" Then
                    excel.LoadXlsx(rutaArchivo & fUploadArchivo.FileName, XlsxOptions.None)
                Else
                    resultado.EstablecerMensajeYValor(-504, "El archivo no es de tipo Excel.")
                End If

                Dim cargar As New ILSBusinessLayer.RedistribucionSerialesCEArchivo

                With cargar
                    .RutaArchivo = Session("rutaArchivo")
                    .idOrigen = cmbOrigen.Value
                    .IdDestino = cmbDestino.Value
                    resultado = .CargarArchivo()
                End With
            Else
                resultado.EstablecerMensajeYValor(-502, "Por favor seleccione el tipo de archivo que desea subir.")
            End If
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(-501, "Error al cargar el archivo: " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub VerRemision()
        Dim remision As New RemisionRedistribucionSerialesCE
        Dim dsDatos As New DataSet
        Dim objRedistribucion As New RedistribucionSerialesCE
        With objRedistribucion
            .IdRuta = CInt(Session("idRuta"))
            .Origen = "Remision"
            dsDatos = .ObtenerRemisionRedistribucionSerialesCE
        End With
        dsDatos.Tables(0).TableName = "dtEncabezado"
        dsDatos.Tables(1).TableName = "dtDetalle"
        Dim identificador As Guid = Guid.NewGuid()
        Dim nombreArchivo As String = System.Web.HttpContext.Current.Server.MapPath("~/RepositorioTemporal/remision_" & identificador.ToString & ".pdf")
        Session("nombreArchivo") = "remision_" & identificador.ToString & ".pdf"
        Session("ruta") = System.Web.HttpContext.Current.Server.MapPath("~/RepositorioTemporal/")
        remision.DataSource = dsDatos
        remision.ExportToPdf(nombreArchivo)
    End Sub

    Private Sub DescargarRemision(idDocumento As Integer, origen As String, ruta As String, nombre As String)
        Dim rutaDocumento As String
        Try
            If idDocumento > 0 Then
                If origen = "RemisionSinHub" Then
                    rutaDocumento = ruta

                    Dim fs As FileStream = New FileStream(ruta + nombre, FileMode.Open, FileAccess.Read)
                    Dim fileData As Byte()
                    ReDim fileData(fs.Length)
                    Dim bytesRead As Long = fs.Read(fileData, 0, CInt(fs.Length))
                    fs.Close()
                    Dim sFileExt As String = Split(nombre, ".")(1)

                    Response.ClearContent()
                    Response.ClearHeaders()

                    Response.AddHeader("Content-Disposition", "attachment; filename=" & nombre.Replace(" ", "_") & "")
                    Response.ContentType = "application/pdf"
                    Response.AddHeader("Content-length", bytesRead.ToString())
                    Response.BinaryWrite(fileData)
                Else
                    Dim objDocumento As New DocumentoServicioMensajeria(idDocumento:=idDocumento)
                    With objDocumento
                        rutaDocumento = Server.MapPath("~/MensajeriaEspecializada/") & .RutaAlmacenamiento & "\" & .IdentificadorUnico.ToString()

                        Response.AddHeader("Content-Disposition", "attachment; filename=" & .NombreArchivo.Replace(" ", "_") & "")
                        Response.ContentType = .TipoContenido
                        Response.TransmitFile(rutaDocumento)
                        Response.End()
                    End With
                End If
            Else
                epPrincipal.showWarning("No se logro obtener el identificador del documento, por favor regrese a la página anterior.")
            End If
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al intentar procesar la página: " & ex.Message)
        End Try
    End Sub
#End Region

#Region "Estructuras"

    Private Function CrearEstructuraServiciosAdicionados() As DataTable
        Dim dtAux As New DataTable
        With dtAux.Columns
            .Add("idProducto", GetType(Integer))
            .Add("serial", GetType(String))
            .Add("producto", GetType(String))
            .Add("codigo", GetType(String))
            '.Add("idColor", GetType(Integer))
            '.Add("idElemento", GetType(Integer))
            '.Add("idAccesorio", GetType(String))
            '.Add("idFallas", GetType(String))
            '.Add("elemento", GetType(String))
            '.Add("marca", GetType(String))
            '.Add("modelo", GetType(String))
            '.Add("color", GetType(String))
            '.Add("fallas", GetType(String))
            '.Add("accesorios", GetType(String))
            '.Add("tipoContenedor", GetType(Integer))
            '.Add("idContenedor", GetType(String))
            .Add("bodegaOrigen", GetType(String))
            .Add("idOrigen", GetType(String))
            .Add("idDestino", GetType(Integer))
        End With
        Return dtAux
    End Function

#End Region

End Class