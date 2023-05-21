<!--#include file="../include/seguridad.inc.asp"-->
<HTML>
<HEAD>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Buscar Perfiles - Modulo de Administración</b>"
Response.write session("titulo")
%>
<hr>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="perfiles_buscar2.asp" onsubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Perfil:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="perfil" SIZE="30" MAXLENGTH="30">&nbsp;<font size=2 color=gray><i>Con una parte basta</i></font></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Buscar Ahora" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.perfil.focus();
</SCRIPT>
</HTML>