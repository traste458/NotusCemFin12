Imports ILSBusinessLayer
Imports DevExpress.Web
Imports System.Collections.Generic

Public Class AdministracionDiasHabiles
    Inherits System.Web.UI.Page

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Seguridad.verificarSession(Me)
        miEncabezado.clear()

        If Not IsPostBack Then
            With miEncabezado
                .showReturnLink(MetodosComunes.getUrlFrameBack(Me))
                .setTitle("Administración Días No Hábiles")
            End With
            CargaInicial()
        End If
    End Sub

    Private Sub gvDiasHabiles_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs) Handles gvDiasHabiles.CustomCallback
        If Not String.IsNullOrEmpty(e.Parameters) Then
            Dim parameters() As String = e.Parameters.Split(":"c)
            Select Case parameters(1)
                Case "eliminar"
                    EliminarDiaNoHabil(CInt(parameters(0)))
                Case Else
                    Throw New ArgumentNullException("Opcion no valida")
            End Select
        End If
        CargaInicial()
    End Sub

    Private Sub gvDiasHabiles_DataBinding(sender As Object, e As System.EventArgs) Handles gvDiasHabiles.DataBinding
        gvDiasHabiles.DataSource = Session("dtDiasNoHabiles")
    End Sub

    Private Sub cpRegistro_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase) Handles cpRegistro.Callback
        Select Case e.Parameter
            Case "Especifico" : AdicionarDia()
            Case "Rango" : AdicionarRango()
            Case Else
                Throw New ArgumentNullException("Opcion no valida")
        End Select
        CType(sender, ASPxCallbackPanel).JSProperties("cpMensaje") = miEncabezado.RenderHtml()
    End Sub

    Protected Sub Link_Init(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim linkEliminar As ASPxHyperLink = CType(sender, ASPxHyperLink)
            Dim templateContainer As GridViewDataItemTemplateContainer = CType(linkEliminar.NamingContainer, GridViewDataItemTemplateContainer)

            'La visualización es visible para todos
            linkEliminar.ClientSideEvents.Click = linkEliminar.ClientSideEvents.Click.Replace("{0}", templateContainer.KeyValue)

        Catch ex As Exception
            miEncabezado.showError("No fué posible establecer los permisos de las funcionalidades: " & ex.Message)
        End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CargaInicial()
        Try
            'Se cargan los días No hábiles
            Dim objDiasNoHabil As New DiasNoHabilesColeccion(activo:=True)
            With gvDiasHabiles
                .DataSource = objDiasNoHabil.GenerarDataTable()
                Session("dtDiasNoHabiles") = .DataSource
                .DataBind()
            End With

        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar cargar los valores iniciales: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarDia()
        Dim resultado As New ResultadoProceso()
        Try
            Dim objDiaNoHabil As New DiasNoHabiles()
            With objDiaNoHabil
                objDiaNoHabil.Fecha = dateFecha.Date
                resultado = .Registrar()
            End With
            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Día no hábil registrado exitosamente.")
            Else
                miEncabezado.showWarning(resultado.Mensaje)
            End If
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar adicionar día no hábil: " & ex.Message)
        End Try
    End Sub

    Private Sub AdicionarRango()
        Try
            Dim listDiasNohabiles As New DiasNoHabilesColeccion()
            Dim listMensajes As New List(Of String)
            Dim diaInicial As Date = dateInicio.Date
            Dim diaFinal As Date = dateFin.Date

            'Calcular días del rango
            While diaInicial <= diaFinal
                If cblDiasSemana.SelectedValues.Contains(CInt(diaInicial.DayOfWeek)) Then
                    Dim objDia As New DiasNoHabiles()
                    With objDia
                        .Fecha = diaInicial
                        .Estado = True
                    End With
                    listDiasNohabiles.Adicionar(objDia)
                End If
                diaInicial = diaInicial.AddDays(1)
            End While

            'Registrar día del rango
            Dim resultado As New ResultadoProceso()
            For Each dia As DiasNoHabiles In listDiasNohabiles
                resultado = dia.Registrar()
                If resultado.Valor = 0 Then
                    listMensajes.Add("Se adicióno exitosamente el día no hábil: " & dia.Fecha.ToShortDateString())
                Else
                    listMensajes.Add(resultado.Mensaje & ": " & dia.Fecha.ToShortDateString())
                End If
            Next
            If listMensajes.Count > 0 Then miEncabezado.showSuccess(Join(listMensajes.ToArray(), "<br>"))
        Catch ex As Exception
            miEncabezado.showError("Se generó un error al intentar adicionar rango de días no hábiles: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarDiaNoHabil(idDia As Integer)
        Dim resultado As New ResultadoProceso()
        Try
            Dim obDiaNoHabil As New DiasNoHabiles()
            With obDiaNoHabil
                .IdDia = idDia
                .Estado = False
                resultado = .Actualizar()
            End With

            If resultado.Valor = 0 Then
                miEncabezado.showSuccess("Se actualizó exitosamente el registro.")
            Else
                miEncabezado.showWarning("No se logro actualizar el registro [" & resultado.Valor & "]")
            End If
        Catch ex As Exception
            miEncabezado.showError("Se genero un error al intentar eliminar el registro: " & ex.Message)
        End Try
    End Sub

#End Region

End Class