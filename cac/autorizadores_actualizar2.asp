<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idautorizador = request.form("idautorizador")
cedula = trim(request.form("cedula"))
autorizador = trim(request.form("autorizador"))
estado = request.form("estado")

'actualizamos los datos en la tabla pos
sql = "update autorizadores set cedula ='"& cedula &"', autorizador='"& autorizador &"'"
sql = sql & ", estado ="& estado
sql = sql & " where idautorizador = "& idautorizador
'Response.write sql
'response.end
set rs=conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "autorizadores_actualizar.asp?bandera=3&idautorizador=" & idautorizador & "&cedula="&cedula 'autorizador actualizado
%>