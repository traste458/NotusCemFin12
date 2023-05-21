<%@ Page Language="vb" AutoEventWireup="false" Codebehind="BuscarserialCambio.aspx.vb" Inherits="BPColSysOP.BuscarserialCambio"%>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>BuscarserialCambio</title>
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
		       if (jQuery.trim(forma.archivosSeriales.value) == "" && jQuery.trim(forma.txtSerial.value) == "" && forma.ddlCAC.value == "0") {
					divImagen.style.display = 'none';
					alert("Por favor seleccion por lo menos un criterio de busqueda");
					return(false);
		  }
		  var expRegSerial = /^[a-zA-Z0-9]+$/;
		  var expRegArchivo = /^([a-zA-Z0-9_\.\-\\\:\s])+(.txt){1}$/;
		  //var expRegArchivo = /^([\*\|\!\?])+(.txt){1}$/;
		   	if (forma.archivosSeriales.value != ""){
		   	    if (!expRegArchivo.test(jQuery.trim(forma.archivosSeriales.value))) {
					divImagen.style.display = 'none';
					alert("El archivo seleccionado no corresponde al formato permitido, por favor verifiquelo");
					return(false);
				   }
			}
			if (forma.txtSerial.value != "") {
			    if (!expRegSerial.test(jQuery.trim(forma.txtSerial.value))) {
			        divImagen.style.display = 'none';
			        alert("El serial contiene caracteres no validos, por favor verifiquelo");
			        return (false);
			    }
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
		 		  
		  function BuscarCAC(valor){
		  		Anthem_InvokePageMethod('BuscarCACFiltrado',[valor]);
				}
		</script>
	</HEAD>
	<body class="cuerpo2" onload="document.Form1.txtSerial.focus();">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Buscar y Actualizar 
				Seriales&nbsp;CAC&nbsp; </b></font>
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<TABLE class="tabla" width="90%">
				<TR>
					<TD><asp:hyperlink id="hlRegresar" runat="server">Regresar</asp:hyperlink><BR>
						<BR>
					</TD>
				</TR>
				<TR>
					<TD align="center"></TD>
				</TR>
				<TR>
					<TD align="center"><anthem:label id="lblError" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" Font-Size="X-Small"
							ForeColor="Red"></anthem:label></TD>
				</TR>
			</TABLE>
			<ul>
				<asp:label id="Label3" runat="server" Font-Bold="True" Font-Size="X-Small" ForeColor="Gray"
					Font-Names="Arial" Font-Italic="True">Se debe proporcionar por lo menos un filtro de búsqueda</asp:label></ul>
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
					<TD colSpan="2"><A id="VerEjemplo" href="javascript:animacion('imagenEjemplo')"><FONT color="#0000ff">(Ver 
								archivo Ejemplo)</FONT></A>
						<DIV id="imagenEjemplo" style="DISPLAY: none; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial"
							name="imagenEjemplo"><IMG id="seriales" src="../images/SerialesTXT.png" name="seriales">
						</DIV>
					</TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 16px" bgColor="#f0f0f0"><asp:label id="Label1" runat="server" Font-Bold="True">Serial:</asp:label></TD>
					<TD style="HEIGHT: 16px" colSpan="1"><anthem:textbox id="txtSerial" runat="server" MaxLength="20"></anthem:textbox>&nbsp;<FONT color="#ff0000" size="2">*</FONT>&nbsp;</TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0"><asp:label id="Label2" runat="server" Font-Bold="True">Archivo Seriales:</asp:label></TD>
					<TD><INPUT id="archivosSeriales" style="WIDTH: 433px; HEIGHT: 22px" type="file" size="53" name="archivosSeriales"
							runat="server">&nbsp;&nbsp; <FONT color="#ff0000" size="2">*</FONT></TD>
				</TR>
				<TR>
					<TD bgColor="#f0f0f0"><asp:label id="Label5" runat="server" Font-Bold="True">CAC:</asp:label></TD>
					<TD><anthem:textbox id="txtNombreMay" onpropertychange="BuscarCAC(this.value)" runat="server" PostCallBackFunction="colocar()"
							Width="72px"></anthem:textbox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<anthem:dropdownlist id="ddlCAC" runat="server" AutoUpdateAfterCallBack="True"></anthem:dropdownlist>&nbsp;
						<anthem:label id="lblRegistros" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True"
							ForeColor="Green" Font-Italic="True"></anthem:label></TD>
				</TR>
			</TABLE>
			<TABLE class="tabla">
				<TR>
					<TD colSpan="2"><FONT color="#ff0000" size="2">&nbsp;*</FONT> &nbsp;Se omitirán los 
						demas filtros<BR>
						<BR>
					</TD>
				</TR>
				<TR>
					<TD colSpan="2"><asp:button id="btnConsultar" runat="server" Text="Consultar" CssClass="boton"></asp:button>&nbsp;
					</TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>
