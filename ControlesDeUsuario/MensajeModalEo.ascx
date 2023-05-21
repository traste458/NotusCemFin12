<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="MensajeModalEo.ascx.vb" Inherits="BPColSysOP.MensajeModalEo" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<asp:HiddenField ID="hfControlMensajeInfo" runat="server" />
 <eo:Dialog runat="server" ID="mpeControlMensajeInfo" ControlSkinID="None" Height="330px"
                Width="500px" HeaderHtml="Confirmar Cambios" CloseButtonUrl="00020312" BackColor="White"
                CancelButton="btnAceptarMensajeInfo" BackShadeColor="Gray" BackShadeOpacity="50">
                <ContentTemplate>
                    <asp:Panel ID="pnlMensajeInfo" runat="server" CssClass="modalPopUp" Style="width: 500px;
                        display: none;">
                        <div style="text-align: right;">
                            <asp:ImageButton ID="imgBtnCerrarPopUpMensajeInfo" runat="server" ImageUrl="~/images/cerrar.gif" />
                        </div>
                        <div style="padding: 20px;">
                            <asp:Image ID="imgMensajeInfo" runat="server" ImageUrl="~/images/alertMsg.png" Style="border-width: 0;
                                float: left; padding-right: 20px;" />
                            <span>
                                <asp:Label ID="lblMensajeInfo" runat="server" Text="Label"></asp:Label>
                            </span>
                        </div>
                        <div style="clear: both; padding-top: 25px; text-align: center;">
                            <asp:Button ID="btnAceptarMensajeInfo" CssClass="search" runat="server" Text="Aceptar" />
                        </div>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                </BorderImages>
            </eo:Dialog>	