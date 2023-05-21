<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ModalProgress.ascx.vb" Inherits="BPColSysOP.ModalProgress" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script type="text/javascript" language="javascript">
    var ModalProgress = '<%= ModalProgress.ClientID %>';
    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginReq);
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endReq);

    function beginReq(sender, args) {
        // muestra el popup
        $find(ModalProgress).show();
    }
    function endReq(sender, args) {
        //  esconde el popup
        $find(ModalProgress).hide();
      
    }
     

      
</script>

<asp:Panel ID="PanelUpdateProgress" runat="server" CssClass="updateProgress" Style="display: none;">
    <div id="divProgress" style="position: relative; padding-top: 10px; text-align: center;">
        <asp:Image ID="imgProgress" runat="server" ImageUrl="~/images/progress_purple.gif" />
        <br />Cargando...
    </div>
</asp:Panel>
<cc1:ModalPopupExtender ID="ModalProgress" runat="server"  BackgroundCssClass="modalBackground"
    PopupControlID="PanelUpdateProgress" TargetControlID="PanelUpdateProgress">
</cc1:ModalPopupExtender>
