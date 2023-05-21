<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearOrdenDevolucionLogisticaInversa.aspx.vb"
    Inherits="BPColSysOP.CrearOrdenDevolucionLogisticaInversa" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Crear Orden Devolución Logistica Inversa</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

</head>
<body class="cuerpo2">
    <form id="frm" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
        <asp:HiddenField ID="hfIdRecoleccion" runat="server" />
        <table class="tablaGris" width="800">
            <tr>
                <th colspan="4">
                    Datos de la Órden
                </th>
            </tr>
            <tr>
                <td class="field">
                    ID Orden Recolección:
                </td>
                <td>
                    <asp:Label ID="lblOrdenRecoleccion" runat="server" Text=""></asp:Label>
                </td>
                <td class="field">
                    Transportadora:
                </td>
                <td>
                    <asp:Label ID="lblTransportadora" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Guia:
                </td>
                <td>
                    <asp:Label ID="lblGuia" runat="server" Text=""></asp:Label>
                </td>
                <td class="field">
                    Observación Recolección:
                </td>
                <td>
                    <asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Grupo de Devolución:
                </td>
                <td>
                    <asp:DropDownList ID="ddlGrupoDevolucion" runat="server">
                    </asp:DropDownList>
                    <div>
                        <asp:RequiredFieldValidator Display="Dynamic" ID="rfvGrupoDevolucion" InitialValue="0"
                            runat="server" ErrorMessage="Por favor seleccione,el grupo de devolución" ControlToValidate="ddlGrupoDevolucion">
                        </asp:RequiredFieldValidator>
                    </div>
                </td>
                <td class="field">
                    Observación:
                </td>
                <td>
                    <asp:TextBox ID="txtObservacion" runat="server" TextMode="MultiLine" Height="42px"
                        Width="262px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Origen</td>
                <td>
                    <asp:Label ID="lblOrigen" runat="server"></asp:Label>
                </td>
                <td class="field">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td colspan="4" align="center">
                <br />
                    <p>
                        <asp:LinkButton ID="lnkCrear" OnClientClick="return confirm('Desea establecer la devolucion con los datos proporcionados?');"
                            runat="server" CssClass="search">Continuar...</asp:LinkButton>
                    &nbsp;&nbsp;
                       <asp:LinkButton ID="lnkLeerDevolucion" ValidationGroup="lectura" 
                runat="server" CssClass="search" Visible="False"> <img alt="" src="../images/flecha_fwd.png" /> &nbsp;&nbsp;Leer Devolución</asp:LinkButton></p>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
