<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarCasoSAC.aspx.vb" Inherits="BPColSysOP.RegistrarCasoSAC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registrar Caso SAC</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, "") }
        function EsSerialValido(source, args) {
            try {
                var serial = document.getElementById('txtSerial').value.trim();
                if (serial.length > 0) {
                    var regExp = /^([0-9]{10}|[0-9]{15}|[0-9]{17})$/
                    if (regExp.test(serial)) {
                        args.IsValid = true;
                    } else {
                        args.IsValid = false;
                    }
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                alert("Error al tratar de validar datos.\n" + e.description);
                args.IsValid = false;
            }
        }

        function ExistenSeriales(source, args) {
            try {
                var numSeriales = document.getElementById('hfNumSeriales').value;
                if (numSeriales > 0) {
                    args.IsValid = true;
                } else {
                    args.IsValid = false;
                }
            } catch (e) {
                alert("Error al tratar de validar adición de seriales.\n" + e.description);
                args.IsValid = false;
            }
        }

        function MakeSubmit(btnName) {
            if (event.keyCode == 13) {
                event.returnValue = false;
                event.cancelBubble = true;
                btn = document.getElementById(btnName);
                btn.click();
            }
        }

        function EsFechaValida(source, args) {
            try {
                var fechaSeleccionada = eo_GetObject("dpFechaRecepcion").getSelectedDate();
                if (fechaSeleccionada != null) {
                    if (IsDate(fechaSeleccionada)) {
                        var fechaActual = new Date();
                        if (fechaSeleccionada.valueOf() <= fechaActual.valueOf()) {
                            args.IsValid = true;
                        } else {
                            args.IsValid = false;
                            source.innerHTML = "La fecha de recepción no puede ser mayor que la fecha actual.";
                        }
                    } else {
                        args.IsValid = false;
                        source.innerHTML = "La fecha proporcionada no es válida. Por favor verifique"
                    }
                } else { args.IsValid = true; }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar Fecha.\n" + e.description);
            }
        }

        function MostrarPopUp(popUpId, titulo, url) {
            var dlg = eo_GetObject(popUpId);
            dlg.setCaption("<b>" + titulo + "</b>");
            if (url.length > 0) { dlg.setContentUrl(url); }
            dlg.show(true);
            return (false);
        }

        function ActualizarListaRemitente() {
            try {
                eo_Callback("cpRemitente", "cargarRemitentes");
            } catch (e) {
                alert("Error al tratar de actualizar listado de remitentes.\n" + e.description);
            }
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <eo:CallbackPanel ID="cpGeneral" runat="server" ChildrenAsTriggers="true" LoadingDialogID="ldrWait_dlgWait">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        <table class="tabla" border="1" bordercolor="#f0f0f0" cellpadding="1" cellspacing="1">
            <tr>
                <th colspan="2">
                    Información del Caso
                </th>
            </tr>
            <tr>
                <td class="field" style="width: 130px">
                    Tipo de Cliente:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipoCliente" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvTipoCliente" runat="server" ErrorMessage="Tipo de Cliente Requerido. Seleccione el Tipo de Cliente, Por favor"
                            ControlToValidate="ddlTipoCliente" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Cliente:
                </td>
                <td>
                    <asp:DropDownList ID="ddlCliente" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvCliente" runat="server" ErrorMessage="Cliente Requerido. Seleccione un Cliente, Por favor"
                            ControlToValidate="ddlCliente" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Clase de Caso:
                </td>
                <td>
                    <asp:DropDownList ID="ddlClaseCaso" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvClaseDeCaso" runat="server" ErrorMessage="Clase de Caso Requerida. Seleccione una Clase de Caso, Por favor"
                            ControlToValidate="ddlClaseCaso" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Tipo de Caso:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipoCaso" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvTipoDeCaso" runat="server" ErrorMessage="Tipo de Caso Requerido. Seleccione un Tipo de Caso, Por favor"
                            ControlToValidate="ddlTipoCaso" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Remitente:
                </td>
                <td>
                    <eo:CallbackPanel ID="cpRemitente" runat="server" QueueMode="KeepLast" Style="display: inline"
                        ChildrenAsTriggers="true">
                        <asp:DropDownList ID="ddlRemitente" runat="server">
                        </asp:DropDownList>
                        &nbsp;
                        <asp:ImageButton ID="ibCrearRemitente" runat="server" ToolTip="Adicionar Remitente"
                            ImageUrl="~/images/add_user.png" Style="display: inline; vertical-align: middle !important"
                            OnClientClick="return MostrarPopUp('dlgPopUp', 'Creación de Nuevo Remitente', 'CrearUsuarioModuloSAC.aspx');" />
                    </eo:CallbackPanel>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvRemitente" runat="server" ErrorMessage="Remitente Requerido. Seleccione un Remitente, Por favor"
                            ControlToValidate="ddlRemitente" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Descripción:
                </td>
                <td>
                    <asp:TextBox ID="txtDescripcion" runat="server" Columns="70" Rows="4" TextMode="MultiLine"></asp:TextBox>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ErrorMessage="Digite la descripción del Caso, Por favor"
                            ControlToValidate="txtDescripcion" Display="Dynamic" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                    <div style="display: block">
                        <asp:RegularExpressionValidator ID="revDescripcion" runat="server" ValidationExpression="(.|\n){0,2000}"
                            Display="Dynamic" ValidationGroup="formularioGeneral" ControlToValidate="txtDescripcion"
                            ErrorMessage="Formato o longitud no válidos. Se espera un texto de máximo 2000 caracteres."></asp:RegularExpressionValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Información de Serial:
                </td>
                <td>
                    <table>
                        <tr>
                            <td>
                                <div style="display: block">
                                    <uc1:EncabezadoPagina ID="epNotificacionSerial" runat="server" />
                                </div>
                                <div style="display: inline">
                                    <asp:TextBox ID="txtSerial" runat="server" Width="200px" onkeydown="try{MakeSubmit('ibAdicionar');}catch(e){alert('Error: '+e.description )}"
                                        MaxLength="20"></asp:TextBox>&nbsp;
                                    <asp:ImageButton ID="ibAdicionar" runat="server" ImageUrl="~/images/add.png" ToolTip="Adicionar Serial"
                                        ValidationGroup="adicionSerial" CssClass="search" />
                                </div>
                                <div style="display: block">
                                    <asp:RequiredFieldValidator ID="rfvSerial" runat="server" ErrorMessage="Digite el serial que desea asignar, Por favor."
                                        Display="Dynamic" ControlToValidate="txtSerial" ValidationGroup="adicionSerial"></asp:RequiredFieldValidator>
                                    <asp:CustomValidator ID="cusSerial" runat="server" ControlToValidate="txtSerial"
                                        ErrorMessage="El Serial digitado no tiene un formato válido, Por favor verifique"
                                        ClientValidationFunction="EsSerialValido" Display="Dynamic" ValidationGroup="adicionSerial"></asp:CustomValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:GridView ID="gvSerial" runat="server" AutoGenerateColumns="false" ShowFooter="true"
                                    EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han adicionado seriales&lt;/i&gt;&lt;/blockquote&gt;">
                                    <Columns>
                                        <asp:BoundField DataField="serial" HeaderText="Serial" />
                                        <asp:BoundField DataField="pdv" HeaderText="Punto de Venta" />
                                        <asp:BoundField DataField="coordinador" HeaderText="Coordinador" />
                                        <asp:BoundField DataField="supervisor" HeaderText="Supervisor" />
                                        <asp:TemplateField HeaderText="Opción">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibEliminar" runat="server" ImageUrl="~/images/eliminar.gif"
                                                    CommandArgument='<%#Bind("serial") %>' CommandName="Eliminar" OnClientClick="return confirm('¿Realmente desea eliminar el serial seleccionado?');" />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                    </Columns>
                                    <FooterStyle CssClass="thGris" />
                                </asp:GridView>
                                <div style="display: block">
                                    <asp:HiddenField ID="hfNumSeriales" Value="0" runat="server" />
                                    <asp:CustomValidator ID="cusNumSeriales" runat="server" ClientValidationFunction="ExistenSeriales"
                                        ErrorMessage="Debe proporcionar la información de seriales asociados al caso"
                                        ValidationGroup="formularioGeneral"></asp:CustomValidator>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Fecha de Recepción:
                </td>
                <td>
                    <eo:DatePicker ID="dpFechaRecepcion" runat="server" DayCellHeight="15" SelectedDates=""
                        DisabledDates="" PopupDownImageUrl="~/images/calendar.png" PopupImageUrl="~/images/calendar.png"
                        OtherMonthDayVisible="True" MonthSelectorVisible="True" WaitMessage="Cargando..."
                        DayHeaderFormat="Short" TitleFormat="MMMM, yyyy" PickerFormat="dd/MM/yyyy HH:mm"
                        VisibleDate="2011-01-01" TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                        DayCellWidth="31" PopupHoverImageUrl="~/images/calendar.png" ControlSkinID="None"
                        PickerHint="" PopupExpandDirection="Auto">
                        <TodayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040401');color:#1176db;">
                        </TodayStyle>
                        <SelectedDayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040403');color:Brown;">
                        </SelectedDayStyle>
                        <DisabledDayStyle CssText="font-family:Verdana;font-size:8pt;color: gray"></DisabledDayStyle>
                        <FooterTemplate>
                            <table style="font-size: 11px; font-family: Verdana" border="0" cellspacing="5" cellpadding="0">
                                <tr>
                                    <td width="30">
                                    </td>
                                    <td valign="center">
                                        <img src="{img:00040401}">
                                    </td>
                                    <td valign="center">
                                        Today: {var:today:dd/MM/yyyy}
                                    </td>
                                </tr>
                            </table>
                        </FooterTemplate>
                        <MonthSelectorStyle CssText=""></MonthSelectorStyle>
                        <CalendarStyle CssText="background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;">
                        </CalendarStyle>
                        <TitleArrowStyle CssText="cursor: hand"></TitleArrowStyle>
                        <DayHoverStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040402');color:#1c7cdc;">
                        </DayHoverStyle>
                        <MonthStyle CssText="cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px;">
                        </MonthStyle>
                        <TitleStyle CssText="font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;">
                        </TitleStyle>
                        <DayHeaderStyle CssText="font-family:Verdana;font-size:8pt;border-bottom: #f5f5f5 1px solid">
                        </DayHeaderStyle>
                        <DayStyle CssText="font-family:Verdana;font-size:8pt;"></DayStyle>
                    </eo:DatePicker>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvFechaRecepcion" runat="server" ErrorMessage="Fecha de recepción requerida. Proporcione la fecha de recepción del caso, por favor. "
                            ControlToValidate="dpFechaRecepcion" Display="Dynamic" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                    <div style="display: block">
                        <asp:CustomValidator ID="cusFechaRecepcion" runat="server" ErrorMessage="La fecha de recepción no puede ser mayor que la fecha actual."
                            ControlToValidate="dpFechaRecepcion" ValidationGroup="formularioGeneral" Display="Dynamic"
                            ClientValidationFunction="EsFechaValida"></asp:CustomValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Tramitado Por:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTramitador" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvTramitador" runat="server" ErrorMessage="Tramitador Requerido. Seleccione un Tramitador, Por favor"
                            ControlToValidate="ddlTramitador" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Observaciones:
                </td>
                <td>
                    <asp:TextBox ID="txtObservacion" runat="server" Columns="70" Rows="4" TextMode="MultiLine"></asp:TextBox>
                    <div style="display: block">
                        <asp:RegularExpressionValidator ID="revObservaciones" runat="server" ValidationExpression="(.|\n){0,2000}"
                            Display="Dynamic" ValidationGroup="formularioGeneral" ControlToValidate="txtObservacion"
                            ErrorMessage="Formato o longitud no válidos. Se espera un texto de máximo 2000 caracteres."></asp:RegularExpressionValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <br />
                    <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="submit" ValidationGroup="formularioGeneral" />
                </td>
            </tr>
        </table>
    </eo:CallbackPanel>
    <uc3:Loader ID="ldrWait" runat="server" />
    <eo:Dialog ID="dlgPopUp" runat="server" CloseButtonUrl="00070101" ContentUrl="CrearUsuarioModuloSAC.aspx"
        ControlSkinID="None" Height="300px" Width="400px" AllowResize="True" BorderColor="#335C88"
        BorderStyle="Solid" BorderWidth="1px" HeaderHtml="<b>Creación de Nuevo Remitente</b>"
        MinimizeButtonUrl="00070102" ResizeImageUrl="00020014" RestoreButtonUrl="00070103"
        ShadowColor="LightGray" ShadowDepth="3" MaxHeight="400" MaxWidth="550" MinHeight="200"
        MinWidth="400" VerticalAlign="Middle" BackShadeColor="Gray" ClientSideOnCancel="ActualizarListaRemitente"
        IconUrl="~/images/add_user.png">
        <HeaderStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 11px; background-image: url(00070104); padding-bottom: 3px; padding-top: 3px; font-family: tahoma" />
        <FooterStyleActive CssText="background-color: #e5f1fd; padding-bottom: 8px;" />
        <ContentStyleActive CssText="border-top: #335c88 1px solid; background-color: #e5f1fd; height: 300px; width: 400px;" />
    </eo:Dialog>
    </form>
</body>
</html>
