<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.subproducto.value == "")
        {
        alert ("Escriba el nombre del Subproducto, Por Favor");
        document.forma.subproducto.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY class="cuerpo2">
<% session("titulo") = "<b>Actualizar - Subproductos</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript:history.back();"><u>Regresar</u></A>
<%
idsubproducto = request.querystring ("idsubproducto")

sql = "select idsubproducto, idsubproducto2, subproducto, estado "
sql = sql & " from subproductos "
sql = sql & " where idsubproducto = " & idsubproducto
'response.write   sql
'response.end
set rs = conn.execute(sql)
idsubproducto2 = trim(rs("idsubproducto2"))
subproducto = trim(rs("subproducto"))
estado = trim(rs("estado"))
if estado = "1" then
   estadoNombre= "Activo"
end if
if estado = "2" then
   estadoNombre= "Inactivo"
end if

bandera = request.querystring("bandera")
if bandera = 3 then
  subproductoA = request.querystring("subproducto")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>Subproducto <%=subproductoA%> Actualizado.</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="subproductos_actualizar2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Codigo Subproductoo o Material:</B></TD>
    <TD><%=idsubproducto2%></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Subproducto:</B></TD>
    <TD><input type="text" name="subproducto" value="<%=subproducto%>" size="40" maxlength="45" class="textbox">
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Estado:</B></TD>
    <TD>
      <SELECT NAME="estado">
        <OPTION  value="<%=estado%>"><%=estadoNombre%></OPTION>
        <OPTION  value="1">Activo</OPTION>
        <OPTION  value="2">Inactivo</OPTION>
      </SELECT>
    </TD>   
  </TR>
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Actualizar Subproducto" class="boton">
</UL>
<input type=hidden name="idsubproducto" value="<%=idsubproducto%>">
</FORM>
<hr>
<%
conn.close
%>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.subproducto.focus();
</SCRIPT>
</HTML>