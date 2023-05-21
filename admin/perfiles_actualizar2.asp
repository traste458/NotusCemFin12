<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
idperfil = request.form("idperfil")

'traemos los datos recogidos en la forma
perfil = trim(request.form("perfil"))

'verificamos que no este creado un perfil con un nombre parecido
sql = "select count(*) as cant from perfiles where upper(perfil) = upper('" & perfil & "')"
set rs = conn.execute(sql)
if cdbl(rs("cant")) > 0 then
   response.redirect("perfiles_actualizar.asp?idperfil=" & idperfil & "&estado=2")
end if

'actualizamos los datos en la tabla noticias.
sql = "update perfiles set "
sql = sql & " perfil ='"& perfil & "' "
sql = sql & " where idperfil = "& idperfil
'response.write (sql)
'response.end
set rs=conn.execute(sql)

conn.Close
response.redirect("perfiles_actualizar.asp?idperfil=" & idperfil & "&estado=1")
%>