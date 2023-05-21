<html>
<body>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/titulo1.inc.asp"-->
<form name=forma method=post>
<font color=red size=6><i>Registro Insertado en clientes</i></font>
<br><br>
<%

sql="update secuencias set numero=numero+1 where secuencia='clientes' "
conn.Execute(sql)
SQL="select numero from secuencias where secuencia='clientes'"
Set Rds=conn.Execute(sql)
If Not Rds.Eof Then
  idcliente=Rds("numero")
Else
 Response.Write "No se pudo obtener consecutivo"
End If

sql="insert into clientes (idcliente,idcliente2,dealer,cliente,cliente2,idciudad,direccion,telefonos,email,gerente,gerente_cel,estado,region) values ("
sql=sql& idcliente&",'"&request.form("idcliente2")&"','"& request.form("dealer")&"','"& request.form("cliente")&"','"& request.form("cliente2")&"',"
sql=sql& request.form("idciudad")&",'"& request.form("direccion")&"','"& request.form("telefonos")&"','"& request.form("email")&"','"
sql=sql& request.form("gerente")&"','"& request.form("gerente_cel")&"',1,'"&request.form("region")&"')"
'response.write sql
'response.end
set rs=conn.execute(sql)
response.redirect "clientes.asp?idestado=2"
%>
<h2>Registro Creado</h2>
</form>
</body>
</html>
