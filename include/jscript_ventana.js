var unidadUbicacionPantalla = 'px'; //Especificamos las unidad de ubicación en pantala (px=pixeles)
var objBody,  objMascara, objContenedorVentana, objVentana;  //Variables para manejar los objectos usados para el efecto.
var objaMostrar;  //Variable en donde almacenamos la referencía del objecto desplegado en el area de información de la ventana.
var navegador,objLoader
/***** Función que genera la mascara oscura que queda sobre la pagina actual. *****/

function getMascara()
{ var objMascara;
  /***** Creamos el objecto que nos servira de mascara (DIV) *****/
  objMascara = document.createElement("DIV");
  /***** Asignamos las propiedades al objecto que nos servira de mascara. *****/
  objMascara.id = "divMascara";
  /***** Asignamos el ancho y el alto de la mascara ocupara todo el area de trabajo del cliente *****/
   //Ancho
     objMascara.style.width = String(getWidthClient()) + unidadUbicacionPantalla;
   //Alto
    objMascara.style.height = String(getHeightClient()) + unidadUbicacionPantalla;
  /*****/
  objMascara.style.display = "none";
  return (objMascara);
}

/***** Función que retorna el contenedor de la ventana que colocaremos encima de la mascara oscura ******/
function getContenedorVentana()
{ var objContenedorVentana;
  /****** Creamos el objecto (DIV) que nos servira de contenedor de la ventana y que colocaremos sobre la mascara *****/
  objContenedorVentana = document.createElement("DIV");
  /***** Asignamos el id con el cual identificaremos al objecto *****/
  objContenedorVentana.id="divContenedorVentana";
  /***** Asignamos el ancho y el alto del contenedor de la ventana *****/
   //Ancho
     objContenedorVentana.style.width = String(getWidthClient()) + unidadUbicacionPantalla;
   //Alto
    objContenedorVentana.style.height = String(getHeightClient()) + unidadUbicacionPantalla;
  /*****/
  objContenedorVentana.style.display = "none";
  return (objContenedorVentana);
}

/***** Función que devuelve el objecto ventana en el cual mostraremos información.  *****/
function getVentana()
{ try 
  { var objVentana,objBarra,objAreaInformacion,objTitulo,objCerrar,objImagenCerrar;
	/***** Creamos la ventana que contendra la barra  y el area para desplegar información *****/
	objVentana = document.createElement("DIV");
	/***** Creamos la barra de la ventana *****/
	objBarra = document.createElement("DIV");
	/***** Creamos el objecto donde desplegaremos el titulo de la ventana ****/
	objTitulo = document.createElement("DIV");
	objTitulo.id="divTitulo";
	/***** Creamos el objecto donde pondremos la imagen para cerrar *****/
	objCerrar = document.createElement("DIV");
	//le creamos el evento on click al div y la imagen se la añadimos por CSS
	objCerrar['onclick']=new Function("ocultarVentana()");
	objCerrar.id="divCerrar";
	/***** Creamos el objeto image en donde mostraremos la imagen de cerrar *****/
	
/*xxxxx______  no sirve la img cuando la pagina esta un un path diferente_____--xxxxxxxxxx
	objImagenCerrar = document.createElement("IMG");	
	/***** Especificamos la ruta donde esta la imagen almacenada. *****/
	//objImagenCerrar.src = "../images/close.png"
	/***** Definimos el evento para cuando se le haga click al cerrar *****/
	//objImagenCerrar.onclick = function(){
//	                           ocultarVentana()
//	                          };
/*xxx_____

	/***** Agregamos la imagen al div donde la mostraremos *****/
	//objCerrar.appendChild(objImagenCerrar);
	/*****Agregamos los objetos div de titulo e imagen a la barra *****/
	objBarra.appendChild(objTitulo);
	objBarra.appendChild(objCerrar);
	//objBarra.setAttribute("onmousedown","comienzoMovimiento(event, 'divVentana')");  //esta linea solo funciona si soporta gecko, es Mozilla, Netscape, Safari, etc
	objBarra['onmousedown']=new Function("comienzoMovimiento(event, 'divVentana')");//esta linea solo funciona en iexplorer :p
	/***** Creamos el objeto div para 
	/***** Creamos el area de información de la ventana *****/
	objAreaInformacion = document.createElement("DIV")
	/***** Definimos las propiedas de los objetos antes creados *****/
	//id de los objetos para referenciarlos.
		objVentana.id="divVentana"
		objBarra.id="divBarra"
		objAreaInformacion.id="divAreaInfo"
  	
	/**** Agregamos los objetos a la ventana *****/
	objVentana.appendChild(objBarra);
	objVentana.appendChild(objAreaInformacion);
    
	return (objVentana);
  }catch(e)
   { alert(e.message + e.line);
   }
}

/***** Función que une todos los objectos para generar el efecto. *****/
function crearAreaMostrado()
{ /***** Obtenemos la referencía del objecto body de la pagina. *****/
  objBody=document.getElementsByTagName('BODY')[0];
  /***** Obtenemos la mascara de color oscuro de fondo *****/
  objMascara = getMascara();
  /***** Obtenemos el contenedor de la ventana *****/
  objContenedorVentana = getContenedorVentana();
  /***** Obtenemos el objeto ventana que agregaremos al contenedor de esta para desplegar en la ventana info ****/
  objVentana = getVentana();
  objLoader=getLoader();
  /***** Asignamos al objecto contenedor la ventana la cual desplegaremos en esta *****/
  objContenedorVentana.appendChild(objVentana);
  objContenedorVentana.appendChild(objLoader);
  
  /***** Agremamos los objectos a la pagina la mascara y el contenedor de la ventana *****/
  objBody.appendChild(objMascara);
  objBody.appendChild(objContenedorVentana);
  carga();
}

/***** Función para obtener el ancho del area de trabajo del cliente. *****/
function getWidthClient()
{  //Para navegadores como firefox
   if (document.compatMode=='CSS1Compat') 
   { return document.documentElement.clientWidth;
   }
   //Para navegadores como internet explorer
   if (document.body) 
   { return document.body.clientWidth;
   }
}

/***** Función para obtener el alto del area de trabajo del cliente *****/
function getHeightClient()
{  //Para navegadores como firefox
   if (document.compatMode=='CSS1Compat') 
   { return document.documentElement.clientHeight;
   }
   //Para navegadores como internet explorer
   if (document.body) 
   { return document.body.clientHeight;
   }
}

/***** Función para mostrar la ventana junto con el efecto desplegando el objeto que querramos mostrar en el area de información *****/
function mostrarVentana(ancho,alto,objMostrar)
{ var objAreaInformacion, objBarra, altoBarraVentana;
  try
  {     objMascara.style.display = "block";
        objContenedorVentana.style.display = "block";
        /*** agrego enventos para mover la ventana ****/	
  	
     /***** Asignamos a la ventana las dimensiones solicitadas por el usuario *****/
     objVentana.style.width = String(ancho) + unidadUbicacionPantalla;
     objVentana.style.height = String(alto) + unidadUbicacionPantalla;
    /*****  Calculamos la dimensiones del div del area de información de la ventana  *****/
     //Obtenemos la referencía del div que manejara el area de información de la ventana.
       objAreaInformacion = document.getElementById("divAreaInfo");
     //Obtenemos la referencia del div que maneja la barra de la ventana.
       objBarra = document.getElementById("divBarra");
     //Guardamos en una variable el alto de la barra de la ventana.     
       altoBarraVentana = parseInt(objBarra.offsetHeight,10);
     //El ancho del area de información es igual al ancho de la ventana pero ya viene especificado asi en el estilo de esta.
     //El alto del area de información es igual a el alto de la ventana menos el alto de la barra de la ventana.
       objAreaInformacion.style.height = (alto - altoBarraVentana) + unidadUbicacionPantalla;
       
    /*****/
    /***** Removemos el primer hijo del div que es el objecto que hemos mostrado *****/
  
    while (objAreaInformacion.firstChild){   
            //document.body.appendChild(objAreaInformacion.removeChild(objAreaInformacion.firstChild));            
            document.body.getElementsByTagName("form").item(0).appendChild(objAreaInformacion.removeChild(objAreaInformacion.firstChild));            
     }    
    
    /***** Mostramos en el area de información de la ventana el objeto especificado *****/
    objaMostrar = objMostrar
    objAreaInformacion.appendChild(objaMostrar);          
    /***** Centramos la ventana en el area utilizada por el cliente *****/
    centrarVentana(objVentana);
    /*****  Mostramos la mascara del efecto del fondo oscuro y el contenedor que despliega la ventana ****/
    objMascara.style.visibility = 'visible';
    objContenedorVentana.style.visibility = 'visible';
    objaMostrar.style.visibility='visible';

  }catch(e)
   { alert(e.message);
   } 
}

/***** Función para centrar la ventana en el contenedor de esta *****/
function centrarVentana(objVentana)
{ 

try
  { var scrollTop,scrollLeft;      //Variables para almacenar la posición de scroll.
	var ventanaAlto,ventanaAncho; //Variables para almacenar el ancho y el alto de la ventana.
	var clienteAncho,clienteAlto;//Variables para almacenar las dimensiones del area del cliente.
	var adicion = 20;  //Adicionamos 20 pixeles al alto de la mascara fondo negro para cuando suba o baje no se vea la linea blanca
	var miAlto = 850;
	/***** Asignamos la posición del scroll(x,y) a cada una de las variables donde las almacenaremos. *****/
	scrollTop  = parseInt(objBody.scrollTop,10);
	scrollLeft = parseInt(objBody.scrollLeft,10);
	/***** Almacenamos el ancho y el alto de la ventana *****/
	ventanaAlto = objVentana.offsetHeight;
	ventanaAncho = objVentana.offsetWidth;
	/***** Almacenamos las dimensiones del area del cliente *****/
	clienteAncho = getWidthClient();
	clienteAlto = getHeightClient();  
	/***** Asignamos las ubicaciones en (x,y) y el ancho y el alto de la mascara y el contenedor. *****/
		//(x,y)
		objMascara.style.top  = String(scrollTop - (adicion/2)) + unidadUbicacionPantalla;
		objMascara.style.left = String(scrollLeft) + unidadUbicacionPantalla;
		objContenedorVentana.style.top  = String(scrollTop - (adicion/2)) + unidadUbicacionPantalla;
		objContenedorVentana.style.left = String(scrollLeft) + unidadUbicacionPantalla;
	//Ancho y alto
		objMascara.style.width  = String(clienteAncho) + unidadUbicacionPantalla;
		objMascara.style.height = String(clienteAlto + adicion) + unidadUbicacionPantalla;
		objContenedorVentana.style.width  = String(clienteAncho) + unidadUbicacionPantalla;
		objContenedorVentana.style.height = String(clienteAlto + adicion) + unidadUbicacionPantalla;
	/***** Ubicamos la ventana en el centro del area del cliente *****/    
	objVentana.style.top = ((((clienteAlto - ventanaAlto) / 2))+60) + unidadUbicacionPantalla;
	objVentana.style.left =  (((clienteAncho - ventanaAncho) / 2)) + unidadUbicacionPantalla;
  }catch(e)
   { alert(e.message);
   }
}


/**** Función para ocultar la ventana y el efecto mostrado *****/
function ocultarVentana()
{ try
  {  /*****  Ocultamos la mascara del efecto del fondo oscuro y el contenedor que despliega la ventana ****/
    objMascara.style.visibility = 'hidden';
    objContenedorVentana.style.visibility = 'hidden';
    objaMostrar.style.visibility = 'hidden';
    objMascara.style.display = "none";
    objContenedorVentana.style.display = "none";
    limpiarObjectos(objaMostrar);
  }catch(e)
  { alert(e.message);
  }
}

/***** Función a traves de la cual limpiamos los estados de los objetos contenidos 
       dentro del objeto que mostramos en la ventana, limpiamos los estados de los objetos 
       de tipo TEXT, HIDDEN, SELECT.  ****/
function limpiarObjectos(objeto)
{ var objectosObtenidos = new Array();
  try
  { //Obtenemos todos los objectos de tipo INPUT del objecto contenedor.
    objectosObtenidos = objeto.getElementsByTagName("INPUT");
    //Recorremos todos los objetos encontrados y limpiamos el value de los tipos TEXT,HIDDEN y PASSWORD.
    for (var i = 0;i<objectosObtenidos.length;i++)
    { if(objectosObtenidos[i].type.toUpperCase() == "TEXT" || objectosObtenidos[i].type.toUpperCase() == "HIDDEN" || objectosObtenidos[i].type.toUpperCase() == "PASSWORD")
      { objectosObtenidos[i].value = "";
      }else{
        if(objectosObtenidos[i].type.toUpperCase() == "CHECKBOX" || objectosObtenidos[i].type.toUpperCase() == "RADIO")
        { objectosObtenidos[i].checked = false;
        }
      }
    }
    //Obtenemos todos los objectos de tipo SELECT del objecto contenedor.
    objectosObtenidos = objeto.getElementsByTagName("SELECT");
    //Recorremos todos los objetos encontrados y marcamos el valor seleccionado en el inicial que es cero.
    for (var i = 0;i<objectosObtenidos.length;i++)
    {  objectosObtenidos[i].selectedIndex=0;
    }
  }catch(e)
   { alert(e.message);
   }
}

//___________Funciones para MOVER la ventana __________

function carga()
{
	posicion=0; elMovimiento=null;
	
	// IE
	if(navigator.userAgent.indexOf("MSIE")>=0) navegador=0;
	// Otros
	else navegador=1;
}

function evitaEventos(event)
{
	// Funcion que evita que se ejecuten eventos adicionales
	if(navegador==0)
	{
		window.event.cancelBubble=true;
		window.event.returnValue=false;
	}
	if(navegador==1) event.preventDefault();
}

function comienzoMovimiento(event, id)
{

	elMovimiento=document.getElementById(id);
	
	/* Si el elemento que se le hizo click es texto (nodeType=3) se toma como target
	el elemento padre */
	if(elMovimiento.nodeType==3) elMovimiento=elMovimiento.parentNode;
	
	 // Obtengo la posicion del cursor
	if(navegador==0)
	 {
	 	cursorComienzoX=window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft;
		cursorComienzoY=window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop;

		document.attachEvent("onmousemove", enMovimiento);
		document.attachEvent("onmouseup", finMovimiento);
	}
	if(navegador==1)
	{    
		cursorComienzoX=event.clientX+window.scrollX;
		cursorComienzoY=event.clientY+window.scrollY;
		
		document.addEventListener("mousemove", enMovimiento, true); 
		document.addEventListener("mouseup", finMovimiento, true);
	}
	
	elComienzoX=parseInt(elMovimiento.style.left);
	elComienzoY=parseInt(elMovimiento.style.top);
	// Actualizo la posicion del elemento
	elMovimiento.style.zIndex=++posicion;	
	evitaEventos(event);
}

function enMovimiento(event)
{  
	var xActual, yActual;
	if(navegador==0)
	{    
		xActual=window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft;
		yActual=window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop;
	}  
	if(navegador==1)
	{
		xActual=event.clientX+window.scrollX;
		yActual=event.clientY+window.scrollY;
	}
	
	elMovimiento.style.left=(elComienzoX+xActual-cursorComienzoX)+"px";
	elMovimiento.style.top=(elComienzoY+yActual-cursorComienzoY)+"px";

	evitaEventos(event);
}

function finMovimiento(event)
{
	if(navegador==0)
	{    
		document.detachEvent("onmousemove", enMovimiento);
		document.detachEvent("onmouseup", finMovimiento);
	}
	if(navegador==1)
	{
		document.removeEventListener("mousemove", enMovimiento, true);
		document.removeEventListener("mouseup", finMovimiento, true); 
	}
}

/*funciones para preloader*/

function getLoader(){
  objLoader = document.createElement("DIV");
  objLoader.id = "divLoader";
  objLoader.style.display = "none";
  return (objLoader);
}
function mostrarLoader(){
/**** Almacenamos las dimensiones del area del cliente *****/
objMascara.style.display = "block";
objContenedorVentana.style.display = "block";
objLoader.style.display = "block"; 
objBody.scroll="no"   
centrarVentana(objLoader);
objMascara.style.visibility = 'visible';
objLoader.style.visibility = 'visible'; 
}
function ocultarLoader(){ 
objBody.scroll="yes"   
objMascara.style.visibility = 'hidden';
objContenedorVentana.style.visibility = 'hidden';
objLoader.style.visibility = 'hidden'; 
objMascara.style.display = "none";
objContenedorVentana.style.display = "none";
objLoader.style.display = "none";  }