Imports ILSBusinessLayer
Imports DevExpress.Web
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes


Public Class ReporteCruceRealceVsFisico
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Me.IsPostBack Then
            miEncabezado.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            miEncabezado.setTitle("Reporte Cruce Solicitud Realce Vs. Fisico")
            deFechaInicio.MaxDate = DateTime.Now.Date
            deFechaFin.MaxDate = DateTime.Now.Date
            CargarListadoBodegas()
            CargarListadoBase()
        End If
    End Sub

    Private Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Dim resultado As New ResultadoProceso
        Dim result As Integer = 0
        Try
            Dim arrayAccion As String()
            arrayAccion = e.Parameter.Split(":")
            Select Case arrayAccion(0)
                Case "filtrarDatos"
                    CargarDatos()
                    result = 1
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de manejar CallBack: " & ex.Message)
        End Try
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        CType(sender, ASPxCallbackPanel).JSProperties("cpResultado") = result
    End Sub

    Private Sub gvDetalle_DataBinding(sender As Object, e As System.EventArgs) Handles gvDetalle.DataBinding
        gvDetalle.DataSource = Session("dtDatos")
    End Sub

    Private Sub cbFormatoExportar_ButtonClick(source As Object, e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Dim formato As String = cbFormatoExportar.Value
        If Not String.IsNullOrEmpty(formato) Then
            With gveExportador
                .FileName = "ReporteCruceSolicitudRealceVsFisico"
                .ReportHeader = "Reporte Cruce Solicitud Realce Vs. Fisico" & vbCrLf & vbCrLf
                .ReportFooter = vbCrLf & "Logytech Mobile S.A.S"
                .Landscape = False
                With .Styles.Default.Font
                    .Name = "Arial"
                    .Size = FontUnit.Point(10)
                End With
                .DataBind()
            End With

            gvDetalle.SettingsDetail.ExportMode = GridViewDetailExportMode.Expanded

            Select Case formato
                Case "xls"
                    gveExportador.WriteXlsToResponse()
                Case "pdf"
                    With gveExportador
                        .Landscape = True
                        .WritePdfToResponse()
                    End With
                Case "xlsx"
                    gveExportador.WriteXlsxToResponse()
                Case "csv"
                    gveExportador.WriteCsvToResponse()
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarListadoBodegas()
        Dim dtBodegas As New DataTable
        Try
            dtBodegas = HerramientasMensajeria.ConsultarBodega(idUsuarioConsulta:=CInt(Session("usxp001")))
            MetodosComunes.CargarComboDX(cbBodega, dtBodegas, "idBodega", "bodega")
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Bodegas. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarListadoBase()
        Dim dtBase As New DataTable
        Try
            dtBase = HerramientasMensajeria.ConsultarBaseCliente()
            MetodosComunes.CargarComboDX(cbBase, dtBase, "idPlano", "nombreArchivo")
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el listado de Base. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDatos()
        Dim InfoServicio As New ServicioMensajeria
        Dim dtDatos As New DataTable
        With InfoServicio
            If cbBodega.SelectedIndex <> -1 Then .IdBodega = cbBodega.Value
            If cbBase.SelectedIndex <> -1 Then .IdBase = cbBase.Value
            If deFechaInicio.Value <> Date.MinValue And deFechaFin.Value <> Date.MinValue Then
                .FechaIni = deFechaInicio.Value
                .fechaFin = deFechaFin.Value
            End If
            dtDatos = .ObtenerDatosCruceRealceVsFisico
        End With

        Session("dtDatos") = dtDatos

        With gvDetalle
            .DataSource = Session("dtDatos")
            .DataBind()
        End With

    End Sub

#End Region

End Class