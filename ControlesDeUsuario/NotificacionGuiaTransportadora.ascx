<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NotificacionGuiaTransportadora.ascx.vb" Inherits="BPColSysOP.NotificacionGuiaTransportadora" %>

<%@ Register Src="~/ControlesDeUsuario/EncabezadoServicioTipoVentaCorporativa.ascx" TagPrefix="uc1" TagName="EncabezadoServicioTipoVentaCorporativa" %>

<script type="text/javascript">
    function DescargarArchivo(rutaAzure) {        
            cpSoporteNotificacion.PerformCallback(rutaAzure)
        }
</script>
<div>    
    <asp:Panel ID="pnlSoporteNotificacion" runat="server" Visible="true">
        <table class="tabla" style="width: 95%">
            <tr style="color: black; font-family: 'trebuchet ms'; font-size: 10pt; font-weight: bold; padding-bottom: 5px; padding-left: 8px; padding-right: 3px; padding-top: 0px;">
                <td>Información de soporte notificación transportadora</td>
            </tr>
            <tr>
                <td style="width: 45%" valign="top">
                    <dx:ASPxCallbackPanel ID="cpSoporteNotificacion" runat="server" ClientInstanceName="cpSoporteNotificacion" EnableAnimation="true">
                        <PanelCollection>
                            <dx:PanelContent>
                                <asp:GridView ID="gvSoporteNotificacion" runat="server" Width="100%" AutoGenerateColumns="false"
                                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen soportes de guías de transportadoras&lt;/i&gt;&lt;/blockquote&gt;" OnRowCommand="gvSoporteNotificacion_RowCommand">
                                            <Columns>
                                                <asp:BoundField DataField="Guia" HeaderText="Numero Guía" ItemStyle-HorizontalAlign="Center" Visible="true" >
                                                <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="FechaEntrega" HeaderText="Fecha Entrega" ItemStyle-HorizontalAlign="Center" >                                              
                                                <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha Registro" ItemStyle-HorizontalAlign="Center" >                                              
                                                <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="NombreArchivo" HeaderText="Archivo" ItemStyle-HorizontalAlign="Center" >                                              
                                                <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Opciones">
                                                     <ItemStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbDescargar" runat="server" AutoPostBack="false" ToolTip="Descargar Archivo" CommandArgument='<%# Eval("RutaAzure") %>'>
                                                            <asp:Image ID="imgDescargar" ImageUrl="~/images/descargar.png" runat="server" />
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>
                </td>
            </tr>
        </table>
    </asp:Panel>

</div>
