Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Comunes

Public Class ReporteDetalladoServiciosSiembra
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _PersonasGerencia As DataTable

#End Region

#Region "Propiedades"

    Public Property PersonasGerencia As DataTable
        Get
            If _PersonasGerencia Is Nothing Then PersonalEnGerencia()
            Return _PersonasGerencia
        End Get
        Set(value As DataTable)
            _PersonasGerencia = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()
            If Not IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Reporte Detallado de Servicios SIEMBRA")
                End With
                CargarFiltros()
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al cargar la pagina: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDatos_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        BuscarRegistros()
    End Sub

    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        If Session("dtDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtDatos")
    End Sub

    Protected Sub cbFormatoExportar_ButtonClick(ByVal source As Object, ByVal e As DevExpress.Web.ButtonEditClickEventArgs) Handles cbFormatoExportar.ButtonClick
        Try
            If Session("dtDatos") IsNot Nothing Then
                Dim formato As String = cbFormatoExportar.Value
                If Not String.IsNullOrEmpty(formato) Then

                    With gveDatos
                        .FileName = "Reporte_Detallado_Servicios_Siembra_" + Now.Year.ToString() + Now.Month.ToString() + Now.Day.ToString()
                        .PageHeader.Center = "Reporte Detallado Servicios SIEMBRA" & vbCrLf
                        .PageFooter.Left = "Logytech Mobile S.A.S"
                        .PageFooter.Right = "[Page # of Pages #]"
                        .Landscape = False

                        With .Styles
                            .Default.Font.Size = FontUnit.Point(10)
                            .Default.Font.Name = "Arial"

                            .Title.HorizontalAlign = HorizontalAlign.Center
                            .Title.Font.Size = FontUnit.Point(20)
                            .Title.Font.Bold = True
                            .Title.Font.Name = "Arial"

                            .Header.HorizontalAlign = HorizontalAlign.Center
                            .Header.Font.Size = FontUnit.Point(10)
                            .Header.Font.Bold = True
                            .Header.Font.Name = "Arial"

                            .Footer.HorizontalAlign = HorizontalAlign.Center

                        End With
                        .DataBind()
                    End With

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
            Else
                miEncabezado.showWarning("No se pudo recuperar la información del reporte, por favor intente nuevamente.")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al exportar los datos: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub BuscarRegistros()
        Try
            Dim objReporte As New ReporteDetalldoServiciosSiembraBLL
            With objReporte
                .IdUsuario = CInt(Session("usxp001"))
                If cmbEstado.Value > 0 Then .IdEstado = cmbEstado.Value
                If cmbCiudad.Value > 0 Then .IdCiudad = cmbCiudad.Value
                If cmbGerencia.Value > 0 Then .IdGerencia = cmbGerencia.Value
                If cmbCoordinador.Value > 0 Then .IdCoordinacion = cmbCoordinador.Value
            End With

            With gvDatos
                .DataSource = objReporte.ObtenerReporte()
                Session("dtDatos") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se presento un error al buscar los registros: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarFiltros()
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)

            'Estados
            Dim objEstados As New EstadoColeccion
            With objEstados
                .IdEntidad = Enumerados.Entidad.ServicioMensajeria
                .CargarDatos()
            End With

            With cmbEstado
                .TextField = "Descripcion"
                .ValueField = "IdEstado"
                .DataSource = objEstados
                .DataBind()
            End With

            'Se cargan las Ciudades
            Dim dtCiudad As DataTable = HerramientasMensajeria.ObtenerCiudadesCem()
            With cmbCiudad
                .DataSource = dtCiudad
                Session("dtCiudades") = .DataSource
                .DataBind()
                If dtCiudad.Rows.Count = 1 Then .SelectedIndex = 0
            End With

            'Gerencias y Ejecutivos
            Dim dvPersonasGerencia As DataView = PersonasGerencia.DefaultView
            dvPersonasGerencia.RowFilter = "idPersona = " & idUsuario.ToString

            If dvPersonasGerencia.Count > 0 Then
                With cmbGerencia
                    .DataSource = dvPersonasGerencia.ToTable()
                    .ValueField = "idGerencia"
                    .TextField = "gerencia"
                    .SelectedIndex = -1
                    .DataBind()
                End With

                With cmbCoordinador
                    .DataSource = dvPersonasGerencia.ToTable()
                    .ValueField = "idPersonaPadre"
                    .TextField = "personaPadre"
                    .SelectedIndex = -1
                    .DataBind()
                End With
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de cargar los filtros:" & ex.Message)
        End Try
    End Sub

    Private Sub PersonalEnGerencia()
        Try
            _PersonasGerencia = HerramientasMensajeria.ObtienePersonalEnGerencia()
            Session("dtPersonasGerencia") = _PersonasGerencia
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

End Class