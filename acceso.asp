<!--#include file="include/conexion.inc.asp"-->
<!--#include file="include/constantes.inc.asp"-->
<!--#include file="include/md5.asp"-->
<%  
	session("path")=server.mapPath("inf_excel") & "\" 
	session("path_planos")=server.mapPath("archivos_planos") & "\"
	
	usuario = trim(request.form("usuario"))
	clave = md5(trim(request.form("clave")))
	if usuario <> "" and clave <> "" then
		dim oCmd,oRs 
		Const adVarChar = 200

		set oCmd = Server.CreateObject("ADODB.Command")

		sql = "select idtercero,tercero,usuario,clave,ciudad,cargo,cliente,idciudad,idcargo,"
		sql = sql & "idcliente,idperfil,linea,idbodega from vi_terceros where usuario = ?"
		sql = sql & " and clave =? and estado = 1 and idarea in (" & AREASOPERACIONES & ")"
		'response.write sql
		'response.end

		set oRs = Server.CreateObject("ADODB.Recordset")

		with oCmd
			.ActiveConnection = conn
			.CommandText = sql
			.Parameters.Append(.CreateParameter("usuario",adVarChar,,30,usuario))
			.Parameters.Append(.CreateParameter("clave",adVarChar,,40,clave))
			set oRs = .Execute
		end with
		
		if oRs.eof then
			Response.Redirect("login.asp?err=true")
		else
			session("usxp001") = oRs("idtercero")
			session("usxp002") = oRs("tercero")
			session("usxp003") = oRs("cliente")
			session("usxp004") = oRs("cargo")
			session("usxp005") = oRs("ciudad")
			session("usxp006") = oRs("idcargo")
			session("usxp007") = oRs("idciudad")
			session("usxp008") = oRs("idcliente")
			session("usxp009") = oRs("idperfil")
			session("usxp010") = oRs("linea")
			session("usxp012") = oRs("idbodega")
			vIdPerfil = oRs("idperfil")
			session("usxp013") = vIdPerfil
			'redireccionamos a pagina aspx para levantar sesiones en .net
			direccionar = "idusuario=" & session("usxp001") & "&tercero=" & session("usxp002")
			direccionar = direccionar & "&cliente=" & session("usxp003") & "&cargo=" & session("usxp004")
			direccionar = direccionar & "&ciudad=" & session("usxp005") & "&idcargo=" & session("usxp006")
			direccionar = direccionar & "&idciudad=" & session("usxp007") & "&idcliente=" & session("usxp008") & "&idperfil=" & session("usxp009")
			direccionar = direccionar & "&linea=" & session("usxp010") & "&idbodega=" & session("usxp012")
			if CInt(vIdPerfil) = 1 then
				session("usxp011") = "Administrador Operativo"
			elseif CInt(vIdPerfil) = 2 then
				session("usxp011") = "Demo"
			elseif CInt(vIdPerfil) = 3 then
				session("usxp011") = "Gerencial"
			elseif CInt(vIdPerfil) = 4 then
				session("usxp011") = "Alta Gerencia" 
			elseif CInt(vIdPerfil) = 5 or CInt(vIdPerfil) = 11 then
				session("usxp011") = "Contingencia" 
			elseif CInt(vIdPerfil) = 7 or CInt(vIdPerfil) = 10 then
				session("usxp011") = "Devoluciones" 
			elseif CInt(vIdPerfil) = 8 then
				session("usxp011") = "Administrador Inventarios" 
			elseif CInt(vIdPerfil) = 9 then
				session("usxp011") = "Inventarios" 
			elseif CInt(vIdPerfil) = 12 then
				session("usxp011") = "Bodega" 
			elseif CInt(vIdPerfil) = 6 or CInt(vIdPerfil) > 12 then
				session("usxp011") = "Usuario BPCOLSYS"
			end if 
			oRs.close
			
			idUsuario = session("usxp001")
			
			forwardedIp = Request.ServerVariables("HTTP_X-Forwarded-For")
			if forwardedIp <> "" then
				ipAcceso = forwardedIp
			else
				ipAcceso = Request.ServerVariables("REMOTE_ADDR")
			end if
			
			sqlQuery = "EXEC RegistrarLogDeIngresoDeUsuarioAlSistema " & idUsuario & ", '" & ipAcceso & "','NotusIlsWeb'"
			conn.execute(sqlQuery)
			
			conn.close
			set conn = nothing
			
			response.redirect "acceso.aspx?" & direccionar
		End If
	Else
	    oRs.close
	    conn.close
		set conn = nothing
		response.redirect "login.asp"
	End If
%>