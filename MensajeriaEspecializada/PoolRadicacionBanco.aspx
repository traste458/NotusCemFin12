<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolRadicacionBanco.aspx.vb" Inherits="BPColSysOP.PoolRadicacionBanco" ValidateRequest="false" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>:: Pool de Radicación en Banco ::</title>

    <link href="../css/EstiloAutocomplete.css" rel="stylesheet" />
    <link href="../css/jquery-confirm.css" rel="stylesheet" />
    <link href="../css/StyleAlert.css" rel="stylesheet" />
    <link href="../css/bootstrap3.3.7.min.css" rel="stylesheet" />
    <script type="text/javascript" src="../include/jquery-1.12.4.js"></script>
    <script type="text/javascript" src="../include/jquery-1.12.1-ui.js"></script>
    <script src="../include/jquery-confirm.js"></script>
    <script src="../include/ScriptAlert.js"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <script src="../include/jquery.PrintArea.js"></script>

    <style type="text/css">

        #dvContenedorMasivo {
            width: 67%;
            margin-top: 3%;
            margin-left: 8%;
        }

        #dvRecepcionRadicado {
            width: 67%;
            margin-top: -7%;
            margin-left: 8%;
        }

        #dvTblBusquedaVenta {
            margin-top: 7%;
        }

        #dvTblBusquedaVenta {
            margin-top: 10%;
        }

        #btnRecibirRad, #btnPasoRadicar {
            height: 44px;
            font-size: 100%;
        }

        #dvBotonesAcciones {
            margin-left: 9%;
            margin-top: 3%;
        }

        /* Style check type Switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }

            .switch input {
                display: none;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            -webkit-transition: .4s;
            transition: .4s;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 26px;
                width: 26px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                -webkit-transition: .4s;
                transition: .4s;
            }

        input:checked + .slider {
            background-color: #2196F3;
        }

        input:focus + .slider {
            box-shadow: 0 0 1px #2196F3;
        }

        input:checked + .slider:before {
            -webkit-transform: translateX(26px);
            -ms-transform: translateX(26px);
            transform: translateX(26px);
        }

        /* Rounded sliders */
        .slider.round {
            border-radius: 34px;
        }

            .slider.round:before {
                border-radius: 50%;
            }

        /* End Style check type Switch */
    </style>

    <script type="text/javascript">
        var _globalIdServicio = [],
            _globalInfRadicadosPlanilla = [],
            //_globalOficina = 0,
            _globalPasadasCuerpoPlanilla = 0,
            _globalEsValidaDestruccion = false,
            _globalByteImagenes = [],
            _globalAutocomplete,
            _globalControl,
            _srcGlobalImagenMC = '',
            _globalInfRadicadosPlanillaMultiple = [];

        function EjecutarCallback(s, e, opcion, idServicio, idTiposervicio) {
            gvDatos.PerformCallback(opcion + ':' + idServicio + ':' + idTiposervicio);
        }

        function CargarBusquedaVenta(s, e, evt) {

            if (evt.which == 13 || evt.which == 38 || evt.which == 40) {

                if (evt.which == 13)
                {
                    EjecutarCallback('', '', 'ConsultaVentaCliente', 2);
                }
                return false;
            }
            else {
                if (s == 'Campania') {
                    EjecutarCallback('', '', 'ConsultaVentaCliente', 2);
                }
                else if (s == 'Cedula') {
                    EjecutarCallback('', '', 'ConsultaVentaCliente', 1);
                }
            }
        }

        function AutoCompletar(_busqueda) {
            var control;
            var busqueda = _busqueda.split('|');

            if (busqueda[0] != '-1' && busqueda[0] != '-2' && busqueda[0] != '-3' && busqueda[0] != '-4' && busqueda[0] != '-5' && busqueda[0] != '-7' && busqueda[0] != '-8' &&
                busqueda[0] != '-9' && busqueda[0] != '-10' && busqueda[0] != '-11' && busqueda[0] != '-12' && busqueda[0] != '-22' && busqueda[0] != '-23') {
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
                    _globalControl = control;
                }
                else if (busqueda[0] == 2) {
                    PintarTablaRadicado($("input[id$='txtCedulaRadiacado']").val());
                    //control = 'txtCampaniaEstrategia';
                    //_globalControl = control;
                }


                $("input[id$='" + control + "']").autocomplete({
                    source: resultadoBusqueda,
                    select: function (event, ui) {
                        PintarTablaRadicado(ui.item.value);
                    },
                });
            }
            else if (busqueda[0] == '-1') {
                PintarDocumentosByte(busqueda);
            }
            else if (busqueda[0] == '-2') {
                PintarCausalesRechazoMCBanco(busqueda);
                //LlenarCausalesRezhazo($.parseJSON(busqueda[1]));
            }
            else if (busqueda[0] == '-3') {
                var retorno = busqueda[1].split('_');
                alert(retorno[0], busqueda[2].split('_')[0]);
                if (retorno[1] != '2') {
                    $('#dvCausalRechazoDocs').dialog('close');
                }
            }
            else if (busqueda[0] == '-4') {
                $.alert(busqueda[1]);
            }
            else if (busqueda[0] == '-5') {
                if (busqueda[2] == 'verde') {
                    PintarTablaRecepcionMasiva($.parseJSON(busqueda[3]));
                }
                alert(busqueda[1], busqueda[2]);
            }
            else if (busqueda[0] == '-7') {
                alert(busqueda[1], busqueda[2]);
            }
            else if (busqueda[0] == '-8') {
                var color = busqueda[2].split('_')[0];
                var archivo = busqueda[2].split('_')[2];
                alert(busqueda[1], color);
                $('#chkSeleccionMultiple').prop('checked', false);
                $('#dvServiciosSeleccionados').css('display', 'none');
                _globalInfRadicadosPlanillaMultiple = [];
                LimpiarGlobales();

                window.location.href = 'DescargarDocumento.aspx?nombreArchivo=' + archivo + '&rutaArchivo=/MensajeriaEspecializada/TemporalPlanillaRadicacionBanco/';
            }
            else if (busqueda[0] == '-9') {
                var color = busqueda[2].split('_')[0];
                var mensaje = busqueda[1];
                var estado = busqueda[2].split('_')[1];

                if (estado >= 0) {
                    _globalEsValidaDestruccion = true;
                }
                else {
                    alert(mensaje, color);
                    _globalEsValidaDestruccion = false;
                    window.stop();
                }
                if (_globalPasadasCuerpoPlanilla == _globalIdServicio.length - 1) {
                    if (_globalEsValidaDestruccion) {
                        DestruccionDocumentos();
                    }
                    _globalPasadasCuerpoPlanilla = 0;
                }

                _globalPasadasCuerpoPlanilla++;
            }
            else if (busqueda[0] == '-10') {
                var finalizacion = $.parseJSON(busqueda[1]);
                if (finalizacion.length > 0) {
                    var color = finalizacion[0].color;
                    var servicios = '';
                    if (color == 'rojo') {
                        for (x = 0; x < finalizacion.length; x++) {
                            var idRadicado = finalizacion[x].idServicio;
                            var estado = finalizacion[x].nombreEstado;
                            servicios += 'Radicado: ' + idRadicado + ', Estado: ' + estado + '<br />';
                        }
                    }
                    alert(finalizacion[0].mensaje + servicios, finalizacion[0].color);
                }
            }
            else if (busqueda[0] == '-11') {
                PintarNovedades(busqueda);
            }
            else if (busqueda[0] == '-12') {
                var mensaje = busqueda[1];
                var color = busqueda[2];

                alert(mensaje, color);
            }
            else if (busqueda[0] == '-22') {
                if (busqueda[1].length > 0) {
                    CausalesRechazoMC($.parseJSON(busqueda[1]));
                }
            }
            else if (busqueda[0] == '-23') {
                if (busqueda[1].length > 0) {
                    CausalesRechazoBanco($.parseJSON(busqueda[1]));
                }

            }
        }

        function PintarTablaRadicado(itemSeleccionado)
        {
            LimpiarGlobales();
            $('#dvRecepcionRadicado').css('margin-top', '3%');

            $("input[id$='txtCedulaRadiacado']").val('');
            $('#tblBusquedaVenta').empty();
            $('#dvContentGridImages').empty();
            $('#dvTblBusquedaVenta').css('display', 'inline');

            var campania, idRadicado, identificacion, nombre, codEstrategia = '', novedadesDocumentos = '', obsTemp = '',
                codTemp = '', encabezadoTblMensajeria = 0, cargado = '', subirDoc = '', estadoRadicado = '',
                consecutivoInternoOutsourcing = '', codigoOutsourcing = '';

            for (x = 0; x < _globalAutocomplete.length; x++) {
                if (_globalAutocomplete[x].Busqueda.toString() == itemSeleccionado) {
                    campania = _globalAutocomplete[x].Campania;
                    idRadicado = _globalAutocomplete[x].numeroRadicado;
                    identificacion = _globalAutocomplete[x].identicacion;
                    nombre = _globalAutocomplete[x].nombre;
                    codEstrategia = _globalAutocomplete[x].CCEcodigo;
                    docAprobado = _globalAutocomplete[x].docsAprobados;
                    consecutivoInternoOutsourcing = _globalAutocomplete[x].consecutivoInternoOutsourcing;
                    codigoOutsourcing = _globalAutocomplete[x].codigoOutsourcing;
                    subirDoc = 'disabled';
                    cargado = '';
                    estadoRadicado = _globalAutocomplete[x].idEstado + '_' + _globalAutocomplete[x].EstadoServicio

                    codTemp = _globalAutocomplete[x].CCEcodigo;


                    if (encabezadoTblMensajeria == 0) {
                        //Encabezado tabla Servicio Mensajería o Radicado
                        tr = $('<tr/>');
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Campaña</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Radicado</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Estado</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Identificación</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Nombre</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Código Estrategia</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Ver Doc.</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Cargar Doc.</td>");
                        tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados()'>Novedades</td>");
                        tr.append("<td style='cursor:pointer'><label class='switch'><input id='chkGenerarOrdenRadicado' onclick='SeleccionDeRadicados()' type='checkbox'><span class='slider round'></span></label>Seleccione...</td>");
                        //tr.append("<td style='cursor:pointer'><input type='checkbox' id='chkSeleccionarTodo' onclick='SeleccionDeRadicados()'/> Seleccione..</td>");

                        $('#tblBusquedaVenta').append(tr);
                        $('#tblBusquedaVenta').prepend('<br />');
                        $('#tblBusquedaVenta').find('> tbody > tr')[0].className = 'danger';
                    }
                    encabezadoTblMensajeria++;

                    //Cuerpo tabla Servicio Mensajería o Radicado
                    tr = $('<tr/>');
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'>" + campania + "</td>");
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'>" + idRadicado + "</td>");
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'>" + estadoRadicado + "</td>");
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'>" + identificacion + "</td>");
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'>" + nombre + "</td>");
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'>" + codEstrategia + "</td>");

                    if (docAprobado == null) {
                        cargado = 'disabled';
                    }
                    if (_globalAutocomplete[x].idEstado == 275 || _globalAutocomplete[x].idEstado == 281 || _globalAutocomplete[x].idEstado == 283) {
                        subirDoc = '';
                    }
                    tr.append("<td><button id='btnVerDoc_" + x + "' type='button' class='btn btn-info' onclick='VerDocsMC(this)'" + cargado + ">Ver</button></td>");
                    tr.append("<td><button type='button' id='btnSubirDocs' class='btn btn-success' onclick='Mostrar(this)'" + subirDoc + ">Subir</button></td>");
                    tr.append("<td><button type='button' id='btnNovedades' class='btn btn-success' onclick='CargarNovedades(this)'>Ver</button></td>");
                    tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'><label class='switch'><input id='chkGenerarOrdenRadicado' type='checkbox'><span class='slider round'></span></label></td>");
                    //tr.append("<td style='cursor:pointer' onclick='SeleccionDeRadicados(this)'><input type='checkbox' id='chkGenerarOrdenRadicado' /></td>");

                    tr.append("<td style='display:none'>" + docAprobado + "</td>");
                    tr.append("<td style='display:none'>" + consecutivoInternoOutsourcing + "</td>");
                    tr.append("<td style='display:none'>" + codigoOutsourcing + "</td>");
                    $('#tblBusquedaVenta').append(tr);
                    $("input[id$='txtCedulaRadiacado']").focus();
                    $('#tblBusquedaVenta').find('> tbody > tr').addClass('success');

                    if (_globalControl == 'txtCampaniaEstrategia') {
                        TablaPorCampania(campania, idRadicado, identificacion, nombre, codEstrategia, obsTemp);
                    }
                }


            }
        }

        function LimpiarGlobales() {
            $('#tblGenerarPlanilla').empty();
            _globalIdServicio = [];
            _globalInfRadicadosPlanilla = [];
            //_globalOficina = 0;
            _globalPasadasCuerpoPlanilla = 0;
            _globalByteImagenes = [];
            _globalControl = '';
            _srcGlobalImagenMC = '';
            $('#tblNovedadesRadicadosEncabezado').empty();
            $('#tblNovedadesRadicadosCuerpo').empty();

        }

        function PintarTablaRecepcionMasiva(json) {
            if (json.length > 0) {
                var indice = 0;

                if ($('#tblRecepcionMasiva').find('> tbody > tr').length == 0) {
                    //Encabezado tabla Recepción Masiva Radicados
                    tr = $('<tr/>');
                    tr.append("<td>Radicado</td>");
                    tr.append("<td>Campaña</td>");
                    tr.append("<td>Estrategia</td>");
                    tr.append("<td>Usuario</td>");
                    tr.append("<td>Identificación</td>");
                    tr.append("<td>Estado Radicado</td>");
                    tr.append("<td>Ciudad</td>");
                    tr.append("<td>Dirección</td>");
                    tr.append("<td>Teléfono</td>");
                    tr.append("<td>Detalle</td>");
                    tr.append("<td>Anular acción</td>");
                    $('#tblRecepcionMasiva').append(tr);
                    $('#tblRecepcionMasiva').find('> tbody > tr')[indice].className = 'danger';
                }

                indice = $('#tblRecepcionMasiva').find('> tbody > tr').length;

                //Cuerpo tabla Recepción Masiva Radicados
                tr = $('<tr/>');
                tr.append("<td>" + json[0].idServicioMensajeria + "</td>");
                tr.append("<td>" + json[0].Campania + "</td>");
                tr.append("<td>" + json[0].CCEcodigo + "</td>");
                tr.append("<td>" + json[0].Usuario + "</td>");
                tr.append("<td>" + json[0].identicacion + "</td>");
                tr.append("<td>" + json[0].EstadoRadicado + "</td>");
                tr.append("<td>" + json[0].Ciudad + "</td>");
                tr.append("<td>" + json[0].direccion + "</td>");
                tr.append("<td>" + json[0].telefono + "</td>");
                tr.append("<td>" + json[0].observacion + "</td>");
                tr.append('<td style="text-align: center;"> <img src="../images/DXEraser16.png" onclick="DevolverEstadoRecepcionRadicado(this)" style="cursor: pointer"> </td>');

                $('#tblRecepcionMasiva').append(tr);
                $('#tblRecepcionMasiva').find('> tbody > tr')[indice].className = 'success';
            }

        }

        function DevolverEstadoRecepcionRadicado(_this) {
            var idServicio = parseInt($(_this).parent().parent()[0].cells[0].innerText);

            $(_this).parent().parent().remove();

            EjecutarCallback('', '', 'DevolverEstadoRecepcionRadicado', idServicio);
        }

        function TablaPorCampania(campania, idRadicado, identificacion, nombre, codEstrategia, obsTemp) {
            //Cuerpo tabla
            tr = $("<tr/>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'>" + campania + "</td>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'>" + idRadicado + "</td>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'>" + identificacion + "</td>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'>" + nombre + "</td>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'>" + codEstrategia + "</td>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'><button type='button' class='btn btn-info' onclick='VerDocsMC(this)'>Ver</button></td>");
            tr.append("<td onclick='SeleccionDeRadicados(this)'><button type='button' id='btnSubirDocs' class='btn btn-success' onclick='Mostrar(this)'>Subir</button></td>");
            if (_globalAutocomplete[0].docsAprobados == null) {
                tr.append("<td onclick='SeleccionDeRadicados(this)'><input type='checkbox' id='chkAprobado' onclick='AprobacionRecchazo(this)' /></td>");
                tr.append("<td onclick='SeleccionDeRadicados(this)'><input type='checkbox' id='chkRechazado' onclick='AprobacionRecchazo(this)' /></td>");
            }
            else if (_globalAutocomplete[0].docsAprobados) {
                tr.append("<td onclick='SeleccionDeRadicados(this)'><input type='checkbox' id='chkRechazado' onclick='AprobacionRecchazo(this)' /></td>");
            }
            else if (_globalAutocomplete[0].docsAprobados == false) {
                tr.append("<td onclick='SeleccionDeRadicados(this)'><input type='checkbox' id='chkAprobado' onclick='AprobacionRecchazo(this)' /></td>");
            }
            if (obsTemp.length > 0 && _globalControl == 'txtCedulaRadiacado') {
                tr.append("<td onclick='SeleccionDeRadicados(this)'><button type='button' class='btn btn-info' onclick='MostrarNovedades()'>Ver</button></td>");
            }
            else if (_globalControl == 'txtCampaniaEstrategia') {
                tr.append("<td style='display:none'><input type='checkbox' id='chkGenerarOrdenRadicado' /></td>");
            }
            $('#tblBusquedaVenta').append(tr);
            $("input[id$='txtCampaniaEstrategia']").focus();
            $('#tblBusquedaVenta').find('> tbody > tr').addClass('success');
            $('#tblBusquedaVenta').find('> tbody > tr').css('cursor', 'pointer');
        }

        function SeleccionDeRadicados(_this) {
            var titulo = 'Imposible flujo de estados',
                cursor = 'default',
                funcion = '';

            if (_this != undefined) {
                var clase = $(_this).parent()[0].className;
                var idServicio = parseInt($(_this).parent()[0].cells[1].innerText);
                var contenidoTablaRadicacion = $(_this).parent()[0].cells[1].innerText + '|' +                            //id del Radicado
                                               $(_this).parent()[0].cells[3].innerText + '|' +                           //Cédula usuario
                                               $(_this).parent()[0].cells[4].innerText + '|' +                          //Nombre usuario
                                               $(_this).parent()[0].cells[5].innerText + '|' +                         //Código estrategia
                                               $(_this).parent()[0].cells[0].innerText.split('_')[1] + '|' +          //Nombre campaña
                                               $(_this).parent()[0].cells[10].innerText + '|' +                      //Determina si ya se cargaron los documentos antes de enviar a radicar al banco
                                               $(_this).parent()[0].cells[11].innerText + '|' +                     //Consecutivo interno Outsourcing
                                               $(_this).parent()[0].cells[12].innerText + '|' +                    //Código Outsourcing
                                               $(_this).parent()[0].cells[2].innerText.split('_')[0];             //id Estado del radicado
                var idEstadoServicio = parseInt($(_this).parent()[0].cells[2].innerText.split('_')[0]);

                if (clase == 'success') {
                    _globalIdServicio.push(idServicio);

                    var busqueda = jQuery.grep(_globalInfRadicadosPlanilla, function (value) {
                        return value.toUpperCase().indexOf(idServicio) >= 0;
                    });

                    if (busqueda.length == 0) {
                        _globalInfRadicadosPlanilla.push(contenidoTablaRadicacion);
                    }

                    if ($('#chkSeleccionMultiple').prop('checked'))  //Usado para la función de selección múltiple de planilla de radicación en el banco
                    {
                        if (idEstadoServicio != 278 && idEstadoServicio != 279) {
                            var busquedaMultiple = jQuery.grep(_globalInfRadicadosPlanillaMultiple, function (value) {
                                return value.toUpperCase().indexOf(idServicio) >= 0;
                            });

                            if (busquedaMultiple.length == 0) {
                                _globalInfRadicadosPlanillaMultiple.push(contenidoTablaRadicacion);
                            }

                            if ($('#spn_' + idServicio).length == 0) {
                                if ($('#btnGenerarPlanillaMultiple').length == 0) {
                                    $('#dvServiciosSeleccionados').append('<button type="button" id="btnGenerarPlanillaMultiple" class="btn btn-primary" onclick="RadicarBanco(1)" >Radicar en Banco</button>');
                                }
                                $('#dvServiciosSeleccionados').append('<span id="spn_' + idServicio + '" busquedaIndex="' + contenidoTablaRadicacion + '" class="label label-primary" style="cursor: pointer" onclick="RemoverServicioMultiple(this)">' + idServicio + '</span>');
                            }
                            $(_this).parent().find('[id^=chkGenerarOrdenRadicado][type=checkbox]')[0].checked = true;
                            $(_this).parent()[0].className = 'active';
                        }
                        else if (idEstadoServicio == 278 || idEstadoServicio == 279) {
                            alert('El estado del servicio: ' + idServicio + ' es incorrecto para generar la planilla', 'rojo');
                        }
                    }
                    else {
                        $('#dvChkSeleccionMultiple').css('display', 'none');
                        $('#btnGenerarOrden').removeClass('btn btn-danger');
                        $('#btnGenerarOrden').addClass('btn btn-success');
                        $(_this).parent().find('[id^=chkGenerarOrdenRadicado][type=checkbox]')[0].checked = true;
                        $(_this).parent()[0].className = 'active';
                        titulo = '¡Continuar!';
                        cursor = 'pointer';
                        funcion = 'CambiarEstadoRadicados()';
                    }

                }
                else if (clase == 'active') {
                    if (!$('#chkSeleccionMultiple').prop('checked')) {
                        var index = _globalIdServicio.indexOf(idServicio),
                            indexRadicacion = _globalInfRadicadosPlanilla.indexOf(contenidoTablaRadicacion);

                        if (index > -1) {
                            _globalIdServicio.splice(index, 1);
                        }
                        if (indexRadicacion > -1) {
                            _globalInfRadicadosPlanilla.splice(indexRadicacion, 1);
                        }

                        var clase = 'btn btn-danger', chkCausal = false;

                        $(_this).parent()[0].className = 'success';
                        $(_this).parent().find('[id^=chkGenerarOrdenRadicado][type=checkbox]')[0].checked = false;

                        $('#tblBusquedaVenta').find('> tbody > tr').find('[id^=chkGenerarOrdenRadicado][type=checkbox]').each(function () {

                            chkCausal = this;
                            if (chkCausal.checked) {
                                clase = 'btn btn-success';
                                titulo = '¡Continuar!';
                                cursor = 'pointer';
                                funcion = 'CambiarEstadoRadicados()';
                            }
                        });

                        $('#btnGenerarOrden').removeClass('btn btn-success');
                        $('#btnGenerarOrden').addClass(clase);
                    }
                }
            }
            else {
                // Usado para la selección  de todos los elementos de la tabla
                if ($(':checkbox').prop('checked')) {
                    _globalInfRadicadosPlanilla = [];
                    _globalInfRadicadosPlanillaMultiple = [];
                    _globalIdServicio = [];

                    if ($('#dvServiciosSeleccionados').find('span').length > 0) {
                        $('#dvServiciosSeleccionados').css('display', 'none');
                        $('#dvServiciosSeleccionados').find('span').remove();
                    }

                    $(':checkbox').prop('checked', false);
                    $('#tblBusquedaVenta tr').removeClass('active');
                    $('#tblBusquedaVenta tr').addClass('success');
                    $('#btnGenerarOrden').removeClass('btn btn-success');
                    $('#btnGenerarOrden').addClass('btn btn-danger');
                }
                else {
                    var y = 0;
                    $('#tblBusquedaVenta tbody tr').each(function () {
                        $('#dvChkSeleccionMultiple').css('display', 'none');
                        $('#chkSeleccionMultiple').prop('checked', false);

                        if (y > 0) {
                            var idServicio = $(this)[0].cells[1].innerText;
                            var contenidoTablaRadicacion = idServicio + '|' +                               //id del Radicado
                                                           $(this)[0].cells[3].innerText + '|' +                              //Cédula usuario
                                                           $(this)[0].cells[4].innerText + '|' +                             //Nombre usuario
                                                           $(this)[0].cells[5].innerText + '|' +                            //Código estrategia
                                                           $(this)[0].cells[0].innerText + '|' +                           //Nombre campaña
                                                           $(this)[0].cells[10].innerText + '|' +                          //Determina si ya se cargaron los documentos antes de enviar a radicar al banco
                                                           $(this)[0].cells[2].innerText.split('_')[0];                   //id Estado del radicado

                            var busqueda = jQuery.grep(_globalInfRadicadosPlanilla, function (value) {
                                return value.toUpperCase().indexOf(idServicio) >= 0;
                            });

                            if (busqueda.length == 0) {
                                _globalInfRadicadosPlanilla.push(contenidoTablaRadicacion);
                            }

                            _globalIdServicio.push(idServicio);
                        }
                        y++;

                    });

                    $(':checkbox').prop('checked', true);
                    $('#tblBusquedaVenta tr').removeClass('success');
                    $('#tblBusquedaVenta tr').addClass('active');
                    $('#btnGenerarOrden').removeClass('btn btn-danger');
                    $('#btnGenerarOrden').addClass('btn btn-success');
                    titulo = '¡Continuar!';
                    cursor = 'pointer';
                    funcion = 'CambiarEstadoRadicados()';
                }
            }

            $('#btnGenerarOrden').prop('title', titulo);
            $('#btnGenerarOrden').attr('onclick', funcion);
            $('#btnGenerarOrden').css('cursor', cursor);
        }

        function RemoverServicioMultiple(_this) {
            var terminoBusqueda = $('#' + _this.id).attr('busquedaindex');
            var indexRadicacion = _globalInfRadicadosPlanillaMultiple.indexOf(terminoBusqueda);

            $('#' + _this.id).remove();

            if (indexRadicacion > -1) {
                _globalInfRadicadosPlanillaMultiple.splice(indexRadicacion, 1);
            }

            $('#tblBusquedaVenta tr').each(function () {
                var idTmp = $(this)[0].cells[1].innerText;

                if (idTmp == _this.innerText) {
                    if ($(this)[0].className == 'active') {
                        $(this)[0].className = 'success';
                    }
                    if ($(this).find('[id^=chkGenerarOrdenRadicado][type=checkbox]')[0].checked) {
                        $(this).find('[id^=chkGenerarOrdenRadicado][type=checkbox]')[0].checked = false;
                    }
                }

            });
        }

        function GenerarOrdenRadicado() {
            var x = 0, t;
            $('#tblBusquedaVenta tbody tr').each(function () {
                t = $(this).parent().find('[id^=chkGenerarOrdenRadicado][type=checkbox]')[x].checked;
                if (x != $(this).parent().find('[id^=chkGenerarOrdenRadicado][type=checkbox]').length - 1) {
                    x++;
                }
            });
        }

        function CambiarEstadoRadicados() {
            var botones = ValidarEstadosAcciones().split('|');
            var radicar                 = Boolean(parseInt(botones[0])),
                devolucionMTI           = Boolean(parseInt(botones[1])),
                verificacionConNovedad  = Boolean(parseInt(botones[2])),
                //recuperacion = Boolean(parseInt(botones[3])),
                finalizar               = Boolean(parseInt(botones[3])),
                destruccion             = Boolean(parseInt(botones[4]));

            $.confirm({
                title: 'Cambiar Estado',
                content: '',
                icon: ' fa fa-question-circle-o',
                theme: 'Material',
                closeIcon: true,
                type: 'red',
                buttons: {
                    RadicarBanco: {
                        text: "Radicar en banco",
                        btnClass: 'btn-primary',
                        isDisabled: radicar,
                        action: function () {
                            RadicarBanco();
                        }
                    },
                    DocumentoEnRecuperacion: {
                        text: "Devolución MTI",
                        btnClass: 'btn-primary',
                        isDisabled: devolucionMTI,
                        action: function () {
                            EjecutarCallback('', '', 'ConsultarCausalesDevolucion', -23);
                        }
                    },
                    VerificacionConNovedad: {
                        text: "Verificación con Novedad",
                        btnClass: 'btn-primary',
                        isDisabled: verificacionConNovedad,
                        action: function () {
                            EjecutarCallback('', '', 'ConsultarCausalesDevolucion', -22);
                        }
                    },
                    FinalzarCampania: {
                        text: "Campaña Finalizada",
                        btnClass: 'btn-primary',
                        isDisabled: finalizar,
                        action: function () {


                            if (_globalIdServicio.length == 1) {
                                EjecutarCallback('', '', 'FinalizarCampania', _globalIdServicio[0]);
                            }
                            else if (_globalIdServicio.length > 1) {
                                alert('Por favor seleccione solamente un radicado que esté asociado a la campaña que desea finalizar.', 'rojo');
                            }
                        }
                    },
                    DestruirDoc: {
                        text: "Documento Destruido",
                        btnClass: 'btn-success',
                        isDisabled: destruccion,
                        action: function () {
                            _globalPasadasCuerpoPlanilla = 0;
                            for (x = 0; x < _globalIdServicio.length; x++) {
                                EjecutarCallback('', '', 'PasarADestruccion', _globalIdServicio[x]);
                            }
                        }
                    },
                    cancel: {
                        text: "Cancelar",
                        btnClass: 'btn-danger'
                    },
                }
            });
        }

        function ValidarEstadosAcciones() {
            var radicarBanco = 0, devolucionMTI = 0, verificacionConNovedad = 0, docRecuperacion = 0, finalizar = 0, destruccion = 0;

            for (x = 0; x < _globalInfRadicadosPlanilla.length; x++) {
                var estadoRadicado = parseInt(_globalInfRadicadosPlanilla[x].split('|')[8]);

                if (estadoRadicado == 275) { // verificación mesa
                    devolucionMTI = 1;
                    destruccion = 1;
                }
                else if (estadoRadicado == 278) { // radicado banco
                    radicarBanco = 1;
                    destruccion = 1;
                    verificacionConNovedad = 1;
                }
                else if (estadoRadicado == 281) { // Devolución MTI
                    radicarBanco = 1;
                    devolucionMTI = 1;
                    destruccion = 1;
                    verificacionConNovedad = 1;
                }
                else if (estadoRadicado == 283) { // Verificación con novedad
                    devolucionMTI = 1;
                    verificacionConNovedad = 1;
                    destruccion = 1;
                }
                else if (estadoRadicado == 279) { // Campaña Finalizada
                    radicarBanco = 1;
                    devolucionMTI = 1;
                    verificacionConNovedad = 1;
                    finalizar = 1;
                }
            }

            return radicarBanco + '|' + devolucionMTI + '|' + verificacionConNovedad + '|' + /*docRecuperacion + '|' +*/ finalizar + '|' + destruccion;
        }

        function RadicarBanco(origen) {
            if (origen == 1) // origen por selección múltiple
            {
                if (_globalInfRadicadosPlanillaMultiple.length == 0) {
                    alert('Debe seleccionar al menos un radicado para generar la planilla', 'rojo');
                    return;
                }
            }

            $.confirm({
                title: 'Ingrese precinto',
                content: '' +
                    '<input type="text" class="precinto form-control" id="txtPrecinto" placeholder="Ingrese precinto." /><br/>' +
                    //'<input type="text" class="oficina form-control" id="txtOficina" placeholder="Ingrese nùmero de oficina." /><br/>' +
                    '<textarea id="texObsRadicarBanco" class="form-control" rows="3" placeholder="Ingrese sus comentarios..."></textarea>',
                onContentReady: function () {
                    $('#txtPrecinto').focus();
                },
                theme: 'dark',
                type: 'blue',
                buttons: {
                    GenerarPlanilla: {
                        text: 'Generar Planilla',
                        btnClass: 'btn-success',
                        action: function () {
                            var precinto = this.$content.find('.precinto').val();
                            //_globalOficina = parseInt(this.$content.find('.oficina').val());

                            var variableGlobal = _globalInfRadicadosPlanilla;

                            if (_globalInfRadicadosPlanillaMultiple.length > 0) {
                                variableGlobal = _globalInfRadicadosPlanillaMultiple;
                            }
                            else {
                                variableGlobal = _globalInfRadicadosPlanilla;
                            }

                            for (x = 0; x < variableGlobal.length; x++) {
                                var estado = variableGlobal[x].split('|')[5];
                                var idServicio = variableGlobal[x].split('|')[0];
                                if (estado == 'null') {
                                    alert('No se han cargado los documentos para el radicado: ' + idServicio + '. Por favor verifique.', 'rojo');
                                    return;
                                }
                            }

                            if (precinto.length > 0 && precinto.length < 16) {
                                //$('input[id$=hdfOficina]').val(_globalOficina);
                                EncabezadoHtmlPlanillaRadicacion(precinto);
                            }
                            else {
                                alert('Por favor revise el campo precinto. No cumple con los requerimientos. No puede estar vacío y máximo 15 caracteres.', 'rojo');
                                return false;
                            }
                        }
                    },
                    Cancelar: {
                        text: 'Cancelar',
                        btnClass: 'btn-danger'
                    }
                }

            });
        }

        function EncabezadoHtmlPlanillaRadicacion(precinto) {
            // Inserta el encabezado de la planilla en la tabla PlanillaRadicacionBanco

            var variableGlobal = _globalInfRadicadosPlanilla;

            if (_globalInfRadicadosPlanillaMultiple.length > 0) {
                variableGlobal = _globalInfRadicadosPlanillaMultiple;
            }

            var cuerpoPlanilla = JSON.stringify(variableGlobal);
            EjecutarCallback('', '', 'GenerarPlanillaRadicacion', precinto, $('#texObsRadicarBanco').val() + '|' + cuerpoPlanilla);
        }

        function CausalesRechazoBanco(jsonCausales) {
            var selectList;

            $.confirm({
                title: 'Causales de devolución del banco',
                theme: 'dark',
                type: 'blue',
                columnClass: 'large',
                content: 'Puede elegir una o varias causales con las teclas de selección "Ctrl, Shift o Mouse"',
                onContentReady: function () {
                    var self = this;
                    for (x = 0; x <= jsonCausales.length; x++) {
                        selectList = '<select multiple="" class="btn btn-primary" id="selRechazoBanco" style="text-align: left; height: 236px;">';
                        for (var x = 0; x < jsonCausales.length; x++) {
                            selectList += "<option value ='" + jsonCausales[x].idBNC + "'>" + jsonCausales[x].causalBNC + "</option>"
                        }
                        selectList += "</select>";
                    }
                    self.setContentAppend(selectList);
                    self.setContentAppend('<br /><br />' + '<textarea id="texObsRechazoBanco" class="form-control" rows="3" placeholder="Ingrese sus comentarios..."></textarea>' + '<br />');
                },
                buttons: {
                    GuardarCausal: {
                        text: 'Guardar Causal',
                        btnClass: 'btn-success',
                        action: function ()
                        {
                            var arrCausalesBanco = $('#selRechazoBanco').val();

                            if (_globalIdServicio.length > 0 && arrCausalesBanco != null)
                            {
                                var strServicios = '',
                                    strCausales = '';
                                var radicadoObs = $('#texObsRechazoBanco').val();

                                for (x = 0; x < _globalIdServicio.length; x++) {
                                    strServicios += _globalIdServicio[x] + '|';
                                }

                                for (x = 0; x < arrCausalesBanco.length; x++) {
                                    strCausales += arrCausalesBanco[x] + '|';
                                }

                                $('input[id$=hdfIdRadicado]').val(strServicios);
                                $('input[id$=hdfCausalesBanco]').val(strCausales);

                                EjecutarCallback('', '', 'GuardarRechazoDocumentosBanco', radicadoObs);
                            }
                            else {
                                alert('Es necesario elegir al menos una causal de devolución', 'rojo');
                                return false;
                            }
                        }
                    },
                    Cancelar: {
                        text: 'Salir',
                        btnClass: 'btn-danger'
                    }
                }
            });
        }

        function CausalesRechazoMC(jsonCausales) {
            var selectList;

            $.confirm({
                title: 'Causales de devolución Mesa de Control',
                theme: 'dark',
                type: 'blue',
                columnClass: 'large',
                content: 'Puede elegir una o varias causales con las teclas de selección "Ctrl, Shift o Mouse"',
                onContentReady: function () {
                    var self = this;
                    for (x = 0; x <= jsonCausales.length; x++) {
                        selectList = '<select multiple="" class="btn btn-primary" id="selRechazoMC" style="text-align: left; height: 236px;">';
                        for (var x = 0; x < jsonCausales.length; x++) {
                            selectList += "<option value ='" + jsonCausales[x].idMC + "'>" + jsonCausales[x].causalMC + "</option>"
                        }
                        selectList += "</select>";
                    }
                    self.setContentAppend(selectList);
                    self.setContentAppend('<br /><br />' + '<textarea id="texObsRechazoMC" class="form-control" rows="3" placeholder="Ingrese sus comentarios..."></textarea>' + '<br />');
                },
                buttons: {
                    GuardarCausal: {
                        text: 'Guardar Causal',
                        btnClass: 'btn-success',
                        action: function ()
                        {

                            var arrCausalesMc = $('#selRechazoMC').val();

                            if (_globalIdServicio.length > 0 && arrCausalesMc != null) {
                                var strServicios = '',
                                    strCausales = '';
                                var radicadoObs = $('#texObsRechazoMC').val();

                                for (x = 0; x < _globalIdServicio.length; x++) {
                                    strServicios += _globalIdServicio[x] + '|';
                                }

                                for (x = 0; x < arrCausalesMc.length; x++) {
                                    strCausales += arrCausalesMc[x] + '|';
                                }

                                $('input[id$=hdfIdRadicado]').val(strServicios);
                                $('input[id$=hdfCausalesBanco]').val(strCausales);

                                EjecutarCallback('', '', 'GuardarRechazoDocumentos', radicadoObs);
                            }
                            else {
                                alert('Es necesario elegir al menos una causal de devolución', 'rojo');
                                return false;
                            }
                        }
                    },
                    Cancelar: {
                        text: 'Salir',
                        btnClass: 'btn-danger'
                    }
                }
            });
        }

        function DestruccionDocumentos() {

            $.confirm({
                title: 'Por favor confirme la acción',
                content: 'Este es un paso irreversible',
                theme: 'material',
                closeIcon: true,
                type: 'red',
                buttons: {
                    btnOk: {
                        text: 'Aceptar',
                        btnClass: 'btn-primary',
                        action: function ()
                        {
                            $.confirm({
                                title: 'Escoja un archivo pdf...' + '<br/>',
                                content: '' +
                                    '<input type="file" id="fuSubirArchivoDestruccion" /><br/>' +
                                    '<textarea id="texObsDestruccionDoc" class="form-control" rows="3" placeholder="Ingrese sus comentarios..."></textarea>',
                                theme: 'dark',
                                type: 'blue',
                                buttons: {
                                    btnSubir: {
                                        text: 'SUBIR...' + '<span class="badge"><img src="../images/uploadMC.png" /></span>',
                                        btnClass: 'btn-primary',
                                        action: function () {
                                            var fileUpload = $("#fuSubirArchivoDestruccion").get(0);

                                            if (fileUpload.files[0].type == 'application/pdf') {
                                                var files = fileUpload.files;
                                                var test = new FormData();
                                                var idUsuario = parseInt($('input[id$=hdfUsuarioSesion]').val());
                                                for (var i = 0; i < files.length; i++) {
                                                    test.append(files[i].name, files[i]);
                                                }

                                                for (x = 0; x < _globalIdServicio.length; x++) {
                                                    $.ajax({
                                                        url: "../ControlesDeUsuario/CargarArchivosServidor.ashx?idRadicado=" + _globalIdServicio[x] + "&origen=DestruirDocumento" +
                                                             "&obsDestruccion=" + $('#texObsDestruccionDoc').val() + "&idUsuario=" + idUsuario,
                                                        type: "POST",
                                                        contentType: false,
                                                        processData: false,
                                                        data: test,
                                                        success: function (result) {
                                                            var mensaje = result.split('|')[0];
                                                            var color = result.split('|')[1];
                                                            alert(mensaje, color);
                                                            $('#fuSubirArchivoDestruccion')[0].value = '';
                                                            $('#texObsDestruccionDoc').val('');
                                                        },
                                                        error: function (err) {
                                                            alert(err.statusText);
                                                        }
                                                    });
                                                }
                                            }
                                            else {
                                                alert('Se requiere el archivo en formato PDF', 'rojo');
                                            }

                                            return false; //Impide que el modal se cierre
                                        }
                                    },
                                    btnCancelar: {
                                        text: 'Salir',
                                        btnClass: 'btn-danger'
                                    }
                                }
                            });

                        }
                    },
                    btnCancelar: {
                        text: 'Cancelar',
                        btnClass: 'btn-danger'
                    },
                }
            });
        }

        function ConvertirAFecha(milisegundos) {
            var date = new Date(milisegundos);
            var y = date.getFullYear()
            var m = date.getMonth() + 1;
            var d = date.getDate();
            m = (m < 10) ? '0' + m : m;
            d = (d < 10) ? '0' + d : d;

            if (y > 1900) {
                return [d, m, y].join('-');
            }
            else {
                return '';
            }
        }

        function CargarNovedades(_this) {
            var indice = $(_this).parent().parent();
            var idRadicado = indice[0].cells[1].innerText;

            EjecutarCallback('', '', 'VerNovedadesRadicado', idRadicado);
        }

        function PintarNovedades(arrNov) {
            if (arrNov.length > 0) {
                var index = arrNov.indexOf('-11');
                if (index > -1) {
                    arrNov.splice(index, 1);
                }

                var encabezado = $.parseJSON(arrNov[0]),
                    cuerpo = $.parseJSON(arrNov[1]),
                    tieneCausales = false,
                    idServicio = 0;

                $.confirm({
                    title: 'Novedades Radicado' + '<br />',
                    content: '' +
                        '<table id="tblNovedadesRadicadosEncabezado" class="table table-hover"></table>' +
                        '<table id="tblNovedadesRadicadosCuerpo" class="table table-hover"></table>',
                    theme: 'material',
                    columnClass: 'xlarge',
                    onContentReady: function () {
                        //Encabezado novedades

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Nombre Cliente</td>");
                        tr.append("<td>" + encabezado[0].NombreCliente + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Cédula/NIT</td>");
                        tr.append("<td>" + encabezado[0].identicacion + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Dirección Correspondencia</td>");
                        tr.append("<td>" + encabezado[0].direccion + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Barrio</td>");
                        tr.append("<td>" + encabezado[0].barrio + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Ciudad residencia</td>");
                        tr.append("<td>" + encabezado[0].Ciudad + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Teléfono</td>");
                        tr.append("<td>" + encabezado[0].telefono + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Persona Contacto</td>");
                        tr.append("<td>" + encabezado[0].nombreAutorizado + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Fecha agendamiento</td>");
                        tr.append("<td>" + ConvertirAFecha(parseInt(encabezado[0].fechaAgenda.split('(')[1].split(')')[0])) + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Jornada</td>");
                        tr.append("<td>" + encabezado[0].Jornada + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Fecha de registro</td>");
                        tr.append("<td>" + ConvertirAFecha(parseInt(encabezado[0].fechaRegistroAgenda.split('(')[1].split(')')[0])) + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Registrado por</td>");
                        tr.append("<td>" + encabezado[0].UsuarioRegistro + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Prioridad</td>");
                        tr.append("<td>" + encabezado[0].prioridad + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Fecha confirmación</td>");
                        tr.append("<td>" + ConvertirAFecha(parseInt(encabezado[0].fechaConfirmacion.split('(')[1].split(')')[0])) + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Confirmado por</td>");
                        tr.append("<td>" + encabezado[0].UsuarioConfirmacion + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Bodega</td>");
                        tr.append("<td>" + encabezado[0].bodega + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Fecha despacho</td>");
                        tr.append("<td>" + ConvertirAFecha(parseInt(encabezado[0].fechaDespacho.split('(')[1].split(')')[0])) + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Despachado por</td>");
                        tr.append("<td>" + encabezado[0].UsuarioDespacho + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Fecha cambio servicio</td>");
                        tr.append("<td>" + ConvertirAFecha(parseInt(encabezado[0].fechaCambioServicio.split('(')[1].split(')')[0])) + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Zona</td>");
                        tr.append("<td>" + encabezado[0].Zona + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Responsable entrega</td>");
                        tr.append("<td>" + encabezado[0].RespEntrega + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Fecha entrega</td>");
                        tr.append("<td>" + ConvertirAFecha(parseInt(encabezado[0].fechaAgendaEntrega.split('(')[1].split(')')[0])) + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Observaciones</td>");
                        tr.append("<td>" + encabezado[0].observacion + "</td>");
                        tr.append("<td></td>");
                        tr.append("<td></td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Factura</td>");
                        tr.append("<td>" + encabezado[0].facturaCambioServicio + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);

                        tr = $('<tr/>');
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Actividad Laboral</td>");
                        tr.append("<td>" + encabezado[0].actividadLaboral + "</td>");
                        tr.append("<td style='font-weight: bolder;background-color: #c4ccd0;'>Campaña</td>");
                        tr.append("<td>" + encabezado[0].Campania + "</td>");
                        $('#tblNovedadesRadicadosEncabezado').append(tr);


                        // Histórico de Estados
                        tr = $('<tr/>');
                        tr.append("<td>Estado Actual</td>");
                        tr.append("<td>Estado Anterior</td>");
                        tr.append("<td>Novedad</td>");
                        tr.append("<td>Usuario Modificó</td>");
                        tr.append("<td>Fecha</td>");
                        $('#tblNovedadesRadicadosCuerpo').append(tr);
                        $('#tblNovedadesRadicadosCuerpo').find('> tbody > tr')[0].className = 'danger';

                        for (x = 0; x < cuerpo.length; x++) {
                            tr = $('<tr/>');
                            tr.append("<td>" + cuerpo[x].Actual + "</td>");
                            tr.append("<td>" + cuerpo[x].Anterior + "</td>");
                            tr.append("<td>" + cuerpo[x].Novedad + "</td>");
                            tr.append("<td>" + cuerpo[x].UsuarioMod + "</td>");
                            tr.append("<td>" + ConvertirAFecha(parseInt(cuerpo[x].FechaModificacion.split('(')[1].split(')')[0])) + "</td>");
                            $('#tblNovedadesRadicadosCuerpo').append(tr);
                            $('#tblNovedadesRadicadosCuerpo').find('> tbody > tr')[x + 1].className = 'success';
                            tieneCausales = Boolean(parseInt(cuerpo[x].CausalesRechazo));
                            idServicio = parseInt(cuerpo[x].HEMidServicio);
                        }
                        if (tieneCausales) {
                            $('#tblNovedadesRadicadosCuerpo').append('<br />');
                            $('#tblNovedadesRadicadosCuerpo').append("<button type='button' id='btnVerCausalesRechazo' class='btn btn-primary' onclick='VerCausalesRadicado(" + idServicio + ")'>Ver causales</button>")
                        }
                    },
                    closeIcon: true,
                    type: 'red',
                    buttons: {
                        btnCerrar: {
                            text: "Cerrar",
                            btnClass: 'btn-danger'
                        }
                    }
                });
            }
        }

        function VerCausalesRadicado(idRadicado) {
            EjecutarCallback('', '', 'VerCausalesrechazo', idRadicado);
        }

        function PintarCausalesRechazoMCBanco(arrCausales) {
            if (arrCausales.length > 0) {
                var index = arrCausales.indexOf('-2');
                if (index > -1) {
                    arrCausales.splice(index, 1);
                }

                var bancos = [],
                    mc = [],
                    generico = [],
                    origen = '';

                if (arrCausales.length == 2) {
                    bancos = $.parseJSON(arrCausales[0]);
                    mc = $.parseJSON(arrCausales[1]);
                }
                else if (arrCausales.length == 1) {
                    generico = $.parseJSON(arrCausales[0]);
                    origen = $.parseJSON(arrCausales[0])[0].Origen;
                }


                $.confirm({
                    title: 'Causales de Rechazo',
                    content: '' +
                        '<table id="tblCausalesRechazoBanco" class="table table-hover"></table>' +
                        '<table id="tblCausalesRechazoMC" class="table table-hover"></table>',
                    theme: 'Material',
                    type: 'red',
                    columnClass: 'large',
                    onContentReady: function () {
                        var encabezado = 0,
                            origen = generico[0].Origen;
                        for (x = 0; x < generico.length; x++) {
                            if (encabezado == 0) {
                                tr = $('<tr/>');
                                tr.append("<td>Causal " + generico[x].Origen + "</td>");
                                tr.append("<td>Usuario Modificación</td>");
                                tr.append("<td>Fecha Modificación</td>");
                                $('#tblCausalesRechazoBanco').append(tr);
                                $('#tblCausalesRechazoBanco').find('> tbody > tr')[0].className = 'danger';
                            }

                            if (origen != generico[x].Origen) {
                                encabezado = 0;
                                origen = generico[x].Origen;
                                if (encabezado == 0) {
                                    tr = $('<tr/>');
                                    tr.append("<td>Causal " + generico[x].Origen + "</td>");
                                    tr.append("<td>Usuario Modificación</td>");
                                    tr.append("<td>Fecha Modificación</td>");
                                    $('#tblCausalesRechazoBanco').append(tr);
                                    $('#tblCausalesRechazoBanco').find('> tbody > tr')[x + 1].className = 'danger';
                                }
                            }

                            tr = $('<tr/>');
                            tr.append("<td>" + generico[x].Causal + "</td>");
                            tr.append("<td>" + generico[x].tercero + "</td>");
                            tr.append("<td>" + ConvertirAFecha(parseInt(generico[x].fechaModificacion.split('(')[1].split(')')[0])) + "</td>");
                            $('#tblCausalesRechazoBanco').append(tr);
                            //$('#tblCausalesRechazoBanco').find('> tbody > tr')[x + 1].className = 'success';

                            encabezado++;
                        }

                        //if (arrCausales.length == 2)
                        //{


                        //    for (x = 0; x < bancos.length; x++)
                        //    {
                        //        tr = $('<tr/>');
                        //        tr.append("<td>" + bancos[x].CausalBanco + "</td>");
                        //        tr.append("<td>" + bancos[x].tercero + "</td>");
                        //        tr.append("<td>" + ConvertirAFecha(parseInt(bancos[x].RBDfechaModificacion.split('(')[1].split(')')[0])) + "</td>");
                        //        $('#tblCausalesRechazoBanco').append(tr);
                        //        $('#tblCausalesRechazoBanco').find('> tbody > tr')[x+1].className = 'success';
                        //    }
                        //}


                    },
                    buttons: {
                        btnCerrar: {
                            text: "Cerrar",
                            btnClass: 'btn-danger'
                        }
                    }
                });
            }

        }

        function PoolServicios(origen) {
            if (origen == 'PoolS') {
                $('#dvPoolServiciosFin').css('display', 'inline');
                $('#dvPoolRecepcioRadicados').css('display', 'none');
                $('#spnTituloMC').css('display', 'none');
                $('#dvTblBusquedaVenta').css('display', 'none');
                //$('#dvFupload').css('display', 'none');
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

        function Mostrar(_this) {
            var indice = $(_this).parent().parent();
            var idRadicado = indice[0].cells[1].innerText;
            //var contenidoTabla = indice[0].cells[0].innerText + '|' + indice[0].cells[1].innerText + '|' + indice[0].cells[2].innerText + '|' + indice[0].cells[3].innerText + '|' + indice[0].cells[4].innerText;
            // $('#dvFupload').css('display', 'inline');
            $('input[id$=hdfIdRadicado]').val(idRadicado);
            //$('input[id$=hdfContenidoTablaResultado]').val(contenidoTabla);


            $.confirm({
                title: 'Escoja un archivo pdf...' + '<br/>',
                content: '' +
                    '<input type="file" id="fuSubirArchivo" />',//'Elija un archivo pdf...' + '<br/>' + '<br/>' + '<br/>',
                theme: 'dark',
                closeIcon: true,
                type: 'blue',
                //onContentReady: function () {
                //    //$('#dvSubirArchivo').css('display', 'inline');
                //    //this.setContentAppend($('#dvSubirArchivo'));
                //},
                buttons: {
                    btnSubir: {
                        text: 'SUBIR...' + '<span class="badge"><img src="../images/uploadMC.png" /></span>',
                        btnClass: 'btn-primary',
                        action: function () {
                            SubirDocumentoMC();
                            return false;
                        }
                    },
                    btnCancelar: {
                        text: 'Salir',
                        btnClass: 'btn-danger'
                    }
                }
            });

            return false;
        }

        function VerDocsMC(_this) {
            var idRadicado = $(_this).parent().parent()[0].cells[1].innerText;
            $('input[id$=hdfIdRadicado]').val(idRadicado);

            EjecutarCallback('', '', 'VerDocsMC', idRadicado);

            //$('#tblBusquedaVenta tbody tr').each(function () {
            //    var t = $(this)[0].children[1].innerText;
            //});
        }

        function PintarDocumentosByte(docByte) {
            var index = docByte.indexOf('-1');
            var rex = /\S/;
            docByte = docByte.filter(rex.test.bind(rex));

            if (index > -1) {
                docByte.splice(index, 1);
            }

            $.confirm({
                title: 'Documentos usuario',
                theme: 'material',
                type: 'red',
                columnClass: 'small',
                content: '',
                onContentReady: function () {
                    if (docByte.length > 0) {
                        _globalByteImagenes = docByte;

                        for (x = 0; x < docByte.length; x++) {
                            this.setContentAppend('<a onclick="CambiarImagenPDF(this)" style="color: black; cursor: pointer">' + docByte[x] + '</a><br />');
                        }
                    }

                },
                buttons: {
                    Salir: {
                        text: 'Salir',
                        btnClass: 'btn btn-danger',
                        action: function () {
                            $('#ifPDF').attr('src', '');
                            _globalByteImagenes = [];
                        }
                    }
                }
            });
        }

        function CambiarImagenPDF(_this) {
            window.location.href = "../ControlesDeUsuario/CargarArchivosServidor.ashx?idRadicado=" + $('input[id$=hdfIdRadicado]').val() + "&origen=DescargarDocMC" + "&nombreDoc=" + _this.innerText;
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

        function MostrarOcultarDvs(origen) {
            if (origen == 'recepcion') {

                if ($('#tblBusquedaVenta').find('> tbody > tr').length > 0) {
                    $('#tblBusquedaVenta').empty();
                    $('#txtCedulaRadiacado').val('');
                    $('#txtCampaniaEstrategia').val('');
                }
                $('#dvRecepcionRadicadoMasivo').css('display', 'inline');
                $('#dvEnvioRadicar').css('display', 'none');
                $('#dvChkSeleccionMultiple').css('display', 'none');
                $('#btnGenerarOrden').css('display', 'none');
            }
            else if (origen == 'paso') {
                if ($('#tblRecepcionMasiva').find('> tbody > tr').length > 0) {
                    $('#tblRecepcionMasiva').empty();
                    $('#txtRecepcionRad').val('');
                }

                $('#dvEnvioRadicar').css('display', 'inline');
                $('#dvChkSeleccionMultiple').css('display', 'inline');
                $('#dvRecepcionRadicadoMasivo').css('display', 'none');
                $('#btnGenerarOrden').css('display', 'inline');
            }
        }

        function ValidarEstadoRadicados(evt) {
            if (ValidaNumeros(evt)) {
                if (evt.which == 13) {
                    var radicado = parseInt($('#txtRecepcionRad').val());

                    if (radicado > 0) {
                        EjecutarCallback('', '', 'VerificarCambiarEstadoRadicado', radicado);
                    }
                    return false;
                }
            }
            else {
                return false;
            }

        }

        function SubirDocumentoMC() {

            var fileUpload = $("#fuSubirArchivo").get(0);

            if ((fileUpload.files[0].type == 'application/pdf' || fileUpload.files[0].type.split('/')[0] == 'image') && (fileUpload.files[0].size < 15000000))
            {
                var files = fileUpload.files;
                var test = new FormData();
                for (var i = 0; i < files.length; i++) {
                    test.append(files[i].name, files[i]);
                }
                $.ajax({
                    url: "../ControlesDeUsuario/CargarArchivosServidor.ashx?idRadicado=" + $('input[id$=hdfIdRadicado]').val() + "&origen=RadicarDocumento",
                    type: "POST",
                    contentType: false,
                    processData: false,
                    data: test,
                    // dataType: "json",
                    success: function (result) {
                        var mensaje = result.split('|')[0];
                        var color = result.split('|')[1];
                        alert(mensaje, color);
                        $('#fuSubirArchivo')[0].value = '';
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }
            else if (fileUpload.files[0].size >= 15000000) {
                alert('El peso del archivo es superior a 15MB. Por favor elija uno con menor tamaño', 'rojo');
            }
            else {
                alert('Se requiere el archivo en formato PDF o formato imagen', 'rojo');
            }
        }


    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </div>
            <div id="dvEncabezado">
                <div style="margin-left: 4%">
                    <h3 id="hEncabezdoBoton">Pool radicación en Bancos </h3>
                </div>

                <hr />
            </div>
            <div id="dvBotonesAcciones">
                <button type="button" id="btnRecibirRad" class="btn btn-primary" onclick="MostrarOcultarDvs('recepcion')">Recepción Masiva </button>
                <button type="button" id="btnPasoRadicar" class="btn btn-primary" onclick="MostrarOcultarDvs('paso')">Gestionar Servicios </button>

                <button type="button" id="btnGenerarOrden" class="btn btn-danger" style="cursor: default; display: none; height: 44px" title="Imposible flujo de estados">
                    Cambiar 
                    <span class="badge">Estados</span>
                </button>
                 <br />
                <br />
                <div id="dvChkSeleccionMultiple" style="display: none">
                    <h4><label class="switch"><input id="chkSeleccionMultiple" type="checkbox" /><span class="slider round"></span></label>Seleccionar múltiples radicados para la planilla</h4>

<%--                    <label id="lblCheckMultiple" class="checkbox-inline">
                        <input type="checkbox" id="chkSeleccionMultiple" />Seleccionar múltiples radicados para la planilla</label>--%>
                </div>
               
                <div id="dvServiciosSeleccionados" style="display: block">
                </div>
                

            </div>

            <div id="dvRecepcionRadicadoMasivo" style="display: none">
                <div id="dvContenedorMasivo">
                    <div class="form-group">
                        <label for="txtRecepcionRad" class="col-lg-2 control-label">Radicado</label>
                        <div class="col-lg-10">
                            <input type="text" class="form-control" id="txtRecepcionRad" onkeydown="return ValidarEstadoRadicados(event)" placeholder="Ingrese su búsqueda..." runat="server" />
                        </div>
                    </div>

                </div>
                <br />
                <br />
                <br />
                <div id="dvTblRecepcionMasiva">
                    <table class="table table-hover" id="tblRecepcionMasiva">
                    </table>
                </div>
            </div>

            <div id="dvEnvioRadicar" style="display: none">

                <div id="dvGridCallBack" style="display: none">

                    <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
                        >
                        <ClientSideEvents EndCallback="function (s, e){
                 FinalizarCallbackGeneral(s, e, 'divEncabezado');
                MostrarInfoEncabezado(s,e);
               
            }" />
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                                    KeyFieldName="idServicioMensajeria" Theme="SoftOrange" Width="100%">
                                    <ClientSideEvents EndCallback="function(s, e) {
                                            if(s.cpBusquedaVta.length != 0)
                                            {
                                                AutoCompletar(s.cpBusquedaVta);
                                            }
                                            else
                                            {
                                                MostrarInfoEncabezado(s, e);
                                            }
                                            
                                        }"></ClientSideEvents>
                                </dx:ASPxGridView>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>
                </div>

                <div id="dvPoolRecepcioRadicados">
                    <div id="dvRecepcionRadicado">
                        <div class="form-group">
                              <div class="col-lg-10">
                                <input type="text" class="form-control" id="txtCedulaRadiacado" onkeydown="return CargarBusquedaVenta('Cedula', this, event)" placeholder="Ingrese su búsqueda..." runat="server" />
                            </div>

                             <div class="col-lg-10">
                                <label for="txtCedulaRadiacado" class="col-lg-2 control-label">Cédula, Radicado o Estrategia</label>
                             </div>
                          
                          
                        </div>
                          <br />
                            <br />
                        <div class="form-group" style="display: none">
                            <label for="txtCampaniaEstrategia" class="col-lg-2 control-label">Campaña o Estrategia</label>
                            <div class="col-lg-10">
                                <input type="text" class="form-control" id="txtCampaniaEstrategia" onkeydown="return CargarBusquedaVenta('Campania', event)" placeholder="Ingrese su búsqueda..." runat="server" />
                            </div>
                        </div>
                    </div>
                </div>



                <div id="dvTblBusquedaVenta">
                    <table class="table table-hover" id="tblBusquedaVenta">
                    </table>
                    <asp:HiddenField ID="hdfIdRadicado" runat="server" />
                    <asp:HiddenField ID="hdfContenidoTablaResultado" runat="server" />
                    <asp:HiddenField ID="hdfUsuarioSesion" runat="server" />
                    <asp:HiddenField ID="hdfCausalesBanco" runat="server" />
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

                        </Columns>
                    </asp:GridView>
                </div>

                <div id="dvNovedadesDocs" title="Novedades">
                    <table class="table table-hover" id="tblNovedadesDocs" style="display: none">
                    </table>
                </div>

                <div id="dvImagenesDocs" title="Documentos - Click para ampliar imagen">
                </div>


                <div id="dvCausalRechazoDocs">
                    <table class="table table-hover" id="tblCausalDevolucion">
                    </table>
                </div>

                <div class="PrintArea">
                    <div>
                        <img id="imgImpresion" />
                    </div>
                </div>
                <br />
                <br />
            </div>

            <table id="tblGenerarPlanilla" style="display: inline">
            </table>


            <%--            <div id="dvSubirArchivo">
                <input type="file" id="fuSubirArchivo" />
            </div>--%>
        </div>
    </form>
</body>
</html>
