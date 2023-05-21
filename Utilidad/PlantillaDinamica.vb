Imports System
Imports System.Data
Imports System.Configuration
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls
Imports System.ComponentModel
Imports System.Collections

Public Class PlantillaDinamica
    Implements ITemplate

    Public templateType As ListItemType
    Public htControls As New System.Collections.Hashtable()
    Public htBindPropertiesNames As New System.Collections.Hashtable()
    Public htBindExpression As New System.Collections.Hashtable()

    Private adicionarManejador As Boolean

    Public Sub New(ByVal type As ListItemType)
        templateType = type
        adicionarManejador = True
    End Sub

    Public Sub AddControl(ByVal wbControl As WebControl, ByVal BindPropertyName As String, ByVal BindExpression As String)
        htControls.Add(htControls.Count, wbControl)
        htBindPropertiesNames.Add(htBindPropertiesNames.Count, BindPropertyName)
        htBindExpression.Add(htBindExpression.Count, BindExpression)
        adicionarManejador = True
    End Sub

    Public Sub AddControl(ByVal wbControl As WebControl)
        htControls.Add(htControls.Count, wbControl)
        adicionarManejador = False
    End Sub

    Public Sub InstantiateIn(ByVal container As Control) Implements System.Web.UI.ITemplate.InstantiateIn
        Dim ph As New PlaceHolder()

        For i As Integer = 0 To htControls.Count - 1
            'Dim cntrl As Control = CloneControl(CType(htControls(i), Control))
            Select Case templateType
                Case ListItemType.Header
                Case ListItemType.Item
                    'ph.Controls.Add(cntrl)
                    ph.Controls.Add(CType(htControls(i), Control))
                    If adicionarManejador Then AddHandler ph.DataBinding, AddressOf Item_DataBinding
                Case ListItemType.AlternatingItem
                    'ph.Controls.Add(cntrl)
                    ph.Controls.Add(CType(htControls(i), Control))
                    If adicionarManejador Then AddHandler ph.DataBinding, AddressOf Item_DataBinding
                Case ListItemType.Footer
                Case Else
                    Throw New ArgumentNullException("Archivo no valido")
            End Select

        Next
        If adicionarManejador Then AddHandler ph.DataBinding, AddressOf Item_DataBinding
        container.Controls.Add(ph)
    End Sub

    Public Sub Item_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ph As PlaceHolder = CType(sender, PlaceHolder)
        Dim ri As GridViewRow = CType(ph.NamingContainer, GridViewRow)
        For i As Integer = 0 To htControls.Count
            If htBindPropertiesNames(i).ToString.Length > 0 Then
                Dim tmpCtrl As Control = CType(htControls(i), Control)
                Dim item1Value As String = CType(DataBinder.Eval(ri.DataItem, htBindExpression(i).ToString()), String)
                Dim ctrl As Control = ph.FindControl(tmpCtrl.ID)
                Dim t As System.Type = ctrl.GetType()
                Dim pi As System.Reflection.PropertyInfo = t.GetProperty(htBindPropertiesNames(i).ToString())
                pi.SetValue(ctrl, item1Value.ToString(), Nothing)
            End If
        Next
    End Sub

    Private Function CloneControl(ByVal src_ctl As Control) As Control

        Dim t As Type = src_ctl.GetType()
        Dim obj As Object = Activator.CreateInstance(t)
        Dim dst_ctl As Control = CType(obj, Control)
        Dim src_pdc As PropertyDescriptorCollection = TypeDescriptor.GetProperties(src_ctl)
        Dim dst_pdc As PropertyDescriptorCollection = TypeDescriptor.GetProperties(dst_ctl)

        For i As Integer = 0 To src_pdc.Count
            If src_pdc(i).Attributes.Contains(DesignerSerializationVisibilityAttribute.Content) Then
                Dim collection_val As Object = src_pdc(i).GetValue(src_ctl)
                If TypeOf collection_val Is System.Collections.IList Then
                    For Each child As Object In CType(collection_val, IList)
                        Dim new_child As Control = CloneControl(CType(child, Control))
                        Dim dst_collection_val As Object = dst_pdc(i).GetValue(dst_ctl)
                        CType(dst_collection_val, IList).Add(new_child)
                    Next
                End If
            Else
                Try
                    dst_pdc(src_pdc(i).Name).SetValue(dst_ctl, src_pdc(i).GetValue(src_ctl))
                Catch ex As Exception
                End Try
            End If
        Next
        Return dst_ctl

    End Function

    
End Class

Public Class PlantillaDinamica2
    Implements ITemplate

    Private _tipo As TipoDato
    Private _id As String

    Public Sub New(ByVal tipo As TipoDato, ByVal id As String)
        Me._tipo = tipo
        Me._id = id
    End Sub

    Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements System.Web.UI.ITemplate.InstantiateIn

        If Me._tipo = TipoDato.BulletList Then
            'AddHandler Me._control.DataBinding, AddressOf ConstruccionDatos
            Dim bullet As New BulletedList
            bullet.ID = Me._id
            container.Controls.Add(bullet)
        End If
    End Sub

    Private Sub ConstruccionDatos(ByVal sender As Object, ByVal e As EventArgs)    
    End Sub

    Public Enum TipoDato
        BulletList = 1
    End Enum

End Class
