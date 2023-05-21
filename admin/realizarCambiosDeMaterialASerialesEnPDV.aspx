<%@ Register TagPrefix="anthem" Namespace="Anthem" Assembly="Anthem" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="realizarCambiosDeMaterialASerialesEnPDV.aspx.vb" Inherits="BPColSysOP.realizarCambiosDeMaterialASerialesEnPDV" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>realizarCambiosDeMaterialASerialesEnPDV</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  String.prototype.trim = function(){return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g,"");}
		  function validacion(){
		    var forma = document.Form1;
		    if(forma.hButtonPress.value=="archivo"){
		      if(forma.flArchivo.value==""){
		        document.getElementById("divImagen").style.display="none";
		        alert("Escoja el Archivo que desea procesar, Por favor");
		        forma.flArchivo.focus();
		        return(false);
		      }
		    }
		    if(forma.hButtonPress.value=="unSerial"){
		      if(forma.txtCodigoMay.value.trim()==""){
		        alert("Digite el Código MAY, Por favor");
		        forma.txtCodigoMay.focus();
		        return(false);
		      }
		      if(forma.txtSerial.value.trim()==""){
		        alert("Digite el Serial, Por favor");
		        forma.txtSerial.focus();
		        return(false);
		      }
		      var expReg = /^[0-9]+$/
		      if(!expReg.test(forma.txtSerial.value)){
		        alert("El Serial digitado no es válido, este campo es numérico.\nDigite un número válido, Por favor");
		        forma.txtSerial.select();
		        return(false);
		      }
		      if(forma.txtMaterialActual.value.trim()==""){
		        alert("Digite el Material Actual, Por favor");
		        forma.txtMaterialActual.focus();
		        return(false);
		      }
		      if(forma.txtNuevoMaterial.value.trim()==""){
		        alert("Digite el Nuevo Material, Por favor");
		        forma.txtNuevoMaterial.focus();
		        return(false);
		      }
		      if(forma.txtMaterialActual.value.trim()==forma.txtNuevoMaterial.value.trim()){
		        alert("El Nuevo Material debe ser diferente al Material Actual");
		        forma.txtNuevoMaterial.focus();
		        return(false);
		      }
		    }
		  }
		  
		  function makeSubmit(btn){
		    var forma = document.Form1;
		    if(event.keyCode==13){
		      event.returnValue = false;
		      event.cancel = true;
		      if(btn.name=="btnCambiar"){
		        forma.hButtonPress.value = "unSerial"
		      }else{
		        forma.hButtonPress.value = "archivo"
		      }
		      btn.click();
		    }
		  }
		  
		  function setButtonPress(btn){
		    var forma = document.Form1;
			if(btn.name == "btnCambiar"){
			  forma.hButtonPress.value = "unSerial";
			}else{
			  forma.hButtonPress.value = "cancelar";
			}
	      }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Registrar Cambios 
				de Material de Seriales En PDV</b></font>&nbsp;
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="images/loader.gif"><font face="arial" size="2"><b>
									Procesando archivo, por favor espere...</b></font><br>
							<br>
							<INPUT id="hButtonPress" style="WIDTH: 12px; HEIGHT: 22px" type="hidden" size="1" name="hButtonPress">
						</DIV>
					</td>
				</tr>
				<tr>
					<td align="center"><anthem:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red" AutoUpdateAfterCallBack="True"></anthem:label><anthem:label id="lblRes" runat="server" Font-Bold="True" ForeColor="Blue" AutoUpdateAfterCallBack="True"></anthem:label></td>
				</tr>
			</table>
			<table class="tabla" width="600">
				<tr>
					<td>
						<fieldset>
							<legend>
								<font color="blue" face="arial" size="2"><b>Realizar Cambio de Un Serial</b> </font>
							</legend>
							<table class="tabla" id="tablaUnSerial" width="100%">
								<TR>
									<td class="celdaTitulo" width="150">Código MAY:</td>
									<td class="celdaNormal">
										<asp:TextBox id="txtCodigoMay" onkeydown="makeSubmit(btnCambiar);" runat="server" CssClass="textbox"
											MaxLength="20"></asp:TextBox></td>
								</TR>
								<TR>
									<TD class="celdaTitulo" width="150">Serial (IMEI/ICCID):</TD>
									<TD class="celdaNormal">
										<asp:TextBox id="txtSerial" onkeydown="makeSubmit(btnCambiar);" runat="server" CssClass="textbox"
											MaxLength="17"></asp:TextBox></TD>
								</TR>
								<TR>
									<TD class="celdaTitulo" width="150">Meterial Actual:</TD>
									<TD class="celdaNormal">
										<asp:TextBox id="txtMaterialActual" onkeydown="makeSubmit(btnCambiar);" runat="server" CssClass="textbox"
											Width="50px" MaxLength="10"></asp:TextBox></TD>
								</TR>
								<TR>
									<TD class="celdaTitulo" width="150">Nuevo Material:</TD>
									<TD class="celdaNormal">
										<asp:TextBox id="txtNuevoMaterial" onkeydown="makeSubmit(btnCambiar);" runat="server" CssClass="textbox"
											Width="50px" MaxLength="10"></asp:TextBox></TD>
								</TR>
								<tr>
									<td colSpan="2"><br>
										<br>
										<asp:button id="btnCambiar" onmouseover="setButtonPress(this);" onfocus="setButtonPress(this);"
											runat="server" CssClass="boton" Text="Procesar Serial"></asp:button></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
			<br>
			<table class="tabla" width="600">
				<tr>
					<td>
						<fieldset>
							<legend>
								<font color="blue" face="arial" size="2"><b>Realizar Cambio a Través de Archivo</b> </font>
							</legend>
							<table class="tabla" id="tablaInicial" width="100%">
								<TR>
									<TD class="celdaNormal" width="200" colSpan="2"></TD>
								</TR>
								<tr>
									<td class="celdaTitulo" width="140">Archivo con Seriales:</td>
									<td class="celdaNormal" width="200"><INPUT class="textbox" id="flArchivo" onkeydown="makeSubmit(btnProcesar);" style="WIDTH: 400px; HEIGHT: 19px"
											type="file" size="34" name="flArchivo" runat="server"></td>
								</tr>
								<tr>
									<td colSpan="2"><br>
										<br>
										<asp:button id="btnProcesar" onmouseover="setButtonPress(this);" onfocus="setButtonPress(this);"
											runat="server" CssClass="boton" Text="Procesar Archivo"></asp:button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<asp:HyperLink id="hlEjemplo" runat="server" Font-Bold="True" ForeColor="Blue" NavigateUrl="ejemplo.txt"
											Target="_search">Ver Archivo Ejemplo</asp:HyperLink></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
			<br>
			<asp:Panel Runat="server" ID="pnlErrores" Visible="False">
				<TABLE class="tabla" width="90%">
					<TR>
						<TD>
							<asp:label id="Label1" runat="server" Font-Bold="True" ForeColor="Maroon">Fue imposible cambiar el Material de algun(os) Serial(es).</asp:label>&nbsp;&nbsp;&nbsp;&nbsp;
							<anthem:LinkButton id="lbVerDetalle" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True"
								ForeColor="RoyalBlue" TextDuringCallBack="Enlazando datos ...">Ver Detalle de Seriales sin Cambiar</anthem:LinkButton></TD>
					</TR>
					<TR>
						<TD>
							<anthem:DataGrid id="dgDetalleErrores" runat="server" AutoUpdateAfterCallBack="True" CssClass="tabla"
								Visible="False" AutoGenerateColumns="False" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px"
								BackColor="White" CellPadding="3" GridLines="Horizontal" ShowFooter="True" UpdateAfterCallBack="True">
								<PagerStyle HorizontalAlign="Right" ForeColor="#4A3C8C" BackColor="#E7E7FF" Mode="NumericPages"></PagerStyle>
								<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
								<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
								<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
								<ItemStyle ForeColor="#4A3C8C" BackColor="#E7E7FF"></ItemStyle>
								<HeaderStyle Font-Bold="True" HorizontalAlign="Center" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
								<Columns>
									<asp:BoundColumn DataField="serial" HeaderText="Serial"></asp:BoundColumn>
									<asp:BoundColumn DataField="error" HeaderText="Error">
										<FooterStyle HorizontalAlign="Center"></FooterStyle>
									</asp:BoundColumn>
									<asp:BoundColumn DataField="linea" HeaderText="L&#237;nea"></asp:BoundColumn>
								</Columns>
							</anthem:DataGrid></TD>
					</TR>
				</TABLE>
			</asp:Panel>
		</form>
	</body>
</HTML>
