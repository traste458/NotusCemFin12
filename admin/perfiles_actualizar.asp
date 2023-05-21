<!--#include file="../include/seguridad.inc.asp"-->
<HTML>
<HEAD>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.perfil.value == "")
        {
        alert ("Escriba el nombre del Perfil, Por Favor");
        document.forma.perfil.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF" class="cuerpo2">
<% session("titulo") = "<b>Buscar Perfiles - Modulo de Administración</b>"
Response.write session("titulo")
%>
<hr>
<!--#include file="../include/conexion.inc.asp"-->
<%
estado = request.querystring("estado")
idperfil = request.querystring("idperfil")

if estado = 1 then  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4">Perfil Actualizado</FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <CENTER><FONT COLOR="RED" SIZE="4">Ya existe un perfil con ese nombre. Perfil No Actualizado</FONT></CENTER>
<%  
end if

sql = "select idperfil, perfil from perfiles where idperfil = " & idperfil
'response.write(sql)
'response.end

set rs=conn.execute(sql)

%>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="perfiles_actualizar2.asp" onSubmit="return validacion()">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Perfil:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="perfil" SIZE="30" MAXLENGTH="30" value="<%=trim(rs("perfil"))%>"></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Actualizar Perfil" class="boton">
</UL>
<INPUT TYPE="HIDDEN" NAME="idperfil" VALUE="<%=idperfil%>">
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.perfil.focus();
</SCRIPT>
</HTML>