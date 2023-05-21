Imports System.Data.SqlClient

Partial Class eliminarVentasWB
    Inherits System.Web.UI.Page

    Dim iccid As String
#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents Hidden1 As System.Web.UI.HtmlControls.HtmlInputHidden

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
        Server.ScriptTimeout = 600
        iccid = Request.QueryString("iccid").Trim
        lblError.Text = ""
        btnContinuar.Attributes.Add("onclick", "divImagen.style.display='block'")
        If Not Me.IsPostBack Then
            Try
                getDatosVenta()
            Catch ex As Exception
                lblError.Text = ex.Message & "<br><br>"
            End Try
        End If
    End Sub

    Private Sub getDatosVenta()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String

        sqlSelect = "select factura,idpos,nit_cedula,cliente,cliente2,direccion,"
        sqlSelect += "telefono1, serial, sim, [min],transaccion,fecha_usuario,"
        sqlSelect += "(select rtrim(pos) from pos where idpos = fk.idpos)as pos, "
        sqlSelect += "(select idsubproducto from sims where sim=fk.sim "
        sqlSelect += " and iddespacho is not null and idpos is not null "
        sqlSelect += " union select idSubproducto from DespachosOtrosOperadores "
        sqlSelect += " where serial=fk.sim and idDespacho is not null and idPos is not null "
        sqlSelect += ") as idSubproducto,(select 'sims' from sims where sim=fk.sim "
        sqlSelect += " and iddespacho is not null and idpos is not null "
        sqlSelect += " union select 'doo' from DespachosOtrosOperadores "
        sqlSelect += " where serial=fk.sim and idDespacho is not null and idPos is not null "
        sqlSelect += ") as tablaOrigen from facturas_kits_wb fk where sim = @sim"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@sim", iccid)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                lblFactura.Text = IIf(IsDBNull(sqlRead.GetValue(0)), "", sqlRead.GetValue(0))
                lblIdentificacion.Text = IIf(IsDBNull(sqlRead.GetValue(2)), "", sqlRead.GetValue(2))
                lblNombre.Text = IIf(IsDBNull(sqlRead.GetValue(3)), "", sqlRead.GetValue(3))
                lblApellidos.Text = IIf(IsDBNull(sqlRead.GetValue(4)), "", sqlRead.GetValue(4))
                lblDireccion.Text = IIf(IsDBNull(sqlRead.GetValue(5)), "", sqlRead.GetValue(5))
                lblTelefono1.Text = IIf(IsDBNull(sqlRead.GetValue(6)), "", sqlRead.GetValue(6))
                lblImei.Text = IIf(IsDBNull(sqlRead.GetValue(7)), "", sqlRead.GetValue(7))
                lblIccid.Text = IIf(IsDBNull(sqlRead.GetValue(8)), "", sqlRead.GetValue(8))
                lblMin.Text = IIf(IsDBNull(sqlRead.GetValue(9)), "", sqlRead.GetValue(9))
                lblFecha.Text = IIf(IsDBNull(sqlRead.GetValue(11)), "", sqlRead.GetValue(11))
                lblPos.Text = IIf(IsDBNull(sqlRead.GetValue(12)), "", sqlRead.GetValue(12))
                hTransaccion.Value = IIf(IsDBNull(sqlRead.GetValue(10)), "", sqlRead.GetValue(10))
                hIdPos.Value = IIf(IsDBNull(sqlRead.GetValue(1)), "", sqlRead.GetValue(1))
                hIdSubproducto.Value = IIf(IsDBNull(sqlRead.GetValue(13)), 0, sqlRead.GetValue(13))
                hTablaOrigen.Value = IIf(IsDBNull(sqlRead.GetValue(14)), "sims", sqlRead.GetValue(14))
            Else
                lblError.Text = "No se encontró ninguna Venta asociada a la Sim proporcionada.<br><br>"
                btnContinuar.Enabled = False
            End If
            sqlRead.Close()
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener los datos de la Venta: <br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Function getIdSubproducto(ByRef tablaOrigen As String) As Integer
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String, idSubproducto As Integer = 0

        sqlSelect = "select isnull(idsubproducto,0) as idSubproducto,'sims' "
        sqlSelect += "as origen from sims where sim=@sim and iddespacho is not null "
        sqlSelect += "and idpos is not null union select idSubproducto,'doo' "
        sqlSelect += " as origen from DespachosOtrosOperadores where serial=@sim "
        sqlSelect += " and idDespacho Is Not null And idPos is not null "

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@sim", iccid)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then idSubproducto = sqlRead.GetValue(0)
            sqlRead.Close()
            sqlConexion.Close()
            GC.Collect()
            Return idSubproducto
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener el Subproducto de la Sim:<br>" & ex.Message)
        End Try
    End Function

    Private Function getIdKardex(ByVal idSubproducto As Integer) As Long
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String
        Dim idKardex As Long = 0

        sqlSelect = "select idpos_kardex from pos_kardex where idpos = @idPos "
        sqlSelect += " and idsubproducto = @idSubproducto and "
        sqlSelect += " convert(varchar,fecha,112) = convert(varchar,getdate(),112)"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@idPos", hIdPos.Value)
            sqlComando.Parameters.Add("@idSubproducto", idSubproducto)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then idKardex = sqlRead.GetValue(0)
            sqlRead.Close()
            sqlConexion.Close()
            GC.Collect()
            Return idKardex
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener el último Kardex del Punto:<br>" & ex.Message)
        End Try
    End Function

    Private Function getSaldosUltimoKardex(ByVal idSubproducto As Integer) As Integer
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String, saldo As Integer = 0


        sqlSelect = "select saldo_final from pos_kardex where "
        sqlSelect += "idpos_kardex = (select max(idpos_kardex) from pos_kardex "
        sqlSelect += "where idpos = @idPos and idsubproducto = @idSubproducto)"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@idPos", hIdPos.Value)
            sqlComando.Parameters.Add("@idSubproducto", idSubproducto)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then saldo = sqlRead.GetValue(0)
            sqlRead.Close()
            sqlConexion.Close()
            GC.Collect()
            Return saldo
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener el Saldo del último Kardex del Punto:<br>" & ex.Message)
        End Try
    End Function

    Private Sub eliminarVenta()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlTransaccion As SqlTransaction
        Dim sqlUpdate1, sqlUpdate2, sqlUpdate3, sqlInsert, sqlDelete, sqlQuery As String
        Dim idSubproducto, saldo As Integer, idKardex As Long

        sqlDelete = "delete from facturas_kits_wb where transaccion=@transaccion"
        sqlQuery = "update logVentasWBEliminadas set accion='Eliminacion',idUsuario=@idUsuario where transaccion=@transaccion"
        If hTablaOrigen.Value.ToUpper = "SIMS" Then
            sqlUpdate1 = "update sims set idpos = @idPos where sim = @sim"
        Else
            sqlUpdate1 = "update DespachosOtrosOperadores set idpos = @idPos where serial=@sim"
        End If
        sqlUpdate2 = "update pos_inventario set saldo = saldo + 1 where idpos=@idPos "
        sqlUpdate2 += "and idsubproducto = @idSubproducto"
        sqlUpdate3 = "update pos_kardex set entradas = entradas + 1, "
        sqlUpdate3 += "saldo_final = saldo_final + 1 where idpos_kardex = @idKardex"
        sqlInsert = "insert into pos_kardex (idpos, fecha, idproducto, idsubproducto, "
        sqlInsert += " saldo_inicial, entradas, saldo_final) values (@idPos, getdate(),"
        sqlInsert += " 58, @idSubproducto, @saldoInicial, 1, @saldoFinal)"

        Try
            idSubproducto = CInt(hIdSubproducto.Value) 'getIdSubproducto()
            If idSubproducto <> 0 Then
                idKardex = getIdKardex(idSubproducto)
                If idKardex = 0 Then saldo = getSaldosUltimoKardex(idSubproducto)
                sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
                sqlComando = New SqlCommand(sqlUpdate1, sqlConexion)
                sqlComando.Parameters.Add("@idPos", SqlDbType.Int).Value = hIdPos.Value
                sqlComando.Parameters.Add("@sim", SqlDbType.VarChar, 20).Value = iccid
                sqlComando.Parameters.Add("@transaccion", SqlDbType.BigInt).Value = hTransaccion.Value
                sqlComando.Parameters.Add("@idSubproducto", SqlDbType.Int).Value = idSubproducto
                sqlComando.Parameters.Add("@idUsuario", SqlDbType.Int).Value = Session("usxp001")
                sqlComando.CommandTimeout = 300
                sqlConexion.Open()
                sqlTransaccion = sqlConexion.BeginTransaction
                sqlComando.Transaction = sqlTransaccion
                'Se actualiza el pos de la sim
                sqlComando.ExecuteNonQuery()
                'Se actuaiza el inventario
                sqlComando.CommandText = sqlUpdate2
                sqlComando.ExecuteNonQuery()
                'Se verifica si se debe actualizar el kardex o insertar un nuevo registro
                If idKardex = 0 Then
                    sqlComando.Parameters.Add("@saldoInicial", saldo)
                    sqlComando.Parameters.Add("@saldoFinal", saldo + 1)
                    sqlComando.CommandText = sqlInsert
                Else
                    sqlComando.Parameters.Add("@idKardex", idKardex)
                    sqlComando.CommandText = sqlUpdate3
                End If
                sqlComando.ExecuteNonQuery()
                'Se procede a eliminar la venta
                sqlComando.CommandText = sqlDelete
                sqlComando.ExecuteNonQuery()
                'Por último se actualiza el usuario y el tipo de acción en el Log de Eliminación
                sqlComando.CommandText = sqlQuery
                sqlComando.ExecuteNonQuery()
            Else
                Throw New Exception("No se puede Eliminar la Venta, porque no se encontró el Subproducto asociado a la Sim.")
            End If
            sqlTransaccion.Commit()
        Catch ex As Exception
            If Not sqlTransaccion Is Nothing Then sqlTransaccion.Rollback()
            Throw New Exception("Error al tratar de Eliminar Venta:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        Try
            eliminarVenta()
            Response.Redirect("eliminarVentasWBInicio.aspx?resultado=1", True)
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try
    End Sub
End Class
