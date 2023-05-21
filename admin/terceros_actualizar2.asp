<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/md5.asp"-->
<!--#include file="../include/funciones.inc.asp"-->
<!--#include file="../include/funcionCorreo.asp"-->
<!--#include file="../include/constantes.inc.asp"-->
<%
idtercero = request.form("idtercero")

'traemos los datos recogidos en la forma
idtercero2 = request.form("idtercero2")
tercero = request.form("tercero")
'le quitamos los espacios dobles al nombre
tercero = reemplazar_espacios(tercero)

idcargo = request.form("idcargo")
sql = "select areas.idarea from areas, cargos where cargos.idarea = areas.idarea and cargos.idcargo = " & idcargo
set rs =conn.execute(sql)
idarea = rs("idarea")
rs.close

idciudad = request.form("idciudad")
idpos = Request.Form("idpos")
idcentro_costo = Request.form("idcentro_costo")
idempresa_temporal = request.form("idempresa_temporal")
email = request.Form("Email")
 
sql = "select idperfil from cargos where idcargo=" & idcargo
'response.write sql
'response.end 
set rs = conn.execute(sql)
if not rs.eof then
 idPerfil = rs("idperfil")  
end if 
if isnull(idPerfil) then idPerfil="NULL"
rs.close
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

'se verifica que sea un nombre de correo válido
if email<>"" then
  dim miCadena,numItems
  miCadena = Split(email,"@",-1,1)
  if ucase(micadena(1)) <> "LOGYTECHMOBILE.COM" then
   response.redirect("terceros_actualizar.asp?estado=4&idtercero="&idtercero)
  else
    numItems = Split(miCadena(0),".",-1,1)
    if ubound(numItems) <> 1 then
      response.redirect("terceros_actualizar.asp?estado=4&idtercero="&idtercero)
    end if 
  end if
end if

'se hacen las valoraciones necesarias
'usuario y clave no existentes .... en caso de que se haya actualizado la clave
sql = "select usuario,clave from terceros where idtercero="& idtercero
set rs=conn.execute(sql)
usuario_ant = rs("usuario")
clave_ant = rs("clave")
'response.write "clave1="&clave_ant&"<br>"
'response.write "clave2="&clave&"<br>"
'response.end

'actualizamos los datos en la tabla terceros.
sql = "update terceros set "
sql = sql & " idtercero2='"& idtercero2 &"',tercero='"& tercero &"',"
sql = sql & " idarea="& idarea &",idcargo="& idcargo &",idciudad="& idciudad &","
sql = sql & " estado="& idestado &", clave='"& clave &"',"
sql = sql & " linea="& linea &",idcliente="& idcliente & ", idpos = " & idpos & ", idcentro_costo = " & idcentro_costo & ", idempresa_temporal = " & idempresa_temporal
sql = sql & ", idperfil = " & idPerfil & ",email='" & email & "'"
sql = sql & " where idtercero = "& idtercero 
'response.write (sql)
'response.end
conn.execute(sql)


if instr("78,79,85,88,90,119",cstr(idCargoActual)) > 0 or instr("78,79,85,88,90,119",cstr(idCargo)) > 0 then 
motivo = ""
 
		if estado = 1 then 
		strEstado = "Activo"
		else
		strEstado = "Inactivo"
		end if

if estadoActual <> strEstado then
 		Motivo = " El estado de <b>" & tercero &  "</B> a cambiado y actualmente es: "
		if estado = 1 then 
		Motivo = Motivo + "Activo"
		else
		Motivo = Motivo + "Inactivo"
		end if
elseif  idCargoActual <> idcargo then
				sql ="select (select  cargo from cargos where idCargo = " +idCargo +" ) as cargo ,"
				sql = sql + "(select pos from pos where idpos = " + idpos + ") as pos " 
				set rsCargo = conn.execute(sql)
				cargoMotivo =rsCargo("cargo") 
				posCargo = rsCargo("pos")
				Motivo = " El cargo asignado para <b>" & tercero &  "</b> fue modificado a " + cargoMotivo + " del Punto de Venta " + posCargo 
			 	set rsCargo = nothing  
elseif idPosActual <> idpos then
			 sql ="select (select 'El ' + cargo from cargos where idCargo = " +idcargo +" ) as cargo ,"
			 sql = sql + "(select pos from pos where idpos = " + idpos + ") as pos " 
			 set rsCargo = conn.execute(sql)
			 cargoMotivo =rsCargo("cargo") 
			 posCargo = rsCargo("pos")
			 Motivo = cargoMotivo & " <b>" & tercero &  "</b> fue trasladado al Punto de Venta: " + posCargo 
			 set rsCargo = nothing  
else
		Motivo = ""
end if

if motivo <> "" then
	 comprobarCorreo conn,motivo 
end if 
end if
'cerramos objetos de BD conexion y piscina  y los limpiamos
'rs.Close
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect("terceros_actualizar.asp?idtercero="&idtercero&"&estado=1")
%>


<%


sub comprobarCorreo(conn,motivo)
sql = " select correo,'seguridad' as tabla from correoSeguridadCandados "
sql = sql + " where activo = 1 "
destino = EMAIL_NOTIF_SEGURIDAD 

 
set rsDestino = conn.execute(sql)

while not rsDestino.EOF
			destino = destino + ";" +rsDestino("correo")
			rsDestino.moveNext
wend

destino =destino


titulo = "Se realizo un cambio en el Punto de Venta: "  + pos
asunto = "Actualización de Candado(s) para el Punto de Venta: "  + pos

nota = "Este correo es generado automaticamente,si tiene alguna duda," 
nota = nota + " inquietud o comentario por favor envíe un e-mail al grupo IT DEVELOPMENT"

firma = "Proceso Activaciones Retail"
contenidoCorreo =  motivo & ", por favor asignarle Nuevas claves a los candados"
response.write detino
enviarCorreo titulo,asunto,destino,firma,contenidoCorreo,nota,nothing
		
end sub
%>
