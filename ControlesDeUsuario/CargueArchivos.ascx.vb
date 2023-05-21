Imports DevExpress.Web
Imports ILSBusinessLayer
Imports System.IO

Public Class CargueArchivos
    Inherits System.Web.UI.UserControl

    Public Property _ruta As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub LinkDatosEditar_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim hlEditar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(hlEditar.NamingContainer, GridViewDataItemTemplateContainer)
            Dim ruta As String = templateContainer.KeyValue.ToString.Replace("\", "|-")
            hlEditar.ClientSideEvents.Click = hlEditar.ClientSideEvents.Click.Replace("{0}", ruta)
        Catch ex As Exception
            epPrincipal.showError("No fué posible establecer los parametrospara editar" & "<br><br>" & ex.Message)
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml()
        End Try
    End Sub

    Protected Sub btnAgregarSoportes_Click(sender As Object, e As EventArgs) Handles btnAgregarSoportes.Click
        AdicionarSoporte()

    End Sub
    Private Sub AdicionarSoporte()
        Try
            If fuArchivos.HasFile Then
                Dim _ruta As String
                Dim Variable As String = "RUTACARGUEARCHIVOSSOPORTEEQUIPOS"
                Try
                    Dim obj As Comunes.ConfigValues = New Comunes.ConfigValues(Variable)
                    _ruta = obj.ConfigKeyValue + "\Soporte\" + Guid.NewGuid().ToString() + Path.GetExtension(fuArchivos.FileName)
                Catch ex As Exception
                    epPrincipal.showError("Se generó un error al tratar cargar la ruta: " & "<br><br>" & ex.Message)
                    'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
                End Try
                If Not String.IsNullOrEmpty(_ruta) Then
                    If Not Directory.Exists(_ruta) Then
                        Directory.CreateDirectory(_ruta)
                    End If
                    fuArchivos.SaveAs(_ruta)
                    RegistrarSoporte(_ruta, fuArchivos.PostedFile.ContentType, Guid.NewGuid().ToString() + Path.GetExtension(fuArchivos.FileName))
                End If
            Else
                epPrincipal.showWarning("Ya se ingreso el numero maximo de imagenes.")
                'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
            End If
            If CType(Session("dtSoportes"), DataTable).Rows.Count <= 4 Then
                fuArchivos.Enabled = True
                btnAgregarSoportes.ClientEnabled = True
            Else
                fuArchivos.Enabled = False
                btnAgregarSoportes.ClientEnabled = False
            End If
        Catch ex As Exception
            epPrincipal.showError("Se generó un error al tratar adicionar el archivos: " & "<br><br>" & ex.Message)
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
    End Sub
    Private Sub RegistrarSoporte(ByVal ruta As String, ByVal tipoImagen As String, ByVal nombre As String)
        Try
            Dim dtSoportes As New DataTable
            If Session("dtSoportes") Is Nothing Then
                dtSoportes.Columns.Add(New DataColumn("nombre", System.Type.GetType("System.String")))
                dtSoportes.Columns.Add(New DataColumn("ruta"))
                dtSoportes.Columns.Add(New DataColumn("tipoImagen"))
                Dim pkColumn(0) As DataColumn
                With dtSoportes.Columns
                    pkColumn(0) = .Item("ruta")
                End With
                dtSoportes.PrimaryKey = pkColumn
                Dim dr As DataRow = dtSoportes.NewRow()
                dr("ruta") = ruta
                dr("nombre") = nombre
                dr("tipoImagen") = tipoImagen
                dtSoportes.Rows.Add(dr)
                Session("dtSoportes") = dtSoportes
                gvSoporte.DataSource = dtSoportes
                gvSoporte.DataBind()
            Else
                Dim drAux As DataRow
                dtSoportes = Session("dtSoportes")
                drAux = dtSoportes.Rows.Find(ruta)
                If drAux IsNot Nothing Then
                    epPrincipal.showError(" Ya existe un soporte con el mismo nombre")
                Else
                    Dim dr As DataRow = dtSoportes.NewRow()
                    dr("ruta") = ruta
                    dr("nombre") = nombre
                    dr("tipoImagen") = tipoImagen
                    dtSoportes.Rows.Add(dr)
                    Session("dtSoportes") = dtSoportes
                    gvSoporte.DataSource = dtSoportes
                    gvSoporte.DataBind()
                End If

            End If
            gvSoporte.Visible = True
            epPrincipal.showSuccess("El soporte se adiciono de forma correcta: " & "<br><br>")
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        Catch ex As Exception
            epPrincipal.showError("Error al adicionar el soporte. " & ex.Message & "<br><br>")
            'cpPrincipal.JSProperties("cpMensaje") = epPrincipal.RenderHtml
        End Try
    End Sub

End Class