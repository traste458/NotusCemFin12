Imports CrystalDecisions.Web
Imports CrystalDecisions.ReportSource
Imports CrystalDecisions.Shared
Imports CrystalDecisions.CrystalReports.Engine
Imports System.IO
Partial Public Class VisorReportes
    Inherits System.Web.UI.Page
    Private reporte As ReporteCrystal

    Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        cargarInicial()
    End Sub
    ''' <summary>
    ''' Interfaz que Carga un reporte previamente diseñado.
    ''' El reporte se carga implementando la clase ReporteCrystal y es recuperada en esta interfáz
    ''' a traves de la variable de sesion ...Session("ReporteCrystal")
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Request.QueryString("rpt") IsNot Nothing Then
                loadAndShow(Request.QueryString("rpt"))
            End If
        End If
    End Sub
    Private Sub cargarInicial()
        Try
            If Not Session("ReporteCrystal") Is Nothing Then
                reporte = Session("ReporteCrystal")
                Me.rptViewer.ReportSource = reporte.reportSource
            End If
        Catch ex As Exception
            lblError.Text = "Error inesperado Cargando Información"
        End Try
    End Sub

    Private Sub loadAndShow(ByVal NombreReporte As String)
        Dim id As String = Request.QueryString("id").ToString
        Dim values As String = Request.QueryString("values").ToString
        Dim arrValues As New ArrayList(values.Split("|"))
        reporte = New ReporteCrystal(NombreReporte, Server.MapPath(Nothing))
        reporte.agregarParametroDiscreto(id, arrValues)
        '****Se verifica si se solicito una reimpresion.
        If Request.QueryString("esReimpresion") IsNot Nothing Then
            If reporte.Parametros.Contains("reimpresion") Then
                reporte.agregarParametroDiscreto("reimpresion", True)
            End If
        End If
        ' reporte.idUsuario = Session("user01")
        Dim var As Int16 = 0
        If Request.QueryString("exp") IsNot Nothing Then
            var = CInt(Request.QueryString("exp"))
            Dim thePath As String = reporte.exportar(var)
            'path = path.Substring(path.LastIndexOf("\") + 1)
            If Request.QueryString("fromVB") IsNot Nothing Then
                Response.Redirect("rptTemp/" & Path.GetFileName(thePath), True)
            Else
                ' descargarArchivo(thePath, HttpContext.Current)
            End If
            'ClientScript.RegisterStartupScript(Me.GetType, "newWindow", "window.open ( '" & Server.MapPath(Nothing) & "\rptTemp\" & Path & "','Visor de Reportes  ', 'status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1'); ", True)
        End If
        Session("ReporteCrystal") = reporte
        Me.rptViewer.ReportSource = reporte.reportSource
    End Sub

End Class