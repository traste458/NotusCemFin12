Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports LMDataAccessLayer
Imports ILSBusinessLayer.AlmacenBodega
Imports ILSBusinessLayer.LogisticaInversa
Imports System.Web.Services
Imports ILSBusinessLayer
Imports ILSBusinessLayer.OMS
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Productos
Public Class CrearBodega
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim objbodega As New AlmacenBodega

        If Not IsPostBack Then
            EncabezadoPagina1.setTitle("Crear Bodega")

            cargarTipoBodega()
            cargarUnidadNegocio()
            cargarCliExt()
            cargarBodegas()
        End If
    End Sub

    Private Sub BtnCreaBodega_Click(sender As Object, e As EventArgs) Handles BtnCreaBodega.Click

        Dim bodegas As New AlmacenBodega

        Try

            With bodegas

                .idBodega2 = txBodega.Text
                .Nombre = txNomBod.Text
                .Direccion = txDireccion.Text
                .Telefono = txTelefono.Text
                .ciuPrincipal = cmbCiudad.SelectedItem.Value
                .IdCiudad = cmbCiudad.SelectedItem.Value
                If rdBtnTrue.Checked Then
                    .AceptaProductoEnReconocimiento = 1
                ElseIf rdBtnFalse.Checked Then
                    .AceptaProductoEnReconocimiento = 0
                End If
                .clientExterno = cmbCliExt.SelectedItem.Value
                .Tipo = cmbTipo.SelectedItem.Value
                .unidadNegocio = cmbUnidNegocio.SelectedItem.Value
                .codigo = txCodigo.Text.Trim
                .TokenSimpliRoute = txtTokenSimpliRoute.Text.Trim
                .codigoSucursalInterRapidisimo = 0
                If IsNumeric(txtcodigoSucursalInterRapidisimo.Text.Trim) = True Then
                    .codigoSucursalInterRapidisimo = txtcodigoSucursalInterRapidisimo.Text.Trim
                End If
                .Centro = txCentro.Text
                .Almacen = txAlmacen.Text
                .HorarioAtencion = txtHorarioAtencion.Text.Trim
                .IdSucursal = txtIdSucursal.Text.Trim
            End With
            bodegas.Crear()

            Dim regInsumo As New ResultadoProceso
            If regInsumo.Valor = 1 Then
                EncabezadoPagina1.showSuccess("Se ha creado de forma satisfactoria")
            Else
                EncabezadoPagina1.showSuccess("Se ha creado de forma satisfactoria")
            End If
            limpiarFormulario()

        Catch ex As Exception
            EncabezadoPagina1.showError("Error " & ex.Message)
        End Try

    End Sub

    Public Sub limpiarFormulario()
        txBodega.Text = ""
        txCodigo.Text = ""
        txDireccion.Text = ""
        txNomBod.Text = ""
        txTelefono.Text = ""
        cmbCiudad.SelectedIndex = -1
        cmbCliExt.SelectedIndex = -1
        cmbTipo.SelectedIndex = -1
        cmbUnidNegocio.SelectedIndex = -1
        rdBtnFalse.Checked = False
        rdBtnTrue.Checked = False
        txtcodigoSucursalInterRapidisimo.Text = 0
        txCentro.Text = ""
        txAlmacen.Text = ""
        txtIdSucursal.Text = ""
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

    Private Sub cargarBodegas()
        Dim dtBodega As New DataTable
        Dim objBod As New AlmacenBodega
        Try
            dtBodega = objBod.ObtenerCiudadSinBodega()
            Session("dtBodega") = dtBodega
            If dtBodega.Rows.Count > 0 Then
                MetodosComunes.CargarComboDX(cmbCiudad, dtBodega, "idCiudad", "ciudad")
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

End Class