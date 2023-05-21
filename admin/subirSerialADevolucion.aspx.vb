Imports System.Data.SqlClient
Partial Class subirSerialADevolucion
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
        'seguridad.verificarSession (me)
        buscarDatosSerial()
    End Sub
    Private Sub buscarDatosSerial()
        Dim serial As String, conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, sentencia As String, dtSerial As New DataTable
        Dim especial As Int16, estado As String
        sentencia = "select * from seriales_despachados_cads where serial = @numSerial"
        serial = Request.QueryString("serial")
        Try
            MetodosComunes.inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            comando.Parameters.Add("@numSerial", SqlDbType.VarChar).Value = serial
            adaptador.Fill(dtSerial)
            If dtSerial.Rows.Count > 0 Then
                especial = dtSerial.Rows(0)("especial")
                estado = dtSerial.Rows(0)("estado")

                If especial = 1 Then
                    lblError.Text = "El Serial Número : " + serial + "<br>corresponde "
                    lblError.Text += "a una devolución especial el cual se debe subir "
                    lblError.Text += "<br>por la optión Lectura de Devoluciones Especiales "

                Else
                    If estado <> "ALMA" Then
                        cambioEstadoDevolucion()
                    Else
                        lblRes.Text = "El Serial Número " + serial + " el material es : " + dtSerial.Rows(0)("material")
                        lblRes.Text += "el material es : " + dtSerial.Rows(0)("material")
                    End If

                End If
            Else
                lblRes.Text = "No se encontro producto con el serial : " + serial
                Response.Redirect("subirManualSerial.aspx?serial=" + serial, True)
            End If

        Catch ex As Exception
            lblError.Text += "Error al cargar los datos : " & ex.Message
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            GC.Collect()
        End Try



    End Sub
    Private Sub cambioEstadoDevolucion()
        lblError.Text = "funcion cambioEstadoDevolucion"
    End Sub

End Class
