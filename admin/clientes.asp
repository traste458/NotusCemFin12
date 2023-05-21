<html>
<body>
<% session("titulo")="Clientes"
%>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/titulo1.inc.asp"-->
<form name=forma2 method=post action=clientes_buscar.asp>
  <% if request.querystring("idestado") = 1 then %>
  <center><font color="#FF0000" size="3">Cliente Actualizado Satisfactoriamente</font></center> 
  <% End if%>
  <% if request.querystring("idestado") = 3 then %>
  <center><font color="#FF0000" size="3">Cliente Inactivado Satisfactoriamente</font></center> 
  <br>
  <% End if%>
  <b><font color="gray" face=arial>Buscar en clientes</font></b>
  <br><br>
  Nombre del Cliente : 
  <input type=text name=buscar size=20>
  <font color=gray size=2><i>(O parte de este)</i></font>
  <br><br>
  <input type=submit name=bt_buscar value='Buscar'>
  <br>
  <br>
  <hr>
</form>
<form name=forma method=post action=clientes1.asp>
  <% if request.querystring("idestado") = 2 then %>
  <font color="#FF0000" size="5">Cliente Ingresado Satisfactoriamente</font> <br>
  <% End if%>
  <b><font color="gray" face=arial>Insertar en clientes</font></b>
  <br><br>
  Ciudad: 
  <input type=text name=ciudad value="bog%">
  <font color=gray size=2><i>(Escriba las iniciales o partes del nombre separadas 
  por el signo %)</i></font><br>
  <br>
  <input type=submit name=boton value=Continuar..>
</form>
<script language="JavaScript">
  document.forma2.buscar.focus();
</script>
</body>
</html>