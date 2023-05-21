﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecepcionEquiposServicioTecnico.aspx.vb" Inherits="BPColSysOP.RecepcionEquiposServicioTecnico" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
    
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Recepción Equipos Servicio Técnico - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
        
        function ProcesarEnter(ctrl) {
            var btn;
            var kCode = (event.keyCode ? event.keyCode : event.which);
            if (kCode.toString() == "13") {
                switch(ctrl.id){
                    case 'txtNumeroRadicado':
                        btn = document.getElementById("lbProcesarRadicado");  
                        break;
                    case 'txtImei':
                        btn = document.getElementById("lbRecibirImei");  
                        break;
                }
                DetenerEvento(event);                
                btn.click();
            }
        }
        
        function validarImeis() {
            try {
                var items = $('#gvIMEIS input:checkbox');
                var itemsCheckeds = $('#gvIMEIS input:checkbox:checked');
                var itemsRecibidos = parseInt($('#lbImeisRecibidos').html());
                
                if(items.length==itemsCheckeds.length) {
                    return true;
                } else {
                    if(itemsCheckeds.length=itemsRecibidos) {
                        return confirm('No se han recibido todos los IMEIs asociados al servicio.\n\n¿Desea continuar de todos modos?.\nEsto generará una novedad automática al servicio.');
                    } else {
                        alert('Existen reportados [' + itemsRecibidos + '] IMEIs como recibidos, se debe registrar la misma cantidad de IMEIs.');
                        return false;
                    }
                }
            } catch(e) {
                return false;
                alert("Error al validar los IMEIS: " + e.description);
            }
        }

    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
        <eo:CallbackPanel ID="cpEncabezado" runat="server" UpdateMode="Always" Width=" 98%">
            <asp:UpdatePanel ID="upEncabezado" runat="server">
                <ContentTemplate>
                    <uc1:EncabezadoPagina ID="epEncabezado" runat="server" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" Width="100%">
            
            <asp:Panel ID="pnlRadicado" runat="server">
                <table class="tablaGris" cellpadding="2" style="float:left; margin-right:30px">
                    <tr>
                        <th colspan="2">
                            Información del Servicio Técnico
                        </th>
                    </tr>
                    <tr>
                        <td class="alterColor">Número de Radicado:</td>
                        <td>
                            <asp:TextBox ID="txtNumeroRadicado" runat="server" MaxLength="8"
                                onkeypress="javascript:return ValidaNumero(event)" onkeydown="ProcesarEnter(this);" />
                            <br />
                            <asp:RequiredFieldValidator ID="rfvtxtNumeroRadicado" runat="server" ErrorMessage="Se debe ingresar el número de radicado."
                                ControlToValidate="txtNumeroRadicado" ValidationGroup="vgRadicado" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:LinkButton ID="lbProcesarRadicado" runat="server" CssClass="search" 
                                Font-Bold="True" CausesValidation="true" ValidationGroup="vgRadicado">
                                <img alt="Procesar Radicado" src="../images/view.png" />&nbsp;Procesar Radicado
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
            <asp:Panel ID="pnlRegistarImei" runat="server" Visible="false">
                <table class="tablaGris" cellpadding="2" style="float:left; margin-right:30px">
                    <tr>
                        <th colspan="2">
                            Registro de IMEIS recibidos
                        </th>
                    </tr>
                    <tr>
                        <td class="alterColor">IMEIs reportados como Recibidos (WAP):</td>
                        <td align="center">
                            <asp:Label id="lbImeisRecibidos" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="alterColor">IMEI:</td>
                        <td>
                            <asp:TextBox ID="txtImei" runat="server" MaxLength="16"
                                onkeypress="javascript:return ValidaNumero(event)" onkeydown="ProcesarEnter(this);" />
                            <br />
                            <asp:RequiredFieldValidator ID="rfvtxtImei" runat="server" ErrorMessage="Se debe ingresar un IMEI."
                                ControlToValidate="txtImei" ValidationGroup="vgImeis"/>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:LinkButton ID="lbRecibirImei" runat="server" CssClass="search" 
                                Font-Bold="True" CausesValidation="true" ValidationGroup="vgImeis">
                                <img alt="Procesar Radicado" src="../images/add.png" />&nbsp;Recibir IMEI
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
            <asp:Panel ID="pnlImeis" runat="server" Visible="false">
                <table class="tablaGris" cellpadding="2" style="clear:both; margin-top:100px">
                    <tr>
                        <td align="center">
                            <asp:GridView ID="gvIMEIS" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                EmptyDataText="&lt;h3&gt;No hay registros para mostrar&lt;/h3&gt;" Width="100%">
                                <AlternatingRowStyle CssClass="alterColor" />
                                <FooterStyle CssClass="footer" />
                                <Columns>
                                    <asp:BoundField DataField="idDetalle" HeaderText="ID" />
                                    <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                    <asp:BoundField DataField="Serial" HeaderText="IMEI" />
                                    <asp:CheckBoxField DataField="recibido" HeaderText="Recibido" ItemStyle-HorizontalAlign="Center" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:LinkButton ID="lbGuardar" runat="server" CssClass="search" Font-Bold="True" OnClientClick="return validarImeis()">
                                <img alt="Guardar IMEIS" src="../images/save_all.png" />&nbsp;Guardar IMEIS
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