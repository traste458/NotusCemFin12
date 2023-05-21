Imports ILSBusinessLayer
Imports ILSBusinessLayer.Productos
Imports DevExpress.Web
Imports System.Text
Imports GemBox.Spreadsheet
Imports System.IO
Imports GemBox
Imports System.Collections.Generic

Public Class RecepcionserialesMesacontrol
    Inherits System.Web.UI.Page

#Region "Atributos."



#End Region

#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
#If DEBUG Then
        Session("usxp001") = IIf(Session("usxp001") Is Nothing, "20099", Session("usxp001"))
        Session("usxp007") = IIf(Session("usxp007") Is Nothing, "150", Session("usxp007"))
#End If
        Try
            If Not Me.IsPostBack Then
                With miEncabezado
                    .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                    .setTitle("::: Recepcion seriales mesa de control ::: ")
                End With
                Me.CargarCambiosRadicados()
            End If
            If cpGeneral.IsCallback Then
                gvDatos.DataBind()
            End If
        Catch ex As Exception
            miEncabezado.showError("Error al cargar la opción. " & ex.Message & "<br><br>")
        End Try
    End Sub
    Protected Sub cpGeneral_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpGeneral.Callback
        Try
            miEncabezado.clear()
            Dim resultado As New ResultadoProceso
            Dim arrAccion As String()
            arrAccion = e.Parameter.Split("|")
            Select Case arrAccion(0)
                Case "cargarSerial"
                    Try
                        VerificarCambiarRadicado(arrAccion(1))
                    Catch ex As Exception
                        miEncabezado.showError("Se generó un error al registrar el serial:" & ex.Message)
                    End Try
                Case "removerSerial"
                    RemoverRadicado(arrAccion(1))
                Case "ConfirmarSeriales"
                    If gvDatos.DataSource Is Nothing Then
                        miEncabezado.showWarning("Debe leer al menos un radicado.")
                    Else
                        ConfirmarCambiosRadicados()
                    End If
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
            txtSerial.Focus()
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al tratar de obtrener la información:" & ex.Message)
        End Try
        cpGeneral.JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub



    Private Sub gvDatos_DataBinding(sender As Object, e As System.EventArgs) Handles gvDatos.DataBinding
        If Session("dtgvDatos") IsNot Nothing Then gvDatos.DataSource = Session("dtgvDatos")
    End Sub
#End Region

#Region "Metodos Privados"
    Protected Sub LinkDatos_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim lnkAgregar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(lnkAgregar.NamingContainer, GridViewDataItemTemplateContainer)
            lnkAgregar.ClientSideEvents.Click = lnkAgregar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los parametros de las funcionalidades: " & ex.Message)
        End Try
    End Sub
    Private Sub limpiar()

        txtSerial.Text = String.Empty
        With gvDatos
            .DataSource = Nothing
            .DataSourceID = Nothing
            .DataBind()
        End With
        txtSerial.Focus()
    End Sub
    Private Sub ConfirmarCambiosRadicados()
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso
        Dim dtInfRadicado As New DataTable()
        Dim msjRecibido As String = String.Empty

        With objDocumentos
            .IdEstado = Enumerados.EstadoServicio.VerificacionMesaControl
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .ActualizarCambiarEstadoRadicado()
            dtInfRadicado = .DtInformacionRadicado
            If dtInfRadicado.Rows.Count > 0 Then
                Session("dtgvDatos") = dtInfRadicado
                With gvDatos
                    .DataSource = dtInfRadicado
                    .DataBind()
                End With
                rpAdministrador.ClientVisible = True
            End If
        End With
        If (resultado.Valor = 0) Then
            CargarCambiosRadicados()
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If 
    End Sub


    Private Sub CargarCambiosRadicados()
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso
        Dim dtInfRadicado As New DataTable()
        Dim msjRecibido As String = String.Empty

        With objDocumentos
            .ConsultaInfRad = True
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .ActualizarCambiarEstadoRadicado()
            dtInfRadicado = .DtInformacionRadicado
            Session("dtgvDatos") = dtInfRadicado
            With gvDatos
                .DataSource = dtInfRadicado
                .DataBind()
            End With

            If dtInfRadicado.Rows.Count > 0 Then
                rpAdministrador.ClientVisible = True
            End If
        End With


        'End If

        txtSerial.Text = String.Empty
        txtSerial.Focus()
    End Sub
    Private Sub RemoverRadicado(Radicado As Integer)
        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso
        Dim dtInfRadicado As New DataTable()
        Dim msjRecibido As String = String.Empty

        With objDocumentos
            .IdRadicado = Radicado
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .RemoverCambiarEstadoRadicado()
        End With
        If (resultado.Valor = 0) Then
            CargarCambiosRadicados()
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If

    End Sub
    Private Sub VerificarCambiarRadicado(ByVal Radicado As Integer)

        Dim objDocumentos As New GenerarPoolServicioMensajeria
        Dim resultado As ResultadoProceso
        Dim dtInfRadicado As New DataTable()
        Dim msjRecibido As String = String.Empty

        'With objDocumentos
        '    .IdRadicado = Radicado
        '    .IdEstado = Enumerados.EstadoServicio.VerificacionMesaControl
        '    .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
        '    resultado = .ActualizarCambiarEstadoRadicado()
        '    msjRecibido = resultado.Mensaje
        '    If (resultado.Valor = 0) Then
        '        miEncabezado.showSuccess(resultado.Mensaje)
        '    Else
        '        miEncabezado.showError(resultado.Mensaje)
        '    End If
        'End With

        'If (resultado.Valor = 0) Then

        With objDocumentos
            .ConsultaInfRad = True
            .IdRadicado = Radicado
            .IdEstado = Enumerados.EstadoServicio.VerificacionMesaControl
            .IdUsuarioGenerador = Integer.Parse(Session("usxp001"))
            resultado = .ActualizarCambiarEstadoRadicado()
            dtInfRadicado = .DtInformacionRadicado
            If dtInfRadicado.Rows.Count > 0 Then
                Session("dtgvDatos") = dtInfRadicado
                With gvDatos
                    .DataSource = dtInfRadicado
                    .DataBind()
                End With
                rpAdministrador.ClientVisible = True
            End If
        End With
        If (resultado.Valor = 0) Then
            miEncabezado.showSuccess(resultado.Mensaje)
        Else
            miEncabezado.showError(resultado.Mensaje)
        End If

        'End If

        txtSerial.Text = String.Empty
        txtSerial.Focus()
    End Sub

#End Region

End Class