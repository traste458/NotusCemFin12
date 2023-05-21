Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic
Imports GemBox.Spreadsheet

Partial Public Class CargarInventarioPorArchivo
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _idUsuario As Integer

#End Region

#Region "Propiedades"

    Public ReadOnly Property contieneErrores() As Boolean
        Get
            If Session("dtError") Is Nothing Then
                Return False
            Else
                Return (CType(Session("dtError"), DataTable).Rows.Count > 0)
            End If
        End Get
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            Try
                With epNotificacion
                    .setTitle("Cargue de Inventario CEM por archivo plano ZMMAK")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                pnlErrores.Visible = False
                pnlRegistroZmma1.Visible = False
                lbGuardar.Visible = False
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cargar página. " & ex.Message)
            End Try
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub btnSubir_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubir.Click
        Try
            If fuArchivo.PostedFile.FileName <> "" Then
                Dim ruta As String = Server.MapPath("..\archivos_planos\") & Session("usxp001") & fuArchivo.FileName
                fuArchivo.SaveAs(ruta)
                Dim extencion As String = fuArchivo.PostedFile.FileName.Substring(fuArchivo.PostedFile.FileName.LastIndexOf(".")).ToLower()
                Dim dtDatos As New DataTable
                If extencion = ".txt" Then
                    dtDatos = Me.LeerZmmak(ruta)
                Else
                    epNotificacion.showError("Imposible determinar el formato del archivo")
                    Exit Sub
                End If
                If Session("dtError") Is Nothing Then
                    Dim flagExito As Boolean = CargarInventarioCEM.CargarZMMAK(dtDatos, _idUsuario)
                    'pnlRegistro.Visible = False
                    lbGuardar.Visible = True
                    'pnlRegistroZmma1.Visible = True
                    pnlErrores.Visible = False
                    epNotificacion.showSuccess("Se realizo el cargue de " + dtDatos.Rows.Count.ToString + " registos del archivo ZMMAK correctamente, por favor proceda con el cargue del Inventario")
                Else
                    epNotificacion.showWarning("Se encontraron diferencias al subir el archivo ZMMAK, por favor verifique el log de resultados")
                    gvErrores.DataSource = CType(Session("dtError"), DataTable)
                    gvErrores.DataBind()
                    pnlErrores.Visible = True
                End If

            Else
                epNotificacion.showError("Debe seleccionar un archivo")
            End If

        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error al subir el archivo al servidor: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCargar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCargar.Click
        Try
            If fuArchivo2.PostedFile.FileName <> "" Then
                Dim ruta As String = Server.MapPath("..\archivos_planos\") & Session("usxp001") & fuArchivo2.FileName
                fuArchivo2.SaveAs(ruta)
                Dim extencion As String = fuArchivo2.PostedFile.FileName.Substring(fuArchivo2.PostedFile.FileName.LastIndexOf(".")).ToLower()
                Dim dtDatos As New DataTable
                If extencion = ".txt" Then
                    dtDatos = Me.LeerZmma1(ruta)
                Else
                    epNotificacion.showError("Imposible determinar el formato del archivo")
                    Exit Sub
                End If
                If Session("dtError") Is Nothing Then
                    Dim flagExito As Boolean = CargarInventarioCEM.CargarZMMA1(dtDatos, _idUsuario)
                    fuArchivo2.Enabled = False
                    lbGuardar.Visible = True
                    btnCargar.Enabled = False
                    pnlErrores.Visible = False
                    epNotificacion.showSuccess("Se realizo el cargue de " + dtDatos.Rows.Count.ToString + " registos del archivo ZMMA1 correctamente, por favor proceda con el cargue del inventario")
                Else
                    epNotificacion.showWarning("Se encontraron diferencias al subir el archivo ZMMA1, por favor verifique el log de resultados")
                    gvErrores.DataSource = CType(Session("dtError"), DataTable)
                    gvErrores.DataBind()
                    pnlErrores.Visible = True
                End If

            Else
                epNotificacion.showError("Debe seleccionar un archivo")
            End If
        Catch ex As Exception
            epNotificacion.showError("Ocurrio un error al subir el archivo al servidor: " & ex.Message)
        End Try
    End Sub

    Protected Sub lbGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGuardar.Click
        CargarInventario()
    End Sub

    

#End Region

#Region "Métodos Privados"

    Private Function LeerZmmak(ByVal ruta As String) As DataTable
        Dim lectorArchivo As StreamReader = Nothing
        Dim linea As String
        Dim arregloDatos() As String
        Dim numLinea As Integer = 1
        Dim dtDatos As DataTable = CargarInventarioCEM.ObtenerEstructuraDatos

        Session.Remove("dtError")
        If ruta <> "" Then
            Try
                lectorArchivo = File.OpenText(ruta)
                Do
                    linea = lectorArchivo.ReadLine
                    If linea <> "" Then
                        arregloDatos = linea.Split("|")
                        If arregloDatos.Length <> 14 Then
                            RegError(numLinea, "Formato no esperado para determinar el serial a actualizar")
                        Else
                            Dim flag As Boolean = True
                            If arregloDatos(10).Trim() = "" Then RegError(numLinea, "Se esperaba un serial", "") : flag = False
                            If arregloDatos(8).Trim() = "" Then RegError(numLinea, "Se esperaba una entrega", arregloDatos(8)) : flag = False
                            If arregloDatos(0).Trim() = "" Then RegError(numLinea, "Se esperaba una entrega", arregloDatos(0)) : flag = False
                            If flag Then Me.AgregarSeriales(arregloDatos(10), arregloDatos(0), arregloDatos(8), arregloDatos(3), numLinea, dtDatos)
                        End If
                    ElseIf linea = "" AndAlso dtDatos.Rows.Count = 0 Then
                        RegError(numLinea, "Formato no esperado para determinar el serial a actualizar")
                    End If
                    numLinea += 1
                Loop Until (linea = "")
            Catch ex As Exception
                Throw New Exception("Error al tratar de leer los datos del archivo. " & ex.Message)
            Finally
                If Not lectorArchivo Is Nothing Then lectorArchivo.Close()
            End Try
        End If
        Return dtDatos
    End Function

    Private Function LeerZmma1(ByVal ruta As String) As DataTable
        Dim lectorArchivo As StreamReader = Nothing
        Dim linea As String
        Dim arregloDatos() As String
        Dim numLinea As Integer = 1
        Dim dtDatos As DataTable = CargarInventarioCEM.ObtenerEstructuraDatosZmma1
        Session.Remove("dtError")
        If ruta <> "" Then
            Try
                lectorArchivo = File.OpenText(ruta)
                Do
                    linea = lectorArchivo.ReadLine
                    If linea <> "" And numLinea > 3 Then
                        arregloDatos = linea.Split(vbTab)
                        If arregloDatos.Length < 14 Then
                            RegError(numLinea, "Formato no esperado para determinar el serial a actualizar")
                        Else
                            Dim flag As Boolean = True
                            Dim arrCentroAlm() = arregloDatos(4).Split("-")
                            Dim centro As String = arrCentroAlm(0)
                            Dim almacen As String = ""

                            If arrCentroAlm.Length > 1 Then almacen = CInt(arrCentroAlm(1))
                            If flag Then Me.AgregarEntregas(arregloDatos(1), centro, almacen, arregloDatos(14), arregloDatos(16).Substring(0, arregloDatos(16).IndexOf(".")).Trim(), numLinea, dtDatos)
                        End If
                    ElseIf linea = "" AndAlso numLinea > 3 AndAlso dtDatos.Rows.Count = 0 Then
                        RegError(numLinea, "Formato no esperado para determinar el serial a actualizar")
                    End If
                    numLinea += 1
                Loop Until (linea = "" And numLinea > 4)
            Catch ex As Exception
                Throw New Exception("Error al tratar de leer los datos del archivo. " & ex.Message)
            Finally
                If Not lectorArchivo Is Nothing Then lectorArchivo.Close()
            End Try
        End If
        Return dtDatos
    End Function

    Private Sub RegError(ByVal linea As Integer, ByVal descripcion As String, Optional ByVal serial As String = "")
        Dim dtError As New DataTable
        If Session("dtError") Is Nothing Then
            dtError.Columns.Add(New DataColumn("lineaArchivo"))
            dtError.Columns.Add(New DataColumn("descripcion"))
            dtError.Columns.Add(New DataColumn("serial", GetType(String)))
            Session("dtError") = dtError
        Else
            dtError = Session("dtError")
        End If
        Dim dr As DataRow = dtError.NewRow()
        dr("lineaArchivo") = linea
        dr("serial") = serial
        dr("descripcion") = descripcion
        dtError.Rows.Add(dr)
        Session("dtError") = dtError
    End Sub

    Private Sub AgregarSeriales(ByVal serial As String, ByVal entrega As String, ByVal material As String, _
                                ByVal codigoCAC As String, ByVal lineaArchivo As Integer, ByVal dtDatos As DataTable)
        If dtDatos.Select("serial='" & serial & "'").Length = 0 Then
            Dim dr As DataRow = dtDatos.NewRow
            dr("serial") = serial
            dr("entrega") = entrega
            dr("material") = material
            dr("lineaArchivo") = lineaArchivo
            dr("codigoCAC") = codigoCAC
            dtDatos.Rows.Add(dr)
        Else
            RegError(lineaArchivo, "El serial se encuentra varias veces en el archivo", serial)
        End If
    End Sub

    Private Sub AgregarEntregas(ByVal entrega As Long, ByVal centro As String, ByVal almacen As String, ByVal material As String, _
                                ByVal cantidad As Long, ByVal lineaArchivo As String, ByVal dtDatos As DataTable)
        Dim dr As DataRow = dtDatos.NewRow
        dr("entrega") = entrega
        dr("centro") = centro
        dr("almacen") = almacen
        dr("material") = material
        dr("cantidad") = cantidad
        dr("lineaArchivo") = lineaArchivo
        dtDatos.Rows.Add(dr)
    End Sub

    Private Sub CargarInventario()
        Try
            Dim resultado As New List(Of ResultadoProceso)
            Dim cargar As New CargarInventarioCEM
            Dim dtLog As New DataTable()
            dtLog.Columns.Add("Diferencias Encontradas", Type.GetType("System.String"))
            With cargar
                .IdUsuario = _idUsuario
            End With
            resultado = cargar.CargarInventarioArchivo
            If resultado.Count = 0 Then
                epNotificacion.showSuccess("Se realizo el cargue del inventario satifactoriamente.")
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    Dim filaLog As DataRow = dtLog.NewRow()
                    filaLog(0) = mensaje.Mensaje
                    dtLog.Rows.Add(filaLog)
                Next
                epNotificacion.showWarning("Se presentaron diferencias al realizar el cargue del inventario, por favor verifique el Log de resultados")
                dtLog.AcceptChanges()
                gvErrores.DataSource = dtLog
                gvErrores.DataBind()
                lbGuardar.Visible = False
                pnlErrores.Visible = True
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el inventario. " & ex.Message)
        End Try
    End Sub

#End Region

End Class