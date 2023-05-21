Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class AdministracionUsuariosReporteVentasWeb
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración Usuarios Reporte Ventas WEB")
                    CargarClientes()
                End With
            End If
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

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "adcionarUsuario"
                    resultado = AdicionarUsuario(arrayAccion(1), arrayAccion(2))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcCofigurar_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcCofigurar.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "configurarUsuario"
                    CargarUsuario(arrayAccion(1))
                    lbIdCliente.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtClientesCEM") IsNot Nothing Then gvDatos.DataSource = Session("dtClientesCEM")
    End Sub

    Private Sub lbUsuarios_DataBinding(sender As Object, e As EventArgs) Handles lbUsuarios.DataBinding
        If Session("dtUsuario") IsNot Nothing Then lbUsuarios.DataSource = Session("dtUsuario")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarClientes()
        Dim dtDatos As New DataTable
        If Session("dtClientesCEM") Is Nothing Then
            Dim objCliente As New ClienteCemColeccion
            With objCliente
                .Estado = True
                dtDatos = .GenerarDataTable()
            End With
            Session("dtClientesCEM") = dtDatos
        End If
        With gvDatos
            .DataSource = CType(Session("dtClientesCEM"), DataTable)
            .DataBind()
        End With
    End Sub

    Private Sub CargarUsuario(ByVal idCliente As Integer)
        If Session("dtUsuarios") Is Nothing Then
            Dim listPerfiles As List(Of String) = New List(Of String)(MetodosComunes.seleccionarConfigValue("PERFILES_REPORTE_VENTAS_WEB").Split(","))
            With lbUsuarios
                .DataSource = New UsuarioColeccion(listIdPerfil:=listPerfiles.ConvertAll(Of Integer)(Function(x) CInt(x))).GenerarDataTable()
                Session("dtUsuarios") = .DataSource
                .DataBind()
            End With
        Else
            lbUsuarios.DataSource = CType(Session("dtUsuarios"), DataTable)
            lbUsuarios.DataBind()
        End If

        Dim objUsuarios As New RelacionUsuarioCadenaWEBColeccion(idCliente)
        For Each itemSel As RelacionUsuarioCadenaWEB In objUsuarios
            For Each item As ListEditItem In lbUsuarios.Items
                If item.Value = itemSel.IdUsuario Then
                    item.Selected = True
                    Exit For
                End If
            Next
        Next
    End Sub

    Private Function AdicionarUsuario(ByVal idCliente As Integer, ByVal list As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objUsuario As New RelacionUsuarioCadenaWEB
        Dim arrayAccion As String()
        arrayAccion = list.Split(",")
        With objUsuario
            .IdClienteCem = idCliente
            For id As Integer = 0 To arrayAccion.Length - 1
                .ListIdUsuario.Add(arrayAccion(id).ToString)
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

#End Region

End Class