<!--#include file="../include/seguridad.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
{
    if (document.forma.serial.value == "")
        {
        alert ("Digite o Dispare el serial, Por Favor");
        document.forma.serial.focus();
        return (false);
        }
   if((document.forma.serial.value.length != 15) && (document.forma.serial.value.length != 11) && (document.forma.serial.value.length != 17) )
        {
            alert("La longitud del IMEI es de  "+document.forma.serial.value.length+", no es aceptada. Tiene que ser de 17, 15 ú 11");
            document.forma.serial.focus();
            return(false);
        }
        
   if (isNaN(document.forma.serial.value) == true)
   {
     alert('por favor verifique el serial digitado. Solo se permiten numeros en el serial');
     document.forma.serial.focus();
     return false;
   }

}
</script>
</HEAD>
<BODY class="cuerpo2">
<%
session("titulo") = "<b>Cambio de Material</b>"
%>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
idsubproducto = request.form("idsubproducto")

%>
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="cambio_material3.asp" onsubmit="return validacion();">
<TABLE class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Dispare o Digite el serial</B></TD>
    <TD>
      <input type="text" name="serial" class="textbox" size="20" maxlength="17">
    </TD>
  </TR>  
</TABLE>
<input type="hidden" name="idsubproducto" value="<%=idsubproducto%>">
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Buscar Ahora" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.serial.focus();
</SCRIPT>
</HTML>