<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
serial = trim(request.form("serial"))
idsubproducto = Request.form("idsubproducto")
'response.write serial
'response.end
sqlCac = "select idcac from terceros where idtercero = " & session("usxp001")
set rsCac = conn.execute(sqlCac)
if not rsCac.eof then
   idcac = rsCac("idcac")
end if
'response.write idcac
'response.end
if ((len(serial) = 11) or (len(serial) = 15)) then
   sqlSerial = "select idcac, idsubproducto from productos_serial where serial = '" & serial & "' and idcac = " & idcac
   set rsSerial = conn.execute(sqlSerial)
   if rsSerial.eof then
      'insertamos unicamente el serial en cambio_material_cac
      sqlInsert = "insert into cambio_material_cac(idcac, idsubproducto_anterior, idsubproducto, serial, idtercero) "
      sqlInsert = sqlInsert & " values(" & idcac & ", NULL, " & idsubproducto & ", '" & serial & "', " & session("usxp001") & " )"
      conn.execute(sqlInsert)
      response.redirect "cambio_material_imprimir.asp?serial="&serial
   else
      idsubproducto_anterior = rsSerial("idsubproducto")
      if isnull(idsubproducto_anterior) then
         idsubproducto_anterior = "NULL"
      end if
      if cdbl(idcac) = cdbl(rsSerial("idcac")) then
         'insertamos el serial en cambio_material_cac
         sqlInsert = "insert into cambio_material_cac (idcac, idsubproducto_anterior, idsubproducto, serial, idtercero) "
         sqlInsert = sqlInsert & " values(" & idcac & ", " & idsubproducto_anterior & ", " & idsubproducto & ", '" & serial & "', " & session("usxp001") & " )"
         conn.execute(sqlInsert)
         if not isnull(rsSerial("idsubproducto")) then
            'movemos el inventario del material anterior y el material nuevo
            sqlUpdateAnt = "update cac_inventario set saldo = saldo - 1 where idcac = " & idcac & " "
            sqlUpdateAnt = sqlUpdateAnt & " and idsubproducto = " & idsubproducto_anterior
            conn.execute(sqlUpdateAnt)
            sqlInv = "select idcac_inventario from cac_inventarios where idcac = " & idcac & " and idsubproducto = " & idsubproducto
            set rsInv = conn.execute(sqlInv)
            if rsInv.eof then
               sqlInsert = "insert into cac_inventario (idcac, idproducto, idsubproducto, saldo) "
               sqlInsert = sqlInsert & " select " & idcac & ", idproducto, " & idsubproducto & " , 1 "
               sqlInsert = sqlInsert & " from productos_serial where serial = '" & serial & "'"
               conn.execute(sqlInsert)
            else
               sqlUpdate = "update cac_inventario set saldo = saldo + 1 where idcac = " & idcac & " "
               sqlUpdate = sqlUpdate & " and idsubproducto = " & idsubproducto
               conn.execute(sqlUpdate)
            end if
         end if
         response.redirect "cambio_material_imprimir.asp?serial="&serial
      else
         %>
          <a href="javascript:history.back();"><font color="blue">Regresar</font></a>
          <br><br>
          <center>
            <font color="990000" size="3">El serial <b><%=serial%></b> no esta asignado a su CAC</font>
          </center>
         <%
      end if
   end if
end if
if (len(serial) = 17) then
   sqlSerial = "select idcac, idsubproducto from sims where sim = '" & serial & "' and idcac =" & idcac
   set rsSerial = conn.execute(sqlSerial)
   if rsSerial.eof then
      'insertamos unicamente el serial en cambio_material_cac
      sqlInsert = "insert into cambio_material_cac(idcac, idsubproducto_anterior, idsubproducto, serial, idtercero) "
      sqlInsert = sqlInsert & " values(" & idcac & ", NULL, " & idsubproducto & ", '" & serial & "', " & session("usxp001") & " )"
      conn.execute(sqlInsert)
   else
      idsubproducto_anterior = rsSerial("idsubproducto")
      if isnull(idsubproducto_anterior) then
         idsubproducto_anterior = "NULL"
      end if
      if cdbl(idcac) = cdbl(rsSerial("idcac")) then
         'insertamos el serial en cambio_material_cac
         sqlInsert = "insert into cambio_material_cac (idcac, idsubproducto_anterior, idsubproducto, serial, idtercero) "
         sqlInsert = sqlInsert & " values(" & idcac & ", " & idsubproducto_anterior & ", " & idsubproducto & ", '" & serial & "', " & session("usxp001") & " )"
         conn.execute(sqlInsert)
         if not isnull(rsSerial("idsubproducto")) then
            'movemos el inventario del material anterior y el material nuevo
            sqlUpdateAnt = "update cac_inventario set saldo = saldo - 1 where idcac = " & idcac & " "
            sqlUpdateAnt = sqlUpdateAnt & " and idsubproducto = " & idsubproducto_anterior
            conn.execute(sqlUpdateAnt)
            sqInv = "select idcac_inventario from cac_inventarios where idcac = " & idcac & " and idsubproducto = " & idsubproducto
            set rsInv = conn.execute(sqlInv)
            if rsInv.eof then
               sqlInsert = "insert into cac_inventario (idcac, idproducto, idsubproducto, saldo) "
               sqlInsert = sqlInsert & " select " & idcac & ", idproducto, " & idsubproducto & " , 1 "
               sqlInsert = sqlInsert & " from sims where sim = '" & serial & "'"
               conn.execute(sqlInsert)
            else
               sqlUpdate = "update cac_inventario set saldo = saldo + 1 where idcac = " & idcac & " "
               sqlUpdate = sqlUpdate & " and idsubproducto = " & idsubproducto
               conn.execute(sqlUpdate)
            end if
         end if
         response.redirect "cambio_material_imprimir.asp?serial="&serial
      else
         %>
          <a href="javascript:history.back();"><font color="blue">Regresar</font></a>
          <br><br>
          <center>
            <font color="990000" size="3">El sim <b><%=serial%></b> no esta asignado a su CAC</font>
          </center>
         <%
      end if
   end if
end if



%>

