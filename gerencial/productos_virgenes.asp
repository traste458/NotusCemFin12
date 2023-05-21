<% session("titulo") = "Productos Virgenes" %>
<html>
<body>
<body bgcolor="#FFFFFF" text="#000000">
<!--#include file="../include/titulo1.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<%
  sql="select * from subproductos "
  Set rs=conn.execute(sql) 
  if rs.eof then 
    %>
       No hay Ordenes
    <%
   Else
%>
  <table border=1 align=center>
    <tr bgcolor=#FF9900> 
      <td align=center> <font face="Arial, Helvetica, sans-serif" size="2">Código</font></td>
      <td align=center> <font face="Arial, Helvetica, sans-serif" size="2">Producto</font></td>
      <td align=center> <font face="Arical, Helvetica, sans-serif" size="2">Tipo orden</font></td>
      <td align=center> <font face="Arial, Helvetica, sans-serif" size="2">Region</font></td>
      <td align=center bgcolor="#FF9900"> <font face="Arial, Helvetica, sans-serif" size="2">Asig.Mines<br>
        Automátic.</font> </td>
      <td align=center><font face="Arial, Helvetica, sans-serif" size="2">Impresión<br>Labels</font></td>
      <td align=center><font face="Arial, Helvetica, sans-serif" size="2">Cant.<br>Empaque</font></td>
      <td align=center><font face="Arial, Helvetica, sans-serif" size="2">estado</font></td>
    </tr>
    <%
while not rs.eof
      estado="Anulado"
      if CInt(rs("estado"))= 1 then 
         estado = "Activo"
      end if
      if CInt(rs("estado"))= 2 then
         estado = "Pausado"
      end if 
      asig_mines = "Si"
      if CInt(rs("asig_mines"))= 2 then
          asig_mines = "No"
      end if
      label = "Ninguno"
      if CInt(rs("label")) = 1 then
          label = "ESN"
      end if
     if CInt(rs("label")) = 2 then
          label = "ESN-MIN"
      end if
    %>
    <tr> 
      <td><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("idsubproducto2")%></font></td>
      <td><a href=../adm_operativo/subproductos_actualizar.asp?idsubproducto=<%=rs("idsubproducto")%>><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("subproducto")%></font></a></td>
      <td><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("tipoorden")%></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("region")%></font></td>
       <td><font face="Arial, Helvetica, sans-serif" size="2"><%=asig_mines%></font></td>
       <td><font face="Arial, Helvetica, sans-serif" size="2"><%=label%></font></td>
       <td align=right><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("cantidad_empaque")%></font></td>
      <td><font face="Arial, Helvetica, sans-serif" size="2"><%=estado%></font></td>
    </tr>
    <%rs.movenext
wend %>
</table>
<%
End if
%>
</form>
</body>
</html>
