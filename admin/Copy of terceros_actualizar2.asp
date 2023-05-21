<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/md5.asp"-->
<%
idtercero = request.form("idtercero")

'traemos los datos recogidos en la forma
idtercero2 = request.form("idtercero2")
tercero = request.form("tercero")

idcargo = request.form("idcargo")
sql = "select areas.idarea from areas, cargos where cargos.idarea = areas.idarea and cargos.idcargo = " & idcargo
set rs =conn.execute(sql)
idarea = rs("idarea")

idciudad = request.form("idciudad")
idpos = Request.Form("idpos")
idcentro_costo = Request.form("idcentro_costo")
idempresa_temporal = request.form("idempresa_temporal")


'verificacion de cambio de clave
cambioclave = request.form("cambioclave")
if cambioclave = "1" then
   clave = md5(trim(request.form("clave")))
else
   clave = trim(request.form("clave"))
end if


linea = request.form("linea")
idestado = request.form("idestado")
if linea = "" then
  linea = 0 'valor default en bd 
end if
idcliente = 1

'se hacen las valoraciones necesarias
'usuario y clave no existentes .... en caso de que se haya actualizado la clave
sql = "select usuario,clave from terceros where idtercero="& idtercero
set rs=conn.execute(sql)
usuario_ant = rs("usuario")
clave_ant = rs("clave")
response.write "clave1="&clave_ant&"<br>"
response.write "clave2="&clave&"<br>"
'response.end

'actualizamos los datos en la tabla terceros.
sql = "update terceros set "
sql = sql & " idtercero2='"& idtercero2 &"',tercero='"& tercero &"',"
sql = sql & " idarea="& idarea &",idcargo="& idcargo &",idciudad="& idciudad &","
sql = sql & " estado="& idestado &", clave='"& clave &"',"
sql = sql & " linea="& linea &",idcliente="& idcliente & ", idpos = " & idpos & ", idcentro_costo = " & idcentro_costo & ", idempresa_temporal = " & idempresa_temporal
sql = sql & " where idtercero = "& idtercero 
'response.write (sql)
'response.end
set rs=conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
'rs.Close
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect("terceros_actualizar.asp?idtercero="&idtercero&"&estado=1")
%>