function LimpiaFormulario() {
    if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
        ASPxClientEdit.ClearEditorsInContainerById('frmPrincipal');
    }
}

function validarSoloNumero(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;

    return true;
}
function EjecutarCallback(s, e) {
    cpGeneral.PerformCallback('CargarServicios' + ':' + '0');
}


function invocarCallBackServicio(s, e) {

    if (txtServicio.GetValue() != null && txtServicio.GetValue().length > 4) {
        cpGeneral.PerformCallback('CargarRadicado:'+ txtServicio.GetValue());
    }
}

function finalizarCallBackServicio(s, e) {

    if (LoadingPanel) { LoadingPanel.Hide(); }
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