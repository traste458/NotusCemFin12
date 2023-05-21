<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
session("usxp_region") = ""

idplano=request.querystring("idplano")

i=0

' 1  Error validado en clientes_planos2.asp cuando el registro trae mas campos de los necesarios.

sql = "select count(0) as cant from errores_planos where idplano = "&idplano 
 set rs= conn.execute(sql)
if not rs.eof then
  i=rs("cant") 
end if

' 2  Error en cliente

sql = "select consecutivo from planos_clientes where cliente is null" 
sql = sql & " and idplano="&idplano
 set rs=conn.execute(sql)
if not rs.eof then
  error="Nombre del Cliente vacio"  
  while not rs.eof 
    i=i+1
    consecutivo= rs("consecutivo")
    sql="insert into errores_planos (iderror,error,idplano,consecutivo) "
    sql = sql & " values (2,'"& error &"',"& idplano & ","& consecutivo &")"
     set rs2=conn.execute(sql)
    rs.movenext
  wend
end if

' 3  Error en Region

sql = "select consecutivo from planos_clientes where region is null" 
sql = sql & " and idplano="&idplano
 set rs=conn.execute(sql)
if not rs.eof then
  error="Campo Región Vacio"  
  while not rs.eof 
    i=i+1
    consecutivo= rs("consecutivo")
    sql="insert into errores_planos (iderror,error,idplano,consecutivo) "
    sql = sql & " values (3,'"& error &"',"& idplano & ","& consecutivo &")"
     set rs2=conn.execute(sql)
    rs.movenext
  wend
end if

sql = "select consecutivo from planos_clientes where region not in ('OR','OC','NO')" 
sql = sql & " and idplano="&idplano
 set rs=conn.execute(sql)
if not rs.eof then
  error="Región Desconocida"  
  while not rs.eof 
    i=i+1
    consecutivo= rs("consecutivo")
    sql="insert into errores_planos (iderror,error,idplano,consecutivo) "
    sql = sql & " values (3,'"& error &"',"& idplano & ","& consecutivo &")"
     set rs2=conn.execute(sql)
    rs.movenext
  wend
end if


if i = 0 then
  rs.close
  conn.close
  response.redirect("clientes_planos_subir.asp?idplano="&idplano)
else 
  rs.close
  conn.close
  response.redirect("clientes_planos_reporte.asp?idplano="&idplano&"&errores="&i)
end if

%>