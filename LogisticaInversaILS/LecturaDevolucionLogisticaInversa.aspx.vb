Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.LogisticaInversa
Imports ILSBusinessLayer.Localizacion
Imports System.Collections.Generic

Partial Public Class LecturaDevolucionLogisticaInversa
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EncabezadoPagina1.clear()
        lblNotificacion.Text = ""
        Seguridad.verificarSession(Me)
        If Not IsPostBack Then
            'Session("usxp009") = "46"
            EncabezadoPagina1.setTitle("Lectura de Devolución")
            EncabezadoPagina1.showReturnLink("RecibirOrdenDevolucion.aspx")
            If Request.QueryString("idDevolucion") IsNot Nothing Then
                Me.CargaInicial(Request.QueryString("idDevolucion"))
            End If
        End If
    End Sub

#Region "Eventos"

    Protected Sub rdbClasificacion_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles rdbClasificacion.SelectedIndexChanged
        Me.CargarNovedades(rdbClasificacion.SelectedValue)
    End Sub

    Protected Sub lnkIniciarLectura_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkIniciarLectura.Click
        If rdbClasificacion.SelectedIndex >= 0 Then
            pnlLecturaSerial.Visible = True
            pnlTipoLectura.Visible = False
            Dim listaNovedades As List(Of Integer) = Me.ObtenerIDsNovedad()
            Session("listaNovedades") = listaNovedades
        Else
            EncabezadoPagina1.showWarning("Debe seleccionar el tipo de lectura para iniciar")
        End If
    End Sub

    Protected Sub btnLeerSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLeerSerial.Click
        If rdbClasificacion.SelectedIndex > 0 Then
            Me.RegistrarSerial(txtSerial.Text)
            Me.ValidarFinalizacion()
        Else
            Me.RegistrarRechazado(txtSerial.Text)
        End If
    End Sub

    Protected Sub btnEliminarSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEliminarSerial.Click
        If rdLecura.Checked Then
            Me.EliminarSerial(txtBorrarSerial.Text)
        Else
            Me.EliminarRechazado(txtBorrarSerial.Text)
        End If
        txtBorrarSerial.Text = ""
        txtBorrarSerial.Focus()
    End Sub

    Private Sub gvMateriales_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvMateriales.SelectedIndexChanged
        Me.CargarGridSeriales(gvMateriales.SelectedValue)
    End Sub

    Protected Sub lnkVerTodos_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkVerTodos.Click
        Me.CargarGridSeriales(0)
    End Sub

    Protected Sub lnkFinalizarLectura_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkFinalizarLectura.Click
        pnlLecturaSerial.Visible = False
        pnlTipoLectura.Visible = True
        txtSerial.Text = ""
        txtBorrarSerial.Text = ""
    End Sub

    Protected Sub lnkCerrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkCerrar.Click
        Dim ConfigValue As String = MetodosComunes.seleccionarConfigValue("PERFILES_CIERRE_ORDEN_DIFERENCIAS")
        Dim perfilesCierreDiferencias As New ArrayList(ConfigValue.Split(","))
        Dim idPerfil As Integer = Session("usxp009")

        Dim devolucion As New Devolucion(lblidDevolucion.Text)
        Dim dtProductos As DataTable = DevolucionDetalle.ObtenerDetalleDevolucion(devolucion.IdDevolucion)
        If dtProductos.Select("cantidad<>cantidad_leida").Length = 0 Then
            Try
                devolucion.IdEstado = 2
                devolucion.Actualizar()
                Me.GenerarActa()
                lnkCerrar.Enabled = False
                lnkAccesorios.Enabled = False
            Catch ex As Exception
                EncabezadoPagina1.showError("Error al tratar de cerrar la devolución")
            End Try
        ElseIf perfilesCierreDiferencias.Contains(idPerfil.ToString()) Then
            hfCerrar_ModalPopupExtender.Show()
        Else
            EncabezadoPagina1.showWarning("La orden no puede ser cerrada con diferencias")
        End If
    End Sub

    Protected Sub lnkCerrarObservacion_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkCerrarObservacion.Click
        Dim devolucion As New Devolucion(lblidDevolucion.Text)
        devolucion.Observacion = txtBorrarSerial.Text
        Try
            devolucion.IdEstado = 2
            devolucion.Observacion = txtObservacion.Text
            devolucion.Actualizar()
            Me.GenerarActa()
            Response.Redirect("RecibirOrdenDevolucion.aspx?ok=" & devolucion.IdDevolucion.ToString(), False)
        Catch ex As Exception
            EncabezadoPagina1.showError("Error al tratar de cerrar la devolución")
        End Try
    End Sub

    Protected Sub lnkDescargar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkDescargar.Click
        Dim dtLeidos As DataTable = DevolucionDetalleSerial.ObtenerSeriales(lblidDevolucion.Text, 0)
        dtLeidos.TableName = "Seriales Leídos Devolución"
        Me.PrepararDTExportar(dtLeidos)
        Dim dtRechazados As DataTable = DevolucionSerialRechazado.ObtenerListado(lblidDevolucion.Text)
        Me.PrepararDTExportar(dtRechazados)
        dtRechazados.TableName = "Seriales Rechazados"
        Dim ds As New DataSet("Lectura de Seriales Devolución")
        ds.Tables.Add(dtLeidos)
        ds.Tables.Add(dtRechazados)
        MetodosComunes.exportarDatosAExcelGemBox(HttpContext.Current, ds, "ReporteSerialesDevolucion.xls", Server.MapPath("../archivos_planos/ReporteSerialesDevolucion.xls"))
    End Sub

    Protected Sub lnkAccesorios_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkAccesorios.Click
        Response.Redirect("ConfirmarDevolucionAccesorios.aspx?idOrden=" & lblidRecoleccion.Text & "&idDevolucion=" & lblidDevolucion.Text)
    End Sub

#End Region

#Region "Metodos"

    Private Sub CargaInicial(ByVal idDevolucion As Integer)
        Dim objDevolucion As New Devolucion(idDevolucion)
        Dim recoleccion As OrdenRecoleccion
        With objDevolucion
            lblidDevolucion.Text = .IdDevolucion
            lblidRecoleccion.Text = .IdOrdenRecoleccion
            lblGuia.Text = .Guia
            recoleccion = New OrdenRecoleccion(.IdOrdenRecoleccion)
            lblOrigen.Text = recoleccion.Origen.Nombre
            Dim ciudad As New Ciudad(recoleccion.Origen.IdCiudad)
            lblCiudad.Text = ciudad.Nombre
            recoleccion.Accesorios.CargarListaAccesorios(.IdOrdenRecoleccion)
            lblFecha.Text = .Fecha.ToString()
            lblGrupoDev.Text = .GrupoDevolucion
        End With
        If recoleccion.Accesorios.ListaAccesorios.Rows.Count = 0 Then lnkAccesorios.Visible = False
        Dim dt As DataTable = LogisticaInversa.NovedadSerial.ObtenerClasificacionNovedades()
        MetodosComunes.CargarDropDown(dt, CType(rdbClasificacion, ListControl))
        rdbClasificacion.Items(0).Text = "RECHAZADOS"
        pnlLecturaSerial.Visible = False
        EstablecerLinkDescargaSeriales()
        Me.CargarGridDevolucionDetalle()
        Me.CargarRechazados()
        Dim regExLongitudSerial As String = MetodosComunes.seleccionarConfigValue("REGEX_LONGITUD_SERIALES")
        RegularExpressionValidatorSerial.ValidationExpression = regExLongitudSerial
    End Sub

    Private Sub CargarNovedades(ByVal idClasificacionNovedad As Integer)
        Dim dt As DataTable = NovedadSerial.ObtenerNovedadesTransporte(NovedadSerial.ProcesoNovedad.Devolucion, idClasificacionNovedad)
        MetodosComunes.CargarDropDown(dt, CType(chlbxNovedades, ListControl))
        chlbxNovedades.Items.RemoveAt(0)
    End Sub

    Private Sub CargarGridDevolucionDetalle()
        Dim dt As DataTable = DevolucionDetalle.ObtenerDetalleDevolucion(lblidDevolucion.Text)
        gvMateriales.DataSource = dt
        gvMateriales.DataBind()
        gvSeriales.DataBind()
    End Sub

    Private Sub CargarGridSeriales(ByVal idDetalle As Integer)
        Dim dt As DataTable = DevolucionDetalleSerial.ObtenerSeriales(lblidDevolucion.Text, idDetalle)
        gvSeriales.DataSource = dt
        gvSeriales.DataBind()
    End Sub

    Private Sub CargarRechazados()
        Dim dt As DataTable = DevolucionSerialRechazado.ObtenerListado(lblidDevolucion.Text)
        gvRechazados.DataSource = dt
        gvRechazados.DataBind()
    End Sub

    Private Sub RegistrarRechazado(ByVal serial As String)
        Dim serialRechazado As New DevolucionSerialRechazado
        With serialRechazado
            .Serial = txtSerial.Text
            .IdDevolucion = lblidDevolucion.Text

        End With
        Try
            serialRechazado.Registrar()
            Me.CargarRechazados()
            txtSerial.Text = ""
            txtSerial.Focus()
            lnkDescargar.Visible = True
        Catch ex As Exception
            If ex.Message = "1" Then
                EncabezadoPagina1.showWarning("El serial ya se encuentra leido como rechazado")
            ElseIf ex.Message = "2" Then
                EncabezadoPagina1.showWarning("El serial ya fue aceptado, debe eliminarlo de la devolución para para poder leerlo como rechazado")
            Else
                EncabezadoPagina1.showError("Error al tratar de registrar el serial como rechazado")
            End If
        End Try
    End Sub

    Private Sub RegistrarSerial(ByVal serial As String)
        Dim devolSerial As New DevolucionDetalleSerial
        With devolSerial
            .Serial = serial
            .IdDevolucion = lblidDevolucion.Text
            .IdClasificacion = rdbClasificacion.SelectedValue
        End With
        Try
            Dim listaNovedades As List(Of Integer) = Session("listaNovedades")
            devolSerial.Novedad.ListaCodigosNovedad = listaNovedades
            devolSerial.Registrar()
            EncabezadoPagina1.showSuccess("El serial " & serial & " se ha registrado correctamente")
            txtSerial.Text = ""
            txtSerial.Focus()
            Me.CargarGridDevolucionDetalle()
            lnkDescargar.Visible = True

        Catch ex As Exception
            If ex.Message = "1" Then
                EncabezadoPagina1.showWarning("El serial no se encuentra incluido en la recolección")
            ElseIf ex.Message = "2" Then
                EncabezadoPagina1.showWarning("El serial se encuentra rechazado y no se puede registrar")
            ElseIf ex.Message = "3" Then
                EncabezadoPagina1.showWarning("El serial ya fue leido en la devolución")
            Else
                EncabezadoPagina1.showError("Error al tratar de registrar el serial")
            End If
        End Try
    End Sub

    Private Sub EliminarSerial(ByVal serial As String)

        Dim devolSerial As New DevolucionDetalleSerial
        With devolSerial
            .Serial = serial
            .IdDevolucion = lblidDevolucion.Text
        End With
        Try
            devolSerial.Eliminar()
            Me.CargarGridDevolucionDetalle()
            Me.CargarGridSeriales(0)
            pnlLecturaSerial.Enabled = True
            lblNotificacion.CssClass = "ok"
            lblNotificacion.Text = "<ul><li>El serial se ha eliminado</li></ul>"
        Catch ex As Exception
            If ex.Message = "1" Then
                lblNotificacion.CssClass = "warning"
                lblNotificacion.Text = "<ul><li>El serial no se encuentra en la devolución</li></ul>"
            Else
                EncabezadoPagina1.showError("Error al tratar de eliminar el serial")
            End If
        End Try
    End Sub

    Private Sub EliminarRechazado(ByVal serial As String)
        Dim serialRechazado As New DevolucionSerialRechazado
        With serialRechazado
            .Serial = serial
            .IdDevolucion = lblidDevolucion.Text
        End With
        Try
            serialRechazado.Eliminar()
            Me.CargarRechazados()
        Catch ex As Exception
            EncabezadoPagina1.showError("Error al tratar de eliminar el serial")
        End Try
    End Sub

    Private Sub EstablecerLinkDescargaSeriales()
        Dim flagVisible As Boolean = False
        Dim dt As DataTable = DevolucionDetalleSerial.ObtenerSeriales(lblidDevolucion.Text, 0)
        If dt.Rows.Count > 0 Then flagVisible = True
        dt = DevolucionSerialRechazado.ObtenerListado(lblidDevolucion.Text)
        If dt.Rows.Count > 0 Then flagVisible = True
        lnkDescargar.Visible = flagVisible
    End Sub

    Private Sub PrepararDTExportar(ByRef dt As DataTable)
        dt.Columns("referencia").SetOrdinal(0)
        dt.Columns("serial").SetOrdinal(1)
        dt.Columns("fecha").SetOrdinal(2)
        dt.TableName = "Seriales Leídos Devolución"
        Dim numColumnas As Integer = dt.Columns.Count - 3
        Do Until dt.Columns.Count = 3
            dt.Columns.RemoveAt(dt.Columns.Count - 1)
        Loop
    End Sub

    Private Function ObtenerIDsNovedad() As List(Of Integer)
        Dim novedades As New List(Of Integer)
        For Each item As ListItem In chlbxNovedades.Items
            If item.Selected Then
                novedades.Add(item.Value)
            End If
        Next
        Return novedades
    End Function

    Private Sub GenerarActa()
        Dim acta As New ReporteCrystal("ActaDevolucionLogisticaInversa", Server.MapPath("../reports/"))
        acta.agregarParametroDiscreto("@idDevolucion", lblidDevolucion.Text)
        acta.agregarParametroDiscreto("@idRecoleccion", lblidRecoleccion.Text)
        Dim ruta As String = acta.exportar(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "Acta", "window.open ('../reports/rptTemp/" + Path.GetFileName(ruta) + "','Acta', 'status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1'); ", True)
    End Sub

    Private Function ValidarFinalizacion() As Boolean
        Dim cantidadLeida As Integer
        Dim cantidadLeer As Integer
        Dim dt As DataTable = DevolucionDetalleSerial.ObtenerSeriales(lblidDevolucion.Text, 0)
        cantidadLeida = dt.Rows.Count()
        dt = RecoleccionSerial.Consultar(lblidRecoleccion.Text)
        cantidadLeer = dt.Rows.Count()
        If cantidadLeida = cantidadLeer Then
            EncabezadoPagina1.showSuccess("La devolución ha sido leida en su totalidad")
            pnlLecturaSerial.Enabled = False
        Else
            pnlLecturaSerial.Enabled = True
        End If
    End Function
#End Region

End Class