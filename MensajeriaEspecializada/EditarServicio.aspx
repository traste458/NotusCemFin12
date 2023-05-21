<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarServicio.aspx.vb"
    Inherits="BPColSysOP.EditarServicio" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar servicio</title>
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

        function ObtenerIdFlagCallBackPanelFilter(idFlag) {

            switch (idFlag) {
                case 1:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMaterial.ClientID %>');
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMaterial.ClientID %>');
                    break;
                case 2:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMaterial.ClientID %>')
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMaterial.ClientID %>');
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

        function ConfirmarRegistro() {
            try {
                Page_ClientValidate('vgServicio');
                if (Page_IsValid) {
                    var mensaje = "";
                    var numReferencias = parseInt(document.getElementById("hfNumReferencias").value);
                    var numMsisdns = parseInt(document.getElementById("hfNumMsisdn").value);
                    if (numReferencias == 0 && numMsisdns == 0) {
                        mensaje = "No se han proporcionado Referencias ni MSISDNs. ¿Realmente desea continuar?";
                    } else {
                        if (numReferencias == 0) { mensaje = "No se han proporcionado Referencias. ¿Realmente desea continuar?"; }
                        if (numMsisdns == 0) { mensaje = "No se han proporcionado MSISDNs.. ¿Realmente desea continuar?"; }
                    }
                    if (mensaje != "") {
                        return confirm(mensaje);
                    } else {
                        return true;
                    }
                }
                return Page_IsValid;
            } catch (e) {
                alert("Error al tratar de confirmar registro.\n" + e.description);
            }
        }

        function ConfirmarEliminacionRegistro(idValidator) {
            try {
                var mensaje = "";
                var numReferencias = parseInt(document.getElementById("hfNumReferencias").value);
                var numMsisdns = parseInt(document.getElementById("hfNumMsisdn").value);

                switch (idValidator) {
                    case 'vgReferencia':
                        if (numReferencias == 0) { mensaje = "No se han proporcionado Referencias. ¿Realmente desea continuar?"; }
                        else if (numReferencias == 1) { mensaje = "El servicio quedará sin Referencias asociadas. ¿Realmente desea continuar?"; }
                        else if (numReferencias > 1) { mensaje = "¿Está seguro de eliminar esta referencia?"; }

                        break;
                    case 'vgMIN':
                        if (numMsisdns == 0) { mensaje = "No se han proporcionado MSISDNs. ¿Realmente desea continuar?"; }
                        else if (numMsisdns == 1) { mensaje = "El servicio quedará sin MSISDNs asociadas. ¿Realmente desea continuar?"; }
                        else if (numMsisdns > 1) { mensaje = "¿Está seguro de eliminar este MSISDN?"; }
                        break;
                }

                if (mensaje != "") {
                    return confirm(mensaje);
                } else {
                    return true;
                }
            } catch (e) {
                alert("Error al validar registro.\n" + e.description);
                return false;
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
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
                alert("Error al tratar de validar teléfono.\n" + Error.description);
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
                alert(e);
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
        function abrirArchivoEjemplo() {
            var newWindow = window.open("../images/CreacionServicio.png", "EjemploArchivo", "toolbar=0,location=0,menubar=0,scrollbars=1;resizable=1,status=0;titlebar=0");
            try {
                newWindow.document.title = "Archivo de Ejemplo";
            } catch (e) { }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="CallbackPanelServicio" runat="server" UpdateMode="Always" Width=" 98%">
        <asp:UpdatePanel ID="upEncabezado" runat="server">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:HiddenField ID="hfNumReferencias" runat="server" Value="0" />
        <asp:HiddenField ID="hfNumMsisdn" runat="server" Value="0" />
        <asp:HiddenField ID="hfDetalleArchivo" runat="server" Value="0" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="pnlGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait"
        ChildrenAsTriggers="true" Width="100%">
        <asp:Panel ID="pnlInfoGeneral" runat="server">
            <table class="tablaGris" cellpadding="1">
                <tr>
                    <th colspan="4">
                        Información del Servicio de Mensajería
                    </th>
                </tr>
                <tr>
                    <td class="alterColor">
                        Tipo Servicio:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoServicio" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="alterColor">
                        N&uacute;mero de Radicado:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNoRadicado" runat="server" Width="100px" MaxLength="10" Enabled="False"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvtxtNoRadicado" runat="server" ControlToValidate="txtNoRadicado"
                                Display="Dynamic" ErrorMessage="El número de Radicado es obligatorio" ValidationGroup="vgServicio" />
                            <asp:RegularExpressionValidator ID="revtxtNoRadicado" runat="server" Display="Dynamic"
                                ControlToValidate="txtNoRadicado" ValidationGroup="vgServicio" ErrorMessage="El radicado debe ser numérico"
                                ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Prioridad:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlPrioridad" runat="server">
                        </asp:DropDownList>
                        <div style="display: block;">
                            <asp:RequiredFieldValidator ID="rfvPrioridad" runat="server" ErrorMessage="Valor de campo prioridad requerido"
                                Display="Dynamic" ControlToValidate="ddlPrioridad" InitialValue="0" ValidationGroup="vgServicio"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                    <td class="alterColor">
                        Fecha Vencimiento Reserva:
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
                            &lt;/style&gt;" DayCellHeight="15" DayCellWidth="31" DayHeaderFormat="Short"
                            DisabledDates="" OtherMonthDayVisible="True" SelectedDates="" TitleFormat="MMMM, yyyy"
                            TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                            AllowMultiSelect="False">
                            <TodayStyle CssClass="DatePickerStyle5" />
                            <SelectedDayStyle CssClass="DatePickerStyle8" />
                            <DisabledDayStyle CssClass="DatePickerStyle6" />
                            <FooterTemplate>
                                <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                    <tr>
                                        <td width="30">
                                        </td>
                                        <td valign="center">
                                            <img src="{img:00040401}"></img>
                                        </td>
                                        <td valign="center">
                                            Today: {var:today:dd/MM/yyyy}
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
                    <td class="alterColor">
                        Usuario Ejecutor:
                    </td>
                    <td>
                        <asp:TextBox ID="txtUsuarioEjecutor" runat="server" Width="200px" MaxLength="50"
                            Enabled="False"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Nombres:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNombres" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Identificaci&oacute;n:
                    </td>
                    <td>
                        <asp:TextBox ID="txtIdentificacion" runat="server" Width="200px" MaxLength="50" Enabled="False"></asp:TextBox>
                        <div style="display: block">
                            <asp:RegularExpressionValidator ID="revIdentificacion" runat="server" Display="Dynamic"
                                ControlToValidate="txtIdentificacion" ValidationGroup="vgServicio" ErrorMessage="La identificación debe ser numérica"
                                ValidationExpression="[0-9]{1,10}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="alterColor">
                        Persona de Contacto (Autorizado):
                    </td>
                    <td>
                        <asp:TextBox ID="txtNombresAutorizado" runat="server" Width="300px" MaxLength="150"
                            Enabled="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Ciudad:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlCiudad" runat="server" Enabled="False">
                        </asp:DropDownList>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvCiudad" runat="server" ErrorMessage="La ciudad de entrega des requerida"
                                ControlToValidate="ddlCiudad" InitialValue="0" ValidationGroup="vgServicio" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                    <td class="alterColor">
                        Barrio:
                    </td>
                    <td>
                        <asp:TextBox ID="txtBarrio" runat="server" Width="300px" MaxLength="50" Enabled="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Dirección:
                    </td>
                    <td>
                        <asp:TextBox ID="txtDireccion" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Teléfono:
                    </td>
                    <td>
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
                    <td class="style1">
                        Fecha Asignaci&oacute;n
                    </td>
                    <td>
                        <eo:DatePicker ID="dpFechaAsignacion" runat="server" PickerFormat="dd/MM/yyyy" ControlSkinID="None"
                            CssBlock="&lt;style type=&quot;text/css&quot;&gt;
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
                                &lt;/style&gt;" DayCellHeight="15" DayCellWidth="31" DayHeaderFormat="Short"
                            DisabledDates="" OtherMonthDayVisible="True" SelectedDates="" TitleFormat="MMMM, yyyy"
                            TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                            VisibleDate="2011-05-01">
                            <TodayStyle CssClass="DatePickerStyle5" />
                            <SelectedDayStyle CssClass="DatePickerStyle8" />
                            <DisabledDayStyle CssClass="DatePickerStyle6" />
                            <FooterTemplate>
                                <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                    <tr>
                                        <td width="30">
                                        </td>
                                        <td valign="center">
                                            <img src="{img:00040401}"></img>
                                        </td>
                                        <td valign="center">
                                            Today: {var:today:dd/MM/yyyy}
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
                    </td>
                    <td class="alterColor">
                        Cliente VIP:
                    </td>
                    <td>
                        <asp:CheckBox ID="chbClienteVIP" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Plan actual:
                    </td>
                    <td>
                        <asp:TextBox ID="txtPlanActual" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Observaciones:
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
        </asp:Panel>
        <br />
        <div style="display: block; text-align: center">
            <asp:LinkButton ID="lbGuardar" runat="server" CssClass="search" Font-Bold="True"
                CausesValidation="true" ValidationGroup="vgServicio">
                     <img alt="Guardar Servicio" src="../images/save_all.png" />&nbsp;Guardar
            </asp:LinkButton>&nbsp;
            <asp:LinkButton ID="lbAnular" runat="server" CssClass="search" Font-Bold="True" OnClientClick="return confirm('¿Está seguro que desea Anular el servicio?');">
                <img alt="Anular Servicio" src="../images/close.png" /> &nbsp;Anular
            </asp:LinkButton>
            <br />
            <br />
        </div>
        <div style="width: 75%">
            <blockquote>
                Los cambios realizados sobre referencias y MSISDNs, serán confirmados inmediatamente
                en la base de datos. El botón &quot;Actualizar&quot; solo aplica para los cambios
                sobre la cabecera del servicio.<br />
            </blockquote>
        </div>
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
        <table>
            <tr>
                <%--Agregar Referencias--%>
                <td valign="top">
                    <asp:Panel ID="pnlInfoReferencia" runat="server">
                        <table class="tablaGris" cellpadding="1" style="width: 100%;">
                            <tr>
                                <th colspan="3">
                                    Agregar referencias
                                </th>
                            </tr>
                            <tr>
                                <td class="alterColor">
                                    Referencia:
                                </td>
                                <td>
                                    <div style="display: inline">
                                        <asp:TextBox ID="txtFiltroMaterial" runat="server" CssClass="textbox" MaxLength="50"
                                            onkeyup="FiltrarEOPanel(this.id, 1, 'filtrarMaterial');" Width="150px" Style="display: inline;"></asp:TextBox>&nbsp;-&nbsp;
                                        <br />
                                        <eo:CallbackPanel ID="cpFiltroMaterial" runat="server" UpdateMode="Group" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                                            Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle" GroupName="general">
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
                                <td class="alterColor">
                                    Cantidad:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCantidad" runat="server" Width="100px" ValidationGroup="vgReferencia"
                                        MaxLength="4"></asp:TextBox>
                                    <div style="display: block">
                                        <asp:RequiredFieldValidator ID="rfvtxtCantidad" runat="server" ControlToValidate="txtCantidad"
                                            Display="Dynamic" ErrorMessage="La Cantidad es requerida" ValidationGroup="vgReferencia" />
                                        <asp:RegularExpressionValidator ID="revtxtCantidad" runat="server" Display="Dynamic"
                                            ControlToValidate="txtCantidad" ValidationGroup="vgReferencia" ErrorMessage="La cantidad debe ser numérica."
                                            ValidationExpression="[0-9]{1,4}"></asp:RegularExpressionValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <br />
                                    <div style="display: inline">
                                        <asp:LinkButton ID="lbAgregarReferencia" runat="server" CssClass="search" Font-Bold="True"
                                            ValidationGroup="vgReferencia" CausesValidation="true">
                                            <img alt="Agregar referencia" src="../images/add.png" />&nbsp;Agregar
                                        </asp:LinkButton>
                                    </div>
                                    <asp:Panel ID="pnlBotonEdicionReferencia" runat="server" Style="display: inline;">
                                        <asp:LinkButton ID="lbActualizarRef" runat="server" CssClass="search" Font-Bold="True"
                                            ValidationGroup="vgReferencia" CausesValidation="true"> <img alt="Actualizar Referencia" src="../images/save_all.png" />&nbsp;Actualizar </asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbCancelarActRef" runat="server" CssClass="search" Font-Bold="True"
                                            CausesValidation="true"> <img alt="Cancelar Actualizaci&oacute;n" src="../images/cancelar.png" />&nbsp;Cancelar </asp:LinkButton>
                                    </asp:Panel>
                                    <br />
                                    <asp:HiddenField ID="hfMaterialAct" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td class="alterColor">
                                    Filtrar Referencia:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFiltroReferencia" runat="server" MaxLength="10"></asp:TextBox>&nbsp;
                                    <cc1:FilteredTextBoxExtender ID="ftbFiltroReferencia" runat="server" FilterType="Numbers,Custom"
                                        TargetControlID="txtFiltroReferencia">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:LinkButton ID="lbFiltraMaterial" runat="server" CausesValidation="true" CssClass="search"
                                        Font-Bold="True">
                                     <img alt="Filtrar" src="../images/filtro.png" />&nbsp;Filtrar
                                    </asp:LinkButton>&nbsp;
                                    <asp:LinkButton ID="lbQuitaFiltromaterial" runat="server" CausesValidation="true"
                                        CssClass="search" Font-Bold="True">
                                     <img alt="Filtrar" src="../images/unfunnel.png" />&nbsp;Quitar Filtro
                                    </asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:Label ID="lblfiltroMensajeMaterial" runat="server" Text="Referencia no existe" ForeColor="Red" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <asp:GridView ID="gvReferencias" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                        EmptyDataText="&lt;h3&gt;No hay registros para mostrar&lt;/h3&gt;" ShowFooter="true"
                                        Width="90%">
                                        <AlternatingRowStyle CssClass="alterColor" />
                                        <FooterStyle CssClass="footer" />
                                        <Columns>
                                            <asp:BoundField DataField="Material" HeaderText="material" />
                                            <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia" />
                                            <asp:BoundField DataField="cantidad" HeaderText="Cantidad" />
                                            <asp:TemplateField HeaderText="Opciones">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkEliminar" runat="server" CommandArgument='<%# Bind("material") %>'
                                                        CommandName="eliminar" OnClientClick="return ConfirmarEliminacionRegistro('vgReferencia');"
                                                        ToolTip="Eliminar"> 
                                                        <img alt="Eliminar" border="0" src="../images/Delete-32.png"></img>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="lnkEditar" runat="server" CommandArgument='<%# Bind("material") %>'
                                                        CommandName="editar" ToolTip="Editar"> 
                                                        <img alt="Editar" border="0" src="../images/Edit-32.png"></img>
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            </caption>
                        </table>
                    </asp:Panel>
                </td>
                <%--Agregar MINs--%>
                <td valign="top">
                    <asp:Panel ID="pnlInfoMin" runat="server">
                        <table class="tablaGris" cellpadding="1" style="width: 100%;">
                            <tr>
                                <th colspan="2">
                                    Agregar MINs
                                </th>
                            </tr>
                            <tr>
                                <td class="alterColor">
                                    Msisdn:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMsisdn" runat="server" Width="100px" ValidationGroup="vgMIN"
                                        MaxLength="10"></asp:TextBox>
                                    <div style="display: block">
                                        <asp:RequiredFieldValidator ID="rfvtxtMsisdn" runat="server" ControlToValidate="txtMsisdn"
                                            Display="Dynamic" ErrorMessage="El MSISDN es requerido" ValidationGroup="vgMIN" />
                                        <asp:RegularExpressionValidator ID="revtxtMsisdn" runat="server" Display="Dynamic"
                                            ControlToValidate="txtMsisdn" ValidationGroup="vgMIN" ErrorMessage="El MSISDN debe ser numérico"
                                            ValidationExpression="[0-9]{1,10}"></asp:RegularExpressionValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
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
                                    <div style="display: block;">
                                        <asp:RequiredFieldValidator ID="rfvddlClausula" runat="server" ErrorMessage="Valor de campo clausula requerido"
                                            Display="Dynamic" ControlToValidate="ddlClausula" InitialValue="0" ValidationGroup="vgMIN"></asp:RequiredFieldValidator>
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
                                    <div style="display: inline;">
                                        <asp:LinkButton ID="lbAgregarMIN" runat="server" CssClass="search" Font-Bold="True"
                                            CausesValidation="true" ValidationGroup="vgMIN">
                                     <img alt="Agregar MIN" src="../images/add.png" />&nbsp;Agregar
                                        </asp:LinkButton>
                                    </div>
                                    <asp:Panel ID="pnlBotonEdicionMin" runat="server" Style="display: inline;">
                                        <asp:LinkButton ID="lbActualizarMin" runat="server" CssClass="search" Font-Bold="True"
                                            ValidationGroup="vgMIN" CausesValidation="true"> <img alt="Actualizar Referencia" src="../images/save_all.png" />&nbsp;Actualizar </asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbCancelarActMin" runat="server" CssClass="search" Font-Bold="True"
                                            CausesValidation="true"> <img alt="Cancelar Actualizaci&oacute;n" src="../images/cancelar.png" />&nbsp;Cancelar </asp:LinkButton>
                                    </asp:Panel>
                                    <br />
                                    <asp:HiddenField ID="hfMsisdnAct" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td class="alterColor">
                                    &nbsp;<asp:Label ID="lblFiltroMsisdn" runat="server" Text="Filtrar Msisdn:"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFiltroMsisdn" runat="server" MaxLength="10"></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <cc1:FilteredTextBoxExtender ID="ftbTarifaDetalle" runat="server" FilterType="Numbers,Custom"
                                        TargetControlID="txtFiltroMsisdn">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:LinkButton ID="lbFiltrarMsisdn" runat="server" CausesValidation="true" CssClass="search"
                                        Font-Bold="True">
                                     <img alt="Filtrar" src="../images/filtro.png" />&nbsp;Filtrar
                                    </asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton ID="lbLimpiarFiltroMsisdn" runat="server" CausesValidation="true"
                                        CssClass="search" Font-Bold="True">
                                     <img alt="Filtrar" src="../images/unfunnel.png" />&nbsp;Quitar Filtro
                                    </asp:LinkButton>
                                </td>
                                <tr>
                                    <td colspan="2">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:Label ID="lblMensajeFiltroMsisdn" runat="server" Text="Msisdn no existe" ForeColor="Red" Visible="false"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <br />
                                        <asp:GridView ID="gvMINS" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                            EmptyDataText="&lt;h3&gt;No hay registros para mostrar&lt;/h3&gt;" ShowFooter="True"
                                            Width="90%">
                                            <AlternatingRowStyle CssClass="alterColor" />
                                            <FooterStyle CssClass="footer" />
                                            <Columns>
                                                <asp:BoundField DataField="msisdn" HeaderText="Msisdn" />
                                                <asp:BoundField DataField="numeroReserva" HeaderText="No. Reserva" />
                                                <asp:BoundField DataField="activaEquipoAnterior" HeaderText="Activa equipo anterior" />
                                                <asp:BoundField DataField="comSeguro" HeaderText="ComSeguro" />
                                                <asp:BoundField DataField="precioConIVA" DataFormatString="{0:c}" HeaderText="Precio con IVA" />
                                                <asp:BoundField DataField="precioSinIVA" DataFormatString="{0:c}" HeaderText="Precio sin IVA" />
                                                <asp:BoundField DataField="idClausula" HeaderText="idClausula" Visible="False" />
                                                <asp:BoundField DataField="clausula" HeaderText="Clausula" />
                                                <asp:BoundField DataField="Lista28Texto" HeaderText="Lista 28" />
                                                <asp:TemplateField HeaderText="Opciones">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkEliminar" runat="server" CommandArgument='<%# Bind("idRegistro") %>'
                                                            CommandName="eliminar" OnClientClick="return ConfirmarEliminacionRegistro('vgMIN')"
                                                            ToolTip="Eliminar">
                                                    <img alt="Eliminar" border="0" src="../images/Delete-32.png"></img>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lnkEditar" runat="server" CommandArgument='<%# Bind("idRegistro") %>'
                                                            CommandName="editar" ToolTip="Editar"> 
                                                    <img alt="Editar" border="0" src="../images/Edit-32.png"></img>
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
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
            </tr>
        </table>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
