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

Public Class verBodegasDetalle
    Inherits System.Web.UI.Page

    Dim idBodega As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            idBodega = Request.QueryString("idbodega")

            EncabezadoPagina1.showReturnLink("AdministrarBodegas.aspx")
            EncabezadoPagina1.setTitle("Ver información de Bodega")
            cargarDatosPrincipal()
            cargarDatos()

        End If
    End Sub


    Private Sub cargarDatosPrincipal()

        Dim instruccion As AlmacenBodega = New AlmacenBodega(idbodega:=idBodega)
        With instruccion
            lbIdBodega.Text = .IdBodega
            idBod2.Text = .idBodega2
            lbBodega.Text = .Nombre
            lbTelefono.Text = .Telefono
            lbDireccion.Text = .Direccion
            lbCiudad.Text = .nomCiudad
            lbEstado.Text = .estados
            If .AceptaProductoEnReconocimiento = "True" Then
                lbAcept.Text = "Si"
            Else lbAcept.Text = "No"
            End If
            lbClie.Text = .nomCli
            lbUnidNeg.Text = .unidNego
            lbTipo.Text = .nomTipo
            lbCodigo.Text = .codigo
            lbTokenSimpliRoute.Text = .TokenSimpliRoute
            lblcodigoSucursalInterRapidisimo.Text = .codigoSucursalInterRapidisimo
        End With

    End Sub

    Private Sub cargarDatos()
        Dim filtro As New AlmacenBodega
        Dim dt As DataTable = filtro.ObtenerCiudadAsignada(idBodega)
        Me.CargarBodegas(dt)
    End Sub


    Private Sub CargarBodegas(Optional ByVal dt As DataTable = Nothing)
        If dt Is Nothing Then
            Dim filtro As New AlmacenBodega
            dt = filtro.ObtenerCiudadAsignada(idBodega)
        End If
        If dt.Rows.Count > 0 Then
            gvCiudades.DataSource = dt
            gvCiudades.DataBind()
        End If


    End Sub

End Class