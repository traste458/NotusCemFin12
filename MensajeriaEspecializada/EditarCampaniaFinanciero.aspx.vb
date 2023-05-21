Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.WMS
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class EditarCampaniaFinanciero
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _idCampania As Integer

#End Region

#Region "Eventos"

    Private Sub EditarCampaniaFinanciero_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Session("dtServicios") IsNot Nothing Then
            lbServicios.DataSource = Session("dtServicios")
            lbServicios.DataBind()
        End If
        If Session("dtBodega") IsNot Nothing Then
            lbBodegas.DataSource = Session("dtBodega")
            lbBodegas.DataBind()
        End If
        If Session("dtProductos") IsNot Nothing Then
            lbProductoExt.DataSource = Session("dtProductos")
            lbProductoExt.DataBind()
        End If
        If Session("dtDocumentos") IsNot Nothing Then
            lbDocumentos.DataSource = Session("dtDocumentos")
            lbDocumentos.DataBind()
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            If Request.QueryString("idCampania") IsNot Nothing Then Integer.TryParse(Request.QueryString("idCampania").ToString, _idCampania)
            If _idCampania > 0 Then
                With miEncabezado
                    .setTitle("Modificar Campaña Servicio Financiero")
                End With
                Session("idCampania") = _idCampania
                CargaInicial()
            Else
                miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
            End If
        Else
            If Session("idCampania") IsNot Nothing Then _idCampania = Session("idCampania")
        End If
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "Actualizar"
                    resultado = ActualizarCampania()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            Dim objCampania As New Campania(idCampania:=_idCampania)
            With objCampania
                txtNombreCampania.Text = .Nombre
                dateFechaInicio.Value = .FechaInicio
                dateFechaInicio.MinDate = .FechaInicio
                If .FechaFin <> Date.MinValue Then dateFechaFin.Value = .FechaFin
                cbActivo.Checked = .Activo
            End With

            ' Se cargan los tipos de servicio
            With lbServicios
                .DataSource = New TipoServicioColeccion(activo:=True, esFinanciero:=True).GenerarDataTable()
                Session("dtServicios") = .DataSource
                .DataBind()
            End With

            Dim objServicioCampania As New TipoServicioColeccion(activo:=True, idCampania:=_idCampania)
            For Each itemSel As TipoServicio In objServicioCampania
                For Each item As ListEditItem In lbServicios.Items
                    If item.Value = itemSel.IdTipoServicio Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            ' Se cargan las bodegas
            With lbBodegas
                .DataSource = HerramientasMensajeria.ConsultarBodega
                Session("dtBodega") = .DataSource
                .DataBind()
            End With
            Dim objServicioBodega As New BodegaColeccion(idCampania:=_idCampania)
            For Each itemSel As Bodega In objServicioBodega
                For Each item As ListEditItem In lbBodegas.Items
                    If item.Value = itemSel.IdBodega Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            ' Se cargan los productos
            Dim objProducto As New ProductoComercialColeccion
            Dim dtDatos As New DataTable

            With objProducto
                .ListIdClienteExterno.Add(Enumerados.ClienteExterno.DAVIVIENDA)
                .ListIdClienteExterno.Add(Enumerados.ClienteExterno.BANCOLOMBIA)
                dtDatos = .GenerarDataTable
            End With

            With lbProductoExt
                .DataSource = dtDatos
                Session("dtProductos") = .DataSource
                .DataBind()
            End With
            Dim objServicioProducto As New ProductoComercialColeccion(idCampania:=_idCampania)
            For Each itemSel As ProductoComercial In objServicioProducto
                For Each item As ListEditItem In lbProductoExt.Items
                    If item.Value = itemSel.IdProductoComercial Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Se cargan los documentos (Productos Financieros)
            With lbDocumentos
                .DataSource = New ProductoDocumentoFinancieroColeccion().GenerarDataTable
                Session("dtDocumentos") = .DataSource
                .DataBind()
            End With
            Dim objServicioDocumento As New ProductoDocumentoFinancieroColeccion(idCampania:=_idCampania)
            For Each itemSel As ProductoDocumentoFinanciero In objServicioDocumento
                For Each item As ListEditItem In lbDocumentos.Items
                    If item.Value = itemSel.IdProducto Then
                        item.Selected = True
                        Exit For
                    End If
                Next
            Next

            'Carga los tipos de cliente
            Session("dtCliente") = Comunes.ClienteExterno.ObtenerListado()
            MetodosComunes.CargarComboDX(cmbCl, CType(Session("dtCliente"), DataTable), "idClienteExterno", "nombre")
            cmbCl.Value = objCampania.IdClienteExterno

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Function ActualizarCampania() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miCampania As New CampaniaFinanciero
        With miCampania
            .IdCampania = _idCampania
            .Nombre = txtNombreCampania.Text.Trim()
            .FechaInicio = dateFechaInicio.Date
            If dateFechaFin.Date <> Date.MinValue Then .FechaFin = dateFechaFin.Date
            .Activo = cbActivo.Checked
            If lbServicios.SelectedValues.Count > 0 Then
                .ListTiposDeServicio = New List(Of Integer)
                For servicio As Integer = 0 To lbServicios.SelectedValues.Count - 1
                    .ListTiposDeServicio.Add(lbServicios.SelectedValues(servicio))
                Next
            End If
            If lbBodegas.SelectedValues.Count > 0 Then
                .ListBodegas = New List(Of Integer)
                For bodega As Integer = 0 To lbBodegas.SelectedValues.Count - 1
                    .ListBodegas.Add(lbBodegas.SelectedValues(bodega))
                Next
            End If
            If lbProductoExt.SelectedValues.Count > 0 Then
                .ListProductoExterno = New List(Of Integer)
                For prod As Integer = 0 To lbProductoExt.SelectedValues.Count - 1
                    .ListProductoExterno.Add(lbProductoExt.SelectedValues(prod))
                Next
            End If
            If lbDocumentos.SelectedValues.Count > 0 Then
                .ListDocumentoFinanciero = New List(Of Integer)
                For doc As Integer = 0 To lbDocumentos.SelectedValues.Count - 1
                    .ListDocumentoFinanciero.Add(lbDocumentos.SelectedValues(doc))
                Next
            End If
            resultado = .ActualizarFinanciero()
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        End With
        Return resultado
    End Function

#End Region

End Class