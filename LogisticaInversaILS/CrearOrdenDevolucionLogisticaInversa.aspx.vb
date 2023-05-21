Imports ILSBusinessLayer
Imports ILSBusinessLayer.Estructuras
Partial Public Class CrearOrdenDevolucionLogisticaInversa
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            epPrincipal.clear()
            If Not Me.IsPostBack Then
                epPrincipal.setTitle("Crear Orden Devolución Logistica Inversa")
                Dim idRecoleccion As Integer
                With Request.QueryString
                    If .Item("idRecoleccion") IsNot Nothing Then Integer.TryParse(.Item("idRecoleccion"), idRecoleccion)
                    hfIdRecoleccion.Value = idRecoleccion.ToString
                End With
                If CInt(hfIdRecoleccion.Value) > 0 Then
                    CargarGrupoDevolucion()
                    CargarDatosRecoleccion()
                End If
       
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar la pagina por favor, intente nuevamente. " & ex.Message)
        End Try

    End Sub

    Private Sub CargarDatosRecoleccion()
        Try
            Dim RecoleccionObj As New LogisticaInversa.OrdenRecoleccion(CInt(hfIdRecoleccion.Value))
            With RecoleccionObj
                lblOrdenRecoleccion.Text = .IdOrden.ToString
                lblGuia.Text = .Guia
                lblTransportadora.Text = .Transportadora
                lblObservacion.Text = .Observacion
                lblOrigen.Text = .Origen.Nombre
            End With
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

    Private Sub CargarGrupoDevolucion()
        Try
            Dim filtro As New FiltroGrupoDevolucion
            Dim dtDatos As New DataTable()
            filtro.Estado = 1
            dtDatos = LogisticaInversa.GrupoDevolucion.ObtenerListado(filtro)
            CargarControl(ddlGrupoDevolucion, dtDatos, "idgrupo_devolucion2", "idgrupo_devolucion", True)
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

    Protected Sub lnkCrear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkCrear.Click

        If Request.QueryString("idDevolucion") IsNot Nothing Then
            Try
                Dim idDev As String = Request.QueryString("idDevolucion")
                Dim DevolucionObj As New LogisticaInversa.Devolucion(idDev)
                DevolucionObj.IdGrupoDevolucion = ddlGrupoDevolucion.SelectedValue
                DevolucionObj.Observacion = txtObservacion.Text
                DevolucionObj.Actualizar()
                lnkLeerDevolucion.Visible = True
                Session("devolucion") = DevolucionObj
            Catch ex As Exception
                epPrincipal.showError("error al tratar de obtener los datos de la orden")
            End Try

        Else
            Try

                Dim DevolucionObj As New LogisticaInversa.Devolucion()
                With DevolucionObj
                    .IdTercero = CLng(Session("usxp001"))
                    .IdEstado = 1
                    .IdOrdenRecoleccion = CInt(hfIdRecoleccion.Value)
                    .IdGrupoDevolucion = ddlGrupoDevolucion.SelectedValue
                    .Observacion = txtObservacion.Text
                    If .Crear() Then
                        ddlGrupoDevolucion.ClearSelection()
                        txtObservacion.Text = String.Empty
                        epPrincipal.showSuccess("Devolución No. " & .IdDevolucion.ToString() & " creada correctamente.")
                        lnkLeerDevolucion.Visible = True
                        Session("devolucion") = DevolucionObj
                    End If
                End With

            Catch ex As Exception
                If ex.Message = "1" Then
                    epPrincipal.showWarning("La ya existe una devolución para la Orden de recolección")
                Else
                    epPrincipal.showError("Error al crear la devolución. " & ex.Message)
                End If
                lnkLeerDevolucion.Visible = False
            End Try
        End If
    End Sub

    Public Sub CargarControl(ByRef control As Object, ByVal datos As DataTable, ByVal campoMuestra As String, ByVal campoValor As String, _
                              Optional ByVal muestraMensaje As Boolean = False, Optional ByVal primerMensaje As String = "Seleccione", Optional ByVal primerValor As Integer = 0)
        Try
            Dim newDt As New DataTable()
            Dim calumnaCodigo As New DataColumn(campoValor, GetType(System.String))
            Dim columnaValor As New DataColumn(campoMuestra, GetType(System.String))
            Dim fila As DataRow
            newDt.Columns.Add(calumnaCodigo)
            newDt.Columns.Add(columnaValor)

            control.DataTextField = campoMuestra
            control.DataValueField = campoValor

            If muestraMensaje Then
                fila = newDt.NewRow()
                fila.Item(campoValor) = primerValor
                fila.Item(campoMuestra) = primerMensaje
                newDt.Rows.Add(fila)
            End If

            Dim Registro As DataRow
            For Each Registro In datos.Rows
                fila = newDt.NewRow()
                fila.Item(campoValor) = Registro(campoValor)
                fila.Item(campoMuestra) = Registro(campoMuestra)
                newDt.Rows.Add(fila)
            Next
            control.DataSource = newDt
            control.DataBind()
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Sub

    Protected Sub lnkLeerDevolucion_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkLeerDevolucion.Click
        Dim devolucion As ILSBusinessLayer.LogisticaInversa.Devolucion = Session("devolucion")
        Response.Redirect("LecturaDevolucionLogisticaInversa.aspx?idDevolucion=" & devolucion.IdDevolucion.ToString())
    End Sub
End Class