Imports System.Data.SqlClient
Imports System.IO

Partial Class InicioReporteRemision
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents pnlConsultar As Anthem.Panel

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
        hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)

    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        Dim remisiones As New System.Text.StringBuilder
        Try
            If txtRemision.Text <> "" Then
                If IsNumeric(txtRemision.Text.Trim) Then
                    remisiones.Append(CLng(txtRemision.Text.Trim).ToString)
                Else
                    Throw New Exception("El valor de la remisión no es numérico")
                End If

            End If
            If archivosRemisiones.Value <> "" Then
                With remisiones
                    If .Length <> 0 Then .Append(",")
                    .Append(cargarArchivo())
                End With
                
            End If
            Session("remisiones") = remisiones.ToString
            Response.Redirect("ReporteRemision.aspx?fechaInicial=" & fechaInicial.Value & "&fechaFinal=" & fechaFinal.Value, True)
        Catch ex As Exception
            lblError.Text = "Error: " & ex.Message
        End Try
    End Sub

    Function cargarArchivo() As String
        Dim lectorArchivo As StreamReader, archivo As String, informacion As New System.Text.StringBuilder
        Dim cadena As String, intCadena As Integer = 0
        Try
            If System.IO.Path.GetExtension(archivosRemisiones.PostedFile.FileName).ToLower = ".txt" Then
                archivo = Server.MapPath("..\archivos_planos\remisionesConsulta" & Session("usxp001") & ".txt")
                archivosRemisiones.PostedFile.SaveAs(archivo)
                lectorArchivo = File.OpenText(archivo)
                While lectorArchivo.Peek >= 0
                    cadena = lectorArchivo.ReadLine.Trim
                    If InStr(cadena, ",") > 0 Or InStr(cadena, "|") > 0 Or InStr(cadena, vbTab) > 0 Then
                        Throw New Exception("el archivo no tiene el formato correcto")
                    Else
                        If IsNumeric(cadena) = True Then
                            intCadena = Integer.Parse(cadena)
                            informacion.Append(intCadena.ToString & ",")
                        Else
                            Throw New Exception(" la remisón: " & cadena & " no es numérico")
                        End If
                    End If
                End While
                lectorArchivo.Close()
                Return informacion.ToString.Substring(0, informacion.ToString.Length - 1)
            Else
                Throw New Exception("este no corresponde a una archivo de texto")
            End If
        Catch ex As Exception
            Throw New Exception(" Al cargar los datos del Archivo plano " & ex.Message)
        Finally
            If Not lectorArchivo Is Nothing Then lectorArchivo.Close()
        End Try

    End Function
End Class
