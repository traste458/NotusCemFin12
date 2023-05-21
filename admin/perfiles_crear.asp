<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.perfil.value == "")
        {
        alert ("Escriba el Nombre del Perfil, Por Favor");
        document.forma.perfil.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Perfiles - Modulo de Administración </b>"
Response.write session("titulo")
%>
<hr>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<%
estado = request.querystring("estado")
if estado = 1 then  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face="verdana">Perfil Creado</FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <CENTER><FONT COLOR="RED" SIZE="3" face="verdana"><b>Ya existe un perfil con ese nombre. Perfil No Creado</b></FONT></CENTER>
<%  
end if

%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="perfiles_crear2.asp" onSubmit="return validacion()">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Nombre del Perfil:</B></TD>
    <TD><input type=text NAME="perfil" maxlength=30 size=30></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Perfil" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.perfil.focus();
</SCRIPT>
</HTML>