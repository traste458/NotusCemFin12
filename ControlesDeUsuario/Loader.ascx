<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Loader.ascx.vb" Inherits="BPColSysOP.Loader" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<eo:Dialog ID="dlgWait" runat="server" BackShadeColor="Gray" BackShadeOpacity="50">
    <ContentTemplate>
        <table border="0" align="center" style="width: 98%; height: 98%">
            <tr>
                <td align="center">
                    <div id="divProgress" class="updateProgress" style="position: relative; padding-top: 10px;
                        text-align: center;">
                        <asp:Image ID="imgProgress" runat="server" ImageUrl="~/images/progress_purple.gif" />
                        <br />
                        Cargando...
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</eo:Dialog>
