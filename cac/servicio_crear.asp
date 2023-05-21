<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->

<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.fecha_ingreso.value == "")
        {
        alert ("Elija la fecha de ingreso del Telefono, Por Favor");
        document.forma.fecha_ingreso.focus();
        return (false);
        }
    if (document.forma.razon.value == "")
        {
        alert ("Digite la razon del servicio, Por Favor");
        document.forma.razon.focus();
        return (false);
        }
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
<!--#include file="../include/obtenerIdentificadorCAC.inc.asp" -->
<A HREF="javascript: history.back();"><u>Regresar</u></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="servicio_buscar.asp"><u>Buscar Servicio Técnico</u></A>
<%
bandera = request.querystring("bandera")
if bandera = 1 then
  %>
  <CENTER><FONT COLOR="RED" SIZE="4" face=arial><b>ERROR:</b> El serial ya se encuentra en servicio técnico.</FONT></CENTER>
<%  
end if
if bandera = 2 then
   serial = request.querystring("serial")
  %>
  <br><br>
  <CENTER><FONT COLOR="blue" SIZE="4" face=arial><b>Serial <%=serial%> registrado en Servicio Técnico</FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="servicio_crear2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD bgcolor="F0F0F0"><b>Fecha de Ingreso</b></TD>
    <TD>
          <input name="fecha_ingreso" value="" size="11" class="textbox"><a href="javascript:void(0)" onclick="if(self.gfPop)gfPop.fPopCalendar(document.forma.fecha_ingreso);return false;" HIDEFOCUS><img class="PopcalTrigger" align="absmiddle" src="../include/HelloWorld/calbtn.gif" width="34" height="22" border="0" alt="Seleccione una Fecha">
    </TD>
  </TR>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Razón del Servicio:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="razon" SIZE="25" MAXLENGTH="150" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Digite o Dispare el serial:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="serial" SIZE="25" MAXLENGTH="20" class="textbox"></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Servicio Técnico" class="boton">
</UL>
<!-- iframe para uso de selector de fechas -->
<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="../include/HelloWorld/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
//   document.forma.idcac2.focus();
</SCRIPT>
</HTML>