<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%

'traemos los datos recogidos en la forma
idmenu = request.form("idmenu")
idperfil = request.form("idperfil")


'verificamos que no este asignado el menu a ese perfil
sql = "select count(*) as cant from menus_perfiles where idmenu = " & idmenu & " and idperfil = " & idperfil
set rs = conn.execute(sql)
if cdbl(rs("cant")) > 0 then
   response.redirect("menus_perfiles_asignar2.asp?idperfil=" & idperfil & "&estado=2")
end if

'asignamos el menu al perfil.
sql = "insert into menus_perfiles (idmenu, idperfil )"
sql = sql & " values (" & idmenu & ", " & idperfil & " ) "
'response.write (sql)
'response.end
set rs=conn.execute(sql)

conn.Close
response.redirect("menus_perfiles_asignar2.asp?idperfil=" & idperfil & "&estado=1")
%>