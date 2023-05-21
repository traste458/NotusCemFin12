<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="SerialCambioCAC.aspx.vb" Inherits="BPColSysOP.SerialCambioCAC"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SerialCambioCAC</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<LINK href="../include/style_ventana.css" type="text/css" rel="stylesheet">
		<script src="../include/jquery-1.js" type="text/javascript"></script>
		<script language="javascript" src="../include/jscript_ventana.js" type="text/javascript"></script>
		<script language="jscript" type="text/javascript">
		    String.prototype.trim = function() { return this.replace(/^[\s\t\n\r]+|[\s\t\n\r]+$/g, ""); }
		    var expresionEstructuraSerial = /^[0-9]+$/
		  function subirVetana(){
			mostrarVentana(650,300,document.getElementById('divRegistroCambio'));
		  }
		 function registrarCambio(){
		 if (jQuery.trim(document.getElementById("txtSerialNEW").value) == ""){
		 	alert("Debe digitar el serial nuevo, por favor");
		 }

		 else {
		     if (!expresionEstructuraSerial.test(document.getElementById("txtSerialNEW").value)) {
		         alert("Serial contiene Caracteres no Validos, no se Registra");
		     }
		     else {
		         if (document.getElementById("ddlProducto").value == "0") {
		             alert("Debe Seleccionar el producto del serial nuevo, por favor");
		         }
		         else {
		             if (document.getElementById("ddlSubproducto").value == "0") {
		                 alert("Debe Seleccionar la referencia del serial nuevo, por favor");
		             }
		             else {
		                 Anthem_InvokePageMethod('registrarSerialNEW', [document.getElementById("txtSerialNEW").value, document.getElementById("ddlProducto").value, document.getElementById("ddlSubproducto").value]);
		             }

		         }
		     }
		 }
			
		 }
		 function buscarSubproducto() {
		    Anthem_InvokePageMethod('buscarSubproducto',[document.getElementById("ddlProducto").value]);
		 }
		</script>
	</HEAD>
	<body class="cuerpo2" onscroll="if(document.getElementById('divContenedorVentana').style.visible == 'visible'){javascript:centrarVentana(document.getElementById('divVentana'))};"
		onload="javascript:crearAreaMostrado();">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b><FONT face="Arial, Helvetica, sans-serif" color="black" size="4">
					<B>Serial que se Actualizará en el Inventario CAC</B></FONT><BR>
			</b></font>
		<hr>
		<form id="Form1" method="post" runat="server">
			<TABLE class="tabla" width="90%">
				<TR>
					<TD><asp:hyperlink id="hlRegresar" runat="server" NavigateUrl="BuscarserialCambio.aspx">Regresar</asp:hyperlink><BR>
						<BR>
					</TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 16px" align="center"></TD>
				</TR>
				<TR>
					<TD align="center"><anthem:label id="lblError" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" Font-Size="X-Small"
							ForeColor="Red"></anthem:label><anthem:label id="lblRes" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" Font-Size="X-Small"
							ForeColor="Blue"></anthem:label></TD>
				</TR>
			</TABLE>
			<TABLE class="tabla" borderColor="#f0f0f0" cellSpacing="1" cellPadding="1" >
				<TR>
					<TD colSpan="2"><anthem:datagrid id="dgSeriales" runat="server" CssClass="tabla" AutoGenerateColumns="False" ShowFooter="True" AutoUpdateAfterCallBack="true"  >
							<AlternatingItemStyle BackColor="Beige"></AlternatingItemStyle>
							<HeaderStyle CssClass="header"></HeaderStyle>
							<Columns>
								<asp:TemplateColumn HeaderText="Actualizar">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
									<ItemTemplate>
										<anthem:ImageButton id="ImageButton1" runat="server" ImageUrl="../images/editar.gif" CommandName="edit"
											ToolTip="Cambiar Serial" PostCallBackFunction="subirVetana" ImageUrlDuringCallBack="../images/loader_cake.gif"></anthem:ImageButton>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:BoundColumn DataField="Serial" HeaderText="Serial"></asp:BoundColumn>
								<asp:BoundColumn DataField="SerialNew" HeaderText="Serial Anterior"></asp:BoundColumn>
								<asp:BoundColumn DataField="Producto" HeaderText="Producto"></asp:BoundColumn>
								<asp:BoundColumn DataField="Subproducto" HeaderText="Referencia"></asp:BoundColumn>
								<asp:BoundColumn DataField="cac" HeaderText="CAC"></asp:BoundColumn>
								<asp:BoundColumn DataField="orden" HeaderText="Orden de Lectura"></asp:BoundColumn>
							</Columns>
						</anthem:datagrid><BR>
					</TD>
				</TR>
			</TABLE>
			<div id="divRegistroCambio" style="VISIBILITY: hidden; TEXT-ALIGN: center"><br>
				<br>
				<TABLE class="tabla" borderColor="#f0f0f0" cellSpacing="1" cellPadding="1" border="1">
					<TR>
						<TD style="HEIGHT: 16px" bgColor="#f0f0f0"><asp:label id="Label6" runat="server" Font-Bold="True">Serial A Cambiar:</asp:label></TD>
						<TD style="HEIGHT: 16px"><anthem:label id="lblSeriaOLD" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
					</TR>
					<TR>
						<TD style="HEIGHT: 16px" bgColor="#f0f0f0"><asp:label id="Label8" runat="server" Font-Bold="True">Nombre CAC:</asp:label></TD>
						<TD style="HEIGHT: 16px"><anthem:label id="lblCAC" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
					</TR>
					<TR>
						<TD style="HEIGHT: 16px" bgColor="#f0f0f0"><asp:label id="Label9" runat="server" Font-Bold="True">Referencia:</asp:label></TD>
						<TD style="HEIGHT: 16px"><anthem:label id="lblReferencia" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
					</TR>
					<TR>
						<TD style="HEIGHT: 16px" bgColor="#f0f0f0"><asp:label id="Label4" runat="server" Font-Bold="True">Serial Nuevo:</asp:label></TD>
						<TD style="HEIGHT: 16px" colSpan="1"><anthem:textbox id="txtSerialNEW" runat="server" MaxLength="20"></anthem:textbox>&nbsp;<FONT color="#ff0000" size="2">*</FONT>&nbsp;</TD>
					</TR>
					<TR>
						<TD bgColor="#f0f0f0"><asp:label id="Label5" runat="server" Font-Bold="True"> Producto:</asp:label></TD>
						<TD><anthem:dropdownlist id="ddlProducto" runat="server" PreCallBackFunction="buscarSubproducto" AutoCallBack="true" ></anthem:dropdownlist><FONT color="#ff0000" size="2">*</FONT></TD>
					</TR>
					<TR>
						<TD bgColor="#f0f0f0"><asp:label id="Label7" runat="server" Font-Bold="True">Material:</asp:label></TD>
						<TD><anthem:dropdownlist id="ddlSubproducto" runat="server" AutoUpdateAfterCallBack="True"></anthem:dropdownlist><FONT color="#ff0000" size="2">*</FONT></TD>
					</TR>
					<TR>
						<TD colSpan="2"><FONT color="#ff0000" size="2">&nbsp;*</FONT>&nbsp;&nbsp;Campo 
							Obligatorio<BR>
							<BR>
						</TD>
					</TR>
					<!--	<TR>
						<TD colSpan="2">
							<asp:Button id="btnCambiar" runat="server" Text="Cambiar Serial" CssClass="boton2"></asp:Button></TD>
					</TR>--></TABLE>
				<br>
				&nbsp; <INPUT class="boton2" id="btCambiar" onclick="registrarCambio()" type="button" value="Cambiar Serial"
					name="btAsignar">
			</div>
		</form>
	</body>
</HTML>
