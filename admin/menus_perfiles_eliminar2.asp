<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%

'traemos los datos recogidos en la forma

idmenu_perfil = request.querystring("idmenu_perfil")
idperfil = Request.querystring("idperfil")

'verificamos que no este asignado el menu a ese perfil
'asignamos el menu al perfil.
sql = "delete from menus_perfiles where idmenu_perfil =" & idmenu_perfil

'response.write (sql)
'response.end
set rs=conn.execute(sql)

conn.Close
response.redirect("menus_perfiles_asignar2.asp?idperfil=" & idperfil & "&estado=3")
%>