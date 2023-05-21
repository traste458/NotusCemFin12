Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports ILSBusinessLayer.Enumerados
Imports System.Collections.Generic
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class LegalizarServicio
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _dtEstado As New DataTable
    Private _idUsuario As Integer
    Private _bCerrar As Boolean

#End Region

#Region "Propiedades"

    Public Property BCerrar As Boolean
        Get
            Return _bCerrar
        End Get
        Set(value As Boolean)
            _bCerrar = True
            Session("bCerrar") = _bCerrar
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epLegalizacionServicio.clear()
        If Not IsPostBack Then
            With epLegalizacionServicio
                .setTitle("Legalización de Servicios")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            CargarNovedad()
            txtNumeroRadicado.Focus()
            If Not String.IsNullOrEmpty(txtNumeroRadicado.Text) Then CargarDetalleRadicado()
            pnlResultados.Visible = False
            pnlErrores.Visible = False
            Session.Remove("bCerrar")
        Else
            If Session("dtEstado") IsNot Nothing Then _dtEstado = CType(Session("dtEstado"), DataTable)
            If Session("bCerrar") IsNot Nothing Then _bCerrar = CType(Session("bCerrar"), Boolean)
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub lbQuitarFiltros_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Protected Sub lbBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Buscar()
    End Sub

    Private Sub gvDatos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDatos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.HasControls() Then
                Dim idTipoProducto As Integer = CInt(CType(e.Row.DataItem, DataRowView).Item("IdTipoProducto"))
                Dim tbAux As TextBox = CType(e.Row.FindControl("txtNuevoMSISDN"), TextBox)
                Dim tbPlanilla As TextBox = CType(e.Row.FindControl("txtPlanilla"), TextBox)

                Dim bLegalizado As Boolean
                Dim bLegalizadoCliente As Boolean

                Dim fechaLegalizacion As Date
                tbAux.Enabled = IIf(idTipoProducto = 2, True, False)

                If Not IsDBNull(CType(e.Row.DataItem, DataRowView).Item("fechaLegalizacion")) Then _
                    fechaLegalizacion = CDate(CType(e.Row.DataItem, DataRowView).Item("fechaLegalizacion"))

                bLegalizado = IIf(fechaLegalizacion <= Date.MinValue, False, True)
                bLegalizadoCliente = CBool(CType(e.Row.DataItem, DataRowView).Item("legalizaCliente"))

                Dim chkSeleccion As CheckBox = CType(e.Row.FindControl("chkSeleccion"), CheckBox)
                With chkSeleccion
                    .Enabled = Not (bLegalizado Or bLegalizadoCliente)
                    .Checked = bLegalizado
                End With

                Dim chkLegalizaComcel As CheckBox = CType(e.Row.FindControl("chkLegalizaComcel"), CheckBox)
                With chkLegalizaComcel
                    .Enabled = Not (bLegalizado Or bLegalizadoCliente)
                    .Checked = bLegalizadoCliente
                End With

                Dim numPlanilla As String
                numPlanilla = CType(e.Row.DataItem, DataRowView).Item("planillaLegalizacion").ToString()
                tbPlanilla.Text = numPlanilla
                tbPlanilla.Enabled = Not (bLegalizado Or bLegalizadoCliente)

                Dim idNovedad As Integer
                Integer.TryParse(CType(e.Row.DataItem, DataRowView).Item("idNovedadLegalizacion"), idNovedad)
                Dim ddlNovedad As DropDownList = CType(e.Row.FindControl("ddlNovedad"), DropDownList)
                With ddlNovedad
                    .DataSource = _dtEstado
                    .DataTextField = "descripcion"
                    .DataValueField = "idTipoNovedad"
                    .DataBind()
                    If .Items.Count <> 1 Then .Items.Insert(0, New ListItem("Seleccione Tipo Novedad...", "0"))
                    If idNovedad > 0 Then ddlNovedad.SelectedValue = idNovedad
                    ddlNovedad.Enabled = Not (bLegalizado Or bLegalizadoCliente)
                End With

                Dim lblEstado As Label = CType(e.Row.FindControl("lblEstado"), Label)
                lblEstado.Text = If((bLegalizado Or bLegalizadoCliente), "SI", "NO")
            End If
        End If
    End Sub
    Protected Sub lbGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lbGuardar.Click
        RegistrarLegalizacion()
        CargarDetalleRadicado()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargarNovedad()
        Try
            _dtEstado = HerramientasMensajeria.ObtenerTiposDeNovedad(idProceso:=Enumerados.ProcesoMensajeria.Legalización)
            Session("dtEstado") = _dtEstado
        Catch ex As Exception
            epLegalizacionServicio.showError("Error al tratar de obtener el listado de Tipos de Novedad. " & ex.Message)
        End Try
    End Sub

    Private Function BuscarDuplas() As DataTable
        Dim dtDatos As New DataTable
        Dim datos As New LegalizarServicioCEM
        Try
            With datos
                .NumeroRadicado = txtNumeroRadicado.Text.Trim
            End With
            dtDatos = datos.BuscarDupla
        Catch ex As Exception
            epLegalizacionServicio.showError("Error al tratar de obtener el listado de seriales. " & ex.Message)
        End Try
        Return dtDatos
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable, Optional ByVal muestraMSISDN As Boolean = True)
        Try
            pnlResultados.Visible = True
            txtNumeroRadicado.Enabled = False
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
                If muestraMSISDN Then
                    .Columns(7).Visible = True
                Else
                    .Columns(7).Visible = False
                End If
            End With
            Session("dtLegalizarServicios") = dtDatos
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFiltros()
        Session.Remove("infoServicio")
        txtNumeroRadicado.Text = ""
        txtNumeroRadicado.Enabled = True
        cusSeleccion.Enabled = True
        pnlResultados.Visible = False
        'btnBuscar.Visible = False
        pnlResultados.Visible = False
        pnlErrores.Visible = False
        lbBuscar.Enabled = True
    End Sub

    Private Sub RegistrarLegalizacion()
        Dim dtLog As New DataTable()
        Dim dtReslt As New DataTable()
        dtLog.Columns.Add("Diferencias Encontradas", Type.GetType("System.String"))
        dtReslt.Columns.Add("Seriales Legalizados", Type.GetType("System.String"))

        Dim dtServiciosLegalizar As DataTable = LegalizarServicioCEM.CrearEstructuraDeTabla()
        Dim resultado As New List(Of ResultadoProceso)

        Try
            For Each fila As GridViewRow In gvDatos.Rows
                Dim check As CheckBox = fila.FindControl("chkSeleccion")
                Dim checkCliente As CheckBox = fila.FindControl("chkLegalizaComcel")


                If (check.Checked Or checkCliente.Checked) And (check.Enabled Or checkCliente.Enabled) Then
                    Dim filaLegalizacion As DataRow = dtServiciosLegalizar.NewRow()
                    With filaLegalizacion
                        .Item("IdDetalle") = CInt(fila.Cells(0).Text)
                        .Item("IdUsuarioLegaliza") = _idUsuario
                        .Item("NuevoMsisdn") = CType(fila.FindControl("txtNuevoMSISDN"), TextBox).Text
                        .Item("IdTipoNovedad") = CType(fila.FindControl("ddlNovedad"), DropDownList).SelectedValue
                        .Item("PlanillaLegalizacion") = CType(fila.FindControl("txtPlanilla"), TextBox).Text
                        .Item("ClienteLegaliza") = CType(fila.FindControl("chkLegalizaComcel"), CheckBox).Checked
                    End With
                    dtServiciosLegalizar.Rows.Add(filaLegalizacion)
                    dtServiciosLegalizar.AcceptChanges()

                    'Dim detalleLegalizacion As New LegalizarServicioCEM()
                    'With detalleLegalizacion
                    '    .IdDetalle = CInt(fila.Cells(0).Text)
                    '    .IdUsuarioLegaliza = _idUsuario
                    '    .NuevoMsisdn = CType(fila.FindControl("txtNuevoMSISDN"), TextBox).Text
                    '    .IdTipoNovedad = CType(fila.FindControl("ddlNovedad"), DropDownList).SelectedValue
                    '    .PlanillaLegalizacion = CType(fila.FindControl("txtPlanilla"), TextBox).Text
                    '    .ClienteLegaliza = IIf(CType(fila.FindControl("chkLegalizaComcel"), CheckBox).Checked, Enumerados.EstadoBinario.Activo, Enumerados.EstadoBinario.Inactivo)
                    '    resultado = detalleLegalizacion.RegistrarLegalizacion()
                    'End With

                    'If resultado.Count = 0 Then
                    '    Dim mensajeResultado As String
                    '    Dim filaReslt As DataRow = dtReslt.NewRow()
                    '    mensajeResultado = fila.Cells(2).Text
                    '    filaReslt(0) = ("El serial: " & mensajeResultado & " fue legalizado")
                    '    dtReslt.Rows.Add(filaReslt)
                    '    dtReslt.AcceptChanges()
                    '    check.Checked = False
                    '    check.Enabled = False
                    '    fila.FindControl("txtNuevoMSISDN").Visible = False
                    '    fila.FindControl("ddlNovedad").Visible = False
                    '    CType(fila.FindControl("lblEstado"), Label).Text = "SI"
                    '    epLegalizacionServicio.showSuccess("Transacción Exitosa")
                    'Else
                    '    Dim mensajeRespuesta As String
                    '    For Each mensaje As ResultadoProceso In resultado
                    '        Dim filaLog As DataRow = dtLog.NewRow()
                    '        filaLog(0) = mensaje.Mensaje
                    '        dtLog.Rows.Add(filaLog)
                    '    Next
                    '    epLegalizacionServicio.showWarning("Se encontraron novedades en la legalización, por favor revisar resultados del Log.")
                    '    dtLog.AcceptChanges()
                    '    gvErrores.DataSource = dtLog
                    '    gvErrores.DataBind()
                    'End If
                End If
            Next

            Dim detalleLegalizacion As New LegalizarServicioCEM()
            resultado = detalleLegalizacion.RegistrarLegalizacion(dtServiciosLegalizar)

            For Each mensaje As ResultadoProceso In resultado
                If mensaje.Valor = 0 Then
                    Dim filaReslt As DataRow = dtReslt.NewRow()
                    filaReslt(0) = mensaje.Mensaje
                    dtReslt.Rows.Add(filaReslt)
                Else
                    Dim filaLog As DataRow = dtLog.NewRow()
                    filaLog(0) = mensaje.Mensaje
                    dtLog.Rows.Add(filaLog)
                End If
            Next
            dtReslt.AcceptChanges()
            gvLegaliza.DataSource = dtReslt
            gvLegaliza.DataBind()
            dtLog.AcceptChanges()
            gvErrores.DataSource = dtLog
            gvErrores.DataBind()
            pnlErrores.Visible = True

            Buscar()
        Catch ex As Exception
            epLegalizacionServicio.showError("Error al tratar de legalizar los Msisdn " & ex.Message)
        End Try
    End Sub

    Private Sub CierreRadicado(Optional ByVal numeroContrato As Long = 0)
        Dim resultado As New List(Of ResultadoProceso)
        Dim objServicioLegalizacion As New LegalizarServicioCEM
        Dim idUsuario As Integer
        Try
            Integer.TryParse(Session("usxp001"), idUsuario)
            With objServicioLegalizacion
                If rblTipoServicio.Items(1).Selected Then 'Venta 
                    .IdServicio = txtNumeroRadicado.Text.Trim
                Else
                    .NumeroRadicado = txtNumeroRadicado.Text.Trim
                End If

                If numeroContrato > 0 Then .NumeroContrato = numeroContrato
                .IdUsuarioLegaliza = idUsuario
            End With

            resultado = objServicioLegalizacion.CerrarRadicado
            If resultado.Count <> 0 Then
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    mensajeRespuesta = mensaje.Mensaje
                Next
                epLegalizacionServicio.showWarning(mensajeRespuesta)
            End If
        Catch ex As Exception
            epLegalizacionServicio.showError("Ocurrio un error al cerrar el radicado " & ex.Message)
        End Try
    End Sub

    Private Sub Buscar()
        Try
            pnlResultados.Visible = False
            Session.Remove("infoServicio")

            Dim infoServicio As ServicioMensajeria

            If rblTipoServicio.Items(1).Selected Then 'Venta
                infoServicio = New ServicioMensajeria(idServicio:=CLng(txtNumeroRadicado.Text))
            Else
                infoServicio = New ServicioMensajeria(numeroRadicado:=CLng(txtNumeroRadicado.Text))
            End If

            If infoServicio.Registrado Then
                If infoServicio.IdEstado = Enumerados.EstadoServicio.Entregado Then
                    Session("infoServicio") = infoServicio

                    Dim infoSerial As New DetalleSerialServicioMensajeriaColeccion(infoServicio.IdServicioMensajeria)
                    Dim dtDatos As DataTable = infoSerial.GenerarDataTable()

                    If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                        Dim dvDatos As DataView = dtDatos.DefaultView
                        dvDatos.RowFilter = "devuelto = 0"

                        If dvDatos.Count > 0 Then
                            EnlazarDatos(dvDatos.ToTable(), (Not infoServicio.IdTipoServicio = Enumerados.TipoServicio.Venta))
                            txtNumeroContrato.Text = infoServicio.NumeroRadicado
                            CargarDetalleRadicado()
                        Else
                            epLegalizacionServicio.showWarning("El servicio asociado no tiene seriales disponibles para legalizar, por favor verifique.")
                        End If
                    Else
                        epLegalizacionServicio.showWarning("<i>El servicio asociado al número de radicado proporcionado no tiene seriales, por favor verifique</i>")
                    End If
                    If dtDatos IsNot Nothing Then pnlResultados.Visible = dtDatos.Rows.Count
                ElseIf infoServicio.IdEstado = Enumerados.EstadoServicio.Legalizado Then
                    epLegalizacionServicio.showWarning("El número del radicado consultado, ya se encuentra legalizado")
                Else
                    epLegalizacionServicio.showWarning("El número del radicado no se encuentra entregado, por favor verifique el estado")
                End If
            Else
                epLegalizacionServicio.showWarning("El número del servicio no se encuentra registrado en el sistema")
            End If

        Catch ex As Exception
            epLegalizacionServicio.showError("Error al tratar de validar el número de radicado. " & ex.Message)
        End Try
    End Sub

    Private Function CargarDetalleRadicado()
        Dim respuesta As New List(Of ResultadoProceso)
        Dim objLegalizarServicio As New LegalizarServicioCEM

        Try
            With objLegalizarServicio
                If Not String.IsNullOrEmpty(txtNumeroRadicado.Text) Then
                    If rblTipoServicio.Items(1).Selected Then 'Venta 
                        .IdServicio = txtNumeroRadicado.Text.Trim
                    Else
                        .NumeroRadicado = txtNumeroRadicado.Text.Trim
                    End If
                End If
            End With
            respuesta = objLegalizarServicio.ValidarRadicado

            If respuesta.Count = 0 Then
                If DirectCast(Session("infoServicio"), ServicioMensajeria).IdTipoServicio = Enumerados.TipoServicio.Venta Then
                    'Se calcula si debe solicitar el número de contrato
                    pnlTipoServicioVenta.Visible = True
                    rfvtxtNumeroContrato.Enabled = True
                    cusSeleccion.Enabled = False

                    If Not String.IsNullOrEmpty(txtNumeroContrato.Text) And BCerrar Then
                        pnlResultados.Enabled = False
                        pnlErrores.Visible = False
                        lbGuardar.Enabled = False
                        lbBuscar.Enabled = False
                        CierreRadicado(CLng(txtNumeroContrato.Text))
                        epLegalizacionServicio.clear()
                        epLegalizacionServicio.showSuccess("Los seriales del radicado ya se encuentran legalizados en su totalidad, se realizo el cierre del radicado.")
                    End If
                    BCerrar = True
                Else
                    epLegalizacionServicio.showSuccess("Los seriales del radicado ya se encuentran legalizados en su totalidad, se realizo el cierre del radicado.")
                    pnlResultados.Enabled = False
                    pnlErrores.Visible = False
                    lbGuardar.Enabled = False
                    lbBuscar.Enabled = False
                    CierreRadicado()
                End If
            End If
        Catch ex As Exception
            epLegalizacionServicio.showError("Ocurrio un error al validar el radicado " & ex.Message)
        End Try
    End Function

#End Region

End Class