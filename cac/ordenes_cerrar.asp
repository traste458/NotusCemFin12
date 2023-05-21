<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<%
idorden = request.querystring("idorden")
'response.write idorden
'response.end
sqlUpdate = "update ordenes_cac set estado = 2, cantidad_leida = cantidad  where idorden_cac = " & idorden
conn.execute(sqlUpdate)

sqlInsert  = "insert into cac_seriales (serial, idproducto, idsubproducto, idcac, idtercero, fecha, idorden_ingreso) "
sqlInsert = sqlInsert & " select b.serial, a.idproducto, a.idsubproducto, a.idcac, " & session("usxp001") & " , getdate(), a.idorden_cac "
sqlInsert = sqlInsert & " from ordenes_cac a, ordenes_cac_detalle b "
sqlInsert = sqlInsert & " where a.idorden_cac = b.idorden_cac "
sqlInsert = sqlInsert & " and a.idorden_cac = " & idorden
conn.execute(sqlInsert)

sqlInv = "select a.idcac_inventario, b.cantidad_leida "
sqlInv = sqlInv & " from cac_inventario a, "
sqlInv = sqlInv & " ordenes_cac b "
sqlInv = sqlInv & " where a.idproducto = a.idproducto and a.idsubproducto = b.idsubproducto "
sqlInv = sqlInv & " and b.idorden_cac = "  & idorden
Set rsInv = conn.execute(sqlInv)
if not rsInv.eof then
   idcac_inventario = rsInv("idcac_inventario")
   sqlUpdate = "update cac_inventario set saldo = saldo + " & trim(rsInv("cantidad_leida")) & " where idcac_inventario = " & idcac_inventario
   conn.execute(sqlUpdate)
else
   sqlInsert = "insert into cac_inventario (idcac, idproducto, idsubproducto, saldo) "
   sqlInsert = sqlInsert & " select idcac, idproducto, idsubproducto, cantidad_leida from "
   sqlInsert = sqlInsert & " ordenes_cac where idorden_cac = " & idorden
   conn.execute(sqlInsert)
end if

response.redirect "ordenes_buscar_cac2.asp?idorden=" & idorden
%>