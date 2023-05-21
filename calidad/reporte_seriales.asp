<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.idpos.value == "0")
        {
        alert ("Elija un punto de venta, Por Favor");
        document.forma.idpos.focus();
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
<% session("titulo") = "<b>Reporte de Seriales para PDV</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="reporte_seriales2.asp" onSubmit="return validacion();">
<TABLE BORDER="0" class="tabla">
  <TR>
    <TD BGCOLOR="#F0F0F0"><B>Punto de Venta:</B></TD>
    <TD>
      <select name="idpos">
        <option value="0">Elija un Pdv</option>
        <%
        sqlCac = "select idpos, pos from pos where idestado = 1 order by pos"
        set rsCac = conn.execute(sqlCac)
        while not rsCac.eof
          %>
          <option value="<%=trim(rsCac("idpos"))%>"><%=trim(rsCac("pos"))%></option>
          <%
          rsCac.movenext
        wend
        %>
      </select>
    </TD>
  </TR>  
</TABLE>
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