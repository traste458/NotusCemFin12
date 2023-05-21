<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EncabezadoPagina.ascx.vb"
    Inherits="BPColSysOP.EncabezadoPagina" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>


<div>
    <table width="90%">
        <tr>
            <td>
                <asp:Label ID="lblTitle" runat="server" Font-Bold="True" Font-Names="Segoe UI" 
                    Font-Size="14pt" Visible="false"></asp:Label>
                <asp:Literal ID="ltDivision" runat="server" Text="<hr/>" Visible="false"></asp:Literal>
                <div style="float:left; width:15%; vertical-align:middle">
                    <asp:Panel ID="pnlRegresar" runat="server" Visible="False" style="margin-top: 10px; margin-bottom:10px">
                        <img alt = "regresar" src="../images/arrow-turn.gif" />
                        <asp:HyperLink ID="hlRegresar" runat="server">Regresar</asp:HyperLink>
                    </asp:Panel>
                </div>
                <div id="divMensajes" style="float:right; text-align:center; width:80%; vertical-align:middle;margin-top: 10px; margin-bottom:10px">
                    <asp:Label ID="lblError" runat="server" CssClass="error" Visible="false"></asp:Label>
                    <asp:Label ID="lblWarning" runat="server" CssClass="warning" Visible="false"></asp:Label>
                    <asp:Label ID="lblSuccess" runat="server" CssClass="ok" Visible="false"></asp:Label>
                </div>
            </td>
        </tr>
    </table>
</div>
