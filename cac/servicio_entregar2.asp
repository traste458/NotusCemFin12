<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idservicio = trim(request.form("idservicio"))
serial = trim(request.Form("serial"))

sqlVal = "select idservicio from servicio_tecnico where serial = '" & serial & "' and idservicio <> " & idservicio
set rsVal = conn.execute(sqlVal)
if not rsval.eof then
   Response.redirect "servicio_entregar.asp?bandera=1&idservicio=" & idservicio
   response.end
end if

sqlSerial = "select serial from servicio_tecnico where idservicio = " & idservicio
set rsSerial = conn.execute(sqlSerial)

if strcomp(trim(rsSerial("serial")), trim(serial)) = 0 then
   sqlUpdate = "update servicio_tecnico set estado = 3, fecha_respuesta = getdate(), fecha_cierre = getdate() "
   sqlUpdate = sqlUpdate & " where idservicio = " & idservicio
else
   sqlUpdate = "update servicio_tecnico set estado = 2, fecha_respuesta = getdate(), serial_reemplazo = '" & trim(serial) & "'  "
   sqlUpdate = sqlUpdate & " where idservicio = " & idservicio
end if
conn.execute(sqlUpdate)

response.redirect "servicio_buscar2.asp?serial=" & rsSerial("serial")
%>