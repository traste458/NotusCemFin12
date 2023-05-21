<%@ Register TagPrefix="anthem" Namespace="Anthem" Assembly="Anthem"%>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="CambiarClaveWap.aspx.vb" Inherits="BPColSysOP.CambiarClaveWap" culture="es-CO" uiCulture="es-CO" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>cambiar_Clave_Wap</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  String.prototype.trim = function (){return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g,"")}
		  function validacion(){
		    try{
	          var forma = document.Form1;
	          if(forma.ddlNombres.value==""||forma.ddlNombres.value=="0"){
	            alert("Escoja el Usuario al cual desea cambiar/asignar clave, Por favor");
	            forma.ddlNombres.focus();
	            return(false);
   	          }
   	          if(forma.hCrearUsuario.value=="si"){
   	            if(forma.txtUsuario.value.trim()==""){
   	              alert("Digite el nombre Usuario que desea asignarle a la persona para su ingreso al Sistema, Por favor");
   	              forma.txtUsuario.focus();
   	              return(false);
   	            }
   	          }
   	          if(forma.txtClaveNueva.value.trim()==""){
	            alert("Digite la nueva clave del Usuario, Por favor");
	            forma.txtClaveNueva.focus();
	            return(false);
	          }
	          if(forma.txtClaveNueva.value.length<5){
	            alert("La clave no cumple con los requisitos de seguridad.\nDebe tener como mínimo 5 caracteres.");
	            forma.txtClaveNueva.focus();
	            return(false);
	          }
	          var index = forma.ddlNombres.selectedIndex;
	          var nombre = forma.ddlNombres[index].text.toLowerCase();
	          var arrayNombre = new Array();
	          var laClave = forma.txtClaveNueva.value.toLowerCase();
	          arrayNombre = nombre.split(" ");
	          for(i=0;i<arrayNombre.length;i++){
	            if(laClave.indexOf(arrayNombre[i].trim())!=-1){
	              alert("La clave no cumple con los requisitos de seguridad.\nNo puede contener partes del nombre o identificación del usuario.");
	              forma.txtClaveNueva.focus();
	              return(false);
	            }
	          }
	          if(forma.txtRepetirClave.value.trim()==""){
	            alert("Digite nuevamente la nueva clave del Usuario, Por favor");
	            forma.txtRepetirClave.focus();
	            return(false);
	          }
	          if(forma.txtClaveNueva.value.trim()!=forma.txtRepetirClave.value.trim()) {
	            alert("Las claves proporcionadas no coinciden. Por favor verifique");
	            forma.txtRepetirClave.value="";
	            forma.txtRepetirClave.focus();
   	            return(false);
	          }
            }catch(ex){
             alert("Ocurrió un error al aplicar validaciones. "+ex.name+" - "+ex.description);
             return(false);
            }
	      }//fin de function
	             
	      function aplicarFiltroNombres(){
	        var cedula = document.Form1.txtCedula.value;
	        Anthem_InvokePageMethod('filtrarNombres',[cedula])
	        document.Form1.txtCedula.focus();
	      }
	            
		</script>
	</HEAD>
	<body class="cuerpo2">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Cambiar Clave WAP</b></font>
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><anthem:label id="lblError" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" ForeColor="Red"></anthem:label><anthem:label id="lblResp" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" ForeColor="Blue"></anthem:label></td>
				</tr>
			</table>
			<br>
			<br>
			<TABLE class="tabla" borderColor="#f0f0f0" cellSpacing="1" cellPadding="1" border="1">
				<TR>
					<TD bgColor="#f0f0f0"><asp:label id="Label19" runat="server" Font-Bold="True">Nombre:</asp:label></TD>
					<TD><font color="blue" size="2"><asp:textbox id="txtCedula" onpropertychange="aplicarFiltroNombres();" runat="server" CssClass="textbox"
								Width="90px"></asp:textbox>&nbsp;-&nbsp;<anthem:dropdownlist id="ddlNombres" AutoUpdateAfterCallBack="True" Runat="server" AutoCallBack="True"
								TextDuringCallBack="Cargando Informacion ..."></anthem:dropdownlist>*&nbsp;
							<anthem:label id="lblNumNombres" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True"></anthem:label></font>&nbsp;
					</TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 20px" bgColor="#f0f0f0"><asp:label id="Label5" runat="server" Font-Bold="True">Cargo:</asp:label></TD>
					<TD style="HEIGHT: 20px"><anthem:label id="lblCargo" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" CssClass="textbox"
							BorderStyle="Solid" BorderWidth="1px"></anthem:label></TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 20px" bgColor="#f0f0f0"><asp:label id="Label1" runat="server" Font-Bold="True">Usuario:</asp:label></TD>
					<TD style="HEIGHT: 20px" colSpan="1"><anthem:textbox id="txtUsuario" runat="server" AutoUpdateAfterCallBack="True" Width="152px" EnabledDuringCallBack="False"
							ReadOnly="True" MaxLength="30" BackColor="WhiteSmoke"></anthem:textbox><FONT color="gray" size="2">*<INPUT id="hCrearUsuario" style="WIDTH: 19px; HEIGHT: 22px" type="hidden" size="1" name="hCrearUsuario"
								runat="server"></FONT></TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0"><anthem:label id="Label2" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True">Clave Actual:</anthem:label></TD>
					<TD><anthem:textbox id="txtClaveActual" runat="server" AutoUpdateAfterCallBack="True" Width="152px"
							BackColor="WhiteSmoke" EnabledDuringCallBack="False" ReadOnly="True" MaxLength="15" TextMode="Password"></anthem:textbox></TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0"><anthem:label id="Label3" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True">Clave Nueva:</anthem:label></TD>
					<TD><anthem:textbox id="txtClaveNueva" runat="server" AutoUpdateAfterCallBack="True" Width="152px" textmode="password"></anthem:textbox><FONT color="blue" size="2">*</FONT></TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0"><anthem:label id="Label4" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True">Confirmar Clave:</anthem:label></TD>
					<TD><anthem:textbox id="txtRepetirClave" runat="server" AutoUpdateAfterCallBack="True" Width="152px"
							textmode="password"></anthem:textbox><FONT color="blue" size="2">*</FONT></TD>
				</TR>
				<TR>
					<TD colSpan="2"><FONT color="blue" size="2">*</FONT> Campo Obligatorio<br>
						<FONT color="blue" size="2">*</FONT> Campo Requerido para Cambio o Asignación 
						de Clave
					</TD>
				</TR>
			</TABLE>
			<br>
			<table class="tabla">
				<TR>
					<TD colSpan="2"><asp:button id="btnCrear" runat="server" CssClass="boton" Text="Actualizar"></asp:button></TD>
				</TR>
			</table>
			<br>
			<TABLE class="tabla">
				<TR>
					<TD><anthem:linkbutton id="lbConsultar" runat="server" Font-Bold="True" ForeColor="Blue" AutoUpdateAfterCallBack="True"
							TextDuringCallBack="Consultando Historial ..." EnabledDuringCallBack="False" Visible="False"><img src="../images/historial.gif" border="0" width="20" height="16" />&nbsp;Ver Historial del Usuario</anthem:linkbutton></TD>
				</TR>
				<TR>
					<TD><anthem:panel id="pnlHistorial" runat="server" AutoUpdateAfterCallBack="True" Visible="False">
							<TABLE class="tabla">
								<TR>
									<TD align="center" bgColor="#f0f0f0" colSpan="4">
										<asp:label id="Label6" runat="server" Font-Bold="True">Datos del Usuario:</asp:label></TD>
								</TR>
								<TR>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label18" runat="server" Font-Bold="True">Nombres y Apellidos:</asp:label></TD>
									<TD>
										<anthem:label id="lblNombres" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label12" runat="server" Font-Bold="True">Identificación:</asp:label></TD>
									<TD>
										<anthem:label id="lblIdentificacion" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
								</TR>
								<TR>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label7" runat="server" Font-Bold="True">Cargo:</asp:label></TD>
									<TD>
										<anthem:label id="lblCargoAct" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label13" runat="server" Font-Bold="True">Ciudad:</asp:label></TD>
									<TD>
										<anthem:label id="lblCiudad" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
								</TR>
								<TR>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label8" runat="server" Font-Bold="True">POS:</asp:label></TD>
									<TD>
										<anthem:label id="lblPos" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label14" runat="server" Font-Bold="True">Centro de Costo:</asp:label></TD>
									<TD>
										<anthem:label id="lblCentroCosto" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
								</TR>
								<TR>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label9" runat="server" Font-Bold="True">Empresa Temporal:</asp:label></TD>
									<TD>
										<anthem:label id="lblTemporal" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label15" runat="server" Font-Bold="True">Fecha de Ingreso:</asp:label></TD>
									<TD>
										<anthem:label id="lblFechaIngreso" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
								</TR>
								<TR>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label10" runat="server" Font-Bold="True">Usuario:</asp:label></TD>
									<TD>
										<anthem:label id="lblUsuario" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label16" runat="server" Font-Bold="True">Estado:</asp:label></TD>
									<TD>
										<anthem:label id="lblEstado" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
								</TR>
								<TR>
									<TD bgColor="#f0f0f0">
										<asp:label id="Label11" runat="server" Font-Bold="True">Teléfono:</asp:label></TD>
									<TD colSpan="3">
										<anthem:label id="lblTelefono" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
								</TR>
							</TABLE>
							<BR>
							<TABLE class="tabla">
								<TR>
									<TD align="center" bgColor="#f0f0f0">
										<asp:label id="Label17" runat="server" Font-Bold="True">Historial de Movimientos</asp:label></TD>
								</TR>
								<TR>
									<TD>
										<asp:DataGrid id="dgHistorial" runat="server" CssClass="tabla" AutoGenerateColumns="False">
											<AlternatingItemStyle BackColor="#F8F8F8"></AlternatingItemStyle>
											<HeaderStyle Font-Bold="True" HorizontalAlign="Center" BackColor="#F0F0F0"></HeaderStyle>
											<Columns>
												<asp:BoundColumn DataField="cargo" HeaderText="CARGO"></asp:BoundColumn>
												<asp:BoundColumn DataField="centroCosto" HeaderText="CENTRO DE COSTO"></asp:BoundColumn>
												<asp:BoundColumn DataField="pos" HeaderText="POS"></asp:BoundColumn>
												<asp:BoundColumn DataField="empresaTemporal" HeaderText="EMPRESA TEMPORAL"></asp:BoundColumn>
												<asp:BoundColumn DataField="fecha_inicial" HeaderText="FECHA INICIAL" DataFormatString="{0:dd-MMM-yyyy}">
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:BoundColumn>
												<asp:BoundColumn DataField="fecha_final" HeaderText="FECHA FINAL" DataFormatString="{0:dd-MMM-yyyy}">
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:BoundColumn>
												<asp:BoundColumn DataField="estado" HeaderText="ESTADO">
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:BoundColumn>
												<asp:BoundColumn DataField="modificador" HeaderText="MODIFICADO POR"></asp:BoundColumn>
											</Columns>
										</asp:DataGrid></TD>
								</TR>
							</TABLE>
						</anthem:panel></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>
