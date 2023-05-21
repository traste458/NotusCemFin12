<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarNovedadServicioMensajeria.aspx.vb" Inherits="BPColSysOP.RegistrarNovedadServicioMensajeria" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress" TagPrefix="uc3" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Registrar Novedad - Servicio Mensajería</title>
    
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
    
</head>
<body>
    <form id="formPrincipal" runat="server">
    
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    
    <eo:CallbackPanel ID="cpEncabezado" runat="server" UpdateMode="Always" Width=" 98%">
        <asp:UpdatePanel ID="upEncabezado" runat="server">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </eo:CallbackPanel>
    
    <eo:CallbackPanel ID="cpGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait"
        ChildrenAsTriggers="true" Width="100%">
        
        <asp:Panel ID="pnlRadicado" runat="server">
            <table class="tabla">
                <tr><th colspan="3">RADICADO</th></tr>
                <tr valign="middle">
                    <td class="field">Número de Radicado:</td>
                    <td>
                        <asp:TextBox ID="txtNoRadicado" runat="server" MaxLength="15"></asp:TextBox> <br />
                        <asp:RequiredFieldValidator ID="rfvtxtNoRadicado" runat="server" ControlToValidate ="txtNoRadicado" ValidationGroup="vgRadicado"
                            ErrorMessage ="Por favor ingrese un radicado." Text="Por favor ingrese un radicado." Display="Dynamic" />
                    </td>
                    <td>
                        <asp:LinkButton ID="lbAdicionarNovedad" runat="server" ValidationGroup="vgRadicado" 
                            CssClass="search" Font-Bold="True" CausesValidation="true">
                            <img alt="Guardar Servicio" src="../images/Notepad.gif" />Adicionar Novedad&nbsp;
                            </asp:LinkButton>
                        &nbsp;
                    </td>
                </tr>
                <tr valign="middle">
                    <td class="field">Novedad:</td>
                    <td>
                        <asp:DropDownList ID="ddlNovedad" runat="server">
                        </asp:DropDownList> <br />
                        <asp:RequiredFieldValidator ID="rfvddlNovedad" runat="server" ControlToValidate="ddlNovedad"
                            ErrorMessage="Por favor seleccione una novedad." InitialValue="0" Display="Dynamic" ValidationGroup="vgRadicado">
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        
    </eo:CallbackPanel>
    
    <uc2:Loader ID="ldrWait" runat="server" />
    
    </form>
</body>
</html>
