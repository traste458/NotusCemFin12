<%@ LANGUAGE="VBScript" %>
<% Response.Buffer=True %>
<!--#include file="../include/conexion.inc.asp"-->
<html>
<HEAD>
<LINK REL="StyleSheet" HREF="../../css/vinculos2.css" TYPE="text/css">
</HEAD>
<body>
<form name=forma method=post action=subir_clientes.asp>
<%

idplano=request.querystring("idplano")

sql="delete errores_planos where idplano="&idplano
set rs=conn.execute(sql)

i=0

' 1  Error en cliente

  sql = "select consecutivo from planos_clientes where idcliente2 in (select idcliente2 from clientes) " 
  sql = sql & " and idplano="&idplano
   set rs=conn.execute(sql)
    if not rs.eof then
	error="Cliente ya Existe (Código)"	
	c1="checked"
	while not rs.eof 
   	  i=i+1
	  consecutivo= rs("consecutivo")
	  sql="insert into errores_planos (iderror,error,idplano,consecutivo) "
	  sql = sql & " values (1,'"& error &"',"& idplano & ","& consecutivo &")"
	  set rs2=conn.execute(sql)
	  'response.write sql
	rs.movenext
	wend
    end if

  sql = "select consecutivo from planos_clientes where cliente in (' ') " 
  sql = sql & " and idplano="&idplano
   set rs=conn.execute(sql)
    if not rs.eof then
	error=" Nombre del Cliente vacio"	
	c1="checked"
	while not rs.eof 
   	  i=i+1
	  consecutivo= rs("consecutivo")
	  sql="insert into errores_planos (iderror,error,idplano,consecutivo) "
	  sql = sql & " values (1,'"& error &"',"& idplano & ","& consecutivo &")"
	  set rs2=conn.execute(sql)
	  'response.write sql
	rs.movenext
	wend
    end if
  if i = 0 then
    response.redirect("planos_clientes_subir.asp?idplano="&idplano)
  else 
    response.redirect("planos_clientes_reporte.asp?idplano="&idplano&"&errores="&i)
  end if
%>
</body>
</html> 