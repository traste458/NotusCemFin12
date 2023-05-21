<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Public Class XtrOrdenDespachoServicioTecnico
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(XtrOrdenDespachoServicioTecnico))
        Me.Detail = New DevExpress.XtraReports.UI.DetailBand()
        Me.serial1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.msisdn1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text9 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text18 = New DevExpress.XtraReports.UI.XRLabel()
        Me.numeroRadicado1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.contacto1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.empresa1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.secuencia1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.ReportHeader = New DevExpress.XtraReports.UI.ReportHeaderBand()
        Me.XrBarCode1 = New DevExpress.XtraReports.UI.XRBarCode()
        Me.Picture5 = New DevExpress.XtraReports.UI.XRPictureBox()
        Me.Text1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Fechadecreacióndelarchivo1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text15 = New DevExpress.XtraReports.UI.XRLabel()
        Me.PageHeader = New DevExpress.XtraReports.UI.PageHeaderBand()
        Me.Text8 = New DevExpress.XtraReports.UI.XRLabel()
        Me.fechaCreacion1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text3 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text4 = New DevExpress.XtraReports.UI.XRLabel()
        Me.agenteDomiciliario1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text5 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text6 = New DevExpress.XtraReports.UI.XRLabel()
        Me.telefonoAgente1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.placa1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.cedulaAgente1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text12 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text13 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text10 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text11 = New DevExpress.XtraReports.UI.XRLabel()
        Me.nombre1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.identificacion1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.direccion1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.telefono1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text7 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text14 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text16 = New DevExpress.XtraReports.UI.XRLabel()
        Me.Text17 = New DevExpress.XtraReports.UI.XRLabel()
        Me.PageFooter = New DevExpress.XtraReports.UI.PageFooterBand()
        Me.PáginaNdeM1 = New DevExpress.XtraReports.UI.XRLabel()
        Me.DsOrdenDespachoServicioTecnico = New BPColSysOP.dsOrdenDespachoServicioTecnico()
        Me.ObtenerInfoHojaRutaMensajeriaTableAdapter = New BPColSysOP.dsOrdenDespachoServicioTecnicoTableAdapters.ObtenerInfoHojaRutaMensajeriaTableAdapter()
        Me.ObtieneRutaProveedorServicioTecnicoTableAdapter = New BPColSysOP.dsOrdenDespachoServicioTecnicoTableAdapters.ObtieneRutaProveedorServicioTecnicoTableAdapter()
        Me.ObtieneInfoRutaDespachoServicioTecnicoTableAdapter = New BPColSysOP.dsOrdenDespachoServicioTecnicoTableAdapters.ObtieneInfoRutaDespachoServicioTecnicoTableAdapter()
        Me.TopMarginBand1 = New DevExpress.XtraReports.UI.TopMarginBand()
        Me.BottomMarginBand1 = New DevExpress.XtraReports.UI.BottomMarginBand()
        Me.GroupHeader1 = New DevExpress.XtraReports.UI.GroupHeaderBand()
        CType(Me.DsOrdenDespachoServicioTecnico, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.serial1, Me.msisdn1})
        Me.Detail.HeightF = 15.0!
        Me.Detail.Name = "Detail"
        '
        'serial1
        '
        Me.serial1.BackColor = System.Drawing.Color.White
        Me.serial1.BorderColor = System.Drawing.Color.Black
        Me.serial1.CanGrow = False
        Me.serial1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneInfoRutaDespachoServicioTecnico.serial")})
        Me.serial1.Font = New System.Drawing.Font("Arial", 9.0!)
        Me.serial1.ForeColor = System.Drawing.Color.Black
        Me.serial1.LocationFloat = New DevExpress.Utils.PointFloat(91.0!, 0.0!)
        Me.serial1.Name = "serial1"
        Me.serial1.SizeF = New System.Drawing.SizeF(138.0!, 15.0!)
        Me.serial1.Text = "serial1"
        Me.serial1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'msisdn1
        '
        Me.msisdn1.BackColor = System.Drawing.Color.White
        Me.msisdn1.BorderColor = System.Drawing.Color.Black
        Me.msisdn1.CanGrow = False
        Me.msisdn1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneInfoRutaDespachoServicioTecnico.msisdn")})
        Me.msisdn1.Font = New System.Drawing.Font("Arial", 9.0!)
        Me.msisdn1.ForeColor = System.Drawing.Color.Black
        Me.msisdn1.LocationFloat = New DevExpress.Utils.PointFloat(250.0!, 0.0!)
        Me.msisdn1.Name = "msisdn1"
        Me.msisdn1.SizeF = New System.Drawing.SizeF(128.0!, 15.0!)
        Me.msisdn1.Text = "msisdn1"
        Me.msisdn1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text9
        '
        Me.Text9.BackColor = System.Drawing.Color.White
        Me.Text9.BorderColor = System.Drawing.Color.Black
        Me.Text9.CanGrow = False
        Me.Text9.Font = New System.Drawing.Font("Arial", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Text9.ForeColor = System.Drawing.Color.Gray
        Me.Text9.LocationFloat = New DevExpress.Utils.PointFloat(82.0000229!, 26.0!)
        Me.Text9.Name = "Text9"
        Me.Text9.SizeF = New System.Drawing.SizeF(129.0!, 15.0!)
        Me.Text9.Text = "IMEI"
        Me.Text9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text18
        '
        Me.Text18.BackColor = System.Drawing.Color.White
        Me.Text18.BorderColor = System.Drawing.Color.Black
        Me.Text18.CanGrow = False
        Me.Text18.Font = New System.Drawing.Font("Arial", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Text18.ForeColor = System.Drawing.Color.Gray
        Me.Text18.LocationFloat = New DevExpress.Utils.PointFloat(241.0!, 26.0!)
        Me.Text18.Name = "Text18"
        Me.Text18.SizeF = New System.Drawing.SizeF(129.0!, 15.0!)
        Me.Text18.Text = "MSISDN"
        Me.Text18.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'numeroRadicado1
        '
        Me.numeroRadicado1.BackColor = System.Drawing.Color.White
        Me.numeroRadicado1.BorderColor = System.Drawing.Color.Black
        Me.numeroRadicado1.CanGrow = False
        Me.numeroRadicado1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.numeroRadicado")})
        Me.numeroRadicado1.Font = New System.Drawing.Font("Arial", 10.0!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Underline), System.Drawing.FontStyle))
        Me.numeroRadicado1.ForeColor = System.Drawing.Color.Black
        Me.numeroRadicado1.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 2.0!)
        Me.numeroRadicado1.Name = "numeroRadicado1"
        Me.numeroRadicado1.SizeF = New System.Drawing.SizeF(131.0!, 16.0!)
        Me.numeroRadicado1.Text = "numeroRadicado1"
        Me.numeroRadicado1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'contacto1
        '
        Me.contacto1.BackColor = System.Drawing.Color.White
        Me.contacto1.BorderColor = System.Drawing.Color.Black
        Me.contacto1.CanGrow = False
        Me.contacto1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.contacto")})
        Me.contacto1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.contacto1.ForeColor = System.Drawing.Color.Black
        Me.contacto1.LocationFloat = New DevExpress.Utils.PointFloat(589.0!, 2.0!)
        Me.contacto1.Name = "contacto1"
        Me.contacto1.SizeF = New System.Drawing.SizeF(157.0!, 15.0!)
        Me.contacto1.Text = "contacto1"
        Me.contacto1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'empresa1
        '
        Me.empresa1.BackColor = System.Drawing.Color.White
        Me.empresa1.BorderColor = System.Drawing.Color.Black
        Me.empresa1.CanGrow = False
        Me.empresa1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.empresa")})
        Me.empresa1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.empresa1.ForeColor = System.Drawing.Color.Black
        Me.empresa1.LocationFloat = New DevExpress.Utils.PointFloat(191.0!, 1.99999595!)
        Me.empresa1.Name = "empresa1"
        Me.empresa1.SizeF = New System.Drawing.SizeF(379.208405!, 15.0!)
        Me.empresa1.Text = "empresa1"
        Me.empresa1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'secuencia1
        '
        Me.secuencia1.BackColor = System.Drawing.Color.White
        Me.secuencia1.BorderColor = System.Drawing.Color.Black
        Me.secuencia1.CanGrow = False
        Me.secuencia1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.secuencia")})
        Me.secuencia1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.secuencia1.ForeColor = System.Drawing.Color.Black
        Me.secuencia1.LocationFloat = New DevExpress.Utils.PointFloat(139.0!, 4.0!)
        Me.secuencia1.Name = "secuencia1"
        Me.secuencia1.SizeF = New System.Drawing.SizeF(41.0!, 15.0!)
        Me.secuencia1.Text = "secuencia1"
        Me.secuencia1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.XrBarCode1, Me.Picture5, Me.Text1, Me.Fechadecreacióndelarchivo1, Me.Text15})
        Me.ReportHeader.HeightF = 155.0!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'XrBarCode1
        '
        Me.XrBarCode1.Font = New System.Drawing.Font("Times New Roman", 20.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.XrBarCode1.LocationFloat = New DevExpress.Utils.PointFloat(500.0!, 0.0!)
        Me.XrBarCode1.Name = "XrBarCode1"
        Me.XrBarCode1.Padding = New DevExpress.XtraPrinting.PaddingInfo(10, 10, 0, 0, 100.0!)
        Me.XrBarCode1.SizeF = New System.Drawing.SizeF(282.0!, 75.7499466!)
        Me.XrBarCode1.StylePriority.UseFont = False
        Me.XrBarCode1.Symbology = Code128Generator1
        Me.XrBarCode1.Text = "[idRutaCode39]"
        '
        'Picture5
        '
        Me.Picture5.BackColor = System.Drawing.Color.White
        Me.Picture5.BorderColor = System.Drawing.Color.Black
        Me.Picture5.Image = CType(resources.GetObject("Picture5.Image"), System.Drawing.Image)
        Me.Picture5.LocationFloat = New DevExpress.Utils.PointFloat(0.0!, 10.0000095!)
        Me.Picture5.Name = "Picture5"
        Me.Picture5.SizeF = New System.Drawing.SizeF(225.0!, 84.4999466!)
        Me.Picture5.Sizing = DevExpress.XtraPrinting.ImageSizeMode.StretchImage
        '
        'Text1
        '
        Me.Text1.BackColor = System.Drawing.Color.White
        Me.Text1.BorderColor = System.Drawing.Color.Black
        Me.Text1.CanGrow = False
        Me.Text1.Font = New System.Drawing.Font("Arial", 16.0!)
        Me.Text1.ForeColor = System.Drawing.Color.Black
        Me.Text1.LocationFloat = New DevExpress.Utils.PointFloat(234.0!, 7.99999189!)
        Me.Text1.Name = "Text1"
        Me.Text1.SizeF = New System.Drawing.SizeF(215.375!, 67.7499619!)
        Me.Text1.Text = "Orden Despacho " & Global.Microsoft.VisualBasic.ChrW(10) & "Servicio Técnico No.:"
        Me.Text1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopRight
        '
        'Fechadecreacióndelarchivo1
        '
        Me.Fechadecreacióndelarchivo1.BackColor = System.Drawing.Color.White
        Me.Fechadecreacióndelarchivo1.BorderColor = System.Drawing.Color.Black
        Me.Fechadecreacióndelarchivo1.CanGrow = False
        Me.Fechadecreacióndelarchivo1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Italic)
        Me.Fechadecreacióndelarchivo1.ForeColor = System.Drawing.Color.Black
        Me.Fechadecreacióndelarchivo1.LocationFloat = New DevExpress.Utils.PointFloat(625.0!, 110.5!)
        Me.Fechadecreacióndelarchivo1.Name = "Fechadecreacióndelarchivo1"
        Me.Fechadecreacióndelarchivo1.SizeF = New System.Drawing.SizeF(164.0!, 12.0!)
        Me.Fechadecreacióndelarchivo1.Text = "[DateTime.Now.ToString()]"
        Me.Fechadecreacióndelarchivo1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text15
        '
        Me.Text15.BackColor = System.Drawing.Color.White
        Me.Text15.BorderColor = System.Drawing.Color.Black
        Me.Text15.CanGrow = False
        Me.Text15.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Italic)
        Me.Text15.ForeColor = System.Drawing.Color.Black
        Me.Text15.LocationFloat = New DevExpress.Utils.PointFloat(516.0!, 110.5!)
        Me.Text15.Name = "Text15"
        Me.Text15.SizeF = New System.Drawing.SizeF(108.0!, 15.0!)
        Me.Text15.Text = "Fecha de Impresión:"
        Me.Text15.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.Text8, Me.fechaCreacion1, Me.Text3, Me.Text4, Me.agenteDomiciliario1, Me.Text5, Me.Text6, Me.telefonoAgente1, Me.placa1, Me.cedulaAgente1, Me.Text12, Me.Text13, Me.Text10, Me.Text11, Me.nombre1, Me.identificacion1, Me.direccion1, Me.telefono1, Me.Text14, Me.Text17, Me.Text16, Me.Text7})
        Me.PageHeader.HeightF = 118.0!
        Me.PageHeader.Name = "PageHeader"
        '
        'Text8
        '
        Me.Text8.BackColor = System.Drawing.Color.White
        Me.Text8.BorderColor = System.Drawing.Color.Black
        Me.Text8.CanGrow = False
        Me.Text8.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text8.ForeColor = System.Drawing.Color.Black
        Me.Text8.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 0.0!)
        Me.Text8.Name = "Text8"
        Me.Text8.SizeF = New System.Drawing.SizeF(58.0!, 15.0!)
        Me.Text8.Text = "Fecha:"
        Me.Text8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'fechaCreacion1
        '
        Me.fechaCreacion1.BackColor = System.Drawing.Color.White
        Me.fechaCreacion1.BorderColor = System.Drawing.Color.Black
        Me.fechaCreacion1.CanGrow = False
        Me.fechaCreacion1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.fechaCreacion")})
        Me.fechaCreacion1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.fechaCreacion1.ForeColor = System.Drawing.Color.Black
        Me.fechaCreacion1.LocationFloat = New DevExpress.Utils.PointFloat(83.0!, 0.0!)
        Me.fechaCreacion1.Name = "fechaCreacion1"
        Me.fechaCreacion1.SizeF = New System.Drawing.SizeF(145.0!, 15.0!)
        Me.fechaCreacion1.Text = "fechaCreacion"
        Me.fechaCreacion1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text3
        '
        Me.Text3.BackColor = System.Drawing.Color.White
        Me.Text3.BorderColor = System.Drawing.Color.Black
        Me.Text3.CanGrow = False
        Me.Text3.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text3.ForeColor = System.Drawing.Color.Black
        Me.Text3.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 25.0!)
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
        Me.Text4.LocationFloat = New DevExpress.Utils.PointFloat(241.0!, 0.0!)
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
        Me.agenteDomiciliario1.LocationFloat = New DevExpress.Utils.PointFloat(441.0!, 0.0!)
        Me.agenteDomiciliario1.Name = "agenteDomiciliario1"
        Me.agenteDomiciliario1.SizeF = New System.Drawing.SizeF(341.0!, 15.0!)
        Me.agenteDomiciliario1.Text = "agenteDomiciliario"
        Me.agenteDomiciliario1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text5
        '
        Me.Text5.BackColor = System.Drawing.Color.White
        Me.Text5.BorderColor = System.Drawing.Color.Black
        Me.Text5.CanGrow = False
        Me.Text5.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text5.ForeColor = System.Drawing.Color.Black
        Me.Text5.LocationFloat = New DevExpress.Utils.PointFloat(241.0!, 25.0!)
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
        Me.Text6.LocationFloat = New DevExpress.Utils.PointFloat(441.0!, 25.0!)
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
        Me.telefonoAgente1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.CantTelefonos")})
        Me.telefonoAgente1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.telefonoAgente1.ForeColor = System.Drawing.Color.Black
        Me.telefonoAgente1.LocationFloat = New DevExpress.Utils.PointFloat(333.0!, 25.0!)
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
        Me.placa1.LocationFloat = New DevExpress.Utils.PointFloat(500.0!, 25.0!)
        Me.placa1.Name = "placa1"
        Me.placa1.SizeF = New System.Drawing.SizeF(41.0!, 15.0!)
        Me.placa1.Text = "placa"
        Me.placa1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'cedulaAgente1
        '
        Me.cedulaAgente1.BackColor = System.Drawing.Color.White
        Me.cedulaAgente1.BorderColor = System.Drawing.Color.Black
        Me.cedulaAgente1.CanGrow = False
        Me.cedulaAgente1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtenerInfoHojaRutaMensajeria.cedulaAgente")})
        Me.cedulaAgente1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.cedulaAgente1.ForeColor = System.Drawing.Color.Black
        Me.cedulaAgente1.LocationFloat = New DevExpress.Utils.PointFloat(83.0!, 25.0!)
        Me.cedulaAgente1.Name = "cedulaAgente1"
        Me.cedulaAgente1.SizeF = New System.Drawing.SizeF(109.0!, 15.0!)
        Me.cedulaAgente1.Text = "cedulaAgente"
        Me.cedulaAgente1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text12
        '
        Me.Text12.BackColor = System.Drawing.Color.White
        Me.Text12.BorderColor = System.Drawing.Color.Black
        Me.Text12.CanGrow = False
        Me.Text12.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text12.ForeColor = System.Drawing.Color.Black
        Me.Text12.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 50.0!)
        Me.Text12.Name = "Text12"
        Me.Text12.SizeF = New System.Drawing.SizeF(191.0!, 15.0!)
        Me.Text12.Text = "Proveedor Servicio Técnico:"
        Me.Text12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text13
        '
        Me.Text13.BackColor = System.Drawing.Color.White
        Me.Text13.BorderColor = System.Drawing.Color.Black
        Me.Text13.CanGrow = False
        Me.Text13.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text13.ForeColor = System.Drawing.Color.Black
        Me.Text13.LocationFloat = New DevExpress.Utils.PointFloat(8.0!, 75.0!)
        Me.Text13.Name = "Text13"
        Me.Text13.SizeF = New System.Drawing.SizeF(191.0!, 15.0!)
        Me.Text13.Text = "Identificación:"
        Me.Text13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text10
        '
        Me.Text10.BackColor = System.Drawing.Color.White
        Me.Text10.BorderColor = System.Drawing.Color.Black
        Me.Text10.CanGrow = False
        Me.Text10.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text10.ForeColor = System.Drawing.Color.Black
        Me.Text10.LocationFloat = New DevExpress.Utils.PointFloat(433.0!, 50.0!)
        Me.Text10.Name = "Text10"
        Me.Text10.SizeF = New System.Drawing.SizeF(83.0!, 15.0!)
        Me.Text10.Text = "Dirección:"
        Me.Text10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'Text11
        '
        Me.Text11.BackColor = System.Drawing.Color.White
        Me.Text11.BorderColor = System.Drawing.Color.Black
        Me.Text11.CanGrow = False
        Me.Text11.Font = New System.Drawing.Font("Arial", 10.0!, System.Drawing.FontStyle.Bold)
        Me.Text11.ForeColor = System.Drawing.Color.Black
        Me.Text11.LocationFloat = New DevExpress.Utils.PointFloat(433.0!, 75.0!)
        Me.Text11.Name = "Text11"
        Me.Text11.SizeF = New System.Drawing.SizeF(83.0!, 15.0!)
        Me.Text11.Text = "Teléfono:"
        Me.Text11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'nombre1
        '
        Me.nombre1.BackColor = System.Drawing.Color.White
        Me.nombre1.BorderColor = System.Drawing.Color.Black
        Me.nombre1.CanGrow = False
        Me.nombre1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneRutaProveedorServicioTecnico.nombre")})
        Me.nombre1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.nombre1.ForeColor = System.Drawing.Color.Black
        Me.nombre1.LocationFloat = New DevExpress.Utils.PointFloat(208.0!, 50.0!)
        Me.nombre1.Name = "nombre1"
        Me.nombre1.SizeF = New System.Drawing.SizeF(216.0!, 15.0!)
        Me.nombre1.Text = "nombre1"
        Me.nombre1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'identificacion1
        '
        Me.identificacion1.BackColor = System.Drawing.Color.White
        Me.identificacion1.BorderColor = System.Drawing.Color.Black
        Me.identificacion1.CanGrow = False
        Me.identificacion1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneRutaProveedorServicioTecnico.identificacion")})
        Me.identificacion1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.identificacion1.ForeColor = System.Drawing.Color.Black
        Me.identificacion1.LocationFloat = New DevExpress.Utils.PointFloat(208.0!, 75.0!)
        Me.identificacion1.Name = "identificacion1"
        Me.identificacion1.SizeF = New System.Drawing.SizeF(216.0!, 15.0!)
        Me.identificacion1.Text = "identificacion1"
        Me.identificacion1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'direccion1
        '
        Me.direccion1.BackColor = System.Drawing.Color.White
        Me.direccion1.BorderColor = System.Drawing.Color.Black
        Me.direccion1.CanGrow = False
        Me.direccion1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneRutaProveedorServicioTecnico.direccion")})
        Me.direccion1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.direccion1.ForeColor = System.Drawing.Color.Black
        Me.direccion1.LocationFloat = New DevExpress.Utils.PointFloat(525.0!, 50.0!)
        Me.direccion1.Name = "direccion1"
        Me.direccion1.SizeF = New System.Drawing.SizeF(258.0!, 15.0!)
        Me.direccion1.Text = "direccion1"
        Me.direccion1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
        '
        'telefono1
        '
        Me.telefono1.BackColor = System.Drawing.Color.White
        Me.telefono1.BorderColor = System.Drawing.Color.Black
        Me.telefono1.CanGrow = False
        Me.telefono1.DataBindings.AddRange(New DevExpress.XtraReports.UI.XRBinding() {New DevExpress.XtraReports.UI.XRBinding("Text", Nothing, "ObtieneRutaProveedorServicioTecnico.telefono")})
        Me.telefono1.Font = New System.Drawing.Font("Arial", 10.0!)
        Me.telefono1.ForeColor = System.Drawing.Color.Black
        Me.telefono1.LocationFloat = New DevExpress.Utils.PointFloat(525.0!, 75.0!)
        Me.telefono1.Name = "telefono1"
        Me.telefono1.SizeF = New System.Drawing.SizeF(258.0!, 15.0!)
        Me.telefono1.Text = "telefono1"
        Me.telefono1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft
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
        Me.Text7.LocationFloat = New DevExpress.Utils.PointFloat(9.99997425!, 98.0!)
        Me.Text7.Name = "Text7"
        Me.Text7.SizeF = New System.Drawing.SizeF(122.0!, 17.0!)
        Me.Text7.Text = "Radicado"
        Me.Text7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
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
        Me.Text14.LocationFloat = New DevExpress.Utils.PointFloat(588.0!, 98.0!)
        Me.Text14.Name = "Text14"
        Me.Text14.SizeF = New System.Drawing.SizeF(158.0!, 17.0!)
        Me.Text14.Text = "Contacto"
        Me.Text14.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
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
        Me.Text16.LocationFloat = New DevExpress.Utils.PointFloat(242.0!, 98.0!)
        Me.Text16.Name = "Text16"
        Me.Text16.SizeF = New System.Drawing.SizeF(141.0!, 17.0!)
        Me.Text16.Text = "Empresa"
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
        Me.Text17.LocationFloat = New DevExpress.Utils.PointFloat(140.0!, 98.0!)
        Me.Text17.Name = "Text17"
        Me.Text17.SizeF = New System.Drawing.SizeF(41.0!, 17.0!)
        Me.Text17.Text = "Sec."
        Me.Text17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
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
        Me.PáginaNdeM1.SizeF = New System.Drawing.SizeF(783.0!, 15.0!)
        Me.PáginaNdeM1.Text = "Untranslated"
        Me.PáginaNdeM1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter
        '
        'DsOrdenDespachoServicioTecnico
        '
        Me.DsOrdenDespachoServicioTecnico.DataSetName = "dsOrdenDespachoServicioTecnico"
        Me.DsOrdenDespachoServicioTecnico.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'ObtenerInfoHojaRutaMensajeriaTableAdapter
        '
        Me.ObtenerInfoHojaRutaMensajeriaTableAdapter.ClearBeforeFill = True
        '
        'ObtieneRutaProveedorServicioTecnicoTableAdapter
        '
        Me.ObtieneRutaProveedorServicioTecnicoTableAdapter.ClearBeforeFill = True
        '
        'ObtieneInfoRutaDespachoServicioTecnicoTableAdapter
        '
        Me.ObtieneInfoRutaDespachoServicioTecnicoTableAdapter.ClearBeforeFill = True
        '
        'TopMarginBand1
        '
        Me.TopMarginBand1.HeightF = 25.0!
        Me.TopMarginBand1.Name = "TopMarginBand1"
        '
        'BottomMarginBand1
        '
        Me.BottomMarginBand1.HeightF = 25.0!
        Me.BottomMarginBand1.Name = "BottomMarginBand1"
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New DevExpress.XtraReports.UI.XRControl() {Me.contacto1, Me.secuencia1, Me.empresa1, Me.numeroRadicado1, Me.Text18, Me.Text9})
        Me.GroupHeader1.GroupFields.AddRange(New DevExpress.XtraReports.UI.GroupField() {New DevExpress.XtraReports.UI.GroupField("secuencia", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending), New DevExpress.XtraReports.UI.GroupField("numeroRadicado", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)})
        Me.GroupHeader1.HeightF = 41.0!
        Me.GroupHeader1.Name = "GroupHeader1"
        '
        'XtrOrdenDespachoServicioTecnico
        '
        Me.Bands.AddRange(New DevExpress.XtraReports.UI.Band() {Me.Detail, Me.ReportHeader, Me.PageHeader, Me.PageFooter, Me.TopMarginBand1, Me.BottomMarginBand1, Me.GroupHeader1})
        Me.DataAdapter = Me.ObtieneInfoRutaDespachoServicioTecnicoTableAdapter
        Me.DataMember = "ObtenerInfoHojaRutaMensajeria"
        Me.DataSource = Me.DsOrdenDespachoServicioTecnico
        Me.Margins = New System.Drawing.Printing.Margins(25, 25, 25, 25)
        Me.ScriptLanguage = DevExpress.XtraReports.ScriptLanguage.VisualBasic
        Me.Version = "12.2"
        CType(Me.DsOrdenDespachoServicioTecnico, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents Detail As DevExpress.XtraReports.UI.DetailBand
    Friend WithEvents serial1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents msisdn1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents numeroRadicado1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents contacto1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents empresa1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents secuencia1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text9 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text18 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents ReportHeader As DevExpress.XtraReports.UI.ReportHeaderBand
    Friend WithEvents Text1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Fechadecreacióndelarchivo1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text15 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PageHeader As DevExpress.XtraReports.UI.PageHeaderBand
    Friend WithEvents Text8 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents fechaCreacion1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text3 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text4 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents agenteDomiciliario1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text5 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text6 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents telefonoAgente1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents placa1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents cedulaAgente1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text12 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text13 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text10 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text11 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents nombre1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents identificacion1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents direccion1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents telefono1 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text7 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text14 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text16 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents Text17 As DevExpress.XtraReports.UI.XRLabel
    Friend WithEvents PageFooter As DevExpress.XtraReports.UI.PageFooterBand
    Friend WithEvents PáginaNdeM1 As DevExpress.XtraReports.UI.XRLabel
    Private WithEvents Picture5 As DevExpress.XtraReports.UI.XRPictureBox
    Friend WithEvents DsOrdenDespachoServicioTecnico As BPColSysOP.dsOrdenDespachoServicioTecnico
    Friend WithEvents ObtenerInfoHojaRutaMensajeriaTableAdapter As BPColSysOP.dsOrdenDespachoServicioTecnicoTableAdapters.ObtenerInfoHojaRutaMensajeriaTableAdapter
    Friend WithEvents ObtieneRutaProveedorServicioTecnicoTableAdapter As BPColSysOP.dsOrdenDespachoServicioTecnicoTableAdapters.ObtieneRutaProveedorServicioTecnicoTableAdapter
    Friend WithEvents ObtieneInfoRutaDespachoServicioTecnicoTableAdapter As BPColSysOP.dsOrdenDespachoServicioTecnicoTableAdapters.ObtieneInfoRutaDespachoServicioTecnicoTableAdapter
    Friend WithEvents TopMarginBand1 As DevExpress.XtraReports.UI.TopMarginBand
    Friend WithEvents BottomMarginBand1 As DevExpress.XtraReports.UI.BottomMarginBand
    Friend WithEvents XrBarCode1 As DevExpress.XtraReports.UI.XRBarCode
    Friend WithEvents GroupHeader1 As DevExpress.XtraReports.UI.GroupHeaderBand
End Class
