<HTML>
<HEAD>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Buscar Terceros</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<A HREF="terceros.asp">Regresar</A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="terceros_buscar2.asp">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE BORDER="1">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Nombres y/o Apellidos:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="tercero" SIZE="40" MAXLENGTH="50">*</TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Identifiaci&oacute;n:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="idtercero2" SIZE="17" MAXLENGTH="15">**</TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Area:</B></TD>   
    <TD>
      <SELECT NAME="idarea">
        <OPTION VALUE=0>Elija un Area</OPTION>
<%
        sql = "select idarea,area from areas order by area"
        set rs = conn.execute(sql)
        while not rs.eof
          idarea=rs("idarea")
          area=rs("area") %>
          <OPTION VALUE=<%=idarea%>><%=area%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Cargo:</B></TD>   
    <TD>
      <SELECT NAME="idcargo">
        <OPTION VALUE=0>Elija un Cargo</OPTION>
<%
        sql = "select idcargo,cargo+case when estado<>1 then ' (INACTIVO)' else '' end as cargo from cargos order by cargo"
        set rs = conn.execute(sql)
        while not rs.eof
          idcargo=rs("idcargo")
          cargo=rs("cargo") %>
          <OPTION VALUE=<%=idcargo%>><%=cargo%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Linea:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="linea" SIZE="3" MAXLENGTH="2"></TD>   
  </TR>  
</TABLE>
<FONT SIZE=2>
* Con una parte basta.<BR>
** Se omitirán los demas criterios de Busqueda.
</FONT>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Buscar Ahora">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.tercero.focus();
</SCRIPT>
</HTML>