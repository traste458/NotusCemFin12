<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.tipoentrega.value == "")
        {
        alert ("Escriba el nombre del Tipo de Entrega, Por Favor");
        document.forma.tipoentrega.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY class="cuerpo2">
<% session("titulo") = "<b>Actualizar - Tipos de Entrega</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript:history.back();"><u>Regresar</u></A>
<%
idtipoentrega = request.querystring ("idtipoentrega")
sql = "select idtipoentrega, tipoentrega, estado, "
sql = sql & " convert(varchar,fecha, 105) as fecha  "
sql = sql & " from tipoentregas "
sql = sql & " where idtipoentrega = " & idtipoentrega
'response.write   sql
'response.end
 set rs = conn.execute(sql)
tipoentrega = trim(rs("tipoentrega"))
estado = trim(rs("estado"))
if estado = "1" then
   estadoNombre= "Activo"
end if
if estado = "2" then
   estadoNombre= "Inactivo"
end if

bandera = request.querystring("bandera")
if bandera = 3 then
  tipoentrega_aux = request.querystring("tipoentrega")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>Tipo de Entrega <%=tipoentrega_aux%> Actualizado.</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="tipoentregas_actualizar2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Tipo de Entrega:</B></TD>
    <TD><input type="text" name="tipoentrega" value="<%=tipoentrega%>" size="40" maxlength="80">
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
  <INPUT TYPE="SUBMIT" VALUE="Actualizar Tipo de Entrega" class="boton">
</UL>
<input type=hidden name="idtipoentrega" value="<%=idtipoentrega%>">
</FORM>
<hr>
<%
conn.close
%>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>