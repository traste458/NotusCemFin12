<%
if conn is nothing then %>
  <!--#include file="../include/conexion.inc.asp"--><%
end if
sqlCac = "select idcac, idcac2, cac from cac where idauxiliar = " & session("usxp001") & "AND idEstado= 1"
set rsCac = conn.execute(sqlCac)
if not rsCac.eof then
  idcac = rsCac("idcac")
	idCac2 = rsCac("idcac2")
	cac = rsCac("cac")  
end if
if IsNull(idcac) or idcac = "" then%>
  <center>
	  <font size="4" color="red">
		  <b><i>El usuario actual no está asociado a ningún CAC. Por favor contacte al Adminitrador de CACs</i></b>
	  </font>
  </center>
<% 
  conn.close
	set conn = nothing
  response.end
end if
%>
