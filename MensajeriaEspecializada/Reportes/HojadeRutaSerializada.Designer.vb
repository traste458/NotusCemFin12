<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class HojadeRutaSerializada
    Inherits DevExpress.XtraReports.UI.XtraReport

    'XtraReport overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Designer
    'It can be modified using the Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim Code128Generator1 As DevExpress.XtraPrinting.BarCode.Code128Generator = New DevExpress.XtraPrinting.BarCode.Code128Generator()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(HojadeRutaSerializada))
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLabel4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLabel2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine8 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine7 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine6 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine5 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine4 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine3 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine2 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine1 = New DevExpress.XtraReports.UI.XRLine()
        Me.Text24 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text25 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text26 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text27 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Line5 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine9 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line6 = New DevExpress.XtraReports.UI.XRLine()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrLabel1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text15 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text16 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text17 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text20 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text18 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text19 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Line3 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line11 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line12 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line14 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line15 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line16 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line17 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line18 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line19 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line20 = New DevExpress.XtraReports.UI.XRLine()
        Me.ReportHeader = New DevExpress.XtraReports.UI.ReportHeaderBand()
        Me.XrBarCode1 = New DevExpress.XtraReports.UI.XRBarCode()
        Me.Picture5 = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.Text1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text11 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Line1 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line2 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line8 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line9 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line10 = New DevExpress.XtraReports.UI.XRLine()
        Me.PageFooter = New DevExpress.XtraReports.UI.PageFooterBand()
        Me.Line21 = New DevExpress.XtraReports.UI.XRLine()
        Me.Text30 = New DevExpress.XtraReports.UI.XRLabel()
        Me.DsReporteHojadeRuta1 = New BPColSysOP.dsReporteHojadeRuta()
        Me.TopMarginBand1 = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMarginBand1 = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter = New BPColSysOP.dsReporteHojadeRutaTableAdapters.ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter()
        CType(Me.DsReporteHojadeRuta1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel4, Me.XrLabel3, Me.XrLabel2, Me.XrLine8, Me.XrLine7, Me.XrLine6, Me.XrLine5, Me.XrLine4, Me.XrLine3, Me.XrLine2, Me.XrLine1, Me.Text24, Me.Text25, Me.Text26, Me.Text27, Me.Line5, Me.XrLine9, Me.Line6})
        Me.Detail.HeightF = 30.0!
        Me.Detail.Name = "Detail"
        Me.Detail.SortFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("numeroRadicado", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        '
        'XrLabel4
        '
        Me.XrLabel4.BackColor = System.Drawing.Color.White
        Me.XrLabel4.BorderColor = System.Drawing.Color.Black
        Me.XrLabel4.CanGrow = False
        Me.XrLabel4.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel4.ForeColor = System.Drawing.Color.Black
        Me.XrLabel4.LocationFloat = New DevExpress.Utils.PointFloat(16.0!, 3.000005!)
        Me.XrLabel4.Name = "XrLabel4"
        Me.XrLabel4.SizeF = New System.Drawing.SizeF(105.0!, 23.37499!)
        Me.XrLabel4.StylePriority.UseFont = False
        Me.XrLabel4.Text = "[numeroRadicado]"
        Me.XrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel3
        '
        Me.XrLabel3.BackColor = System.Drawing.Color.White
        Me.XrLabel3.BorderColor = System.Drawing.Color.Black
        Me.XrLabel3.CanGrow = False
        Me.XrLabel3.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel3.ForeColor = System.Drawing.Color.Black
        Me.XrLabel3.LocationFloat = New DevExpress.Utils.PointFloat(706.0!, 3.000014!)
        Me.XrLabel3.Name = "XrLabel3"
        Me.XrLabel3.SizeF = New System.Drawing.SizeF(134.9999!, 22.37499!)
        Me.XrLabel3.StylePriority.UseFont = False
        Me.XrLabel3.Text = "[telefonos]"
        Me.XrLabel3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLabel2
        '
        Me.XrLabel2.BackColor = System.Drawing.Color.White
        Me.XrLabel2.BorderColor = System.Drawing.Color.Black
        Me.XrLabel2.CanGrow = False
        Me.XrLabel2.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrLabel2.ForeColor = System.Drawing.Color.Black
        Me.XrLabel2.LocationFloat = New DevExpress.Utils.PointFloat(850.0833!, 2.000014!)
        Me.XrLabel2.Name = "XrLabel2"
        Me.XrLabel2.SizeF = New System.Drawing.SizeF(128.0!, 23.37499!)
        Me.XrLabel2.StylePriority.UseFont = False
        Me.XrLabel2.Text = "[sim]"
        Me.XrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLine8
        '
        Me.XrLine8.BackColor = System.Drawing.Color.White
        Me.XrLine8.BorderColor = System.Drawing.Color.Black
        Me.XrLine8.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine8.ForeColor = System.Drawing.Color.Black
        Me.XrLine8.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine8.LocationFloat = New DevExpress.Utils.PointFloat(124.0!, 0.0!)
        Me.XrLine8.Name = "XrLine8"
        Me.XrLine8.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'XrLine7
        '
        Me.XrLine7.BackColor = System.Drawing.Color.White
        Me.XrLine7.BorderColor = System.Drawing.Color.Black
        Me.XrLine7.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine7.ForeColor = System.Drawing.Color.Black
        Me.XrLine7.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine7.LocationFloat = New DevExpress.Utils.PointFloat(299.0!, 0.0!)
        Me.XrLine7.Name = "XrLine7"
        Me.XrLine7.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'XrLine6
        '
        Me.XrLine6.BackColor = System.Drawing.Color.White
        Me.XrLine6.BorderColor = System.Drawing.Color.Black
        Me.XrLine6.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine6.ForeColor = System.Drawing.Color.Black
        Me.XrLine6.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine6.LocationFloat = New DevExpress.Utils.PointFloat(432.0!, 0.0!)
        Me.XrLine6.Name = "XrLine6"
        Me.XrLine6.SizeF = New System.Drawing.SizeF(2.083344!, 27.33333!)
        '
        'XrLine5
        '
        Me.XrLine5.BackColor = System.Drawing.Color.White
        Me.XrLine5.BorderColor = System.Drawing.Color.Black
        Me.XrLine5.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine5.ForeColor = System.Drawing.Color.Black
        Me.XrLine5.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine5.LocationFloat = New DevExpress.Utils.PointFloat(582.0!, 0.0!)
        Me.XrLine5.Name = "XrLine5"
        Me.XrLine5.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'XrLine4
        '
        Me.XrLine4.BackColor = System.Drawing.Color.White
        Me.XrLine4.BorderColor = System.Drawing.Color.Black
        Me.XrLine4.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine4.ForeColor = System.Drawing.Color.Black
        Me.XrLine4.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine4.LocationFloat = New DevExpress.Utils.PointFloat(699.0!, 0.0!)
        Me.XrLine4.Name = "XrLine4"
        Me.XrLine4.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'XrLine3
        '
        Me.XrLine3.BackColor = System.Drawing.Color.White
        Me.XrLine3.BorderColor = System.Drawing.Color.Black
        Me.XrLine3.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine3.ForeColor = System.Drawing.Color.Black
        Me.XrLine3.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine3.LocationFloat = New DevExpress.Utils.PointFloat(844.0!, 0.0!)
        Me.XrLine3.Name = "XrLine3"
        Me.XrLine3.SizeF = New System.Drawing.SizeF(2.083252!, 27.33333!)
        '
        'XrLine2
        '
        Me.XrLine2.BackColor = System.Drawing.Color.White
        Me.XrLine2.BorderColor = System.Drawing.Color.Black
        Me.XrLine2.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine2.ForeColor = System.Drawing.Color.Black
        Me.XrLine2.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine2.LocationFloat = New DevExpress.Utils.PointFloat(982.0!, 0.0!)
        Me.XrLine2.Name = "XrLine2"
        Me.XrLine2.SizeF = New System.Drawing.SizeF(2.083252!, 27.33333!)
        '
        'XrLine1
        '
        Me.XrLine1.BackColor = System.Drawing.Color.White
        Me.XrLine1.BorderColor = System.Drawing.Color.Black
        Me.XrLine1.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine1.ForeColor = System.Drawing.Color.Black
        Me.XrLine1.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine1.LocationFloat = New DevExpress.Utils.PointFloat(1043.0!, 0.0!)
        Me.XrLine1.Name = "XrLine1"
        Me.XrLine1.SizeF = New System.Drawing.SizeF(2.083252!, 27.33333!)
        '
        'Text24
        '
        Me.Text24.BackColor = System.Drawing.Color.White
        Me.Text24.BorderColor = System.Drawing.Color.Black
        Me.Text24.CanGrow = False
        Me.Text24.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Text24.ForeColor = System.Drawing.Color.Black
        Me.Text24.LocationFloat = New DevExpress.Utils.PointFloat(132.0!, 3.0!)
        Me.Text24.Name = "Text24"
        Me.Text24.SizeF = New System.Drawing.SizeF(162.0!, 23.37499!)
        Me.Text24.StylePriority.UseFont = False
        Me.Text24.Text = "[contacto]"
        Me.Text24.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text25
        '
        Me.Text25.BackColor = System.Drawing.Color.White
        Me.Text25.BorderColor = System.Drawing.Color.Black
        Me.Text25.CanGrow = False
        Me.Text25.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Text25.ForeColor = System.Drawing.Color.Black
        Me.Text25.LocationFloat = New DevExpress.Utils.PointFloat(305.0!, 3.0!)
        Me.Text25.Name = "Text25"
        Me.Text25.SizeF = New System.Drawing.SizeF(123.0!, 23.37499!)
        Me.Text25.StylePriority.UseFont = False
        Me.Text25.Text = "[empresa]"
        Me.Text25.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text26
        '
        Me.Text26.BackColor = System.Drawing.Color.White
        Me.Text26.BorderColor = System.Drawing.Color.Black
        Me.Text26.CanGrow = False
        Me.Text26.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Text26.ForeColor = System.Drawing.Color.Black
        Me.Text26.LocationFloat = New DevExpress.Utils.PointFloat(439.3333!, 3.0!)
        Me.Text26.Name = "Text26"
        Me.Text26.SizeF = New System.Drawing.SizeF(137.75!, 23.37499!)
        Me.Text26.StylePriority.UseFont = False
        Me.Text26.Text = "[direccion]"
        Me.Text26.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text27
        '
        Me.Text27.BackColor = System.Drawing.Color.White
        Me.Text27.BorderColor = System.Drawing.Color.Black
        Me.Text27.CanGrow = False
        Me.Text27.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Text27.ForeColor = System.Drawing.Color.Black
        Me.Text27.LocationFloat = New DevExpress.Utils.PointFloat(589.0!, 3.0!)
        Me.Text27.Name = "Text27"
        Me.Text27.SizeF = New System.Drawing.SizeF(105.0!, 23.37499!)
        Me.Text27.StylePriority.UseFont = False
        Me.Text27.Text = "[telefono]"
        Me.Text27.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Line5
        '
        Me.Line5.BackColor = System.Drawing.Color.White
        Me.Line5.BorderColor = System.Drawing.Color.Black
        Me.Line5.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line5.ForeColor = System.Drawing.Color.Black
        Me.Line5.LocationFloat = New DevExpress.Utils.PointFloat(10.08331!, 0.0!)
        Me.Line5.Name = "Line5"
        Me.Line5.SizeF = New System.Drawing.SizeF(1035.0!, 2.0!)
        '
        'XrLine9
        '
        Me.XrLine9.BackColor = System.Drawing.Color.White
        Me.XrLine9.BorderColor = System.Drawing.Color.Black
        Me.XrLine9.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine9.ForeColor = System.Drawing.Color.Black
        Me.XrLine9.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine9.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 0.0!)
        Me.XrLine9.Name = "XrLine9"
        Me.XrLine9.SizeF = New System.Drawing.SizeF(2.083313!, 28.33333!)
        '
        'Line6
        '
        Me.Line6.BackColor = System.Drawing.Color.White
        Me.Line6.BorderColor = System.Drawing.Color.Black
        Me.Line6.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line6.ForeColor = System.Drawing.Color.Black
        Me.Line6.LocationFloat = New DevExpress.Utils.PointFloat(9.0!, 27.33332!)
        Me.Line6.Name = "Line6"
        Me.Line6.SizeF = New System.Drawing.SizeF(1035.0!, 2.000002!)
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLabel1, Me.Text14, Me.Text15, Me.Text16, Me.Text17, Me.Text20, Me.Text18, Me.Text19, Me.Line3, Me.Line11, Me.Line12, Me.Line14, Me.Line15, Me.Line16, Me.Line17, Me.Line18, Me.Line19, Me.Line20})
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("idRuta", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 27.0!
        Me.GroupHeader1.Name = "GroupHeader1"
        '
        'XrLabel1
        '
        Me.XrLabel1.BackColor = System.Drawing.Color.White
        Me.XrLabel1.BorderColor = System.Drawing.Color.Black
        Me.XrLabel1.CanGrow = False
        Me.XrLabel1.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.XrLabel1.ForeColor = System.Drawing.Color.Black
        Me.XrLabel1.LocationFloat = New DevExpress.Utils.PointFloat(991.0833!, 6.00001!)
        Me.XrLabel1.Name = "XrLabel1"
        Me.XrLabel1.SizeF = New System.Drawing.SizeF(47.12494!, 16.0!)
        Me.XrLabel1.Text = "Puntos"
        Me.XrLabel1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text14
        '
        Me.Text14.BackColor = System.Drawing.Color.White
        Me.Text14.BorderColor = System.Drawing.Color.Black
        Me.Text14.CanGrow = False
        Me.Text14.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text14.ForeColor = System.Drawing.Color.Black
        Me.Text14.LocationFloat = New DevExpress.Utils.PointFloat(22.55118!, 6.0!)
        Me.Text14.Name = "Text14"
        Me.Text14.SizeF = New System.Drawing.SizeF(92.64568!, 15.0!)
        Me.Text14.Text = "Radicado"
        Me.Text14.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text15
        '
        Me.Text15.BackColor = System.Drawing.Color.White
        Me.Text15.BorderColor = System.Drawing.Color.Black
        Me.Text15.CanGrow = False
        Me.Text15.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text15.ForeColor = System.Drawing.Color.Black
        Me.Text15.LocationFloat = New DevExpress.Utils.PointFloat(132.0!, 6.0!)
        Me.Text15.Name = "Text15"
        Me.Text15.SizeF = New System.Drawing.SizeF(156.5512!, 15.0!)
        Me.Text15.Text = "Persona Contacto"
        Me.Text15.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text16
        '
        Me.Text16.BackColor = System.Drawing.Color.White
        Me.Text16.BorderColor = System.Drawing.Color.Black
        Me.Text16.CanGrow = False
        Me.Text16.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text16.ForeColor = System.Drawing.Color.Black
        Me.Text16.LocationFloat = New DevExpress.Utils.PointFloat(324.0!, 6.0!)
        Me.Text16.Name = "Text16"
        Me.Text16.SizeF = New System.Drawing.SizeF(75.0!, 15.0!)
        Me.Text16.Text = "Empresa"
        Me.Text16.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text17
        '
        Me.Text17.BackColor = System.Drawing.Color.White
        Me.Text17.BorderColor = System.Drawing.Color.Black
        Me.Text17.CanGrow = False
        Me.Text17.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text17.ForeColor = System.Drawing.Color.Black
        Me.Text17.LocationFloat = New DevExpress.Utils.PointFloat(466.0001!, 6.0!)
        Me.Text17.Name = "Text17"
        Me.Text17.SizeF = New System.Drawing.SizeF(82.99994!, 15.0!)
        Me.Text17.Text = "Dirección"
        Me.Text17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text20
        '
        Me.Text20.BackColor = System.Drawing.Color.White
        Me.Text20.BorderColor = System.Drawing.Color.Black
        Me.Text20.CanGrow = False
        Me.Text20.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text20.ForeColor = System.Drawing.Color.Black
        Me.Text20.LocationFloat = New DevExpress.Utils.PointFloat(598.9999!, 6.0!)
        Me.Text20.Name = "Text20"
        Me.Text20.SizeF = New System.Drawing.SizeF(91.0!, 15.0!)
        Me.Text20.Text = "Tel. Contacto"
        Me.Text20.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text18
        '
        Me.Text18.BackColor = System.Drawing.Color.White
        Me.Text18.BorderColor = System.Drawing.Color.Black
        Me.Text18.CanGrow = False
        Me.Text18.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text18.ForeColor = System.Drawing.Color.Black
        Me.Text18.LocationFloat = New DevExpress.Utils.PointFloat(703.9999!, 6.0!)
        Me.Text18.Name = "Text18"
        Me.Text18.SizeF = New System.Drawing.SizeF(138.9999!, 16.0!)
        Me.Text18.Text = "Telefonos"
        Me.Text18.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text19
        '
        Me.Text19.BackColor = System.Drawing.Color.White
        Me.Text19.BorderColor = System.Drawing.Color.Black
        Me.Text19.CanGrow = False
        Me.Text19.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text19.ForeColor = System.Drawing.Color.Black
        Me.Text19.LocationFloat = New DevExpress.Utils.PointFloat(881.9999!, 6.0!)
        Me.Text19.Name = "Text19"
        Me.Text19.SizeF = New System.Drawing.SizeF(66.0!, 16.0!)
        Me.Text19.Text = "Sims"
        Me.Text19.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Line3
        '
        Me.Line3.BackColor = System.Drawing.Color.White
        Me.Line3.BorderColor = System.Drawing.Color.Black
        Me.Line3.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line3.ForeColor = System.Drawing.Color.Black
        Me.Line3.LocationFloat = New DevExpress.Utils.PointFloat(10.08333!, 0.0!)
        Me.Line3.Name = "Line3"
        Me.Line3.SizeF = New System.Drawing.SizeF(1032.917!, 2.0!)
        '
        'Line11
        '
        Me.Line11.BackColor = System.Drawing.Color.White
        Me.Line11.BorderColor = System.Drawing.Color.Black
        Me.Line11.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line11.ForeColor = System.Drawing.Color.Black
        Me.Line11.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line11.LocationFloat = New DevExpress.Utils.PointFloat(1043.0!, 0.0!)
        Me.Line11.Name = "Line11"
        Me.Line11.SizeF = New System.Drawing.SizeF(2.083374!, 27.33333!)
        '
        'Line12
        '
        Me.Line12.BackColor = System.Drawing.Color.White
        Me.Line12.BorderColor = System.Drawing.Color.Black
        Me.Line12.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line12.ForeColor = System.Drawing.Color.Black
        Me.Line12.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line12.LocationFloat = New DevExpress.Utils.PointFloat(981.9999!, 0.0!)
        Me.Line12.Name = "Line12"
        Me.Line12.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'Line14
        '
        Me.Line14.BackColor = System.Drawing.Color.White
        Me.Line14.BorderColor = System.Drawing.Color.Black
        Me.Line14.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line14.ForeColor = System.Drawing.Color.Black
        Me.Line14.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line14.LocationFloat = New DevExpress.Utils.PointFloat(843.9999!, 0.0!)
        Me.Line14.Name = "Line14"
        Me.Line14.SizeF = New System.Drawing.SizeF(2.083374!, 27.33333!)
        '
        'Line15
        '
        Me.Line15.BackColor = System.Drawing.Color.White
        Me.Line15.BorderColor = System.Drawing.Color.Black
        Me.Line15.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line15.ForeColor = System.Drawing.Color.Black
        Me.Line15.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line15.LocationFloat = New DevExpress.Utils.PointFloat(698.9999!, 0.0!)
        Me.Line15.Name = "Line15"
        Me.Line15.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'Line16
        '
        Me.Line16.BackColor = System.Drawing.Color.White
        Me.Line16.BorderColor = System.Drawing.Color.Black
        Me.Line16.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line16.ForeColor = System.Drawing.Color.Black
        Me.Line16.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line16.LocationFloat = New DevExpress.Utils.PointFloat(581.9999!, 0.0!)
        Me.Line16.Name = "Line16"
        Me.Line16.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'Line17
        '
        Me.Line17.BackColor = System.Drawing.Color.White
        Me.Line17.BorderColor = System.Drawing.Color.Black
        Me.Line17.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line17.ForeColor = System.Drawing.Color.Black
        Me.Line17.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line17.LocationFloat = New DevExpress.Utils.PointFloat(432.0!, 0.0!)
        Me.Line17.Name = "Line17"
        Me.Line17.SizeF = New System.Drawing.SizeF(2.083344!, 27.33333!)
        '
        'Line18
        '
        Me.Line18.BackColor = System.Drawing.Color.White
        Me.Line18.BorderColor = System.Drawing.Color.Black
        Me.Line18.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line18.ForeColor = System.Drawing.Color.Black
        Me.Line18.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line18.LocationFloat = New DevExpress.Utils.PointFloat(299.0!, 0.0!)
        Me.Line18.Name = "Line18"
        Me.Line18.SizeF = New System.Drawing.SizeF(2.083313!, 27.33333!)
        '
        'Line19
        '
        Me.Line19.BackColor = System.Drawing.Color.White
        Me.Line19.BorderColor = System.Drawing.Color.Black
        Me.Line19.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line19.ForeColor = System.Drawing.Color.Black
        Me.Line19.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line19.LocationFloat = New DevExpress.Utils.PointFloat(124.0!, 0.0!)
        Me.Line19.Name = "Line19"
        Me.Line19.SizeF = New System.Drawing.SizeF(2.083336!, 27.33333!)
        '
        'Line20
        '
        Me.Line20.BackColor = System.Drawing.Color.White
        Me.Line20.BorderColor = System.Drawing.Color.Black
        Me.Line20.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line20.ForeColor = System.Drawing.Color.Black
        Me.Line20.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line20.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 0.0!)
        Me.Line20.Name = "Line20"
        Me.Line20.SizeF = New System.Drawing.SizeF(2.083333!, 27.33333!)
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrBarCode1, Me.Picture5, Me.Text1, Me.Text4, Me.Text5, Me.Text6, Me.Text7, Me.Text8, Me.Text9, Me.Text10, Me.Text11, Me.Text12, Me.Text13, Me.Line1, Me.Line2, Me.Line8, Me.Line9, Me.Line10})
        Me.ReportHeader.HeightF = 228.0!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'XrBarCode1
        '
        Me.XrBarCode1.Font = New System.Drawing.Font("Times New Roman", 20.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrBarCode1.LocationFloat = New DevExpress.Utils.PointFloat(366.0!, 10.00001!)
        Me.XrBarCode1.Name = "XrBarCode1"
        Me.XrBarCode1.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 10, 0, 0, 100.0!)
        Me.XrBarCode1.SizeF = New System.Drawing.SizeF(308.0!, 68.83333!)
        Me.XrBarCode1.StylePriority.UseFont = False
        Me.XrBarCode1.Symbology = Code128Generator1
        Me.XrBarCode1.Text = "[idRuta]"
        '
        'Picture5
        '
        Me.Picture5.BackColor = System.Drawing.Color.White
        Me.Picture5.BorderColor = System.Drawing.Color.Black
        Me.Picture5.Image = CType(resources.GetObject("Picture5.Image"), System.Drawing.Image)
        Me.Picture5.LocationFloat = New DevExpress.Utils.PointFloat(9.999998!, 7.999991!)
        Me.Picture5.Name = "Picture5"
        Me.Picture5.SizeF = New System.Drawing.SizeF(225.0!, 84.49995!)
        Me.Picture5.Sizing = DevExpress.XtraPrinting.ImageSizeMode.StretchImage
        '
        'Text1
        '
        Me.Text1.BackColor = System.Drawing.Color.White
        Me.Text1.BorderColor = System.Drawing.Color.Black
        Me.Text1.CanGrow = False
        Me.Text1.Font = New System.Drawing.Font("Arial", 18.0!)
        Me.Text1.ForeColor = System.Drawing.Color.Black
        Me.Text1.LocationFloat = New DevExpress.Utils.PointFloat(250.0!, 25.0!)
        Me.Text1.Name = "Text1"
        Me.Text1.SizeF = New System.Drawing.SizeF(108.0!, 33.0!)
        Me.Text1.Text = "No. Ruta:"
        Me.Text1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text4
        '
        Me.Text4.BackColor = System.Drawing.Color.White
        Me.Text4.BorderColor = System.Drawing.Color.Black
        Me.Text4.CanGrow = False
        Me.Text4.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text4.ForeColor = System.Drawing.Color.Black
        Me.Text4.LocationFloat = New DevExpress.Utils.PointFloat(16.0!, 131.0!)
        Me.Text4.Name = "Text4"
        Me.Text4.SizeF = New System.Drawing.SizeF(45.0!, 15.0!)
        Me.Text4.Text = "Fecha:"
        Me.Text4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text5
        '
        Me.Text5.BackColor = System.Drawing.Color.White
        Me.Text5.BorderColor = System.Drawing.Color.Black
        Me.Text5.CanGrow = False
        Me.Text5.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text5.ForeColor = System.Drawing.Color.Black
        Me.Text5.LocationFloat = New DevExpress.Utils.PointFloat(71.99999!, 131.0!)
        Me.Text5.Name = "Text5"
        Me.Text5.SizeF = New System.Drawing.SizeF(134.7083!, 20.0!)
        Me.Text5.Text = "[fechaRadicado]"
        Me.Text5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text6
        '
        Me.Text6.BackColor = System.Drawing.Color.White
        Me.Text6.BorderColor = System.Drawing.Color.Black
        Me.Text6.CanGrow = False
        Me.Text6.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text6.ForeColor = System.Drawing.Color.Black
        Me.Text6.LocationFloat = New DevExpress.Utils.PointFloat(238.6667!, 131.0!)
        Me.Text6.Name = "Text6"
        Me.Text6.SizeF = New System.Drawing.SizeF(191.3333!, 15.0!)
        Me.Text6.Text = "Nombre agente domiciliario:"
        Me.Text6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text7
        '
        Me.Text7.BackColor = System.Drawing.Color.White
        Me.Text7.BorderColor = System.Drawing.Color.Black
        Me.Text7.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text7.ForeColor = System.Drawing.Color.Black
        Me.Text7.LocationFloat = New DevExpress.Utils.PointFloat(446.7084!, 132.0!)
        Me.Text7.Name = "Text7"
        Me.Text7.SizeF = New System.Drawing.SizeF(193.5833!, 19.00002!)
        Me.Text7.Text = "[agenteDomiciliario]"
        Me.Text7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text8
        '
        Me.Text8.BackColor = System.Drawing.Color.White
        Me.Text8.BorderColor = System.Drawing.Color.Black
        Me.Text8.CanGrow = False
        Me.Text8.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text8.ForeColor = System.Drawing.Color.Black
        Me.Text8.LocationFloat = New DevExpress.Utils.PointFloat(16.0!, 164.0!)
        Me.Text8.Name = "Text8"
        Me.Text8.SizeF = New System.Drawing.SizeF(58.0!, 15.0!)
        Me.Text8.Text = "Cedula:"
        Me.Text8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text9
        '
        Me.Text9.BackColor = System.Drawing.Color.White
        Me.Text9.BorderColor = System.Drawing.Color.Black
        Me.Text9.CanGrow = False
        Me.Text9.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text9.ForeColor = System.Drawing.Color.Black
        Me.Text9.LocationFloat = New DevExpress.Utils.PointFloat(81.0!, 161.0!)
        Me.Text9.Name = "Text9"
        Me.Text9.SizeF = New System.Drawing.SizeF(114.0!, 17.0!)
        Me.Text9.Text = "[cedulaAgente]"
        Me.Text9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text10
        '
        Me.Text10.BackColor = System.Drawing.Color.White
        Me.Text10.BorderColor = System.Drawing.Color.Black
        Me.Text10.CanGrow = False
        Me.Text10.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text10.ForeColor = System.Drawing.Color.Black
        Me.Text10.LocationFloat = New DevExpress.Utils.PointFloat(208.0!, 164.0!)
        Me.Text10.Name = "Text10"
        Me.Text10.SizeF = New System.Drawing.SizeF(58.0!, 15.0!)
        Me.Text10.Text = "Teléfono:"
        Me.Text10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text11
        '
        Me.Text11.BackColor = System.Drawing.Color.White
        Me.Text11.BorderColor = System.Drawing.Color.Black
        Me.Text11.CanGrow = False
        Me.Text11.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text11.ForeColor = System.Drawing.Color.Black
        Me.Text11.LocationFloat = New DevExpress.Utils.PointFloat(275.0!, 161.0!)
        Me.Text11.Name = "Text11"
        Me.Text11.SizeF = New System.Drawing.SizeF(108.0!, 18.0!)
        Me.Text11.Text = "[telefonoAgente]"
        Me.Text11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text12
        '
        Me.Text12.BackColor = System.Drawing.Color.White
        Me.Text12.BorderColor = System.Drawing.Color.Black
        Me.Text12.CanGrow = False
        Me.Text12.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text12.ForeColor = System.Drawing.Color.Black
        Me.Text12.LocationFloat = New DevExpress.Utils.PointFloat(408.0!, 164.0!)
        Me.Text12.Name = "Text12"
        Me.Text12.SizeF = New System.Drawing.SizeF(41.0!, 15.0!)
        Me.Text12.Text = "Placa:"
        Me.Text12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text13
        '
        Me.Text13.BackColor = System.Drawing.Color.White
        Me.Text13.BorderColor = System.Drawing.Color.Black
        Me.Text13.CanGrow = False
        Me.Text13.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text13.ForeColor = System.Drawing.Color.Black
        Me.Text13.LocationFloat = New DevExpress.Utils.PointFloat(458.0!, 161.0!)
        Me.Text13.Name = "Text13"
        Me.Text13.SizeF = New System.Drawing.SizeF(87.00003!, 17.0!)
        Me.Text13.Text = "[placa]"
        Me.Text13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Line1
        '
        Me.Line1.BackColor = System.Drawing.Color.White
        Me.Line1.BorderColor = System.Drawing.Color.Black
        Me.Line1.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line1.ForeColor = System.Drawing.Color.Black
        Me.Line1.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 128.0!)
        Me.Line1.Name = "Line1"
        Me.Line1.SizeF = New System.Drawing.SizeF(638.0!, 2.0!)
        '
        'Line2
        '
        Me.Line2.BackColor = System.Drawing.Color.White
        Me.Line2.BorderColor = System.Drawing.Color.Black
        Me.Line2.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line2.ForeColor = System.Drawing.Color.Black
        Me.Line2.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 181.0!)
        Me.Line2.Name = "Line2"
        Me.Line2.SizeF = New System.Drawing.SizeF(638.0!, 2.0!)
        '
        'Line8
        '
        Me.Line8.BackColor = System.Drawing.Color.White
        Me.Line8.BorderColor = System.Drawing.Color.Black
        Me.Line8.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line8.ForeColor = System.Drawing.Color.Black
        Me.Line8.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line8.LocationFloat = New DevExpress.Utils.PointFloat(7.0!, 128.0!)
        Me.Line8.Name = "Line8"
        Me.Line8.SizeF = New System.Drawing.SizeF(2.0!, 53.0!)
        '
        'Line9
        '
        Me.Line9.BackColor = System.Drawing.Color.White
        Me.Line9.BorderColor = System.Drawing.Color.Black
        Me.Line9.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line9.ForeColor = System.Drawing.Color.Black
        Me.Line9.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line9.LocationFloat = New DevExpress.Utils.PointFloat(645.2917!, 128.0!)
        Me.Line9.Name = "Line9"
        Me.Line9.SizeF = New System.Drawing.SizeF(2.0!, 54.0!)
        '
        'Line10
        '
        Me.Line10.BackColor = System.Drawing.Color.White
        Me.Line10.BorderColor = System.Drawing.Color.Black
        Me.Line10.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line10.ForeColor = System.Drawing.Color.Black
        Me.Line10.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 156.0!)
        Me.Line10.Name = "Line10"
        Me.Line10.SizeF = New System.Drawing.SizeF(638.0!, 2.0!)
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.Line21, Me.Text30})
        Me.PageFooter.HeightF = 41.0!
        Me.PageFooter.Name = "PageFooter"
        '
        'Line21
        '
        Me.Line21.BackColor = System.Drawing.Color.White
        Me.Line21.BorderColor = System.Drawing.Color.Black
        Me.Line21.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.Line21.ForeColor = System.Drawing.Color.Black
        Me.Line21.LocationFloat = New DevExpress.Utils.PointFloat(791.0!, 33.0!)
        Me.Line21.Name = "Line21"
        Me.Line21.SizeF = New System.Drawing.SizeF(195.0!, 2.0!)
        '
        'Text30
        '
        Me.Text30.BackColor = System.Drawing.Color.White
        Me.Text30.BorderColor = System.Drawing.Color.Black
        Me.Text30.CanGrow = False
        Me.Text30.Font = New System.Drawing.Font("Arial", 14.0!)
        Me.Text30.ForeColor = System.Drawing.Color.Black
        Me.Text30.LocationFloat = New DevExpress.Utils.PointFloat(733.0!, 13.0!)
        Me.Text30.Name = "Text30"
        Me.Text30.SizeF = New System.Drawing.SizeF(58.0!, 25.0!)
        Me.Text30.Text = "Firma:"
        Me.Text30.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'DsReporteHojadeRuta1
        '
        Me.DsReporteHojadeRuta1.DataSetName = "dsReporteHojadeRuta"
        Me.DsReporteHojadeRuta1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'TopMarginBand1
        '
        Me.TopMarginBand1.HeightF = 59.0!
        Me.TopMarginBand1.Name = "TopMarginBand1"
        '
        'BottomMarginBand1
        '
        Me.BottomMarginBand1.HeightF = 25.0!
        Me.BottomMarginBand1.Name = "BottomMarginBand1"
        '
        'ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter
        '
        Me.ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter.ClearBeforeFill = True
        '
        'HojadeRutaSerializada
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.GroupHeader1, Me.ReportHeader, Me.PageFooter, Me.TopMarginBand1, Me.BottomMarginBand1})
        Me.DataAdapter = Me.ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter
        Me.DataMember = "ObtenerInfoHojaRutaMensajeriaSerializada"
        Me.DataSource = Me.DsReporteHojadeRuta1
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(25, 25, 59, 25)
        Me.PageHeight = 850
        Me.PageWidth = 1100
        Me.ScriptLanguage = DevExpress.XtraReports.ScriptLanguage.VisualBasic
        Me.Version = "12.2"
        CType(Me.DsReporteHojadeRuta1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Line5 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents Text14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text15 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text16 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text17 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text20 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text18 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text19 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Line3 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line11 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line12 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line14 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line15 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line16 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line17 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line18 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line19 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line20 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line6 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents ReportHeader As DevExpress.XtraReports.UI.ReportHeaderBand
    Friend WithEvents Text1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Line1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line8 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line9 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line10 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents PageFooter As DevExpress.XtraReports.UI.PageFooterBand
    Friend WithEvents Line21 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Text30 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DsReporteHojadeRuta1 As BPColSysOP.dsReporteHojadeRuta
    Friend WithEvents TopMarginBand1 As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMarginBand1 As DevExpress.XtraReports.UI.BottomMarginBand
    Private WithEvents Picture5 As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter As BPColSysOP.dsReporteHojadeRutaTableAdapters.ObtenerInfoHojaRutaMensajeriaSerializadaTableAdapter
    Friend WithEvents XrBarCode1 As DevExpress.XtraReports.UI.XRBarCode
    Friend WithEvents XrLabel1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLine8 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine7 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine6 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine5 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine4 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine3 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine9 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLabel3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text24 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text25 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text26 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text27 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLabel4 As DevExpress.XtraReports.UI.XRLabel
    Private WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
End Class
