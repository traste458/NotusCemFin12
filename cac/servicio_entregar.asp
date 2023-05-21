<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.serial.value == "")
        {
        alert ("Digite o dispare el serial, Por Favor");
        document.forma.serial.focus();
        return (false);
        }
    if (isNaN(document.forma.serial.value))
       {
        alert ("Verifique el serial, solamente se permiten numeros en el serial");
        document.forma.serial.focus();
        return (false);
       }
    if ((document.forma.serial.value.length != 15) && (document.forma.serial.value.length != 11))
       {
        alert ("Verifique el serial, la longitud del serial debe ser de 15 u 11");
        document.forma.serial.focus();
        return (false);
       }


    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Ingreso de Servicio Técnico</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="servicio_buscar.asp"><u>Buscar Servicio Técnico</u></A>
<%
idservicio = request.querystring("idservicio")
sqlServicio = "select "
sqlServicio = sqlServicio & " serial, "
sqlServicio = sqlServicio & " (select producto from productos where idproducto = a.idproducto) as producto, "
sqlServicio = sqlServicio & " convert(varchar, a.fecha_ingreso, 105) as fecha_ingreso, convert(varchar, a.fecha_entrega, 105) as fecha_entrega, "
sqlServicio = sqlServicio & " (select tercero from terceros where idtercero = a.idtercero) as tercero "
sqlServicio = sqlServicio & " from servicio_tecnico a "
sqlServicio = sqlServicio & " where idservicio = " & idservicio
set rsServicio = conn.execute(sqlServicio)

bandera = request.querystring("bandera")
if bandera = "1" then
   serial = request.querystring("serial")
   %>
   <center>
     <font color="990000" style="font-weight:bold" >El serial <%=serial%> fue incluido en otro servicio técnico</font>
   </center>
   <%
end if

%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="servicio_entregar2.asp" onSubmit="return validacion();">
<table class="tabla">
  <tr>
    <td bgcolor="F0F0F0"><b>Producto</b></td>
    <td ><%=trim(rsServicio("producto"))%></td>
  </tr>
  <tr>
    <td bgcolor="F0F0F0"><b>Serial Entregado a Servicio Técnico</b></td>
    <td ><%=trim(rsServicio("serial"))%></td>
  </tr>
  <tr>
    <td bgcolor="F0F0F0"><b>Fecha de Ingreso</b></td>
    <td ><%=trim(rsServicio("fecha_ingreso"))%></td>
  </tr>
  <tr>
    <td bgcolor="F0F0F0"><b>Fecha de Entrega a Servicio Técnico</b></td>
    <td ><%=trim(rsServicio("fecha_entrega"))%></td>
  </tr>
</table>
<input type="hidden" name="idservicio" value="<%=idservicio%>">
<br>
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Digite o Dispare el serial que esta recibiendo:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="serial" SIZE="25" MAXLENGTH="20" class="textbox"></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Cerrar Servicio Técnico" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.serial.focus();
</SCRIPT>
</HTML>