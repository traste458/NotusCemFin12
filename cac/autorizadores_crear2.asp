<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
autorizador = trim(request.form("autorizador"))
cedula = trim(request.form("cedula"))
estado = request.form("estado")
'verificamos que no exosta un cac con el mismo codigo
sql = "select count(0) as cant from autorizadores where cedula = '"& cedula &"'"
set rs = conn.execute(sql)
if cdbl(rs("cant")) <> 0 then
  response.redirect "autorizadores_crear.asp?bandera=3&cedula=" & cedula  'cedula ya existente
end if

'insertamos los datos en la tabla autorizadores
sql = "insert into autorizadores (autorizador, cedula, fecha, estado) "
sql = sql & " values ('"& ucase(autorizador) & "','"& cedula &"', getdate() , " & estado &" )"
'response.write sql
'response.end
conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "autorizadores_crear.asp?bandera=4&cedula=" & cedula   'autorizador creado
%>