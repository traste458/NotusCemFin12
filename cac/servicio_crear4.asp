<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
fecha_ingreso = trim(request.form("fecha_ingreso"))
serial = trim(request.Form("serial"))
idproducto = Request.form("idproducto")
razon = trim(Request.Form("razon"))

sqlCac = "select idcac from terceros where idtercero = " & session("usxp001")
set rsCac = conn.execute(sqlCac)
idcac = rsCac("idcac")
'insertamos el serial

sqlInsert = "insert into servicio_tecnico(serial, fecha_ingreso, estado, idtercero, idcac, idproducto, razon) "
sqlInsert = sqlInsert & " values('" & serial & "', '" & fecha_ingreso & "', 0, " & session("usxp001") & ", " & idcac & ", " & idproducto & ", '" & razon & "')"
conn.execute(sqlInsert)

response.redirect "servicio_crear.asp?serial=" & serial & "&bandera=2"
%>