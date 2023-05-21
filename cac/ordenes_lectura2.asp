<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<%
idorden = request.form("idorden")
serial = trim(request.form("serial"))
idcac = Request.form("idcac")
cantidad = Request.form("cantidad")
cantidad_leida = Request.form("cantidad_leida")
'response.write idorden
'response.end

sqlOrden = "select idorden_cac from ordenes_cac_detalle where serial = '" & serial & "'"
set rsOrden = conn.execute(sqlOrden)
if not rsOrden.eof then
   %>
   <a href="ordenes_lectura.asp?idorden=<%=idorden%>&serialUlt=<%=serial%>">Regresar</a><br><br>
   <ul>
     <center><font color="red" size="3">El serial <%=serial%> ya fue leido</font></center>
   </ul>
   <%
   response.end
end if

if cdbl(cantidad) = cdbl(cantidad_leida) then
   %>
   <a href="ordenes_lectura.asp?idorden=<%=idorden%>&serialUlt=<%=serial%>">Regresar</a><br><br>
   <ul>
     <center><font color="red" size="3">Ya fue leida la totalidad del orden. Por favor, cierre la orden</font></center>
   </ul>
   <%
   response.end
end if


sqlInsert = "insert into ordenes_cac_detalle (idorden_cac, serial) "
sqlInsert = sqlInsert & " values( " & idorden & "  ,'" & serial & "' ) "
conn.execute(sqlInsert)

response.redirect "ordenes_lectura.asp?idorden=" & idorden & "&serialUlt=" & serial
%>