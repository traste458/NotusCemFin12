<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idcac2 = trim(request.form("idcac2"))
cac = trim(request.form("cac"))
idciudad = request.form("idciudad")
direccion = trim(request.form("direccion"))
telefono = trim(request.form("telefono"))
idauxiliar = Request.form("idauxiliar")
region = trim(request.form("region"))
if region <> "0" then
   region = "'" & region & "'"
else
  region = "NULL"
end if
centro = trim(request.form("centro"))
if centro <> "0" then
   centro = "'" & centro & "'"
else
   centro = "NULL"
end if

'verificamos que no exosta un cac con el mismo codigo
sql = "select count(0) as cant from cac where idcac2 = '"& idcac2 &"'"
set rs = conn.execute(sql)
if cdbl(rs("cant")) <> 0 then
  response.redirect "cac_crear.asp?bandera=3&idcac2=" & idcac2  'codigo de cac ya existente
end if

'insertamos los datos en la tabla cac
sql = "insert into cac (idcac2,cac,direccion,telefono, idauxiliar, region, centro, idciudad) "
sql = sql & " values ('"& idcac2 & "','"& cac &"','"& direccion &"', '"& telefono &"',"& idauxiliar
sql = sql & " , "& region &"," & centro & ", " & idciudad & " ) "

'response.write sql
'response.end
 set rs=conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "cac_crear.asp?bandera=4&idcac2="&idcac2   'cac creado
%>