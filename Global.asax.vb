Imports System.Web
Imports System.Web.SessionState

Public Class [Global]
    Inherits System.Web.HttpApplication

#Region " Component Designer Generated Code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Required by the Component Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Component Designer
    'It can be modified using the Component Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        components = New System.ComponentModel.Container()
    End Sub

#End Region

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application is started
        'Dim dirPath As String = Server.MapPath("~")
        'Dim cont As Integer
        'cont = MetodosComunes.CambiarCodificacionDeArchivos(dirPath, "*.aspx", IO.SearchOption.AllDirectories)
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session is started
        If Session IsNot Nothing Then
            For index As Integer = 0 To Session.Count - 1
                If Session(index) IsNot Nothing AndAlso TypeOf Session(index) Is CrystalDecisions.CrystalReports.Engine.ReportDocument Then
                    With CType(Session(index), CrystalDecisions.CrystalReports.Engine.ReportDocument)
                        .Close()
                        .Dispose()
                    End With
                End If
            Next
        End If
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires at the beginning of each request
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when an error occurs
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session ends
        If Session IsNot Nothing Then
            For index As Integer = 0 To Session.Count - 1
                If Session(index) IsNot Nothing AndAlso TypeOf Session(index) Is CrystalDecisions.CrystalReports.Engine.ReportDocument Then
                    With CType(Session(index), CrystalDecisions.CrystalReports.Engine.ReportDocument)
                        .Close()
                        .Dispose()
                    End With
                End If
            Next
        End If
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application ends
        If Session IsNot Nothing Then
            For index As Integer = 0 To Session.Count - 1
                If Session(index) IsNot Nothing AndAlso TypeOf Session(index) Is CrystalDecisions.CrystalReports.Engine.ReportDocument Then
                    With CType(Session(index), CrystalDecisions.CrystalReports.Engine.ReportDocument)
                        .Close()
                        .Dispose()
                    End With
                End If
            Next
            Session.RemoveAll()
        End If
    End Sub

End Class
