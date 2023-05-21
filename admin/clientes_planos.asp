<%@ language= "VBscript"%>
<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<html>
<head>
<script language="JavaScript">
function validacion()  {
  if (document.forma.file1.value == "")  {
    alert("Elija el Archivo de Clientes a Subir");
    document.forma.file1.focus();
    return (false);
  }
}
function Nueva_Ventana(Url,Var) {
  CAM = window.open(Url,"Ejemplos",Var) ;
}
</SCRIPT>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
region = request.form("region")
session("usxp_region") = region
%>
<%session("titulo")="Subir Plano de clientes - "&session("usxp_region")%>
<!--#include file="../include/titulo1.inc.asp" -->
<a href="actualizar.asp"><<< Regresar</a>
<%
if request.querystring("vacio") = 1 then %>
  <center><font color=red><b>El archivo esta vacio.</b></font></center><br><br>
  <% 
end if
%>
<form name=forma method=post action="clientes_planos2.asp" enctype="multipart/form-data" onsubmit="return validacion()">
<font color=blue><i>Formato del Archivo (idcliente2|dealer|cliente|ciudad|direccion|telefono|region)</i></font><br>
<br>
<input type=file name="file1" size=60>
<ul>
<input type="submit" value="Subir este Archivo">
</form>
<font color=gray face=arial><i>El sistema actualizará los clientes que encuentre con el mismo código de cliente(idcliente2), y creará los demas en la BD de inventarios.</i></font>
</ul>
<hr>
<a href="JavaScript:void (0) ;" onclick=" Nueva_Ventana('../archivos_planos/ejemplo_correcto_clientes.txt','Width=600 ,Height=300,Left=200,Top=100,scrollbars') ;">Ver ejemplo Valido</a>
<br>
<a href="JavaScript:void (0) ;" onclick=" Nueva_Ventana('../archivos_planos/ejemplo_errado_clientes.txt','Width=600 ,Height=300,Left=200,Top=100,scrollbars') ;">Ver ejemplo Errado</a>
</body>
</html>