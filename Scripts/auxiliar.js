function ActualizarSesionesClasicas(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13) {
    try {
        var url = "ActualizaSesiones.asp";

        $.ajax({
            url: url,
            type: 'POST',
            data: {
                s001: s1, s002: s2, s003: s3, s004: s4, s005: s5, s006: s6, s007: s7,
                s008: s8, s009: s9, s010: s10, s011: s11, s012: s12, s013: s13
            },

            dataType: "text",
            cache: false,
            success: function (response) {
            },
            error: function (xhr, status, error) {
                console.log("Error al tratar de actualizar sesiones. " + xhr.responseText);
            }
        });

    } catch (e) {
        console.log("Error al tratar de actualizar sesiones. " + e.message);
    }
}

function RegistrarLogOut(idUsr, sId) {
    try {
        var url = "Inicio.aspx/RegistrarLogOutFromClient";

        $.ajax({
            url: url,
            type: 'POST',
            data: {
                idUsuario: idUsr, sessionId: sId
            },

            dataType: "text",
            cache: false,
            success: function (response) {
            },
            error: function (xhr, status, error) {
                console.log("Error al tratar de registrar logout. " + xhr.responseText);
            }
        });

    } catch (e) {
        console.log("Error al tratar de registrar logout " + e.message);
    }
}

function MostrarCambioPassword() {
    pcCambiarPassword.Show();
    return false;
}

function CambiarPassword() {
    if (ASPxClientEdit.AreEditorsValid()) {
        cpCambioPassword.PerformCallback('CambioPassword');
        $('#btnCambiarPassword').prop('disabled', true);
        $('#btnCancelarCambiarPassword').prop('disabled', true);
    }
}

function OnBtnCancelarCambiarPasswordPopUpClick() {
    LimpiarFormularioCambioPassword();
    pcCambiarPassword.Hide();
}

function LimpiarFormularioCambioPassword() {
    complejidadPassword = 0;
    txtNuevoPassword.SetText('');
    txtConfirmarPassword.SetText('');
    txtPasswordActual.SetText('');
}

var complejidadPassword = 0;

function ObtenerComplejidadPassword(password) {
    var passwordMinLength = 6;
    var result = 0;
    if (password) {
        //result++;
        if (password.length >= passwordMinLength) {
            result++;
            if (/[a-z]/.test(password) || /[A-Z]/.test(password))
                result++;
            if (/\d/.test(password))
                result++;
            //if (/[A-Z]/.test(password))
            //    result++;
            if (/[!"#$%&'()*+,\-./:;<=>?@[\\\]^_`{|}~]/.test(password))
                result++;
            if (!(/^[a-z0-9]+$/i.test(password)))
                result++;
        }
    }
    console.log('Resultado: ' + result.toString());
    return result;
}

function ObtenerActualComplejidadPassword(s, e) {
    var password = txtNuevoPassword.GetText();
    complejidadPassword = ObtenerComplejidadPassword(password);
}

function ObtenerTextoError(editor) {
    if (editor === txtNuevoPassword) {
        if (complejidadPassword < 3) {
            return "La contraseña es muy débil. Debe contener mínimo 6 caracteres, por lo menos una letra y un número o un caracter especial.";
        }

        if (txtNuevoPassword.GetText() == txtPasswordActual.GetText()) {
            return "La nueva contraseña no puede ser igual a la contraseña actual.";
        }
    } else if (editor === txtConfirmarPassword) {
        if (txtNuevoPassword.GetText() !== txtConfirmarPassword.GetText())
            return "Las contraseñas ingresadas no coinciden";
    }
    return "";
}

function OnValidacionPassword(s, e) {
    var errorText = ObtenerTextoError(s);
    if (errorText) {
        e.isValid = false;
        e.errorText = errorText;
    }
}

function MostrarMensaje(titulo, tipo, mensaje) {
    $.toast({
        heading: titulo,
        text: mensaje,
        showHideTransition: 'fade',
        hideAfter: 5000,
        position: 'top-center',
        icon: tipo,
        loaderBg: '#5f368d'
    })
}

function ProcesarFinCallbackCambioPassword(s, e) {
    if (s.cpResultadoCambio != null) {
        if (s.cpResultadoCambio == 200) {
            LimpiarFormularioCambioPassword();
            pcCambiarPassword.Hide();
            MostrarMensaje('Exitoso', 'success', s.cpMensajeCambio.toString());
        } else {
            MostrarMensaje('Error', 'error', s.cpMensajeCambio.toString());
        }
    } else {
        MostrarMensaje('Error', 'error', 'No fue posible evaluar el resultado. Por favor intente nuevamente');
    }

    $('#btnCambiarPassword').prop('disabled', false);
    $('#btnCancelarCambiarPassword').prop('disabled', false);
    
}
