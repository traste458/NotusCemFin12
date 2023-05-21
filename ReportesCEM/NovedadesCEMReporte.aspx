<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NovedadesCEMReporte.aspx.vb" 
Inherits="BPColSysOP.NovedadesCEMReporte" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Novedades CEM</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">

        function esRangoValido(source, arguments) {
            try {
                if (document.getElementById("txtFechaInicial").value.trim() != "" || document.getElementById("txtFechaFinal").value.trim() != "") {
                    if (document.getElementById("txtFechaInicial").value.trim() != "" && document.getElementById("txtFechaFinal").value.trim() == "") {
                        arguments.IsValid = false;
                    } else {
                        if (document.getElementById("txtFechaInicial").value.trim() == "" && document.getElementById("txtFechaFinal").value.trim() != "") {
                            arguments.IsValid = false;
                        } else {
                            arguments.IsValid = true;
                        }
                    }
                } else {
                    arguments.IsValid = true;
                }
            } catch (e) {
                arguments.IsValid = false;
            }
        }
        function esFechaValida(source, arguments) {
            try {
                if (document.getElementById("txtFechaInicial").value.trim() == "" && document.getElementById("txtFechaFinal").value.trim() == "") {
                    arguments.IsValid = false;
                } else {
                    arguments.IsValid = true;
                }
            } catch (e) {
                arguments.IsValid = false;
            }
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        UpdateMode="Group" GroupName="general" LoadingDialogID="ldrWait_dlgWait">
        <asp:Panel ID="pnlFiltros" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <td colspan="9" style="text-align: center" class="thGris">
                        <b>INGRESE LOS DATOS PARA LA CONSULTA</b>
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        No. Radicado:
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtRadicado" runat="server" MaxLength="17"></asp:TextBox>
                        <div style="clear: both">
                            <asp:RegularExpressionValidator ID="revRadicado" runat="server" Display="Dynamic"
                                ControlToValidate="txtRadicado" ValidationGroup="vgFiltro" ErrorMessage="El valor digitado no es valido"
                                ValidationExpression="[0-9]{1,17}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field" align="left">
                        MSISDN:
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtMsisdn" runat="server" MaxLength="10">
                        </asp:TextBox>
                        <div style="clear: both">
                            <asp:RegularExpressionValidator ID="revMsisdn" runat="server" Display="Dynamic"
                                ControlToValidate="txtMsisdn" ValidationGroup="vgFiltro" ErrorMessage="El valor digitado no es valido"
                                ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field" align="left">
                        Tipo Servicio:
                    </td>
                    <td align="left">
                        <asp:DropDownList ID="ddlTipoServicio" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Ciudad:
                    </td>
                    <td align="left">
                        <asp:DropDownList ID="ddlCiudad" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field" align="left">
                        Bodega:
                    </td>
                    <td align="left">
                        <asp:DropDownList ID="ddlBodega" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field" align="left">
                        Sub Proceso:
                    </td>
                    <td align="left">
                        <asp:DropDownList ID="ddlSubProceso" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        <b>Fecha Novedad:</b>
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
                        <div style="clear: both">
                        <asp:CustomValidator ID="cusRango" runat="server" ErrorMessage="Es necesario especificar los dos valores del Rango"
                                    Display="Dynamic" ClientValidationFunction="esRangoValido" ValidationGroup="vgFiltro"></asp:CustomValidator>
                        <div style="clear: both">
                        <asp:CustomValidator ID="cusSeleccion" runat="server" ErrorMessage="La fecha de novedad es obligatroria"
                                    Display="Dynamic" ClientValidationFunction="esFechaValida" ValidationGroup="vgFiltro"></asp:CustomValidator>            
                    </div> 
                    </td>
                    <td class="field">
                        <b>Fecha Solución:</b>
                    </td>
                    <td style="vertical-align: middle" nowrap="nowrap">
                        <table style="padding: 0px !important">
                            <tr>
                                <td>
                                    De:&nbsp;&nbsp;
                                </td>
                                <td valign="middle">
                                    <input class="textbox" id="txtFechaInicialSolucion" readonly="readonly" size="11" name="txtFechaInicialSolucion"
                                        runat="server" />
                                </td>
                                <td valign="middle">
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicialSolucion,document.form1.txtFechaFinalSolucion);return false;"
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
                                    <input class="textbox" id="txtFechaFinalSolucion" readonly="readonly" size="11" name="txtFechaFinalSolucion"
                                        runat="server" />
                                </td>
                                <td>
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicialSolucion,document.form1.txtFechaFinalSolucion);return false;"
                                        href="javascript:void(0)">
                                        <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                            width="34" align="middle" border="0"></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="8">
                        <asp:LinkButton ID="lbFiltrar" runat="server" CssClass="submit" Font-Bold="True"
                            CausesValidation="True" ValidationGroup="vgFiltro">
                                        <img alt="Filtro" src="../images/filtro.png" />Filtrar
                        </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbBorrar" runat="server" CssClass="submit" Font-Bold="True" CausesValidation="False">
                                        <img alt="Borrar " src="../images/unfunnel.png" />Borrar Filtros
                        </asp:LinkButton>
                        <br />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpResultado" runat="server" Width="100%" UpdateMode="Group"
        GroupName="general" LoadingDialogID="ldrWait_dlgWait">
        <asp:Panel ID="panelReporte" runat="server">
            <asp:LinkButton ID="lbReporte" runat="server" CssClass="submit" Font-Bold="True"
                CausesValidation="False">
                    <img alt="Descargar" src="../images/Excel.gif" />Descargar Reporte
            </asp:LinkButton>
        </asp:Panel>
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpDatos" runat="server" Width="100%" UpdateMode="Group" 
        GroupName="general" LoadingDialogID="ldrWait_dlgWait" ChildrenAsTriggers="true">    
        <asp:Panel ID="panelResultado" runat="server">
            <asp:GridView ID="gvDatos" runat="server" AutoGenerateColumns="False" CssClass="grid"
                    Font-Size="Small" EmptyDataText="&lt;i&gt;No existen registros según los parámetros de búsqueda establecidos&lt;/i&gt;"
                    AllowPaging="True" PageSize="100" ShowFooter="True" HeaderStyle-HorizontalAlign="Center">
                    <HeaderStyle CssClass="pagerChildDG" Font-Size="12px" HorizontalAlign="Center" />
                    <FooterStyle CssClass="footerChildDG" Font-Bold="False" Font-Italic="False"
                        Font-Overline="False" Font-Strikeout="False" Font-Underline="False"></FooterStyle>
                    <RowStyle Font-Size="11px" />
                    <Columns>
                        <asp:BoundField DataField="numeroRadicado" HeaderText="Radicado" />
                        <asp:BoundField DataField="msisdn" HeaderText="Msisdn" />
                        <asp:BoundField DataField="fechaReporte" HeaderText="Fecha de Reporte" DataFormatString ="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="horaReporte" HeaderText="Hora Reporte" />
                        <asp:BoundField DataField="fechaSolucion" HeaderText="Fecha Solución" DataFormatString ="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="horaSolucion" HeaderText="Hora Solución" />
                        <asp:BoundField DataField="cliente" HeaderText="Cliente" ItemStyle-HorizontalAlign="left" />
                        <asp:BoundField DataField="ciudad" HeaderText="Ciudad" />
                        <asp:BoundField DataField="reportadoPor" HeaderText="Reportado por" />
                        <asp:BoundField DataField="subProceso" HeaderText="SubProceso" />
                        <asp:BoundField DataField="estadoNotus" HeaderText="Estado Notus"/>
                        <asp:BoundField DataField="novedadPresentada" HeaderText="Novedad Presentada"/>
                        <asp:BoundField DataField="comentarioEspecifico" HeaderText="Comentario Especifico"/>
                    </Columns>
                    <AlternatingRowStyle BackColor="#f3f3f3" />
                </asp:GridView>
        </asp:Panel> 
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
</body>
</html>

