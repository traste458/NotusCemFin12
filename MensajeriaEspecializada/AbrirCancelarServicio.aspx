<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AbrirCancelarServicio.aspx.vb" Inherits="BPColSysOP.AbrirCancelarServicio" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
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
            <asp:Panel ID="pnlAuxiliar" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                <table align="center" class="tabla">
                    <asp:Panel ID="pnlMensajeRestriccionNovedad" runat="server">
                        <tr>
                            <td colspan="2">
                                <blockquote>
                                    <p>No es posible cerrar el radicado, por favor verifique que exista una novedad creada para el proceso actual y fecha de hoy.</p>
                                </blockquote>
                            </td>
                        </tr>
                    </asp:Panel>
                    <tr>
                        <td class="field">Observacion:
                        </td>
                        <td>
                            <asp:TextBox ID="txtObservacionModificacion" runat="server" Rows="6" Width="400px"
                                TextMode="MultiLine"></asp:TextBox>
                            <div>
                                <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ErrorMessage="Se requiere una observaci&oacute;n para continuar con el proceso"
                                    Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="txtObservacionModificacion"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <asp:Panel ID="pnlEstadoReapertura" runat="server">
                        <tr>
                            <td class="field">Estado de reapertura:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlEstadoReapertura" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="rfvddlEstadoReapertura" runat="server" ErrorMessage="El estado de reapertura es requerido."
                                        Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="ddlEstadoReapertura"
                                        InitialValue="0" />
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                    <tr>
                        <td colspan="2" align="center">
                            <asp:LinkButton ID="lbAbrirServicio" runat="server" CssClass="search" ValidationGroup="modificacionServicio"><img src="../images/unlock.png" alt=""/>&nbsp;Abrir Servicio</asp:LinkButton>
                            <asp:LinkButton ID="lbCancelarServicio" runat="server" CssClass="search" ValidationGroup="modificacionServicio"><img src="../images/package.png" alt=""/>&nbsp;Cerrar Servicio</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                <dx:ASPxHyperLink ID="lbAbortarModificacion1" runat="server" ImageUrl="~/images/cancelar.png" Text="Cancelar" ToolTip="Cancelar" CausesValidation="false">
                                    <ClientSideEvents Click="function(s, e){
                                                         window.location.href ='PoolServiciosNew.aspx';
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
