Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.WMS
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class AdministracionClienteCEM
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración Clientes CEM")
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
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")
            Select Case arryAccion(0)
                Case "busquedaClientes"
                    resultado = BusquedaClientes()
                Case "editarClientes"
                    resultado = EditarCliente(arryAccion(1))
                    If resultado.Valor = 0 Then
                        BusquedaClientes()
                    End If
                Case "crearClientes"
                    resultado = CrearCliente()
                    If resultado.Valor = 0 Then
                        BusquedaClientes()
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al procesar el callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As EventArgs) Handles gvDatos.DataBinding
        If Session("dtClientesCEM") IsNot Nothing Then gvDatos.DataSource = Session("dtClientesCEM")
    End Sub

    Private Sub pcModificaCliente_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcModificaCliente.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "verCliente"
                    resultado = ConsultaDatosCliente(arrayAccion(1))
                    lblIdCliente.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcCrear_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcCrear.WindowCallback
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "crearCliente"
                    CargaInicial()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

#End Region

#Region "Métodos privados"

    Private Function BusquedaClientes() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objAlmacen As New AlmacenBodegaColeccion
        Dim dtDatos As New DataTable
        With objAlmacen
            .EsClienteCEM = True
            If txtNombre.Text <> "" Then .Descripcion = txtNombre.Text.Trim
            If txtCentro.Text <> "" Then .ListaCentro.Add(txtCentro.Text.Trim)
            If txtAlmacen.Text <> "" Then .ListaAlmacen.Add(txtAlmacen.Text.Trim)
            .Estado = cbFiltro.Checked
            dtDatos = .GenerarDataTable()
        End With
        Session("dtClientesCEM") = dtDatos
        With gvDatos
            .DataSource = dtDatos
            .DataBind()
        End With

        Return resultado
    End Function

    Private Function ConsultaDatosCliente(ByVal idCliente As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objAlmacen As New AlmacenBodega(idAlmacenBodega:=idCliente)
        With objAlmacen
            txtEditNombre.Text = .Descripcion.Trim
            txtEditCentro.Text = .Centro.Trim
            txtEditAlmacen.Text = .Almacen.Trim
            cbEdit.Checked = .Activo
        End With
        Return resultado
    End Function

    Private Function EditarCliente(ByVal idCliente As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objAlmacen As New AlmacenBodega
        With objAlmacen
            .IdAlmacenBodega = idCliente
            .IdUsuario = CInt(Session("usxp001"))
            .Centro = txtEditCentro.Text.Trim
            .Almacen = txtEditAlmacen.Text.Trim
            .Descripcion = txtEditNombre.Text.Trim
            .Activo = cbEdit.Checked
            resultado = .Actualizar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function CrearCliente() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objAlmacen As New AlmacenBodega
        With objAlmacen
            .IdBodega = CInt(cmbBodega.Value)
            .Centro = txtCreaCentro.Text.Trim
            .Almacen = txtCreaAlmacen.Text.Trim
            .Descripcion = txtCreaNombre.Text.Trim
            .IdUsuario = CInt(Session("usxp001"))
            .IdClienteCem = CInt(cmbCliente.Value)
            resultado = .Registrar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Sub CargaInicial()
        Dim objCliente As New ClienteCemColeccion
        Dim objBodega As New BodegaColeccion
        With objCliente
            .Estado = True
        End With
        MetodosComunes.CargarComboDX(cmbCliente, CType(objCliente.GenerarDataTable(), DataTable), "IdClienteCem", "Nombre")

        With objBodega
            .EsAdministrable = True
        End With
        MetodosComunes.CargarComboDX(cmbBodega, CType(objBodega.GenerarDataTable(), DataTable), "IdBodega", "Nombre")

        cmbBodega.SelectedIndex = -1
        cmbCliente.SelectedIndex = -1
        txtCreaCentro.Text = ""
        txtCreaAlmacen.Text = ""
        txtCreaNombre.Text = ""
    End Sub

#End Region

End Class