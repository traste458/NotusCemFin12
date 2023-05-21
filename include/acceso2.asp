<%@ LANGUAGE="VBScript" %>
<% Response.Buffer=True %>
<%session.Timeout=480%>
<!--#include file="include/conexion.inc.asp"-->
<!--#include file="include/md5.asp"-->
<%  
sql = "select ubic_excel,ubic_planos from configuracion"
set rs=conn.execute(sql)
session("path")=trim(rs("ubic_excel"))
session("path_planos")=trim(rs("ubic_planos"))

usuario=trim(request.form("usuario"))
clave= md5(trim(request.form("clave")))
sql = "select idtercero,tercero,ciudad,cargo,cliente,idciudad,idcargo,idcliente,idperfil,linea,idbodega"
sql = sql & " from vi_terceros"
sql = sql & " where ltrim(usuario)='"+usuario+"' and rtrim(clave)='"+clave+"' and estado = 1"
'response.write sql
'response.end
  set rs=conn.execute(sql)
if rs.eof then %>
<br>
<br>
<br>
<br>
<br>
<br>
<h2 align="center"> <font face="Arial, Helvetica, sans-serif" size="4">Clave o 
  Usuario Equivocado.. Verifique por Favor.</font></h2>
 <h2 align="center">&nbsp;</h2>
<h2 align="center"><font face="Arial, Helvetica, sans-serif" size="4"><a href="contenido.htm">Regresar</a></font></h2>
<% else
    session("usxp001")=rs("idtercero")
    session("usxp002")=rs("tercero")
    session("usxp003")=rs("cliente")
    session("usxp004")=rs("cargo")
    session("usxp005")=rs("ciudad")
    session("usxp006")=rs("idcargo")
    session("usxp007")=rs("idciudad")
    session("usxp008")=rs("idcliente")
    session("usxp009")=rs("idperfil")
    session("usxp010")=rs("linea")
    session("usxp012")=rs("idbodega")
        vidperfil = rs("idperfil")
    session("usxp013")=rs("idperfil")

    if CInt(vIdperfil)=1 Then
      session("usxp011")= "Administrador Operativo"
      conn.close
      response.redirect "frames.htm"  
    end if
    if CInt(vIdperfil)=2 Then
      session("usxp011")= "Demo"   
      conn.close
      response.redirect "consulta_basica/frames.htm"
    end if
    if CInt(vIdperfil)=3 Then
       session("usxp011")= "Gerencial"
      conn.close
      response.redirect "gerencial/frames.htm"
    End If
    if CInt(vIdperfil)=4 Then
      session("usxp011")= "Alta Gerencia" 
      conn.close
      response.redirect "gerencial/frames.htm"  
     end if
    if CInt(vIdperfil)=5 or CInt(vIdperfil)=11 Then
      session("usxp011")= "Contingencia" 
      conn.close
      response.redirect "contingencia/frames.htm"  
     end if
    'if CInt(vIdperfil)=6  Then
    '  session("usxp011")= "Administrador del Sistema"
    '  conn.close
    '  response.redirect "admin/frames.htm"
    ' end if
    if CInt(vIdperfil)=7 or CInt(vIdperfil)=10 Then
      session("usxp011")= "Devoluciones" 
      conn.close
      response.redirect "devoluciones/frames.htm"  
     end if
    if CInt(vIdperfil)=8  Then
      session("usxp011")= "Administrador Inventarios" 
      conn.close
      response.redirect "inventarios/frames.htm"  
     end if
    if CInt(vIdperfil)=9  Then
      session("usxp011")= "Inventarios" 
      conn.close
      response.redirect "inventarios/frames_user.htm"  
     end if
    if CInt(vIdperfil)=12  Then
      session("usxp011")= "Bodega" 
      conn.close
      response.redirect "bodega/frames.htm"  
     end if
     'redireccionar a sistema de perfiles
    if CInt(vIdperfil)=13 or CInt(vIdperfil)=14 or CInt(vIdperfil)=15 or CInt(vIdperfil)=16 or CInt(vIdperfil)=17 or CInt(vIdperfil)=18 or CInt(vIdperfil)=19 or CInt(vIdperfil)=6 or CInt(vIdperfil)= 27 Then
      session("usxp011")= "Promotor de Ventas Kits" 
      conn.close
      response.redirect "frames.asp"
     end if

End if

%>