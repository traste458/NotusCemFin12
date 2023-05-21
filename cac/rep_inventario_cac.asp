<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<html>
<head>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" class="cuerpo2">
<% session("titulo")= "Reporte de Inventarios CAC's" %>
<!-- #include file="../include/titulo1.inc.asp" -->
<% 
sqlCac = "select idcac, idcac2, cac from cac where idcac <> 1 order by cac "
set rsCac = conn.execute(sqlCac)
%>
<a href=despachos_crear.asp><u></u></a> <br>
<form name="forma" method="post" action="rep_inventario_cac2.asp" >
<table class="tabla">
   <tr>
     <td>Elija el CAC</td>
     <td>
       <select name="idcac">
         <%
         while not rsCac.eof
               %>
               <option value="<%=rsCac("idcac")%>"><%=rsCac("idcac2")& " - " &rsCac("cac")%></option>
               <%
               rsCac.movenext
         wend
         %>
       </select>
     </td>
   </tr>
</table>
<ul>
<input type="submit" value="Ver Inventario" class="boton">
</ul>
</form>
</body>
</html>