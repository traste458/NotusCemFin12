Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.WMS
Imports ILSBusinessLayer.Comunes
Imports DevExpress.Web
Imports ILSBusinessLayer.Localizacion

Public Class AdministracionBodegas
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración Bodegas")
                    CargarBodegas()
                End With
            End If
            If cmbCiudad.IsCallback Then
                CargarTipoServicio()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "crear"
                    resultado = CrearBodega()
                Case "editar"
                    resultado = EditarBodega(arrayAccion(1))
                Case "adcionarUsuario"
                    resultado = AgregarUsuario(arrayAccion(1), arrayAccion(2))
                    If resultado.Valor = 0 Then
                        gvDatos.CollapseAll()
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            If resultado.Valor = 0 Then
                CargarBodegas()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)

            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_InitDetalle(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)

            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("IdAlmacenBodega") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetalle(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar el detalle de la Instrucción. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    End Sub

    Private Sub pcEditar_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEditar.WindowCallback
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "verInfoBodega"
                    CargarInformacionBodega(arrayAccion(1))
                Case "crear"
                    LimpiarCamposBodega()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcUsuarios_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcUsuarios.WindowCallback
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "verUsuarios"
                    Dim objAlmacenBodega As New AlmacenBodega(idAlmacenBodega:=CInt(Session("idAlmacenBodega")))
                    CargarInformacionUsuario(arrayAccion(1), objAlmacenBodega.IdBodega)
                    lbIdTipo.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveDatos
                .FileName = "Administración Bodegas"
                .ReportHeader = "Administración Bodegas" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            gvDatos.SettingsDetail.ExportMode = GridViewDetailExportMode.Expanded

            Select Case formato
                Case "xls"
                    gveDatos.WriteXlsToResponse()
                Case "pdf"
                    With gveDatos
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveDatos.WriteXlsxToResponse()
                Case "csv"
                    gveDatos.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarBodegas()
        Dim objBodega As New AlmacenBodegaColeccion
        With objBodega
            '.Estado = True
            .EsClienteCEM = False
            .IdTipoBodega = Enumerados.TipoBodega.SateliteSecundaria
        End With
        With gvDatos
            .DataSource = objBodega.GenerarDataTable()
            Session("dtDatos") = .DataSource
            .DataBind()
        End With


    End Sub

    Private Sub CargarInformacionBodega(ByVal idAlmacenBodega As Integer)
        CargarTipoServicio()
        Session("idAlmacenBodega") = idAlmacenBodega
        Dim objAlmacenBodega As New AlmacenBodega(idAlmacenBodega:=idAlmacenBodega)
        With objAlmacenBodega
            If .Registrado Then
                txtEditNombre.Text = .Bodega
                txtEditCentro.Text = .Centro
                txtEditAlmacen.Text = .Almacen
                cbEditActivo.Checked = .Activo
                cmbEditUnidadNegocio.Value = .IdUnidadNegocio
                cmbCiudad.Value = .IdCiudad
            End If
        End With
    End Sub

    Private Sub LimpiarCamposBodega()
        CargarTipoServicio()
        txtEditNombre.Text = ""
        txtEditCentro.Text = ""
        txtEditAlmacen.Text = ""
        cbEditActivo.Checked = True
        cmbEditUnidadNegocio.SelectedIndex = -1
        cmbCiudad.SelectedIndex = -1
    End Sub

    Private Sub CargarTipoServicio()
        ' *** Se carga la información de las unidades de negocio
        If Session("UnidadNegocio") Is Nothing Then
            Dim objUnidadNegocio As New UnidadNegocioColeccion
            With objUnidadNegocio
                .Activo = True
                .IdTipoUnidadNegocio = Enumerados.TipoUnidadNegocio.Externa
                Session("UnidadNegocio") = .GenerarDataTable
            End With
        End If
        MetodosComunes.CargarComboDX(cmbEditUnidadNegocio, CType(Session("UnidadNegocio"), DataTable), "IdUnidadNegocio", "Nombre")

        '*** Cargar Ciudades ***
        If Session("dtCiudad") Is Nothing Then
            Session("dtCiudad") = Ciudad.ObtenerCiudadesPorPais
        End If
        MetodosComunes.CargarComboDX(cmbCiudad, CType(Session("dtCiudad"), DataTable), "idCiudad", "nombre")

    End Sub

    Private Function CrearBodega() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objAlmacenBodega As New AlmacenBodega
        With objAlmacenBodega
            .Descripcion = txtEditNombre.Text.Trim
            .Centro = txtEditCentro.Text.Trim
            .Almacen = txtEditAlmacen.Text.Trim
            .Activo = cbEditActivo.Checked
            .IdCiudad = cmbCiudad.Value
            .IdClienteExterno = Enumerados.ClienteExterno.COMCEL
            .IdUnidadNegocio = cmbEditUnidadNegocio.Value
            .IdTipoBodega = Enumerados.TipoBodega.SateliteSecundaria
            resultado = .Registrar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function EditarBodega(ByVal idAlmacenBodega As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objAlmacenBodega As New AlmacenBodega(idAlmacenBodega:=idAlmacenBodega)
        With objAlmacenBodega
            .IdAlmacenBodega = idAlmacenBodega
            .IdUsuario = CInt(Session("usxp001"))
            .Descripcion = txtEditNombre.Text.Trim
            .Centro = txtEditCentro.Text.Trim
            .Almacen = txtEditAlmacen.Text.Trim
            .Activo = cbEditActivo.Checked
            .IdCiudad = cmbCiudad.Value
            .IdBodega = .IdBodega
            resultado = .Actualizar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Sub CargarDetalle(gv As ASPxGridView)
        If Session("IdAlmacenBodega") IsNot Nothing Then
            Dim dtDetalle As New DataTable
            Dim objALmacen As New AlmacenBodega(idAlmacenBodega:=CInt(Session("IdAlmacenBodega")))
            Dim IdBodega As Integer = objALmacen.IdBodega
            dtDetalle = ObtenerDetalle(IdBodega)
            Session("dtDetalle") = dtDetalle
            With gv
                .DataSource = Session("dtDetalle")
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerDetalle(ByVal idBodega As Integer) As DataTable
        Dim miDataTable As New DataTable
        Dim objPerfiles As New PerfilTipoServicioBodegaColeccion
        With objPerfiles
            .IdBodega = idBodega
            miDataTable = .GenerarDataTable()
        End With
        Return miDataTable
    End Function

    Private Sub CargarInformacionUsuario(ByVal idPerfil As Integer, Optional ByVal idBodega As Integer = 0)
        Dim objTercero As New TerceroColeccion
        Dim miDataTable As New DataTable
        With objTercero
            .Listaidperfil.Add(idPerfil)
            miDataTable = .GenerarDataTable()
        End With
        Session("dtPerfil") = miDataTable
        CargarListas(miDataTable, idBodega)
    End Sub

    Private Sub CargarListas(ByVal miDataTable As DataTable, ByVal idBodega As Integer)
        With lbUsuarios
            .DataSource = miDataTable
            .DataBind()
        End With

        Dim objUsuario As New UsuarioBodegaColeccion(idBodega)
        For Each itemSel As UsuarioBodega In objUsuario
            For Each item As ListEditItem In lbUsuarios.Items
                If item.Value = itemSel.IdUsuario Then
                    item.Selected = True
                    Exit For
                End If
            Next
        Next

    End Sub

    Private Function AgregarUsuario(ByVal idPerfil As Integer, list As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objUsuario As New UsuarioBodega
        Dim arrayAccion As String()
        arrayAccion = list.Split(",")
        If Session("IdAlmacenBodega") IsNot Nothing Then
            Dim objALmacen As New AlmacenBodega(idAlmacenBodega:=CInt(Session("IdAlmacenBodega")))
            With objUsuario
                .IdBodega = objALmacen.IdBodega
                .IdPerfil = idPerfil
                For id As Integer = 0 To arrayAccion.Length - 1
                    .ListIdUsuario.Add(arrayAccion(id).ToString)
                Next
                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        End If

        Return resultado
    End Function

#End Region

End Class