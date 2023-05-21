<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
idcac = request.form("idcac")
idcac2 = trim(request.form("idcac2"))
cac = trim(request.form("cac"))
idciudad = request.form("idciudad")
direccion = trim(request.form("direccion"))
telefono = trim(request.form("telefono"))
idauxiliar = request.Form("idauxiliar")
region = request.form("region")
centro = trim(request.form("centro"))
idEstado = request.form("ddlEstado")

'actualizamos los datos en la tabla pos
sql = "update cac set cac ='"& cac &"',direccion='"& direccion &"'"
sql = sql & ", telefono='"& telefono & "', region = '" & region & "', idEstado= "& idEstado&" ,idciudad="& idciudad & ", idauxiliar = " & idauxiliar

if centro<>"" then sql = sql & " , centro = " & centro 

sql = sql & " where idcac = "& idcac
'Response.write sql
'response.end
set rs=conn.execute(sql)

'cerramos objetos de BD conexion y piscina  y los limpiamos
conn.Close
Set rs = nothing
Set conn = nothing
response.redirect "cac_actualizar.asp?bandera=3&idcac2="&idcac2&"&idcac="&idcac   'pos actualizado
%>