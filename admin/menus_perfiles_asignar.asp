<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
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
<% session("titulo") = "<b>Asignar Menus a Perfil - Modulo de Administración </b>"
Response.write session("titulo")
%>
<hr>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="menus_perfiles_asignar2.asp" onSubmit="return validacion()">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Nombre del Perfil:</B></TD>
    <TD BGCOLOR="#DDDDDD">
    <select name="idperfil">
    <%
    sql = "select idperfil, perfil from perfiles order by perfil"
    set rs = conn.execute(sql)
    while not rs.eof
    %>
    <option value="<%=rs("idperfil")%>"><%=rs("perfil")%></option>
    <%
    rs.movenext
    wend
    %>
    </select>
    </TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Continuar" class="boton">
</UL>
</FORM>
</BODY> 
</HTML>
<%
conn.close
%>