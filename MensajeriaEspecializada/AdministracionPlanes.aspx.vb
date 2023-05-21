Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports GemBox
Imports GemBox.Spreadsheet
Imports System.IO

Public Class AdministracionPlanes
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private oExcel As ExcelFile
    Private dtEquipos As DataTable

#End Region

#Region "Propiedades"

    Public Property Equipos As DataTable
        Get
            If IsNothing(Session("dtEquipos")) Then
                EstructuraDatos()
            Else
                dtEquipos = Session("dtEquipos")
            End If
            Return dtEquipos
        End Get
        Set(value As DataTable)
            dtEquipos = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración de Planes")
            End With
            CargaInicial()
        Else
            If Session("oExcel") IsNot Nothing Then oExcel = DirectCast(Session("oExcel"), ExcelFile)
        End If
        MetodosComunes.setGemBoxLicense()
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs) Handles btnFiltrar.Click
        BuscarPlanes()
    End Sub

    Protected Sub btnAdicionar_Click(sender As Object, e As EventArgs) Handles btnAdicionar.Click
        AdicionarPlan()
    End Sub

    Protected Sub gvPlanes_DataBinding(sender As Object, e As EventArgs) Handles gvPlanes.DataBinding
        gvPlanes.DataSource = Session("dtDatosPlanes")
    End Sub

    Protected Sub ucCargueArchivoEquipos_FileUploadComplete(sender As Object, e As DevExpress.Web.FileUploadCompleteEventArgs) Handles ucCargueArchivoEquipos.FileUploadComplete
        Try
            Dim UploadDirectory As String = Server.MapPath("~/MensajeriaEspecializada/Archivos/")
            If ucCargueArchivoEquipos.HasFile Then
                ucCargueArchivoEquipos.SaveAs(UploadDirectory & ucCargueArchivoEquipos.FileName)

                Dim fileExtension As String = Path.GetExtension(ucCargueArchivoEquipos.FileName)
                oExcel = New ExcelFile()
                If fileExtension.ToUpper = ".XLS" Then
                    oExcel.LoadXls(UploadDirectory & ucCargueArchivoEquipos.FileName)
                ElseIf fileExtension.ToUpper = ".XLSX" Then
                    oExcel.LoadXlsx(UploadDirectory & ucCargueArchivoEquipos.FileName, XlsxOptions.None)
                End If
                Session("oExcel") = oExcel

                If File.Exists(UploadDirectory & ucCargueArchivoEquipos.FileName) Then File.Delete(UploadDirectory & ucCargueArchivoEquipos.FileName)
            End If
            e.CallbackData = e.UploadedFile.PostedFile.FileName
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Private Sub cpFiltroMaterial_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltroMaterial.Callback
        Try
            Dim filtroRapido As String = ""
            If e.Parameter.Length >= 4 Then
                filtroRapido = e.Parameter
                CargarListadoMateriales(filtroRapido)
            Else
                lblResultadoMaterial.Text = "0 Registro(s) Cargado(s)"
            End If
        Catch : End Try
    End Sub

    Private Sub gvEquipos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvEquipos.CustomCallback
        Dim resultado As ResultadoProceso
        Try
            resultado = AdicionarEquipo(cmbEquipo.Value, cmbEquipo.Text, CDbl(txtValorEquipo.Text), CDbl(txtValorIva.Text))
            If resultado.Valor = 0 Then
                With gvEquipos
                    .DataSource = Equipos
                    .DataBind()
                End With

                txtValorEquipo.Text = String.Empty
                txtValorIva.Text = String.Empty
                txtEquipoFiltro.Text = String.Empty
                cmbEquipo.Value = Nothing
                cmbEquipo.Text = Nothing
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub gvEquipos_DataBinding(sender As Object, e As System.EventArgs) Handles gvEquipos.DataBinding
        gvEquipos.DataSource = Equipos
    End Sub

    Private Sub gvErrores_DataBinding(sender As Object, e As System.EventArgs) Handles gvErrores.DataBinding
        If Session("dtErrores") IsNot Nothing Then gvErrores.DataSource = Session("dtErrores")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarPlanes()
        Try
            Dim objPlanes As New PlanVentaColeccion()
            With objPlanes
                If Not String.IsNullOrEmpty(txtNombrePlanFiltro.Text.Trim) Then .NombrePlan = txtNombrePlanFiltro.Text.Trim
                .Activo = chbEstadoFiltro.Checked
            End With

            With gvPlanes
                .DataSource = objPlanes.GenerarDataTable()
                Session("dtDatosPlanes") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarPlan()
        Dim resultado As New ResultadoProceso()
        Try
            If oExcel IsNot Nothing Or Equipos.Rows.Count > 0 Then
                Dim objPlan As New PlanVenta()
                With objPlan
                    .NombrePlan = txtNombrePlan.Text.Trim
                    .Descripcion = memoDescripcionPlan.Text.Trim
                    .CargoFijoMensual = CDbl(txtCargoFijoMensual.Text.Trim)
                    .Activo = chbActivo.Checked
                    .IdTipoPlan = cmbTipoPlan.Value
                    .ArchivoExcel = oExcel
                    .EquiposManual = Equipos

                    resultado = .Registrar()
                End With
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)
                    LimpiarFormulario()
                    BuscarPlanes()
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                    If objPlan.EstructuraTablaErrores.Rows.Count > 0 Then
                        rpLogErrores.Visible = True
                        With gvErrores
                            .DataSource = objPlan.EstructuraTablaErrores()
                            Session("dtErrores") = .DataSource
                            .DataBind()
                        End With
                    End If
                End If
            Else
                miEncabezado.showWarning("No fue posible recuperar los datos de equipos, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó error inesperado al tratar de adicionar el plan: " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicial()
        Try
            'Tipos de planes
            MetodosComunes.CargarComboDX(cmbTipoPlan, HerramientasMensajeria.ObtieneTiposPlanVenta(), "idTipo", "nombre")
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar los valores iniciales: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNombrePlan.Text = String.Empty
        memoDescripcionPlan.Text = String.Empty
        txtCargoFijoMensual.Text = String.Empty
        cmbTipoPlan.Value = Nothing
        chbActivo.Checked = True
        Session("dtEquipos") = Nothing
        With gvEquipos
            .DataSource = Equipos
            .DataBind()
        End With
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

    Private Sub EstructuraDatos()
        Dim dtDatos As New DataTable
        If dtEquipos Is Nothing Then
            With dtDatos.Columns
                .Add(New DataColumn("material", GetType(String)))
                .Add(New DataColumn("descripcion", GetType(String)))
                .Add(New DataColumn("precioEquipo", GetType(Double)))
                .Add(New DataColumn("precioIvaEquipo", GetType(Double)))
            End With
            dtDatos.AcceptChanges()
            dtEquipos = dtDatos
            Session("dtEquipos") = dtEquipos
        End If
    End Sub

    Private Function AdicionarEquipo(ByVal material As String, _
                                     ByVal descripcion As String, _
                                     ByVal precioEquipo As Double, precioIvaEquipo As Double) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            With Equipos
                If .Select("material='" & material & "'").Length = 0 Then
                    Dim drEquipo As DataRow = .NewRow()
                    With drEquipo
                        .Item("material") = material
                        .Item("descripcion") = descripcion
                        .Item("precioEquipo") = precioEquipo
                        .Item("precioIvaEquipo") = precioIvaEquipo
                    End With
                    .Rows.Add(drEquipo)
                    .AcceptChanges()
                    resultado.EstablecerMensajeYValor(0, "El material " & material & " fue adicionado satisfactoriamente.")
                Else
                    resultado.EstablecerMensajeYValor(1, "El material " & material & " ya se encuentra adicionadoa la lista.")
                End If
            End With
        Catch ex As Exception
            Throw ex
        End Try
        Return resultado
    End Function

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)

            'La visualización es visible para todos
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

#End Region

End Class