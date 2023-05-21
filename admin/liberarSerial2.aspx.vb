Imports System.Data.SqlClient

Partial Class liberarSerial2
    Inherits System.Web.UI.Page

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

    Dim serial As String, tipo As Integer

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Seguridad.verificarSession(Me)
        lblError.Text = ""
        serial = Request.QueryString("serial").Trim
        tipo = Request.QueryString("tipo")
        If Not Me.IsPostBack Then
            Try
                getDatos()
            Catch ex As Exception
                lblError.Text = ex.Message & "<br><br>"
            End Try
        End If
    End Sub

    Private Sub getDatos()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String

        sqlSelect = "select serial,sim,(select rtrim(pos) from pos where idpos=sr.idpos) as pos,"
        sqlSelect += "(select rtrim(tipo) from tipos where idtipo = sr.idtipo) as siniestro,"
        sqlSelect += "case when idestado = 0 then 'REPORTADO' else 'LIBERADO' end as estado,"
        sqlSelect += "convert(varchar,fecha,103) as fechas,idserial_reportado "
        sqlSelect += "from seriales_reportados sr where "
        If tipo = 1 Then
            sqlSelect += " serial = @serial "
        Else
            sqlSelect += " sim = @serial "
        End If

        sqlSelect += " Order by Fecha desc "

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@serial", serial)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                If tipo = 1 Then
                    lblSerial.Text = IIf(IsDBNull(sqlRead.GetValue(0)), "", sqlRead.GetValue(0))
                Else
                    lblSerial.Text = IIf(IsDBNull(sqlRead.GetValue(1)), "", sqlRead.GetValue(1))
                End If
                lblPOS.Text = IIf(IsDBNull(sqlRead.GetValue(2)), "", sqlRead.GetValue(2))
                lblSiniestro.Text = IIf(IsDBNull(sqlRead.GetValue(3)), "", sqlRead.GetValue(3))
                lblEstado.Text = IIf(IsDBNull(sqlRead.GetValue(4)), "", sqlRead.GetValue(4))
                lblFecha.Text = IIf(IsDBNull(sqlRead.GetValue(5)), "", sqlRead.GetValue(5))
                hIdSerialReportado.Value = sqlRead.GetValue(6)
                If lblEstado.Text = "LIBERADO" Then btnLiberar.Enabled = False
            Else
                lblError.Text = "El Serial no se encuentra registrado como Reportado<br><br>"
                btnLiberar.Enabled = False
            End If
            sqlRead.Close()
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener la información del Serial:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub liberar()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlUpdate As String

        sqlUpdate = "update seriales_reportados set idestado = 1 where "
        sqlUpdate += "idserial_reportado = @idSerialReportado"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlUpdate, sqlConexion)
            sqlComando.Parameters.Add("@idSerialReportado", hIdSerialReportado.Value)
            sqlConexion.Open()
            sqlComando.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("")
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub btnLiberar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLiberar.Click
        Try
            liberar()
            Response.Redirect("liberarSerial.aspx?resultado=1", True)
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try
    End Sub
End Class
