Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.IO
Imports ILSBusinessLayer.Comunes
Imports System.Collections.Generic

Partial Public Class ConsultaSeriales
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _altoVentana As Integer
    Private _anchoVentana As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.ValidarSesion(EO.Web.CallbackPanel.Current)
        epNotificacion.clear()
        ObtenerTamanoVentana()

        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Consulta de Seriales")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))

                    EstableceExpresionSerial()
                End With
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
    End Sub

    Private Sub lbLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbLimpiar.Click
        LimpiarFiltro()
    End Sub

    Private Sub lbConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbConsultar.Click
        Consultar()
    End Sub

    Private Sub gvDatos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatos.PageIndexChanging
        Try
            Dim dtDatos As DataTable = DirectCast(Session("dtDatos"), DataTable)
            gvDatos.PageIndex = e.NewPageIndex
            EnlazarDatos(dtDatos)
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de paginar: " & ex.Message)
        End Try
    End Sub

    Private Sub lbExportar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbExportar.Click
        ExportarDatos()
    End Sub

    Private Sub gvDatos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatos.RowCommand
        Dim idServicio As Integer
        Integer.TryParse(e.CommandArgument.ToString, idServicio)

        Select Case e.CommandName
            Case "ver"
                With dlgVerInformacionServicio
                    .Width = Unit.Pixel(Me._anchoVentana * 0.95)
                    .Height = Unit.Pixel(Me._altoVentana * 0.93)
                    .ContentUrl = "VerInformacionServicio.aspx?idServicio=" & idServicio.ToString
                    .Show()
                End With
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
    End Sub

#End Region

#Region "Médotos Privados"

    Private Sub LimpiarFiltro()
        Try
            txtSeriales.Text = String.Empty
            Session.Remove("dtDatos")
            EnlazarDatos(New DataTable())
        Catch ex As Exception
            epNotificacion.showError("Error al limpiar filtros: " & ex.Message)
        End Try
    End Sub

    Private Sub Consultar()
        Dim dtDatos As New DataTable
        Dim tamanoParticion As Integer = 400
        Dim particiones As Integer = 0

        Try
            Dim arrSeriales As New ArrayList(txtSeriales.Text.Split(New [Char]() {ControlChars.Lf, ControlChars.Cr}, StringSplitOptions.RemoveEmptyEntries))
            particiones = Math.Ceiling((arrSeriales.Count / tamanoParticion))

            For i As Integer = 0 To particiones - 1 Step 1
                Dim arrParticion As ArrayList
                If i <> particiones - 1 Then
                    arrParticion = arrSeriales.GetRange(i * tamanoParticion, tamanoParticion)
                Else
                    arrParticion = arrSeriales.GetRange(i * tamanoParticion, arrSeriales.Count - i * tamanoParticion)
                End If
                HerramientasMensajeria.ObtenerInformacionSeriales(dtDatos, arrParticion)
            Next

            If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                EnlazarDatos(dtDatos)
            Else
                epNotificacion.showWarning("<i>No se encontraron resultados.</i>")
            End If
            Session("dtDatos") = dtDatos
        Catch ex As Exception
            epNotificacion.showError("Error al consultar seriales: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            epNotificacion.showError("Se generó error al enlazar datos: " & ex.Message)
        End Try
    End Sub

    Private Sub ExportarDatos()
        Try
            Dim nombreArchivo As String = "ConsultaSeriales.xls"
            Dim RutaRelativa As String = "../MensajeriaEspecializada/Reportes/" & nombreArchivo & ""

            If Not Directory.Exists(Path.GetDirectoryName(Server.MapPath("Reportes\") & nombreArchivo)) Then
                Throw New Exception("No existe el directorio de almacenamiento de reportes.")
            End If

            If Session("dtDatos") IsNot Nothing Then
                Dim dtDatos As DataTable = DirectCast(Session("dtDatos"), DataTable).DefaultView.ToTable(False, _
                    "serial", "EstadoInventario", "Material", "DescripcionMaterial", "Bodega", "numeroRadicado", "EstadoRadicado")

                Dim arrayNombre As New ArrayList
                With arrayNombre
                    .Add("SERIAL")
                    .Add("ESTADO INVENTARIO")
                    .Add("MATERIAL")
                    .Add("DESCRIPCIÓN MATERIAL")
                    .Add("BODEGA")
                    .Add("No RADICADO")
                    .Add("ESTADO RADICADO")
                End With

                HerramientasMensajeria.exportarDatosAExcelGemBox(HttpContext.Current, dtDatos, Server.MapPath("Reportes\") & nombreArchivo, arrayNombre, True)
                Response.Redirect(RutaRelativa, True)
            Else
                epNotificacion.showWarning("No se encontraron datos disponibles para exportar.")
            End If
        Catch ex As Exception
            epNotificacion.showError("Se generó error al tratar de exportar: " & ex.Message)
        End Try
    End Sub

    Private Sub ObtenerTamanoVentana()
        If hfMedidasVentana.Value <> "" Then
            Dim arrAux() As String = hfMedidasVentana.Value.Split(";")
            If arrAux.Length = 2 Then
                Me._altoVentana = CInt(arrAux(0))
                Me._anchoVentana = CInt(arrAux(1))
            End If
        End If
        If Me._altoVentana = 0 Then Me._altoVentana = 600
        If Me._anchoVentana = 0 Then Me._anchoVentana = 800
    End Sub

    Private Sub EstableceExpresionSerial()
        Dim listExpresion As New List(Of String)

        Dim objConfigSerial As New ConfiguracionLecturaSerialColeccion()
        With objConfigSerial
            .CargarDatos()
        End With

        If objConfigSerial.Count > 0 Then
            For Each configSerial As ConfiguracionLecturaSerial In objConfigSerial
                listExpresion.Add("(" & configSerial.CaracterPermitido.Replace("+", String.Empty) & "{" & configSerial.Longitud & "}" & ")")
            Next
            hfRegexSerial.Value = String.Join("|", listExpresion.ConvertAll(Of String)(Function(x) x.ToString()).ToArray())
        End If
    End Sub

#End Region

End Class