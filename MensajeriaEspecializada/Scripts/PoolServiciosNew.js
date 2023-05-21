document.getElementById("trTransportadora").style.display = "none";
document.getElementById("trMotorizado").style.display = "none";

function verServicio(idServicio, idTiposervicio) {
    if (idTiposervicio == 2) {
        PopUpSetContenUrl(pcGeneral, 'VerInformacionServicioTipoVenta.aspx?idServicio=' + idServicio, '0.9', '0.9');
    }
    else if (idTiposervicio == 8) {
        PopUpSetContenUrl(pcGeneral, 'VerInformacionServicioTipoSiembra.aspx?idServicio=' + idServicio, '0.9', '0.9');
    }
    else if (idTiposervicio == 12 || idTiposervicio == 15) {
        PopUpSetContenUrl(pcGeneral, 'VerInformacionServicioTipoVentaCorporativa.aspx?idServicio=' + idServicio, '0.9', '0.9');
    }
    else if (idTiposervicio == 32) {
        PopUpSetContenUrl(pcGeneral, 'VerInformacionServicioDelivery.aspx?idServicio=' + idServicio, '0.9', '0.9');
    }
    else {
        PopUpSetContenUrl(pcGeneral, 'VerInformacionServicio.aspx?idServicio=' + idServicio, '0.9', '0.9');
    }
    pcGeneral.RefreshContentUrl();
}
function OnMotorizadoChanged(cmbMotorizado) {
    EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'ObtenerDatosTransportador', cmbMotorizado.GetValue().toString());
}
function mostrarCamposTipoTransporte(s, e) {
    
    var tipoTransporte = s.GetSelectedItem().value;
    if (tipoTransporte == "trMotorizado") document.getElementById("trTransportadora").style.display = "none";
    if (tipoTransporte == "trTransportadora") document.getElementById("trMotorizado").style.display = "none";
    document.getElementById(tipoTransporte).style.display = "table-row";
}

function AsignarTransportador(){
    if (txtPlacaMotorizado.GetValue() != null || txtPlacaTransportadora.GetValue() != null) {
        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'AsignarTransportadorDelivery', lblIdDelivery.GetValue());
    }else {
        alert('Debe ingresar la placa.');
        return false;
    }
}

function AsignarTransporte(idServicio, idTiposervicio) {

    if (idTiposervicio == 32) {
        
        document.getElementById("trTransportadora").style.display = "none";
        document.getElementById("trMotorizado").style.display = "none";

        cmbMotorizado.SetValue("");
        lblIdDelivery.SetText(idServicio);
        txtMotorizado.SetValue("");
        txtPlacaMotorizado.SetValue("");
        cmbTipoTransporte.SetValue("");  
        cmbTransportadora.SetValue("");  
        txtNumeroGuia.SetValue("");  
        txtNombreTransportadora.SetValue("");  
        txtCedulaTransportadora.SetValue("");  
        txtPlacaTransportadora.SetValue(""); 

        pcAsignarTransporte.Show();
        pcAsignarTransporte.Refresh();
    }
}
function NotificarNoCobertura(idServicio, idTiposervicio) {
    if (idTiposervicio == 32) {
        if (confirm("Esta seguro de notificar no cobertura")) {
            EjecutarCallbackGeneral(LoadingPanel, cpGeneral, "NotificarNoCobertura", idServicio);
        } else {
            return false;
        }
    }
}

function invocarCallBackMotorizado(s, e) {

    if (txtMotorizado.GetValue() != null && txtMotorizado.GetValue().length > 2) {
        cpFiltroMotorizado.PerformCallback(txtMotorizado.GetValue()+":"+lblIdDelivery.GetText());
    }
}
function finalizarCallBackMotorizado(s, e) {

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

function ConfirmarServicio(idServicio, idTiposervicio) {
    if (idTiposervicio == 2) {
        WindowLocation('ConfirmacionServicioTipoVenta.aspx?idServicio=' + idServicio);
    }
    else if (idTiposervicio == 8) {
        WindowLocation('ConfirmacionServicioTipoSiembra.aspx?idServicio=' + idServicio);
    }
    else if (idTiposervicio == 12 || idTiposervicio == 15) {
        WindowLocation('ConfirmacionServicioTipoVentaCorporativa.aspx?idServicio=' + idServicio);
    }
    else {
        WindowLocation('ConfirmacionServicio.aspx?idServicio=' + idServicio);
    }
}

function DespachoServicio(idServicio, idTiposervicio) {
    if (idTiposervicio == 8) {
        WindowLocation('AlistamientoSerialesSiembra.aspx?idServicio=' + idServicio);
    } else if (idTiposervicio == 32) {
        WindowLocation('CheckDelivery.aspx?idServicio=' + idServicio);
    }
    else {
        WindowLocation('DespacharSerialesServicioMensajeria.aspx?idServicio=' + idServicio);
    }
}

function AsignarZona(idServicio, idTiposervicio) {
    WindowLocation('AsignarZonaServicioMensajeria.aspx?idServicio=' + idServicio);
}

function ModificarServicio(idServicio, idTiposervicio) {
    if (idTiposervicio == 8) {
        WindowLocation('EditarServicioTipoSiembra.aspx?idServicio=' + idServicio);
    } else if (idTiposervicio == 2) {
        WindowLocation('EditarServicioTipoVenta.aspx?idServicio=' + idServicio);
    }
    else if (idTiposervicio == 12 || idTiposervicio == 15) {
        WindowLocation('EditarServicioTipoVentaCorporativa.aspx?idServicio=' + idServicio);
    }
    else {
        WindowLocation('EditarServicio.aspx?idServicio=' + idServicio);
    }
}

function CambioServicio(idServicio, idTiposervicio) {
    WindowLocation('RegistrarCambioServicio.aspx?idServicio=' + idServicio);
}

function AbrirCancelarServicio(opcion, idServicio, idTiposervicio) {
    hfReactivarIdServicio.Set('idServicio', idServicio);

    if (opcion == 'AbrirServicio') {
        lbAbrirServicio.SetVisible(true);
        lbCancelarServicio.SetVisible(false)
    }
    if (opcion == 'cancelarServicio') {
        lbCancelarServicio.SetVisible(true)
        lbAbrirServicio.SetVisible(false);
    }
    EjecutarCallbackGeneral(LoadingPanel, pcAbrirCancelarServicio, opcion, idServicio);

    pcAbrirCancelarServicio.Show();
    //WindowLocation('AbrirCancelarServicio.aspx?idServicio=' + idServicio + '&idOpcion=' + opcion);
}
function CambioServicio(idServicio, idTiposervicio) {
    WindowLocation('RegistrarCambioServicio.aspx?idServicio=' + idServicio);
}
function AbrirCancelarServicioMensajeria(opcion, idServicio) {
    EjecutarCallbackGeneral(LoadingPanel, cpGeneral, opcion, idServicio);
    //setTimeout('pcAbrirCancelarServicio.Hide()', 1000);
    pcAbrirCancelarServicio.Hide();
}
function ReactivarServicio(idServicio) {
    txtNuevoRadicado.SetText('');
    txtObservacionReactivacion.SetValue('');
    hfReactivarIdServicio.Set('idServicio', idServicio);
    pcReactivarServicio.Show();

}

function GestionarServicioTecnico(idServicio, idTiposervicio) {
    if (idTiposervicio == 5) {
        WindowLocation('GestionServicioTecnico.aspx?idServicio=' + idServicio);
    }
}

function DevolverVenta(idServicio) {
    WindowLocation('DevolverVenta.aspx?idServicio=' + idServicio);
}

function LegalizarServicioFinanciero(idServicio, idTiposervicio) {
    if (idTiposervicio == 10 || idTiposervicio == 17 || idTiposervicio == 18 || idTiposervicio == 19) {
        WindowLocation('LegalizarServicioFinanciero.aspx?idServicio=' + idServicio);
    }
}

function AsignarSeriales(idServicio, idTiposervicio) {
    if (idTiposervicio == 12 || idTiposervicio == 15) {
        WindowLocation('DespacharSerialesServicioCorporativo.aspx?idServicio=' + idServicio);
    }
}

function QuitarCheckReagenda(idServicio, idTiposervicio) {
    if (confirm('¿Realmente desea quitar el check de reagendamiento?')) {
        lblIdServicio.SetText(idServicio);
        pcReagenda.Show();
    } else {
        pcReagenda.Hide();
    }
}
function QuitarReagenda(s, e) {
    pcReagenda.Hide();
    gvDatos.PerformCallback('QuitarCheckReagenda' + ':' + lblIdServicio.GetValue());

}

function DesCamServicioCorporativo(idServicio, idTiposervicio) {
    if (idTiposervicio == 12 || idTiposervicio == 15) {
        WindowLocation('RegistrarCambioServicio.aspx?idServicio=' + idServicio);
    }
}
function EjecutarCallback(s, e, opcion, idServicio, idTiposervicio) {
    gvDatos.PerformCallback(opcion + ':' + idServicio + ':' + idTiposervicio);
}
function LimpiaFormulario() {
    if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
          ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
    }
}

function MostrarInfoEncabezado(s, e) {
    if (s.cpMensaje) {
        $('#divEncabezado').html(s.cpMensaje);
        if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
            $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
        }
        LoadingPanel.Hide();
    }
    if (s.cpDescargarArchivo) {
        if (s.cpDescargarArchivo.length > 0) {
            window.open(s.cpDescargarArchivo, 'Adendo', 'status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1');
        }
    }

}

function SetPCVisible(value) {
    var popupControl = GetPopupControl();
    if (value)
        popupControl.Show();
    else
        popupControl.Hide();
}
function SetImageState(value) {
    var img = document.getElementById('imgButton');
    var imgSrc = value ? '../images/arrow_up2.gif' : '../images/DxView24.png';
    img.src = imgSrc;
}
function GetPopupControl() {
    return ASPxPopupClientControl;
}
function validaSeleccionReactivacion() {
    try {
        var strMensaje = "";
        var numRadicado = txtNuevoRadicado.GetText();
        var reactivaSin = rbReactivacion.GetValue();
        if (numRadicado == undefined) {
            numRadicado = '';
        }
        else { }
        var txtObservacion = txtObservacionReactivacion.GetValue();

        /*Se validan los datos antes de guadar.*/
        if (reactivaSin == null) {
            strMensaje += "- Debe seleccionar si se realiza cambio de Radicado.\n";
        }
        if (reactivaSin && numRadicado == '') {
            strMensaje += "- El nuevo número de radicado es requerido.\n";
        }
        if (txtObservacion.length == 0) {
            strMensaje += "- La observación de reactivación es obligatoria.\n";
        }

        if (strMensaje.length == 0) {
            //cpGeneral.PerformCallback('ReactivarServicio:');
            EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'ReactivarServicio', hfReactivarIdServicio.Get('idServicio'));
            setTimeout('pcReactivarServicio.Hide()', 1000);

        } else {
            alert(strMensaje);
            return false;
        }
    } catch (ex) {
        return false;
    }
}

function ValidarNumeroRadicado() {
    try {
        var numRadicado = txtNuevoRadicado.GetText();
        if (numRadicado.length > 0) {
            ActivarRadicado();
            EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultarRadicado', numRadicado);
            LoadingPanel.Show();
        }
    } catch (e) {
        LoadingPanel.Hide();

    }
}

function ActivarRadicado() {
    reactivaSin = rbReactivacion.GetValue();
    ///*Se muestra u oculta el textbox del radicado.*/
    if (reactivaSin) {
        txtNuevoRadicado.SetVisible(true);
        lbNuevoRadicado.SetVisible(true);
    } else {
        txtNuevoRadicado.SetVisible(false);
        txtNuevoRadicado.SetText('');
        lbNuevoRadicado.SetVisible(false);
        imgError.SetVisible(false);

    }
}

function NotificarVencimiento(opcion, idServicio) {
    LoadingPanel.Show();
    EjecutarCallbackGeneral(LoadingPanel, cpGeneral, opcion, idServicio);
}

function DespacharServicioDomicilio(idServicio, idTiposervicio) {
    if (idTiposervicio == 29 || idTiposervicio == 30) {
        WindowLocation('DespacharSerialesServicioDomicilio.aspx?idServicio=' + idServicio);
    }
}
function finalizarImprimirReporte(urlValue) {
    try {
        if (urlValue) {
            var win = window.open(urlValue, '_blank');
            win.focus();
        }
    } catch (ex) {
        return false
    }
}

function finalizarMostrarPlaca(value) {
    try {
        if (value) {
            txtPlacaMotorizado.SetText(value);
        }
    } catch (ex) {
        return false
    }
}

