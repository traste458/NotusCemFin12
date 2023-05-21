<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.idproducto.value == "")
        {
        alert ("Elija el producto al que pertenece del Telefono, Por Favor");
        document.forma.idproducto.focus();
        return (false);
        }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<%
session("titulo") = "<b>Ingreso de Servicio Técnico</b>"
serial = trim(Request.querystring("serial"))
fecha_ingreso = trim(request.QueryString("fecha_ingreso"))
razon = trim(request.querystring("razon"))
%>
<!--#include file="../include/titulo1.inc.asp"-->
<A HREF="servicio_crear.asp"><u>Regresar</u></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="servicio_buscar.asp"><u>Buscar Servicio Técnico</u></A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="servicio_crear4.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD bgcolor="F0F0F0"><b>Serial</b></TD>
    <TD><%=serial%></TD>
  </TR>
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Elija el Producto al que pertenece:</B></TD>
    <TD>
      <select name="idproducto">
        <option value="">Elija un Producto</option>
        <%
        sqlProducto = "select idproducto, producto from productos where estado = 1 order by producto"
        set rsProducto = conn.execute(sqlProducto)
        while not rsProducto.eof
          %>
          <option value="<%=rsProducto("idproducto")%>"><%=trim(rsProducto("producto"))%></option>
          <%
          rsProducto.movenext
        wend
        %>
      </select>
    </TD>
  </TR>  
</TABLE>
<input type="hidden" name="serial" value="<%=serial%>">
<input type="hidden" name="fecha_ingreso" value="<%=trim(fecha_ingreso)%>">
<input type="hidden" name="razon" value="<%=trim(razon)%>">
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Servicio Técnico" class="boton">
</UL>
<!-- iframe para uso de selector de fechas -->
<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="../include/HelloWorld/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
</iframe>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
//   document.forma.idcac2.focus();
</SCRIPT>
</HTML>