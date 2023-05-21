<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteDevolucionesCEM.aspx.vb" 
Inherits="BPColSysOP.ReporteDevolucionesCEM" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Reporte Devoluciones CEM</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        
        function ProcesarEnter() {

            var btn = document.getElementById("lbBuscar");
            var kCode = (event.keyCode ? event.keyCode : event.which);

            if (kCode.toString() == "13") {

                DetenerEvento(event)
                btn.click();

            }

        }
       
        
    </script>
    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            width: 1px;
        }
    </style>
</head>

<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="false"
        LoadingDialogID="ldrWait_dlgWait" >
        <table class="tablaGris" style="width: auto;">
        <asp:Panel ID="pnlRegistro" runat="server">
        <tr>
            <td colspan="4" style="text-align: center" class="thGris">
                INGRESE LOS DATOS DE BUSQUEDA
            </td> 
        </tr>
        <tr>
            <td class="field" align="left">
                Número Radicado
            </td> 
            <td align="left">
                <asp:TextBox ID="txtNumeroRadicado" runat="server" TabIndex = "1" MaxLength ="10" onkeydown="ProcesarEnter();"></asp:TextBox>
                     <div>
                       <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                            ControlToValidate="txtNumeroRadicado" ValidationGroup="vgDevolucion" ErrorMessage="El número del radicado digitado no es válido, por favor verifique"
                            ValidationExpression="[0-9]{7,10}"></asp:RegularExpressionValidator>
                     </div>
            </td>   
        </tr>
        <tr>
            <td class="field" align="left">
                Motorizado:
            </td>
            <td align="left">
                <asp:DropDownList ID="ddlMotorizado" runat="server">
                </asp:DropDownList>
            </td> 
            <td class="field">
                        <b>Fecha Devolución:</b>
                    </td>
                    <td style="vertical-align: middle" nowrap="nowrap">
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
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicial,document.form1.txtFechaFinal);return false;"
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
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicial,document.form1.txtFechaFinal);return false;"
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
                <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgDevolucion">
                                <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                        </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                        </asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td colspan="4" align="center">
                <br />
                <asp:LinkButton ID="lbDescargar" runat="server" CssClass="search" Font-Bold="True" Visible = "False">
                                <img alt="Descargar" src="../images/Excel.gif" /> Descargar
                        </asp:LinkButton>
            </td> 
        </tr>
        </asp:Panel> 
        </table>
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpdatosReporte" runat="server" UpdateMode="Conditional" >
        <table class="tablaGris">
            <tr>
                <td>
                    <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center">
                        <div style="text-align: center;">
                            <b>Resultado de la busqueda</b>
                            <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                                EmptyDataText="No hay resultados" HeaderStyle-HorizontalAlign="Center" PageSize="50"
                                ShowFooter="True">
                                <PagerSettings Mode="NumericFirstLast" />
                                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                <PagerStyle CssClass="field" HorizontalAlign="Center" />
                                <HeaderStyle HorizontalAlign="Center" />
                                <AlternatingRowStyle CssClass="alterColor" />
                                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                                <Columns>
                                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                                    <asp:BoundField DataField="numeroRadicado" HeaderText="NumeroRadicado" />
                                    <asp:BoundField DataField="fechaDevolucion" HeaderText="FechaDevolucion" />
                                    <asp:BoundField DataField="motorizado" HeaderText="Motorizado" />
                                </Columns>
                            </asp:GridView>
                        </div>
                        <br />
                        <br />
                        </asp:Panel>
           
                </td>
           </tr>
        </table> 
        </eo:CallbackPanel>
     
     <uc2:Loader ID="ldrWait" runat="server" />
     <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </div>
    </form>
</body>

</html>
