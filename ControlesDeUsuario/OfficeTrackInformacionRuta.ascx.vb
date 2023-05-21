Imports ILSBusinessLayer.MensajeriaEspecializada.OfficeTrack

Public Class OfficeTrackInformacionRuta
    Inherits System.Web.UI.UserControl





    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub CargarInformacionOfficeTrack(ByVal IdServicio As Integer)

        Dim tarea As New OfficeTrackTask
        'IdServicio = 429823
        hfIdServicio.Value = IdServicio
        Try

            tarea.ObtenerTareaServicio(IdServicio)
            If tarea.IdTask > 0 Then
                lblTaskNumber.Text = tarea.TaskNumber
                lblEstado.Text = tarea.StatusName
                lblDuracion.Text = tarea.Duration.ToString() + " Horas"
                lblStartDate.Text = tarea.StartDate
                lblDueDate.Text = tarea.DueDate
                lblInfoContacto.Text = tarea.ContactName
                lblEmployeeNumber.Text = tarea.EmployeeNumber
                lblTelContacto.Text = "0"
                lblInfoCliente.Text = tarea.CustomerName
                lblTelefonosCliente.Text = tarea.Phone1 & " - " & tarea.Phone2

                gvDatos.DataSource = tarea.ObtenerhistorialTareaServicio(IdServicio)
                gvDatos.DataBind()
            Else
                rpRegistroVentaCorporativa.Visible = False
                gvDatos.Visible = False
            End If
        Catch ex As Exception
            lblError.Text = "Error al tratar de cargar información del servicio. " & ex.Message
        End Try

    End Sub

    Protected Sub lbBuscar_Click(sender As Object, e As EventArgs)
        Try
            Dim tarea As New OfficeTrackTask
            tarea.ObtenerTareaServicio(Integer.Parse(hfIdServicio.Value))

            Dim ObjOfficeTrack As New ConfiguracionOfficeTrack
            Dim idDetalle As Integer = tarea.IdDetalle
            Dim ConfigurationID As Integer = ConfigurationManager.AppSettings.Item("idDatabase")
            Dim userName As String = ConfigurationManager.AppSettings.Item("userName")
            Dim password As String = ConfigurationManager.AppSettings.Item("password")

            With ObjOfficeTrack
                ObjOfficeTrack.CargarConfigOfficeTrack(idDetalle, userName, password, ConfigurationID)
            End With
        Catch ex As Exception
            lblError.Text = "Error al tratar de cargar información del servicio. " & ex.Message
        End Try
    End Sub


End Class