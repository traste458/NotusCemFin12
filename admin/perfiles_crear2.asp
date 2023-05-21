<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%

'traemos los datos recogidos en la forma
perfil = trim(request.form("perfil"))
'response.write perfil
'response.end

'verificamos que no este creado un perfil con un nombre parecido
sql = "select count(*) as cant from perfiles where upper(perfil) = upper('" & perfil & "')"
set rs = conn.execute(sql)
if cdbl(rs("cant")) > 0 then
   response.redirect("perfiles_crear.asp?estado=2")
end if

'insertamos los datos en la tabla noticias.
sql = "insert into perfiles "
sql = sql & " (perfil,fecha)"
sql = sql & " values ('"& perfil & "',getdate () )"
'response.write (sql)
'response.end
set rs=conn.execute(sql)


'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
response.redirect("perfiles_crear.asp?estado=1")
%>