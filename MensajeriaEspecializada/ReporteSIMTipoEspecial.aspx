<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteSIMTipoEspecial.aspx.vb" Inherits="BPColSysOP.ReporteSIMTipoEspecial" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager" runat="server">
        </asp:ScriptManager>
        
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="false"
            LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlFiltro" runat="server">
            
                <table class="tablaGris" style="width: auto; float:left; margin-right:100px;">
                    <tr>
                        <td colspan="4" style="text-align: center" class="thGris">
                            INGRESE LOS DATOS PARA CONSULTA
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table style="padding: 0px !important">
                                <tr>
                                    <td>
                                        De:&nbsp;&nbsp;
                                    </td>
                                    <td valign="middle">
                                        <input class="textbox" id="txtFechaInicial" readonly="readonly" size="11" name="txtFechaInicial"
                                            runat="server" />
                                    </td>
                                    <td valign="middle">
                                        <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.formPrincipal.txtFechaInicial,document.formPrincipal.txtFechaFinal);return false;"
                                            href="javascript:void(0)">
                                            <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Inicial" src="../include/DateRange/calbtn.gif"
                                                width="34" align="middle" border="0"></a>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        Hasta:&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <input class="textbox" id="txtFechaFinal" readonly="readonly" size="11" name="txtFechaFinal"
                                            runat="server" />
                                    </td>
                                    <td>
                                        <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.formPrincipal.txtFechaInicial,document.formPrincipal.txtFechaFinal);return false;"
                                            href="javascript:void(0)">
                                            <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                                width="34" align="middle" border="0"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <br />
                            <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Filtrar Reportes" src="../images/filtro.png" />Filtrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Quitar filtro" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                            <br />
                        </td>
                    </tr>
                </table>
                
                <table class="tablaGris" style="width: auto; float:left" cellpadding="2">
                    <tr>
                        <td colspan="2" style="text-align: center" class="thGris">
                            GENERAR INFORMACIÓN
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:LinkButton ID="lbGenerarReporte" runat="server" CssClass="search" Font-Bold="true">
                                <img alt="Generar reporte" src="../images/engranaje.jpg" /> Generar Reporte
                            </asp:LinkButton>
                        </td>
                        <td>
                            <asp:LinkButton ID="lbReporteControl" runat="server" CssClass="search" Font-Bold="true">
                                <img alt="Ver Reporte de Control" src="../images/Excel.gif" /> Ver Reporte de Control
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />

            <div style="clear:both; margin-top:100px;">
                <asp:Panel ID="pnlResultados" runat="server" >
                <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                        EmptyDataText="No existen elementos para los filtros de búsqueda." HeaderStyle-HorizontalAlign="Center"
                        PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="2" 
                        CellSpacing="2" AllowSorting="True">
                        <PagerSettings Mode="NumericFirstLast" />
                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <AlternatingRowStyle CssClass="alterColor" />
                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                        <Columns>
                            <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:g}" />
                            <asp:BoundField DataField="nombreArchivo" HeaderText="Archivo" />
                            <asp:BoundField DataField="tercero" HeaderText="Usuario Generación" />
                            
                            <asp:TemplateField HeaderText="Opciones">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbExportar" runat="server" CommandName="Exportar" CommandArgument='<%# Bind("idReporte") %>'
                                        ToolTip="Descargar archivo">
                                    <img alt="Descargar archivo" border="0" src="../images/Excel.gif"></img></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
            </asp:Panel>
            </div>
            
        </eo:CallbackPanel>
        
        <uc2:Loader ID="ldrWait" runat="server" />
        
        <!-- iframe para uso de selector de fechas -->
        <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
            position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
            frameborder="0" width="132" scrolling="no" height="142">
        </iframe>
    </form>
</body>
</html>
