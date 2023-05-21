Imports System.Data.SqlClient

Partial Class cambiarFechaVenta2
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

    Dim transaccion As String, tipoVenta As Byte

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Seguridad.verificarSession(Me)
        lblError.Text = ""
        lblRes.Text = ""
        transaccion = Request.QueryString("transaccion")
        tipoVenta = Request.QueryString("tipoVenta")
        btnContinuar.Attributes.Add("onclick", "divImagen.style.display='block'")
        If Not Me.IsPostBack Then
            cpFechaNueva.UpperBoundDate = Now
            Try
                getDatos()
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub getDatos()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String

        sqlSelect = "select factura,nit_cedula,cliente,"
        sqlSelect += "cliente2,serial,sim,[min],convert(varchar,fecha_usuario,103) "
        sqlSelect += "as fecha_usuario,transaccion "

        If tipoVenta = 1 Then ' es una venta KP
            sqlSelect += "from facturas_kits fk "
        Else ' es una venta WB
            sqlSelect += "from facturas_kits_wb fk "
        End If
        sqlSelect += "where transaccion = @transaccion "

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@transaccion", transaccion)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                lblFactura.Text = IIf(IsDBNull(sqlRead.GetValue(0)), "", sqlRead.GetValue(0))
                lblIdentificacion.Text = IIf(IsDBNull(sqlRead.GetValue(1)), "", sqlRead.GetValue(1))
                lblNombre.Text = IIf(IsDBNull(sqlRead.GetValue(2)), "", sqlRead.GetValue(2))
                lblApellidos.Text = IIf(IsDBNull(sqlRead.GetValue(3)), "", sqlRead.GetValue(3))
                lblImei.Text = IIf(IsDBNull(sqlRead.GetValue(4)), "", sqlRead.GetValue(4))
                lblIccid.Text = IIf(IsDBNull(sqlRead.GetValue(5)), "", sqlRead.GetValue(5))
                lblMin.Text = IIf(IsDBNull(sqlRead.GetValue(6)), "", sqlRead.GetValue(6))
                lblFecha.Text = IIf(IsDBNull(sqlRead.GetValue(7)), "", sqlRead.GetValue(7))
                hTransaccion.Value = IIf(IsDBNull(sqlRead.GetValue(8)), "", sqlRead.GetValue(8))
            Else
                sqlRead.Close()
                sqlConexion.Close()
                GC.Collect()
                Response.Redirect("cambiarFechaVenta.aspx?noDatos=si", True)
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener datos:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub cambiarLaFecha()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlUpdate As String

        If tipoVenta = 1 Then
            sqlUpdate = "update facturas_kits "
        Else
            sqlUpdate = "update facturas_kits_wb "
        End If
        sqlUpdate += "set fecha_usuario = @fechaUsuario where transaccion = @transaccion "
        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlUpdate, sqlConexion)
            sqlComando.Parameters.Add("@fechaUsuario", SqlDbType.SmallDateTime).Value = cpFechaNueva.SelectedDate
            sqlComando.Parameters.Add("@transaccion", transaccion)
            sqlConexion.Open()
            sqlComando.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Error al tratar de actualizar Fecha:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        Try
            cambiarLaFecha()
            lblRes.Text = "La Fecha se Actualizó Satisfactoriamente.<br><br>"
            lblFecha.Text = cpFechaNueva.SelectedDate.ToShortDateString
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try
    End Sub
End Class
