Imports System.IO
Imports LMDataAccessLayer
Imports System.Text.RegularExpressions

Partial Public Class RegistrarSerialesGarantia
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        epNotificador.clear()
        Seguridad.verificarSession(Me)
        If Not Me.IsPostBack Then
            epNotificador.setTitle("Registrar Seriales - Información de Garantías")
            epNotificador.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            pnlResultadoArchivo.Visible = False
        End If
    End Sub

    Private Function ObtenerSerialesDesdeArchivo(ByVal dtError As DataTable) As DataTable
        Dim ruta As String = Server.MapPath("~/archivos_planos/RegistrarSerialesGarantia" & Session("usxp001") & ".txt")
        Dim fileReader As StreamReader = Nothing
        Dim dtDatos As DataTable = GenerarEstructuraDeTablaDatos()
        Dim registro As String
        Dim arrDatos() As String

        Try
            fuManager.PostedFile.SaveAs(ruta)
            If File.Exists(ruta) Then
                fileReader = File.OpenText(ruta)
                Dim numLinea As Integer = 1
                Dim patronRegex As String = "^" & MetodosComunes.seleccionarConfigValue("REGEX_LONGITUD_SERIALES") & "$"
                Dim oRegEx As New Regex(patronRegex)
                Dim fechaAux As Date
                Dim idUsuario As Integer
                Integer.TryParse(Session("usxp001"), idUsuario)
                While fileReader.Peek > -1
                    registro = fileReader.ReadLine.Trim
                    If registro.Length > 0 Then
                        arrDatos = registro.Split(",")
                        If arrDatos.Length = 3 Then
                            If oRegEx.IsMatch(arrDatos(0).Trim) Then
                                'If Not ExisteSerial(arrDatos(0).Trim) Then
                                If Date.TryParse(arrDatos(2).Trim, fechaAux) Then
                                    AdicionarSerial(dtDatos, arrDatos(0).Trim, arrDatos(1).Trim, fechaAux, idUsuario, numLinea)
                                Else
                                    AdicionarRegistroErroneo(dtError, numLinea, "La fecha de cargue proporcioada no es válida: " & arrDatos(2).Trim)
                                End If
                                'Else
                                'AdicionarRegistroErroneo(dtError, numLinea, "El serial:  " & arrDatos(0).Trim & " ya se encuentra registrado en la Base de Datos.")
                                'End If
                            Else
                                AdicionarRegistroErroneo(dtError, numLinea, "El serial:  " & arrDatos(0).Trim & " no es válido")
                            End If
                        Else
                            AdicionarRegistroErroneo(dtError, numLinea, "Formato de registro no válido. Número de campos esperados no concuerda")
                        End If
                    End If
                    numLinea += 1
                End While
            Else
                Throw New Exception("No se encontró el archivo en el servidor. Por favor intente nuevamente")
            End If
        Catch ex As Exception
            Throw New Exception("Imposible leer datos de archivo. " & ex.Message)
        Finally
            If fileReader IsNot Nothing Then fileReader.Close()
        End Try
        Return dtDatos
    End Function

    Private Function GenerarEstructuraDeTablaDatos() As DataTable
        Dim dtAux As New DataTable
        With dtAux
            .Columns.Add("serial", GetType(String))
            .Columns.Add("material", GetType(String))
            .Columns.Add("fechaCargue", GetType(Date))
            .Columns.Add("idUsuario", GetType(Integer))
            .Columns.Add("linea", GetType(Integer))
        End With
        Dim pkColumn(0) As DataColumn
        pkColumn(0) = dtAux.Columns("serial")
        dtAux.PrimaryKey = pkColumn
        Return dtAux
    End Function

    Private Function GenerarEstructuraDeTablaError() As DataTable
        Dim dtAux As New DataTable
        With dtAux
            .Columns.Add("linea", GetType(Integer))
            .Columns.Add("descripcion", GetType(String))
        End With
        Return dtAux
    End Function

    Private Sub AdicionarSerial(ByVal dtDatos As DataTable, ByVal serial As String, ByVal material As String, _
        ByVal fechaCargue As Date, ByVal idUsuario As Integer, ByVal linea As Integer)
        Dim drAux As DataRow
        drAux = dtDatos.Rows.Find(serial)
        If drAux Is Nothing Then
            drAux = dtDatos.NewRow
            drAux("serial") = serial
            drAux("material") = material
            drAux("fechaCargue") = fechaCargue
            drAux("idUsuario") = idUsuario
            drAux("linea") = linea
            dtDatos.Rows.Add(drAux)
        End If
    End Sub

    Private Sub AdicionarRegistroErroneo(ByVal dtError As DataTable, ByVal linea As Integer,  ByVal mensajeError As String)
        Dim drAux As DataRow
        drAux = dtError.NewRow
        drAux("linea") = linea
        drAux("descripcion") = mensajeError
        dtError.Rows.Add(drAux)
    End Sub

    Private Function ExisteSerial(ByVal serial As String) As Boolean
        Dim dbManager As New LMDataAccess
        Dim resultado As Boolean
        Try
            With dbManager
                .SqlParametros.Add("@serial", SqlDbType.VarChar, 20).Value = serial
                resultado = CBool(.ejecutarScalar("ExisteSerialEnInfoGarantia", CommandType.StoredProcedure))
            End With
        Finally
            If dbManager IsNot Nothing Then dbManager.Dispose()
        End Try
        Return resultado
    End Function

    Protected Sub btnRegistrarArchivo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrarArchivo.Click
        Dim dtError As DataTable = GenerarEstructuraDeTablaError()
        pnlResultadoArchivo.Visible = False
        Try
            Dim dtDatos As DataTable = ObtenerSerialesDesdeArchivo(dtError)
            ValidarExistenciaDeSeriales(dtDatos, dtError)
            If dtError.Rows.Count = 0 Then
                If dtDatos.Rows.Count > 0 Then
                    RegistrarSeriales(dtDatos)
                    epNotificador.showSuccess("Los seriales fueron registrados satosfactoriamente.")
                Else
                    epNotificador.showWarning("El archivo especificado no contiene registros válidos. Por favor verifique")
                End If
            Else
                epNotificador.showWarning("El archivo especificado contiene registros no válidos. No se puede continuar con el registro. Por favor revise el log de registros erróneos.")
                Session("dtListaErrores") = dtError
                EnlazarErrores(dtError)
            End If
        Catch ex As Exception
            epNotificador.showError("Error al tratar de procesar y registrar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub RegistrarSeriales(ByVal dtDatos As DataTable)
        Dim dbManager As New LMDataAccess
        Dim dcAux As New DataColumn("idUsuario")
        Dim idUsuario As Integer = IIf(Session("usxp001") IsNot Nothing, Session("usxp001"), 1)
        dcAux.DefaultValue = idUsuario

        Try
            With dbManager
                .inicilizarBulkCopy()
                With .BulkCopy
                    .DestinationTableName = "InfoGarantia"
                    .ColumnMappings.Add("serial", "serial")
                    .ColumnMappings.Add("material", "material")
                    .ColumnMappings.Add("fechaCargue", "fechaCargue")
                    .ColumnMappings.Add("idUsuario", "idUsuario")
                    .WriteToServer(dtDatos)
                End With
            End With
        Finally
            If dbManager IsNot Nothing Then dbManager.Dispose()
        End Try
    End Sub

    Private Sub EnlazarErrores(ByVal dtError As DataTable)
        Dim dvError As DataView = dtError.DefaultView
        dvError.Sort = "linea ASC"
        With gvErrores
            .DataSource = dvError
            If dvError.Count > 0 Then .Columns(0).FooterText = dvError.Count.ToString & " Registro(s) Erróneo(s)"
            .DataBind()
        End With
        MetodosComunes.mergeGridViewFooter(gvErrores)
        pnlResultadoArchivo.Visible = True
    End Sub

    Private Sub gvErrores_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvErrores.PageIndexChanging
        If Session("dtListaErrores") IsNot Nothing Then
            Dim dtError As DataTable = CType(Session("dtListaErrores"), DataTable)
            Try
                gvErrores.PageIndex = e.NewPageIndex
                EnlazarErrores(dtError)
            Catch ex As Exception
                epNotificador.showError("Error al tratar de cambiar página. " & ex.Message)
            End Try
        Else
            epNotificador.showWarning("imposible recuperar los datos desde la memoria. Por favor consulte nuevamente")
        End If
    End Sub

    Private Sub ValidarExistenciaDeSeriales(ByVal dtDatos As DataTable, ByVal dtError As DataTable)
        Dim dbManager As New LMDataAccess
        Dim dtSerial As New DataTable
        Dim arrSerial As New ArrayList
        Dim arrAux As New ArrayList

        Try

            For Each drAux As DataRow In dtDatos.Rows
                arrSerial.Add(drAux("serial").ToString)
            Next
            With dbManager
                .SqlParametros.Add("@listadoSerial", SqlDbType.VarChar, 8000)
                For index As Integer = 0 To arrSerial.Count - 1
                    arrAux.Add(arrSerial(index))
                    If (arrAux.Count = 180) Or (arrAux.Count > 0 And (index = arrSerial.Count - 1)) Then
                        .SqlParametros("@listadoSerial").Value = Join(arrAux.ToArray, ",")
                        .llenarDataTable(dtSerial, "ExistenSerialesEnInfoGarantia", CommandType.StoredProcedure)
                        arrAux.Clear()
                    End If
                Next
            End With
            Dim drInfo As DataRow
            For Each drSerial As DataRow In dtSerial.Rows
                drInfo = dtDatos.Rows.Find(drSerial("serial"))
                If drInfo IsNot Nothing Then
                    AdicionarRegistroErroneo(dtError, drInfo("linea").ToString, _
                        "El serial:  " & drSerial("serial").ToString & " ya se encuentra registrado en la Base de Datos.")
                End If
            Next
        Finally
            If dbManager IsNot Nothing Then dbManager.Dispose()
        End Try
    End Sub
End Class