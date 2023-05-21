<%@ Page Language="vb" AutoEventWireup="false" Codebehind="cambioPlan.aspx.vb" Inherits="BPColSysOP.cambioPlan" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem"%>
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
		    if(document.getElementById('planes').selectedIndex>0)
		    { if(confirm("¿ Desea cambiar el plan: "+document.getElementById('planActual').value +" por el plan: "+ document.getElementById('planes').options(document.getElementById('planes').selectedIndex).text +" ?"))
		      { document.getElementById('Guardar').value=1
		      }else{
		       document.getElementById('Guardar').value=0
		      }
		    }else
		     { alert("Error: Seleccione un plan, para el realizar el cambio")
		       document.getElementById('Guardar').value=0
		     }
		   }
		   
		 
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Cambio de Plan 
				Postpago</b></font>&nbsp;
		<hr>
		<form id="Form1" onsubmit="" method="post" runat="server">
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
					<td class="celdaTitulo">Factura No.:</td>
					<td class="celdaNormal" width="200"><asp:label id="lblFactura" runat="server"></asp:label></td>
				</tr>
				<TR>
					<TD class="celdaTitulo">Identificación Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIdentificacion" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Nombres Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblNombre" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Apellidos Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblApellidos" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">IMEI:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblImei" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">ICCID (Sim):</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIccid" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">MSISDN:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblMin" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Fecha (Usuario):</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblFecha" runat="server"></asp:label></TD>
				</TR>
				<tr>
					<td class="celdaTitulo" style="WIDTH: 106px">
						<div>Plan Actual:</div>
					</td>
					<td class="celdaNormal" ><anthem:textBox id="planActual" Runat="server" AutoUpdateAfterCallBack="True" ReadOnly="True" Width="256px"></anthem:textBox></td>
				</tr>
				<tr>
					<td class="celdaTitulo" style="WIDTH: 106px">
						<div>Nuevo Plan:</div>
					</td>
					<td class="celdaNormal" ><asp:dropdownlist id="planes" runat="server" Width="256px"></asp:dropdownlist></td>
				</tr>
			</table>
			<input type="hidden" id="Guardar" runat="server" style="WIDTH: 16px; HEIGHT: 22px" size="1">
			<br>
			<br>
			<anthem:Button ID="continuar" Runat="server" CssClass="boton" Text="Cambiar Plan" AutoUpdateAfterCallBack="True"></anthem:Button>
		</form>
	</body>
</HTML>
