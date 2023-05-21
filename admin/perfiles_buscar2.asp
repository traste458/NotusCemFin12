<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<BODY>
<head>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
</head>
<body class="cuerpo2">
<% session("titulo") = "<b>Busqueda de Perfiles - Modulo de Administración</b>"
Response.write session("titulo")
%>
<hr>

<%
'traemos los datos recogidos en la forma
perfil = trim(request.form("perfil"))


sql = " select idperfil, perfil , fecha from perfiles where upper(perfil) like upper('%" & perfil & "%')"
sql = sql & " order by perfil"
'response.write (sql)
'response.end
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="perfiles_buscar.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
<%
  conn.close
  response.end
end if  %>
<A HREF="perfiles_buscar.asp"><b>Nueva Busqueda</b></A>
<BR><BR>
<TABLE WIDTH="60%" BORDER="0" class="tabla" >
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><B>Perfil</B></TD>
    <TD><B>Fecha de Creación</B></TD>
  </TR>
<%
  i=0
  while not rs.eof
    i=i+1
    idperfil = rs("idperfil")
    perfil = trim(rs("perfil"))
    fecha = rs("fecha")
    %>
    <TR ALIGN="CENTER">
      <TD><A HREF="perfiles_actualizar.asp?idperfil=<%=idperfil%>"><u><%=perfil%></u></TD>
      <TD><%=fecha%></TD>
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
</BODY>
</HTML>