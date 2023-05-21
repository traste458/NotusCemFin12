<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RadicadosDevolucionesReporte.aspx.vb" 
Inherits="BPColSysOP.RadicadosDevolucionesReporte" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Radicados Devoluciones</title>
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
                        <asp:TextBox ID="txtRadicado" runat="server" MaxLength="7">
                        </asp:TextBox>
                        <div style="clear: both">
                            <asp:RegularExpressionValidator ID="revRadicado" runat="server" Display="Dynamic"
                                ControlToValidate="txtRadicado" ValidationGroup="vgFiltro" ErrorMessage="El valor digitado no es valido"
                                ValidationExpression="[0-9]{7}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field" align="left">
                        Serial:
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtSerial" runat="server" MaxLength="17">
                        </asp:TextBox>
                        <div style="clear: both">
                            <asp:RegularExpressionValidator ID="revSerial" runat="server" Display="Dynamic"
                                ControlToValidate="txtSerial" ValidationGroup="vgFiltro" ErrorMessage="El valor digitado no es valido"
                                ValidationExpression="[0-9]{15,17}"></asp:RegularExpressionValidator>
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
                        Tipo Servicio:
                    </td>
                    <td align="left">
                        <asp:DropDownList ID="ddlTipoServicio" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        <b>Fecha Agendamiento:</b>
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
                        <asp:CustomValidator ID="cusSeleccion" runat="server" ErrorMessage="La fecha de agendamiento es obligatroria"
                                    Display="Dynamic" ClientValidationFunction="esFechaValida" ValidationGroup="vgFiltro"></asp:CustomValidator>            
                    </div> 
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
                                    <input class="textbox" id="txtFechaInicialDevolucion" readonly="readonly" size="11" name="txtFechaInicialDevolucion"
                                        runat="server" />
                                </td>
                                <td valign="middle">
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicialDevolucion,document.form1.txtFechaFinalDevolucion);return false;"
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
                                    <input class="textbox" id="txtFechaFinalDevolucion" readonly="readonly" size="11" name="txtFechaFinalDevolucion"
                                        runat="server" />
                                </td>
                                <td>
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicialDevolucion,document.form1.txtFechaFinalDevolucion);return false;"
                                        href="javascript:void(0)">
                                        <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                            width="34" align="middle" border="0"></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                    
                </tr>
                <tr>
                    <td class="field">
                        <b>Fecha Reagendamiento:</b>
                    </td>
                    <td style="vertical-align: middle" nowrap="nowrap">
                        <table style="padding: 0px !important">
                            <tr>
                                <td>
                                    De:&nbsp;&nbsp;
                                </td>
                                <td valign="middle">
                                    <input class="textbox" id="txtFechaInicialReagendamiento" readonly="readonly" size="11" name="txtFechaInicialReagendamiento"
                                        runat="server" />
                                </td>
                                <td valign="middle">
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicialReagendamiento,document.form1.txtFechaFinalReagendamiento);return false;"
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
                                    <input class="textbox" id="txtFechaFinalReagendamiento" readonly="readonly" size="11" name="txtFechaFinalReagendamiento"
                                        runat="server" />
                                </td>
                                <td>
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicialReagendamiento,document.form1.txtFechaFinalReagendamiento);return false;"
                                        href="javascript:void(0)">
                                        <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                            width="34" align="middle" border="0"></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class="field">
                        <b>Fecha Cierre:</b>
                    </td>
                    <td style="vertical-align: middle" nowrap="nowrap">
                        <table style="padding: 0px !important">
                            <tr>
                                <td>
                                    De:&nbsp;&nbsp;
                                </td>
                                <td valign="middle">
                                    <input class="textbox" id="txtFechaInicialCierre" readonly="readonly" size="11" name="txtFechaInicialCierre"
                                        runat="server" />
                                </td>
                                <td valign="middle">
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicialCierre,document.form1.txtFechaFinalCierre);return false;"
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
                                    <input class="textbox" id="txtFechaFinalCierre" readonly="readonly" size="11" name="txtFechaFinalCierre"
                                        runat="server" />
                                </td>
                                <td>
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicialCierre,document.form1.txtFechaFinalCierre);return false;"
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
            <asp:GridView ID="gvDevolucion" runat="server" AllowPaging="true" AutoGenerateColumns="false"
                CssClass="grid" EmptyDataText="&lt;blockquote&gt;No se encontraron registros seg&uacute;n los filtros aplicados&lt;/blockquote&gt;"
                PageSize="100">
                <PagerSettings Mode="NumericFirstLast" />
                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                <PagerStyle CssClass="pagerChildDG" />
                <HeaderStyle HorizontalAlign="Center" />
                <Columns>
                    <asp:TemplateField HeaderText="[+/-]">
                        <ItemTemplate>
                            <asp:ImageButton ID="ibVerDetalle" runat="server" ImageUrl="~/images/expandir.png"
                                ToolTip="Ver/Ocultar Detalle" ImageAlign="Middle" CommandName="VerOcultarDetalle"
                                CommandArgument='<%# Bind("numeroRadicado") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="numeroRadicado" HeaderText="Radicado" />
                    <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" DataFormatString="{0:dd/MM/yyyy}"/>
                    <asp:BoundField DataField="fechaEntrega" HeaderText="Fecha Entrega" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="cliente" HeaderText="Cliente" />
                    <asp:BoundField DataField="imei" HeaderText="Serial Equipo" />
                    <asp:BoundField DataField="iccid" HeaderText="Serial Sim" />
                    <asp:BoundField DataField="msisdn" HeaderText="Msisdn" />
                    <asp:BoundField DataField="estado" HeaderText="Estado"/>
                    <asp:BoundField DataField="fechaTramite" HeaderText="Fecha Tramite" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="fechaCierre" HeaderText="Fecha Cierre" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="ciudad" HeaderText="Ciudad" />
                    
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            </td></tr>
                            <tr>
                                <td colspan="10">
                                    <asp:Panel ID="pnlDetalle" runat="server" Style="display: none; text-align: left;"
                                        Width="100%">
                                        <asp:GridView ID="gvDatosDetalle" runat="server" AutoGenerateColumns="False" BackColor="White"
                                            BorderColor="Gray" BorderStyle="Dashed" BorderWidth="2px" CellPadding="4" ForeColor="Black"
                                            GridLines="Vertical" Width="100%">
                                            <RowStyle BackColor="#F7F7DE" />
                                            <Columns>
                                                <asp:BoundField DataField="fechaEnvio" HeaderText="Fecha Envío" DataFormatString="{0:dd/MM/yyyy}"/>
                                                <asp:BoundField DataField="agente" HeaderText="Agente"/>
                                                <asp:BoundField DataField="horaLlegada" HeaderText="Hora Llegada"/>
                                            </Columns>
                                            <FooterStyle BackColor="#CCCC99" />
                                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <AlternatingRowStyle BackColor="White" />
                                        </asp:GridView>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
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
