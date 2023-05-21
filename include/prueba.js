// JScript source code
function newVentana()
{   var contenedor;
	var tabla;
	var tr;
	var td;
	var cerrar;
	var contenido;
	var body;
		
	try
	{   contenedor = document.createElement('DIV'); 
		contenedor.id="contenedor"
			
		tabla = document.createElement('Table')
		tabla.cellspacing=0
		tabla.cellpadding=0
		tabla.width='100%'
			
		tr = document.createElement('tr')
			
		td = document.createElement('td')
		td.width='100%'
			
		cerrar = document.createElement('DIV')
		cerrar.id='Cerrar'
		cerrar.onmouseOver="this.style.cursor = 'pointer'"
		cerrar.onmouseOut="this.style.cursor = 'none'"
		cerrar.onClick="javascript:ocultarVentana()"
		cerrar.innerHTML = '<img src="../images/cerrar.gif">'
			
		td.appendChild(cerrar)
		tr.appendChild(td) 
		tabla.appendChild(tr)
			
		tr = document.createElement('tr')
		td = document.createElement('td')
			
		contenido = document.createElement('DIV')
		contenido.id='contenido'
		contenido.innerHTML = ''
			
		td.appendChild(contenido)
		tr.appendChild(td)
		tabla.appendChild(tr)
		contenedor.appendChild(tabla)

		body = document.getElementsByTagName('Body')[0]
		body.appendChild(contenedor)
		
		var popup = document.createElement('DIV')
		popup.id='popup'
		popup.innerHTML = document.getElementById('contenedor').innerHTML
		
		body = document.getElementsByTagName('Body')[0]
		body.appendChild(popup)
		
		body.removeChild(contenedor)
	}
	catch(e)
	{ 
	}
	
}

function ocultarVentana()
{ document.getElementById('popup').style.visibility='hidden'
}

function mensaje(pos)
{ var cadena;
  var bodys;
  var scrollTop;
  var altoCliente;
  var top;
  var popup = document.getElementById("popup")
  var altoPopup = parseInt(document.getElementById("popup").offsetHeight)
  
  cadena = "Ultimo punto de venta al que fue despachado : <br> <b>" + pos +"</b>"
  document.getElementById('contenido').innerHTML = cadena
  document.getElementById('popup').style.visibility='visible'
  
  bodys = document.getElementsByTagName('BODY')[0]
  scrollTop = parseInt(bodys.scrollTop)
  
  altoCliente= parseInt(document.body.clientHeight)
  top = (altoCliente/2)-(altoPopup/2) + scrollTop
  
  popup.style.top = top
  popup.style.left = (document.body.clientWidth/2)-(popup.offsetWidth/2)
  
}

function mostrarHand(objecto)
{ objecto.style.cursor='pointer'
}

function ocultarHand(objecto)
{ objecto.style.cursor='none'
}
