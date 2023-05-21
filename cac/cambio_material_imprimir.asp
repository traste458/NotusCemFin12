<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</HEAD>
<BODY class="cuerpo2">
<%
serial = trim(request.querystring("serial"))
sqlSerial = "select "
sqlSerial = sqlSerial & " (select subproducto from subproductos where idsubproducto = a.idsubproducto) as subproducto, "
sqlSerial = sqlSerial & " (select idsubproducto2 from subproductos where idsubproducto = a.idsubproducto) as material, "
sqlSerial = sqlSerial & " serial "
sqlSerial = sqlSerial & " from cambio_material_cac a "
sqlSerial = sqlSerial & " where serial = '" & serial & "'"
set rsSerial = conn.execute(sqlSerial)
'Response.write sqlSerial
'response.end
%>
<br>
<font size="1px">Producto:</font><br>
<font size="2px" style="font-weight:bold"><%=trim(rsSerial("subproducto"))%><br></font>
<font size="2px">Material:&nbsp;&nbsp;&nbsp;<%=trim(rsSerial("material"))%></font><br>
<font size="2px">IMEI:</font><br>
<font face="Code 39" size="2px"><%="*" &trim(rsSerial("serial")) & "*"%></font><br>
<font size="2px"><%=trim(rsSerial("serial"))%></font><br>
<font size="1px">Cambio de Material</font>
</body>
</html>