<%@ language= "VBscript"%>
<% session("titulo") = "Subir Planos (Clientes)" %>
<!--#include file="../include/titulo1.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<head>
<script language="JavaScript">
function validacion()  {
        if (document.forma.file1.value == "")  {
		alert("Elija el Archivo de Clientes a Subir");
		document.forma.file1.focus();
		return (false);
        }
}
</script>
</head>
<html>
<body bgcolor="#FFFFFF" text="#000000">
<form name=forma method=post action="planos_clientes2.asp" enctype="multipart/form-data" onsubmit="return validacion()">
<SCRIPT LANGUAGE="JavaScript">
function Nueva_Ventana(Url,Var)	{
	CAM = window.open(Url,"Ejemplos",Var) ;
}
</SCRIPT>
<a href="actualizar.asp"><<< Regresar</a><br><br>
<%
if request.querystring("cant") <> "" then 
   i = request.querystring("cant")
   %>
  <center><font color=blue><b><%=i%> Clientes fueron ingresados al Sistema</b></font></center><br><br>
  <% 
end if
%>
<font color=blue><i>Formato del Archivo (idcliente2,dealer,cliente,ciudad,direccion,telefono)</i></font><br>
  <input type=file name="file1" size=60>
<br>
<br><input type="submit" value="Subir este Archivo">

<br>
<br>
<hr>
<a href="JavaScript:void (0) ;" onclick=" Nueva_Ventana('../archivos_planos/ejemplo_correcto_clientes.txt','Width=600 ,Height=300,Left=200,Top=100,scrollbars') ;">Ver ejemplo Valido</a>
      <br>
      <a href="JavaScript:void (0) ;" onclick=" Nueva_Ventana('../archivos_planos/ejemplo_errado_clientes.txt','Width=600 ,Height=300,Left=200,Top=100,scrollbars') ;">Ver ejemplo Errado</a>
</form>
</body>
</html>
