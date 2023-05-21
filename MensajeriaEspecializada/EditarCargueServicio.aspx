<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarCargueServicio.aspx.vb"
    Inherits="BPColSysOP.EditarCargueServicio" %>

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
    <title>Edición de Servicio</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            height: 25px;
        }
        .style2
        {
            background-color: #eee9e9;
            height: 42px;
        }
        .style3
        {
            height: 42px;
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
        
        function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 35 && e.keyCode != 36 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        }
    </script>

</head>
<body class="cuerpo2" onload="GetWindowSize()">
    <form id="formPrincipal" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpEncabezado" runat="server" UpdateMode="Always" Width=" 98%">
        <asp:UpdatePanel ID="upEncabezado" runat="server">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
        <asp:HiddenField ID="hfNumReferencias" runat="server" Value="0" />
        <asp:HiddenField ID="hfNumMsisdn" runat="server" Value="0" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait"
        ChildrenAsTriggers="true" Width="100%" Height="627px">
        <asp:Panel ID="pnlInfoGeneral" runat="server" Enabled="False">
            <table class="tablaGris" cellpadding="1">
                <tr>
                    <th colspan="4">
                        Información del Servicio de Mensajería
                    </th>
                </tr>
                <tr>
                    <td class="style2">
                        Tipo Servicio:
                    </td>
                    <td class="style3">
                        <asp:TextBox ID="txtTipoServicio" runat="server" Enabled="False"></asp:TextBox>
                    </td>
                    <td class="style2">
                        N&uacute;mero de Radicado:
                    </td>
                    <td class="style3">
                                <asp:TextBox ID="txtNoRadicado" runat="server" Width="100px" onblur="ValidarNumeroRadicado();"
                                    MaxLength="10" Enabled="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Prioridad:
                    </td>
                    <td>
                        <asp:TextBox ID="txtPrioridad" runat="server" Enabled="False"></asp:TextBox>
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
                        <asp:TextBox ID="txtUsuarioEjecutor" runat="server" Width="200px" 
                            MaxLength="50" Enabled="False"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Nombres:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNombres" runat="server" Width="300px" MaxLength="255" 
                            Enabled="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Identificaci&oacute;n:
                    </td>
                    <td>
                        <asp:TextBox ID="txtIdentificacion" runat="server" Width="200px" MaxLength="15" 
                            Enabled="False"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Persona de Contacto (Autorizado):
                    </td>
                    <td>
                        <asp:TextBox ID="txtNombresAutorizado" runat="server" Width="300px" 
                            MaxLength="150" Enabled="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Ciudad:
                    </td>
                    <td>
                        <asp:textBox ID="txtCiudad" runat="server" Enabled="False">
                        </asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Barrio:
                    </td>
                    <td>
                        <asp:TextBox ID="txtBarrio" runat="server" Width="300px" MaxLength="50" 
                            Enabled="False"></asp:TextBox>
                         <div style="display: block">
                                        <asp:RequiredFieldValidator ID="rfvtxtBarrio" runat="server" ControlToValidate="txtBarrio"
                                         Display="Dynamic" ErrorMessage="El Barrio es requerido" ValidationGroup="vgServicio" />
                         </div>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Dirección:
                    </td>
                    <td>
                        <asp:TextBox ID="txtDireccion" runat="server" Width="300px" MaxLength="255" 
                            Enabled="False"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Teléfono:
                    </td>
                    <td valign="middle">
                        <div>
                            <asp:RadioButton runat="server" ID="rbTelefonoCelular" GroupName="telefono" 
                                Text="Celular" Enabled="False" />
                            <asp:RadioButton runat="server" ID="rbTelefonoFijo" GroupName="telefono" 
                                Text="Fijo" Enabled="False" />
                        </div>
                        <asp:TextBox ID="txtTelefono" runat="server" Width="150px" 
                            onKeyDown="return checkTextAreaMaxLength(this,event);" Enabled="False"></asp:TextBox>
                        &nbsp;ext.&nbsp;
                        <asp:TextBox ID="txtExtension" runat="server" Width="50px" Enabled="False" 
                            MaxLength="5"></asp:TextBox>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="style1">
                        Fecha Asignaci&oacute;n
                    </td>
                    <td>
                        <asp:TextBox ID="txtFechaAsignacion" runat="server" Enabled="False"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Cliente VIP:
                    </td>
                    <td>
                        <asp:CheckBox ID="chbClienteVIP" runat="server" Enabled="False" />
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">
                        Plan actual:
                    </td>
                    <td>
                        <asp:TextBox ID="txtPlanActual" runat="server" Width="300px" MaxLength="255" 
                            Enabled="False"></asp:TextBox>
                    </td>
                    <td class="alterColor">
                        Observaciones:
                    </td>
                    <td>
                        <asp:TextBox ID="txtObservacion" runat="server" Width="400px" Rows="3" TextMode="MultiLine"
                            MaxLength="1024" Enabled="False"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <br />
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
        <table width="95%">
            <tr>
                <%--Agregar Referencias--%>
                <td valign="top" style="width: 34%">
                    <asp:Panel ID="pnlInfoReferencia" runat="server">
                        <table class="tablaGris" cellpadding="1" style="width: 100%;">
                            <tr>
                                <th colspan="3">
                                    Agregar Referencias
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
                                            ValidationExpression="[0-9]{1,3}"></asp:RegularExpressionValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <br />
                                    <div style="display: inline">
                                        <asp:LinkButton ID="lbAgregarReferencia" runat="server" CssClass="search" Font-Bold="True"
                                            ValidationGroup="vgReferencia" CausesValidation="true"> <img alt="Agregar referencia" src="../images/add.png" />&nbsp;Agregar </asp:LinkButton>
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
                                <td align="center" colspan="2">
                                    <br />
                                    <asp:GridView ID="gvReferencias" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                        EmptyDataText="&lt;h3&gt;No hay registros para mostrar&lt;/h3&gt;" Width="90%">
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
                                            ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                                    </div>
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
                                            Display="Dynamic" ErrorMessage="Cláusula requerida" 
                                            ValidationGroup="vgMIN" InitialValue="0" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <br />
                                    <div style="display: block">
                                        <asp:CustomValidator ID="cusPrecios" runat="server" ControlToValidate="txtPrecioConIva" ErrorMessage="Los valores de Precio Sin Iva y Precio Con Iva no pueden ser iguales."
                                        Display="Dynamic" ClientValidationFunction="ValidarPrecios" ValidationGroup="vgMIN"></asp:CustomValidator>
                                    </div>
                                    <div style="display: inline;">
                                        <asp:LinkButton ID="lbAgregarMIN" runat="server" CssClass="search" Font-Bold="True"
                                            CausesValidation="true" ValidationGroup="vgMIN"> <img alt="Agregar MIN" src="../images/add.png" />&nbsp;Agregar </asp:LinkButton>
                                        <asp:Label ID="lblMensajeBloqueo" runat="server" CssClass="comentario" Visible="false">No esta permitido adicionar mines.</asp:Label>
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
                                <td align="center" colspan="2">
                                    <br />
                                    <asp:GridView ID="gvMINS" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                        EmptyDataText="&lt;h3&gt;No hay registros para mostrar&lt;/h3&gt;" Width="90%">
                                        <AlternatingRowStyle CssClass="alterColor" />
                                        <FooterStyle CssClass="footer" />
                                        <Columns>
                                            <asp:BoundField DataField="msisdn" HeaderText="Msisdn" />
                                            <asp:BoundField DataField="activaEquipoAnterior" HeaderText="Activa equipo anterior" />
                                            <asp:BoundField DataField="comSeguro" HeaderText="ComSeguro" />
                                            <asp:BoundField DataField="precioConIVA" HeaderText="Precio con IVA" />
                                            <asp:BoundField DataField="precioSinIVA" HeaderText="Precio sin IVA" />
                                            <asp:BoundField DataField="clausula" HeaderText="Clausula" />
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
            </tr>
        </table>
        <br /><br />
        <asp:Panel ID="pnlBotones" runat="server">
            <div style="display: block; text-align:center">
                <asp:LinkButton ID="lbGuardar" runat="server" CssClass="search" Font-Bold="True"
                    CausesValidation="true" ValidationGroup="vgServicio">
                         <img alt="Guardar Servicio" src="../images/save_all.png" />&nbsp;Guardar
                </asp:LinkButton>&nbsp;
            </div>
        </asp:Panel>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
