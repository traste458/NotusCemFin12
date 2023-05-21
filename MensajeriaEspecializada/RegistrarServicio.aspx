<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarServicio.aspx.vb"
    Inherits="BPColSysOP.RegistrarServicio" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registro de Servicio</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            height: 25px;
        }
    </style>
    <script language="javascript" type="text/javascript">

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
                //alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }

        }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        var ctrIdFlagFilterFilter
        var callBackPanelFilter

        function FiltrarEOPanel(idFiltro, idFlag, parametro, idCallbackPanel) {
            var filtro = document.getElementById(idFiltro).value.trim();
            if (idFlag != 0) { ObtenerIdFlagCallBackPanelFilter(idFlag); }
            var comboFiltrado = ctrIdFlagFilterFilter.value;
            try {
                if (filtro.length >= 4 || (filtro.length < 4 && comboFiltrado == "1")) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(callBackPanelFilter.id, parametro);
                    if (filtro.length >= 4) {
                        ctrIdFlagFilterFilter.value = "1";
                    } else {
                        ctrIdFlagFilterFilter.value = "0";
                    }
                }
                document.getElementById(idFiltro).focus();
            } catch (e) {
                MostrarOcultarDivFloater(false);
                //alert("Error al tratar de filtrar Datos.\n" + e.description);
            }
        }

        function ValidarNumeroRadicado() {
            try {
                var numRadicado = document.getElementById("txtNoRadicado").value.trim();
                if (numRadicado.length > 0) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback("cpValidacionNumRadicado", numRadicado);
                }
            } catch (e) {
                MostrarOcultarDivFloater(false);
                //alert("Error al tratar de filtrar Datos.\n" + e.description);
            }
        }

        function ObtenerIdFlagCallBackPanelFilter(idFlag) {

            switch (idFlag) {
                case 1:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMaterial.ClientID %>');
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMaterial.ClientID %>');
                    break;
                case 2:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMaterialPrestamo.ClientID %>')
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMaterialPrestamo.ClientID %>');
                    break;
                default:
                    break;
            }
        }

        function ValidarNumCaracteresObservacion(source, args) {
            var texto = document.getElementById("txtObservacion").value;
            if (texto.length > 1024) {
                args.IsValid = true;
            } else {
                args.IsValid = true;
            }
        }

        function activarCantidad(ctrl) {
            try {
                var row = ctrl.parent("td").parent("tr");
                var controlCantidad = row.find('input[id*="txtCantRequerida"]');
                if (ctrl.attr('checked')) {
                    controlCantidad.removeAttr('disabled');
                } else {
                    controlCantidad.attr('value', '0');
                    controlCantidad.attr('disabled', 'disabled');
                }
            } catch (e) {
                alert("Error al tratar de activar cantidad.\n Error:" + e.description);
            }
        }

        function ConfirmarRegistro() {
            try {
                var tipoServicio = $('#ddlTipoServicio').attr('value');

                //Reposición - Orden de Compra
                if (tipoServicio == 1 || tipoServicio == 7) {
                    Page_ClientValidate('vgServicio');
                    if (Page_IsValid) {
                        var mensaje = "";
                        var numReferencias = parseInt(document.getElementById("hfNumReferencias").value);
                        var numMsisdns = parseInt(document.getElementById("hfNumMsisdn").value);
                        var numDetalle = parseInt(document.getElementById("hfDetalleArchivo").value);

                        if (numReferencias == 0 && numMsisdns == 0 && numDetalle == 0) {
                            mensaje = "No se han proporcionado Referencias ni MSISDNs. ¿Realmente desea continuar?";
                        } else {
                            if (numDetalle == 0) {
                                if (numReferencias == 0) { mensaje = "No se han proporcionado Referencias. ¿Realmente desea continuar?"; }
                                if (numMsisdns == 0) { mensaje = "No se han proporcionado MSISDNs. ¿Realmente desea continuar?"; }
                                if (numDetalle == 0) { mensaje = "No se han proporcionado Detalle. ¿Realmente desea continuar?"; }
                            }
                        }
                        if (mensaje != "") {
                            return confirm(mensaje);
                        } else {
                            return true;
                        }
                    }
                    return Page_IsValid;
                }
                    //Servicio Técnico
                else if (tipoServicio == 5) {
                    Page_ClientValidate('vgServicio');
                    if (Page_IsValid) {
                        var mensaje = "";
                        var equipos = $('#gvEquipos').find('input[type="checkbox"]');

                        if (equipos.length <= 0) {
                            mensaje = "No se han adicionado equipos para reparación, por favor adicionelos e intente nuevamente.";
                        } else {
                            var equiposPrestamo = 0;
                            var equiposInventario = 0;

                            equiposPrestamo = $('#gvEquipos').find('input:checked').length;
                            $('#gvEquiposPrestamo input').each(function () {
                                var cantidadRow = 0;
                                var row = $(this).parent("td").parent("tr");
                                cantidadRow = parseInt(row.find('td')[3].innerHTML);
                                equiposInventario += (cantidadRow != 0) ? cantidadRow : 0;
                            });


                            if (equiposPrestamo != equiposInventario) {
                                mensaje = "La cantidad de equipos seleccionados del inventario, debe ser igual a la cantidad de equipos que requieren prestamo.\n\nEquipos que requieren prestamo prestamo: [" + equiposPrestamo + "]\nEquipos seleccionados del Inventario: [" + equiposInventario + "]";
                            }
                        }
                        if (mensaje != "") {
                            alert(mensaje);
                            return false;
                        } else {
                            return true;
                        }
                    }
                    return Page_IsValid;
                }

            } catch (e) {
                alert("Error al tratar de confirmar registro.\n Error:" + e.description);
                return false;
            }
        }

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

            document.getElementById("hfMedidasVentana").value = myHeight + ";" + myWidth;
        }

        function ValidarPrecios(source, args) {
            try {
                var precioSinIva = document.getElementById("txtPrecioSinIVA").value;
                var precioConIva = document.getElementById("txtPrecioConIVA").value;
                if (precioSinIva == "") { precioSinIva = 0; }
                if (precioConIva == "") { precioConIva = 0; }
                if (parseFloat(precioSinIva) > 0 && parseFloat(precioConIva) > 0) {
                    if (precioConIva == precioSinIva) {
                        args.IsValid = false;
                    } else {
                        args.IsValid = true;
                    }
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                alert("Error al tratar de evaluar precios.\n" + Error.description);
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function ValidaSeleccionInventario(ctrl) {
            var row = ctrl.parent("td").parent("tr");
            var controlCantidadDisponible = parseInt(row.find('input[id*="txtCantDisponible"]').val());
            var controlCantidadRequerida = parseInt(row.find('input[id*="txtCantRequerida"]').val());

            if (controlCantidadDisponible < controlCantidadRequerida) {
                alert("La cantidad requerida de este material es superior a la disponible, por favor verifique e intente nuevamente.\n\nCantidad Disponible: [" + controlCantidadDisponible + "]\nCantidad requerida: [" + controlCantidadRequerida + "]");
                row.find('input[id*="txtCantRequerida"]').attr('value', '0');
                return false;
            } else {
                return true;
            }
        }

        function ValidarAdicionEquipoPrestamo() {
            try {
                Page_ClientValidate('vgReferenciaPrestamo');
                if (Page_IsValid) {
                    var ctrlMaterialPrestamo = $('#ddlMaterialPrestamo option:selected');
                    var cantidadDisponible = parseInt(ctrlMaterialPrestamo.text().substring(ctrlMaterialPrestamo.text().indexOf("[") + 1, ctrlMaterialPrestamo.text().length - 1));
                    var cantidadPrestamo = parseInt($('#txtCantidadPrestamo').val());

                    if (cantidadPrestamo <= cantidadDisponible) {
                        var arrIdMaterial = ctrlMaterialPrestamo.val().split('|');
                        var mensaje = "";

                        $('#gvEquiposPrestamo input').each(function () {
                            var row = $(this).parent("td").parent("tr");
                            if (row.find('td')[1].innerHTML == arrIdMaterial[0]) {
                                mensaje = "El material que intenta adicionar ya se encuentra incluido en la reserva actual, por favor verifique e intente nuevamente.";
                                return false;
                            }
                        });

                        if (mensaje != "") {
                            alert(mensaje);
                            return false;
                        } else { return true; }
                    } else {
                        alert("La cantidad requerida de este material es superior a la disponible, por favor verifique e intente nuevamente.\n\nCantidad Disponible: [" + cantidadDisponible + "]\nCantidad requerida: [" + cantidadPrestamo + "]");
                        return false;
                    }
                } else { return false; }
            } catch (e) {
                alert("Error al tratar de validar adición de equipo de préstamo: " + e.description);
            }
        }

        function validarTelefonoClient(source, args) {
            try {
                var objExtension = document.getElementById('<%= txtExtension.ClientID %>');

                if (document.getElementById('<%= rbTelefonoFijo.ClientID %>').checked) {
                    objExtension.disabled = false;
                    document.getElementById('<%= hfMaxLength.ClientID %>').value = 7;
                    if (document.getElementById('<%= txtTelefono.ClientID %>').value.length == 7)
                        args.IsValid = true;
                    else
                        args.IsValid = false;
                }
                else if (document.getElementById('<%= rbTelefonoCelular.ClientID %>').checked) {
                    objExtension.disabled = true;
                    document.getElementById('<%= hfMaxLength.ClientID %>').value = 10;
                    if (document.getElementById('<%= txtTelefono.ClientID %>').value.length == 10)
                        args.IsValid = true;
                    else
                        args.IsValid = false;
                }

            document.getElementById('<%= txtTelefono.ClientID %>').disabled = false;
                document.getElementById('<%= txtTelefono.ClientID %>').focus();
            }
            catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar teléfono.\n" + e.description);
            }
        }

        function validarTelefono() {
            try {
                var objExtension = document.getElementById('<%= txtExtension.ClientID %>');

                if (document.getElementById('<%= rbTelefonoFijo.ClientID %>').checked) {
                    objExtension.disabled = true;
                    document.getElementById('<%= hfMaxLength.ClientID %>').value = 7;
                }
                else if (document.getElementById('<%= rbTelefonoCelular.ClientID %>').checked) {
                    objExtension.disabled = false;
                    document.getElementById('<%= hfMaxLength.ClientID %>').value = 10;
                }
            document.getElementById('<%= txtTelefono.ClientID %>').disabled = false;
                document.getElementById('<%= txtTelefono.ClientID %>').focus();
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar teléfono.\n" + e.description);
            }
        }

        function checkTextAreaMaxLength(textBox, e) {
            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = document.getElementById('<%= hfMaxLength.ClientID %>').value;
            var maxLength = parseInt(mLen);
            if (!checkSpecialKeys(e)) {
                if (textBox.value.length > maxLength - 1) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                        e.preventDefault();
                }
            }
        }

        function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 35 && e.keyCode != 36 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        }

        function showDescription(obj, mensaje) {
            $("#fancy, #fancy2").tooltip({
                track: true,
                delay: 0,
                showURL: false,
                opacity: 1,
                fixPNG: true,
                showBody: " - ",
                extraClass: "pretty fancy",
                top: -15,
                left: 5
            });
        }

        function abrirArchivoEjemplo() {
            var newWindow = window.open("../images/CreacionServicio.png", "EjemploArchivo", "toolbar=0,location=0,menubar=0,scrollbars=1;resizable=1,status=0;titlebar=0");
            try {
                newWindow.document.title = "Archivo de Ejemplo";
            } catch (e) { }
        }

        function ControlErrorUpload(control, error, message) {
            alert('Extensión o peso del archivo no permitida');
        }

        function ControlCargueUpload() {
            var archivosEO = $("#fuArchivoAdjuntarEO_postedFiles");
            if (archivosEO.html().length == 0) {
                $('#btnSubir').attr('disabled', 'disabled');
            } else {
                $('#btnSubir').removeAttr('disabled');
            }
        }
        function your_error_handler(control, error, message) {
            //do whatever you like here, for example:
            if (error == "time_out")
                window.alert("time out!");
        }


    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize()">
    <form id="formPrincipal" runat="server">
        <eo:CallbackPanel ID="cpEncabezado" runat="server" UpdateMode="Always" Width=" 98%">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            <asp:HiddenField ID="hfMedidasVentana" runat="server" />
            <asp:HiddenField ID="hfNumReferencias" runat="server" Value="0" />
            <asp:HiddenField ID="hfNumMsisdn" runat="server" Value="0" />
            <asp:HiddenField ID="hfDetalleArchivo" runat="server" Value="0" />
        </eo:CallbackPanel>
        <eo:CallbackPanel ID="cpGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait" AutoDisableContent="true"
            ChildrenAsTriggers="false" Width="100%">
            <asp:Panel ID="pnlInfoGeneral" runat="server">
                <table class="tablaGris" cellpadding="1">
                    <tr>
                        <th colspan="4">Información del Servicio de Mensajería
                        </th>
                    </tr>
                    <tr>
                        <td class="alterColor">Tipo Servicio:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTipoServicio" runat="server" AutoPostBack="True">
                            </asp:DropDownList>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvTipoServicio" runat="server" ErrorMessage="El tipo de servicio a registrar es requerido"
                                    Display="Dynamic" ControlToValidate="ddlTipoServicio" InitialValue="0" ValidationGroup="vgServicio"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td class="alterColor">N&uacute;mero de Radicado:
                        </td>
                        <td>
                            <eo:CallbackPanel ID="cpValidacionNumRadicado" runat="server" UpdateMode="Self" Width=" 100%"
                                ClientSideAfterUpdate="CallbackAfterUpdateHandler">
                                <div style="display: inline">
                                    <asp:TextBox ID="txtNoRadicado" runat="server" Width="100px" onblur="ValidarNumeroRadicado();"
                                        MaxLength="15"></asp:TextBox><asp:Image ID="imgError" runat="server" ImageUrl="~/images/close.gif" />
                                </div>
                                <div style="display: block">
                                    <asp:RequiredFieldValidator ID="rfvtxtNoRadicado" runat="server" ControlToValidate="txtNoRadicado"
                                        Display="Dynamic" ErrorMessage="El número de Radicado es obligatorio" ValidationGroup="vgServicio" />
                                    <asp:RegularExpressionValidator ID="revtxtNoRadicado" runat="server" Display="Dynamic"
                                        ControlToValidate="txtNoRadicado" ValidationGroup="vgServicio" ErrorMessage="El radicado debe ser numérico con logitud de 7 a 15 d&iacute;gitos"
                                        ValidationExpression="[0-9]{5,15}"></asp:RegularExpressionValidator>
                                </div>
                            </eo:CallbackPanel>
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">Prioridad:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlPrioridad" runat="server"></asp:DropDownList>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvPrioridad" runat="server" ErrorMessage="Valor de campo prioridad requerido"
                                    Display="Dynamic" ControlToValidate="ddlPrioridad" InitialValue="0" ValidationGroup="vgServicio"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td class="alterColor">Fecha Vencimiento Reserva:
                        </td>
                        <td>
                            <eo:DatePicker ID="dpFechaVencimientoReserva" runat="server" PickerFormat="dd/MM/yyyy"
                                ControlSkinID="None" CssBlock="&lt;style type=&quot;text/css&quot;&gt;
                        .DatePickerStyle1 {background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}
                        .DatePickerStyle2 {border-bottom-color:#f5f5f5;border-bottom-style:solid;border-bottom-width:1px;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle3 {font-family:Verdana;font-size:8pt}
                        .DatePickerStyle4 {background-image:url('00040402');color:#1c7cdc;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle5 {background-image:url('00040401');color:#1176db;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle6 {color:gray;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle7 {cursor:pointer;cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px}
                        .DatePickerStyle8 {background-image:url('00040403');color:Brown;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle9 {cursor:pointer;cursor:hand}
                        .DatePickerStyle10 {font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}
                            &lt;/style&gt;"
                                DayCellHeight="15" DayCellWidth="31" DayHeaderFormat="Short"
                                DisabledDates="" OtherMonthDayVisible="True" SelectedDates="" TitleFormat="MMMM, yyyy"
                                TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                                AllowMultiSelect="False">
                                <TodayStyle CssClass="DatePickerStyle5" />
                                <SelectedDayStyle CssClass="DatePickerStyle8" />
                                <DisabledDayStyle CssClass="DatePickerStyle6" />
                                <FooterTemplate>
                                    <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                        <tr>
                                            <td width="30"></td>
                                            <td valign="center">
                                                <img src="{img:00040401}"></img>
                                            </td>
                                            <td valign="center">Today: {var:today:dd/MM/yyyy}
                                            </td>
                                        </tr>
                                    </table>
                                </FooterTemplate>
                                <CalendarStyle CssClass="DatePickerStyle1" />
                                <TitleArrowStyle CssClass="DatePickerStyle9" />
                                <DayHoverStyle CssClass="DatePickerStyle4" />
                                <MonthStyle CssClass="DatePickerStyle7" />
                                <TitleStyle CssClass="DatePickerStyle10" />
                                <DayHeaderStyle CssClass="DatePickerStyle2" />
                                <DayStyle CssClass="DatePickerStyle3" />
                            </eo:DatePicker>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvFechaVencimiento" runat="server" ErrorMessage="La fecha de vencimiento es requerida"
                                    Display="Dynamic" ControlToValidate="dpFechaVencimientoReserva" ValidationGroup="vgServicio"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">Usuario Ejecutor (Cadena):
                        </td>
                        <td>
                            <asp:TextBox ID="txtUsuarioEjecutor" runat="server" Width="200px" MaxLength="50"></asp:TextBox>
                        </td>
                        <td class="alterColor">Nombres:
                        </td>
                        <td>
                            <asp:TextBox ID="txtNombres" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">Identificaci&oacute;n:
                        </td>
                        <td>
                            <asp:TextBox ID="txtIdentificacion" runat="server" Width="200px" MaxLength="15"></asp:TextBox>
                            <div style="display: block">
                                <asp:RegularExpressionValidator ID="revIdentificacion" runat="server" Display="Dynamic"
                                    ControlToValidate="txtIdentificacion" ValidationGroup="vgServicio" ErrorMessage="La identificación no es correcta. Se espera un valor numérico cuya longitud esté entre 4 y 15 dígitos"
                                    ValidationExpression="[0-9]{4,10}"></asp:RegularExpressionValidator>
                            </div>
                        </td>
                        <td class="alterColor">Persona de Contacto (Autorizado):
                        </td>
                        <td>
                            <asp:TextBox ID="txtNombresAutorizado" runat="server" Width="300px" MaxLength="150"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">Ciudad:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCiudad" runat="server">
                            </asp:DropDownList>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvCiudad" runat="server" ErrorMessage="La ciudad de entrega es requerida"
                                    ControlToValidate="ddlCiudad" InitialValue="0" ValidationGroup="vgServicio" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td class="alterColor">Barrio:
                        </td>
                        <td>
                            <asp:TextBox ID="txtBarrio" runat="server" Width="300px" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">Dirección:
                        </td>
                        <td>
                            <asp:TextBox ID="txtDireccion" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
                        </td>
                        <td class="alterColor">Teléfono:
                        </td>
                        <td valign="middle">
                            <div>
                                <asp:RadioButton runat="server" ID="rbTelefonoCelular" GroupName="telefono" Text="Celular" />
                                <asp:RadioButton runat="server" ID="rbTelefonoFijo" GroupName="telefono" Text="Fijo" />
                            </div>
                            <asp:TextBox ID="txtTelefono" runat="server" Width="150px" Enabled="False" MaxLength="10"></asp:TextBox>
                            &nbsp;ext.&nbsp;
                        <asp:TextBox ID="txtExtension" runat="server" Width="50px" Enabled="False" MaxLength="5"></asp:TextBox>
                            <br />
                            <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono"
                                Display="Dynamic" ErrorMessage="El teléfono es requerido" ValidationGroup="vgServicio">
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="cvTelefono" runat="server" Display="Dynamic" ControlToValidate="txtTelefono"
                                ValidationGroup="vgServicio" ClientValidationFunction="validarTelefonoClient"
                                ErrorMessage="La longitud del teléfono debe ser de 10 dígitos para celular y 7 para teléfonos fijos." />
                            <asp:HiddenField ID="hfMaxLength" Value="0" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style1">Fecha Asignaci&oacute;n
                        </td>
                        <td>
                            <eo:DatePicker ID="dpFechaAsignacion" runat="server" PickerFormat="dd/MM/yyyy HH:mm"
                                ControlSkinID="None" CssBlock="&lt;style type=&quot;text/css&quot;&gt;
                        .DatePickerStyle1 {background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}
                        .DatePickerStyle2 {border-bottom-color:#f5f5f5;border-bottom-style:solid;border-bottom-width:1px;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle3 {font-family:Verdana;font-size:8pt}
                        .DatePickerStyle4 {background-image:url('00040402');color:#1c7cdc;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle5 {background-image:url('00040401');color:#1176db;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle6 {color:gray;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle7 {cursor:pointer;cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px}
                        .DatePickerStyle8 {background-image:url('00040403');color:Brown;font-family:Verdana;font-size:8pt}
                        .DatePickerStyle9 {cursor:pointer;cursor:hand}
                        .DatePickerStyle10 {font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}
                            &lt;/style&gt;"
                                DayCellHeight="15" DayCellWidth="31" DayHeaderFormat="Short"
                                DisabledDates="" OtherMonthDayVisible="True" SelectedDates="" TitleFormat="MMMM, yyyy"
                                TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                                AllowMultiSelect="False">
                                <TodayStyle CssClass="DatePickerStyle5" />
                                <SelectedDayStyle CssClass="DatePickerStyle8" />
                                <DisabledDayStyle CssClass="DatePickerStyle6" />
                                <FooterTemplate>
                                    <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                        <tr>
                                            <td width="30"></td>
                                            <td valign="center">
                                                <img src="{img:00040401}"></img>
                                            </td>
                                            <td valign="center">Today: {var:today:dd/MM/yyyy}
                                            </td>
                                        </tr>
                                    </table>
                                </FooterTemplate>
                                <CalendarStyle CssClass="DatePickerStyle1" />
                                <TitleArrowStyle CssClass="DatePickerStyle9" />
                                <DayHoverStyle CssClass="DatePickerStyle4" />
                                <MonthStyle CssClass="DatePickerStyle7" />
                                <TitleStyle CssClass="DatePickerStyle10" />
                                <DayHeaderStyle CssClass="DatePickerStyle2" />
                                <DayStyle CssClass="DatePickerStyle3" />
                            </eo:DatePicker>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvFechaAsignacion" runat="server" ErrorMessage="Fecha de Asignaci&oacute;n es requerida. Por favor verifique"
                                    ControlToValidate="dpFechaAsignacion" ValidationGroup="vgServicio" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td class="alterColor">Cliente VIP:
                        </td>
                        <td>
                            <asp:CheckBox ID="chbClienteVIP" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">Plan actual:
                        </td>
                        <td>
                            <asp:TextBox ID="txtPlanActual" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
                        </td>
                        <td class="alterColor">Observaciones:
                        </td>
                        <td>
                            <asp:TextBox ID="txtObservacion" runat="server" Width="400px" Rows="3" TextMode="MultiLine"
                                MaxLength="1024"></asp:TextBox>
                            <div style="display: block">
                                <asp:CustomValidator ID="cusObservacion" runat="server" ControlToValidate="txtObservacion"
                                    ClientValidationFunction="ValidarNumCaracteresObservacion" ErrorMessage="El texto supera la cantidad maxima de caracteres permitidos"
                                    Display="Dynamic"></asp:CustomValidator>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <div style="display: block; text-align: center">
                    <asp:LinkButton ID="lbGuardar" runat="server" CssClass="search" Font-Bold="True"
                        CausesValidation="true" ValidationGroup="vgServicio" OnClientClick="return ConfirmarRegistro();"> 
                    <img alt="Guardar Servicio" src="../images/save_all.png" />&nbsp;Guardar </asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:LinkButton ID="lbMostrarFormNovedad" runat="server" CssClass="search" Font-Bold="True"
                    CausesValidation="false"> 
            <img alt="Adicionar Novedad" src="../images/notepad.gif" />&nbsp;Adicionar Novedad </asp:LinkButton><br />
                    <br />
                    <eo:Dialog runat="server" ID="dlgNovedad" ControlSkinID="None" Height="350px" HeaderHtml="Adici&oacute;n de Novedades"
                        CloseButtonUrl="00020312" BackColor="White" CancelButton="lbCerrarPopUp" BackShadeColor="Gray"
                        BackShadeOpacity="50">
                        <ContentTemplate>
                            <table align="center" class="tabla">
                                <tr>
                                    <th colspan="2">INFORMACI&Oacute;N DE LA NOVEDAD</th>
                                </tr>
                                <tr>
                                    <td class="field">Seleccione tipo de Novedad:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlTipoNovedad" runat="server" ValidationGroup="registroNovedad">
                                        </asp:DropDownList>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvTipoNovedad" runat="server" ErrorMessage="Seleccione un tipo de novedad"
                                                Display="Dynamic" ControlToValidate="ddlTipoNovedad" ValidationGroup="registroNovedad"
                                                InitialValue="0"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">Comentario General:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtObservacionNovedad" runat="server" TextMode="MultiLine" Rows="3"
                                            Columns="50"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvObservacionNovedad" runat="server" ErrorMessage="Indique la descripci&oacute;n general de la novedad, por favor"
                                                Display="Dynamic" ControlToValidate="txtObservacionNovedad" ValidationGroup="registroNovedad"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <br />
                                        <asp:LinkButton ID="lbAdicionarNovedad" runat="server" ValidationGroup="registroNovedad"
                                            CssClass="submit"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="submit"><img src="../images/close.gif" alt="" />&nbsp;Cancelar</asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                        <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                        <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                        <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                        <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                            TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                            TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
                    </eo:Dialog>
                </div>
            </asp:Panel>
            <div id="divFloater" style="display: none; position: static; height: 35px; width: 200px;">
                <table align="center">
                    <tr>
                        <td align="center" valign="middle" style="height: 100%">
                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" ImageAlign="Middle" />
                            <b>Procesando...</b>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Panel ID="pnlReposicion" runat="server" Visible="false">
                <table width="95%">
                    <tr>
                        <%--Agregar Referencias--%>
                        <td valign="top" style="width: 34%">
                            <asp:Panel ID="pnlInfoReferencia" runat="server">
                                <table class="tablaGris" cellpadding="1" style="width: 100%;">
                                    <tr>
                                        <th colspan="3">Agregar Referencias
                                        </th>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Referencia:
                                        </td>
                                        <td>
                                            <div style="display: inline">
                                                <asp:TextBox ID="txtFiltroMaterial" runat="server" CssClass="textbox" MaxLength="50"
                                                    onkeyup="FiltrarEOPanel(this.id, 1, 'filtrarMaterial');" Width="150px" Style="display: inline;"></asp:TextBox>&nbsp;-&nbsp;
                                            <br />
                                                <eo:CallbackPanel ID="cpFiltroMaterial" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                                                    Style="display: inline !important; padding: 0px 0px 0px 0px; vertical-align: middle"
                                                    Width="100%">
                                                    <asp:DropDownList ID="ddlMaterial" runat="server" Style="display: inline;">
                                                    </asp:DropDownList>
                                                    <div style="display: block">
                                                        <asp:Label ID="lblMateriales" runat="server" CssClass="comentario"></asp:Label>
                                                        <asp:HiddenField ID="hfMaterial" runat="server" />
                                                    </div>
                                                </eo:CallbackPanel>
                                                <div style="display: block">
                                                    <asp:RequiredFieldValidator ID="rfvMaterial" runat="server" ErrorMessage="La referencia solicitada es requerida"
                                                        ControlToValidate="ddlMaterial" Display="Dynamic" InitialValue="0" ValidationGroup="vgReferencia"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hfFlagFiltroMaterial" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Cantidad:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtCantidad" runat="server" Width="100px" ValidationGroup="vgReferencia"
                                                MaxLength="4"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvtxtCantidad" runat="server" ControlToValidate="txtCantidad"
                                                    Display="Dynamic" ErrorMessage="La Cantidad es requerida" ValidationGroup="vgReferencia" />
                                                <asp:RegularExpressionValidator ID="revtxtCantidad" runat="server" Display="Dynamic"
                                                    ControlToValidate="txtCantidad" ValidationGroup="vgReferencia" ErrorMessage="La cantidad debe ser numérica."
                                                    ValidationExpression="[0-9]{1,3}"></asp:RegularExpressionValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <div style="display: inline">
                                                <asp:LinkButton ID="lbAgregarReferencia" runat="server" CssClass="search" Font-Bold="True"
                                                    ValidationGroup="vgReferencia" CausesValidation="true"> 
                                                <img alt="Agregar referencia" src="../images/add.png" />&nbsp;Agregar </asp:LinkButton>
                                            </div>
                                            <asp:Panel ID="pnlBotonEdicionReferencia" runat="server" Style="display: inline;">
                                                <asp:LinkButton ID="lbActualizarRef" runat="server" CssClass="search" Font-Bold="True"
                                                    ValidationGroup="vgReferencia" CausesValidation="true"> 
                                            <img alt="Actualizar Referencia" src="../images/save_all.png" />&nbsp;Actualizar </asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                            <asp:LinkButton ID="lbCancelarActRef" runat="server" CssClass="search" Font-Bold="True"
                                                CausesValidation="true"> 
                                               <img alt="Cancelar Actualizaci&oacute;n" src="../images/cancelar.png" />&nbsp;Cancelar </asp:LinkButton>
                                            </asp:Panel>
                                            <br />
                                            <asp:HiddenField ID="hfMaterialAct" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <asp:GridView ID="gvReferencias" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                                EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                                Width="90%">
                                                <AlternatingRowStyle CssClass="alterColor" />
                                                <FooterStyle CssClass="footer" />
                                                <Columns>
                                                    <asp:BoundField DataField="material" HeaderText="Material" />
                                                    <asp:BoundField DataField="referencia" HeaderText="Referencia" />
                                                    <asp:BoundField DataField="cantidad" HeaderText="Cantidad" />
                                                    <asp:TemplateField HeaderText="Opciones">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("material") %>'
                                                                ToolTip="Eliminar" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el registro?');" />&nbsp;&nbsp;
                                                        <asp:ImageButton ID="ibEditar" runat="server" CommandName="editar" CommandArgument='<%# Bind("material") %>'
                                                            ToolTip="Editar" ImageUrl="~/images/Edit-32.png" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                        <%--Agregar MINs--%>
                        <td valign="top" style="width: 33%">
                            <asp:Panel ID="pnlInfoMin" runat="server">
                                <table class="tablaGris" cellpadding="1" style="width: 100%;">
                                    <tr>
                                        <th colspan="2">Agregar MINs
                                        </th>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Msisdn:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtMsisdn" runat="server" Width="100px" ValidationGroup="vgMIN"
                                                MaxLength="10"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvtxtMsisdn" runat="server" ControlToValidate="txtMsisdn"
                                                    Display="Dynamic" ErrorMessage="El MSISDN es requerido" ValidationGroup="vgMIN" />
                                                <asp:RegularExpressionValidator ID="revtxtMsisdn" runat="server" Display="Dynamic"
                                                    ControlToValidate="txtMsisdn" ValidationGroup="vgMIN" ErrorMessage="El MSISDN debe ser numérico"
                                                    ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Número Reserva:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNumeroReserva" runat="server" Width="100px" MaxLength="100"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Activa equipo anterior:
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="chbActivaEquipoAnterior" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Comseguro:
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="chbComSeguro" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Precio sin IVA:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtPrecioSinIVA" runat="server" Width="100px" ValidationGroup="vgMIN"
                                                MaxLength="10"></asp:TextBox>
                                            <div style="display: block">
                                                <div style="display: block">
                                                    <asp:RequiredFieldValidator ID="rfvtxtPrecioSinIVA" runat="server" ControlToValidate="txtPrecioSinIVA"
                                                        Display="Dynamic" ErrorMessage="El Precio sin IVA es requerido" ValidationGroup="vgMIN" />
                                                    <asp:RegularExpressionValidator ID="revtxtPrecioSinIVA" runat="server" Display="Dynamic"
                                                        ControlToValidate="txtPrecioSinIVA" ValidationGroup="vgMIN" ErrorMessage="El Precio sin IVA debe ser numérico"
                                                        ValidationExpression="[0-9]{1,10}"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Precio con IVA:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtPrecioConIVA" runat="server" Width="100px" ValidationGroup="vgMIN"
                                                MaxLength="10"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvtxtPrecioConIVA" runat="server" ControlToValidate="txtPrecioConIVA"
                                                Display="Dynamic" ErrorMessage="El Precio con IVA es requerido" ValidationGroup="vgMIN" />
                                            <asp:RegularExpressionValidator ID="revtxtPrecioConIVA" runat="server" Display="Dynamic"
                                                ControlToValidate="txtPrecioConIVA" ValidationGroup="vgMIN" ErrorMessage="El Precio con IVA debe ser numérico"
                                                ValidationExpression="[0-9]{1,10}"></asp:RegularExpressionValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">
                                            <asp:Label ID="Label11" runat="server" Text="Clausula:"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlClausula" runat="server" Height="22px" Width="200px">
                                            </asp:DropDownList>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvClausula" runat="server" ControlToValidate="ddlClausula"
                                                    Display="Dynamic" ErrorMessage="Cláusula requerida" ValidationGroup="vgMIN" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Lista 28:</td>
                                        <td>
                                            <div>
                                                <asp:RadioButtonList ID="rblLista28" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Text="Si" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </div>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvLista28" runat="server" ErrorMessage="Debe seleccionar si aplica Lista 28"
                                                    ControlToValidate="rblLista28" ValidationGroup="vgMIN" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <div style="display: block">
                                                <asp:CustomValidator ID="cusPrecios" runat="server" ControlToValidate="txtPrecioConIva"
                                                    ErrorMessage="Los valores de Precio Sin Iva y Precio Con Iva no pueden ser iguales."
                                                    Display="Dynamic" ClientValidationFunction="ValidarPrecios" ValidationGroup="vgMIN"></asp:CustomValidator>
                                            </div>
                                            <div style="display: inline;">
                                                <asp:LinkButton ID="lbAgregarMIN" runat="server" CssClass="search" Font-Bold="True"
                                                    CausesValidation="true" ValidationGroup="vgMIN"> 
                                                <img alt="Agregar MIN" src="../images/add.png" />&nbsp;Agregar </asp:LinkButton>
                                            </div>
                                            <asp:Panel ID="pnlBotonEdicionMin" runat="server" Style="display: inline;">
                                                <asp:LinkButton ID="lbActualizarMin" runat="server" CssClass="search" Font-Bold="True"
                                                    ValidationGroup="vgMIN" CausesValidation="true"> 
                                                <img alt="Actualizar Referencia" src="../images/save_all.png" />&nbsp;Actualizar </asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                            <asp:LinkButton ID="lbCancelarActMin" runat="server" CssClass="search" Font-Bold="True"
                                                CausesValidation="true"> 
                                            <img alt="Cancelar Actualizaci&oacute;n" src="../images/cancelar.png" />&nbsp;Cancelar </asp:LinkButton>
                                            </asp:Panel>
                                            <br />
                                            <asp:HiddenField ID="hfMsisdnAct" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <asp:GridView ID="gvMINS" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                                EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                                Width="90%">
                                                <AlternatingRowStyle CssClass="alterColor" />
                                                <FooterStyle CssClass="footer" />
                                                <Columns>
                                                    <asp:BoundField DataField="msisdn" HeaderText="Msisdn" />
                                                    <asp:BoundField DataField="numeroReserva" HeaderText="No. Reserva" />
                                                    <asp:BoundField DataField="activaEquipoAnterior" HeaderText="Activa equipo anterior" />
                                                    <asp:BoundField DataField="comSeguro" HeaderText="ComSeguro" />
                                                    <asp:BoundField DataField="precioConIVA" HeaderText="Precio con IVA" />
                                                    <asp:BoundField DataField="precioSinIVA" HeaderText="Precio sin IVA" />
                                                    <asp:BoundField DataField="clausula" HeaderText="Clausula" />
                                                    <asp:BoundField DataField="lista28" HeaderText="Lista 28" />
                                                    <asp:TemplateField HeaderText="Opciones">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("idMsisdn") %>'
                                                                ToolTip="Eliminar" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el registro?');" />&nbsp;&nbsp;
                                                        <asp:ImageButton ID="ibEditar" runat="server" CommandName="editar" CommandArgument='<%# Bind("idMsisdn") %>'
                                                            ToolTip="Editar" ImageUrl="~/images/Edit-32.png" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                        <%--Agregar detalle por archivo--%>
                        <td valign="top" style="width: 33%">
                            <asp:Panel ID="pnlInfoArchivo" runat="server">
                                <table class="tablaGris" cellpadding="1" style="width: 100%;">
                                    <tr>
                                        <th colspan="2">Agregar Detalle Archivo
                                        </th>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Archivo a Cargar:
                                        </td>
                                        <td align="left">
                                            <span class="field">
                                                <eo:AJAXUploader ID="fuArchivoAdjuntarEO" runat="server" TempFileLocation="c:\windows\temp"
                                                    MaxFileCount="1" AutoUpload="true" MaxDataSize="10240" AllowedExtension=".xls|.xlsx" ClientSideOnChange="ControlCargueUpload"
                                                    ClientSideOnError="ControlErrorUpload" BrowseButtonText="Buscar.." DeleteButtonText="Eliminar Archivos">
                                                    <TextBoxStyle CssText="width: 300px" />
                                                    <LayoutTemplate>
                                                        <table border="0" cellpadding="2" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td>
                                                                    <asp:PlaceHolder ID="InputPlaceHolder" runat="server">Input Box Place Holder </asp:PlaceHolder>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <tr>
                                                                    <td colspan="10">
                                                                        <asp:PlaceHolder ID="PostedFilesPlaceHolder" runat="server">Posted Files Place Holder</asp:PlaceHolder>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right">
                                                                        <asp:Button ID="DeleteButton" runat="server" CssClass="search" Text="Eliminar archivos seleccionados" UseSubmitBehavior="true" />
                                                                    </td>
                                                                </tr>
                                                            </tr>
                                                        </table>
                                                    </LayoutTemplate>
                                                </eo:AJAXUploader>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:Button ID="btnSubir" runat="server" Text="Cargar"
                                                ValidationGroup="vgCargue" Enabled="false" Width="56px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left">
                                            <asp:Label ID="lblRegistrosCargados" runat="server" Text="" ForeColor="Blue" Font-Bold="true"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:HyperLink ID="hlVerEjemplo" onclick="abrirArchivoEjemplo();" runat="server"
                                                Font-Bold="True" ForeColor="Blue" NavigateUrl="javascript:void(0);">Ver Archivo Ejemplo</asp:HyperLink>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <asp:GridView ID="gvErrores" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                                EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                                Width="90%">
                                                <AlternatingRowStyle CssClass="alterColor" />
                                                <FooterStyle CssClass="footer" />
                                                <Columns>
                                                    <asp:BoundField DataField="id" HeaderText="id" HeaderStyle-HorizontalAlign="Center" />
                                                    <asp:BoundField DataField="nombre" HeaderText="Nombre" HeaderStyle-HorizontalAlign="Center" />
                                                    <asp:BoundField DataField="descripcion" HeaderText="Descripcion" HeaderStyle-HorizontalAlign="Center" />
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <div style="overflow: auto; width: 620px; height: 240px">
                                                <asp:GridView ID="gvDetalleArchivo" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                                    EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                                    Width="90%">
                                                    <AlternatingRowStyle CssClass="alterColor" />
                                                    <FooterStyle CssClass="footer" />
                                                    <Columns>
                                                        <asp:BoundField DataField="material" HeaderText="Material" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="referencia" HeaderText="Referencia" />
                                                        <asp:BoundField DataField="materialSim" HeaderText="Material Sim" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="min" HeaderText="MSISDN" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="activaEquipo" HeaderText="Activa Equipo" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="comseguro" HeaderText="Comseguro" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="precioEquipoConIva" HeaderText="Precio Equipo con Iva"
                                                            HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="precioEquipoSinIva" HeaderText="Precio equipo sin Iva"
                                                            HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="precioSimCardConIva" HeaderText="Precio SimCard con Iva"
                                                            HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="precioSimCardSinIva" HeaderText="Precio SimCard sin Iva"
                                                            HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="clausula" HeaderText="Clausula" HeaderStyle-HorizontalAlign="Center" />
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                        <!--Mostrar Novedades!-->
                        <td valign="top" style="width: 33%">
                            <asp:GridView ID="gvNovedad" runat="server" AutoGenerateColumns="false" CssClass="tablaGris"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                    <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                                    <asp:TemplateField HeaderText="Opc.">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("idNovedad") %>'
                                                ToolTip="Eliminar" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el registro?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlServicioTecnico" runat="server" Visible="false">
                <table width="95%">
                    <tr>
                        <td style="width: 40%" valign="top">
                            <table class="tablaGris" cellpadding="1" style="width: 100%;">
                                <tr>
                                    <th colspan="2">Equipos para Reparación
                                    </th>
                                </tr>
                                <tr>
                                    <td class="alterColor">IMEI:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtImei" runat="server" MaxLength="15" onkeypress="javascript:return ValidaNumero(event);"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvtxtImei" runat="server" ValidationGroup="vgEquipo"
                                            ControlToValidate="txtImei" ErrorMessage="El IMEI es requerido." />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="alterColor">¿Requiere préstamo?
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="cbRequierePrestamo" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="alterColor">MSISDN:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMsisdnST" runat="server" MaxLength="10" onkeypress="javascript:return ValidaNumero(event);"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvtxtMsisdnST" runat="server" ValidationGroup="vgEquipo"
                                            ControlToValidate="txtMsisdnST" ErrorMessage="El MSISDN es requerido." />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <br />
                                        <div style="display: inline">
                                            <asp:LinkButton ID="lbAgregarEquipo" runat="server" CssClass="search" Font-Bold="True"
                                                ValidationGroup="vgEquipo" CausesValidation="true"> 
                                                <img alt="Agregar Equipo" src="../images/add.png" />&nbsp;Agregar </asp:LinkButton>
                                        </div>
                                        <asp:Panel ID="pnlBotonEdicionEquipo" runat="server" Style="display: inline;">
                                            <asp:LinkButton ID="lbActualizarEquipo" runat="server" CssClass="search" Font-Bold="True"
                                                ValidationGroup="vgEquipo" CausesValidation="true"> 
                                            <img alt="Actualizar Equipo" src="../images/save_all.png" />&nbsp;Actualizar </asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbCancelarActEquipo" runat="server" CssClass="search" Font-Bold="True"
                                            CausesValidation="true"> 
                                            <img alt="Cancelar Actualizaci&oacute;n" src="../images/cancelar.png" />&nbsp;Cancelar </asp:LinkButton>
                                        </asp:Panel>
                                        <br />
                                        <asp:HiddenField ID="hfEquipoAct" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <br />
                                        <asp:GridView ID="gvEquipos" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                            EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                            Width="90%">
                                            <AlternatingRowStyle CssClass="alterColor" />
                                            <FooterStyle CssClass="footer" />
                                            <Columns>
                                                <asp:BoundField DataField="imei" HeaderText="IMEI" />
                                                <asp:CheckBoxField DataField="prestamo" HeaderText="Requiere Préstamo" />
                                                <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                                <asp:TemplateField HeaderText="Opciones">
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("imei") %>'
                                                            ToolTip="Eliminar" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el registro?');" />&nbsp;&nbsp;
                                                    <asp:ImageButton ID="ibEditar" runat="server" CommandName="editar" CommandArgument='<%# Bind("imei") %>'
                                                        ToolTip="Editar" ImageUrl="~/images/Edit-32.png" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top">
                            <asp:Panel ID="pnlInventarioEquiposPrestamo" runat="server" Visible="false">
                                <table class="tablaGris" cellpadding="1" style="width: 100%;">
                                    <tr>
                                        <th colspan="2">Equipos disponibles para préstamo
                                        </th>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Referencia de préstamo:
                                        </td>
                                        <td>
                                            <div style="display: inline">
                                                <eo:CallbackPanel ID="cpFiltroMaterialPrestamo" runat="server" UpdateMode="Self"
                                                    ClientSideAfterUpdate="CallbackAfterUpdateHandler" Style="display: inline !important; padding: 0px 0px 0px 0px; vertical-align: middle"
                                                    Width="100%">
                                                    <asp:TextBox ID="txtFiltroMaterialPrestamo" runat="server" CssClass="textbox" MaxLength="50"
                                                        onkeyup="FiltrarEOPanel(this.id, 2, 'filtrarMaterialPrestamo');" Width="100px"
                                                        Style="display: inline;"></asp:TextBox>&nbsp;-&nbsp;
                                                <asp:DropDownList ID="ddlMaterialPrestamo" runat="server" Style="display: inline;">
                                                </asp:DropDownList>
                                                    <div style="display: inline">
                                                        <asp:Label ID="lblMaterialesPrestamo" runat="server" CssClass="comentario"></asp:Label>
                                                        <asp:HiddenField ID="hfMaterialPrestamo" runat="server" />
                                                    </div>
                                                </eo:CallbackPanel>
                                                <div style="display: block">
                                                    <asp:RequiredFieldValidator ID="rfvMaterialPrestamo" runat="server" ErrorMessage="La referencia solicitada es requerida"
                                                        ControlToValidate="ddlMaterialPrestamo" Display="Dynamic" InitialValue="0" ValidationGroup="vgReferenciaPrestamo"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hfFlagFiltroMaterialPrestamo" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">Cantidad:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtCantidadPrestamo" runat="server" Width="50px" onkeypress="javascript:return ValidaNumero(event);"
                                                MaxLength="3" />
                                            <asp:RequiredFieldValidator ID="rfvCantidadPrestamo" runat="server" ErrorMessage="La cantidad es requerida"
                                                ControlToValidate="txtCantidadPrestamo" Display="Dynamic" ValidationGroup="vgReferenciaPrestamo" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:LinkButton ID="lbAdicionarEquipoPrestamo" runat="server" CausesValidation="true"
                                                CssClass="search" Font-Bold="true" OnClientClick="return ValidarAdicionEquipoPrestamo();"
                                                ValidationGroup="vgReferenciaPrestamo">
                                        <img alt="Adicionar quipo préstamo" src="../images/add.png" />
                                        &nbsp;Agregar
                                            </asp:LinkButton>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <br />
                                            <asp:GridView ID="gvEquiposPrestamo" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                                EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                                DataKeyNames="material">
                                                <AlternatingRowStyle CssClass="alterColor" />
                                                <FooterStyle CssClass="footer" />
                                                <Columns>
                                                    <asp:BoundField DataField="idBloqueo" HeaderText="Reserva" />
                                                    <asp:BoundField DataField="material" HeaderText="Material" />
                                                    <asp:BoundField DataField="subproducto" HeaderText="Detalle Material Préstamo" />
                                                    <asp:BoundField DataField="cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                                    <asp:TemplateField HeaderText="Opciones">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("idBloqueoDetalleProducto") %>'
                                                                ToolTip="Eliminar" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el registro?');" />&nbsp;&nbsp;
                                                        <%--<asp:ImageButton ID="ibEditar" runat="server" CommandName="editar" CommandArgument='<%# Bind("idBloqueoDetalleProducto") %>'
                                                            ToolTip="Editar" ImageUrl="~/images/Edit-32.png" />--%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br />
                                            <asp:GridView ID="gvInventarioPrestamo" runat="server" AutoGenerateColumns="False"
                                                CssClass="grid" EmptyDataText="" Width="90%" DataKeyNames="material">
                                                <AlternatingRowStyle CssClass="alterColor" />
                                                <FooterStyle CssClass="footer" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="cbSeleccion" runat="server" onclick="activarCantidad($(this))" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="material" HeaderText="Material" />
                                                    <asp:BoundField DataField="referencia" HeaderText="Descripción" />
                                                    <asp:TemplateField HeaderText="Cant. Disponible">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtCantDisponible" runat="server" Text='<%#Bind("cantidad")%>' Enabled="false"
                                                                Width="30px" Style="text-align: center" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Cant. Requerida">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtCantRequerida" runat="server" MaxLength="2" Enabled="false" Text="0"
                                                                Width="30px" Style="text-align: center" onkeypress="javascript:return ValidaNumero(event);"
                                                                onkeyup="javascript:return ValidaSeleccionInventario($(this))" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
                <eo:Dialog runat="server" ID="dlgRecuperarReserva" ControlSkinID="None" Height="350px"
                    HeaderHtml="Reservas de Inventario no confirmadas" CloseButtonUrl="00020312"
                    BackColor="White" CancelButton="lbCerrarPopUp" BackShadeColor="Gray" BackShadeOpacity="50">
                    <ContentTemplate>
                        <table align="center" class="tabla">
                            <tr>
                                <td align="center">
                                    <div>
                                        <blockquote>
                                            Se encontraron la siguientes reservas sin confirmar, las cuales se pueden utilizar
                                        para el servicio actual.
                                        </blockquote>
                                    </div>
                                    <asp:GridView ID="gvReservasNoConfirmadas" runat="server" AutoGenerateColumns="False"
                                        CssClass="grid" EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>"
                                        OnRowCommand="gvReservasNoConfirmadas_RowCommand" OnRowDataBound="gvReservasNoConfirmadas_RowDataBound">
                                        <AlternatingRowStyle CssClass="alterColor" />
                                        <FooterStyle CssClass="footer" />
                                        <Columns>
                                            <asp:BoundField DataField="idBloqueo" HeaderText="Reserva" />
                                            <asp:BoundField DataField="fechaRegistro" HeaderText="Fecha" />
                                            <asp:TemplateField HeaderText="Opciones">
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="ibUtilizar" runat="server" CommandName="utilizar" CommandArgument='<%# Bind("idBloqueo") %>'
                                                        ToolTip="Utilizar esta reserva" ImageUrl="~/images/add.png" OnClientClick="return confirm('¿Realmente desea utilizar esta reserva?');" />&nbsp;&nbsp;
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                    <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                    <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                    <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                        TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                        TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
                </eo:Dialog>
            </asp:Panel>
        </eo:CallbackPanel>
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
