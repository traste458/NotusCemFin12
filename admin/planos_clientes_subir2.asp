<%@ LANGUAGE="VBScript" %>
<% 'Response.Buffer=True %>
<!--#include file="../include/conexion.inc.asp"-->
<html>
<HEAD>
<LINK REL="StyleSheet" HREF="../../css/vinculos2.css" TYPE="text/css">
</HEAD>
<body bgcolor=#FFFFFF>
<a href="planos_clientes.asp">Subir otro Archivo de Clientes</a><br><br>
<% 
Server.ScriptTimeout = 200

idplano=request.form("idplano")

sql = "update planosdetalle set fec_aprobado=getdate (),idestado=1 where idplano="&idplano
set rs=conn.execute(sql)
'response.write sql
'response.end
sql = "select idcliente2,dealer,cliente,idciudad,direccion,telefono from planos_clientes where idplano = "& idplano
sql = sql& " and consecutivo not in (select consecutivo from errores_planos where idplano = "&idplano&")"
set rs=conn.execute (sql)
if rs.eof then
  response.write "<center><font color=red>No hay nngun registro que se pueda Subir</font></center>"
  response.end
end if
i=0
while not rs.eof 
  sql = "update secuencias set numero=numero+1 where secuencia = 'clientes'"
  conn.execute(sql)
  sql = "select numero from secuencias where secuencia = 'clientes'"
  set rs2=conn.execute(sql)
  if rs2.eof then
    response.write "<center><font color=red>Problemas con el consecutivo de Clientes</font></center>"
    response.end
  end if
  idcliente = rs2("numero")

  sql = "insert into clientes (idcliente,idcliente2,dealer,cliente,idciudad,direccion,telefonos,estado) values "  
  sql = sql& "("&idcliente&",'"&rs("idcliente2")&"','"&rs("dealer")&"','"&rs("cliente")&"',"&rs("idciudad")
  sql = sql& ",'"&rs("direccion")&"','"&rs("telefono")&"',1)"
'response.write sql
'response.end
  conn.execute(sql)
  i = i+1
  rs.movenext
wend
response.redirect "planos_clientes.asp?cant="&i
%>
<table align=center>
  <tr align=center>
    <td><font color=blue><b><%=i%> Clientes fueron ingresados al Sistema</b></font><br></td>
  </tr>
</table>
</body
</html>