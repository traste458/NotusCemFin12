<!--#include file="../include/seguridad.inc.asp"-->
<HTML>
<HEAD>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.menu.value == "")
        {
        alert ("Escriba el nombre del menu, Por Favor");
        document.forma.menu.focus();
        return (false);
        }
    if (document.forma.idmenupadre.value != "0")
        {
        if (document.forma.posicion.value == "")
           {
           alert ("Escriba la posición del menu, Por Favor");
           document.forma.posicion.focus();
           return (false);
           }
        }

    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF" class="cuerpo2">
<% session("titulo") = "<b>Buscar Menus - Modulo de Administración</b>"
Response.write session("titulo")
%>
<hr>
<!--#include file="../include/conexion.inc.asp"-->
<%
estado = request.querystring("estado")
idmenu = request.querystring("idmenu")


if estado = 1 then  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4">Menu Actualizado</FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <CENTER><FONT COLOR="RED" SIZE="4">Ya existe un menu con ese nombre. Menu No Actualizado</FONT></CENTER>
<%  
end if

sql = "select idmenu, menu, url, idmenupadre, posicion, (select menu from menus where idmenu = a.idmenupadre) as menupadre "
sql = sql & " from menus a where a.idmenu = " & idmenu
'response.write(sql)
'response.end

set rs=conn.execute(sql)
idmenupadre = rs("idmenupadre")
if (isnull(idmenupadre))  or (idmenupadre = "")  then
   idmenupadre = "0"
   menupadre = "Elija un Menu"
else
   idmenupadre = rs("idmenupadre")
   menupadre = trim(rs("menupadre"))
end if

%>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="menus_actualizar2.asp" onSubmit="return validacion()">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Menu:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="menu" SIZE="50" MAXLENGTH="100" value="<%=trim(rs("menu"))%>"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Url:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="url" SIZE="60" MAXLENGTH="100" value="<%=trim(rs("url"))%>"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Menu Padre:</B></TD>
    <TD>
        <select name = "idmenupadre">
          <option value=<%=idmenupadre%>><%=menupadre%></option>
          <%
          sql = "select idmenu, menu from menus where idmenupadre is null order by menu"
          set rs2 = conn.execute(sql)
          while not rs2.eof
          %>
          <option value=<%=rs2("idmenu")%>><%=trim(rs2("menu"))%></option>
          <%
          rs2.movenext
          wend
          %>
        </select>
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Posición:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="posicion" SIZE="20" MAXLENGTH="20" value="<%=trim(rs("posicion"))%>"></TD>
  </TR>  

</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Actualizar Menu" class="boton">
</UL>
<INPUT TYPE="HIDDEN" NAME="idmenu" VALUE="<%=idmenu%>">
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.menu.focus();
</SCRIPT>
</HTML>