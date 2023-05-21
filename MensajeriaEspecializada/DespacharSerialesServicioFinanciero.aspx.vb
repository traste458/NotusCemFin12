Imports System.Text
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports ILSBusinessLayer.Comunes
Imports DevExpress.Web

Public Class DespacharSerialesServicioFinanciero
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink("PoolServiciosNew.aspx")
                .setTitle("Despachar Seriales - Servicio de Mensajer&iacute;a")
                Dim idServicio As Integer
                With Request
                    If .QueryString("idServicio") IsNot Nothing Then Integer.TryParse(.QueryString("idServicio").ToString, idServicio)
                End With
                If idServicio > 0 Then
                    Dim infoServicio As New ServicioMensajeria(idServicio:=idServicio)
                    Dim respuesta As New ResultadoProceso
                    If infoServicio IsNot Nothing AndAlso infoServicio.Registrado Then
                        Dim objEncabezado As EncabezadoServicioMensajeria = Page.LoadControl("../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx")
                        infoServicio = New ServicioMensajeria(idServicio:=idServicio)
                        respuesta = objEncabezado.CargarInformacionGeneralServicio(infoServicio)
                        phEncabezado.Controls.Add(objEncabezado)
                        phEncabezado.DataBind()
                        Session("infoServicioMensajeria") = infoServicio
                        Session("idServicio") = idServicio
                        CargarDetalleDeReferencias(idServicio)
                    Else
                        miEncabezado.showWarning("No fué posible encontrar los datos del servicio.")
                    End If
                Else
                    miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                End If
            End With

        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "Registrar"
                    Dim valor As Integer = CInt(arrayAccion(1))
                    If valor = 1 Then
                        resultado = RegistrarSerial()
                        cmbMaterial.SelectedIndex = -1
                    Else
                        resultado = DesvincularSerial()
                    End If
                Case "Cerrar"
                    CerrarDespacho()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select

        Catch ex As Exception
            miEncabezado.showError("Ocurrio un error al generar el registro: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Chk_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim idDetalle As Long
        Dim esSerializado As Boolean
        Try
            Dim chkPic As CheckBox = CType(sender, CheckBox)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(chkPic.NamingContainer, GridViewDataItemTemplateContainer)
            Dim chkMaterial As CheckBox = templateContainer.FindControl("chkMaterial")
            esSerializado = CInt(gvListaReferencias.GetRowValuesByKeyValue(templateContainer.KeyValue, "EsSerializado"))
            chkMaterial.CssClass = chkMaterial.CssClass.Replace("{0}", idDetalle)
            chkMaterial.ID = idDetalle

            If esSerializado Then
                chkMaterial.Visible = False
            Else
                chkMaterial.Visible = True
                chkMaterial.Checked = True
            End If
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub pcSeriales_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcSeriales.WindowCallback
        VerSeriales()
    End Sub

    Private Sub pcNovedades_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs) Handles pcNovedades.WindowCallback
        Dim param As String = e.Parameter
        Select Case param
            Case "Inicial"
                CargaInicialNovedad()
                cmbNovedad.Focus()
            Case "Registra"
                RegistrarNovedad()
                cmbNovedad.Focus()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

    Private Sub gvListaReferencias_DataBinding(sender As Object, e As EventArgs) Handles gvListaReferencias.DataBinding
        gvListaReferencias.DataSource = Session("lReferencias")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Function CargarDetalleDeReferencias(ByVal idServicio As Integer) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            Dim detalleReferencia As New DetalleMaterialServicioMensajeriaColeccion(idServicio)
            Dim dtAux As DataTable = detalleReferencia.GenerarDataTable()
            Session("lReferencias") = dtAux
            With gvListaReferencias
                .DataSource = Session("lReferencias")
                .DataBind()
            End With
            CargarMaterialesLectura(dtAux)
            resultado.EstablecerMensajeYValor(0, "Cargue de referencias exitoso.")
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(1, "Error al tratar de obtener el listado de referencias solicitadas. " & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub CargarMaterialesLectura(ByVal dtMateriales As DataTable)
        Dim dtValor As DataTable = dtMateriales.Copy
        Dim dvValor As DataView = dtValor.DefaultView
        Dim dvDatos As DataView = dtMateriales.DefaultView
        Dim prodNoSerializado As Boolean = False

        If dtValor.Rows.Count > 0 Then
            For Each dr As DataRow In dtValor.Rows
                If dr("Material") = "NS0000" Or dr("Material") = "NS0001" Then
                    prodNoSerializado = True
                End If
            Next

        End If

        If prodNoSerializado Then
            dvDatos.RowFilter = "productoFinNoSerializado = 1 AND Cantidad > CantidadLeida"
            dvValor.RowFilter = "productoFinNoSerializado = 1"
        Else
            dvDatos.RowFilter = "EsSerializado = 1 AND Cantidad > CantidadLeida"
            dvValor.RowFilter = "EsSerializado = 1"
        End If
       
        Dim dtAux As DataTable = dvDatos.ToTable()
        Dim dtAux1 As DataTable = dvValor.ToTable()
        MetodosComunes.CargarComboDX(cmbMaterial, dtAux1, "Material", "DescripcionMaterial")
        cmbMaterial.Focus()
        If dtAux.Rows.Count = 0 Then
            tdCierra.Visible = True
        Else
            tdCierra.Visible = False
        End If
    End Sub

    Private Function RegistrarSerial() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)

        Dim serial As String = txtSerial.Text.Trim



        If infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosBancolombia Then
            If serial.IndexOf(infoServicio.IdentificacionCliente) > 0 Then
                resultado = infoServicio.LeerSerialServicioFinanciero(txtSerial.Text.Trim, Session("usxp001"), cmbMaterial.Value)
                If resultado.Valor = 0 Then
                    miEncabezado.showSuccess(resultado.Mensaje)
                Else
                    miEncabezado.showWarning(resultado.Mensaje)
                End If
                CargarDetalleDeReferencias(idServicio)
            Else
                miEncabezado.showWarning("El serial no contiene el numero de cedula, no esta asociado al cliente.")
                resultado.EstablecerMensajeYValor("-501", "El serial no contiene el numero de cedula, no esta asociado al cliente.")
            End If
        Else
            If cmbMaterial.Value = "NS0000" Or cmbMaterial.Value = "NS0001" Then
                infoServicio.ProductoNoSerializado = cmbMaterial.Value
            End If
            resultado = infoServicio.LeerSerialServicioFinanciero(txtSerial.Text.Trim, Session("usxp001"), cmbMaterial.Value)
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
            CargarDetalleDeReferencias(idServicio)
        End If
        
        txtSerial.Text = ""
        txtSerial.Focus()
        Return resultado
    End Function

    Private Function DesvincularSerial() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Dim idServicio As Integer = CInt(Session("idServicio"))
        Dim infoSerial As New DetalleSerialServicioMensajeria(idServicio, serial:=txtSerial.Text.Trim)
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)

        If infoSerial.Registrado Then
            If infoSerial.IdServicio = infoServicio.IdServicioMensajeria Then
                resultado = infoSerial.Eliminar(CInt(Session("usxp001")))
            Else
                miEncabezado.showWarning("El serial proporcionado no está asociado al servicio actual. Por favor verifique")
            End If
        Else
            miEncabezado.showWarning("El serial proporcionado para desvincular no ha sido despachado. Por favor verifique")
        End If

        If resultado.Valor = 0 Then
            resultado.Mensaje = "Serial desvinculado satisfactoriamente."
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showWarning(resultado.Mensaje)
        End If
        CargarDetalleDeReferencias(idServicio)
        txtSerial.Text = ""
        txtSerial.Focus()
        Return resultado
    End Function

    Private Function CerrarDespacho() As ResultadoProceso
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Dim resultado As New ResultadoProceso
        Dim idUsuario As Integer = CInt(Session("usxp001"))
        Try
            Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
            If infoServicio Is Nothing Then infoServicio = New ServicioMensajeria(idServicio)
            With infoServicio
                .IdUsuarioCierre = idUsuario
                resultado = .CerrarDespacho()
                If resultado.Valor = 0 Then
                    rpLectura.ClientVisible = False
                    miEncabezado.showSuccess(resultado.Mensaje)

                    If (infoServicio.IdTipoServicio = Enumerados.TipoServicio.DaviviendaSamsung) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressDaviviendaSamsung, idServicio, Enumerados.EstadoServicio.DespachadoCambio, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    ElseIf (infoServicio.IdTipoServicio = Enumerados.TipoServicio.ServiciosFinancierosDavivienda) Then
                        resultado = ActualizarGestionVenta(New ServicioNotusExpressDavivienda, idServicio, Enumerados.EstadoServicio.DespachadoCambio, "Servicio modificado desde CEM, por el usuario: " & CStr(Session("usxp002")))
                    End If
                    'resultado = RegistrarSerialesGestionVenta(idServicio)
                Else
                    miEncabezado.showError(resultado.Mensaje)
                End If
            End With
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cerrar el despacho." & ex.Message)
        End Try
        Return resultado
    End Function

    Private Sub VerSeriales()
        Dim idServicio As Integer = CInt(Request.QueryString("idServicio"))
        Try
            Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio)
            Dim dtDatos As DataTable = detalle.GenerarDataTable()
            With gvSeriales
                .DataSource = dtDatos
                .DataBind()
            End With
            CargarDetalleDeReferencias(idServicio)
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de mostrar seriales. " & ex.Message)
        End Try
    End Sub

    Private Sub CargaInicialNovedad()
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        Dim dtEstado As New DataTable
        dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=4)
        MetodosComunes.CargarComboDX(cmbNovedad, dtEstado, "idTipoNovedad", "descripcion")

        CargarNovedades(infoServicio.IdServicioMensajeria)

    End Sub

    Private Sub CargarNovedades(ByVal idServicio As Integer)
        Try
            Dim listaNovedad As New NovedadServicioMensajeriaColeccion(idServicio)
            With gvNovedad
                .DataSource = listaNovedad.GenerarDataTable()
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de novedades. " & ex.Message)
        End Try

    End Sub

    Private Sub RegistrarNovedad()
        Dim resultado As ResultadoProceso
        Dim infoServicio As ServicioMensajeria = CType(Session("infoServicioMensajeria"), ServicioMensajeria)
        Dim novedad As New NovedadServicioMensajeria
        With novedad
            .IdServicioMensajeria = infoServicio.IdServicioMensajeria
            .Observacion = meJustificacion.Text.Trim
            .IdTipoNovedad = CInt(cmbNovedad.Value)
            resultado = .Registrar(CInt(Session("usxp001")))
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess(resultado.Mensaje)
                meJustificacion.Text = ""
                cmbNovedad.SelectedIndex = -1
                CargaInicialNovedad()
            Else
                miEncabezado.showError(resultado.Mensaje)
            End If
        End With
    End Sub

    Private Function RegistrarSerialesGestionVenta(ByVal idServicio As Integer)
        Dim resultado As New ResultadoProceso
        Dim dsDatos As New DataSet
        Dim detalle As New DetalleSerialServicioMensajeriaColeccion(idServicio)
        Dim dtDatos As DataTable = detalle.GenerarDataTable()

        Dim objGestion As New NotusExpressService.NotusExpressService
        Dim infoWs As New InfoUrlSidService(objGestion, True)
        Dim Wsresultado As New ILSBusinessLayer.NotusExpressService.ResultadoProceso
        dsDatos.Tables.Add(dtDatos)

        Wsresultado = objGestion.RegistraSerialGestionVenta(idServicio, dsDatos)
        resultado.Valor = Wsresultado.Valor
        resultado.Mensaje = Wsresultado.Mensaje
        Return resultado
    End Function

    Public Function ActualizarGestionVenta(ByVal servicioNotusExpress As IServicioNotusExpress, ByVal idServicio As Integer, ByVal idEstado As Integer, Optional ByVal justificacion As String = "Servicio modificado desde CEM, por el usuario: Admin") As ResultadoProceso
        Return servicioNotusExpress.ActualizarGestionVenta(idServicio, idEstado, justificacion)
    End Function



#End Region

End Class