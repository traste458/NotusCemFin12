<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.idcac2.value == "")
        {
        alert ("Escriba el Código del CAC, Por Favor");
        document.forma.idcac2.focus();
        return (false);
        }
    if (document.forma.cac.value == "")
        {
        alert ("Escriba el Nombre del CAC, Por Favor");
        document.forma.cac.focus();
        return (false);
        }
    if (document.forma.idciudad.value == 0) 
        {
        alert ("Escoja una Ciudad, Por Favor");
        document.forma.idciudad.focus();
        return (false);
       }
    if (document.forma.idauxiliar.value == 0)
        {
        alert ("Escoja una Auxiliar, Por Favor");
        document.forma.idauxiliar.focus();
        return (false);
       }
    if (document.forma.region.value == 0)
        {
        alert ("Elija una región, Por Favor");
        document.forma.region.focus();
        return (false);
       }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear CAC</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<%
bandera = request.querystring("bandera")
if bandera = 3 then
  idcac2 = request.querystring("idcac2")
  %>
  <CENTER><FONT COLOR="RED" SIZE="4" face=arial><b>ERROR:</b> CAC No. <%=idcac2%> existente.</FONT></CENTER>
<%  
end if
if bandera = 4 then
  idcac2 = request.querystring("idcac2")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>CAC No. <%=idcac2%> REGISTRADO</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="cac_crear2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Código:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="idcac2" SIZE="15" MAXLENGTH="10" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nombre CAC:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="cac" SIZE="25" MAXLENGTH="57" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Ciudad:</B></TD>
    <TD>
      <SELECT NAME="idciudad">
        <OPTION VALUE="0">Elija una Ciudad</OPTION>
<%
        sql = "select idciudad,ciudad,departamento from ciudades order by prioridad desc,ciudad"
        set rs = conn.execute(sql)
        while not rs.eof
          idciudad=rs("idciudad")
          ciudad=rs("ciudad") %>
          <OPTION VALUE=<%=idciudad%>><%=ciudad%> (<%=rs("departamento")%>)</OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Dirección:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="direccion" SIZE="30" MAXLENGTH="87" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Teléfono de CAC:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="telefono" SIZE="30" MAXLENGTH="40" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Auxiliar:</B></TD>
    <TD>
      <SELECT NAME="idauxiliar">
        <OPTION  value="0">Elija un Auxiliar</OPTION>
<%
        sql = "select idtercero, tercero from terceros where idcargo = 88"
        set rs = conn.execute(sql)
        while not rs.eof
          %>
          <OPTION VALUE="<%=rs("idtercero")%>"><%=trim(rs("tercero"))%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Región:</B></TD>
    <TD>
      <SELECT NAME="region">
        <OPTION  value="0">Elija una Región</OPTION>
<%
        sql = "select idtipo2, tipo from tipos where concepto like 'regiones'"
        set rs = conn.execute(sql)
        while not rs.eof
          %>
          <OPTION VALUE="<%=trim(rs("idtipo2"))%>"><%=trim(rs("tipo"))&" ("&trim(rs("idtipo2"))&")"%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Centro:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="centro" SIZE="15" MAXLENGTH="4" class="textbox"></TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear CAC" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.idcac2.focus();
</SCRIPT>
</HTML>