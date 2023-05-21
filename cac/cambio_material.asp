<!--#include file="../include/seguridad.inc.asp"-->

<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
{
    if(document.forma.idsubproducto.value == "")
    {
      alert('Por favor, elija un Material Nuevo');
      document.forma.idsubproducto.focus();
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
<!--#include file="../include/obtenerIdentificadorCAC.inc.asp" -->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="cambio_material2.asp" onsubmit="return validacion();">
<TABLE class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nuevo Material</B></TD>
    <TD>
      <select name="idsubproducto">
         <option value="">Elija un Material</option>
         <%
         sqlSubproducto = "select idsubproducto, idsubproducto2, subproducto from subproductos where estado = 1 order by idsubproducto2"
         set rsSubproducto = conn.execute(sqlSubproducto)
         while not rsSubproducto.eof
           %>
           <option value="<%=rsSubproducto("idsubproducto")%>"><%=trim(rsSubproducto("idsubproducto2")) & "-" & trim(rsSubproducto("subproducto"))%></option>
           <%
           rsSubproducto.movenext
         wend
         %>
      </select>
    </TD>
  </TR>  
</TABLE>

<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Buscar Ahora" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   //document.forma.cliente2.focus();
</SCRIPT>
</HTML>