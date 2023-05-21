<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/md5.asp"-->
<!--#include file="../include/funciones.inc.asp"-->
<!--#include file="../include/funcionCorreo.asp"-->
<!--#include file="../include/constantes.inc.asp"-->
<%
'response.write "hola"
'response.end
'seleccionamos el siguiente numero de la secuencia de terceros
sql= "select numero+1 as num from secuencias where secuencia = 'terceros'"
set rs=conn.execute(sql)
idtercero = rs("num")

'traemos los datos recogidos en la forma
idtercero2 = request.form("idtercero2")
tercero = ucase(request.form("tercero"))
'le quitamos los espacios dobles al nombre
tercero = reemplazar_espacios(tercero)
idcargo = request.form("idcargo")
sql = "select areas.idarea from areas, cargos where cargos.idarea = areas.idarea and cargos.idcargo = " & idcargo
set rs =conn.execute(sql)
idarea = rs("idarea")
idciudad = request.form("idciudad")
estado = 1 'activo

idpos = request.form("idpos")
idcentro_costo = request.form("idcentro_costo")
idempresa_temporal = request.form("idempresa_temporal")
idcreador = session("usxp001")
usuario = request.form("usuario")
clave = md5(trim(request.form("clave")))
linea = request.form("linea")
email = request.form("Email")

if linea = "" then
  linea = 0 'valor default en bd
end if
idcliente = 1

'se verifica que sea un nombre de correo válido
if email <> "" then
   dim miCadena,numItems
   miCadena = Split(email,"@",-1,1)
   if ucase(micadena(1)) <> "LOGYTECHMOBILE.COM" then
      response.redirect("terceros_crear.asp?estado=4")
   else
      numItems = Split(miCadena(0),".",-1,1)
      if ubound(numItems) <> 1 then
         response.redirect("terceros_crear.asp?estado=4")
      end if
   end if
 'else
 '    response.redirect("terceros_crear.asp?estado=4")   
 end if  

'se hacen las valoraciones necesarias
'usuario y clave no existentes

sql = "select count(0) as cant from terceros where usuario = '"& usuario &"'"
sql = sql & " and clave = '"& clave &"'"
set rs = conn.execute(sql)
if cdbl(rs("cant")) <> 0 then
  response.redirect("terceros_crear.asp?estado=2")
end if

sql = "select count(0) as cant from terceros where idtercero2 = '"& idtercero2 &"'"
set rs = conn.execute(sql)
if cdbl(rs("cant")) <> 0 then
  response.redirect("terceros_crear.asp?estado=3")
end if

'insertamos los datos en la tabla terceros.
sql = "insert into terceros "
sql = sql & " (idtercero2,tercero,idarea,idcargo,idciudad,estado,usuario,clave,linea,idcliente, idpos, idcentro_costo, idempresa_temporal, idcreador, email)"
sql = sql & " values ('"& idtercero2 &"','"& tercero &"',"
sql = sql & idarea &","& idcargo &","& idciudad &","& estado &",'" & usuario &"','"& clave &"',"
sql = sql & linea &","& idcliente &", " & idpos & " , " & idcentro_costo & ", " & idempresa_temporal & ", " & idcreador & ",'" & email & "')"
'response.write(sql)
'response.end
set rs=conn.execute(sql)

'actualizamos la tabla de secuencias en la tabla terceros para evita cruces
sql = "update secuencias set numero = "& idtercero
sql = sql & " where secuencia = 'terceros'"
set rs=conn.execute(sql)
 if idPos <> 1 then
	 		comprobarCorreo idpos,pos,conn,idcargo 
 end if
'cerramos objetos de BD conexion y los limpiamos
'rs.Close
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect("terceros_crear.asp?estado=1")
%>


<%
sub comprobarCorreo(idpos,pos,conn,idcargo)
sql = " select correo,'seguridad' as tabla from correoSeguridadCandados  where activo = 1 "
sql = sql + "union select cargo as correo, 'cargo' as tabla from cargos where idCargo = " & idcargo + " and idCargo in (78,79,85,88,90,119)"
destino = EMAIL_NOTIF_SEGURIDAD 

 
set rsDestino = conn.execute(sql)
if not rsDestino.EOF then
	 while not rsDestino.EOF
			if rsDestino("tabla") = "seguridad" then destino = destino + ";" +rsDestino("correo")
			if rsDestino("tabla") = "cargo"  then
				 motivo = "Asigno un nuevo <b>" +  rsDestino("correo") + "</b> al Punto de Venta: " + pos
			end if
			rsDestino.moveNext
 	 wend

	 destino =destino


	 titulo = "Se realizo un cambio en el Punto de Venta: "  + pos
	 asunto = "Actualización de Candado(s) para el Punto de Venta: "  + pos

	 nota = "Este correo es generado automaticamente,si tiene alguna duda," 
	 nota = nota + " inquietud o comentario por favor envíe un e-mail al grupo IT DEVELOPMENT"

	 firma = "Proceso Activaciones Retail"
	 contenidoCorreo = "Se " & motivo & ", por favor asignarle una nueva clave"

	 enviarCorreo titulo,asunto,destino,firma,contenidoCorreo,nota,nothing
end if
set rsDestino = nothing
end sub
%>
