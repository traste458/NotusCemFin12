Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports DevExpress.Web

Public Class AdministracionCampaniaFinanciero
    Inherits System.Web.UI.Page

#Region "Eventos"

    Private Sub AdministracionCampaniaFinanciero_Init(sender As Object, e As System.EventArgs) Handles Me.Init

        If Session("dtServicios") IsNot Nothing Then
            lbServicios.DataSource = Session("dtServicios")
            lbServicios.DataBind()
            MetodosComunes.CargarComboDX(cmbTipoServicio, CType(Session("dtServicios"), DataTable), "idTipoServicio", "nombre")
        End If
        If Session("dtBodegas") IsNot Nothing Then
            lbBodegas.DataSource = Session("dtBodegas")
            lbBodegas.DataBind()
            MetodosComunes.CargarComboDX(cmbCiudad, CType(Session("dtCiudades"), DataTable), "idCiudad", "Ciudad")
        End If
        If Session("dtProductos") IsNot Nothing Then
            lbProductoExt.DataSource = Session("dtProductos")
            lbProductoExt.DataBind()
        End If
        If Session("dtDocumentos") IsNot Nothing Then
            lbDocumentos.DataSource = Session("dtDocumentos")
            lbDocumentos.DataBind()
        End If
        If Session("dtCliente") IsNot Nothing Then
            MetodosComunes.CargarComboDX(cmbCliente, CType(Session("dtCliente"), DataTable), "idClienteExterno", "nombre")
            MetodosComunes.CargarComboDX(cmbCl, CType(Session("dtCliente"), DataTable), "idClienteExterno", "nombre")
        End If
        dateFechaInicio.MinDate = Now
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        Try
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración de Campañas Financiero")
                End With
                CargaInicial()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "Registrar"
                    resultado = RegistrarCampania()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSistemaOrigen As Integer
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idSistemaOrigen = CInt(gvCampanias.GetRowValuesByKeyValue(templateContainer.KeyValue, "IdSistema"))
            Dim lnkMdifica As ASPxHyperLink = templateContainer.FindControl("lnkEditar")
            If idSistemaOrigen = Enumerados.SistemaOrigen.NotusIls Then
                lnkMdifica.Visible = True
            Else
                lnkMdifica.Visible = False
            End If
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvCampanias_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvCampanias.CustomCallback
        BuscarCampanias()
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvCampanias_DataBinding(sender As Object, e As System.EventArgs) Handles gvCampanias.DataBinding
        gvCampanias.DataSource = Session("dtDatosCampanias")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            ' Se cargan los tipos de servicio
            With lbServicios
                .DataSource = New TipoServicioColeccion(activo:=True, esFinanciero:=True).GenerarDataTable()
                Session("dtServicios") = .DataSource
                .DataBind()
            End With

            ' Se cargan las bodegas
            With lbBodegas
                .DataSource = HerramientasMensajeria.ConsultarBodega()
                Session("dtBodegas") = .DataSource
                .DataBind()
            End With

            ' Se cargarn las ciudaddes
            Session("dtCiudades") = HerramientasMensajeria.ObtenerCiudadesCem

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

            'Se cargan los documentos (Productos Financieros)
            With lbDocumentos
                .DataSource = New ProductoDocumentoFinancieroColeccion().GenerarDataTable
                Session("dtDocumentos") = .DataSource
                .DataBind()
            End With

            ' Carga Bodegas
            MetodosComunes.CargarComboDX(cmbCiudad, CType(Session("dtCiudades"), DataTable), "idCiudad", "Ciudad")
            'Carga los tipos de servicio
            MetodosComunes.CargarComboDX(cmbTipoServicio, CType(Session("dtServicios"), DataTable), "idTipoServicio", "nombre")
            'Carga los tipos de servicio
            MetodosComunes.CargarComboDX(cmbTipoServicio, CType(Session("dtServicios"), DataTable), "idTipoServicio", "nombre")
            'Carga los tipos de cliente
            Session("dtCliente") = Comunes.ClienteExterno.ObtenerListado()
            MetodosComunes.CargarComboDX(cmbCliente, CType(Session("dtCliente"), DataTable), "idClienteExterno", "nombre")
            MetodosComunes.CargarComboDX(cmbCl, CType(Session("dtCliente"), DataTable), "idClienteExterno", "nombre")

        Catch ex As Exception
            miEncabezado.showError("No fué posible realizar la carga inicial: " & ex.Message)
        End Try
    End Sub

    Private Function RegistrarCampania() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miCampania As New CampaniaFinanciero

        With miCampania
            .Nombre = txtNombreCampania.Text.Trim()
            .FechaInicio = dateFechaInicio.Date
            If dateFechaFin.Date <> Date.MinValue Then .FechaFin = dateFechaFin.Date
            .Activo = True
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
            .IdClienteExterno = CInt(cmbCl.Value)
            .IdSistema = 1
            resultado = .RegistrarFinanciero()
            If resultado.Valor = 0 Then
                resultado = .Sincronizacion()
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)
                Else
                    miEncabezado.showWarning("Se creo la campaña exitosamente pero no se pudo sincronizar con NotusExpress")
                End If
                'miEncabezado.showSuccess(resultado.Mensaje)
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        End With
        Return resultado
    End Function

    Private Sub BuscarCampanias()
        Try
            Dim objCampanias As New CampaniaColeccion()
            With objCampanias
                If Not String.IsNullOrEmpty(txtFiltroCampania.Text.Trim) Then .NombreCampania = txtFiltroCampania.Text.Trim
                If rblEstado.Value = 1 Then
                    .Activo = True
                Else
                    .Activo = False
                End If
                If cmbCliente.Value > 0 Then .IdClienteExterno = cmbCliente.Value
                If cmbTipoServicio.Value > 0 Then .ListaTipoServicio.Add(cmbTipoServicio.Value)
                If cmbCiudad.Value > 0 Then .ListaIdCiudad.Add(cmbCiudad.Value)
            End With

            With gvCampanias
                .DataSource = objCampanias.GenerarDataTable()
                Session("dtDatosCampanias") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar realizar la búsqueda: " & ex.Message)
        End Try
    End Sub

#End Region

End Class