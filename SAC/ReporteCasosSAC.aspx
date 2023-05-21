<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteCasosSAC.aspx.vb"
    Inherits="BPColSysOP.ReporteCasosSac" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte Caso SAC</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server" whidth="90%">
        <asp:ScriptManager ID="smAjaxManager" runat="server" EnableScriptGlobalization="true">
        </asp:ScriptManager>
        <script src="../include/jquery-1.js" type="text/javascript"></script>
        <script type="text/javascript">

            String.prototype.trim = function () { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, "") }

            function ValidaNumero(e) {
                var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
                return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
            }
            function ValidaNumerodeEntero(s, e) {
                if (e.value == null) {
                    s.SetIsValid(false);
                    s.SetErrorText("No ingreso ningún Radicado!");
                    if (e.htmlEvent != 'undefined')
                        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                    return (false);
                }
                else {
                    var name = e.value.toString().replace(/\r\n|\n|\r/g, '');
                    if (/^[0-9]+$/.test(name)) {
                        s.SetIsValid(true);
                        return (true);
                    } else {
                        s.SetIsValid(false);
                        s.SetErrorText("Existen Carácter no válidos solo acepta numeros!");
                        if (e.htmlEvent != 'undefined')
                            ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                        return (false);
                    }
                }
            }
            function ValidarDatos(sorce, arguments) {
                try {
                    switch (sorce.id) {
                        case "cusRango":
                            var fechaInicial = $("#txtFechaInicial").val();
                            var fechaFinal = $("#txtFechaFinal").val();
                            if ((fechaInicial != "" && fechaFinal == "") || (fechaInicial == "" && fechaFinal != "")) {
                                arguments.IsValid = false;
                            } else {
                                arguments.IsValid = true;
                            }
                            break;
                        case "cusSeleccion":
                            var noCaso = $("#txtNoCaso").val();
                            var claseCaso = $("#ddlClaseCaso").val();
                            var tipoCliente = $("#ddlTipoCliente").val();
                            var tipoCaso = $("#ddlTipoCaso").val();
                            var cliente = $("#ddlCliente").val();
                            var remitente = $("#ddlRemitente").val();
                            var generadorInconformidad = $("#ddlGeneradorInconformidad").val();
                            var tramitador = $("#ddlTramitador").val();
                            var estado = $("#ddlEstado").val();
                            var fechaInicial = $("#txtFechaInicial").val();
                            var fechaFinal = $("#txtFechaFinal").val();
                            if (noCaso.trim() == "" && claseCaso == "0" && tipoCliente == "0" && tipoCaso == "0" && cliente == "0"
                             && remitente == "0" && generadorInconformidad == "0" && tramitador == "0" && estado == "0"
                                 && fechaInicial == "" && fechaFinal == "") {
                                arguments.IsValid = false;
                            } else {
                                arguments.IsValid = true;
                            }
                            break;
                        default:
                            arguments.IsValid = true;
                    }
                } catch (e) {
                    alert("Error al tratar de valida datos seleccionados.\n" + e.description);
                    arguments.IsValid = false;
                }
            }
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            var elem;
            prm.add_initializeRequest(prm_InitializeRequest);
            prm.add_endRequest(prm_EndRequest);

            function prm_InitializeRequest(sender, args) {
                elem = args.get_postBackElement().id;
                loadingPanel.Show();
            }
            function prm_EndRequest(sender, args) {
                //            console.clear();
                //            console.log(elem);
                loadingPanel.Hide();
                if (elem.indexOf("lbDescargar") > -1) {
                    btnExportador.DoClick();
                }
            }
        </script>
        <asp:UpdatePanel ID="epNotificador" runat="server">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:Panel ID="pnlResultado" runat="server">
            <table width="90%">
                <tr>
                    <th colspan="6">Filtros de Búsqueda
                    </th>
                </tr>
                <tr>
                    <td class="field" style="width: 130px">No. de Caso(s):
                    </td>
                    <td>
                        <dx:ASPxMemo ID="txtNoCaso" runat="server" ClientInstanceName="txtNoCaso" Height="100px"
                            NullText="Ingrese los No. de Cas separados por saltos de línea Ejemplo:                     SOL-2011-016                  QJA-2011-023                    REC-2011-049                    SOL-CEM-2013-7456"
                            Width="190px">
                        </dx:ASPxMemo>
                    </td>
                    <td align="left" class="field">Radicad(os):
                    </td>
                    <td align="left">
                        <dx:ASPxMemo ID="MemoRadicado" runat="server" ClientInstanceName="MemoRadicado" Height="100px"
                            NullText="Ingrese los Radicados separados por saltos de línea Ejemplo:       6732781             6736838                    6736848                    6736839"
                            onkeypress="javascript:return ValidaNumero(event);" ValidateRequestMode="Enabled"
                            Width="190px">
                            <ClientSideEvents Validation="ValidaNumerodeEntero" />
                            <ValidationSettings ErrorDisplayMode="ImageWithText" ErrorText="Existen Carácter no válidos solo acepta numeros!"
                                SetFocusOnError="True" ValidationGroup="buscarCaso">
                            </ValidationSettings>
                        </dx:ASPxMemo>
                    </td>
                </tr>
                <tr>
                    <td class="field">Clases de Caso:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlClaseCaso" runat="server" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                    <td class="field">Tipo de Caso:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoCaso" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">Tipo de Cliente:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoCliente" runat="server" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                    <td class="field">Estado:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlEstado" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">Fecha:
                    </td>
                    <td style="width: 230px">
                        <div style="display: inline">
                            <div style="display: inline">
                                <asp:TextBox ID="txtFechaInicial" runat="server" Enabled="False" Width="80px"></asp:TextBox>
                                <cc1:CalendarExtender ID="ceFechaInicial" runat="server" CssClass="calendarTheme"
                                    Format="dd/MM/yyyy" PopupButtonID="imgFechaIni" TargetControlID="txtFechaInicial">
                                </cc1:CalendarExtender>
                                <img src="../images/calendar.png" id="imgFechaIni" alt="Fecha Inicial" title="Fecha Inicial" />
                                &nbsp;&nbsp;&nbsp;
                            </div>
                            <div style="display: inline">
                                <asp:TextBox ID="txtFechaFinal" runat="server" Enabled="False" Width="80px"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtFechaFinal_CalendarExtender" runat="server" CssClass="calendarTheme"
                                    Format="dd/MM/yyyy" PopupButtonID="imgFechaFin" TargetControlID="txtFechaFinal">
                                </cc1:CalendarExtender>
                                <img src="../images/calendar.png" id="imgFechaFin" alt="Fecha Inicial" title="Fecha Final" />
                            </div>
                        </div>
                    </td>
                    <td class="field">Tipo de Fecha:
                    </td>
                    <td colspan="3">
                        <asp:RadioButtonList ID="rblTipoFecha" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Text="Fecha de Recepción" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Fecha de Registro" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Fecha de Respuesta" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Fecha de Cierre" Value="4"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <div style="display: block">
                            <asp:CompareValidator ID="cvRangoFecha" runat="server" ControlToCompare="txtFechaInicial"
                                ControlToValidate="txtFechaFinal" Display="Dynamic" ErrorMessage="La Fecha Final debe ser mayor o igual a la Fecha Inicial"
                                Operator="GreaterThanEqual" Type="Date" ValidationGroup="buscarCaso"></asp:CompareValidator>
                        </div>
                        <div style="display: block">
                            <asp:CustomValidator ID="cusRango" runat="server" ClientValidationFunction="ValidarDatos"
                                ControlToValidate="txtFechaInicial" Display="Dynamic" ErrorMessage="Es necesario especificar los dos valores del Rango"
                                ValidationGroup="buscarCaso"></asp:CustomValidator>
                        </div>
                        <asp:CustomValidator ID="cusSeleccion" runat="server" ClientValidationFunction="ValidarDatos"
                            Display="Dynamic" Enabled="false" ErrorMessage="Seleccione un filtro de búsqueda, por favor"
                            ValidationGroup="buscarCaso"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="6">
                        <br />
                        <asp:UpdatePanel ID="upGeneral" runat="server" UpdateMode="Always" ChildrenAsTriggers="true">
                            <ContentTemplate>
                                <asp:LinkButton ID="lbDescargar" runat="server" ont-Bold="True" Font-Size="Small" ValidationGroup="buscarCaso"
                                    ForeColor="Green"><img src="../images/find.gif" alt="" />&nbsp;Exportar Casos </asp:LinkButton>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search"><img src="../images/unfunnel.png" alt="" />&nbsp;Quitar Filtros</asp:LinkButton>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <dx:ASPxButton ID="btnExportador" runat="server" ClientInstanceName="btnExportador"
                            ClientVisible="false" OnClick="btnExportador_Click" Width="0px" Height="0px" />

                    </td>
                </tr>
            </table>
            <br />
            <br />
        </asp:Panel>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="loadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
