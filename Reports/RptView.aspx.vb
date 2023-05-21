Imports CrystalDecisions.Web
Imports CrystalDecisions.ReportSource
Imports CrystalDecisions.Shared
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.CrystalReports.TSLV
Imports System.Collections.Specialized
Imports System.IO

Partial Class RptView
    Inherits System.Web.UI.Page
    Dim rpt As New ReportDocument
    Dim valorparametro As New ParameterDiscreteValue

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub


    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
        Try
            Seguridad.verificarSession(Me)
            If Not IsPostBack Or Session("reporte") Is Nothing Then
                If Request.QueryString("regresar") <> "" Then
                    hlRegresar.NavigateUrl = Request.QueryString("regresar")
                Else
                    hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
                End If
                If Not Request.QueryString("rpt") Is Nothing Then

                    Dim nombreRPT As String = Request.QueryString("rpt")
                    rpt = New ReportDocument
                    rpt.Load(Server.MapPath("../reports/" & nombreRPT & ".rpt"))
                    If Not Session("dtsReport") Is Nothing Then
                        Dim ds As DataSet = Session("dtsReport")
                        '   rpt.SetDatabaseLogon(ConfigurationManager.AppSettings("UserDB"), ConfigurationManager.AppSettings("PassDB"), ConfigurationManager.AppSettings("ServerDB"), ConfigurationManager.AppSettings("Database"))
                        rpt.SetDataSource(ds)
                        Me.rptViewer.ReportSource = rpt
                        Session("reporte") = rpt
                        Me.rptViewer.DataBind()
                        btnExportar.Enabled = True
                        'Session("dtsReport") = Nothing
                        ddlExportar.Items.Add(New ListItem("PDF", "5"))
                        ddlExportar.Items.Add(New ListItem("Excel", "4"))
                        ddlExportar.Items.Add(New ListItem("Word", "3"))
                        If Not Request.QueryString("exp") Is Nothing Then
                            ddlExportar.SelectedValue = Request.QueryString("exp")
                            exportar(Request.QueryString("exp"))
                        End If
                        If Request.QueryString("Respuesta") <> "" Then
                            lblRes.Text = Request.QueryString("Respuesta")
                        End If
                    Else
                        lblError.Text = "Error de Session"
                    End If
                End If
            Else
                rpt = Session("reporte")
                Me.rptViewer.ReportSource = rpt
                Me.rptViewer.DataBind()
            End If
        Catch ex As Exception
            lblError.Text = ex.Message
        End Try
    End Sub

    Private Sub btnExportar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExportar.Click
        exportar(ddlExportar.SelectedValue)
    End Sub

    Public Sub exportar(ByVal exp As Integer)
        Dim exportFileName As String = Request.QueryString("rpt")
        Dim exportPath As String
        Dim crExportOptions As ExportOptions
        Dim crDestOptions As New DiskFileDestinationOptions
        Try
            Select Case exp
                Case 5
                    exportFileName += ".pdf"
                Case 4
                    exportFileName += ".xls"
                Case 3
                    exportFileName += ".doc"
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select
            exportFileName = Session("usxp001").ToString & exportFileName
            exportPath = Server.MapPath("../archivos_planos/" & exportFileName)
            crDestOptions.DiskFileName = exportPath
            rpt = Session("reporte")
            'Session("reporte") = Nothing
            crExportOptions = rpt.ExportOptions
            crExportOptions.DestinationOptions = crDestOptions
            crExportOptions.ExportDestinationType = ExportDestinationType.DiskFile
            crExportOptions.ExportFormatType = ddlExportar.SelectedValue
            rpt.Export()

            If File.Exists(exportPath) Then
                Response.Clear()
                Response.ContentType = "application/octet-stream"
                Response.AddHeader("Content-Disposition", "attachment; filename=" & exportFileName)
                Response.Flush()
                Response.WriteFile(exportPath)
                Response.End()
            End If
        Catch tEx As System.Threading.ThreadAbortException
        Catch ex As Exception
            lblError.Text = "<br>Ha ocurrido un error inesperado. " & ex.Message
        End Try
    End Sub

End Class
