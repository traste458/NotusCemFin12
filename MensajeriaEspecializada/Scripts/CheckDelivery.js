Date.prototype.yyyymmdd = function () {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
    var dd = this.getDate().toString();
    return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]); // padding
};

function updateCheckDelivery(idDetalle) {
    CargarCallback(LoadingPanel, cpGeneral, 'ActualizarCheckDelivery' + '|' + idDetalle);
}

function ValidaNumero(e) {
    var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
    return ((tecla > 47 && tecla < 58) || tecla == 46);
}

function LimpiaFormulario() {
    if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
        ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
    }
}

function MostrarLoading() {
    if (ASPxClientEdit.ValidateGroup('Cargar')) {
        LoadingPanel.Show();
    }
}
function CargarCallback(s, e, param) {

    cpGeneral.PerformCallback(param);
}

function MostrarInfoEncabezado(s, e) {
    if (s.cpMensaje) {
        $('#divEncabezado').html(s.cpMensaje);
        $('#divPopMensaje').html(s.cpMensaje);
        if (s.cpMensaje.indexOf("lblError") !== -1 || s.cpMensaje.indexOf("lblWarning") !== -1 || s.cpMensaje.indexOf("lblSuccess") !== -1) {
            $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
        }
    }
    if (s.cpPopup) {
        popMensaje.Show();
    }
}

function FinCallbackGrid(mensajeGrid) {
    $('#divEncabezado').html(mensajeGrid);
}

function TamanioVentana() {
    if (typeof (window.innerWidth) == 'number' || window.innerHeight) {
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

$('document').ready(function () {
    $('#cerrarDireccion').click(function () {
        optenerDireccionMemo();
    });
});

$('document').ready(function () {
    $('#btnConfirmar').click(function () {
        optenerDireccionMemo();
    });
});

function checkSerialesDelivery(s, e) {
    CargarCallback(LoadingPanel, cpGeneral, 'CheckSerialesDelivery|' + 1);
    return false;
}

function checkSerialGridview(s,e) {
    if (e.htmlEvent.which == 13) {
        CargarCallback(LoadingPanel, cpGeneral, 'checkSerialGridview|' + 1);
        return false;
    }
    return false;
}

$("form").bind("keypress", function (e) {
    if (e.keyCode == 13) {
        return false;
    }
});