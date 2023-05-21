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
<% session("titulo") = "<b>Buscar CAC </b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="cac_buscar2.asp" onsubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Código: *</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="idcac2" SIZE="15" MAXLENGTH="10" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nombre CAC: **</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="cac" SIZE="40" MAXLENGTH="50" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Ciudad:</B></TD>
    <TD>
      <SELECT NAME="idciudad">
        <OPTION VALUE=0>Elija una Ciudad</OPTION>
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
    <TD BGCOLOR="#F0F0F0"><B>Auxiliar:</B></TD>
    <TD>
      <SELECT NAME="idauxiliar">
        <OPTION VALUE=0>Elija un Auxiliar</OPTION>
<%
        sql = "select idtercero, tercero from terceros where idperfil = 88"
        set rs = conn.execute(sql)
        while not rs.eof
          idauxiliar =rs("idtercero")
          auxiliar = rs("tercero") %>
          <OPTION VALUE=<%=idauxiliar%>><%=auxiliar%></OPTION>
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
        <OPTION  value=0>Elija una Región</OPTION>
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
    <TD BGCOLOR="#F0F0F0"><b>Estado:</b></TD>
    <TD>
      <SELECT NAME="ddlEstado">
        <OPTION  value=-1>Elija una Estado</OPTION>
        <OPTION  value=1>Activo</OPTION>
        <OPTION  value=0>Inactivo</OPTION>       
      </SELECT></TD>   
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
   document.forma.idcac2.focus();
</SCRIPT>
</HTML>