Imports System.IO
Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports GemBox.Spreadsheet
Imports DevExpress.Web

Public Class CreaciónServicioServicioTecnico
    Inherits System.Web.UI.Page

#Region "Atributos"

    Private _nombreArchivo As String
    Private oExcel As ExcelFile
    Private objCargue As CargueArchivoServicioTecnico

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Registro Servicio Equipos Reparados ST")
            End With
        End If
    End Sub

    Private Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Dim validacionArchivo As New ResultadoProceso
        If fuArchivo.PostedFile.ContentLength <= 10485760 Then
            If fuArchivo.PostedFile.FileName <> "" Then
                Dim ruta As String = "\\Colbogsacde001\Portales\ArchivosTemporale\"
                Dim nombreArchivo As String = "CargueMasivo_" & Session("usxp001") & Path.GetExtension(fuArchivo.PostedFile.FileName)
                _nombreArchivo = nombreArchivo
                ruta += nombreArchivo
                fuArchivo.SaveAs(ruta)
                Dim extencion As String = Path.GetExtension(fuArchivo.PostedFile.FileName).ToLower
                If extencion = ".xls" Or extencion = ".xlsx" Then
                    validacionArchivo = ProcesarArchivo(ruta)
                    hdIdGeneral.Set("valor", validacionArchivo.Valor)
                    If validacionArchivo.Valor = 0 Then
                        miEncabezado.showSuccess(validacionArchivo.Mensaje)
                    Else
                        miEncabezado.showWarning(validacionArchivo.Mensaje)
                    End If
                    ScriptManager.RegisterStartupScript(Me, GetType(Page), "mostrarMensaje", "<script>Procesar()</script>", False)
                Else
                    miEncabezado.showError("Tipo de archivo incorrecto. Se espera un archivo con extensión .XLS")
                    Exit Sub
                End If
            Else
                miEncabezado.showError("Debe seleccionar un archivo")
            End If
        Else
            miEncabezado.showError("El archivo tiene un peso mayor al permitido que es de 10MB.")
        End If
    End Sub

    Protected Sub btnXlsxExport_Click(ByVal sender As Object, ByVal e As EventArgs)
        gveErrores.WriteXlsxToResponse()
    End Sub

    Private Sub gvErrores_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvErrores.CustomCallback
        Try
            Dim param As String = e.Parameters
            Select Case param
                Case "erroresRegistro"
                    With gvErrores
                        .DataSource = Session("dtErrores")
                        .DataBind()
                    End With
                Case Else
                    If objCargue Is Nothing Then
                        objCargue = Session("objCargue")
                    End If
                    With gvErrores
                        .DataSource = objCargue.EstructuraTablaErrores()
                        Session("dtErrores") = .DataSource
                        .DataBind()
                    End With
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar visualizar el log: " & ex.Message)
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        End Try
    End Sub

    Private Sub gvErrores_DataBinding(sender As Object, e As EventArgs) Handles gvErrores.DataBinding
        If Session("dtErrores") IsNot Nothing Then gvErrores.DataSource = Session("dtErrores")
    End Sub

#End Region

#Region "Métodos Privados"

    Private Function ProcesarArchivo(ByVal ruta As String) As ResultadoProceso
        Dim resultado As New ResultadoProceso
        Try
            objCargue = New CargueArchivoServicioTecnico(oExcel)
            If objCargue.ValidarEstructura(ruta) Then
                If objCargue.ValidarInformacion() Then
                    resultado = objCargue.RegistrarServicioEquiposReparadosST()
                    If resultado.Valor = 0 Then
                        'Guardar Archivo
                        'uploader.SaveAs(Server.MapPath("~") & rutaAlmacenamiento & identificador.ToString())
                    End If
                Else
                    resultado.EstablecerMensajeYValor(20, "Datos Inválidos en el archivo proporcionado")
                End If
            Else
                resultado.EstablecerMensajeYValor(10, "Estructura inválida en el archivo proporcionado")
            End If
            Session("objCargue") = objCargue
        Catch ex As Exception
            resultado.EstablecerMensajeYValor(300, "Se generó un error al cargar el archivo: " & ex.Message)
        End Try
        Return resultado
    End Function

#End Region

End Class