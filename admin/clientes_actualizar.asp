<html>
<body>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<% session("titulo") = "Actualizar Clientes"%>
<!--#include file="../include/titulo1.inc.asp"-->
<a href="clientes.asp">Regresar</a>
<form name=forma method=post action=clientes_actualizar2.asp>
<%
idcliente = request.querystring("idcliente")
sql="select idcliente2,dealer,cliente,idciudad,ciudad,direccion,telefonos,email,estado,region"
sql=sql+" from vi_clientes"
sql=sql+" where idcliente="&idcliente
 set rs=conn.execute(sql)
if not rs.eof then
  idcliente2=rs("idcliente2")
  dealer=rs("dealer")
  cliente=rs("cliente")
  idciudad=rs("idciudad")
  ciudad=rs("ciudad")
  direccion=rs("direccion")
  telefonos=rs("telefonos")
  email=rs("email")
  estado=rs("estado")
  region=trim(rs("region"))
  if cdbl(estado) = 1 then
    etiq = "checked"
  else
    etiq = ""
  end if
end if
%>
<input type=hidden name=idcliente value=<%=idcliente%>>
<table border=0>
  <tr> 
    <td><font size="2"><i>idcliente2</i></font></td>
    <td><input type=text name=idcliente2 size=25 maxlength = 25 value="<%=idcliente2%>"></td>
  </tr>
  <tr> 
    <td><font size="2"><i>Dealer</i></font></td>
    <td><input type=text name=dealer size=20 maxlength = 20 value=<%=dealer%>></td>
  </tr>
  <tr> 
    <td><i><font size="2">Cliente</font></i></td>
    <td><input type=text name=cliente size=50 maxlength = 70 value="<%=cliente%>"></td>
  </tr>
  <tr> 
    <td><i><font size="2">Ciudad</font></i></td>
    <td>
    <%
    sql="select idciudad,ciudad from ciudades where estado=1 order by prioridad desc, ciudad"
     set rs=conn.execute(sql) %>
    <select name=idciudad>
      <option value ="<%=idciudad%>"><%=ciudad%></option>
      <%
      while not rs.eof %>
        <option value ="<%=rs("idciudad")%>"><%=rs("ciudad")%></option>
        <%
        rs.movenext
      wend %>
    </select>
    </td>
  </tr>
    <tr> 
      <td><i><font size="2">Dirección</font></i></td>
      <td> 
        <input type=text name=direccion size=50 maxlength=50 value="<%=direccion%>">
      </td>
    </tr>
    <tr> 
      <td><i><font size="2">Telefonos</font></i></td>
      <td> 
        <input type=text name=telefonos size=20 maxlength=20 value="<%=telefonos%>">
      </td>
    </tr>
    <tr> 
      <td><i><font size="2">Email</font></i></td>
      <td> 
        <input type=text name=email size=40 maxlength=50 value="<%=email%>">
      </td>
    </tr>
    <tr> 
      <td><i><font size="2">Región</font></i></td>
      <td> 
        <select name="region">
          <option value="<%=region%>"><%=region%></option>
          <option value="OR">OR</option>
          <option value="OC">OC</option>
          <option value="NO">NO</option>
        </select>
      </td>
    </tr>
    <tr> 
      <td><i><font size="2">Estado</font></i></td>
      <td> 
        <input type=checkbox name=estado <%=etiq%>>
      </td>
    </tr>
  </table>
<br><input type=submit name=boton value=Continuar>
</form>
</body>
</html>
