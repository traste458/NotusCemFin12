<% Rem Abre la conección a la base de datos

'if cdbl(session("usxp001"))=0 then
 '  response.redirect "violacion_conexion.asp"
'end if

set conn=server.createobject("ADOdb.connection")
 conn.open "DSN=bp_inventario2;uid=sa;pwd=sa;"
%>


