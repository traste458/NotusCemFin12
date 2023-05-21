<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
tipoentrega = trim(request.form("tipoentrega"))
estado = request.form("estado")

'insertamos los datos en la tabla autorizadores
sql = "insert into tipoentregas (tipoentrega, fecha, estado) "
sql = sql & " values ('"& ucase(tipoentrega) & "', getdate() , " & estado &" )"
'response.write sql
'response.end
conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "tipoentregas_crear.asp?bandera=4&tipoentrega=" & ucase(tipoentrega)   'tipoentrega creado
%>