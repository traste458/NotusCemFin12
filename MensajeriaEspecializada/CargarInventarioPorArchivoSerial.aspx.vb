Imports System.Web.Services
Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports System.Collections.Generic

Partial Public Class CargarInventarioPorArchivoSerial
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _idUsuario As Integer
    Private _cantidad As String

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
                    .setTitle("Cargue de Inventario CEM por archivo Serial")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With
                pnlErrores.Visible = False
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
                Dim extension As String = fuArchivo.PostedFile.FileName.Substring(fuArchivo.PostedFile.FileName.LastIndexOf(".")).ToLower()
                Dim dsDatos As New DataSet()
                Dim validar As New ValidarCargue
                If extension = ".txt" Then
                    With validar
                        .Ruta = ruta
                    End With
                    dsDatos = validar.LeerPlano()
                Else
                    epNotificacion.showError("Imposible determinar el formato del archivo")
                    Exit Sub
                End If
                If dsDatos.Tables(1).Rows.Count = 0 Then
                    Dim flagExito As Boolean = ValidarCargue.CargarPlano(dsDatos.Tables(0), _idUsuario)
                    pnlErrores.Visible = False
                    _cantidad = dsDatos.Tables(0).Rows.Count.ToString
                    CargarInventario()
                Else
                    epNotificacion.showWarning("Se encontraron diferencias al subir el archivo plano, por favor verifique el log de resultados")
                    gvErrores.DataSource = dsDatos.Tables(1)
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

    Private Sub gvErrores_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvErrores.PageIndexChanging
        If Session("dtErrorCargue") IsNot Nothing Then
            Try
                Dim dtLog As DataTable = CType(Session("dtErrorCargue"), DataTable)
                gvErrores.PageIndex = e.NewPageIndex
                EnlazarErrores(dtLog)
            Catch ex As Exception
                epNotificacion.showError("Error al tratar de cambiar página. " & ex.Message)
            End Try
        Else
            epNotificacion.showWarning("Imposible recuperar el log de errores desde la memoria. No se puede cambiar la página.")
        End If
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarInventario()
        Try
            Dim resultado As New ResultadoProceso
            Dim cargar As New ValidarCargue
            Dim dtLog As New DataTable
            'dtLog.Columns.Add("Diferencias Encontradas", Type.GetType("System.String"))
            With cargar
                .IdUsuario = _idUsuario
                resultado = .CargarInventarioArchivo(dtLog)
            End With

            If resultado.Valor = 0 Then
                epNotificacion.showSuccess("Se realizo el cargue de " & _cantidad & " registros al inventario satifactoriamente.")
            ElseIf resultado.Valor = 1 Then
                epNotificacion.showError(resultado.Mensaje)
            Else
                dtLog.Columns("mensaje").ColumnName = "Diferencias Encontradas"
                epNotificacion.showWarning("No se pudo realizar el cargue de la información. El archivo contenía registros erroneos. Por favor verifique el Log de resultados")
                EnlazarErrores(dtLog)
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el inventario. " & ex.Message)
        End Try
    End Sub

    Private Sub EnlazarErrores(ByVal dtError As DataTable)
        pnlErrores.Visible = True
        With gvErrores
            .DataSource = dtError
            .DataBind()
        End With
        Session("dtErrorCargue") = dtError
    End Sub


#End Region

    
End Class