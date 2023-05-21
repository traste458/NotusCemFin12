Imports DevExpress.Web
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Public Class ConfigurarRangosCEM
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("userId") = 1
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If

        If Not IsPostBack Then
            CargaInicial()
        End If
    End Sub

    Protected Sub CargaInicial()
        Dim dtTransportadora As DataTable = HerramientasMensajeria.ObtenerTransportadoras
        MetodosComunes.CargarComboDX(cmbPopTransportadora, dtTransportadora, "idtransportadora", "transportadora")

        CargarDatosRangos()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim IdRango As Integer
        Dim NombreRango As String
        Dim IdTransportadora As Integer
        Dim CodigoCuenta As String
        Dim GuiaInicial As Integer
        Dim GuiaFinal As Integer
        Dim GuiaActual As Integer

        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)

            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)
            Dim linkEliminar As ASPxHyperLink = templateContainer.FindControl("linkEliminar")

            IdRango = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdRango"))
            NombreRango = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreRango")
            IdTransportadora = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdTransportadora"))
            CodigoCuenta = gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "CodigoCuenta")
            GuiaInicial = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "GuiaInicial"))
            GuiaFinal = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "GuiaFinal"))
            GuiaActual = CInt(gvDatos.GetRowValuesByKeyValue(templateContainer.KeyValue, "GuiaActual"))

            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{1}", NombreRango)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{2}", IdTransportadora)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{3}", CodigoCuenta)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{4}", GuiaInicial)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{5}", GuiaFinal)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{6}", GuiaActual)

            If GuiaActual = GuiaFinal Then
                linkEliminar.Visible = True
            Else
                linkEliminar.Visible = False
            End If

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub CargarDatosRangos()
        Dim dt As DataTable = Nothing
        Try

            gvDatos.DataSource = Nothing
            Session("listaRangos") = Nothing

            Dim infoRangos As New RangosGuiasCEM
            With infoRangos
                dt = infoRangos.CargarDatosRangos
            End With
            Session("listaRangos") = dt

            With gvDatos
                .DataSource = Session("listaRangos")
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Protected Sub LlenarPopupEditarRango(ByVal IdRango As Integer)
        Dim dt As DataTable = Nothing
        Try
            Dim infoRangos As New RangosGuiasCEM
            With infoRangos
                .IdRango = IdRango
                dt = infoRangos.TraerDatosRango
            End With

            cmbPopTransportadora.Value = dt.Rows(0)("IdTransportadora").ToString
            txtPopCodigoCuenta.Text = dt.Rows(0)("CodigoCuenta")
            txtPopGuiaInicial.Text = dt.Rows(0)("GuiaInicial")
            txtPopGuiaFinal.Text = dt.Rows(0)("GuiaFinal")
            txtPopGuiaActual.Text = dt.Rows(0)("GuiaActual")
            txtPopNombreRango.Text = dt.Rows(0)("NombreRango")

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try
    End Sub

    Protected Sub GuardarNuevoRango(ByVal NombreRango As String, ByVal IdTransportadora As Integer, ByVal CodigoCuenta As String,
                                    ByVal GuiaInicial As String, ByVal GuiaFinal As String, ByVal GuiaActual As String)
        Dim Rango As New RangosGuiasCEM

        With Rango
            .NombreRango = NombreRango
            .IdTransportadora = IdTransportadora
            .CodigoCuenta = CodigoCuenta
            .GuiaInicial = GuiaInicial
            .GuiaFinal = GuiaFinal
            .GuiaActual = GuiaActual
            .IdUsuario = Session("userId")

            .GuardarRango()
        End With

        CargarDatosRangos()
    End Sub

    Protected Sub GuardarRango(ByVal IdRango As Integer, ByVal NombreRango As String, ByVal IdTransportadora As Integer,
                               ByVal CodigoCuenta As String, ByVal GuiaInicial As String, ByVal GuiaFinal As String,
                               ByVal GuiaActual As String)
        Dim Rango As New RangosGuiasCEM

        With Rango
            .IdRango = IdRango
            .NombreRango = NombreRango
            .IdTransportadora = IdTransportadora
            .CodigoCuenta = CodigoCuenta
            .GuiaInicial = GuiaInicial
            .GuiaFinal = GuiaFinal
            .GuiaActual = GuiaActual
            .IdUsuario = Session("userId")

            .GuardarRango()
        End With

        LimpiarPopup()
        hidIdRango.Set("Value", 0)

        CargarDatosRangos()
    End Sub

    Protected Sub EliminarRango(ByVal IdRango As Integer)
        If IdRango > 0 Then
            Dim Rango As New RangosGuiasCEM

            With Rango
                .IdRango = IdRango

                .EliminarRango()
            End With

            CargarDatosRangos()
        End If
    End Sub

    Private Sub LimpiarPopup()
        cmbPopTransportadora.SelectedIndex = 0
        txtPopNombreRango.Text = ""
        txtPopCodigoCuenta.Text = ""
        txtPopGuiaInicial.Text = ""
        txtPopGuiaFinal.Text = ""
        txtPopGuiaActual.Text = ""
    End Sub

    Private Sub btnPopGuardar_Click(sender As Object, e As EventArgs) Handles btnPopGuardar.Click
        miEncabezado.clear()
        Dim IdRango As Integer = 0
        Dim sw As Boolean = False

        Dim IdTransportadora As Integer
        Dim GuiaInicial As Long
        Dim GuiaFinal As Long
        Dim GuiaActual As Long
        Dim NombreRango As String
        Dim CodigoCuenta As String

        If hidIdRango.Contains("Value") Then
            IdRango = hidIdRango.Get("Value")
        End If

        If IsNothing(cmbPopTransportadora.Value) Or txtPopCodigoCuenta.Text.Trim.Length = 0 Or
        txtPopGuiaInicial.Text.Trim.Length = 0 Or txtPopGuiaFinal.Text.Trim.Length = 0 Or
        txtPopGuiaActual.Text.Trim.Length = 0 Or txtPopNombreRango.Text.Trim.Length = 0 Then
            sw = True
        End If

        If Not sw Then
            IdTransportadora = cmbPopTransportadora.Value
            GuiaInicial = txtPopGuiaInicial.Text.Trim
            GuiaFinal = txtPopGuiaFinal.Text.Trim
            GuiaActual = txtPopGuiaActual.Text.Trim
            NombreRango = txtPopNombreRango.Text.Trim
            CodigoCuenta = txtPopCodigoCuenta.Text.Trim
        End If


        If GuiaInicial > GuiaFinal Or GuiaInicial > GuiaActual Or GuiaFinal < GuiaActual Or IdTransportadora = 0 Or sw Then
            'miEncabezado.showWarning("Existen campos vacíos o la secuencia de numeros de guías no concuerdan [Inicial - Final - Actual]")
        Else
            GuardarRango(IdRango, NombreRango, IdTransportadora, CodigoCuenta, GuiaInicial, GuiaFinal, GuiaActual)
            CargarDatosRangos()
        End If


    End Sub

    Private Sub btnEliAceptar_Click(sender As Object, e As EventArgs) Handles btnEliAceptar.Click
        EliminarRango(hidIdRango.Get("Value"))
        hidIdRango.Set("Value", 0)
    End Sub


End Class