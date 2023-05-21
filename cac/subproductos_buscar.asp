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
<% session("titulo") = "<b>Buscar Subproductos (Materiales) </b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="subproductos_buscar2.asp" onsubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Producto:</B></TD>
    <TD>
      <select name="idproducto">
        <option value="0">Elija un Producto</option>
        <%
        sqlP = "select idproducto, producto from productos where estado = 1 order by producto"
        set rsP = conn.execute(sqlP)
        while not rsP.eof
          %>
          <option value="<%=trim(rsP("idproducto"))%>"><%=trim(rsP("producto"))%></option>
          <%
          rsP.movenext
        wend
        %>
      </select>
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nombre Subproducto: **</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="subproducto" SIZE="40" MAXLENGTH="45" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Codigo Subproducto o Material: **</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="idsubproducto2" SIZE="20" MAXLENGTH="45" class="textbox"></TD>
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
//   document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>