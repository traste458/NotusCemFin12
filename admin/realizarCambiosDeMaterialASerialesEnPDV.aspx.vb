Imports System.Data.SqlClient
Imports System.IO
Imports System.Text


Partial Class realizarCambiosDeMaterialASerialesEnPDV
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
        Try
            Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
            lblError.Text = ""
            lblRes.Text = ""
            btnProcesar.Attributes.Add("onclick", "divImagen.style.display='block'")
            If Not Me.IsPostBack And Not Anthem.Manager.IsCallBack Then
                hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de cargar página. " & ex.Message & "<br><br>"
        End Try
    End Sub

    Private Function subirArchivoAlServidor() As String
        Dim nombreArchivo As String
        Try
            nombreArchivo = Server.MapPath("../archivos_planos/") & "archivoParaCambioDeMaterial_" & Session("usxp001") & ".txt"
            flArchivo.PostedFile.SaveAs(nombreArchivo)
            Return nombreArchivo
        Catch ex As Exception
            Throw New Exception("Error al tratar de subir Archivo al Servidor. " & ex.Message)
        End Try
    End Function

    Private Sub leerDatosDelArchivo(ByRef dtRegistros As DataTable, ByVal nombreArchivo As String)
        Dim lectorArchivo As StreamReader, drAux As DataRow
        Dim linea, arregloDatos(), serial As String, numeroLinea As Integer = 0
        Dim losDatosEnBP As New DatosEnBPColsys, dtErrores As New DataTable, drError As DataRow

        With dtErrores.Columns
            .Add("serial", GetType(System.String))
            .Add("error", GetType(System.String))
            .Add("linea", GetType(System.Int16))
        End With

        Try
            lectorArchivo = File.OpenText(nombreArchivo)
            Do
                linea = lectorArchivo.ReadLine
                numeroLinea += 1
                If linea <> "" Then
                    arregloDatos = linea.Split(vbTab)
                    If arregloDatos.GetLength(0) = 4 Then
                        losDatosEnBP = obtenerDatosDeBD(arregloDatos)
                        If losDatosEnBP.idPos <> 0 And losDatosEnBP.idSubproductoAnterior <> 0 _
                                                    And arregloDatos(2).ToLower = losDatosEnBP.materialAsignado.ToLower _
                                                    And losDatosEnBP.idSubproductoNuevo <> 0 And losDatosEnBP.tabla <> "NT" Then
                            drAux = dtRegistros.NewRow
                            With losDatosEnBP
                                drAux.Item(0) = .idPos
                                drAux.Item(1) = arregloDatos(1).Trim
                                If .idSubproductoAnterior <> .idSubproductoAsignado And .idSubproductoAsignado <> 0 Then _
                                    .idSubproductoAnterior = .idSubproductoAsignado
                                drAux.Item(2) = .idSubproductoAnterior
                                drAux.Item(3) = .idSubproductoNuevo
                                drAux.Item(4) = .tabla
                            End With
                            dtRegistros.Rows.Add(drAux)
                        Else
                            drError = dtErrores.NewRow
                            With drError
                                .Item(0) = arregloDatos(1).Trim
                                If losDatosEnBP.idPos = 0 Then
                                    .Item(1) = "Imposible Determinar el Punto de Venta en BPCOLSYS"
                                ElseIf losDatosEnBP.idSubproductoAnterior = 0 Then
                                    .Item(1) = "Imposible Determinar el Subproducto del Material Actual en BPCOLSYS"
                                ElseIf losDatosEnBP.idSubproductoNuevo = 0 Then
                                    .Item(1) = "Imposible Determinar el Subproducto del Material Nuevo en BPCOLSYS"
                                ElseIf arregloDatos(2).ToLower <> losDatosEnBP.materialAsignado.ToLower Then
                                    .Item(1) = "El Material Registrado del Serial en el Sistema no es igual al Material especificado."
                                Else
                                    .Item(1) = "Imposible Determinar en que tabla se encuentra el serial en BPCOLSYS"
                                End If
                                .Item(2) = numeroLinea
                            End With
                            dtErrores.Rows.Add(drError)
                        End If
                    Else
                        Throw New Exception("El archivo contiene registros cuyo formato no es válido. Línea " & numeroLinea.ToString)
                    End If
                End If
            Loop Until linea Is Nothing
            If dtErrores.Rows.Count > 0 Then
                dgDetalleErrores.DataSource = dtErrores
                dgDetalleErrores.Columns(1).FooterText = dtErrores.Rows.Count & " Registros Encontrados"
                dgDetalleErrores.DataBind()
                pnlErrores.Visible = True
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de leer los datos del archivo. " & ex.Message)
        Finally
            If Not lectorArchivo Is Nothing Then lectorArchivo.Close()
        End Try
    End Sub

    Private Sub procesarUnSerial(ByRef dtRegistro As DataTable)
        Dim arregloDatos(3) As String,losDatosEnBP As New DatosEnBPColsys
        Dim dtErrores As New DataTable, drAux, drError As DataRow

        With dtErrores.Columns
            .Add("serial", GetType(System.String))
            .Add("error", GetType(System.String))
            .Add("linea", GetType(System.String))
        End With

        Try
            arregloDatos(0) = txtCodigoMay.Text.Trim
            arregloDatos(1) = txtSerial.Text.Trim
            arregloDatos(2) = txtMaterialActual.Text.Trim
            arregloDatos(3) = txtNuevoMaterial.Text.Trim
            losDatosEnBP = obtenerDatosDeBD(arregloDatos)
            If losDatosEnBP.idPos <> 0 And losDatosEnBP.idSubproductoAnterior <> 0 _
                And arregloDatos(2).ToLower = losDatosEnBP.materialAsignado.ToLower _
                And losDatosEnBP.idSubproductoNuevo <> 0 And losDatosEnBP.tabla <> "NT" Then

                drAux = dtRegistro.NewRow
                With losDatosEnBP
                    drAux.Item(0) = .idPos
                    drAux.Item(1) = arregloDatos(1).Trim
                    If .idSubproductoAnterior <> .idSubproductoAsignado And .idSubproductoAsignado <> 0 Then _
                        .idSubproductoAnterior = .idSubproductoAsignado
                    drAux.Item(2) = .idSubproductoAnterior
                    drAux.Item(3) = .idSubproductoNuevo
                    drAux.Item(4) = .tabla
                End With
                dtRegistro.Rows.Add(drAux)
            Else
                drError = dtErrores.NewRow
                With drError
                    .Item(0) = arregloDatos(1).Trim
                    If losDatosEnBP.idPos = 0 Then
                        .Item(1) = "Imposible Determinar el Punto de Venta en BPCOLSYS"
                    ElseIf losDatosEnBP.idSubproductoAnterior = 0 Then
                        .Item(1) = "Imposible Determinar el Subproducto del Material Actual en BPCOLSYS"
                    ElseIf losDatosEnBP.idSubproductoNuevo = 0 Then
                        .Item(1) = "Imposible Determinar el Subproducto del Material Nuevo en BPCOLSYS"
                    ElseIf arregloDatos(2).ToLower <> losDatosEnBP.materialAsignado.ToLower Then
                        .Item(1) = "El Material Registrado del Serial en el Sistema no es igual al Material especificado."
                    Else
                        .Item(1) = "Imposible Determinar en que tabla se encuentra el serial en BPCOLSYS"
                    End If
                End With
                dtErrores.Rows.Add(drError)
            End If

            If dtErrores.Rows.Count > 0 Then
                lblError.Text = "No se puede realizar el cambio de material al Serial.<br><br>"
                dgDetalleErrores.DataSource = dtErrores
                dgDetalleErrores.Columns(1).FooterText = dtErrores.Rows.Count & " Registros Encontrados"
                dgDetalleErrores.DataBind()
                pnlErrores.Visible = True
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de validar Información del Serial. " & ex.Message)
        End Try
    End Sub

    Private Function obtenerDatosDeBD(ByVal arregloDatos As String()) As DatosEnBPColsys
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String
        Dim resultado As New DatosEnBPColsys, arregloAux(), auxiliar As String

        'sqlSelect = "select idpos,(select idsubproducto from subproductos with(nolock) where "
        'sqlSelect += " idsubproducto2=@materialAnt and region=auxPos.region and estado=1)as idSubproductoAnt, "
        'sqlSelect += " (select idsubproducto from subproductos with(nolock) where idsubproducto2=@materialNuevo "
        'sqlSelect += " and region=auxPos.region and estado=1) as idSubproductoNuevo,isnull( case when len(@serial)=17 then "
        'sqlSelect += " (select convert(varchar,idSubproducto)+'@'+(select idsubproducto2 from subproductos where "
        'sqlSelect += " idsubproducto=doo.idsubproducto and sims_sn = (select sims_sn from subproductos with"
        'sqlSelect += "  (nolock) where idSubproducto2 = @materialNuevo and region = (select region from pos where "
        'sqlSelect += " idPos = doo.idpos)))+'@DOO' from DespachosOtrosOperadores doo with(nolock) "
        'sqlSelect += "  where serial=@serial and idPos is not null and idDespacho is not null union "
        'sqlSelect += "  select convert(varchar,idsubproducto)+'@'+(select idsubproducto2 from subproductos "
        'sqlSelect += "  where idsubproducto=s.idsubproducto)+'@SIM' from sims s with(nolock) where sim = @serial and "
        'sqlSelect += "   idpos is not null and iddespacho is not null) else "
        'sqlSelect += "  (select convert(varchar,idsubproducto)+'@'+(select idsubproducto2 from subproductos where "
        'sqlSelect += "  idsubproducto=doo.idsubproducto)+'@DOO' from DespachosOtrosOperadores doo with(nolock) where serial = @serial "
        'sqlSelect += "  and idPos is not null and idDespacho is not null union "
        'sqlSelect += "  select convert(varchar,idsubproducto)+'@'+(select idsubproducto2 from subproductos where "
        'sqlSelect += "  idsubproducto=ps.idsubproducto)+'@PS' from productos_serial ps with(nolock) where serial = @serial and "
        'sqlSelect += "   idpos is not null and iddespacho is not null)"
        'sqlSelect += "  end,'0@0@NT') as tabla from "
        'sqlSelect += "(select idpos,region from pos where idpos2=@codigoMay) auxPos "

        sqlSelect = "  select idpos,(select idsubproducto from subproductos with(nolock) where idsubproducto2=@materialAnt and "
        sqlSelect += " region=auxPos.region and estado=1)as idSubproductoAnt,(select idsubproducto from subproductos with(nolock) "
        sqlSelect += " where idsubproducto2=@materialNuevo  and region=auxPos.region and estado=1) as idSubproductoNuevo,"
        sqlSelect += " isnull( case when len(@serial)=17 then (select convert(varchar,idSubproducto)+'@'+(select idsubproducto2 "
        sqlSelect += " from subproductos where idsubproducto=doo.idsubproducto and sims_sn = (select sims_sn from subproductos "
        sqlSelect += " with (nolock) where idSubproducto2 = @materialNuevo and region = (select region from pos where idPos = "
        sqlSelect += " doo.idpos)))+'@DOO' from DespachosOtrosOperadores doo with(nolock)where serial=@serial and idPos is not "
        sqlSelect += " null and idDespacho is not null union select convert(varchar,idsubproducto)+'@'+(select idsubproducto2 "
        sqlSelect += " from subproductos where idsubproducto=s.idsubproducto and sims_sn = (select sims_sn from subproductos "
        sqlSelect += " with (nolock) where idSubproducto2 = @materialNuevo and region = s.region))+'@SIM' from sims s with(nolock) "
        sqlSelect += " where sim = @serial and idpos is not null and iddespacho is not null) else (select convert(varchar,idsubproducto)"
        sqlSelect += " +'@'+(select idsubproducto2 from subproductos where idsubproducto=doo.idsubproducto and sims_sn = (select sims_sn "
        sqlSelect += " from subproductos with (nolock) where idSubproducto2 = @materialNuevo and region = (select region from pos where "
        sqlSelect += " idPos = doo.idpos)))+'@DOO' from DespachosOtrosOperadores doo with(nolock) where serial = @serial and idPos is not "
        sqlSelect += " null and idDespacho is not null union select convert(varchar,idsubproducto)+'@'+(select idsubproducto2 from "
        sqlSelect += " subproductos where idsubproducto=ps.idsubproducto and sims_sn = (select sims_sn from subproductos with (nolock) "
        sqlSelect += " where idSubproducto2 = @materialNuevo and region = ps.region))+'@PS' from productos_serial ps with(nolock) where "
        sqlSelect += " serial = @serial and idpos is not null and iddespacho is not null)"
        sqlSelect += " end,'0@0@NT') as tabla from (select idpos,region from pos where idpos2=@codigoMay) auxPos "


        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlSelect)
            With sqlComando.Parameters
                .Add("@codigoMay", SqlDbType.VarChar).Value = arregloDatos(0).Trim
                .Add("@serial", SqlDbType.VarChar).Value = arregloDatos(1).Trim
                .Add("@materialAnt", SqlDbType.VarChar).Value = arregloDatos(2).Trim
                .Add("@materialNuevo", SqlDbType.VarChar).Value = arregloDatos(3).Trim
            End With
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            With sqlRead
                If .Read Then
                    resultado.idPos = IIf(IsDBNull(.GetValue(0)), 0, .GetValue(0))
                    resultado.idSubproductoAnterior = IIf(IsDBNull(.GetValue(1)), 0, .GetValue(1))
                    resultado.idSubproductoNuevo = IIf(IsDBNull(.GetValue(2)), 0, .GetValue(2))
                    arregloAux = .GetValue(3).ToString().Split("@")
                    If arregloAux.Length = 3 Then
                        resultado.idSubproductoAsignado = CInt(arregloAux(0))
                        resultado.materialAsignado = arregloAux(1)
                        resultado.tabla = arregloAux(2)
                    Else
                        resultado.idSubproductoAsignado = 0
                        resultado.materialAsignado = "0"
                        resultado.tabla = "NT"
                    End If
                End If
            End With
            Return resultado
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener equivalencias en BPCOLSYS. " & ex.Message)
        Finally
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Function

    Private Sub btnProcesar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnProcesar.Click
        Dim dtRegistros As New DataTable, nombreArchivo As String

        With dtRegistros.Columns
            .Add("idPos")
            .Add("serial")
            .Add("materialAnt")
            .Add("materialNuevo")
            .Add("tabla")
        End With

        pnlErrores.Visible = False

        Try
            nombreArchivo = subirArchivoAlServidor()
            If nombreArchivo <> "" Then
                leerDatosDelArchivo(dtRegistros, nombreArchivo)
                If dtRegistros.Rows.Count > 0 Then
                    actualizarMaterial(dtRegistros)
                    lblRes.Text = "Se actualizaron correctamente " & dtRegistros.Rows.Count & " registros.<br><br>"
                Else
                    lblError.Text = "El archivo no contiene registros válidos.<br><br>"
                End If
            Else
                lblError.Text = "Imposible subir el archivo al Servidor.<br><br> "
            End If
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        Finally
            If Not dtRegistros Is Nothing Then dtRegistros.Dispose()
        End Try
    End Sub

    Structure DatosEnBPColsys
        Public idPos, idSubproductoAnterior, idSubproductoNuevo, idSubproductoAsignado As Integer
        Public tabla, materialAsignado As String
    End Structure

    Private Sub actualizarMaterial(ByVal dtRegistros As DataTable)
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlTransaccion As SqlTransaction
        Dim sqlUpdatePS, sqlUpdateSims, sqlUpdateDOO As String
        Dim sqlQueryInvenUp, sqlQueryInvenDown, sqlInsertLog As String

        sqlUpdatePS = "update productos_serial set idProducto = (select idProducto from subproductos where "
        sqlUpdatePS += "idSubProducto = @idSubproducto),idsubproducto = @idSubproducto where serial = @serial"
        sqlUpdateSims = "update sims set idProducto = (select idProducto from subproductos where idSubProducto "
        sqlUpdateSims += "= @idSubproducto), idsubproducto = @idSubproducto where sim = @serial"
        sqlUpdateDOO = "update DespachosOtrosOperadores set idSubproducto = @idSubproducto where serial = @serial"

        sqlQueryInvenUp = "update pos_inventario set saldo = saldo + 1 where idpos = @idPos "
        sqlQueryInvenUp += " and idsubproducto = @idSubproducto "

        sqlQueryInvenDown = "update pos_inventario set saldo = saldo - 1 where idpos = @idPos "
        sqlQueryInvenDown += " and idsubproducto = @idSubproductoAnt "

        sqlInsertLog = " insert into LogCambioMaterialSerialEnPOS values(@serial,@idSubproductoAnt,@idSubproducto,"
        sqlInsertLog += " @tabla,getdate(),@idUsuario)"

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlUpdatePS)
            With sqlComando.Parameters
                .Add("@idPos", SqlDbType.Int).Value = 0
                .Add("@serial", SqlDbType.VarChar).Value = ""
                .Add("@idSubproducto", SqlDbType.Int).Value = 0
                .Add("@idSubproductoAnt", SqlDbType.Int).Value = 0
                .Add("@tabla", SqlDbType.VarChar, 5).Value = ""
                .Add("@idUsuario", SqlDbType.Int).Value = Session("usxp001")
            End With
            sqlConexion.Open()
            sqlTransaccion = sqlConexion.BeginTransaction
            sqlComando.Transaction = sqlTransaccion
            For Each drDato As DataRow In dtRegistros.Rows
                With drDato
                    sqlComando.Parameters("@idPos").Value = .Item(0)
                    sqlComando.Parameters("@serial").Value = .Item(1)
                    sqlComando.Parameters("@idSubproductoAnt").Value = .Item(2)
                    sqlComando.Parameters("@idSubproducto").Value = .Item(3)
                    Select Case drDato.Item(4).ToString
                        Case "PS"
                            sqlComando.CommandText = sqlUpdatePS
                            sqlComando.Parameters("@tabla").Value = "PS"
                        Case "SIM"
                            sqlComando.CommandText = sqlUpdateSims
                            sqlComando.Parameters("@tabla").Value = "SIM"
                        Case "DOO"
                            sqlComando.CommandText = sqlUpdateDOO
                            sqlComando.Parameters("@tabla").Value = "DOO"
                        Case Else
                            Throw New ArgumentNullException("Opcion no valida")
                    End Select
                    sqlComando.ExecuteNonQuery()
                    sqlComando.CommandText = sqlQueryInvenDown
                    sqlComando.ExecuteNonQuery()
                    sqlComando.CommandText = sqlQueryInvenUp
                    sqlComando.ExecuteNonQuery()
                    moverKardex(sqlConexion, sqlTransaccion, .Item(0), .Item(2), 2)
                    moverKardex(sqlConexion, sqlTransaccion, .Item(0), .Item(3), 1)
                    sqlComando.CommandText = sqlInsertLog
                    sqlComando.ExecuteNonQuery()
                End With
            Next
            sqlTransaccion.Commit()
        Catch ex As Exception
            If Not sqlTransaccion Is Nothing Then sqlTransaccion.Rollback()
            Throw New Exception("Error al tratar de actualizar Materiales. " & ex.Message)
        Finally
            MetodosComunes.liberarConexion(sqlConexion)
            sqlComando.Dispose()
            sqlTransaccion.Dispose()
        End Try
    End Sub

    Private Sub moverKardex(ByVal sqlConexion As SqlConnection, ByVal sqlTransaccion As SqlTransaction, _
           ByVal idPos As Integer, ByVal idSubproducto As Integer, ByVal tipoMovimiento As Byte)
        Dim sqlComando As SqlCommand, sqlSelect, sqlQuery, sqlSelProd As String
        Dim sqlRead As SqlDataReader, fechaKardex As Date
        Dim saldo, idPosKardex, idProducto As Integer

        sqlSelProd = "select idproducto from subproductos where idsubproducto=@idsubproducto"

        sqlSelect = "select idpos_kardex,saldo_final,fecha from pos_kardex where "
        sqlSelect += " idpos_kardex=(select max(idpos_kardex) from pos_kardex "
        sqlSelect += " where idpos=@idPos and idproducto=@idProducto and "
        sqlSelect += " idsubproducto=@idSubproducto)"

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlSelProd)
            sqlComando.Parameters.Add("@idPos", SqlDbType.Int).Value = idPos
            sqlComando.Parameters.Add("@idSubproducto", SqlDbType.Int).Value = idSubproducto
            'Se inicia en módo transaccional
            sqlComando.Transaction = sqlTransaccion
            'Se ejecuta la consulta para determinar el idProducto
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                idProducto = sqlRead.GetValue(0)
            End If
            sqlRead.Close()
            sqlComando.Parameters.Add("@idProducto", SqlDbType.Int).Value = idProducto
            sqlComando.CommandText = sqlSelect
            'Se ejecuta la consulta para determinar si existe Kardex para 
            ' la combinación POS,Producto, Subproducto
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                saldo = sqlRead.GetValue(1)
                fechaKardex = CDate(sqlRead.GetValue(2))
                If fechaKardex.ToShortDateString = Now.ToShortDateString Then
                    idPosKardex = sqlRead.GetValue(0)
                End If
            End If
            sqlRead.Close()
            'Se Arma la consulta adecuada para tratamiento de Kardex
            If idPosKardex <> 0 Then ' Si ya existe Kardex en la fecha actual, se actualiza el registro
                If tipoMovimiento = 1 Then
                    sqlQuery = "update pos_kardex set entradas = entradas + 1,saldo_final = saldo_final + 1 "
                Else
                    sqlQuery = "update pos_kardex set salidas = salidas + 1,saldo_final = saldo_final - 1 "
                End If
                sqlQuery += " where idpos_kardex=@idPosKardex"
                sqlComando.Parameters.Add("@idPosKardex", SqlDbType.Int).Value = idPosKardex
            Else ' De lo contrario, se crea un nuevo registro
                sqlQuery = "insert into pos_kardex(idpos,fecha,idproducto,idsubproducto,saldo_inicial,"
                sqlQuery += " entradas,salidas,saldo_final) values (@idPos,getdate(),@idProducto,"
                If tipoMovimiento = 1 Then
                    sqlQuery += " @idSubproducto,@saldo,1,0,@saldo + 1) "
                Else
                    sqlQuery += " @idSubproducto,@saldo,0,1,@saldo - 1) "
                End If
            End If
            sqlComando.Parameters.Add("@saldo", SqlDbType.Int).Value = saldo
            'Se realiza el movimiento del Kardex
            sqlComando.CommandText = sqlQuery
            sqlComando.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Error al tratar de mover Kardex. " & ex.Message)
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
        End Try
    End Sub

    Private Sub lbVerDetalle_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbVerDetalle.Click
        If Session.Count > 0 Then
            If lbVerDetalle.Text.StartsWith("Ver") Then
                dgDetalleErrores.Visible = True
                lbVerDetalle.Text = "Ocultar Detalle de Seriales sin Cambiar"
            Else
                dgDetalleErrores.Visible = False
                lbVerDetalle.Text = "Ver Detalle de Seriales sin Cambiar"
            End If
        End If
    End Sub

    Private Sub btnCambiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCambiar.Click
        Dim dtRegistro As New DataTable
        With dtRegistro.Columns
            .Add("idPos")
            .Add("serial")
            .Add("materialAnt")
            .Add("materialNuevo")
            .Add("tabla")
        End With

        pnlErrores.Visible = False

        Try
            procesarUnSerial(dtRegistro)
            If dtRegistro.Rows.Count > 0 Then
                pnlErrores.Visible = False
                actualizarMaterial(dtRegistro)
                lblRes.Text = "El serial se actualizó correctamente.<br><br>"
                limpiarTextBox(Me)
            End If
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        Finally
            If Not dtRegistro Is Nothing Then dtRegistro.Dispose()
        End Try
    End Sub

    Private Sub limpiarTextBox(ByVal cPadre As Control)
        For Each ctrl As Control In cPadre.Controls
            If TypeOf ctrl Is TextBox Then
                DirectCast(ctrl, TextBox).Text = ""
            Else
                If ctrl.Controls.Count > 0 Then
                    limpiarTextBox(ctrl)
                End If
            End If
        Next
    End Sub
End Class
