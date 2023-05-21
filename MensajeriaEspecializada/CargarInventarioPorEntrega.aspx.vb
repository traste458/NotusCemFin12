Imports System.IO
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Localizacion
Imports System.Collections.Generic
Imports ILSBusinessLayer.MensajeriaEspecializada

Partial Public Class CargarInventarioPorEntrega
    Inherits System.Web.UI.Page

#Region "Atributos (Campos)"

    Private _idBodega As Integer
    Private _idUsuario As Integer
    Private _idDespacho As Integer

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epNotificacion.clear()
        If Not IsPostBack Then
            With epNotificacion
                .setTitle("Cargar seriales al inventario CEM por número de entrega")
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
            End With
            pnlErrores.Visible = False
            pnlResultados.Visible = False
        End If
        _idUsuario = CInt(Session("usxp001"))
    End Sub

    Protected Sub lbQuitarFiltros_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbQuitarFiltros.Click
        LimpiarFiltros()
    End Sub

    Protected Sub lblBuscar_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbBuscar.Click
        Dim dtDatos As New DataTable
        Dim valida As New CargarInventarioCEM
        Dim resultado As New List(Of ResultadoProceso)
        Try
            With valida
                .NumeroEntrega = txtNumeroEntrega.Text.Trim
            End With
            resultado = valida.RemisionCargada
            If resultado.Count = 0 Then
                dtDatos = BuscarSeriales()
                If dtDatos IsNot Nothing AndAlso dtDatos.Rows.Count > 0 Then
                    EnlazarDatos(dtDatos)
                Else
                    epNotificacion.showWarning("<i>No se encontraron datos según los criterios de búsqueda establecidos</i>")
                    pnlResultados.Visible = False
                End If
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    mensajeRespuesta = mensaje.Mensaje
                Next
                epNotificacion.showWarning(mensajeRespuesta)
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de validar el número de entrega. " & ex.Message)
        End Try
    End Sub

    Protected Sub lbCargar_Clic(ByVal sender As Object, ByVal e As EventArgs) Handles lbCargar.Click
        CargarInventario()
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub LimpiarFiltros()
        txtNumeroEntrega.Text = ""
        txtNumeroEntrega.Enabled = True
        pnlResultados.Visible = False
        lbCargar.Visible = False
        pnlResultados.Visible = False
        pnlErrores.Visible = False
        lbBuscar.Enabled = True
        lbCargar.Enabled = True
    End Sub

    Private Function BuscarSeriales() As DataTable
        Dim dtDatos As New DataTable
        Dim datos As New CargarInventarioCEM
        Try
            With datos
                .NumeroEntrega = txtNumeroEntrega.Text.Trim
            End With
            dtDatos = datos.CargarDatos
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de obtener el listado de seriales. " & ex.Message)
        End Try
        Return dtDatos
    End Function

    Private Sub EnlazarDatos(ByVal dtDatos As DataTable)
        Try
            pnlResultados.Visible = True
            lbCargar.Visible = True
            txtNumeroEntrega.Enabled = False
            With gvDatos
                .DataSource = dtDatos
                .Columns(0).FooterText = dtDatos.Rows.Count.ToString & " Registro(s) Encontrado(s)"
                .DataBind()
            End With
            Integer.TryParse(dtDatos.Rows(0).Item(4).ToString, _idBodega)
            Integer.TryParse(dtDatos.Rows(0).Item(5).ToString, _idDespacho)
            Session("dtSeriales") = dtDatos
            Session("idBodega") = _idBodega
            Session("iDespacho") = _idDespacho
            MetodosComunes.mergeGridViewFooter(gvDatos)
        Catch ex As Exception
            Throw New Exception("Error al tratar de enlazar datos. " & ex.Message)
        End Try
    End Sub

    Private Sub CargarInventario()
        Try
            Dim resultado As New List(Of ResultadoProceso)
            Dim cargar As New CargarInventarioCEM
            Dim dtLog As New DataTable()
            dtLog.Columns.Add("Diferencias Encontradas", Type.GetType("System.String"))
            With cargar
                .NumeroEntrega = txtNumeroEntrega.Text.Trim
                .IdUsuario = _idUsuario
                .IdBodega = CInt(Session("idBodega"))
                .idDespacho = CInt(Session("iDespacho"))
            End With
            resultado = cargar.CargarInventario
            If resultado.Count = 0 Then
                epNotificacion.showSuccess("Se realizo el cargue del inventario satifactoriamente. ")
                LimpiarFiltros()
            Else
                Dim mensajeRespuesta As String
                For Each mensaje As ResultadoProceso In resultado
                    Dim filaLog As DataRow = dtLog.NewRow()
                    filaLog(0) = mensaje.Mensaje
                    dtLog.Rows.Add(filaLog)
                Next
                epNotificacion.showWarning("Se presentaron diferencias al realizar el cargue del inventario, por favor verifique el Log de resultados")
                dtLog.AcceptChanges()
                gvErrores.DataSource = dtLog
                gvErrores.DataBind()
                pnlErrores.Visible = True
                lbBuscar.Enabled = False
                lbCargar.Enabled = False
            End If
        Catch ex As Exception
            epNotificacion.showError("Error al tratar de cargar el inventario. " & ex.Message)
        End Try
    End Sub

#End Region

End Class