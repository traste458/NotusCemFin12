Imports ILSBusinessLayer
Imports ILSBusinessLayer.SAC

Partial Public Class RegistrarCasoSAC
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificador.clear()
        epNotificacionSerial.clear()
        If Not Me.IsPostBack Then
            With dpFechaRecepcion
                .VisibleDate = Now
                .MaxValidDate = Now
            End With
            epNotificador.setTitle("Registrar Caso de Servicio Al Cliente")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            CargarTiposDeCliente()
            CargarClientes()
            CargarClasesDeCaso()
            CargarTiposDeCaso()
            CargarListadoRemitentes()
            CargarListaTramitadores()
            gvSerial.DataBind()
            CargarHoras()
        End If
    End Sub

    Private Sub CargarTiposDeCliente()
        Dim listaTipoClienteSAC As New TipoDeClienteSACColeccion
        Try
            With listaTipoClienteSAC
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlTipoCliente
                .DataSource = listaTipoClienteSAC
                .DataTextField = "descripcion"
                .DataValueField = "idTipoCliente"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione un Tipo de Cliente", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Tipos de Cliente. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarClientes(Optional ByVal idTipoCliente As Integer = 0)
        Try
            If idTipoCliente > 0 Then
                Dim listaCliente As New ClienteSACColeccion
                listaCliente.IdTipo.Add(idTipoCliente)
                listaCliente.CargarDatos()
                With ddlCliente
                    .DataSource = listaCliente
                    .DataTextField = "nombre"
                    .DataValueField = "idCliente"
                    .DataBind()
                End With
            Else
                ddlCliente.Items.Clear()
            End If
            ddlCliente.Items.Insert(0, New ListItem("Seleccione un Cliente", "0"))
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de Clientes. " & ex.Message)
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
            epNotificador.showError("Error al tratar de cargar el listado de Clases de Caso. " & ex.Message)
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
            epNotificador.showError("Error al tratar de cargar el listado de Clientes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoRemitentes()
        Dim listaRemitente As New UsuarioModuloSACColeccion
        Try
            With listaRemitente
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlRemitente
                .DataSource = listaRemitente
                .DataTextField = "nombre"
                .DataValueField = "idUsuario"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione Remitente", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de posibles Remitentes. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListaTramitadores()
        Dim listaTramitador As New UsuarioTramitadorCasoSACColeccion
        Try
            With listaTramitador
                .Activo = Enumerados.EstadoBinario.Activo
                .CargarDatos()
            End With
            With ddlTramitador
                .DataSource = listaTramitador
                .DataTextField = "nombre"
                .DataValueField = "idUsuario"
                .DataBind()
                .Items.Insert(0, New ListItem("Seleccione Tramitador", "0"))
            End With
        Catch ex As Exception
            epNotificador.showError("Error al tratar de cargar el listado de posibles Tramitadores. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarHoras()
        'With ddlHora
        '    For index As Integer = 0 To 23
        '        .Items.Add(New ListItem(index.ToString("00"), index))
        '    Next
        '    .ClearSelection()
        'End With
        'With ddlMinutos
        '    For index As Integer = 0 To 59
        '        .Items.Add(New ListItem(index.ToString("00"), index))
        '    Next
        '    .ClearSelection()
        'End With
    End Sub

    Protected Sub ddlTipoCliente_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlTipoCliente.SelectedIndexChanged
        Dim idTipoCliente As Short
        Short.TryParse(ddlTipoCliente.SelectedValue, idTipoCliente)
        CargarClientes(idTipoCliente)
    End Sub

    Protected Sub ddlClaseCaso_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlClaseCaso.SelectedIndexChanged
        Dim idClase As Short
        Short.TryParse(ddlClaseCaso.SelectedValue, idClase)
        CargarTiposDeCaso(idClase)
    End Sub

    Protected Sub ibAdicionar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdicionar.Click
        Dim listaSerial As New SerialSACColeccion
        Try
            If Session("listaSerialEnCaso") IsNot Nothing Then listaSerial = CType(Session("listaSerialEnCaso"), SerialSACColeccion)
            If Not listaSerial.ExisteSerial(txtSerial.Text.Trim) Then
                Dim infoSerial As New SerialCasoSAC
                Dim resultado As ResultadoProceso
                infoSerial.Serial = txtSerial.Text.Trim
                resultado = infoSerial.EsValidoParaAsigancionACaso()
                With resultado
                    If .Valor = 0 Or .Valor = 2 Then
                        listaSerial.Adicionar(infoSerial)
                        EnlazarSerial(listaSerial)
                        hfNumSeriales.Value = listaSerial.Count
                        txtSerial.Text = ""
                        txtSerial.Focus()
                    Else
                        If .Valor = 3 Then
                            epNotificacionSerial.showError("Imposible adicionar el serial al Caso. " & .Mensaje)
                        Else
                            epNotificacionSerial.showWarning("Imposible adicionar el serial al Caso. " & .Mensaje)
                        End If
                    End If
                End With

            Else
                epNotificacionSerial.showWarning("El serial proporcionado ya está asociado al caso")
            End If
        Catch ex As Exception
            epNotificacionSerial.showError("Error al tratar de adicionar serial. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarSerial(ByVal listaSerial As SerialSACColeccion)
        If listaSerial Is Nothing Then listaSerial = New SerialSACColeccion
        With gvSerial
            .DataSource = listaSerial
            .DataBind()
        End With
        Session("listaSerialEnCaso") = listaSerial
        MetodosComunes.mergeGridViewFooter(gvSerial)
    End Sub

    Private Sub gvSerial_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSerial.RowCommand
        If e.CommandName = "Eliminar" Then
            Try
                Dim serial As String = e.CommandArgument.ToString.Trim
                Dim listaSerial As New SerialSACColeccion
                If Session("listaSerialEnCaso") IsNot Nothing Then listaSerial = CType(Session("listaSerialEnCaso"), SerialSACColeccion)
                Dim indice As Integer = listaSerial.IndiceDe(serial)
                If indice > -1 Then
                    listaSerial.RemoverDe(indice)
                    EnlazarSerial(listaSerial)
                    hfNumSeriales.Value = listaSerial.Count
                Else
                    epNotificacionSerial.showWarning("Imposible encontrar el serial seleccionado en la colección. Por favor intente nuevamente.")
                End If
            Catch ex As Exception
                epNotificacionSerial.showError("Error al tratar de eliminar serial de la colección. " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrar.Click
        Try
            Dim miCaso As New CasoSAC
            Dim resultado As New ResultadoProceso
            Dim idUsuario As Integer
            Dim listaSerial As New SerialSACColeccion
            If Session("listaSerialEnCaso") IsNot Nothing Then listaSerial = CType(Session("listaSerialEnCaso"), SerialSACColeccion)
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001").ToString, idUsuario)
            If idUsuario = 0 Then idUsuario = 1
            With miCaso
                .IdCliente = ddlCliente.SelectedValue
                .IdTipoServicio = ddlTipoCaso.SelectedValue
                .IdRemitente = ddlRemitente.SelectedValue
                .Descripcion = txtDescripcion.Text.Trim
                .FechaDeRecepcion = dpFechaRecepcion.SelectedDate
                .IdTramitador = ddlTramitador.SelectedValue
                .IdUsuarioRegistra = idUsuario
                .Observacion = txtObservacion.Text.Trim
                If listaSerial.Count > 0 Then .DetalleSerial.AdicionarRango(listaSerial)
                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                LimpiarFormulario()
                epNotificador.showSuccess("El Caso fue registrado satisfactoriamente con el código: " & miCaso.Consecutivo)
            Else
                Select Case resultado.Valor
                    Case 1
                        epNotificador.showError(resultado.Mensaje)
                    Case Else
                        epNotificador.showWarning(resultado.Mensaje)
                End Select
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de registrar caso. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtDescripcion.Text = ""
        txtObservacion.Text = ""
        txtSerial.Text = ""
        dpFechaRecepcion.SelectedDates.Clear()
        ddlTipoCliente.ClearSelection()
        CargarClientes()
        ddlClaseCaso.ClearSelection()
        CargarTiposDeCaso()
        ddlRemitente.ClearSelection()
        ddlTramitador.ClearSelection()
        gvSerial.DataBind()
    End Sub

    Protected Sub cpRemitente_Execute(ByVal sender As Object, ByVal e As EO.Web.CallbackEventArgs) Handles cpRemitente.Execute
        Select Case e.Parameter
            Case "cargarRemitentes"
                CargarListadoRemitentes()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Protected Sub ibCrearRemitente_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibCrearRemitente.Click
        dlgPopUp.IsModal = True
        dlgPopUp.Show()
        cpRemitente.Update()
    End Sub
End Class