String.prototype.trim = function () { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }

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

/*Función que permite obtener los valores correspondientes */
function SetWindowSize() {
    if (typeof (window.innerWidth) == 'number') {//Non-IE
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {//IE 6+ in 'standards compliant mode'
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {//IE 4 compatible
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }
}

function EjecutarCallbackGeneral(s, e, parametro, valor) {
    if (ASPxClientEdit.AreEditorsValid()) {
        LoadingPanel.Show();
        callback.PerformCallback(parametro + ':' + valor);
    }
}

function EjecutarCallbackGeneral(s, e, parametro, valor, control) {
    if (ASPxClientEdit.AreEditorsValid()) {
        loadingPanel.Show();
        control.PerformCallback(parametro + ':' + valor);
    }
}

function DescargarReporte() {
    window.location.href = 'DescargaDocumento.aspx?id=1';
}

function ActualizarEncabezado(s, e) {
    if (loadingPanel) { loadingPanel.Hide(); }
    if (s.cpMensaje) {
        if (document.getElementById('divEncabezado')) {
            document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
        }
    }
    if (s.cpMensajePopUp && mensajePopUp) {
        if (s.cpTituloPopUp) { mensajePopUp.SetHeaderText(s.cpTituloPopUp); }
        if (document.getElementById(textoMensajePopUp.name)) {
            document.getElementById(textoMensajePopUp.name).innerHTML = s.cpMensajePopUp;
            mensajePopUp.Show();
            s.cpMensajePopUp = null;
            s.cpTituloPopUp = null;
        }
    }
    if (s.cpLimpiarFiltros) { LimpiarFiltros(); }
}

function DialogCancelHandler(dlg, args) {
    if (args.keyCode == 27) {
        return false;
    }
}

/*Función que permite obtener los valores correspondientes */
function GetWindowSize() {
    var myWidth = 0, myHeight = 0;
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

    return myHeight + ";" + myWidth;
}

/*Función que permite detener la propagación de un evento lanzado sobre la página*/
function DetenerEvento(e) {
    if (!e) {
        if (window.event) { e = window.event; }
    }
    if (e.cancelBubble != null) { e.cancelBubble = true; }
    if (e.stopPropagation) { e.stopPropagation(); }
    if (e.preventDefault) { e.preventDefault(); }
    if (window.event) { e.returnValue = false; }
    if (e.cancel != null) { e.cancel = true; }
}

/*Función que permite cambiar el enfoque entre cajas de texto contenidas en una grilla. 
Requiere JQuery*/
function CambiarEnfoqueEnGrilla(ctrl) {
    var kCode = (event.keyCode ? event.keyCode : event.which);
    if (kCode.toString() == "13") {
        if ($(ctrl).parents("tr").next() != null) {
            var nextTr = $(ctrl).parents("tr").next();
            var inputs = $(ctrl).parents("tr").eq(0).find("input[type='text']");
            var idx = inputs.index(ctrl);
            nextTrinputs = nextTr.find("input[type='text']");
            if (nextTrinputs[idx] != null) {
                nextTrinputs[idx].focus();
                if (nextTrinputs[idx].type != "select-one") { nextTrinputs[idx].select(); }
            }
        }
        else {
            $(ctrl).focus();
            if ($(ctrl).type != "select-one") { $(ctrl).select(); }
        }
        DetenerEvento(event);
    }
}

/*Función que permite procesar el "Enter" proporcionado por el usuario al estar ubicado sobre un objeto particular*/
function ProcesarEnterGeneral(source, botonId) {
    var boton = document.getElementById(botonId);
    var kCode = (event.keyCode ? event.keyCode : event.which);
    if (kCode.toString() == "13") {
        DetenerEvento(event)
        boton.click();
    } else { source.focus(); }
}

/*Función que permite lanzar la validación de un grupo específico de validación y luego mostrar mensaje de confirmación*/
function ValidarDatosYMostrarConfirmacion(grupoValidacion, mensaje) {
    if (Page_ClientValidate(grupoValidacion)) {
        if (mensaje.length > 0) { return confirm(mensaje); }
        else { return true; }
    }
    return false;
}

function MostrarOcultarDivFloater(mostrar) {
    if (document.getElementById("divFloater")) {
        var valorDisplay = mostrar ? "block" : "none";
        var elDiv = document.getElementById("divFloater");
        elDiv.style.display = valorDisplay;
    }
}

function CallbackAfterUpdateHandler(callback, extraData) {
    try {
        if (document.getElementById("divFloater")) {
            MostrarOcultarDivFloater(false);
        }
    } catch (e) {
        alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
    }
}

function EstablecerMemoMaxLength(memo, maxLength) {
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

function OnInitPopUpControl(s, e) {
    ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
        if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
            s.Hide();
    });
}

function validarTr() {
    if (cmbUnidad.GetValue() == 1) {
        cpGeneral_rpAdministradorCliente_trCampania.style.display = 'none';
        cpGeneral_rpAdministradorCliente_trEstrategia.style.diplay = 'table-row';
    } else if (cmbUnidad.GetValue() == 2) {
        cpGeneral_rpAdministradorCliente_trCampania.style.display = 'table-row';
        cpGeneral_rpAdministradorCliente_trEstrategia.style.display = 'none';
    }
}

function SoloNumeros(e) {
    var key;
    if (window.event) { key = e.keyCode; }// IE
    else if (e.which) { key = e.which; }// Netscape/Firefox/Opera

    if (key < 48 || key > 57) { return false; }
    return true;
}

function Seleccionar(s, e) { s.SelectAll(); }

function LimpiaFormulario() {
    if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
        ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
    }
}

function UbicaPositivo() {
    if (cmbUbica.GetValue() == 1 && cmbEvidente.GetValue() == 1 && cmbDataCredito.GetValue() == 1) {
        cmbResultadoProceso.SetValue(1);
        imgAgrega.SetVisible(true)
    } else {
        cmbResultadoProceso.SetValue(2);
        imgAgrega.SetVisible(false)
    }
}

function UbicaNegativo() {
    cmbResultadoProceso.SetValue(2);
    imgAgrega.SetVisible(false)
}

function EvidentePositivo() {
    if (cmbUbica.GetValue() == 1 && cmbEvidente.GetValue() == 1 && cmbDataCredito.GetValue() == 1) {
        cmbResultadoProceso.SetValue(1);
        imgAgrega.SetVisible(true)
    } else {
        cmbResultadoProceso.SetValue(2);
        imgAgrega.SetVisible(false)
    }
}

function EvidenteNegativo() {
    cmbResultadoProceso.SetValue(2);
    imgAgrega.SetVisible(false)
}

function DataCreditoPositivo() {
    cmbResultadoProceso.SetEnabled(false);
    if (cmbUbica.GetValue() == 1 && cmbEvidente.GetValue() == 1 && cmbDataCredito.GetValue() == 1) {
        cmbResultadoProceso.SetValue(1);
        imgAgrega.SetVisible(true)
    } else {
        cmbResultadoProceso.SetValue(2);
        imgAgrega.SetVisible(false)
    }
}

function DataCreditoNegativo() {
    cmbResultadoProceso.SetValue(2);
    imgAgrega.SetVisible(false)
}

function AbrirModalProductos() {
    //TamanioVentana();
    var valor = txtNumIdentificacion.GetValue();
    dialogoServicio.PerformCallback('Inicial:' + valor);
    //dialogoServicio.SetSize(myWidth * 0.9, myHeight * 0.9);
    //dialogoServicio.SetSize(myWidth * 0.9, myHeight * 0.75);
    dialogoServicio.ShowWindow();
}