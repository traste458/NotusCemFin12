<%@ LANGUAGE="VBScript" %>
<% Response.Buffer=True %>
<% Response.expires = 0 %>
<html>
<!--#include file="../include/conexion.inc.asp"-->
      <!-- cuerpo de la página -->
      <%
  mapa="../images/mapa.gif"
  ciudad="Colombia"
  condicion=""
  if request.querystring("idciudad") <> "" then
    idciudad=request.querystring("idciudad")
	if idciudad=150 then
	  mapa="images/bogota.gif"
	elseif idciudad =1 then
	  mapa="images/medellin.gif"  
	elseif idciudad =127 then
	  mapa="../images/barranquilla.gif"  	  
	end if  
    condicion = " and iddestino="&idciudad
    sql="select ciudad as ciudad"
      sql=sql+" from ciudades where idciudad="&idciudad
    set rs=conn.execute(sql)
        'ciudad = rs("ciudad")
   end if

   sql="select subproducto, sum(cantidad) as cantidad from vi_ordenesdetalle "    
     sql=sql & " where datepart(mm,fecha)=datepart(mm,getdate())"
     sql=sql & " group by subproducto order by subproducto"
'    response.write sql
       set rs2=conn.execute(sql)
       vetiq = ""
       vval = ""
       vmax = 0
       i = 0
       vmax = -99999999
       while not rs2.eof 
         i = i+1
         if cdbl(rs2("cantidad")) > vmax then
            vmax = cdbl(rs2("cantidad"))
         end if
         if rs2("subproducto") <> "" then 
           vetiq = vetiq & " ," & mid(rs2("subproducto"),1,5)          
           vval = vval & " ," & rs2("cantidad")   
         end if
          rs2.movenext 
       wend
       vetiq = mid(vetiq,2)
       vval = mid(vval,2)
       vtitulo = "Estad. Productos Mes Actual"
       tipografica = "BarChartApplet"
       'tipografica = "PieChartApplet"
       ancho="350"
       alto="150"
      %>		
<table align=center width="100%">
  <tr> 
    <td>
      <!--#include file="../barras2.asp" -->
    </td>
    <td>

      <img src="<%=mapa%>" width="140" height="180" usemap="#Map" border="0"> 
    </td>
  </tr>
</table>

<% if idciudad = "" then %>
<map name="Map"> 
  <area shape="rect" coords="123,111,213,134" href="est1.asp?idciudad=150" alt="Bogot&aacute;" title="Bogot&aacute;">
  <area shape="rect" coords="39,128,100,147" href="est1.asp?idciudad=944" alt="Cali" title="Cali">
  <area shape="rect" coords="105,29,222,52" href="est1.asp?idciudad=127" alt="Barranquilla" title="Barranquilla">
  <area shape="rect" coords="55,98,114,121" href="est1.asp?idciudad=316" alt="manizales" title="manizales">
  <area shape="rect" coords="76,64,184,85" href="est1.asp?idciudad=1" alt="Medell&iacute;n" title="Medell&iacute;n">
  <area shape="rect" coords="108,139,163,163" href="est1.asp?idciudad=569" alt="Neiva" title="Neiva">
  <area shape="rect" coords="42,157,87,177" href="est1.asp?idciudad=665" alt="Pasto" title="Pasto">
</map>
<% end if %>
<div align=center>
<font color=red><b><i>Cantidad Total de Productos en Todas Ordenes</i></b></font><br>
<br></div>
<table border=1 align=center>
<tr bgcolor=#FF9900 align=center> 
   <td>Producto</td>
   <td>Cantidad</td>
<tr>
<%
      rs2.movefirst    
      if rs2.eof then
               response.write ("<div align=center><font color=red>No Existen Productos</font></div>")
         else
	i=0
       while not rs2.eof 
       i = i+1
       t1 = t1 + cdbl(rs2("cantidad"))
%>
   <td><%=rs2("subproducto")%></td>      
   <td align=right><%=rs2("cantidad")%></td></tr>
<% 
       rs2.movenext 
  wend 
    end if
%>
<tr bgcolor=#FF9900 ><td><b><%=i%> Productos</b></td><td>&nbsp;</td></tr>
</table>
</html>