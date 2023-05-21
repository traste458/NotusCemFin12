<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
numero = clng(request.form("numero"))
i = 0
arreglo = ""
'response.write numero
'response.end
while i < numero
  check = Request.form("check" & cstr(i))
  if check = "on" then
     idservicio = Request.form("idservicio" & i)
     sqlUpdate = "update servicio_tecnico set estado = 1, fecha_entrega = getdate() where idservicio = " & idservicio
     conn.execute(sqlUpdate)
     arreglo = arreglo & idservicio & ","
  end if
  i = i + 1
wend

response.redirect "servicio_imprimir.asp?arreglo=" & arreglo
%>