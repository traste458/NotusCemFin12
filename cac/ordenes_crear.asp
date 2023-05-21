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
        alert ("Elija el producto , Por Favor");
        document.forma.idproducto.focus();
        return (false);
        }
    if (document.forma.idsubproducto.value == "0")
        {
        alert ("Elija el Subproducto , Por Favor");
        document.forma.idsubproducto.focus();
        return (false);
        }
    if (document.forma.idcac.value == "0")
        {
        alert ("Elija el Cac , Por Favor");
        document.forma.idcac.focus();
        return (false);
        }
    if (document.forma.cantidad.value == "")
        {
        alert ("Digite la cantidad de seriales que se van a leer, Por Favor");
        document.forma.cantidad.focus();
        return (false);
        }
    }
function cambiar_filtro() {
        var name1 = document.forma.idproducto.selectedIndex ;
        var valor1 = document.forma.idproducto.options[name1].value ;
        window.location.href= "ordenes_crear.asp?idproducto="+valor1;
}
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Ordenes de Lectura para CAC</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="javascript: history.back();"><u>Regresar</u></A>
<%
idproducto = Request.querystring("idproducto")
if idproducto <> "" and idProducto <> "0" then
   sqlProducto = "select producto from productos where idproducto = " & idproducto
   set rsProducto = conn.execute(sqlProducto)
   if not rsProducto.eof then
        producto = rsProducto("producto")
   end if
   rsProducto.close
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
<FORM NAME="forma" METHOD="POST" ACTION="ordenes_crear2.asp" onSubmit="return validacion();">
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
        if idproducto <> "" and idproducto <>"0" then
           sqlS = "select idsubproducto, idsubproducto2, subproducto from subproductos where estado = 1 and idproducto = "
           sqlS = sqlS & idproducto & " order by subproducto"
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
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Cac:</B></TD>
    <TD>
      <select name="idcac">
        <option value="0">Elija un Cac</option>
        <%
        sqlCac = "select idcac, cac from cac order by cac"
        set rsCac = conn.execute(sqlCac)
        while not rsCac.eof
          %>
          <option value="<%=trim(rsCac("idcac"))%>"><%=trim(rsCac("cac"))%></option>
          <%
          rsCac.movenext
        wend
        %>
      </select>
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Cantidad:</B></TD>
    <TD><input type="text" name="cantidad"  size="20" maxlength="4" class="textbox" >
    </TD>
  </TR>  
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Orden" class="boton">
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
  // document.forma.tipoentrega.focus();
</SCRIPT>
</HTML>