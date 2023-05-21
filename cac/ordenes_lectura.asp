<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<%
idorden = request.querystring("idorden")
serialUlt = request.querystring("serialUlt")

sqlOrden = "select idorden_cac, idorden2_cac, convert(varchar, fecha, 105) as fecha, idcac,"
sqlOrden = sqlOrden & " (select cac from cac where idcac = a.idcac) as cac, cantidad, cantidad_leida, idproducto, idsubproducto, "
sqlOrden = sqlOrden & " (select subproducto from subproductos where idsubproducto = a.idsubproducto) as subproducto, estado "
sqlOrden = sqlOrden & " from ordenes_cac a "
sqlOrden = sqlOrden & " where idorden_cac = " & idorden
set rsOrden = conn.execute(sqlOrden)
estado = rsOrden("estado")

%>
<html>
<head>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
{
    if (document.forma.serial.value == "")
        {
        alert ("Digite o Dispare el serial, Por Favor");
        document.forma.serial.focus();
        return (false);
        }
        if((document.forma.serial.value.length != 15) && (document.forma.serial.value.length != 11)  )
        {
            alert("La longitud del IMEI es de  "+document.forma.serial.value.length+", no es aceptada. Tiene que ser de 15 ú 11");
            document.forma.serial.focus();
            return(false);
        }
}
function validar_orden()
{
    if (document.forma.cantidad.value != document.forma.cantidad_leida.value)
        {
        alert ("No se puede cerrar esta orden.\nLa cantidad leida es diferente a la cantidad pedida en la orden");
        return (false);
        }
}
</SCRIPT>
</HEAD>
<body bgcolor="#FFFFFF" class="cuerpo2">
<!--#include file="../include/titulo1.inc.asp" -->
<ul>
<a href="javascript:history.back();" ><font color="blue"><u>Regresar</u></font></a><br><br>
<font style="font-weight:bold" size="3">Orden de Lectura CAC No. <%=idorden%></font>
<table border=0 class="tabla">
  <TR>
    <TD bgcolor="DDDDDD"><b>Num</b></TD>
    <TD><%=rsOrden("idorden_cac")%></TD>
  </TR>
  <TR>
    <TD bgcolor="DDDDDD"><b>Orden</b></TD>
    <TD><%=rsOrden("idorden2_cac")%></TD>
  </TR>
  <TR>
    <TD bgcolor="DDDDDD"><b>Fecha</b></TD>
    <TD><%=rsOrden("fecha")%></TD>
  </TR>
  <TR>
    <TD bgcolor="DDDDDD"><b>Cac</b></TD>
    <TD><%=rsOrden("cac")%></TD>
  </TR>
  <TR>
    <TD bgcolor="DDDDDD"><b>Cantidad Pedida</b></TD>
    <TD><%=rsOrden("cantidad")%></TD>
  </TR>
  <TR>
    <TD bgcolor="DDDDDD"><b>Cantidad Leida:</b></TD>
    <TD>
         <%
         sqlCantidad = "select count(*) as cantidad from ordenes_cac_detalle where idorden_cac = " & idorden
         set rsCantidad = conn.execute(sqlCantidad)
         if not rsCantidad.eof then
            %>
            <%=trim(rsCantidad("cantidad"))%>
            <%
         end if
         %>
    </TD>
  </TR>
</TABLE>
<hr>
<ul>
<%
if estado = "1" then
%>
 <form name="forma" method="post" action="ordenes_lectura2.asp" onsubmit="return validacion();" >
   <table class="tabla">
     <tr>
       <td><font style="font-weight:bold" color="#0099CC">Dispare o digite el serial</font></td>
     </tr>
     <tr>
       <td>
          <input type="text" name="serial" size="20" maxlength="15" class="textbox" >
          <%
          if serialUlt <>  "" then
             %>
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font style="font-weight:bold" color="#0099CC">Ultimo serial: <%=serialUlt%></font>
             <%
          end if

         %>
       </td>
     </tr>
   </table>
   <input type="hidden" name="idorden" value="<%=idorden%>">
   <input type="hidden" name="cantidad" value="<%=rsOrden("cantidad")%>">
   <input type="hidden" name="cantidad_leida" value="<%=trim(rsCantidad("cantidad"))%>">
   <input type="hidden" name="idcac" value="<%=rsOrden("idcac")%>">
   <input type="hidden" name="idproducto" value="<%=rsOrden("idproducto")%>">
   <input type="hidden" name="idsubproducto" value="<%=rsOrden("idsubproducto")%>">
 </form>
 <script language="JavaScript">
   document.forma.serial.focus();
 </script>
 <%
 if cdbl(rsOrden("cantidad")) = cdbl(rsCantidad("cantidad")) then
 %>
 <a href="ordenes_cerrar.asp?idorden=<%=idorden%>" onclick="return validar_orden();">
   <font color="blue" style="font-weight:bold" size="3"><u>Cerrar esta Orden</u></font>
 </a><br><br>
 <%
 end if
 %>
<%
end if
%>
</ul>


<div id="seriales" style="position: absolute; left: 510px; top: 65px; height: 400px; width: 100px; padding: 1em; " bgcolor="990000" >
<%
sqlSeriales = "select serial from ordenes_cac_detalle where idorden_cac = " & idorden & " order by serial"
set rsSeriales = conn.execute(sqlSeriales)
%>
<a href="javascript:void(0);" onclick="seriales.style.display='none';">
<font face="verdana" size="1px">Ocultar (X)</font>
</a>
<table bgcolor="ffffff" border="1" bordercolor="000000" class="tabla">
<%
while not rsSeriales.eof
      %>
      <tr>
        <td><%=trim(rsSeriales("serial"))%></td>
      </tr>
      <%
      rsSeriales.movenext
wend
%>
</table>
</div>

</body>
</html>

<%


conn.close
response.end
%>





