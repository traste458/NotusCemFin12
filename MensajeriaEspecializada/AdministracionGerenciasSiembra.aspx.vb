Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class AdministracionGerenciasSiembra
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack And Not IsCallback Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Gestión de Gerencias")
            End With
            CargaDatosIniciales()
        End If
        'OrElse gluDocumentos.GridView.IsCallback OrElse Not Me.IsPostBack
        'If pcEdicionCoordinacion.IsCallback Then CargarConsultores()
    End Sub

    Private Sub gvResultado_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvResultado.CustomCallback
        Try
            CargarGerencias()
        Catch ex As Exception
            miEncabezado.showError(ex.Message)
            CType(sender, ASPxGridView).JSProperties("cpMensajeConsulta") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Private Sub gvResultado_DataBinding(sender As Object, e As System.EventArgs) Handles gvResultado.DataBinding
        If Session("objGerencias") IsNot Nothing Then gvResultado.DataSource = DirectCast(Session("objGerencias"), GerenciaClienteColeccion)
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        Try
            Dim arrParametro() As String = e.Parameter.Split("|")
            Select Case arrParametro(0)
                Case "registrar"
                    RegistrarGerencia()
                    LimpiarFormulario()
                    CargaDatosIniciales()

                    CType(sender, ASPxCallbackPanel).JSProperties("cpMensajeRegistro") = miEncabezado.RenderHtml()

                Case "desvincular"
                    DesvincularCoordinador(CInt(arrParametro(1)))
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMensajeRegistro") = miEncabezado.RenderHtml()

                Case "desvincularConsultor"
                    DesvincularConsultor(CInt(arrParametro(1)))
                    CType(sender, ASPxCallbackPanel).JSProperties("cpMensajeRegistro") = miEncabezado.RenderHtml()

                Case Else
                    Throw New ArgumentNullException("Opcion no valida")

            End Select
        Catch ex As Exception
            miEncabezado.showError(ex.Message)
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensajeRegistro") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Protected Sub gvDetalleGerencia_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idGerencia As Integer = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            Dim objCoordinadores As New PersonalEnGerenciaColeccion()
            With objCoordinadores
                .IdGerencia = idGerencia
                .TipoPersona = Enumerados.TipoPersonaSiembra.Coordinador
                .CargarDatos()
                TryCast(sender, ASPxGridView).DataSource = objCoordinadores
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub gvDetalleCoordinacion_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim IdPersonaGerencia As Integer = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()

            Dim obPersonalEnGerencia As New PersonalEnGerencia(IdPersonaGerencia)
           
            Dim objConsultores As New PersonalEnGerenciaColeccion()
            With objConsultores
                .IdPersonaPadre = obPersonalEnGerencia.IdPersona
                .CargarDatos()
                TryCast(sender, ASPxGridView).DataSource = objConsultores
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkModificar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkModificar.NamingContainer, GridViewDataItemTemplateContainer)

            'Link Modificación
            With linkModificar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub LinkDetalle_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idGerencia As Integer
        Dim idconsultor As Integer
        Try
            Dim linkDesvincular As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkDesvincular.NamingContainer, GridViewDataItemTemplateContainer)
            Dim gvDetalle As ASPxGridView = CType(templateContainer.NamingContainer, ASPxGridView)

            idGerencia = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdGerencia"))
            idconsultor = CInt(templateContainer.KeyValue)
            Dim obPersonalCoordinador As New PersonalEnGerencia(idconsultor)

            'Link desvincular
            With linkDesvincular
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", CInt(templateContainer.KeyValue))
            End With

            'Link adicionar consultores
            Dim lnkAdicionarConsultor As ASPxHyperLink = CType(templateContainer.FindControl("lnkAdicionarConsultor"), ASPxHyperLink)
            With lnkAdicionarConsultor
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", obPersonalCoordinador.IdPersona)
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{1}", idGerencia)
            End With

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub LinkDetalleCoordinacion_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkDesvincular As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkDesvincular.NamingContainer, GridViewDataItemTemplateContainer)

            'Link desvincular
            With linkDesvincular
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub pcEdicionGerencia_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEdicionGerencia.WindowCallback
        Dim objGerencia As GerenciaCliente
        Dim respuesta As ResultadoProceso
        Try
            Dim arrParametro() As String = e.Parameter.Split("|")
            objGerencia = New GerenciaCliente(idGerencia:=CInt(arrParametro(1)))
            Select Case arrParametro(0)
                Case "abrir"

                    With objGerencia
                        txtEdicionIdGerencia.Text = .IdGerencia
                        txtEdicionNombreGerencia.Text = .Nombre
                        cbEdicionActivo.Checked = .Activo
                        CargarCoordinadoresEdit()
                    End With
                Case "actualizar"
                    ActualizarGerencia(CInt(arrParametro(1)))
                    CargarCoordinadoresEdit()
                    'CType(sender, ASPxCallbackPanel).JSProperties("cpMensajeRegistro") = miEncabezado.RenderHtml()

                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select


        Catch ex As Exception
            miEncabezado.showError(ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensajeEdicion") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcEdicionCoordinacion_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEdicionCoordinacion.WindowCallback
        Try
            Dim arrParametro() As String = e.Parameter.Split("|")
            Select Case arrParametro(0)
                Case "abrirCoordinador"
                    Dim arrValores As String() = arrParametro(1).Split(",")
                    txtEdicionIdGerenciaCoordinador.Text = arrValores(1)
                    txtEdicionIdCoordinador.Text = arrValores(0)
                    CargarConsultores()
                Case "actualizarCoordinacion"
                    Dim arrValores() As String = arrParametro(1).Split(",")
                    ActualizarCoordinacion(CInt(arrValores(0)), CInt(arrValores(1)))
                    CargarConsultores()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

        Catch ex As Exception
            miEncabezado.showError(ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensajeEdicion") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaDatosIniciales()
        Try

            'Coordinadores
            Dim dtCoordinadores As DataTable = HerramientasMensajeria.ObtieneUsuariosGerenciaDisponible(Enumerados.TipoPersonaSiembra.Coordinador)
            With cblCoordiandores
                .Items.Clear()
                .ValueField = "idTercero"
                .TextField = "tercero"
                .DataSource = dtCoordinadores
                .DataBind()
            End With
           


            'btnAdicionarGerencia.Enabled = (dtEjecutivos.Rows.Count > 0)
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al realizar la carga inicial:" & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarGerencia()
        Dim respuesta As ResultadoProceso
        Try
            If cblCoordiandores.SelectedItems.Count > 0 Then
                Dim objGerencia As New GerenciaCliente()
                With objGerencia
                    .Nombre = txtNombreGerencia.Text
                    .Activo = cbActivo.Checked
                    .IdTerceroGerente = cmbGerente.Value

                    Dim listCoordinadores As New List(Of Integer)
                    For Each ejecutivo As ListEditItem In cblCoordiandores.SelectedItems
                        listCoordinadores.Add(ejecutivo.Value)
                    Next
                    .ListaCoordinadores = listCoordinadores

                    respuesta = .Registrar()
                End With

                If respuesta.Valor = 0 Then
                    miEncabezado.showSuccess(respuesta.Mensaje)
                Else
                    miEncabezado.showWarning(respuesta.Mensaje)
                End If
            Else
                miEncabezado.showWarning("No existen Coordinadores para asignar a la Gerencia.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarGerencias()
        Try
            Dim objGerencias As New GerenciaClienteColeccion()
            With objGerencias
                .Nombre = txtFiltroNombreGerencia.Text
                .Activo = cbFiltroActivo.Checked
                .CargarDatos()
            End With

            Session("objGerencias") = objGerencias
            With gvResultado
                .DataSource = objGerencias
                .DataBind()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNombreGerencia.Text = String.Empty
        cblCoordiandores.UnselectAll()
    End Sub

    Private Sub DesvincularCoordinador(ByVal idRegistro As Integer)
        Dim respuesta As ResultadoProceso
        Try
            Dim objCoordinador As New PersonalEnGerencia(idRegistro)

            Dim objCoordinadores As New PersonalEnGerenciaColeccion()
            With objCoordinadores
                .IdGerencia = objCoordinador.IdGerencia
                .IdPersonaPadre = objCoordinador.IdPersona
                .CargarDatos()
            End With
            If objCoordinadores.Count = 0 Then
                respuesta = objCoordinador.Eliminar()
                If respuesta.Valor = 0 Then
                    CargaDatosIniciales()
                    miEncabezado.showSuccess(respuesta.Mensaje)
                Else
                    miEncabezado.showWarning(respuesta.Mensaje)
                End If
            Else
                miEncabezado.showError("El coordinador no se puede eliminar tiene Consultores asociados ")

            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub DesvincularConsultor(ByVal idConsultor As Integer)
        Dim respuesta As ResultadoProceso
        Try
            Dim objConsultor As New PersonalEnGerencia(idConsultor)
            respuesta = objConsultor.Eliminar()

            If respuesta.Valor = 0 Then
                CargaDatosIniciales()
                miEncabezado.showSuccess(respuesta.Mensaje)
            Else
                miEncabezado.showWarning(respuesta.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarGerencia(ByVal idGerencia As Integer)
        Dim respuesta As ResultadoProceso
        Try
            Dim objGerencia As GerenciaCliente = New GerenciaCliente(idGerencia:=idGerencia)
            With objGerencia
                .Nombre = txtEdicionNombreGerencia.Text
                .Activo = cbEdicionActivo.Checked

                Dim listCoordinadoresseleccionados As List(Of Object) = cblEdicionCoordinadores.GridView().GetSelectedFieldValues("idtercero")
                Dim listCoordinadores As New List(Of Integer)
                For Each coordinador As Integer In listCoordinadoresseleccionados
                    listCoordinadores.Add(coordinador)
                Next
                .ListaCoordinadores = listCoordinadores
                respuesta = .Actualizar()

                If respuesta.Valor = 0 Then
                    CargaDatosIniciales()
                    CargarGerencias()
                    miEncabezado.showSuccess(respuesta.Mensaje)
                Else
                    miEncabezado.showWarning(respuesta.Mensaje)
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

    Private Sub ActualizarCoordinacion(ByVal idCoordinador As Integer, ByVal idGerencia As Integer)
        Dim respuesta As ResultadoProceso
        Dim valor = 1
        Dim listaDoc As List(Of Object) = gluEdicionConsultores.GridView().GetSelectedFieldValues("idtercero")
        Try
            Dim persona As PersonalEnGerencia
            For Each consultor As Integer In listaDoc
                persona = New PersonalEnGerencia()
                With persona
                    .IdGerencia = idGerencia
                    .IdPersonaPadre = idCoordinador
                    .IdPersona = consultor
                    respuesta = .Registrar()
                End With
                valor = respuesta.Valor
            Next

            If valor = 0 Then
                CargaDatosIniciales()
                CargarGerencias()
                miEncabezado.showSuccess(respuesta.Mensaje)
            Else
                miEncabezado.showWarning("No se seleccionó ningún Consultor")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado: " & ex.Message)
        End Try
    End Sub

#End Region

    Protected Sub gluDocumentos_DataBinding(sender As Object, e As EventArgs) Handles gluEdicionConsultores.DataBinding
        If Session("gluEdicionConsultores") IsNot Nothing Then gluEdicionConsultores.DataSource = DirectCast(Session("gluEdicionConsultores"), DataTable)
    End Sub

    Private Sub CargarConsultores()
        'Consultores

        Dim dtConsultores As DataTable = HerramientasMensajeria.ObtieneUsuariosGerenciaDisponible(Enumerados.TipoPersonaSiembra.Consultor)
        Session("gluEdicionConsultores") = dtConsultores
        With gluEdicionConsultores
            .DataSource = dtConsultores
            .DataBind()
        End With
    End Sub

    Protected Sub pcCreacionGerencia_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcCreacionGerencia.WindowCallback
        'Gerentes
        Dim dtGerentes As DataTable = HerramientasMensajeria.ObtieneUsuariosGerenciaDisponible(Enumerados.TipoPersonaSiembra.Gerente)
        With cmbGerente
            .Items.Clear()
            .ValueField = "idTercero"
            .TextField = "tercero"
            .DataSource = dtGerentes
            .DataBind()
        End With
    End Sub

    Private Sub CargarCoordinadoresEdit()
        'CargarCoordinadores
        Dim dtCoordinadores As DataTable = HerramientasMensajeria.ObtieneUsuariosGerenciaDisponible(Enumerados.TipoPersonaSiembra.Coordinador)
        Session("dtCoordinadores") = dtCoordinadores
        With cblEdicionCoordinadores
            .DataSource = dtCoordinadores
            .DataBind()
        End With
    End Sub

    Protected Sub cblEdicionCoordinadores_DataBinding(sender As Object, e As EventArgs) Handles cblEdicionCoordinadores.DataBinding
        If Session("dtCoordinadores") IsNot Nothing Then cblEdicionCoordinadores.DataSource = DirectCast(Session("dtCoordinadores"), DataTable)
    End Sub
End Class