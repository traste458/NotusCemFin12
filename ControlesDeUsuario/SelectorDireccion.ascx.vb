Imports System.Text
Imports System.String

<ValidationPropertyAttribute("value")> _
Public Class SelectorDireccion
    Inherits System.Web.UI.UserControl

#Region "Atributos"

    Private _htDireccion As Hashtable

#End Region

#Region "Propiedades"

    Public Property HTDireccion() As Hashtable
        Get
            If _htDireccion Is Nothing Then CrearEstructuraTabla()
            Return _htDireccion
        End Get
        Set(ByVal value As Hashtable)
            _htDireccion = value
        End Set
    End Property

    Public Property DireccionEdicion() As String
        Get
            Return hdDireccionEdicion.Value
        End Get
        Set(value As String)
            hdDireccionEdicion.Value = value
            ExtraerDatos()
        End Set
    End Property

    ''' <summary>
    ''' Propiedad que permite que el control pueda ser validado cómo requerido en un RequiredFieldValidator.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property value() As String
        Get
            Return memoDireccion.Text
        End Get
        Set(ByVal value As String)
            memoDireccion.Text = value
        End Set
    End Property

#End Region

#Region "Eventos"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack Then
                If Session("$htDireccion") IsNot Nothing Then
                    _htDireccion = Session("$htDireccion")
                    CargarDatos()
                Else
                    CrearEstructuraTabla()
                End If
            Else
                memoDireccion.Text = Request.Form(memoDireccion.UniqueID)
                hdDireccionEdicion.Value = Request.Form(hdDireccionEdicion.UniqueID)
                If Session("$htDireccion") IsNot Nothing Then
                    _htDireccion = Session("$htDireccion")
                End If
            End If
        Catch : End Try
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            If _htDireccion Is Nothing Then CrearEstructuraTabla()

            If cmbNombreVia.SelectedItem IsNot Nothing Then _htDireccion("NombreVia") = cmbNombreVia.SelectedItem.Value
            _htDireccion("NumeroVia") = spNumeroVia.Value
            If cmbLetraVia.SelectedItem IsNot Nothing Then _htDireccion("LetraVia") = cmbLetraVia.SelectedItem.Value
            If cmbBisVia.SelectedItem IsNot Nothing Then _htDireccion("BisVia") = cmbBisVia.SelectedItem.Value
            If cmbOrientacionVia.SelectedItem IsNot Nothing Then _htDireccion("OrientacionVia") = cmbOrientacionVia.SelectedItem.Value
            _htDireccion("NumeroViaSec") = spNumeroViaSec.Value
            If cmbLetraViaSec.SelectedItem IsNot Nothing Then _htDireccion("LetraViaSec") = cmbLetraViaSec.SelectedItem.Value
            If cmbBisViaSec.SelectedItem IsNot Nothing Then _htDireccion("BisViaSec") = cmbBisViaSec.SelectedItem.Value
            _htDireccion("NumeroNomenclatura") = spNumeroNomenclatura.Value
            If cmbOrientacionViaSec.SelectedItem IsNot Nothing Then _htDireccion("OrientacionViaSec") = cmbOrientacionViaSec.SelectedItem.Value

            Session("$htDireccion") = _htDireccion
        Catch : End Try
    End Sub

#End Region

#Region "Métodos Privados"

    Private Sub CrearEstructuraTabla()
        Try
            _htDireccion = New Hashtable
            With _htDireccion
                .Add("NombreVia", String.Empty)
                .Add("NumeroVia", String.Empty)
                .Add("LetraVia", String.Empty)
                .Add("BisVia", String.Empty)
                .Add("OrientacionVia", String.Empty)
                .Add("NumeroViaSec", String.Empty)
                .Add("LetraViaSec", String.Empty)
                .Add("BisViaSec", String.Empty)
                .Add("NumeroNomenclatura", String.Empty)
                .Add("OrientacionViaSec", String.Empty)
            End With
        Catch : End Try
    End Sub

    Private Sub CargarDatos()
        Try
            If Not IsNullOrEmpty(_htDireccion("NombreVia")) Then cmbNombreVia.SelectedItem.Value = _htDireccion("NombreVia")
            If Not IsNullOrEmpty(_htDireccion("NumeroVia")) Then spNumeroVia.Value = _htDireccion("NumeroVia")
            If Not IsNullOrEmpty(_htDireccion("LetraVia")) Then cmbLetraVia.SelectedItem.Value = _htDireccion("LetraVia")
            If Not IsNullOrEmpty(_htDireccion("BisVia")) Then cmbBisVia.SelectedItem.Value = _htDireccion("BisVia")
            If Not IsNullOrEmpty(_htDireccion("OrientacionVia")) Then cmbOrientacionVia.SelectedItem.Value = _htDireccion("OrientacionVia")
            If Not IsNullOrEmpty(_htDireccion("NumeroViaSec")) Then spNumeroViaSec.Value = _htDireccion("NumeroViaSec")
            If Not IsNullOrEmpty(_htDireccion("LetraViaSec")) Then cmbLetraViaSec.SelectedItem.Value = _htDireccion("LetraViaSec")
            If Not IsNullOrEmpty(_htDireccion("BisViaSec")) Then cmbBisViaSec.SelectedItem.Value = _htDireccion("BisViaSec")
            If Not IsNullOrEmpty(_htDireccion("NumeroNomenclatura")) Then spNumeroNomenclatura.Value = _htDireccion("NumeroNomenclatura")
            If Not IsNullOrEmpty(_htDireccion("OrientacionViaSec")) Then cmbOrientacionViaSec.SelectedItem.Value = _htDireccion("OrientacionViaSec")

            memoDireccion.Text = DireccionEdicion
        Catch : End Try
    End Sub

    Private Sub ExtraerDatos()
        Try
            Dim arrValores As String() = hdDireccionEdicion.Value.Split("|")
            If Not IsNullOrEmpty(arrValores(0)) Then cmbNombreVia.Value = arrValores(0)
            If Not IsNullOrEmpty(arrValores(1)) Then spNumeroVia.Value = arrValores(1)
            If Not IsNullOrEmpty(arrValores(2)) Then cmbLetraVia.Value = arrValores(2)
            If Not IsNullOrEmpty(arrValores(3)) Then cmbBisVia.Value = arrValores(3)
            If Not IsNullOrEmpty(arrValores(4)) Then cmbOrientacionVia.Value = arrValores(4)
            If Not IsNullOrEmpty(arrValores(5)) Then spNumeroViaSec.Value = arrValores(5)
            If Not IsNullOrEmpty(arrValores(6)) Then cmbLetraViaSec.Value = arrValores(6)
            If Not IsNullOrEmpty(arrValores(7)) Then cmbBisViaSec.Value = arrValores(7)
            If Not IsNullOrEmpty(arrValores(8)) Then spNumeroNomenclatura.Value = arrValores(8)
            If Not IsNullOrEmpty(arrValores(9)) Then cmbOrientacionViaSec.Value = arrValores(9)
        Catch : End Try
    End Sub

#End Region

#Region "Métodos Públicos"

    Public Sub Limpiar()
        Try
            _htDireccion = Nothing
            cmbNombreVia.Value = Nothing
            spNumeroVia.Value = 0
            cmbLetraVia.Value = Nothing
            cmbBisVia.Value = Nothing
            cmbOrientacionVia.Value = Nothing
            spNumeroViaSec.Value = 0
            cmbLetraViaSec.Value = Nothing
            cmbBisViaSec.Value = Nothing
            spNumeroNomenclatura.Value = 0
            cmbOrientacionViaSec.Value = Nothing
        Catch : End Try
    End Sub

#End Region

End Class