<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolServiciosNew.aspx.vb" Inherits="BPColSysOP.PoolServiciosNew" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>:: Pool de Servicios ::</title>
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript"> 
        function ProcesarCarga() {
            
            cpGeneral.PerformCallback('UploadFileTransporte:');
        }


        function IniciarModales() {
            $("#dvNovedadesDocs").dialog({
                width: 900,
                position: { my: 'top', at: 'top+150' },
                closeOnEscape: true,
                autoOpen: false,
                modal: true,
                show: {
                    effect: "fold",
                    duration: 1000
                },
                hide: {
                    effect: 'clip',
                    duration: 1000
                },
                close: function (event, ui) {
                    if ($('#tblNovedadesDocs').find('> tbody > tr').length > 0) {
                        $('#tblNovedadesDocs').empty();
                        $('#txtCedulaRadiacado').focus();
                    }
                }
            });

            $("#dvImagenesDocs").dialog({
                width: 900,
                position: { my: 'top', at: 'top+150' },
                closeOnEscape: true,
                autoOpen: false,

                show: {
                    effect: "fold",
                    duration: 1000
                },
                close: function (event, ui) {
                    if ($('#dvImagenesDocs').length > 0) {
                        $('#dvImagenesDocs').empty();
                        $('#imgImpresion').attr('src', '');
                        _srcGlobalImagenMC = '';
                    }
                }
            });

            $("#dvCausalRechazoDocs").dialog({
                width: 900,
                position: { my: 'top', at: 'top+150' },
                closeOnEscape: true,
                autoOpen: false,
                modal: true,
                show: {
                    effect: "fold",
                    duration: 1000
                },
                hide: {
                    effect: 'clip',
                    duration: 1000
                },
                close: function (event, ui) {
                    if ($('#tblCausalDevolucion').find('> tbody > tr').length > 0) {
                        $('#tblCausalDevolucion').empty();
                        $('#chkRechazado')[0].checked = false;
                    }
                }
            });
        }

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
            else {
                PopUpSetContenUrl(pcGeneral, 'VerInformacionServicio.aspx?idServicio=' + idServicio, '0.9', '0.9');
            }
            pcGeneral.RefreshContentUrl();
        }

        function ConfirmarServicio(idServicio, idTiposervicio) {
            if (idTiposervicio == 2) {
                WindowLocation('ConfirmacionServicioTipoVenta.aspx?idServicio=' + idServicio);
            }
            else if (idTiposervicio == 8) {
                WindowLocation('ConfirmacionServicioTipoSiembra.aspx?idServicio=' + idServicio);
            }
            else {
                WindowLocation('ConfirmacionServicio.aspx?idServicio=' + idServicio);
            }
        }

        function DespachoServicio(idServicio, idTiposervicio) {
            if (idTiposervicio == 8) {
                WindowLocation('AlistamientoSerialesSiembra.aspx?idServicio=' + idServicio);
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

        function ConfirmaServicioCorporativo(idServicio, idTiposervicio) {
            if (idTiposervicio == 12 || idTiposervicio == 15) {
                WindowLocation('ConfirmacionServicioTipoVentaCorporativa.aspx?idServicio=' + idServicio);
            }
        }

        function EditaServicioCorporativo(idServicio, idTiposervicio) {
            if (idTiposervicio == 12 || idTiposervicio == 15) {
                WindowLocation('EditarServicioTipoVentaCorporativa.aspx?idServicio=' + idServicio);
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
                //cmbEquipo.SetSelectedIndex(0);
                //gvMatrialClaseSim.PerformCallback(null);
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


        function CargarBusquedaVenta(s, e) {

            if (ValidaNumeros(e)) {
                if (s == 'Cedula') {
                    EjecutarCallback('', '', 'ConsultaVentaCliente', 1);
                }
                else if (s == 'Campania') {
                    EjecutarCallback('', '', 'ConsultaVentaCliente', 2);
                }
            }
            else {
                e.value = e.value.replace(/[^0-9\.]/g, '');
            }
        }

        var _globalAutocomplete;
        function AutoCompletar(_busqueda) {
            var control;
            var busqueda = _busqueda.split('|');

            if (busqueda[0] != '-1' && busqueda[0] != '-2' && busqueda[0] != '-3' && busqueda[0] != '-4') {
                var venta = $.parseJSON(busqueda[1]);
                var resultadoBusqueda = [];
                var comparacion;

                _globalAutocomplete = venta;

                for (var x = 0; x < venta.length; x++) {
                    var tmp = venta[x].Busqueda.toString();

                    if (tmp != comparacion) {
                        resultadoBusqueda.push(tmp);
                    }
                    comparacion = tmp;
                }

                if (busqueda[0] == 1) {
                    control = 'txtCedulaRadiacado';
                }
                else if (busqueda[0] == 2) {
                    control = 'txtCampaniaEstrategia';
                }

                $("input[id$='" + control + "']").autocomplete({
                    source: resultadoBusqueda,
                    select: function (event, ui) {
                        $("input[id$='txtCedulaRadiacado']").val('');
                        $('#tblBusquedaVenta').empty();
                        $('#dvContentGridImages').empty();
                        $('#dvFupload').css('display', 'none');
                        $('#dvTblBusquedaVenta').css('display', 'inline');
                        $('#tblNovedadesDocs').empty();

                        //Encabezado tabla Novedades documentos
                        tr = $('<tr/>');
                        tr.append("<td>Observaciones</td>");
                        tr.append("<td>Causal</td>");
                        tr.append("<td>Usuario Modificación</td>");
                        tr.append("<td>Fecha Modificación</td>");
                        $('#tblNovedadesDocs').append(tr);
                        $('#tblNovedadesDocs').find('> tbody > tr')[0].className = 'danger';

                        var campania, idRadicado, identificacion, nombre, codEstrategia = '', novedadesDocumentos = '', obsTemp = '', codTemp = '';

                        for (x = 0; x < _globalAutocomplete.length; x++) {
                            if (_globalAutocomplete[x].Busqueda.toString() == ui.item.value) {
                                campania = _globalAutocomplete[x].Campania;
                                idRadicado = _globalAutocomplete[x].numeroRadicado;
                                identificacion = _globalAutocomplete[x].identicacion;
                                nombre = _globalAutocomplete[x].nombre;
                                if (codTemp != _globalAutocomplete[x].CCEcodigo) {
                                    codEstrategia += _globalAutocomplete[x].CCEcodigo + '-';
                                }
                                if (_globalAutocomplete[x].Causal != null) {

                                    tr = $('<tr/>');
                                    if (obsTemp != _globalAutocomplete[x].Observaciones) {
                                        tr.append("<td style='font-weight: bold'>" + _globalAutocomplete[x].Observaciones.toUpperCase() + "</td>");
                                    }
                                    else {
                                        tr.append("<td></td>");
                                    }
                                    tr.append("<td>" + _globalAutocomplete[x].Causal + "</td>");
                                    tr.append("<td>" + _globalAutocomplete[x].UsuarioModificacion + "</td>");
                                    tr.append("<td>" + ConvertirAFecha(parseInt(_globalAutocomplete[x].FechaIngresoCausal.split('(')[1].split(')')[0])) + "</td>");
                                    $('#tblNovedadesDocs').append(tr);
                                    $('#tblNovedadesDocs').find('> tbody > tr')[x + 1].className = 'success';
                                    obsTemp = _globalAutocomplete[x].Observaciones;
                                }
                                codTemp = _globalAutocomplete[x].CCEcodigo;
                            }
                        }

                        //Encabezado tabla
                        tr = $('<tr/>');
                        tr.append("<td>Campaña</td>");
                        tr.append("<td>Radicado</td>");
                        tr.append("<td>Identificación</td>");
                        tr.append("<td>Nombre</td>");
                        tr.append("<td>Código Estrategia</td>");
                        tr.append("<td>Ver Doc.</td>");
                        tr.append("<td>Cargar Doc.</td>");
                        if (_globalAutocomplete[0].docsAprobados == null) {
                            tr.append("<td>Aprobar</td>");
                            tr.append("<td>Rechazar</td>");
                        }
                        else if (_globalAutocomplete[0].docsAprobados) {
                            tr.append("<td>Rechazar</td>");
                        }
                        else if (_globalAutocomplete[0].docsAprobados == false) {
                            tr.append("<td>Aprobar</td>");
                        }
                        if (obsTemp.length > 0) {
                            tr.append("<td>Novedades</td>");
                        }
                        $('#tblBusquedaVenta').append(tr);
                        $('#tblBusquedaVenta').find('> tbody > tr')[0].className = 'danger';

                        //Cuerpo tabla
                        tr = $('<tr/>');
                        tr.append("<td>" + campania + "</td>");
                        tr.append("<td>" + idRadicado + "</td>");
                        tr.append("<td>" + identificacion + "</td>");
                        tr.append("<td>" + nombre + "</td>");
                        tr.append("<td>" + codEstrategia + "</td>");
                        tr.append("<td><button type='button' class='btn btn-info' onclick='VerDocsMC(this)'>Ver</button></td>");
                        tr.append("<td><button type='button' id='btnSubirDocs' class='btn btn-success' onclick='Mostrar(this)'>Subir</button></td>");
                        if (_globalAutocomplete[0].docsAprobados == null) {
                            tr.append("<td><input type='checkbox' id='chkAprobado' onclick='AprobacionRecchazo(this)' /></td>");
                            tr.append("<td><input type='checkbox' id='chkRechazado' onclick='AprobacionRecchazo(this)' /></td>");
                        }
                        else if (_globalAutocomplete[0].docsAprobados) {
                            tr.append("<td><input type='checkbox' id='chkRechazado' onclick='AprobacionRecchazo(this)' /></td>");
                        }
                        else if (_globalAutocomplete[0].docsAprobados == false) {
                            tr.append("<td><input type='checkbox' id='chkAprobado' onclick='AprobacionRecchazo(this)' /></td>");
                        }
                        if (obsTemp.length > 0) {
                            tr.append("<td><button type='button' class='btn btn-info' onclick='MostrarNovedades()'>Ver</button></td>");
                        }
                        $('#tblBusquedaVenta').append(tr);
                        $("input[id$='txtCedulaRadiacado']").focus();
                        $('#tblBusquedaVenta').find('> tbody > tr').addClass('success');
                    },
                });
            }
            else if (busqueda[0] == '-1') {
                PintarDocumentosByte(busqueda);
            }
            else if (busqueda[0] == '-2') {
                LlenarCausalesRezhazo($.parseJSON(busqueda[1]));
            }
            else if (busqueda[0] == '-3') {
                var retorno = busqueda[1].split('_');
                alert(retorno[0]);
                if (retorno[1] != '2') {
                    $('#dvCausalRechazoDocs').dialog('close');
                }
            }
            else if (busqueda[0] == '-4') {
                $.alert(busqueda[1]);
            }
        }

        function ConvertirAFecha(milisegundos) {
            var date = new Date(milisegundos);
            var y = date.getFullYear()
            var m = date.getMonth() + 1;
            var d = date.getDate();
            m = (m < 10) ? '0' + m : m;
            d = (d < 10) ? '0' + d : d;
            return [d, m, y].join('-');
        }

        function MostrarNovedades() {
            $("#dvNovedadesDocs").dialog("open");
        }

        function PoolServicios(origen) {
            if (origen == 'PoolS') {
                $('#dvPoolServiciosFin').css('display', 'inline');
                $('#dvPoolRecepcioRadicados').css('display', 'none');
                $('#spnTituloMC').css('display', 'none');
                $('#dvTblBusquedaVenta').css('display', 'none');
                $('#dvFupload').css('display', 'none');
                $('#dvContentGridImages').css('display', 'none');
            }
            else if (origen == 'MesaC') {
                $('#dvPoolServiciosFin').css('display', 'none');
                $('#dvPoolRecepcioRadicados').css('display', 'inline');
                $('#spnTituloMC').css('display', 'inline');
                $('#txtCedulaRadiacado').focus();
            }
        }

        var validFiles = ["bmp", "gif", "png", "jpg", "jpeg", "pdf"];
        function OnUpload() {
            var obj = document.getElementById("fuArchivo");
            var file = obj.files[0];
            if (file != null) {
                var tamanoArchivo = file.size;
                tamanoArchivo = Math.round(tamanoArchivo / 1024);
                if (tamanoArchivo > 10240) {
                    document.getElementById("fuArchivo").value = '';
                    alert('El archivo es demasiado grande, el tamaño maximo permitido es 10 MB', 'rojo');
                    //document.getElementById("rfvArchivo").innerHTML = 'El archivo es demasiado grande, el tamaño maximo permitido es 10 MB';
                    return false
                }
            }
            if (obj == null) {
                alert('Es necesario seleccionar un archivo', 'rojo');
                //document.getElementById("rfvArchivo").innerHTML = 'Es necesario seleccionar un archivo';
                return false
            }
            else {
                document.getElementById("rfvArchivo").innerHTML = '';
            }
            var source = obj.value;
            var ext = source.substring(source.lastIndexOf(".") + 1, source.length).toLowerCase();
            for (var i = 0; i < validFiles.length; i++) {
                if (validFiles[i] == ext) {
                    document.getElementById("rfvArchivo").innerHTML = '';
                    break;
                }
            }
            if (i >= validFiles.length) {
                document.getElementById("fuArchivo").value = '';
                alert('Formato del archivo incorrecto', 'rojo');
                //document.getElementById("rfvArchivo").innerHTML = 'Formato del archivo incorrecto';

            }
            return true;
        }

        var _srcGlobalImagenMC = '';
        function VerImagenGrande(_this) {
            _srcGlobalImagenMC = $(_this)[0].src;


            if ($('#' + _this.id)[0].clientWidth > 500) {
                $('#' + _this.id).css('width', '20%');
            }
            else {
                $('#' + _this.id).css('width', '100%');
            }
        }

        function ImprimirDocumentosMC() {
            if (_srcGlobalImagenMC.length > 0) {
                var options = { mode: "popup", popHt: 500, popWd: 400, popX: 500, popY: 600, popTitle: "Impresión documentos Mesa de Control", popClose: true };
                $('#imgImpresion').attr('src', _srcGlobalImagenMC);
                $("div.PrintArea").printArea(options);
            }
            else {
                alert('Seleccione el documento a imprimir', 'azul');
            }
        }

        function Pequena(_this) {
            $('#' + _this.id).css('width', '10%');
        }

        function Mostrar(_this) {
            var indice = $(_this).parent().parent();
            var idRadicado = indice[0].cells[1].innerText;
            //var contenidoTabla = indice[0].cells[0].innerText + '|' + indice[0].cells[1].innerText + '|' + indice[0].cells[2].innerText + '|' + indice[0].cells[3].innerText + '|' + indice[0].cells[4].innerText;
            $('#dvFupload').css('display', 'inline');
            $('input[id$=hdfIdRadicado]').val(idRadicado);
            //$('input[id$=hdfContenidoTablaResultado]').val(contenidoTabla);

            return false;
        }

        function VerDocsMC(_this) {

            var idRadicado = $(_this).parent().parent()[0].cells[1].innerText;

            EjecutarCallback('', '', 'VerDocsMC', idRadicado);


            $('#tblBusquedaVenta tbody tr').each(function () {
                var t = $(this)[0].children[1].innerText;
            });
        }

        function PintarDocumentosByte(docByte) {
            docByte.shift();
            docByte.pop();
            $("#dvImagenesDocs").dialog("open");

            var btnImprimir = "<button type='button' class='btn btn-primary' onclick='ImprimirDocumentosMC()'>Imprimir..<span class='badge'><img src='../images/print.png' /></span></button> <br /><br />";
            $("#dvImagenesDocs").append(btnImprimir);

            for (x = 0; x < docByte.length; x++) {
                $("#dvImagenesDocs").append("<img id='imgdDoc_" + x + "' onclick='VerImagenGrande(this)' />");
                $('#imgdDoc_' + x).attr('src', docByte[x]);
                $('#imgdDoc_' + x).css('width', '20%');
                $('#imgdDoc_' + x).css('cursor', 'pointer');
            }

            //$("#dvImagenesDocs").append("<img id='imgb'/>");
            //$('#imgb').attr('src', bb);
            //$('#imgb').css('width', '20%');
        }

        function PintarValoresPrecargadosGrid() {
            var posicion = $('#gvSoporte tr').length;
            var idRadicadoC = $('#gvSoporte tr')[posicion - 1].innerText.split('_')[0];
            $("input[id$='txtCedulaRadiacado']").val(idRadicadoC);
            CargarBusquedaVenta('Cedula');
            //$("#gvSoporte tr").each(function () {
            //    var nu = $(this);
            //});
        }

        function AprobacionRecchazo(_this) {
            var origen = _this.id;
            var indice = $(_this).parent().parent();
            var idRadicado = indice[0].cells[1].innerText;

            if (origen == 'chkAprobado') {
                if ($('#chkRechazado').length > 0) {
                    $('#chkRechazado')[0].checked = false;
                }
                if ($('#chkAprobado')[0].checked) {
                    var idRadicado = $(_this).parent().parent()[0].cells[1].innerText;
                    confirmar(idRadicado);
                    $('#chkAprobado')[0].checked = false;
                }
            }
            else if (origen == 'chkRechazado') {
                if ($('#chkAprobado').length > 0) {
                    $('#chkAprobado')[0].checked = false;
                }
            }

            if ($('#chkRechazado')[0].checked) {
                $("#dvCausalRechazoDocs").dialog("open");
                EjecutarCallback('', '', 'VerCausalesrechazo', 1);
            }


            $('#dvCausalRechazoDocs').dialog('option', 'title', 'Causal para el servicio: ' + idRadicado);
        }

        function confirmar(idRadicado) {
            $.confirm({
                title: 'Aprobar',
                content: 'Desea continuar?',
                icon: ' fa fa-question-circle-o',
                theme: 'supervan',
                closeIcon: true,
                animation: 'scale',
                type: 'orange',
                buttons: {
                    ok: {
                        text: "ok!",
                        btnClass: 'btn-success',
                        keys: ['enter'],
                        action: function () {
                            EjecutarCallback('', '', 'AprobarDocumentos', idRadicado);
                        }
                    },
                    cancel: {
                        text: "Cancelar"
                    },
                }
            });
        }

        function LlenarCausalesRezhazo(causales) {
            var posicion = 0;
            for (x = 0; x < causales.length; x++) {
                tr = $('<tr/>');
                tr.append("<td>" + causales[x].CRMid + '_' + causales[x].CRMcausal + "</td>");
                tr.append("<td> <input type ='checkbox' id='chk_'" + x + " /> </td>");
                $('#tblCausalDevolucion').append(tr);
                $('#tblCausalDevolucion').find('> tbody > tr').addClass('success');
            }

            tr = $('<tr/>');
            tr.append("<td> <textarea id='texObsRechazo' class='form-control' rows='3' style='width: 70%; margin-left: 22%' placeholder='Ingrese sus comentarios...'></textarea><br /> </td>");
            tr.append("<td></td>");
            $('#tblCausalDevolucion').append(tr);
            posicion = $('#tblCausalDevolucion').find('> tbody > tr').length - 1;
            $('#tblCausalDevolucion').find('> tbody > tr')[posicion].className = 'active';
            $('#texObsRechazo').focus();

            tr = $('<tr/>');
            tr.append("<td> <button type='button' id='btnGuardarCausal' class='btn btn-success' onclick='GuardarCausal()' style='margin-left: 46%'>Guardar Causal</button> </td>");
            tr.append("<td></td>");
            $('#tblCausalDevolucion').append(tr);
            posicion = $('#tblCausalDevolucion').find('> tbody > tr').length - 1;
            $('#tblCausalDevolucion').find('> tbody > tr')[posicion].className = 'danger';
        }

        function GuardarCausal() {
            var tmp = 0;
            var cont = 0;
            var radicadoObs = $('#dvCausalRechazoDocs').dialog('option', 'title').split(':')[1].trim() + '|' + $('#texObsRechazo').val();

            $('#tblCausalDevolucion').find('> tbody > tr').each(function () {
                if (cont < $('#tblCausalDevolucion').find('> tbody > tr').length - 2) {
                    var chkCausal = this;
                    var chequeado = chkCausal.cells[1].children.chk_.checked;
                    var idCausal = chkCausal.cells[0].innerText.split('_')[0];
                    if (chequeado) {
                        EjecutarCallback('', '', 'GuardarRechazoDocumentos', idCausal, radicadoObs);
                        tmp = 1;
                    }
                    cont++;
                }
            });
            if (tmp == 0) {
                alert('Debe seleccionar al menos una causal', 'rojo');
            }
        }

        function GuardarTablaMemoria() {

            //$('#txtCedulaRadiacado').data('ui-autocomplete')._trigger('select', 'autocompleteselect', { item: { value: '1077' } });
            var encabezadoTabla = '', cuerpoTabla = '';
            $('#tblBusquedaVenta tbody tr').each(function () {
                var tabla = $(this)[0].children, tmp = '';

                for (x = 0; x < tabla.length; x++) {
                    tmp += tabla[x].innerHTML + '|';
                }
                if (encabezadoTabla.length == 0) {
                    encabezadoTabla = tmp;
                }
                else {
                    cuerpoTabla = tmp;
                }
            });
            $('input[id$=hdfContenidoTablaResultado]').val(encabezadoTabla + '||' + cuerpoTabla);
        }

        function LlenarTabla(content) {
            var y = $('input[id$=hdfContenidoTablaResultado]').val().split('|||');

            for (x = 0; x < y.length; x++) {
                var z = $('input[id$=hdfContenidoTablaResultado]').val().split('|||')[x].split('|');

                //Encabezado tabla
                tr = $('<tr/>');
                for (a = 0; a < z.length; a++) {
                    tr.append("<td>" + z[a] + "</td>");
                }
                $('#tblBusquedaVenta').append(tr);
                if ($('#tblBusquedaVenta').find('> tbody > tr').length == 1) {
                    $('#tblBusquedaVenta').find('> tbody > tr')[0].className = 'danger';
                }
                else if ($('#tblBusquedaVenta').find('> tbody > tr').length == 2) {
                    $('#tblBusquedaVenta').find('> tbody > tr')[1].className = 'success';
                }

            }
            PoolServicios('MesaC');
            $('#btnSubirDocs').click();

        }

        function ValidaNumeros(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (((charCode == 8) || (charCode == 46) || (charCode == 13) ||
                (charCode >= 35 && charCode <= 40) ||
                (charCode >= 48 && charCode <= 57) ||
                (charCode >= 96 && charCode <= 105) ||
                (charCode == 9))) {
                return true;
            }
            else {
                alert('Este campo solo admite números', 'rojo');
                return false;
            }
        }

        function DescargarDocumento(rutaOrigenArchivo) {
            location.href = 'DescargarDocumentoPool.aspx?rutaArchivoOrigen=' + rutaOrigenArchivo;
        }

        function buscarInformacion(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgFiltro')) {

                if (TextBMin.GetValue() != null && TextBMin.GetValue() != '') {
                    if (TextBMin.GetValue().length < 10 || TextBMin.GetValue().includes(' ')) {
                        e.isValid = false;
                        return;
                    }
                }

                if (mePedidos.GetValue() == null && (cmbCiudad.GetValue() == 0 || cmbCiudad.GetValue() == null) && (cmbEstado.GetValue() == 0 || cmbEstado.GetValue() == null) && (cmbBodega.GetValue() == 0 || cmbBodega.GetValue() == null)
                    && (cmbTipoServicio.GetValue() == 0 || cmbTipoServicio.GetValue() == null) && TextBMin.GetValue() == null && TextBIdentificaion.GetValue() == null
                    && dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null
                    && dateFechaRegistroInicio.GetValue() == null && dateFechaRegistroFin.GetValue() == null && txtSeudocodigo.GetValue() == null
                ) {
                    alert('Debe seleccionar por lo menos un filtro de búsqueda.');
                } else {
                    if (((dateFechaInicio.GetValue() != null && dateFechaFin.GetValue() == null) || (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() != null))
                        || ((dateFechaRegistroInicio.GetValue() != null && dateFechaRegistroFin.GetValue() == null) || (dateFechaRegistroInicio.GetValue() == null && dateFechaRegistroFin.GetValue() != null))) {

                        alert('Debe digitar los dos rangos de fechas.');
                    } else {
                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultar', 1);
                    }
                }
            }
        }

        function handleSpace(event) {
            //handling ie and other browser keycode 
            var keyPressed = event.which || event.keyCode;

            //Handling whitespace
            //keycode of space is 32
            if (keyPressed == 32) {
                event.preventDefault();
                event.stopPropagation();
            }
        }

        $(document).ready(function () {
            ReadyDocument();
        });


         function ReadyDocument() {
           
             $("#cpGeneral_pcMain_rpFiltros_flFiltro_mePedidos_I").keypress(function (e) {
                 if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57) && e.which != 13) {
                     return false;
                 }
             });

             $("#cpGeneral_pcMain_rpFiltros_flFiltro_mePedidos_I").bind('paste', function (e) {
                 if (e.originalEvent.clipboardData.getData('Text').match(/[^\d\r\n]/)) {
                     e.preventDefault();
                 }
             });
               

                $("#cpGeneral_pcMain_rpFiltros_flFiltro_TextBIdentificaion_I").keypress(function (e) {
                    if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                        return false;
                    }
                });

                $("#cpGeneral_pcMain_rpFiltros_flFiltro_TextBIdentificaion_I").bind('paste', function (e) {
                    if (e.originalEvent.clipboardData.getData('Text').match(/[^\d]/)) {
                        e.preventDefault();
                    }
                });          
        }

    </script>
</head>
<body class="cuerpo2">

    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>


        <div id="dvIconoMesaControl" style="display: none">
            <button type="button" class="btn btn-primary" onclick="PoolServicios('MesaC')"><span class="badge">MC</span></button>
            <span id="spnTituloMC" class="label label-primary" style="font-size: 113%; display: none">Flujo documentos Mesa de Control</span>
        </div>

        <div id="dvPoolServiciosFin">


            <input id="hfPosFiltrado" type="hidden" value="0" runat="server" />
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral">
                <ClientSideEvents EndCallback="function (s, e){
                LoadingPanel.Hide();
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
                MostrarInfoEncabezado(s,e);
                finalizarImprimirReporte(s.cpUrlReporte)
                finalizarMostrarPlaca(s.cpPlaca)
                if(s.cpRutaArchivo.length != 0){
                    DescargarDocumento(s.cpRutaArchivo);
                    ReadyDocument();    
                }
               
            }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxHiddenField ID="hfReactivarIdServicio" ClientInstanceName="hfReactivarIdServicio" runat="server"></dx:ASPxHiddenField>
                        <asp:HiddenField ID="hfIdServicio" runat="server" />
                        <div style="float: left; width: 56%; margin-right: 2%">
                            <span runat="server" enableviewstate="False" id="lblCursor" style="cursor: pointer;">
                                <img id="imgButton" alt="" src="../images/DxView24.png" style="width: 28px; height: 28px;" />
                            </span>
                        </div>
                        <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 50%; height: 40%;">
                            <dx:ASPxPopupControl ClientInstanceName="ASPppfiltro" Width="100%" Height="250px" ID="pcMain"
                                ShowFooter="false" PopupElementID="imgButton" HeaderText="Filtros de Búsqueda"
                                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                                <ContentCollection>
                                    <dx:PopupControlContentControl ID="ppFiltroBusqueda" runat="server">
                                        <dx:ASPxRoundPanel ID="rpFiltros" runat="server" Height="40%" Width="100%" ShowHeader="false">
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <dx:ASPxFormLayout ID="flFiltro" runat="server" ColCount="3" Height="100%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="No. Radicado:" RowSpan="2" Height="20%">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                        <div>
                                                                            <dx:ASPxRadioButtonList ID="rblTipoServicio" runat="server" RepeatDirection="Horizontal"
                                                                                ClientInstanceName="rblTipoServicio" Font-Size="XX-Small" Height="10px">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Servicio" Value="0" />
                                                                                    <dx:ListEditItem Text="Radicado" Value="1" Selected="true" />
                                                                                </Items>
                                                                                <Border BorderStyle="None"></Border>
                                                                            </dx:ASPxRadioButtonList>
                                                                        </div>
                                                                         <dx:ASPxMemo ID="mePedidos" runat="server" Height="71px" Width="270px" NullText="Ingrese uno o varios servicios..."
                                                                        ClientInstanceName="mePedidos" TabIndex="0" onkeypress="handleSpace(event)">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                                            <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[0-9\s\-]+\s*$" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxMemo>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Ciudad:" RequiredMarkDisplayMode="Optional">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                                        <dx:ASPxComboBox ID="cmbCiudad" runat="server" AutoPostBack="false" ClientInstanceName="cmbCiudad" Width="100%"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idCiudad">
                                                                            <Columns>
                                                                                <dx:ListBoxColumn FieldName="idCiudad" Caption="Id" Visible="false" />
                                                                                <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                                            </Columns>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxComboBox>
                                                                        <div>
                                                                            <dx:ASPxLabel ID="lblComentario" runat="server" Text="Digite parte de la ciudad."
                                                                                CssClass="comentario" Width="100%" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                            </dx:ASPxLabel>
                                                                        </div>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Estado:" RequiredMarkDisplayMode="Optional">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                        <dx:ASPxComboBox ID="cmbEstado" runat="server" AutoPostBack="false" ClientInstanceName="cmbEstado" Width="100%"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idEstado">
                                                                            <Columns>
                                                                                <dx:ListBoxColumn FieldName="idEstado" Caption="Id" Visible="false" />
                                                                                <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="400px" />
                                                                            </Columns>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Bodega:" RequiredMarkDisplayMode="Optional">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">

                                                                        <dx:ASPxComboBox ID="cmbBodega" runat="server" AutoPostBack="false" ClientInstanceName="cmbBodega" Font-Size="Small"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idbodega">
                                                                            <Columns>
                                                                                <dx:ListBoxColumn FieldName="idbodega" Caption="Id" Visible="false" />
                                                                                <dx:ListBoxColumn FieldName="bodega" Caption="Nombre" Width="400px" />
                                                                            </Columns>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxComboBox>

                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Tipo Servicio:" RequiredMarkDisplayMode="Optional">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                                        <dx:ASPxComboBox ID="cmbTipoServicio" AutoPostBack="false" runat="server" ClientInstanceName="cmbTipoServicio" Width="100%"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idTipoServicio">
                                                                            <Columns>
                                                                                <dx:ListBoxColumn FieldName="idTipoServicio" Caption="Id" Visible="false" />
                                                                                <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="400px" />
                                                                            </Columns>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Fecha Agenda Inicial:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                                        <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                                            Width="100px" TabIndex="6">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                    dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                }" />
                                                                        </dx:ASPxDateEdit>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Fecha Agenda Final:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                                        <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                                            Width="100px" TabIndex="7">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                }" />
                                                                        </dx:ASPxDateEdit>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Cliente VIP" RequiredMarkDisplayMode="Optional">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                                        <dx:ASPxComboBox ID="cmbVIP" runat="server" AutoPostBack="false" ClientInstanceName="cmbVIP" Width="100%"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Seleccione" Value="2" />
                                                                                <dx:ListEditItem Text="Si" Value="1" />
                                                                                <dx:ListEditItem Text="No" Value="0" />
                                                                            </Items>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Estado Novedad:" RequiredMarkDisplayMode="Optional">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                                        <dx:ASPxComboBox ID="cmbTieneNovedad" runat="server" AutoPostBack="false" ClientInstanceName="cmbTieneNovedad" Width="100%"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Seleccione una Opci&oacute;n" Value="0" />
                                                                                <dx:ListEditItem Text="Sin Novedad" Value="2" />
                                                                                <dx:ListEditItem Text="Con Novedad" Value="1" />
                                                                            </Items>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="MIN (MSISDN):">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                                        <dx:ASPxTextBox ID="TextBMin" ClientInstanceName="TextBMin"  runat="server" Width="80px" onkeypress="handleSpace(event)">
                                                                            <MaskSettings Mask="0000000000" ErrorText="Ingrese dígitos completos" />

                                                                        <ValidationSettings CausesValidation="true" Display="Dynamic"
                                                                            RequiredField-ErrorText="*" RequiredField-IsRequired="true" >                                                                           
                                                                            <RequiredField IsRequired="True" ErrorText="*"></RequiredField>
                                                                        </ValidationSettings>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Numero Identificaión:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                                        <dx:ASPxTextBox ID="TextBIdentificaion" ClientInstanceName="TextBIdentificaion" MaxLength="20" runat="server" Width="80px" onkeypress="handleSpace(event)"></dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Fecha Registro Inicial:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server">
                                                                        <dx:ASPxDateEdit ID="dateFechaRegistroInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaRegistroInicio"
                                                                            Width="100px" TabIndex="6">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                            dateFechaRegistroFin.SetMinDate(dateFechaRegistroInicio.GetDate());
                                                                        }" />
                                                                        </dx:ASPxDateEdit>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Fecha Registro Final:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server">
                                                                        <dx:ASPxDateEdit ID="dateFechaRegistroFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaRegistroFin"
                                                                            Width="100px" TabIndex="7">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                        dateFechaRegistroInicio.SetMaxDate(dateFechaRegistroFin.GetDate());
                                                                        }" />
                                                                        </dx:ASPxDateEdit>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Seudocodigo:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server">
                                                                        <dx:ASPxTextBox ID="txtSeudocodigo" ClientInstanceName="txtSeudocodigo" MaxLength="30" runat="server" Width="150px"></dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Eventos" ColSpan="3">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                                        <div style="float: left">
                                                                            <dx:ASPxImage ID="imgBuscar" runat="server" ImageUrl="../images/filtro.png" ToolTip="Búsqueda"
                                                                                ClientInstanceName="imgBuscar" Cursor="pointer">
                                                                                <ClientSideEvents Click="buscarInformacion" />
                                                                            </dx:ASPxImage>
                                                                            <div>
                                                                                <dx:ASPxLabel ID="ASPxLabel5" AutoPostBack="false" runat="server" Text="Filtrar" CssClass="comentario">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </div>
                                                                        <div style="float: left">
                                                                            <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/cancelar.png" ToolTip="Borrar Filtros"
                                                                                ClientInstanceName="imgBuscar" TabIndex="10" Cursor="pointer">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                LimpiaFormulario('formPrincipal');
                                                                rblTipoServicio.SetSelectedIndex(0);
                                                                cbFormatoExportar.SetSelectedIndex(0);
                                                                cmbCiudad.SetSelectedIndex(-1);
                                                            }" />
                                                                            </dx:ASPxImage>
                                                                            <div>
                                                                                <dx:ASPxLabel ID="lblComentarioBorrar" runat="server" Text="Borrar" CssClass="comentario">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </div>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:ASPxFormLayout>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxRoundPanel>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                                <ClientSideEvents CloseUp="function(s, e) { SetImageState(false); }" PopUp="function(s, e) { SetImageState(true); }" />
                            </dx:ASPxPopupControl>
                        </div>
                        <br />
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                        SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                        AutoPostBack="true" ClientInstanceName="cbFormatoExportar"
                                        Width="250px">
                                        <ClientSideEvents ButtonClick="function(s, e) {
	                                                        LoadingPanel.Show();
                                                        setTimeout('LoadingPanel.Hide();',2000);                                                                   
                                                        }" />
                                        <Items>
                                            <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" Selected="true" />
                                        </Items>
                                        <Buttons>
                                            <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                                <Image Url="../images/upload.png">
                                                </Image>
                                            </dx:EditButton>
                                        </Buttons>
                                        <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                            Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                            <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                            <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                                        </ValidationSettings>
                                    </dx:ASPxComboBox>
                                    <%--<dx:ASPxButton ID="btnCargarArchivo" runat="server" Text="CargarArchivo">
                                    <ClientSideEvents Click="function(s, e) { pcCargarArchivoTransporte.Show(); }" />
                                </dx:ASPxButton>--%>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                                        KeyFieldName="idServicioMensajeria" Theme="SoftOrange" Width="100%">
                                        <ClientSideEvents EndCallback="function(s, e) {
                                            MostrarInfoEncabezado(s, e);
                                         LoadingPanel.Hide();
                                        finalizarImprimirReporte(s.cpUrlReporte)
                                        }"></ClientSideEvents>
                                        <Columns>
                                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="1" Width="40px">
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink ID="lbVer" runat="server" ImageUrl="~/images/view.png" Cursor="pointer" ClientVisible="true"
                                                        ToolTip="Ver Información del Servicio" OnInit="Link_Init" Visible="true">
                                                        <ClientSideEvents Click="function(s, e){
                                                            
                                                          verServicio({0},{1}) ;
                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkNotificarNoCobertura" runat="server" ImageUrl="~/images/stop.png" Cursor="pointer" ClientVisible="true"
                                                        ToolTip="Notificar no cobertura" OnInit="Link_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          NotificarNoCobertura({0},{1});                             
                                                }" />
                                                    </dx:ASPxHyperLink>

                                                    <dx:ASPxHyperLink ID="lnkEditar" runat="server" ImageUrl="~/images/Edit-32.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Adicionar Novedad" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          ConfirmarServicio({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkPdfFormulario" runat="server" ImageUrl="~/images/DxPdf.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Descargar PDF" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'ImprimirFormulario', {0}); ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkConfirma" runat="server" ImageUrl="~/images/confirmation.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Confirmar Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          ConfirmarServicio({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkDespacho" runat="server" ImageUrl="~/images/trans_small.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Despachar Pedido" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          DespachoServicio({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkAsignarZona" runat="server" ImageUrl="~/images/encontrar_small.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Asignar Zona" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          AsignarZona({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbModificarServicio" runat="server" ImageUrl="~/images/Edit-User.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Modificar Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          ModificarServicio({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbCambioServicio" runat="server" ImageUrl="~/images/usuario.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Registrar Cambio de Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          CambioServicio({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbAbrirServicio" ClientInstanceName="lbAbrirServicio" runat="server" ImageUrl="~/images/unlock.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Abrir Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          AbrirCancelarServicio('AbrirServicio',{0},{1}) ;                                         
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="ibCancelarServicio" runat="server" ImageUrl="~/images/package.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Cerrar Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          AbrirCancelarServicio('cancelarServicio',{0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkAdendoServicio" runat="server" ImageUrl="~/images/pdf.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Adendo Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                         EjecutarCallback(s,e,'adendoServicio',{0},{1}) ;          
                                                                                                   
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbUrgente" runat="server" ImageUrl="~/images/important.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Marcar como Urgente" OnInit="LinkidServicio_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'marcarUrgente', {0});        
                                                                                                   
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbReactivar" runat="server" ImageUrl="~/images/Open.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Reactivar servicio" OnInit="LinkidServicio_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          ReactivarServicio({0}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbServicioTecnico" runat="server" ImageUrl="~/images/kit_tools.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Gestionar Servicio Técnico" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          GestionarServicioTecnico({0},{1}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbDevolverVenta" runat="server" ImageUrl="~/images/return.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Devolver Venta a Call Center" OnInit="LinkidServicio_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          DevolverVenta({0}) ;                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbLegalizar" runat="server" ImageUrl="~/images/DxMarker.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Legalizar Servicio Financiero" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          LegalizarServicioFinanciero({0},{1});                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="LbAsignacion" runat="server" ImageUrl="~/images/DXLectora16.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Asignación de Seriales" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          AsignarSeriales({0},{1});                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lbConfirmaCorp" runat="server" ImageUrl="~/images/calendar-select-days.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Confirmar Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          ConfirmaServicioCorporativo({0},{1});                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="LnkEditCorp" runat="server" ImageUrl="~/images/DxEdit.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Editar Servicio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          EditaServicioCorporativo({0},{1});                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="LnkCamCorp" runat="server" ImageUrl="~/images/NewProcess.png" Cursor="pointer" ClientVisible="false"
                                                        ToolTip="Despacho con cambio" OnInit="LinkDatos_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                          DesCamServicioCorporativo({0},{1});                                                    
                                                }" />
                                                    </dx:ASPxHyperLink>

                                                    <dx:ASPxCheckBox ID="CheReagenda" runat="server" HeaderText="reagenda" ClientVisible="false" OnInit="LinkDatosCheck_Init"
                                                        ToolTip="Quitar Check de reagenda">
                                                        <ClientSideEvents CheckedChanged="function(s,e){QuitarCheckReagenda({0},{1}); }" />
                                                    </dx:ASPxCheckBox>
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="2" Caption="Id Servicio" FieldName="idServicioMensajeria" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="3" Caption="Empresa" FieldName="empresa" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="4" Caption="N&uacute;mero Radicado" FieldName="numeroRadicado" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="5" Caption="Tipo de Servicio" FieldName="tipoServicio" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="6" Caption="Fecha Asignación" FieldName="fechaAsignacion" ShowInCustomizationForm="true">
                                                <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="7" Caption="Fecha de Agenda" FieldName="fechaAgenda" ShowInCustomizationForm="true">
                                                <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="8" Caption="Usuario Ejecutor" FieldName="usuarioEjecutor" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="9" Caption="Usuario Consultor" FieldName="nombreConsultor" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="10" Caption="Jornada" FieldName="jornada" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="11" Caption="Estado" FieldName="estado" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="12" Caption="Fecha De Confirmacion" FieldName="fechaConfirmacion" ShowInCustomizationForm="true">
                                                <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="13" Caption="Responsable de Entrega" FieldName="responsableEntrega" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="14" Caption="Tiene Novedad" FieldName="tieneNovedad" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="15" Caption="Nombre de Cliente" FieldName="nombreCliente" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="16" Caption="Persona de Contacto" FieldName="personaContacto" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="17" Caption="Ciudad Cliente" FieldName="ciudadCliente" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="18" Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="19" Caption="Barrio" FieldName="barrio" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="20" Caption="Tel&eacute;fono" FieldName="telefonoContacto" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="21" Caption="permisosOpciones" FieldName="permisosOpciones" ShowInCustomizationForm="false" Visible="false">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataColumn VisibleIndex="22" Caption="">
                                                <DataItemTemplate>
                                                    </td> </tr>
                                                <tr>
                                                    <td class="field">Direcci&oacute;n
                                                    </td>
                                                    <td colspan="16" style="text-align: left">
                                                        <asp:Literal runat="server" ID="ltdireccion" Text='<%# Bind("direccion") %>'></asp:Literal>
                                                    </td>
                                                </tr>
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                            <dx:GridViewDataColumn VisibleIndex="23" Caption="">
                                                <DataItemTemplate>
                                                    </td> </tr>
                                                <tr>
                                                    <td class="field">Observaci&oacute;n
                                                    </td>
                                                    <td colspan="16" style="text-align: left">
                                                        <asp:Literal runat="server" ID="ltObservacion" Text='<%# Bind("Observacion") %>'></asp:Literal>
                                                    </td>
                                                </tr>
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                        </Columns>
                                        <SettingsBehavior AllowSelectByRowClick="true" />
                                        <Settings ShowHeaderFilterButton="false"></Settings>
                                        <SettingsPager PageSize="20">
                                            <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                        </SettingsPager>
                                        <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                        <SettingsText Title="Resultado B&#250;squeda"
                                            EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                    </dx:ASPxGridView>
                                    <dx:ASPxGridViewExporter ID="expgveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                                </td>
                            </tr>
                        </table>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>

        </div>
        <dx:ASPxPopupControl ID="pcAsignarTransporte" runat="server"
            ClientInstanceName="pcAsignarTransporte" Modal="true" Width="630px" Height="300px" CloseAction="CloseButton"
            HeaderText="Transporte" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">

            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl3" runat="server">
                    <br />
                    <table align="center" class="tabla">
                        <tr>
                            <td></td>
                            <td class="field">Id. Delivery:
                            </td>
                            <td>
                                <dx:ASPxLabel ID="lblIdDelivery" runat="server" ClientInstanceName="lblIdDelivery"></dx:ASPxLabel>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="field">Tipo de Transporte:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbTipoTransporte" runat="server" ClientInstanceName="cmbTipoTransporte" Width="250px"
                                    IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                    <ClientSideEvents SelectedIndexChanged="function (s, e) {mostrarCamposTipoTransporte(s,e);}" />
                                    <Items>
                                        <dx:ListEditItem Value="trTransportadora" Text="transportadora" />
                                        <dx:ListEditItem Value="trMotorizado" Text="motorizado" />
                                    </Items>
                                    <ItemStyle Wrap="True" />
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr id="trMotorizado">
                            <td class="field">Motorizado:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtMotorizado" runat="server" ClientInstanceName="txtMotorizado"
                                    MaxLength="15" Width="100px">
                                    <ClientSideEvents KeyUp="function (s,e){invocarCallBackMotorizado(s,e);}" />
                                </dx:ASPxTextBox>
                            </td>
                            <td>
                                <dx:ASPxCallbackPanel ID="cpFiltroMotorizado" runat="server" ClientInstanceName="cpFiltroMotorizado">
                                    <ClientSideEvents EndCallback="function(s,e){  finalizarCallBackMotorizado(s,e);}" />
                                    <PanelCollection>
                                        <dx:PanelContent runat="server">
                                            <dx:ASPxComboBox ID="cmbMotorizado" runat="server" ClientInstanceName="cmbMotorizado"
                                                IncrementalFilteringMode="Contains" TextField="referencia" ValueField="idtercero"
                                                Width="195px">
                                                <ButtonStyle>
                                                    <HoverStyle>
                                                        <border borderstyle="Solid" />
                                                    </HoverStyle>
                                                </ButtonStyle>
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnMotorizadoChanged(s); }" />
                                            </dx:ASPxComboBox>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
                            </td>
                            <td class="field">Placa:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtPlacaMotorizado" runat="server" ClientInstanceName="txtPlacaMotorizado"
                                    MaxLength="15" Width="100px">
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr id="trTransportadora">
                            <td></td>
                            <td>
                                <div style="height: 124px;">
                                    <table align="center" class="tabla">
                                        <tr>
                                            <td height="20px" class="field">Transportadora:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20px" class="field">Numero de Guia:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20px" class="field">Nombre Responsable Entrega:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20px" class="field">Cedula Responsable Entrega:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20px" class="field">Placa Responsable Entrega:
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <table align="center" class="tabla">
                                        <tr>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbTransportadora" runat="server" ClientInstanceName="cmbTransportadora" Width="250px"
                                                    IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idtercero">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="idtercero" Caption="Id" Width="20px" Visible="false" />
                                                        <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNumeroGuia" runat="server" ClientInstanceName="txtNumeroGuia">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNombreTransportadora" runat="server" ClientInstanceName="txtNombreTransportadora">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxTextBox ID="txtCedulaTransportadora" runat="server" ClientInstanceName="txtCedulaTransportadora">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxTextBox ID="txtPlacaTransportadora" runat="server" ClientInstanceName="txtPlacaTransportadora">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div align="center">
                        <br />
                        <dx:ASPxButton ID="lbAsignarTransportador" ClientInstanceName="lbAsignarTransportador" AutoPostBack="false" runat="server" Text="&nbsp;Asignar Transportador" ValidationGroup="modificacionServicio" SpriteCssFilePath="~/images/unlock.png" Height="30px" Width="233px">
                            <ClientSideEvents Click="function(s, e) {
                                             pcAsignarTransporte.Hide();
                                             AsignarTransportador();
                                        }" />
                        </dx:ASPxButton>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>


        <dx:ASPxPopupControl ID="pcGeneral" runat="server" EnableViewState="False"
            ClientInstanceName="pcGeneral" Modal="True" CloseAction="CloseButton"
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True" RefreshButtonStyle-Wrap="True" ShowRefreshButton="True">
            <ClientSideEvents CloseButtonClick="function(s, e) {
	                EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultar', 1);
                }" />
            <RefreshButtonStyle Wrap="True"></RefreshButtonStyle>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True"></dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="pcReagenda" runat="server"
            ClientInstanceName="pcReagenda" Modal="true" Width="430px" Height="250px" CloseAction="CloseButton"
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl ID="ContentControl1" runat="server">
                    <table align="center">
                        <tr>
                            <td class="field">Id. Servicio:
                            </td>
                            <td>

                                <dx:ASPxLabel ID="lblIdServicio" runat="server" ClientInstanceName="lblIdServicio"></dx:ASPxLabel>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Tipo de Novedad:</td>
                            <td>
                                <asp:DropDownList ID="ddlNovedadReagenda" runat="server" />
                                <asp:RequiredFieldValidator ID="rfvAgenda" runat="server" ValidationGroup="vgReagenda" InitialValue="0"
                                    ControlToValidate="ddlNovedadReagenda" ErrorMessage="Seleccione un tipo de novedad." Display="Dynamic" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Observación:</td>
                            <td>
                                <asp:TextBox ID="txtObservacionReagenda" runat="server" Rows="5" Columns="30" TextMode="MultiLine" />
                                <asp:RequiredFieldValidator ID="rfvObservacionAgenda" runat="server" ValidationGroup="vgReagenda" Display="Dynamic"
                                    ControlToValidate="txtObservacionReagenda" ErrorMessage="Ingrese una observación." />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <dx:ASPxButton ID="btnReagenda1" AutoPostBack="false" ClientInstanceName="btnReagenda" runat="server" Text="Check Reagenda" ValidationGroup="vgReagenda">
                                    <ClientSideEvents Click="function(s, e) {
                                            pcReagenda.Hide();
                                         EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'QuitarCheckReagenda', lblIdServicio.GetValue() );
                                        }" />
                                </dx:ASPxButton>

                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="pcReactivarServicio" runat="server"
            ClientInstanceName="pcReactivarServicio" Modal="true" Width="430px" Height="250px" CloseAction="CloseButton"
            HeaderText="Reactivar Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                    <table align="center" class="tabla">
                        <tr>
                            <td class="field">¿Con cambio de Radicado?
                            </td>
                            <td>
                                <dx:ASPxRadioButtonList ID="rbReactivacion" AutoPostBack="false" runat="server" ClientInstanceName="rbReactivacion" ValueType="System.Int32" ValidationGroup="cambioRadicado" RepeatDirection="Horizontal">
                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
	                                            ActivarRadicado();
                                            }" />
                                    <Items>
                                        <dx:ListEditItem Value="0" Text="No" />
                                        <dx:ListEditItem Value="1" Text="Si" />
                                    </Items>
                                </dx:ASPxRadioButtonList>
                                <dx:ASPxLabel ID="lbNuevoRadicado" ClientInstanceName="lbNuevoRadicado" ClientVisible="false" runat="server" Text="&nbsp;Nuevo radicado:"></dx:ASPxLabel>
                                <dx:ASPxTextBox ID="txtNuevoRadicado" ClientInstanceName="txtNuevoRadicado" ClientVisible="false" runat="server" Width="170px">
                                    <ClientSideEvents LostFocus="function(s, e) {
	                                        ValidarNumeroRadicado();
                                        }" />
                                </dx:ASPxTextBox>
                                <dx:ASPxImage ID="imgError" ClientInstanceName="imgError" runat="server" ImageUrl="~/images/close.gif" ClientVisible="false"
                                    ToolTip="El número de radicado digitado ya existe.">
                                </dx:ASPxImage>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Observación:
                            </td>
                            <td>
                                <dx:ASPxMemo ID="txtObservacionReactivacion" ClientInstanceName="txtObservacionReactivacion" runat="server" Height="71px" Width="300px"></dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <br />
                                <br />
                                <dx:ASPxButton ID="lbReactivar" AutoPostBack="false" ClientInstanceName="lbReactivar" runat="server" ToolTip="&nbsp;Reactivar Servicio" ValidationGroup="reactivarServicio">
                                    <ClientSideEvents Click="function(s, e) {
	                                        validaSeleccionReactivacion();
                                            }" />
                                    <Image Url="~/images/Open.png">
                                    </Image>
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="pcPopup" runat="server" ClientInstanceName="popup" EncodeHtml="false"
            Width="500px" Height="500px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="pcAbrirCancelarServicio" runat="server"
            ClientInstanceName="pcAbrirCancelarServicio" Modal="true" Width="630px" Height="250px" CloseAction="CloseButton"
            HeaderText="Abrir O Cancelar Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server">
                    <table align="center" class="tabla">
                        <asp:Panel ID="pnlMensajeRestriccionNovedad" Visible="false" runat="server">
                            <tr>
                                <td colspan="2">
                                    <blockquote>
                                        <p>No es posible cerrar el radicado, por favor verifique que exista una novedad creada para el proceso actual y fecha de hoy.</p>
                                    </blockquote>
                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td class="field">Observacion:
                            </td>
                            <td>
                                <asp:TextBox ID="txtObservacionModificacion" runat="server" Rows="6" Width="400px"
                                    TextMode="MultiLine"></asp:TextBox>
                                <div>
                                    <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ErrorMessage="Se requiere una observaci&oacute;n para continuar con el proceso"
                                        Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="txtObservacionModificacion"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <asp:Panel ID="pnlEstadoReapertura" Visible="false" runat="server">
                            <tr>
                                <td class="field">Estado de reapertura:
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="ddlEstadoReapertura" ClientInstanceName="ddlEstadoReapertura" runat="server" ValueType="System.String" ValueField="idEstadoReapertura"></dx:ASPxComboBox>
                                    <div>
                                        <asp:RequiredFieldValidator ID="rfvddlEstadoReapertura" runat="server" ErrorMessage="El estado de reapertura es requerido."
                                            Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="ddlEstadoReapertura"
                                            InitialValue="0" />
                                    </div>
                                </td>
                            </tr>
                        </asp:Panel>

                        <tr>
                            <td colspan="1" align="center">
                                <dx:ASPxButton ID="lbAbrirServicio" ClientInstanceName="lbAbrirServicio" AutoPostBack="false" runat="server" Text="&nbsp;Abrir Servicio" ValidationGroup="modificacionServicio" SpriteCssFilePath="~/images/unlock.png">
                                    <ClientSideEvents Click="function(s, e){
                                                            AbrirCancelarServicioMensajeria('AbrirServicio', hfReactivarIdServicio.Get('idServicio'));
                                                        
                                                }" />
                                </dx:ASPxButton>
                            </td>
                            <td colspan="1" align="center">
                                <dx:ASPxButton ID="lbCancelarServicio" AutoPostBack="false" ClientInstanceName="lbCancelarServicio" runat="server" Text="Cancelar Servicio" ValidationGroup="modificacionServicio" SpriteCssFilePath="~/images/package.png">
                                    <ClientSideEvents Click="function(s, e){
                                             AbrirCancelarServicioMensajeria('cancelarServicio', hfReactivarIdServicio.Get('idServicio'));                                                         
                                                }" />
                                </dx:ASPxButton>
                            </td>
                            <td colspan="1" align="center">
                                <dx:ASPxHyperLink ID="lbAbortarModificacion" AutoPostBack="false" runat="server" ImageUrl="~/images/cancelar.png" Text="Cancelar" ToolTip="Cancelar" CausesValidation="false">
                                    <ClientSideEvents Click="function(s, e){
                                                         pcAbrirCancelarServicio.Hide();
                                                }" />
                                </dx:ASPxHyperLink>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <!-- iframe para uso de selector de fechas -->
        <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible; position: absolute; top: -500px"
            name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
            frameborder="0" width="132" scrolling="no" height="142"></iframe>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
        <script src="../include/jquery-1.min.js" type="text/javascript"></script>
        <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
        <script type="text/javascript" src="Scripts/PoolServiciosNew.js"></script>
        <div id="dvPoolRecepcioRadicados" style="display: none">
            <div id="dvRecepcionRadicado">
                <div class="form-group">
                    <label for="txtCedulaRadiacado" class="col-lg-2 control-label">Cédula o Radicado</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control" id="txtCedulaRadiacado" onkeyup="return CargarBusquedaVenta('Cedula', this)" placeholder="Ingrese su búsqueda..." runat="server" />
                        <br />
                    </div>
                </div>
                <div class="form-group" style="display: none">
                    <label for="txtCampaniaEstrategia" class="col-lg-2 control-label">Campaña o Estrategia</label>
                    <div class="col-lg-10">
                        <input type="text" class="form-control" id="txtCampaniaEstrategia" onkeyup="CargarBusquedaVenta('Campania')" placeholder="Ingrese su búsqueda..." runat="server" />
                    </div>
                </div>
            </div>

        </div>

        <div id="dvTblBusquedaVenta">
            <table class="table" id="tblBusquedaVenta">
            </table>
            <asp:HiddenField ID="hdfIdRadicado" runat="server" />
            <asp:HiddenField ID="hdfContenidoTablaResultado" runat="server" />
        </div>

        <div id="dvFupload" style="display: none">
            <asp:FileUpload ID="fuArchivo" runat="server" accept="jpg|png" maxlength="4" onChange="OnUpload();" TabIndex="7" Width="400px"></asp:FileUpload>
            <div>
                <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                    CssClass="listSearchTheme" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivo"
                    ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.pdf|.jpg|.PDF|.JPG|.png|.PNG|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                    ControlToValidate="fuArchivo" ValidationGroup="vgAdicionarArchivo" />
            </div>
            <asp:Button ID="btnAgregarSoportes" class="btn btn-success" runat="server" Text="Guardar" OnClientClick="GuardarTablaMemoria()" OnClick="btnAgregarSoportes_Click" />
        </div>

        <div id="dvContentGridImages">

            <asp:GridView ID="gvSoporte" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered bs-table" AllowPaging="true">
                <HeaderStyle BackColor="#337ab7" Font-Bold="True" ForeColor="White" />
                <EditRowStyle BackColor="#ffffcc" />
                <EmptyDataRowStyle ForeColor="Red" CssClass="table table-bordered" />
                <EmptyDataTemplate>
                    ¡No se han cargado documentos!  
                </EmptyDataTemplate>

                <%--Paginador...--%>
                <PagerTemplate>
                    <div class="row" style="margin-top: 20px;">
                        <div class="col-lg-1" style="text-align: right;">
                            <h5>
                                <asp:Label ID="MessageLabel" Text="Ir a la pág." runat="server" /></h5>
                        </div>
                        <div class="col-lg-1" style="text-align: left;">
                            <asp:DropDownList ID="PageDropDownList" Width="50px" AutoPostBack="true" runat="server" CssClass="form-control" /></h3>
                        </div>
                        <div class="col-lg-10" style="text-align: right;">
                            <h3>
                                <asp:Label ID="CurrentPageLabel" runat="server" CssClass="label label-warning" /></h3>
                        </div>
                    </div>
                </PagerTemplate>

                <Columns>
                    <%--campos no editables...--%>

                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Width="20%" />
                    <asp:BoundField DataField="tipoDocumento" HeaderText="Tipo Documento" SortExpression="tipoDocumento" />

                    <%--campos editables...--%>

                    <asp:TemplateField HeaderText="Opciones">
                        <ItemTemplate>
                            <asp:Image ID="imgImagenSubida" runat="server" Width="10%" onmouseover="VerImagenGrande(this)" onmouseout="Pequena(this)" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div id="dvNovedadesDocs" title="Novedades">
            <table class="table" id="tblNovedadesDocs">
            </table>
        </div>

        <div id="dvImagenesDocs" title="Documentos - Click para ampliar imagen">
        </div>


        <div id="dvCausalRechazoDocs">
            <table class="table" id="tblCausalDevolucion">
            </table>
        </div>

        <div class="PrintArea">
            <div>
                <img id="imgImpresion" />
            </div>
        </div>
        <br />
        <br />
    </form>
</body>
</html>

