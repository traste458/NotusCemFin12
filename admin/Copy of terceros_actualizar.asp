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
 //validaciones para cambio de clave
    if (document.forma.clave.value != document.forma.clavecript.value)
       {
       if (document.forma.clave.value == "")
           {
           alert ("Escriba una clave de Usuario, Por Favor.");
           document.forma.clave.focus();
           return (false);
           }
       if (document.forma.clave2.value == "") 
           {
           alert ("Escriba la confiramcion de la clave");
           document.forma.clave2.focus();
           return (false);
           }
       if (document.forma.clave.value != document.forma.clave2.value ) 
           {
           alert ("Las Claves no Coinciden");
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
           document.forma.cambioclave.value = "1";
       }
    }
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<% session("titulo") = "<b>Actualizar Tercero</b>" %>
<!--#include file="../include/titulo1.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<%
estado = request.querystring("estado")
idtercero = request.querystring("idtercero")

if estado = 1 then  %>
  <CENTER><FONT COLOR="BLUE" SIZE="4">TERCERO ACTUALIZADO</FONT></CENTER>
<%  
end if
if estado = 2 then  %>
  <CENTER><FONT COLOR="RED" SIZE="4">ERROR: Usuario y Clave existentes.</FONT></CENTER>
<%  
end if

sql = "select * from vi_terceros where idtercero = " &idtercero
'response.write(sql)
'response.end
set rs=conn.execute(sql)

est = rs("estado")
if cdbl(est) = 1 then
  est2 = "Activo"
else
  est2 = "Inactivo"
  est = 0
end if
%>
<A HREF="terceros.asp">Menu Terceros</A>
<BR><BR>
<FORM NAME="forma" METHOD="POST" ACTION="terceros_actualizar2.asp" onSubmit="return validacion()">
<TABLE BORDER="1">
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Nombres y Apellidos:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="tercero" SIZE="40" MAXLENGTH="50" value="<%=rs("tercero")%>"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Identificaci&oacute;n:</B></TD>
    <TD><INPUT TYPE="TEXT" NAME="idtercero2" SIZE="17" MAXLENGTH="15" value="<%=rs("idtercero2")%>"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Cargo:</B></TD>   
    <TD>
      <SELECT NAME="idcargo">
        <OPTION VALUE="<%=rs("idcargo")%>"><%=rs("cargo")%></OPTION>
<%
        sql = "select idcargo,cargo from cargos order by cargo"
        set rs2 = conn.execute(sql)
        while not rs2.eof
          idcargo=rs2("idcargo")
          cargo=rs2("cargo") %>
          <OPTION VALUE=<%=idcargo%>><%=cargo%></OPTION>
<%
          rs2.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Ciudad:</B></TD>   
    <TD>
      <SELECT NAME="idciudad">
        <OPTION VALUE="<%=rs("idciudad")%>"><%=rs("ciudad")%></OPTION>
<%
        sql = "select idciudad,ciudad from ciudades order by prioridad,ciudad"
        set rs2 = conn.execute(sql)
        while not rs2.eof
          idciudad=rs2("idciudad")
          ciudad=rs2("ciudad") %>
          <OPTION VALUE=<%=idciudad%>><%=ciudad%></OPTION>
<%
          rs2.movenext 
        wend
%>         
      </SELECT>
    </TD>   
  </TR>

    <TR>
    <TD BGCOLOR="#DDDDDD"><B>POS:</B></TD>   
    <TD>
      <SELECT NAME="idpos">
      <%
          if isnull(rs("idpos")) then
             idpos = "NULL"
             pos = "Elija un POS (Para Vendedores)"
          else
              idpos = rs("idpos")
              pos = rs("pos")
          end if

      %>
        <OPTION VALUE=<%=idpos%>><%=pos%></OPTION>

<%
        sql = "select pos.idpos,pos.pos,ciu.ciudad"
        sql = sql &" from pos, ciudades ciu"
        sql = sql &" where pos.idciudad = ciu.idciudad"
        sql = sql &" and idestado = 1"
        sql = sql &" order by pos"
        set rs2 = conn.execute(sql)
        while not rs2.eof
          idpos=rs2("idpos")
          pos=rs2("pos")
          ciudad=rs2("ciudad") %>
          <OPTION VALUE="<%=idpos%>"><%=pos%> (<%=rs2("ciudad")%>)</OPTION>
<%
          rs2.movenext
        wend
%>         
      </SELECT>
    </TD>   
  </TR>
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Centro de Costo:</B></TD>   
    <TD>
       <SELECT NAME="idcentro_costo">
      <%
          if isnull(rs("idcentro_costo")) then
             idcentro_costo = "NULL"
             centro_costo = "Elija un Centro de Costo (Para Vendedores)"
          else
              idcentro_costo = rs("idcentro_costo")
              centro_costo = rs("centro_costo")
          end if

      %>
        <OPTION VALUE=<%=idcentro_costo%>><%=centro_costo%></OPTION>

<%
        sql = "select idcentro_costo, nombre"
        sql = sql &" from centros_costo"
        set rs2 = conn.execute(sql)
        while not rs2.eof
          idcentro_costo = rs2("idcentro_costo")
          centro_costo=rs2("nombre")
          %>
          <OPTION VALUE=<%=idcentro_costo%>><%=centro_costo%></OPTION>
<%
          rs2.movenext
        wend
%>         
      </SELECT>

</TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Empresa Temporal:</B></TD>   
    <TD>
     <SELECT NAME="idempresa_temporal">
<%
          if isnull(rs("idempresa_temporal")) then
             idempresa_temporal = "NULL"
             empresa_temporal = "Elija una Empresa Temporal"
          else
              idempresa_temporal = rs("idempresa_temporal")
              empresa_temporal = rs("empresa_temporal")
          end if
%>
        <OPTION VALUE=<%=idempresa_temporal%>><%=empresa_temporal%></OPTION>
<%
        sql = "select idempresa_temporal, nombre"
        sql = sql &" from empresas_temporales"
        set rs2 = conn.execute(sql)
        while not rs2.eof
          idempresa_temporal = rs2("idempresa_temporal")
          empresa_temporal=rs2("nombre")
          %>
          <OPTION VALUE=<%=idempresa_temporal%>><%=empresa_temporal%></OPTION>
<%
          rs2.movenext
        wend
%>         
      </SELECT>

    </TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Usuario:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="usuario" SIZE="10" MAXLENGTH="8" value="<%=rs("usuario")%>" disabled></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Clave:</B></TD>   
    <TD><INPUT TYPE="PASSWORD" NAME="clave" SIZE="10" MAXLENGTH="40" value="<%=rs("clave")%>">
    <INPUT TYPE="hidden" NAME="clavecript"  value="<%=rs("clave")%>">
    <INPUT TYPE="hidden" NAME="cambioclave"  value="0">
    </TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Confirme Clave:</B></TD>   
    <TD><INPUT TYPE="PASSWORD" NAME="clave2" SIZE="10" MAXLENGTH="40" value="<%=rs("clave")%>"></TD>
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>* Linea:</B></TD>   
    <TD><INPUT TYPE="TEXT" NAME="linea" SIZE="3" MAXLENGTH="2" value="<%=rs("linea")%>"></TD>   
  </TR>  
  <TR>
    <TD BGCOLOR="#DDDDDD"><B>Estado:</B></TD>   
    <TD>
      <SELECT NAME="idestado">
        <OPTION VALUE="<%=est%>"><%=est2%></OPTION>
        <OPTION VALUE="1">Activo</OPTION>
        <OPTION VALUE="0">Inactivo</OPTION>
      </SELECT>
    </TD>   
  </TR>  
</TABLE>
    <input type="hidden" name="clavemd5">
<BR><BR>
<UL>
  <INPUT TYPE="SUBMIT" VALUE="Actualizar Tercero Ahora">
</UL>
<INPUT TYPE="HIDDEN" NAME="IDTERCERO" VALUE="<%=rs("idtercero")%>">
</FORM>
</BODY> 
<SCRIPT LANGUAGE="JavaScript">
   document.forma.tercero.focus();
</SCRIPT>
</HTML>