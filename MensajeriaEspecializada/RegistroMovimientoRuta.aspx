<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistroMovimientoRuta.aspx.vb"
    Inherits="BPColSysOP.RegistroSalidaLlegadaRuta" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registro Movimiento Ruta</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        LoadingDialogID="ldrWait_dlgWait">
        <asp:Panel ID="pnlPrincipal" runat="server">
            <table class="tablaGris" style="width: 50%;" cellpadding="3">
                <tr>
                    <td colspan="2" style="text-align: center" class="thGris">
                        INGRESE LOS DATOS PARA EL REGISTRO
                    </td>
                </tr>
                <%--<tr>
                    <td class="field" align="left">
                        Identificación Motorizado:
                    </td>
                    <td valign="middle">
                        <asp:TextBox ID="txtIdentificacion" runat="server" Width="200px" MaxLength="15"></asp:TextBox>
                        <div style="display: block;">
                            <asp:RequiredFieldValidator ID="rfvtxtIdentificacion" runat="server" ControlToValidate="txtIdentificacion"
                                Display="Dynamic" ErrorMessage="La identificación del motorizado es obligatoria."
                                ValidationGroup="vgRegistro"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revIdentificacion" runat="server" ErrorMessage="El número de Identificaci&oacute;n proporcionado no es v&aacute;lido. Se espera un valor num&eacute;rico de entre 4 y 15 d&iacute;gitos."
                                Display="Dynamic" ControlToValidate="txtIdentificacion" ValidationGroup="vgRegistro"
                                ValidationExpression="[0-9]{4,15}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>--%>
                <tr>
                    <td class="field" align="left">
                        Número de Ruta:
                    </td>
                    <td valign="middle">
                        <asp:TextBox ID="txtIdRuta" runat="server" Width="200px" MaxLength="10"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvtxtIdRuta" runat="server" ControlToValidate="txtIdRuta"
                                Display="Dynamic" ErrorMessage="El número de ruta es obligatorio." ValidationGroup="vgRegistro"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revRuta" runat="server" ErrorMessage="El número de Ruta proporcionado no es v&aacute;lido. Se espera un valor num&eacute;rico"
                                Display="Dynamic" ControlToValidate="txtIdRuta" ValidationGroup="vgRegistro"
                                ValidationExpression="[0-9]{1,10}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr align="center">
                    <td colspan="2" style="height: 30px;">
                        <asp:LinkButton ID="lbRegistrar" runat="server" CssClass="search" Font-Bold="True"
                            CausesValidation="true" ValidationGroup="vgRegistro">
                                <img alt="Filtrar Pedido" src="../images/save_all.png" />&nbsp;Registrar
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
