Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class AdministracionUnidadNegocio
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración Unidades de Negocio")
                    CargarUnidadesNegocio()
                    EliminarTransitorios()
                End With
            End If
            If gluPerfiles.IsCallback OrElse gluPerfiles.GridView.IsCallback OrElse Not Me.IsPostBack Then CargarPerfiles()
        Catch ex As Exception
            miEncabezado.showError("Se presentó un error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

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

    Protected Sub Link_InitRegistro(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)

            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "adcionar"
                    resultado = AdicionarServicio()
                    txtNombre.Focus()
                Case "eliminarTipoServicio"
                    resultado = EliminarTipoServicio(arrayAccion(1))
                    If resultado.Valor = 0 Then
                        gvDatos.CollapseAll()
                    End If
                Case "adcionarTipoServicio"
                    resultado = AgregarTipoServicio(arrayAccion(1), arrayAccion(2))
                    If resultado.Valor = 0 Then
                        gvDatos.CollapseAll()
                    End If
                Case "adcionarPerfil"
                    resultado = AgregarPerfiles(arrayAccion(1), arrayAccion(2))
                    If resultado.Valor = 0 Then
                        gvDatos.CollapseAll()
                    End If
                Case "eliminarTemporal"
                    resultado = EliminarTemporal(arrayAccion(1))
                    If resultado.Valor = 0 Then
                        gvRegistro.CollapseAll()
                    End If
                Case "crearUnidad"
                    resultado = CrearUnidad()
                    If resultado.Valor = 0 Then
                        CargarUnidadesNegocio()
                        gvRegistro.CollapseAll()
                    End If
                Case "eliminarTransitoria"
                    EliminarTransitorios()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcTipoServicio_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcTipoServicio.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "tipoServicio"
                    resultado = CargarTipoServicioDisponible()
                    lblIdUnidad.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcPerfiles_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcPerfiles.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "perfiles"
                    resultado = CargarPerfiles(arrayAccion(1))
                    lbIdTipo.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcCrear_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcCrear.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "crear"
                    resultado = CargarTipoServicioDisponible()
                    resultado = CargarPerfiles()
                    txtNombre.Text = ""
                    Session.Remove("dtTipoServicioTemporal")
                    cmbTipoServicio.Text = ""
                    gluPerfiles.Text = ""
                    With gvRegistro
                        .DataSource = Session("dtTipoServicioTemporal")
                        .DataBind()
                    End With
                    txtNombre.Focus()
                    EliminarTransitorios()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("IdUnidadNegocio") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetalle(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar el detalle de la Instrucción. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvPerfiles_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("IdTipoServicio") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetallePerfil(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar el detalle de la Instrucción. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvPerfilesDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("IdRegistro") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetallePerfilTemporal(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar el detalle de la Instrucción. " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    End Sub

    Private Sub lbPerfiles_DataBinding(sender As Object, e As EventArgs) Handles lbPerfiles.DataBinding
        If Session("dtPerfil") IsNot Nothing Then lbPerfiles.DataSource = Session("dtPerfil")
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveDatos
                .FileName = "Administración Unidades de Negocio"
                .ReportHeader = "Administración Unidades de Negocio" & vbCrLf & vbCrLf
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

    Private Sub CargarUnidadesNegocio()
        Dim miDataTable As New DataTable
        Dim objUnidad As New UnidadNegocioColeccion

        With objUnidad
            .IdTipoUnidadNegocio = Enumerados.TipoUnidadNegocio.Externa
            miDataTable = .GenerarDataTable()
        End With
        Session("dtDatos") = miDataTable
        With gvDatos
            .DataSource = miDataTable
            .DataBind()
        End With
    End Sub

    Private Sub CargarDetalle(gv As ASPxGridView)
        If Session("IdUnidadNegocio") IsNot Nothing Then
            Dim dtDetalle As New DataTable
            Dim IdUnidadNegocio As Integer = CInt(Session("IdUnidadNegocio"))
            dtDetalle = ObtenerDetalle(IdUnidadNegocio)
            Session("dtDetalle") = dtDetalle
            With gv
                .DataSource = Session("dtDetalle")
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerDetalle(ByVal idUnidadNegocio As Integer) As DataTable
        Dim miDataTable As New DataTable
        Dim objTipoServicio As New TipoServicioUnidadNegocioColeccion
        With objTipoServicio
            .ListIdUnidadNegocio.Add(idUnidadNegocio)
            miDataTable = .GenerarDataTable()
        End With
        Return miDataTable
    End Function

    Private Sub CargarDetallePerfil(gv As ASPxGridView)
        If Session("idTipoServicio") IsNot Nothing Then
            Dim dtDetalle As New DataTable
            Dim IdTipoServicio As Integer = CInt(Session("idTipoServicio"))
            dtDetalle = ObtenerDetallePerfil(IdTipoServicio)
            Session("dtDetalle") = dtDetalle
            With gv
                .DataSource = Session("dtDetalle")
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerDetallePerfil(ByVal idTipoServicio As Integer) As DataTable
        Dim miDataTable As New DataTable
        Dim objTipoServicio As New PerfilTipoServicioUnidadNegocioColeccion
        With objTipoServicio
            .ListIdTipoServicioNegocio.Add(idTipoServicio)
            miDataTable = .GenerarDataTable()
        End With
        Return miDataTable
    End Function

    Private Sub CargarDetallePerfilTemporal(gv As ASPxGridView)
        If Session("IdRegistro") IsNot Nothing Then
            Dim dtDetalle As New DataTable
            Dim IdRegistro As Integer = CInt(Session("IdRegistro"))
            dtDetalle = ObtenerDetallePerfilTemporal(IdRegistro)
            Session("dtDetalleTemporal") = dtDetalle
            With gv
                .DataSource = Session("dtDetalleTemporal")
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerDetallePerfilTemporal(ByVal IdRegistro As Integer) As DataTable
        Dim miDataTable As New DataTable
        Dim objTipoServicio As New TransitoriaPerfilTipoServicioUnidadNegocioColeccion
        With objTipoServicio
            .IdRegistro.Add(IdRegistro)
            miDataTable = .GenerarDataTable()
        End With
        Return miDataTable
    End Function

    Private Function CargarTipoServicioDisponible() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miDataTable As DataTable = HerramientasMensajeria.ConsultarTipoServicioDisponible()

        With cmbTipoServicio
            .DataSource = miDataTable
            .DataBind()
        End With
        Session("dtTipoServicioDisponible") = miDataTable
        With lbTipoServicio
            .DataSource = miDataTable
            .DataBind()
        End With
        lbTipoServicio.SelectedIndex = -1
        Return resultado
    End Function

    Private Function CargarPerfiles(Optional ByVal idTipoServicioNegocio As Integer = 0) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim miDataTable As New DataTable
        Dim objPerfilUnidad As New PerfilUnidadNegocioColeccion
        Dim objTipoSevicio As New TipoServicioUnidadNegocio(idTipoServicioNegocio:=idTipoServicioNegocio)
        Dim idUnidadNegocio As Integer = objTipoSevicio.IdUnidadNegocio

        With objPerfilUnidad
            If idTipoServicioNegocio > 0 Then
                .ListIdUnidadNegocio.Add(idUnidadNegocio)
            Else
                .ListIdUnidadNegocio.Add(5)
            End If
            miDataTable = .GenerarDataTable()
        End With
        Session("dtPerfil") = miDataTable
        CargarListas(miDataTable, idTipoServicioNegocio)
        Return resultado
    End Function

    Private Function AdicionarServicio() As ResultadoProceso
        Dim miDataTable As New DataTable
        Dim resultado As New ResultadoProceso
        Dim objTransitoriaTipoServicioUnidadNegocio As New TransitoriaTipoServicioUnidadNegocio
        Dim idRegistro As Integer

        With objTransitoriaTipoServicioUnidadNegocio
            .IdUsuario = CInt(Session("usxp001"))
            .IdTipoServicio = CInt(cmbTipoServicio.Value)
            Dim listaDoc As List(Of Object) = gluPerfiles.GridView().GetSelectedFieldValues("IdPerfil")
            For Each id As Integer In listaDoc
                .ListIdPerfil.Add(id)
            Next
            resultado = .Crear()
        End With

        If resultado.Valor = 0 Then
            Dim miregistro As New TransitoriaTipoServicioUnidadNegocioColeccion
            With miregistro
                .ListIdUsuario.Add(CInt(Session("usxp001")))
                miDataTable = .GenerarDataTable()
                Session("dtTipoServicioTemporal") = miDataTable
            End With
            With gvRegistro
                .DataSource = miDataTable
                .DataBind()
            End With
            lnkCrea.ClientVisible = True
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        CargarTipoServicioDisponible()
    End Function

    Private Sub CargarListas(ByVal miDataTable As DataTable, ByVal idTipoServicioNegocio As Integer)
        With gluPerfiles
            .DataSource = miDataTable
            .DataBind()
        End With

        With lbPerfiles
            .DataSource = miDataTable
            .DataBind()
        End With

        Dim objPefilesTipoServicio As New PerfilTipoServicioUnidadNegocioColeccion(idTipoServicioNegocio)
        For Each itemSel As PerfilTipoServicioUnidadNegocio In objPefilesTipoServicio
            For Each item As ListEditItem In lbPerfiles.Items
                If item.Value = itemSel.IdPerfil Then
                    item.Selected = True
                    Exit For
                End If
            Next
        Next

    End Sub

    Private Function EliminarTipoServicio(ByVal idTipoServicioNegocio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objTipoServicioNegocio As New TipoServicioUnidadNegocio
        With objTipoServicioNegocio
            .IdTipoServicioNegocio = idTipoServicioNegocio
            resultado = .Eliminar(idUsuario:=CInt(Session("usxp001")))
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Public Function AgregarTipoServicio(ByVal idUnidadNegocio As Integer, ByVal list As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objTipoServicio As New TipoServicioUnidadNegocio
        Dim arrayAccion As String()
        arrayAccion = list.Split(",")
        With objTipoServicio
            .IdUnidadNegocio = idUnidadNegocio
            For id As Integer = 0 To arrayAccion.Length - 1
                .ListIdTipoServicio.Add(arrayAccion(id).ToString)
            Next
            resultado = .Crear()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function AgregarPerfiles(ByVal idTipoServicioNegocio As Integer, list As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPerfil As New PerfilTipoServicioUnidadNegocio
        Dim arrayAccion As String()
        arrayAccion = list.Split(",")
        With objPerfil
            .IdTipoServicioNegocio = idTipoServicioNegocio
            For id As Integer = 0 To arrayAccion.Length - 1
                .ListIdPerfil.Add(arrayAccion(id).ToString)
            Next
            resultado = .Registrar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function EliminarTemporal(ByVal idRegistro As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objTransitoriaTipoServicioUnidadNegocio As New TransitoriaTipoServicioUnidadNegocio
        With objTransitoriaTipoServicioUnidadNegocio
            .IdRegistro = idRegistro
            .IdUsuario = CInt(Session("usxp001"))
            resultado = .Eliminar()
        End With
        If resultado.Valor <> 0 Then
            miEncabezado.showError(resultado.Mensaje)
        End If
        CargarTipoServicioDisponible()
        Return resultado
    End Function

    Private Function CrearUnidad() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objUnidad As New UnidadNegocio
        With objUnidad
            .IdClienteExterno = Enumerados.ClienteExterno.COMCEL
            .Nombre = txtNombre.Text.Trim
            .IdTipoUnidadNegocio = Enumerados.TipoUnidadNegocio.Externa
            resultado = .Registrar(CInt(Session("usxp001")))
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Sub EliminarTransitorios()
        HerramientasMensajeria.EliminarUnidadNegocioTransitoria(CInt(Session("usxp001")))
    End Sub

#End Region

End Class