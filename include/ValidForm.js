/* - - - - - - - - - - - - - - - - - - - - - - -
 JavaScript
 viernes, 20 de mayo de 2005 9:10:26
 funcion para validar fechas
 - - - - - - - - - - - - - - - - - - - - - - - */
// Declaring valid date character, minimum year and maximum year
var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
  var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
  var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
  // February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
  for (var i = 1; i <= n; i++) {
    this[i] = 31
    if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
    if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr){
  var daysInMonth = DaysArray(12)
  var pos1=dtStr.indexOf(dtCh)
  var pos2=dtStr.indexOf(dtCh,pos1+1)
  var strDay=dtStr.substring(0,pos1)
  var strMonth=dtStr.substring(pos1+1,pos2)
  var strYear=dtStr.substring(pos2+1)
  strYr=strYear
  if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
  if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
  for (var i = 1; i <= 3; i++) {
    if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
  }
  month=parseInt(strMonth)
  day=parseInt(strDay)
  year=parseInt(strYr)
  if (pos1==-1 || pos2==-1){
    alert("El formato de fecha debe ser : dd/mm/yyyy")
    return false
  }
  if (strMonth.length<1 || month<1 || month>12){
    alert("Por favor ingrese un mes valido")
    return false
  }
  if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
    alert("Por favor ingrese un día valido")
    return false
  }
  if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
    alert("Por favor ingrese un año valido de 4 digitos entre "+minYear+" and "+maxYear)
    return false
  }
  if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
    alert("Por favor ingrese un fecha valida")
    return false
  }
return true
}

function ValidateForm(){
  var dt=document.frmSample.txtDate
  if (isDate(dt.value)==false){
    dt.focus()
    return false
  }
    return true
 }


 function CompareDates(date1, date2)
 {
 fecha_vector1 = date1.split("/");
 fecha_vector2 = date2.split("/");
 var resultado;
 if ((fecha_vector1[1] < fecha_vector2[1] ) || (fecha_vector1[2] < fecha_vector2[2]) )
 {
    //date2 menor que date1
    resultado = 1;
 }
 else
 {
    resultado = 0;
 }

 if ((resultado != 1) && ( fecha_vector1[1] == (fecha_vector2[1])) && (fecha_vector1[2] == (fecha_vector2[2])))
 {
    if (fecha_vector1[0] < fecha_vector2[0])
    {
        resultado = 1;
    }
    else
    {
        resultado = 0;
    }
 }
 return(resultado);
 }