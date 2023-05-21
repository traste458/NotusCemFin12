<%@ LANGUAGE="VBScript" %>
<% session("titulo")=("Reporte Plano Clientes ") %>
<!-- #include file="../include/titulo1.inc.asp" -->
<!--#include file="../include/conexion.inc.asp"-->
<html>
<HEAD>
<LINK REL="StyleSheet" HREF="../../css/vinculos2.css" TYPE="text/css">
</HEAD>
<body bgcolor="#FFFFFF">
<a href="planos_clientes.asp">Regresar</a><br><br>
<form name="forma" method="post" action="planos_clientes_subir2.asp">
<%
idplano=request.querystring("idplano")
errores=request.querystring("errores")

subir="disabled"

if errores = "" then
  errores = 0
end if

sql = "select count(0) as cant from planos_clientes where idplano="&idplano
set rs=conn.execute(sql)
lineas=rs("cant")
%>
<%=lineas%> Registros
<% 
if errores <> 0 then %>
, con <a href="errores_clientes_ver.asp?idplano=<%=idplano%>&errores=<%=errores%>"> <%=errores%> Errores </a>
<%end if%>
<br><br>
<%
sql = "select count(0) as cant from errores_planos where idplano="&idplano
sql = sql& " and iderror = 1" 
set rs=conn.execute(sql)
if cdbl(rs("cant")) > 0 then
  c1="checked"
end if

if errores <> 0 then %>
 <br><br>
 <table border=1>
   <tr bgcolor=skyblue align=center>
     <td>
       <CENTER>
          <font color=red size=3><i><b>(Los Campos Selecionados Contienen errores)</i></b></font>
       </CENTER></td></tr>
   <tr>
     <td>
        <input type="checkbox" <%=c1%> disabled><i><font size=3>Nombre del Cliente</font></i><br>
     </td></tr>
 </table> 
<%
end if %>
<ul>
  <input type="hidden" name="idplano" value="<%=idplano%>">
  <input type="hidden" name="cant" value="<%=lineas%>">
  <input type="submit" value="Subir Registros Ahora">
</ul>
</form>
</body>
</html>