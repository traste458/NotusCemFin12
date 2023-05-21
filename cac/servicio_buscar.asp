<!--#include file="../include/seguridad.inc.asp"-->

<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    //no hay validaciones
    }
</script>
</HEAD>
<BODY class="cuerpo2">
<%
session("titulo") = "<b>Buscar Servicio Técnico</b>"
Select case cdbl(month(now))
  case 1:
    mes="Enero"
  case 2:
    mes="Febrero"
  case 3:
    mes="Marzo"
  case 4:
    mes="Abril"
  case 5:
    mes="Mayo"
  case 6:
    mes="Junio"
  case 7:
    mes="Julio"
  case 8:
    mes="Agosto"
  case 9:
    mes="Septiembre"
  case 10:
    mes="Octubre"
  case 11:
    mes="Noviembre"
  case 12:
    mes="Diciembre"
end select

%>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/obtenerIdentificadorCAC.inc.asp" -->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="servicio_buscar2.asp" onsubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Estado:</B></TD>
    <TD>
      <SELECT NAME="estado">
        <OPTION VALUE="">Elija un Estado</OPTION>
        <OPTION VALUE="0">Recibido</OPTION>
        <OPTION VALUE="1">Entregado a Servicio Técnico</OPTION>
        <OPTION VALUE="2">Por confirmación de Comcel</OPTION>
        <OPTION VALUE="3">Cerrado</OPTION>
      </SELECT>
    </TD>   
  </TR>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td BGCOLOR="#F0F0F0"><b>Desde :</b></td>
    <td>
      <input type="text" name="dia1" maxlength="2" size="2" value="1" class="textbox">
      <select name=mes1>
    <option value="<%=month(date)%>"><%=mes%></option>
    <option value=1>Enero</option>
    <option value=2>Febrero</option>
        <option value=3>Marzo</option>
    <option value=4>Abril</option>
    <option value=5>Mayo</option>
    <option value=6>Junio</option>
    <option value=7>Julio</option>
    <option value=8>Agosto</option>
    <option value=9>Septiembre</option>
    <option value=10>Octubre</option>
    <option value=11>Noviembre</option>
    <option value=12>Diciembre</option>
      </select>
      <input type="text" name="ano1" maxlength="4" size="4" value="<%=year(date)%>" class="textbox">
    </td>
  <tr>
    <td BGCOLOR="#F0F0F0"><b>Hasta :</b></td>
    <td>
      <input type="text" name="dia2" maxlength="2" size="2" value="<%=day(date)%>" class="textbox">
      <select name=mes2>
    <option value="<%=month(date)%>"><%=mes%></option>
    <option value=1>Enero</option>
    <option value=2>Febrero</option>
        <option value=3>Marzo</option>
    <option value=4>Abril</option>
    <option value=5>Mayo</option>
    <option value=6>Junio</option>
    <option value=7>Julio</option>
    <option value=8>Agosto</option>
    <option value=9>Septiembre</option>
    <option value=10>Octubre</option>
    <option value=11>Noviembre</option>
    <option value=12>Diciembre</option>
      </select>
      <input type="text" name="ano2" maxlength="4" size="4" value="<%=year(date)%>" class="textbox">
    </td>
  </tr>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Opcion de Fecha:</B></TD>
    <TD>
      <SELECT NAME="fecha">
        <OPTION VALUE="">Elija una Opción de Fecha</OPTION>
        <OPTION VALUE="0">Fecha de Ingreso</OPTION>
        <OPTION VALUE="1">Fecha de Entrega a Servicio Técnico</OPTION>
        <OPTION VALUE="2">Fecha de Devolución de Servicio Técnico</OPTION>
        <OPTION VALUE="3">Cerrado</OPTION>
      </SELECT>
    </TD>   
  </TR>

</TABLE>
<br>
<table class="tabla">
  <tr>
    <td bgcolor="#F0F0F0"><b>Serial : *</b></td>
    <td>
      <input type="text" name="serial" maxlength="20" size="20" class="textbox"><font color="336699"><i>Dispare o Digite el serial aquí</i></font>
    </td>
  </tr>

</table>
<br>
<table class="tabla">
</table>


<FONT SIZE=2>
* Se omitirán los demas criterios de Busqueda.<BR>
** Con una parte basta.
</FONT>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Buscar Ahora" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
  // document.forma.cliente2.focus();
</SCRIPT>
</HTML>