<%@ language= "VBscript"%>
<!--#include file="../include/seguridad.inc.asp" -->
<html>
<head>
<script language="JavaScript">
function validacion()  {
  if (document.forma.region.value == 0)  {
    alert("Elija la Región de los Clientes a Subir");
    document.forma.region.focus();
    return (false);
  }
}
</SCRIPT>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%session("titulo")="Subir Plano de clientes - Elija Región"%>
<!--#include file="../include/titulo1.inc.asp" -->
<a href="actualizar.asp"><<< Regresar</a>
<%
if request.querystring("cant1") <> "" then 
  i = cdbl(request.querystring("cant1")) %>
  <center><font color=blue><b><%=i%> Clientes fueron ingresados al Sistema</b></font></center><br><br>
  <% 
end if
if request.querystring("cant2") <> "" then 
  j = cdbl(request.querystring("cant2")) %>
  <center><font color=blue><b><%=j%> Clientes fueron actualizados en el Sistema</b></font></center><br><br>
  <% 
end if
%>
<form name=forma method=post action="clientes_planos.asp" onsubmit="return validacion()">
<ul>
 Elija región
 <select name=region>
   <option value=0>Elija Región</option>
   <option value="OR">OR</option>
   <option value="OC">OC</option>
   <option value="NO">NO</option>
 </select>  
 <br><br>
 <input type=submit value=Continuar>
<ul>
</form>
</body>
</html>