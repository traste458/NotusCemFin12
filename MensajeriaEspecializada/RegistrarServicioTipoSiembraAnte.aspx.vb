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

Public Class RegistrarServicioTipoSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _PersonasGerencia As DataTable
    Private _Ciudades As DataTable
    Private _Equipos As DataTable
    Private _idServicioPadre As Long


    Private Shared infoEstados As InfoEstadoRestriccionCEM

#End Region

#Region "Propiedades"

    Public Property Equipos As DataTable
        Get
            If _Equipos Is Nothing Then EstructuraEquipos()
            Return _Equipos
        End Get
        Set(value As DataTable)
            _Equipos = value
        End Set
    End Property

    Public Property Ciudades As DataTable
        Get
            Return _Ciudades
        End Get
        Set(value As DataTable)
            _Ciudades = value
        End Set
    End Property

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

#Region "Eventos"

    Private Sub RegistrarServicioTipoSiembra_Init(sender As Object, e As System.EventArgs) Handles Me.Init

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not (Page.IsCallback) Then
            Seguridad.verificarSession(Me)
        End If

#If DEBUG Then
        Session("usxp001") = 33533
        Session("usxp009") = 140
        Session("usxp007") = 944
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

            If Not String.IsNullOrEmpty(Request.QueryString("idServicioPadre")) Then
                _idServicioPadre = CLng(Request.QueryString("idServicioPadre"))
                CargarInfoServicioPadre(_idServicioPadre)
            End If
        Else
            If Session("dtPersonasGerencia") IsNot Nothing Then _PersonasGerencia = Session("dtPersonasGerencia")
            If Session("dtCiudades") IsNot Nothing Then _Ciudades = Session("dtCiudades")
            If Session("dtEquipos") IsNot Nothing Then _Equipos = Session("dtEquipos")

        End If

        If cmbEquipo.IsCallback Then cmbEquipo.DataBind()
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
            Dim arrParametros() As String = e.Parameter.Split("|")

            Select Case arrParametros(0)
                Case "registrar"
                    infoEstados = New InfoEstadoRestriccionCEM(Enumerados.TipoServicio.Siembra, _
                                                       Enumerados.ProcesoMensajeria.Registro, _
                                                       Enumerados.ProcesoMensajeria.Registro, 0)

                    Dim objServicioSiembra As New ServicioMensajeriaSiembra()
                    With objServicioSiembra
                        .IdUsuario = CInt(Session("usxp001"))
                        .FechaRegistro = dateFechaSolicitud.Date
                        .FechaAsignacion = Now.Date
                        .IdEstado = infoEstados.IdEstadoSiguiente
                        .IdCiudad = cmbCiudadEntrega.Value
                        .NombreCliente = txtNombreEmpresa.Text
                        .IdentificacionCliente = txtIdentificacionCliente.Text
                        .TelefonoContacto = txtTelefonoFijo.Text
                        .ExtensionContacto = txtExtTelefonoFijo.Text
                        .NombreRepresentanteLegal = txtNombreRepresentante.Text
                        .TelefonoRepresentanteLegal = txtTelefonoMovilRepresentante.Text
                        .IdentificacionRepresentanteLegal = txtIdentificacionRepresentante.Text
                        .PersonaContacto = txtPersonaAutorizada.Text
                        .IdentificacionAutorizado = txtIdentificacionAutorizado.Text
                        .CargoAutorizado = txtCargoPersonaAutorizada.Text
                        .TelefonoAutorizado = txtTelefonoAutorizado.Text
                        .Direccion = memoDireccion.value
                        .DireccionEdicion = memoDireccion.DireccionEdicion
                        .ObservacionDireccion = memoObservacionDireccion.Text
                        .Barrio = txtBarrio.Text
                        .IdGerencia = cmbGerencia.Value
                        .IdCoordinador = cmbCoordinador.Value
                        .IdConsultor = cmbConsultor.Value
                        .ClienteClaro = rblClienteClaro.Value
                        .Observacion = memoObservaciones.Text

                        resultado = AdicionarReferenciaSim()
                        If resultado.Valor = 0 Then
                            .MinsDataTable = Equipos
                            .DetalleBloqueoInventario = AdicionarMateriales()

                            If (.DetalleBloqueoInventario IsNot Nothing) Then
                                resultado = .Registrar()
                            Else
                                resultado.EstablecerMensajeYValor(1, "No se han registrado equipos para la solicitud en cuestión")
                            End If
                        End If

                        If resultado.Valor = 0 Then
                            miEncabezado.showSuccess("Servicio registrado satisfactoriamente con el identificador: [" & .IdServicioMensajeria & "]")
                            LimpiarFormulario()
                        Else
                            miEncabezado.showWarning(resultado.Mensaje)
                        End If
                    End With

                Case "editarEquipo"
                    CargarDatosMin(arrParametros(1))
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

    Protected Sub Link_InitEquipo(ByVal sender As Object, ByVal e As EventArgs)
        Dim msisdn As String
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            msisdn = CStr(gvCombinacionEquipos.GetRowValuesByKeyValue(templateContainer.KeyValue, "msisdn"))

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


#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            'Fecha de Registro
            With dateFechaSolicitud
                .Date = Now.Date
                .ClientEnabled = False
            End With

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
            Else
                btnGuardar.ClientEnabled = False
                miEncabezado.showWarning("El usuario actual no se encuentra configurado en la Jerarquía de Personal SIEMBRA, por favor contacte al administrador.")
            End If

            'Clase SIM
            Session("dtClaseSim") = HerramientasMensajeria.ObtieneClasesSIM()
            'With cmbClaseSim
            '    .DataSource = HerramientasMensajeria.ObtieneClasesSIM()
            '    .ValueField = "idClase"
            '    .TextField = "nombre"
            '    .DataBind()
            'End With

            'Region


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



    Private Sub EstructuraEquipos()
        _Equipos = New DataTable()
        With _Equipos
            .Columns.Add(New DataColumn("tipo", GetType(String)))
            .Columns.Add(New DataColumn("msisdn", GetType(String)))
            .Columns.Add(New DataColumn("idPlan", GetType(String)))
            .Columns.Add(New DataColumn("plan", GetType(String)))
            .Columns.Add(New DataColumn("fechaDevolucion", GetType(Date)))
            .Columns.Add(New DataColumn("material", GetType(String)))
            .Columns.Add(New DataColumn("referencia", GetType(String)))
            .Columns.Add(New DataColumn("idTipoSim", GetType(String)))
            .Columns.Add(New DataColumn("tipoSim", GetType(String)))
            .Columns.Add(New DataColumn("materialSim", GetType(String)))
            .Columns.Add(New DataColumn("idRegion", GetType(String)))
            .Columns.Add(New DataColumn("region", GetType(String)))
            .Columns.Add(New DataColumn("idPaquete", GetType(String)))
            .Columns.Add(New DataColumn("paquete", GetType(String)))

            .PrimaryKey = New DataColumn() {_Equipos.Columns("msisdn")}
        End With
        _Equipos.AcceptChanges()
        Session("dtEquipos") = _Equipos
    End Sub

    Private Sub PersonalEnGerencia()
        _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
        Session("dtPersonasGerencia") = _PersonasGerencia
    End Sub

    Private Function AdicionarEquipo() As ResultadoProceso
        If Session("nombreRegion") = "" Then
            Dim objMaterialTipoSim As New MaterialEquipoClaseSIMColeccion()
            With objMaterialTipoSim
                .IdCiuda = cmbCiudadEntrega.Value
                .CargarDatos()
            End With
            Session("nombreRegion") = objMaterialTipoSim(0).nombreRegion.ToString
            Session("idRegion") = objMaterialTipoSim(0).idRegion.ToString
        End If
        Dim respuesta As New ResultadoProceso
        Try
            If Not Equipos.Rows.Contains(txtMsisdn.Value) Then
                Dim filaEquipo As DataRow = Equipos.NewRow()
                With filaEquipo
                    .Item("tipo") = rblTipo.Value
                    .Item("msisdn") = txtMsisdn.Value
                    If cmbPlan.Value IsNot Nothing Then
                        .Item("idPlan") = cmbPlan.Value
                        .Item("plan") = cmbPlan.Text
                    End If
                    If cmbPaquete.Value IsNot Nothing Then
                        .Item("idPaquete") = cmbPaquete.Value
                        .Item("paquete") = cmbPaquete.Text
                    End If
                    .Item("fechaDevolucion") = dateFechaDevolucionEquipo.Date
                    .Item("material") = cmbEquipo.Value
                    .Item("referencia") = cmbEquipo.Text
                    If cmbClaseSim.Value IsNot Nothing Then 'And cmbRegion.Value IsNot Nothing 
                        .Item("idTipoSim") = cmbClaseSim.Value
                        .Item("tipoSim") = cmbClaseSim.Text
                        .Item("idRegion") = Session("idRegion")
                        .Item("region") = Session("nombreRegion")
                        Session("nombreRegion") = ""
                    End If
                End With
                Equipos.Rows.Add(filaEquipo)

                CargarEquipos()
                respuesta.EstablecerMensajeYValor(0, "El MSISDN [" + txtMsisdn.Value + "] fue adicionado correctamente.")
            Else
                respuesta.EstablecerMensajeYValor(1, "El MSISDN [" + txtMsisdn.Value + "] ya se encuentra seleccionado, por favor verifique e intente nuevamente.")
            End If
        Catch ex As Exception
            respuesta.EstablecerMensajeYValor(2, "Se generó un error inesperado: " & ex.Message)
        End Try
        Return respuesta
    End Function

    Private Function ActualizarEquipo() As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        Try
            Dim filaEditar As DataRow = Equipos.Rows.Find(Session("msisdn"))
            With filaEditar
                .Item("tipo") = rblTipo.Value
                .Item("msisdn") = txtMsisdn.Value
                If cmbPlan.Value IsNot Nothing Then
                    .Item("idPlan") = cmbPlan.Value
                    .Item("plan") = cmbPlan.Text
                Else
                    .Item("idPlan") = ""
                    .Item("plan") = ""
                End If
                If cmbPaquete.Value IsNot Nothing Then
                    .Item("idPaquete") = cmbPaquete.Value
                    .Item("paquete") = cmbPaquete.Text
                Else
                    .Item("idPaquete") = ""
                    .Item("paquete") = ""
                End If
                .Item("fechaDevolucion") = dateFechaDevolucionEquipo.Date
                .Item("material") = cmbEquipo.Value
                .Item("referencia") = cmbEquipo.Text
                If cmbClaseSim.Value IsNot Nothing Then 'And cmbRegion.Value IsNot Nothing  
                    .Item("idTipoSim") = cmbClaseSim.Value
                    .Item("tipoSim") = cmbClaseSim.Text
                    .Item("idRegion") = Session("idRegion")
                    .Item("region") = Session("nombreRegion")
                Else
                    .Item("idTipoSim") = ""
                    .Item("tipoSim") = ""
                    .Item("idRegion") = ""
                    .Item("region") = ""
                End If
            End With
            Equipos.AcceptChanges()
            CargarEquipos()
            EstablecerBotonesActualizarEquipos(False)
            respuesta.EstablecerMensajeYValor(0, "El MSISDN [" + txtMsisdn.Value + "] fue actualizado correctamente.")
            Session.Remove("msisdn")
        Catch ex As Exception
            respuesta.EstablecerMensajeYValor(2, "Se generó un error inesperado: " & ex.Message)
        End Try
        Return respuesta
    End Function

    Private Function EliminarEquipo(ByVal msisdn As String) As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        Try
            If Equipos.Rows.Contains(msisdn) Then
                Equipos.Rows.Remove(Equipos.Rows.Find(msisdn))
                Equipos.AcceptChanges()

                CargarEquipos()
                respuesta.EstablecerMensajeYValor(0, "Se elimino el MSISDN [" + msisdn + "], ya que no se encuentra registrado.")
            Else
                respuesta.EstablecerMensajeYValor(1, "No es posible eliminar el material [" + msisdn + "], ya que no se encuentra registrado.")
            End If
        Catch ex As Exception
            Throw ex
        End Try
        Return respuesta
    End Function

    Private Sub CargarEquipos()
        With gvCombinacionEquipos
            .DataSource = Equipos
            .DataBind()
        End With
    End Sub

    Private Sub LimpiarFormulario()
        Try
            Session.Remove("dtEquipos")

            dateFechaSolicitud.Date = Now.Date
            'cmbCiudadEntrega.SelectedIndex = -1
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
            memoDireccion.value = Nothing
            memoDireccion.Limpiar()
            memoObservacionDireccion.Text = String.Empty
            txtBarrio.Text = String.Empty
            rblClienteClaro.SelectedIndex = -1
            memoObservaciones.Text = String.Empty

            'Equipos
            cmbEquipo.SelectedIndex = -1
            dateFechaDevolucionEquipo.Date = Nothing
            With gvCombinacionEquipos
                .DataSource = Nothing
                .DataBind()
            End With

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

        Catch : End Try
    End Sub

    Private Function AdicionarReferenciaSim() As ResultadoProceso
        Dim respuesta As New ResultadoProceso
        Dim dtDatosInventario As DataTable
        Dim strMensaje As New StringBuilder()
        Try
            For Each fila As DataRow In Equipos.Rows
                If Not IsDBNull(fila("idTipoSim")) AndAlso Not String.IsNullOrEmpty(fila("idTipoSim")) Then

                    Dim objInventario As New InventarioBodegaSateliteColeccion
                    With objInventario
                        .IdClaseSim = New List(Of Short)(New Short() {CInt(fila("idTipoSim"))})
                        .IdRegion = New List(Of Short)(New Short() {CInt(fila("idRegion"))})
                        If Session("dtCiudades") IsNot Nothing Then
                            .IdBodega = DirectCast(Session("dtCiudades"), DataTable).AsEnumerable().[Select](Function(x) CInt(x("idBodega"))).ToList()
                        End If
                    End With

                    Dim dvDatos As DataView = objInventario.ObtieneInventarioAgrupado().DefaultView
                    If ((dvDatos.Count > 0) AndAlso (dvDatos IsNot Nothing)) Then
                        With dvDatos
                            .RowFilter = "cantidad > 0"
                            .Sort = "cantidad desc"
                        End With
                        dtDatosInventario = dvDatos.ToTable()
                        If dtDatosInventario.Rows.Count > 0 Then
                            Dim filaMayor As DataRow = dtDatosInventario.Rows(0)
                            With fila
                                .Item("materialSim") = filaMayor("material")
                            End With
                        Else
                            strMensaje.AppendLine("No se encontro material para [" + fila("tipoSim") + "-" + fila("region") + "]")
                        End If
                    Else
                        strMensaje.AppendLine("No se encontro material para [" + fila("tipoSim") + "-" + fila("region") + "]")
                    End If
                End If
            Next

            If strMensaje.Length = 0 Then
                respuesta.EstablecerMensajeYValor(0, "")
            Else
                respuesta.EstablecerMensajeYValor(1, strMensaje.ToString())
            End If
        Catch ex As Exception
            Throw ex
        End Try
        Return respuesta
    End Function

    Private Function AdicionarMateriales() As BloqueoInventario
        Dim objBloqueoInventario As New BloqueoInventario()
        Dim idBloqueo As Integer = 0
        Dim respuesta As New ResultadoProceso
        Dim detalleReferencia As DetalleProductoBloqueo
        Try
            Dim objReferencias As New DetalleProductoBloqueoColeccion()
            If Equipos.Rows.Count <> 0 Then


                For Each referencia As DataRow In Equipos.Rows

                    If Not IsDBNull(referencia("material")) And Not IsDBNull(referencia("materialSim")) Then
                        'Equipo y Sim 

                        detalleReferencia = New DetalleProductoBloqueo()
                        With detalleReferencia
                            .IdProducto = (New MaterialColeccion(referencia("material").ToString()))(0).IdProductoPadre
                            .Material = referencia("material").ToString()
                            .Cantidad = 1
                        End With
                        objReferencias.Adicionar(detalleReferencia)

                        detalleReferencia = New DetalleProductoBloqueo()
                        With detalleReferencia
                            .IdProducto = (New MaterialColeccion(referencia("materialSim").ToString()))(0).IdProductoPadre
                            .Material = referencia("materialSim").ToString()
                            .Cantidad = 1
                        End With
                        objReferencias.Adicionar(detalleReferencia)

                    ElseIf Not IsDBNull(referencia("material")) And IsDBNull(referencia("materialSim")) Then
                        detalleReferencia = New DetalleProductoBloqueo()
                        With detalleReferencia
                            .IdProducto = (New MaterialColeccion(referencia("material").ToString()))(0).IdProductoPadre
                            .Material = referencia("material").ToString()
                            .Cantidad = 1
                        End With
                        objReferencias.Adicionar(detalleReferencia)

                    Else
                        detalleReferencia = New DetalleProductoBloqueo()
                        With detalleReferencia
                            .IdProducto = (New MaterialColeccion(referencia("materialSim").ToString()))(0).IdProductoPadre
                            .Material = referencia("materialSim").ToString()
                            .Cantidad = 1
                        End With
                        objReferencias.Adicionar(detalleReferencia)

                    End If
                Next
                With objBloqueoInventario
                    .IdBodega = Ciudades.Select("idCiudad=" & cmbCiudadEntrega.Value)(0).Item("idBodega")
                    .FechaRegistro = Nothing
                    .IdUsuario = CInt(Session("usxp001"))
                    .IdEstado = Enumerados.InventarioBloqueo.Confirmado
                    .FechaInicio = Now()
                    .FechaFin = Nothing
                    .IdUnidadNegocio = Enumerados.UnidadNegocio.MensajeriaEspecializada
                    .IdDestinatario = Nothing
                    .IdTipoBloqueo = Enumerados.TipoBloqueo.ReservadeInventario
                    .Observacion = "Bloqueo generado por Servicio SIEMBRA"
                    If objReferencias.Count > 0 Then .ProductoBloqueoColeccion.AdicionarRango(objReferencias)
                End With
            Else
                respuesta.EstablecerMensajeYValor(1, "No se han registrado equipos para la solicitud en cuestión")
                Exit Function
            End If
        Catch ex As Exception
            Throw ex
        End Try
        Return objBloqueoInventario
    End Function

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

    Private Sub CargarDatosMin(msisdn As String)
        Dim filaMin As DataRow = Equipos.Rows.Find(msisdn)
        CargarTodosLosTiposDeSim()
        ControlarCambioCombinacion(filaMin("tipo"))
        rblTipo.Value = filaMin("tipo")

        Session("msisdn") = filaMin("msisdn")
        txtMsisdn.Text = filaMin("msisdn")

        dateFechaDevolucionEquipo.Date = filaMin("fechaDevolucion")
        cmbPlan.Value = filaMin("idPlan")
        cmbPaquete.Value = filaMin("idPaquete")
        If Not IsDBNull(filaMin("material")) AndAlso Not String.IsNullOrEmpty(filaMin("material")) Then
            CargarListadoMateriales(filaMin("material"))
            cmbEquipo.Value = filaMin("material")
        End If
        cmbClaseSim.Value = Convert.ToInt32(filaMin("idTipoSim"))
        'cmbRegion.Value = filaMin("idRegion")

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

    Private Sub CargarInfoServicioPadre(idServicioPadre As Long)
        Dim objServicioPadre As New ServicioMensajeriaSiembra(idServicioPadre)
        With objServicioPadre
            cmbCiudadEntrega.Value = CStr(.IdCiudad)
            txtNombreEmpresa.Text = .NombreCliente
            txtIdentificacionCliente.Text = .IdentificacionCliente
            txtTelefonoFijo.Text = .TelefonoContacto
            txtExtTelefonoFijo.Text = .ExtensionContacto
            txtNombreRepresentante.Text = .NombreRepresentanteLegal
            txtIdentificacionRepresentante.Text = .IdentificacionRepresentanteLegal
            txtTelefonoMovilRepresentante.Text = .TelefonoRepresentanteLegal
            txtPersonaAutorizada.Text = .PersonaContacto
            txtIdentificacionAutorizado.Text = .IdentificacionAutorizado
            txtCargoPersonaAutorizada.Text = .CargoAutorizado
            txtTelefonoAutorizado.Text = .TelefonoAutorizado
            memoDireccion.value = .Direccion
            memoDireccion.DireccionEdicion = .DireccionEdicion
            memoObservacionDireccion.Text = .ObservacionDireccion
            txtBarrio.Text = .Barrio
            rblClienteClaro.Value = IIf(.ClienteClaro, "1", "0")
            memoObservaciones.Text = .Observacion
        End With
    End Sub

#End Region


    Private Sub cmbEquipo_DataBound(sender As Object, e As EventArgs) Handles cmbEquipo.DataBound
        If cmbEquipo.DataSource Is Nothing AndAlso Session("dtmaterialesSiembra") IsNot Nothing Then cmbEquipo.DataSource = CType(Session("dtmaterialesSiembra"), DataTable)
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
End Class