<%@ Register TagPrefix="anthem" Namespace="Anthem" Assembly="Anthem" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="ReporteRemision.aspx.vb" Inherits="BPColSysOP.ReporteRemision"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>ReporteRemision</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<script src="../include/jquery-1.js" type="text/javascript"></script>
		<script src="../include/animatedcollapse.js" type="text/javascript"></script>
		<LINK media="all" href="../include/widget02.css" type="text/css" rel="stylesheet">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<LINK href="../include/style_ventana.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="../include/jscript_ventana.js" type="text/javascript"></script>
		<script language="jscript" type="text/javascript">
		animatedcollapse.addDiv('imagenEjemplo', 'fade=0,height=200px')
		animatedcollapse.init()
		  function validacion(){
		    if(document.Form1.fechaInicial.value==""){
		      document.getElementById("divImagen").style.display = "none";
		      alert("Escoja la Fecha Inicial (Desde), Por favor");
		      document.Form1.fechaInicial.focus();
		      return(false);
		    }
		    if(document.Form1.fechaFinal.value==""){
		      document.getElementById("divImagen").style.display = "none";
		      alert("Escoja la Fecha Final (Hasta), Por favor");
		      document.Form1.fechaFinal.focus();
		      return(false);
		    }
		  }
		  
		  function mostrar(){
		  mostrarVentana(700,300,document.getElementById('divMostrarHistorico'))
		  }
		</script>
	</HEAD>
	<body class="cuerpo2" onscroll="if(document.getElementById('divContenedorVentana').style.visible == 'visible'){javascript:centrarVentana(document.getElementById('divVentana'))};"
		onload="javascript:crearAreaMostrado();">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Reporte de 
				Remisiones y Novedades de Entrega</b></font>
		<hr>
		<form id="Form1" method="post" runat="server">
			<TABLE>
				<TR>
					<TD style="HEIGHT: 17px"><anthem:hyperlink id="hplRegresar" runat="server" Font-Bold="True" NavigateUrl="InicioReporteRemision.aspx">Regresar</anthem:hyperlink><br>
						<br>
					</TD>
				</TR>
				<TR>
					<TD align="center">
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="../images/loader_black.gif"><FONT face="arial" size="2"><B>
									Generando reporte en Excel, por favor espere...</B></FONT></DIV>
						<anthem:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red" Font-Size="X-Small"
							AutoUpdateAfterCallBack="True"></anthem:label></TD>
				</TR>
				<TR>
					<TD><asp:linkbutton id="lbExportar" runat="server" Font-Bold="True" ForeColor="Green" Visible="False"><img src='../images/Excel.gif' border='0' /> Exportar Reporte a Excel</asp:linkbutton><anthem:datagrid id="dgResultado" runat="server" AllowPaging="True" PageSize="30" CssClass="tabla"
							AutoGenerateColumns="False" ShowFooter="True">
							<PagerStyle PageButtonCount="5" Mode="NumericPages"></PagerStyle>
							<AlternatingItemStyle CssClass="alterItemChildDG"></AlternatingItemStyle>
							<FooterStyle CssClass="Footer"></FooterStyle>
							<HeaderStyle CssClass="headerChildDG"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="remision" HeaderText="Remisi&#243;n"></asp:BoundColumn>
								<asp:BoundColumn DataField="pos" HeaderText="Punto Destino"></asp:BoundColumn>
								<asp:BoundColumn DataField="fechaRegistro" HeaderText="Fecha Registro" DataFormatString="{0:yyyy-MM-dd hh:mm tt}">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="fechaDespacho" HeaderText="Fecha Despacho" DataFormatString="{0:yyyy-MM-dd}">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="numGuia" HeaderText="N&#250;mero de Precinto"></asp:BoundColumn>
								<asp:BoundColumn DataField="fechaTrans" HeaderText="Fecha Entrega Transportadora" DataFormatString="{0:yyyy-MM-dd hh:mm tt}">
									<HeaderStyle Width="120px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="fechaPDV" HeaderText="Fecha Entrega PDV" DataFormatString="{0:yyyy-MM-dd hh:mm tt}">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn HeaderText="Estado Remisi&#243;n">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn Visible="False" DataField="historial" HeaderText="historial"></asp:BoundColumn>
								<asp:TemplateColumn HeaderText="Ver Novedades">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
									<ItemTemplate>
										<anthem:ImageButton id="ImageButton1" runat="server" AutoUpdateAfterCallBack="True" Visible="False"
											CommandName="Edit" ImageUrl="../images/flecha_descargar.gif" ImageUrlDuringCallBack="../images/loader_cake.gif"
											PostCallBackFunction="mostrar"></anthem:ImageButton>
									</ItemTemplate>
								</asp:TemplateColumn>
							</Columns>
						</anthem:datagrid></TD>
				</TR>
			</TABLE>
			<div id="divMostrarHistorico" style="VISIBILITY: hidden; TEXT-ALIGN: center"><br>
				<br>
				<table width="100%">
					<TR>
						<TD class="header" align="center">Historial de Novedades en la Entrega</TD>
					</TR>
					<tr>
						<td align="center"><anthem:datagrid id="dgNovedades" runat="server" AutoUpdateAfterCallBack="True" CssClass="tabla"
								AutoGenerateColumns="False" ShowFooter="True" UpdateAfterCallBack="True" Width="100%">
								<FooterStyle CssClass="footer"></FooterStyle>
								<HeaderStyle CssClass="headerChildDG"></HeaderStyle>
								<Columns>
									<asp:BoundColumn DataField="remision" HeaderText="Remisi&#243;n"></asp:BoundColumn>
									<asp:BoundColumn DataField="novedad" HeaderText="Novedad"></asp:BoundColumn>
									<asp:BoundColumn DataField="fechaNovedad" HeaderText="Fecha de la Novedad"></asp:BoundColumn>
									<asp:BoundColumn DataField="observacion" HeaderText="Observaci&#243;n"></asp:BoundColumn>
									<asp:BoundColumn Visible="False" DataField="fechaRegistro" HeaderText="Fecha de Registro"></asp:BoundColumn>
									<asp:BoundColumn DataField="registrado" HeaderText="Registrado Por:"></asp:BoundColumn>
								</Columns>
							</anthem:datagrid></td>
					</tr>
				</table>
				<br>
				&nbsp;&nbsp;
			</div>
		</form>
	</body>
</HTML>
