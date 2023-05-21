<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.menu.value == "")
        {
        alert ("Escriba el Nombre del menu, Por Favor");
        document.forma.menu.focus();
        return (false);
        }
    if (document.forma.idmenupadre.value != "0")
        {
        if (document.forma.posicion.value == "")
           {
           alert ("Escriba la posición del menu, Por Favor");
           document.forma.posicion.focus();
           return (false);
           }
        }

    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Menus - Modulo de Administración </b>"
Response.write session("titulo")
%>
<hr>
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=session("posicion")%>"><b>Regresar</b></A>
<%
estado = request.querystring("estado")
if estado = 1 then  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face="verdana">Menu Creado</FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <CENTER><FONT COLOR="RED" SIZE="3" face="verdana"><b>Ya existe un menu con ese nombre. Menu No Creado</b></FONT></CENTER>
<%  
end if

%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="menus_crear2.asp" onSubmit="return validacion()">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Nombre del Menu:</B></TD>
    <TD><input type="text" NAME="menu" maxlength="100" size="50" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Url del Menu:</B></TD>
    <TD><input type="text" NAME="url" maxlength="100" size="60" class="textbox"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Menu Padre:</B></TD>
    <TD>
        <select name="idmenupadre">
            <option value="0">Elija un Menu</option>
            <%
            sql = "select idmenu, menu from menus where idmenupadre is null order by menu"
            set rs = conn.execute(sql)
            while not rs.eof
            %>
            <option value="<%=rs("idmenu")%>"><%=trim(rs("menu"))%></option>
            <%
            rs.movenext
            wend
            %>
        </select>
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Posición del Menu:</B></TD>
    <TD><input type="text" NAME="posicion" maxlength="20" size="20" class="textbox"></TD>
  </TR>  

</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Menu" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.menu.focus();
</SCRIPT>
</HTML>