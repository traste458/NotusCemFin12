<HTML>
<BODY>
<%session("titulo")="Busqueda de Usuarios"%>
<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/titulo1.inc.asp"-->
<%
'traemos los datos recogidos en la forma
idtercero2 = request.form("idtercero2")
tercero = request.form("tercero")
idarea = request.form("idarea")
idcargo = request.form("idcargo")
linea = request.form("linea")

'buscamos en la tabla terceros por identificacion
if idtercero2 <> "" then  
  sql = " select ter.idtercero,ter.idtercero2,ter.tercero,car.cargo,ter.linea,ter.estado "
  sql = sql & "from terceros ter, cargos car "
  sql = sql & "where ter.idcargo = car.idcargo "
  sql = sql & "and ter.idtercero2 = "& idtercero2
else
  sql = " select ter.idtercero,ter.idtercero2,ter.tercero,car.cargo,ter.linea,ter.estado "
  sql = sql & "from terceros ter, cargos car "
  sql = sql & "where ter.idcargo = car.idcargo "
  if tercero <> "" then
    sql = sql & "and ter.tercero like '%"& tercero &"%'"
  end if
  if idcargo <> 0 then
    sql = sql & "and ter.idcargo = "& idcargo
  end if
  if idarea <> 0 then
    sql = sql & "and ter.idarea = "& idarea
  end if
  if linea <> "" then
    sql = sql & "and ter.linea = '"& linea &"'"
  end if
end if
'response.write (sql)
'response.end
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="terceros_buscar.asp">Regresar</A> 
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
<%
  response.end
end if  %>
<A HREF="terceros_buscar.asp">Nueva Busqueda</A>
<BR><BR>
<TABLE WIDTH="100%" BORDER=1>
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><B>Identificaci&oacute;n</B></TD>
    <TD><B>Nombre</B></TD>
    <TD><B>Cargo</B></TD>
    <TD><B>Linea</B></TD>
    <TD><B>Estado</B></TD>
  </TR>
<%
  i=0
  while not rs.eof
    i=i+1
    idtercero = rs("idtercero")
    idtercero2 = rs("idtercero2")
    tercero = rs("tercero")
    cargo = rs("cargo")
    linea = rs("linea")
    estado = rs("estado")  %>
    <TR>
      <TD><%=idtercero2%></TD>
      <TD><A HREF="terceros_actualizar.asp?idtercero=<%=idtercero%>"><%=tercero%></A></TD>
      <TD><%=cargo%></TD>
      <TD><%=linea%></TD>
      <TD><%=estado%></TD>
    </TR>
<% 
    rs.movenext
  wend %>
  <TR>
    <TD COLSPAN="5" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
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