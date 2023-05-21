<html>
<body>
<%
if request.querystring("est") = 2 Then
  session("titulo") = "<b>Despachos Abiertos</b>"
else 
  session("titulo") = "<b>Ultimos 20 despachos</b>"
end if
%>
<!--#include file="../include/conexion.inc.asp" -->
<!--#include file="../include/titulo1.inc.asp" -->
<%
if request.querystring("est") = 2 Then %>
  <a href="despachos.asp"> Ver Ultimos 20 despachos</a>
<% else %>   
  <a href="despachos.asp?est=2"> Ver Despachos abiertos</a>
<% end if %>
&nbsp;&nbsp;<a href="despachos_crear.asp">Crear</a>
<br><br>

<%
if request.querystring("est") = 2 Then
  sql="select iddespacho,iddespacho2,cliente,ciudad,tipo, "
  sql = sql& " convert(char,fecha) as fecha,fecha_llegada,convert(char,cerrado) as cerrado,tercero,guia_transp,transportadora"
  sql = sql& " from vi_despachos where cerrado is null order by ins_fec desc, iddespacho desc "
'  response.write sql
else  
  sql="select top 20 iddespacho,iddespacho2,cliente,ciudad,tipo, "
  sql = sql& " convert(char,fecha) as fecha,fecha_llegada,convert(char,cerrado) as cerrado,tercero,guia_transp,transportadora"
  sql = sql& " from vi_despachos order by ins_fec desc, iddespacho desc"
'  response.write sql
end if
'response.write (sql)
'response.end
set rs=conn.execute(sql) 
if rs.eof then %>
 <br><br>
 <div align=center><font color=red size=4><i>No Hay Despachos con esas Caracteristicas</i></font></div>
 <% 
 response.end
end if
if request.querystring("est")=1 Then
 iddespacho2 = request.querystring("iddespacho2")%>
 <div align=center><font color=red size=4><i>El despacho <%=iddespacho2%> ha sido cerrado</i></font></div>
<%
end if
%>
<table border=1 width=100%>
  <tr bgcolor=#FF9900 align=center> 
    <td>Despacho No</td>
    <td>Cliente</td>
    <td>Destino</td>
    <td>Fecha Despacho</td>
    <td>Fecha Llegada</td>
    <td>Operario</td>
    <td>Guia Transportadora</td>
    <td>Transportadora</td>
    <td>Tipo</td>
    <td>Cerrar</td>
  </tr>
  <%
    while not rs.eof %>
  <tr align=center>
    <td>
    <%if rs("cerrado") <> "" Then %>  
       <a href="despachos_imprimir.asp?iddespacho=<%=rs("iddespacho")%>"><%=rs("iddespacho")%></a>
     <%
     else %>
       <a href="despachos_crear3.asp?iddespacho=<%=rs("iddespacho")%>&cerrado=<%=rs("cerrado")%>"><%=rs("iddespacho")%></td>
     <%
     end if %>
    </td>
    <td><%=rs("cliente")%></td>
    <td><%=rs("ciudad")%></td>
    <%
      fecha=day(rs("fecha"))&"/"&month(rs("fecha"))&"/"&year(rs("fecha"))
      if rs("fecha_llegada") <> "" Then
        fecha_llegada=day(rs("fecha_llegada"))&"/"&month(rs("fecha_llegada"))&"/"&year(rs("fecha_llegada"))
      else
        fecha_llegada = ""
      end if
    %>
    <td><%=rs("fecha")%></td>
    <td><%=fecha_llegada%></td>
    <td><%=rs("tercero")%></td>
    <td><%=rs("guia_transp")%></td>
    <td><%=rs("transportadora")%></td>
    <td><%=rs("tipo")%></td>
    <td>
    <%if rs("cerrado") <> "" Then %>
       <%=rs("cerrado")%>
     <%
     else %>
       <a href="despachos_cerrar.asp?iddespacho=<%=rs("iddespacho")%>"> X</a> 
     <%
     end if %>
    </td>
  </tr>
  <% rs.movenext
     wend %>
</table>
</body>
</html>
