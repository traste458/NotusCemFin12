<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</head>
<BODY>
<%session("titulo")="Busqueda de Tipos de Entrega "%>
<!--#include file="../include/titulo1.inc.asp"-->
<%
'traemos los datos recogidos en la forma
tipoentrega = trim(request.form("tipoentrega"))
estado = request.form("estado")

'buscamos en la tabla pos por identificacion
sql = "select idtipoentrega, tipoentrega, estado, convert(varchar,fecha, 105) as fecha from tipoentregas "
sql = sql & " where idtipoentrega is not null "
if tipoentrega <> "" then
   sql = sql & " and tipoentrega like '%" & tipoentrega & "%' "
end if
if estado <> "0" then
   sql = sql & " and estado = " & estado
end if
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="autorizadores_buscar.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
  <%
  conn.close
  response.end
end if  %>
<A HREF="tipoentregas_buscar.asp">Otra Busqueda</A>
<BR><BR>
<TABLE WIDTH="100%" BORDER="0" class="tabla">
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><font size="1" face="verdana"><B>Tipo de Entrega</B></font></TD>
    <TD><font size="1" face="verdana"><B>Fecha de Creación</B></font></TD>
    <TD><font size="1" face="verdana"><B>Estado</B></font></TD>
  </TR>
<%
  i=0
  bgcolor = "#FFFFFF"
  while not rs.eof
    i=i+1
    idtipoentrega = trim(rs("idtipoentrega"))
    tipoentrega = trim(rs("tipoentrega"))
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
      <TD bgcolor="<%=bgcolor%>"><font size=1><A HREF="tipoentregas_actualizar.asp?idtipoentrega=<%=idtipoentrega%>"><u><%=tipoentrega%></u></A></font></TD>
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