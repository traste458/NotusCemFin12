<%
Function getFormato(base,numeroDigitos) 
	   dim numeroCeros  
		 dim longitudBase
		 dim nuevaCadena
	
	   nuevaCadena = "" 
		 
		 longitudBase = len(cStr(base))
		 numeroCeros = cInt(numeroDigitos) - cInt(longitudBase)
		 
		 if cInt(numeroCeros) > 0 then
		    for indice = 1 to numeroCeros
				   nuevaCadena = nuevaCadena & "0"
				next
				nuevaCadena = nuevaCadena & base
		 else
		    nuevaCadena = base
		 end if	 
		 getFormato = nuevaCadena
	 End Function
%>


