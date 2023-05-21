<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'traemos los datos recogidos en la forma
idperfil = request.form("idperfil")
if (isnull(idperfil)) or (idperfil = "") then
   idperfil = request.querystring("idperfil")
end if
%>
<HTML>
<HEAD>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF" class="cuerpo2">
<% session("titulo") = "<b>Asignar Menus a Perfil - Modulo de Administración </b>"
Response.write session("titulo")
%>
<br>
<%
estado = request.querystring("estado")
if estado = 1 then  %>
  <br><CENTER><FONT COLOR="BLUE" SIZE="3" face="verdana"><b>Menu Asignado</b></FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <br><CENTER><FONT COLOR="RED" SIZE="3" face="verdana"><b>Ya fue asignado ese menu al perfil. Menu No Asignado</b></FONT></CENTER>
<%  
end if
if estado = 3 then  %>
  <br><CENTER><FONT COLOR="BLUE" SIZE="3" face="verdana"><b>Menu Eliminado</b></FONT></CENTER>
<%  
end if

%>

<hr>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<FORM NAME="forma" METHOD="POST" ACTION="menus_perfiles_crear2.asp" onSubmit="return validacion()">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Perfil:</B></TD>
    <TD>&nbsp;
    <%
    sql = "select perfil from perfiles where idperfil = " & idperfil
    set rs = conn.execute(sql)
    nombreperfil = rs("perfil")
    %>
    <%=nombreperfil%>
    </TD>
  </TR>  

  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Menu:</B></TD>
    <TD>
    <select name="idmenu">
    <%
    sql = "select idmenu, menu from menus where idmenu not in "
    sql = sql & " (select idmenu from menus_perfiles where idperfil = " & idperfil & ") and idmenupadre is null order by menu asc"
    set rs = conn.execute(sql)
    while not rs.eof
    %>
       <option value="<%=rs("idmenu")%>"><%=rs("menu")%></option>
    <%
    rs.movenext
    wend
    %>
    </select>
    </TD>
  </TR>  

</TABLE>
<input type="hidden" name="idperfil" value="<%=idperfil%>">
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Asignar Menu" class="boton">
</UL>

</form>
<%

'sql = "select a.idmenu_perfil, a.idmenu, (select menu from menus where idmenu = a.idmenu) as menu, "
'sql = sql & " (select url from menus where idmenu = a.idmenu) as url, a.idperfil , a.posicion "
'sql = sql  & " from menus_perfiles a where a.idperfil = " & idperfil & " order by a.posicion "

sql = "select * from (select "
sql = sql & " a.idmenu_perfil, "
sql = sql & " a.idmenu, "
sql = sql & " (select menu from menus where idmenu = a.idmenu) as menu, "
sql = sql & " NULL as url, "
sql = sql & " a.idperfil , "
sql = sql & " NULL as posicion "
sql = sql & " from menus_perfiles a "
sql = sql & " where a.idperfil = " & idperfil & "  "
sql = sql & " union "
sql = sql & " select "
sql = sql & " a.idmenu_perfil, "
sql = sql & " null as idmenu, "
sql = sql & " b.menu as menu, "
sql = sql & " b.url as url, "
sql = sql & " a.idperfil , "
sql = sql & " b.posicion "
sql = sql & " from menus_perfiles a , menus b "
sql = sql & " where a.idmenu = b.idmenupadre and a.idperfil = " & idperfil & " ) c order by idmenu_perfil, posicion "


set rs = conn.execute(sql)
'response.write (sql)
'response.end
%>

<hr>
<br>
<font >Menus asignados al perfil <b><%=ucase(nombreperfil)%></b></font>
<br><br>
<TABLE WIDTH="60%" BORDER="0" class="tabla" >
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><B>Menu</B></TD>
    <TD><B>Url</B></TD>
    <TD><B>Posición</B></TD>
    <TD><B>Opciones</B></TD>
  </TR>
<%
  i=0
  while not rs.eof
    i=i+1
    idmenu_perfil = rs("idmenu_perfil")

    idmenu = rs("idmenu")
    menu = trim(rs("menu"))
    url = trim(rs("url"))
    if (isnull(url)) or (url= "") then
       menu = "<b>" &trim(rs("menu")) & "</b>"
    else
       menu = trim(rs("menu"))
    end if
    posicion = trim(rs("posicion"))
    %>
    <TR ALIGN="CENTER">
      <TD><%=menu%></TD>
      <TD><%=url%></TD>
      <TD><%=posicion%></TD>
      <TD>
      <%
      if (not isnull(idmenu)) or (idmenu <> "") then
      %>
      <a href="menus_perfiles_eliminar2.asp?idmenu_perfil=<%=idmenu_perfil%>&idperfil=<%=idperfil%>" onclick="return confirm('¿Esta seguro que desea eliminar este menu?')"><img src="../images/delete.gif" name="modificar" alt="Eliminar"  border="0" ></a>
      <%
      end if
      %>
      </TD>
    </TR>
<% 
    rs.movenext
  wend %>
  <TR ALIGN="CENTER">
    <TD COLSPAN="5" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
  </TR> 
</TABLE>




<%
conn.Close

%>
</body>
</html>