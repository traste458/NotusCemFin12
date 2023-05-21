<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idservicio = request.querystring("idservicio")

sqlUpdate = "update servicio_tecnico set estado = 3, fecha_cierre = getdate() where idservicio = " & idservicio
conn.execute(sqlUpdate)

sqlSerial = "select serial from servicio_tecnico where idservicio = " & idservicio
set rsSerial = conn.execute(sqlSerial)
response.redirect "servicio_buscar2.asp?serial=" & trim(rsSerial("serial"))
%>