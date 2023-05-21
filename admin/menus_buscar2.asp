<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<BODY>
<head>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
</head>
<body class="cuerpo2">
<% session("titulo") = "<b>Busqueda de Menus - Modulo de Administración</b>"
Response.write session("titulo")
%>
<hr>

<%
'traemos los datos recogidos en la forma
menu = trim(request.form("menu"))


sql = " select a.idmenu, a.menu , a.url, a.idmenupadre, (select menu from menus where idmenu = a.idmenupadre) as menupadre, posicion "
sql = sql & " from menus a where upper(a.menu) like upper('%" & menu & "%')"
sql = sql & " order by idmenupadre , posicion    "
'response.write (sql)
'response.end
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="menus_buscar.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
<%
  conn.close
  response.end
end if  %>
<A HREF="menus_buscar.asp"><b>Nueva Busqueda</b></A>
<BR><BR>
<TABLE WIDTH="60%" BORDER="0" class="tabla" >
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><B>Menu</B></TD>
    <TD><B>Url</B></TD>
    <TD><B>Menu Padre</B></TD>
    <TD><B>Posición</B></TD>
  </TR>
<%
  i=0
  bgcolor = "#FFFFFF"
  while not rs.eof
    i=i+1
    idmenu = rs("idmenu")
    menu = trim(rs("menu"))
    menupadre = trim(rs("menupadre"))
    posicion = rs("posicion")
    url = rs("url")
    if (isnull(url)) or (url= "") then
       menu = "<b>" &trim(rs("menu")) & "</b>"
    else
       menu = trim(rs("menu"))
    end if
    if (isnull(menupadre)) or (menupadre = "") then
       menupadre = "&nbsp;"
    end if
    %>
    <TR ALIGN="CENTER">
      <TD bgcolor="<%=bgcolor%>"><A HREF="menus_actualizar.asp?idmenu=<%=idmenu%>"><u><%=menu%></u></TD>
      <TD bgcolor="<%=bgcolor%>"><%=url%></TD>
      <TD bgcolor="<%=bgcolor%>"><font class="fuente" size="1" style="font-weight:bold" color="#FFC72F"><%=menupadre%></font></TD>
      <TD bgcolor="<%=bgcolor%>"><%=posicion%></TD>
    </TR>
<% 
   if bgcolor = "#FFFFFF" then
      bgcolor = "#F0F0F0"
   ELSE
      bgcolor = "#FFFFFF"
   end if

    rs.movenext
  wend %>
  <TR ALIGN="CENTER">
    <TD COLSPAN="5" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
  </TR> 
</TABLE>
<%
conn.Close
%>
</BODY>
</HTML>