<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.idproducto.value == "0")
        {
        alert ("Elija el Producto, Por Favor");
        document.forma.idproducto.focus();
        return (false);
        }
    if (document.forma.subproducto.value == "")
        {
        alert ("Digite el Nombre del Subproducto o Material, Por Favor");
        document.forma.subproducto.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Subproductos (Materiales)</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<%
bandera = request.querystring("bandera")
if bandera = 4 then
  subproducto = request.querystring("subproducto")
  idsubproducto2 = request.querystring("idsubproducto2")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>Subproducto (Material) <%=subproducto & " - " & idsubproducto2%> REGISTRADO</b></FONT></CENTER>
<%
elseif bandera=5 then%>
    <center><font color="red" size="4"><b>Se produjo un error durante la creación del subproducto en la base de datos. Por favor intente nuevamente.</b></font> </center>
<%
elseif bandera=6 then%>
    <center><font color="red" size="4"><b>Se produjo un error durante la creación del subproducto en la base de datos. Por favor intente nuevamente.</b></font> </center>
<%
elseif bandera=7 then%>
    <center><font color="red" size="4"><b>El subproducto que está intentando crear ya se encuentra registrado en la base de datos.</b></font> </center>      
 <%
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="subproductos_crear2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
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
    <TD BGCOLOR="#F0F0F0"><B>Nombre del Subproducto o Material:</B></TD>
    <TD><input type="text" name="subproducto" size="25" maxlength="45" class="textbox"></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Subproducto" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   //document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>