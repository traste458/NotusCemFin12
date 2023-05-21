Imports ILSBusinessLayer
Imports ILSBusinessLayer.LogisticaInversa

Partial Public Class AdministracionTransportadoras
    Inherits System.Web.UI.Page

#Region "Atributos"
    Private existeProducto As Boolean = True
    Private existeServicio As Boolean = True
    Private existeTarifa As Boolean = True
    Private idTransportadora As Integer = 0
    Private idGrupoTransportadora As Integer = 0
    Private idRango As Integer = 0
    Private idTipoTarifa As Integer = 0
    Private idTarifa As Integer = 0
    Private cantidadTransportadora As Integer = 0
    Private pMensaje As String = ""
    Private dttransportadora As DataTable
    Private dtTarifa As DataTable
    Private dtCombo As DataTable
    Private dtRango As DataTable
    Private dtTipoTarifa As DataTable
    Private dtTransOriginal As DataTable
#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        epNotificar.clear()
        Seguridad.verificarSession(Me)
        'Session("usxp001") = 1
        If Not IsPostBack Then
            Session("existeTransportadora") = False
            epNotificar.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            epNotificar.setTitle("Administración de Transportadoras")
            Me.cargaInicial()
        End If
        txtNombre.Focus()

    End Sub

    Protected Sub btnCrear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCrear.Click
        Dim dt As DataTable = Session("dtTransportadora")
        epNotificar.clear()
        If dt.Select("transportadora = '" & txtNombre.Text.Trim & "'").Length = 0 Then
            cargarDatos()
            liberarCampos()
            If existeProducto And existeServicio And existeTarifa Then
                dlgDetalle.Width = "330"
                dlgDetalle.Visible = True
                dlgDetalle.Show()
            Else
                If Not existeProducto Then
                    epNotificar.showError("No existen Tipos de Producto, por favor verifique.")
                ElseIf Not existeServicio Then
                    epNotificar.showError("No existen Tipos de Servicio, por favor verifique.")
                ElseIf Not existeTarifa Then
                    epNotificar.showError("No existen Tipos de Tarifa, por favor verifique.")
                End If
            End If
        Else
            epNotificar.showError("La transportadora " & txtNombre.Text.Trim & " ya existe, verifique.")
            txtNombre.Text = ""
            txtNombre.Focus()
        End If
    End Sub

    Private Sub chbNacionales_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chbNacionales.CheckedChanged
        If chbNacionales.Checked Then
            'lblError.Text = ""
            If chbTipoProducto.Checked Then
                ddlProducto.Enabled = True
            Else
                ddlProducto.Enabled = False
            End If
            pnlTarifaTransportadora.Visible = True
            dlgDetalle.Width = "720"
            dlgDetalle.AllowResize = True
            dlgDetalle.Visible = True
            dlgDetalle.Show()
        Else
            pnlTarifaTransportadora.Visible = False
            liberarCampos()
            dlgDetalle.Width = "330"
            dlgDetalle.Visible = True
            dlgDetalle.Show()
        End If
    End Sub

    Private Sub chbTipoProducto_CheckedChanged(sender As Object, e As System.EventArgs) Handles chbTipoProducto.CheckedChanged
        If chbTipoProducto.Checked Then
            ddlProducto.Enabled = True
        Else
            ddlProducto.Enabled = False
        End If
        If chbNacionales.Checked Then
            pnlTarifaTransportadora.Visible = True
            dlgDetalle.Width = "720"
            dlgDetalle.AllowResize = True
            dlgDetalle.Visible = True
            dlgDetalle.Show()
        Else
            dlgDetalle.Visible = True
            dlgDetalle.Show()
        End If
    End Sub

    Private Sub ddlTarifa_TextChanged(sender As Object, e As System.EventArgs) Handles ddlTarifa.TextChanged
        If ddlTarifa.SelectedValue.Trim <> "" Then
            If InStr(ddlTarifa.SelectedItem.Text.ToLower, "combo") > 0 Then
                ddlProducto.Enabled = False
                ddlProducto.SelectedValue = 0
                chbCombo.Enabled = True
            Else
                ddlProducto.Enabled = True
                ddlProductoDetalle.SelectedValue = 0
                chbCombo.Enabled = False
            End If
        End If
        dlgDetalle.Show()
    End Sub

    Private Sub ddlTarifaDetalle_TextChanged(sender As Object, e As System.EventArgs) Handles ddlTarifaDetalle.TextChanged
        If ddlTarifaDetalle.SelectedValue.Trim <> "" Then
            If InStr(ddlTarifaDetalle.SelectedItem.Text.ToLower, "combo") > 0 Then
                ddlProductoDetalle.Enabled = False
                ddlProductoDetalle.SelectedValue = 0
            Else
                ddlProductoDetalle.Enabled = True
                ddlProductoDetalle.SelectedValue = 0
            End If
        End If
        dlgDetalleTarifa.Show()
    End Sub

    Private Sub chbCombo_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chbCombo.CheckedChanged
        If chbCombo.Checked Then
            Dim dt As DataTable
            dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoProducto()
            dlgDetalle.Visible = True
            dlgDetalle.Show()
            pnlCombo.Visible = True
            With chblProductosCombo
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoProducto"
                .DataBind()
            End With
        Else
            dlgDetalle.Visible = True
            dlgDetalle.Show()
            pnlCombo.Visible = False
        End If
    End Sub

    Private Sub chbRango_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chbRango.CheckedChanged
        If chbRango.Checked Then
            dlgDetalle.Visible = True
            dlgDetalle.Show()
            pnlRango.Visible = True
        Else
            dlgDetalle.Visible = True
            dlgDetalle.Show()
            pnlRango.Visible = False
        End If
    End Sub

    Private Sub btnGrabar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGrabar.Click
        Try
            ValidarInformacion("")
            If pMensaje.Trim.Length > 0 Then
                LblErrorDetalle.Text = pMensaje
                dlgDetalle.Visible = True
                dlgDetalle.Show()
                Exit Sub
            End If

            If Session("cantidadTransportadora") Is Nothing AndAlso Session("cantidadTransportadora") = 0 Then
                cantidadTransportadora = LogisticaInversa.AdministracionTransportadoras.cantidadTransportadoras() + 1
            Else
                dtTransOriginal = LogisticaInversa.AdministracionTransportadoras.ObtenerTransportadoras(Session("cantidadTransportadora"))
            End If
            'llena tabla transportadora
            dttransportadora = CrearEstructuraDeDatos("dtTransportadora")
            llenarDt("dtTransportadora", "")
            'llena tabla de tarifa
            If chbNacionales.Checked Then
                dtTarifa = CrearEstructuraDeDatos("dtTarifa")
                llenarDt("dtTarifa", "")
            End If
            'llenaTablaCombos()
            If chbCombo.Checked Then
                dtCombo = CrearEstructuraDeDatos("dtCombo")
                llenarDt("dtCombo", "")
            End If
            'llenaTablaRangos
            If chbRango.Checked Then
                dtRango = CrearEstructuraDeDatos("dtRango")
                llenarDt("dtRango", "")
            End If

            LogisticaInversa.AdministracionTransportadoras.grabarTransportadora(dttransportadora, dtTarifa, dtCombo, dtRango)
            dlgDetalle.Visible = False
            If Session("existeTransportadora") Then
                epNotificar.showSuccess("Transportadora " & dtTransOriginal.Rows(0).Item("transportadora").ToString.Trim & " Actualizada Existosamente.")
            Else
                epNotificar.showSuccess("Transportadora " & txtNombre.Text.Trim & " Creada Existosamente.")
            End If

            cargaInicial()
            txtNombre.Text = ""
            txtNombre.Focus()

        Catch ex As Exception
            epNotificar.showError("Error al grabar transportadora: " & ex.ToString)
        End Try
    End Sub

    Private Sub gvTransportadoras_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvTransportadoras.RowCommand
        If e.CommandName = "detalleTransportadora" Then
            idTransportadora = e.CommandArgument.ToString()
            Dim dt As DataTable
            dt = Session("dtTransportadora")
            dlgDetalleTransportadora.HeaderHtml = "Detalle Transportadora " & dt.Select("idTransportadora = " & idTransportadora)(0).Item(1)
            cantidadTransportadora = idTransportadora
            Dim dtPropiedades As DataTable
            dtPropiedades = LogisticaInversa.AdministracionTransportadoras.ObtenerPropiedadesTransportadora(idTransportadora)
            llenaPropiedades(dtPropiedades)
            LblErrorTransportadoraDetalle.Text = ""
            pnlDetalleTransportadora.Visible = True
            dlgDetalleTransportadora.Width = "325"
            Session("cantidadTransportadora") = cantidadTransportadora
            Session("existeTransportadora") = True
            dlgDetalleTransportadora.Visible = True
            dlgDetalleTransportadora.Show()
        ElseIf e.CommandName = "detalleTarifa" Then
            idTransportadora = e.CommandArgument.ToString()
            LblErrorTarifaDetalle.Text = ""
            Dim dt As DataTable
            dt = Session("dtTransportadora")
            dlgDetalleTarifa.HeaderHtml = "Detalle de Tarifa Transportadora " & dt.Select("idTransportadora = " & idTransportadora)(0).Item(1)
            cantidadTransportadora = idTransportadora
            Dim dtPropiedades As DataTable
            dtPropiedades = LogisticaInversa.AdministracionTransportadoras.ObtenerPropiedadesTransportadora(idTransportadora)
            If dtPropiedades.Rows(0).Item("aplicaDespachoNacional") Then
                Dim dtTarifa As DataTable
                dtTarifa = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(idTransportadora, 0)
                Session("dtTarifa") = dtTarifa
                gvDetalleTarifa.DataSource = dtTarifa
                gvDetalleTarifa.DataBind()
                gvDetalleTarifa.Visible = True
                pnlDetalleTarifa.Visible = True
                cargarDatosDetalle()
                Session("cantidadTransportadora") = cantidadTransportadora
                Session("existeTransportadora") = True
                liberarCampos()
                If dtPropiedades.Rows(0).Item("aplicaTipoProducto") Then
                    ddlProductoDetalle.Enabled = True
                Else
                    ddlProductoDetalle.Enabled = False
                End If
                dlgDetalleTarifa.Show()
            Else
                epNotificar.showError("La transportadora no esta configurada para realizar despachos nacionales, por favor configurar antes de continuar con el proceso de actualizacion y creacion de Tarifas.")
                Exit Sub
            End If
        ElseIf e.CommandName = "detalleCombo" Then
            Dim dt As DataTable
            dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoProducto()
            With chblComboDetalle
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoProducto"
                .DataBind()
            End With
            idTransportadora = e.CommandArgument.ToString()
            Dim dtTransp As DataTable
            dtTransp = Session("dtTransportadora")
            dlgDetalleCombo.HeaderHtml = "Detalle de Combo Transportadora " & dtTransp.Select("idTransportadora = " & idTransportadora)(0).Item("transportadora")

            cantidadTransportadora = idTransportadora
            Dim dtTarifaCombo As DataTable
            dtTarifaCombo = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(idTransportadora, "combo")
            If dtTarifaCombo.Rows.Count > 0 Then
                With ddlTarifaCombo
                    .DataSource = dtTarifaCombo
                    .DataTextField = "descripcion"
                    .DataValueField = "idTipoTarifa"
                    .DataBind()
                    If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
                End With
                Session("dtTipoTarifa") = dt
                lnkNew.Enabled = True
                lnkGrabar.Enabled = False
                Dim dtCombos As DataTable
                dtCombos = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(idTransportadora, 0, 0)
                Session("dtCombos") = dtCombos
                gvComboRegistrado.DataSource = dtCombos
                LblErrorComboDetalle.Text = ""
                gvComboRegistrado.DataBind()
                gvComboRegistrado.Visible = True
                Session("cantidadTransportadora") = cantidadTransportadora
                Session("existeTransportadora") = True
                dlgDetalleCombo.Show()
            Else
                epNotificar.showError("La transportadora no tiene configuradas tarifas, por favor configurarlas antes de continuar con el proceso de actualizacion y creacion de Combos.")
                Exit Sub
            End If
        ElseIf e.CommandName = "detalleRango" Then
            idTransportadora = e.CommandArgument.ToString()
            Dim dt As DataTable
            dt = Session("dtTransportadora")
            dlgDetalleRango.HeaderHtml = "Detalle de Rango Transportadora " & dt.Select("idTransportadora = " & idTransportadora)(0).Item(1)
            cantidadTransportadora = idTransportadora
            Session("cantidadTransportadora") = cantidadTransportadora
            Session("existeTransportadora") = True
            idTransportadora = e.CommandArgument.ToString()
            cantidadTransportadora = idTransportadora
            Dim dtTarifaRango1 As DataTable
            dtTarifaRango1 = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(idTransportadora, "rango")
            If dtTarifaRango1.Rows.Count > 0 Then
                Dim dtTarifaRango As DataTable
                dtTarifaRango = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(idTransportadora, "rango")
                With ddlTarifaRangoDetalle
                    .DataSource = dtTarifaRango
                    .DataTextField = "descripcion"
                    .DataValueField = "idTipoTarifa"
                    .DataBind()
                    If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
                End With
                Session("dtTipoTarifa") = dtTarifaRango
                lnkNewRango.Enabled = True
                lnkGrabarRango.Enabled = False
                Dim dtRangos As DataTable
                dtRangos = LogisticaInversa.AdministracionTransportadoras.ObtenerRangosTransportadora(idTransportadora, 0)
                Session("dtRangos") = dtRangos
                gvRangoDetalle.DataSource = dtRangos
                gvRangoDetalle.DataBind()
                gvRangoDetalle.Visible = True
                lblerrorRangoDetalle.Text = ""
                dlgDetalleRango.Show()
            Else
                epNotificar.showError("La transportadora no tiene configuradas tarifas, por favor configurarlas antes de continuar con el proceso de actualizacion y creacion de Rangos.")
                Exit Sub
            End If
        End If
    End Sub

    Private Sub BtnGrabarDetalleTransportadora_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnGrabarDetalleTransportadora.Click
        ValidarInformacion("Detalle")
        If pMensaje.Trim.Length > 0 Then
            LblErrorTransportadoraDetalle.Text = pMensaje
            LblErrorTransportadoraDetalle.Visible = True
            dlgDetalleTransportadora.Visible = True
            dlgDetalleTransportadora.Show()
            Exit Sub
        Else
            dlgDetalleTransportadora.Visible = False
        End If
        dtTransOriginal = LogisticaInversa.AdministracionTransportadoras.ObtenerTransportadoras(Session("cantidadTransportadora"))

        'llena tabla transportadora
        dttransportadora = CrearEstructuraDeDatos("dtTransportadora")
        llenarDt("dtTransportadora", "detalle")

        LogisticaInversa.AdministracionTransportadoras.ActualizarDatosTransportadora(dttransportadora, "Transportadora")

        epNotificar.showSuccess("Transportadora " & dtTransOriginal.Rows(0).Item("transportadora").ToString.Trim & " Actualizada Existosamente.")

        cargaInicial()
        txtNombre.Text = ""
        txtNombre.Focus()

    End Sub

    Private Sub gvDetalleTarifa_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDetalleTarifa.RowCommand
        If e.CommandName = "EditarTarifa" Then
            idTarifa = e.CommandArgument.ToString()
            Session("idTarifa") = idTarifa
            Session("accion") = "actualizar"
            Dim dtTarifa As DataTable
            dtTarifa = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(0, idTarifa)
            If dtTarifa.Rows.Count <> 0 Then
                ddlServicioDetalle.SelectedValue = dtTarifa.Rows(0).Item("idTipoServicio")
                txtValorDetalle.Text = dtTarifa.Rows(0).Item("valordeManejo")
                txtTarifaDetalle.Text = dtTarifa.Rows(0).Item("tarifaMinima")
                ddlProductoDetalle.SelectedValue = dtTarifa.Rows(0).Item("idTipoProducto")
                ddlTarifaDetalle.SelectedValue = dtTarifa.Rows(0).Item("idTipoTarifa")
                ddlCanal.SelectedValue = dtTarifa.Rows(0).Item("idCanal")
            End If
        ElseIf e.CommandName = "BorrarTarifa" Then
            idTarifa = e.CommandArgument.ToString()
            Dim idTransporte As Integer = Session("cantidadTransportadora")
            Dim dtTarifa As DataTable
            dtTarifa = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(0, idTarifa)
            ddlTarifaDetalle.SelectedValue = dtTarifa.Rows(0).Item("idTipoTarifa")
            Dim dt As DataTable
            dt = LogisticaInversa.AdministracionTransportadoras.ObtenerComboTarifa(idTransporte, dtTarifa.Rows(0).Item("idTipoTarifa"))
            Dim dt1 As DataTable
            dt1 = LogisticaInversa.AdministracionTransportadoras.ObtenerRangoTarifa(idTransporte, dtTarifa.Rows(0).Item("idTipoTarifa"))

            If dt.Rows.Count > 0 Then
                epNotificar.showError("La tarifa tiene combos asociados, por favor eliminar los combos asociados a la tarifa antes de continuar con el proceso de eliminacion de Tarifas.")
                Exit Sub
            ElseIf dt1.Rows.Count Then
                epNotificar.showError("La tarifa tiene Rangos asociados, por favor eliminar los rangos asociados a la tarifa antes de continuar con el proceso de eliminacion de Tarifas.")
                Exit Sub
            Else
                Session("idTarifa") = idTarifa
                Session("accion") = "borrar"
                dlgConfirmacionTarifa.Show()
            End If
        End If
        dlgDetalleTarifa.Show()
    End Sub

    Private Sub btnGrabarDetalleTarifa_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGrabarDetalleTarifa.Click

        If Session("idTarifa") = 0 Then
            Session("accion") = "insertar"
        End If

        If Session("accion") <> "borrar" Then
            validaTarifa()
            If pMensaje.Trim.Length > 0 Then
                LblErrorTarifaDetalle.ForeColor = Color.Red
                LblErrorTarifaDetalle.Text = pMensaje.Trim
                dlgDetalleTarifa.Show()
                Exit Sub
            Else
                LblErrorTarifaDetalle.Text = ""
            End If
        End If

        dtTarifa = CrearEstructuraDeDatos("dtTarifa")
        llenarDt("dtTarifa", "detalle")

        LogisticaInversa.AdministracionTransportadoras.ActualizarDatosTransportadora(dtTarifa, "Tarifa")

        LblErrorTarifaDetalle.ForeColor = Color.Blue
        If Session("accion") = "borrar" Then
            LblErrorTarifaDetalle.Text = "Tarifa Borrada Existosamente"
        Else
            LblErrorTarifaDetalle.Text = "Tarifa Actualizada Existosamente"
        End If

        Dim dtTarifaAct As DataTable
        dtTarifaAct = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(Session("cantidadTransportadora"), 0)
        Session("dtTarifa") = dtTarifaAct
        gvDetalleTarifa.DataSource = dtTarifaAct
        gvDetalleTarifa.DataBind()
        gvDetalleTarifa.Visible = True
        pnlDetalleTarifa.Visible = True
        gvDetalleTarifa.Visible = True
        cargarDatosDetalle()
        liberarCampos()
        dlgDetalleTarifa.Show()
    End Sub

    Private Sub gvComboRegistrado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvComboRegistrado.RowCommand
        If e.CommandName = "VerCombo" Then
            LblErrorComboDetalle.Text = ""
            lnkNew.Enabled = True
            lnkGrabar.Enabled = False
            idGrupoTransportadora = e.CommandArgument.ToString()
            Dim dtComboSelect As DataTable
            dtComboSelect = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(Session("cantidadTransportadora"), idGrupoTransportadora, 0)
            llenaComboSeleccionado(dtComboSelect)
            Session("idGrupoTransportadora") = idGrupoTransportadora
            PnlDetalleCombo.Enabled = False
            dlgDetalleCombo.Show()
        ElseIf e.CommandName = "EditarCombo" Then
            idGrupoTransportadora = e.CommandArgument.ToString()
            LblErrorComboDetalle.Text = ""
            Dim dtComboSelect As DataTable
            dtComboSelect = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(Session("cantidadTransportadora"), idGrupoTransportadora, 0)
            llenaComboSeleccionado(dtComboSelect)
            Session("idGrupoTransportadora") = e.CommandArgument.ToString()
            PnlDetalleCombo.Enabled = True
            Session("accion") = "actualizar"
            lnkNew.Enabled = False
            lnkGrabar.Enabled = True
            dlgDetalleCombo.Show()
        ElseIf e.CommandName = "BorrarCombo" Then
            LblErrorComboDetalle.Text = ""
            Session("accion") = "borrar"
            idGrupoTransportadora = e.CommandArgument.ToString()
            Session("idGrupoTransportadora") = idGrupoTransportadora
            Dim dtComboSelect As DataTable
            dtComboSelect = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(Session("cantidadTransportadora"), idGrupoTransportadora, 0)
            llenaComboSeleccionado(dtComboSelect)
            lnkNew.Enabled = False
            lnkGrabar.Enabled = False
            dlgConfirmacion.Show()
        End If
    End Sub

    Private Sub lnkNew_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNew.Click
        Dim dtmaxGrupoCombo As DataTable
        dtmaxGrupoCombo = LogisticaInversa.AdministracionTransportadoras.ObtenerGrupoComboMaximo(Session("cantidadTransportadora"))
        If dtmaxGrupoCombo.Rows.Count > 0 Then
            idGrupoTransportadora = CInt(dtmaxGrupoCombo.Rows(0).Item("maxGrupo"))
        Else
            idGrupoTransportadora = 1
        End If
        Session("idGrupoTransportadora") = idGrupoTransportadora
        desmarcarComboDetalle()

        If ddlTarifaCombo.Items.FindByText("Seleccione...") IsNot Nothing Then
            ddlTarifaCombo.SelectedValue = 0
        End If

        LblErrorComboDetalle.Text = ""
        lnkNew.Enabled = False
        lnkGrabar.Enabled = True
        PnlDetalleCombo.Enabled = True
        gvComboRegistrado.Enabled = False
        Session("accion") = "insertar"
        dlgDetalleCombo.Show()
    End Sub

    Private Sub lnkGrabar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGrabar.Click

        Dim dtGrupoCombos As DataTable
        dtGrupoCombos = Session("dtCombos")

        dtCombo = CrearEstructuraDeDatos("dtCombo")
        Dim drAux As DataRow
        Dim i As Integer = 0
        For i = 0 To chblComboDetalle.Items.Count - 1
            If chblComboDetalle.Items(i).Selected Then
                drAux = dtCombo.NewRow
                drAux("idTipoTarifa") = ddlTarifaCombo.SelectedValue
                drAux("idTipoProducto") = chblComboDetalle.Items(i).Value
                drAux("idUsuario") = Session("usxp001")
                drAux("idTransportadora") = Session("cantidadTransportadora")
                If Session("accion") = "insertar" Then
                    If dtGrupoCombos Is Nothing OrElse dtGrupoCombos.Rows.Count = 0 Then
                        drAux("idGrupoTransportadora") = Session("idGrupoTransportadora")
                    Else
                        drAux("idGrupoTransportadora") = Session("idGrupoTransportadora") + 1
                    End If
                ElseIf Session("accion") = "actualizar" Then
                    drAux("idGrupoTransportadora") = Session("idGrupoTransportadora")
                ElseIf Session("accion") = "borrar" Then
                    drAux("idGrupoTransportadora") = Session("idGrupoTransportadora")
                End If
                drAux("accion") = Session("accion")
                dtCombo.Rows.Add(drAux)
            End If
        Next

        If Session("accion") <> "borrar" Then

            If dtGrupoCombos.Rows.Count > 0 Then
                validaCombo(dtGrupoCombos)
            Else
                pMensaje = ""
            End If
            If pMensaje.Trim.Length > 0 Then
                LblErrorComboDetalle.ForeColor = Color.Red
                LblErrorComboDetalle.Text = "   Combo ya existe verifique."
                desmarcarComboDetalle()
                gvComboRegistrado.Enabled = True
                lnkNew.Enabled = True
                lnkGrabar.Enabled = False
                PnlDetalleCombo.Enabled = False
                dlgDetalleCombo.Show()
                Exit Sub
            Else
                LblErrorComboDetalle.Text = ""
            End If
        End If

        LogisticaInversa.AdministracionTransportadoras.ActualizarDatosTransportadora(dtCombo, "Combo")

        LblErrorComboDetalle.ForeColor = Color.Blue
        If Session("accion") = "insertar" Then
            LblErrorComboDetalle.Text = "Combo Creado Existosamente"
        ElseIf Session("accion") = "actualizar" Then
            LblErrorComboDetalle.Text = "Combo Actualizado Existosamente"
        ElseIf Session("accion") = "borrar" Then
            LblErrorComboDetalle.Text = "Combo Borrado Existosamente"
        End If

        idTransportadora = Session("cantidadTransportadora")
        cantidadTransportadora = idTransportadora
        Dim dtCombos As DataTable
        dtCombos = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(idTransportadora, 0, 0)
        Session("dtCombos") = dtCombos
        gvComboRegistrado.DataSource = dtCombos
        gvComboRegistrado.DataBind()
        gvComboRegistrado.Visible = True
        Session("cantidadTransportadora") = cantidadTransportadora
        Session("existeTransportadora") = True
        desmarcarComboDetalle()
        gvComboRegistrado.Enabled = True
        PnlDetalleCombo.Enabled = False
        lnkNew.Enabled = True
        lnkGrabar.Enabled = False
        dlgDetalleCombo.Show()

    End Sub

    Private Sub gvRangoDetalle_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvRangoDetalle.RowCommand
        If e.CommandName = "VerRango" Then
            lblerrorRangoDetalle.Text = ""
            lnkNew.Enabled = True
            lnkGrabar.Enabled = False
            idRango = e.CommandArgument.ToString()
            Dim dtRango As DataTable
            dtRango = Session("dtRangos")
            llenaRangoDetalle(dtRango, idRango)
            Session("idRango") = idRango
            pnlRangoDetalle.Enabled = False
            dlgDetalleRango.Show()
        ElseIf e.CommandName = "EditarRango" Then
            idRango = e.CommandArgument.ToString()
            lblerrorRangoDetalle.Text = ""
            dtRango = Session("dtRangos")
            llenaRangoDetalle(dtRango, idRango)
            Session("idRango") = e.CommandArgument.ToString()
            gvRangoDetalle.Enabled = False
            pnlRangoDetalle.Enabled = True
            Session("accion") = "actualizar"
            lnkNewRango.Enabled = False
            lnkGrabarRango.Enabled = True
            dlgDetalleRango.Show()
        ElseIf e.CommandName = "BorrarRango" Then
            lblerrorRangoDetalle.Text = ""
            Session("accion") = "borrar"
            idRango = e.CommandArgument.ToString()
            Session("idRango") = idRango
            dtRango = Session("dtRangos")
            llenaRangoDetalle(dtRango, idRango)
            lnkNewRango.Enabled = False
            lnkGrabarRango.Enabled = False
            dlgConfirmacionRango.Show()
            'lnkGrabarRango_Click(sender, e)
            pnlRangoDetalle.Enabled = False
            gvRangoDetalle.Enabled = False
            ''dlgDetalleRango.Show()
        End If
    End Sub

    Private Sub lnkNewRango_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewRango.Click
        idRango = Session("idRango")
        txtCntInicialDetalle.Text = ""
        txtCntFinalDetalle.Text = ""
        lblerrorRangoDetalle.Text = ""
        lnkNewRango.Enabled = False
        lnkGrabarRango.Enabled = True
        pnlRangoDetalle.Enabled = True
        gvRangoDetalle.Enabled = False
        Session("accion") = "insertar"
        dlgDetalleRango.Show()
    End Sub

    Private Sub lnkGrabarRango_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGrabarRango.Click

        Dim dtRangosExistentes As DataTable
        dtRangosExistentes = Session("dtRangos")

        If Session("accion") <> "borrar" Then
            If dtRangosExistentes.Rows.Count > 0 Then
                validaRango(dtRangosExistentes)
            Else
                pMensaje = ""
            End If
            If pMensaje.Trim.Length > 0 Then
                lblerrorRangoDetalle.ForeColor = Color.Red
                lblerrorRangoDetalle.Text = "Rango ya existe verifique."
                txtCntInicialDetalle.Text = ""
                txtCntFinalDetalle.Text = ""
                gvRangoDetalle.Enabled = True
                lnkNewRango.Enabled = True
                lnkGrabarRango.Enabled = False
                pnlRangoDetalle.Enabled = False
                dlgDetalleRango.Show()
                Exit Sub
            Else
                lblerrorRangoDetalle.Text = ""
            End If
        End If

        dtRango = CrearEstructuraDeDatos("dtRango")
        llenarDt("dtRango", "detalle")

        LogisticaInversa.AdministracionTransportadoras.ActualizarDatosTransportadora(dtRango, "Rangos")

        lblerrorRangoDetalle.ForeColor = Color.Blue
        If Session("accion") = "insertar" Then
            lblerrorRangoDetalle.Text = "Rango Creado Existosamente"
        ElseIf Session("accion") = "actualizar" Then
            lblerrorRangoDetalle.Text = "Rango Actualizado Existosamente"
        ElseIf Session("accion") = "borrar" Then
            lblerrorRangoDetalle.Text = "Rango Borrado Existosamente"
        End If

        idTransportadora = Session("cantidadTransportadora")
        cantidadTransportadora = idTransportadora
        txtCntInicialDetalle.Text = ""
        txtCntFinalDetalle.Text = ""
        lnkNewRango.Enabled = True
        lnkGrabarRango.Enabled = False
        Dim dtRangos As DataTable
        Session("cantidadTransportadora") = cantidadTransportadora
        Session("existeTransportadora") = True
        dtRangos = LogisticaInversa.AdministracionTransportadoras.ObtenerRangosTransportadora(idTransportadora, 0)
        Session("dtRangos") = dtRangos
        gvRangoDetalle.DataSource = dtRangos
        gvRangoDetalle.DataBind()
        gvRangoDetalle.Visible = True
        pnlRangoDetalle.Enabled = False
        gvRangoDetalle.Enabled = True
        dlgDetalleRango.Show()

    End Sub

    Private Sub BtnSi_Click(sender As Object, e As System.EventArgs) Handles BtnSi.Click
        lnkGrabar_Click(sender, e)
        idTransportadora = Session("cantidadTransportadora")
        cantidadTransportadora = idTransportadora
        Dim dtCombos As DataTable
        dtCombos = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(idTransportadora, 0, 0)
        Session("dtCombos") = dtCombos
        gvComboRegistrado.DataSource = dtCombos
        gvComboRegistrado.DataBind()
        gvComboRegistrado.Visible = True
        Session("cantidadTransportadora") = cantidadTransportadora
        Session("existeTransportadora") = True
        desmarcarComboDetalle()
        gvComboRegistrado.Enabled = True
        PnlDetalleCombo.Enabled = False
        lnkNew.Enabled = True
        lnkGrabar.Enabled = False
        dlgDetalleCombo.Show()
    End Sub

    Private Sub BtnNO_Click(sender As Object, e As System.EventArgs) Handles BtnNO.Click
        idTransportadora = Session("cantidadTransportadora")
        cantidadTransportadora = idTransportadora
        Dim dtCombos As DataTable
        dtCombos = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(idTransportadora, 0, 0)
        Session("dtCombos") = dtCombos
        gvComboRegistrado.DataSource = dtCombos
        gvComboRegistrado.DataBind()
        gvComboRegistrado.Visible = True
        Session("cantidadTransportadora") = cantidadTransportadora
        Session("existeTransportadora") = True
        desmarcarComboDetalle()
        gvComboRegistrado.Enabled = True
        PnlDetalleCombo.Enabled = False
        lnkNew.Enabled = True
        lnkGrabar.Enabled = False
        dlgDetalleCombo.Show()
    End Sub

    Private Sub btnSiTarifa_Click(sender As Object, e As System.EventArgs) Handles btnSiTarifa.Click
        btnGrabarDetalleTarifa_Click(sender, e)
        Dim dtTarifaAct As DataTable
        dtTarifaAct = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(Session("cantidadTransportadora"), 0)
        Session("dtTarifa") = dtTarifaAct
        gvDetalleTarifa.DataSource = dtTarifaAct
        gvDetalleTarifa.DataBind()
        gvDetalleTarifa.Visible = True
        pnlDetalleTarifa.Visible = True
        gvDetalleTarifa.Visible = True
        dlgDetalleTarifa.Show()
    End Sub

    Private Sub btnNoTarifa_Click(sender As Object, e As System.EventArgs) Handles btnNoTarifa.Click
        Dim dtTarifaAct As DataTable
        dtTarifaAct = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(Session("cantidadTransportadora"), 0)
        Session("dtTarifa") = dtTarifaAct
        gvDetalleTarifa.DataSource = dtTarifaAct
        gvDetalleTarifa.DataBind()
        gvDetalleTarifa.Visible = True
        pnlDetalleTarifa.Visible = True
        gvDetalleTarifa.Visible = True
        cargarDatosDetalle()
        liberarCampos()
        dlgDetalleTarifa.Show()
    End Sub

    Private Sub BtnSiRango_Click(sender As Object, e As System.EventArgs) Handles BtnSiRango.Click
        lnkGrabarRango_Click(sender, e)
        idTransportadora = Session("cantidadTransportadora")
        cantidadTransportadora = idTransportadora
        txtCntInicialDetalle.Text = ""
        txtCntFinalDetalle.Text = ""
        lnkNewRango.Enabled = True
        lnkGrabarRango.Enabled = False
        Dim dtRangos As DataTable
        Session("cantidadTransportadora") = cantidadTransportadora
        Session("existeTransportadora") = True
        dtRangos = LogisticaInversa.AdministracionTransportadoras.ObtenerRangosTransportadora(idTransportadora, 0)
        Session("dtRangos") = dtRangos
        gvRangoDetalle.DataSource = dtRangos
        gvRangoDetalle.DataBind()
        gvRangoDetalle.Visible = True
        pnlRangoDetalle.Enabled = False
        gvRangoDetalle.Enabled = True
        dlgDetalleRango.Show()
    End Sub

    Private Sub BtnNoRango_Click(sender As Object, e As System.EventArgs) Handles BtnNoRango.Click
        idTransportadora = Session("cantidadTransportadora")
        cantidadTransportadora = idTransportadora
        ddlTarifaRangoDetalle.SelectedValue = 0
        txtCntInicialDetalle.Text = ""
        txtCntFinalDetalle.Text = ""
        lnkNewRango.Enabled = True
        lnkGrabarRango.Enabled = False
        Dim dtRangos As DataTable
        Session("cantidadTransportadora") = cantidadTransportadora
        Session("existeTransportadora") = True
        dtRangos = LogisticaInversa.AdministracionTransportadoras.ObtenerRangosTransportadora(idTransportadora, 0)
        Session("dtRangos") = dtRangos
        gvRangoDetalle.DataSource = dtRangos
        gvRangoDetalle.DataBind()
        gvRangoDetalle.Visible = True
        pnlRangoDetalle.Enabled = False
        gvRangoDetalle.Enabled = True
        dlgDetalleRango.Show()
    End Sub

    Private Sub LnkBtnTipoTarifa_Click(sender As Object, e As EventArgs) Handles LnkBtnTipoTarifa.Click
        lnkNuevoTipoTarifa.Enabled = True
        lnkGrabarTipoTarifa.Enabled = False
        txtTipoTarifa.Text = ""
        Dim dtTipos As DataTable
        dtTipos = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(0, "")
        Session("dtTipoTarifa") = dtTipos
        With gvTipoTarifa
            .DataSource = dtTipos
            .DataBind()
            .Visible = True
            .Enabled = True
        End With
        pnlTipoTarifa.Enabled = False
        dlgTipoTarifa.Show()
    End Sub

    Private Sub lnkNuevoTipoTarifa_Click(sender As Object, e As System.EventArgs) Handles lnkNuevoTipoTarifa.Click
        txtTipoTarifa.Text = ""
        LblResulTipoTarifa.Text = ""
        lnkNuevoTipoTarifa.Enabled = False
        lnkGrabarTipoTarifa.Enabled = True
        pnlTipoTarifa.Enabled = True
        gvTipoTarifa.Enabled = False
        Session("accion") = "insertar"
        dlgTipoTarifa.Show()
    End Sub

    Private Sub lnkGrabarTipoTarifa_Click(sender As Object, e As System.EventArgs) Handles lnkGrabarTipoTarifa.Click

        Dim dtTiposExistentes As DataTable
        dtTiposExistentes = Session("dtTipoTarifa")

        If Session("accion") <> "borrar" Then
            If dtTiposExistentes.Rows.Count > 0 Then
                validaTipoTarifa(dtTiposExistentes)
            Else
                pMensaje = ""
            End If
            If pMensaje.Trim.Length > 0 Then
                LblResulTipoTarifa.ForeColor = Color.Red
                LblResulTipoTarifa.Text = "Tipo Tarifa ya existe, verifique."
                txtTipoTarifa.Text = ""
                gvTipoTarifa.Enabled = True
                lnkNuevoTipoTarifa.Enabled = True
                lnkGrabarTipoTarifa.Enabled = False
                pnlTipoTarifa.Enabled = False
                dlgTipoTarifa.Show()
                Exit Sub
            Else
                LblResulTipoTarifa.Text = ""
            End If
        End If

        dtTipoTarifa = CrearEstructuraDeDatos("dtTipoTarifa")

        If Session("accion") = "insertar" Then
            llenarDt("dtTipoTarifa", "")
        Else
            llenarDt("dtTipoTarifa", "detalle")
        End If

        LogisticaInversa.AdministracionTransportadoras.ActualizarDatosTransportadora(dtTipoTarifa, "TipoTarifa")

        LblResulTipoTarifa.ForeColor = Color.Blue
        If Session("accion") = "insertar" Then
            LblResulTipoTarifa.Text = "Tipo Tarifa Creado Existosamente"
        ElseIf Session("accion") = "actualizar" Then
            LblResulTipoTarifa.Text = "Tipo Tarifa Actualizado Existosamente"
        ElseIf Session("accion") = "borrar" Then
            LblResulTipoTarifa.Text = "Tipo Tarifa Borrado Existosamente"
        End If

        txtTipoTarifa.Text = ""
        lnkNuevoTipoTarifa.Enabled = True
        lnkGrabarTipoTarifa.Enabled = False
        Dim dtTipos As DataTable
        dtTipos = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(0, "")
        Session("dtTipoTarifa") = dtTipos
        With gvTipoTarifa
            .DataSource = dtTipos
            .DataBind()
            .Visible = True
            .Enabled = True
        End With
        pnlTipoTarifa.Enabled = False
        dlgTipoTarifa.Show()
    End Sub

    Private Sub gvTipoTarifa_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvTipoTarifa.RowCommand
        If e.CommandName = "EditarTipoTarifa" Then
            idTipoTarifa = e.CommandArgument.ToString()
            LblResulTipoTarifa.Text = ""
            dtTipoTarifa = Session("dtTipoTarifa")
            llenaTipoTarifa(dtTipoTarifa, idTipoTarifa)
            Session("idTipoTarifa") = e.CommandArgument.ToString()
            gvTipoTarifa.Enabled = False
            pnlTipoTarifa.Enabled = True
            Session("accion") = "actualizar"
            lnkNuevoTipoTarifa.Enabled = False
            lnkGrabarTipoTarifa.Enabled = True
            dlgTipoTarifa.Show()
        ElseIf e.CommandName = "BorrarTipoTarifa" Then
            LblResulTipoTarifa.Text = ""
            Session("accion") = "borrar"
            idTipoTarifa = e.CommandArgument.ToString()
            Session("idTipoTarifa") = idTipoTarifa
            dtTipoTarifa = Session("dtTipoTarifa")
            llenaTipoTarifa(dtTipoTarifa, idTipoTarifa)
            lnkNuevoTipoTarifa.Enabled = False
            lnkGrabarTipoTarifa.Enabled = False
            dlgConfirmacionTipo.Show()
            pnlTipoTarifa.Enabled = False
            gvTipoTarifa.Enabled = False
        End If
    End Sub

    Private Sub BtnSiTipo_Click(sender As Object, e As System.EventArgs) Handles BtnSiTipo.Click
        lnkGrabarTipoTarifa_Click(sender, e)
        txtTipoTarifa.Text = ""
        lnkNuevoTipoTarifa.Enabled = True
        lnkGrabarTipoTarifa.Enabled = False
        Dim dtTipos As DataTable
        dtTipos = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(0, "")
        Session("dtTipoTarifa") = dtTipos
        gvTipoTarifa.DataSource = dtTipos
        gvTipoTarifa.DataBind()
        gvTipoTarifa.Visible = True
        pnlTipoTarifa.Enabled = False
        gvTipoTarifa.Enabled = True
        dlgTipoTarifa.Show()
    End Sub

    Private Sub BtnNoTipo_Click(sender As Object, e As System.EventArgs) Handles BtnNoTipo.Click
        txtTipoTarifa.Text = ""
        lnkNuevoTipoTarifa.Enabled = True
        lnkGrabarTipoTarifa.Enabled = False
        Dim dtTipos As DataTable
        dtTipos = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(0, "")
        Session("dtTipoTarifa") = dtTipos
        gvTipoTarifa.DataSource = dtTipos
        gvTipoTarifa.DataBind()
        gvTipoTarifa.Visible = True
        pnlTipoTarifa.Enabled = False
        gvTipoTarifa.Enabled = True
        dlgTipoTarifa.Show()
    End Sub

#End Region

#Region "metodos"

    Private Sub cargaInicial()
        Try
            Dim dt As DataTable = LogisticaInversa.AdministracionTransportadoras.ObtenerTransportadoras(0)
            Session("dtTransportadora") = dt
            gvTransportadoras.DataSource = dt
            gvTransportadoras.DataBind()
            gvTransportadoras.Visible = True
        Catch ex As Exception
            epNotificar.showError("Error al cargar transportadora: " & ex.ToString)
        End Try
    End Sub

    Private Sub cargarDatos()

        Dim dt As DataTable
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoProducto()
        If dt.Rows.Count > 0 Then
            With ddlProducto
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoProducto"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtTipoProducto") = dt
        Else
            existeProducto = False
            Exit Sub
        End If

        dt.Clear()
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoServicio(idTransportadora)
        If dt.Rows.Count > 0 Then
            With ddlServicio
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtTipoServicio") = dt
        Else
            existeServicio = False
            Exit Sub
        End If

        dt.Clear()
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(0, "")
        If dt.Rows.Count > 0 Then
            With ddlTarifa
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoTarifa"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtTipoTarifa") = dt
        Else
            existeTarifa = False
            Exit Sub
        End If

    End Sub

    Private Sub cargarDatosDetalle()

        Dim dt As DataTable
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoProducto()
        If dt.Rows.Count > 0 Then
            With ddlProductoDetalle
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoProducto"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtTipoProducto") = dt
        Else
            existeProducto = False
            Exit Sub
        End If

        dt.Clear()
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoServicio(0)
        If dt.Rows.Count > 0 Then
            With ddlServicioDetalle
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoServicio"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtTipoServicio") = dt
        Else
            existeServicio = False
            Exit Sub
        End If

        dt.Clear()
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoTarifa(0, "")
        If dt.Rows.Count > 0 Then
            With ddlTarifaDetalle
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idTipoTarifa"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtTipoTarifa") = dt
        Else
            existeTarifa = False
            Exit Sub
        End If

        dt.Clear()
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerCanales(0, "")
        If dt.Rows.Count > 0 Then
            With ddlCanal
                .DataSource = dt
                .DataTextField = "descripcion"
                .DataValueField = "idCanal"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione...", "0"))
            End With
            Session("dtCanales") = dt
        Else
            existeTarifa = False
            Exit Sub
        End If


    End Sub

    Private Sub liberarCampos()
        Try
            ddlServicio.SelectedValue = 0
            ddlServicioDetalle.SelectedValue = 0
            txtValor.Text = ""
            txtValorDetalle.Text = ""
            txtTarifa.Text = ""
            txtTarifaDetalle.Text = ""
            ddlProducto.SelectedValue = 0
            ddlProductoDetalle.SelectedValue = 0
            ddlTarifa.SelectedValue = 0
            ddlTarifaDetalle.SelectedValue = 0
            ddlCanal.SelectedValue = 0
            chbCombo.Checked = False
            chbRango.Checked = False
            pnlRango.Visible = False
            pnlCombo.Visible = False
            chbPOS.Checked = False
            chbGuia.Checked = False
            chbPrecinto.Checked = False
            chbLogisticaInversa.Checked = False
            chbImportacion.Checked = False
            chbNacionales.Checked = False
            chbTipoProducto.Checked = False
            pnlTarifaTransportadora.Visible = False
            LblErrorDetalle.Text = ""
            txtCntInicial.Text = ""
            txtCntFinal.Text = ""
            If dttransportadora IsNot Nothing Then dttransportadora.Clear()
            If dtTarifa IsNot Nothing Then dtTarifa.Clear()
            If dtRango IsNot Nothing Then dtRango.Clear()
            If dtCombo IsNot Nothing Then dtCombo.Clear()
            Session("idTarifa") = 0
        Catch ex As Exception
            epNotificar.showError("Error al liberar campos transportadora: " & ex.ToString)
        End Try
    End Sub

    Private Sub ValidarInformacion(ByVal pOrigen As String)
        If pOrigen.Trim = "" Then
            If Not chbPOS.Checked And Not chbGuia.Checked And Not chbPrecinto.Checked And Not chbLogisticaInversa.Checked And Not chbImportacion.Checked And Not chbNacionales.Checked And Not chbTipoProducto.Checked Then
                pMensaje = "Debe Seleccionar minimo un valor de las propiedades para continuar con la creación de la transportadora."
            End If
        Else
            If Not chbPosDetalle.Checked And Not chbGuiaDetalle.Checked And Not chbPrecintoDetalle.Checked And Not chbLogisticaDetalle.Checked And Not chbImportacionDetalle.Checked And Not chbNacionalesDetalle.Checked And Not chbTipoProductoDetalle.Checked Then
                pMensaje = "Debe Seleccionar minimo un valor de las propiedades para continuar con la creación de la transportadora."
            End If
        End If
    End Sub

    Private Sub validaTarifa()
        Dim dtTarifa As DataTable
        dtTarifa = LogisticaInversa.AdministracionTransportadoras.ObtenerTarifaTransportadora(Session("cantidadTransportadora"), 0)
        If dtTarifa.Rows.Count > 0 Then
            Dim i As Integer
            i = 0
            For i = 0 To dtTarifa.Rows.Count - 1
                If InStr(ddlTarifaDetalle.SelectedItem.Text.ToLower, "combo") > 0 Then

                    If dtTarifa.Rows(i).Item("idTipoServicio") = ddlServicioDetalle.SelectedValue And dtTarifa.Rows(i).Item("idTipoTarifa") = ddlTarifaDetalle.SelectedValue Then
                        pMensaje = "Combinacion de Tarifa-Transportadora ya existe verifique."
                        Exit Sub
                    End If
                Else
                    If dtTarifa.Rows(i).Item("idTipoServicio") = ddlServicioDetalle.SelectedValue And dtTarifa.Rows(i).Item("idTipoProducto") = ddlProductoDetalle.SelectedValue And dtTarifa.Rows(i).Item("idTipoTarifa") = ddlTarifaDetalle.SelectedValue Then
                        pMensaje = "Combinacion de Tarifa-Transportadora ya existe verifique."
                        Exit Sub
                    End If
                End If
            Next
        Else
        pMensaje = ""
        End If
        If pMensaje.ToString.Trim.Length = 0 Then
            If ddlProductoDetalle.Enabled And InStr(ddlTarifaDetalle.SelectedItem.Text.ToLower, "combo") = 0 Then
                If ddlProductoDetalle.SelectedValue = "0" Then
                    pMensaje = "Debe Seleccionar tipo de producto para continuar con la creación de la tarifa de la transportadora."
                End If
            End If
        End If
    End Sub

    Private Function CrearEstructuraDeDatos(ByVal nombreTable As String)
        Dim dt As New DataTable
        Dim columnas As String = ""
        Select Case nombreTable
            Case "dtTransportadora"
                columnas = "idtrans,transportadora,estado,maneja_pos,usaGuia,usaPrecinto,aplicaLogisticaInversa,cargaPorImportacion,aplicaDespachoNacional,aplicaTipoProducto"
            Case "dtTarifa"
                columnas = "idtarifa,idTipoServicio,idTransportadora,valordeManejo,tarifaMinima,idTipoProducto,idTipoTarifa,idCanal,idUsuario,accion"
            Case "dtCombo"
                columnas = "idTipoTarifa,idTipoProducto,idUsuario,idtransportadora,idGrupoTransportadora,accion"
            Case "dtRango"
                columnas = "idTipoTarifa,valorInicial,valorFinal,idUsuario,idTransportadora,idRango,accion"
            Case "dtResultado"
                columnas = "resultado"
            Case "dtTipoTarifa"
                columnas = "idTipoTarifa,descripcion,idUsuario,accion"
            Case Else
                columnas = "Error inesperado"
        End Select
        Dim arrcolumnas As String() = columnas.Split(",")
        For Each nombreColumna As String In arrcolumnas
            dt.Columns.Add(New DataColumn(nombreColumna))
        Next
        If dt.Columns.Count = 0 Then
            Throw New Exception("no se ha podido obtener la estructura de los datos")
        Else
            Return dt
        End If
    End Function

    Private Sub llenarDt(ByVal nombreTabla As String, ByVal pOrigen As String)
        Dim drAux As DataRow
        Select Case nombreTabla
            Case "dtTransportadora"
                drAux = dttransportadora.NewRow
                If pOrigen.Trim.Length > 0 Then 'Modificación Transportadora
                    drAux("idTrans") = dtTransOriginal.Rows(0).Item("idTransportadora").ToString.Trim
                    drAux("transportadora") = dtTransOriginal.Rows(0).Item("transportadora").ToString.Trim
                    drAux("estado") = "1"
                    If chbPosDetalle.Checked Then drAux("maneja_pos") = "S" Else drAux("maneja_pos") = "N"
                    If chbGuiaDetalle.Checked Then drAux("usaGuia") = "1" Else drAux("usaGuia") = "0"
                    If chbPrecintoDetalle.Checked Then drAux("usaPrecinto") = "1" Else drAux("usaPrecinto") = "0"
                    If chbLogisticaDetalle.Checked Then drAux("aplicaLogisticaInversa") = "1" Else drAux("aplicaLogisticaInversa") = "0"
                    If chbImportacionDetalle.Checked Then drAux("cargaPorImportacion") = "1" Else drAux("cargaPorImportacion") = "0"
                    If chbNacionalesDetalle.Checked Then drAux("aplicaDespachoNacional") = "1" Else drAux("aplicaDespachoNacional") = "0"
                    If chbTipoProductoDetalle.Checked Then drAux("aplicaTipoProducto") = "1" Else drAux("aplicaTipoProducto") = "0"
                    dttransportadora.Rows.Add(drAux)
                Else 'Creación Transportadora
                    drAux("idTrans") = cantidadTransportadora
                    drAux("transportadora") = txtNombre.Text.Trim
                    drAux("estado") = "1"
                    If chbPOS.Checked Then drAux("maneja_pos") = "S" Else drAux("maneja_pos") = "N"
                    If chbGuia.Checked Then drAux("usaGuia") = "1" Else drAux("usaGuia") = "0"
                    If chbPrecinto.Checked Then drAux("usaPrecinto") = "1" Else drAux("usaPrecinto") = "0"
                    If chbLogisticaInversa.Checked Then drAux("aplicaLogisticaInversa") = "1" Else drAux("aplicaLogisticaInversa") = "0"
                    If chbImportacion.Checked Then drAux("cargaPorImportacion") = "1" Else drAux("cargaPorImportacion") = "0"
                    If chbNacionales.Checked Then drAux("aplicaDespachoNacional") = "1" Else drAux("aplicaDespachoNacional") = "0"
                    If chbTipoProducto.Checked Then drAux("aplicaTipoProducto") = "1" Else drAux("aplicaTipoProducto") = "0"
                    dttransportadora.Rows.Add(drAux)
                End If
            Case "dtTarifa"
                drAux = dtTarifa.NewRow
                If pOrigen.Trim.Length > 0 Then 'Modificación Tarifa
                    drAux("idTarifa") = Session("idTarifa")
                    drAux("idTipoServicio") = ddlServicioDetalle.SelectedValue.ToString
                    drAux("idTransportadora") = Session("cantidadTransportadora")
                    drAux("valordeManejo") = txtValorDetalle.Text.Trim
                    drAux("tarifaMinima") = txtTarifaDetalle.Text.Trim
                    If ddlProductoDetalle.Enabled Then
                        drAux("idTipoProducto") = ddlProductoDetalle.SelectedValue.ToString
                    Else
                        drAux("idTipoProducto") = 0
                    End If
                    drAux("idTipoTarifa") = ddlTarifaDetalle.SelectedValue.ToString
                    drAux("idCanal") = ddlCanal.SelectedValue.ToString
                    drAux("idUsuario") = Session("usxp001")
                    drAux("accion") = Session("accion")
                    dtTarifa.Rows.Add(drAux)
                Else 'Creacion Tarifa
                    drAux("idTipoServicio") = ddlServicio.SelectedValue.ToString
                    drAux("idTransportadora") = cantidadTransportadora
                    drAux("valordeManejo") = txtValor.Text.Trim
                    drAux("tarifaMinima") = txtTarifa.Text.Trim
                    If ddlProducto.Enabled Then
                        drAux("idTipoProducto") = ddlProducto.SelectedValue.ToString
                    Else
                        drAux("idTipoProducto") = 0
                    End If
                    drAux("idTipoTarifa") = ddlTarifa.SelectedValue.ToString
                    drAux("idUsuario") = Session("usxp001")
                    dtTarifa.Rows.Add(drAux)
                End If
            Case "dtCombo"
                Dim i As Integer = 0
                For i = 0 To chblProductosCombo.Items.Count - 1
                    If chblProductosCombo.Items(i).Selected Then
                        drAux = dtCombo.NewRow
                        drAux("idTipoTarifa") = ddlTarifa.SelectedValue.ToString
                        drAux("idTipoProducto") = chblProductosCombo.Items(i).Value
                        drAux("idUsuario") = Session("usxp001")
                        If Session("existeTransportadora") Then
                            drAux("idTransportadora") = Session("cantidadTransportadora")
                        Else
                            drAux("idTransportadora") = cantidadTransportadora
                        End If
                        drAux("idGrupoTransportadora") = 1
                        dtCombo.Rows.Add(drAux)
                    End If
                Next
            Case "dtRango"
                dtRango.Clear()
                If pOrigen.Trim.Length > 0 Then 'Modificación Rango
                    drAux = dtRango.NewRow
                    drAux("idTipoTarifa") = ddlTarifaRangoDetalle.SelectedValue.ToString
                    drAux("valorInicial") = txtCntInicialDetalle.Text
                    drAux("valorFinal") = txtCntFinalDetalle.Text
                    drAux("idUsuario") = Session("usxp001")
                    If Session("existeTransportadora") Then
                        drAux("idTransportadora") = Session("cantidadTransportadora")
                    Else
                        drAux("idTransportadora") = cantidadTransportadora
                    End If
                    drAux("idRango") = Session("idRango")
                    drAux("accion") = Session("accion")
                    dtRango.Rows.Add(drAux)
                Else
                    drAux = dtRango.NewRow
                    drAux("idTipoTarifa") = ddlTarifa.SelectedValue.ToString
                    drAux("valorInicial") = txtCntInicial.Text
                    drAux("valorFinal") = txtCntFinal.Text
                    drAux("idUsuario") = Session("usxp001")
                    If Session("existeTransportadora") Then
                        drAux("idTransportadora") = Session("cantidadTransportadora")
                    Else
                        drAux("idTransportadora") = cantidadTransportadora
                    End If
                    dtRango.Rows.Add(drAux)
                End If
            Case "dtTipoTarifa"
                dtTipoTarifa.Clear()
                If pOrigen.Trim.Length > 0 Then 'Modificación Tipo Tarifa
                    drAux = dtTipoTarifa.NewRow
                    drAux("idTipoTarifa") = Session("idTipoTarifa")
                    drAux("descripcion") = txtTipoTarifa.Text.Trim
                    drAux("idUsuario") = Session("usxp001")
                    drAux("accion") = Session("accion")
                    dtTipoTarifa.Rows.Add(drAux)
                Else
                    drAux = dtTipoTarifa.NewRow
                    drAux("descripcion") = txtTipoTarifa.Text.Trim
                    drAux("idUsuario") = Session("usxp001")
                    drAux("accion") = Session("accion")
                    dtTipoTarifa.Rows.Add(drAux)
                End If
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub llenaPropiedades(ByVal dtPropiedades As DataTable)

        If dtPropiedades.Rows(0).Item("maneja_pos") = "S" Then
            chbPosDetalle.Checked = True
        Else
            chbPosDetalle.Checked = False
        End If

        If dtPropiedades.Rows(0).Item("usaGuia") = "1" Then
            chbGuiaDetalle.Checked = True
        Else
            chbGuiaDetalle.Checked = False
        End If

        If dtPropiedades.Rows(0).Item("usaPrecinto") = "1" Then
            chbPrecintoDetalle.Checked = True
        Else
            chbPrecintoDetalle.Checked = False
        End If

        If dtPropiedades.Rows(0).Item("aplicaLogisticaInversa") = "1" Then
            chbLogisticaDetalle.Checked = True
        Else
            chbLogisticaDetalle.Checked = False
        End If

        If dtPropiedades.Rows(0).Item("cargaPorImportacion") = "1" Then
            chbImportacionDetalle.Checked = True
        Else
            chbImportacionDetalle.Checked = False
        End If

        If dtPropiedades.Rows(0).Item("aplicaDespachoNacional") = "1" Then
            chbNacionalesDetalle.Checked = True
        Else
            chbNacionalesDetalle.Checked = False
        End If

        If dtPropiedades.Rows(0).Item("aplicaTipoProducto") = "1" Then
            chbTipoProductoDetalle.Checked = True
        Else
            chbTipoProductoDetalle.Checked = False
        End If

    End Sub

    Private Sub llenaTarifa(ByVal dtTarifa As DataTable)

        ddlServicio.SelectedValue = dtTarifa.Rows(0).Item("idTipoServicio")
        txtValor.Text = dtTarifa.Rows(0).Item("valordeManejo").ToString.Substring(0, 9)
        txtTarifa.Text = dtTarifa.Rows(0).Item("tarifaMinima")
        ddlProducto.SelectedValue = dtTarifa.Rows(0).Item("idTipoProducto")
        ddlTarifa.SelectedValue = dtTarifa.Rows(0).Item("idTipoTarifa")

    End Sub

    Private Sub llenaCombo(ByVal dtCombo As DataTable)
        Dim dt As DataTable
        dt = LogisticaInversa.AdministracionTransportadoras.ObtenerTipoProducto()
        With chblProductosCombo
            .DataSource = dt
            .DataTextField = "descripcion"
            .DataValueField = "idTipoProducto"
            .DataBind()
        End With

        Dim i, a As Integer
        i = 0
        a = 0
        Dim idtipoProducto As Integer
        For i = 0 To dtCombo.Rows.Count - 1
            idtipoProducto = dtCombo.Rows(i).Item("idtipoproducto")
            For a = 0 To chblProductosCombo.Items.Count - 1
                If chblProductosCombo.Items(a).Value = idtipoProducto Then
                    chblProductosCombo.Items(a).Selected = True
                    Exit For
                End If
            Next
        Next

    End Sub

    Private Sub llenaRango(ByVal dtRango As DataTable)
        txtCntInicial.Text = dtRango.Rows(0).Item("valorInicial")
        txtCntFinal.Text = dtRango.Rows(0).Item("valorFinal")
    End Sub

    Private Sub llenaRangoDetalle(ByVal dtRango As DataTable, ByVal idrango As Integer)
        Dim dtRow As DataRow()
        dtRow = dtRango.Select("idRango = " & idrango)
        'ddlTarifaRangoDetalle.SelectedValue = dtRow(0).Item("idTipoTarifa")
        txtCntInicialDetalle.Text = dtRow(0).Item("valorInicial")
        txtCntFinalDetalle.Text = dtRow(0).Item("valorFinal")
    End Sub

    Private Sub llenaTipoTarifa(ByVal dtTipoTarifa As DataTable, ByVal idTipoTarifa As Integer)
        Dim dtRow As DataRow()
        dtRow = dtTipoTarifa.Select("idTipoTarifa = " & idTipoTarifa)
        txtTipoTarifa.Text = dtRow(0).Item("descripcion")
    End Sub

    Private Sub desmarcarComboDetalle()
        Dim i As Integer
        i = 0
        For i = 0 To chblComboDetalle.Items.Count - 1
            chblComboDetalle.Items(i).Selected = False
        Next
    End Sub

    Private Sub llenaComboSeleccionado(ByVal dt As DataTable)

        desmarcarComboDetalle()

        Dim j As Integer
        j = 0
        For j = 0 To dt.Rows.Count - 1
            Dim i As Integer
            i = 0
            For i = 0 To chblComboDetalle.Items.Count - 1
                If dt.Rows(j).Item("idTipoProducto") = chblComboDetalle.Items(i).Value Then
                    chblComboDetalle.Items(i).Selected = True
                    Exit For
                End If
            Next
        Next

        If Session("accion") <> "borrar" Then
            ddlTarifaCombo.SelectedValue = dt.Rows(0).Item("idTipoTarifa")
        End If

    End Sub

    Private Sub validaCombo(ByVal dtGrupos As DataTable)

        Dim dtresultado As DataTable = CrearEstructuraDeDatos("dtResultado")
        Dim dtComboVal As DataTable
        Dim drResultado As DataRow

        dtComboVal = LogisticaInversa.AdministracionTransportadoras.ObtenerCombosTransportadora(0, 0, Session("cantidadTransportadora"))
        If dtComboVal.Rows.Count > 0 Then
            Dim a As Integer
            a = 0
            For a = 0 To dtGrupos.Rows.Count - 1
                Dim dtRow As DataRow()
                dtRow = dtComboVal.Select("idGrupoTransportadora =" & dtGrupos.Rows(a).Item("idcombo"))
                If dtRow.Length > 0 Then
                    If dtCombo.Rows.Count = dtRow.Length Then
                        Dim e As Integer
                        e = 0
                        For e = 0 To dtRow.Length - 1
                            Dim i As Integer
                            i = 0
                            For i = 0 To dtCombo.Rows.Count - 1
                                drResultado = dtresultado.NewRow()
                                If dtRow(e).Item("idtipoproducto") = dtCombo.Rows(i).Item("idtipoproducto") And dtRow(e).Item("idtipotarifa") = dtCombo.Rows(i).Item("idtipotarifa") Then
                                    drResultado("resultado") = "True"
                                    dtresultado.Rows.Add(drResultado)
                                    Exit For
                                Else
                                    drResultado("resultado") = "False"
                                    dtresultado.Rows.Add(drResultado)
                                End If
                            Next
                        Next

                        Dim resulPositivo As Integer = 0
                        Dim resulNegativo As Integer = 0
                        Dim o As Integer
                        o = 0
                        For o = 0 To dtresultado.Rows.Count - 1
                            If dtresultado.Rows(o).Item("resultado") = "True" Then
                                resulPositivo = resulPositivo + 1
                            Else
                                resulNegativo = resulNegativo + 1
                            End If
                        Next

                        If resulPositivo = dtRow.Length Then
                            pMensaje = "Combo ya existe. Verifique."
                            Exit For
                        Else
                            pMensaje = ""
                        End If
                        dtresultado.Clear()
                    End If
                End If
            Next
        Else
            pMensaje = ""
        End If
    End Sub

    Private Sub validaRango(ByVal dt As DataTable)
        Dim i As Integer
        i = 0
        For i = 0 To dt.Rows.Count - 1
            If dt.Rows(i).Item("valorInicial") = txtCntInicialDetalle.Text.Trim And dt.Rows(i).Item("valorFinal") = txtCntFinalDetalle.Text.Trim And dt.Rows(i).Item("idTipoTarifa") = ddlTarifaRangoDetalle.SelectedValue Then
                pMensaje = "Error"
                Exit For
            Else
                pMensaje = ""
            End If

            If txtCntInicialDetalle.Text.Trim >= dt.Rows(i).Item("valorInicial") And txtCntInicialDetalle.Text.Trim <= dt.Rows(i).Item("valorFinal") And dt.Rows(i).Item("idTipoTarifa") = ddlTarifaRangoDetalle.SelectedValue Then
                pMensaje = "Error"
                Exit For
            Else
                pMensaje = ""
            End If

            If txtCntFinalDetalle.Text.Trim >= dt.Rows(i).Item("valorInicial") And txtCntFinalDetalle.Text.Trim <= dt.Rows(i).Item("valorFinal") And dt.Rows(i).Item("idTipoTarifa") = ddlTarifaRangoDetalle.SelectedValue Then
                pMensaje = "Error"
                Exit For
            Else
                pMensaje = ""
            End If
        Next
    End Sub

    Private Sub validaTipoTarifa(ByVal dt As DataTable)
        Dim i As Integer
        i = 0
        For i = 0 To dt.Rows.Count - 1
            If dt.Rows(i).Item("descripcion").ToString.ToLower = txtTipoTarifa.Text.Trim.ToLower Then
                pMensaje = "Error"
                Exit For
            Else
                pMensaje = ""
            End If
        Next
    End Sub

#End Region

End Class