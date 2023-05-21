/* Author: Beltrán, Diego
Create date: 08/08/2014
Description: Función que permite ajustar el tamaño de las ventanas emergentes POP-UP*/

function TamanioVentana() {
    if (typeof (window.innerWidth) == 'number') {
        //Non-IE
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
        //IE 6+ in 'standards compliant mode'
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
        //IE 4 compatible
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }
}

/*Author: Beltrán, Diego
Create date: 08/08/2014 
Función que permite ejecutar el evento de callback para un popup y realizar el evento + .Show
Recibe los siguientes parametros: element(objeto), key(parametro "llave"), action(acción a realizar), Width(ancho tamaño), Height(largo tamaño) */

function CallbackvsShowPopup(element, key, action, Width, Height) {
    TamanioVentana();
    element.PerformCallback(action + ':' + key)
    element.SetSize(myWidth * Width, myHeight * Height);
    element.ShowWindow();
}

/*Author: Beltrán, Diego
Create date: 08/08/2014 
Función que permite ejecutar el evento de callback para un objeto y realizar el evento + .Show en un popup
Recibe los siguientes parametros: element(objeto al cual se realiza el callback), element(objeto Popup), key(parametro "llave"), action(acción a realizar), Width(ancho tamaño), Height(largo tamaño) */

function CallbackObjectvsShowPopup(object, element, key, action, Width, Height) {
    TamanioVentana();
    object.PerformCallback(action + ':' + key)
    element.SetSize(myWidth * Width, myHeight * Height);
    element.ShowWindow();
}

/*Author: Beltrán, Diego
Create date: 08/08/2014 
Función que permite ejecutar el evento de callback general
Recibe los siguientes parametros: LoadingPanel(LoadingPanel), object(elemento a realizar callback), parametro(acción a realizar), valor(key) */
function EjecutarCallbackGeneral(LoadingPanel, object, parametro, valor) {
    //if (ASPxClientEdit.AreEditorsValid()) {
    //LoadingPanel.Show();
    object.PerformCallback(parametro + ':' + valor);
    //}
}


/*Author: Beltrán, Diego
Create date: 08/08/2014 
Función que permite ejecutar el evento de callback general*/
function FinalizarCallbackGeneral(s, e, control) {
    if (ASPxClientEdit.AreEditorsValid()) {
        $('#' + control).html(s.cpMensaje);
    }
}

/*Author: Beltrán, Diego
Create date: 11/08/2014 
Función que permite ocultar o mostrar un control, según su posición actual
Recibe los siguientes parametros: control(Objeto)*/
function toggle(control) {
    $("#" + control).slideToggle("slow");
}

/*Author: Beltrán, Diego
Create date: 26/08/2014 
Función que permite limpiar los datos del formulario
Recibe los siguientes parametros: control(Id del formulario)*/
function LimpiaFormulario(control) {
    if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
        ASPxClientEdit.ClearEditorsInContainerById(control);
    }
}
/*Author: Beltrán, Diego
Create date: 21/09/2014 
Función que permite abrir un Popup y que este contenga la función ContentUrl
Recibe los siguientes parametros: control(Id del Popup),url(dirección de la página que va a contener el control)*/
function PopUpSetContenUrl(control, url, Width, Height) {
    TamanioVentana();
    control.SetContentHtml("");
    control.SetSize(myWidth * Width, myHeight * Height);
    control.SetContentUrl(url)
    control.ShowAtElement(control.GetMainElement());
    //control.ShowWindow(control.GetWindow(0));
}


/*Author: Beltrán, Diego
Create date: 08/08/2014 
Función que permite ejecutar cerrar una ventana Popup
Recibe los siguientes parametros: element(objeto)*/

function PopUpSetHidle(element) {
    element.PopUpSetHidle();
}

/*Author: Beltrán, Diego
Create date: 22/09/2014 
Función que permite retornar la cantidad máxima de registros en un control 
Recibe los siguientes parametros: memo(nombre control),maxLength(cantidad máxima de registros permitidos)*/
function SetMaxLength(memo, maxLength) {
    if (!memo)
        return;
    if (typeof (maxLength) != "undefined" && maxLength >= 0) {
        memo.maxLength = maxLength;
        memo.maxLengthTimerToken = window.setInterval(function () {
            var text = memo.GetText();
            if (text && text.length > memo.maxLength)
                memo.SetText(text.substr(0, memo.maxLength));
        }, 10);
    } else if (memo.maxLengthTimerToken) {
        window.clearInterval(memo.maxLengthTimerToken);
        delete memo.maxLengthTimerToken;
        delete memo.maxLength;
    }
}

/*Author: Beltrán, Diego
Create date: 18/11/2014 
Función que permite realizar la función "window.location.href", en dependencia de la url asignada
Recibe los siguientes parametros: url(url de la página)*/
function WindowLocation(url) {
    window.location.href = url;
}