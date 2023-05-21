<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%

'traemos los datos recogidos en la forma
idmenu = request.form("idmenu")
menu = trim(request.form("menu"))
url = trim(request.form("url"))
idmenupadre = request.form("idmenupadre")
posicion = trim(request.form("posicion"))
if (isnull(url)) or (url = "") then
 varurl = "NULL"
else
 varurl = "'" & trim(request.form("url")) &  "'"
end if
if (isnull(idmenupadre)) or (idmenupadre = "") or (idmenupadre = "0") then
 idmenupadre = "NULL"
end if

if (isnull(posicion)) or (posicion = "") then
 posicion = "NULL"
end if


'actualizamos los datos en la tabla noticias.
sql = "update menus set "
sql = sql & " menu ='"& menu & "' , url = " & varurl & " , idmenupadre = " & idmenupadre & ", posicion = " & posicion
sql = sql & " where idmenu = "& idmenu
'response.write (sql)
'response.end
set rs=conn.execute(sql)

conn.Close
response.redirect("menus_actualizar.asp?idmenu=" & idmenu & "&estado=1")
%>