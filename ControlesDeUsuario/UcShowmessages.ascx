<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UcShowmessages.ascx.vb"
    Inherits="BPColSysOP.UcShowmessages" %>
<link href="../../include/styleBACK.css" type="text/css" rel="stylesheet" />
<div>
    <dx:ASPxPopupControl ID="pcUcShowmessages1" runat="server" CloseAction="None" PopupHorizontalAlign="Center"
        PopupVerticalAlign="Middle" ClientInstanceName="pcShowmessages" HeaderText="" AllowDragging="True"
        Modal="True" EnableViewState="False" PopupHorizontalOffset="190" PopupVerticalOffset="90"
        ShowCloseButton="False">
        <SizeGripImage Width="11px" />
        <LoadingPanelImage Url="~/images/Loading.gif">
        </LoadingPanelImage>
        <ContentStyle VerticalAlign="Top">
        </ContentStyle>
        <ContentCollection>
            <dx:PopupControlContentControl ID="PopupControlContentControl3" runat="server">
                <dx:ASPxPanel ID="Panel3" runat="server" DefaultButton="btCreate">
                    <PanelCollection>
                        <dx:PanelContent ID="PanelContent2" runat="server">
                            <table class="tablaNormal" align="center">
                                <tr>
                                    <td class="style4">
                                        &nbsp;&nbsp; &nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" class="style4">
                                        <asp:Image ID="ImageInformacion" runat="server" ImageUrl="~/images/icn_alert.jpg"
                                            Height="29px" Width="30px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style4">
                                        &nbsp;&nbsp; &nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" class="style4">
                                        <dx:ASPxLabel ID="lblMensaje1" runat="server">
                                        </dx:ASPxLabel>
                                        <br />
                                    </td>

                                </tr>
                                <tr>
                                    <td class="style4">
                                        &nbsp;&nbsp; &nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" class="style4">
                                        <dx:ASPxLabel ID="lblAccion1" runat="server">
                                        </dx:ASPxLabel>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style4">
                                        &nbsp;&nbsp; &nbsp;&nbsp;
                                    </td>
                                </tr>
                                <dx:PanelContent ID="PanelContSiNo1" runat="server" Visible="False">
                                    <tr align="center">
                                        <td>
                                            <asp:Button ID="btSi" runat="server" Text=" SI " CssClass="boton" AutoPostBack="False">
                                            </asp:Button>
                                            &nbsp;&nbsp; &nbsp;&nbsp;
                                            <asp:Button ID="btNO" runat="server" Text="NO" CssClass="boton" AutoPostBack="False">
                                            </asp:Button>
                                        </td>
                                    </tr>
                                </dx:PanelContent>
                                <dx:PanelContent ID="PanelContAceptar1" runat="server" Visible="False">
                                    <tr align="center">
                                        <td>
                                            <dx:ASPxButton ID="btAceptar1" runat="server" CssClass="boton2" Text="Aceptar" AutoPostBack="False">
                                                <ClientSideEvents Click="function(s, e) { pcShowmessages.Hide(); }" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </dx:PanelContent>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</div>

