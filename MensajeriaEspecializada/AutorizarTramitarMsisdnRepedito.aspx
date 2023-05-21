<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AutorizarTramitarMsisdnRepedito.aspx.vb" Inherits="BPColSysOP.AutorizarTramitarMsisdnRepedito" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Autorizar MSISDN Repetido - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla= document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager" runat="server">
        </asp:ScriptManager>
    
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlPrincipal" runat="server">
                <table class="tablaGris" cellpadding="2" cellspacing="2">
                    <tr>
                        <th colspan="2">
                            Ingrese los datos de los radicados
                        </th>
                    </tr>
                    <tr>
                        <td class="field">Número de Radicado Existente:</td>
                        <td>
                            <asp:TextBox ID="txtRadicado1" runat="server" MaxLength="15" onkeypress="javascript:return ValidaNumero(event)" />
                            <span>
                                <asp:RequiredFieldValidator ID="rfvtxtRadicado1" runat="server" 
                                    ControlToValidate="txtRadicado1" ErrorMessage="El valor del radicado no es opcional." ValidationGroup="vgAutorizar" />
                            </span>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="field">Número de Radicado Adicional:</td>
                        <td>
                            <asp:TextBox ID="txtRadicado2" runat="server" MaxLength="15" onkeypress="javascript:return ValidaNumero(event)" />
                            <span>
                                <asp:RequiredFieldValidator ID="rfvtxtRadicado2" runat="server" 
                                    ControlToValidate="txtRadicado2" ErrorMessage="El valor del radicado no es opcional." ValidationGroup="vgAutorizar" />
                            </span>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" align="center">
                            <asp:LinkButton ID="lbAutorizar" runat="server" CssClass="search" CausesValidation="true" ValidationGroup="vgAutorizar" >
                                <img alt="Autorizar" src="../images/ok.png" />&nbsp;Autorizar
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
        </eo:CallbackPanel>
        
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>