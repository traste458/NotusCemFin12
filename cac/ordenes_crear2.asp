<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idproducto = Request.form("idproducto")
idsubproducto = request.form("idsubproducto")
idcac = request.form("idcac")
cantidad = trim(Request.form("cantidad"))
'response.write "asdas"
'response.end

sqlId = "select substring(subproducto, 0, 30) as id from subproductos where idsubproducto = " & idsubproducto
set rsId = conn.execute(sqlId)
idorden2 = trim(rsId("id"))

'insertamos los datos en la tabla autorizadores
sqlInsert = "insert into ordenes_cac(idorden2_cac, fecha, idcac, cantidad, idproducto, idsubproducto, estado) "
sqlInsert = sqlInsert & " values ('" & idorden2 & "', getdate(), " & idcac & ", " & cantidad & ", " &  idproducto & ", " & idsubproducto & ", 1 )"
'response.write sql
'response.end
conn.execute(sqlInsert)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "ordenes_crear.asp?bandera=4&idorden2=" & idorden2
%>