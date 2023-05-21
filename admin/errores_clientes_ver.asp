<html>
<head>
<title>Errores </title>
<LINK REL="StyleSheet" HREF="../../css/vinculos2.css" TYPE="text/css">
</head>
<body>
<%@ LANGUAGE="VBScript" %>
<% 'Response.Buffer=True %>
<% titulo = "Erores en el plano de Clientes"%>
<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
idplano=request.querystring("idplano")
errores=request.querystring("errores")

sql="select * from planosdetalle where idplano="&idplano
   set rs1=conn.execute(sql)

%>
	<center><a href="planos_clientes_reporte.asp?idplano=<%=idplano%>&errores=<%=errores%>">REGRESAR</a><br><br></center>
<table align=center>
	<tr><td><font face="Arial, Helvetica, sans-serif" size="2" color=blue><b><i>Archivo: </i></b></font></td>
	    <td><font size=4><b><%=rs1("plano")%></b></font></td></tr>    
</table>
<br>
<%
sql = " select iderror,consecutivo,error from errores_planos where idplano="& idplano &" order by consecutivo,iderror"
  set rs=conn.execute(sql)
    if not rs.eof then
%>
<table border=1	width="100%">
  <tr bgcolor="#009933" align=center>
      <td bgcolor=red ><font face="Arial, Helvetica, sans-serif" size="1"><b>Error</b></font></td>	
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Linea</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>idcliente2</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Dealer</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Cliente</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Ciudad</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Direccion</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Telefono</b></font></td>
  </tr>
<%
	while not rs.eof
	consecutivo=rs("consecutivo")

	sql="select consecutivo,idcliente2,dealer,cliente,idciudad,direccion,telefono"
	sql= sql & " from planos_clientes where consecutivo="& consecutivo &" and idplano="&idplano 
	  set rs2=conn.execute(sql)
	'response.write sql
%>
	<tr>
	    <td><font color=red size=1><%=trim(rs("error"))%></font></td>
            <td><font size=1><%=rs2("consecutivo")%></font></td>
	    <td><font size=1><%=rs2("idcliente2")%></font></td>
	    <td><font size=1><%=rs2("dealer")%></font></td>
	    <td><font size=1><%=rs2("cliente")%></font></td>
	    <td><font size=1><%=rs2("idciudad")%></font></td>
	    <td><font size=1><%=rs2("direccion")%></font></td>
	    <td><font size=1><%=rs2("telefono")%></font></td>
	</tr>
<%
	rs.movenext
	wend
    else
%>
     <center><b><i><font face="Arial, Helvetica, sans-serif" size=2 color=red>Su Archivo fue validado y no Contiene Errores</font></i></b></center>
<%
    end if 
%>
<table>
</body
</html>