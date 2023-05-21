<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.tipoentrega.value == "")
        {
        alert ("Escriba el nombre del Tipo de Entrega, Por Favor");
        document.forma.tipoentrega.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Tipos de Entrega</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<%
bandera = request.querystring("bandera")
if bandera = 4 then
  tipoentrega = request.querystring("tipoentrega")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>Tipo de Entrega <%=tipoentrega%> REGISTRADO</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="tipoentregas_crear2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Tipo de entrega:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="tipoentrega" SIZE="40" MAXLENGTH="80" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Estado:</B></TD>
    <TD>
      <SELECT NAME="estado">
        <OPTION VALUE="1">Activo</OPTION>
        <OPTION VALUE="2">Inactivo</OPTION>
      </SELECT>
    </TD>   
  </TR>
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Tipo de Entrega" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>