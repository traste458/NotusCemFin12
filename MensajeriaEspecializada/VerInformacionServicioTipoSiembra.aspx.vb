Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Web.UI.HtmlControls
Imports DevExpress.Web
Imports System.IO

Public Class VerInformacionServicioTipoSiembra
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim idServicio As Integer
        Try
            Seguridad.verificarSession(Me)
            miEncabezado.clear()

            If Not IsPostBack And Not IsCallback Then
                Dim idUsuario As Integer = 0
                If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)
                If Request.QueryString("idServicio") IsNot Nothing Then Integer.TryParse(Request.QueryString("idServicio").ToString, idServicio)
                If idServicio > 0 Then
                    With miEncabezado
                        .setTitle("Información Servicio SIEMBRA: " + idServicio.ToString())
                    End With

                    Dim link As HtmlImage = DirectCast(Me.FindControl("imgImprimir"), HtmlImage)
                    link.Attributes.Add("onclick", "VerImpresion(" & idServicio.ToString() & ")")

                    CargarInformacionServicio(idServicio)
                    CargarHistoricoCambioEstado(idServicio, idUsuario)
                Else
                    miEncabezado.showWarning("Imposible recuperar el identificador del servicio. Por favor retorne a la página anterior.")
                End If
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error inesperado al tratar de obtener información del servicio: " & ex.Message)
        End Try
    End Sub

    Private Sub gvMins_DataBinding(sender As Object, e As System.EventArgs) Handles gvMins.DataBinding
        If Session("objMins") IsNot Nothing Then gvMins.DataSource = Session("objMins")
    End Sub

    Private Sub gvReferencias_DataBinding(sender As Object, e As System.EventArgs) Handles gvReferencias.DataBinding
        If Session("objReferencias") IsNot Nothing Then gvReferencias.DataSource = Session("objReferencias")
    End Sub

    Private Sub gvRutas_DataBinding(sender As Object, e As System.EventArgs) Handles gvRutas.DataBinding
        If Session("dtRutas") IsNot Nothing Then gvRutas.DataSource = Session("dtRutas")
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim extensionArchivo As String
        Try
            Dim linkVer As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkVer.NamingContainer, GridViewDataItemTemplateContainer)

            extensionArchivo = Path.GetExtension(CStr(gvDocumentos.GetRowValuesByKeyValue(templateContainer.KeyValue, "NombreArchivo"))).ToLower()

            'Link de Visualización de Archivo
            With linkVer
                .ClientSideEvents.Click = .ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

                Select Case extensionArchivo
                    Case ".pdf"
                        .ImageUrl = "~/images/pdf.png"
                    Case ".jpg", ".tiff"
                        .ImageUrl = "~/images/Paint.gif"
                    Case Else
                        .ImageUrl = "~/images/view.png"
                End Select
            End With
        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

    Private Sub gvDocumentos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDocumentos.DataBinding
        If Session("objDatosDocu") IsNot Nothing Then gvDocumentos.DataSource = Session("objDatosDocu")
    End Sub

    Private Sub gvAgendamientos_DataBinding(sender As Object, e As EventArgs) Handles gvAgendamientos.DataBinding
        If Session("objAgenda") IsNot Nothing Then gvAgendamientos.DataSource = Session("objAgenda")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarInformacionServicio(idServicio As Integer)
        Try
            Dim objServicio As New ServicioMensajeriaSiembra(idServicio:=idServicio)
            esEncabezado.CargarInformacionGeneralServicio(objServicio)

            With gvMins
                .DataSource = objServicio.MinsColeccion
                Session("objMins") = .DataSource
                .DataBind()
            End With

            With gvReferencias
                .DataSource = objServicio.ReferenciasColeccion
                Session("objReferencias") = .DataSource
                .DataBind()
            End With

            With gvRutas
                .DataSource = objServicio.InformacionRutas()
                Session("dtRutas") = .DataSource
                .DataBind()
            End With

            EnlazarDocumentos(idServicio)
            EnlazarHistorialAgenda(idServicio)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub EnlazarDocumentos(idServicio As Integer)
        Try
            Dim objDocumentos As New DocumentoServicioMensajeriaColeccion()
            With objDocumentos
                .IdServicio = idServicio
                .CargarDatos()
            End With

            With gvDocumentos
                .DataSource = objDocumentos
                Session("objDatosDocu") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar los documentos: " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarHistorialAgenda(idServicio As Integer)
        Try
            Dim dtHistorial As DataTable = HerramientasMensajeria.ConsultarHistorialReagenda(idServicio)
            With gvAgendamientos
                .DataSource = dtHistorial
                Session("objAgenda") = .DataSource
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Se generó un error inesperado al intentar cargar los documentos: " & ex.Message)
        End Try
    End Sub
    Private Sub CargarHistoricoCambioEstado(ByVal idServicio As Integer, ByVal idUsuario As Integer)
        Try
            Dim dtCambioEstado As DataTable = HerramientasMensajeria.ConsultarHistorialCambioEstado(idServicio, idUsuario)
            With gvCambioEstado
                .DataSource = dtCambioEstado
                .DataBind()
            End With
        Catch ex As Exception
            miEncabezado.showError("Error al tratar de obtener el historial de cambio de estado. " & ex.Message)
        End Try
    End Sub
#End Region

End Class