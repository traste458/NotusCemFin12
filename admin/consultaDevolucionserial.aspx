<%@ Page Language="vb" AutoEventWireup="false" Codebehind="consultaDevolucionserial.aspx.vb" Inherits="BPColSysOP.consultaDevolucionserial" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SubirSerialDevoluciones</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		function validacion()
		{
				   if(document.Form1.txtSerial.value=="")
				   {
					     alert("Digite el Serial, Por Favor");
						 document.Form1.txtSerial.focus();
						 return(false);
				}
				
		   var seleccionado = false;
		   for(var i=1;i<document.getElementsByName("rblTipoSerial").length;i++){
		     if(document.getElementsByName("rblTipoSerial").item(i).checked==true){
		       seleccionado = true;
			}
		   }
		   if(seleccionado==false){
		      alert("Escoja la Devolución a: , Por Favor");
		      document.getElementById("rblTipoSerial").focus();
		      return(false);
		    }
	
		}
		  
		</script>
	</HEAD>
	<body class="cuerpo" onload="window.document.Form1.txtSerial.focus();">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Buscar Serial 
				Devoluciones CAD para subir</b></font>&nbsp;
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" tabIndex="4" runat="server" NavigateUrl="javascript:history.back();"
							Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:label><asp:label id="lblRes" runat="server" Font-Bold="True" ForeColor="Blue"></asp:label></td>
				</tr>
			</table>
			<table class="tabla" id="tablaInicial">
				<tr>
					<td class="celdaTitulo">Serial:</td>
					<td class="celdaNormal" width="200"><asp:textbox id="txtSerial" tabIndex="1" runat="server" MaxLength="20" CssClass="textbox"></asp:textbox></td>
				</tr>
				<TR>
					<TD class="celdaTitulo">Devolución a:</TD>
					<TD class="celdaNormal" width="200"><asp:radiobuttonlist id="rblTipoSerial" tabIndex="2" runat="server" Font-Bold="True" RepeatColumns="2"
							Height="8px" RepeatLayout="Flow" RepeatDirection="Horizontal" Font-Size="8pt" Font-Names="Arial">
							<asp:ListItem Value="1">CAD</asp:ListItem>
							<asp:ListItem Value="2">ZONA FRANCA</asp:ListItem>
						</asp:radiobuttonlist></TD>
				</TR>
				<tr>
					<td colSpan="2"><br>
						<br>
						<asp:button id="btnContinuar" tabIndex="3" runat="server" CssClass="boton" Text="Continuar"></asp:button></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
