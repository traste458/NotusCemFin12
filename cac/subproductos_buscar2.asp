<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</head>
<BODY>
<%session("titulo")="Busqueda de Subproductos "%>
<!--#include file="../include/titulo1.inc.asp"-->
<%
'traemos los datos recogidos en la forma
idproducto = Request.form("idproducto")
subproducto = trim(request.form("subproducto"))
idsubproducto2 = trim(Request.form("idsubproducto2"))
'response.write "asdas"
'response.end
'buscamos en la tabla subproductos solamente los de tipoorden = CAC
sql = "select idsubproducto, idsubproducto2, subproducto, estado "
sql = sql & " from subproductos "
sql = sql & " where tipoorden = 'CAC' "
if idproducto <> "0" then
   sql = sql & " and idproducto = " & idproducto
end if
if subproducto <> "" then
   sql = sql & " and subproducto like '%" & subproducto & "%'"
end if
if idsubproducto2 <> "" then
   sql = sql & " and idsubproducto2 like '%" & idsubproducto2 & "%'"
end if
sql = sql & " order by subproducto "
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="subproductos_buscar.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
  <%
  conn.close
  response.end
end if  %>
<A HREF="subproductos_buscar.asp">Otra Busqueda</A>
<BR><BR>
<TABLE BORDER="0" class="tabla">
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><font size="1" face="verdana"><B>Codigo</B></font></TD>
    <TD><font size="1" face="verdana"><B>Nombre</B></font></TD>
    <TD><font size="1" face="verdana"><B>Estado</B></font></TD>
  </TR>
<%
  i=0
  bgcolor = "#FFFFFF"
  while not rs.eof
    i=i+1
    idsubproducto = trim(rs("idsubproducto"))
    idsubproducto2 = trim(rs("idsubproducto2"))
    subproducto = trim(rs("subproducto"))
    estado = trim(rs("estado"))
    if estado = "1" then
       estado = "Activo"
    end if
    if estado = "2" then
       estado = "<font color=""990000"">Inactivo</font>"
    end if
    
    %>
    <TR>
      <TD bgcolor="<%=bgcolor%>"><font size=1><A HREF="subproductos_actualizar.asp?idsubproducto=<%=idsubproducto%>"><u><%=idsubproducto2%></u></A></font></TD>
      <TD bgcolor="<%=bgcolor%>" align="left"><font size=1><%=subproducto%></font></TD>
      <TD bgcolor="<%=bgcolor%>" align="center"><font size=1><%=estado%></font></TD>
    </TR>
<% 
     'color de fondo de las filas
   if bgcolor = "#FFFFFF" then
      'response.write("1")
      bgcolor = "#F0F0F0"
   ELSE
      bgcolor = "#FFFFFF"
   end if

    rs.movenext
  wend %>
  <TR>
    <TD COLSPAN="3" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
  </TR> 
</TABLE>
<%
'cerramos objetos de BD conexion y piscina  y los limpiamos
'rs.Close
conn.Close
Set rs = nothing
Set conn = nothing  %>
</BODY>
</HTML>