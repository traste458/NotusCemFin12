Imports System.IO
Imports System.Globalization
Imports ILSBusinessLayer.SAC
Imports ILSBusinessLayer

Partial Public Class EdicionCasoSACCEM
    Inherits System.Web.UI.Page
    Dim idCaso As Integer


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epGeneral.clear()

        If Not Me.IsPostBack Then
            With dpFechaGestion
                .VisibleDate = Now
                .MaxValidDate = Now
            End With
            epGeneral.setTitle("Edición Gestión de Caso de Servicio Al Cliente")
            epGeneral.showReturnLink("BuscarCasoSAC.aspx?filtrar=true")
            Session.Remove("CasoSACGestionar")
            Session.Remove("listaRespuestaGestion")
            Try
                If Request.QueryString("idCaso") IsNot Nothing Then
                    Dim idCaso As Integer
                    Integer.TryParse(Request.QueryString("idCaso"), idCaso)
                    hIdCaso.Value = idCaso.ToString
                    CargarTiposDeGestion()
                    CargarClientes()
                    CargarClasesDeCaso()
                    CargarTiposDeCaso()
                    CargarInformacionGeneralDelCaso(idCaso)
                    CargarListadoFuncionarios()
                    CargarListadoOrigenRespuesta()
                    gvRespuesta.DataBind()
                    CargarGestiones()
                    btnEditar.Visible = False
                    btnCancelar.Visible = False
                Else
                    epGeneral.showWarning("Imposible recuperar el identificador del caso. Por favor regrese a la página anterior e intente nuevamente.")
                End If
            Catch ex As Exception
                epGeneral.showError("Error al tratar de cargar datos. " & ex.Message)
            End Try
        End If

    End Sub

    Private Sub CargarInformacionGeneralDelCaso(ByVal idCaso As Integer)

        Try
            Dim infoCaso As New CasoSAC(idCaso)
            If infoCaso.Registrado Then
                With infoCaso
                    lblNoCaso.Text = .Consecutivo
                    lblCliente.Text = .Cliente
                    'lblClaseCaso.Text = .ClaseDeServicio
                    ddlClaseCaso.SelectedValue = .IdClaseServicio
                    CargarTiposDeCaso(.IdClaseServicio)
                    'lblTipoCaso.Text = .TipoDeServicio
                    ddlTipoCaso.SelectedValue = .IdTipoServicio
                    'lblFechaRecepcion.Text = .FechaDeRecepcion
                    dpFechaRecepcion.SelectedDateString = .FechaDeRecepcion.ToString
                    lblRemitente.Text = .Remitente
                    lblTramitador.Text = .Tramitador
                    lblEstado.Text = .Estado
                    If .FechaRespuesta > Date.MinValue Then lblFechaRespuesta.Text = .FechaRespuesta
                    txtDescripcionCaso.Text = .Descripcion
                    txtObservacion.Text = .Observacion
                    'lblDescripcion.Text = .Descripcion
                    'lblObservacion.Text = .Observacion
                    dpFechaGestion.MinValidDate = .FechaDeRecepcion
                    hfFechaRecepcion.Value = .FechaDeRecepcion.ToString("MM/dd/yyyy HH:mm:ss")
                End With
                Session("CasoSACGestionar") = infoCaso
            Else
                epGeneral.showWarning("Imposible recuperar la información general del caso. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener información general del caso. " & ex.Message, ex)
        End Try
    End Sub

    Private Sub CargarTiposDeGestion()
        Dim listaTipoGestion As New TipoGestionSACColeccion
        Try
            With listaTipoGestion
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlTipoGestion
                .DataSource = listaTipoGestion
                .DataTextField = "Descripcion"
                .DataValueField = "IdTipo"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione Tipo de Gestión", "0"))
            End With
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Tipos de Gestión. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarListadoFuncionarios()
        Dim listaFuncionario As New UsuarioModuloSACColeccion
        Try
            With listaFuncionario
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlFuncionario
                .DataSource = listaFuncionario
                .DataTextField = "nombre"
                .DataValueField = "idUsuario"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione Funcionario", "0"))
            End With
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de posibles Funcionarios. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarClasesDeCaso()
        Dim listaClaseCasoSAC As New ClaseDeServicioSACColeccion
        Try
            With listaClaseCasoSAC
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlClaseCaso
                .DataSource = listaClaseCasoSAC
                .DataTextField = "descripcion"
                .DataValueField = "idClase"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione Clase de Caso", "0"))
            End With
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Clases de Caso. " & ex.Message)
        End Try

    End Sub


    Private Sub CargarTiposDeCaso(Optional ByVal idClase As Integer = 0)
        Try
            If idClase > 0 Then
                Dim listaTipoCaso As New TipoDeServicioSACColeccion
                listaTipoCaso.IdClaseServicio.Add(idClase)
                listaTipoCaso.CargarDatos()
                With ddlTipoCaso
                    .DataSource = listaTipoCaso
                    .DataTextField = "descripcion"
                    .DataValueField = "idTipo"
                    .DataBind()
                End With
            Else
                ddlTipoCaso.Items.Clear()
            End If
            ddlTipoCaso.Items.Insert(0, New ListItem("Seleccione un Tipo de Caso", "0"))
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Clientes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoOrigenRespuesta()
        Dim listaOrigen As New OrigenRespuestaGestionCasoSACColeccion
        Try
            With listaOrigen
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            Dim dtOrigen As DataTable = listaOrigen.GenerarDataTable()
            Dim pkKey() As DataColumn = {dtOrigen.Columns("idOrigenRespuesta")}
            dtOrigen.PrimaryKey = pkKey

            With rblOrigenRespuesta
                .DataSource = dtOrigen
                .DataTextField = "descripcion"
                .DataValueField = "idOrigenRespuesta"
                .DataBind()
            End With
            Session("dtOrigenRespuesta") = dtOrigen
            With rblOrigenRespuesta
                .SelectedIndex = .Items.IndexOf(.Items.FindByValue("1"))
            End With
            Dim idOrigen As Byte
            Byte.TryParse(rblOrigenRespuesta.SelectedValue, idOrigen)
            ValidarSeleccioOrigenRespuesta(idOrigen, dtOrigen)
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Origen de Respuesta. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarHoras(ByRef ddlHora As ListControl, ByRef ddlMinutos As ListControl)
        With ddlHora
            For index As Integer = 0 To 23
                .Items.Add(New ListItem(index.ToString("00"), index))
            Next
            .ClearSelection()
        End With
        With ddlMinutos
            For index As Integer = 0 To 59
                .Items.Add(New ListItem(index.ToString("00"), index))
            Next
            .ClearSelection()
        End With
    End Sub

    Private Sub CargarClientes(Optional ByVal idTipoGestion As Short = 0)

        Try
            If idTipoGestion > 0 Then
                Dim listaTipoCliente As New TipoDeClienteSACColeccion
                Dim listaClientes As New ClienteSACColeccion
                With listaTipoCliente
                    .Activo = Enumerados.EstadoBinario.Activo
                    .IdTipoGestion.Add(idTipoGestion)
                    .CargarDatos()
                End With

                With listaClientes
                    .Activo = Enumerados.EstadoBinario.Activo
                    If listaTipoCliente.Count > 0 Then
                        For index As Integer = 0 To listaTipoCliente.Count - 1
                            .IdTipo.Add(CType(listaTipoCliente(index), TipoDeClienteSAC).IdTipoCliente)
                        Next
                    End If
                    .CargarDatos()
                End With
                With ddlCliente
                    .DataSource = listaClientes
                    .DataTextField = "Nombre"
                    .DataValueField = "IdCliente"
                    .DataBind()
                End With
            Else
                If ddlCliente.Items.Count > 1 Then ddlCliente.Items.Clear()
            End If
            ddlCliente.Items.Insert(0, New ListItem("Seleccione un Cliente", "0"))
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Clientes. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarGestiones()
        Try
            Dim elCaso As CasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Dim infoGestion As InfoGestionCasoSACColeccion = elCaso.DetalleGestion
            Dim dtDatos As DataTable = Nothing
            If elCaso.DetalleGestion.Count > 0 Then
                ltAux.Visible = False
                dtDatos = elCaso.DetalleGestion.GenerarDataTable()
                trCerrarCaso.Visible = True
                Session("infoGestion") = elCaso.DetalleGestion
            Else
                ltAux.Visible = True
                trCerrarCaso.Visible = False
            End If
            EnlazarInfoGestion(dtDatos)
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cargar el listado de Gestiones del Caso registradas. " & ex.Message)
        End Try
    End Sub

    Protected Sub ddlTipoGestion_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlTipoGestion.SelectedIndexChanged
        Dim idTipoGestion As Integer
        Integer.TryParse(ddlTipoGestion.SelectedValue, idTipoGestion)
        CargarClientes(idTipoGestion)
    End Sub

    Private Sub gvRespuesta_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvRespuesta.RowCommand
        Select Case e.CommandName.ToLower
            Case "descargar"
                Try
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, e.CommandArgument)
                Catch ex As Exception
                    epGeneral.showError("Error al tratar de descargar archivo de respuesta." & ex.Message)
                End Try

            Case "eliminar"
                Try
                    Dim listaRespuesta As RespuestaGestionCasoSACColeccion = ObtenerListaRespuesta()
                    Dim idRespuesta As Integer
                    If listaRespuesta.Count > 0 Then
                        If Integer.TryParse(e.CommandArgument, idRespuesta) Then
                            Dim indice As Integer = listaRespuesta.IndiceDe(idRespuesta)
                            Dim respuesta As RespuestaGestionCasoSAC = listaRespuesta(indice)
                            Dim minFecha As Date
                            listaRespuesta.RemoverDe(indice)
                            Date.TryParseExact(hfMinFechaRespuesta.Value, "MM/dd/yyyy HH:mm:ss", New CultureInfo("en-US"), DateTimeStyles.None, minFecha)
                            If minFecha = respuesta.FechaRecepcion Then
                                hfMinFechaRespuesta.Value = ""
                                GuardarFechaRespuestaMenor(listaRespuesta)
                            End If
                        Else
                            epGeneral.showError("Imposible determinar el identificador de posición del archivo. Por favor intente nuevamente")
                        End If
                    End If
                    EnlazarRespuestaNoRegistrada(listaRespuesta.GenerarDataTable())
                Catch ex As Exception
                    epGeneral.showError("Error al tratar de eliminar archivo de respuesta. " & ex.Message)
                End Try
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvRespuesta_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvRespuesta.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            'Dim requiereArchivo As Boolean
            'Boolean.TryParse(CType(e.Row.DataItem, DataRowView).Item("requiereArchivo").ToString, requiereArchivo)
            'Dim ibAux As ImageButton = CType(e.Row.FindControl("ibDescargar"), ImageButton)
            'If Not requiereArchivo Then ibAux.Visible = False

            Dim ibAux As ImageButton = CType(e.Row.FindControl("ibDescargar"), ImageButton)
            If CType(e.Row.DataItem, DataRowView).Item("nombreArchivo").ToString <> "" Then
                ibAux.Visible = True
            Else
                ibAux.Visible = False
            End If

        End If
    End Sub

    Protected Sub ibAdicionar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdicionar.Click
        Dim fileFullName As String
        Try
            Dim elCaso As CasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Dim listaRespuesta As RespuestaGestionCasoSACColeccion = ObtenerListaRespuesta()
            Dim filePath As String = Server.MapPath("~/SAC/DirectorioCasos/Caso_" & hIdCaso.Value)
            Dim numGestion As Integer = elCaso.DetalleGestion.Count + 1
            Dim nombreArchivo As String = ""
            Dim numRespuesta As Integer = 0

            If fuArchivo.PostedFile.FileName.Trim.Length > 0 Then
                If Not Directory.Exists(filePath) Then Directory.CreateDirectory(filePath)

                numRespuesta = listaRespuesta.Count
                Do
                    numRespuesta += 1
                    nombreArchivo = "CASO_" & elCaso.Consecutivo & "_GES_" & numGestion.ToString & "_RTA_" & numRespuesta.ToString &
                        Path.GetExtension(fuArchivo.PostedFile.FileName)
                    fileFullName = filePath & "\" & nombreArchivo
                Loop While File.Exists(fileFullName)
                fuArchivo.SaveAs(fileFullName)
                If Not File.Exists(fileFullName) Then
                    epGeneral.showWarning("Imposible subir el archivo seleccionado al servidor. Por favor intente nuevamente.")
                    Exit Sub
                End If
            End If
            Dim respuesta As New RespuestaGestionCasoSAC
            With respuesta
                .IdRespuesta = numRespuesta
                .IdOrigenRespuesta = CByte(rblOrigenRespuesta.SelectedValue)
                .Descripcion = rblOrigenRespuesta.SelectedItem.Text
                .OrigenRespuesta = rblOrigenRespuesta.SelectedItem.Text
                If nombreArchivo.Length > 0 Then
                    .NombreArchivo = nombreArchivo
                    .NombreArchivoConRuta = fileFullName
                    .NombreArchivoOriginal = Path.GetFileName(fuArchivo.PostedFile.FileName)
                End If
                .FechaRecepcion = dpFechaRespuesta.SelectedDate
            End With
            listaRespuesta.Adicionar(respuesta)
            EnlazarRespuestaNoRegistrada(listaRespuesta.GenerarDataTable())
            dpFechaRespuesta.SelectedDates.Clear()
            Session("listaRespuestaGestion") = listaRespuesta
            GuardarFechaRespuestaMenor(respuesta)

        Catch ex As Exception
            epGeneral.showError("Error al tratar de adicionar archivo de Respuesta. " & ex.Message)
        End Try
    End Sub

    Public Function ObtenerListaRespuesta() As RespuestaGestionCasoSACColeccion
        Dim listaRespuesta As RespuestaGestionCasoSACColeccion
        If Session("listaRespuestaGestion") IsNot Nothing Then
            listaRespuesta = CType(Session("listaRespuestaGestion"), RespuestaGestionCasoSACColeccion)
        Else
            listaRespuesta = New RespuestaGestionCasoSACColeccion()
        End If
        Return listaRespuesta
    End Function

    Private Sub EnlazarRespuestaNoRegistrada(ByVal dtRespuesta As DataTable)
        With gvRespuesta
            .DataSource = dtRespuesta
            .DataBind()
        End With
        hfNumRespuestas.Value = dtRespuesta.Rows.Count
    End Sub

    Private Sub EnlazarInfoGestion(ByVal dtDatos As DataTable)
        With repInfoGestion
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Try
            Dim infoGestion As New InfoGestionCasoSAC
            'Dim miCaso As CasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Dim resultado As New ResultadoProceso
            Dim idUsuario As Integer
            Dim listaRespuesta As RespuestaGestionCasoSACColeccion = ObtenerListaRespuesta()

            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            If idUsuario = 0 Then idUsuario = 1
            With infoGestion
                Integer.TryParse(hIdCaso.Value, .IdCaso)
                .IdTipoGestion = ddlTipoGestion.SelectedValue
                .IdCliente = ddlCliente.SelectedValue
                .IdGestionador = ddlFuncionario.SelectedValue
                .Descripcion = txtDescripcion.Text.Trim
                .FechaDeGestion = dpFechaGestion.SelectedDate
                .IdUsuarioRegistra = idUsuario
                If listaRespuesta.Count > 0 Then .ListadoRespuesta.AdicionarRango(listaRespuesta)
                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                LimpiarFormulario()
                CargarGestiones()
                epGeneral.showSuccess("La información de gestión fue registrada satisfactoriamente.")
            Else
                Select Case resultado.Valor
                    Case 1
                        epGeneral.showError(resultado.Mensaje)
                    Case Else
                        epGeneral.showWarning(resultado.Mensaje)
                End Select
            End If
        Catch ex As Exception
            epGeneral.showError("Error al tratar de registrar información de gestión del caso. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        ddlTipoGestion.ClearSelection()
        ddlCliente.ClearSelection()
        ddlFuncionario.ClearSelection()
        txtDescripcion.Text = ""
        dpFechaGestion.SelectedDates.Clear()
        dpFechaRespuesta.SelectedDates.Clear()
        gvRespuesta.DataBind()
        Session.Remove("listaRespuestaGestion")
    End Sub

    Protected Sub lbCerrarCaso_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbCerrarCaso.Click
        Try
            Response.Redirect("CerrarCasoSAC.aspx?idCaso=" & hIdCaso.Value)
        Catch ex As Exception
            epGeneral.showError("Error al tratar de cambiar página. " & ex.Message)
        End Try
    End Sub

    Private Sub repInfoGestion_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repInfoGestion.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Try
                Dim idGestion As Integer = CType(e.Item.DataItem, DataRowView).Item("IdGestion")
                Dim listaRespuesta As New RespuestaGestionCasoSACColeccion(idGestion)
                If listaRespuesta.Count > 0 Then
                    Dim gvAux As GridView = e.Item.FindControl("gvRespuestaRegistrada")
                    If gvAux IsNot Nothing Then
                        With gvAux
                            .DataSource = listaRespuesta.GenerarDataTable()
                            .DataBind()
                        End With
                    End If
                End If
            Catch ex As Exception
                epGeneral.showError("Error al tratar de enlazar el listado de archivos de respuesta de cada gestión. " & ex.Message)
            End Try

        End If
    End Sub

    Protected Sub gvRespuestaRegistrada_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            'Dim requiereArchivo As Boolean
            Dim ibAux As ImageButton = CType(e.Row.FindControl("ibDescargar"), ImageButton)
            If CType(e.Row.DataItem, DataRowView).Item("nombreArchivo").ToString <> "" Then
                ibAux.Visible = True
            Else
                ibAux.Visible = False
            End If
            'Boolean.TryParse(CType(e.Row.DataItem, DataRowView).Item("requiereArchivo").ToString, requiereArchivo)
            'Dim ibAux As ImageButton = CType(e.Row.FindControl("ibDescargar"), ImageButton)
            'If Not requiereArchivo Then ibAux.Visible = False
        End If
    End Sub

    Protected Sub gvRespuestaRegistrada_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Select Case e.CommandName.ToLower
            Case "descargar"
                Try
                    MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, e.CommandArgument)
                Catch ex As Exception
                    epGeneral.showError("Error al tratar de descargar archivo de respuesta." & ex.Message)
                End Try
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub GuardarFechaRespuestaMenor(ByVal listaRespuesta As RespuestaGestionCasoSACColeccion)
        For index As Integer = 0 To listaRespuesta.Count - 1
            GuardarFechaRespuestaMenor(listaRespuesta(index))
        Next
    End Sub

    Private Sub GuardarFechaRespuestaMenor(ByVal respuesta As RespuestaGestionCasoSAC)
        Dim minFecha As Date = respuesta.FechaRecepcion
        If Date.TryParseExact(hfMinFechaRespuesta.Value, "MM/dd/yyyy HH:mm:ss", New CultureInfo("en-US"), DateTimeStyles.None, minFecha) Then
            If respuesta.FechaRecepcion < minFecha Then minFecha = respuesta.FechaRecepcion
        Else
            minFecha = respuesta.FechaRecepcion
        End If
        hfMinFechaRespuesta.Value = minFecha.ToString("MM/dd/yyyy HH:mm:ss")
    End Sub

    Protected Sub ibCrearFuncionario_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibCrearFuncionario.Click
        'With dlgPopUp
        '    .ContentUrl = ""
        'End With
    End Sub

    Protected Sub cpFuncionario_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpFuncionario.Execute
        If e.Parameter.ToLower = "actualizarlistado" Then
            CargarListadoFuncionarios()
        End If
    End Sub

    Private Sub ValidarSeleccioOrigenRespuesta(ByVal idOrigen As Byte, ByVal dtOrigen As DataTable)
        If rblOrigenRespuesta.SelectedValue.Length > 0 Then
            Dim drAux As DataRow = dtOrigen.Rows.Find(idOrigen)
            If drAux IsNot Nothing Then
                rfvArchivo.Enabled = CBool(drAux("RequiereArchivo").ToString)
            End If
        End If
    End Sub

    Protected Sub rblOrigenRespuesta_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles rblOrigenRespuesta.SelectedIndexChanged
        Try
            If Session("dtOrigenRespuesta") IsNot Nothing Then
                Dim dtOrigen As DataTable = CType(Session("dtOrigenRespuesta"), DataTable)
                Dim idOrigen As Byte
                Byte.TryParse(rblOrigenRespuesta.SelectedValue, idOrigen)
                ValidarSeleccioOrigenRespuesta(idOrigen, dtOrigen)
            Else
                Throw New Exception("Imposible recuperar la tabla de configuración de los orígenes de respuesta. por favor recargue la página. ")
            End If
        Catch ex As Exception
            epGeneral.showError("Error al tratar de validar selección. " & ex.Message)
        End Try
    End Sub

    Private Sub lbEditarCaso_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbEditarCaso.Click
        Try
            Dim infoCasoSAC As CasoSAC
            Dim idUsuarioRegistra As Integer
            infoCasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Integer.TryParse(Session("usxp001"), idUsuarioRegistra)
            If idUsuarioRegistra = 0 Then idUsuarioRegistra = 1
            If Not infoCasoSAC Is Nothing Then
                With infoCasoSAC
                    .IdUsuarioRegistra = idUsuarioRegistra
                    Integer.TryParse(ddlClaseCaso.SelectedValue.ToString(), .IdClaseServicio)
                    Integer.TryParse(ddlTipoCaso.SelectedValue.ToString(), .IdTipoServicio)
                    .Descripcion = txtDescripcionCaso.Text
                    .Observacion = txtObservacion.Text
                    .FechaDeRecepcion = dpFechaRecepcion.SelectedDate
                    .ActualizarInformacionBasica()
                End With
                epGeneral.showSuccess("Actualización realizada correctamente.")
            Else
                epGeneral.showError("Error al obtener la información del caso.")
            End If
        Catch ex As Exception
            epGeneral.showError("Error al editar el caso. " & ex.Message)
        End Try
    End Sub

    Protected Sub repInfoGestion_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repInfoGestion.ItemCommand
        Try
            Dim idGestion As Integer
            If e.CommandName = "EditarGestion" Then
                Integer.TryParse(e.CommandArgument.ToString(), idGestion)
                CargarDatosEditarGestion(idGestion)
            End If
        Catch ex As Exception
            epGeneral.showError("Error al realizar la operación. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatosEditarGestion(ByVal idGestion As Integer)
        Try
            Dim gestion As New InfoGestionCasoSAC(idGestion)
            ddlTipoGestion.SelectedValue = gestion.IdTipoGestion
            CargarClientes(gestion.IdTipoGestion)
            ddlCliente.SelectedValue = gestion.IdCliente
            ddlFuncionario.SelectedValue = gestion.IdGestionador
            txtDescripcion.Text = gestion.Descripcion
            dpFechaGestion.SelectedDate = gestion.FechaDeGestion
            Session("listaRespuestaGestion") = gestion.ListadoRespuesta
            EnlazarRespuestaNoRegistrada(gestion.ListadoRespuesta.GenerarDataTable())
            repInfoGestion.Visible = False
            btnRegistrar.Visible = False
            btnEditar.Visible = True
            btnCancelar.Visible = True
            hfIdGestionEdicion.Value = idGestion.ToString()
        Catch ex As Exception
            epGeneral.showError("Error al cargar los datos para la edición de la gestión. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnEditar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditar.Click
        Try
            Dim idGestion As Integer
            Integer.TryParse(hfIdGestionEdicion.Value.ToString(), idGestion)
            Dim infoGestion As New InfoGestionCasoSAC(idGestion)
            'Dim miCaso As CasoSAC = CType(Session("CasoSACGestionar"), CasoSAC)
            Dim resultado As New ResultadoProceso
            Dim idUsuario As Integer
            Dim listaRespuesta As RespuestaGestionCasoSACColeccion = ObtenerListaRespuesta()

            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            If idUsuario = 0 Then idUsuario = 1
            With infoGestion
                Integer.TryParse(hIdCaso.Value, .IdCaso)
                .IdTipoGestion = ddlTipoGestion.SelectedValue
                .IdCliente = ddlCliente.SelectedValue
                .IdGestionador = ddlFuncionario.SelectedValue
                .Descripcion = txtDescripcion.Text.Trim
                .FechaDeGestion = dpFechaGestion.SelectedDate
                .IdUsuarioRegistra = idUsuario
                If listaRespuesta.Count > 0 Then .ListadoRespuesta.AdicionarRango(listaRespuesta, True)
                resultado = .Editar()
            End With
            If resultado.Valor = 0 Then
                LimpiarFormulario()
                CargarGestiones()
                epGeneral.showSuccess("La información de gestión fue editada satisfactoriamente.")
                btnRegistrar.Visible = True
                btnEditar.Visible = False
                btnCancelar.Visible = False
                repInfoGestion.Visible = True
            Else
                Select Case resultado.Valor
                    Case 1
                        epGeneral.showError(resultado.Mensaje)
                    Case Else
                        epGeneral.showWarning(resultado.Mensaje)
                End Select
            End If
        Catch ex As Exception
            epGeneral.showError("Error al tratar de editar la información de gestión del caso. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        btnRegistrar.Visible = True
        btnEditar.Visible = False
        btnCancelar.Visible = False
        LimpiarFormulario()
        repInfoGestion.Visible = True
        hfIdGestionEdicion.Value = ""
    End Sub
End Class

