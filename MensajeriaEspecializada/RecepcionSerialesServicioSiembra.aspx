<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecepcionSerialesServicioSiembra.aspx.vb"
    Inherits="BPColSysOP.RecepcionSerialesServicioSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Recepción Seriales SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ProcesarRadicado(s, e) {
            cpRecepcion.PerformCallback('buscarServicio|' + txtServicio.GetValue());
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function RecibirSerial(s, e) {
            if (txtSerial.GetValue().length > 0) {
                cpRecepcion.PerformCallback('recibirSerial|' + txtSerial.GetValue());
            }
        }

        function CerrarServicio(s, e) {
            cpRecepcion.PerformCallback('cerrarServicio|' + txtServicio.GetValue());
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpRecepcion" runat="server" ClientInstanceName="cpRecepcion">
        <ClientSideEvents EndCallback="function(s, e) {
                if (s.cpMensaje) {
                    $('#divEncabezado').html(s.cpMensaje);
                }
            }" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxRoundPanel ID="rpServicio" runat="server" HeaderText="Servicio SIEMBRA">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table>
                                <tr>
                                    <td>
                                        Número de Servicio:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtServicio" runat="server" Width="170px" ClientInstanceName="txtServicio"
                                            onkeypress="javascript:return ValidaNumero(event);">
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center">
                                        <dx:ASPxButton ID="btnProcesar" runat="server" Text="Procesar Radicado" Width="200px"
                                            HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False">
                                            <ClientSideEvents Click="function(s, e) {
                                                            ProcesarRadicado(s, e);
                                                        }"></ClientSideEvents>
                                            <Image Url="../images/find.gif">
                                            </Image>
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
                <div style="float: left">
                    <dx:ASPxRoundPanel ID="rpSeriales" runat="server" HeaderText="Recepción Seriales"
                        Style="margin-top: 10px;">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td>
                                            Serial:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtSerial" runat="server" Width="170px" ClientInstanceName="txtSerial"
                                                AutoPostBack="false">
                                                <ClientSideEvents KeyPress="function(s, e) {
                                                    if(e.htmlEvent.keyCode == 13) {
                                                        btnRecibirSerial.DoClick();
                                                        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                    }    
                                                }"></ClientSideEvents>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td align="right">
                                            <dx:ASPxButton ID="btnRecibirSerial" runat="server" Text="Recibir Serial" Width="150px"
                                                ClientInstanceName="btnRecibirSerial" HorizontalAlign="Center" Style="display: inline"
                                                AutoPostBack="False" CausesValidation="False">
                                                <ClientSideEvents Click="function(s, e) {
                                                    RecibirSerial(s, e);
                                                }"></ClientSideEvents>
                                                <Image Url="../images/add.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" align="center">
                                            <dx:ASPxGridView ID="gvSeriales" runat="server" AutoGenerateColumns="False">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Serial" VisibleIndex="0"
                                                        FieldName="Serial">
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                            </dx:ASPxGridView>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
                <div style="float: left; margin-left: 20px; margin-top: 20px;">
                    <dx:ASPxRoundPanel ID="rpDetalleSeriales" runat="server" HeaderText="Información de Seriales">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvInfoSeriales" runat="server" AutoGenerateColumns="False">
                                    <Columns>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="MSISDN" VisibleIndex="0"
                                            FieldName="Msisdn">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Serial" VisibleIndex="0"
                                            FieldName="Serial">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Estado" VisibleIndex="0"
                                            FieldName="EstadoSerial">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Estado Devolucion"
                                            VisibleIndex="0" FieldName="EstadoDevolucion">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                </dx:ASPxGridView>
                                <dx:ASPxButton ID="btnCerrarServicio" runat="server" Text="Cerrar Servicio" Width="150px"
                                    ClientInstanceName="btnRecibirSerial" HorizontalAlign="Center" Style="display: inline"
                                    AutoPostBack="False" CausesValidation="False" ClientEnabled="false">
                                    <ClientSideEvents Click="function(s, e) {
                                                    CerrarServicio(s, e);
                                                }"></ClientSideEvents>
                                    <Image Url="../images/Closed.png">
                                    </Image>
                                </dx:ASPxButton>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>
    </form>
</body>
</html>
