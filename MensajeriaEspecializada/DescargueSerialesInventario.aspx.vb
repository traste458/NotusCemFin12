Imports System.IO
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Inventario
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports System.ComponentModel
Imports System.Reflection


Partial Public Class DescargueSerialesInventario
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _listaSeriales As New List(Of String)

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Seguridad.verificarSession(Me)
            epNotificacion.clear()

            If Not IsPostBack Then
                With epNotificacion
                    .setTitle("Descargue de Seriales Inventario")
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                End With

                txtSerial.Attributes.Add("onkeypress", "javascript:return ValidaNumero(event)")
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al cargar la página: " & ex.Message)
        End Try
    End Sub

    Protected Sub lbProcesar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbProcesar.Click
        ProcesarArchivo()
    End Sub

    Protected Sub lbDescargarSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbDescargarSerial.Click
        DescargarSeriales()
    End Sub

#End Region

#Region "Métodos Privados"

    Public Sub ProcesarArchivo()
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            Dim dtArchivo As New DataTable
            dtArchivo = ValidarArchivo()

            If dtArchivo.Rows.Count = 0 Then
                Dim objDescargueInverarioCEM As New DescargueInventarioCEM(_listaSeriales)


                Dim dtSeriales As DataTable = ConvertToDataTable(_listaSeriales)
                dtArchivo = objDescargueInverarioCEM.ValidarDescargue(idUsuario, dtSeriales)

                If dtArchivo.Rows.Count = 0 Then
                    objDescargueInverarioCEM.CargarDatos()
                    For Each serial As ItemBodegaSatelite In objDescargueInverarioCEM
                        objDescargueInverarioCEM.Remover(serial)
                    Next

                    objDescargueInverarioCEM.AplicarCambios(idUsuario)
                    epNotificacion.showSuccess("Se descargaron correctamente los seriales.")
                    pnlErrores.Visible = False
                Else
                    epNotificacion.showWarning("No se logro realizar el descargue de los archivos, por favor revisar el log de Resultados.")
                    pnlErrores.Visible = True
                    gvErrores.DataSource = dtArchivo
                    gvErrores.DataBind()
                End If
            Else
                epNotificacion.showWarning("El archivo no es válido para realizar el descargue, por favor revise el log de resultados.")
                pnlErrores.Visible = True
                gvErrores.DataSource = dtArchivo
                gvErrores.DataBind()
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al procesar el archivo: " & ex.Message)
        End Try
    End Sub
    Public Shared Function ConvertToDataTable(Of T)(ByVal list As IList(Of T)) As DataTable
        Dim table As New DataTable()
        table.Columns.Add(New DataColumn("Serial", GetType(System.String)))
        For Each item As T In list
            Dim row As DataRow = table.NewRow()
            row("Serial") = item
            table.Rows.Add(row)
        Next
        Return table
    End Function
    Public Sub DescargarSeriales()
        Try
            Dim idUsuario As Integer
            If Session("usxp001") IsNot Nothing Then Integer.TryParse(Session("usxp001"), idUsuario)

            _listaSeriales.Clear()
            _listaSeriales.Add(txtSerial.Text)

            Dim objDescargueInverarioCEM As New DescargueInventarioCEM(_listaSeriales)
            Dim dtArchivo As DataTable = ConvertToDataTable(_listaSeriales)
            dtArchivo = objDescargueInverarioCEM.ValidarDescargue(idUsuario, dtArchivo)
            If dtArchivo.Rows.Count = 0 Then
                objDescargueInverarioCEM.CargarDatos()
                For Each serial As ItemBodegaSatelite In objDescargueInverarioCEM
                    objDescargueInverarioCEM.Remover(serial)
                Next
                objDescargueInverarioCEM.AplicarCambios(idUsuario)
                epNotificacion.showSuccess("Se descargaron correctamente el serial.")
                txtSerial.Text = String.Empty
                pnlErrores.Visible = False
            Else
                epNotificacion.showWarning("No se logro realizar el descargue de los archivos, por favor revisar el log de Resultados.")
                pnlErrores.Visible = True
                gvErrores.DataSource = dtArchivo
                gvErrores.DataBind()
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al descargar el serial: " & ex.Message)
        End Try
    End Sub

    Private Sub registraError(ByRef dtDatos As DataTable, ByVal linea As Integer, ByVal mensaje As String)
        Try
            Dim row As DataRow = dtDatos.NewRow()
            row.Item("mensaje") = "Linea " & linea & ": " & mensaje
            dtDatos.Rows.Add(row)
            dtDatos.AcceptChanges()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Function ValidarArchivo() As DataTable
        Dim dtReturn As New DataTable()
        dtReturn.Columns.Add(New DataColumn("Mensaje", GetType(String)))

        Try
            If fuArchivo.HasFile AndAlso (Not String.IsNullOrEmpty(fuArchivo.PostedFile.FileName)) Then
                Dim linea As Integer = 1
                _listaSeriales.Clear()
                Using srArchivo As New StreamReader(fuArchivo.FileContent())
                    Do
                        Dim strLinea As String = srArchivo.ReadLine()
                        If String.IsNullOrEmpty(strLinea) Then
                            registraError(dtReturn, linea, "Vacía")
                        Else
                            If Not CheckIfAlphaNumeric(strLinea) Then
                                registraError(dtReturn, linea, "Serial no válido")
                            End If
                        End If
                        linea = linea + 1
                        _listaSeriales.Add(strLinea)
                    Loop While Not srArchivo.EndOfStream
                End Using
            Else
                Throw New Exception("No se logro obtener el nombre del archivo.")
            End If
        Catch ex As Exception
            Throw ex
        End Try
        Return dtReturn
    End Function

    Public Shared Function CheckIfAlphaNumeric(Str As String) As Boolean
        Dim IsAlpha As Boolean = True
        Dim c As Char
        Try
            For i As Integer = 0 To Str.Length() - 1
                c = Str.Chars(i)
                If Not IsNumeric(c) And Not IsAlphabet(c) Then
                    IsAlpha = False
                    Exit For
                End If
            Next
        Catch ex As Exception
            IsAlpha = False
        End Try
        Return IsAlpha
    End Function
    Public Shared Function IsAlphabet(alpha As String) As Boolean
        Dim IsA As Boolean = False
        Try
            IsA = (Asc(alpha) >= 65 And Asc(alpha) <= 90) Or (Asc(alpha) >= 97 And Asc(alpha) <= 122)
        Catch ex As Exception
            IsA = False
        End Try
        Return IsA
    End Function

#End Region

End Class