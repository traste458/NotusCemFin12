<%@ Register NameSpace="Anthem" Assembly="Anthem" TagPrefix="Anthem"%>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="elminarFacturaPostPago.aspx.vb" Inherits="BPColSysOP.elminarFacturaPostPago" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>cambiarFechaVenta2</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		 function validacion(){
		   if (document.getElementById('lblFactura').innerHTML+"." !=".")    
		   { if(confirm("¿ Desea eliminar la factura Nº : "+ document.getElementById('lblFactura').innerHTML +"?"))
		     { document.getElementById('Guardar').value=1
		     }else{
		      document.getElementById('Guardar').value=0
		     } 
		   }else
		    { alert("Error: No Exite Factura para Eliminar")
		    }
		  } 
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Eliminar Factura 
				Post Pago</b></font>
		<hr>
		<form id="Form1" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><anthem:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red" AutoUpdateAfterCallBack="True"></anthem:label><anthem:label id="lblExito" runat="server" Font-Bold="True" ForeColor="Blue" AutoUpdateAfterCallBack="True"></anthem:label></td>
				</tr>
			</table>
			<br>
			<br>
			<table class="tabla" style="WIDTH: 376px; HEIGHT: 53px">
				<tr>
					<td class="celdaTitulo" style="WIDTH: 215px">Factura No.:</td>
					<td class="celdaNormal" width="200"><asp:label id="lblFactura" runat="server"></asp:label></td>
				</tr>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Identificación Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIdentificacion" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Nombres Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblNombre" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Apellidos Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblApellidos" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">IMEI:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblImei" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">ICCID (Sim):</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIccid" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">MSISDN:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblMin" runat="server"></asp:label></TD>
				</TR>
				<tr>
					<td class="celdaTitulo" style="WIDTH: 215px">
						<div>Plan:
						</div>
					</td>
					<td class="celdaNormal" width="200"><asp:label id="lblPlan" runat="server"></asp:label></td>
				</tr>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Fecha (Usuario):</TD>
					<TD class="celdaNormal" width="200"><anthem:label id="lblFecha" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
				</TR>
			</table>
			<input type="hidden" id="Guardar" runat="server" style="WIDTH: 16px; HEIGHT: 22px" size="1"
				NAME="Guardar">
			<br>
			<br>
			<anthem:Button ID="continuar" Runat="server" CssClass="boton" Text="Eliminar" AutoUpdateAfterCallBack="True"></anthem:Button>
		</form>
	</body>
</HTML>
