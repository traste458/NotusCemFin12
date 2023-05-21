<%@ LANGUAGE="VBScript" %>
<% Response.Buffer=True %>
<% Response.expires = 0 %>
<html>
<!--#include file="../include/conexion.inc.asp"-->
<table border="0" align=center>
  <tr> 
    <td> 
      <!-- cuerpo de la página -->
      <%
  mapa="../images/colombia.gif"
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

    	f1="'20-10-2002'"
	f2="'20-12-2002'"



   sql="select subproducto,count(0) as cant from vi_ordenesdetalle where fecha >= "& f1 &" and fecha <= "& f2    
   sql=sql & " group by subproducto order by subproducto "

       set rs2=conn.execute(sql)
       vetiq = ""
       vval = ""
       vmax = 20  
       i = 0
       t1 = 0
       while not rs2.eof 
       i = i+1
       t1 = t1 + cdbl(rs2("cant"))
       if rs2("subproducto") <> "" then 
       vetiq = vetiq & " ," & mid(rs2("subproducto"),1,5)
       
        vval = vval & " ," & rs2("cant")   
       end if
       rs2.movenext 
        wend
        vetiq = mid(vetiq,2)
       vval = mid(vval,2)
       vtitulo = "Estadisticas Productos"
       tipografica = "BarChartApplet"
        'tipografica = "PieChartApplet"
        ancho="400"
        alto="200"
      %>		
      <br>
    <td>
      <!--#include file="../barras2.asp" -->
    </td>
    <td> 
      <img src="<%=mapa%>" width="300" height="250" usemap="#Map" border="0"> 
    </td>
  </tr>
</table>
<br>
<br>
<% if idciudad = "" then %>

<map name="Map"> 
  <area shape="rect" coords="123,111,213,134" href="estadisticas.asp?idciudad=150" alt="Bogot&aacute;" title="Bogot&aacute;">
  <area shape="rect" coords="39,128,100,147" href="estadisticas.asp?idciudad=944" alt="Cali" title="Cali">
  <area shape="rect" coords="105,29,222,52" href="estadisticas.asp?idciudad=127" alt="Barranquilla" title="Barranquilla">
  <area shape="rect" coords="55,98,114,121" href="estadisticas.asp?idciudad=316" alt="manizales" title="manizales">
  <area shape="rect" coords="76,64,184,85" href="estadisticas.asp?idciudad=1" alt="Medell&iacute;n" title="Medell&iacute;n">
  <area shape="rect" coords="108,139,163,163" href="estadisticas.asp?idciudad=569" alt="Neiva" title="Neiva">
  <area shape="rect" coords="42,157,87,177" href="estadisticas.asp?idciudad=665" alt="Pasto" title="Pasto">
</map>
<% end if
%>
 <table border=1 align=center>
  <tr bgcolor=#FF9900 align=center> 
    <td><font face="Arial, Helvetica, sans-serif" size="2">Orden No.</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Fecha</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Producto</font></td>
	    <td><font face="Arial, Helvetica, sans-serif" size="2">Linea</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Operario</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Cantidad<br>Real</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Cantidad<br>Pedida</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Cantidad<br>
      Empaque</font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2">Estado</font></td>
  </tr>

<%

   sql="select * from vi_ordenesdetalle where fecha>="& f1 &" and fecha<="& f2    
   sql=sql & " order by subproducto "
    set rs=conn.execute(sql)      

	    if rs.eof then
               response.write ("No Existen Productos")
            else

while not rs.eof
%>
<tr bgcolor=<%=bgc%>> 
    <td> <font face="Arial, Helvetica, sans-serif" size="2"> 
      <a href=../adm_operativo/ordenes_mostrar.asp?idorden=<%=rs("idorden")%>><%=rs("idorden2")%> 
      </a> </font> 
    </td>
    <td><font face="Arial, Helvetica, sans-serif" size="2"><%=mid(rs("fecha"),1,9)%></font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("subproducto")%>	
      </font></td>
	     <td align=right><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("linea")%>	
      </font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("tercero")%><br><%=rs("tercero2")%></font></td>
    <td align=right><font face="Arial, Helvetica, sans-serif" size="2"><b><%=rs("cantidad")%></b></font></td>
    <td align=right><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("cantidad_pedida")%></font></td>
    <td align=right><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("cantidad_empaque")%></font></td>
    <td><font face="Arial, Helvetica, sans-serif" size="2"><%=rs("cantidad_empaque")%></td>
  </tr>
  <%rs.movenext
wend
end if
%>
  <tr bgcolor=#FF9900>
    <td><%=i%> Ordenes</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align=right><b><%=t1%></b></td>
    <td>&nbsp;</td>    <td>&nbsp;</td> <td>&nbsp;</td>
  </tr>
</table>
</html>



