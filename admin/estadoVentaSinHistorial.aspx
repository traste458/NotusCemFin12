<%@ Page Language="vb" AutoEventWireup="false" Codebehind="estadoVentaSinHistorial.aspx.vb" Inherits="BPColSysOP.estadoVentaSinHistorial" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>VentaSinHirtorial</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		   if(document.Form1.txtSerial.value==""){
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
		      alert("Escoja el Tipo de Serial, Por Favor");
		      document.getElementById("rblTipoSerial").focus();
		      return(false);
		    }
		  }
		</script>
	</HEAD>
	<body class="cuerpo" onload="window.document.Form1.txtSerial.focus();">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Buscar Serial con 
				estado de Vendido</b></font>&nbsp;
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" Font-Bold="True" NavigateUrl="javascript:history.back();"
							tabIndex="4">Regresar</asp:hyperlink><br>
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
					<td class="celdaNormal" width="200"><asp:textbox id="txtSerial" runat="server" CssClass="textbox" MaxLength="20" tabIndex="1"></asp:textbox></td>
				</tr>
				<TR>
					<TD class="celdaTitulo">Tipo de Serial:</TD>
					<TD class="celdaNormal" width="200"><asp:radiobuttonlist id="rblTipoSerial" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="8pt"
							RepeatDirection="Horizontal" RepeatLayout="Flow" Height="8px" RepeatColumns="2" tabIndex="2">
							<asp:ListItem Value="1">IMEI</asp:ListItem>
							<asp:ListItem Value="2">ICCID</asp:ListItem>
						</asp:radiobuttonlist></TD>
				</TR>
				<tr>
					<td colSpan="2"><br>
						<br>
						<asp:button id="btnContinuar" runat="server" Text="Continuar" CssClass="boton" tabIndex="3"></asp:button></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
