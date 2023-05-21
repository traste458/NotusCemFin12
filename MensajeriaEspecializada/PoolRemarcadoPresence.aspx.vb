Imports System.IO
Imports DevExpress.Web
Imports System.Net.Mail
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Comunes
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Linq

Public Class PoolRemarcadoPresence
    Inherits System.Web.UI.Page
    Private _mensajeGenerico As String = String.Empty


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("userId") = 1
        Session("usxp009") = 118
        Session("usxp007") = 150
#End If
        CargarLicenciaGembox()
        'Seguridad.verificarSession(Me)
        Try
            If Not Me.IsPostBack Then
                With miEncabezado
                    .setTitle("Pool Remarcación Precense")
                End With
                CargaInicial()
                deFechaInicio.Value = DateSerial(Year(DateTime.Now.Date), Month(DateTime.Now.Date), 1)
                deFechaFin.Value = DateTime.Now.Date
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la página: " & ex.Message)
        End Try
    End Sub
    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        'Dim opcionesPermitidas As String = ""

        'Try
        '    Dim lnkAgregar As ASPxCheckBox = CType(sender, ASPxCheckBox)
        '    Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
        '    lnkAgregar.ClientSideEvents.CheckedChanged = lnkAgregar.ClientSideEvents.CheckedChanged.Replace("{0}", templateContainer.VisibleIndex)

        'Catch ex As Exception
        '    epNotificador.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        'End Try
    End Sub

#Region "Métodos Privados"

    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            Dim resul As ResultadoProceso
            Dim arrayAccion As String()

            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "filtrarDatos"
                    CargarListadoDeVentasRegistrados(True)
                Case "LimpiarConsulta"

                    If Session("listaBusqueda") IsNot Nothing Then
                        CType(Session("listaBusqueda"), DataTable).Clear()
                    End If
                    If Session("dtCampanias") IsNot Nothing Then
                        cmbCampania.Value = -1
                    End If
                    Dim dt As New DataTable
                    With gvDatos
                        .DataSource = dt
                        .DataBind()
                    End With
                Case "EnviarDatosPresence"
                    resul = EnviarDatosPresence(arrayAccion(1), arrayAccion(2), arrayAccion(3))

                    If (resul.Valor = -1) Then
                        miEncabezado.showSuccess(resul.Mensaje)
                    Else
                        miEncabezado.showSuccess(resul.Mensaje)
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception

            _mensajeGenerico = "Ocurrió un error al generar el registro: " & ex.Message & "|rojo"
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Private Sub CargaInicial()

        Dim dtEmpresa As DataTable
        Dim dtEstadoBanco As DataTable

        dtEmpresa = HerramientasMensajeria.ObtenerInformacionEmpresa()
        MetodosComunes.CargarComboDX(cmbEmpresa, CType(dtEmpresa, DataTable), "idEmpresa", "nombre")

        dtEstadoBanco = HerramientasMensajeria.ObtenerInformacionBanco()
        MetodosComunes.CargarComboDX(cmbBanco, CType(dtEstadoBanco, DataTable), "idEstado", "nombre")

        ' Se cargan los tipos de Novedad
        With cmbEstadosConfirmacion
            .DataSource = HerramientasMensajeria.ConsultarEstado
            .TextField = "nombre"
            .ValueField = "idEstado"
            .DataBind()
        End With

        'Se cargan las campañas existentes en el sistema
        Dim objListBox As ASPxListBox = DirectCast(cmbCampania.FindControl("lbCampanias"), ASPxListBox)
        With objListBox
            Dim objCampanias As CampaniaPOPColeccion = New CampaniaPOPColeccion()
            objCampanias.CargarDatos()

            .Items.Add("(Todos)", 0)
            For Each camp As CampaniaPOP In objCampanias
                .Items.Add(camp.Nombre, camp.IdCampania)
            Next
        End With

        'Se carga el tipo de servicio para enviar a presence
        MetodosComunes.CargarDropDown(HerramientasMensajeria.ObtenerTipoServiciosPresence(), listTipoServicio)


    End Sub
    Private Sub CargarListadoDeVentasRegistrados(Optional ByVal forzarConsulta As Boolean = False)

        Dim dtDatos As DataTable = Nothing
        Try
            If Session("listaBusqueda") Is Nothing OrElse forzarConsulta Then
                Dim infoServicio As New ServicioMensajeria
                With infoServicio

                    If Not String.IsNullOrEmpty(txtRadicado.Text) Then .NumeroRadicado = txtRadicado.Text.Trim
                    If deFechaInicio.Date > Date.MinValue Then .FechaIni = deFechaInicio.Date
                    If deFechaFin.Date > Date.MinValue Then .fechaFin = deFechaFin.Date

                    For Each campSel As Object In DirectCast(cmbCampania.FindControl("lbCampanias"), ASPxListBox).SelectedValues
                        .IdCampaniaList.Add(CLng(campSel))
                    Next
                    If Not String.IsNullOrEmpty(cmbBanco.Text) Then .EstadoBanco = cmbBanco.Text
                    If (cmbEstadosConfirmacion.Value <> 0) Then .EstadoConfrimacion = cmbEstadosConfirmacion.Value
                    If (cmbEmpresa.Value <> 0) Then .IdEmpresa = cmbEmpresa.Value

                    dtDatos = .ConsultaRemarcadoPrecense()
                End With
                Session("listaBusqueda") = dtDatos
            Else
                dtDatos = CType(Session("listaBusqueda"), DataTable)
            End If

            With gvDatos
                .DataSource = dtDatos
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Error al tratar de cargar la información del reporte.")
        End Try

    End Sub
    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        If Session("listaBusqueda") Is Nothing Then
        Else
            gvDatos.DataSource = Session("listaBusqueda")
        End If
    End Sub

    Protected Function EnviarDatosPresence(ByVal datos As String, ByVal idTipo As Integer, ByVal nombreCarga As String) As ResultadoProceso

        Dim resultado As New ResultadoProceso
        Try
            Dim tblDatos As New DataTable
            Dim infoReferido As New CargadorArchivosGestionBaseClientesPrencece
            Dim arrCausal() As String

            tblDatos.Columns.Add("IdRegistroBase")
            arrCausal = datos.Split(",")
            For i As Integer = 0 To arrCausal.Count - 1
                Dim tbrDatos As DataRow = tblDatos.NewRow()
                tbrDatos("IdRegistroBase") = arrCausal(i)
                tblDatos.Rows.Add(tbrDatos)
            Next
            resultado = infoReferido.GenerarTemporalesRemarcado(tblDatos, idTipo, nombreCarga, CInt(Session("userId").ToString.Trim))

            If (resultado.Valor <> -1) Then
                Dim conn As New ConectorPresence
                Dim UrlApi = ConfigurationManager.AppSettings("UrlApiPresenceDes")
                If String.IsNullOrEmpty(UrlApi) Then Throw New Exception("No fue posible obtener la URL del API de Conexion de Presence. Por favor contacte al grupo de soporte de Desarrollo")

                With conn
                    .UrlApi = UrlApi
                    Dim res As ResultadoProceso = conn.EnviaGestionClientes(idTipo, nombreCarga, resultado.Valor)

                    If res.Valor = 0 Then
                        Dim dtDatos As DataTable = Nothing

                        dtDatos = infoReferido.ConsultaDetalleDatosRemarcado(resultado.Valor)

                        If (dtDatos.Rows.Count > 0) Then
                            Dim servicePresence As New webServicePresenceCarga
                            Dim urlservicio As New InfoUrlService
                            urlservicio.CargarDatos("PresenceService")

                            For Each row As DataRow In dtDatos.Rows
                                servicePresence.ServiceId = row("ServiceId")
                                servicePresence.LoadId = row("LoadId")
                                servicePresence.SourceId = row("SourceId")
                                servicePresence.Name = row("Name").ToString
                                servicePresence.TimeZone = row("TimeZone").ToString
                                servicePresence.Status = row("Status").ToString
                                servicePresence.Phone = row("Phone").ToString
                                servicePresence.PhoneTimeZone = row("PhoneTimeZone").ToString
                                servicePresence.AlternativePhones = row("AlternativePhones").ToString
                                servicePresence.AlternativePhoneDescriptions = row("AlternativePhoneDescriptions").ToString
                                servicePresence.AlternativePhoneTimeZones = row("AlternativePhoneTimeZones").ToString
                                servicePresence.ScheduleDate = row("ScheduleDate").ToString
                                servicePresence.CapturingAgent = CType(row("CapturingAgent"), Integer)
                                servicePresence.Priority = row("Priority").ToString
                                servicePresence.Comments = row("Comments").ToString
                                servicePresence.CustomData1 = row("CustomData1").ToString
                                servicePresence.CustomData2 = row("CustomData2").ToString
                                servicePresence.CustomData3 = row("CustomData3").ToString
                                servicePresence.CallerId = row("CallerId").ToString
                                servicePresence.CallerName = row("CallerName").ToString
                                servicePresence.InsertarRegistroOutbound(urlservicio.Url)
                            Next
                        Else
                            resultado.EstablecerMensajeYValor(-1, "Error al tratar de enviar los datos.")
                        End If
                    Else
                        resultado.EstablecerMensajeYValor(-1, res.Mensaje)
                    End If
                End With
            Else
                resultado.EstablecerMensajeYValor(-1, "Se presento un error al tratar de realizar la consulta")
            End If



        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar los datos: " & ex.Message)
        End Try

        Return resultado

    End Function


#End Region

End Class
