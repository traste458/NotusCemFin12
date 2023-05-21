<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class XtReporteHojaRutaRecoleccion
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(XtReporteHojaRutaRecoleccion))
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.XrLine5 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine2 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLine3 = New DevExpress.XtraReports.UI.XRLine()
        Me.XrLserialPrestamo = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLrequierePrestamoEquipo = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLmsisdn = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLSerial = New DevExpress.XtraReports.UI.XRLabel()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        Me.XrLine4 = New DevExpress.XtraReports.UI.XRLine()
        Me.Line32 = New DevExpress.XtraReports.UI.XRLine()
        Me.numeroRadicado1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.empresa1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.secuencia1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.contacto1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.direccion1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.telefono1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text20 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text22 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.XrLine1 = New DevExpress.XtraReports.UI.XRLine()
        Me.ReportHeader = New DevExpress.XtraReports.UI.ReportHeaderBand()
        Me.XrBarCode1 = New DevExpress.XtraReports.UI.XRBarCode()
        Me.Picture5 = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.Text1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text15 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Fechadecreacióndelarchivo1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.PageHeader = New DevExpress.XtraReports.UI.PageHeaderBand()
        Me.Text2 = New DevExpress.XtraReports.UI.XRLabel()
        Me.fechaCreacion1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.agenteDomiciliario1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.telefonoAgente1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.placa1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text11 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.cedulaAgente1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text16 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text17 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text18 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text19 = New DevExpress.XtraReports.UI.XRLabel()
        Me.PageFooter = New DevExpress.XtraReports.UI.PageFooterBand()
        Me.PáginaNdeM1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.DsHojaRutaRecoleccion = New BPColSysOP.dsHojaRutaRecoleccion()
        Me.ObtenerInfoHojaRutaMensajeriaTableAdapter = New BPColSysOP.dsHojaRutaRecoleccionTableAdapters.ObtenerInfoHojaRutaMensajeriaTableAdapter()
        Me.TopMarginBand1 = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMarginBand1 = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter = New BPColSysOP.dsHojaRutaRecoleccionTableAdapters.ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter()
        CType(Me.DsHojaRutaRecoleccion, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLine5, Me.XrLine2, Me.XrLine3, Me.XrLserialPrestamo, Me.XrLrequierePrestamoEquipo, Me.XrLmsisdn, Me.XrLSerial})
        Me.Detail.HeightF = 25.5!
        Me.Detail.Name = "Detail"
        '
        'XrLine5
        '
        Me.XrLine5.BackColor = System.Drawing.Color.White
        Me.XrLine5.BorderColor = System.Drawing.Color.Black
        Me.XrLine5.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine5.ForeColor = System.Drawing.Color.Black
        Me.XrLine5.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine5.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 0.0!)
        Me.XrLine5.Name = "XrLine5"
        Me.XrLine5.SizeF = New System.Drawing.SizeF(2.0!, 24.0!)
        '
        'XrLine2
        '
        Me.XrLine2.BackColor = System.Drawing.Color.White
        Me.XrLine2.BorderColor = System.Drawing.Color.Black
        Me.XrLine2.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine2.ForeColor = System.Drawing.Color.Black
        Me.XrLine2.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine2.LocationFloat = New DevExpress.Utils.PointFloat(1037.5!, 0.0!)
        Me.XrLine2.Name = "XrLine2"
        Me.XrLine2.SizeF = New System.Drawing.SizeF(2.0!, 25.0!)
        '
        'XrLine3
        '
        Me.XrLine3.BackColor = System.Drawing.Color.White
        Me.XrLine3.BorderColor = System.Drawing.Color.Gray
        Me.XrLine3.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLine3.ForeColor = System.Drawing.Color.Black
        Me.XrLine3.LocationFloat = New DevExpress.Utils.PointFloat(12.0!, 23.5!)
        Me.XrLine3.Name = "XrLine3"
        Me.XrLine3.SizeF = New System.Drawing.SizeF(1027.0!, 2.0!)
        '
        'XrLserialPrestamo
        '
        Me.XrLserialPrestamo.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneInfoRutaRecoleccionClienteServicioTecnico.serialPrestamo")})
        Me.XrLserialPrestamo.LocationFloat = New DevExpress.Utils.PointFloat(520.5!, 5.0!)
        Me.XrLserialPrestamo.Name = "XrLserialPrestamo"
        Me.XrLserialPrestamo.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLserialPrestamo.SizeF = New System.Drawing.SizeF(156.0!, 17.0!)
        Me.XrLserialPrestamo.Text = "XrLserialPrestamo"
        '
        'XrLrequierePrestamoEquipo
        '
        Me.XrLrequierePrestamoEquipo.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneInfoRutaRecoleccionClienteServicioTecnico.requierePrestamoEquipo")})
        Me.XrLrequierePrestamoEquipo.LocationFloat = New DevExpress.Utils.PointFloat(358.0!, 5.0!)
        Me.XrLrequierePrestamoEquipo.Name = "XrLrequierePrestamoEquipo"
        Me.XrLrequierePrestamoEquipo.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLrequierePrestamoEquipo.SizeF = New System.Drawing.SizeF(76.0!, 17.0!)
        Me.XrLrequierePrestamoEquipo.Text = "XrLrequierePrestamoEquipo"
        '
        'XrLmsisdn
        '
        Me.XrLmsisdn.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneInfoRutaRecoleccionClienteServicioTecnico.msisdn")})
        Me.XrLmsisdn.LocationFloat = New DevExpress.Utils.PointFloat(195.5!, 5.0!)
        Me.XrLmsisdn.Name = "XrLmsisdn"
        Me.XrLmsisdn.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLmsisdn.SizeF = New System.Drawing.SizeF(139.0!, 17.0!)
        Me.XrLmsisdn.Text = "XrLmsisdn"
        '
        'XrLSerial
        '
        Me.XrLSerial.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneInfoRutaRecoleccionClienteServicioTecnico.serial")})
        Me.XrLSerial.LocationFloat = New DevExpress.Utils.PointFloat(33.0!, 5.0!)
        Me.XrLSerial.Name = "XrLSerial"
        Me.XrLSerial.Padding = New DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100.0!)
        Me.XrLSerial.SizeF = New System.Drawing.SizeF(156.0!, 17.0!)
        Me.XrLSerial.Text = "XrLSerial"
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrLine4, Me.Line32, Me.numeroRadicado1, Me.empresa1, Me.secuencia1, Me.Text9, Me.Text10, Me.contacto1, Me.direccion1, Me.telefono1, Me.Text20, Me.Text22, Me.Text8, Me.Text13, Me.XrLine1})
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("idServicioMensajeria", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 43.6250191!
        Me.GroupHeader1.Name = "GroupHeader1"
        '
        'XrLine4
        '
        Me.XrLine4.BackColor = System.Drawing.Color.White
        Me.XrLine4.BorderColor = System.Drawing.Color.Black
        Me.XrLine4.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.XrLine4.ForeColor = System.Drawing.Color.Black
        Me.XrLine4.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.XrLine4.LocationFloat = New DevExpress.Utils.PointFloat(12.5!, 0.0!)
        Me.XrLine4.Name = "XrLine4"
        Me.XrLine4.SizeF = New System.Drawing.SizeF(2.0!, 43.6250191!)
        '
        'Line32
        '
        Me.Line32.BackColor = System.Drawing.Color.White
        Me.Line32.BorderColor = System.Drawing.Color.Black
        Me.Line32.Borders = DevExpress.XtraPrinting.BorderSide.Left
        Me.Line32.ForeColor = System.Drawing.Color.Black
        Me.Line32.LineDirection = DevExpress.XtraReports.UI.LineDirection.Vertical
        Me.Line32.LocationFloat = New DevExpress.Utils.PointFloat(1037.5!, 0.0!)
        Me.Line32.Name = "Line32"
        Me.Line32.SizeF = New System.Drawing.SizeF(2.0!, 43.6250191!)
        '
        'numeroRadicado1
        '
        Me.numeroRadicado1.BackColor = System.Drawing.Color.White
        Me.numeroRadicado1.BorderColor = System.Drawing.Color.Black
        Me.numeroRadicado1.CanGrow = False
        Me.numeroRadicado1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria;1.numeroRadicado")})
        Me.numeroRadicado1.Font = New System.Drawing.Font("Arial", 10.0!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Underline), System.Drawing.FontStyle))
        Me.numeroRadicado1.ForeColor = System.Drawing.Color.Black
        Me.numeroRadicado1.LocationFloat = New DevExpress.Utils.PointFloat(16.0!, 6.62501907!)
        Me.numeroRadicado1.Name = "numeroRadicado1"
        Me.numeroRadicado1.SizeF = New System.Drawing.SizeF(112.0!, 16.0!)
        Me.numeroRadicado1.Text = "[numeroRadicado]"
        Me.numeroRadicado1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'empresa1
        '
        Me.empresa1.BackColor = System.Drawing.Color.White
        Me.empresa1.BorderColor = System.Drawing.Color.Black
        Me.empresa1.CanGrow = False
        Me.empresa1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria;1.empresa")})
        Me.empresa1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.empresa1.ForeColor = System.Drawing.Color.Black
        Me.empresa1.LocationFloat = New DevExpress.Utils.PointFloat(183.0!, 6.62501907!)
        Me.empresa1.Name = "empresa1"
        Me.empresa1.SizeF = New System.Drawing.SizeF(141.0!, 15.0!)
        Me.empresa1.Text = "[empresa]"
        Me.empresa1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'secuencia1
        '
        Me.secuencia1.BackColor = System.Drawing.Color.White
        Me.secuencia1.BorderColor = System.Drawing.Color.Black
        Me.secuencia1.CanGrow = False
        Me.secuencia1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria;1.secuencia")})
        Me.secuencia1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.secuencia1.ForeColor = System.Drawing.Color.Black
        Me.secuencia1.LocationFloat = New DevExpress.Utils.PointFloat(133.0!, 6.62501907!)
        Me.secuencia1.Name = "secuencia1"
        Me.secuencia1.SizeF = New System.Drawing.SizeF(41.0!, 15.0!)
        Me.secuencia1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text9
        '
        Me.Text9.BackColor = System.Drawing.Color.White
        Me.Text9.BorderColor = System.Drawing.Color.Black
        Me.Text9.CanGrow = False
        Me.Text9.Font = New System.Drawing.Font("Arial", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Text9.ForeColor = System.Drawing.Color.Gray
        Me.Text9.LocationFloat = New DevExpress.Utils.PointFloat(33.0!, 28.6250191!)
        Me.Text9.Name = "Text9"
        Me.Text9.SizeF = New System.Drawing.SizeF(129.0!, 15.0!)
        Me.Text9.Text = "IMEI"
        Me.Text9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text10
        '
        Me.Text10.BackColor = System.Drawing.Color.White
        Me.Text10.BorderColor = System.Drawing.Color.Black
        Me.Text10.CanGrow = False
        Me.Text10.Font = New System.Drawing.Font("Arial", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Text10.ForeColor = System.Drawing.Color.Gray
        Me.Text10.LocationFloat = New DevExpress.Utils.PointFloat(191.0!, 28.6250191!)
        Me.Text10.Name = "Text10"
        Me.Text10.SizeF = New System.Drawing.SizeF(129.0!, 15.0!)
        Me.Text10.Text = "MSISDN"
        Me.Text10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'contacto1
        '
        Me.contacto1.BackColor = System.Drawing.Color.White
        Me.contacto1.BorderColor = System.Drawing.Color.Black
        Me.contacto1.CanGrow = False
        Me.contacto1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.contacto")})
        Me.contacto1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.contacto1.ForeColor = System.Drawing.Color.Black
        Me.contacto1.LocationFloat = New DevExpress.Utils.PointFloat(333.0!, 6.62501907!)
        Me.contacto1.Name = "contacto1"
        Me.contacto1.SizeF = New System.Drawing.SizeF(157.0!, 15.0!)
        Me.contacto1.Text = "contacto1"
        Me.contacto1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'direccion1
        '
        Me.direccion1.BackColor = System.Drawing.Color.White
        Me.direccion1.BorderColor = System.Drawing.Color.Black
        Me.direccion1.CanGrow = False
        Me.direccion1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria;1.direccion")})
        Me.direccion1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.direccion1.ForeColor = System.Drawing.Color.Black
        Me.direccion1.LocationFloat = New DevExpress.Utils.PointFloat(500.0!, 6.62501907!)
        Me.direccion1.Name = "direccion1"
        Me.direccion1.SizeF = New System.Drawing.SizeF(151.0!, 15.0!)
        Me.direccion1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'telefono1
        '
        Me.telefono1.BackColor = System.Drawing.Color.White
        Me.telefono1.BorderColor = System.Drawing.Color.Black
        Me.telefono1.CanGrow = False
        Me.telefono1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria;1.telefono")})
        Me.telefono1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.telefono1.ForeColor = System.Drawing.Color.Black
        Me.telefono1.LocationFloat = New DevExpress.Utils.PointFloat(658.0!, 6.62501907!)
        Me.telefono1.Name = "telefono1"
        Me.telefono1.SizeF = New System.Drawing.SizeF(133.0!, 15.0!)
        Me.telefono1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text20
        '
        Me.Text20.BackColor = System.Drawing.Color.White
        Me.Text20.BorderColor = System.Drawing.Color.Black
        Me.Text20.CanGrow = False
        Me.Text20.Font = New System.Drawing.Font("Arial", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Text20.ForeColor = System.Drawing.Color.Gray
        Me.Text20.LocationFloat = New DevExpress.Utils.PointFloat(341.0!, 28.6250191!)
        Me.Text20.Name = "Text20"
        Me.Text20.SizeF = New System.Drawing.SizeF(128.0!, 15.0!)
        Me.Text20.Text = "Requiere Prestamo?"
        Me.Text20.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text22
        '
        Me.Text22.BackColor = System.Drawing.Color.White
        Me.Text22.BorderColor = System.Drawing.Color.Black
        Me.Text22.CanGrow = False
        Me.Text22.Font = New System.Drawing.Font("Arial", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Text22.ForeColor = System.Drawing.Color.Gray
        Me.Text22.LocationFloat = New DevExpress.Utils.PointFloat(508.0!, 28.6250191!)
        Me.Text22.Name = "Text22"
        Me.Text22.SizeF = New System.Drawing.SizeF(138.0!, 15.0!)
        Me.Text22.Text = "Serial Préstamo"
        Me.Text22.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text8
        '
        Me.Text8.BackColor = System.Drawing.Color.White
        Me.Text8.BorderColor = System.Drawing.Color.Black
        Me.Text8.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.Text8.CanGrow = False
        Me.Text8.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text8.ForeColor = System.Drawing.Color.Black
        Me.Text8.LocationFloat = New DevExpress.Utils.PointFloat(800.0!, 19.6250191!)
        Me.Text8.Name = "Text8"
        Me.Text8.SizeF = New System.Drawing.SizeF(142.0!, 13.0!)
        Me.Text8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text13
        '
        Me.Text13.BackColor = System.Drawing.Color.White
        Me.Text13.BorderColor = System.Drawing.Color.Black
        Me.Text13.Borders = DevExpress.XtraPrinting.BorderSide.Bottom
        Me.Text13.CanGrow = False
        Me.Text13.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.Text13.ForeColor = System.Drawing.Color.Black
        Me.Text13.LocationFloat = New DevExpress.Utils.PointFloat(946.0!, 19.6250191!)
        Me.Text13.Name = "Text13"
        Me.Text13.SizeF = New System.Drawing.SizeF(85.0!, 13.0!)
        Me.Text13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'XrLine1
        '
        Me.XrLine1.BackColor = System.Drawing.Color.White
        Me.XrLine1.BorderColor = System.Drawing.Color.Gray
        Me.XrLine1.Borders = DevExpress.XtraPrinting.BorderSide.Top
        Me.XrLine1.ForeColor = System.Drawing.Color.Gray
        Me.XrLine1.LocationFloat = New DevExpress.Utils.PointFloat(12.0!, 0.0!)
        Me.XrLine1.Name = "XrLine1"
        Me.XrLine1.SizeF = New System.Drawing.SizeF(1025.0!, 2.0!)
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrBarCode1, Me.Picture5, Me.Text1, Me.Text15, Me.Fechadecreacióndelarchivo1})
        Me.ReportHeader.HeightF = 112.624901!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'XrBarCode1
        '
        Me.XrBarCode1.Font = New System.Drawing.Font("Times New Roman", 20.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrBarCode1.LocationFloat = New DevExpress.Utils.PointFloat(735.958313!, 6.0!)
        Me.XrBarCode1.Name = "XrBarCode1"
        Me.XrBarCode1.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 10, 0, 0, 100.0!)
        Me.XrBarCode1.SizeF = New System.Drawing.SizeF(301.041687!, 69.7916565!)
        Me.XrBarCode1.StylePriority.UseFont = False
        Me.XrBarCode1.Symbology = Code128Generator1
        Me.XrBarCode1.Text = "[idRuta]"
        '
        'Picture5
        '
        Me.Picture5.BackColor = System.Drawing.Color.White
        Me.Picture5.BorderColor = System.Drawing.Color.Black
        Me.Picture5.Image = CType(resources.GetObject("Picture5.Image"), System.Drawing.Image)
        Me.Picture5.LocationFloat = New DevExpress.Utils.PointFloat(16.0!, 7.0!)
        Me.Picture5.Name = "Picture5"
        Me.Picture5.SizeF = New System.Drawing.SizeF(225.0!, 84.4999466!)
        Me.Picture5.Sizing = DevExpress.XtraPrinting.ImageSizeMode.StretchImage
        '
        'Text1
        '
        Me.Text1.BackColor = System.Drawing.Color.White
        Me.Text1.BorderColor = System.Drawing.Color.Black
        Me.Text1.CanGrow = False
        Me.Text1.Font = New System.Drawing.Font("Arial", 18.0!)
        Me.Text1.ForeColor = System.Drawing.Color.Black
        Me.Text1.LocationFloat = New DevExpress.Utils.PointFloat(262.0!, 25.0!)
        Me.Text1.Name = "Text1"
        Me.Text1.SizeF = New System.Drawing.SizeF(450.0!, 33.0!)
        Me.Text1.Text = "Ruta Recolección Servicio Técnico No.:"
        Me.Text1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text15
        '
        Me.Text15.BackColor = System.Drawing.Color.White
        Me.Text15.BorderColor = System.Drawing.Color.Black
        Me.Text15.CanGrow = False
        Me.Text15.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Italic)
        Me.Text15.ForeColor = System.Drawing.Color.Black
        Me.Text15.LocationFloat = New DevExpress.Utils.PointFloat(766.0!, 85.0!)
        Me.Text15.Name = "Text15"
        Me.Text15.SizeF = New System.Drawing.SizeF(108.0!, 15.0!)
        Me.Text15.Text = "Fecha de Impresión:"
        Me.Text15.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Fechadecreacióndelarchivo1
        '
        Me.Fechadecreacióndelarchivo1.BackColor = System.Drawing.Color.White
        Me.Fechadecreacióndelarchivo1.BorderColor = System.Drawing.Color.Black
        Me.Fechadecreacióndelarchivo1.CanGrow = False
        Me.Fechadecreacióndelarchivo1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Italic)
        Me.Fechadecreacióndelarchivo1.ForeColor = System.Drawing.Color.Black
        Me.Fechadecreacióndelarchivo1.LocationFloat = New DevExpress.Utils.PointFloat(875.0!, 85.0!)
        Me.Fechadecreacióndelarchivo1.Name = "Fechadecreacióndelarchivo1"
        Me.Fechadecreacióndelarchivo1.SizeF = New System.Drawing.SizeF(164.0!, 12.0!)
        Me.Fechadecreacióndelarchivo1.Text = "Untranslated"
        Me.Fechadecreacióndelarchivo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.Text2, Me.fechaCreacion1, Me.Text3, Me.Text4, Me.agenteDomiciliario1, Me.Text5, Me.Text6, Me.telefonoAgente1, Me.placa1, Me.Text7, Me.Text11, Me.Text12, Me.Text14, Me.cedulaAgente1, Me.Text16, Me.Text17, Me.Text18, Me.Text19})
        Me.PageHeader.HeightF = 111.958298!
        Me.PageHeader.Name = "PageHeader"
        '
        'Text2
        '
        Me.Text2.BackColor = System.Drawing.Color.White
        Me.Text2.BorderColor = System.Drawing.Color.Black
        Me.Text2.CanGrow = False
        Me.Text2.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text2.ForeColor = System.Drawing.Color.Black
        Me.Text2.LocationFloat = New DevExpress.Utils.PointFloat(84.0!, 21.0!)
        Me.Text2.Name = "Text2"
        Me.Text2.SizeF = New System.Drawing.SizeF(58.0!, 15.0!)
        Me.Text2.Text = "Fecha:"
        Me.Text2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'fechaCreacion1
        '
        Me.fechaCreacion1.BackColor = System.Drawing.Color.White
        Me.fechaCreacion1.BorderColor = System.Drawing.Color.Black
        Me.fechaCreacion1.CanGrow = False
        Me.fechaCreacion1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.fechaCreacion")})
        Me.fechaCreacion1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.fechaCreacion1.ForeColor = System.Drawing.Color.Black
        Me.fechaCreacion1.LocationFloat = New DevExpress.Utils.PointFloat(159.0!, 21.0!)
        Me.fechaCreacion1.Name = "fechaCreacion1"
        Me.fechaCreacion1.SizeF = New System.Drawing.SizeF(145.0!, 15.0!)
        Me.fechaCreacion1.Text = "fechaCreacion1"
        Me.fechaCreacion1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text3
        '
        Me.Text3.BackColor = System.Drawing.Color.White
        Me.Text3.BorderColor = System.Drawing.Color.Black
        Me.Text3.CanGrow = False
        Me.Text3.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text3.ForeColor = System.Drawing.Color.Black
        Me.Text3.LocationFloat = New DevExpress.Utils.PointFloat(84.0!, 46.0!)
        Me.Text3.Name = "Text3"
        Me.Text3.SizeF = New System.Drawing.SizeF(58.0!, 15.0!)
        Me.Text3.Text = "Cédula:"
        Me.Text3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text4
        '
        Me.Text4.BackColor = System.Drawing.Color.White
        Me.Text4.BorderColor = System.Drawing.Color.Black
        Me.Text4.CanGrow = False
        Me.Text4.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text4.ForeColor = System.Drawing.Color.Black
        Me.Text4.LocationFloat = New DevExpress.Utils.PointFloat(317.0!, 21.0!)
        Me.Text4.Name = "Text4"
        Me.Text4.SizeF = New System.Drawing.SizeF(191.0!, 15.0!)
        Me.Text4.Text = "Nombre agente domiciliario:"
        Me.Text4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'agenteDomiciliario1
        '
        Me.agenteDomiciliario1.BackColor = System.Drawing.Color.White
        Me.agenteDomiciliario1.BorderColor = System.Drawing.Color.Black
        Me.agenteDomiciliario1.CanGrow = False
        Me.agenteDomiciliario1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.agenteDomiciliario")})
        Me.agenteDomiciliario1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.agenteDomiciliario1.ForeColor = System.Drawing.Color.Black
        Me.agenteDomiciliario1.LocationFloat = New DevExpress.Utils.PointFloat(517.0!, 21.0!)
        Me.agenteDomiciliario1.Name = "agenteDomiciliario1"
        Me.agenteDomiciliario1.SizeF = New System.Drawing.SizeF(341.0!, 15.0!)
        Me.agenteDomiciliario1.Text = "agenteDomiciliario1"
        Me.agenteDomiciliario1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text5
        '
        Me.Text5.BackColor = System.Drawing.Color.White
        Me.Text5.BorderColor = System.Drawing.Color.Black
        Me.Text5.CanGrow = False
        Me.Text5.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text5.ForeColor = System.Drawing.Color.Black
        Me.Text5.LocationFloat = New DevExpress.Utils.PointFloat(317.0!, 46.0!)
        Me.Text5.Name = "Text5"
        Me.Text5.SizeF = New System.Drawing.SizeF(83.0!, 15.0!)
        Me.Text5.Text = "Teléfono:"
        Me.Text5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text6
        '
        Me.Text6.BackColor = System.Drawing.Color.White
        Me.Text6.BorderColor = System.Drawing.Color.Black
        Me.Text6.CanGrow = False
        Me.Text6.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text6.ForeColor = System.Drawing.Color.Black
        Me.Text6.LocationFloat = New DevExpress.Utils.PointFloat(517.0!, 46.0!)
        Me.Text6.Name = "Text6"
        Me.Text6.SizeF = New System.Drawing.SizeF(50.0!, 15.0!)
        Me.Text6.Text = "Placa:"
        Me.Text6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'telefonoAgente1
        '
        Me.telefonoAgente1.BackColor = System.Drawing.Color.White
        Me.telefonoAgente1.BorderColor = System.Drawing.Color.Black
        Me.telefonoAgente1.CanGrow = False
        Me.telefonoAgente1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.telefonoAgente")})
        Me.telefonoAgente1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.telefonoAgente1.ForeColor = System.Drawing.Color.Black
        Me.telefonoAgente1.LocationFloat = New DevExpress.Utils.PointFloat(409.0!, 46.0!)
        Me.telefonoAgente1.Name = "telefonoAgente1"
        Me.telefonoAgente1.SizeF = New System.Drawing.SizeF(100.0!, 15.0!)
        Me.telefonoAgente1.Text = "telefonoAgente1"
        Me.telefonoAgente1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'placa1
        '
        Me.placa1.BackColor = System.Drawing.Color.White
        Me.placa1.BorderColor = System.Drawing.Color.Black
        Me.placa1.CanGrow = False
        Me.placa1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.placa")})
        Me.placa1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.placa1.ForeColor = System.Drawing.Color.Black
        Me.placa1.LocationFloat = New DevExpress.Utils.PointFloat(576.0!, 46.0!)
        Me.placa1.Name = "placa1"
        Me.placa1.SizeF = New System.Drawing.SizeF(91.0!, 15.0!)
        Me.placa1.Text = "placa1"
        Me.placa1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text7
        '
        Me.Text7.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text7.BorderColor = System.Drawing.Color.Gray
        Me.Text7.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text7.CanGrow = False
        Me.Text7.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text7.ForeColor = System.Drawing.Color.Black
        Me.Text7.LocationFloat = New DevExpress.Utils.PointFloat(2.0!, 94.0!)
        Me.Text7.Name = "Text7"
        Me.Text7.SizeF = New System.Drawing.SizeF(122.0!, 15.0!)
        Me.Text7.Text = "Radicado"
        Me.Text7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text11
        '
        Me.Text11.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text11.BorderColor = System.Drawing.Color.Gray
        Me.Text11.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text11.CanGrow = False
        Me.Text11.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text11.ForeColor = System.Drawing.Color.Black
        Me.Text11.LocationFloat = New DevExpress.Utils.PointFloat(133.0!, 94.0!)
        Me.Text11.Name = "Text11"
        Me.Text11.SizeF = New System.Drawing.SizeF(41.0!, 15.0!)
        Me.Text11.Text = "Sec."
        Me.Text11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text12
        '
        Me.Text12.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text12.BorderColor = System.Drawing.Color.Gray
        Me.Text12.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text12.CanGrow = False
        Me.Text12.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text12.ForeColor = System.Drawing.Color.Black
        Me.Text12.LocationFloat = New DevExpress.Utils.PointFloat(183.0!, 94.0!)
        Me.Text12.Name = "Text12"
        Me.Text12.SizeF = New System.Drawing.SizeF(141.0!, 15.0!)
        Me.Text12.Text = "Empresa"
        Me.Text12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text14
        '
        Me.Text14.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text14.BorderColor = System.Drawing.Color.Gray
        Me.Text14.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text14.CanGrow = False
        Me.Text14.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text14.ForeColor = System.Drawing.Color.Black
        Me.Text14.LocationFloat = New DevExpress.Utils.PointFloat(333.0!, 94.0!)
        Me.Text14.Name = "Text14"
        Me.Text14.SizeF = New System.Drawing.SizeF(158.0!, 15.0!)
        Me.Text14.Text = "Contacto"
        Me.Text14.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'cedulaAgente1
        '
        Me.cedulaAgente1.BackColor = System.Drawing.Color.White
        Me.cedulaAgente1.BorderColor = System.Drawing.Color.Black
        Me.cedulaAgente1.CanGrow = False
        Me.cedulaAgente1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.cedulaAgente")})
        Me.cedulaAgente1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.cedulaAgente1.ForeColor = System.Drawing.Color.Black
        Me.cedulaAgente1.LocationFloat = New DevExpress.Utils.PointFloat(159.0!, 46.0!)
        Me.cedulaAgente1.Name = "cedulaAgente1"
        Me.cedulaAgente1.SizeF = New System.Drawing.SizeF(109.0!, 15.0!)
        Me.cedulaAgente1.Text = "cedulaAgente1"
        Me.cedulaAgente1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text16
        '
        Me.Text16.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text16.BorderColor = System.Drawing.Color.Gray
        Me.Text16.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text16.CanGrow = False
        Me.Text16.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text16.ForeColor = System.Drawing.Color.Black
        Me.Text16.LocationFloat = New DevExpress.Utils.PointFloat(500.0!, 94.0!)
        Me.Text16.Name = "Text16"
        Me.Text16.SizeF = New System.Drawing.SizeF(150.0!, 15.0!)
        Me.Text16.Text = "Dirección"
        Me.Text16.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text17
        '
        Me.Text17.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text17.BorderColor = System.Drawing.Color.Gray
        Me.Text17.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text17.CanGrow = False
        Me.Text17.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text17.ForeColor = System.Drawing.Color.Black
        Me.Text17.LocationFloat = New DevExpress.Utils.PointFloat(658.0!, 94.0!)
        Me.Text17.Name = "Text17"
        Me.Text17.SizeF = New System.Drawing.SizeF(133.0!, 15.0!)
        Me.Text17.Text = "Teléfono"
        Me.Text17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text18
        '
        Me.Text18.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text18.BorderColor = System.Drawing.Color.Gray
        Me.Text18.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text18.CanGrow = False
        Me.Text18.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text18.ForeColor = System.Drawing.Color.Black
        Me.Text18.LocationFloat = New DevExpress.Utils.PointFloat(800.0!, 94.0!)
        Me.Text18.Name = "Text18"
        Me.Text18.SizeF = New System.Drawing.SizeF(141.0!, 15.0!)
        Me.Text18.Text = "Nombre"
        Me.Text18.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'Text19
        '
        Me.Text19.BackColor = System.Drawing.Color.FromArgb(CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(216, Byte), Integer))
        Me.Text19.BorderColor = System.Drawing.Color.Gray
        Me.Text19.Borders = CType((((DevExpress.XtraPrinting.BorderSide.Left Or DevExpress.XtraPrinting.BorderSide.Top) _
            Or DevExpress.XtraPrinting.BorderSide.Right) _
            Or DevExpress.XtraPrinting.BorderSide.Bottom), DevExpress.XtraPrinting.BorderSide)
        Me.Text19.CanGrow = False
        Me.Text19.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text19.ForeColor = System.Drawing.Color.Black
        Me.Text19.LocationFloat = New DevExpress.Utils.PointFloat(952.0!, 94.0!)
        Me.Text19.Name = "Text19"
        Me.Text19.SizeF = New System.Drawing.SizeF(90.0!, 15.0!)
        Me.Text19.Text = "Firma"
        Me.Text19.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.PáginaNdeM1})
        Me.PageFooter.HeightF = 15.0!
        Me.PageFooter.Name = "PageFooter"
        '
        'PáginaNdeM1
        '
        Me.PáginaNdeM1.BackColor = System.Drawing.Color.White
        Me.PáginaNdeM1.BorderColor = System.Drawing.Color.Black
        Me.PáginaNdeM1.CanGrow = False
        Me.PáginaNdeM1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.PáginaNdeM1.ForeColor = System.Drawing.Color.Black
        Me.PáginaNdeM1.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 0.0!)
        Me.PáginaNdeM1.Name = "PáginaNdeM1"
        Me.PáginaNdeM1.SizeF = New System.Drawing.SizeF(1033.0!, 15.0!)
        Me.PáginaNdeM1.Text = "Untranslated"
        Me.PáginaNdeM1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'DsHojaRutaRecoleccion
        '
        Me.DsHojaRutaRecoleccion.DataSetName = "dsHojaRutaRecoleccion"
        Me.DsHojaRutaRecoleccion.EnforceConstraints = False
        Me.DsHojaRutaRecoleccion.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'ObtenerInfoHojaRutaMensajeriaTableAdapter
        '
        Me.ObtenerInfoHojaRutaMensajeriaTableAdapter.ClearBeforeFill = True
        '
        'TopMarginBand1
        '
        Me.TopMarginBand1.HeightF = 15.0!
        Me.TopMarginBand1.Name = "TopMarginBand1"
        '
        'BottomMarginBand1
        '
        Me.BottomMarginBand1.HeightF = 15.0!
        Me.BottomMarginBand1.Name = "BottomMarginBand1"
        '
        'ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter
        '
        Me.ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter.ClearBeforeFill = True
        '
        'XtReporteHojaRutaRecoleccion
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.GroupHeader1, Me.ReportHeader, Me.PageHeader, Me.PageFooter, Me.TopMarginBand1, Me.BottomMarginBand1})
        Me.DataAdapter = Me.ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter
        Me.DataMember = "ObtenerInfoHojaRutaMensajeria"
        Me.DataSource = Me.DsHojaRutaRecoleccion
        Me.Landscape = True
        Me.Margins = New System.Drawing.Printing.Margins(10, 10, 15, 15)
        Me.PageHeight = 850
        Me.PageWidth = 1100
        Me.ScriptLanguage = DevExpress.XtraReports.ScriptLanguage.VisualBasic
        Me.Version = "12.2"
        CType(Me.DsHojaRutaRecoleccion, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
    Friend WithEvents numeroRadicado1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents empresa1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents secuencia1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents contacto1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents direccion1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents telefono1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text20 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text22 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents ReportHeader As DevExpress.XtraReports.UI.ReportHeaderBand
    Friend WithEvents Text1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text15 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Fechadecreacióndelarchivo1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PageHeader As DevExpress.XtraReports.UI.PageHeaderBand
    Friend WithEvents Text2 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents fechaCreacion1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents agenteDomiciliario1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents telefonoAgente1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents placa1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents cedulaAgente1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text16 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text17 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text18 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text19 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PageFooter As DevExpress.XtraReports.UI.PageFooterBand
    Friend WithEvents PáginaNdeM1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents DsHojaRutaRecoleccion As BPColSysOP.dsHojaRutaRecoleccion
    Friend WithEvents ObtenerInfoHojaRutaMensajeriaTableAdapter As BPColSysOP.dsHojaRutaRecoleccionTableAdapters.ObtenerInfoHojaRutaMensajeriaTableAdapter
    Friend WithEvents XrBarCode1 As DevExpress.XtraReports.UI.XRBarCode
    Private WithEvents Picture5 As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents TopMarginBand1 As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMarginBand1 As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents XrLSerial As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLmsisdn As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLserialPrestamo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents XrLrequierePrestamoEquipo As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter As BPColSysOP.dsHojaRutaRecoleccionTableAdapters.ObtieneInfoRutaRecoleccionClienteServicioTecnicoTableAdapter
    Friend WithEvents XrLine3 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine1 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine5 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine2 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents XrLine4 As DevExpress.XtraReports.UI.XRLine
    Friend WithEvents Line32 As DevExpress.XtraReports.UI.XRLine
End Class
