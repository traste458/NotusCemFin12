
<%

'----------------------------------------------------------------
'   Archivo de Funciones
'----------------------------------------------------------------

'------------
' Funcion de Reemplazo de Carateres
'------------

function reemplazar_espacios(cadena)

While(InStr(cadena, "  ") > 0)
cadena = replace(cadena, "  ", " ")
wend
reemplazar_espacios = cadena
end function

sub liberarMIN(tipoFactura,idUsuario,MIN,errorGenerado,conn)
dim rsFactura 

rsFactura = Server.CreateObject ("ADODB.RecordSet")

select case tipoFactura
	case "KP"
		facturaCambio ="facturas_kits"
		sqlUpdate = "select factura,Transaccion as idVenta from " & facturaCambio & " where [min] = '" & min & "'"
	case "WB"
		facturaCambio ="facturas_kits_wb"
		sqlUpdate = "select factura,Transaccion as idVenta from " & facturaCambio & " where [min] = '" & min & "'"
	case "PP"
		facturaCambio ="facturas_postpago"
		sqlUpdate = "select factura,idVenta from " & facturaCambio & " where [min] = '" & min & "'"
	case "PW"
		facturaCambio ="facturas_postpago_wb"
		sqlUpdate  = "select factura,idVenta from " & facturaCambio & " where [min] = '" & min & "'"
end select 

set rsFactura = conn.execute(sqlUpdate)

if not rsFactura.EOF then 
	transaccionmin = rsFactura("idVenta")
	facturamin = rsFactura("factura")
	if conn.state = 0 then conn.open 
	  on error resume next
	  conn.BeginTrans
	sqlUpdate = "update " & facturaCambio & " set [min] = null where transaccion = " & transaccionmin &" and [min] = '" & min & "'"  		 
	conn.execute (sqlUpdate)
	call manejarErrores(conn,errorGenerado,nothing)
	
	sqlUpdate = "update LogFacturasConMinLiberado set idUsuario=" & idUsuario & " where factura = '" & facturamin & "' and transaccion = " & transaccionmin &" and [min] = '" & min & "'"
	conn.execute (sqlUpdate)
	call manejarErrores(conn,errorGenerado,nothing)
	conn.CommitTrans
else
	errorGenerado ="No se Encuentra la Factura para el MSISDN"
end if 
end sub
sub manejarErroresLiberarMIN(oConn,errorGenerado,rsActivo)
  if Err.number<>0 then 'Ocurrió un error y se debe devolver la transacción
    errorGenerado ="No se pudo liberar el MSISDN " & Err.Description
    if not rsActivo is nothing then rsActivo.close

    oConn.RollbackTrans
    oConn.close
    set oConn = nothing
   end if
end sub

%>