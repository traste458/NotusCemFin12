Imports System.Security.Claims
Imports System.Net.Mail
Imports System.IO
Imports GemBox.Spreadsheet
Imports ILSBusinessLayer
Imports System.Text
Imports System.Text.RegularExpressions
Imports DevExpress.Web
Imports LumenWorks.Framework.IO.Csv
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Estructuras


Public Class AdministracionDeUsuarios
    Inherits System.Web.UI.Page
    Private oExcel As ExcelFile

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Seguridad.verificarSession(Me)
#If DEBUG Then
        Session("usxp001") = 20608  '2009
        Session("usxp009") = 180  '185
        Session("usxp007") = 150
        Session("usxp014") = "192.127.62.1"
#End If
        'Seguridad.verificarSession(Me)

        Try
            If Not Me.IsPostBack Then
                Session.Remove("IdBodega")

                With epPrincipal
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administracion De Usuarios")
                End With
                Session.Remove("dtFabricantes")
                Session.Remove("dtPerfiles")
                cargarCiudades()
                cargarPerfiles()
                CargarCentrosDeCosto()
                CargarEmpresaTemporal()

            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar los datos: " & ex.Message)
        End Try

    End Sub



    Private Function CrearEstructuraInfoSerial() As DataTable
        Dim dtAux As New DataTable

        With dtAux.Columns
            dtAux.Columns.Add("identificacion", GetType(String))
            dtAux.Columns.Add("perfil", GetType(String))
            dtAux.Columns.Add("callcernter", GetType(String))
            dtAux.Columns.Add("siteCallcenter", GetType(String))
            dtAux.Columns.Add("ciudad", GetType(String))
            dtAux.Columns.Add("usuario", GetType(String))
            dtAux.Columns.Add("correo", GetType(String))
        End With
        Return dtAux
    End Function

    Private Sub ExtractDataErrorHandler(ByVal sender As Object, ByVal e As ExtractDataDelegateEventArgs)
        If e.ErrorID = ExtractDataError.WrongType Then
            If e.ExcelValue Is Nothing Then
                e.DataTableValue = DBNull.Value
            Else
                e.DataTableValue = e.ExcelValue.ToString()
            End If
            e.Action = ExtractDataEventAction.Continue
        End If
    End Sub

    Public Function FetchFromCSVFileLong(ByVal filePath As String) As DataTable

        Dim hasHeader As Boolean = True
        Dim csvTable As DataTable = New DataTable()

        Using csvReader As CsvReader = New CsvReader(New StreamReader(filePath), hasHeader, vbTab, 1)
            Dim fieldCount As Integer = csvReader.FieldCount
            Dim headers As String() = csvReader.GetFieldHeaders()

            For Each headerLabel As String In headers
                csvTable.Columns.Add(headerLabel, GetType(String))
            Next

            While csvReader.ReadNextRecord()
                Dim newRow As DataRow = csvTable.NewRow()

                For i As Integer = 0 To fieldCount - 1
                    newRow(i) = csvReader(i)
                Next

                csvTable.Rows.Add(newRow)
            End While
        End Using

        Return csvTable
    End Function



    Protected Sub Link_Init_Eliminar(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idtercero As Integer

            Dim linkDesactivar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkDesactivar.NamingContainer, GridViewDataItemTemplateContainer)
            linkDesactivar.ClientSideEvents.Click = linkDesactivar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            Dim idestado As Integer
            idestado = CInt(templateContainer.Grid.GetRowValues(templateContainer.VisibleIndex, "idEstado").ToString())
            If idestado = 1 Then
                linkDesactivar.Visible = True
            Else
                linkDesactivar.Visible = False
            End If
            idtercero = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtercero"))

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idtercero As Integer

            Dim linkEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEditar.NamingContainer, GridViewDataItemTemplateContainer)
            linkEditar.ClientSideEvents.Click = linkEditar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idtercero = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtercero"))

            Dim idestado As Integer
            idestado = CInt(templateContainer.Grid.GetRowValues(templateContainer.VisibleIndex, "idEstado").ToString())

            If idestado = 2 Then
                linkEditar.Visible = False
            Else
                linkEditar.Visible = True
            End If

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Protected Sub Link_Init_Activar(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idtercero As Integer

            Dim linkActivar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkActivar.NamingContainer, GridViewDataItemTemplateContainer)
            linkActivar.ClientSideEvents.Click = linkActivar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)
            idtercero = CInt(gvDetalle.GetRowValuesByKeyValue(templateContainer.KeyValue, "idtercero"))

            Dim idestado As Integer
            idestado = CInt(templateContainer.Grid.GetRowValues(templateContainer.VisibleIndex, "idEstado").ToString())
            If idestado = 2 Then
                linkActivar.Visible = True

            Else
                linkActivar.Visible = False
            End If

        Catch ex As Exception
            CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Private Sub cargarCiudades()
        Dim dtCiudades As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtCiudades = objBod.ObtenerCiudades()
            Session("dtCiudades") = dtCiudades
            MetodosComunes.CargarComboDX(cmbCiudades, dtCiudades, "idCiudad", "ciudad")
            MetodosComunes.CargarComboDX(cmbCiudadEditar, dtCiudades, "idCiudad", "ciudad")
        Catch ex As Exception

        End Try
    End Sub

    Private Sub cargarPerfiles()
        Dim dtPerfiles As New DataTable
        Dim objBod As New CreacionDeUsuarios
        Try
            dtPerfiles = objBod.ConsultarPerfiles()
            Session("dtcmbPerfiesEditar") = dtPerfiles
            MetodosComunes.CargarComboDX(cmbPerfiles, dtPerfiles, "idperfil", "perfil")
            MetodosComunes.CargarComboDX(cmbPerfilesEditar, dtPerfiles, "idperfil", "perfil")

        Catch ex As Exception

        End Try
    End Sub

    Private Sub CargarCentrosDeCosto()
        Dim dtCentrosDeCosto As New DataTable
        Dim objBod As New CreacionDeUsuarios
        Try
            dtCentrosDeCosto = objBod.ConsultarCentrosDeCosto()
            Session("dtcmbCentroDeCosto") = dtCentrosDeCosto
            If dtCentrosDeCosto.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbCentroDeCosto, dtCentrosDeCosto, "idcentro_costo", "nombre")
            End If
        Catch ex As Exception

        End Try
    End Sub

    Private Sub CargarEmpresaTemporal()
        Dim dtEmpresaTemporal As New DataTable
        Dim objBod As New CreacionDeUsuarios
        Try
            dtEmpresaTemporal = objBod.ConsultardtEmpresaTemporal()
            Session("dtcmbEmpresaTemporal") = dtEmpresaTemporal
            If dtEmpresaTemporal.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbEmpresaTemporal, dtEmpresaTemporal, "idempresa_temporal", "nombre")
            End If
        Catch ex As Exception

        End Try
    End Sub


    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        epPrincipal.clear()
        Try

            Dim accion As String
            Dim parametro As String
            Dim cadena As String() = e.Parameter.ToString().Split(New Char() {":"})
            accion = cadena(0)
            parametro = cadena(1)
            Select Case accion
                Case "ConsultarInformacion"
                    epPrincipal.clear()
                    cargarDatos()
                Case "desabilitar"
                    Dim objEditar As New CreacionDeUsuarios
                    epPrincipal.clear()
                    With objEditar
                        .idTercero = Session("IdUsuario")
                        .idUsuario = Session("usxp001")
                        .Observacion = txtObservacion.Text
                        resultado = .DesactivarTercero(.idUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos()
                        pcEditar.ShowOnPageLoad = False
                    ElseIf resultado.Valor = 1 Then
                        epPrincipal.showError(resultado.Mensaje)
                    Else
                        epPrincipal.showError(resultado.Mensaje)
                    End If
                Case "habilitar"
                    Dim objEditar As New CreacionDeUsuarios
                    epPrincipal.clear()
                    With objEditar
                        .idTercero = Session("IdUsuario")
                        .idUsuario = Session("usxp001")
                        .Observacion = txtObservacion.Text
                        resultado = .HabilitarTercero(.idUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos()
                        pcEditar.ShowOnPageLoad = False
                    ElseIf resultado.Valor = 1 Then

                    Else
                        epPrincipal.showError(resultado.Mensaje)
                    End If
                Case "modificar"
                    Dim objModificar As New CreacionDeUsuarios
                    epPrincipal.clear()
                    With objModificar
                        .idTercero = Session("idTercero")
                        .idUsuario = Session("usxp001")
                        .NombreCompleto = txtNombreEditar.Text.Trim
                        .Identificacion = txtCedulaEditar.Text.Trim
                        .Usuario = txtUsuarioEditar.Text.Trim
                        .correo = txtCorreo.Text.Trim
                        .idperfil = cmbPerfilesEditar.Value
                        .IdCiudad = cmbCiudadEditar.Value
                        .idCentroCostos = cmbCentroDeCosto.Value
                        .idEmpresaTemporal = cmbEmpresaTemporal.Value
                        resultado = .ModificarTercero(.idUsuario)
                    End With
                    If resultado.Valor = 0 Then
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos()
                        pcEditarTercero.ShowOnPageLoad = False
                    ElseIf resultado.Valor = 1 Then

                    ElseIf resultado.Valor = 2 Then
                        epPrincipal.showError(resultado.Mensaje)
                    Else
                        epPrincipal.showError(resultado.Mensaje)
                    End If
                Case "Crear"
                    Dim objModificar As New CreacionDeUsuarios
                    Dim idTerceroUsuario As Integer
                    epPrincipal.clear()
                    With objModificar
                        .idTercero = Session("idTercero")
                        .idUsuario = Session("usxp001")
                        .NombreCompleto = txtNombreEditar.Text.Trim
                        .Identificacion = txtCedulaEditar.Text.Trim
                        .Usuario = txtUsuarioEditar.Text.Trim
                        .correo = txtCorreo.Text.Trim
                        .idperfil = cmbPerfilesEditar.Value
                        .IdCiudad = cmbCiudadEditar.Value
                        .idCentroCostos = cmbCentroDeCosto.Value
                        .idEmpresaTemporal = cmbEmpresaTemporal.Value
                        resultado = .CrearTercero(idTerceroUsuario)

                    End With
                    If resultado.Valor = 0 Then
                        objModificar.notificarContrasena(txtCedulaEditar.Text.Trim)
                        epPrincipal.showSuccess(resultado.Mensaje)
                        Session.Remove("dtResultados")
                        cargarDatos(idTerceroUsuario)
                        pcEditarTercero.ShowOnPageLoad = False
                    ElseIf resultado.Valor <> 0 Then
                        EncabezadoPop.showError(resultado.Mensaje)
                        btnModificar.Visible = False
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            cpGeneral.JSProperties("cpMensajePop") = EncabezadoPop.RenderHtml
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub

    Private Sub cargarDatos(Optional ByVal idTerceroCreado As Integer = 0)
        Dim objMatriz As New CreacionDeUsuarios
        Try
            With objMatriz
                .idperfil = cmbPerfiles.Value
                .IdCiudad = cmbCiudades.Value
                .Identificacion = txtCedula.Text.Trim
                .Usuario = txtUsuario.Text.Trim
                .NombreCompleto = txtNombreApellido.Text.Trim
                .idTerceroCreado = idTerceroCreado
                Session("dtResultados") = .listarUsuarios
            End With
            If Session("dtResultados").Rows.Count > 0 Then
                With gvDetalle
                    .DataSource = CType(Session("dtResultados"), DataTable)
                    .DataBind()
                End With
            Else
                With gvDetalle
                    .DataSource = CType(Session("dtResultados"), DataTable)
                    .DataBind()
                End With
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub


    Private Sub gvDetalle_DataBinding(sender As Object, e As EventArgs) Handles gvDetalle.DataBinding
        If Session("dtResultados") IsNot Nothing Then gvDetalle.DataSource = CType(Session("dtResultados"), DataTable)
    End Sub

    Private Sub pcEditar_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEditar.WindowCallback
        txtObservacion.Text = Nothing
        Dim arrAccion As String()
        Dim parametro As String = e.Parameter.ToString
        arrAccion = e.Parameter.Split(":")
        CargarInformacionUsuario(CInt(arrAccion(0)))
    End Sub

    Private Sub pcEditarTercero_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcEditarTercero.WindowCallback
        Try

            Dim accion As String
            Dim idperfilUsuario As Integer
            Dim parametro As String
            Dim cadena As String() = e.Parameter.ToString().Split(New Char() {":"})
            accion = cadena(1)
            parametro = cadena(0)
            'Dim arrAccion As String()
            'Dim parametro As String = e.Parameter.ToString
            'arrAccion = e.Parameter.Split(":")
            Dim objMatriz As New CreacionDeUsuarios
            Session("idTercero") = CInt(parametro)
            Select Case accion
                Case 1
                    btnCrearUsuario.Visible = False
                    With objMatriz
                        .CargarInformacionTercero(Session("idTercero"))
                        txtNombreEditar.Text = objMatriz.NombreCompleto
                        txtCedulaEditar.Text = objMatriz.Identificacion
                        txtUsuarioEditar.Text = objMatriz.Usuario
                        txtCorreo.Text = objMatriz.correo
                        cmbPerfilesEditar.Value = objMatriz.idperfil
                        cmbCiudadEditar.Value = objMatriz.IdCiudad
                        cmbCentroDeCosto.Value = objMatriz.idCentroCostos
                        idperfilUsuario = objMatriz.idperfil
                        cmbEmpresaTemporal.Value = objMatriz.idEmpresaTemporal
                    End With
                Case 2
                    btnModificar.Visible = False
                    epPrincipal.clear()
                    cmbPerfilesEditar.Value = Nothing
                    cmbCentroDeCosto.Value = Nothing
                    cmbCiudadEditar.Value = Nothing
                    cmbEmpresaTemporal.Value = Nothing
                    txtCorreo.Text = Nothing
                    txtCedulaEditar.Text = Nothing
                    txtNombreEditar.Text = Nothing
                    txtUsuarioEditar.Text = Nothing
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInformacionUsuario(ByVal idUsuarioNotificacion As Integer)
        Dim objMatriz As New CreacionDeUsuarios
        Session("IdUsuario") = idUsuarioNotificacion
        Try
            With objMatriz
                .idUsuario = idUsuarioNotificacion
                .listarUsuarios()
                txtNombre.Text = .listarUsuarios.Rows(0).Item(2).ToString
                txtIdUsuario.Text = .listarUsuarios.Rows(0).Item(0).ToString
                Dim estado As String = .listarUsuarios.Rows(0).Item(5).ToString
                If estado = "Activo" Then
                    btnAnular.Enabled = True
                    btnReactivar.Visible = False
                Else
                    btnAnular.Visible = False
                    btnReactivar.Enabled = True
                End If
            End With
        Catch ex As Exception
            Throw ex
        End Try

    End Sub


    Protected Sub cbFormatoExportar_ButtonClick(source As Object, e As ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            Dim fecha As DateTime = DateTime.Now
            Dim fec As String = fecha.ToString("HH:mm:ss:fff").Replace(":", "_")
            Dim nombre As String = "DatosUsuarios"
            nombre = nombre & "_" & Session("usxp001") & "_" & fec & ".xlsx"
            If Session("dtResultados") IsNot Nothing AndAlso CType(Session("dtResultados"), DataTable).Rows.Count > 0 Then
                Dim gvDetalle As DataView = CType(Session("dtResultados"), DataTable).DefaultView
                Dim dtDatos As DataTable = gvDetalle.ToTable(False, "idtercero", "cedula", "nombre", "usuario", "perfil", "ciudad", "estado")
                MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, nombre, Server.MapPath("../archivos_planos/" & nombre), )
            Else
                epPrincipal.showError("No se encontraron datos para exportar, por favor intente nuevamente.")
            End If

        Catch ex As Exception
            epPrincipal.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
    End Sub



    Protected Sub cmbCentroDeCosto_DataBinding(sender As Object, e As EventArgs) Handles cmbCentroDeCosto.DataBinding
        If Session("dtcmbCentroDeCosto") IsNot Nothing Then cmbCentroDeCosto.DataSource = Session("dtcmbCentroDeCosto")
    End Sub



    Protected Sub cmbPerfiesEditar_DataBinding(sender As Object, e As EventArgs) Handles cmbPerfilesEditar.DataBinding
        If Session("dtcmbPerfiesEditar") IsNot Nothing Then cmbPerfilesEditar.DataSource = Session("dtcmbPerfiesEditar")
    End Sub


End Class