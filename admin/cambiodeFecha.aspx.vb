Imports System.Data.SqlClient
Imports System.Data
Imports System.Globalization

Partial Class cambiodeFecha
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
            If lblFecha.Text = "" Then
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
                consultaSQL += " factura = @Factura And"
                comando.Parameters.Add("@Factura", SqlDbType.VarChar, 12)
                comando.Parameters("@Factura").Value = factura
            End If

            If serial <> "" Then
                consultaSQL += " Serial = @Serial And"
                comando.Parameters.Add("@Serial", SqlDbType.VarChar, 20)
                comando.Parameters("@Serial").Value = serial
            End If

            If sim <> "" Then
                If sim.StartsWith("89") And sim.Length > 17 Then
                    sim = sim.Substring(2, sim.Length - 2)
                End If
                consultaSQL += " Sim = @Sim And"
                comando.Parameters.Add("@Sim", SqlDbType.VarChar, 20)
                comando.Parameters("@Sim").Value = sim
            End If

            If min <> "" Then
                consultaSQL += " Min = @Min And"
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
                lblPlan.Text = " "
                lblFactura.Text = ""
                lblIdentificacion.Text = ""
                lblNombre.Text = ""
                lblApellidos.Text = ""
                lblFecha.Text = ""
                lblImei.Text = ""
                lblIccid.Text = ""
                lblMin.Text = ""
            End If

            reader.Close()
        Catch ex As Exception
            lblError.Text = ex.Message & ex.StackTrace
        End Try
    End Sub

    Private Sub continuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles continuar.Click
        If Guardar.Value = 1 Then
            Dim consultaSQL As String = "Update Facturas_Postpago Set fecha_venta = @fecha_venta "
            consultaSQL += " Where Upper(factura)=@factura "
            MetodosComunes.inicializarObjetos(Me.conexion, Me.comando, Me.adapter, consultaSQL, True)
            conexion.Open()
            Try
                comando.Parameters.Clear()
                comando.Parameters.Add("@fecha_venta", SqlDbType.SmallDateTime)
                comando.Parameters("@fecha_venta").Value = DateTime.Parse(cpFechaNueva.SelectedDate, cultura)
                comando.Parameters.Add("@factura", SqlDbType.VarChar, 12)
                comando.Parameters("@factura").Value = lblFactura.Text
                comando.CommandText = consultaSQL
                comando.CommandType = CommandType.Text
                If comando.ExecuteNonQuery > 0 Then
                    lblExito.Text = " La fecha de venta de la factura fue actualizada exitosamente "
                    lblFecha.Text = cpFechaNueva.SelectedDate
                Else
                    lblError.Text = "Error: No se pudo realizar el cambio de fecha de venta "
                End If
                conexion.Close()
            Catch ex As Exception
                lblError.Text = ex.Message & ex.StackTrace
            End Try
        End If
    End Sub
End Class
