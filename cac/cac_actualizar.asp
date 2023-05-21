<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
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
    if (document.forma.ddlEstado.value == -1) { 
      alert ("Escoja un Estado, Por Favor");
        document.forma.idciudad.focus();
        return (false);
         }
    }
</SCRIPT>
</HEAD>
<BODY class="cuerpo2">
<% session("titulo") = "<b>Actualizar - CAC</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript:history.back();"><u>Regresar</u></A>
<%
idcac = request.querystring ("idcac")
if idcac = "" then %>
  <center><font color=red class="fuente" size=4><b>Error:</b> CAC vacio.</font></center>
  <%
  conn.close
  response.end
end if
sqlCac = "select idcac, idcac2, cac, idciudad, "
sqlCac = sqlCac & " (select ciudad from ciudades where idciudad = a.idciudad) as ciudad, "
sqlCac = sqlCac & " direccion, telefono, "
sqlCac = sqlCac & " (select tercero from terceros where idtercero = a.idauxiliar) as auxiliar, "
sqlCac = sqlCac & " idauxiliar, region, centro,idEstado "
sqlCac = sqlCac & " from cac a "
sqlCac = sqlCac & " where idcac = " & idcac
'response.write   sql
'response.end
 set rs = conn.execute(sqlCac)
if rs.eof then  %>
  <center><font color=red face=arial size=4><b>Error:</b> No se encontro CAC.</font></center>
  <%
  conn.close
  response.end
end if
idcac2 = trim(rs("idcac2"))
cac = trim(rs("cac"))
idciudad = rs("idciudad")
direccion = trim(rs("direccion"))
telefono = trim(rs("telefono"))
ciudad = trim(rs("ciudad"))
idauxiliar = trim(rs("idauxiliar"))
if isnull(idauxiliar) then
   idauxiliar = "NULL"
end if
auxiliar = trim(rs("auxiliar"))
region = trim(rs("region"))
centro = trim(rs("centro"))
 idEstado= cbool(rs("idEstado"))
bandera = request.querystring("bandera")
if bandera = 2 then
        idcac2_aux = request.querystring("idcac2")

  %>
  <CENTER><FONT COLOR="RED" SIZE="4" face=arial><b>ERROR:</b> CAC No. <%=idcac2_aux%> existente.</FONT></CENTER>
<%  
end if
if bandera = 3 then
  idcac2_aux = request.querystring("idcac2")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>CAC No. <%=idcac2_aux%> Actualizado.</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="cac_actualizar2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Código:</B></TD>
    <TD><input type="hidden" name="idcac2" value="<%=idcac2%>">
    <INPUT TYPE="TEXT" NAME="idcac2m" SIZE="15" MAXLENGTH="10" value="<%=idcac2%>" disabled class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Nombre CAC:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="cac" SIZE="60" MAXLENGTH="57" value="<%=cac%>" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Ciudad:</B></TD>
    <TD>
      <SELECT NAME="idciudad">
        <OPTION  value="<%=idciudad%>"><%=ciudad%></OPTION>
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
    <TD><INPUT TYPE="TEXT" NAME="direccion" SIZE="30" MAXLENGTH="87" value="<%=direccion%>" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Teléfono:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="telefono" SIZE="30" MAXLENGTH="40" value="<%=telefono%>" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Auxiliar:</B></TD>
    <TD>
      <SELECT NAME="idauxiliar">
        <OPTION  value="<%=idauxiliar%>"><%=auxiliar%></OPTION>
<%
        sql = "select idtercero, tercero from terceros where idperfil = 88"
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
        <OPTION  value="<%=region%>"><%=region%></OPTION>
<%
        sql = "select idtipo2, tipo from tipos where concepto like 'regiones'"
        set rs = conn.execute(sql)
        while not rs.eof
          %>
          <OPTION VALUE="<%=rs("idtipo2")%>"><%=trim(rs("tipo"))& " (" & trim(rs("idtipo2")) & ")"%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Centro:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="centro" SIZE="30" MAXLENGTH="4" value="<%=centro%>" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><b>Estado</b></TD>
    <TD>
      <SELECT NAME="ddlEstado" >
      <%
            if idEstado then
                selAct = "selected='selected'"
            else
                selDesAct = "selected='selected'"
            end if
       %>      
        <OPTION  value="-1">Elija una Estado</OPTION>
        <OPTION  value="1" <%= selAct %> >Activo</OPTION>
        <OPTION  value="0" <%= selDesAct %>>Inactivo</OPTION>              
      </SELECT></TD>
        </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Actualizar CAC" class="boton">
</UL>
<input type=hidden name="idcac" value="<%=idcac%>">
</FORM>
<hr>
<%
conn.close
%>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.cac.focus();
</SCRIPT>
</HTML>