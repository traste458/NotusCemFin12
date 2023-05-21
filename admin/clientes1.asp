<html>
<body>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<!--#include file="../include/titulo1.inc.asp"-->
<a href="clientes.asp">Regresar</a>
<form name=forma method=post action=clientes_insertar.asp>
  <font color="#000000" size="6"><i>Insertar en clientes</i></font><br>
  <br>
  <table border=0 >
    <tr> 
      <td>idcliente2</td>
      <td> 
        <input type=text name=idcliente2 size=25>
      </td>
    </tr>
    <tr> 
      <td>Dealer</td>
      <td> 
        <input type=text name=dealer size=20 maxlength=20>
      </td>
    </tr>
    <tr> 
      <td>cliente</td>
      <td> 
        <input type=text name=cliente size=70>
      </td>
    </tr>
    <tr> 
      <td>idciudad</td>
      <td> 
        <%
sql="select idciudad,ciudad from ciudades where upper(ciudad) like upper('%"&request.form("ciudad")&"%') and estado=1 order by prioridad desc,ciudad"
set rs=conn.execute(sql) %>
        <select name=idciudad>
          <% while not rs.eof %>
          <option value =<%=rs("idciudad")%>><%=rs("ciudad")%></option>
          <% rs.movenext
wend %>
        </select>
      </td>
    </tr>
    <tr> 
      <td>direccion</td>
      <td> 
        <input type=text name=direccion size=50>
      </td>
    </tr>
    <tr> 
      <td>telefonos</td>
      <td> 
        <input type=text name=telefonos size=20>
      </td>
    </tr>
    <tr> 
      <td>email</td>
      <td> 
        <input type=text name=email size=20>
      </td>
    </tr>
    <tr> 
      <td><i><font size="2">Región</font></i></td>
      <td> 
        <select name="region">
          <option value="OR">OR</option>
          <option value="OC">OC</option>
          <option value="NO">NO</option>
        </select>
      </td>
    </tr>
  </table>
  <br>
  <input type=submit name=boton value=Continuar>
</form>
</body>
</html>
