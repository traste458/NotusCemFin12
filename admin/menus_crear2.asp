<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%

'traemos los datos recogidos en la forma
menu = trim(request.form("menu"))
url = trim(request.form("url"))
idmenupadre = request.form("idmenupadre")
posicion = trim(request.form("posicion"))
if (isnull(url))  or (url = "") then
   url = "NULL"
else
    url = "'" & url & "'"
end if
if (isnull(idmenupadre))  or (idmenupadre = "") or (idmenupadre = "0" ) then
   idmenupadre = "NULL"
end if
if (isnull(posicion))  or (posicion = "") then
   posicion = "NULL"
end if


'verificamos que no este creado un perfil con un nombre parecido
sql = "select count(*) as cant from menus where upper(menu) = upper('" & menu & "') "
if idmenupadre <> "NULL" then
  sql = sql & " and idmenupadre = " & idmenupadre
else 
  sql = sql & " and idmenupadre is null "
end if
set rs = conn.execute(sql)
if cdbl(rs("cant")) > 0 then
   response.redirect("menus_crear.asp?estado=2")
end if

'actualizamos las posiciones de los menus antes de insertar
sql = "update menus set posicion = posicion + 1 where idmenupadre = " & idmenupadre & " and posicion >= " & posicion & " "
conn.execute(sql)

'insertamos los datos en la tabla noticias.
sql = "insert into menus "
sql = sql & " (menu, url, idmenupadre, posicion)"
sql = sql & " values ('"& menu & "', " & url & ", " & idmenupadre & ", " & posicion & " )"
'response.write (sql)
'response.end
set rs=conn.execute(sql)


'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
response.redirect("menus_crear.asp?estado=1")
%>
