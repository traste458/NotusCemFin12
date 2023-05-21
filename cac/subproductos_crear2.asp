<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idproducto = request.form("idproducto")
subproducto = trim(request.form("subproducto"))
'response.write idproducto
'Response.end

set oCmd = Server.CreateObject("ADODB.Command")

oCmd.ActiveConnection = conn
oCmd.CommandText = "CrearSubproductoCAC"
oCmd.CommandType = 4

paramId = Server.CreateObject("ADODB.Parameter")
set paramId = oCmd.CreateParameter("idSubproducto",20,4)

oCmd.Parameters.Append paramId
oCmd.Parameters.Append oCmd.CreateParameter("nombre", 200, 1, 100,subproducto)
oCmd.Parameters.Append oCmd.CreateParameter("idProducto", 20, 1,, idproducto)

paramMaterial = Server.CreateObject("ADODB.Parameter")
set paramMaterial = oCmd.CreateParameter("material",200,2,15)

oCmd.Parameters.Append paramMaterial

oCmd.Execute
if not IsNull(paramId) then
  if cdbl(paramId.value) = 0 then
    response.redirect "subproductos_crear.asp?bandera=6"
  elseif cdbl(paramId.value) = 1 then
    response.redirect "subproductos_crear.asp?bandera=7"
  else
    material = cstr(paramMaterial.value)
    set oCmd = nothing
    conn.close
    set conn = nothing
    response.redirect "subproductos_crear.asp?bandera=4&subproducto=" & ucase(subproducto) & "&idsubproducto2=" & material
  end if
else
  set oCmd = nothing
  conn.close
  set conn = nothing
  response.redirect "subproductos_crear.asp?bandera=5"
end if 

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rsId = nothing
Set rsId2 = nothing
Set conn = nothing
%>

