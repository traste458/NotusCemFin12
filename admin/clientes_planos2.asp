<%@ LANGUAGE="VBScript" %>
<!--#include file="../include/seguridad.inc.asp"-->
<!--#include file="../include/conexion.inc.asp"-->
<% Response.Buffer=True %>
<%
Server.ScriptTimeout = 800

region = session("usxp_region")
if region = "" then
  conn.close
  response.write "<center><font color=red size=3 face=arial>La Región no puede ser vacia</font></center>"
  response.end
end if

' Option Explicit   
Dim upl, NewFileName, objFSO, objTStream, intLineNum, cadena, linea
Set upl = Server.CreateObject("ASPSimpleUpload.Upload") 
 
If Len(upl.Form("File1")) < 1 Then 
  response.write ("<center><font color=red face=arial size=4>El Campo de archivo va vacio</font></center>")
  conn.close
  response.end
end if
 
' borramos los datos de la tabla temporal. Sirve si no hay concurrencia.
sql = "delete from planos_clientes"
 conn.execute(sql)

' buscamos el idplano
sql=" update secuencias set numero = numero+1 where secuencia = 'planos'"
 set rs=conn.execute(sql)    

sql = "select numero from secuencias where secuencia='planos'"
 set rs=conn.execute(sql)
idplano=cdbl(rs("numero")) 
arc_cliente = upl.ExtractFileName(upl.Form("File1"))
wplano = "clientes_" & idplano &".txt"

' insertamos el registro del detalle del plano 
sql="insert into planosdetalle (idplano,plano,idtercero,tipo) values "
sql = sql & " ( "& idplano &",'"& wplano &"',"& session("usxp001")&",'clientes')"
 set rs=conn.execute(sql)    

nuevo_archivo = "../archivos_planos/" & wplano
If upl.SaveToWeb("File1", nuevo_archivo) Then 
  Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
  wplano=session("path_planos")&wplano
  Set objTStream = objFSO.OpenTextFile(wplano) ' abrimos el archivo para lectura 
  i=1
  werror_plano = "N"
  Do While Not objTStream.AtEndOfStream
    wexiste = "N"
    cadena = objTStream.ReadLine
    cadena = trim(replace(cadena,"'"," "))
    'response.write "<font color=blue>Lin:" & i &"--> "& cadena & "</font><br>"
    if trim(cadena) <> "" then
      matriz = Split(cadena,"/")
'response.write Ubound(matriz)
'response.end
      if Ubound(matriz) <> 5 then
        error="Registro con numero de campos incorrecto"  
        consecutivo= i
        sql="insert into errores_planos (iderror,error,idplano,consecutivo) "
        sql = sql & " values (1,'"& error &"',"& idplano & ","& consecutivo &")"
'response.write (sql)&"<hr>"
         set rs = conn.execute(sql)     
      else
        cliente = trim(matriz(2))
        ciudad = trim(Ucase(matriz(3)))
        if cliente = "" then
          cliente = "null"

        else
          cliente = "'"&cliente&"'"
        end if  
        ' buscamos el idciudad para cada registro
        if ciudad = "SANTAFE DE BOGOTA" then
          ciudad = "BOGOTA"
        end if  
        sql = "select idciudad from ciudades where rtrim(upper(ciudad))='"&ciudad&"'"
         set rs=conn.execute(sql)
        if rs.eof then
          idciudad = 1074 'ciudad desconocida
        else
          idciudad = rs("idciudad")
        end if
        ' insertamos el regsitro en la tabla temporal
        sql = "insert into planos_clientes (idplano,consecutivo,idcliente2,dealer,cliente,idciudad,direccion,telefono,region)"        
        sql = sql & " values (" & idplano & ",'" & i & "','" & matriz(0) & "','"
        sql = sql & matriz(1) & "',"& cliente &"," & idciudad & ",'" & matriz(4) & "','" & matriz(5) & "','"& region &"')"
'response.write sql&"<hr>"
         set rs=conn.execute(sql)
      end if  'fin del if matriz(7) o mas campos de los necesarios    
      i=i+1
    end if 'Fin  If de Cadena Vacia
  Loop
  objTStream.Close
  ' Actualizamos el registro del plano con el numero de registros insertados en la tabla temp.
  sql="update planosdetalle set registros="& i-1 &"where idplano="&idplano
   set rs=conn.execute(sql)
  'response.end
  response.redirect("clientes_planos3.asp?idplano="&idplano)
Else
  response.write "<center><font color=red face=arial size=4>Hubo un error al Subir su archivo al servidor.</font></center>"
  conn.close
End If
%>