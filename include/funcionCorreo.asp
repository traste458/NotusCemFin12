
<%
'Modificado por:   German Fernando Heredia Sánchez
'Fecha:						 20/12/2007
'ASUNTO:           Página con las funciones que permite enviar correos segun orden o requisición  

'									 

function enviarCorreo(titulo,asunto,destino,firma,contenidoCorreo,nota,rutaAttachment)
      cuerpo = " <HTML> "
      cuerpo = cuerpo & "   <HEAD>"
      cuerpo = cuerpo & "      <link rel='stylesheet' type='text/css' href='http://" & request.ServerVariables("SERVER_NAME") & "/bpcolsys_ar/include/styleBACK.css >"
      cuerpo = cuerpo & "      </HEAD>"
      cuerpo = cuerpo & "      <BODY class='cuerpo2'> "
      cuerpo = cuerpo & "     <table width='100%' border='0' align='center' cellpadding='5' cellspacing='0' class='tabla'"
      cuerpo = cuerpo & "        <tr> "
      cuerpo = cuerpo & "          <td width='20'><img src='http://" & request.ServerVariables("SERVER_NAME") & "/bpcolsys_ar/images/logo_trans.png'>"
      cuerpo = cuerpo & "          </td>"
      cuerpo = cuerpo & "          			<td align='center' bgcolor='#883485' width='80%'><font size='3' face='arial' color='white'><b>" & titulo & "</b></font></td>"
      cuerpo = cuerpo & "        </tr>"
      cuerpo = cuerpo & "      </table><br><br>"
			
			If hour(now) < 12 Then
				 cuerpo = cuerpo & "      <font class='fuente'>Buenos Días"
      ElseIf hour(now) > 18 Then
				 cuerpo = cuerpo & "      <font class='fuente'>Buenas Noches"
      Else
				 cuerpo = cuerpo & "      <font class='fuente'>Buenas Tardes"
      End If
			
		  cuerpo = cuerpo & "      <br><br>" & contenidoCorreo
					  cuerpo = cuerpo & "      <br><br>	<font class='fuente'>Cordial Saludo,<br>" 
      cuerpo = cuerpo & "     		<br><b>" & firma & "</b><br><br>"
      cuerpo = cuerpo & "  </font><br><br><br><br><br>"
			If nota <> "" Then
				       cuerpo = cuerpo & "	</font><font class='fuente' size='1'><i>Nota: " & nota & ".</i></font></font> "
			end if
     	cuerpo = cuerpo & "    </body></HTML>"
			
			Set myMail = CreateObject("CDO.Message")
			if rutaAttachment <> "" then
				        myMail.AddAttachment(rutaAttachment)
			end if 
      myMail.Subject = asunto
      myMail.From = EMAIL_NOTIF
      myMail.To = destino
			myMail.HTMLBody = cuerpo
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
      'Name or IP of remote SMTP server
      myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = MAILSERVER
      'Server port
      myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
      myMail.Configuration.Fields.Update
      myMail.Send
			Set myMail = Nothing


end function

%>
