<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idtipoentrega = request.form("idtipoentrega")
tipoentrega = trim(request.form("tipoentrega"))
estado = request.form("estado")

'actualizamos los datos en la tabla pos
sql = "update tipoentregas set tipoentrega ='"& tipoentrega & "' "
sql = sql & ", estado = " & estado
sql = sql & " where idtipoentrega = "& idtipoentrega
'Response.write sql
'response.end
set rs=conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "tipoentregas_actualizar.asp?bandera=3&idtipoentrega=" & idtipoentrega & "&tipoentrega=" & tipoentrega 'tipoentrega actualizado
%>