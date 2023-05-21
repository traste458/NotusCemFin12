<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idsubproducto = request.form("idsubproducto")
subproducto = trim(request.form("subproducto"))
estado = request.form("estado")

'actualizamos los datos en la tabla pos
sql = "update subproductos set subproducto ='"& subproducto & "' "
sql = sql & ", estado = " & estado
sql = sql & " where idsubproducto = "& idsubproducto
'Response.write sql
'response.end
set rs=conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "subproductos_actualizar.asp?bandera=3&subproducto=" & subproducto & "&idsubproducto=" & idsubproducto
%>