<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<html>
<head>
 <LINK REL="StyleSheet" HREF="../../css/vinculos2.css" TYPE="text/css">
</head>
<body>
<% titulo = "Erores en el plano de Clientes"%>
<!--#include file="../include/titulo1.inc.asp"-->
<%
idplano=request.querystring("idplano")
errores=request.querystring("errores")

sql="select * from planosdetalle where idplano="&idplano
 set rs1=conn.execute(sql)
%>
<a href="clientes_planos_reporte.asp?idplano=<%=idplano%>&errores=<%=errores%>">Regresar</a><br><br>
<table align=center>
  <tr><td><font face="Arial, Helvetica, sans-serif" size="2" color=blue><b><i>Archivo: </i></b></font></td>
      <td><font size=4><b><%=rs1("plano")%></b></font></td></tr>    
</table>
<br>
<%

sql = " select iderror,consecutivo,error from errores_planos where idplano="& idplano &" order by consecutivo,iderror"
 set rs=conn.execute(sql)

if not rs.eof then   %>
  <table border=1 width="100%">
    <tr bgcolor="#009933" align=center>
      <td bgcolor=red ><font face="Arial, Helvetica, sans-serif" size="1"><b>Error</b></font></td>	
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Linea</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>idcliente2</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Dealer</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Cliente</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Ciudad</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Direccion</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Telefono</b></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="1"><b>Región</b></font></td>
    </tr>
    <%
    while not rs.eof
      consecutivo=rs("consecutivo")
      sql="select pla.idcliente2,pla.dealer,pla.cliente,pla.idciudad,pla.direccion,pla.telefono,pla.region,ciu.ciudad"
      sql= sql & " from planos_clientes pla, ciudades ciu "
      sql= sql & " where pla.consecutivo="& consecutivo &" and pla.idplano="&idplano 
      sql= sql & " and pla.idciudad=ciu.idciudad"
       set rs2=conn.execute(sql) %>
        <tr>
          <td><font color=red size=1><%=trim(rs("error"))%></font></td>
          <td><font size=1><%=consecutivo%></font></td>
          <% 
          if not rs2.eof then  %>
            <td><font size=1><%=rs2("idcliente2")%></font></td>
            <td><font size=1><%=rs2("dealer")%></font></td>
            <td><font size=1><%=rs2("cliente")%></font></td>
            <td><font size=1><%=rs2("ciudad")%></font></td>
            <td><font size=1><%=rs2("direccion")%></font></td>
            <td><font size=1><%=rs2("telefono")%></font></td>
            <%
          end if %> 
        </tr>
        <% 
        rs.movenext
    wend %>
  </table>
  <%
  rs1.close
  rs2.close
  rs.close
  conn.close
else  %>
  <center><b><i><font face="Arial, Helvetica, sans-serif" size=2 color=red>Su Archivo fue validado y no Contiene Errores</font></i></b></center>
  <%
  rs1.close
  conn.close
end if  %>
</body>
</html>