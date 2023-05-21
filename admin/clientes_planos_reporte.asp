<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<% session("titulo")="Reporte Plano Clientes " %>
<!-- #include file="../include/titulo1.inc.asp" -->
<html>
<HEAD>
  <LINK REL="StyleSheet" HREF="../../css/vinculos2.css" TYPE="text/css">
</HEAD>
<body bgcolor="#FFFFFF">
<a href="clientes_planos_region.asp">Regresar</a><br><br>
<form name="forma" method="post" action="clientes_planos_subir2.asp">
<%
idplano=request.querystring("idplano")
errores=request.querystring("errores")

sql = "select count(0) as cant from planos_clientes where idplano="&idplano
set rs=conn.execute(sql)
lineas = cdbl(rs("cant"))

' contamos los registros que no fueron ingresados a la tabla de planos_clientes por no tener el numero de campos adecuados
sql = "select count(0) as cant from errores_planos where idplano = "&idplano&" and iderror = 1"
 set rs= conn.execute(sql)
if not rs.eof then
  lineas = lineas + cdbl(rs("cant"))
end if
%>

<%=lineas%> Registros
, con <a href="clientes_planos_errores_ver.asp?idplano=<%=idplano%>&errores=<%=errores%>"> <%=errores%> Errores</a>
<%

sql = "select count(0) as cant,iderror from errores_planos where idplano="&idplano
sql = sql + "group by iderror"
 set rs=conn.execute(sql)
while not rs.eof
  iderror = rs("iderror")
  if cdbl(iderror) = 1 then
    if cdbl(rs("cant")) > 0 then
      c1="checked"
    end if
  end if
  if cdbl(iderror) = 2 then
    if cdbl(rs("cant")) > 0 then
      c2="checked"
    end if
  end if
  if cdbl(iderror) = 3 then
    if cdbl(rs("cant")) > 0 then
      c3="checked"
    end if
  end if
  rs.movenext
wend %>
<br><br>
<table border=1>
  <tr bgcolor=skyblue align=center>
    <td align=center>
      <font color=red size=3><i><b>(Los Campos Selecionados Contienen errores)</i></b></font>
    </td></tr>
  <tr>
    <td>
      <input type="checkbox" <%=c1%> disabled><i><font size=3>Registros con campos Sobrantes</font></i><br>
    </td></tr>
  <tr>
    <td>
      <input type="checkbox" <%=c2%> disabled><i><font size=3>Nombre del Cliente</font></i><br>
    </td></tr>
  <tr>
    <td>
      <input type="checkbox" <%=c3%> disabled><i><font size=3>Región</font></i><br>
    </td></tr>
</table> 
<ul>
  <input type="hidden" name="idplano" value="<%=idplano%>">
  <input type="hidden" name="cant" value="<%=lineas%>">
  <input type="submit" value="Subir Registros Aceptables">&nbsp;&nbsp;&nbsp;&nbsp;
  <font color=gray face=arial><i>(Inserta o actualiza los registros que no tienen errores.)</i></font>
</ul>
</form>
</body>
<%
rs.close
conn.close
%>
</html>