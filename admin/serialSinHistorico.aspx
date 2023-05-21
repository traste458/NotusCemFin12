<%@ Page Language="vb" AutoEventWireup="false" Codebehind="serialSinHistorico.aspx.vb" Inherits="BPColSysOP.serialSinHistorico" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>serialSinHistorico</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body class="cuerpo" MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Serial buscado sin 
					Historico</b></font>&nbsp;
			<hr>
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" NavigateUrl="estadoVentaSinHistorial.aspx" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red" Font-Size="Small"></asp:label></td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblRes" runat="server" Font-Bold="True" ForeColor="Blue" Font-Size="Small"></asp:label></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
