Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class EditarPlanVenta
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idPlan As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            If Request.QueryString("idPlan") IsNot Nothing Then Integer.TryParse(Request.QueryString("idPlan").ToString, _idPlan)
            If _idPlan > 0 Then
                With miEncabezado
                    .setTitle("Modificar Plan de Venta")
                End With
                Session("idPlan") = _idPlan
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idPlan") IsNot Nothing Then _idPlan = Session("idPlan")
        End If
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Dim resultado As ResultadoProceso
        If IsCallback And Not String.IsNullOrEmpty(e.Parameters) Then
            Dim parameters() As String = e.Parameters.Split(":"c)
            Select Case parameters(1)
                Case "eliminar"
                    EliminarVenta(CInt(parameters(0)))
                    DirectCast(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                Case "adicionar"
                    resultado = AdicionarEquipo(cmbEquipo.Value, cmbEquipo.Text, CDbl(txtValorEquipo.Text), CDbl(txtValorIva.Text))
                    If resultado.Valor = 0 Then
                        txtValorEquipo.Text = String.Empty
                        txtValorIva.Text = String.Empty
                        txtEquipoFiltro.Text = String.Empty
                        cmbEquipo.Value = Nothing
                        cmbEquipo.Text = Nothing
                        BuscarRegistros()

                        miEncabezado.showSuccess(resultado.Mensaje)
                    Else
                        miEncabezado.showWarning(resultado.Mensaje)
                    End If
                    DirectCast(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        End If
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    End Sub

    Private Sub cpFiltroMaterial_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltroMaterial.Callback
        Dim filtroRapido As String = ""
        If e.Parameter.Length >= 4 Then
            filtroRapido = e.Parameter
            CargarListadoMateriales(filtroRapido)
        Else
            lblResultadoMaterial.Text = "0 Registro(s) Cargado(s)"
        End If
    End Sub

    Private Sub cbPrincipal_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles cbPrincipal.Callback
        Try
            ActualizarPlan()
            CType(source, ASPxCallback).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch : End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Carga los tipos de Plan
            MetodosComunes.CargarComboDX(cmbTipoPlan, HerramientasMensajeria.ObtieneTiposPlanVenta, "idTipo", "nombre")

            Dim objPlan As New PlanVenta(idPlan:=_idPlan)
            With objPlan
                txtNombrePlan.Text = .NombrePlan
                memoDescripcionPlan.Text = .Descripcion
                txtCFM.Text = .CargoFijoMensualConImpuesto
                txtCargoFijoMensual.Text = .CargoFijoMensual
                textImpuestos.Text = .Impuesto
                cmbTipoPlan.Value = .IdTipoPlan.ToString()
                chbActivo.Checked = .Activo
            End With
            BuscarRegistros()

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            'La visualización es visible para todos
            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarVenta(ByVal idRegistroMaterialPlan As Integer)
        Dim resultado As New ResultadoProceso()
        Try
            Dim objMaterialPlan As New MaterialEnPlanVenta(idRegistro:=idRegistroMaterialPlan)
            resultado = objMaterialPlan.Eliminar()

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Material " & objMaterialPlan.Material & " desvinculado exitosamente.")
                BuscarRegistros()
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("No se logro eliminar el material seleccionado: " & ex.Message)
        End Try
    End Sub

    Private Sub BuscarRegistros()
        Try
            Dim objMaterial As New MaterialEnPlanVentaColeccion
            With objMaterial
                .IdPlan = _idPlan
                .CargarDatos()
            End With

            With gvDatos
                .DataSource = objMaterial.GenerarDataTable()
                Session("dtDatos") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error cargando los materiales: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoMateriales(filtroRapido As String)
        If Not String.IsNullOrEmpty(filtroRapido.Trim) Then
            Dim dtMaterial As DataTable = ObtenerListaMateriales(filtroRapido)
            With cmbEquipo
                .DataSource = dtMaterial
                .ValueField = "material"
                .TextField = "referenciaCompuesta"
                .DataBind()
            End With
        Else
            cmbEquipo.Items.Clear()
        End If
        With cmbEquipo
            lblResultadoMaterial.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            ElseIf .Items.Count <> 1 Then
                '.Items.Insert(0, New ListItem("Seleccione un Material...", "0"))
            End If
        End With
    End Sub

    Private Function ObtenerListaMateriales(ByVal filtro As String) As DataTable
        Dim listaMaterial As New Productos.MaterialColeccion
        Dim dtMaterial As DataTable
        With listaMaterial
            .IdTipoProducto = Enumerados.TipoProductoMaterial.HANDSETS
            .FiltroRapido = filtro
            dtMaterial = .GenerarDataTable()
        End With
        Dim dcAux As New DataColumn("referenciaCompuesta")
        dcAux.Expression = "material + ' - '+ referencia"
        dtMaterial.Columns.Add(dcAux)
        Return dtMaterial
    End Function

    Private Function AdicionarEquipo(ByVal material As String, _
                                     ByVal descripcion As String, _
                                     ByVal precioEquipo As Double, _
                                     ByVal precioIvaEquipo As Double) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim objMaterialPlan As New MaterialEnPlanVenta()
            With objMaterialPlan
                .IdPlan = _idPlan
                .Material = material
                .PrecioVentaEquipo = precioEquipo
                .IvaEquipo = precioIvaEquipo
                resultado = .Adicionar()
            End With
        Catch ex As Exception
            Throw ex
        End Try
        Return resultado
    End Function

    Private Sub ActualizarPlan()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objPlan As New PlanVenta()
            With objPlan
                .IdPlan = _idPlan
                .NombrePlan = txtNombrePlan.Text.Trim()
                .Descripcion = memoDescripcionPlan.Text.Trim()
                .CargoFijoMensual = CDbl(txtCFM.Text.Trim())
                .IdTipoPlan = CInt(cmbTipoPlan.Value)
                .Activo = chbActivo.Checked
                .IdUsuario = CInt(Session("usxp001"))
                resultado = .Actualizar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Se realizó la actualziación exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar realizar la actualización: " & ex.Message)
        End Try
    End Sub

#End Region

End Class