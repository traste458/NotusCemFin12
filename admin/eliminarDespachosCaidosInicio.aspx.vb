Imports System.IO
Imports System.Data.SqlClient

Partial Class eliminarDespachosCaidosInicio
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
        Server.ScriptTimeout = 600
        lblError.Text = ""
        lblRes.Text = ""
        btnEliminar.Attributes.Add("onclick", "divImagen.style.display='block'")
        If Not Me.IsPostBack Then
            hlRegresar.NavigateUrl = MetodosComunes.getUrlFrameBack(Me)
        End If
    End Sub

    Private Sub btnEliminar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEliminar.Click
        Dim remisiones, despachos As String
        Try
            guardarArchivo()
            remisiones = leerArchivo()

            If remisiones <> "" Then
                despachos = getNumerosDespachos(remisiones)

                If despachos <> "" Then
                    eliminarRemisiones(despachos)
                    lblRes.Text = "Las Remisiones se Eliminaron Satisfactoriamente.<br><br>"
                Else
                    lblError.Text = "No se encontraron Números de despacho asociados a las remisiones en el archivo.<br><br>"
                End If
            Else
                lblError.Text = "El archivo no contienes remisiones válidas.<br><br>"
            End If
        Catch ex As Exception
            lblError.Text = ex.Message & "<br><br>"
        End Try
    End Sub

    Private Sub guardarArchivo()
        Dim nombreArchivo As String

        Try
            If Path.GetExtension(flArchivo.PostedFile.FileName) = ".txt" Then
                nombreArchivo = Server.MapPath("../archivos_planos/remisionesCaidas" & String.Format("{0:ddMMMyyy}", Now) & "_" & Session("usxp001") & ".txt")
                flArchivo.PostedFile.SaveAs(nombreArchivo)
            Else
                Throw New Exception("El archivo que está tratando de subir no és un archivo de texto con extensión .TXT")
            End If
        Catch ex As Exception
            Throw New Exception("Error al tratar de guardar el archivo en el Servidor:<br>" & ex.Message)
        End Try
    End Sub

    Private Function leerArchivo() As String
        Dim remisiones, nombreArchivo, remision As String, arrRemisiones As New ArrayList
        Dim elArchivo As StreamReader

        Try
            nombreArchivo = Server.MapPath("../archivos_planos/remisionesCaidas" & String.Format("{0:ddMMMyyy}", Now) & "_" & Session("usxp001") & ".txt")
            elArchivo = File.OpenText(nombreArchivo)
            While elArchivo.Peek >= 0
                remision = elArchivo.ReadLine
                'If remision.Trim.Replace(vbTab, "") Then arrRemisiones.Add(remision)
                arrRemisiones.Add(remision.Trim.Replace(vbTab, ""))
            End While
            If arrRemisiones.Count <> 0 Then
                remisiones = "'" & Join(arrRemisiones.ToArray, "','") & "'"
            End If
            Return remisiones
        Catch ex As Exception
            Throw New Exception("Error al tratar de Leer Archivo. " & ex.Message)
        Finally
            If Not elArchivo Is Nothing Then elArchivo.Close()
        End Try
    End Function

    Private Function getNumerosDespachos(ByVal remisiones As String) As String
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlRead As SqlDataReader
        Dim sqlSelect, despachos As String, arrDespachos As New ArrayList

        sqlSelect = "select iddespacho from despachos with(nolock) where iddespacho2 in (" & remisiones & ") "
        sqlSelect += "order by iddespacho2"
        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlSelect)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            While sqlRead.Read
                arrDespachos.Add(sqlRead.GetValue(0).ToString)
            End While
            If arrDespachos.Count <> 0 Then despachos = Join(arrDespachos.ToArray, ",")
            Return despachos
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener los números de despacho: <br>" & ex.Message)
        Finally
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Function

    Private Sub eliminarRemisiones(ByVal despachos As String)
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlTransaccion As SqlTransaction, sqlQuery As String

        Try
            sqlQuery = "delete from despachosdetalle_serial where iddespacho in(" & despachos & "); "
            sqlQuery += "delete from despachosdetalle where iddespacho in(" & despachos & "); "
            sqlQuery += "delete from planos_despachos_aux where iddespacho in(" & despachos & "); "
            sqlQuery += "update productos_serial set idpos = NULL, iddespacho = NULL where iddespacho in (" & despachos & "); "
            sqlQuery += "update sims set idpos = NULL, iddespacho = NULL where iddespacho in(" & despachos & "); "
            sqlQuery += "delete from transito_detalle where idtransito in "
            sqlQuery += " (select idtransito from transito with(nolock) where iddespacho in (" & despachos & ")); "
            sqlQuery += "delete from transito where iddespacho in (" & despachos & "); "
            sqlQuery += "delete from despachos where iddespacho in(" & despachos & ")"

            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlQuery)
            sqlComando.CommandTimeout = 300
            sqlConexion.Open()
            sqlTransaccion = sqlConexion.BeginTransaction
            sqlComando.Transaction = sqlTransaccion
            sqlComando.ExecuteNonQuery()
            sqlTransaccion.Commit()
        Catch ex As Exception
            If Not sqlTransaccion Is Nothing Then sqlTransaccion.Rollback()
            Throw New Exception("Error al tratar de Eliminar Remisiones:<br>" & ex.Message & ex.StackTrace)
        Finally
            MetodosComunes.liberarConexion(sqlConexion)
        End Try
    End Sub
End Class
