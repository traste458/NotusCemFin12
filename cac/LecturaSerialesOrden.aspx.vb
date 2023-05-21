Imports System.Data.SqlClient
Partial Class LecturaSerialesOrden
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
    Private idorden As String
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            'Recogemos el idInventario pasado de la pagina del reporte.
            Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
            idorden = Trim(Request.QueryString("idOrden"))
            lblError.Text = ""
            If Not Page.IsPostBack Then
                'Cargamos la información del inventario.
                hlRegresar.NavigateUrl = "ordenes_buscar_cac2.asp?idproducto=" & Request.QueryString("idproducto") & "&idSubproducto=" & Request.QueryString("idSubproducto")
                cargarDatosOrden(idorden)
            End If
        Catch ex As Exception
            lblError.Text = ex.Message
        End Try
    End Sub

    'Rutina para efectuar el cargue de la información en los label informativos del inventario.
    Private Sub cargarDatosOrden(ByVal idorden As String)
        Dim comando As SqlCommand, conexion As SqlConnection, adapter As SqlDataAdapter
        Dim consultaSQL As String, dtInfoInventario As New DataTable, dtSerial As New DataTable

        Try
            'Consulta para obtener la información requerida.

            consultaSQL = "select idorden_cac, idorden2_cac, convert(varchar, fecha, 105) as fecha, idcac,"
            consultaSQL += " (select cac from cac with(nolock) where idcac = a.idcac) as cac, cantidad, cantidad_leida, idproducto, idsubproducto, "
            consultaSQL += " (select subproducto from subproductos with(nolock) where idsubproducto = a.idsubproducto) as subproducto, estado "
            consultaSQL += " from ordenes_cac a with(nolock)"
            consultaSQL += " where idorden_cac =@idOrden"

            'Inicializamos los objetos para interactuar con la base de datos.
            MetodosComunes.inicializarObjetos(conexion, comando, adapter, consultaSQL, True)
            'Definimos los parametros que pasaremos a la consulta.
            comando.Parameters.Add("@idOrden", SqlDbType.BigInt).Value = idorden
            'Cargamos al dataTable la información del inventario.
            adapter.Fill(dtInfoInventario)
            'Cargamos a los label informativos la información del inventario.
            If dtInfoInventario.Rows.Count > 0 Then
                With dtInfoInventario
                    lblTitulo.Text = "Orden de Lectura CAC No. " & .Rows(0).Item(0)
                    lblIdOrden.Text = .Rows(0).Item(0)
                    lblOrden.Text = .Rows(0).Item(1)
                    lblFecha.Text = .Rows(0).Item(2)
                    lblCAC.Text = .Rows(0).Item(4)
                    'lblEtiquetaBorrado.Text = .Rows(0).Item(3)
                    'lblEtiquetaLectura.Text = .Rows(0).Item(3)
                    lblCantidad.Text = .Rows(0).Item(5)
                    lblCantidadLeida.Text = .Rows(0).Item(6)
                    'Almacenamos en el hidden la longitud del tipo de lectura del pedido.
                   
                    If lblCantidad.Text = lblCantidadLeida.Text Then lbCerrar.Visible = True
                    If .Rows(0).Item(10) <> 1 Then
                        tbxSerialaLeer.Visible = False
                        tbxSerialaBorrar.Visible = False
                        lblEtiquetaLectura.Visible = False
                        lblEtiquetaBorrado.Visible = False
                        lbCerrar.Visible = False
                    Else
                        tbxSerialaLeer.Visible = True
                        tbxSerialaBorrar.Visible = True
                        lblEtiquetaLectura.Visible = True
                        lblEtiquetaBorrado.Visible = True
                        If .Rows(0).Item(5) <= .Rows(0).Item(6) Then
                            lbCerrar.Visible = True
                        Else
                            lbCerrar.Visible = False
                        End If
                    End If
                    hddLongitud.Value = .Rows(0).Item(10)
                End With
                consultaSQL = "select serial from ordenes_cac_detalle with(nolock) where idorden_cac = @idOrden"
                comando.CommandText = consultaSQL
                adapter.Fill(dtSerial)
                With dgSerial
                    .DataSource = dtSerial
                    .DataBind()
                End With
            End If
        Catch ex As Exception
            lblError.Text = ex.Message
        Finally
            'Liberamos los objetos de Conexion a la base de datos.
            If Not comando Is Nothing Then comando.Dispose()
            If Not adapter Is Nothing Then adapter.Dispose()
            If Not conexion Is Nothing Then conexion.Close()
        End Try
    End Sub

    'Funciòn para efectuar el registro del serial.
    <Anthem.Method()> _
    Public Function registrarSerial(ByVal serial As String) As Boolean
        Dim comando As SqlCommand, conexion As SqlConnection, transaccion As SqlTransaction, dtSerial As New DataTable
        Dim insertSQL As String, OrdenCac, ordenDet, serialInsertado As Integer, Adapter As SqlDataAdapter

        Try
            lblError.Text = ""
            'Consultamos se ya se encuentra inventario el serial como no SAP
            insertSQL = " select count(0) from ordenes_cac_detalle with(nolock) where serial = @serial"
            'Instanciamos los objetos para interactuar con la base de datos.
            MetodosComunes.inicializarObjetos(conexion, comando, insertSQL)
            'Definimos los parametros para el registro del serial
            comando.Parameters.Add("@serial", SqlDbType.VarChar, 20).Value = serial
            'comando.Parameters.Add("@idInventario", SqlDbType.BigInt).Value = idInventario
            'Abrimos la Conexion.
            conexion.Open()
            transaccion = conexion.BeginTransaction
            With comando
                .Transaction = transaccion
                OrdenCac = 0
                ordenDet = 0
            'consultamos si existe ya inventariad
                ordenDet = .ExecuteScalar

                'Consultamos se ya se encuentra inventario el serial en otro inventario
                If ordenDet = 0 Then
                    If CInt(lblCantidad.Text.Trim) > CInt(lblCantidadLeida.Text.Trim) Then
                        'Definimos la estructura del insert para registrar el serial en el inventario.
                        insertSQL = "insert into ordenes_cac_detalle (idorden_cac, serial)  values (@idOrden,@serial) "
                        .Parameters.Add("@idOrden", SqlDbType.Int).Value = idorden
                        'le asignamos la sentencia al comando
                        .CommandText = insertSQL
                        'Registramos el serial.
                        serialInsertado = comando.ExecuteNonQuery()
                        If serialInsertado <> 0 Then
                            insertSQL = "update ordenes_cac set cantidad_leida = cantidad_leida +1 where idOrden_Cac = @idOrden"
                            .CommandText = insertSQL
                            .ExecuteNonQuery()
                            lblCantidadLeida.Text = lblCantidadLeida.Text + 1
                        End If
                        If CInt(lblCantidad.Text) <= CInt(lblCantidadLeida.Text) Then lbCerrar.Visible = True
                        transaccion.Commit()
                        insertSQL = "select serial from ordenes_cac_detalle with(nolock) where idorden_cac = @idOrden"
                        comando.CommandText = insertSQL
                        Adapter = New SqlDataAdapter(comando)
                        Adapter.Fill(dtSerial)
                        With dgSerial
                            .DataSource = dtSerial
                            .DataBind()
                        End With
                        Return (True)
                    Else
                        lbCerrar.Visible = True
                        Throw New Exception("<br>Ya fue leída la totalidad del orden. Por favor, cierre la orden")
                    End If
                Else
                    Throw New Exception("<br>El serial " & serial & " ya fue leído")
                End If
            End With
        Catch ex As Exception
            If Not transaccion Is Nothing Then transaccion.Rollback()
            lblError.Text = "No se pudo leer el serial en al orden " & ex.Message
        Finally
            'Liberamos los objetos de Conexion a la base de datos.
            If Not comando Is Nothing Then
                comando.Dispose()
            End If

            If Not conexion Is Nothing Then
                If conexion.State = ConnectionState.Open Then conexion.Close()
            End If
        End Try
    End Function

    'Funciòn para efectuar el registro del serial.
    <Anthem.Method()> _
    Public Function eliminarSerial(ByVal serial As String) As Integer
        Dim comando As SqlCommand, conexion As SqlConnection, transaccion As SqlTransaction, Adapter As SqlDataAdapter, dtSerial As New DataTable
        Dim deleteSQL As String, serialesEliminados As Integer
        lblError.Text = ""
        Try
            If lblCantidadLeida.Text > 0 Then
                'Definimos la estructura del delete para eliminar el serial en el inventario.
                deleteSQL = "delete ordenes_cac_detalle  "
                deleteSQL += "Where serial = @serial and  idorden_cac = @idOrden "
                'Instanciamos los objetos para interactuar con la base de datos.
                MetodosComunes.inicializarObjetos(conexion, comando, deleteSQL)
                'Definimos los parametros para eliminacion del serial
                With comando
                    .Parameters.Add("@serial", SqlDbType.VarChar, 20).Value = serial
                    .Parameters.Add("@idOrden", SqlDbType.Int).Value = idorden
                    'Abrimos la Conexion.
                    conexion.Open()
                    transaccion = conexion.BeginTransaction
                    .Transaction = transaccion
                    'Eliminamos el serial
                    serialesEliminados = .ExecuteNonQuery()
                    If serialesEliminados <> 0 Then
                        lblCantidadLeida.Text = Integer.Parse(lblCantidadLeida.Text) - 1
                        deleteSQL = "update ordenes_cac set cantidad_leida = (select count(0) from ordenes_cac_detalle with(nolock) where idOrden_Cac = cac.idOrden_cac ) from ordenes_cac cac with(nolock) where idOrden_Cac = @idOrden"
                        .CommandText = deleteSQL
                        .ExecuteNonQuery()
                        transaccion.Commit()
                    End If
                End With
                deleteSQL = "select serial from ordenes_cac_detalle with(nolock) where idorden_cac = @idOrden"
                comando.CommandText = deleteSQL
                Adapter = New SqlDataAdapter(comando)
                Adapter.Fill(dtSerial)
                With dgSerial
                    .DataSource = dtSerial
                    .DataBind()
                End With
                If CInt(lblCantidad.Text.Trim) > CInt(lblCantidadLeida.Text.Trim) Then lbCerrar.Visible = False

                Return (serialesEliminados)
            Else
                Throw New Exception("<br>No se puede Eliminar el serial porque la orden no contiene seriales ")
            End If
        Catch ex As Exception
            If Not transaccion Is Nothing Then transaccion.Rollback()
            lblError.Text = "No se pudo leer el serial  " & ex.Message
        Finally
            'Liberamos los objetos de Conexion a la base de datos.
            If Not comando Is Nothing Then
                comando.Dispose()
            End If

            If Not conexion Is Nothing Then
                If conexion.State = ConnectionState.Open Then conexion.Close()
            End If
        End Try
    End Function

    <Anthem.Method()> Public Sub refrescar(ByVal valor As String)
        If valor = "0" Then
            lblError.Text = ""
        End If
    End Sub

    Public Function cerrarInventario(ByVal idOrdenCerrar As String) As Boolean
        Dim comando As SqlCommand, conexion As SqlConnection, updateSQL As String, oTransac As SqlTransaction
        Dim invCAC As Integer

        updateSQL = "select count(0) from cac_seriales with(nolock) where serial in ( select b.serial from ordenes_cac a with(nolock), "
        updateSQL += "ordenes_cac_detalle b with(nolock) where a.idorden_cac = b.idorden_cac and a.idorden_cac =@idOrdenCerrar )"

        Try
            lblError.Text = ""
            lblRes.Text = ""
            MetodosComunes.inicializarObjetos(conexion, comando, updateSQL)
            With comando
                .Parameters.Add("@idOrdenCerrar", SqlDbType.BigInt).Value = idOrdenCerrar
                .Parameters.Add("@usuario", SqlDbType.BigInt).Value = IIf(Session("usxp001") = "", 1, Session("usxp001"))
                conexion.Open()


                If .ExecuteScalar = 0 Then
                    oTransac = conexion.BeginTransaction
                    comando.Transaction = oTransac

                    updateSQL = "update ordenes_cac set estado = 2, cantidad_leida = cantidad  where idorden_cac = @idOrdenCerrar"
                    .CommandText = updateSQL
                    .ExecuteNonQuery()

                    updateSQL = "insert into cac_seriales (serial, idproducto, idsubproducto, idcac, idtercero, fecha, idorden_ingreso) "
                    updateSQL += " select b.serial, a.idproducto, a.idsubproducto, a.idcac, @usuario, getdate(), a.idorden_cac "
                    updateSQL += " from ordenes_cac a with(nolock), ordenes_cac_detalle b with(nolock) where a.idorden_cac = b.idorden_cac "
                    updateSQL += " and a.idorden_cac = @idOrdenCerrar "

                    .CommandText = updateSQL
                    .ExecuteNonQuery()

                    updateSQL = "select count(0) from cac_inventario a with(nolock) inner join ordenes_cac b with(nolock) on a.idCac=b.idCac and b.idproducto = "
                    updateSQL += "a.idproducto and a.idsubproducto = b.idsubproducto where b.idorden_cac = @idOrdenCerrar"

                    .CommandText = updateSQL
                    invCAC = .ExecuteScalar

                    If invCAC = 0 Then
                        updateSQL = "update cac_inventario set saldo= saldo + (select count(0) from  ordenes_cac_detalle with(nolock) where idOrden_CAC = b.idOrden_CAC )"
                        updateSQL += " from cac_inventario a with(nolock)inner join ordenes_cac b with(nolock) on a.idCac=b.idCac and b.idproducto = a.idproducto and a.idsubproducto = b.idsubproducto where b.idorden_cac = @idOrdenCerrar"
                    Else
                        updateSQL = "insert into cac_inventario (idcac, idproducto, idsubproducto, saldo) "
                        updateSQL += "select idcac, idproducto, idsubproducto, cantidad_leida from "
                        updateSQL += "ordenes_cac with(nolock) where idorden_cac = @idOrdenCerrar"
                    End If
                    .CommandText = updateSQL
                    .ExecuteNonQuery()

                    oTransac.Commit()
                    Return (True)
                Else
                    lblError.Text = "los seriales de esta orden ya se encuentran en el inventario para CAC<br>"
                End If
            End With
        Catch ex As Exception
            If Not oTransac Is Nothing Then oTransac.Rollback()
            lblError.Text = "Error al tratar de cerrar Inventario. " & ex.Message
        Finally
            MetodosComunes.liberarConexion(conexion)
        End Try
    End Function

    Private Sub lbCerrar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbCerrar.Click
        If cerrarInventario(idorden) Then
            lblRes.Text = "Se cerró correctamente la orden "
        Else
            lblError.Text += "Fue imposible cerrar la Orden. Por favor intente nuevamente."
        End If
    End Sub

End Class
