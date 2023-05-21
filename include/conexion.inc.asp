<% Rem Abre la conección a la base de datos

'if cdbl(session("usxp001"))=0 then
 '  response.redirect "violacion_conexion.asp"
'end if

 set conn=server.createobject("ADODB.connection")
 conn.CommandTimeout = 600
 
'conn.open "Driver={SQL Server};Server=Development;Database=bpcolsys_des;uid=sa;pwd=sa"
'conn.open "Driver={SQL Server};SERVER=COLBOGSA026C\COLBOGSA026C;DATABASE=NotusCEMFinData;UID=sa;PWD=12345.LM"
conn.open "Driver={SQL Server};SERVER=COLBOGSACDE002,1533;DATABASE=NotusCEMFinData;UID=AppNCEMDBUser;PWD=u$eRdb_L0gyCem"

%>
