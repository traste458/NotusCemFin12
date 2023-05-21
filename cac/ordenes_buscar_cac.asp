<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->

<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    }
function cambiar_filtro() {
        var name1 = document.forma.idproducto.selectedIndex ;
        var valor1 = document.forma.idproducto.options[name1].value ;
        window.location.href= "ordenes_buscar_cac.asp?idproducto="+valor1;
}
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF" class="cuerpo2">
<% session("titulo") = "<b>Buscar Ordenes de Lectura para CAC</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/obtenerIdentificadorCAC.inc.asp"-->
<A HREF="../frames_back.asp?idmenu=<%=session("idmenu")%>&posicion=<%=Session("posicion")%>"><u>Regresar</u></A>
<%
idproducto = Request.querystring("idproducto")
if idproducto <> "" then
   sqlProducto = "select producto from productos where idproducto = " & idproducto
   set rsProducto = conn.execute(sqlProducto)
   producto = rsProducto("producto")
end if

bandera = request.querystring("bandera")
if bandera = 4 then
  idorden2 = request.querystring("idorden2")
  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4" face=arial><b>La orden para <%=idorden2%> a sido creada</b></FONT></CENTER>
<%  
end if
%>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="ordenes_buscar_cac2.asp" onSubmit="return validacion();">
<UL>
<FONT COLOR="GRAY"><I>Busque por uno o varios de los siguientes criterios</I></FONT>
</UL>
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Producto:</B></TD>
    <TD>
      <select name="idproducto" onchange="cambiar_filtro();">
      <option value="0">Elija un Producto</option>
      <%
      
        sqlP = "select idproducto, producto from productos where estado = 1 order by producto"
        set rsP = conn.execute(sqlP)
        while not rsP.eof
				
				if cint(idproducto) = cint(rsP("idproducto")) then
      %>
          <option selected value="<%=trim(rsP("idproducto"))%>"><%=trim(rsP("producto"))%></option>
        <%
       else
      %>
          <option value="<%=trim(rsP("idproducto"))%>"><%=trim(rsP("producto"))%></option>
        <%
      end if
          %>

          <%
          rsP.movenext
        wend
        %>
      </select>
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Subproducto:</B></TD>
    <TD>
      <select name="idsubproducto">
        <option value="0">Elija un subproducto</option>
        <%
        if idproducto <> "" then
           sqlS = "select idsubproducto, idsubproducto2, subproducto from subproductos where estado = 1 and idproducto = "
           sqlS = sqlS & idproducto & " and tipoORden = 'CAC' order by subproducto"
           set rsS = conn.execute(sqlS)
           while not rsS.eof
             %>
             <option value="<%=trim(rsS("idsubproducto"))%>"><%=trim(rsS("subproducto"))%>(<%=trim(rsS("idsubproducto2"))%>)</option>
             <%
             rsS.movenext
           wend
        end if
        %>
      </select>
    </TD>
  </TR>  
</TABLE>
<BR><BR>
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
  // document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>