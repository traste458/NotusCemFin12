<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</head>
<BODY>
<%session("titulo")="Busqueda de Autorizadores "%>
<!--#include file="../include/titulo1.inc.asp"-->
<%
'traemos los datos recogidos en la forma
cedula = trim(request.form("cedula"))
autorizador = trim(request.form("autorizador"))
estado = request.form("estado")

'buscamos en la tabla pos por identificacion
if cedula <> "" then
   sql = "select idautorizador, autorizador, cedula, "
   sql = sql & " convert(varchar,fecha, 105) as fecha, estado "
   sql = sql & " from autorizadores "
   sql = sql & " where cedula = '" & cedula & "'"
else
   sql = "select idautorizador, autorizador, cedula, "
   sql = sql & " convert(varchar,fecha, 105) as fecha, estado "
   sql = sql & " from autorizadores where idautorizador is not null "
   if autorizador <> "" then
      sql = sql & " and autorizador like '%" & autorizador & "%' "
   end if
   if estado <> "0" then
      sql = sql & " and estado = " & estado
   end if
end if
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="autorizadores_buscar.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
  <%
  conn.close
  response.end
end if  %>
<A HREF="autorizadores_buscar.asp">Otra Busqueda</A>
<BR><BR>
<TABLE WIDTH="100%" BORDER="0" class="tabla">
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><font size="1" face="verdana"><B>Cedula</B></font></TD>
    <TD><font size="1" face="verdana"><B>Autorizador</B></font></TD>
    <TD><font size="1" face="verdana"><B>Fecha de Creación</B></font></TD>
    <TD><font size="1" face="verdana"><B>Estado</B></font></TD>
  </TR>
<%
  i=0
  bgcolor = "#FFFFFF"
  while not rs.eof
    i=i+1
    idautorizador = trim(rs("idautorizador"))
    autorizador = trim(rs("autorizador"))
    cedula = trim(rs("cedula"))
    fecha = trim(rs("fecha"))
    estado = trim(rs("estado"))
    if estado = "1" then
       estado = "Activo"
    end if
    if estado = "2" then
       estado = "<font color=""990000"">Inactivo</font>"
    end if
    
    %>
    <TR>
      <TD bgcolor="<%=bgcolor%>" align="right"><font size=1><%=formatnumber(cedula, 0)%></font></TD>
      <TD bgcolor="<%=bgcolor%>"><font size=1><A HREF="autorizadores_actualizar.asp?idautorizador=<%=idautorizador%>"><u><%=autorizador%></u></A></font></TD>
      <TD bgcolor="<%=bgcolor%>" align="center"><font size=1><%=fecha%></font></TD>
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
    <TD COLSPAN="4" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
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