<%@ Page Language="vb" AutoEventWireup="false" Codebehind="eliminarVentasWB.aspx.vb" Inherits="BPColSysOP.eliminarVentasWB" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>eliminarVentasWB</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		    document.getElementById("divImagen").style.display="none";
		    if(!confirm("Realmente desea Eliminar la Venta?")){
		      return(false);
		    }
		    document.getElementById("divImagen").style.display="block";
		  }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Eliminar Ventas WB</b></font>
		<hr>
		<form id="Form1" method="post" runat="server" onsubmit="return validacion();">
			<table class="tabla" width="90%">
				<tr>
					<td>
						<asp:HyperLink id="hlRegresar" runat="server" Font-Bold="True" NavigateUrl="eliminarVentasWBInicio.aspx">Regresar</asp:HyperLink><br>
						<br>
					</td>
				</tr>
				<TR>
					<TD>
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="images/loader.gif"><font face="arial" size="2"><b>
									Eliminando Venta...</b></font><br>
							<br>
						</DIV>
					</TD>
				</TR>
				<tr>
					<td align="center">
						<asp:Label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label></td>
				</tr>
			</table>
			<table class="tabla">
				<tr>
					<td class="celdaTitulo">Factura No.:</td>
					<td class="celdaNormal" width="200">
						<asp:Label id="lblFactura" runat="server"></asp:Label>
					</td>
				</tr>
				<TR>
					<TD class="celdaTitulo">Identificación Cliente:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblIdentificacion" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Nombres Cliente:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblNombre" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Apellidos Cliente:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblApellidos" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Dirección:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblDireccion" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Teléfono 1:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblTelefono1" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">IMEI:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblImei" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">ICCID (Sim):</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblIccid" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">MSISDN:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblMin" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Fecha (Usuario):</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblFecha" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">POS:</TD>
					<TD class="celdaNormal" width="200">
						<asp:Label id="lblPos" runat="server"></asp:Label></TD>
				</TR>
				<tr>
					<td colspan="2"><br>
						<br>
						<asp:Button id="btnContinuar" runat="server" CssClass="boton" Text="Eliminar"></asp:Button><INPUT id="hTransaccion" style="WIDTH: 16px; HEIGHT: 22px" type="hidden" size="1" name="hTransaccion"
							runat="server"> <INPUT id="hIdPos" style="WIDTH: 16px; HEIGHT: 22px" type="hidden" size="1" name="hIdPos"
							runat="server">&nbsp;<INPUT style="WIDTH: 16px; HEIGHT: 22px" type="hidden" size="1" id="hIdSubproducto" name="hIdSubproducto"
							runat="server"> <INPUT id="hTablaOrigen" style="WIDTH: 16px; HEIGHT: 22px" type="hidden" size="1" name="hTablaOrigen"
							runat="server">
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
