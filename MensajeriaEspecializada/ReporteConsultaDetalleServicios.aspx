<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteConsultaDetalleServicios.aspx.vb" Inherits="BPColSysOP.ReporteConsultaDetalleServicios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script type="text/javascript">

    function EjecutarCallbackGeneral(s, e, parametro) {
        if (ASPxClientEdit.AreEditorsValid()) {
            loadingPanel.Show();
            cpGeneral.PerformCallback(parametro);

        }
    }
    function MostrarInfoEncabezado(s, e) {
        if (s.cpMensaje) {
            $('#divEncabezado').html(s.cpMensaje);
            if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
            }
        }
        }
    function VerEjemploTxt(ctrl) {
                window.open( 'Plantillas/EjemploConsultaReporteSerialesAsociados.txt');
            }
</script>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<head runat="server">
    <title>Reporte Detalle de Servicios</title>
</head>
<body>
        <form id="form1" runat="server">
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s, e) { loadingPanel.Hide(); }" />
        </dx:ASPxCallback>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            <br />
        </div>
        <div>
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
                <ClientSideEvents EndCallback="function(s, e) { ExportarArchivo(s,e); }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxHiddenField ID="hdRuta" runat="server" ClientInstanceName="hdRuta"></dx:ASPxHiddenField>
                        <script type="text/javascript">

                            function ExportarArchivo(sender, args) {
                                loadingPanel.Hide();
                                if (hdRuta.Get('Ruta') != "0") {
                                    btnExportador.DoClick();
                                }
                                else {
                                    MostrarInfoEncabezado(sender, args);
                                }
                            }
                        </script>
                        <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtros de B&uacute;squeda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxPanel ID="pnlFiltros" runat="server" Width="100%" ClientInstanceName="pnlFiltros">
                                        <Paddings Padding="0px" />
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <table>
                                                    <tr>                                                       
                                                        <td>
                                                            <div>
                                                                <dx:ASPxLabel runat="server" ID="lbTxtx" Text="Tipo Cargue"></dx:ASPxLabel>
                                                            </div>
                                                            <dx:ASPxRadioButtonList ID="rdBtnTipoCargue" ClientInstanceName="rdBtnTipoCargue" runat="server" RepeatDirection="Horizontal" Width="50%" Paddings-Padding="0">
                                                                <Paddings Padding="0px"></Paddings>
                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="CargueServicios">
                                                                    <RequiredField ErrorText="Información Requerida" IsRequired="True" />
                                                                </ValidationSettings>
                                                                <Items>
                                                                    <dx:ListEditItem Text="idServicio" Value="1"  Selected ="true"  />
                                                                    <dx:ListEditItem Text="Radicado" Value="2" />                                                                    
                                                                </Items>
                                                                <Border BorderColor="Transparent" />
                                                            </dx:ASPxRadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:FileUpload ID="fuArchivo" runat="server" Width="370px" ValidationGroup="CargueServicios" />
                                                            <br />
                                                            
                                                            <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                                                            CssClass="listSearchTheme" BackColor="Red" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivo" Display="Dynamic"
                                                            ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.txt|.csv)$" ValidationGroup="CargueServicios"></asp:RegularExpressionValidator>

                                                        <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                                                            ControlToValidate="fuArchivo" Display="Dynamic" ValidationGroup="CargueServicios" />
                                                            
                                                            <br />
                                                            <a href="javascript:void(0);" id="VerEjemplo" onclick="javascript:VerEjemploTxt((this));"><font color="#0000ff">(Ver archivo Ejemplo)</font></a>

                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                                <table style="margin: auto;">                                                    
                                                    <tr>
                                                        <td style="white-space: nowrap; text-align: center">
                                                            <dx:ASPxButton ID="btnBuscar" runat="server" Text="Descargar información " Style="display: inline!important;"
                                                                AutoPostBack="false" ValidationGroup="CargueServicios">
                                                                <Image Url="~/images/Excel.gif">
                                                                </Image>
                                                               
                                                            </dx:ASPxButton>
                                                        </td>
                                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar"
                                                                Style="display: inline!important;" AutoPostBack="false">
                                                                <Image Url="../images/cancelar.png">
                                                                </Image>
                                                                <ClientSideEvents Click="function(s, e) { LimpiarFiltros(s,e); }" />
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <dx:ASPxButton ID="btnExportador" runat="server" ClientInstanceName="btnExportador"
                                                                ClientVisible="false" OnClick="btnExportador_Click" Width="0px" Height="0px">
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <div style="clear: both;">
                                                </div>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxPanel>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </dx:PanelContent>
                </PanelCollection>
                <LoadingDivStyle CssClass="modalBackground"></LoadingDivStyle>
            </dx:ASPxCallbackPanel>
        </div>
        <dx:ASPxLoadingPanel ID="loadingPanel" runat="server" ClientInstanceName="loadingPanel" Modal="True"></dx:ASPxLoadingPanel>
    </form>

</body>
</html>
