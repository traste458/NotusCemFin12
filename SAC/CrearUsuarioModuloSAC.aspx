<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearUsuarioModuloSAC.aspx.vb"
    Inherits="BPColSysOP.CrearUsuarioModuloSAC" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Crear Usuario Módulo SAC</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
        <eo:CallbackPanel ID="cpGeneral" runat="server" ChildrenAsTriggers="True" AutoDisableContents="True">
            <uc3:EncabezadoPagina ID="epGeneral" runat="server" />
            <table class="tabla">
                <tr>
                    <th colspan="2">
                        Información del Usuario
                    </th>
                </tr>
                <tr>
                    <td class="field">
                        Nombre:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNombre" runat="server" Width="300px" MaxLength="100"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ErrorMessage="Nombre requerido. Por favor digite el nombre del usuario."
                                ControlToValidate="txtNombre" Display="Dynamic" ValidationGroup="guardar"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        E-Mail
                    </td>
                    <td>
                        <asp:TextBox ID="txtEmail" runat="server" Width="300px" MaxLength="100"></asp:TextBox>
                        <div style="display: block">
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ErrorMessage="El E-Mail proporcionado no es válido. por favor verifique"
                                Display="Dynamic" ControlToValidate="txtEmail" ValidationGroup="guardar" ValidationExpression="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <br />
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="submit" ValidationGroup="guardar" />
                    </td>
                </tr>
            </table>
        </eo:CallbackPanel>
    </div>
    </form>
</body>
</html>
