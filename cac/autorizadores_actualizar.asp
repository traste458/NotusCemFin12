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
<BODY class="cuerpo2">
<% session("titulo") = "<b>Actualizar - Autorizadores</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript:history.back();"><u>Regresar</u></A>
<%
idautorizador = request.querystring ("idautorizador")
sql = "select idautorizador, autorizador, cedula, "
sql = sql & " convert(varchar,fecha, 105) as fecha, estado "
sql = sql & " from autorizadores "
sql = sql & " where idautorizador = " & idautorizador
'response.write   sql
'response.end
 set rs = conn.execute(sql)
idautorizador = trim(rs("idautorizador"))
autorizador = trim(rs("autorizador"))
cedula = rs("cedula")
estado = trim(rs("estado"))
if estado = "1" then
   estadoNombre= "Activo"
end if
if estado = "2" then
   estadoNombre= "Inactivo"
end if

bandera = request.querystring("bandera")
if bandera = 2 then
  cedula_aux = request.querystring("cedula")
  %>
  <CENTER><FONT COLOR="RED" SIZE="4" face=arial><b>ERROR:</b> Numero de Cédula <%=cedula_aux%> existente.</FONT></CENTER>
<%  
end if
if bandera = 3 then
  cedula_aux = request.querystring("cedula")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>Autorizador con Número de Cédula <%=cedula_aux%> Actualizado.</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="autorizadores_actualizar2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Cédula:</B></TD>
    <TD><input type="text" name="cedula" value="<%=cedula%>" size="20" maxlength="12">
</TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nombre Autorizador:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="autorizador" SIZE="60" MAXLENGTH="80" value="<%=autorizador%>" class="textbox"></TD>
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
  <INPUT TYPE="SUBMIT" VALUE="Actualizar Autorizador" class="boton">
</UL>
<input type=hidden name="idautorizador" value="<%=idautorizador%>">
</FORM>
<hr>
<%
conn.close
%>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.cedula.focus();
</SCRIPT>
</HTML>