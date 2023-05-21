Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports LMDataAccessLayer
Imports ILSBusinessLayer.AlmacenBodega
Imports ILSBusinessLayer.OMS
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Productos
Imports System.Web.Services
Imports ILSBusinessLayer

Imports System.Data
Public Class editarBodega
    Inherits System.Web.UI.Page

    Dim Bodega As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Bodega = Request.QueryString("idBodega")

        Dim objbodega As New AlmacenBodega

        If Not IsPostBack Then
            cargarTipoBodega()
            cargarUnidadNegocio()
            cargarCliExt()
            cargarCiudades()

            EncabezadoPagina1.showReturnLink("AdministrarBodegas.aspx")
            EncabezadoPagina1.setTitle("Actualización de Bodega")

            gvCiudades.DataSource = objbodega.ObtenerCiudadCercanaSinBodega(Bodega)
            gvCiudades.DataBind()


            gvSeleccion.DataSource = objbodega.ObtenerCiudadAsignada(Bodega)
            gvSeleccion.DataBind()

            Session("idCiudad") = objbodega.ObtenerCiudadCercanaSinBodega(Bodega)
            Session("idCiudades") = objbodega.ObtenerCiudadAsignada(Bodega)


            Me.cargaDatosBodega(Bodega)

            'cargarCiudades()

        End If

    End Sub


    Private Sub cargaDatosBodega(ByVal bodegas As Integer)

        Dim instruccion = New AlmacenBodega(Bodegas:=bodegas)
        With instruccion
            txBodega.Text = .idBodega2
            txNomBod.Text = .Nombre
            txDireccion.Text = .Direccion
            txTelefono.Text = .Telefono
            txCodigo.Text = .Codigo
            cmbCliExt.Value = .clientExterno
            cmbTipo.Value = .Tipo
            cmbCiudad.Value = .IdCiudad
            cmbUnidNegocio.Value = .unidadNegocio
            txtcodigoSucursalInterRapidisimo.Text = .codigoSucursalInterRapidisimo
            If .AceptaProductoEnReconocimiento = False Then
                rdBtnFalse.Checked = True
            Else
                rdBtnTrue.Checked = True
            End If
            txtTokenSimpliRoute.Text = .tokenSimpliRoute
            txtIdSucursal.Text = .IdSucursal
        End With

    End Sub

    Private Sub cargarCliExt()
        Dim dtCliente As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtCliente = objBod.ObtenerClienteExterno()
            Session("dtCliente") = dtCliente
            If dtCliente.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbCliExt, dtCliente, "idClienteExterno", "nombre")
            End If
        Catch ex As Exception

        End Try
    End Sub

    Private Sub cargarTipoBodega()
        Dim dtBodega As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtBodega = objBod.ObtenerTipoBodega()
            Session("dtBodega") = dtBodega
            If dtBodega.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbTipo, dtBodega, "idTipo", "nombre")
            End If
        Catch ex As Exception

        End Try
    End Sub

    Private Sub cargarUnidadNegocio()
        Dim dtNegocio As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtNegocio = objBod.ObtenerUnidadNegocio()
            Session("dtNegocio") = dtNegocio
            If dtNegocio.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbUnidNegocio, dtNegocio, "idUnidadNegocio", "nombre")
            End If
        Catch ex As Exception

        End Try
    End Sub




    Protected Sub btnSeleccionar_Click(ByVal sender As Object, ByVal e As EventArgs)


        Dim objBod As New AlmacenBodega

        Session("idCiudad") = objBod.ObtenerCiudadCercanaSinBodega(Bodega)

        For Each row As GridViewRow In gvCiudades.Rows

            Dim check As CheckBox = TryCast(row.FindControl("chkSeleccion"), CheckBox)
            Dim idUsuario As Integer

            If check.Checked Then

                With objBod
                    .IdCiudad = Convert.ToInt32(gvCiudades.DataKeys(row.RowIndex).Value)
                    .ciudades = row.Cells(1).Text
                End With

                Dim rowdelete As DataRow() = Session("idCiudad").[Select](String.Format("idCiudad={0}", objBod.IdCiudad))
                Session("idCiudad").Rows.Remove(rowdelete(0))

                objBod.CrearCiudadCercana(Bodega, objBod.IdCiudad, Integer.TryParse(Session("usxp001"), idUsuario))

            End If
        Next

        Session("idCiudad2") = objBod.ObtenerCiudadAsignada(Bodega)

        gvCiudades.DataSource = Session("idCiudad")
        gvCiudades.DataBind()

        gvSeleccion.DataSource = Session("idCiudad2")
        gvSeleccion.DataBind()

    End Sub

    Private Sub cargarCiudades()
        Dim dtBodega As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtBodega = objBod.ObtenerCiudades()
            Session("dtBodega") = dtBodega
            If dtBodega.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbCiudad, dtBodega, "idCiudad", "ciudad")
            End If
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub btnQuitar_Click(ByVal sender As Object, ByVal e As EventArgs)

        'Dim dtSelec As DtCiuadesBod.dt_CiudadesDataTable = TryCast(Session("idCiudadesp"), DtCiuadesBod.dt_CiudadesDataTable)

        Dim bodegaS As New AlmacenBodega

        Session("idCiudade") = bodegaS.ObtenerCiudadCercanaSinBodega(Bodega)
        Session("idCiudad2") = bodegaS.ObtenerCiudadAsignada(Bodega)

        For Each row As GridViewRow In gvSeleccion.Rows

            Dim check As CheckBox = TryCast(row.FindControl("chkSeleccion"), CheckBox)

            If check.Checked Then

                With bodegaS
                    .IdCiudad = Convert.ToInt32(gvSeleccion.DataKeys(row.RowIndex).Value)
                    .idBodega2 = row.Cells(1).Text
                    .ciudades = row.Cells(2).Text
                End With


                Dim rowdelete As DataRow() = Session("idCiudad2").[Select](String.Format("IdCiudad={0}", bodegaS.IdCiudad))
                Session("idCiudad2").Rows.Remove(rowdelete(0))

                bodegaS.borrarCiudadCercana(bodegaS.idBodega2)

            End If
        Next

        Session("idCiudad2") = bodegaS.ObtenerCiudadAsignada(Bodega)

        gvCiudades.DataSource = Session("idCiudade")
        gvCiudades.DataBind()

        gvSeleccion.DataSource = Session("idCiudad2")
        gvSeleccion.DataBind()


    End Sub

    Private Sub btnActua_Click(sender As Object, e As EventArgs) Handles btnActu.Click

        Dim bodegas As New AlmacenBodega

        Try
            With bodegas

                .idBodega2 = txBodega.Text
                .Nombre = txNomBod.Text
                .Direccion = txDireccion.Text
                .Telefono = txTelefono.Text
                .ciuPrincipal = cmbCiudad.SelectedItem.Value
                If rdBtnTrue.Checked Then
                    .AceptaProductoEnReconocimiento = 1
                ElseIf rdBtnFalse.Checked Then
                    .AceptaProductoEnReconocimiento = 0
                End If
                .clientExterno = cmbCliExt.SelectedItem.Value
                .Tipo = cmbTipo.SelectedItem.Value
                .unidadNegocio = cmbUnidNegocio.SelectedItem.Value
                .Codigo = txCodigo.Text.Trim
                .IdBodega = Bodega
                .TokenSimpliRoute = txtTokenSimpliRoute.Text.Trim
                .IdSucursal = txtIdSucursal.Text.Trim
                .codigoSucursalInterRapidisimo = 0
                If IsNumeric(txtcodigoSucursalInterRapidisimo.Text.Trim) = True Then
                    .codigoSucursalInterRapidisimo = txtcodigoSucursalInterRapidisimo.Text.Trim
                End If

            End With
            bodegas.editar()
            Dim regInsumo As New ResultadoProceso
            If regInsumo.Valor = 1 Then
                EncabezadoPagina1.showSuccess("Se ha actualizo de forma satisfactoria")
            Else
                EncabezadoPagina1.showSuccess("Se ha actualizo de forma satisfactoria")
            End If

        Catch ex As Exception
            EncabezadoPagina1.showError("Error al actualizar" & ex.Message)
        End Try

    End Sub


End Class