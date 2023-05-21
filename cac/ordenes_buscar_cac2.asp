<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</head>
<BODY>
<%session("titulo")="Busqueda de Ordenes de Lectura "%>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/obtenerIdentificadorCAC.inc.asp"-->
<%
'traemos los datos recogidos en la forma
if Request.QueryString ("idproducto") <> "" then 
	 idproducto = Request.QueryString("idproducto")
else 
		 idproducto = Request.form("idproducto")
end if
if Request.QueryString ("idsubproducto") <> "" then 
	 idsubproducto = trim(request.QueryString("idsubproducto"))
else 
		 idsubproducto = trim(request.form("idsubproducto"))
end if

idorden = request.queryString("idorden")

reporteFiltro = "?idproducto=" & idProducto & "&idSubproducto=" & idsubproducto & "&idOrden=" 
sql = "select idorden_cac, idorden2_cac, convert(varchar, fecha, 105) as fecha, "
sql = sql & " (select cac from cac where idcac = a.idcac) as cac, cantidad, cantidad_leida, "
sql = sql & " (select subproducto from subproductos where idsubproducto = a.idsubproducto) as subproducto, estado "
sql = sql & " from ordenes_cac a "
sql = sql & " where idorden_cac is not null "
if idorden = "" then
   if idproducto <> "0" then
      sql = sql & " and idproducto = " & idproducto
   end if
   if idsubproducto <> "0" then
      sql = sql & " and idsubproducto = " & idsubproducto
   end if
else
  sql = sql & " and idorden_cac = " & idorden
end if
sql = sql & " and idcac = " & idcac
sql = sql & " order by estado, fecha "
'response.write sql
'response.write "<br>" & producto
'response.end
set rs=conn.execute(sql)

if rs.eof then  %>
  <A HREF="ordenes_buscar_cac.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
  <%
  conn.close
  response.end
end if  %>
<A HREF="ordenes_buscar_cac.asp">Otra Busqueda</A>
<BR><BR>
<TABLE BORDER="0" class="tabla">
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><font size="1" face="verdana"><B>Numero</B></font></TD>
    <TD><font size="1" face="verdana"><B>Orden</B></font></TD>
    <TD><font size="1" face="verdana"><B>Fecha</B></font></TD>
    <TD><font size="1" face="verdana"><B>Cac</B></font></TD>
    <TD><font size="1" face="verdana"><B>Cantidad</B></font></TD>
    <TD><font size="1" face="verdana"><B>Cantidad Leida</B></font></TD>
    <TD><font size="1" face="verdana"><B>Subproducto</B></font></TD>
    <TD><font size="1" face="verdana"><B>Estado</B></font></TD>
  </TR>
<%
  i=0
  bgcolor = "#FFFFFF"
  while not rs.eof
    i=i+1
    idorden = rs("idorden_cac")
    idorden2 = rs("idorden2_cac")
    fecha = trim(rs("fecha"))
    cac = trim(rs("cac"))
    cantidad  = rs("cantidad")
    cantidad_leida =rs("cantidad_leida")
    subproducto = trim(rs("subproducto"))
    estado = trim(rs("estado"))
    if estado = "1" then
       estado = "Activa"
    end if
    if estado = "2" then
       estado = "<font color=""990000"">Cerrada</font>"
    end if
    
    %>
    <TR bgcolor="<%=bgcolor%>">
      <TD align="right"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=idorden%></font></a></TD>
      <TD align="left"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=idorden2%></font></a></TD>
      <TD align="center"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=fecha%></font></a></TD>
      <TD align="left"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=cac%></font></a></TD>
      <TD align="right"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=cantidad%></font></a></TD>
      <TD align="right"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=cantidad_leida%></font></a></TD>
      <TD align="left"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=subproducto%></font></a></TD>
      <TD align="left"><a href="LecturaSerialesOrden.aspx<%=reporteFiltro%><%=idorden%>"><font size=1><%=estado%></font></a></TD>
    </TR>
<% 
     'color de fondo de las filas
   if bgcolor = "#FFFFFF" then
      'response.write("1")
      bgcolor = "#F0F0F0"
   ELSE
      bgcolor = "#FFFFFF"
   end if

    rs.movenext
  wend %>
  <TR>
    <TD COLSPAN="8" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
  </TR> 
</TABLE>
<%
'cerramos objetos de BD conexion y piscina  y los limpiamos
'rs.Close
conn.Close
Set rs = nothing
Set conn = nothing  %>
</BODY>
</HTML>