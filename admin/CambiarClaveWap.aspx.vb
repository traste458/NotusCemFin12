Imports System.Data.SqlClient
Imports System.Data
Imports System.IO
Imports System.Text
Imports System.Net

Partial Class CambiarClaveWap
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents TxtConfirmacionClave As System.Web.UI.WebControls.TextBox
    Protected WithEvents TxtClaveNueva1 As System.Web.UI.WebControls.TextBox


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
        'Put user code to initialize the page here
        Try
            Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
            lblError.Text = ""
            Anthem.Manager.Register(Me)
            If Not Page.IsPostBack And Not Anthem.Manager.IsCallBack Then
                cargarDatos()
                hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
                If ddlNombres.SelectedValue <> "0" And ddlNombres.SelectedValue <> "" Then lbConsultar.Visible = True
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de cargar página. " & ex.Message & "<br><br>"
        End Try
    End Sub

    Private Sub btnCrear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCrear.Click
        Dim claveEncriptada As String
        Try
            claveEncriptada = encriptarClave()
            actualizarClave(claveEncriptada)
        Catch ex As Exception
            lblError.Text = ex.Message
        End Try
    End Sub

    Public Sub llenarCampos(ByVal idTercero As String)
        '' Proced. que llena los campos usuario y clave
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlRead As SqlDataReader
        Dim sqlSelect As String, dtUsuarios As New DataTable, cadena As String
        Dim drsAuxiliar As DataRow()
        Try
            Me.lblResp.Text = ""
            dtUsuarios = CType(Session("dtTerceros"), DataTable)
            drsAuxiliar = dtUsuarios.Select("idtercero = " & idTercero.ToString)
            If drsAuxiliar.Length > 0 Then
                With txtUsuario
                    .Text = drsAuxiliar(0).Item("usuario").ToString
                    If .Text.Trim = "" Then
                        .BackColor = Nothing
                        .ReadOnly = False
                        Anthem.Manager.AddScriptForClientSideEval("document.Form1.hCrearUsuario.value='si'")
                    Else
                        .BackColor = Color.WhiteSmoke
                        Anthem.Manager.AddScriptForClientSideEval("document.Form1.hCrearUsuario.value='no'")
                    End If
                End With
                txtClaveActual.Attributes.Add("value", drsAuxiliar(0).Item("clave").ToString)
                lblCargo.Text = drsAuxiliar(0).Item("cargo").ToString
            End If
        Catch ex As Exception
            Me.lblError.Text = "No se encontro los datos del usuario " & ex.Message
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub

    Public Sub actualizarClave(ByVal clave As String)
        '' procedimiento que actualiza la clave y/o el usuario
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlUpdate As String, sqlTransaccion As SqlTransaction
        Try
            If clave <> "" Then
                sqlUpdate = "update terceros set clave=@clave,usuario=@usuario where idtercero = @idTercero "
                MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlUpdate)
                With sqlComando.Parameters
                    .Add("@clave", SqlDbType.VarChar).Value = clave
                    .Add("@usuario", SqlDbType.VarChar, 30).Value = txtUsuario.Text.Trim
                    .Add("@idTercero", SqlDbType.Int).Value = ddlNombres.SelectedValue
                End With
                sqlConexion.Open()
                sqlTransaccion = sqlConexion.BeginTransaction()
                sqlComando.Transaction = sqlTransaccion
                sqlComando.ExecuteNonQuery()
                sqlTransaccion.Commit()
                Me.lblResp.Text = "La información del Usuario actualizó satisfactoriamente"
                txtCedula.Text = ""
            End If
        Catch ex As Exception
            If Not sqlTransaccion Is Nothing Then sqlTransaccion.Rollback()
            Me.lblError.Text = "Error al tratar de registrar la información. " & ex.Message
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub

    Private Sub cargarDatos()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim dtNombres As New DataTable, sqlSelect As String, sqlAdaptador As SqlDataAdapter
        '' procedimiento que carga los Usuarios
        Try
            sqlSelect = "select idtercero,tercero+' ('+idtercero2+')' as tercero,usuario,clave,idtercero2 as cedula, "
            sqlSelect += " isnull((select cargo from cargos where idcargo=t.idcargo),'SIN CARGO') as cargo from terceros t "
            sqlSelect += " where idcargo in (78,79,83, 85, 86, 90, 119) and estado= 1 "
            sqlSelect += " order by tercero "
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)

            sqlAdaptador.Fill(dtNombres)
            Session.Remove("dtTerceros")
            Session("dtTerceros") = dtNombres
            With ddlNombres
                .DataSource = dtNombres
                .DataTextField = "tercero"
                .DataValueField = "idtercero"
                .DataBind()
                If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja un Nombre de la Lista", "0"))
            End With
            lblNumNombres.Text = dtNombres.Rows.Count.ToString & " Usuarios Encontrados"
        Catch ex As Exception
            Me.lblError.Text = "No se pudieron Cargar los datos" & ex.Message
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub

    Private Sub ddlNombres_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlNombres.SelectedIndexChanged
        If Session.Count > 0 Then
            If ddlNombres.SelectedValue = "0" Then
                limpiar()
            Else
                llenarCampos(ddlNombres.SelectedValue)
            End If
            pnlHistorial.Visible = False
            If ddlNombres.SelectedValue <> "" And ddlNombres.SelectedValue <> "0" Then
                lbConsultar.Visible = True
            Else
                lbConsultar.Visible = False
            End If
            Anthem.Manager.AddScriptForClientSideEval("document.Form1.ddlNombres.focus();")
        End If
    End Sub

    Private Function encriptarClave() As String
        Dim claveEncriptada As String

        Try
            Dim myRequest As HttpWebRequest, myResponse As HttpWebResponse
            Dim encode As System.Text.Encoding, leerStreamRespuesta As StreamReader
            Dim oUrl As System.Uri, arregloAux(), urlAux As String


            oUrl = HttpContext.Current.Request.Url
            arregloAux = oUrl.AbsolutePath.Split("/")
            If arregloAux.Length > 2 Then
                urlAux = oUrl.Scheme & "://" & oUrl.Host & ":" & oUrl.Port.ToString & "/" & arregloAux(1)
            Else
                urlAux = oUrl.Scheme & "://" & oUrl.Host & ":" & oUrl.Port.ToString
            End If

            myRequest = WebRequest.Create(urlAux & "/encriptar.asp?cadena=" & txtClaveNueva.Text)
            myRequest.Credentials = CredentialCache.DefaultCredentials

            myResponse = myRequest.GetResponse

            encode = System.Text.Encoding.GetEncoding("utf-8")

            leerStreamRespuesta = New StreamReader(myResponse.GetResponseStream, encode)
            claveEncriptada = leerStreamRespuesta.ReadToEnd
            Return claveEncriptada
        Catch ex As Exception
            lblError.Text = "Error al tratar de encriptar Clave. " & ex.Message
        End Try

    End Function

    Private Sub limpiar()
        txtUsuario.Text = ""
        ddlNombres.ClearSelection()
        txtClaveActual.Attributes.Add("Value", "")
        txtClaveNueva.Attributes.Add("Value", "")
        txtRepetirClave.Attributes.Add("Value", "")
        lblCargo.Text = ""
    End Sub

    Private Sub limpiarInfoPersonal()
        '****Limpiar Labes que almacenan Información Personal****'
        lblNombres.Text = ""
        lblCargoAct.Text = ""
        lblPos.Text = ""
        lblTemporal.Text = ""
        lblUsuario.Text = ""
        lblTelefono.Text = ""
        lblIdentificacion.Text = ""
        lblCiudad.Text = ""
        lblCentroCosto.Text = ""
        lblFechaIngreso.Text = ""
        lblEstado.Text = ""
    End Sub

    <Anthem.Method()> _
    Public Sub filtrarNombres(ByVal cedula As String)
        If Session.Count > 0 Then
            Dim dtAux As New DataTable, dtNombres As New DataTable
            Dim drsAux() As DataRow

            Try
                dtNombres = CType(Session("dtTerceros"), DataTable)
                If cedula.Trim <> "" Then
                    dtAux = dtNombres.Clone
                    drsAux = dtNombres.Select("cedula like '" & cedula.Trim & "%'", "tercero asc")
                    For index As Integer = 0 To drsAux.Length - 1
                        dtAux.ImportRow(drsAux(index))
                    Next
                Else
                    dtAux = dtNombres.Copy
                End If
                With ddlNombres
                    .DataSource = dtAux
                    .DataTextField = "tercero"
                    .DataValueField = "idtercero"
                    .DataBind()
                    If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Escoja un Nombre de la lista", "0"))
                End With
                lblNumNombres.Text = dtAux.Rows.Count.ToString & " Usuarios Encontrados"
                If ddlNombres.SelectedValue = "0" Then
                    limpiar()
                Else
                    llenarCampos(ddlNombres.SelectedValue)
                End If
                pnlHistorial.Visible = False
                If ddlNombres.SelectedValue <> "" And ddlNombres.SelectedValue <> "0" Then
                    lbConsultar.Visible = True
                Else
                    lbConsultar.Visible = False
                End If
            Catch ex As Exception
                lblError.Text = "Error al tratar de filtrar Nombres. " & ex.Message & "<br><br>"
            End Try
        End If
    End Sub

    Private Sub getHistorialUsuario()
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlAdaptador As SqlDataAdapter
        Dim dtHistorial As New DataTable, sqlRead As SqlDataReader, sqlSelect As String

        sqlSelect = "select tercero,(select cargo from cargos where idcargo=t.idcargo) as cargo, "
        sqlSelect += " (select pos from pos with(nolock) where idpos=t.idpos) as pos,(select nombre from "
        sqlSelect += " empresas_temporales where idempresa_temporal=t.idempresa_temporal) as empresaTemporal,"
        sqlSelect += " usuario,telefono,idtercero2 as identificacion,(select ciudad from ciudades with(nolock) "
        sqlSelect += " where idciudad=t.idciudad) as ciudad,(select nombre from centros_costo where "
        sqlSelect += " idcentro_costo=t.idcentro_costo) as centroCosto,(select min(fecha_inicial) from terceros_historial"
        sqlSelect += " with(nolock) where idtercero=t.idtercero) as fechaInicial, case when estado=1 then 'Activo' else"
        sqlSelect += " 'Inactivo' end as estado from terceros t with(nolock) where idtercero = @idTercero "

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlComando.Parameters.Add("@idTercero", SqlDbType.Int).Value = ddlNombres.SelectedValue
            sqlConexion.Open()
            '****Obtener la Información Personal del Usuario****'
            sqlRead = sqlComando.ExecuteReader
            If sqlRead.Read Then
                With sqlRead
                    lblNombres.Text = .GetValue(0).ToString
                    lblCargoAct.Text = .GetValue(1).ToString
                    lblPos.Text = .GetValue(2).ToString
                    lblTemporal.Text = .GetValue(3).ToString
                    lblUsuario.Text = .GetValue(4).ToString
                    lblTelefono.Text = .GetValue(5).ToString
                    lblIdentificacion.Text = .GetValue(6).ToString
                    lblCiudad.Text = .GetValue(7).ToString
                    lblCentroCosto.Text = .GetValue(8).ToString
                    lblFechaIngreso.Text = .GetValue(9).ToString
                    lblEstado.Text = .GetValue(10).ToString
                End With
            End If
            sqlRead.Close()
            '**************************************************'
            '****Obtener el Historial de Movimientos del Usuario****'
            sqlSelect = "select (select cargo from cargos where idcargo = th.idcargo ) as cargo, "
            sqlSelect += " (select nombre from centros_costo where idcentro_costo = th.idcentro_costo) as centroCosto, "
            sqlSelect += " (select pos from pos with(nolock) where idpos = th.idpos ) as pos, "
            sqlSelect += " (select nombre from empresas_temporales where idempresa_temporal=th.idempresa_temporal) as empresaTemporal, "
            sqlSelect += "  fecha_inicial,fecha_final,(select tercero from terceros where idtercero=th.idmodificador) as modificador, "
            sqlSelect += "  case when estado=1 then '<font color=""blue"">Activo</font>' else '<font color=""red"">Inactivo</font>' end "
            sqlSelect += "  as estado from terceros_historial th with(nolock) where th.idtercero = @idTercero order by fecha_inicial"
            sqlComando.CommandText = sqlSelect
            sqlAdaptador.Fill(dtHistorial)
            With dgHistorial
                .DataSource = dtHistorial
                .Columns(0).FooterText = dtHistorial.Rows.Count.ToString & " Movimientos Encontrados"
                .DataBind()
            End With
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener el Historial de Movimientos del usuario. " & ex.Message)
        Finally
            If Not dtHistorial Is Nothing Then dtHistorial.Dispose()
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub

    Private Sub lbConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbConsultar.Click
        If Session.Count > 0 Then
            Try
                getHistorialUsuario()
                pnlHistorial.Visible = True
            Catch ex As Exception
                lblError.Text = ex.Message
            End Try
        End If
    End Sub

    Private Sub dgHistorial_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgHistorial.ItemDataBound
        If e.Item.ItemType = ListItemType.Footer Then
            For index As Integer = 1 To 7
                e.Item.Cells.RemoveAt(1)
            Next
            e.Item.Cells(0).ColumnSpan = 8
        End If
    End Sub
End Class
