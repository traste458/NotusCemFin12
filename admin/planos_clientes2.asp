<%@ LANGUAGE="VBScript" %>
<% 'Response.Buffer=True %>
<!--#include file="../include/conexion.inc.asp"-->
<%
Server.ScriptTimeout = 800

' Option Explicit   
 Dim upl, NewFileName, objFSO, objTStream, intLineNum, cadena, linea
 Set upl = Server.CreateObject("ASPSimpleUpload.Upload") 
 
   
If Len(upl.Form("File1")) > 0 Then 
 
  sql=" update secuencias set numero = numero+1 where secuencia = 'planos'"
    set rs=conn.execute(sql)    
'    response.write sql & "<br>"

  sql = "select numero from secuencias where secuencia='planos'"
  set rs=conn.execute(sql)
  idplano=cdbl(rs("numero")) 

  arc_cliente = upl.ExtractFileName(upl.Form("File1"))
'  response.write "<font color=red>Usted subio desde su cliente :" & arc_cliente & "</font><br> 

  wplano = "clientes_" & idplano &".txt"
    'response.write "wplano:" & wplano & "<br>"

  sql="insert into planosdetalle (idplano,plano,idtercero,tipo) values "
  sql = sql & " ( "& idplano &",'"& wplano &"',"& session("usxp001")&",'clientes')"
    set rs=conn.execute(sql)    
'   response.write sql & "<br>"

  i=0
  r=0
  nuevo_archivo = "../archivos_planos/" & wplano
  If upl.SaveToWeb("File1", nuevo_archivo) Then         
   'response.Write("Archivo Escrito: <br>")  
    Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
    wplano=session("path_planos")&wplano
    'response.write "wplano:" & wplano & "<br>"
   Set objTStream = objFSO.OpenTextFile(wplano) 'ForReading 
    linea=0
    werror_plano = "N"
    Do While Not objTStream.AtEndOfStream
      linea = linea+1
      wexiste = "N"
      cadena = objTStream.ReadLine
      cadena = replace(cadena,"'"," ")	  
      ' response.write "<font color=blue>Lin:" & linea &"--> "& cadena & "</font><br>"
      if trim(cadena) <> "" then
        matriz = Split(cadena, "/", -1, 1)
             ciudad = trim(Ucase(matriz(3)))
             if ciudad = "SANTAFE DE BOGOTA" then
               ciudad = "BOGOTA"
             end if  
             sql = "select idciudad from ciudades where rtrim(upper(ciudad))='"&ciudad&"'"
'response.write sql
'response.end
             set rs=conn.execute(sql)
             if rs.eof then
               idciudad = 1074
             else
               idciudad = rs("idciudad")
	     end if
             sql = "insert into planos_clientes (idplano,consecutivo,idcliente2,dealer,cliente,idciudad,direccion,telefono)"        
             sql = sql & " values (" & idplano & ",'" & i & "','" & matriz(0) & "','"
             sql = sql & matriz(1) & "','" & matriz(2) & "'," & idciudad & ",'" & matriz(4) & "','" & matriz(5) & "')"
             set rs=conn.execute(sql)
	    response.write sql & "<br>"
'response.end
	     i=i+1
     end if 'Fin  If de Cadena Vacia
    Loop
    objTStream.Close
      sql="update planosdetalle set registros="& i &"where idplano="&idplano
      set rs2=conn.execute(sql)
'response.end
       response.redirect("planos_clientes3.asp?idplano="&idplano)
  Else
    Response.Write("Hubo un error al Subirlo") 
  End If

else
         Response.Write("El campo va Vacio") 
End If 

%>
</body>
</html>
