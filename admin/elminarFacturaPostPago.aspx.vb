Imports System.Data.SqlClient
Imports System.Data
Imports System.Globalization

Partial Class elminarFacturaPostPago
    Inherits System.Web.UI.Page
    Private conexion As SqlConnection
    Private comando As SqlCommand
    Private adapter As SqlDataAdapter
    Private factura As String
    Private serial As String
    Private sim As String
    Private min As String
    Private Plan As String
    Private cultura As CultureInfo

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents txtSerial As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtSim As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtFactura As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtMin As System.Web.UI.WebControls.TextBox
    Protected WithEvents rblTipoCambio As System.Web.UI.WebControls.RadioButtonList

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
        Dim dtPlanes As New DataTable
        Dim cadenaTemporal As String
        cultura = New CultureInfo("es-Es")
        lblError.Text = ""
        lblExito.Text = ""
        hlRegresar.NavigateUrl = "cambiosFacturaPostPago.aspx"
        continuar.Attributes.Add("Onclick", "javascript:validacion()")
        If Not Page.IsPostBack Then
            MetodosComunes.inicializarObjetos(Me.conexion, Me.comando, Me.adapter, "", True)
            serial = Request.Form.Item("txtSerial")
            sim = Request.Form.Item("txtSim")
            min = Request.Form.Item("txtmin")
            factura = Request.Form.Item("txtfactura")
            conexion.Open()
            obtenerInfo()
            cadenaTemporal = lblFactura.Text & "."
            If cadenaTemporal.CompareTo(".") = 0 Then
                lblError.Text = " Error: No existe una factura con estas caracteristicas "
            End If
            conexion.Close()
        End If
    End Sub
    Private Function verificarDatoDb(ByVal Dato) As String
        If IsDBNull(Dato) Then
            Return ("")
        Else
            Return (Dato.ToString)
        End If
    End Function

    Private Sub obtenerInfo()
        Dim consultaSQL As String
        Dim reader As SqlDataReader

        consultaSQL = " Select Top 1 (Select [Plan]+' - '+tipo From Planes where idPlan = FP.idPlan ) ,idVenta,nit_cedula,nombres,apellidos,convert(varchar,fecha_venta,103),serial,sim,min,factura"
        consultaSQL += " From Facturas_postpago FP Where "
        comando.Parameters.Clear()

        Try
            If factura <> "" Then
                consultaSQL += " ltrim(rtrim(factura)) = @Factura And"
                comando.Parameters.Add("@Factura", SqlDbType.VarChar, 12)
                comando.Parameters("@Factura").Value = factura
            End If

            If serial <> "" Then
                consultaSQL += " rtrim(ltrim(Serial)) = @Serial And"
                comando.Parameters.Add("@Serial", SqlDbType.VarChar, 20)
                comando.Parameters("@Serial").Value = serial
            End If

            If sim <> "" Then
                If sim.StartsWith("89") And sim.Length > 17 Then
                    sim = sim.Substring(2, sim.Length - 2)
                End If
                consultaSQL += " ltrim(rtrim(Sim)) = @Sim And"
                comando.Parameters.Add("@Sim", SqlDbType.VarChar, 20)
                comando.Parameters("@Sim").Value = sim
            End If

            If min <> "" Then
                consultaSQL += " ltrim(rtrim(Min)) = @Min And"
                comando.Parameters.Add("@Min", SqlDbType.VarChar, 20)
                comando.Parameters("@Min").Value = min
            End If

            If consultaSQL.EndsWith("And") Then
                consultaSQL = consultaSQL.Substring(0, consultaSQL.Length - 3)
            End If

            consultaSQL += " Order by fecha_venta desc "
            comando.CommandText = consultaSQL
            comando.CommandType = CommandType.Text
            reader = comando.ExecuteReader

            If reader.Read() Then
                lblPlan.Text = verificarDatoDb(reader.GetValue(0))
                lblFactura.Text = verificarDatoDb(reader.GetValue(9)).ToUpper
                lblIdentificacion.Text = verificarDatoDb(reader.GetValue(2))
                lblNombre.Text = verificarDatoDb(reader.GetValue(3))
                lblApellidos.Text = verificarDatoDb(reader.GetValue(4))
                lblFecha.Text = verificarDatoDb(reader.GetValue(5))
                lblImei.Text = verificarDatoDb(reader.GetValue(6))
                lblIccid.Text = verificarDatoDb(reader.GetValue(7))
                lblMin.Text = verificarDatoDb(reader.GetValue(8))
            Else
                lblPlan.Text = ""
                lblFactura.Text = ""
                lblIdentificacion.Text = ""
                lblNombre.Text = ""
                lblApellidos.Text = ""
                lblFecha.Text = ""
                lblImei.Text = ""
                lblIccid.Text = ""
                lblMin.Text = ""
            End If

        Catch ex As Exception
            lblError.Text = ex.Message & ex.StackTrace
        Finally
            If Not reader Is Nothing Then
                reader.Close()
            End If
            If Not comando Is Nothing Then
                comando.Dispose()
            End If
            If Not conexion Is Nothing Then
                conexion.Close()
            End If
        End Try
    End Sub

    Private Sub continuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles continuar.Click
        If Guardar.Value = 1 Then
            Dim consultaSQL As String = "sp_elminarFacturaPostPago"

            MetodosComunes.inicializarObjetos(Me.conexion, Me.comando, Me.adapter, consultaSQL, True)
            conexion.Open()
            Try
                comando.Parameters.Clear()
                comando.Parameters.Add("@serial", SqlDbType.VarChar, 20)
                comando.Parameters("@serial").Value = lblImei.Text
                comando.Parameters.Add("@sim", SqlDbType.VarChar, 20)
                comando.Parameters("@sim").Value = lblIccid.Text
                comando.CommandText = consultaSQL
                comando.CommandType = CommandType.StoredProcedure
                comando.Transaction = conexion.BeginTransaction
                If comando.ExecuteScalar() = 1 Then
                    comando.Parameters.Clear()
                    comando.Parameters.Add("@accion", SqlDbType.VarChar, 200)
                    comando.Parameters.Add("@usuario", SqlDbType.BigInt)
                    comando.Parameters.Add("@fecha", SqlDbType.SmallDateTime)
                    comando.Parameters.Add("@Factura", SqlDbType.VarChar, 12)
                    comando.Parameters.Add("@Serial", SqlDbType.VarChar, 20)
                    comando.Parameters.Add("@Sim", SqlDbType.VarChar, 20)
                    comando.Parameters.Add("@Min", SqlDbType.VarChar, 20)
                    comando.CommandType = CommandType.Text
                    comando.CommandText = "Insert Into logFacturasPostPago values (@accion,@usuario,@fecha,@Factura,@Serial,@Sim,@Min) "
                    comando.Parameters("@accion").Value = " Eliminación "
                    comando.Parameters("@usuario").Value = Session.Item("usxp001")
                    comando.Parameters("@fecha").Value = DateTime.Parse(Now.ToString("dd/MM/yyyy hh:mm:ss"), cultura)
                    comando.Parameters("@Factura").Value = lblFactura.Text
                    comando.Parameters("@serial").Value = lblImei.Text
                    comando.Parameters("@sim").Value = lblIccid.Text
                    comando.Parameters("@min").Value = lblMin.Text
                    comando.ExecuteNonQuery()
                    comando.Transaction.Commit()
                    lblExito.Text = " La factura fue eliminada exitosamente "
                Else
                    lblError.Text = "Error: No se pudo eliminar la factura "
                    If Not comando.Transaction Is Nothing Then
                        comando.Transaction.Rollback()
                    End If
                End If
            Catch ex As Exception
                If Not comando.Transaction Is Nothing Then
                    comando.Transaction.Rollback()
                End If
                lblError.Text = ex.Message & ex.StackTrace
            End Try
            conexion.Close()
        End If
    End Sub
End Class
