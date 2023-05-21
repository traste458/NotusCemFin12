<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp" -->
<%
estado = 1
if request.form("estado") = "" then
  estado = 0
end if

sql="update clientes set idcliente2='"& request.form("idcliente2")&"',dealer='"&request.form("dealer")&"',cliente='"& request.form("cliente")&"',"
sql=sql+"idciudad = "&request.form("idciudad")&",direccion='"& request.form("direccion")&"',telefonos='"& request.form("telefonos")&"',estado = "&estado&","
sql=sql+"email='"&request.form("email")&"',region='"&request.form("region")&"'"
sql=sql+" where idcliente="& request.form("idcliente")
 set rs=conn.execute(sql)

conn.close
set conn=nothing
response.redirect "clientes.asp?idestado=1"
%>
