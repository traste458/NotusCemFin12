<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarCambioServicio.aspx.vb"
    Inherits="BPColSysOP.RegistrarCambioServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx" TagName="EncabezadoSM"
    TagPrefix="esm" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Registrar Cambio de Servicio</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
       

    <style type="text/css">
        .style1
        {
            font-family: "Segoe UI", Arial, sans-serif;
            font-size: 9pt;
            border-color: Gray;
            width: 587px;
        }
    </style>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        //        $(document).ready(function() {
        //        $(".tipoLectura input").click(ValidarTipoLectura($(this).val()));
        ////        $(".tipoLectura input").each(function(key,value) {
        ////                $(this).change(ValidarTipoLectura($(this).val()));
        ////            });
        //        });
        String.prototype.trim = function () { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, "") }

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                var tgId = callback.getEventTarget();
                if (tgId == "btnRegistrar") {
                    var txt = document.getElementById("txtSerial");
                    if (txt) {
                        if (!txt.disabled) { txt.select(); }
                    }
                }
            } catch (e) {
                alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }
        }

        function ValidarEspecificacionSerial(source, args) {
            var imei = document.getElementById("txtImei").value.trim();
            var iccid = document.getElementById("txtIccid").value.trim();
            if (imei.length == 0 && iccid.length == 0) {
                args.IsValid = false;
            } else {
                args.IsValid = true;
            }
        }

        function ProcesarEnter(ctrl) {
            var kCode = (event.keyCode ? event.keyCode : event.which);
            if (kCode.toString() == "13") {
                DetenerEvento(event)
                switch (ctrl.id) {
                    case "txtIccid":
                        document.getElementById("txtMsisdn").select();
                        break;
                    case "txtImei":
                        document.getElementById("txtMsisdn").select();
                        break;
                    case "txtMsisdn":
                        document.getElementById("txtNumCambio").select();
                        __doPostBack('miPostBack', document.getElementById("txtMsisdn").value);
                        break;
                    case "txtNumCambio":
                        var btn = document.getElementById("btnRegistrar");
                        btn.click();
                }
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

        function ValidarTipoLectura(valor) {
            var txtIccid = document.getElementById("txtIccid");
            var txtImei = document.getElementById("txtImei");
            var rblTipoSim = document.getElementById("rblTipoSim");

            if (valor == "1") {
                txtIccid.disabled = false;
                txtImei.disabled = true;
                rblTipoSim.style.display = "block";
                txtIccid.focus();
            }
            else {
                txtImei.disabled = false;
                txtIccid.disabled = true;
                rblTipoSim.style.display = "none";
                txtImei.focus();
            }
            txtImei.value = "";
            txtIccid.value = "";
        }

        function ValidarSeleccionTipoSim(source, args) {
            var rbl = document.getElementById('<%=rblTipoSim.ClientID%>');
            if (rbl.style.display != 'none') {
                try {
                    var arrRadio = document.getElementsByName('<%=rblTipoSim.ClientID%>');
                    var haySeleccion = false;
                    for (var i = 0; i < arrRadio.length; i++) {
                        if (arrRadio[i].checked == true) {
                            haySeleccion = true;
                            break;
                        }
                    }
                    args.IsValid = haySeleccion;
                } catch (e) {
                    alert("Error al tratar de validar selección de tipo de Sim.\n" + e.description);
                    args.IsValid = false;
                }
            } else {
                args.IsValid = true;
            }
        }

        function abrirArchivoEjemplo() {
            var newWindow = window.open("../images/CambioServicio.PNG", "EjemploArchivo", "toolbar=0,location=0,menubar=0,scrollbars=0,resizable=1,status=0,titlebar=0,width=770,height=220,left=300,top=200");
            try {
                newWindow.document.title = "Archivo de Ejemplo";
            } catch (e) { }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function ControlErrorUpload(control, error, message) {
            alert('Extensión o peso del archivo no permitida');
        }

        function ControlCargueUpload() {
            var archivosEO = $("#dlgArchivo_ctl00_fuArchivoAdjuntarEO_postedFiles");
            if (archivosEO.html().length == 0) {
                $('#dlgArchivo_ctl00_btnRegistrarArchivo').attr('disabled', 'disabled');
            } else {
                $('#dlgArchivo_ctl00_btnRegistrarArchivo').removeAttr('disabled');
            }
        }

    </script>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
    </eo:CallbackPanel>
    <asp:Panel ID="pnlGeneral" runat="server">
        <asp:PlaceHolder ID="phEncabezado" runat="server"></asp:PlaceHolder>
        
        <table class="tabla" width="100%">
            <tr>
                <td class="field" width="15%">
                    Observación:
                </td>
                <td colspan="5" width="45%">
                    <asp:TextBox ID="txtObservacion" runat="server" Rows="3" TextMode="MultiLine" Width="95%"></asp:TextBox>
                </td>
                <td class="field" width="15%">
                    Número de Contrato:
                </td>
                <td width="25%" valign="middle">
                    <asp:TextBox ID="txtNumeroContrato" runat="server" onkeypress="javascript:return ValidaNumero(event);" 
                        MaxLength="20" Enabled="false" />
                    <asp:RequiredFieldValidator ID="rfvtxtNumeroContrato" runat="server" ControlToValidate="txtNumeroContrato"
                        ErrorMessage="El número de contrato requerido." 
                        ValidationGroup="finalizar" Enabled="false" />
                </td>
            </tr>
        </table>

        <table class="tabla">
            <tr>
                <td colspan="6">
                    <br />
                    <eo:CallbackPanel ID="cpFinalizar" runat="server" UpdateMode="Always" Width="100%"
                        LoadingDialogID="ldrWait_dlgWait">
                        <asp:LinkButton ID="lbCerrar" runat="server" CssClass="search" Enabled="False" ValidationGroup="finalizar">
                        <img src="../images/save_all.png" alt="" />&nbsp;Finalizar Cambio Servicio</asp:LinkButton>
                        <asp:LinkButton ID="lbMostrarFormNovedad" runat="server" CssClass="search" Font-Bold="True"
                            CausesValidation="false"> <img alt="Adicionar Novedad" src="../images/notepad.gif" />&nbsp;Adicionar Novedad </asp:LinkButton>
                         &nbsp;
                         <asp:LinkButton ID="lbVerNovedad" runat="server" CssClass="search" Font-Bold="True"
                            CausesValidation="false"> <img alt="Ver Novedades" src="../images/view.png" />&nbsp;Ver Novedades </asp:LinkButton>
                         &nbsp;
                        <asp:LinkButton ID="lbCargueArchivo" runat="server" CssClass="search" Font-Bold="True"
                            CausesValidation="false"> <img alt="Cargar Archivo de Detalle" src="../images/Excel.gif" />&nbsp;Cargar Archivo </asp:LinkButton>

                        <eo:Dialog runat="server" ID="dlgSerial" ControlSkinID="None" Height="350px" HeaderHtml="Detalle de Seriales"
                            CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                            <ContentTemplate>
                                <table align="center" class="tabla">
                                    <tr>
                                        <td>
                                            <asp:GridView ID="gvSeriales" runat="server" Width="100%" AutoGenerateColumns="false"
                                                ShowFooter="true" EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                                <Columns>
                                                    <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                                    <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia" />
                                                    <asp:BoundField DataField="Serial" HeaderText="Serial" />
                                                    <asp:BoundField DataField="Msisdn" HeaderText="MSISDN" />
                                                    <asp:BoundField DataField="Factura" HeaderText="Factura" />
                                                    <asp:BoundField DataField="Remision" HeaderText="Remisión" />
                                                </Columns>
                                                <FooterStyle CssClass="field" />
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                            <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                            </FooterStyleActive>
                            <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                            </HeaderStyleActive>
                            <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                            </ContentStyleActive>
                            <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                                TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                                TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                            </BorderImages>
                        </eo:Dialog>
                        <br />
                        <eo:Dialog ID="dlgAdicionarMIN" runat="server" ControlSkinID="None" Height="10px"
                            HeaderHtml="Adición de MSISDNs" CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray"
                            BackShadeOpacity="50" AcceptButtonPostBack="True">
                            <ContentTemplate>
                                <table align="left" style="width:200px; margin: 5px" cellspacing="2" cellpadding="2">
                                    <tr>
                                        <td class="alterColor">
                                            Msisdn:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtMsisdnNuevo" runat="server" Width="100px" ValidationGroup="vgMIN" MaxLength="10"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvtxtMsisdn" runat="server" ControlToValidate="txtMsisdnNuevo"
                                                    Display="Dynamic" ErrorMessage="El MSISDN es requerido" ValidationGroup="vgMIN" />
                                                <asp:RegularExpressionValidator ID="revtxtMsisdn" runat="server" Display="Dynamic"
                                                    ControlToValidate="txtMsisdnNuevo" ValidationGroup="vgMIN" ErrorMessage="El MSISDN debe ser numérico"
                                                    ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <%--<tr>
                                        <td class="alterColor">
                                            Número Reserva:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNumeroReserva" runat="server" Width="100px" MaxLength="100"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">
                                            Activa equipo anterior:
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="chbActivaEquipoAnterior" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">
                                            Comseguro:
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="chbComSeguro" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="alterColor">
                                            Precio sin IVA:
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
                                        <td class="alterColor">
                                            Precio con IVA:
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
                                        <td class="alterColor">
                                            Lista 28:
                                        </td>
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
                                    </tr>--%>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <div style="display: inline;">
                                                <asp:LinkButton ID="lbAgregarMIN" runat="server" CssClass="search" Font-Bold="True"
                                                    CausesValidation="true" ValidationGroup="vgMIN"> 
                                                <img alt="Agregar MIN" src="../images/add.png" />&nbsp;Agregar </asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                            <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                            </FooterStyleActive>
                            <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                            </HeaderStyleActive>
                            <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                            </ContentStyleActive>
                        </eo:Dialog>
                    </eo:CallbackPanel>
                </td>
            </tr>
        </table>
        <br />
        <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
            GroupName="Lectura">
            <table class="tabla" style="width: 95%">
                <tr>
                    <td style="width: 45%" valign="top">
                        <asp:Panel ID="pnlLectura" runat="server">
                            <table>
                                <tr>
                                    <th colspan="4">
                                        LECTURA DE SERIALES
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Tipo de Lectura
                                    </td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rblTipoLectura" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="1" Text="Msisdn - Iccid"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Msisdn - Imei"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvTipoLectura" runat="server" ErrorMessage="Seleccione un tipo de lectura"
                                                Display="Dynamic" ControlToValidate="rblTipoLectura" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Iccid:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtIccid" runat="server" onkeydown="ProcesarEnter(this);" Width="200px"
                                            MaxLength="17"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RegularExpressionValidator ID="revIccid" runat="server" ErrorMessage="El Iccid digitado no es válido"
                                                Display="Dynamic" ControlToValidate="txtIccid" ValidationGroup="lecturaSerial"
                                                ValidationExpression="[0-9]{17}"></asp:RegularExpressionValidator>
                                        </div>
                                    </td>
                                    <td class="field">
                                        Factura:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFacturaLectura" runat="server" onkeydown="ProcesarEnter(this);"
                                            Width="200px"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvFactura" runat="server" ErrorMessage="El valor del campo Factura es requerido"
                                                Display="Dynamic" ControlToValidate="txtFacturaLectura" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Imei:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtImei" runat="server" onkeydown="ProcesarEnter(this);" Width="200px"
                                            MaxLength="30"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RegularExpressionValidator ID="revImei" runat="server" ErrorMessage="El imei digitado no es válido"
                                                Display="Dynamic" ControlToValidate="txtImei" ValidationGroup="lecturaSerial"
                                                ValidationExpression="[0-9]{15}"></asp:RegularExpressionValidator>
                                        </div>
                                    </td>
                                    <td class="field">
                                        Remisión:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtRemsioLectura" runat="server" onkeydown="ProcesarEnter(this);"
                                            Width="200px"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvRemision" runat="server" ErrorMessage="El valor del campo Remisión es requerido"
                                                Display="Dynamic" ControlToValidate="txtRemsioLectura" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Msisdn:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMsisdn" runat="server" onkeydown="ProcesarEnter(this);" Width="200px"
                                            MaxLength="10"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvMsisdn" runat="server" ErrorMessage="El valor del campo Msisdn es requerido"
                                                Display="Dynamic" ControlToValidate="txtMsisdn" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="revSerial" runat="server" ErrorMessage="El Msisdn digitado no es válido"
                                                Display="Dynamic" ControlToValidate="txtMsisdn" ValidationGroup="lecturaSerial"
                                                ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                                            <asp:CustomValidator ID="CustomValidatorMsisdn" runat="server" Display="Dynamic" ControlToValidate="txtMsisdn" ErrorMessage="El Msisdn registrado no se encuentra asociado al servicio" ValidationGroup="lecturaSerial"></asp:CustomValidator>
                                        </div>
                                    </td>
                                    <td class="field">
                                        Estado Novedad
                                    </td>
                                    <td>
                                        <asp:RadioButtonList ID="rblNovedadLectura" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                            <asp:ListItem Value="0" Selected="True" Text="No"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td  class="field" colspan="2">
                                        Numero De Cambio de Servicio:
                                    </td>
                                    <td colspan="2">
                                        <asp:TextBox ID="txtNumCambio" runat="server" onkeydown="ProcesarEnter(this);" Width="200px"
                                            MaxLength="10" ></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvNumCambio" runat="server" ErrorMessage="El valor del campo Numero de Cambio de Servicio es requerido"
                                                Display="Dynamic" ControlToValidate="txtNumCambio" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="revNumCambio" runat="server" ErrorMessage="El numero de cambio de servicio digitado no es válido"
                                                Display="Dynamic" ControlToValidate="txtNumCambio" ValidationGroup="lecturaSerial"
                                                ValidationExpression="[0-9]{0,10}"></asp:RegularExpressionValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" align="center" valign="middle">
                                        &nbsp;
                                        <asp:RadioButtonList ID="rblTipoSim" runat="server" RepeatDirection="Horizontal"
                                            ToolTip="Seleccione un tipo de SIM" Style="display: none">
                                            <asp:ListItem Value="1">Sim Normal</asp:ListItem>
                                            <asp:ListItem Value="2">Sim Backup</asp:ListItem>
                                            <asp:ListItem Value="3">Sim Suelta</asp:ListItem>
                                            <asp:ListItem Value="4">Micro Sim</asp:ListItem>
                                            <asp:ListItem Value="5">Sim Manual</asp:ListItem>
                                        </asp:RadioButtonList>
                                        <div style="display: block">
                                            <asp:CustomValidator ID="cuTipoSim" runat="server" ErrorMessage="Debe seleccionar un tipo de Sim"
                                                ValidationGroup="lecturaSerial" ControlToValidate="rblTipoSim" ClientValidationFunction="ValidarSeleccionTipoSim"
                                                Display="Dynamic" ValidateEmptyText="true"></asp:CustomValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="display: block;">
                                            <asp:CustomValidator ID="cusSeriales" runat="server" ErrorMessage="Se requiere que por lo menos sea proporcionado el valor de uno de los campos Imei y/o Iccid"
                                                ValidationGroup="lecturaSerial" ControlToValidate="txtImei" ClientValidationFunction="ValidarEspecificacionSerial"
                                                Display="Dynamic"></asp:CustomValidator>
                                        </div>
                                        <br />
                                        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="search" ValidationGroup="lecturaSerial" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:GridView ID="gvDatosCargados" runat="server" Width="100%" AutoGenerateColumns="false"
                                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han cargado ningun archivo&lt;/i&gt;&lt;/blockquote&gt;">
                                            <Columns>
                                                <asp:BoundField DataField="min" HeaderText="Min" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="serial" HeaderText="serial" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"/>
                                                <asp:BoundField DataField="remision" HeaderText="Remision" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="factura" HeaderText="Factura" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"/>
                                            </Columns>
                                        </asp:GridView>   
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                    <td style="width: 10%">
                        &nbsp;
                    </td>
                    <td style="width: 45%" valign="top">
                        <div style="display: block; padding-bottom: 3px;">
                            <asp:LinkButton ID="lbVerSeriales" runat="server" CssClass="search"><img src="../images/view.png" alt=""/>&nbsp;Ver Seriales</asp:LinkButton>
                        </div>
                        <asp:GridView ID="gvListaReferencias" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen referencias asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia Solicitada" />
                                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="CantidadLeida" HeaderText="Cantidad Le&iacute;da" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="CantidadCambio" HeaderText="Cantidad Cambio" ItemStyle-HorizontalAlign="Center" />
                            </Columns>
                        </asp:GridView>
                        <br />
                        <div style="display: block; padding-bottom: 3px;">
                            <asp:LinkButton ID="lbAdicionarMin" runat="server" CssClass="search">
                                <img src="../images/flecha_fwd.png" alt=""/>&nbsp;Adicionar MSISDNs
                            </asp:LinkButton>
                        </div>
                        <asp:GridView ID="gvListaMsisdn" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen MSISDNs asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                <asp:BoundField DataField="activaEquipoAnteriorTexto" HeaderText="Activar Equipo Anterior (S/N)"
                                    ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="comseguroTexto" HeaderText="Comseguro (S/N)" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="precioConIva" HeaderText="Precio Con Iva" DataFormatString="{0:c}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="precioSinIva" HeaderText="Precio Sin Iva" DataFormatString="{0:c}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="clausula" HeaderText="Clausula" />
                                <asp:TemplateField HeaderText="Disponibilidad">
                                    <ItemTemplate>
                                        <asp:Image ID="imgBloquear" ImageUrl="~/images/BallGreen.gif" runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            </eo:CallbackPanel>
        <br />
            <eo:Dialog runat="server" ID="dlgNovedad" ControlSkinID="None" Height="350px" HeaderHtml="Adici&oacute;n de Novedades"
                CloseButtonUrl="00020312" BackColor="White" CancelButton="lbCerrarPopUp" BackShadeColor="Gray"
                BackShadeOpacity="50">
                <ContentTemplate>
                    <table align="center" class="tabla">
                        <tr>
                            <th colspan="2">
                                INFORMACI&Oacute;N DE LA NOVEDAD
                            </th>
                        </tr>
                        <tr>
                            <td class="field">
                                Seleccione tipo de Novedad:
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
                            <td class="field">
                                Comentario General:
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
                                <asp:LinkButton ID="lbRegistrarNovedad" runat="server" ValidationGroup="registroNovedad"
                                    CssClass="submit"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="submit"><img src="../images/close.gif" alt="" />&nbsp;Cancelar</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                </BorderImages>
            </eo:Dialog>
    </asp:Panel>
    <br />
    <eo:Dialog runat="server" ID="dlgNovedades" ControlSkinID="None" Height="10px" HeaderHtml="Novedades Registradas"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray"
                BackShadeOpacity="50" AcceptButtonPostBack="True">
                <ContentTemplate>
                    <table align="center" class="style1">
                        <tr>
                            <td>
                                <asp:GridView ID="gvNovedad" runat="server" Width="90%" AutoGenerateColumns="false"
                                    EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                    <Columns>
                                        <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                        <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                        <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}" />
                                        <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                                    </Columns>
                                    <AlternatingRowStyle CssClass="alterColor" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>    
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </ContentStyleActive>
            </eo:Dialog>
    <br />
    <eo:Dialog runat="server" ID="dlgArchivo" ControlSkinID="None" Height="10px" HeaderHtml="Adici&oacute;n por archivo"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray"
                BackShadeOpacity="50" AcceptButtonPostBack="True">
                <ContentTemplate>
                    <table align="left" class="style1">
                        <tr>
                            <th colspan="2">
                                INFORMACI&Oacute;N DEL ARCHIVO
                            </th>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:Label ID="lblConfirmacion" runat="server" Text="Registros Almacenados Exitosamente" ForeColor="Blue" Font-Bold="true" Visible="false" ></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="field" style="width:250px" >
                                    Archivo a Cargar:
                            </td>
                            <td align="left" style="background-color:#E8E8E8">
                                <span class="field">
                                    <eo:AJAXUploader ID="fuArchivoAdjuntarEO" runat="server" TempFileLocation="c:\windows\temp"
                                        MaxFileCount="1" AutoUpload="true" MaxDataSize="10240" AllowedExtension=".xls|.xlsx" 
                                        ClientSideOnChange="ControlCargueUpload" ClientSideOnError="ControlErrorUpload" 
                                        BrowseButtonText="Buscar..." DeleteButtonText="Eliminar Archivos">
                                        <TextBoxStyle CssText="width: 300px" />
                                        <LayoutTemplate>
                                            <table border="0" cellpadding="2" cellspacing="0" style="width:100%">
                                                <tr>
                                                    <td>
                                                        <asp:PlaceHolder ID="InputPlaceHolder" runat="server">Input Box Place Holder </asp:PlaceHolder>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:PlaceHolder ID="PostedFilesPlaceHolder" runat="server">Posted Files Place Holder</asp:PlaceHolder>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="center">
                                                        <asp:Button ID="DeleteButton" runat="server" CssClass="search" Text="Eliminar archivos seleccionados" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </LayoutTemplate>
                                    </eo:AJAXUploader>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <br />
                                <asp:Button ID="btnRegistrarArchivo" runat="server" ValidationGroup="vgCarga" Enabled="false" Text="Registra" />&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Button ID="btnCancelarArchivo" runat="server" ValidationGroup="vgCarga" Enabled="true" Text="Cancelar" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:HyperLink id="hlVerEjemplo" onclick="abrirArchivoEjemplo();" runat="server" Font-Bold="True"
                                        ForeColor="Blue" NavigateUrl="javascript:void(0);">Ver Archivo Ejemplo</asp:HyperLink>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <br />
                                <div id="divArchivo" runat="server" style="overflow:auto; width:568px; height:0px"
                                    align="center">
                                    <asp:GridView ID="gvErrores" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                        EmptyDataText="<blockquote><b><i>No hay registros para mostrar</i></b></blockquote>" 
                                        Width="99%" Height="0px">
                                        <AlternatingRowStyle CssClass="alterColor" />
                                        <FooterStyle CssClass="footer" />
                                        <Columns>
                                            <asp:BoundField DataField="id" HeaderText="id" HeaderStyle-HorizontalAlign="Center"  />
                                            <asp:BoundField DataField="nombre" HeaderText="Nombre" HeaderStyle-HorizontalAlign="Center"  />
                                            <asp:BoundField DataField="descripcion" HeaderText="Descripcion" HeaderStyle-HorizontalAlign="Center" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                     </table>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </ContentStyleActive>
            </eo:Dialog>
    <uc2:Loader ID="ldrWait" runat="server" />
    <script language="javascript" type="text/javascript">
        function CambiarEnfoque() {
            var ctrl = document.getElementById("txtSerial");
            if (ctrl != null) {
                if (!ctrl.disabled) { ctrl.select(); }
            }
        }
        window.setTimeout("CambiarEnfoque()", 10)
    </script>
    </form>
</body>
</html>
