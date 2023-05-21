<html>
<body>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<% session("titulo") = "Resultado de la Busqueda"%>
<!--#include file="../include/titulo1.inc.asp"-->
<%
cliente = request.form("buscar")
%>
<a href="clientes.asp">Regresar</a><br><br>
<font color=gray face=arial size=2><i>Cuando cliente es semajante a : </i><b><%=cliente%></b></font>
<br>
<%
sql="select idcliente,idcliente2,cliente,idciudad,ciudad,direccion,telefonos,estado,region"
sql=sql&" from vi_clientes where cliente like ('%"&request.form("buscar")&"%')"
 Set rs=conn.execute(sql) %>
<table border=1 width="100%">
  <tr bgcolor=#FFCC00 align=center> 
    <td><font size=2><b>idcliente2</b></font></td>
    <td><font size=2><b>Cliente</b></font></td>
    <td><font size=2><b>Ciudad</b></font></td>
    <td><font size=2><b>Direccion</b></font></td>
    <td><font size=2><b>Telefonos</b></font></td>
    <td><font size=2><b>Región</b></font></td>
    <td><font size=2><b>Estado</b></font></td>
    <td><font size=2><b>Deshab.</b></font></td>
  </tr>
  <% 
  i=0
  while not rs.eof  
    i = i+1
    if cdbl(rs("estado")) = 1 then
      estado = "Activo"
      etiq = "X"
    else
      estado = "Inactivo"
      etiq = ""
    end if
    %>
    <tr> 
      <td><font size=2><%=rs("idcliente2")%></font></td>
      <td><font size=2><a href=clientes_actualizar.asp?idcliente=<%=rs("idcliente")%>><%=rs("cliente")%></a></font></td>
      <td><font size=2><%=rs("ciudad")%></font></td>
      <td><font size=2><%=rs("direccion")%></font></td>
      <td><font size=2><%=rs("telefonos")%></font></td>
      <td><font size=2><%=rs("region")%></font></td>
      <td><font size=2><%=estado%></font></td>
      <td align=center><font size=2><a href=clientes_borrar.asp?idcliente=<%=rs("idcliente")%>><%=etiq%></a></font></td>
    </tr>
    <%
    rs.movenext
  wend %>
  <tr bgcolor="FFCC00">
    <td colspan="8"><font size=2><b><%=i%> Clientes</b></font></td> 
  </tr>
</table>
</body>
</html>