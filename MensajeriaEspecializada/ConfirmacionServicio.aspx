<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmacionServicio.aspx.vb"
    Inherits="BPColSysOP.ConfirmacionServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Confirmar Servicio Mensajeria</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
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

        var ctrIdFlagFilterFilter;
        var callBackPanelFilter;

        function ObtenerIdFlagCallBackPanelFilter(idFlag) {

            switch (idFlag) {
                case 1:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroFecha.ClientID %>');
                    callBackPanelFilter = document.getElementById('<%= cpFiltroFecha.ClientID %>');
                    break;
                case 2:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroJornada.ClientID %>')
                    callBackPanelFilter = document.getElementById('<%= cpFiltroJornada.ClientID %>');
                    break;
                default:
                    break;
            }
        }

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {

            }

        }
        function MostrarOcultarDivFloater(mostrar) {
            if (mostrar)
                $("#divFloater").show();
            else
                $("#divFloater").hide();
        }

        function ValidarCapacidadDeEntrega() {
            try {
                var fechaAgenda = eo_GetObject('<%=dpFechaAgenda.ClientID %>').getSelectedDate();
                var idJornada = document.getElementById('<%= ddlJornada.ClientID %>').value;

                if (fechaAgenda != null && idJornada.toString() != "0") {
                    try {
                        MostrarOcultarDivFloater(true);
                        eo_Callback('cpFiltroJornada', '');
                    } catch (e) {
                        MostrarOcultarDivFloater(false);
                        alert("Error al tratar de validar capacidades de entrega.\n" + e.description);
                    }
                } else {
                    var btn = document.getElementById('<%=btnConfirmar.ClientID %>');
                    btn.disabled = true;
                }
            } catch (e) {
            }
        }


        function validarAgenda(idFiltro, idFlag, parametro, idCallbackPanel) {
            var control = eo_GetObject(idFiltro).getSelectedDate();
            var controlJornada = document.getElementById('<%= ddlJornada.ClientID %>');

            if (control != null && controlJornada.selectedIndex != 0) {
                ObtenerIdFlagCallBackPanelFilter(idFlag);
                var comboFiltrado = ctrIdFlagFilterFilter.value;
                try {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(callBackPanelFilter.id, parametro);
                    ctrIdFlagFilterFilter.value = "1";

                } catch (e) {
                    MostrarOcultarDivFloater(false);
                    //alert("Error al tratar de filtrar Datos.\n" + e.description);
                }
            }
        }

        function validarJornada(idFiltro, idFlag, parametro, idCallbackPanel) {

            var controlJornada = document.getElementById(idFiltro);
            var control = eo_GetObject('<%= dpFechaAgenda.ClientID %>').getSelectedDate();


            if (control != null && controlJornada.selectedIndex != 0) {
                ObtenerIdFlagCallBackPanelFilter(idFlag);
                var comboFiltrado = ctrIdFlagFilterFilter.value;
                try {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(callBackPanelFilter.id, parametro);
                    ctrIdFlagFilterFilter.value = "1";

                } catch (e) {
                    MostrarOcultarDivFloater(false);
                    //alert("Error al tratar de filtrar Datos.\n" + e.description);
                }
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

        function GestionCampoCorreo(control) {
            try {
                var objCtrlCorreo = $('#txtCorreoEnvioCH');
                var objCtrlValidatorCorreo = document.getElementById('<%= rfvtxtCorreoEnvioCH.ClientID %>');

                switch (control.val()) {
                    case "F":
                        ValidatorEnable(objCtrlValidatorCorreo, false);
                        objCtrlCorreo.focus();
                        break;
                    case "E":
                        ValidatorEnable(objCtrlValidatorCorreo, true);
                        objCtrlCorreo.focus();
                        break;
                }
            } catch (e) {
                alert("Error al tratar de gestionar el campo Correo.\n" + e.description);
            }
        }

        function ValidaMedioEnvioCH(sender, args) {
            try {
                var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
                args.IsValid = pattern.test($('#txtCorreoEnvioCH').val());
            }
            catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar medio de envío CH.\n" + e.description);
            }
        }

        function pageLoad(sender, args) {
            $('#formPrincipal input[type="radio"]').each(function () {
                $(this).checked = false;
            });
        }
    </script>

</head>
<body class="cuerpo2" onload="GetWindowSize();">
    <form id="form1" runat="server">
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            <asp:HiddenField ID="hfMedidasVentana" runat="server" />
        </eo:CallbackPanel>
        <asp:Panel ID="pnlGeneral" runat="server">
            <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait" ChildrenAsTriggers="true">
                <table class="tabla" style="width: 95%">
                    <tr>
                        <th colspan="4">INFORMACI&Oacute;N DEL SERVICIO
                        </th>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <b>No. Radicado:</b>&nbsp;<asp:Label ID="lblNumRadicado" runat="server" Text=""></asp:Label>
                        </td>
                        <td colspan="2">
                            <b>Ejecutor:</b>&nbsp;<asp:Label ID="lblEjecutor" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Label ID="lblTipoServicio" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Nombre Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblNombreCliente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">C&eacute;dula/Nit:
                        </td>
                        <td>
                            <asp:Label ID="lblIdentificacion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Direcci&oacute;n Correspondencia:
                        </td>
                        <td>
                            <asp:TextBox ID="txtDireccion" Enabled="false" runat="server" Width="300px"></asp:TextBox>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ErrorMessage="Campo Direcci&oacute;n requerido"
                                    Display="Dynamic" ControlToValidate="txtDireccion" ValidationGroup="confirmacion"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td class="field">Barrio:
                        </td>
                        <td>
                            <asp:TextBox ID="txtBarrio" runat="server" Enabled="false" Width="300px"></asp:TextBox>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvBarrio" runat="server" Enabled="false" ErrorMessage="Campo Barrio requerido"
                                    Display="Dynamic" ControlToValidate="txtBarrio" ValidationGroup="confirmacion"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Ciudad donde se encuentra Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblCiudad" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">Tel&eacute;fono de Contacto:
                        </td>
                        <td>
                            <div>
                                <asp:RadioButton runat="server" Enabled="false" ID="rbTelefonoCelular" GroupName="telefono" Text="Celular" />
                                <asp:RadioButton runat="server" Enabled="false" ID="rbTelefonoFijo" GroupName="telefono" Text="Fijo" />
                            </div>
                            <asp:TextBox ID="txtTelefono" runat="server" Width="150px"
                                Enabled="False"></asp:TextBox>
                            &nbsp;ext.&nbsp;
                        <asp:TextBox ID="txtExtension" runat="server" Width="50px" Enabled="False"
                            MaxLength="5"></asp:TextBox>
                            <br />
                            <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                                ControlToValidate="txtTelefono" Display="Dynamic"
                                ErrorMessage="El teléfono es requerido" ValidationGroup="confirmacion"></asp:RequiredFieldValidator>

                            <asp:CustomValidator ID="cvTelefono" runat="server" Display="Dynamic" ControlToValidate="txtTelefono" ValidationGroup="confirmacion"
                                ClientValidationFunction="validarTelefonoClient" ErrorMessage="La longitud del teléfono debe ser de 10 dígitos para celular y 7 para teléfonos fijos." />

                            <asp:HiddenField ID="hfMaxLength" Value="0" runat="server" />

                        </td>
                    </tr>
                    <tr>
                        <td class="field">Persona de Contacto (Autorizado):
                        </td>
                        <td>
                            <asp:TextBox ID="txtPersonaContacto" Enabled="false" runat="server" Width="200px"></asp:TextBox>
                        </td>
                        <td class="field">Observaciones:
                        </td>
                        <td>
                            <asp:TextBox ID="txtObservacion" runat="server" Width="95%" TextMode="MultiLine"
                                Rows="2"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Fecha Agendamiento:
                        </td>
                        <td>
                            <div style="display: inline">
                                <eo:CallbackPanel ID="cpFiltroFecha" runat="server" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                                    Style="display: inline; padding: 0px 0px 0px 0px; vertical-align: middle" GroupName="filtroFecha" UpdateMode="Group">
                                    <eo:DatePicker ID="dpFechaAgenda" runat="server" PickerFormat="dd/MM/yyyy" ControlSkinID="None"
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
                        .DatePickerStyle10 {font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}&lt;/style&gt;"
                                        DayCellHeight="15" DayCellWidth="31" DayHeaderFormat="Short" DisabledDates=""
                                        OtherMonthDayVisible="True" SelectedDates="" TitleFormat="MMMM, yyyy" TitleLeftArrowImageUrl="DefaultSubMenuIconRTL"
                                        TitleRightArrowImageUrl="DefaultSubMenuIcon" ClientSideOnSelect="ValidarCapacidadDeEntrega">
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
                                </eo:CallbackPanel>
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
                            <asp:HiddenField ID="hfFlagFiltroFecha" runat="server" />
                            <div style="display: inline">
                                <asp:Label ID="lblCuposDisponibles" runat="server" Text="" Font-Italic="true"></asp:Label>
                            </div>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvFeChaAgendamiento" runat="server" ErrorMessage="Fecha de agendamiento requerida"
                                    Display="Dynamic" ControlToValidate="dpFechaAgenda" ValidationGroup="confirmacion"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td class="field">Jornada:
                        </td>
                        <td>
                            <eo:CallbackPanel ID="cpFiltroJornada" runat="server" UpdateMode="Group" Width="100%" GroupName="filtroFecha">
                                <asp:DropDownList ID="ddlJornada" runat="server" onchange="ValidarCapacidadDeEntrega();">
                                </asp:DropDownList>
                            </eo:CallbackPanel>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvJornada" runat="server" ErrorMessage="Jornada de agendamiento requerida"
                                    Display="Dynamic" ControlToValidate="ddlJornada" ValidationGroup="confirmacion"
                                    InitialValue="0"></asp:RequiredFieldValidator>
                            </div>
                            <asp:HiddenField ID="hfFlagFiltroJornada" runat="server" />
                        </td>
                    </tr>

                    <tr id="trCorreo" runat="server">
                        <td class="field">Medio de envío
                            <br />
                            Certificado Homologación:</td>
                        <td>
                            <asp:RadioButtonList ID="rblMedoEnvioCH" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="F" Text="Físico" onClick="GestionCampoCorreo($(this))" />
                                <asp:ListItem Value="E" Text="Correo Electrónico" onClick="GestionCampoCorreo($(this))" />
                            </asp:RadioButtonList>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvrblMedoEnvioCH" runat="server" ControlToValidate="rblMedoEnvioCH"
                                    ErrorMessage="Se debe seleccionar un medio de envío" ValidationGroup="confirmacion" />
                            </div>
                        </td>

                        <td class="field">Correo Electrónico envío
                            <br />
                            Certificado Homologación:</td>
                        <td>
                            <asp:TextBox ID="txtCorreoEnvioCH" runat="server" Width="400px" MaxLength="100" />
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvtxtCorreoEnvioCH" runat="server" ControlToValidate="txtCorreoEnvioCH"
                                    ErrorMessage="El correo electrónico es requerido" Display="Dynamic" ValidationGroup="confirmacion" />
                                <asp:CustomValidator ID="cvtxtCorreoEnvioCH" runat="server" ControlToValidate="txtCorreoEnvioCH"
                                    ErrorMessage="Se debe ingresar un correo electrónico válido" Display="Dynamic" ValidationGroup="confirmacion"
                                    ClientValidationFunction="ValidaMedioEnvioCH" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="4" align="center">
                            <br />
                            <eo:CallbackPanel ID="cpConfirmar" runat="server" UpdateMode="Group" Width="100%" GroupName="filtroFecha" Style="display: inline">
                                <asp:Button ID="btnConfirmar" runat="server" Text="Confirmar" ValidationGroup="confirmacion"
                                    CssClass="search" />&nbsp;&nbsp;&nbsp;&nbsp;

                            <asp:Button ID="btnAdicionarNovedad" runat="server" Text="" CssClass="search" 
                                CausesValidation="False" />&nbsp;&nbsp;&nbsp;&nbsp;
                               
                            </eo:CallbackPanel>
                        </td>
                    </tr>
                </table>
                <eo:Dialog runat="server" ID="dlgNovedad" ControlSkinID="None" Height="350px" HeaderHtml="Adici&oacute;n de Novedades"
                    CloseButtonUrl="00020312" BackColor="White" CancelButton="lbCerrarPopUp" BackShadeColor="Gray"
                    BackShadeOpacity="50">
                    <ContentTemplate>
                        <table align="center" class="tabla">
                            <tr>
                                <th colspan="2">INFORMACI&Oacute;N DE LA NOVEDAD
                                </th>
                            </tr>
                            <tr>
                                <td class="field">Seleccione tipo de Novedad:
                                </td>
                                <td>

                                    <asp:DropDownList ID="ddlTipoNovedadCall" runat="server" ValidationGroup="registroNovedad" Visible="false">
                                    </asp:DropDownList>
                                    <div style="display: block;">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Seleccione un tipo de novedad"
                                            Display="Dynamic" ControlToValidate="ddlTipoNovedadCall" ValidationGroup="registroNovedad"
                                            InitialValue="0"></asp:RequiredFieldValidator>
                                    </div>

                                    <asp:DropDownList ID="ddlTipoNovedad" runat="server" ValidationGroup="registroNovedad"  Visible="false">
                                    </asp:DropDownList >
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
                                    <asp:LinkButton ID="lbRegistrar" runat="server" ValidationGroup="registroNovedad"
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
                
            </eo:CallbackPanel>
            <br />
            <asp:Panel ID="pnlInfoReposicion" runat="server" Visible="false">
                <table class="tabla" style="width: 95%">
                    <tr>
                        <td style="width: 45%" valign="top">
                            <asp:GridView ID="gvListaReferencias" runat="server" Width="100%" AutoGenerateColumns="false"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen referencias asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia Solicitada" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="CantidadDisponible" HeaderText="Cantidad Disponible" ItemStyle-HorizontalAlign="Center" />
                                    <asp:TemplateField HeaderText="Disponibilidad">
                                        <ItemTemplate>
                                            <asp:Image ID="imgDisponibilidad" ImageUrl="~/images/BallGreen.gif" runat="server" />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <br />
                            <br />
                            <eo:CallbackPanel ID="cpNovedad" runat="server" Width="100%" UpdateMode="Always"
                                LoadingDialogID="ldrWait_dlgWait">
                                <asp:GridView ID="gvNovedad" runat="server" Width="100%" AutoGenerateColumns="false"
                                    EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                    <Columns>
                                        <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                        <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                        <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}" />
                                        <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                                    </Columns>
                                </asp:GridView>
                            </eo:CallbackPanel>
                        </td>
                        <td style="width: 10%">&nbsp;
                        </td>
                        <td style="width: 45%" valign="top">
                            <asp:GridView ID="gvListaMsisdn" runat="server" Width="100%" AutoGenerateColumns="false"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen MSISDNs asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                    <asp:BoundField DataField="activaEquipoAnterior" HeaderText="Activar Equipo Anterior (S/N)"
                                        ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="comseguro" HeaderText="Comseguro (S/N)" ItemStyle-HorizontalAlign="Center" />
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
            </asp:Panel>

            <asp:Panel ID="pnlInfoServicioTecnico" runat="server" Visible="false">
                <table class="tabla" style="width: 95%">
                    <tr>
                        <td style="width: 45%" valign="top">
                            <asp:GridView ID="gvSerialesPrestamo" runat="server" AutoGenerateColumns="false"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="idDetalle" HeaderText="ID" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="serial" HeaderText="IMEI Reparación" />
                                    <asp:BoundField DataField="ReferenciaReparado" HeaderText="Referencia" />
                                    <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                    <asp:CheckBoxField DataField="requierePrestamoEquipo" HeaderText="Requiere Préstamo" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="serialPrestamo" HeaderText="Serial Préstamo" />
                                    <asp:BoundField DataField="ReferenciaPrestamo" HeaderText="Referencia" />
                                    <asp:BoundField DataField="fechaEntregaServicioTecnicoString" HeaderText="Fecha Entrega" DataFormatString="{0:dd/MM/yyyy}" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td style="width: 45%" valign="top">
                            <asp:GridView ID="gvNovedadST" runat="server" Width="100%" AutoGenerateColumns="false"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                    <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                    <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                        DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>

        </asp:Panel>
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
