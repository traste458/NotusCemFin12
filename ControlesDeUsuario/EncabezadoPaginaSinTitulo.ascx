<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EncabezadoPaginaSinTitulo.ascx.vb"
    Inherits="BPColSysOP.EncabezadoPaginaSinTitulo" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<div>
    <table style="width: 100%; height: 30px">
        <tr>
            <td>
                <div id="divMensajes" style="float:left; text-align:center; width:100%; vertical-align:middle;margin-top: 1px; margin-bottom:1px;">
                    <asp:Label ID="lblError" runat="server" CssClass="error" Visible="false"></asp:Label>
                    <asp:Label ID="lblWarning" runat="server" CssClass="warning" Visible="false"></asp:Label>
                    <asp:Label ID="lblSuccess" runat="server" CssClass="ok" Visible="false"></asp:Label>
                </div>
            </td>
        </tr>
    </table>
</div>
