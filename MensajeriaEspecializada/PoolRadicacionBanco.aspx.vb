Imports System.Collections.Generic
Imports ILSBusinessLayer
Imports DevExpress.Web
Imports System.IO
Imports GemBox.Spreadsheet

Public Class PoolRadicacionBanco
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Session("usxp001")) IsNot Nothing Then
            hdfUsuarioSesion.Value = Integer.Parse(Session("usxp001"))
        Else
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "sesion", "alert('Por favor inicie sesión', 'rojo')", True)
        End If

    End Sub

    Protected Sub gvDatos_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles gvDatos.CustomCallback
        Dim resultadoBusqueda As String = String.Empty
        Try
            Dim resultado As New ResultadoProceso
            Dim arrAccion As String()

            arrAccion = e.Parameters.Split(":")
            'gvDatos.FocusedRowIndex = arrAccion(1)
            Select Case arrAccion(0)
                Case "ConsultaVentaCliente"
                    resultadoBusqueda = ConsultaAutocomplete(arrAccion(1))
                Case "VerDocsMC"
                    resultadoBusqueda = VerDocumentosMesaC(arrAccion(1))
                Case "VerCausalesrechazo"
                    resultadoBusqueda = ObtenerCausalesRechazo(arrAccion(1))
                Case "GuardarRechazoDocumentos"
                    resultadoBusqueda = GuardarRechazoDocMC(arrAccion(1))
                Case "AprobarDocumentos"
                    resultadoBusqueda = AprobarDocumentosMC(arrAccion(1))
                Case "LimpiarSesionImagenes"
                    resultadoBusqueda = LimpiarSesionImagenes()
                Case "VerificarCambiarEstadoRadicado"
                    resultadoBusqueda = VerificarCambiarRadicado(arrAccion(1))
                Case "ConsultarCausalesDevolucion"
                    resultadoBusqueda = ConsultaCausalesDevolucion(arrAccion(1))
                Case "GuardarRechazoDocumentosBanco"
                    resultadoBusqueda = GuardarRechazoDocBanco(arrAccion(1))
                Case "DocEnRecuperacion"
                    resultadoBusqueda = DocumentoRecuperacionMC(arrAccion(2))
                Case "GenerarPlanillaRadicacion"
                    resultadoBusqueda = GenerarPlanillaRadicacion(arrAccion(1), arrAccion(2))
                Case "PasarADestruccion"
                    resultadoBusqueda = PasoDestruccionDocs(arrAccion(1))
                Case "FinalizarCampania"
                    resultadoBusqueda = FinalizarCampania(arrAccion(1))
                Case "VerNovedadesRadicado"
                    resultadoBusqueda = VerNovedadesRadicado(arrAccion(1))
                Case "DevolverEstadoRecepcionRadicado"
                    resultadoBusqueda = DevolverEstadoRecepcionRadicado(arrAccion(1))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtrener la información:" & ex.Message)
        End Try

        If (String.IsNullOrEmpty(resultadoBusqueda)) Then
            CType(sender, ASPxGridView).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
        Else
            CType(sender, ASPxGridView).JSProperties("cpBusquedaVta") = resultadoBusqueda
        End If

    End Sub

    Private Function ConsultaAutocomplete(ByVal operacion As Integer) As String
        Dim objVenta As New GenerarPoolServicioMensajeria
        Dim dtDataVenta As New DataTable
        Dim filtroBusqueda As String

        filtroBusqueda = txtCedulaRadiacado.Value

        'If (operacion = 1) Then

        'ElseIf (operacion = 2) Then
        '    filtroBusqueda = txtCampaniaEstrategia.Value
        'End If

        Try
            dtDataVenta = objVenta.ConsultaAutocomplete(operacion, filtroBusqueda)

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()
            Dim row As Dictionary(Of String, Object)
            For Each dr As DataRow In dtDataVenta.Rows
                row = New Dictionary(Of String, Object)()
                For Each col As DataColumn In dtDataVenta.Columns
                    row.Add(col.ColumnName, dr(col))
                Next
                rows.Add(row)
            Next
            Return operacion & "|" & serializer.Serialize(rows)
        Catch ex As Exception
            Return ex.ToString()
        End Try
    End Function

    Private Function VerDocumentosMesaC(ByVal idRadicado As Integer) As String
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim dtMC As New DataTable
        Dim tmpB64Imagenes As String = String.Empty

        Try
            With objDocumentos
                .IdRadicado = idRadicado
                dtMC = objDocumentos.ConsultaDocumentosMC()
                'tmpB64Imagenes = dtMC.Rows(0)(3).ToString()
            End With

            Dim posicion = 0
            For Each dr As DataRow In dtMC.Rows
                tmpB64Imagenes += dtMC.Rows(posicion).Item("DMCnombreDocumento").ToString() & "|"
                posicion += +1
            Next

            Return "-1|" & tmpB64Imagenes
        Catch ex As Exception
            Return ex.ToString()
        End Try
    End Function

    Private Function ObtenerCausalesRechazo(ByVal IdRadicado As Integer) As String
        Dim objVenta As New GenerarPoolServicioMensajeria
        Dim dsDataVenta As New DataSet
        Dim dtBanco As New DataTable
        Dim serializado As String = String.Empty

        With objVenta
            .IdRadicado = IdRadicado
            dsDataVenta = .ConsultaCausalesRechazoMC()
        End With

        If (dsDataVenta.Tables(0).Rows.Count > 0) Then
            dtBanco = dsDataVenta.Tables(0)

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()
            Dim row As Dictionary(Of String, Object)
            For Each dr As DataRow In dtBanco.Rows
                row = New Dictionary(Of String, Object)()
                For Each col As DataColumn In dtBanco.Columns
                    row.Add(col.ColumnName, dr(col))
                Next
                rows.Add(row)
            Next

            serializado = serializer.Serialize(rows)
        End If

        Return "-2|" & serializado
    End Function

    Private Function GuardarRechazoDocMC(ByVal ServicioObs As String) As String

        Dim objRechazo As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objRechazo
            .SplitServicios = hdfIdRadicado.Value
            .SplitCausales = hdfCausalesBanco.Value
            .ObservacionesDevolucionDocs = ServicioObs

            '.IdRadicado = Integer.Parse(ServicioObs.Split("|")(0))
            '.IdCausalDevolucion = IdCausal
            '.ObservacionesDevolucionDocs = ServicioObs.Split("|")(1)
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            .IdEstado = Enumerados.EstadoServicio.RechazadoMesaControl
            resultado = .GuardarRechazoMC()
        End With
        Return "-3|" & resultado.Mensaje & "_" & resultado.Valor
    End Function

    Private Function GuardarRechazoDocBanco(ByVal ServicioObs As String) As String

        Dim objRechazo As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objRechazo
            .SplitServicios = hdfIdRadicado.Value
            .SplitCausales = hdfCausalesBanco.Value
            .ObservacionesDevolucionDocs = ServicioObs

            '.IdRadicado = Integer.Parse(ServicioObs.Split("|")(0))
            '.IdCausalDevolucion = IdCausal
            '.ObservacionesDevolucionDocs = ServicioObs.Split("|")(1)
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            .IdEstado = Enumerados.EstadoServicio.RechazadoBanco
            resultado = .GuardarRechazoBanco()
        End With
        Return "-7|" & resultado.Mensaje
    End Function

    Private Function DocumentoRecuperacionMC(ByVal ServicioObs As String) As String

        Dim objRechazo As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objRechazo
            .DocRecuperacion = True
            .ObservacionesDevolucionDocs = ServicioObs.Split("|")(1)
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            .IdRadicado = Integer.Parse(ServicioObs.Split("|")(0))
            .IdEstado = Enumerados.EstadoServicio.RecuperacionMesaControl
            resultado = .DocumentoRecuperacionMC()
        End With
        Return "-6|" & resultado.Mensaje & "_" & resultado.Valor
    End Function

    Private Function AprobarDocumentosMC(ByVal idServicio As Integer) As String
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objDocumentos
            .DocRecuperacion = 1
            .IdRadicado = idServicio
            resultado = .GuardarRechazoMC()
        End With

        Return "-4|" & resultado.Mensaje
    End Function

    Protected Sub btnAgregarSoportes_Click(sender As Object, e As EventArgs)
        AdicionarSoporte()
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "prueba", "LlenarTabla();", True)
    End Sub

    Private Sub AdicionarSoporte()
        Try
            If fuArchivo.HasFile Then
                Dim _ruta As String
                Dim Variable As String = "RUTA_DOCUMENTOS_MESA_CONTROL"
                Dim rutaPlantilla As String = Server.MapPath("~/MensajeriaEspecializada/Archivos")
                Try
                    Dim obj As Comunes.ConfigValues = New Comunes.ConfigValues(rutaPlantilla)
                    _ruta = obj.ConfigKeyValue + "\" + Guid.NewGuid().ToString() + Path.GetExtension(fuArchivo.FileName)
                Catch ex As Exception
                    'epPrincipal.showError("Se generó un error al tratar cargar la ruta: " & "<br><br>" & ex.Message)
                    'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
                End Try
                If Not String.IsNullOrEmpty(_ruta) Then
                    fuArchivo.SaveAs(_ruta)
                    RegistrarSoporte(_ruta, fuArchivo.PostedFile.ContentType, Guid.NewGuid().ToString() + Path.GetExtension(fuArchivo.FileName))
                End If
            Else
                'epPrincipal.showWarning("Ya se ingreso el numero maximo de imagenes.")
                'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
            End If
            'If CType(Session("dtSoportes"), DataTable).Rows.Count <= 4 Then
            '    fuArchivo.Enabled = True
            '    btnAgregarSoportes.Enabled = True
            'Else
            '    fuArchivo.Enabled = False
            '    btnAgregarSoportes.Enabled = False
            'End If
        Catch ex As Exception
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('" & ex.Message & "', 'rojo')", True)
            'epPrincipal.showError("Se generó un error al tratar adicionar el archivos: " & "<br><br>" & ex.Message)
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
    End Sub

    Private Sub RegistrarSoporte(ByVal ruta As String, ByVal tipoImagen As String, ByVal nombre As String)
        '_contenidoTablaCliente = hdfContenidoTablaResultado.Value

        Try
            Dim img As System.Web.UI.WebControls.Image
            Dim fs As System.IO.Stream = fuArchivo.PostedFile.InputStream
            Dim br As New System.IO.BinaryReader(fs)
            Dim bytes As Byte() = br.ReadBytes(CType(fs.Length, Integer))
            Dim base64String As String = Convert.ToBase64String(bytes, 0, bytes.Length)
            Dim resultado As ResultadoProceso
            Dim objDocumentos As New GenerarPoolServicioMensajeria
            Dim dtDocum As DataTable

            With objDocumentos
                .IdRadicado = hdfIdRadicado.Value
                .NombreDocumento = nombre
                .ByteDocumento = "data:" & tipoImagen & ";base64," & base64String
                .RutaDocumento = ruta
                resultado = objDocumentos.GuardarDocumentoMC()
            End With

            Dim dtSoportes As New DataTable

            If Session("dtSoportes") IsNot Nothing Then
                If (Session("dtSoportes").Rows(0)(0).split("_")(0) <> hdfIdRadicado.Value) Then
                    Session("dtSoportes") = Nothing
                End If
            End If


            If Session("dtSoportes") Is Nothing Then
                dtSoportes.Columns.Add(New DataColumn("nombre", System.Type.GetType("System.String")))
                dtSoportes.Columns.Add(New DataColumn("ruta"))
                dtSoportes.Columns.Add(New DataColumn("tipoDocumento"))

                Dim pkColumn(0) As DataColumn
                With dtSoportes.Columns
                    pkColumn(0) = .Item("ruta")
                End With
                dtSoportes.PrimaryKey = pkColumn
                Dim dr As DataRow = dtSoportes.NewRow()
                dr("ruta") = ruta
                dr("nombre") = hdfIdRadicado.Value & "_" & nombre
                dr("tipoDocumento") = tipoImagen
                dtSoportes.Rows.Add(dr)
                Session("dtSoportes") = dtSoportes
                gvSoporte.DataSource = dtSoportes
                gvSoporte.DataBind()
                img = gvSoporte.Rows(0).FindControl("imgImagenSubida")
                img.ImageUrl = "data:image/png;base64," & base64String
            Else
                Dim drAux As DataRow
                dtSoportes = Session("dtSoportes")
                drAux = dtSoportes.Rows.Find(ruta)
                If drAux IsNot Nothing Then
                    'epPrincipal.showError(" Ya existe un soporte con el mismo nombre")
                Else



                    Dim dr As DataRow = dtSoportes.NewRow()
                    dr("ruta") = ruta
                    dr("nombre") = hdfIdRadicado.Value & "_" & nombre
                    dr("tipoDocumento") = tipoImagen
                    dtSoportes.Rows.Add(dr)
                    Session("dtSoportes") = dtSoportes
                    gvSoporte.DataSource = dtSoportes
                    gvSoporte.DataBind()

                    Dim tmp As Integer = 0
                    For Each dr1 As DataRow In dtSoportes.Rows
                        img = gvSoporte.Rows(tmp).FindControl("imgImagenSubida")
                        With objDocumentos
                            .NombreDocumento = dtSoportes.Rows(tmp)(0).ToString().Split("_")(1)
                            dtDocum = objDocumentos.ConsultaDocumentosMC()
                            img.ImageUrl = dtDocum.Rows(0)(3).ToString()
                            tmp += +1
                        End With
                    Next
                End If

            End If
            gvSoporte.Visible = True
            miEncabezado.showSuccess("El soporte se adiciono de forma correcta: " & "<br><br>")
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        Catch ex As Exception
            'epPrincipal.showError("Error al adicionar el soporte. " & ex.Message & "<br><br>")
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml

        End Try

    End Sub

    Private Function LimpiarSesionImagenes() As String
        Session("dtSoportes") = Nothing
        Return String.Empty
    End Function

    Private Function VerificarCambiarRadicado(ByVal Radicado As Integer) As String

        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso
        Dim dtInfRadicado As New DataTable()
        Dim msjRecibido As String = String.Empty

        With objDocumentos
            .IdRadicado = Radicado
            .IdEstado = Enumerados.EstadoServicio.VerificacionMesaControl
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .ActualizarCambiarEstadoRadicado()
            msjRecibido = resultado.Mensaje
        End With

        If (resultado.Valor = 0) Then
            With objDocumentos
                .ConsultaInfRad = True
                resultado = .ActualizarCambiarEstadoRadicado()
                dtInfRadicado = .DtInformacionRadicado

                Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
                Dim rows As New List(Of Dictionary(Of String, Object))()
                Dim row As Dictionary(Of String, Object)
                For Each dr As DataRow In dtInfRadicado.Rows
                    row = New Dictionary(Of String, Object)()
                    For Each col As DataColumn In dtInfRadicado.Columns
                        row.Add(col.ColumnName, dr(col))
                    Next
                    rows.Add(row)
                Next
                resultado.Mensaje = msjRecibido & "|" & serializer.Serialize(rows)
            End With
        End If

        Return "-5|" & resultado.Mensaje

    End Function

    Private Function ConsultaCausalesDevolucion(ByVal Origen As Integer) As String
        Dim objVenta As New GenerarPoolServicioMensajeria
        Dim dtCausales As New DataTable
        Dim filtroBusqueda As String

        Try
            dtCausales = objVenta.ConsultaCausalesDevolucion(Origen)

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()
            Dim row As Dictionary(Of String, Object)
            For Each dr As DataRow In dtCausales.Rows
                row = New Dictionary(Of String, Object)()
                For Each col As DataColumn In dtCausales.Columns
                    row.Add(col.ColumnName, dr(col))
                Next
                rows.Add(row)
            Next
            Return Origen & "|" & serializer.Serialize(rows)
        Catch ex As Exception
            Return ex.ToString()
        End Try
    End Function

    Private Function GenerarPlanillaRadicacion(ByVal precinto As String, ByVal DetallePlanilla As String) As String

        Dim objPlanilla As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso
        Dim cuerpo() As String = DetallePlanilla.Replace("""", String.Empty).Replace("[", String.Empty).Replace("]", String.Empty).Split(",")
        HerramientasFuncionales.CargarLicenciaGembox()
        Dim miWs As ExcelWorksheet
        Dim contexto As HttpContext = HttpContext.Current
        Dim fullPath As String
        fullPath = contexto.Server.MapPath("~/MensajeriaEspecializada/Plantillas/")
        Dim miExcel As New ExcelFile
        miExcel.LoadXlsx(fullPath & "PlanillaOrdenRadiacionBanco.xlsx", XlsxOptions.None)
        Dim templateSheet As ExcelWorksheet = miExcel.Worksheets(0)
        Dim _rutaArchivo As String
        Dim nombreFinalPlanilla As String = "PlanillaRadicacionDocumentos-" & System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") & ".xlsx"
        nombreFinalPlanilla = nombreFinalPlanilla.Replace("/", String.Empty).Replace(":", String.Empty)

        miWs = miExcel.Worksheets(0)


        With objPlanilla
            Dim fila As Integer = 12
            Dim control As Integer = 1
            Dim radicacion As String = String.Empty
            Dim novedades As String = String.Empty
            Dim generic As String

            'Inserta el encabezado de la planilla
            .IdClienteExterno = Enumerados.ClienteExterno.DAVIVIENDA
            .Precinto = precinto
            .IdCiudad = Integer.Parse(Session("usxp007"))
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .GenerarPlanillaRadicacionBanco()
            .PlanillaGenerada = resultado.Valor
            .Pagare = resultado.Mensaje

            miWs.Cells("J6").Value = .PlanillaGenerada
            miWs.Cells("J7").Value = precinto
            miWs.Cells("J8").Value = .NombreCiudad
            generic = System.DateTime.Now.ToString("dd-MM-yyyy") & " " & .NombreCiudad
            miExcel.Worksheets(0).Name = generic

            'Inserta el cuerpo de la planilla
            For x As Integer = 0 To cuerpo.Length - 1
                Dim arrayPlanilla() As String = cuerpo(x).Split("|")

                .Identificaion = arrayPlanilla(1)
                .Campania = arrayPlanilla(4)
                .CodEstrategia = arrayPlanilla(3)
                '.Oficina = hdfOficina.Value
                .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
                .IdEstado = Enumerados.EstadoServicio.RadicadoBanco
                If (.ObservacionesDevolucionDocs Is Nothing) Then
                    .ObservacionesDevolucionDocs = arrayPlanilla(0)
                    .IdRadicado = arrayPlanilla(1)
                Else
                    .IdRadicado = arrayPlanilla(0)
                End If

                resultado = .GenerarPlanillaRadicacionBanco()

                If (.NumEvidencias > 0) Then
                    novedades = "X"
                Else
                    radicacion = "X"
                End If

                miWs.Cells("B" & fila).Value = control
                miWs.Cells("C" & fila).Value = System.DateTime.Now.ToString("dd/MM/yyyy")
                miWs.Cells("E" & fila).Value = "Aplica"
                miWs.Cells("F" & fila).Value = "No Aplica"
                miWs.Cells("G" & fila).Value = .Pagare
                If arrayPlanilla.Length = 10 Then
                    miWs.Cells("H" & fila).Value = arrayPlanilla(2)
                    miWs.Cells("I" & fila).Value = arrayPlanilla(5)
                    miWs.Cells("J" & fila).Value = arrayPlanilla(4)
                    miWs.Cells("D" & fila).Value = 12 ' siempre va 12
                    miWs.Cells("K" & fila).Value = 860 ' siempre es 860
                ElseIf arrayPlanilla.Length = 9 Then
                    miWs.Cells("H" & fila).Value = arrayPlanilla(1)
                    miWs.Cells("I" & fila).Value = arrayPlanilla(4)
                    miWs.Cells("J" & fila).Value = arrayPlanilla(3)
                    miWs.Cells("D" & fila).Value = 12 ' siempre va 12
                    miWs.Cells("K" & fila).Value = 860 ' siempre es 860
                End If

                miWs.Cells("L" & fila).Value = .CodOficinaCliente
                fila += +1
                control += +1
            Next
            miWs.Cells("C8").Value = radicacion
            miWs.Cells("C9").Value = novedades
        End With

        _rutaArchivo = contexto.Server.MapPath("~/MensajeriaEspecializada/TemporalPlanillaRadicacionBanco/") & nombreFinalPlanilla
        miExcel.SaveXlsx(_rutaArchivo)

        Return "-8|" & resultado.Mensaje & "_" & resultado.Valor & "_" & nombreFinalPlanilla
    End Function

    Private Function PasoDestruccionDocs(ByVal IdRadicado As Integer) As String
        Dim objDestruccion As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso

        With objDestruccion
            .IdRadicado = IdRadicado
            .ValidarPasoDestruccion = True
            resultado = .PasoDestruccionDoc()

        End With

        Return "-9|" & resultado.Mensaje & "_" & resultado.Valor

    End Function

    Private Function FinalizarCampania(ByVal IdRadicado As Integer) As String
        Dim objFinalizar As New GenerarPoolServicioMensajeria
        Dim dtFinalizar As New DataTable

        With objFinalizar
            .IdRadicado = IdRadicado
            .IdEstado = Enumerados.EstadoServicio.CampaniaFinalizada
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            dtFinalizar = .FinalizarCampania()
        End With

        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim rows As New List(Of Dictionary(Of String, Object))()
        Dim row As Dictionary(Of String, Object)
        For Each dr As DataRow In dtFinalizar.Rows
            row = New Dictionary(Of String, Object)()
            For Each col As DataColumn In dtFinalizar.Columns
                row.Add(col.ColumnName, dr(col))
            Next
            rows.Add(row)
        Next
        Return "-10|" & serializer.Serialize(rows)
    End Function

    Private Function VerNovedadesRadicado(ByVal IdRadicado As Integer) As String
        Dim objNovedades As New GenerarPoolServicioMensajeria
        Dim dsNov As New DataSet
        Dim dtEncabezado As New DataTable
        Dim dtCuerpo As New DataTable
        Dim serializado As String = String.Empty

        With objNovedades
            .IdRadicado = IdRadicado
            dsNov = .VerNovedadesRadicado()
        End With

        If (dsNov.Tables(0).Rows.Count > 0) Then
            dtEncabezado = dsNov.Tables(0)

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()
            Dim row As Dictionary(Of String, Object)
            For Each dr As DataRow In dtEncabezado.Rows
                row = New Dictionary(Of String, Object)()
                For Each col As DataColumn In dtEncabezado.Columns
                    row.Add(col.ColumnName, dr(col))
                Next
                rows.Add(row)
            Next

            serializado = serializer.Serialize(rows)
        End If

        If (dsNov.Tables(1).Rows.Count > 0) Then
            dtCuerpo = dsNov.Tables(1)

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()
            Dim row As Dictionary(Of String, Object)
            For Each dr As DataRow In dtCuerpo.Rows
                row = New Dictionary(Of String, Object)()
                For Each col As DataColumn In dtCuerpo.Columns
                    row.Add(col.ColumnName, dr(col))
                Next
                rows.Add(row)
            Next
            serializado += "|" & serializer.Serialize(rows)

        End If

        Return "-11|" & serializado
    End Function

    Private Function DevolverEstadoRecepcionRadicado(ByVal IdRadicado As Integer) As String
        Dim objDevolverEstado As New GenerarPoolServicioMensajeria
        Dim resultado As New ResultadoProceso

        With objDevolverEstado
            .IdRadicado = IdRadicado
            .IdEstado = Enumerados.EstadoServicio.Entregado
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .DevolverEstadoRecepcionRadicado()
        End With

        Return "-12|" & resultado.Mensaje
    End Function

End Class