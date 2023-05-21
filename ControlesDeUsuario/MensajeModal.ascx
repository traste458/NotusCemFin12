<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="MensajeModal.ascx.vb" Inherits="BPColSysOP.MensajeModal" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>
<asp:HiddenField ID="hfControlMensajeInfo" runat="server" />
<cc1:ModalPopupExtender ID="mpeControlMensajeInfo" BackgroundCssClass="modalBackground" 
            runat="server" TargetControlID="hfControlMensajeInfo" CancelControlID="imgBtnCerrarPopUpMensajeInfo" PopupControlID="pnlMensajeInfo">
</cc1:ModalPopupExtender>
<asp:Panel ID="pnlMensajeInfo" runat="server" CssClass="modalPopUp" style="width:500px;display:none;">
        <div style="text-align: right;">
            <asp:ImageButton ID="imgBtnCerrarPopUpMensajeInfo" runat="server" ImageUrl="~/images/cerrar.gif" />
        </div>
        <div style="padding:20px;">
            <asp:Image ID="imgMensajeInfo" runat="server" 
                ImageUrl="~/images/alertMsg.png" style="border-width: 0;float: left;padding-right: 20px;" />            
            <span>
                <asp:Label ID="lblMensajeInfo" runat="server" Text="Label"></asp:Label>
            </span>
        </div>    
        <div style="clear:both;padding-top:25px;text-align:center;">
            <asp:Button ID="btnAceptarMensajeInfo" CssClass="search" runat="server" Text="Aceptar" />            
        </div>
        </asp:Panel>  
   