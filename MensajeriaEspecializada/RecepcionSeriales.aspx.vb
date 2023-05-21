Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports ILSBusinessLayer.Proveedor
Imports DevExpress.Web
Imports GemBox.Spreadsheet
Imports System.IO
Imports ILSBusinessLayer.Recibos
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.Localizacion
Imports DevExpress.Web.ASPxPivotGrid
Imports System.Text

Public Class RecepcionSeriales
    Inherits System.Web.UI.Page


#Region "Atributos"
#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        epPrincipal.clear()
        Try
            If Not Me.IsPostBack Then
                epPrincipal.showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                Session.Remove("dtServiciosAdicionados")
                epPrincipal.setTitle("Confirmar Recepción Seriales")
                CargarDatos()
            End If
        Catch ex As Exception
            epPrincipal.showError("Error al tratar de cargar la página: " & ex.Message)
        End Try
    End Sub

    Private Sub cpPrincipal_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpPrincipal.Callback
        epPrincipal.clear()
        Try
            Dim arryAccion As String()
            arryAccion = e.Parameter.Split(":")

            Select Case arryAccion(1)
                Case "100" ''Confirmar entrega seriales
                    Dim resultado As String
                    resultado = ConfirmarEntregaSeriales()
                    epPrincipal.showSuccess(resultado)
       
                Case "200" 'Cargar Seriales

                    CargarGridSeriales()
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            
        Catch ex As Exception
            epPrincipal.showError("Error: " & ex.Message)
        End Try

    End Sub

#End Region

#Region "Métodos públicos"

#End Region

#Region "Métodos privados"

    Private Sub CargarDatos()
        Try
            CargarBodegasTraslado()
        Catch ex As Exception
            epPrincipal.showError("Error al cargar los datos: " & ex.ToString)
        End Try
    End Sub

    Private Sub CargarBodegasTraslado()
        Dim dtBodegas As DataTable
        Try
            Dim objCentroExperiencia As New CentroExperiencia
            With objCentroExperiencia
                dtBodegas = .ObtenerBoedegasTraslado()
            End With
            If dtBodegas.Rows.Count > 0 Then

            End If
        Catch ex As Exception
            epPrincipal.showError("Error al cargar el Origen: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarGridSeriales()
        Dim dtPrdSerial As DataTable
        Dim objProducto As New CentroExperiencia
        With objProducto
            dtPrdSerial = .ObtenerInformacionTrasladoInventario(txtSerial.Text)
        End With

        EnlazarReporte(gridProductos, dtPrdSerial)
    End Sub

    Private Function ConfirmarEntregaSeriales() As String
        Dim objSerial As New CentroExperiencia
        Dim mensaje As String
        Try
            With objSerial
                .ConfirmarEntregaSeriales(txtSerial.Text)
                mensaje = "Se confirmó correctamente la recepción de seriales"
                txtSerial.Text = String.Empty
            End With
        Catch ex As Exception
            mensaje = ex.ToString()
        End Try
        Return mensaje
    End Function

    Private Sub EnlazarReporte(ByVal grid As Object, ByVal dtDatos As DataTable)
        With grid
            .DataSource = dtDatos
            .DataBind()
        End With
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)
            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

            Dim linkVerFallas As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer1 As GridViewDataItemTemplateContainer = CType(linkVerFallas.NamingContainer, GridViewDataItemTemplateContainer)
            linkVerFallas.ClientSideEvents.Click = linkVerFallas.ClientSideEvents.Click.Replace("{0}", templateContainer1.KeyValue)

            Dim linkVerAccesorios As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer2 As GridViewDataItemTemplateContainer = CType(linkVerAccesorios.NamingContainer, GridViewDataItemTemplateContainer)
            linkVerAccesorios.ClientSideEvents.Click = linkVerAccesorios.ClientSideEvents.Click.Replace("{0}", templateContainer2.KeyValue)

        Catch ex As Exception
            epPrincipal.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub


#End Region


End Class