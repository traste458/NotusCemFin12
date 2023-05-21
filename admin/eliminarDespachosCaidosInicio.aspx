<%@ Page Language="vb" AutoEventWireup="false" Codebehind="eliminarDespachosCaidosInicio.aspx.vb" Inherits="BPColSysOP.eliminarDespachosCaidosInicio" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>eliminarDespachosCaidosInicio</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		    if(document.Form1.flArchivo.value==""){
		      alert("Escoja el Archivo con la Resmisiones, Por Favor");
		      document.Form1.flArchivo.focus();
		      return(false);
		    }
		  }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Eliminar Remisiones 
				Caídas</b></font>
		<hr>
		<form id="Form1" method="post" runat="server" onsubmit="return validacion();">
			<table class="tabla" width="90%">
				<tr>
					<td>
						<asp:HyperLink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:HyperLink><br>
						<br>
					</td>
				</tr>
				<TR>
					<TD>
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="images/loader.gif"><font face="arial" size="2"><b>
									Realizando Proceso de Eliminación...</b></font><br>
							<br>
						</DIV>
					</TD>
				</TR>
				<tr>
					<td align="center">
						<asp:Label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
						<asp:Label id="lblRes" runat="server" Font-Bold="True" ForeColor="Blue"></asp:Label></td>
				</tr>
			</table>
			<table class="tabla">
				<tr>
					<td class="celdaTitulo">Archivo Remisiones:</td>
					<td class="celdaNormal" width="200"><font face="arial" size="2" color="blue"><INPUT class="textbox" type="file" size="50" id="flArchivo" name="flArchivo" runat="server">*
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="2"><font face="arial" size="2" color="blue">*</font> <font size="1">Campo 
							Obligatorio</font><br>
						<br>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:Button id="btnEliminar" runat="server" CssClass="boton" Text="Eliminar Remisiones"></asp:Button>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
