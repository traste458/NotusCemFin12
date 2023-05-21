Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports DevExpress.Web
Imports System.Linq
Public Class AdministracionTipoSimMaterial
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        Try
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle(":: Administración de Materiales Clase Sims  ::")
                End With
            End If
            If pcEditar.IsCallback Then
                CargarClasesSIM()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)
            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            Dim lnkMdifica As ASPxHyperLink = templateContainer.FindControl("lnkEditar")
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvMatrialClaseSim_DataBinding(sender As Object, e As System.EventArgs) Handles gvMatrialClaseSim.DataBinding
        If Session("dtDatosMaterial") IsNot Nothing Then gvMatrialClaseSim.DataSource = Session("dtDatosMaterial")
    End Sub
    Protected Sub cmbEquipo_OnItemsRequestedByFilterCondition_SQL(source As Object, e As ListEditItemsRequestedByFilterConditionEventArgs)
        Dim dtmateriales As New DataTable
        Dim objMateriales As New AdministracionMaterialClaseSim()
        dtmateriales = objMateriales.CargarMaterialesComboTipomaterial(e.Filter, e.BeginIndex + 1, e.EndIndex + 1)
        Session("dtmateriales") = dtmateriales
        With cmbEquipo
            .DataSource = dtmateriales
            .DataBind()
        End With
        With cmbEquipo
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedIndex = -1
            End If
        End With

    End Sub
    Protected Sub cmbEquipo_OnItemRequestedByValue_SQL(source As Object, e As ListEditItemRequestedByValueEventArgs)
        If e.Value = Nothing Then
            Return
        End If
        If Session("dtmateriales") IsNot Nothing Then
            Dim data As DataTable = Session("dtmateriales")
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
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            Else
                .SelectedIndex = -1
            End If
        End With

    End Sub
    Protected Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        Try
            Dim dtmaterialCalseSim As New DataTable
            Dim objMateriales As New AdministracionMaterialClaseSim()
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "ConsultarClaseSim"
                    With objMateriales
                        .Material = cmbEquipo.Value
                        .IdUsuario = CInt(Session("usxp001"))
                        dtmaterialCalseSim = .ConsultarClaseSimMaterial()
                        Session("dtDatosMaterial") = dtmaterialCalseSim
                        With gvMatrialClaseSim
                            .DataSource = dtmaterialCalseSim
                            .DataBind()
                        End With
                    End With
                Case "verInfoClaseSimCard"
                    txCodMateri.Text = cmbEquipo.Value
                    txMateri.Text = cmbEquipo.Text
                    pcEditar.Width = 400
                    pcEditar.Height = 200
                    pcEditar.ShowOnPageLoad = True
                    CargarClasesSIM()
                Case "ActualizaClaseSim"
                    Dim resultado As New ResultadoProceso
                    With objMateriales
                        .Material = cmbEquipo.Value
                        .IdUsuario = CInt(Session("usxp001"))
                        .IdClase = cmClaseSimCard.Value
                        resultado = .RegistrarClasesSIM()
                    End With
                    If resultado.Valor = 0 Then
                        miEncabezado.showSuccess(resultado.Mensaje)
                    Else
                        miEncabezado.showError(resultado.Mensaje)
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub
    Protected Sub cmClaseSimCard_DataBinding(sender As Object, e As EventArgs) Handles cmClaseSimCard.DataBinding
        If Session("dtclasesim") IsNot Nothing Then cmClaseSimCard.DataSource = Session("dtclasesim")
    End Sub
#End Region

#Region "Métodos Privados"
    Public Function CopyToDataTableOverride(Of T As DataRow)(ByVal Source As EnumerableRowCollection(Of T)) As DataTable
        If Source.Count = 0 Then
            Return New DataTable
        Else
            Return DataTableExtensions.CopyToDataTable(Of DataRow)(Source)
        End If
    End Function
    Private Sub CargarClasesSIM()
        'Clases de SIMs 
        Dim dtclasesim As New DataTable
        Dim objMateriales As New AdministracionMaterialClaseSim()
        dtclasesim = objMateriales.ObtieneClasesSIM
        Session("dtclasesim") = dtclasesim
        With cmClaseSimCard
            .DataSource = dtclasesim
            .DataBind()
        End With
    End Sub
#End Region

    

    
End Class