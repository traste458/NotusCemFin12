Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web


Public Class CrearNotificacionesCEM
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            If Not IsPostBack Then
                With miEncabezado
                    .setTitle("Crear Usuario Notificación CEM")
                End With
                CargarControles()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Private Sub cpFiltros_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpFiltros.Callback
        Try
            Dim Param As String = e.Parameter.ToString
            Select Case Param
                Case "eliminar"
                Case Else
                    Dim arrAccion As String()
                    arrAccion = e.Parameter.Split(":")
                    Select Case arrAccion(1)
                        Case "agregar"
                            AgregarUsuario(arrAccion(0))
                            CargarControles()
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select
                    Session.Remove("dtDatos")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al generar el proceso: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
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

            Dim objListBox As ASPxListBox = DirectCast(cmbBodegaCEM.FindControl("lbBodega"), ASPxListBox)
            With objListBox
                Dim dtBodegas As DataTable = HerramientasMensajeria.ConsultarBodega()
                Dim objCantidad As Integer = dtBodegas.Rows.Count

                .Items.Add("(Todos)", 0)
                For Each fila As DataRow In dtBodegas.Rows
                    .Items.Add(fila("bodega"), fila("idBodega"))
                Next
            End With
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar los controles: " & ex.Message)
        End Try
    End Sub

    Private Sub AgregarUsuario(ByVal listaBodega As String)
        Dim dtDatos As New DataTable
        Dim objRegistro As New UsuarioNotificacionCEM
        Dim listaNotificacion As New ArrayList
        Dim resultado As New ResultadoProceso

        Dim flagDominios As Boolean = objRegistro.ValidarDominio(txtCorreo.Text.Trim)

        If flagDominios Then
            Dim arrbodega As String() = listaBodega.Split(",")
            Dim listBodega As New ArrayList
            For Each ped As String In arrbodega
                listBodega.Add(ped)
            Next

            With objRegistro
                .Nombres = txtNombre.Text.Trim
                .Apellidos = txtApellido.Text.Trim
                .Email = txtCorreo.Text.Trim
                .IdUsuarioCreacion = CInt(Session("usxp001"))
                .TipoDestino = rblDestino.Value
                listaNotificacion.Add(cmbTipo.Value)
                resultado = .Registrar(listaNotificacion, listBodega)
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        Else
            miEncabezado.showWarning("Dominio de correo invalido, por favor verifique")
        End If

    End Sub

#End Region

End Class