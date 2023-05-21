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
<% session("titulo") = "<b>Buscar Menus - Modulo de Administración</b>"
Response.write session("titulo")
%>
<hr>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="menus_buscar2.asp" onsubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Menu:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="menu" SIZE="30" MAXLENGTH="100">&nbsp;<font size=2 color=gray><i>Con una parte basta</i></font></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Buscar Ahora" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.menu.focus();
</SCRIPT>
</HTML>