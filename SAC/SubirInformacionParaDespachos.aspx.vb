Imports ILSBusinessLayer

Partial Public Class SubirInformacionParaDespachos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()
        LimpiarLog()
        If Not Me.IsPostBack Then
            With miEncabezado
                .setTitle("Subir información para despachos")
            End With

            CargaInicial()
        End If
    End Sub

    Private Sub CargaInicial()
        Dim filtroTransportadoras As Estructuras.FiltroTransportadora

        filtroTransportadoras.Activo = Enumerados.EstadoBinario.Activo
        filtroTransportadoras.UsaGuia = True
        filtroTransportadoras.CargaPorImportacion = 2

        MetodosComunes.CargarDropDown(AdministradorArchivos.ObtenerTiposArchivoCarga, ddlOpciones, "Escoja tipo de información...")
        MetodosComunes.CargarDropDown(Transportadora.ListadoTransportadoras(filtroTransportadoras), ddlTransportadoras, "Escoja una transportadora...")
        pnlGuias.Visible = False
        pnlInfoTransportadoras.Visible = False
        pnlValorDeclarado.Visible = False
        miEncabezado.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
    End Sub

    Private Sub LimpiarLog()
        gvErrores.DataSource = Nothing
        gvErrores.DataBind()
        pnlErrores.Visible = False
    End Sub

    Private Sub ddlOpciones_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlOpciones.SelectedIndexChanged
        If ddlOpciones.SelectedValue = 1 Then
            pnlGuias.Visible = False
            pnlInfoTransportadoras.Visible = True
            pnlValorDeclarado.Visible = False
        ElseIf ddlOpciones.SelectedValue = 2 Then
            pnlGuias.Visible = False
            pnlInfoTransportadoras.Visible = False
            pnlValorDeclarado.Visible = True
        ElseIf ddlOpciones.SelectedValue = 3 Then
            pnlGuias.Visible = True
            pnlInfoTransportadoras.Visible = False
            pnlValorDeclarado.Visible = False
        End If
    End Sub

    Protected Sub btnSubirTransportadoras_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubirTransportadoras.Click
        Dim manejadorArchivo As New AdministradorArchivos
        Dim ruta As String = ""

        Try
            manejadorArchivo.IdUsuario = Session("usxp001")
            ruta = Server.MapPath("../archivos_planos/") & manejadorArchivo.IdUsuario.ToString() & fuTransportadoras.FileName
            fuTransportadoras.SaveAs(ruta)

            manejadorArchivo.CargarMatrizTransporte(ruta, manejadorArchivo.IdUsuario)

            If manejadorArchivo.ContieneErrores Then
                pnlErrores.Visible = True
                gvErrores.DataSource = manejadorArchivo.ListaErrores
                gvErrores.DataBind()
            Else
                miEncabezado.showSuccess("Los datos fueron almacenados correctamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la carga del archivo: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnSubirValores_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubirValores.Click
        Dim manejadorArchivo As New AdministradorArchivos
        Dim ruta As String = ""

        Try
            manejadorArchivo.IdUsuario = Session("usxp001")
            ruta = Server.MapPath("../archivos_planos/") & manejadorArchivo.IdUsuario.ToString() & fuValores.FileName
            fuValores.SaveAs(ruta)

            manejadorArchivo.CargarValoresDeclarados(ruta, manejadorArchivo.IdUsuario)

            If manejadorArchivo.ContieneErrores Then
                pnlErrores.Visible = True
                gvErrores.DataSource = manejadorArchivo.ListaErrores
                gvErrores.DataBind()
            Else
                miEncabezado.showSuccess("Los datos fueron almacenados correctamente")
            End If
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error durante la carga del archivo: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuias_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGuias.Click
        Try
            Transportadora.RegistrarRangoGuias(ddlTransportadoras.SelectedValue, txtGuiaInicial.Text.Trim, txtGuiaFinal.Text.Trim)
            miEncabezado.showSuccess("Los datos de guías de transportadora fueron registrados correctamente")
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un inconveniente durante la asignación del rango de guías: " & ex.Message)
        End Try
    End Sub

    Protected Sub lnkBajarMatrizActual_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkBajarMatrizActual.Click
        Dim matriz As DataTable
        Try
            matriz = AdministradorArchivos.GenerarPlantillaMatriz
            MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, matriz, "Matriz de Transporte", "MatrizTransporte.xls", Server.MapPath("../archivos_planos/MatrizTransporte.xls"))
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error recuperando la información de la matriz de transporte: " & ex.Message)
        End Try
    End Sub

    Protected Sub lnkBajarValoresActuales_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkBajarValoresActuales.Click
        Dim matriz As DataTable
        Try
            matriz = AdministradorArchivos.GenerarPlantillaValores
            MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, matriz, "Valores Declarados", "ValoresDeclarados.xls", Server.MapPath("../archivos_planos/ValoresDeclarados.xls"))
        Catch ex As Exception
            miEncabezado.showError("Ocurrió un error recuperando la información de los valores declarados: " & ex.Message)
        End Try
    End Sub
End Class