<%@ Page Language="vb" AutoEventWireup="false" Codebehind="liberarMinDeFactura.aspx.vb" Inherits="BPColSysOP.liberarMinDeFactura" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>liberarMinDeFactura</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<script language="jscript" type="text/javascript">
		  function validacion(){
		    if(document.Form1.hButtonPress.value=="buscar"){
		      if(document.Form1.txtMin.value==""){
		        alert("Digite el MSISDN que desea consultar, Por favor");
		        return(false);
		      }else{
		        var expReg = /[0-9]{10}/
		        if(!expReg.test(document.Form1.txtMin.value)){
		          if(document.Form1.txtMin.value.length!=10){
		            alert("La longitud del MSISDN digitado no es válida. Debería tener 10 dígitos");
		          }else{
		            alert("El MSISDN contiene caracteres no válidos.");
		          }
		         document.Form1.txtMin.focus();
		         return(false);
		        } 
		      }
		    }else{
		      if(!confirm("¿Realmente desea liberar el MSISDN?")){
		        document.Form1.btnContinuar.focus();
		        return(false);
		      }
		    }
		  }
		  
		  function makeSubmit(){
		     if(event.keyCide==13){
		       document.Form1.hButtonPress.value="buscar";
		       document.Form1.submit();
		     }
		  }
		  
		</script>
	</HEAD>
	<body class="cuerpo2" ms_positioning="GridLayout">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Liberación de 
				MSISDN</b></font>
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblError" runat="server" Font-Names="Arial" Font-Bold="True" ForeColor="Red"
							Font-Size="Small"></asp:label><asp:label id="lblRes" runat="server" Font-Names="Arial" Font-Bold="True" ForeColor="Blue"
							Font-Size="Small"></asp:label></td>
				</tr>
			</table>
			<table class="tabla">
				<TR>
					<TD style="HEIGHT: 16px" colSpan="2">
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="../images/loader_black.gif"><FONT face="arial" size="2"><B>
									Verificando la existencia del MSISDN, por favor espere...</B></FONT></DIV>
					</TD>
				</TR>
			</table>
			<table class="tabla" borderColor="#f0f0f0" cellSpacing="1" cellPadding="1" width="500"
				border="1">
				<TR>
					<TD width="100" bgColor="#f0f0f0"><asp:label id="Label1" runat="server" Font-Bold="True">MSISDN:</asp:label></TD>
					<TD><asp:textbox id="txtMin" onkeydown="makeSubmit();" runat="server" MaxLength="10"></asp:textbox><FONT color="#0000ff" size="2">*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</FONT>&nbsp;&nbsp;<asp:button id="btnContinuar" onmouseover="hButtonPress.value='buscar';" onfocus="hButtonPress.value='buscar';"
							onmouseout="hButtonPress.value='';" runat="server" CssClass="boton" Text="Consultar"></asp:button><INPUT id="hButtonPress" style="WIDTH: 29px; HEIGHT: 22px" type="hidden" size="1" name="hButtonPress"
							runat="server"></TD>
				</TR>
				<TR>
					<TD colSpan="2"><FONT color="#0000ff" size="2">*</FONT> Campo Obligatorio</TD>
				</TR>
			</table>
			<br>
			<br>
			<asp:panel id="pnlDatos" runat="server" Visible="False">
				<TABLE class="tabla" borderColor="#f0f0f0" cellSpacing="1" cellPadding="1" border="1">
					<TR>
						<TD align="center" bgColor="#dddddd" colSpan="2">
							<asp:label id="Label3" runat="server" Font-Bold="True">INFORMACIÓN DE LA FACTURA</asp:label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label2" runat="server" Font-Bold="True">Factura:</asp:label></TD>
						<TD width="380">
							<asp:Label id="lblFactura" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label4" runat="server" Font-Bold="True">IMEI:</asp:label></TD>
						<TD>
							<asp:Label id="lblSerial" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label5" runat="server" Font-Bold="True">ICCID:</asp:label></TD>
						<TD>
							<asp:Label id="lblSim" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label6" runat="server" Font-Bold="True">MSISDN:</asp:label></TD>
						<TD>
							<asp:Label id="lblMin" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label7" runat="server" Font-Bold="True">Tipo de Factura:</asp:label></TD>
						<TD>
							<asp:Label id="lblTipoFactura" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label8" runat="server" Font-Bold="True">POS:</asp:label></TD>
						<TD>
							<asp:Label id="lblPos" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="120" bgColor="#f0f0f0">
							<asp:label id="Label9" runat="server" Font-Bold="True">Fecha de Venta:</asp:label></TD>
						<TD>
							<asp:Label id="lblFechaVenta" runat="server"></asp:Label></TD>
					</TR>
					<TR>
						<TD colSpan="2"><BR>
							<BR>
							<asp:button id="btnLiberar" onmouseover="hButtonPress.value='liberar';" onfocus="hButtonPress.value='liberar';"
								onmouseout="hButtonPress.value='';" runat="server" CssClass="boton" Text="Liberar MSISDN"></asp:button><INPUT id="hTransaccion" style="WIDTH: 29px; HEIGHT: 22px" type="hidden" size="1" name="hTransaccion"
								runat="server"></TD>
					</TR>
				</TABLE>
			</asp:panel></form>
	</body>
</HTML>
