<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<HTML>
<head>
<link rel="stylesheet" type="text/css" href="../include/styleBACK.css" >
</head>
<BODY>
<%session("titulo")="Busqueda de CAC "%>
<!--#include file="../include/titulo1.inc.asp"-->
<%
'traemos los datos recogidos en la forma
idcac2 = trim(request.form("idcac2"))
cac = trim(request.form("cac"))
idciudad = request.form("idciudad")
idauxiliar = request.form("idauxiliar")
region = request.form("region")
idEstado = request.form("ddlEstado")
'buscamos en la tabla pos por identificacion
   sqlCac = "select idcac, idcac2, cac, "
   sqlCac = sqlCac & " (select ciudad from ciudades where idciudad = a.idciudad) as ciudad, "
   sqlCac = sqlCac & " (select tercero from terceros where idtercero = a.idauxiliar) as auxiliar, "
   sqlCac = sqlCac & " telefono,  CASE idestado WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS estado "
   sqlCac = sqlCac & " from cac a"
      
if idcac2 <> "" then
   sqlCac = sqlCac & " where idcac2 = '" & idcac2 & "'"
else
   sqlCac = sqlCac & " where idcac <> 1 "
   if cac <> "" then
     sqlCac = sqlCac & " and cac like '%"& cac &"%'"
   end if
   if idciudad <> 0 then
     sqlCac = sqlCac & " and idciudad = "& idciudad
   end if
   if idauxiliar <> 0 then
      sqlCac = sqlCac & " and idauxiliar = " & idauxiliar
   end if
   if region <> "0" then
      sqlCac = sqlCac & " and region = '" & region & "' "
   end if
   
   '''posibles Estados Activo =1 inactivo=0
      if idEstado <> "-1"then sqlCac = sqlCac & " and idEstado = " & idEstado & " "
   
end if
set rs=conn.execute(sqlCac)

if rs.eof then  %>
  <A HREF="cac_buscar.asp">Regresar</A>
  <CENTER><FONT COLOR="RED" SIZE="4">No Se encontrar&oacute;n Registros con esas caracteristicas.</FONT></CENTER>
  <%
  conn.close
  response.end
end if  %>
<A HREF="cac_buscar.asp">Otra Busqueda</A>
<BR><BR>
<TABLE WIDTH="100%" BORDER="0" class="tabla">
  <TR BGCOLOR="#DDDDDD" ALIGN="CENTER">
    <TD><font size="1" face="verdana"><B>Código</B></font></TD>
    <TD><font size="1" face="verdana"><B>CAC</B></font></TD>
    <TD><font size="1" face="verdana"><B>Ciudad</B></font></TD>
    <TD><font size="1" face="verdana"><B>Auxiliar</B></font></TD>
    <TD><font size="1" face="verdana"><B>Teléfono</B></font></TD>
    <TD><font size="1" face="verdana"><B>Estado</B></font></TD>
  </TR>
<%
  i=0
  bgcolor = "#FFFFFF"
  while not rs.eof
    i=i+1
    idcac = rs("idcac")
    idcac2 = trim(rs("idcac2"))
    cac = trim(rs("cac"))
    ciudad = trim(rs("ciudad"))
    auxiliar = trim(rs("auxiliar"))
    estado= rs("estado")
    %>
    <TR>
      <TD bgcolor="<%=bgcolor%>"><font size=1><%=idcac2%></font></TD>
      <TD bgcolor="<%=bgcolor%>"><font size=1><A HREF="cac_actualizar.asp?idcac=<%=idcac%>"><u><%=cac%></u></A></font></TD>
      <TD bgcolor="<%=bgcolor%>"><font size=1><%=ciudad%></font></TD>
      <TD bgcolor="<%=bgcolor%>"><font size=1><%=auxiliar%></font></TD>
      <TD bgcolor="<%=bgcolor%>"><font size=1><%=telefono%></font></TD>
      <TD bgcolor="<%=bgcolor%>"><font size=1><%=estado%></font></TD>
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
    <TD COLSPAN="6" bgcolor="#DDDDDD"><b><%=i%> Registros</b></TD>
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