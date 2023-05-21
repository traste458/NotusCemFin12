<%@ Page Language="vb" AutoEventWireup="false" Codebehind="cambiodeventaAPlanUnico.aspx.vb" Inherits="BPColSysOP.cambiodeventaAPlanUnico" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>cambiarFechaVenta</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Cambios de Facturas de Ventas KP a Ventas Plan Unico</b></font>&nbsp;
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:label></td>
				</tr>
			</table>
			<table class="tabla" id="tablaInicial" style="WIDTH: 320px; HEIGHT: 265px">
				<tr>
					<td class="celdaTitulo" style="WIDTH: 199px">IMEI:</td>
					<td class="celdaNormal" width="200"><asp:textbox id="txtSerial" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></td>
				</tr>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 199px">ICCID:</TD>
					<TD class="celdaNormal" width="200"><asp:textbox id="txtSim" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 199px">MIN:</TD>
					<TD class="celdaNormal" width="200"><asp:textbox id="txtMin" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 199px">Factura:</TD>
					<TD class="celdaNormal" width="200"><asp:textbox id="txtFactura" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 199px">Tipo de Cambio:</TD>
					<TD class="celdaNormal" width="200"><asp:radiobuttonlist id="rblTipoCambio" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="8pt"
							RepeatLayout="Flow" Height="8px" RepeatColumns="2" RepeatDirection="Horizontal" Width="120px">
							<asp:ListItem Value="1">Cambio de Plan</asp:ListItem>
							<asp:ListItem Value="2">Cambio de Fecha</asp:ListItem>
							<asp:ListItem Value="3">Eliminar Venta</asp:ListItem>
						</asp:radiobuttonlist><FONT face="arial" color="blue" size="2"><FONT face="arial" color="blue" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD colSpan="2"><FONT face="arial" color="blue" size="2">*</FONT> <FONT size="1">Campo 
							Obligatorio</FONT><BR>
						<FONT face="arial" color="blue" size="2">**</FONT> <FONT size="1">Se debe 
							especificar uno de los valores</FONT>
						<BR>
					</TD>
				</TR>
				<tr>
					<td colSpan="2"><br>
						<br>
						<asp:button id="btnContinuar" runat="server" CssClass="boton" Text="Continuar"></asp:button></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
