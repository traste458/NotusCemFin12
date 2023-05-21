<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp" -->
<%

sql="update clientes set estado = 0 where idcliente="& request.querystring("idcliente")
'response.write sql
set rs=conn.execute(sql)
response.redirect "clientes.asp?idestado=3"

%>
