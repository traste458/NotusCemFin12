<%@ Page Language="vb" AutoEventWireup="false" Codebehind="eliminarVentasWBInicio.aspx.vb" Inherits="BPColSysOP.eliminarVentasWBInicio" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>eliminarVentasWBInicio</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		    if(document.Form1.txtSim.value==""){
		      alert("Digite el ICCID (Sim), Por Favor");
		      document.Form1.txtSim.focus();
		      return(false);
		    }
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
						<asp:HyperLink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:HyperLink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center">
						<asp:Label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
						<asp:Label id="lblRes" runat="server" Font-Bold="True" ForeColor="Blue"></asp:Label></td>
				</tr>
			</table>
			<table class="tabla">
				<tr>
					<td class="celdaTitulo">ICCID (Sim):</td>
					<td class="celdaNormal" width="200">
						<asp:TextBox id="txtSim" runat="server" CssClass="textbox" Width="144px" MaxLength="20"></asp:TextBox><font face="arial" size="2" color="blue">*
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="2"><font face="arial" size="2" color="blue">*</font> <font size="1">Campo 
							Obligatorio</font><br>
						<br>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:Button id="btnContinuar" runat="server" CssClass="boton" Text="Continuar"></asp:Button>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
