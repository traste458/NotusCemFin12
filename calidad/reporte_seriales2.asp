<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<%
session("titulo") = "<b>Reporte de Seriales para PDV</b>"
Response.ContentType = "application/vnd.ms-excel"
idpos = request.form("idpos")
sql = " select serial, (select producto from productos where idproducto = a.idproducto) as producto "
sql = sql & " from "
sql = sql & " (select serial, idproducto from productos_serial "
sql = sql & " where idpos = " & idpos
sql = sql & " union "
sql = sql & " select sim as serial, idproducto from sims "
sql = sql & " where idpos = " & idpos & ") a "
sql = sql & " order by producto "
'response.write sql
set rs = conn.execute(sql)
%>
<!--#include file="../include/titulo1.inc.asp"-->
<BR><BR>
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Serial</B></TD>
    <TD BGCOLOR="#F0F0F0"><b>Producto</b></TD>
  </TR>
  <%
  while not rs.eof
    %>
  <TR>
    <TD >&nbsp;<%=trim(rs("serial"))%>&nbsp;</TD>
    <TD ><%=trim(rs("producto"))%></TD>
  </TR>
    <%
    rs.movenext
  wend
  %>
</TABLE>
<BR><BR>
</BODY>
<SCRIPT LANGUAGE="JavaScript">
  // document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>