<%@ Page Language="vb" AutoEventWireup="false" Codebehind="liberarSerial2.aspx.vb" Inherits="BPColSysOP.liberarSerial2" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>liberarSerial2</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		    alert(event.srcElement.name);
		  }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Liberar Seriales 
				Reportados</b></font>&nbsp;
		<hr>
		<form id="Form1" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td>
						<asp:HyperLink id="hlRegresar" runat="server" Font-Bold="True" NavigateUrl="liberarSerial.aspx">Regresar</asp:HyperLink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center">
						<asp:Label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label></td>
				</tr>
			</table>
			<TABLE class="tabla" id="tablaSecundaria" runat="server">
				<TBODY>
					<TR>
						<TD class="celdaTitulo" style="HEIGHT: 15px">Serial:</TD>
						<TD class="celdaNormal" style="HEIGHT: 15px" width="200"><asp:Label id="lblSerial" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD class="celdaTitulo">Punto de Venta:</TD>
						<TD class="celdaNormal" width="200"><asp:Label id="lblPOS" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD class="celdaTitulo">Siniestro:</TD>
						<TD class="celdaNormal" width="200"><asp:Label id="lblSiniestro" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD class="celdaTitulo">Estado:</TD>
						<TD class="celdaNormal" width="200"><asp:Label id="lblEstado" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD class="celdaTitulo">Fecha:</TD>
						<TD class="celdaNormal" width="200"><asp:Label id="lblFecha" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD colSpan="2"><BR>
							<BR>
							<asp:Button id="btnLiberar" runat="server" Text="Liberar" CssClass="boton"></asp:Button><INPUT id="hIdSerialReportado" style="WIDTH: 16px; HEIGHT: 22px" type="hidden" size="1"
								name="hIdSerialReportado" runat="server">
						</TD>
					</TR>
				</TBODY>
			</TABLE>
		</form>
	</body>
</HTML>
