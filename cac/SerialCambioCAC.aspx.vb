Imports System.Data.SqlClient
Partial Class SerialCambioCAC
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
        'Put user code to initialize the page here
        Seguridad.verificarSession(Me, True)
        lblError.Text = ""
        lblRes.Text = ""
        If Not IsPostBack Then
            cargarSeriales()
            cargarProducto()
            cargarSubproducto()
        End If
    End Sub
    Private Sub cargarSeriales()
        Dim sentencia As String, dtDatos As DataTable, parametros As SqlParameter, arregloParam As New ArrayList
        Try
            sentencia = "select serial,isNull((select max(serialAnterior) from logSerialesCambiadosCAC with(nolock) where serialNuevo = ca.serial),'Sin Modificación') as SerialNew,"
            sentencia += " isnull((select producto from productos with(nolock) where idProducto = ca.idProducto),'Sin Producto') as producto,"
            sentencia += " isnull((select subproducto from subproductos with(nolock) where idSubProducto =  ca.idSubProducto),'Sin Referencia') as Subproducto, "
            sentencia += " isnull((select  cac from cac with(nolock) where idCac =  ca.idCac),'CAC Desconocido') as cac,"
            sentencia += " isnull((select idOrden2_cac from ordenes_cac with(nolock) where idOrden_cac in (select max(idORden_cac) from ordenes_cac_detalle with(nolock) "
            sentencia += "where serial = ca.serial)),'Sin Orden') as orden from cac_seriales ca with(nolock) where "

            If Not Session("arraySeriales") Is Nothing Then
                sentencia += "serial in ('" & Join(CType(Session("arraySeriales"), ArrayList).ToArray, "','") & "')"

                dtDatos = MetodosComunes.consultaBaseDatos(sentencia)
            ElseIf Request.QueryString("idCac") <> 0 Then
                sentencia += "idCac = @idCac"
                arregloParam.Add(New SqlParameter("@idCac", Request.QueryString("idCac")))
                dtDatos = MetodosComunes.consultaBaseDatos(sentencia, arregloParam)
            End If
            If dtDatos.Rows.Count > 0 Then
                With dgSeriales
                    .DataSource = dtDatos
                    .Columns(0).FooterText = dtDatos.Rows.Count & " Registro(s) Encontrado(s)"
                    .DataBind()
                End With
                MetodosComunes.mergeFooter(dgSeriales)
            Else
                lblError.Text = "No existe seriales con los criterios seleccionados"
            End If
        Catch ex As Exception
            lblError.Text = "Error al cargar los seriales: " & ex.Message
        End Try
    End Sub
    Private Sub cargarProducto()
        Dim dtDatos As DataTable
        dtDatos = MetodosComunes.getAllProductos
        With ddlProducto
            .DataSource = dtDatos
            .DataValueField = "idProducto"
            .DataTextField = "Producto"
            .DataBind()
            .Items.Insert(0, New ListItem("Seleccione un Producto", "0"))
        End With
    End Sub
    Private Sub cargarSubproducto(Optional ByVal dtSubproducto As DataTable = Nothing)
        Dim dtDatos As DataTable
        If dtSubproducto Is Nothing Then
            dtDatos = MetodosComunes.getAllSubproductos
            Session.Remove("subProducto")
            Session.Add("subProducto", dtDatos)
        Else
            dtDatos = dtSubproducto
        End If

        With ddlSubproducto
            .DataSource = dtDatos
            .DataValueField = "idsubProducto"
            .DataTextField = "subProducto"
            .DataBind()
            .Items.Insert(0, New ListItem("Seleccione una Referencia", "0"))
        End With
    End Sub

    Private Sub dgSeriales_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgSeriales.EditCommand
        lblSeriaOLD.Text = e.Item.Cells(1).Text.Trim
        lblCAC.Text = e.Item.Cells(5).Text.Trim
        lblReferencia.Text = e.Item.Cells(4).Text.Trim
    End Sub
    <Anthem.Method()> _
    Public Sub registrarSerialNEW(ByVal serialNew As String, ByVal producto As String, ByVal subproducto As String)
        Dim sentencia As String, conexion As SqlConnection, comando As SqlCommand, resultado As Integer
        Dim arregloSeriales As ArrayList
        Try
            sentencia = "pa_cambioSerialCAC"
            MetodosComunes.inicializarObjetos(conexion, comando, sentencia)
            conexion.Open()
            With comando
                .CommandType = CommandType.StoredProcedure
                With .Parameters
                    .Add("@serialNew", SqlDbType.VarChar).Value = serialNew.Trim
                    .Add("@serialOld", SqlDbType.VarChar).Value = lblSeriaOLD.Text.Trim.Trim
                    .Add("@idProducto", SqlDbType.BigInt).Value = Integer.Parse(producto)
                    .Add("@idSubproducto", SqlDbType.BigInt).Value = Integer.Parse(subproducto)
                    .Add("@idUsuario", SqlDbType.Int).Value = Integer.Parse(Session("usxp001"))
                End With
                resultado = .ExecuteScalar
            End With
            Select Case resultado
                Case 0
                    lblRes.Text = "Se realizo correctamente la actualización del serial"
                    If Not Session("arraySeriales") Is Nothing Then
                        arregloSeriales = CType(Session("arraySeriales"), ArrayList)
                        For index As Integer = 0 To arregloSeriales.Count - 1
                            If arregloSeriales(index) = lblSeriaOLD.Text Then
                                arregloSeriales(index) = serialNew
                            End If
                        Next
                        Session("arraySeriales") = arregloSeriales
                    End If
                    cargarSeriales()
                    txtSerialNEW.Text = ""
                    ddlProducto.SelectedValue = 0
                    ddlSubproducto.SelectedValue = 0
                Case 1
                    lblError.Text = "El serial " & serialNew & " ya se encuentra registrado en el inventario de CAC"
                Case 2
                    lblError.Text = "El serial " & lblSeriaOLD.Text & " no existe en el Inventario"
                Case Else
                    lblError.Text = "Error no definido"
            End Select
            
        Catch ex As Exception
            lblError.Text = "Error al actualizar los datos del serial: " & ex.Message & ex.StackTrace
        Finally
            MetodosComunes.liberarConexion(conexion)
            Anthem.Manager.RegisterClientScriptBlock(Me.GetType, "Cerrar", "ocultarVentana();")
        End Try
    End Sub

    <Anthem.Method()> _
    Public Function buscarSubproducto(ByVal valor As String)
        Dim dtDatos As DataTable, drAux() As DataRow
        Try
            If valor <> "0" Then
                dtDatos = CType(Session("subProducto"), DataTable).Clone
                drAux = CType(Session("subProducto"), DataTable).Select("idproducto = " & valor)
                For index As Integer = 0 To drAux.GetUpperBound(0)
                    dtDatos.ImportRow(drAux(index))
                Next

            Else
                dtDatos = CType(Session("subProducto"), DataTable)
            End If
            cargarSubproducto(dtDatos)
        Catch ex As Exception
            lblError.Text += "Error al Buscar el dato"
        End Try
    End Function

    'Protected Sub ddlProducto_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlProducto.SelectedIndexChanged
    '    Dim dtDatos As DataTable, drAux() As DataRow
    '    Try
    '        lblError.Text = ddlProducto.SelectedValue
    '        If ddlProducto.SelectedValue <> "0" Then
    '            dtDatos = CType(Session("subProducto"), DataTable).Clone
    '            drAux = CType(Session("subProducto"), DataTable).Select("idproducto = " & ddlProducto.SelectedValue)
    '            For index As Integer = 0 To drAux.GetUpperBound(0)
    '                dtDatos.ImportRow(drAux(index))
    '            Next

    '        Else
    '            dtDatos = CType(Session("subProducto"), DataTable)
    '        End If
    '        cargarSubproducto(dtDatos)
    '    Catch ex As Exception
    '        lblError.Text += "Error al Buscar el dato"
    '    End Try
    'End Sub
End Class
