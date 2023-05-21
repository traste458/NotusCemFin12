Imports System.Data.SqlClient

Partial Class cambiarFechaVenta
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

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Seguridad.verificarSession(Me)
        lblError.Text = ""
        hlRegresar.NavigateUrl = "../frames_back.asp?idmenu=" & Session("idmenu") & "&posicion=" & Session("posicion")
    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        Dim url As String, transaccion As Long
        Try
            transaccion = getTransaccion()
            If transaccion <> 0 Then
                url = "cambiarFechaVenta2.aspx?transaccion=" & transaccion.ToString
                url += "&tipoVenta=" & rblTipoVenta.SelectedValue
                Response.Redirect(url, True)
            Else
                lblError.Text = "No se encontró ninguna Venta con las características solicitadas.<br><br>"
            End If
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try
    End Sub

    Private Function getTransaccion() As Long
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String
        Dim resultado As Long = 0

        sqlSelect = "select transaccion "
        If rblTipoVenta.SelectedValue = 1 Then ' es una venta KP
            sqlSelect += "from facturas_kits fk where transaccion is not null "
        Else ' es una venta WB
            sqlSelect += "from facturas_kits_wb fk where transaccion is not null "
        End If
        If txtSerial.Text.Trim <> "" Then sqlSelect += "and serial = @serial "
        If txtSim.Text.Trim <> "" Then sqlSelect += "and sim = @sim "
        If txtFactura.Text.Trim <> "" Then sqlSelect += "and factura = @factura"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@serial", txtSerial.Text.Trim)
            sqlComando.Parameters.Add("@sim", txtSim.Text.Trim)
            sqlComando.Parameters.Add("@factura", txtFactura.Text.Trim)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                resultado = sqlRead.GetValue(0)
            End If
            sqlRead.Close()
            sqlConexion.Close()
            GC.Collect()
            Return resultado
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener los Datos de la Venta:<br>" & ex.Message)
        End Try
    End Function

End Class
