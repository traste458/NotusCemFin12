Imports DevExpress.Web
Imports ILSBusinessLayer
Imports LMDataAccessLayer

Public Class ReporteRutasSimpliRoute
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
#If DEBUG Then
        Session("usxp001") = 14974  '2009
#End If
        Try
            If Not Me.IsPostBack Then
                With epPrincipal
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("Reporte de Rutas")

                    deFechaInicial.Date = DateTime.Now
                    deFechaFinal.Date = DateTime.Now
                End With
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar página: " & ex.Message)
        End Try
    End Sub


    Protected Sub cpPrincipal_Callback(sender As Object, e As CallbackEventArgsBase) Handles cpPrincipal.Callback
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        epPrincipal.clear()

        Try
            Dim arrayParameters As String()
            arrayParameters = Split(e.Parameter.ToString, ":")
            Select Case arrayParameters(0)
                Case "consultarRutas" ' Consulta información de rutas aplicando filtro de fechas
                    ConsultarInformacion()

                Case "ExportarRutas" 'Exporta rutas seleccionadas en la grilla
                    If hfRutaSeleccionado.Count > 0 Then
                        ConsultarMasivoRutas()
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de ejecutar operación : " & ex.Message)
        End Try
    End Sub

    Private Function ConsultarInformacion() As ResultadoProceso
        Dim ruta As New RutaSimpliRoute
        Dim dtDatos As DataTable
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Session.Remove("dtRutasSimpliRoute")

        With ruta
            .IdUsuario = Session("usxp001")
            .Opcion = 1
            If deFechaInicial.Value <> Date.MinValue Then
                .FechaInicial = CDate(deFechaInicial.Value)
                deFechaInicial.Date = CDate(deFechaInicial.Value)
            End If
            If deFechaFinal.Value <> Date.MinValue Then
                .FechaFinal = CDate(deFechaFinal.Value)
                deFechaFinal.Date = CDate(deFechaFinal.Value)
            End If

            dtDatos = .ObtenerReporteSimpliRoute()
            Session("dtRutasSimpliRoute") = dtDatos

        End With

        If dtDatos.Rows.Count Then
            With gridInfoRutas
                .DataSource = CType(Session("dtRutasSimpliRoute"), DataTable)
                .DataBind()
            End With
            resultado.Valor = 1
        Else
            With gridInfoRutas
                .DataSource = Nothing
                .DataBind()
            End With
            resultado.Valor = 0
        End If
        Return resultado
    End Function

    Private Sub ConsultarMasivoRutas()
        Dim ruta As New RutaSimpliRoute
        Dim dtDatos As DataTable
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtRutas As New DataTable
        Dim resul As New InfoResultado
        Dim metodos As New MetodosComunes

        Dim fecha As String = DateTime.Now.ToString("HH:mm:ss:fff")
        fecha = fecha.Replace(":", "_").ToString()
        Dim nombreArchivo As String = "ReporteMasivoSimpliRoute" & "_" & fecha & ".xlsx"

        Session.Remove("dtRutasMasivo")

        dtRutas.Columns.Add("IdListaBigint", GetType(Integer))

        Try
            With ruta

                .IdUsuario = Session("usxp001")

                Dim valoresRutas As String = String.Empty
                For Each item As Object In hfRutaSeleccionado
                    valoresRutas = item.Value
                    Dim arrValores() As String = Split(valoresRutas, ";")

                    dtRutas.Rows.Add(arrValores(0))
                Next

                dtDatos = .ConsultarRutasCargueMasivoVisitaSimpliRoute(dtRutas)
                Session("dtRutasMasivo") = dtDatos

                resul = metodos.exportarDatosAExcelGemBoxCallback(dtDatos, nombreArchivo, Server.MapPath("../archivos_planos/" & nombreArchivo), Nothing, Nothing, True, False)

                If resul.Valor > 0 Then
                    cpPrincipal.JSProperties("cpNombreArchivo") = resul.Mensaje
                Else
                    epPrincipal.showError("Error al generar reporte " & resul.Mensaje)
                End If
            End With
        Catch ex As Exception
            epPrincipal.showError(resul.Mensaje)
        End Try
    End Sub

    Protected Sub cm_selectAll_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim CM_chk As ASPxCheckBox = TryCast(sender, ASPxCheckBox)
        Dim grid As ASPxGridView = (TryCast(CM_chk.NamingContainer, GridViewHeaderTemplateContainer)).Grid
        CM_chk.Checked = False
    End Sub

    Protected Sub Link_Init_chkBox(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkRuta As ASPxCheckBox = CType(sender, ASPxCheckBox)
            Dim container As GridViewDataItemTemplateContainer = CType(lnkRuta.NamingContainer, GridViewDataItemTemplateContainer)

            lnkRuta.ClientSideEvents.CheckedChanged = lnkRuta.ClientSideEvents.CheckedChanged.Replace("{0}", container.KeyValue)

            Dim c As GridViewDataItemTemplateContainer = TryCast((CType(sender, ASPxCheckBox)).NamingContainer, GridViewDataItemTemplateContainer)
            CType(sender, ASPxCheckBox).ClientInstanceName = "cbRuta" & c.KeyValue.ToString()
            CType(sender, ASPxCheckBox).JSProperties("cp_indexcm") = c.VisibleIndex

            Dim hfKey As String = "key" & c.KeyValue.ToString() '.Replace("|"c, ";"c)

            If hfRutaSeleccionado.Contains(hfKey) Then
                Dim pars As String() = Convert.ToString(hfRutaSeleccionado(hfKey)).Split(";"c)

                If pars.Length > 0 Then
                    CType(sender, ASPxCheckBox).Checked = Convert.ToBoolean(Convert.ToString(pars(1)))
                End If
            End If
        Catch ex As Exception
            epPrincipal.showError("No fué posible establecer el identificador de la ruta: " & ex.Message)
        End Try
    End Sub

    Protected Sub gridInfoRutas_DataBinding(sender As Object, e As EventArgs) Handles gridInfoRutas.DataBinding

        gridInfoRutas.DataSource = CType(Session("dtRutasSimpliRoute"), DataTable)

    End Sub

    Protected Sub gridDetail_BeforePerformDataSelect(sender As Object, e As EventArgs)
        Try
            Session("idRuta") = (TryCast(sender, ASPxGridView)).GetMasterRowKeyValue()
            CargarDetalleRuta(TryCast(sender, ASPxGridView))
        Catch ex As Exception
            Throw New Exception("Error al tratar de obtener los datos de órdenes de recepción " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalleRuta(gv As ASPxGridView)

        If Session("idRuta") IsNot Nothing Then

            Dim idRuta As Integer = CInt(Session("idRuta"))
            Dim dtDetalle As New DataTable
            dtDetalle = ObtenerDetalle(idRuta)
            Session("dtDetalle") = dtDetalle
            With gv
                .DataSource = Session("dtDetalle")
            End With
        Else
            Throw New Exception("No se pudo establecer el identificador da la ruta, por favor intente nuevamente.")
        End If
    End Sub

    Private Function ObtenerDetalle(ByVal idRuta As Integer) As DataTable
        Dim dtResultado As New DataTable
        Try
            Dim ruta As New RutaSimpliRoute
            With ruta
                .IdUsuario = Session("usxp001")
                .Opcion = 2
                .IdRuta = idRuta
                dtResultado = .ObtenerReporteSimpliRoute()
            End With
        Catch ex As Exception
            Throw New Exception("Se presento un error al cargar el detalle de la ruta:." & ex.Message)
        End Try
        Return dtResultado
    End Function
End Class