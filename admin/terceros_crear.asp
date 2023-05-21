<HTML>
<HEAD>
<SCRIPT language="JavaScript" src="../include/ValidForm.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function validacion()
    {
    if (document.forma.tercero.value == "") 
        {
        alert ("Escriba el Nombre, Por Favor");
        document.forma.tercero.focus();
        return (false);
        }
    if (document.forma.idtercero2.value == "") 
        {
        alert ("Escriba la Identificación, Por Favor");
        document.forma.idtercero2.focus();
        return (false);
        }
    if (document.forma.idcargo.value == 0)
        {
        alert ("Escoja un Cargo, Por Favor");
        document.forma.idcargo.focus();
        return (false);
        }
    if (document.forma.idciudad.value == 0) 
        {
        alert ("Escoja una Ciudad, Por Favor");
        document.forma.idciudad.focus();
        return (false);
        }

    if (document.forma.usuario.value == "")
        {
        alert ("Escriba el Nombre de Usuario, Por Favor. Es con el que se identificará a la persona en el sistema");
        document.forma.usuario.focus();
        return (false);
        }

//**********************
// validaciones de clave
//**********************

    if (document.forma.clave.value == "") 
        {
        alert ("Escriba una clave de Usuario, Por Favor.");
        document.forma.clave.focus();
        return (false);
        }
    if (document.forma.clave2.value == "") 
        {
        alert ("Escriba la confirmación de la clave");
        document.forma.clave2.focus();
        return (false);
        }
    if (document.forma.clave.value != document.forma.clave2.value ) 
        {
        alert ("Las Claves no Coinciden");
        document.forma.clave.value = "";
        document.forma.clave2.value = "";
        document.forma.clave.focus();
        return (false);
        }

    if (document.forma.clave.value == document.forma.usuario.value)
       {
            alert ("La clave no cumple con los requisitos de seguridad. No puede tener el mismo nombre de usuario");
            document.forma.clave.value = "";
            document.forma.clave2.value = "";
            document.forma.clave.focus();
            return (false);
       }
    if (document.forma.clave.value.length < 5)
       {
            alert ("La clave no cumple con los requisitos de seguridad. Debe tener como minimo 5 digitos");
            document.forma.clave.value = "";
            document.forma.clave2.value = "";
            document.forma.clave.focus();
            return (false);
       }
/*
//validacion de nombres en la clave. no puede tener el partes del nombre en la clave
    var verificar_clave
    var mayusculas
    var contador = 0;
    var clavetemp = document.forma.clave.value.toUpperCase();
    mayusculas = document.forma.tercero.value.toUpperCase();
    verificar_clave = mayusculas.split(" ");

    while (contador < verificar_clave.length)
          {

              if(clavetemp.indexOf(verificar_clave[contador]) >= 0 )
                 {
                     alert ("La clave no cumple con los requisitos de seguridad. No puede contener partes del nombre del tercero");
                     document.forma.clave.value = "";
                     document.forma.clave2.value = "";
                     document.forma.clave.focus();
                     return (false);
                     exit;
                 }
              contador = contador + 1;
          }
*/

    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Crear Terceros</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
estado = request.querystring("estado")
if estado = 1 then  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4">TERCERO INSERTADO</FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <CENTER><FONT COLOR="RED" SIZE="4">ERROR: Usuario y Clave existentes.</FONT></CENTER>
<%  
end if
if estado = 3 then
%>
  <CENTER><FONT COLOR="RED" SIZE="4">ERROR: Número de Identificación ya existente.</FONT></CENTER>
<%  
end if

if estado = 4 then
%>
  <CENTER><FONT COLOR="RED" SIZE="4">ERROR: El Nombre de Correo no es Válido.</FONT></CENTER>
<%  
end if
%>


<A HREF="terceros.asp">Regresar</A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="terceros_crear2.asp" onSubmit="return validacion()">
<TABLE BORDER="1">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Nombres y Apellidos:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="tercero" SIZE="40" MAXLENGTH="50"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Identificaci&oacute;n:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="idtercero2" SIZE="17" MAXLENGTH="15"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Cargo:</B></TD>   
    <TD>
      <SELECT NAME="idcargo">
        <OPTION VALUE=0>Elija un Cargo</OPTION>
<%
        sql = "select idcargo,cargo from cargos where estado = 1 order by cargo"
        set rs = conn.execute(sql)
        while not rs.eof
          idcargo=rs("idcargo")
          cargo=rs("cargo") %>
          <OPTION VALUE=<%=idcargo%>><%=cargo%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Ciudad:</B></TD>   
    <TD>
      <SELECT NAME="idciudad">
        <OPTION VALUE=0>Elija una Ciudad</OPTION>
<%
        sql = "select idciudad,ciudad from ciudades order by prioridad desc,ciudad"
        set rs = conn.execute(sql)
        while not rs.eof
          idciudad=rs("idciudad")
          ciudad=rs("ciudad") %>
          <OPTION VALUE=<%=idciudad%>><%=ciudad%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>POS:</B></TD>   
    <TD>
      <SELECT NAME="idpos">
        <OPTION VALUE=1>Elija un POS (Para Vendedores)</OPTION>
<%
        sql = "select pos.idpos,pos.pos,ciu.ciudad from pos with(nolock) inner join ciudades ciu with(nolock)on "
        sql = sql &" pos.idciudad = ciu.idciudad where idestado = 1 order by pos "
        set rs = conn.execute(sql)
        while not rs.eof
          idpos=rs("idpos")
          pos=rs("pos")
          ciudad=rs("ciudad") %>
          <OPTION VALUE=<%=idpos%>><%=pos%> (<%=rs("ciudad")%>)</OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Centro de Costo:</B></TD>   
    <TD>
      <SELECT NAME="idcentro_costo">
        <OPTION VALUE="1">Elija un Centro de Costo (Para Vendedores)</OPTION>
<%
        sql = "select idcentro_costo, nombre"
        sql = sql &" from centros_costo where estado = 1"
        set rs = conn.execute(sql)
        while not rs.eof
          idcentro_costo = rs("idcentro_costo")
          centro_costo=rs("nombre")
          %>
          <OPTION VALUE=<%=idcentro_costo%>><%=centro_costo%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>

</TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Empresa Temporal:</B></TD>   
    <TD>
      <SELECT NAME="idempresa_temporal">
        <OPTION VALUE="1">Elija una Empresa Temporal</OPTION>
<%
        sql = "select idempresa_temporal, nombre"
        sql = sql &" from empresas_temporales where estado = 1"
        set rs = conn.execute(sql)
        while not rs.eof
          idempresa_temporal = rs("idempresa_temporal")
          empresa_temporal=rs("nombre")
          %>
          <OPTION VALUE=<%=idempresa_temporal%>><%=empresa_temporal%></OPTION>
<%
          rs.movenext 
        wend
%>         
      </SELECT>

    </TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Usuario:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="usuario" SIZE="10" MAXLENGTH="30"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Clave:</B></TD>   
    <TD><INPUT TYPE="PASSWORD" NAME="clave" SIZE="10" MAXLENGTH="20"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Confirme Clave:</B></TD>   
    <TD><INPUT TYPE="PASSWORD" NAME="clave2" SIZE="10" MAXLENGTH="20"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Linea:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="linea" SIZE="3" MAXLENGTH="2"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Digite su Email:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="Email" SIZE="50" MAXLENGTH="50" ID="Text1"></TD>   
  </TR> 
</TABLE>
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Crear Tercero" >
</UL>
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.tercero.focus();
</SCRIPT>
</HTML>