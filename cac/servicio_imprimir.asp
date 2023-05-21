<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
'recuperapmos las variables
arreglo = request.querystring("arreglo")
arreglo = left(arreglo, (len(arreglo) - 1))
'actualizamos el estado del servicio
sqlCac = "select isnull(idcac,0) as idcac from cac where idAuxiliar = " & session("usxp001")
set rsCac = conn.execute(sqlCac)
if not rsCac.eof then
    idcac = rsCac("idcac")
else
   %> 
	 		<div align=center><font color="Red" size=3 face=arial><b>Usuario no tiene asignación a un CAC, por favor notificar al administrador </b></font></div>
	<%
	rsCac.close
	set rsCac = nothing
	response.end
	
end if 
rsCac.close
%>
<html>
<head>
<title>Imprimir Entrega a Servicio Técnico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" >
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function imprimir()
{
  //volver.style.display = 'none';
  window.print();
  //volver.style.display = 'block';
}

</SCRIPT>

</head>
<!--#include file="../include/conexion.inc.asp" -->
<%
 region="OC"
 rte = "Logytech Mobile S.A"
 nit = "900.208.029-2"
 tel= "4395237"
 dir = "Cra 106 No. 15 - 25 Int 121 Bodega 0"
 ciu = "Bogotá"

sql= "select "
sql = sql & " serial, "
sql = sql & " (select producto from productos where idproducto = a.idproducto) as producto, "
sql = sql & " convert(varchar, a.fecha_ingreso, 105) as fecha_ingreso, convert(varchar, a.fecha_entrega, 105) as fecha_entrega, "
sql = sql & " (select tercero from terceros where idtercero = a.idtercero) as tercero, "
sql = sql & " (select cac from cac where idcac = a.idcac) as cac, "
sql = sql & " (select centro from cac where idcac = a.idcac) as centro, "
sql = sql & " (select almacen from cac where idcac = a.idcac) as almacen, razon "
sql = sql & " from servicio_tecnico a "
sql = sql & " where idcac = " & idcac & " and estado = 1 and idservicio in (" & arreglo & ")"
'response. write sql
'response.end
set rs= conn.execute(sql)
%>
<a href="servicio_buscar.asp" id="volver">Regresar</a><br><br>
<form name="forma">
<table class="tabla" border="0" width="100%">
       <tr>
         <td><a onclick="imprimir();"><img src="../images/Imprimir.gif" width="25" height="25" alt="Imprimir" border="0"></a></td>
         <td><img src="../images/logoLM_small.png" >&nbsp;</td>
          <td><font color size=2><%=rte%><br><%=nit%><br><%=dir%> Tel:<%=tel%><br><%=ciu%></td>
          <td valign="top" align="center"><font style="font-weight:bold" size="2">&nbsp;</font></td>
       </tr>
 </table>


<body class="cuerpo2">
<ul>
  <center>
    <font size="4" style="font-weight:bold" >Entrega a Servicio Técnico</font>
  </center>
</ul>
<table width="90%" border="1" bordercolor="black" class="tabla">
 <tr ><td>
   <table class="tabla" width="100%">
     <tr><td><b>Entregado a:</b></td></tr>
     <tr><td>Servicio Técnico (<%=trim(rs("cac"))%>)</td></tr>
   </table></td>
 <td align="right">
  <table align=right border="0" width=100% class="tabla">
    <tr>
      <td><b>Fecha Emision:</b></td>
      <td><%=formatdatetime(Now, 1)%></td>
    </tr>
    <tr>
      <td><b>Despachado por:</b></td>
      <td><%=session("usxp002")%> (<%=trim(rs("cac"))%></i>)</td>
    </tr>
  </table></td>
 </tr>
</table>
<br>
<table width="100%" border=1 class="tabla">
  <tr>
    <td colspan="7" align="center"><b>LISTADO DE TELEFONOS PARA ENVIAR A SERVICIO TECNICO</b></td>
  </tr>
 <tr bgcolor=#CCCCCC>
  <td><b>ITEM</b></td>
  <td><b>CENTRO</b></td>
  <td><b>ALMACEN</b></td>
  <td><b>REFERENCIA</b></td>
  <td><b>ESN/IMEI</b></td>
  <td><b>DESCRIPCION</b></td>
 </tr>   
<%
Response.flush
i = 1
while not rs.eof
%>
  <tr>
     <td><i><%=i%></b></td>
     <td><i><%=trim(rs("centro"))%></i></td>
     <td><i><%=trim(rs("almacen"))%></i></td>
     <td><i><%=trim(rs("producto"))%></i></td>
     <td><i><%=trim(rs("serial"))%></i></td>
     <td><i><%=trim(rs("razon"))%></i></td>
   </tr>
<%
  i = i + 1
  rs.movenext
wend
%>
   <tr>
     <td colspan="7" align="center">Cantidad total de Productos Entregados: <b><%=(i-1)%></b></td>

   </tr>
</table>
<br><br>
<table width="100%" border=1 bordercolor=black class="tabla">
 <tr>
   <td width="50%"><b>Despachador:</b><br><br><br><center>FIRMA Y SELLO</center></td> 
   <td width="50%"><b>Recibido por:</b><br><br><br><center>FIRMA Y SELLO</center></td> 
 </tr>
</table>   
</form>
</body>
</html>