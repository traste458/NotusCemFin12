Imports GemBox.Spreadsheet
Imports System.IO
Imports DevExpress.Web
Imports LMDataAccessLayer
Imports ILSBusinessLayer

Public Class CrearCargueRealceDavivienda
    Inherits System.Web.UI.Page


#Region "Atributos"
    Private excel As ExcelFile
    Private rutaArchivo As String
    Private dtErrorArchivo, dtArchivo As DataTable
#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epPrincipal.clear()
        Try
            If Not Me.IsPostBack Then
                epPrincipal.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                epPrincipal.setTitle("Cargue realce Davivienda.")
                CargarLicenciaGembox()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub gridErrores_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gridErrores.CustomCallback
        Dim dtDatos As DataTable = Session("dtErrores")

        With gridErrores
            .PageIndex = 0
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Private Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        Dim parametro As String
        Dim arrParametro() As String

        parametro = e.Parameter.ToString
        arrParametro = parametro.Split("¬")

        If arrParametro(0).ToString.ToUpper = "CAMBIOTIPOARCHIVO" Then
            Session("TipoArchivo") = arrParametro(1)
        End If
    End Sub

    Private Sub gridErrores_DataBinding(sender As Object, e As EventArgs) Handles gridErrores.DataBinding
        gridErrores.DataSource = Session("dtErrores")
    End Sub

    Private Function CargarArchivo() As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            If (fUploadArchivo.HasFile) Then
                rutaArchivo = Server.MapPath("~/Archivos_Planos/CEM" & Session("usxp001"))
                fUploadArchivo.SaveAs(rutaArchivo & fUploadArchivo.FileName)
                Session("rutaArchivo") = rutaArchivo & fUploadArchivo.FileName

                Dim fileExtension As String = Path.GetExtension(fUploadArchivo.FileName)
                excel = New ExcelFile()

                If fileExtension.ToUpper = ".XLS" Then
                    excel.LoadXls(rutaArchivo & fUploadArchivo.FileName)
                ElseIf fileExtension.ToUpper = ".XLSX" Then
                    excel.LoadXlsx(rutaArchivo & fUploadArchivo.FileName, XlsxOptions.None)
                Else
                    resultado.EstablecerMensajeYValor(-504, "El archivo no es de tipo Excel.")
                End If

                Dim cargar As New ILSBusinessLayer.CrearCargueRealceDavivienda

                With cargar
                    .RutaArchivo = Session("rutaArchivo")
                    resultado = .CargarArchivo()
                End With

            Else
                resultado.EstablecerMensajeYValor(-503, "Por favor seleccione el archivo que desea subir.")
            End If

        Catch ex As Exception
            resultado.EstablecerMensajeYValor(-501, "Error al cargar el archivo: " & ex.Message)
        End Try
        Return resultado

    End Function

    Private Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Dim resultado As New ResultadoProceso
        resultado = CargarArchivo()
        If resultado.Valor = 1 Then
            epPrincipal.showSuccess(resultado.Mensaje)
        Else
            epPrincipal.showError(resultado.Mensaje)
        End If
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "CargarArchivo", "<script>CargarArchivo()</script>", False)
    End Sub

#End Region





End Class