Imports ILSBusinessLayer
Imports DevExpress.Web
Imports System.Collections.Generic
Imports System.Text
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Productos

Public Class CrearRutaTransportadoraCEM
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 22058
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If

        If Not IsPostBack And Not IsCallback Then
            CargaInicial()
        End If

        If IsPostBack Then
            If (cmbTipoAsignacion.Value = 1) Then
                lblTipoBodegaOrigen.ClientVisible = True
                cmbTipoBodegaOrigen.ClientVisible = True
                lblBodegaOrigen.ClientVisible = True
                cmbBodegaOrigen.ClientVisible = True
                lblTipoBodegaDestino.ClientVisible = True
                cmbTipoBodegaDestino.ClientVisible = True
                lblBodegaDestino.ClientVisible = True
                cmbBodegaDestino.ClientVisible = True
            Else
                lblTipoBodegaDestino.ClientVisible = False
                cmbTipoBodegaDestino.ClientVisible = False
                lblBodegaDestino.ClientVisible = False
                cmbBodegaDestino.ClientVisible = False
            End If
        End If
    End Sub

    Private Sub CargaInicial()

        Dim despacho As New RutaServicioMensajeriaTransportadora
        despacho.LimpiarDespachosTemporal()

        Dim dtTransportadora As DataTable = ObtenerTransportadoras()
        Session("dtTransportadora") = dtTransportadora
        MetodosComunes.CargarComboDX(cmbTransportadora, dtTransportadora, "idtransportadora", "transportadora")

        Dim tipoBodega As New CargueInventarioCemMasivoSerializado
        Dim dtTipoBodega As New DataTable
        dtTipoBodega = tipoBodega.ConsultarTipoBodega
        Session("dtTipoBodega") = dtTipoBodega

        MetodosComunes.CargarComboDX(cmbTipoBodegaOrigen, dtTipoBodega, "idTipo", "nombre")
        MetodosComunes.CargarComboDX(cmbTipoBodegaDestino, dtTipoBodega, "idTipo", "nombre")

        MetodosComunes.CargarComboDX(ddlUnidades, UnidadEmpaque.ObtenerListado(), "idTipoUnidad", "descripcion")
    End Sub

    Private Sub cmbTransportadora_ValueChanged(sender As Object, e As EventArgs) Handles cmbTransportadora.ValueChanged
        CargarRutasTransportadora(cmbTransportadora.Value)
    End Sub

    Private Sub CargarRutasTransportadora(ByVal IdTransportadora As Integer)
        Dim dt As DataTable = Nothing
        Try
            Dim infoRangos As New RangosGuiasCEM
            With infoRangos
                .IdTransportadora = IdTransportadora
                dt = infoRangos.TraerDatosRangosPorTransportadora
            End With

            MetodosComunes.CargarComboDX(cmbRangoGuias, dt, "IdRango", "NombreRango")

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Private Sub cmbTipoBodegaOrigen_ValueChanged(sender As Object, e As EventArgs) Handles cmbTipoBodegaOrigen.ValueChanged
        CargarBodegasOrigen(cmbTipoBodegaOrigen.Value)
    End Sub

    Private Sub CargarBodegasOrigen(ByVal IdTipoBodega As Integer)
        Dim dt As DataTable = Nothing
        Try
            Dim infoBodegas As New CargueInventarioCemMasivoSerializado
            With infoBodegas
                .idTipoBodega = IdTipoBodega
                dt = infoBodegas.ConsultarBodegasPosicion
            End With

            MetodosComunes.CargarComboDX(cmbBodegaOrigen, dt, "idbodega", "bodega")

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Private Sub cmbTipoBodegaDestino_ValueChanged(sender As Object, e As EventArgs) Handles cmbTipoBodegaDestino.ValueChanged
        CargarBodegasDestino(cmbTipoBodegaDestino.Value)
    End Sub

    Private Sub CargarBodegasDestino(ByVal IdTipoBodega As Integer)
        Dim dt As DataTable = Nothing
        Try
            Dim infoBodegas As New CargueInventarioCemMasivoSerializado
            With infoBodegas
                .idTipoBodega = IdTipoBodega
                dt = infoBodegas.ConsultarBodegasPosicion
            End With

            MetodosComunes.CargarComboDX(cmbBodegaDestino, dt, "idbodega", "bodega")

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Private Sub btnAgregarRadicado_Click(sender As Object, e As EventArgs) Handles btnAgregarRadicado.Click
        If ValidarCamposVacios() Then
            ValidarRadicado(txtRadicado.Text.Trim, cmbBodegaOrigen.Value)
        Else
            miEncabezado.showWarning("Existen campos vacíos. Por favor diligéncielos")
        End If
    End Sub

    Private Sub ValidarRadicado(ByVal Radicado As Long, ByVal IdBodega As Integer)
        Dim validacion As New RutaServicioMensajeriaTransportadora
        Dim dt As New DataTable


        With validacion
            .Radicado = Radicado
            .IdBodegaDestino = IdBodega

            dt = .ValidarRadicado
        End With

        If dt.Rows(0)(0) = 1 Then
            AgregarRadicado(Radicado)
        Else
            miEncabezado.showError("El número de radicado no concuerda con la bodega seleccionada")
        End If

    End Sub

    Private Function ValidarCamposVacios() As Boolean
        Dim resultado As Boolean = True
        miEncabezado.clear()

        If IsNothing(cmbTipoAsignacion.Value) Then
            miEncabezado.showWarning("Seleccione el tipo de asignación")
            resultado = False
        Else
            If String.IsNullOrEmpty(txtRadicado.Text) Then
                miEncabezado.showWarning("Debe ingresar un radicado")
                resultado = False
            Else
                If cmbTipoAsignacion.Value = 1 Then
                    If IsNothing(cmbTransportadora.Value) Or IsNothing(cmbRangoGuias.Value) Or IsNothing(cmbTipoBodegaOrigen.Value) Or
                    cmbBodegaOrigen.SelectedIndex = 0 Or IsNothing(cmbTipoBodegaDestino.Value) Or cmbBodegaDestino.SelectedIndex = 0 Then
                        resultado = False
                    End If
                Else
                    If IsNothing(cmbTransportadora.Value) Or IsNothing(cmbRangoGuias.Value) Or IsNothing(cmbTipoBodegaOrigen.Value) Or
                    cmbBodegaOrigen.SelectedIndex = 0 Then
                        resultado = False
                    End If
                End If
            End If

        End If

        'If txtRadicado.Text.Trim.Length = 0 Then
        '    resultado = False
        'End If

        Return resultado
    End Function

    Private Sub CargarDespachosTemporales()
        Dim dt As DataTable = Nothing
        Try
            Dim infoBodegas As New RutaServicioMensajeriaTransportadora
            With infoBodegas
                .IdUsuario = Session("usxp001")
                dt = .TraerDespachosTemporales()

                gvDatos.DataSource = dt
                gvDatos.DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Excepción al eliminar Radicado temporal.")
        End Try
    End Sub

    Private Sub AgregarRadicado(ByVal Radicado As Long)
        Dim dt As DataTable = Nothing
        Dim mensaje As String = ""
        miEncabezado.clear()

        Try
            Dim infoBodegas As New RutaServicioMensajeriaTransportadora
            With infoBodegas
                .Radicado = Radicado
                .IdUsuario = Session("usxp001")
                mensaje = .AgregarDespachoTemporal()

                If mensaje = "Duplicado" Then
                    miEncabezado.showError("El radicado ya existe en la relación")
                End If
            End With


            cmbTipoAsignacion.Enabled = False
            cmbTransportadora.Enabled = False
            cmbRangoGuias.Enabled = False
            cmbBodegaDestino.Enabled = False
            cmbBodegaOrigen.Enabled = False
            cmbTipoBodegaDestino.Enabled = False
            cmbTipoBodegaOrigen.Enabled = False

            If cmbTipoAsignacion.Value = 2 Then
                txtRadicado.Enabled = False
                btnAgregarRadicado.Enabled = False
            End If

            CargarDespachosTemporales()
            txtRadicado.Text = ""
        Catch ex As Exception
            miEncabezado.showError(ex.Message)
        End Try
    End Sub

    Protected Sub EliminarRadicado(ByVal Radicado As Long)
        Try
            Dim dt As DataTable = Nothing
            Try
                Dim infoBodegas As New RutaServicioMensajeriaTransportadora
                With infoBodegas
                    .Radicado = Radicado
                    .EliminarDespachoTemporal()

                End With
            Catch ex As Exception
                miEncabezado.showError("Excepción al eliminar Radicado temporal.")
            End Try

            CargarDespachosTemporales()

        Catch ex As Exception

        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim Radicado As Long

        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)
            Radicado = CLng(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "Radicado"))

            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", Radicado)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub btnEliAceptar_Click(sender As Object, e As EventArgs) Handles btnEliAceptar.Click
        Dim Radicado As Long = hidIdRadicado.Get("Value")
        EliminarRadicado(Radicado)
        hidIdRadicado.Set("Value", 0)
    End Sub

    Private Sub btnGenerarGuia_Click(sender As Object, e As EventArgs) Handles btnGenerarGuia.Click
        If ValidarGeneracionGuia() Then
            GenerarDespacho()
        Else
            miEncabezado.showWarning("Existen campos vacíos. Por favor diligéncielos")
        End If

    End Sub

    Private Function ValidarGeneracionGuia() As Boolean
        Dim resultado As Boolean = True
        miEncabezado.clear()

        If txtPeso.Text.Trim.Length = 0 Or txtVolumen.Text.Trim.Length = 0 Or txtCantidad.Text.Trim.Length = 0 Or ddlUnidades.SelectedIndex < 1 Then
            resultado = False
        Else
            resultado = True
        End If

        Return resultado
    End Function

    Private Sub GenerarDespacho()
        Try
            Dim Transportadora As Integer = cmbTransportadora.Value
            Dim RangoGuia As Integer = cmbRangoGuias.Value
            Dim BodegaOrigen As Integer = cmbBodegaOrigen.Value
            Dim BodegaDestino As Integer = cmbBodegaDestino.Value
            Dim Peso As Double = txtPeso.Text.Trim
            Dim Volumen As Double = txtVolumen.Text.Trim
            Dim idTipoUnidad As Integer = ddlUnidades.Value
            Dim cantidad As String = txtCantidad.Text.Trim
            Dim NuevoDespacho As Integer = 0

            Dim despacho As New RutaServicioMensajeriaTransportadora
            Dim dt As DataTable = gvDatos.DataSource

            With despacho
                .IdTransportadora = Transportadora
                .IdRangoGuia = RangoGuia
                .IdBodegaOrigen = BodegaOrigen

                If cmbTipoAsignacion.Value = 1 Then
                    .IdBodegaDestino = BodegaDestino
                Else
                    .IdBodegaDestino = 0
                End If

                .Peso = Peso
                .Volumen = Volumen
                .idTipoUnidad = idTipoUnidad
                .cantidad = cantidad
                .idTipoEnvio = cmbTipoAsignacion.Value
                .IdUsuario = Session("usxp001")

                NuevoDespacho = .GuardarDespacho()

                .LimpiarDespachosTemporal()
            End With

            LimpiarControles()

            cargareporte("../ReportesCEM/VisorReporteGuiaTransportadoraCEM.aspx?repo=guia&desp=" & NuevoDespacho.ToString)
            Threading.Thread.Sleep(5000)
            cargarHojaRuta("../ReportesCEM/VisorHojaRutaCEM.aspx?desp=" & NuevoDespacho.ToString)
        Catch ex As Exception
            miEncabezado.showError(ex.Message)
        End Try
    End Sub

    Private Sub cargareporte(ByVal url As String)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Guia", "window.open('" & url & "');", True)
    End Sub

    Private Sub cargarHojaRuta(ByVal url As String)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Remisión", "window.open('" & url & "');", True)
    End Sub

    Private Sub LimpiarControles()
        cmbTipoAsignacion.Enabled = True
        cmbTransportadora.Enabled = True
        cmbRangoGuias.Enabled = True
        cmbBodegaDestino.Enabled = True
        cmbBodegaOrigen.Enabled = True
        cmbTipoBodegaDestino.Enabled = True
        cmbTipoBodegaOrigen.Enabled = True
        txtRadicado.Enabled = True
        btnAgregarRadicado.Enabled = True

        cmbRangoGuias.SelectedIndex = -1
        cmbBodegaDestino.SelectedIndex = -1
        cmbTipoBodegaDestino.SelectedIndex = -1
        cmbBodegaOrigen.SelectedIndex = -1
        cmbTipoBodegaOrigen.SelectedIndex = -1
        cmbTipoAsignacion.SelectedIndex = -1
        cmbTransportadora.SelectedIndex = -1
        ddlUnidades.SelectedIndex = -1
        txtRadicado.Text = ""
        txtCantidad.Text = ""
        txtPeso.Text = ""
        txtVolumen.Text = ""

        Dim despacho As New RutaServicioMensajeriaTransportadora
        despacho.LimpiarDespachosTemporal()

        gvDatos.DataSource = Nothing
        gvDatos.DataBind()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        LimpiarControles()
    End Sub
End Class