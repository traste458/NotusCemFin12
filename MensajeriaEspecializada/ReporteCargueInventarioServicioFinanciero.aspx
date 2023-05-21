<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteCargueInventarioServicioFinanciero.aspx.vb" Inherits="BPColSysOP.ReporteCargueInventarioServicioFinanciero" %>

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
    function LimpiarFiltros() {
        hdRuta.Set('Ruta', '0');
        deFechaLecturaInicial.SetValue(null);
        deFechaLecturaFinal.SetValue(null);
    }
    function MostrarInfoEncabezado(s, e) {
        if (s.cpMensaje) {
            $('#divEncabezado').html(s.cpMensaje);
            if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
            }
        }
    }
</script>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<head runat="server">
    <title>Reporte Cargue Inventario Servicio Financiero Tarjeta</title>
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
                                                        <td class="field">Fecha de Creación:
                                                        </td>
                                                        <td>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <dx:ASPxDateEdit ID="deFechaLecturaInicial" runat="server" ClientInstanceName="deFechaLecturaInicial"
                                                                            NullText="Seleccione..." Width="120px" ToolTip="Fecha Lectura Inicial" EnableClientSideAPI="true">
                                                                            <ClientSideEvents ValueChanged="function(s, e){deFechaLecturaFinal.SetMinDate(deFechaLecturaInicial.GetDate());}" />
                                                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" ValidationGroup="Filtrado">
                                                                                <RequiredField IsRequired="true" ErrorText="Fecha Inicial de Lectura Requerida" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxDateEdit>
                                                                    </td>
                                                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                    <td>
                                                                        <dx:ASPxDateEdit ID="deFechaLecturaFinal" runat="server" ClientInstanceName="deFechaLecturaFinal"
                                                                            NullText="Seleccione..." Width="120px" ToolTip="Fecha Lectura Final">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                if (deFechaLecturaInicial.GetDate()==null){
                                                                    deFechaLecturaInicial.SetMaxDate(deFechaLecturaFinal.GetDate());
                                                                }
                                                              }" />
                                                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" ValidationGroup="Filtrado">
                                                                                <RequiredField IsRequired="true" ErrorText="Fecha Final de Lectura Requerida" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxDateEdit>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                                <table style="margin: auto;">
                                                    <tr>
                                                        <td style="white-space: nowrap; text-align: center">
                                                            <dx:ASPxButton ID="btnBuscar" runat="server" Text="Descargar información " Style="display: inline!important;"
                                                                AutoPostBack="false" ValidationGroup="Filtrado">
                                                                <Image Url="~/images/Excel.gif">
                                                                </Image>
                                                                <ClientSideEvents Click="function(s, e) { EjecutarCallbackGeneral(s,e,'DescargarReporte'); }" />
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
