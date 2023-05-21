Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Estructuras
Imports System.Web.Services
Imports ILSBusinessLayer



Partial Public Class ActualizarInformacionValorDeclaradoGravado
    Inherits System.Web.UI.Page

    Public ReadOnly Property UsuarioSession() As Integer
        Get
            Session("usxp001") = 1
            Return Session("usxp001")
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        ucEncabezado.clear()
        If Not IsPostBack Then
            InicializarFormulario()
        End If
    End Sub
    Private Sub InicializarFormulario()
        ucEncabezado.setTitle("Listado materiales con precio excento de IVA.")
        CargarListaMaterial()
        CargarInformacionMaterialExcento()
    End Sub

    Private Function CargarListaMaterial() As DataTable
        Dim dt As New DataTable
        Dim filtro As FiltroSubproducto
        Try
            filtro.Estado = ILSBusinessLayer.Enumerados.EstadoBinario.Activo
            dt = Subproducto.ObtenerListado(filtro)
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                With ddlMaterial
                    .DataSource = dt
                    .DataTextField = "materialRegion"
                    .DataValueField = "material"
                    .DataBind()
                    .Items.Insert(0, New ListItem("...Seleccione material...", "0"))
                End With

            Else
                ucEncabezado.showError("No se obtuvo lista de ya l.")
            End If
        Catch ex As Exception
            ucEncabezado.showError("Error al listar materiales " & ex.Message)
        End Try
        Return dt
    End Function
    Private Sub CargarInformacionMaterialExcento(Optional ByVal filtro As String = "")
        Dim dtDatos As New DataTable
        Dim Material As New Subproducto
        Try
            dtDatos = Material.ObtenerMaterialExcentoDeImpuesto(filtro)
            EnlazarInformacionListaMaterialExcento(dtDatos)
            Session("dtListadoMaterialExcento") = dtDatos
        Catch ex As Exception
            ucEncabezado.showWarning("No fue posible cargar infomración de materiales excentos de impuesto " & ex.Message)
        End Try

    End Sub

    Private Sub EnlazarInformacionListaMaterialExcento(ByVal dtDatos As DataTable)
        If dtDatos IsNot Nothing Then
            With gvDatosValorDeclaradoExcento
                .DataSource = dtDatos
                .DataBind()
                .FooterRow.Cells(0).Text = dtDatos.Rows.Count & " registros encontrados."
                MetodosComunes.mergeGridViewFooter(gvDatosValorDeclaradoExcento)
            End With
        Else
            Throw New Exception("Imposible recuperar la informacíon de materiales excentos de impuesto.")
        End If
    End Sub

    Protected Sub imbtnAdicionar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imbtnAdicionar.Click
        If ddlMaterial.SelectedValue <> "0" Then
            AdicionarMaterialAListado(ddlMaterial.SelectedValue)
        End If
    End Sub

    Protected Sub ddlMaterial_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlMaterial.SelectedIndexChanged
        imbtnAdicionar.Focus()
    End Sub

    Private Sub gvDatosValorDeclaradoExcento_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDatosValorDeclaradoExcento.PageIndexChanging
        If Session("dtListadoMaterialExcento") IsNot Nothing Then
            'e.Cancel = True
            Dim dtDatos As DataTable = CType(Session("dtListadoMaterialExcento"), DataTable)
            gvDatosValorDeclaradoExcento.PageIndex = e.NewPageIndex
            EnlazarInformacionListaMaterialExcento(dtDatos)
        Else
            ucEncabezado.showError("Imposible recuperar los datos desde la memoria. Por favor genere el informe nuevamente.")
        End If
    End Sub

    Private Sub gvDatosValorDeclaradoExcento_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDatosValorDeclaradoExcento.RowCommand
        If e.CommandName = "Eliminar" Then
            EliminarMaterialDeListado()
        End If
    End Sub

    Private Sub AdicionarMaterialAListado(ByVal codigoMaterial As String)
        Dim Material As New Subproducto
        Dim resultado As New ResultadoProceso
        Try
            resultado = Material.AdicionarMaterialExcentoDeImpuesto(codigoMaterial, UsuarioSession)
            If resultado.Valor = 0 Then
                ucEncabezado.showSuccess(resultado.Mensaje)
                ddlMaterial.SelectedIndex = -1
                CargarInformacionMaterialExcento()
            ElseIf resultado.Valor = 1 Then
                ucEncabezado.showWarning(resultado.Mensaje)
            Else
                ucEncabezado.showError(resultado.Mensaje)
            End If

        Catch ex As Exception
            ucEncabezado.showError("Error al adicionar material a la lista " & ex.Message)
        End Try

    End Sub

    Private Sub EliminarMaterialDeListado()
        Dim Material As New Subproducto
        Dim resultado As New ResultadoProceso
        Dim cadenaMateriales As String = String.Empty
        Try
            cadenaMateriales = ObtenerListaMaterialAEliminar()
            If cadenaMateriales.Trim.Length > 0 Then
                resultado = Material.EliminarMaterialExcentoDeImpuesto(cadenaMateriales, UsuarioSession)
                If resultado.Valor = 0 Then
                    ucEncabezado.showSuccess(resultado.Mensaje)
                    CargarInformacionMaterialExcento()
                Else
                    ucEncabezado.showError(resultado.Mensaje)
                End If
            Else
                ucEncabezado.showWarning("No se seleccionó ningun material.")
            End If
        Catch ex As Exception
            ucEncabezado.showError("Error al Eliminar material(es) de la lista:" & ex.Message)
        End Try

    End Sub

    Private Function ObtenerListaMaterialAEliminar() As String
        Dim listaMaterial As New ArrayList
        Try
            For Each fila As GridViewRow In gvDatosValorDeclaradoExcento.Rows

                Dim mycheck As CheckBox = CType(fila.FindControl("chkEliminar"), CheckBox)
                If mycheck.Enabled AndAlso mycheck.Checked Then
                    If fila.Cells(0).Text.Trim.Length > 0 Then
                        listaMaterial.Add(fila.Cells(0).Text.Trim)
                    End If
                End If
            Next
            Return Join(listaMaterial.ToArray, ",")
        Catch ex As Exception
            ucEncabezado.showError("Error al obtener materiales a Eliminar." & ex.Message)
        End Try
    End Function

    Protected Sub imbtnBuscar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imbtnBuscar.Click
        If ddlMaterial.SelectedValue <> "0" Then
            CargarInformacionMaterialExcento(ddlMaterial.SelectedValue)
            ddlMaterial.SelectedIndex = -1
        Else
            CargarInformacionMaterialExcento()
        End If
    End Sub
End Class
