Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web
Imports System.IO
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Comunes

Public Class AdministradorNotificacionesCEM
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administrador Notificaciones CEM")
                End With
                CargarControles()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            linkVer.ClientSideEvents.Click = linkVer.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Try
            Dim Param As String = e.Parameters.ToString
            Select Case Param
                Case "limpiar"
                    Session.Remove("dtDatos")
                    EnlazarDatos(CType(Session("dtDatos"), DataTable))
                Case "expandir"
                    gvDatos.SettingsDetail.AllowOnlyOneMasterRowExpanded = chkSingleExpanded.Checked
                    If gvDatos.SettingsDetail.AllowOnlyOneMasterRowExpanded Then
                        gvDatos.DetailRows.CollapseAllRows()
                    End If
                Case "consultar"
                    ConsultarUsuario()
                Case Else
                    Dim arrAccion As String()
                    arrAccion = e.Parameters.Split(":")
                    Select Case arrAccion(1)
                        Case "informacion"
                            CargarInformacionUsuario(CInt(arrAccion(0)))
                            Session("IdUsuarioNotificacion") = CInt(arrAccion(0))
                        Case "editar"
                            EditarUsuario(arrAccion(0))
                            ConsultarUsuario()
                        Case "eliminar"
                            EliminarUsuario(arrAccion(0))
                            ConsultarUsuario()
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al realizar el proceso: " & ex.Message)
        End Try
        CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcEditar_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEditar.WindowCallback
        Dim arrAccion As String()
        arrAccion = e.Parameter.Split(":")
        Select Case arrAccion(1)
            Case "informacion"
                CargarInformacionUsuario(CInt(arrAccion(0)))
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        gvDatos.DataSource = Session("dtDatos")
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveDatos
                .FileName = "NotificaionesCEM"
                .ReportHeader = "Notificaciones CEM" & vbCrLf & vbCrLf
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

    Protected Sub gvDetalle_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Session("IdUsuarioNotificacion") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetalle(TryCast(sender, ASPxGridView))
        Catch ex As Exception

        End Try
    End Sub

    Private Sub cpFiltroNombre_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltroNombre.Callback
        Dim filtroRapido As String = ""
        If e.Parameter.Length >= 4 Then
            filtroRapido = e.Parameter
            CargarListadoNombre(filtroRapido)
        Else
            lblResultadoNombre.Text = "0 Registro(s) Cargado(s)"
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarControles()

        Try
            '** Cargar tipo de notificación **
            Dim filtro As New FiltroAsuntoNotificacion
            filtro.IdPerfil = Session("usxp009")
            Dim dt As DataTable = AsuntoNotificacion.ObtenerListado(filtro)
            Session("dtAsunto") = dt
            MetodosComunes.CargarComboDX(cmbTipo, dt, "idAsuntoNotificacion", "nombre")

            '** Cargar Bodegas **
            Dim dtBodega As New DataTable
            dtBodega = HerramientasMensajeria.ConsultarBodega()
            MetodosComunes.CargarComboDX(cmbBodega, dtBodega, "idbodega", "bodega")

        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar los controles: " & ex.Message)
        End Try

    End Sub

    Private Sub CargarListadoNombre(ByVal filtro As String)
        If Not String.IsNullOrEmpty(filtro.Trim) Then
            Dim objUsuario As New UsuarioNotificacionCEMColeccion
            Dim dtUsuario As New DataTable
            With objUsuario
                .DestinatarioNotificacion = filtro
                dtUsuario = .GenerarDataTable
            End With
            Dim dt As DataTable = dtUsuario.DefaultView.ToTable(True, "idUsuarioNotificacion", "nombreCompuesto")
            MetodosComunes.CargarComboDX(cmbNombre, dt, "idUsuarioNotificacion", "nombreCompuesto")
        Else
            cmbNombre.Items.Clear()
        End If
        With cmbNombre
            lblResultadoNombre.Text = .Items.Count.ToString & " Registro(s) Cargado(s)"
            If .Items.Count = 1 Then
                .SelectedIndex = 0
            End If
        End With
    End Sub

    Private Sub ConsultarUsuario()
        Dim objUsuario As New UsuarioNotificacionCEMColeccion
        Dim dtDatos As New DataTable
        Dim arrIdEstado As New ArrayList

        With objUsuario
            If cmbTipo.Value > 0 Then .IdAsuntoNotificacion.Add(CStr(cmbTipo.Value))
            If cmbBodega.Value > 0 Then .IdBodega.Add(cmbBodega.Value)
            If cmbNombre.Value > 0 Then .IdUsuarioNotificacion.Add(cmbNombre.Value)
            If Not String.IsNullOrEmpty(txtMail.Text) Then .Email = txtMail.Text
            If dateFechaInicio.Date > Date.MinValue Then .FechaInicio = dateFechaInicio.Date
            If dateFechaFin.Date > Date.MinValue Then .FechaFin = dateFechaFin.Date
            If rblFiltroEstado.Value = 1 Then
                arrIdEstado.Add(1)
            ElseIf rblFiltroEstado.Value = 2 Then
                arrIdEstado.Add(0)
            Else
                arrIdEstado.Add(0)
                arrIdEstado.Add(1)
            End If
            .Estado.AddRange(arrIdEstado)
            dtDatos = .GenerarDataTable()
        End With

        Session("dtDatos") = dtDatos
        EnlazarDatos(dtDatos)

        If dtDatos.Rows.Count = 0 Then
            miEncabezado.showWarning("<i> No se encontraron resultados, según los filtros establecidos. </i>")
        End If

    End Sub

    Private Sub CargarDetalle(gv As ASPxGridView)
        If Session("IdUsuarioNotificacion") IsNot Nothing Then
            Dim dtDetalle As New DataTable
            Dim IdNotificacion As Integer = CLng(Session("IdUsuarioNotificacion"))
            dtDetalle = ObtenerDetalle(IdNotificacion)
            Session("dtDetalle") = dtDetalle
            With gv
                .DataSource = Session("dtDetalle")
            End With
        Else
            miEncabezado.showWarning("No se pudo establecer el identificador de la distribución, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerDetalle(ByVal IdNotificacion As Integer) As DataTable
        Dim dtResultado As New DataTable
        Dim objDetalle As New UsuarioNotificacionCEM
        With objDetalle
            .IdUsuarioNotificacion = IdNotificacion
            dtResultado = .ObtenerBodegasNotificacion
        End With

        Return dtResultado
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        With gvDatos
            .PageIndex = 0
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Private Sub CargarInformacionUsuario(ByVal idUsuarioNotificacion As Integer)
        Dim objInfoUsuario As New UsuarioNotificacionCEM(idUsuarioNotificacion)
        Dim dtBodegaUsuario As New DataTable

        Session("IdUsuarioNotificacion") = idUsuarioNotificacion
        txtEditNombre.Text = objInfoUsuario.Nombres
        txtEditApellido.Text = objInfoUsuario.Apellidos
        txtEditCorreo.Text = objInfoUsuario.Email
        dtBodegaUsuario = ObtenerDetalle(idUsuarioNotificacion)
        If objInfoUsuario.Estado Then
            rblEstado.Items(0).Selected = True
            rblEstado.Items(1).Selected = False
        Else
            rblEstado.Items(0).Selected = False
            rblEstado.Items(1).Selected = True
        End If

        If objInfoUsuario.TipoDestino = 1 Then
            rblDestino.Items(0).Selected = True
            rblDestino.Items(1).Selected = False
        Else
            rblDestino.Items(0).Selected = False
            rblDestino.Items(1).Selected = True
        End If

        If Session("dtAsunto") Is Nothing Then
            CargarControles()
        End If

        MetodosComunes.CargarComboDX(cmbEditTipo, Session("dtAsunto"), "idAsuntoNotificacion", "nombre")
        cmbEditTipo.SelectedIndex = objInfoUsuario.IdTipoNotificacion

        Dim objListBox As ASPxListBox = DirectCast(cmbBodegaCEM.FindControl("lbBodega"), ASPxListBox)
        With objListBox
            Dim dtBodegas As DataTable = HerramientasMensajeria.ConsultarBodega()
            Dim objCantidad As Integer = dtBodegas.Rows.Count

            .Items.Add("(Todos)", 0)
            For Each fila As DataRow In dtBodegas.Rows
                .Items.Add(fila("bodega"), fila("idBodega"))
            Next

        End With

        For Each row As DataRow In dtBodegaUsuario.Rows
            Dim idBodega As String = row("idBodega")
            objListBox.Items.FindByValue(idBodega).Selected = True
        Next

    End Sub

    Private Sub EditarUsuario(ByVal listaBodega As String)
        If Session("IdUsuarioNotificacion") IsNot Nothing Then
            Dim objActualizar As New UsuarioNotificacionCEM
            Dim resultado As New ResultadoProceso
            Dim listaNotificacion As New ArrayList

            Dim flagDominios As Boolean = objActualizar.ValidarDominio(txtEditCorreo.Text.Trim)

            If flagDominios Then

                Dim arrbodega As String() = listaBodega.Split(",")
                Dim listBodega As New ArrayList
                For Each ped As String In arrbodega
                    listBodega.Add(ped)
                Next

                With objActualizar
                    .IdUsuarioNotificacion = CInt(Session("IdUsuarioNotificacion"))
                    .IdUsuarioCreacion = CInt(Session("usxp001"))
                    .Estado = rblEstado.Value
                    .Nombres = txtEditNombre.Text.Trim
                    .Apellidos = txtEditApellido.Text.Trim
                    .Email = txtEditCorreo.Text.Trim
                    .TipoDestino = rblDestino.Value
                    listaNotificacion.Add(cmbEditTipo.Value)
                    resultado = .Actualizar(listaNotificacion, listBodega)
                End With
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            Else
                miEncabezado.showWarning("Dominio de correo invalido, por favor verifique")
            End If
        Else
            miEncabezado.showWarning("No se pude establecer el identificador del usuario, por favor intente nuevamente. ")
        End If
    End Sub

    Private Sub EliminarUsuario(ByVal idUsuarioNotificacion As Integer)
        Dim resultado As New ResultadoProceso
        Dim objUsuario As New UsuarioNotificacionCEM

        Try
            With objUsuario
                .IdUsuarioNotificacion = idUsuarioNotificacion
                resultado = .Eliminar
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al realizar la eliminación: " & ex.Message)
        End Try
    End Sub

#End Region

End Class