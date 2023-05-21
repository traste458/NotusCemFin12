Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class CrearTrasladoInterno
    Inherits System.Web.UI.Page

    Private Shared IdTipoTraslado As Integer
    Private Shared ObjServicio As MensajeriaEspecializada.ServicioMensajeria

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            epPrincipal.clear()
            If Not Page.IsPostBack Then
                'Session("usxp001") = 1
                epPrincipal.setTitle("Creación de Traslado")
                If Not Page.Request.QueryString("idTipoTraslado") Is Nothing Then
                    Integer.TryParse(Page.Request.QueryString("idTipoTraslado").ToString(), CrearTrasladoInterno.IdTipoTraslado)
                Else
                    CrearTrasladoInterno.IdTipoTraslado = 1
                End If

                CargaInicial()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar la pagina. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnAdicionar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAdicionar.Click
        Dim numeroRadicado As Long
        Try
            Long.TryParse(txtNoRadicado.Text, numeroRadicado)
            If ValidarServicio(numeroRadicado) Then
                ObjServicio = New MensajeriaEspecializada.ServicioMensajeria(numeroRadicado)
                txtNoRadicado.Enabled = False
                btnAdicionar.Visible = False
                pnlLecturaSeriales.Visible = True
            Else
                txtNoRadicado.Enabled = True
                btnAdicionar.Visible = True
                pnlLecturaSeriales.Visible = False
            End If

        Catch ex As Exception
            epPrincipal.showError("Error al adicionar el radicado." & ex.Message)
        End Try
    End Sub


    Protected Sub btnAdicionarSerial_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAdicionarSerial.Click
        Dim serial As String
        Try
            serial = txtSerial.Text
            If ValidarSerial(serial) Then
                Dim objSerial As New DetalleTraslado.SerialBodegaSatelite()
                objSerial = DetalleTraslado.ObtenerInfoSerialBodegaSatelite(serial)
                AgregarSerial(objSerial)
                CargarDetalle()
                txtSerial.Text = ""
                txtSerial.Focus()
                epPrincipal.showSuccess("El serial fue adicionado correctamente.")
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al adicionar el serial. " & ex.Message)
        End Try
    End Sub

    Protected Sub gvSeriales_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSeriales.RowCommand
        Try
            Dim serial As String
            serial = e.CommandArgument.ToString()
            If e.CommandName = "Eliminar" Then
                EliminarSerial(serial)
                CargarDetalle()
                epPrincipal.showSuccess("El serial fue eliminado correctamente.")
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al realizar la operación. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelarTraslado_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelarTraslado.Click
        Try
            LimpiarForma()
            epPrincipal.showSuccess("El traslado fue cancelado.")
        Catch ex As Exception
            epPrincipal.showError("Error al cancelar el traslado. " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCerrar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCerrar.Click
        Try
            VerificarMateriales()
            Dim dtError As DataTable = EstructuraErrores()
            If dtError.Rows.Count > 0 Then
                epPrincipal.showWarning("Error al cerrar el traslado por favor verifique el detalle de errores.")
                gvErrores.DataSource = dtError
                gvErrores.DataBind()
                pnlErrores.Visible = True
            Else
                pnlErrores.Visible = False
                Dim dtDetalle As DataTable = EstructuraDetalle()
                Dim detalleTrasladoLista As New DetalleTrasladoColeccion()
                Dim objDetalle As DetalleTraslado
                For index As Integer = 0 To dtDetalle.Rows.Count - 1
                    objDetalle = New DetalleTraslado()
                    With objDetalle
                        .Serial = dtDetalle.Rows(index)("serial").ToString()
                    End With
                    detalleTrasladoLista.Adicionar(objDetalle)
                Next

                Dim objTraslado As New Traslado()
                Dim objServicio As New ServicioMensajeria(CLng(txtNoRadicado.Text))
                objTraslado.IdServicio = objServicio.IdServicioMensajeria
                objTraslado.NumeroRadicado = objServicio.NumeroRadicado
                Integer.TryParse(Session("usxp001").ToString(), objTraslado.IdUsuario)
                objTraslado.IdTipoTraslado = CrearTrasladoInterno.IdTipoTraslado
                objTraslado.Crear(detalleTrasladoLista)
                LimpiarForma()
                epPrincipal.showSuccess("Traslado No. " & objTraslado.IdTraslado.ToString() & " creado correctamente.")
            End If

        Catch ex As Exception
            epPrincipal.showError("Error al confirmar el traslado. " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Metodos"

    Private Sub CargaInicial()
        Try
            txtNoRadicado.Attributes.Add("onKeyPress", "doClick('" + btnAdicionar.ClientID + "',event)")
            txtSerial.Attributes.Add("onKeyPress", "doClick('" + btnAdicionarSerial.ClientID + "',event)")
        Catch ex As Exception
            Throw New Exception("Error al cargar datos. " & ex.Message)
        End Try
    End Sub

    Private Function ValidarServicio(ByVal numeroRadicado As Long) As Boolean
        Dim retorno As Boolean = True
        Try
            Dim trasladoObj As New Traslado(numeroRadicado)
            Dim servicioObj As New ServicioMensajeria(numeroRadicado)
            If servicioObj.IdServicioMensajeria > 0 Then
                If servicioObj.IdEstado = 104 Then
                    epPrincipal.showWarning("El numero radicado " & numeroRadicado.ToString() & " no se encuentra cancelado.")
                    retorno = False
                ElseIf servicioObj.IdEstado <> 101 Then
                    epPrincipal.showWarning("El numero radicado " & numeroRadicado.ToString() & " no se encuentra confirmado.")
                    retorno = False
                Else
                    If trasladoObj.IdServicio > 0 Then
                        epPrincipal.showWarning("El numero radicado No. " & numeroRadicado.ToString() & " ya se encuentra en un traslado.")
                        retorno = False
                    End If
                End If
            Else
                epPrincipal.showWarning("El numero radicado No. " & numeroRadicado.ToString() & " no existe.")
                retorno = False
            End If

        Catch ex As Exception
            Throw New Exception("Error al validar el servicio. " & ex.Message)
        End Try
        Return retorno
    End Function

    Private Function ValidarSerial(ByVal serial As String) As Boolean
        Dim serialRepetido As DataRow
        Dim retorno As Boolean = True
        Dim mensaje As String
        Dim objSerial As New DetalleTraslado.SerialBodegaSatelite()
        Dim cantidadAdicionada As Integer
        Dim dtDetalle As DataTable
        Try
            dtDetalle = EstructuraDetalle()
            serialRepetido = dtDetalle.Rows.Find(serial)
            If serialRepetido Is Nothing Then
                objSerial = DetalleTraslado.ObtenerInfoSerialBodegaSatelite(serial)
                If Not String.IsNullOrEmpty(objSerial.Serial) Then
                    cantidadAdicionada = CantidadAdicionadaDeMaterial(objSerial.Material)
                    If Not DetalleTraslado.ValidoSerial(CLng(txtNoRadicado.Text), serial, cantidadAdicionada, mensaje) Then
                        epPrincipal.showWarning("El serial no cumple con las condiciones. " & mensaje)
                        retorno = False
                    End If
                Else
                    epPrincipal.showWarning("El serial no existe en el inventario. " & mensaje)
                    retorno = False
                End If
            Else
                epPrincipal.showWarning("El serial ya se encuentra adicionado. ")
                retorno = False
            End If

        Catch ex As Exception
            Throw New Exception("Error al validar el servicio. " & ex.Message)
        End Try
        Return retorno
    End Function

    Private Function EstructuraDetalle() As DataTable
        Dim dtDetalleTraslado As DataTable
        Try
            If Not Session("dtDetalleTraslado") Is Nothing Then
                dtDetalleTraslado = CType(Session("dtDetalleTraslado"), DataTable)
            Else
                dtDetalleTraslado = New DataTable("DetalleTraslado")
                Dim dcSerial As New DataColumn("serial")
                dcSerial.Caption = "serial"
                dcSerial.DataType = GetType(String)                
                dcSerial.AllowDBNull = False
                dtDetalleTraslado.Columns.Add(dcSerial)
                dtDetalleTraslado.PrimaryKey = New DataColumn() {dcSerial}
                Dim dcMaterial As New DataColumn("material")
                dcMaterial.Caption = "material"
                dcMaterial.DataType = GetType(String)
                dcMaterial.AllowDBNull = False
                dtDetalleTraslado.Columns.Add(dcMaterial)
                Dim dcIdSubproducto As New DataColumn("idSubproducto")
                dcIdSubproducto.Caption = "idSubproducto"
                dcIdSubproducto.DataType = GetType(Integer)
                dcIdSubproducto.AllowDBNull = False
                dtDetalleTraslado.Columns.Add(dcIdSubproducto)
                Session("dtDetalleTraslado") = dtDetalleTraslado
            End If
        Catch ex As Exception
            Throw New Exception("Error al obtener la estructura del detalle. " & ex.Message)
        End Try
        Return dtDetalleTraslado
    End Function

    Private Sub AgregarSerial(ByVal serialObj As DetalleTraslado.SerialBodegaSatelite)
        Try
            If Not String.IsNullOrEmpty(serialObj.Serial) Then
                Dim dtDetalle As DataTable = EstructuraDetalle()
                Dim nuevaFila As DataRow
                nuevaFila = dtDetalle.NewRow()
                nuevaFila("serial") = serialObj.Serial
                nuevaFila("material") = serialObj.Material
                nuevaFila("idSubproducto") = serialObj.IdSubproducto
                dtDetalle.Rows.Add(nuevaFila)
            End If
        Catch ex As Exception
            Throw New Exception("Error al adicionar el serial. " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarSerial(ByVal serial As String)
        Try
            Dim dtDetalle As DataTable = EstructuraDetalle()
            dtDetalle.Rows.Find(serial).Delete()
        Catch ex As Exception
            Throw New Exception("Error al eliminar el serial. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarDetalle()
        Try
            Dim dtDetalle As DataTable = EstructuraDetalle()            
            gvSeriales.DataSource = dtDetalle
            gvSeriales.DataBind()
            btnCerrar.Visible = CBool(dtDetalle.Rows.Count)
        Catch ex As Exception
            Throw New Exception("Error al cargar el detalle del traslado. " & ex.Message)
        End Try
    End Sub

    Private Function CantidadAdicionadaDeMaterial(ByVal material As String) As Integer
        Try
            Dim dtDetalle As DataTable = EstructuraDetalle()
            Dim cantidadAdicionada As Integer
            Integer.TryParse(dtDetalle.Compute("COUNT(serial)", "material=" & material).ToString(), cantidadAdicionada)
            Return cantidadAdicionada
        Catch ex As Exception
            Throw New Exception("Error al calcular la cantidad adicionada. " & ex.Message)
        End Try
    End Function

    Private Sub VerificarMateriales()
        Try
            LimpiarDtErrores()
            Dim dtDetalle As DataTable = EstructuraDetalle()
            Dim dtReferencias As DataTable
            Dim cantidadAdicionada As Integer

            If Not ObjServicio Is Nothing Then
                With ObjServicio
                    If .ReferenciasColeccion IsNot Nothing AndAlso .ReferenciasColeccion.Count > 0 Then
                        dtReferencias = .ReferenciasColeccion.GenerarDataTable()

                        Dim pkMaterial() As DataColumn = {dtReferencias.Columns("material")}
                        dtReferencias.PrimaryKey = pkMaterial
                    End If
                End With
                For Each detalleMaterial As DetalleMaterialServicioMensajeria In ObjServicio.ReferenciasColeccion
                    Integer.TryParse(dtDetalle.Compute("COUNT(serial)", "material=" & detalleMaterial.Material).ToString(), cantidadAdicionada)
                    If cantidadAdicionada <> detalleMaterial.Cantidad Then InsertarError("El material " + detalleMaterial.Material + " no esta completo. Se han cargado " + cantidadAdicionada.ToString() + " seriales y deben ser " + detalleMaterial.Cantidad.ToString())
                Next

            End If

        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

    Private Sub LimpiarDetalle()
        Try
            Dim dtDetalle As DataTable = EstructuraDetalle()
            dtDetalle.Rows.Clear()
        Catch ex As Exception
            Throw New Exception("Error al limpiar el detalle. " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarForma()
        LimpiarDetalle()
        CargarDetalle()
        txtNoRadicado.Text = ""
        txtNoRadicado.Enabled = True
        pnlLecturaSeriales.Visible = False
        btnAdicionar.Visible = True
    End Sub

    Private Function EstructuraErrores() As DataTable
        Dim dt As New DataTable("Errores")
        Try
            If (Session("dtErrores") Is Nothing) Then                
                Dim descripcion As New DataColumn()
                With descripcion
                    .AllowDBNull = False
                    .DataType = GetType(String)
                    .Caption = "Descripcion"
                    .ColumnName = "descripcion"
                End With
                dt.Columns.Add(descripcion)
                Session("dtErrores") = dt
            Else
                dt = CType(Session("dtErrores"), DataTable)
            End If
        Catch ex As Exception
            Throw New Exception("Error al crear la estructura de errores. " & ex.Message)
        End Try
        Return dt
    End Function

    Private Sub LimpiarDtErrores()
        Try
            Dim dt As New DataTable
            dt = EstructuraErrores()
            dt.Rows.Clear()
        Catch ex As Exception
            Throw New Exception("Error al limpiar la tabla de errores. " & ex.Message)
        End Try
    End Sub

    Private Sub InsertarError(ByVal descripcion As String)
        Try
            Dim dt As DataTable
            dt = EstructuraErrores()
            If (Not dt Is Nothing) Then
                Dim nuevaFila As DataRow
                nuevaFila = dt.NewRow()
                nuevaFila("descripcion") = descripcion
                dt.Rows.Add(nuevaFila)
            End If
        Catch ex As Exception
            Throw New Exception("Error al ingresar el error. " & ex.Message)
        End Try
    End Sub


#End Region

End Class