<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NotificationControl.ascx.vb" Inherits="BPColSysOP.NotificationControl" %>
   
<div>
    <table width="90%">
        <tr>
            <td>
                <asp:Label ID="lblTitle" runat="server" Font-Bold="True" Font-Names="Arial" 
                    Font-Size="14pt" Visible="false"></asp:Label>
                <asp:Literal ID="ltDivision" runat="server" Text="<hr/>" Visible="false"></asp:Literal>
                <asp:Panel ID="pnlRegresar" runat="server" Visible="False" style="margin-top: 15px; margin-bottom:15px" ToolTip="Regresar">
                    <asp:HyperLink ID="hlRegresar" runat="server">
                        <asp:Image ID="imgReturn" runat="server" ImageUrl="~/images/arrow-turn.png"/>Regresar</asp:HyperLink>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td align="center">
                <asp:Label ID="lblError" runat="server" CssClass="error" Visible="false"></asp:Label>
                <asp:Label ID="lblWarning" runat="server" CssClass="warning" Visible="false"></asp:Label>
                <asp:Label ID="lblSuccess" runat="server" CssClass="ok" Visible="false"></asp:Label>
            </td>
        </tr>
    </table>
</div>