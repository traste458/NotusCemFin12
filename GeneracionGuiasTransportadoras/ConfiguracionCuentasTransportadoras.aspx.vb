Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ConfiguracionCuentasTransportadorasCEM
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = 20099
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If
        Seguridad.verificarSession(Me)

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Configuración de Cuentas para Generar Guías")
            End With
            CargaInicial()
        End If
    End Sub

    Protected Sub CargaInicial()
        Dim idTrans As String = MetodosComunes.seleccionarConfigValue("idTransportadorasActivas")
        Dim dtTransportadora As DataTable = HerramientasMensajeria.ObtenerTransportadoras(listaIdTransportadoras:=idTrans)
        MetodosComunes.CargarComboDX(cmbPopTransportadora, dtTransportadora, "idtransportadora", "transportadora")
        CargarDatosRangos()

        Dim tipoBodega As New CargueInventarioCemMasivoSerializado
        Dim dtTipoBodega As New DataTable
        dtTipoBodega = tipoBodega.ConsultarTipoBodega
        MetodosComunes.CargarComboDX(cmbTipoBodegaDestino, dtTipoBodega, "idTipo", "nombre")
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
            If hidBodega.Contains("Value") Then
                If hidBodega.Get("Value") <> 0 Then
                    Dim xrow() As DataRow
                    xrow = dt.Select("idbodega=" & hidBodega.Get("Value"))
                    If xrow.Length > 0 Then
                        cmbBodegaDestino.Value = hidBodega.Get("Value")
                    End If
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información de la bodega.")
        End Try
    End Sub

    Protected Sub CargarDatosRangos()
        Dim dt As DataTable = Nothing
        Try

            gvDatos.DataSource = Nothing
            Session("dtCuentas") = Nothing

            Dim CuentasT As New CuentasTransportadoras
            With CuentasT
                dt = CuentasT.ObtenerCuentasTransportadora
            End With
            Session("dtCuentas") = dt

            With gvDatos
                .DataSource = Session("dtCuentas")
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        'Dim idCuenta As Integer
        Dim NombreCuenta As String
        Dim IdTransportadora As Integer
        Dim cuenta As String
        Dim cuentaPass As String
        Dim activo As Boolean

        Dim xCodigoCuenta As String
        Dim xCodFacturacion As String
        Dim xNombreCargue As String

        Dim xTipoBodega As String
        Dim xBodegae As String
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)

            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)
            Dim linkEliminar As ASPxHyperLink = templateContainer.FindControl("linkEliminar")

            'idCuenta = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idcuenta"))
            NombreCuenta = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "Descripcion")
            IdTransportadora = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtransportadora"))
            cuenta = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "CuentaUser")
            cuentaPass = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "CuentaPass")
            activo = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "activo")
            xCodigoCuenta = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "CodigoCuenta")
            xCodFacturacion = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "CodFacturacion")
            xNombreCargue = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreCargue")
            xTipoBodega = IIf(IsDBNull(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idTipo")) = True, 0, gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idTipo"))
            xBodegae = IIf(IsDBNull(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idbodega")) = True, 0, gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "idbodega"))

            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{1}", IdTransportadora)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{2}", NombreCuenta)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{3}", xCodigoCuenta)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{4}", cuenta)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{5}", cuentaPass)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{6}", xCodFacturacion)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{7}", xNombreCargue)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{8}", activo)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{9}", xTipoBodega)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{10}", xBodegae)

            'If GuiaActual = GuiaFinal Then
            '    linkEliminar.Visible = True
            'Else
            '    linkEliminar.Visible = False
            'End If

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub btnPopGuardar_Click(sender As Object, e As EventArgs) Handles btnPopGuardar.Click
        miEncabezado.clear()
        Dim IdRango As Integer = 0
        Dim sw As Boolean = False

        Dim IdTransportadora As Integer
        Dim NombreCuenta As String
        Dim CuentaUser As String
        Dim Cuentapass As String

        If hidIdCuenta.Contains("Value") Then
            IdRango = hidIdCuenta.Get("Value")
        End If

        IdTransportadora = cmbPopTransportadora.Value
        NombreCuenta = txtPopNombreCuenta.Text.Trim
        CuentaUser = txtPopCuentaUsuario.Text.Trim
        Cuentapass = txtPopCuentaPass.Text.Trim

        GuardarCuenta(IdRango, IdTransportadora, NombreCuenta, CuentaUser, Cuentapass, txtPopCodigoCuenta.Text.Trim, txtPopCodFacturacion.Text.Trim, txtPopNombreCargue.Text.Trim, cmbBodegaDestino.Value)
        CargarDatosRangos()
    End Sub

    Protected Sub GuardarCuenta(ByVal idCuenta As Integer, ByVal IdTransportadora As Integer,
                               ByVal txtPopDescripcion As String, ByVal txtPopCuentaUsuario As String, ByVal txtPopCuentaPass As String, ByVal txtCodigoCuenta As String, ByVal txtCodFacturacion As String, ByVal txtNombreCargue As String, ByVal idBodega As Integer)
        Dim CuentaT As New CuentasTransportadoras

        With CuentaT
            .IdCuenta = idCuenta
            .descripcion = txtPopDescripcion
            .CodigoCuenta = txtCodigoCuenta
            .cuentauser = txtPopCuentaUsuario
            .cuentapass = txtPopCuentaPass
            .idtransportadora = IdTransportadora
            .CodFacturacion = txtCodFacturacion
            .NombreCargue = txtNombreCargue
            .activo = cbActivo.Checked
            .idusuario = Session("usxp001")
            .IdBodega = idBodega
            If idCuenta > 0 Then
                .strModo = "Modificar"
            Else
                .strModo = "Insertar"
            End If

            .GuardarCuenta()
        End With

        LimpiarPopup()
        hidIdCuenta.Set("Value", 0)
        hidBodega.Set("Value", 0)
        CargarDatosRangos()
    End Sub

    Private Sub LimpiarPopup()
        cmbPopTransportadora.SelectedIndex = 0
        txtPopNombreCuenta.Text = ""
        txtPopCuentaUsuario.Text = ""
        txtPopCuentaPass.Text = ""
    End Sub


    Protected Sub popupHistorico_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles popHistorico.WindowCallback
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "MostrarHistorico"
                    CargarDatosHistoricos(arrayAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Sub CargarDatosHistoricos(ByVal idCuenta As Integer)

        Dim dt As DataTable = Nothing
        Try
            gvHistorico.DataSource = Nothing
            Session("dtHistorico") = Nothing

            Dim CuentasT As New CuentasTransportadoras
            With CuentasT
                dt = CuentasT.ObtenerCuentasTransportadoraLog(idCuenta)
            End With
            Session("dtHistorico") = dt

            With gvHistorico
                .DataSource = Session("dtHistorico")
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del Historico.")
        End Try
    End Sub

    Protected Sub gvHistorico_DataBinding(sender As Object, e As EventArgs) Handles gvHistorico.DataBinding
        If Session("dtHistorico") IsNot Nothing Then gvHistorico.DataSource = Session("dtHistorico")
    End Sub


End Class