<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<% 
Server.ScriptTimeout = 300

idplano=request.form("idplano")

sql = "update planosdetalle set fec_aprobado=getdate (),idestado=1 where idplano="&idplano
 set rs=conn.execute(sql)

sql = "select idcliente2,dealer,cliente,idciudad,direccion,telefono,region from planos_clientes where idplano = "& idplano
sql = sql& " and consecutivo not in (select consecutivo from errores_planos where idplano = "&idplano&")"
 set rs=conn.execute (sql)
if rs.eof then
  rs.close
  conn.close
  response.redirect "clientes_plano.asp?vacio=1"
  response.end
end if
i=0
j=0
while not rs.eof 
  idcliente2 = trim(rs("idcliente2"))
  sql = "select count(*) as cant from clientes where rtrim(idcliente2) = '"&idcliente2&"'"
   set rs2 = conn.execute(sql)
  if cdbl(rs2("cant")) > 0 then
    dealer = rs("dealer")
    direccion = rs("direccion")
    telefono = rs("telefono")
    if dealer = "" then
      dealer = "null"
    else
      dealer = "'"&dealer&"'"
    end if
    if direccion = "" then
      direccion = "null"
    else
      direccion = "'"&direccion&"'"
    end if
    if telefono = "" then
      telefono = "null"
    else
      telefono = "'"&telefono&"'"
    end if
    sql = "update clientes set dealer="&dealer&",cliente = '"&rs("cliente")&"',idciudad="&rs("idciudad")&","
    sql = sql & " direccion="&direccion&",telefonos="&telefono&",region='"&rs("region")&"'"
    sql = sql & " where rtrim(idcliente2) = '"&idcliente2&"'"
     conn.execute(sql)
    j=j+1
  else
    sql = "update secuencias set numero=numero+1 where secuencia = 'clientes'"
     conn.execute(sql)
    sql = "select numero from secuencias where secuencia = 'clientes'"
      set rs2=conn.execute(sql)
    if rs2.eof then
      response.write "<center><font color=red>Problemas con el consecutivo de Clientes</font></center>"
      rs.close
      conn.close
      response.end
    end if
    idcliente = rs2("numero")

    sql = "insert into clientes (idcliente,idcliente2,dealer,cliente,idciudad,direccion,telefonos,estado) values "  
    sql = sql& "("&idcliente&",'"&rs("idcliente2")&"','"&rs("dealer")&"','"&rs("cliente")&"',"&rs("idciudad")
    sql = sql& ",'"&rs("direccion")&"','"&rs("telefono")&"',1)"
     conn.execute(sql)
    i=i+1
  end if
  rs.movenext
wend
rs2.close
rs.close
conn.close
response.redirect "clientes_planos_region.asp?cant1="&i&"&cant2="&j
%>