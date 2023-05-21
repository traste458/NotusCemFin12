Public Partial Class ReporteProductoNoConformeCliente
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me, Anthem.Manager.IsCallBack)
        Dim dtDatos As New DataTable
        Dim strNombreArchivo As String = Request.QueryString("nombreArchivo")
        Dim strTitulo As String = Request.QueryString("Titulo")

        dtDatos = Session("dtDatosNCSAP")
        EnlazarDatos(dtDatos, strTitulo, strNombreArchivo)
        Response.Redirect("../adm_operativo/ReporteNoConformesClienteExcel.aspx")
    End Sub

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, ByVal titulo As String, ByVal nombreArchivo As String)
        Dim sw As New System.IO.StringWriter, htw As New System.Web.UI.HtmlTextWriter(sw)
        Try
            With dgDatos
                .ItemStyle.CssClass = "text"
                .DataSource = dtDatos
                .DataBind()
                .RenderControl(htw)
            End With
            MetodosComunes.exportarDatosAExcel(HttpContext.Current, sw.ToString, titulo, nombreArchivo)
        Catch ex As Exception
            Throw New Exception("Error al tratar de exportar reporte. " & ex.Message)
        End Try

    End Sub

   
End Class