Imports System.Data.SqlClient

Partial Class liberarMinDeFactura
    Inherits System.Web.UI.Page

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
        lblError.Text = ""
        lblRes.Text = ""
        If Not Me.IsPostBack Then
            hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
        End If
    End Sub

    Private Sub consultarMIN()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlRead As SqlDataReader
        Dim sqlSelect As New System.Text.StringBuilder

        sqlSelect.Append("select rtrim(factura) as factura,rtrim(serial) as serial,rtrim(sim) as sim,rtrim([min]) as [min], ")
        sqlSelect.Append("  'KIT PREPAGO' as tipoFactura,(select pos from pos where idpos=fk.idpos) as pos,convert(varchar,fecha_usuario,103) ")
        sqlSelect.Append("  as fechaVenta,transaccion from facturas_kits fk where [min] = @min ")
        sqlSelect.Append(" union ")
        sqlSelect.Append("select rtrim(factura) as factura,rtrim(serial) as serial,rtrim(sim) as sim,rtrim([min]) as [min], ")
        sqlSelect.Append("  'WELCOME BACK' as tipoFactura,(select pos from pos where idpos=fkw.idpos) as pos,convert(varchar,fecha_usuario,103) ")
        sqlSelect.Append("  as fechaVenta,transaccion from facturas_kits_wb fkw where [min] = @min ")
        sqlSelect.Append("  union ")
        sqlSelect.Append("select rtrim(factura) as factura,rtrim(serial) as serial,rtrim(sim) as sim,rtrim([min]) as [min], ")
        sqlSelect.Append(" 'POSTPAGO' as tipoFactura,(select pos from pos where idpos=fp.idpos) as pos,convert(varchar,fecha_venta,103) ")
        sqlSelect.Append("  as fechaVenta,idventa as transaccion from facturas_postpago fp where [min] = @min")

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlSelect.ToString)
            sqlComando.Parameters.Add("@min", SqlDbType.VarChar, 10).Value = txtMin.Text.Trim
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                pnlDatos.Visible = True
                With sqlRead
                    lblFactura.Text = .GetValue(0).ToString
                    lblSerial.Text = .GetValue(1).ToString
                    lblSim.Text = .GetValue(2).ToString
                    lblMin.Text = .GetValue(3).ToString
                    lblTipoFactura.Text = .GetValue(4).ToString
                    lblPos.Text = .GetValue(5).ToString
                    lblFechaVenta.Text = .GetValue(6).ToString
                    hTransaccion.Value = .GetValue(7).ToString
                    .Close()
                End With
            Else
                pnlDatos.Visible = False
                lblError.Text = "No se encontró ninguna Factura asociada al MSISDN proporcionado.<br><br>"
            End If

        Catch ex As Exception
            lblError.Text = "Error al tratar de consultar el MSISDN. " & ex.Message & "<br><br>"
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub

    Private Sub btnContinuar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        consultarMIN()
    End Sub

    Private Sub liberarMIN()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlTransaccion As SqlTransaction
        Dim sqlUpdate, sqlQuery, tipoFac As String

        Select Case lblTipoFactura.Text
            Case "KIT PREPAGO"
                sqlUpdate = "update facturas_kits set [min]=null where transaccion=@transaccion and [min]=@min"
                tipoFac = "KIT"
            Case "WELCOME BACK"
                sqlUpdate = "update facturas_kits_wb set [min]=null where transaccion=@transaccion and [min]=@min"
                tipoFac = "WB"
            Case "POSTPAGO"
                sqlUpdate = "update facturas_postpago set [min]=null where idventa=@transaccion and [min]=@min"
                tipoFac = "PP"
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select

        sqlQuery = "update LogFacturasConMinLiberado set idUsuario=@idUsuario where factura=@factura and transaccion=@transaccion and tipoFactura=@tipoFactura"

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlUpdate)
            sqlComando.Parameters.Add("@transaccion", SqlDbType.Int).Value = hTransaccion.Value
            sqlComando.Parameters.Add("@min", SqlDbType.VarChar, 10).Value = lblMin.Text.Trim
            sqlConexion.Open()
            sqlTransaccion = sqlConexion.BeginTransaction
            sqlComando.Transaction = sqlTransaccion
            sqlComando.ExecuteNonQuery()
            sqlComando.CommandText = sqlQuery
            sqlComando.Parameters.Add("@factura", SqlDbType.VarChar, 20).Value = lblFactura.Text.Trim
            sqlComando.Parameters.Add("@tipoFactura", SqlDbType.VarChar, 10).Value = tipoFac.Trim
            sqlComando.Parameters.Add("@idUsuario", SqlDbType.Int).Value = Session("usxp001")
            sqlComando.ExecuteNonQuery()
            sqlTransaccion.Commit()
            lblRes.Text = "El MSISDN " & lblMin.Text.Trim & " fue liberado satisfactoriamente.<br><br>"
            limpiarCampos()
            pnlDatos.Visible = False
        Catch ex As Exception
            If Not sqlTransaccion Is Nothing Then sqlTransaccion.Rollback()
            lblError.Text = "Error al tratar de liberar MSISDN. " & ex.Message & "<br><br>"
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub

    Private Sub limpiarCampos()
        lblFactura.Text = ""
        lblSerial.Text = ""
        lblSim.Text = ""
        lblMin.Text = ""
        lblTipoFactura.Text = ""
        lblPos.Text = ""
        lblFechaVenta.Text = ""
        hTransaccion.Value = ""
        txtMin.Text = ""
    End Sub

    Private Sub btnLiberar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLiberar.Click
        liberarMIN()
    End Sub
End Class
