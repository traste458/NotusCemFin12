<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteDeTransmisionesTransportadoras.aspx.vb"
    Inherits="BPColSysOP.ReporteDeTransmisionesTransportadoras" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte de Transmisiones para Transportadoras</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }
        function EsListadoEntregaConsultarValido(source, args) {
            var lista = document.getElementById("txtEntrega").value.trim();
            try {
                if (lista.length > 0) {
                    var arrEntrega = lista.split("\n");
                    var expReg = /^[0-9]{1,12}$/
                    var valor = "";
                    args.IsValid = true;
                    if (arrEntrega.length == 1) { arrEntrega = lista.split(",") }
                    for (i = 0; i < arrEntrega.length; i++) {
                        valor = arrEntrega[i].trim();
                        if (valor.trim().length > 0 && !expReg.test(valor.trim())) {
                            args.IsValid = false;
                            break;
                        }
                    }
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar el listado de entregas especificado para consulta.\n" + e.description);
            }
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <eo:CallbackPanel ID="cpNotificacion" runat="server" Width="100%" UpdateMode="Always">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true">
        <table class="tabla">
            <tr>
                <th colspan="4">
                    <img src="../images/find.gif" alt="" />&nbsp;Filtros de B&uacute;squeda
                </th>
            </tr>
            <tr>
                <td class="field">
                    Transportadora:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTransportadora" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvTransportadora" runat="server" ControlToValidate="ddlTransportadora"
                            ErrorMessage="Seleccione una transportadora, por favor" ValidationGroup="filtrado"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </td>
                <td class="field" rowspan="3">
                    No. Entrega:
                </td>
                <td rowspan="3" valign="top">
                    <asp:TextBox ID="txtEntrega" runat="server" Rows="5" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Cuenta:
                </td>
                <td>
                    <asp:DropDownList ID="ddlCuenta" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvCuenta" runat="server" ControlToValidate="ddlCuenta"
                            ErrorMessage="Seleccione una cuenta (código de cliente), por favor" ValidationGroup="filtrado"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Fecha Despacho:
                </td>
                <td style="vertical-align: middle">
                    De:
                    <input id="txtFechaInicial" runat="server" class="textbox" name="txtFechaInicial"
                        readonly="readonly" size="11" />&nbsp;&nbsp;<a hidefocus="" href="javascript:void(0)"
                            onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicial,document.form1.txtFechaFinal);return false;">
                            <img align="absMiddle" alt="Seleccione una Fecha Inicial" border="0" class="PopcalTrigger"
                                src="../images/calendar.png" /></a> &nbsp;&nbsp; Hasta:&nbsp;&nbsp;<input id="txtFechaFinal"
                                    runat="server" class="textbox" name="txtFechaFinal" readonly="readonly" size="11" />
                    <a hidefocus="" href="javascript:void(0)" onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicial,document.form1.txtFechaFinal);return false;">
                        <img align="absMiddle" alt="Seleccione una Fecha Final" border="0" class="PopcalTrigger"
                            src="../images/calendar.png" /></a>&nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <div style="display: block;">
                        <asp:CustomValidator ID="cusListaEntrega" runat="server" ErrorMessage="El listado de entregas contiene registros con formato y/o longitud no válidos"
                            ClientValidationFunction="EsListadoEntregaConsultarValido" Display="Dynamic"
                            ControlToValidate="txtEntrega" ValidationGroup="filtrado"></asp:CustomValidator>
                    </div>
                    <br />
                    <center>
                        <asp:LinkButton ID="lbConsultar" runat="server" CssClass="search" ValidationGroup="filtrado"><img src="../images/filtro.png" alt=""/>&nbsp;Consultar</asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;&nbsp;<asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search"><img src="../images/unfunnel.png" alt=""/>&nbsp;Quitar Filtros</asp:LinkButton></center>
                </td>
            </tr>
        </table>
    </eo:CallbackPanel>
    <br />
    <eo:CallbackPanel ID="cpResultado" runat="server" Width="100%" UpdateMode="Self"
        ChildrenAsTriggers="true" Triggers="{ControlID:lbConsultar;Parameter:}">
        <asp:Panel ID="pnlResultado" runat="server">
            <table class="tabla">
                <tr>
                    <td>
                        <asp:LinkButton ID="lbExportar" runat="server" Font-Bold="true">
                            <asp:Image ID="imgExportar" runat="server" />&nbsp;Exportar Datos</asp:LinkButton>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:GridView ID="gvResultado" runat="server" AllowPaging="True" PageSize="300">
                            <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </eo:CallbackPanel>
    <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
</body>
</html>
