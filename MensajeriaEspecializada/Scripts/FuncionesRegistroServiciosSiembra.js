function ValidaNumero(e) {
    var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
    return ((tecla > 47 && tecla < 58) || tecla == 46);
}

function FiltrarDevExpMaterial(s, e) {
    try {
        if (e.htmlEvent.keyCode >= 97 && e.htmlEvent.keyCode <= 122
            || e.htmlEvent.keyCode >= 65 && e.htmlEvent.keyCode <= 90
            || e.htmlEvent.keyCode >= 48 && e.htmlEvent.keyCode <= 57
            || (e.htmlEvent.keyCode == 32 || e.htmlEvent.keyCode == 8)) {
            if (s.GetText().length >= 4 || cmbEquipo.GetItemCount() != 0) {cpFiltroMaterial.PerformCallback(s.GetText());}
        }
    } catch (e) { }
}

function ControlFinFiltro(s, e) {
    try {
        txtEquipoFiltro.SetEnabled(true);
        txtEquipoFiltro.SetCaretPosition(txtEquipoFiltro.GetText().length);
        txtEquipoFiltro.Focus();
        if (cmbEquipo.GetItemCount() == 1) { EstablecerTipoSim(cmbEquipo); }
    } catch (e) { }
}

function AdicionarEquipo(s, e) {
    if (ASPxClientEdit.ValidateGroup('vgAdicionarCombinacion')) {
        if (cmbEquipo.GetValue() != null || (cmbClaseSim.GetValue() != null && cmbRegion.GetValue() != null)) {
            gvEquipos.PerformCallback('registrar');
        } else {alert('La seleccion de un Equipo y/o Sim es requerida.');}
    }
}

function EliminarEquipo(s, key) {
    if (confirm('¿Realmente desea eliminar la referencia?')) {gvEquipos.PerformCallback('eliminar|' + key);}
}

function EditarEquipo(s, key) {callbackRegistro.PerformCallback('editarEquipo|' + key);}

function ActualizarEquipo(s, e) {
    if (ASPxClientEdit.ValidateGroup('vgAdicionarCombinacion')) {
        if (cmbEquipo.GetValue() != null || (cmbClaseSim.GetValue() != null && cmbRegion.GetValue() != null)) {
            gvEquipos.PerformCallback('actualizar');
            CancelarEquipo()
        } else {alert('La seleccion de un Equipo y/o Sim es requerida.');}
    }
}

function CancelarEquipo() {
    LimpiarFiltroEquipo();
    btnAdicionarCombinacion.SetVisible(true);
    btnEdicionCombinacion.SetVisible(false);
    btnCancelarEdicion.SetVisible(false);
}

function RegistrarServicio(s, e) {
    var cantidadEquipos = 0;

    if (ASPxClientEdit.ValidateGroup('vgRegistrar')) {
        cantidadEquipos = gvEquipos.GetVisibleRowsOnPage();
        if (cantidadEquipos > 0) {
            callbackRegistro.PerformCallback('registrar');
        } else {alert('Se debe seleccionar al menos un Equipo ó Sim para registrar el servicio');}
    }
}

function LimpiaFormulario() {
    if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
        ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
        dateFechaSolicitud.SetDate(new Date());
        txtMsisdn.SetEnabled(false);
        dateFechaAgenda.SetEnabled(false);
        btnAdicionarCombinacion.SetEnabled(false);
        btnAdicionarCombinacion.SetEnabled(false);
        lblResultadoMaterial.SetVisible(false);
    }
}

function LimpiarFiltroEquipo() {
    rblTipo.SetSelectedIndex(-1);
    txtMsisdn.SetValue(null);
    cmbPlan.SetValue(null);
    dateFechaAgenda.SetValue(null);
    txtEquipoFiltro.SetValue(null);
    cmbEquipo.SetValue(null);
    cmbClaseSim.SetValue(null);
    cmbPaquete.SetValue(null);
    cmbRegion.SetValue(null);
    txtMsisdn.Focus();
}

function ControlarCambioCombinacion(s, e) {
    txtMsisdn.SetEnabled(true);
    dateFechaAgenda.SetEnabled(true);
    btnAdicionarCombinacion.SetEnabled(true);
    txtEquipoFiltro.SetEnabled(true);
    switch (s.GetValue()) {
        //Equipo y Sim                
        case "0":
            cmbPlan.SetEnabled(true);
            cmbPaquete.SetEnabled(true);
            txtEquipoFiltro.SetEnabled(true);
            cmbEquipo.SetEnabled(true);
            cmbClaseSim.SetEnabled(false);
            //cmbClaseSim.ClearItems();
            cmbRegion.SetEnabled(true);
            lblResultadoMaterial.SetVisible(false);
            break;
            //Solo equipo
        case "1":
            cmbPlan.SetEnabled(false);
            cmbPlan.SetSelectedIndex(-1);
            cmbPaquete.SetEnabled(false);
            cmbPaquete.SetSelectedIndex(-1);
            txtEquipoFiltro.SetEnabled(true);
            cmbEquipo.SetEnabled(true);
            //cmbClaseSim.ClearItems();
            cmbClaseSim.SetEnabled(false);
            cmbRegion.SetEnabled(false);
            lblResultadoMaterial.SetVisible(false);
            break;

            //Solo Sim
        case "2":
            cmbPlan.SetEnabled(true);
            cmbPaquete.SetEnabled(true);
            txtEquipoFiltro.SetEnabled(false);
            txtEquipoFiltro.SetValue(null);
            cmbEquipo.SetEnabled(false);
            cmbEquipo.ClearItems();
            //cmbClaseSim.SetEnabled(true);
            cmbRegion.SetEnabled(true);
            lblResultadoMaterial.SetVisible(false);
            cmbClaseSim.PerformCallback("CargarTodas");
            break;
    }
}

function EstablecerTipoSim(s, e) {
    var tipo = rblTipo.GetValue();
    if (tipo == 0) {cmbClaseSim.PerformCallback(s.GetValue());}
}

function ControlFinalizacionClaseSIM(s, e) {
    MostrarInfoEncabezado(s, e);

    if (s.cpTipoSeleccionado) {
        s.SetValue(s.cpTipoSeleccionado);
        s.SetEnabled(false);
    } else {
        s.SetEnabled(true);
    }
}

function MostrarInfoEncabezado(s, e) {
    if (s.cpMensaje) {
        $('#divEncabezado').html(s.cpMensaje);
        if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
            $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
        }
    }
}