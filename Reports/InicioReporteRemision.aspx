<%@ Page Language="vb" AutoEventWireup="false" Codebehind="InicioReporteRemision.aspx.vb" Inherits="BPColSysOP.InicioReporteRemision"%>
<%@ Register TagPrefix="anthem" Namespace="Anthem" Assembly="Anthem" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>InicioReporteRemision</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<script src="../include/jquery-1.js" type="text/javascript"></script>
		<script src="../include/animatedcollapse.js" type="text/javascript"></script>
		<LINK media="all" href="../include/widget02.css" type="text/css" rel="stylesheet">
		<LINK href="../include/styleBACK.css" type="text/css" rel="stylesheet">
		<LINK href="../include/style_ventana.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="../include/jscript_ventana.js" type="text/javascript"></script>
		<script language="jscript" type="text/javascript">
		String.prototype.trim = function(){return this.replace(/^[\s\t\n\r]+|[\s\t\n\r]+$/g,"");}
		animatedcollapse.addDiv('imagenEjemplo', 'fade=2,height=350px')
		animatedcollapse.init()
		  function validacion(){
		  var forma = document.Form1 
			if(forma.txtRemision.value.trim()==""&&forma.archivosRemisiones.value.trim()==""&&forma.fechaInicial.value.trim()==""&&forma.fechaFinal.value.trim()==""){
				alert("Debido a lo pesado que puede resultar el reporte,\nes necesario establecer por lo menos un filtro de búsqueda.")	;
				forma.txtRemision.focus();
				return(false);
			}
		  	if(forma.fechaInicial.value==""&&forma.fechaFinal.value!=""){
		      document.getElementById("divImagen").style.display = "none";
		      alert("Escoja la Fecha Inicial (Desde), Por favor");
		      forma.fechaInicial.focus();
		      return(false);
		    }
		    if(forma.fechaFinal.value==""&&forma.fechaInicial.value!=""){
		      document.getElementById("divImagen").style.display = "none";
		      alert("Escoja la Fecha Final (Hasta), Por favor");
		      forma.fechaFinal.focus();
		      return(false);
		    }
		  }
		  function animacion(nombre){
		  	if (document.getElementById ('VerEjemplo').innerText  == '(Ver archivo Ejemplo)') {
				document.getElementById ('VerEjemplo').innerText = '(Ocultar Ejemplo)'
			}
			else {
				document.getElementById ('VerEjemplo').innerText = '(Ver archivo Ejemplo)' 
			}
		  	  animatedcollapse.toggle(nombre);
		 
		  }
		 
		</script>
	</HEAD>
	<body class="cuerpo2">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Reporte de 
				Remisiones y Novedades de Entrega </b></font>
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<TABLE class="tabla" width="90%">
				<TR>
					<TD>
						<asp:hyperlink id="hlRegresar" runat="server">Regresar</asp:hyperlink><BR>
						<BR>
					</TD>
				</TR>
				<TR>
					<TD align="center"></TD>
				</TR>
				<TR>
					<TD align="center">
						<anthem:label id="lblError" runat="server" ForeColor="Red" Font-Size="X-Small" AutoUpdateAfterCallBack="True"
							Font-Bold="True"></anthem:label></TD>
				</TR>
			</TABLE>
			<ul>
				<asp:Label id="Label3" runat="server" Font-Bold="True" ForeColor="Gray" Font-Italic="True"
					Font-Size="X-Small" Font-Names="Arial">Se debe proporcionar por lo menos un filtro de búsqueda</asp:Label>
			</ul>
			<TABLE class="tabla">
				<TR>
					<TD style="HEIGHT: 16px" colSpan="2">
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="../images/loader_black.gif"><FONT face="arial" size="2"><B>
									Generando reporte, por favor espere...</B></FONT></DIV>
					</TD>
				</TR>
			</TABLE>
			<TABLE class="tabla" borderColor="#f0f0f0" cellSpacing="1" cellPadding="1" border="1">
				<TR>
					<TD colSpan="2"><A href="javascript:animacion('imagenEjemplo')" id="VerEjemplo"><FONT color="#0000ff">(Ver 
								archivo Ejemplo)</FONT></A>
						<DIV id="imagenEjemplo" style="DISPLAY: none;  -moz-background-clip: -moz-initial;  -moz-background-origin: -moz-initial;  -moz-background-inline-policy: -moz-initial"
							name="imagenEjemplo"><IMG id="seriales" src="../images/RemisionesTXT.png" name="seriales">
						</DIV>
					</TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 16px" bgColor="#f0f0f0">
						<asp:label id="Label1" runat="server" Font-Bold="True">Número Remisión:</asp:label></TD>
					<TD style="HEIGHT: 16px">
						<anthem:TextBox id="txtRemision" runat="server" MaxLength="20"></anthem:TextBox>&nbsp;<FONT color="#ff0000" size="2">*<FONT color="#ff0000" size="2">*</FONT></FONT>&nbsp;</TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0">
						<asp:label id="Label2" runat="server" Font-Bold="True">Archivo Remisiones:</asp:label></TD>
					<TD><INPUT id="archivosRemisiones" type="file" name="archivosRemisiones" runat="server" style="WIDTH: 433px; HEIGHT: 22px"
							size="53">&nbsp;&nbsp; <FONT color="#ff0000" size="2">*<FONT color="#ff0000" size="2">*</FONT></FONT></TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0">
						<asp:label id="Label6" runat="server" Font-Bold="True">Fecha Remisión:</asp:label></TD>
					<TD>Desde <INPUT class="textbox" id="fechaInicial" readOnly size="11" name="fechaInicial" runat="server"><A hideFocus onclick="if(self.gfPop)gfPop.fStartPop(document.Form1.fechaInicial,document.Form1.fechaFinal);return false;"
							href="javascript:void(0)"><IMG class="PopcalTrigger" height="22" alt="Seleccione una Fecha Inicial" src="../include/HelloWorld/calbtn.gif"
								width="34" align="absMiddle" border="0"></A>&nbsp;<FONT color="#ff0000" size="2">*</FONT>&nbsp; 
						Hasta <INPUT class="textbox" id="fechaFinal" readOnly size="11" name="fechaFinal" runat="server"><A hideFocus onclick="if(self.gfPop)gfPop.fEndPop(document.Form1.fechaInicial,document.Form1.fechaFinal);return false;"
							href="javascript:void(0)"><IMG class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/HelloWorld/calbtn.gif"
								width="34" align="absMiddle" border="0"></A>&nbsp;<FONT color="#ff0000" size="2">*</FONT>&nbsp;</TD>
				</TR>
			</TABLE>
			<TABLE class="tabla">
				<TR>
					<TD colSpan="2"><FONT color="#ff0000" size="2">*</FONT> Se deben proporcionar los 
						dos valores
						<BR>
						<FONT color="#ff0000" size="2">* *</FONT>&nbsp;Se omitirán el rangos de las 
						fechas<BR>
						<BR>
					</TD>
				</TR>
				<TR>
					<TD colSpan="2">
						<asp:button id="btnContinuar" runat="server" CssClass="boton" Text="Continuar"></asp:button>&nbsp;
					</TD>
				</TR>
			</TABLE> <!-- iframe para uso de selector de fechas --><IFRAME id="gToday:contrast:agenda.js" style="Z-INDEX: 999; POSITION: absolute; VISIBILITY: visible; TOP: -500px; LEFT: -500px"
				name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm" frameBorder="0" width="132" scrolling="no" height="142">
			</IFRAME>
		</form>
	</body>
</HTML>
