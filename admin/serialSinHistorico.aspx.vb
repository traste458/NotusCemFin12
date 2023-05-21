Imports System.Data.SqlClient
Partial Class serialSinHistorico
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
        If Not IsPostBack Then
            tomarDatos()
        End If
    End Sub
    Private Sub tomarDatos()
        Dim numSerial As String, tabla As String, nombreTabla As String
        Dim tipoSerial As Int16, idPos As Integer, res_Tabla As String
        Dim serialNombre As String
        numSerial = Request.QueryString("serial")
        tipoSerial = CInt(Request.QueryString("tipoSerial"))
        Server.ScriptTimeout = 15000
        Try
            If tipoSerial = 1 Then
                serialNombre = "El IMEI Número "
                tabla = "productos_serial where serial="
                nombreTabla = "productos_serial"
            Else
                tabla = "sims where sim="
                nombreTabla = "sims"
                serialNombre = "El ICCID Número "
            End If
            serialNombre += numSerial + "<br>"
            consultarImei(numSerial, tabla, nombreTabla, idPos, res_Tabla, serialNombre)
            If idPos = 49 Then
                consultaFacturas(numSerial, tipoSerial, 49, res_Tabla, serialNombre)
            Else
                If idPos = -1 Then
                    lblError.Text = serialNombre + " no existe en la base de datos o <br>"
                    lblError.Text += "no tiene despachado asignado"
                Else
                    lblError.Text = serialNombre + " no se encuentra registrado como vendido"
                    lblError.Text += "<BR>en la base de datos"
                End If

            End If
        Catch ex As Exception
            lblError.Text = "ERROR AL TOMAR LOS DATOS " & ex.Message
        End Try

    End Sub

    Private Sub consultarImei(ByVal numSerial As String, ByVal tabla As String, _
    ByVal nombretabla As String, ByRef idPos As Integer, ByRef res_Tabla As String, ByVal serialNombre As String)
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, dataRed As New DataTable
        Dim sentencia As String
        sentencia = "select idPos,'" & nombretabla & "' as tabla from "
        sentencia += tabla & " @serial and idDespacho is not null "
        sentencia += "union select idPos, 'DespachosOtrosOperadores' as tabla from "
        sentencia += "DespachosOtrosOperadores where serial = @serial "
        sentencia += " and idDespacho is not null "
        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, _
            sentencia, True)
            sqlComando.CommandTimeout = 5000
            sqlComando.Parameters.Add("@serial", SqlDbType.VarChar).Value = numSerial
            sqlAdaptador.Fill(dataRed)
            If dataRed.Rows.Count > 0 Then
                idPos = dataRed.Rows(0)("idPos")
                res_Tabla = dataRed.Rows(0)("tabla")
            Else
                idPos = -1
                lblError.Text = serialNombre + " no corresponde a " + nombretabla

            End If
        Catch ex As Exception
            lblError.Text = "No se pudo optener el idPos" & ex.Message
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try

    End Sub

    Private Sub consultaFacturas(ByVal numSerial As String, ByVal tipoSerial As Int16, _
    ByVal idpost As Integer, ByVal nombreTabla As String, ByVal serialNombre As String)
        Dim conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, dtDatos As New DataTable
        Dim sentencia As String, factura As String, fecha As String, where As String
        Dim selector As String, subida As Boolean
        selector = "select factura, convert(varchar,fecha,103) as fecha "
        sentencia = ",'Facturas Kits' as tabla from facturas_kits where "
        Try
            If tipoSerial = 1 Then
                where = "serial = @Serial "
            Else
                where = "sim = @Serial "
            End If
            sentencia = selector + sentencia + where + "union " + selector
            sentencia += ", 'Facturas PostPago' as tabla from facturas_postpago "
            sentencia += "where " + where
            If tipoSerial = 2 Then
                sentencia += "union " + selector + ", 'Facturas Kits WB' as tabla "
                sentencia += "from facturas_kits_wb where sim=@Serial"
            End If
            MetodosComunes.inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            comando.CommandTimeout = 5000
            comando.Parameters.Add("@serial", SqlDbType.VarChar).Value = numSerial
            adaptador.Fill(dtDatos)
            If dtDatos.Rows.Count = 0 Then
                buscarFacturaPendiente(numSerial, tipoSerial, subida, nombreTabla, serialNombre)
                If subida Then
                    actualizaidPosOrigen(numSerial, nombreTabla, where, serialNombre)
                End If
            Else
                lblError.Text += serialNombre + " tiene asignada la factura : "
                lblError.Text += dtDatos.Rows(0)("factura") + " <BR> con la  fecha : "
                lblError.Text += dtDatos.Rows(0)("fecha") + "<br> en  "
                lblError.Text += dtDatos.Rows(0)("tabla")
            End If
        Catch ex As Exception
            lblError.Text = "Error al buscar historial de factura:" & ex.Message
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub buscarFacturaPendiente(ByVal numSerial As String, _
    ByVal tipoSerial As Int16, ByRef subida As Boolean, ByVal nombreTabla As String, ByVal serialNombre As String)
        Dim conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, dtSubida As New DataTable
        Dim sentencia As String, valorSubida As DateTime
        If tipoSerial = 1 Then
            sentencia = "select convert(varchar,subida,103) as subida, factura, idPos,"
            sentencia += "'Facturas Pendientes ' as tabla"
            sentencia += " from facturas_kits_pendientes where serial = @numserial"
        Else
            sentencia = "select convert(varchar,subida,103) as subida, factura, idPos,"
            sentencia += "'Facturas Pendientes ' as tabla"
            sentencia += " from facturas_kits_pendientes where sim = @numserial "
            sentencia += "union select convert(varchar,subida,103) as subida, factura, idPos ,"
            sentencia += "'Facturas Pendientes_wb ' as tabla"
            sentencia += " from facturas_kits_pendientes_wb where sim = @numserial"
        End If
        Try
            MetodosComunes.inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            comando.CommandTimeout = 5000
            comando.Parameters.Add("@numserial", SqlDbType.VarChar).Value = numSerial
            adaptador.Fill(dtSubida)

            If dtSubida.Rows.Count = 0 Then
                subida = True ' si es verdadero NO tiene facturas pendientes
            Else
                If dtSubida.Rows(0)("subida") Is DBNull.Value Then
                    lblRes.Text = serialNombre + " se encuentra en " & dtSubida.Rows(0)("tabla")
                    lblRes.Text += "disponible para subir con Número de factura : " & dtSubida.Rows(0)("factura")
                Else
                cambiarSubidaPendiente(numSerial, tipoSerial, _
                dtSubida.Rows(0)("factura"), serialNombre)
                End If
                subida = False
                cambioIdPosPendiente(numSerial, tipoSerial, nombreTabla, dtSubida.Rows(0)("idPos"), serialNombre)
            End If

        Catch ex As Exception
            lblError.Text = "Error al consultar datos de subida : " & ex.Message
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            GC.Collect()
        End Try

    End Sub

    Private Sub actualizaidPosOrigen(ByVal numSerial As String, _
    ByVal nombreTabla As String, ByVal filtro As String, ByVal serialNombre As String)
        Dim sentencia As String, casoError As String, pos As Integer
        Dim conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, dtidPos As New DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, nombrePos As String
        sentencia = "select idpos, pos from pos where idpos2 in("
        sentencia += "select rtrim(idcliente2) from clientes where idcliente in("
        sentencia += "select idcliente from despachos where iddespacho = "
        sentencia += "(select max(iddespacho) from despachosdetalle_serial "
        sentencia += "where serial =@numSerial)))"
        Try
            MetodosComunes.inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            comando.CommandTimeout = 5000
            comando.Parameters.Add("@numSerial", SqlDbType.VarChar).Value = numSerial
            adaptador.Fill(dtidPos)
            If nombreTabla = "DespachosOtrosOperadores" Then filtro = "serial = @Serial "

            If dtidPos.Rows.Count > 0 Then
                pos = dtidPos.Rows(0)("idpos")
                nombrePos = dtidPos.Rows(0)("pos")
                conexion.Close()

                Try
                    sentencia = "update " + nombreTabla + " set idPos= " + CStr(pos)
                    sentencia += " where " + filtro
                    sqlConexion = _
                    New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
                    sqlComando = New SqlCommand(sentencia, sqlConexion)
                    sqlComando.Parameters.Add("@Serial", SqlDbType.VarChar).Value = _
                    numSerial
                    sqlConexion.Open()
                    sqlComando.ExecuteNonQuery()
                    sqlConexion.Close()
                    lblRes.Text += serialNombre + " fue asignado a <b>" + nombrePos
                    lblRes.Text += "</b><BR> según su último despacho <br><br>"
                Catch ex As Exception
                    lblError.Text += "Error al actulizar los datos : " & ex.Message
                Finally
                    If Not sqlConexion Is Nothing Then sqlConexion.Close()
                End Try
            Else
                lblError.Text = serialNombre + " no se encuentra despachado <BR> "
                lblError.Text += "por el cual no se puede asignar a ningún punto de venta"
            End If

        Catch ex As Exception
            lblError.Text += "Error al cargar idPos de la factura : " & ex.Message
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub cambiarSubidaPendiente(ByVal numSerial As String, ByVal tipoSerial _
    As Int16, ByVal factura As String, ByVal serialNombre As String)
        Dim conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, dtSubida As New DataTable
        Dim sqlSelect As String, where As String

        If tipoSerial = 1 Then
            sqlSelect = "update facturas_kits_pendientes set subida = null "
            sqlSelect += "where serial=@numSerial"
        Else
            sqlSelect = "update facturas_kits_pendientes_wb set subida = null "
            sqlSelect += "where sim=@numSerial;"
            sqlSelect += "update facturas_kits_pendientes_wb set subida = null "
            sqlSelect += "where sim=@numSerial"
        End If
        Try
            MetodosComunes.inicializarObjetos(conexion, comando, adaptador, _
            sqlSelect, True)
            comando.CommandTimeout = 5000
            comando.Parameters.Add("@numSerial", SqlDbType.VarChar).Value = numSerial
            conexion.Open()
            comando.ExecuteNonQuery()
            conexion.Close()
            lblError.Text = serialNombre + " se encuentra en Facturas pendientes "
            If tipoSerial = 2 Then
                lblError.Text += " WB <BR>"
            Else
                lblError.Text += " <BR>"
            End If
            lblError.Text += "disponible para subir con número de factura : " & factura
        Catch ex As Exception
            lblError.Text = " Error al cambiar el estado de subida " & ex.Message
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            GC.Collect()
        End Try
    End Sub

    Private Sub cambioIdPosPendiente(ByVal numSerial As String, ByVal tipoSerial As Int16, _
    ByVal nombreTabla As String, ByVal idPos As Integer, ByVal serialNombre As String)

        Dim conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, sentencia As String, cadena As String, nombrePos As String

        sentencia = "update " + nombreTabla + " set idPos = " + CStr(idPos) + " where "
        If nombreTabla <> "DespachosOtrosOperadores" Then
            If tipoSerial = 1 Then
                sentencia += "serial = @numSerial"
            Else
                sentencia += "Sim = @numSerial"
            End If
        Else
            sentencia += "serial = @numSerial"
        End If
        If tipoSerial = 1 Then
            cadena = "El IMEI = " + CStr(numSerial)
        Else
            cadena = "El ICCID = " + CStr(numSerial)
        End If
        Try
            MetodosComunes.inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            comando.CommandTimeout = 5000
            comando.Parameters.Add("@numSerial", SqlDbType.VarChar).Value = numSerial
            conexion.Open()
            comando.ExecuteNonQuery()
            comando.CommandText = "select pos from pos where idpos = " & CStr(idPos)
            nombrePos = comando.ExecuteScalar

            conexion.Close()
            lblRes.Text += "<br><br>  " + cadena + " se le asigno al POS " + nombrePos + " según su Factura Pendiente <br><br>"
        Catch ex As Exception
            lblError.Text = "Error al cargar IdPos Pendientes : " & ex.Message
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            GC.Collect()
        End Try
    End Sub
End Class
