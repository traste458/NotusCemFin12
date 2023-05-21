<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolRutasActivas.aspx.vb" Inherits="BPColSysOP.PoolRutasActivas" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Pool Rutas Activas - Mensajería especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/jscript_ventana.js" type="text/javascript" language="javascript"></script>
    
    <script language="javascript" type="text/javascript">
        function CollapseDetail(img, control) {
            try {
                var panel = document.getElementById(control);
                if (panel.style.display == "none") {
                    panel.style.display = "inline";
                    img.src = "../images/contraer.png";
                }
                else {
                    panel.style.display = "none";
                    img.src = "../images/expandir.png";
                }
            } catch (err) {
                alert(err);
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize('hfMedidasVentana');">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager" runat="server">
        </asp:ScriptManager>
        
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <asp:HiddenField ID="hfMedidasVentana" runat="server" />
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <%--<eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            UpdateMode="Group" GroupName="general" LoadingDialogID="ldrWait_dlgWait">--%>
            
            <asp:Panel ID="pnlFiltro" runat="server">
                <table class="tablaGris" style="width: 100%;">
                    <tr>
                        <td colspan="6" style="text-align: center" class="thGris">
                            INGRESE LOS DATOS PARA CONSULTA
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Fecha Agenda:
                        </td>
                        <td style="vertical-align: middle" nowrap="nowrap">
                            <table style="padding: 0px !important">
                                <tr>
                                    <td>
                                        De:&nbsp;&nbsp;
                                    </td>
                                    <td valign="middle">
                                        <input class="textbox" id="txtFechaAgendaInicial" readonly="readonly" size="11" name="txtFechaAgendaInicial"
                                            runat="server" />
                                    </td>
                                    <td valign="middle">
                                        <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.formPrincipal.txtFechaAgendaInicial,document.formPrincipal.txtFechaAgendaFinal);return false;"
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
                                        <input class="textbox" id="txtFechaAgendaFinal" readonly="readonly" size="11" name="txtFechaAgendaFinal"
                                            runat="server" />
                                    </td>
                                    <td>
                                        <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.formPrincipal.txtFechaAgendaInicial,document.formPrincipal.txtFechaAgendaFinal);return false;"
                                            href="javascript:void(0)">
                                            <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                                width="34" align="middle" border="0"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="field">
                            <b>Fecha Creación: </b>
                        </td>
                        <td style="vertical-align: middle" nowrap="nowrap">
                            <table style="padding: 0px !important">
                                <tr>
                                    <td>
                                        De:&nbsp;&nbsp;
                                    </td>
                                    <td valign="middle">
                                        <input class="textbox" id="txtFechaCreacionInicial" readonly="readonly" size="11" name="txtFechaCreacionInicial"
                                            runat="server" />
                                    </td>
                                    <td valign="middle">
                                        <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.formPrincipal.txtFechaCreacionInicial,document.formPrincipal.txtFechaCreacionFinal);return false;"
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
                                        <input class="textbox" id="txtFechaCreacionFinal" readonly="readonly" size="11" name="txtFechaCreacionFinal"
                                            runat="server" />
                                    </td>
                                    <td>
                                        <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.formPrincipal.txtFechaCreacionInicial,document.formPrincipal.txtFechaCreacionFinal);return false;"
                                            href="javascript:void(0)">
                                            <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                                width="34" align="middle" border="0"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="field">
                            <b>Jornada: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlJornada" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="field">Ciudad:</td>
                        <td>
                            <asp:DropDownList ID="ddlCiudad" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">Estado:</td>
                        <td>
                            <asp:DropDownList ID="ddlEstado" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">No Ruta:<br />
                        </td>
                        <td>
                            <asp:TextBox ID="txtRuta" runat="server" MaxLength="5"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <br />
                            <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Buscar Rutas" src="../images/filtro.png" />Filtrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Rutas" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                        </td>
                    </tr>
                    <tr><td colspan="6">&nbsp;</td></tr>
                </table>
            </asp:Panel>
            
            <asp:Panel ID="pnlResultados" runat="server">
                <div style="text-align: left;">
                    <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                    CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                    EmptyDataText="No hay pedidos pendientes" HeaderStyle-HorizontalAlign="Center"
                    PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1"
                    AllowSorting="True" Width="100%">
                    <PagerSettings Mode="NumericFirstLast" />
                    <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                    <PagerStyle CssClass="field" HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <AlternatingRowStyle CssClass="alterColor" />
                    <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                    
                    <Columns>
                        <asp:TemplateField HeaderText="[+/-]" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="ibVerDetalleRuta" runat="server" ImageUrl="~/images/expandir.png"
                                    ToolTip="Ver/Ocultar Detalle" ImageAlign="Middle" CommandName="VerOcultarDetalleRuta"
                                    CommandArgument='<%# Bind("idRuta") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="idRuta" HeaderText="Ruta" SortExpression="idRuta">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="responsable" SortExpression="responsable" HeaderText="Responsable Entrega" />
                        <asp:BoundField DataField="estado" SortExpression="estado" HeaderText="Estado" />
                        <asp:BoundField DataField="jornada" SortExpression="jornada" HeaderText="Jornada" />
                        <asp:BoundField DataField="Ciudad" SortExpression="Ciudad" HeaderText="Ciudad" />
                        <asp:BoundField DataField="fechaCreacion" SortExpression="fechaCreacion" HeaderText="Fecha Creación" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="fechaAgenda" SortExpression="fechaAgenda" HeaderText="Fecha Agenda" DataFormatString="{0:dd/MM/yyyy}" />
                        
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                </td></tr>
                                <tr>
                                    <td colspan="10">
                                        <asp:Panel ID="pnlDetalle" runat="server" Style="display: none;" Width="100%">
                                            <asp:GridView ID="gvDatosDetalle" runat="server" AutoGenerateColumns="False"
                                                BackColor="White" BorderColor="Gray" BorderStyle="Dashed" BorderWidth="2px"
                                                CellPadding="4" ForeColor="Black" GridLines="Vertical" Width="100%" OnRowCommand="gvDatosDetalle_RowCommand"
                                                OnRowDataBound="gvDatosDetalle_RowDataBound" DataKeyNames="idServicioMensajeria,idTipoServicio" >
                                                <RowStyle BackColor="#F7F7DE" />
                                                <Columns>
                                                    <asp:BoundField DataField="idServicioMensajeria" HeaderText="Servicio" />
                                                    <asp:BoundField DataField="numeroRadicado" HeaderText="Radicado" />
                                                    <asp:BoundField DataField="empresa" HeaderText="Cliente" />
                                                    <asp:BoundField DataField="identificacionCliente" HeaderText="Identificación"/>
                                                    <asp:BoundField DataField="contacto" HeaderText="Contacto" />
                                                    <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                                                    <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                                                    <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" DataFormatString="{0:dd/MM/yyyy}" />
                                                    <asp:TemplateField HeaderText="Opción" ItemStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="imgSolucionar" runat="server" ImageUrl="~/images/view.png" CommandName="ver"
                                                            CommandArgument='<%# Bind("idServicioMensajeria") %>' ToolTip="Ver" ImageAlign="Middle"/>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
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
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                </div>
            </asp:Panel>

        <%--</eo:CallbackPanel>--%>
        
        <eo:CallbackPanel id="cpVerInformacion" runat="server" loadingdialogid="ldrWait_dlgWait"
            updatemode="Group" groupname="general">
            <eo:Dialog runat="server" ID="dlgVerInformacionServicio" ControlSkinID="None" Height="400px" HeaderHtml="Información detallada del Servicio"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                <ContentTemplate>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                </BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <uc2:Loader ID="ldrWait" runat="server" />
        
        <!-- iframe para uso de selector de fechas -->
        <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
            position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
            frameborder="0" width="132" scrolling="no" height="142"></iframe>
        
    </form>
</body>
</html>
