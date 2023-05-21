<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DevolucionParcialServicioMensajeria.aspx.vb" Inherits="BPColSysOP.DevolucionParcialServicioMensajeria" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
    <%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
    <%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Recepción Devolución Parcial - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ProcesarEnter() {
            var btn = document.getElementById("lbRegistrar");
            var kCode = (event.keyCode ? event.keyCode : event.which);

            if (kCode.toString() == "13") {
                DetenerEvento(event)
                btn.click();
            }
        }
        
         function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlRegistro" runat="server">
                <table class="tablaGris" style="width: auto;">
                     <tr>
                        <td colspan="4" style="text-align: center" class="thGris">
                            INGRESE LOS DATOS DE LA DEVOLUCIÓN PARCIAL
                        </td> 
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Número Radicado:
                        </td> 
                        <td align="left">
                            <asp:TextBox ID="txtNumeroRadicado" runat="server" TabIndex = "1" MaxLength ="10" onkeydown="ProcesarEnter();"></asp:TextBox>
                                 <div>
                                   <asp:RequiredFieldValidator ID="rfvNumeroRadicado" runat="server" ErrorMessage="Número de radicado Requerido"
                                        Display="Dynamic" ControlToValidate="txtNumeroRadicado" ValidationGroup="vgDevolucion"></asp:RequiredFieldValidator>
                                   <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                                        ControlToValidate="txtNumeroRadicado" ValidationGroup="vgDevolucion" ErrorMessage="El número del radicado digitado no es válido, por favor verifique"
                                        ValidationExpression="[0-9]{4,10}"></asp:RegularExpressionValidator>
                                 </div>
                        </td>   
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Novedad:
                        </td>
                        <td align="left">
                            <asp:DropDownList ID="ddlNovedad" runat="server">
                            </asp:DropDownList>
                            <div>
                                <asp:RequiredFieldValidator ID="rfvddlNovedad" runat="server" ErrorMessage="Seleccione un tipo de novedad"
                                    Display="Dynamic" ControlToValidate="ddlNovedad" ValidationGroup="vgDevolucion" InitialValue="0"></asp:RequiredFieldValidator>
                            </div>
                        </td> 
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <br />
                            <asp:LinkButton ID="lbRegistrar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgDevolucion">
                            <img alt="Registrar Devolucion Parcial" src="../images/save_all.png" />&nbsp;Registrar </asp:LinkButton>                        
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
        </eo:CallbackPanel>
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
