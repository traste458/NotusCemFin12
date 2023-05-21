<!--#include file="../include/seguridad.inc.asp" -->
<!--#include file="../include/conexion.inc.asp" -->
<%
' Server.ScriptTimeout = 1000

dia1 = request.form("dia1")
mes1 = request.form("mes1")
ano1 = request.form("ano1")
dia2 = request.form("dia2")
mes2 = request.form("mes2")
ano2 = request.form("ano2")
estado = request.form("estado")
fecha = request.Form("fecha")
serial = trim(request.form("serial"))
if serial = "" then
   serial = trim(request.querystring("serial"))
end if

if (dia1 <> "" and dia2 <> "" and fecha <> "")  then
   'manejo de fechas para evitar errores se concatena con el cero
   if cdbl(dia1) < 10 and len(dia1) < 2 then
     dia1="0"+dia1
   end if
   if cdbl(dia2) < 10 and len(dia2) < 2 then
     dia2="0"+dia2
   end if
   if cdbl(mes1) < 10 and len(mes1) < 2 then
     mes1="0"+mes1
   end if
   if cdbl(mes2) < 10 and len(mes2) < 2 then
     mes2="0"+mes2
   end if
     
   fec1=ano1+mes1+dia1   'fechas para comparar
   fec2=ano2+mes2+dia2

   f1 = dia1 & "/" & mes1 & "/" & ano1   'fechas para mostrar
   f2 = dia2 & "/" & mes2 & "/" & ano2

   sql = "select isdate('"&fec1&"') as fec1_aux, isdate('"&fec2&"') as fec2_aux"
    set rs=conn.execute(sql)
   if cdbl(rs("fec1_aux")) = 0 then 
     response.write "<center><font color=red size=4 face=arial>Error: La Fecha inicial no es valida.</font></center>"
     conn.close
     response.end
   end if
   if cdbl(rs("fec2_aux")) = 0 then 
     response.write "<center><font color=red size=4 face=arial>Error: La Fecha final no es valida.</font></center>"
     conn.close
     response.end
   end if
end if

sqlCac = "select idcac from terceros where idtercero = " & session("usxp001")
set rsCac = conn.execute(sqlCac)
idcac = rsCac("idcac")

%>
<html>
<head>
<LINK REL="StyleSheet" HREF="../include/styleBACK.css" TYPE="text/css">      
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    }
</SCRIPT>
</head>
<body bgcolor="#FFFFFF" class="cuerpo2" >
<!--#include file="../include/titulo1.inc.asp" -->
<a href="servicio_buscar.asp" ><u>Regresar</u></a>
<%

if serial = "" then
   sql = "select "
   sql = sql & " idservicio, serial, "
   sql = sql & " (select producto from productos where idproducto = a.idproducto) as producto, "
   sql = sql & " convert(varchar, a.fecha_ingreso, 105) as fecha_ingreso, convert(varchar, a.fecha_entrega, 105) as fecha_entrega, "
   sql = sql & " convert(varchar, a.fecha_respuesta, 105) as fecha_respuesta, convert(varchar, a.fecha_cierre, 105) as fecha_cierre, "
   sql = sql & " serial_reemplazo, estado,  "
   sql = sql & " (select tercero from terceros where idtercero = a.idtercero) as tercero "
   sql = sql & " from servicio_tecnico a "
   sql = sql & " where idcac = " & idcac
   if fecha <> "" then
      if fecha = "0" then
         sql = sql & " and convert(varchar,fecha_ingreso, 112) >= '" & fec1 & "' and convert(varchar,fecha_ingreso, 112) <= '" & fec2 & "' "
      end if
      if fecha = "1" then
         sql = sql & " and convert(varchar,fecha_entrega, 112) >= '" & fec1 & "' and convert(varchar,fecha_entrega, 112) <= '" & fec2 & "' "
      end if
      if fecha = "2" then
         sql = sql & " and convert(varchar,fecha_respuesta, 112) >= '" & fec1 & "' and convert(varchar,fecha_respuesta, 112) <= '" & fec2 & "' "
      end if
      if fecha = "3" then
         sql = sql & " and convert(varchar,fecha_cierre, 112) >= '" & fec1 & "' and convert(varchar,fecha_cierre, 112) <= '" & fec2 & "' "
      end if
   end if
   if estado <> "" then
      sql = sql & " and estado = " & estado
   end if
   sql = sql & " order by fecha_ingreso, estado  "

else
   sql = "select "
   sql = sql & " idservicio, serial, "
   sql = sql & " (select producto from productos where idproducto = a.idproducto) as producto, "
   sql = sql & " convert(varchar, a.fecha_ingreso, 105) as fecha_ingreso, convert(varchar, a.fecha_entrega, 105) as fecha_entrega, "
   sql = sql & " convert(varchar, a.fecha_respuesta, 105) as fecha_respuesta, convert(varchar, a.fecha_cierre, 105) as fecha_cierre, "
   sql = sql & " serial_reemplazo, estado,  "
   sql = sql & " (select tercero from terceros where idtercero = a.idtercero) as tercero "
   sql = sql & " from servicio_tecnico a "
   sql = sql & " where idcac = " & idcac
   sql = sql & " and serial = '" & serial & "'"
   sql = sql & " order by fecha_ingreso, estado  "
end if


set rs2=conn.execute(sql)
if rs2.eof then %>
 <br><br>
 <div align=center><font color=red size=4><i>No Hay Servicio Técnico con esas caracterisiticas.</i></font></div>
 <% 
 response.end
end if
%>
<br>
<br>
<FORM NAME="forma" METHOD="POST" ACTION="servicio_enviar.asp" onSubmit="return validacion();">
<table class="tabla" width="100%">
  <tr bgcolor=#DDDDDD align=center> 
    <td><FONT SIZE="1"><b>Num</b></FONT></td>
    <td><FONT SIZE="1"><b>Serial</b></FONT></td>
    <td><FONT SIZE="1"><b>Producto</b></FONT></td>
    <td><FONT SIZE="1"><b>F. de Ingreso</b></FONT></td>
    <td><FONT SIZE="1"><b>F. de Entrega</b></FONT></td>
    <td><FONT SIZE="1"><b>F. de Devolución S.T.</b></FONT></td>
    <td><FONT SIZE="1"><b>F. de Cierre</b></FONT></td>
    <td><FONT SIZE="1"><b>Serial de Reemplazo</b></FONT></td>
    <td><FONT SIZE="1"><b>Estado</b></FONT></td>
    <td><FONT SIZE="1"><b>Opciones</b></FONT></td>
  </tr>
  <%
    bgcolor="" 
    i = 0    
    total = 0
    entregar = 0
    while not rs2.eof
      idservicio = rs2("idservicio")
      if rs2("estado") = "0" then
         estado = "Recibido"
         hrefOpcion = "<input type=""checkbox"" name=""check" & entregar & """ ><input type=""hidden"" name=""idservicio" & entregar & """ value=""" & idservicio & """>"
         hrefOpcion = hrefOpcion & "<font size=""1"" color=blue>Entregar a S.T.</font></a>"
         entregar = entregar + 1
      end if
      if rs2("estado") = "1" then
         estado = "Entregado a S.T."
         hrefOpcion = "<a href=""servicio_entregar.asp?idservicio=" & idservicio & """><font size=""1"" color=blue>Recibir de S.T.</font></a>"
      end if
      if rs2("estado") = "2" then
         estado = "Por confirmación"
         hrefOpcion = "<a href=""servicio_confirmar.asp?idservicio=" & idservicio & """ onclick=""return(confirm('¿Esta seguro que desea cerrar este Servicio Tecnico?'))""><font size=""1"" color=blue>Cerrar Servicio</font></a>"
      end if
      if rs2("estado") = "3" then
         estado = "Cerrado"
         hrefOpcion = ""
      end if
      %>
      <tr align=center bgcolor=<%=bgcolor%>>
        <td><FONT SIZE="1"><%=trim(rs2("idservicio"))%></FONT></a></td>
        <td><FONT SIZE="1"><%=trim(rs2("serial"))%></FONT></a></td>
        <td><FONT SIZE="1"><%=trim(rs2("Producto"))%></FONT></td>
        <td><FONT SIZE="1"><%=trim(rs2("fecha_ingreso"))%></FONT></td>
        <td><FONT SIZE="1"><%=trim(rs2("fecha_entrega"))%></FONT></td>
        <td><FONT SIZE="1"><%=trim(rs2("fecha_respuesta"))%></FONT></td>
        <td><FONT SIZE="1"><%=trim(rs2("fecha_cierre"))%></FONT></td>
        <td><FONT SIZE="1"><%=trim(rs2("serial_reemplazo"))%></FONT></td>
        <td><FONT SIZE="1"><%=estado%></FONT></td>
        <td><%=hrefOpcion%></td>
      </tr>
      <%
      i = i+1
      if bgcolor = "" then
        bgcolor = "F3F3F3"
      else
        bgcolor = ""
      end if  
      rs2.movenext
    wend %>
  <tr  align="center">
    <%
    if entregar > 0 then
    %>
      <td bgcolor=#DDDDDD colspan="9"><b><%=i%> Seriales</b></td>
      <td  ><input type="submit" value="Enviar a S.T." class="boton"></td>
    <%
    else
    %>
      <td bgcolor=#DDDDDD colspan="10"><b><%=i%> Seriales</b></td>
    <%
    end if
    %>

  </tr> 
</table>
<input type="hidden" name="numero" value="<%=entregar%>">
</form>
<br>
<br>
<%
conn.close
%>
</body>
</html>