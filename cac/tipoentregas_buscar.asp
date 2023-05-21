<!--#include file="../include/seguridad.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
        }
</script>
</HEAD>
<BODY class="cuerpo2">
<% session("titulo") = "<b>Buscar Tipos de Entrega </b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="tipoentregas_buscar2.asp" onsubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nombre Tipo de Entrega: **</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="tipoentrega" SIZE="40" MAXLENGTH="80" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Estado:</B></TD>
    <TD>
      <SELECT NAME="estado">
        <OPTION VALUE="0">Elija una Estado</OPTION>
        <OPTION VALUE="1">Activo</OPTION>
        <OPTION VALUE="2">Inactivo</OPTION>
      </SELECT>
    </TD>   
  </TR>
</TABLE>
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
   document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>