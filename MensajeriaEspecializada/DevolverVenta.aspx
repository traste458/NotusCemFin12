<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DevolverVenta.aspx.vb" Inherits="BPColSysOP.DevolverVenta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div>
            <asp:Panel ID="pnlDevolucionVenta" runat="server">
                <table align="center">
                    <tr>
                        <td class="field">Tipo de Novedad:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTipoNovedadDevolucion" runat="server" />
                            <asp:RequiredFieldValidator ID="rfvddlTipoNovedadDevolucion" runat="server" ValidationGroup="vgDevolucion"
                                InitialValue="0" ControlToValidate="ddlTipoNovedadDevolucion" ErrorMessage="Seleccione un tipo de novedad."
                                Display="Dynamic" />
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Observación:
                        </td>
                        <td>
                            <asp:TextBox ID="txtObservacionDevolucion" runat="server" Rows="5" Columns="30" TextMode="MultiLine" />
                            <asp:RequiredFieldValidator ID="rfvtxtObservacionDevolucion" runat="server" ValidationGroup="vgDevolucion"
                                Display="Dynamic" ControlToValidate="txtObservacionDevolucion" ErrorMessage="Ingrese una observación." />
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="btnDevolverVenta" runat="server" Text="Devolver" CssClass="search"
                                ValidationGroup="vgDevolucion" />
                            <dx:ASPxHyperLink ID="lbAbortarModificacion1" runat="server" ImageUrl="~/images/arrow-turn.gif" Text="Cancelar" ToolTip="Cancelar" CausesValidation="false">
                                    <ClientSideEvents Click="function(s, e){
                                                          window.history.back();                                                 
                                                }" />
                                </dx:ASPxHyperLink>
                            <asp:HiddenField ID="hfIdServicio" runat="server" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
