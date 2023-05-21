Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports DevExpress.Web

Public Class AdministracionPlanesSiembra
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Administración Planes Siembra")
                    CargarPlanesSiembra()
                    CargarPaquetes()
                    CargarTipoPlan()
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

    Protected Sub Link_InitPaq(ByVal sender As Object, ByVal e As EventArgs)
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
                Case "registrarPlan"
                    resultado = RegistrarPlan()
                    If resultado.Valor = 0 Then
                        txtNombre.Text = ""
                        meDescripcion.Text = ""
                        cmbTipoPlan.SelectedIndex = -1
                        CargarPlanesSiembra()
                        CargarTipoPlan()
                    End If
                Case "buscarPlan"
                    CargarPlanesSiembra(cbFiltroPlan.Checked)
                    CargarTipoPlan()
                Case "registrarPaquete"
                    resultado = RegistrarPaquete()
                    If resultado.Valor = 0 Then
                        txtPaquete.Text = ""
                        mePaquete.Text = ""
                        CargarPaquetes()
                    End If
                Case "buscarPaquete"
                    CargarPaquetes(cbFiltroPaquete.Checked)
                Case "editarPlan"
                    resultado = EditarPlanVenta(arrayAccion(1))
                    If resultado.Valor = 0 Then
                        CargarPlanesSiembra()
                        CargarTipoPlan()
                    End If
                Case "editarPaquete"
                    resultado = EditarPaqueteVenta(arrayAccion(1))
                    If resultado.Valor = 0 Then
                        CargarPaquetes()
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcModificaPlan_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcModificaPlan.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "plan"
                    resultado = ConsultaDatosPlan(arrayAccion(1))
                    lblIdPlan.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub pcModificaPaquete_WindowCallback(source As Object, e As PopupWindowCallbackArgs) Handles pcModificaPaquete.WindowCallback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "paquete"
                    resultado = ConsultaDatosPaquete(arrayAccion(1))
                    lblIdPaquete.Text = arrayAccion(1)
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al procesar el Callback: " & ex.Message)
        End Try
        CType(source, ASPxPopupControl).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub gvPlanes_DataBinding(sender As Object, e As EventArgs) Handles gvPlanes.DataBinding
        If Session("dtDatosPlanes") IsNot Nothing Then gvPlanes.DataSource = Session("dtDatosPlanes")
    End Sub

    Private Sub gvPaquetes_DataBinding(sender As Object, e As EventArgs) Handles gvPaquetes.DataBinding
        If Session("dtDatosPaquetes") IsNot Nothing Then gvPaquetes.DataSource = Session("dtDatosPaquetes")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarPlanesSiembra(Optional ByVal activo As Boolean = True)
        Dim objPlanes As New PlanVentaColeccion()
        With objPlanes
            .Activo = activo
            .ListTipoServicio.Add(Enumerados.TipoServicio.Siembra)
        End With

        With gvPlanes
            .DataSource = objPlanes.GenerarDataTable()
            Session("dtDatosPlanes") = .DataSource
            .DataBind()
        End With

    End Sub

    Private Sub CargarPaquetes(Optional ByVal activo As Boolean = True)
        Dim objPaquete As New PaqueteVentaColeccion
        With objPaquete
            .Activo = activo
        End With

        With gvPaquetes
            .DataSource = objPaquete.GenerarDataTable()
            Session("dtDatosPaquetes") = .DataSource
            .DataBind()
        End With

    End Sub

    Private Sub CargarTipoPlan()
        Try
            'Tipos de planes
            MetodosComunes.CargarComboDX(cmbTipoPlan, HerramientasMensajeria.ObtieneTiposPlanVenta(), "idTipo", "nombre")
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar los valores iniciales: " & ex.Message)
        End Try
    End Sub

    Private Function RegistrarPlan() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPlan As New PlanVenta
        With objPlan
            .NombrePlan = txtNombre.Text.Trim
            .Descripcion = meDescripcion.Text.Trim
            .CargoFijoMensual = 0
            .IdTipoPlan = cmbTipoPlan.Value
            .ListTipoServicio.Add(Enumerados.TipoServicio.Siembra)
            resultado = .RegistrarSiembra(CInt(Session("usxp001")))
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function RegistrarPaquete() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPaquete As New PaqueteVenta
        With objPaquete
            .Nombre = txtPaquete.Text.Trim
            .Observacion = mePaquete.Text.Trim
            resultado = .Registrar()
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function ConsultaDatosPlan(ByVal idPlan As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPlan As New PlanVenta(idPlan)
        MetodosComunes.CargarComboDX(cmbEditTipoPlan, HerramientasMensajeria.ObtieneTiposPlanVenta(), "idTipo", "nombre")
        With objPlan
            txtEditNombre.Text = .NombrePlan
            meEditPlan.Text = .Descripcion
            cmbEditTipoPlan.Value = .IdTipoPlan.ToString()
            cbActivo.Checked = .Activo
        End With
        Return resultado
    End Function

    Private Function ConsultaDatosPaquete(ByVal idPaquete As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPaquete As New PaqueteVenta(idPaquete)
        With objPaquete
            txtEditPaquete.Text = .Nombre
            meEditPaquete.Text = .Observacion
            cbActivoPaq.Checked = .Activo
        End With
        Return resultado
    End Function

    Private Function EditarPlanVenta(ByVal idPlan As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPlan As New PlanVenta
        With objPlan
            .IdPlan = idPlan
            .NombrePlan = txtEditNombre.Text.Trim
            .Descripcion = meEditPlan.Text.Trim
            .IdTipoPlan = cmbEditTipoPlan.Value
            .Activo = cbActivo.Checked
            resultado = .ActualizarSiembra(CInt(Session("usxp001")))
        End With
        If resultado.Valor = 0 Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
        Return resultado
    End Function

    Private Function EditarPaqueteVenta(ByVal idPaquete As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim objPlan As New PaqueteVenta
        With objPlan
            .IdPaquete = idPaquete
            .Nombre = txtEditPaquete.Text.Trim
            .Observacion = meEditPaquete.Text.Trim
            .Activo = cbActivoPaq.Checked
            resultado = .Actualizar(CInt(Session("usxp001")))
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