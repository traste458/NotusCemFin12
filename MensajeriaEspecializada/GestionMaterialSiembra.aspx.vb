Imports GemBox
Imports GemBox.Spreadsheet
Imports DevExpress.Web
Imports System.IO
Imports ILSBusinessLayer

Public Class GestionMaterialSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private oExcel As ExcelFile

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack And Not IsCallback Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Gestión de Materiales Siembra")
            End With
        Else
            If Session("oExcel") IsNot Nothing Then oExcel = DirectCast(Session("oExcel"), ExcelFile)
        End If
        MetodosComunes.setGemBoxLicense()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            'Link Eliminar
            With lnkEliminar
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub ucCargueArchivoEquipos_FileUploadComplete(sender As Object, e As DevExpress.Web.FileUploadCompleteEventArgs) Handles ucCargueArchivoEquipos.FileUploadComplete
        Dim respuesta As ResultadoProceso
        Try
            If ucCargueArchivoEquipos.UploadedFiles.Length > 0 Then
                Dim fileExtension As String = Path.GetExtension(ucCargueArchivoEquipos.UploadedFiles(0).FileName)
                oExcel = New ExcelFile()
                If fileExtension.ToUpper = ".XLS" Then
                    oExcel.LoadXls(ucCargueArchivoEquipos.UploadedFiles(0).FileContent)
                ElseIf fileExtension.ToUpper = ".XLSX" Then
                    oExcel.LoadXlsx(ucCargueArchivoEquipos.UploadedFiles(0).FileContent, XlsxOptions.None)
                End If

                Dim objMaterialSiembra As New MaterialSiembra()
                With objMaterialSiembra
                    .Excel = oExcel
                    respuesta = .Registrar()
                End With
                If objMaterialSiembra.EstructuraTablaErrores.Rows.Count > 0 Then
                    CargarErrores(objMaterialSiembra.EstructuraTablaErrores)
                    CType(sender, ASPxUploadControl).JSProperties("cpMensajeError") = miEncabezado.RenderHtml()
                End If

                If respuesta.Valor = 0 Then
                    miEncabezado.showSuccess(respuesta.Mensaje)
                    e.CallbackData = e.UploadedFile.FileName
                Else
                    miEncabezado.showWarning(respuesta.Mensaje)
                    CType(sender, ASPxUploadControl).JSProperties("cpMensajeError") = respuesta.Valor
                End If
                CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
            CType(sender, ASPxUploadControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Private Sub gvLog_DataBinding(sender As Object, e As System.EventArgs) Handles gvLog.DataBinding
        If Session("dtErrores") IsNot Nothing Then gvLog.DataSource = Session("dtErrores")
    End Sub

    Private Sub gvResultado_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvResultado.CustomCallback
        Dim respuesta As New ResultadoProceso
        Try
            Dim arrParametro() As String = e.Parameters.Split("|")
            Select Case arrParametro(0)
                Case "consulta"
                    ConsultarMateriales()

                Case "eliminar"
                    Dim objMaterialSiembra As New MaterialSiembra(CInt(arrParametro(1)))

                    respuesta = objMaterialSiembra.Eliminar()
                    If respuesta.Valor = 0 Then
                        miEncabezado.showSuccess(respuesta.Mensaje)
                        ConsultarMateriales()
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If

                Case "adicionar"
                    Dim objMaterialSiembra As New MaterialSiembra(arrParametro(1))

                    respuesta = objMaterialSiembra.Registrar()
                    If respuesta.Valor = 0 Then
                        miEncabezado.showSuccess(respuesta.Mensaje)
                        ConsultarMateriales()
                        If objMaterialSiembra.EstructuraTablaErrores.Rows.Count > 0 Then
                            CargarErrores(objMaterialSiembra.EstructuraTablaErrores)
                            CType(sender, ASPxGridView).JSProperties("cpMensajeError") = miEncabezado.RenderHtml()
                        End If
                    Else
                        miEncabezado.showWarning(respuesta.Mensaje)
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar procesar el archivo: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvResultado_DataBinding(sender As Object, e As System.EventArgs) Handles gvResultado.DataBinding
        If Session("objMaterialSiembra") IsNot Nothing Then gvResultado.DataSource = Session("objMaterialSiembra")
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

#End Region

#Region "Métodos Privados"

    Public Sub ConsultarMateriales()
        Dim objMaterialSiembra As New MaterialSiembraColeccion()
        With objMaterialSiembra
            .Material = txtFiltroMaterial.Text
            .Referencia = txtFiltroReferencia.Text
            .CargarDatos()
        End With

        With gvResultado
            .DataSource = objMaterialSiembra
            Session("objMaterialSiembra") = objMaterialSiembra
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

    Private Sub CargarErrores(dtDatos As DataTable)
        With gvLog
            .DataSource = dtDatos
            Session("dtErrores") = .DataSource
            .DataBind()
        End With
    End Sub

#End Region

End Class
