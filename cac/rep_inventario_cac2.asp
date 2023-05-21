<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<html>
<head>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" class="cuerpo2">
<%
idcac = request.form("idcac")
sqlCac = "select idcac, idcac2, cac from cac where idcac = " & idcac
set rsCac = conn.execute(sqlcac)

session("titulo")= "Reporte de Inventarios " & rsCac("idcac2") & " - " & rsCac("cac")
%>
<!-- #include file="../include/titulo1.inc.asp" -->
<a href=rep_inventario_cac.asp><font color="blue">Regresar</font></a> <br><br>
<%

sqlInventario = "select idproducto, "
sqlInventario = sqlInventario & " (select producto from productos where idproducto = a.idproducto) as producto, "
sqlInventario = sqlInventario & " idsubproducto,  "
sqlInventario = sqlInventario & " (select idsubproducto2 from subproductos where idsubproducto = a.idsubproducto) as idsubproducto2, "
sqlInventario = sqlInventario & " (select subproducto + ' - ' + region from subproductos where idsubproducto = a.idsubproducto) as subproducto, "
sqlInventario = sqlInventario & " saldo "
sqlInventario = sqlInventario & " from cac_inventario a "
sqlInventario = sqlInventario & " where idcac = " & idcac
set rsInventario = conn.execute(sqlInventario)
%>

<table class="tabla">
   <tr bgcolor="DDDDDD">
     <td><b>Producto</b></td>
     <td><b>Material</b></td>
     <td><b>Subproducto</b></td>
     <td><b>Cantidad</b></td>
   </tr>
   <%
   bgcolor="FFFFFF"
   while not rsInventario.eof
         %>
         <tr >
           <td bgcolor="<%=bgcolor%>"><%=trim(rsInventario("producto"))%></td>
           <td bgcolor="<%=bgcolor%>" align="right"><%=trim(rsInventario("idsubproducto2"))%></td>
           <td bgcolor="<%=bgcolor%>"><%=trim(rsInventario("subproducto"))%></td>
           <td bgcolor="<%=bgcolor%>" align="right"><%=trim(rsInventario("saldo"))%></td>
         </tr>
         <%
         if bgcolor = "FFFFFF" then
            bgcolor = "F0F0F0"
         else
            bgcolor = "FFFFFF"
         end if
         rsInventario.movenext
   wend
   %>
</table>
</body>
</html>