Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports System.Text
Imports GemBox.Spreadsheet
Imports System.IO
Imports GemBox
Imports System.Collections.Generic

Public Class GenerarPlanillaRadicacion
    Inherits System.Web.UI.Page

#Region "Atributos."



#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = IIf(Session("usxp001") Is Nothing, "20099", Session("usxp001"))
        Session("usxp007") = IIf(Session("usxp007") Is Nothing, "150", Session("usxp007"))
#End If


        Try
            If Not Me.IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("::: Gestion Radicados Mesa de Control ::: ")
                End With
                Dim radicado As New PlanillaRadicacion
                radicado.IdUsuario = Integer.Parse(Session("usxp001"))
                radicado.CargarRegistrosRadicadoTransitorios()
                CargarTablaRadicados(radicado.Radicados)
            End If
            If cpGeneral.IsCallback Then
                gvDatos.DataBind()
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al cargar la opción. " & ex.Message & "<br><br>")
        End Try
    End Sub
    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            miEncabezado.clear()
            Dim resultado As New ResultadoProceso
            Dim arrAccion As String()
            arrAccion = e.Parameter.Split("|")
            Select Case arrAccion(0)
                Case "cargarSerial"
                    Try
                        VerificarCambiarRadicado(arrAccion(1))
                        txtSerial.Focus()
                    Catch ex As Exception
                        miEncabezado.showError("Se generó un error al registrar el serial:" & ex.Message)
                    End Try
                Case "cargarSerialDestruccion"
                    Try
                        VerificarCambiarRadicado(arrAccion(1))
                    Catch ex As Exception
                        miEncabezado.showError("Se generó un error al registrar el serial:" & ex.Message)
                    End Try
                Case "removerSerial"
                    Dim planilla As New PlanillaRadicacion
                    With planilla
                        .IdUsuario = Integer.Parse(Session("usxp001"))
                        .Radicado = arrAccion(1)
                        resultado = .BorrarResgistrosRadicadoTransitorios
                        If resultado.Valor = 0 Then
                            miEncabezado.showSuccess("Registro removido")
                            .CargarRegistrosRadicadoTransitorios()
                            CargarTablaRadicados(planilla.Radicados)
                        Else
                            miEncabezado.showError("Error al remover registro: " & resultado.Mensaje)
                        End If
                    End With
                Case "BorrarTodo"
                    Dim planilla As New PlanillaRadicacion
                    With planilla
                        .IdUsuario = Integer.Parse(Session("usxp001"))
                        .BorrarResgistrosRadicadoTransitorios()
                        .CargarRegistrosRadicadoTransitorios()
                        CargarTablaRadicados(.Radicados)
                    End With
                Case "RegistrarPlanilla"
                    GenerarPlanilla()
                Case "Reimprimir"
                    Try
                        ReimprimirPLanilla(arrAccion(1))
                    Catch ex As Exception
                        miEncabezado.showError("Error al reimprimir la planilla: " & ex.Message)
                    End Try
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            txtSerial.Focus()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtrener la información:" & ex.Message)
        End Try
        cpGeneral.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub



    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        If Session("dtgvDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtgvDatos")
    End Sub
#End Region

#Region "Metodos Privados"
    Protected Sub LinkDatos_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub
    Private Sub limpiar()

        txtSerial.Text = String.Empty
        With gvDatos
            .DataSource = Nothing
            .DataSourceID = Nothing
            .DataBind()
        End With
        txtSerial.Focus()
    End Sub
    Private Sub CargarTablaRadicados(ByVal radicados As DataTable)
        Session("dtgvDatos") = radicados
        With gvDatos
            .DataSource = radicados
            .DataBind()
        End With
        If radicados.Rows.Count <> 0 Then
            rpAdministrador.ClientVisible = True
        Else
            rpAdministrador.ClientVisible = False
        End If
    End Sub
    Private Sub VerificarCambiarRadicado(ByVal Radicado As Long, Optional tipo As Integer = 1)

        pnlErrores.ClientVisible = False

        Dim resultado As ResultadoProceso
        Dim dtInfRadicado As New DataTable()
        Dim msjRecibido As String = String.Empty
        Dim objPlanilla As New PlanillaRadicacion

        With objPlanilla
            .IdUsuario = Integer.Parse(Session("usxp001"))
            .Radicado = Radicado
            resultado = .RegistrarRadicadoTransitorio(tipo)
            If (resultado.Valor <> 0) Then
                miEncabezado.showError(resultado.Mensaje)
            End If
        End With


        With objPlanilla
            .CargarRegistrosRadicadoTransitorios()
            dtInfRadicado = .Radicados
            Session("dtgvDatos") = dtInfRadicado
            CargarTablaRadicados(dtInfRadicado)

            gvErrores.DataSource = .Errores
            gvErrores.DataBind()
            If .Errores.Rows.Count > 0 Then
                pnlErrores.ClientVisible = True
            End If

        End With


        txtSerial.Text = String.Empty
        txtSerial.Focus()
    End Sub
    Private Sub ReimprimirPLanilla(radicado As Long)
        Dim planilla As New PlanillaRadicacion
        Dim ds As DataSet
        Dim url As String
        planilla.Radicado = radicado
        planilla.IdUsuario = Integer.Parse(Session("usxp001"))
        ds = planilla.CargarDatosPlanilla()
        url = GenerarExcelPlanilla(ds)
        hdnUrl.Value = url
    End Sub
    Private Sub GenerarPlanilla()
        Dim planilla As New PlanillaRadicacion()
        Dim resultado As ResultadoProceso
        Dim ds As DataSet
        Dim url As String
        If String.IsNullOrEmpty(txtPrecinto.Text) Then
            miEncabezado.showError("El precinto no puede ser vacio")
            Return
        End If
        If gvDatos.DataSource Is Nothing Then
            miEncabezado.showError("No posee radicados ingresados.")
            Return
        End If
        With planilla
            .IdUsuario = Integer.Parse(Session("usxp001"))
            .IdCiudad = Integer.Parse(Session("usxp007"))
            .Precinto = txtPrecinto.Text
            .Observaciones = memoObservacion.Text
            resultado = .RegistrarPlanilla()
        End With
        If resultado.Valor = 0 Then
            ds = planilla.CargarDatosPlanilla()
            url = GenerarExcelPlanilla(ds)
            planilla = New PlanillaRadicacion()
            planilla.IdUsuario = Integer.Parse(Session("usxp001"))
            planilla.BorrarResgistrosRadicadoTransitorios()
            Session("dtgvDatos") = Nothing
            gvDatos.DataSource = Nothing
            gvDatos.DataBind()
            hdnUrl.Value = url
            txtPrecinto.Text = ""
            memoObservacion.Text = ""
            miEncabezado.showSuccess("Planilla generada Exitosamente")
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If
    End Sub

    Private Function GenerarExcelPlanilla(planillaDs As DataSet) As String

        Dim resultado As ResultadoProceso
        HerramientasFuncionales.CargarLicenciaGembox()
        Dim miWs As ExcelWorksheet
        Dim contexto As HttpContext = HttpContext.Current
        Dim fullPath As String
        fullPath = contexto.Server.MapPath("~/MensajeriaEspecializada/Plantillas/")
        Dim miExcel As New ExcelFile
        miExcel.LoadXlsx(fullPath & "PlanillaOrdenRadiacionBanco.xlsx", XlsxOptions.None)
        Dim templateSheet As ExcelWorksheet = miExcel.Worksheets(0)
        Dim _rutaArchivo As String
        Dim nombreFinalPlanilla As String = "PlanillaRadicacionDocumentos-" & System.DateTime.Now.ToString("yyyyMMddHHmmss") & ".xlsx"
        miWs = miExcel.Worksheets(0)
        Dim generic As String
        Dim cabecera As DataTable = planillaDs.Tables(0)
        Dim detalle As DataTable = planillaDs.Tables(1)
        Dim fila As Integer = 12
        Dim control As Integer = 1


        miWs.Cells("J6").Value = cabecera.Rows(0).Item("Planilla").ToString()
        miWs.Cells("J7").Value = cabecera.Rows(0).Item("Precinto").ToString()
        miWs.Cells("J8").Value = cabecera.Rows(0).Item("CiudadUsuario").ToString()
        miWs.Cells("C8").Value = cabecera.Rows(0).Item("Radicacion").ToString()
        miWs.Cells("C9").Value = cabecera.Rows(0).Item("Novedades").ToString()

        generic = System.DateTime.Now.ToString("dd-MM-yyyy") & " " & cabecera.Rows(0).Item("CiudadUsuario").ToString()
        miExcel.Worksheets(0).Name = generic


        'Inserta el cuerpo de la planilla
        For Each row As DataRow In detalle.Rows

            miWs.Cells("B" & fila).Value = control
            miWs.Cells("C" & fila).Value = System.DateTime.Now.ToString("dd/MM/yyyy")
            miWs.Cells("E" & fila).Value = "Aplica"
            miWs.Cells("F" & fila).Value = "No Aplica"
            miWs.Cells("G" & fila).Value = row("pagare").ToString
            miWs.Cells("H" & fila).Value = row("identificacion").ToString
            miWs.Cells("I" & fila).Value = row("campana").ToString
            miWs.Cells("J" & fila).Value = row("codEstrategia").ToString
            miWs.Cells("D" & fila).Value = 12 ' siempre va 12
            miWs.Cells("K" & fila).Value = row("outsourcing").ToString
            miWs.Cells("L" & fila).Value = row("codOficina").ToString
            fila += +1
            control += +1

        Next
        miWs.Cells("C" & (fila + 5)).Value = cabecera.Rows(0).Item("usuario").ToString()

        miWs.Cells("B" & (fila + 6)).SetBorders(MultipleBorders.Top, Color.Black, LineStyle.Medium)
        miWs.Cells("C" & (fila + 6)).SetBorders(MultipleBorders.Top, Color.Black, LineStyle.Medium)
        miWs.Cells("D" & (fila + 6)).SetBorders(MultipleBorders.Top, Color.Black, LineStyle.Medium)

        Dim ruta As String = "TemporalPlanillaRadicacionBanco/"

        If Not Directory.Exists(Server.MapPath(ruta)) Then
            Directory.CreateDirectory(Server.MapPath(ruta))
        End If

        _rutaArchivo = contexto.Server.MapPath("~/MensajeriaEspecializada/" & ruta) & nombreFinalPlanilla
        miExcel.SaveXlsx(_rutaArchivo)

        Return ruta & nombreFinalPlanilla
    End Function
#End Region

    Protected Sub btnDestruirFinal_Click(sender As Object, e As EventArgs)
        If gvDatos.DataSource Is Nothing Then
            miEncabezado.showError("Debe leer radicados para la destruccion de documentos.")
            Return
        End If
    End Sub
End Class