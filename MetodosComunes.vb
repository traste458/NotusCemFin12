Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions
Imports ICSharpCode.SharpZipLib.Zip
Imports ICSharpCode.SharpZipLib.Checksums
Imports System.Web.Mail
Imports GemBox.Spreadsheet
Imports System.Drawing
Imports LMDataAccessLayer
Imports DevExpress.Web.ASPxEditors								  
Imports DevExpress.Web
Imports System.Collections.Generic								  

Public Class MetodosComunes

    Public Sub New()
    End Sub

    Public Shared Function getAllPos() As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlAdaptador As SqlDataAdapter
        Dim sqlSelect As String
        Dim dtPos As New DataTable

        sqlSelect = "select idpos,rtrim(ltrim(pos))as pos,rtrim(ltrim(cadena)) "
        sqlSelect += "as cadena from pos where idestado=1  order by pos"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtPos)
            GC.Collect()
            Return dtPos
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("No se pudo Obtener el Listado de Puntos de Venta: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Sub CargarComboDXSinSeleccione(ByRef control As ASPxComboBox, ByRef dataSource As DataTable, Optional valueField As String = Nothing, Optional textField As String = Nothing)
        Try
            With control
                .DataSource = dataSource
                If valueField IsNot Nothing Then
                    .ValueField = valueField
                Else
                    .ValueField = dataSource.Columns(0).ColumnName
                End If

                If textField IsNot Nothing Then
                    .TextField = textField
                Else
                    .TextField = dataSource.Columns(1).ColumnName
                End If

                .DataBind()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Shared Function getAnyValor(ByVal Campomostrar As String, ByVal Tabla As String, ByVal Valorbuscado As String, ByVal CampoCond As String) As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, sqlSelect As String
        Dim dtTipos As New DataTable

        sqlSelect = "select " & Campomostrar & " From " & Tabla & " Where " & CampoCond & "='" & Valorbuscado & "'"

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtTipos)
            GC.Collect()
            Return dtTipos
        Catch ex As Exception
            liberarConexion(sqlConexion)
            Throw New Exception("Error al tratar de Obtener el Listado de Proveedores: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getAllProductos() As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlAdaptador As SqlDataAdapter
        Dim sqlSelect As String
        Dim dtProductos As New DataTable

        sqlSelect = "select idproducto,rtrim(ltrim(producto)) as producto "
        sqlSelect += "from productos where estado=1 order by producto "

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtProductos)
            GC.Collect()
            Return dtProductos
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al taratar de Obtener el Listado de Productos: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getAllSubproductos() As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlAdaptador As SqlDataAdapter
        Dim sqlSelect As String
        Dim dtproductos As New DataTable

        sqlSelect = "select idsubproducto,rtrim(ltrim(subproducto))+'-'+ rtrim(idsubproducto2) "
        sqlSelect += "as subproducto,idproducto,region from subproductos where tipoorden='OTK' "
        sqlSelect += "and estado=1 order by subproducto"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtproductos)
            GC.Collect()
            Return dtproductos
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al taratar de Obtener el Listado de Subproductos: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getCadenasFromTipos() As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlAdaptador As SqlDataAdapter
        Dim sqlSelect As String
        Dim dtCadenas As New DataTable

        sqlSelect = "select distinct idtipo,rtrim(ltrim(tipo)) as tipo from tipos "
        sqlSelect += "where concepto='cadenas' and estado=1 order by tipo"

        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtCadenas)
            GC.Collect()
            Return dtCadenas
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Dispose()
            GC.Collect()
            Throw New Exception("Error al taratar de obtener el Listado de Cadenas: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getNombreCadena(ByVal idCadena As Integer) As String
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlSelect As String, resultado As String = ""

        sqlSelect = "select tipo from tipos where idtipo=@idCadena"
        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@idCadena", idCadena)
            sqlConexion.Open()
            resultado = sqlComando.ExecuteScalar
            sqlConexion.Close()
            GC.Collect()
            Return resultado.Trim
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener el nombre de la Cadena:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getIdCadena(ByVal cadena As String) As Integer
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlSelect As String, idCadena As Integer

        sqlSelect = "select idtipo from tipos where tipo = @cadena"
        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            sqlComando.Parameters.Add("@cadena", cadena)
            sqlConexion.Open()
            idCadena = sqlComando.ExecuteScalar
            sqlConexion.Close()
            GC.Collect()
            Return idCadena
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener el Identificador de la Cadena:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getTipificacionesMateriales() As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, dtTipificaciones As New DataTable
        Dim sqlSelect As String


        sqlSelect = "select idtipo,idtipo2,rtrim(tipo) as tipo from tipos "
        sqlSelect += " where concepto='CLASIF MATERIAL' order by idtipo"

        Try
            'sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            'sqlComando = New SqlCommand(sqlSelect, sqlConexion)
            'sqlAdaptador = New SqlDataAdapter(sqlComando)
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador.Fill(dtTipificaciones)
            Return dtTipificaciones
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al taratar de Obtener el Listado de Tipificaciones de Productos: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Sub inicializarObjetos(ByRef sqlConexion As SqlConnection, ByRef sqlComando As SqlCommand,
        ByRef sqlAdaptador As SqlDataAdapter, ByVal instruccionSql As String, Optional ByVal crearAdaptador As Boolean = True)

        Try
            If sqlConexion Is Nothing Then
                sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            End If
            sqlComando = New SqlCommand(instruccionSql, sqlConexion)
            If crearAdaptador Then sqlAdaptador = New SqlDataAdapter(sqlComando)
        Catch ex As Exception
            Throw New Exception("Error al tratar de inicializar objetos de Conexión a la Base de Datos:<br>" & ex.Message)
        End Try
    End Sub

    Public Shared Sub inicializarObjetos(ByRef sqlConexion As SqlConnection, ByRef sqlComando As SqlCommand,
        ByVal instruccionSql As String)

        Try
            If sqlConexion Is Nothing Then
                sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            End If
            sqlComando = New SqlCommand(instruccionSql, sqlConexion)
        Catch ex As Exception
            Throw New Exception("Error al tratar de inicializar objetos de Conexión a la Base de Datos:<br>" & ex.Message)
        End Try
    End Sub

    Public Shared Sub exportarDatosSinTitulo(ByVal contextHttp As HttpContext, ByVal dtDatos As DataSet, ByVal titulo As String, ByVal nombreArchivo As String, ByVal ruta As String,
                                                Optional ByVal nombreColumnas As ArrayList = Nothing, Optional ByVal showFooter As Boolean = True)
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet

        Dim numTablas As Integer = dtDatos.Tables.Count

        Try

            For j As Integer = 0 To dtDatos.Tables.Count - 1

                ws = ef.Worksheets.Add(dtDatos.Tables(j).TableName.ToString())
                ws.ExtractToDataTable(dtDatos.Tables(j), dtDatos.Tables(j).Rows.Count, ExtractDataOptions.StopAtFirstEmptyRow, ws.Rows(1), ws.Columns(0))
                ws.InsertDataTable(dtDatos.Tables(j), "A1", True)
                ws.Cells.GetSubrangeAbsolute(0, 0, 0, dtDatos.Tables(j).Columns.Count).Merged = False

                For i As Integer = 0 To dtDatos.Tables(j).Columns.Count - 1
                    If Not nombreColumnas Is Nothing Then
                        ws.Cells(0, i).Value = nombreColumnas(i)
                    Else
                        ws.Cells(0, i).Value = dtDatos.Tables(j).Columns(i).ColumnName
                    End If
                    With ws.Cells(0, i).Style
                        .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                        .Font.Color = Color.White
                        .Font.Weight = ExcelFont.BoldWeight
                        .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                        .HorizontalAlignment = HorizontalAlignmentStyle.Center
                    End With

                Next


                If showFooter Then
                    ws.Cells.GetSubrangeAbsolute(dtDatos.Tables(j).Rows.Count + 3, 0, (dtDatos.Tables(j).Rows.Count + 3), dtDatos.Tables(j).Columns.Count - 1).Merged = True
                    With ws.Cells("A" & (dtDatos.Tables(j).Rows.Count + 4).ToString).Style
                        .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                        .Font.Color = Color.DarkBlue
                        .Font.Weight = ExcelFont.BoldWeight
                        .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                        .HorizontalAlignment = HorizontalAlignmentStyle.Center
                    End With

                End If
                For index As Integer = 0 To dtDatos.Tables(j).Columns.Count - 1
                    ws.Columns(index).AutoFitAdvanced(1.1)
                Next
            Next

            ef.SaveXls(ruta)
            With contextHttp
                .Response.Clear()
                .Response.ContentType = "application/octet-stream"
                .Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                .Response.Flush()
                .Response.WriteFile(ruta)
            End With

        Catch ex As Exception
            Throw New Exception("Al tratar de exportar a Excel: " & ex.Message & ex.StackTrace)
        End Try
    End Sub

    Public Shared Sub inicializarObjetos(ByRef sqlConexion As SqlConnection, ByRef sqlAdaptador As SqlDataAdapter,
        ByVal instruccionSql As String, Optional ByVal crearAdaptador As Boolean = True)

        Try
            If sqlConexion Is Nothing Then
                sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
            End If
            If crearAdaptador Then sqlAdaptador = New SqlDataAdapter(instruccionSql, sqlConexion)
        Catch ex As Exception
            Throw New Exception("Error al tratar de inicializar objetos de Conexión a la Base de Datos:<br>" & ex.Message)
        End Try
    End Sub

    Public Function exportarDatosAExcelGemBoxCallback(ByVal dtDatos As DataTable, ByVal nombreArchivo As String, ByVal ruta As String, titulo As String,
                                                Optional ByVal nombreColumnas As ArrayList = Nothing, Optional ByVal showFooter As Boolean = True, Optional ByVal showTitle As Boolean = True) As InfoResultado
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")

        Dim resultado As New InfoResultado
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet

        Try
            ws = ef.Worksheets.Add("Datos")
            ws.ExtractToDataTable(dtDatos, dtDatos.Rows.Count, ExtractDataOptions.StopAtFirstEmptyRow, ws.Rows(0), ws.Columns(0))
            Dim fila As Integer = 0
            If showTitle Then
                ws.InsertDataTable(dtDatos, "A3", True)
                ws.Cells.GetSubrangeAbsolute(0, 0, 0, dtDatos.Columns.Count).Merged = True
                With ws.Cells("A1")
                    .Value = titulo
                    With .Style
                        .Font.Color = Color.Black
                        .Font.Weight = ExcelFont.BoldWeight
                        .Font.Size = 16 * 18
                    End With
                End With
                fila = 2
            Else
                ws.InsertDataTable(dtDatos, "A1", True)
            End If


            For i As Integer = 0 To dtDatos.Columns.Count - 1
                If Not nombreColumnas Is Nothing Then
                    ws.Cells(fila, i).Value = nombreColumnas(i)
                Else
                    ws.Cells(fila, i).Value = dtDatos.Columns(i).ColumnName
                End If
                With ws.Cells(fila, i).Style
                    .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                    .Font.Color = Color.White
                    .Font.Weight = ExcelFont.BoldWeight
                    .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                    .HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With
                resultado.Valor += 1
            Next

            For index As Integer = 0 To dtDatos.Columns.Count - 1
                ws.Columns(index).AutoFit()
            Next
            ef.SaveXlsx(ruta)

            resultado.Mensaje = ruta

        Catch ex As Exception
            Throw New Exception("Al tratar de exportar a Excel: " & ex.Message & ex.StackTrace)
        End Try
        Return resultado
    End Function

    Public Shared Function crearConexionSql() As SqlConnection
        Dim sqlConexion As SqlConnection
        Try
            sqlConexion = New SqlConnection(ConfigurationManager.AppSettings("CadenaConexion"))
        Catch ex As Exception
            Throw New Exception("Error al tratar de crear objeto de Conexion a la Base de Datos. " & ex.Message)
        End Try
        Return sqlConexion
    End Function

    Public Shared Function getNombreDia(ByVal numeroDia As Integer) As String
        Select Case numeroDia
            Case 1
                Return "Lunes"
            Case 2
                Return "Martes"
            Case 3
                Return "Miercoles"
            Case 4
                Return "Jueves"
            Case 5
                Return "Viernes"
            Case 6
                Return "Sabado"
            Case Else
                Return "Domingo"
        End Select
    End Function

    Public Shared Function getMeses() As DataTable
        Dim dtMeses As New DataTable, drMes As DataRow
        dtMeses.Columns.Add(New DataColumn("idMes", GetType(String)))
        dtMeses.Columns.Add(New DataColumn("Mes", GetType(String)))
        drMes = dtMeses.NewRow
        drMes("idMes") = "01"
        drMes("Mes") = "Enero"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "02"
        drMes("Mes") = "Febrero"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "03"
        drMes("Mes") = "Marzo"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "04"
        drMes("Mes") = "Abril"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "05"
        drMes("Mes") = "Mayo"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "06"
        drMes("Mes") = "Junio"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "07"
        drMes("Mes") = "Julio"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "08"
        drMes("Mes") = "Agosto"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = "09"
        drMes("Mes") = "Septiembre"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = 10
        drMes("Mes") = "Octubre"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = 11
        drMes("Mes") = "Noviembre"
        dtMeses.Rows.Add(drMes)
        drMes = dtMeses.NewRow
        drMes("idMes") = 12
        drMes("Mes") = "Diciembre"
        dtMeses.Rows.Add(drMes)

        Return dtMeses
    End Function

    Public Shared Function getMateriales(ByVal incluirSim As Boolean) As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, dtMateriales As New DataTable
        Dim sqlSelect As String

        sqlSelect = "select distinct rtrim(ltrim(idsubproducto2)) as material,case when subproducto like '%oriente%' then "
        sqlSelect += "  replace(ltrim(rtrim(subproducto)),'oriente','') when subproducto like '%occidente%' then "
        sqlSelect += "  replace(ltrim(rtrim(subproducto)),'occidente','') when subproducto like '%norte%' then "
        sqlSelect += "  replace(ltrim(rtrim(subproducto)),'norte','') else ltrim(rtrim(subproducto)) end "
        sqlSelect += " as subproducto from subproductos where estado=1 and subproducto not like '%virgen%' "
        sqlSelect += " and idtipo not in(9015,903,904) and isnull(idEstadoRetail,0) = 1"
        If incluirSim = False Then
            sqlSelect += " and idproducto not in (select idproducto from productos "
            sqlSelect += " where producto like '%SIM%CARD%' )"
        End If
        sqlSelect += "order by subproducto "

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador.Fill(dtMateriales)
            Return dtMateriales
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener el listado de Materiales:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function getMaterialesActivos() As ArrayList
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlRead As SqlDataReader, sqlSelect As String
        Dim materialesBien As New ArrayList

        sqlSelect = "select distinct rtrim(ltrim(idsubproducto2)) as material "
        sqlSelect += "from subproductos where estado=1 and subproducto not like '%virgen%' "
        sqlSelect += "and idtipo not in(9015,903,904) and isnull(idEstadoRetail,0) = 1 "
        sqlSelect += "and idproducto not in (select idproducto from productos "
        sqlSelect += "where producto like '%SIM%CARD%') order by material asc"

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, Nothing, sqlSelect, False)
            sqlConexion.Open()
            sqlRead = sqlComando.ExecuteReader
            While sqlRead.Read
                materialesBien.Add(sqlRead.GetString(0))
            End While
            sqlRead.Close()
            sqlConexion.Close()
            GC.Collect()
            Return materialesBien
        Catch ex As Exception
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
            Throw New Exception("Error al tratar de obtener el listado de Materiales Aceptados:<br>" & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Sub liberarConexion(ByRef sqlConexion As SqlConnection)
        If Not sqlConexion Is Nothing Then
            sqlConexion.Close()
            sqlConexion.Dispose()
            GC.Collect()
        End If
    End Sub

    Public Shared Function searchValor(ByVal Campomostrar As String, ByVal Tabla As String, ByVal Valorbuscado As String, ByVal CampoCond As String) As String
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, sqlSelect As String
        Dim dtTipos As New DataTable

        sqlSelect = "select " & Campomostrar & " From " & Tabla & " with(nolock) Where " & CampoCond & "='" & Valorbuscado & "'"

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtTipos)
            GC.Collect()
            If dtTipos.Rows.Count = 0 Then
                Return "-1"
            Else
                Return dtTipos.Rows(0)(0)
            End If
        Catch ex As Exception
            liberarConexion(sqlConexion)
            Throw New Exception("Error al tratar de Obtener el Listado de Proveedores: " & ex.Message & sqlSelect)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function searchValor(ByVal camposAMostrar As String, ByVal Tabla As String, ByVal condicional As String) As String
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, sqlSelect As String
        Dim dtTipos As New DataTable

        sqlSelect = "select " & camposAMostrar & " From " & Tabla & " with(nolock) Where " & condicional & ""

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtTipos)
            GC.Collect()
            If dtTipos.Rows.Count = 0 Then
                Return "-1"
            Else
                Return dtTipos.Rows(0)(0)
            End If
        Catch ex As Exception
            liberarConexion(sqlConexion)
            Throw New Exception("Error al tratar de Obtener el Listado de Proveedores: " & ex.Message & sqlSelect)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Function traerNombresCorreos(ByVal CampoCond As String) As String
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, sqlSelect, NombresCorreos As String
        Dim dtCorreos As New DataTable
        Dim Filas As DataRow

        sqlSelect = "Select * From CorreosSerialesPreactivados Where " & CampoCond & "=1"

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtCorreos)
            If dtCorreos.Rows.Count <> 0 Then
                For Each Filas In dtCorreos.Rows
                    NombresCorreos = Filas("NombreCorreo") & ";" & NombresCorreos
                Next
            Else
                NombresCorreos = "itdevelopment@logytechmobile.com.co"
            End If

            GC.Collect()
            Return NombresCorreos
        Catch ex As Exception
            liberarConexion(sqlConexion)
            Throw New Exception("Error al tratar de Obtener el Listado de Correos: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Sub comprimirArchivos(ByVal NombreArchivo As String, ByVal NombreZip As String, ByVal NivelComprension As Int16, Optional ByVal clave As String = Nothing)
        Dim objCrc32 As New Crc32
        Dim strmZipOutputStream As ZipOutputStream

        strmZipOutputStream = New ZipOutputStream(File.Create(NombreZip))

        If clave IsNot Nothing AndAlso Not String.IsNullOrEmpty(clave) Then
            strmZipOutputStream.Password = clave
        End If

        ' Compression Level: 0-9
        ' 0: no(Compression)
        ' 9: maximum compression
        strmZipOutputStream.SetLevel(NivelComprension)

        Dim strmFile As FileStream = File.OpenRead(NombreArchivo)
        Dim abyBuffer(Convert.ToInt32(strmFile.Length - 1)) As Byte

        strmFile.Read(abyBuffer, 0, abyBuffer.Length)

        'Se guarda con el path completo
        Dim sFile As String = Path.GetFileName(NombreArchivo)
        Dim Archivozip As New ZipEntry(sFile)

        'Guardamos la fecha y hora de la modificacion
        Dim fi As New FileInfo(NombreArchivo)
        Archivozip.DateTime = fi.LastWriteTime

        Archivozip.Size = strmFile.Length
        strmFile.Close()
        objCrc32.Reset()
        objCrc32.Update(abyBuffer)
        Archivozip.Crc = objCrc32.Value
        strmZipOutputStream.PutNextEntry(Archivozip)
        strmZipOutputStream.Write(abyBuffer, 0, abyBuffer.Length)

        strmZipOutputStream.Finish()
        strmZipOutputStream.Close()
    End Sub

    Public Shared Function validarDigitos(ByVal cadena As String) As Boolean
        Dim expresionRegularValidarDigitos As Regex, respuestaValidacion As Boolean
        Try
            'Expresion regular para validar si una cadena contiene digitos
            expresionRegularValidarDigitos = New Regex("^[0-9]+$")
            'Retornamos la validacion de la estructura.
            respuestaValidacion = expresionRegularValidarDigitos.IsMatch(cadena)
            Return (respuestaValidacion)
        Catch ex As Exception
        End Try
    End Function

    Public Shared Function getUrlFrameBack(ByVal pagina As System.Web.UI.Page) As String
        Dim url As String
        url = "../frames_back.asp?idmenu=" & pagina.Session("idmenu")
        url += "&posicion=" & pagina.Session("posicion")
        Return (url)
    End Function

    Public Shared Function getAllProveedores() As DataTable
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, sqlSelect As String
        Dim dtProveedores As New DataTable

        sqlSelect = "select idproveedor,upper(rtrim(proveedor)) as proveedor "
        sqlSelect += "from proveedores order by proveedor "

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtProveedores)
            GC.Collect()
            Return dtProveedores
        Catch ex As Exception
            liberarConexion(sqlConexion)
            Throw New Exception("Error al taratar de Obtener el Listado de Proveedores: " & ex.Message)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function

    Public Shared Sub actualizarModificadorEnLogFE(ByVal sqlConexion As SqlConnection, ByVal sqlTransaccion As SqlTransaction,
        ByVal idFactura As Integer, ByVal pagina As Page)

        Dim sqlComando As SqlCommand, sqlUpdate As String
        sqlUpdate = "update LogFacturasExternas set idUsuarioCambia=@idUsuario "
        sqlUpdate += " where idLogFactura=(select max(idLogFactura) from LogFacturasExternas "
        sqlUpdate += " where idFactura=@idFactura)"

        Try
            sqlComando = New SqlCommand(sqlUpdate, sqlConexion)
            sqlComando.Transaction = sqlTransaccion
            With sqlComando.Parameters
                .Add("@idUsuario", pagina.Session("usxp001"))
                .Add("@idFactura", idFactura)
            End With
            sqlComando.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Error al tratar de actualizar Log. " & ex.Message)
        End Try
    End Sub

    Public Shared Function consultaBaseDatos(ByVal sentencia As String, Optional ByVal parametros As ArrayList = Nothing) As DataTable
        Dim conexion As SqlConnection, comando As SqlCommand
        Dim adaptador As SqlDataAdapter, dtPos As New DataTable
        Try
            inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            If Not parametros Is Nothing Then
                Dim paramAux As SqlParameter

                For index As Integer = 0 To parametros.Count - 1
                    comando.Parameters.Add(DirectCast(parametros(index), SqlParameter))
                Next
            End If
            'adaptador = New SqlDataAdapter(comando)
            adaptador.Fill(dtPos)
            'GC.Collect()
            Return dtPos
        Catch ex As Exception
            'liberarConexion(conexion)
            Throw New Exception("Error al ejecutar " & sentencia & " fue " & ex.Message)
        Finally
            If Not dtPos Is Nothing Then dtPos.Dispose()
            If Not adaptador Is Nothing Then adaptador.Dispose()
            If Not comando Is Nothing Then comando.Dispose()
            liberarConexion(conexion)
        End Try
    End Function

    Public Shared Function getCiudadesParaKP() As DataTable

        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, dtCiudades As New DataTable
        Dim sqlSelect As String

        sqlSelect = "select idciudad,rtrim(ciudad)+' ('+rtrim(departamento)+')' as ciudad "
        sqlSelect += " from ciudades where idciudad in (select distinct idciudad from "
        sqlSelect += "pos where idestado=1) order by ciudad"

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador.Fill(dtCiudades)
            Return dtCiudades
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener el listado de Ciudades. " & ex.Message)
        Finally
            liberarConexion(sqlConexion)
        End Try
    End Function

    Public Shared Function getCoordinador() As DataTable
        Dim dtDatos As New DataTable, sentencia As String, conexion As SqlConnection
        Dim comando As SqlCommand, adaptador As SqlDataAdapter
        sentencia = "select  idcoordinador, (Select tercero from terceros where idtercero"
        sentencia += " = pos.idcoordinador) as coordinador from  pos where idcoordinador "
        sentencia += " is not null group by pos.idcoordinador order by coordinador"
        Try
            inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            adaptador.Fill(dtDatos)
            Return dtDatos
        Catch ex As Exception
            Throw New Exception("Error al cargar los Coordinadores del Punto de Venta. " & ex.Message)
        Finally
            liberarConexion(conexion)
        End Try

    End Function

    Public Shared Function getSupervisor() As DataTable
        Dim dtDatos As New DataTable, sentencia As String, conexion As SqlConnection
        Dim comando As SqlCommand, adaptador As SqlDataAdapter
        sentencia = "select idsupervisor, (Select tercero from terceros where idtercero="
        sentencia += " pos.idsupervisor) as supervisor from pos where idsupervisor "
        sentencia += " is not null order by supervisor"
        Try
            inicializarObjetos(conexion, comando, adaptador, sentencia, True)
            adaptador.Fill(dtDatos)
            Return dtDatos
        Catch ex As Exception
            Throw New Exception("Error al cargar los Supervisores del Punto de Venta. " & ex.Message)
        Finally
            liberarConexion(conexion)
        End Try

    End Function

    Public Shared Sub moverInventarioPOS(ByVal sqlConexion As SqlConnection, ByVal sqlTransaccion As SqlTransaction,
         ByVal idPos As Integer, ByVal idProducto As Integer, ByVal idSubproducto As Integer, Optional ByVal adicion As Boolean = False)

        Dim sqlComando As SqlCommand, sqlSelect, sqlUpdateInv, sqlQuery As String
        Dim sqlRead As SqlDataReader, fechaKardex As Date
        Dim saldo, idPosKardex As Integer

        sqlSelect = "select idpos_kardex,saldo_final,fecha from pos_kardex where "
        sqlSelect += " idpos_kardex=(select max(idpos_kardex) from pos_kardex "
        sqlSelect += " where idpos=@idPos and idproducto=@idProducto and "
        sqlSelect += " idsubproducto=@idSubproducto)"


        If adicion Then
            sqlUpdateInv = "update pos_inventario set saldo=saldo+1 where idpos=@idPos "
            sqlUpdateInv += " and idsubproducto=@idSubproducto "
        Else
            sqlUpdateInv = "update pos_inventario set saldo=saldo-1 where idpos=@idPos "
            sqlUpdateInv += " and idsubproducto=@idSubproducto "
        End If

        Try
            MetodosComunes.inicializarObjetos(sqlConexion, sqlComando, sqlSelect)
            With sqlComando.Parameters
                .Add("@idPos", SqlDbType.Int).Value = idPos
                .Add("@idproducto", SqlDbType.Int).Value = idProducto
                .Add("@idSubproducto", SqlDbType.Int).Value = idSubproducto
            End With
            'Se inicia en modo transaccional
            sqlComando.Transaction = sqlTransaccion
            'Se ejecuta la consulta para determinar si existe Kardex para 
            ' la combinacion POS,Producto, Subproducto
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

                If adicion Then
                    sqlQuery = "update pos_kardex set entradas=entradas+1,saldo_final=saldo_final+1 "
                    sqlQuery += " where idpos_kardex=@idPosKardex"
                Else
                    sqlQuery = "update pos_kardex set salidas=salidas+1,saldo_final=saldo_final-1 "
                    sqlQuery += " where idpos_kardex=@idPosKardex"
                End If
                sqlComando.Parameters.Add("@idPosKardex", SqlDbType.Int).Value = idPosKardex
            Else ' De lo contrario, se crea un nuevo registro
                If adicion Then
                    sqlQuery = "insert into pos_kardex(idpos,fecha,idproducto,idsubproducto,saldo_inicial,"
                    sqlQuery += " entradas,salidas,saldo_final) values (@idPos,getdate(),@idProducto,"
                    sqlQuery += " @idSubproducto,@saldo,1,0,@saldo+1) "
                Else
                    sqlQuery = "insert into pos_kardex(idpos,fecha,idproducto,idsubproducto,saldo_inicial,"
                    sqlQuery += " entradas,salidas,saldo_final) values (@idPos,getdate(),@idProducto,"
                    sqlQuery += " @idSubproducto,@saldo,0,1,@saldo-1) "
                End If


            End If
            sqlComando.Parameters.Add("@saldo", SqlDbType.Int).Value = saldo
            'Se actualiza el inventario del POS
            sqlComando.CommandText = sqlUpdateInv
            sqlComando.ExecuteNonQuery()
            'Se realiza el movimiento del Kardex
            sqlComando.CommandText = sqlQuery
            sqlComando.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Error al tratar de mover Inventario. " & ex.Message)
        Finally
            If Not sqlComando Is Nothing Then sqlComando.Dispose()
        End Try
    End Sub

    Public Shared Function maxId(ByVal NomCampo As String, ByVal Tabla As String) As Integer
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand
        Dim sqlAdaptador As SqlDataAdapter, sqlSelect As String
        Dim dtTipos As New DataTable

        sqlSelect = "select Max(" & NomCampo & ") From " & Tabla & ""

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador = New SqlDataAdapter(sqlComando)
            sqlAdaptador.Fill(dtTipos)
            GC.Collect()
            If IsDBNull(dtTipos.Rows(0)(0)) Then
                Return 1
            Else
                Return dtTipos.Rows(0)(0) + 1
            End If
        Catch ex As Exception
            liberarConexion(sqlConexion)
            Throw New Exception("Error al tratar de Obtener el Listado de Proveedores: " & ex.Message & sqlSelect)
        Finally
            If Not sqlConexion Is Nothing Then sqlConexion.Close()
            GC.Collect()
        End Try
    End Function


    Public Shared Sub exportarDtAExcelGemBox(ByVal contextHttp As HttpContext, ByVal dtDatos As DataTable, ByVal titulo As String, ByVal nombreArchivo As String, ByVal ruta As String,
                                              Optional ByVal nombreColumnas As ArrayList = Nothing, Optional ByVal showFooter As Boolean = True, Optional ByVal mergeFooter As Boolean = True)
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet
        Try
            ws = ef.Worksheets.Add(titulo)
            ws.InsertDataTable(dtDatos, "A3", True)

            ws.Cells.GetSubrangeAbsolute(0, 0, 0, dtDatos.Columns.Count - 1).Merged = True

            For i As Integer = 0 To dtDatos.Columns.Count - 1
                If Not nombreColumnas Is Nothing Then
                    ws.Cells(2, i).Value = nombreColumnas(i)
                Else
                    ws.Cells(2, i).Value = dtDatos.Columns(i).ColumnName
                End If
                With ws.Cells(2, i).Style
                    .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                    .Font.Color = Color.White
                    .Font.Weight = ExcelFont.BoldWeight
                    .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                    .HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With

            Next

            If showFooter Then
                Dim PiePagina As Integer
                If mergeFooter Then
                    PiePagina = 4
                    ws.Cells.GetSubrangeAbsolute(dtDatos.Rows.Count + 3, 0, (dtDatos.Rows.Count + 3), dtDatos.Columns.Count - 1).Merged = True
                    With ws.Cells("A" & (dtDatos.Rows.Count + PiePagina).ToString).Style
                        .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                        .Font.Color = Color.DarkBlue
                        .Font.Weight = ExcelFont.BoldWeight
                        .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                        .HorizontalAlignment = HorizontalAlignmentStyle.Center
                    End With
                    ws.Cells("A" & (dtDatos.Rows.Count + PiePagina).ToString).Value = dtDatos.Rows.Count & " Registro(s) Encontrado(s)"
                Else
                    PiePagina = 2
                    For i As Integer = 0 To dtDatos.Columns.Count - 1
                        With ws.Cells(dtDatos.Rows.Count + PiePagina, i).Style
                            .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                            .Font.Color = Color.DarkBlue
                            .Font.Weight = ExcelFont.BoldWeight
                            .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                            .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                            .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                            .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                        End With
                    Next
                End If
            End If

            For index As Integer = 0 To dtDatos.Columns.Count - 1
                ws.Columns(index).AutoFitAdvanced(1)
            Next
            With ws.Cells("A1")
                .Value = titulo
                With .Style
                    .Font.Color = Color.Black
                    .Font.Weight = ExcelFont.BoldWeight
                    .Font.Size = 16 * 18
                End With
            End With
            ruta += nombreArchivo

            ef.SaveXls(ruta)

            If File.Exists(ruta) Then
                MetodosComunes.ForzarDescargaDeArchivo(HttpContext.Current, ruta, nombreArchivo)
            Else
                Throw New Exception("Imposible recuperar el archivo desde su ruta de almacenamiento. ")
            End If
        Catch ex As System.Threading.ThreadAbortException
        End Try
    End Sub


    Public Shared Sub exportarDatosAExcelGemBox(ByVal contextHttp As HttpContext, ByVal dtDatos As DataTable, ByVal titulo As String, ByVal nombreArchivo As String, ByVal ruta As String,
                                                Optional ByVal nombreColumnas As ArrayList = Nothing, Optional ByVal showFooter As Boolean = True)
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet

        Try
            ws = ef.Worksheets.Add("Hoja 1")
            ws.ExtractToDataTable(dtDatos, dtDatos.Rows.Count, ExtractDataOptions.StopAtFirstEmptyRow, ws.Rows(3), ws.Columns(0))
            ws.InsertDataTable(dtDatos, "A3", True)
            ws.Cells.GetSubrangeAbsolute(0, 0, 0, dtDatos.Columns.Count).Merged = True
            With ws.Cells("A1")
                .Value = titulo
                With .Style
                    .Font.Color = Color.Black
                    .Font.Weight = ExcelFont.BoldWeight
                    .Font.Size = 16 * 18
                End With
            End With
            For i As Integer = 0 To dtDatos.Columns.Count - 1
                If Not nombreColumnas Is Nothing Then
                    ws.Cells(2, i).Value = nombreColumnas(i)
                Else
                    ws.Cells(2, i).Value = dtDatos.Columns(i).ColumnName
                End If
                With ws.Cells(2, i).Style
                    .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                    .Font.Color = Color.White
                    .Font.Weight = ExcelFont.BoldWeight
                    .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                    .HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With

            Next
            If showFooter Then
                ws.Cells.GetSubrangeAbsolute(dtDatos.Rows.Count + 3, 0, (dtDatos.Rows.Count + 3), dtDatos.Columns.Count - 1).Merged = True
                With ws.Cells("A" & (dtDatos.Rows.Count + 4).ToString).Style
                    .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                    .Font.Color = Color.DarkBlue
                    .Font.Weight = ExcelFont.BoldWeight
                    .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                    .HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With
                ws.Cells("A" & (dtDatos.Rows.Count + 4).ToString).Value = dtDatos.Rows.Count & " Registro(s) Encontrado(s)"
            End If

            For index As Integer = 0 To dtDatos.Columns.Count - 1
                ws.Columns(index).AutoFitAdvanced(1.1)
            Next

            ef.SaveXls(ruta)
            With contextHttp
                .Response.Clear()
                .Response.ContentType = "application/octet-stream"
                .Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                .Response.Flush()
                .Response.WriteFile(ruta)
            End With

        Catch ex As Exception
            Throw New Exception("Al tratar de exportar a Excel: " & ex.Message & ex.StackTrace)
        End Try
    End Sub

    Public Shared Sub exportarDatosAExcelGemBox(ByVal contextHttp As HttpContext, ByVal dtDatos As DataTable, ByVal nombreArchivo As String, ByVal ruta As String,
                                                Optional ByVal nombreColumnas As ArrayList = Nothing)
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet

        Try
            ws = ef.Worksheets.Add("Datos")
            ws.ExtractToDataTable(dtDatos, dtDatos.Rows.Count, ExtractDataOptions.StopAtFirstEmptyRow, ws.Rows(0), ws.Columns(0))
            ws.InsertDataTable(dtDatos, "A1", True)

            For i As Integer = 0 To dtDatos.Columns.Count - 1
                If Not nombreColumnas Is Nothing Then
                    ws.Cells(0, i).Value = nombreColumnas(i)
                Else
                    ws.Cells(0, i).Value = dtDatos.Columns(i).ColumnName
                End If
                With ws.Cells(0, i).Style
                    .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                    .Font.Color = Color.White
                    .Font.Weight = ExcelFont.BoldWeight
                    .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                    .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                    .HorizontalAlignment = HorizontalAlignmentStyle.Center
                End With
            Next

            For index As Integer = 0 To dtDatos.Columns.Count - 1
                ws.Columns(index).AutoFit()
            Next
            ef.SaveXlsx(ruta)

            With contextHttp
                .Response.Clear()
                .Response.ContentType = "application/octet-stream"
                .Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                .Response.Flush()
                .Response.WriteFile(ruta)
                .Response.End()
            End With
        Catch ex As Exception
            Throw New Exception("Al tratar de exportar a Excel: " & ex.Message & ex.StackTrace)
        End Try
    End Sub

    Public Shared Sub exportarDatosAExcelGemBox(ByVal contextHttp As HttpContext, ByVal dsDatos As DataSet, ByVal nombreArchivo As String, ByVal ruta As String)
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
        Dim ef As New ExcelFile
        Dim ws As ExcelWorksheet
        Try
            For Each tabla As DataTable In dsDatos.Tables
                If tabla.Rows.Count > 0 Then
                    ws = ef.Worksheets.Add(tabla.TableName)
                    ws.ExtractToDataTable(tabla, tabla.Rows.Count, ExtractDataOptions.StopAtFirstEmptyRow, ws.Rows(3), ws.Columns(0))
                    ws.InsertDataTable(tabla, "A3", True)
                    ws.Cells.GetSubrangeAbsolute(0, 0, 0, tabla.Columns.Count).Merged = True
                    With ws.Cells("A1")
                        .Value = tabla.TableName
                        With .Style
                            .Font.Color = Color.Black
                            .Font.Weight = ExcelFont.BoldWeight
                            .Font.Size = 14 * 16
                        End With
                    End With
                    ws.Columns(0).AutoFitAdvanced(1)

                    For i As Integer = 0 To tabla.Columns.Count - 1
                        With ws.Cells(2, i).Style
                            .FillPattern.SetPattern(FillPatternStyle.Solid, Color.DarkBlue, Color.DarkBlue)
                            .Font.Color = Color.White
                            .Font.Weight = ExcelFont.BoldWeight
                            .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                            .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                            .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                            .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                            .HorizontalAlignment = HorizontalAlignmentStyle.Center
                        End With
                    Next
                    ws.Cells.GetSubrangeAbsolute(tabla.Rows.Count + 3, 0, (tabla.Rows.Count + 3), tabla.Columns.Count - 1).Merged = True
                    With ws.Cells("A" & (tabla.Rows.Count + 4).ToString).Style
                        .FillPattern.SetPattern(FillPatternStyle.Solid, Color.LightGray, Color.LightGray)
                        .Font.Color = Color.DarkBlue
                        .Font.Weight = ExcelFont.BoldWeight
                        .Borders.SetBorders(MultipleBorders.Top, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Right, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Left, Color.FromName("black"), LineStyle.Thin)
                        .Borders.SetBorders(MultipleBorders.Bottom, Color.FromName("black"), LineStyle.Thin)
                        .HorizontalAlignment = HorizontalAlignmentStyle.Center
                    End With
                    ws.Cells("A" & (tabla.Rows.Count + 4).ToString).Value = tabla.Rows.Count & " Registro(s) Encontrado(s)"
                    For index As Integer = 0 To tabla.Columns.Count - 1
                        ws.Columns(index).AutoFitAdvanced(1)
                    Next
                End If
            Next
            If ws.Rows.Count <= 65536 Then
                ef.SaveXls(ruta)
            Else
                ruta = ruta.Replace(".xls", ".xlsx")
                nombreArchivo = nombreArchivo.Replace(".xls", ".xlsx")
                ef.SaveXlsx(ruta)
            End If

            With contextHttp
                .Response.Clear()
                .Response.ContentType = "application/octet-stream"
                .Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                .Response.Flush()
                .Response.WriteFile(ruta)
                .Response.End()
            End With
        Catch trAb As Threading.ThreadAbortException
        Catch ex As Exception
            Throw New Exception("Al tratar de exportar a Excel: " & ex.Message)
        End Try
    End Sub

    Public Shared Sub exportarDatosAExcel(ByVal contextHttp As HttpContext, ByVal textoHTML As String, ByVal titulo As String, ByVal nombreArchivo As String, Optional ByVal formatoFecha As String = "")
        Dim encabezado As String
        encabezado = "<html xmlns:x='urn:schemas-microsoft-com:office:excel'>" & vbCrLf
        encabezado += "<head><style>" & vbCrLf & ".text {mso-number-format:\@;} " & vbCrLf
        encabezado += " .fechaCorta {mso-number-format:dd\/mm\/yyyy;}" & vbCrLf
        encabezado += " .fecha {mso-number-format:dd\-MMM\-yyyy\ hh\:mm\ AM\/PM;}" & vbCrLf
        If formatoFecha.Trim <> "" Then
            formatoFecha = formatoFecha.Replace("-", "\-").Replace("/", "\/").Replace(":", "\:").Replace(".", "\.").Replace(" ", "\ ")
            encabezado += " .fechaCustom {mso-number-format:" & formatoFecha & ";}" & vbCrLf
        End If
        encabezado += " .fechaEspecial {mso-number-format:dd\-MMM\-yyyy;}" & vbCrLf & "</style></head>"
        encabezado += vbCrLf & "<body>"
        With contextHttp
            '.Response.Write(encabezado)
            .Response.Clear()
            .Response.Buffer = True
            .Response.ContentType = "application/vnd.ms-excel"
            .Response.AppendHeader("content-disposition", "attachment;filename=" & nombreArchivo)
            .Response.ContentEncoding = System.Text.Encoding.Default
            .Response.Charset = ""
            .Response.Write(encabezado)
            .Response.Write("<FONT face='Arial,Helvetica,sans-serif' color='black' size='4'><B>")
            .Response.Write(titulo & "</B></FONT><hr>")
            .Response.Write(textoHTML)
            .Response.Write("</body>" & vbCrLf & "</html>")
            .Response.End()
        End With
    End Sub

    Public Shared Sub exportarDatosATexto(ByVal contextHttp As HttpContext, ByVal texto As String, ByVal nombreArchivo As String)
        With contextHttp
            .Response.Clear()
            .Response.Buffer = True
            .Response.ContentType = "text/plain"
            .Response.AppendHeader("content-disposition", "attachment;filename=" & nombreArchivo)
            .Response.Charset = ""
            .Response.Write(texto)
            .Response.End()
        End With
    End Sub
    'Funcion para validar la estructura de un correo electronico del dominio BrightPoint.com.co
    Public Shared Function validarEstructuraCorreoBP(ByVal correo As String) As Boolean
        Dim expresionRegularValidarCorreo As Regex, respuestaValidacion As Boolean
        Try
            'Expresion regular para validar la estructura de un correo de BP.
            expresionRegularValidarCorreo = New Regex("^([a-zA-Z0-9_\-\.]+)@(LOGYTECHMOBILE\.COM)$")
            'Retornamos la validacion de la estructura.
            respuestaValidacion = expresionRegularValidarCorreo.IsMatch(correo.ToUpper)
            Return (respuestaValidacion)
        Catch ex As Exception
        End Try
    End Function

    Public Shared Sub manejarBarraNavegacionDG(ByRef ibFirst As ImageButton, ByRef ibPrev As ImageButton,
        ByRef ibNext As ImageButton, ByRef ibLast As ImageButton, ByVal currentPage As Integer, ByVal pageCount As Integer)

        If currentPage = 0 Then
            ibFirst.ImageUrl = "../images/pageFirstD.gif"
            ibFirst.Enabled = False
            ibPrev.ImageUrl = "../images/pagePrevD.gif"
            ibPrev.Enabled = False
            If pageCount <> 1 Then
                ibLast.ImageUrl = "../images/pageLast.gif"
                ibLast.Enabled = True
                ibNext.ImageUrl = "../images/pageNext.gif"
                ibNext.Enabled = True
            Else
                ibLast.ImageUrl = "../images/pageLastD.gif"
                ibLast.Enabled = False
                ibNext.ImageUrl = "../images/pageNextD.gif"
                ibNext.Enabled = False
            End If
        ElseIf (currentPage + 1) = pageCount Then
            ibFirst.ImageUrl = "../images/pageFirst.gif"
            ibFirst.Enabled = True
            ibPrev.ImageUrl = "../images/pagePrev.gif"
            ibPrev.Enabled = True
            ibLast.ImageUrl = "../images/pageLastD.gif"
            ibLast.Enabled = False
            ibNext.ImageUrl = "../images/pageNextD.gif"
            ibNext.Enabled = False
        Else
            ibFirst.ImageUrl = "../images/pageFirst.gif"
            ibFirst.Enabled = True
            ibPrev.ImageUrl = "../images/pagePrev.gif"
            ibPrev.Enabled = True
            ibLast.ImageUrl = "../images/pageLast.gif"
            ibLast.Enabled = True
            ibNext.ImageUrl = "../images/pageNext.gif"
            ibNext.Enabled = True
        End If
    End Sub

    Public Shared Function verificarUsuario(ByVal idUsuario As Integer) As Integer
        Dim sqlConexion As SqlConnection, sqlComando As SqlCommand, sqlAdaptador As SqlDataAdapter
        Dim dtUsuario As New DataTable, sqlSelect As String

        sqlSelect = "select * from UsuarioConPrivilegiosOperaciones where estado=1 and idusuario=" & idUsuario

        Try
            inicializarObjetos(sqlConexion, sqlComando, sqlAdaptador, sqlSelect, True)
            sqlAdaptador.Fill(dtUsuario)
            If dtUsuario.Rows.Count = 0 Then
                idUsuario = 0
            Else
                idUsuario = 1
            End If

        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener información del usuario. " & ex.Message)
        Finally
            If Not dtUsuario Is Nothing Then dtUsuario.Dispose()
            liberarConexion(sqlConexion)
        End Try

        Return idUsuario
    End Function

    Public Shared Function getDistinctsFromDataTable(ByVal dtOrigen As DataTable, ByVal arrCampos As ArrayList, Optional ByVal filtro As String = "", Optional ByVal sort As String = "") As DataTable
        Dim dtDatos, dtDictionary As DataTable, dcDato, dcsPK(arrCampos.Count - 1) As DataColumn
        Dim drDato, drAuxOrigen(), drEntry As DataRow, index As Integer

        Try
            dtDictionary = New DataTable
            dtDictionary.Columns.Add("key", GetType(Object))
            dtDictionary.Columns.Add("value", GetType(Object))
            Dim dictionaryKeys As DataColumn() = {dtDictionary.Columns("key")}
            dtDictionary.PrimaryKey = dictionaryKeys

            '****Se recorre el array de campos proporcionado, con el fin de crear una ****'
            '****columna y una entrada de diccionario (en hashtable) por cada campo****' 
            For index = 0 To arrCampos.Count - 1
                dcDato = New DataColumn(arrCampos(index).ToString, GetType(String))
                dcsPK(index) = dcDato
                drEntry = dtDictionary.NewRow
                drEntry("key") = arrCampos(index).ToString
                drEntry("value") = ""
                dtDictionary.Rows.Add(drEntry)
            Next
            dtDatos = New DataTable
            '***Se Agregan las Columnas a la Tabla****'
            dtDatos.Columns.AddRange(dcsPK)
            '****Se establecven todos los campos como llave primarya, con el fin de ****'

            dtDatos.PrimaryKey = dcsPK

            Dim hayDiferencia As Boolean, pkKeys As New ArrayList
            '****Se recorre el cunjunto de datos base, obteniendo los valores distintos****'
            drAuxOrigen = dtOrigen.Select(filtro, sort)
            For Each drAux As DataRow In drAuxOrigen
                hayDiferencia = False
                drDato = dtDatos.NewRow
                pkKeys.Clear()
                For Each drEntry In dtDictionary.Rows
                    drDato(drEntry("key")) = drAux(drEntry("key")).ToString
                    If drAux(drEntry("key")).ToString.ToLower <> drEntry("value").ToString.ToLower Then
                        drEntry("value") = drAux(drEntry("key")).ToString
                        hayDiferencia = True
                    End If
                    Dim clave As String
                    clave = drAux(drEntry("key"))
                    pkKeys.Add(drAux(drEntry("key")))
                Next
                If hayDiferencia Then
                    If dtDatos.Rows.Find(pkKeys.ToArray) Is Nothing Then dtDatos.Rows.Add(drDato)
                End If
            Next
            Return dtDatos
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener datos distintos de la Tabla. " & ex.Message)
        End Try
    End Function

    Public Shared Function clonarDataGrid(ByVal dgSource As DataGrid) As DataGrid
        Dim dgAux As New DataGrid

        With dgAux
            .AccessKey = dgSource.AccessKey
            .AllowCustomPaging = dgSource.AllowCustomPaging
            .AllowPaging = dgSource.AllowPaging
            .AllowSorting = dgSource.AllowSorting
            .AlternatingItemStyle.CopyFrom(dgSource.AlternatingItemStyle)
            .CopyBaseAttributes(dgSource)
            .AutoGenerateColumns = dgSource.AutoGenerateColumns
            .BackColor = dgSource.BackColor
            .BackImageUrl = dgSource.BackImageUrl
            .BorderColor = dgSource.BorderColor
            .BorderStyle = dgSource.BorderStyle
            .BorderWidth = dgSource.BorderWidth
            .CellPadding = dgSource.CellPadding
            .CellSpacing = dgSource.CellSpacing
            .CssClass = dgSource.CssClass
            .Font.MergeWith(dgSource.Font)
            .FooterStyle.CopyFrom(dgSource.FooterStyle)
            .ForeColor = dgSource.ForeColor
            .GridLines = dgSource.GridLines
            .HeaderStyle.CopyFrom(dgSource.HeaderStyle)
            .ItemStyle.CopyFrom(dgSource.ItemStyle)
            .PagerStyle.CopyFrom(dgSource.PagerStyle)
            .ShowFooter = dgSource.ShowFooter
            .ShowHeader = dgSource.ShowHeader
            .ToolTip = dgSource.ToolTip
            .Width = dgSource.Width

            If .AutoGenerateColumns = False Then
                For Each dgColumn As DataGridColumn In dgSource.Columns
                    .Columns.Add(dgColumn)
                Next
            End If
        End With
        Return dgAux
    End Function

    Public Shared Function consultarDetallePreactivacionSimMin(ByVal sim As String) As String
        Dim conexion As SqlConnection, comando As SqlCommand, minEncontrado As String
        Dim sqlSelect As String
        sqlSelect = "select [min] from DetallePreactivacionSimMin where sim = @sim"
        Try
            inicializarObjetos(conexion, comando, sqlSelect)
            conexion.Open()
            comando.Parameters.Add("@sim", SqlDbType.VarChar).Value = sim
            minEncontrado = comando.ExecuteScalar
            Return minEncontrado
        Catch ex As Exception
            Throw New Exception("No se puede determinar el MSISDN del ICCID: " & ex.Message)
        Finally
            liberarConexion(conexion)
        End Try
    End Function

    Public Shared Function evaluarMin(ByVal min As String, ByVal idUsuario As String, ByRef errores As String, Optional ByVal factura As String = "") As Boolean
        Dim sentencia As String, conexion As SqlConnection, comando As SqlCommand,
        adaptador As SqlDataReader
        Dim dtDatos As New DataTable, valor As Boolean, stringFactura As String
        Try
            If factura <> "" Then
                stringFactura = " and factura <> '" & factura & "'"
            Else
                stringFactura = " "
            End If
            sentencia = "select 'KP' as tabla from facturas_kits with(nolock) where min = @serial "
            sentencia += stringFactura & "  union select 'WB' as factura from "
            sentencia += " facturas_kits_wb with(nolock) where min = @serial " & stringFactura & " union "
            sentencia += " select 'PP' as factura from facturas_Postpago with(nolock) "
            sentencia += " where min = @serial " & stringFactura & " "
            MetodosComunes.inicializarObjetos(conexion, comando, sentencia)
            conexion.Open()

            comando.Parameters.Add("@serial", SqlDbType.VarChar).Value = min
            adaptador = comando.ExecuteReader
            If adaptador.Read Then

                liberarMIN(adaptador.GetValue(0), min, Integer.Parse(idUsuario))
                While adaptador.Read
                    liberarMIN(adaptador.GetValue(0), min, Integer.Parse(idUsuario))
                End While
                valor = True
            Else
                valor = True
            End If
            adaptador.Close()
            Return valor
        Catch ex As Exception
            Throw New Exception("Error al consultar el Min: " & ex.Message)
        Finally
            If Not conexion Is Nothing Then conexion.Close()
            If Not dtDatos Is Nothing Then dtDatos.Dispose()
        End Try
    End Function

    Public Shared Function liberarMIN(ByVal tipoFactura As String, ByVal min As String, ByVal idUsuario As Integer)
        Dim sentencia, nombreTabla, factura, arreglo(), cadenaArreglo, facturaActual As String, transaccion As Integer
        Dim conexion As SqlConnection, comando As SqlCommand

        Try

            'segun el tipo de factura es 
            Select Case tipoFactura
                Case "KP"
                    sentencia = "select factura + '-' + convert(varchar,transaccion) from facturas_kits where min = @minLibre"
                    nombreTabla = "facturas_Kits"
                Case "WB"
                    sentencia = "select factura + '-' + convert(varchar,transaccion) from facturas_kits_wb where min = @minLibre"
                    nombreTabla = "facturas_Kits_wb"
                Case "PP"
                    sentencia = "select factura + '-' + convert(varchar,idVenta) from facturas_postpago where min = @minLibre"
                    nombreTabla = "facturas_postpago"
                Case "PW"
                    sentencia = "select factura + '-' + convert(varchar,idVenta) from facturas_postpago_wb where min = @minLibre"
                    nombreTabla = "facturas_postpago_WB"
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            inicializarObjetos(conexion, comando, sentencia)
            conexion.Open()
            With comando
                .CommandText = sentencia
                .Parameters.Add("@minLibre", SqlDbType.VarChar).Value = min
                cadenaArreglo = comando.ExecuteScalar()
                arreglo = cadenaArreglo.Split("-")
                factura = arreglo(0)
                transaccion = Integer.Parse(arreglo(1))

                sentencia = "update " & nombreTabla & " set [min] = null where factura = @facturaMIN and [min] = @minLibre"

                .CommandText = sentencia
                .Parameters.Add("@facturaMIN", SqlDbType.VarChar).Value = factura


                .ExecuteNonQuery()

                sentencia = "update LogFacturasConMinLiberado set idUsuario=@idUsuario where factura = @facturaMIN and transaccion = @transaccion and [min] = @minLibre"

                .CommandText = sentencia

                .Parameters.Add("@transaccion", SqlDbType.Int).Value = transaccion
                .Parameters.Add("@idUsuario", SqlDbType.Int).Value = idUsuario

                .ExecuteNonQuery()
            End With
        Catch ex As Exception
            Throw New Exception("se genero un error al liberar el MSISDN. " & ex.Message & ex.StackTrace)
        Finally
            If Not conexion Is Nothing Then conexion.Close()
        End Try

    End Function

    Public Shared Function retornaCarecteresValidos(ByRef cadenaCambio As String)

        If cadenaCambio <> "" Then cadenaCambio = cadenaCambio.Replace("%", "").Replace("/*", "").Replace("'", "").Replace("*", "").Replace("[", "").Replace("]", "")

    End Function

    Public Shared Function enviarCorreo(ByVal titulo As String, ByVal asunto As String, ByVal destino As String, ByVal firma As String, ByVal contenidoCorreo As String, Optional ByVal prioridad As MailPriority = MailPriority.Normal, Optional ByVal nota As String = "", Optional ByVal rutaAttachment As String = "")
        Dim correo As New MailMessage
        Dim cuerpo As New System.Text.StringBuilder
        Dim attach As MailAttachment

        Try
            With cuerpo
                .Append("<HTML>")
                .Append("	<HEAD>")
                .Append("		<LINK href='" & ConfigurationManager.AppSettings("SITIOBASE") & "include/styleBACK.css' type='text/css' rel='stylesheet'>")
                .Append("	</HEAD>")
                .Append("	<body class='cuerpo2'>")
                .Append("	<table width='100%' border='0' align='center' cellpadding='5' cellspacing='0' class='tabla'")
                .Append("		ID='Table1'>")
                .Append("		<tr>")
                .Append("			<td width='20%' ><img src='" & ConfigurationManager.AppSettings("SITIOBASE") & "images/logo_trans.png'>")
                .Append("			</td>")
                .Append("			<td align='center' bgcolor='#883485' width='80%'><font size='3' face='arial' color='white'><b>" & titulo & "</b></font></td>")
                .Append("		</tr>")
                .Append("	</table>")
                .Append("	<br>")
                .Append("	<br>")
                If Now.Hour < 12 Then
                    .Append("	<font class='fuente'>Buenos Dias")
                ElseIf Now.Hour > 18 Then
                    .Append("	<font class='fuente'>Buenas Noches")
                Else
                    .Append("	<font class='fuente'>Buenas Tardes")
                End If
                .Append("<br><br>" & contenidoCorreo)
                .Append("	<br>")
                .Append("<br>	<font class='fuente'>Cordial Saludo,<br>")
                .Append("		<br><b>" & firma & "</b><br><br>")
                .Append("</font><br><br><br><br><br>")
                If nota <> "" Then
                    .Append("	</font><font class='fuente' size='1'><i>Nota: " & nota & ".</i></font></font> ")
                End If

                .Append("	</body>")
                .Append("</HTML>")
            End With
            correo.To = destino
            correo.From = ConfigurationManager.AppSettings("mailSender")
            correo.Subject = asunto
            correo.Priority = prioridad
            correo.Body = cuerpo.ToString
            correo.BodyFormat = MailFormat.Html
            If rutaAttachment <> "" Then
                attach = New MailAttachment(rutaAttachment)
                correo.Attachments.Add(attach)
            End If

            SmtpMail.SmtpServer = ConfigurationManager.AppSettings("mailServer")
            SmtpMail.Send(correo)
        Catch ex As Exception
            Throw New Exception("Error al cargar enviear el correo. " & ex.Message & ex.StackTrace)
        End Try
    End Function

    '''<sumary>
    '''Procedimiento que permite combinar las celdas pertenecientes al Footer de un DataGrid
    '''</sumary>
    Public Shared Sub mergeFooter(ByRef dgAux As DataGrid, Optional ByVal cellSpanIndex As Integer = 0,
        Optional ByVal celdaInicial As Integer = 1, Optional ByVal celdaFinal As Integer = 0)
        If dgAux.Items.Count > 0 Then
            Dim numIndex As Integer = 1
            If dgAux.AllowPaging = True Then numIndex = 2
            Dim footer As DataGridItem =
                CType(dgAux.Controls(0).Controls(dgAux.Controls(0).Controls.Count - numIndex), DataGridItem)
            Dim maxIndex As Integer = IIf(celdaFinal <> 0, celdaFinal, footer.Cells.Count - 1)
            For index As Integer = celdaInicial To maxIndex
                footer.Cells(index).Visible = False
            Next
            footer.Cells(cellSpanIndex).ColumnSpan = footer.Cells.Count
        End If
    End Sub

    Public Shared Sub mergeGridViewFooter(ByRef gvAux As GridView, Optional ByVal cellSpanIndex As Integer = 0,
       Optional ByVal celdaInicial As Integer = 1, Optional ByVal celdaFinal As Integer = 0)
        If gvAux.Rows.Count > 0 Then
            Dim numIndex As Integer = 1
            If gvAux.AllowPaging = True Then numIndex = 2
            Dim footer As GridViewRow =
                CType(gvAux.Controls(0).Controls(gvAux.Controls(0).Controls.Count - numIndex), GridViewRow)
            Dim maxIndex As Integer = IIf(celdaFinal <> 0, celdaFinal, footer.Cells.Count - 1)
            For index As Integer = celdaInicial To maxIndex
                footer.Cells(index).Visible = False
            Next
            footer.Cells(cellSpanIndex).ColumnSpan = footer.Cells.Count
        End If
    End Sub

    Public Shared Sub setGemBoxLicense()
        SpreadsheetInfo.SetLicense("EVIF-6YOV-FYFL-M3H6")
    End Sub

    Public Shared Sub ajustarLongitudSerial(ByRef serial As String)
        Try
            Dim configKeyValue As String = seleccionarConfigValue("LONGITUDES_PERMITIDAS_SERIAL")
            Dim arrLongitudesPermitidas As New ArrayList(configKeyValue.Split(","))
            Dim diferencia As Integer = 0
            For Each longitud As Integer In arrLongitudesPermitidas
                If longitud = serial.Length Then
                    Exit Sub
                ElseIf longitud > serial.Length Then
                    diferencia = longitud - serial.Length
                    serial = Join(ArrayList.Repeat("0", diferencia).ToArray(), "") & serial.Trim
                    Exit For
                End If
            Next
        Catch ex As Exception
            Throw New Exception("Error al tratar de ajustar la longitud de caracteres del serial, por favor contactar al proceso ITDEVELOPMENT")
        End Try

    End Sub

    Public Shared Function seleccionarConfigValue(ByVal configKeyName As String) As String
        Dim db As New LMDataAccessLayer.LMDataAccess
        Dim resultado As String
        Try
            With db
                .SqlParametros.Add("@configKeyName", SqlDbType.VarChar, 200).Value = configKeyName
                .ejecutarReader("SELECT configKeyValue FROM ConfigValues WHERE configKeyName=@configKeyName AND status=1")
                If .Reader IsNot Nothing Then
                    If .Reader.Read Then
                        resultado = .Reader("configKeyValue").ToString
                    End If
                    .Reader.Close()
                End If
            End With
        Finally
            If db IsNot Nothing Then db.Dispose()
        End Try

        Return resultado
    End Function

    Public Shared Sub CargarDropDown(ByVal dt As DataTable, ByRef ddl As ListControl, Optional ByVal mensajeInicial As String = "", Optional ByVal setmensajeInicial As Boolean = True, Optional ByVal valueField As String = Nothing, Optional ByVal textField As String = Nothing)
        ddl.DataSource = dt
        Try
            If String.IsNullOrEmpty(valueField) Then
                ddl.DataValueField = dt.Columns(0).ColumnName
            Else
                ddl.DataValueField = valueField
            End If

            If dt.Columns.Count = 1 Then
                If String.IsNullOrEmpty(textField) Then
                    ddl.DataTextField = dt.Columns(0).ColumnName
                Else
                    ddl.DataTextField = textField
                End If
            Else
                If String.IsNullOrEmpty(textField) Then
                    ddl.DataTextField = dt.Columns(1).ColumnName
                Else
                    ddl.DataTextField = textField
                End If
            End If
            ddl.DataBind()
            If setmensajeInicial Then
                If mensajeInicial = "" Then mensajeInicial = "Seleccione..."
                ddl.Items.Insert(0, New ListItem(mensajeInicial, "0"))
            End If
        Catch
        End Try
    End Sub

    Public Shared Sub ForzarDescargaDeArchivo(ByVal contextoHttp As HttpContext, ByVal rutaArchivo As String, Optional ByVal finalizarRepuesta As Boolean = False)
        Dim infoArchivo As FileInfo
        infoArchivo = New FileInfo(rutaArchivo)
        If infoArchivo.Exists Then
            Dim nombreArchivo As String = Path.GetFileName(rutaArchivo)
            ForzarDescargaDeArchivo(contextoHttp, rutaArchivo, nombreArchivo, finalizarRepuesta)
        End If
    End Sub

    Public Sub ForzarDescargaDeArchivo(ByVal contextoHttp As HttpContext, ByVal archivo As MemoryStream)
        Try
            Dim startBytes As Long = 0
            With contextoHttp.Response
                .Clear()
                .Buffer = True
                .Charset = ""
                .ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                .AddHeader("content-disposition", "attachment;filename=ReproteSerialesOrdenRecepcion.xlsx")
                archivo.WriteTo(.OutputStream)
                .Flush()
                .End()
            End With

        Catch ex As Threading.ThreadAbortException
        End Try
    End Sub
    Public Shared Sub ForzarDescargaDeArchivoStream(ByVal fileStream As MemoryStream, ByVal nombreArchivo As String, ByVal tipoArchivo As String, Optional ByVal finalizarRepuesta As Boolean = False)
        Dim infoArchivo As FileInfo
        Dim contextoHttp As HttpContext = HttpContext.Current

        Try
            Dim binaryReader As New BinaryReader(fileStream)
            Dim startBytes As Long = 0

            With contextoHttp.Response
                .Clear()
                .ContentType = tipoArchivo
                .AppendHeader("content-disposition", "inline; filename=" + nombreArchivo)
                .AppendHeader("content-length", fileStream.Length.ToString)
                .BinaryWrite(fileStream.ToArray)
                If finalizarRepuesta Then .End()
            End With

        Catch ex As System.Threading.ThreadAbortException
        End Try
    End Sub

    Public Shared Sub ForzarDescargaDeArchivo(ByVal contextoHttp As HttpContext, ByVal rutaArchivo As String,
                                              ByVal nombreMostrarArchivo As String, Optional ByVal finalizarRepuesta As Boolean = False)
        Dim infoArchivo As FileInfo
        Try
            If nombreMostrarArchivo.Trim.Length = 0 Then nombreMostrarArchivo = Path.GetFileName(rutaArchivo)
            infoArchivo = New FileInfo(rutaArchivo)
            If infoArchivo.Exists Then
                Dim myFile As New FileStream(rutaArchivo, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)
                Dim binaryReader As New BinaryReader(myFile)
                Dim startBytes As Long = 0
                Dim lastUpdateTiemStamp As String = File.GetLastWriteTimeUtc(rutaArchivo).ToString("r")
                Dim encodedData As String = HttpUtility.UrlEncode(nombreMostrarArchivo, Encoding.UTF8) + lastUpdateTiemStamp

                With contextoHttp.Response
                    .Clear()
                    .Buffer = False
                    .BufferOutput = False
                    .ContentType = "application/octet-stream"
                    .AppendHeader("Content-Disposition", "attachment; filename=" & nombreMostrarArchivo)
                    .AppendHeader("Content-Length", (infoArchivo.Length - startBytes).ToString())
                    If infoArchivo.Length > 10485760 Then
                        .AddHeader("Accept-Ranges", "bytes")
                        .AppendHeader("Last-Modified", lastUpdateTiemStamp)
                        .AppendHeader("ETag", Chr(34) & encodedData & Chr(34))
                        .AppendHeader("Connection", "Keep-Alive")
                        '.ContentEncoding = Encoding.UTF8
                        binaryReader.BaseStream.Seek(startBytes, SeekOrigin.Begin)
                        Dim maxCount As Integer = CInt(Math.Ceiling((infoArchivo.Length - startBytes + 0.0) / 1024))
                        Dim index As Integer
                        While index < maxCount And .IsClientConnected
                            .BinaryWrite(binaryReader.ReadBytes(1024))
                            .Flush()
                            index += 1
                        End While
                    Else
                        .WriteFile(rutaArchivo)
                        '.TransmitFile(rutaArchivo)
                        .Flush()
                    End If
                    .Clear()
                    If finalizarRepuesta Then .End()
                End With
            End If
        Catch ex As System.Threading.ThreadAbortException
        End Try
    End Sub

    Public Shared Function CambiarCodificacionDeArchivos(ByVal pPathFolder As String, ByVal pExtension As String, ByVal pDirOption As IO.SearchOption) As Integer
        'Dim texto As String = ""
        'Dim contexto As System.Web.HttpContext = System.Web.HttpContext.Current
        'Dim dirInfo As DirectoryInfo = New DirectoryInfo(contexto.Server.MapPath("~"))

        'For Each fi As FileInfo In dirInfo.GetFiles("*.aspx", SearchOption.AllDirectories)
        '    texto = File.ReadAllText(fi.FullName, System.Text.Encoding.Default)
        '    File.WriteAllText(fi.FullName, texto, System.Text.Encoding.UTF8)
        'Next
        Dim cont As Integer
        Dim texto As String
        Dim reader As IO.StreamReader
        Dim gEnc As System.Text.Encoding
        Dim direc As IO.DirectoryInfo = New IO.DirectoryInfo(pPathFolder)
        For Each fi As IO.FileInfo In direc.GetFiles(pExtension, pDirOption)
            texto = ""
            reader = New IO.StreamReader(fi.FullName, System.Text.Encoding.Default, True)
            texto = reader.ReadToEnd
            gEnc = reader.CurrentEncoding
            reader.Close()

            If (gEnc.EncodingName <> System.Text.Encoding.UTF8.EncodingName) Then
                texto = IO.File.ReadAllText(fi.FullName, gEnc)
                IO.File.WriteAllText(fi.FullName, texto, System.Text.Encoding.UTF8)
                cont += 1
            End If
        Next
        Return cont
    End Function

    Public Shared Function GetWebRelativePathFromAbsolutePath(ByVal pagina As Page, ByVal absolutePath As String) As String
        Dim relativePath As String = absolutePath.Replace(pagina.Request.ServerVariables("APPL_PHYSICAL_PATH"), "~\")
        relativePath = pagina.ResolveUrl(relativePath)
        Return relativePath
    End Function

    Public Shared Function getRegiones(esRegion As Nullable(Of Boolean)) As DataTable
        Dim dtDatos As DataTable
        Using dbManager As New LMDataAccess
            Try
                With dbManager
                    If esRegion IsNot Nothing Then .SqlParametros.Add("@esRegion", SqlDbType.Bit).Value = esRegion
                    dtDatos = .EjecutarDataTable("ObtenerRegiones", CommandType.StoredProcedure)
                End With
            Catch ex As Exception
                Throw ex
            End Try
        End Using
        Return dtDatos
    End Function

#Region "Metodos Utiles DevExpress.Web"

    Public Shared Sub CargarComboDX(ByRef control As ASPxComboBox, ByRef dataSource As DataTable, Optional valueField As String = Nothing, Optional textField As String = Nothing)
        Try
            With control
                .DataSource = dataSource
                If valueField IsNot Nothing Then
                    .ValueField = valueField
                Else
                    .ValueField = dataSource.Columns(0).ColumnName
                End If

                If textField IsNot Nothing Then
                    .TextField = textField
                Else
                    .TextField = dataSource.Columns(1).ColumnName
                End If

                .DataBind()
            End With
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    Public Shared Sub EnlazarReporte(ByVal grid As Object, ByVal dtDatos As DataTable)
        With grid
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

Public Shared Sub CerrarSesiones(contexto As HttpContext)
        If contexto IsNot Nothing Then
            Dim sesiones As New Dictionary(Of String, Object)

            For i As Integer = 1 To 20
                Dim nombreVariable As String = "usxp" + i.ToString().PadLeft(3, "0")
                If (contexto.Session(nombreVariable) IsNot Nothing) Then
                    sesiones.Add(nombreVariable, contexto.Session(nombreVariable))
                End If
            Next
            If (contexto.Session("mensajeError") IsNot Nothing) Then
                sesiones.Add("mensajeError", contexto.Session("mensajeError"))
            End If


            For Each kvp As KeyValuePair(Of String, Object) In sesiones
                contexto.Session(kvp.Key) = kvp.Value
            Next
        End If
    End Sub

    Public Shared Function ObtenerIpDeUsuario() As String
        Dim rqst As HttpRequest = HttpContext.Current.Request
        Dim ip As String
        Dim Random As New Random()

        If Not String.IsNullOrEmpty(rqst.ServerVariables("HTTP_X_FORWARDED_FOR")) Then
            ip = rqst.ServerVariables("HTTP_X_FORWARDED_FOR")
        Else
            ip = rqst.ServerVariables("REMOTE_ADDR")
        End If

        If ip.Contains(",") Then ip = ip.Split(",")(0).Trim()
        If String.IsNullOrEmpty(ip) Or ip = "::1" Then
            ip = "192.168.4." + Random.Next(1, 255).ToString
        End If

        Return ip
    End Function

#End Region

#Region "Manejo de Fechas"

    Public Shared Function ObtienePrimerDiaDeMes(ByVal dtDate As DateTime) As DateTime
        Dim dtFrom As DateTime = dtDate
        dtFrom = dtFrom.AddDays(-(dtFrom.Day - 1))
        Return dtFrom
    End Function

    Public Shared Function ObtieneUltimoDiadeMes(ByVal dtDate As DateTime) As DateTime
        Dim dtTo As New DateTime(dtDate.Year, dtDate.Month, 1)
        dtTo = dtTo.AddMonths(1)
        dtTo = dtTo.AddDays(-(dtTo.Day))
        Return dtTo
    End Function

#End Region

End Class

#Region "Estructuras para filtros de Busqueda"

Public Structure filtrosBuscarFacturasPendientes
    Dim idCiudad, idPos As Integer
    Dim cadena, descripcionError, factura, fechaInicial, fechaFinal As String
    Dim idTipoFecha As Byte, tipoFactura As String
End Structure

Public Structure filtroBusquedaFacturasOP
    Dim factura, ordenCompra, guia, fechaInicial, fechaFinal, esRegionalizado As String
    Dim idTipoProducto, idProveedor, idProducto, idTipoRecepcion As Integer
    Dim idEstadoRecepcion, idEstadoFactura As Integer
End Structure

Public Structure filtrosBusquedaDeVentas
    Dim idCiudad, idPos, idCoordinador, idSupervisor As Integer
    Dim tipoFecha As TipoDeFecha
    Dim cadena, fechaInicial, fechaFinal As String
End Structure

Public Structure filtersSerialSearch
    Dim serial As String
    Dim type As String
End Structure

#End Region

Public Enum TipoDeFecha
    fechaDeVenta = 1
    fechaDeRegistro = 2
    fechaDeRecep = 3
End Enum
