<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
fecha_ingreso = trim(request.form("fecha_ingreso"))
serial = trim(request.Form("serial"))
razon = trim(request.form("razon"))
'response.write "87"
'response.end
arrFecha = split(fecha_ingreso, "/")
fecha_ingreso = arrFecha(2) & arrFecha(1) & arrFecha(0)

sqlVal = "select idservicio from servicio_tecnico where serial = '" & serial & "' and estado <> 3"
set rsVal = conn.execute(sqlVal)
if not rsval.eof then
   Response.redirect "servicio_crear.asp?bandera=1"
   response.end
end if

sqlProducto = " select (select idproducto from subproductos where idsubproducto = a.idsubproducto ) as idproducto "
sqlProducto =  sqlProducto & " from cambio_material_cac a    where serial = '"  & serial &"'"
set rsProducto = conn.execute(sqlProducto)
if (rsProducto.eof) then
    sqlProd2 = "select idproducto from productos_serial where serial = '" & serial & "'"
    set rsProd2 = conn.execute(sqlProd2)
    if rsProd2.eof then
       sqlProd3 = "select idproducto from cac_seriales where serial = '" & serial & "'"
       set rsprod3 = conn.execute(sqlProd3)
       if rsProd3.eof then
          response.redirect "servicio_crear3.asp?serial=" & serial & "&fecha_ingreso=" & trim(fecha_ingreso) & "&razon=" & razon
          response.end
       else
         idproducto = rsProd3("idproducto")
       end if
    else
      idproducto = rsProd2("idproducto")
    end if
else
  if isnull(rsProducto("idproducto")) then
    sqlProd2 = "select idproducto from productos_serial where serial = '" & serial & "'"
    set rsProd2 = conn.execute(sqlProd2)
    if rsProd2.eof then
       sqlProd3 = "select idproducto from cac_seriales where serial = '" & serial & "'"
       set rsprod3 = conn.execute(sqlProd3)
       if rsProd3.eof then
          response.redirect "servicio_crear3.asp?serial=" & serial & "&fecha_ingreso=" & trim(fecha_ingreso) & "&razon=" & razon
          response.end
       else
         idproducto = rsProd3("idproducto")
       end if
    else
      idproducto = rsProd2("idproducto")
    end if
  else
    idproducto = rsProducto("idproducto")
  end if
end if

sqlCac = "  select idcac from cac where idAuxiliar=  " & session("usxp001")
set rsCac = conn.execute(sqlCac)
idcac = rsCac("idcac")
'insertamos el serial
sqlInsert = "insert into servicio_tecnico(serial, fecha_ingreso, estado, idtercero, idcac, idproducto, razon) "
sqlInsert = sqlInsert & " values('" & serial & "', '" & fecha_ingreso & "', 0, " & session("usxp001") & ", " & idcac & ", " & idproducto & ", '" & razon & "')"
conn.execute(sqlInsert)
response.redirect "servicio_crear.asp?serial=" & serial & "&bandera=2"
%>