<%@ Page Language="vb" AutoEventWireup="false" Codebehind="cambiarFechaVenta.aspx.vb" Inherits="BPColSysOP.cambiarFechaVenta" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>cambiarFechaVenta</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		   if(document.Form1.txtSerial.value==""&&document.Form1.txtSim.value==""&&document.Form1.txtFactura.value==""){
		     alert("Digite el Serial, la Sim o la Factura asociada a la Venta, Por Favor");
		     document.Form1.txtSerial.focus();
		     return(false);
		   }
		   
		   var seleccionado = false;
		   for(var i=1;i<document.getElementsByName("rblTipoVenta").length;i++){
		     if(document.getElementsByName("rblTipoVenta").item(i).checked==true){
		       seleccionado = true;
		     }
		   }
		   if(seleccionado==false){
		      alert("Escoja el Tipo de Venta, Por Favor");
		      document.getElementById("rblTipoVenta").focus();
		      return(false);
		    }
		  }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Cambiar Fecha de 
				Venta</b></font>&nbsp;
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
			<table class="tabla" id="tablaInicial">
				<tr>
					<td class="celdaTitulo">IMEI:</td>
					<td class="celdaNormal" width="200"><asp:textbox id="txtSerial" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></td>
				</tr>
				<TR>
					<TD class="celdaTitulo">ICCID:</TD>
					<TD class="celdaNormal" width="200"><asp:textbox id="txtSim" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Factura:</TD>
					<TD class="celdaNormal" width="200"><asp:textbox id="txtFactura" runat="server" CssClass="textbox" MaxLength="20"></asp:textbox><FONT face="arial" color="blue" size="2">*<FONT face="arial" color="blue" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Tipo de Venta:</TD>
					<TD class="celdaNormal" width="200"><asp:radiobuttonlist id="rblTipoVenta" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="8pt"
							RepeatDirection="Horizontal" RepeatLayout="Flow" Height="8px" RepeatColumns="2">
							<asp:ListItem Value="1">Kit Prepago</asp:ListItem>
							<asp:ListItem Value="2">Welcome Back</asp:ListItem>
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
