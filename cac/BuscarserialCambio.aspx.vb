Partial Class BuscarserialCambio
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents archivosRemisiones As System.Web.UI.HtmlControls.HtmlInputFile

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
        hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
        Seguridad.verificarSession(Me, True)
        If Not IsPostBack Then
            btnConsultar.Attributes.Add("onclick", "divImagen.style.display='block';")
            cargarCAC()
        End If
    End Sub
    Private Sub cargarCAC()
        Dim sentencia As String, dtDatos As DataTable
        Try
            sentencia = "select idCac, cac from cac with(nolock) "
            dtDatos = MetodosComunes.consultaBaseDatos(sentencia)
            Session.Remove("dtCAC")
            Session.Add("dtCAC", dtDatos)
            ddlCAC.Items.Insert(0, New ListItem("Seleccione un CAC", "0"))
            lblRegistros.Text = "0 Registro(s) Encontrado(s)"
        Catch ex As Exception
            lblError.Text = "Error al cargar los CAC: " & ex.Message
        End Try
    End Sub
    <Anthem.Method()> _
    Public Function BuscarCACFiltrado(ByVal filtro As String)
        Dim dtDatos As DataTable, drAux() As DataRow
        Try
            dtDatos = CType(Session("dtCAC"), DataTable).Clone
            drAux = CType(Session("dtCAC"), DataTable).Select("cac like '%" & filtro & "%'")
            For index As Integer = 0 To drAux.GetUpperBound(0)
                dtDatos.ImportRow(drAux(index))
            Next
            With ddlCAC
                .DataSource = dtDatos
                .DataValueField = "idCAC"
                .DataTextField = "CAC"
                .DataBind()
                lblRegistros.Text = dtDatos.Rows.Count & " Registro(s) Encontrado(s)"
                If dtDatos.Rows.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione un CAC", "0"))
            End With
        Catch ex As Exception
            lblError.Text = "Error al filtrar los CAC: " & ex.Message
        End Try
    End Function
    Private Function subirArchivoServer() As String
        Dim valorReturn As String
        valorReturn = Server.MapPath("../archivos_planos/") & "SerialesCAC" & Session("usxp001") & ".txt"
        If System.IO.File.Exists(valorReturn) Then
            archivosSeriales.PostedFile.SaveAs(valorReturn)
        Else
            Throw New Exception("No se encuentra el archivo en la ruta especificada")
        End If
        Return valorReturn
    End Function
    Private Function leerDatosArchivo(ByVal NombreArchivo As String) As ArrayList
        Dim serialesReturn As New ArrayList, datosArchivo As String
        Dim lectorArchivo As System.IO.StreamReader
        Dim datos As System.IO.FileStream
        lectorArchivo = System.IO.File.OpenText(NombreArchivo)
        While lectorArchivo.Peek >= 0
            datosArchivo = lectorArchivo.ReadLine.ToString
            If datosArchivo.Trim.Trim <> "" Then
                serialesReturn.Add(datosArchivo.Trim)
            End If
        End While
        Return serialesReturn
    End Function
    Private Function cargarArchivo() As ArrayList
        Dim seriales As ArrayList, nombreArchivo As String
        Try
            nombreArchivo = subirArchivoServer()
            seriales = leerDatosArchivo(nombreArchivo)
            Return seriales
        Catch ex As Exception
            Throw New Exception("Error al cargar el archivo texto: " & ex.Message)
        End Try
    End Function

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Dim SerialesArray As ArrayList
        Try
            If archivosSeriales.PostedFile.FileName <> "" Then
                SerialesArray = cargarArchivo()
            End If
            If txtSerial.Text.Trim <> "" Then
                If SerialesArray Is Nothing Then SerialesArray = New ArrayList
                SerialesArray.Add(txtSerial.Text.Trim)
            End If
            If Not SerialesArray Is Nothing Then
                Session.Add("arraySeriales", SerialesArray)
            Else
                Session.Remove("arraySeriales")
            End If
            Response.Redirect("SerialCambioCAC.aspx?idCac=" & ddlCAC.SelectedValue, True)

        Catch ex As Exception
            lblError.Text = ex.Message
        End Try
    End Sub
End Class
