<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.autorizador.value == "")
        {
        alert ("Escriba el nombre del Autorizador, Por Favor");
        document.forma.autorizador.focus();
        return (false);
        }
    if (document.forma.cedula.value == "")
        {
        alert ("Escriba el número de cedula del Autorizador, Por Favor");
        document.forma.cedula.focus();
        return (false);
        }
    if (isNaN(document.forma.cedula.value))
       {
        alert ("Por favor, escriba unicamente valores numericos en la cedula del autorizador, Por Favor");
        document.forma.cedula.focus();
        return (false);
       }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Autorizadores</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<%
bandera = request.querystring("bandera")
if bandera = 3 then
  cedula = request.querystring("cedula")
  %>
  <CENTER><FONT COLOR="RED" SIZE="4" face=arial><b>ERROR:</b> Numero de Cedula <%=cedula%> existente.</FONT></CENTER>
<%  
end if
if bandera = 4 then
  cedula = request.querystring("cedula")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>Autorizador con Número de Cédula No. <%=cedula%> REGISTRADO</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="autorizadores_crear2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Autorizador:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="autorizador" SIZE="40" MAXLENGTH="100" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Numero de Cédula:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="cedula" SIZE="25" MAXLENGTH="12" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Estado:</B></TD>
    <TD>
      <SELECT NAME="estado">
        <OPTION VALUE="1">Activo</OPTION>
        <OPTION VALUE="2">Inactivo</OPTION>
      </SELECT>
    </TD>   
  </TR>
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Autorizador" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.autorizador.focus();
</SCRIPT>
</HTML>