<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolAsignacionSerialesPrestamo.aspx.vb" Inherits="BPColSysOP.PoolAsignacionSerialesPrestamo" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Pool asignación seriales préstamo - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
        function CollapseDetail(img, control){
            try{
                var panel = document.getElementById(control);
                if (panel.style.display=="none") {
                    panel.style.display = "inline";
                    img.src = "../images/contraer.png";
                }
                else {
                    panel.style.display = "none";
                    img.src = "../images/expandir.png";
                }
            }catch(err){
                alert(err);
            }
        }
        
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            UpdateMode="Group" GroupName="general" LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlFiltro" runat="server">
                <table class="tablaGris" style="width: auto; float:left; margin-right:50px">
                    <tr>
                        <td colspan="6" style="text-align: center" class="thGris">
                            INGRESE LOS DATOS PARA CONSULTA
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            No Radicado:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtidServicio" runat="server" onkeypress="javascript:return ValidaNumero(event);"></asp:TextBox>
                            <div>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator" runat="server" Display="Dynamic"
                                    ControlToValidate="txtidServicio" ValidationGroup="vgCliente" ErrorMessage="El número de radicado digitado no es válido."
                                    ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                            </div>
                        </td>
                        <td class="field">
                            <b>Ciudad: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCiudad" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">
                            <b>Bodega: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlBodega" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            <b>Fecha Agenda:</b>
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
                        <td class="field">
                            Cliente VIP:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlVIP" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">Prioridad:</td>
                        <td>
                            <asp:DropDownList ID="ddlPrioridad" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="6" align="center">
                            <br />
                            <br />
                            <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                        <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                        <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                        </td>
                    </tr>
                    <tr><td colspan="6">&nbsp;</td></tr>
                </table>
                
                <asp:GridView ID="gvLog" runat="server" style="float:left" CssClass="grid" EmptyDataRowStyle-Font-Size="14px"
                        EmptyDataText="<blockquote style='height:25px'>No se encontraron registros de log.</blockquote>" HeaderStyle-HorizontalAlign="Center"
                        PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1"
                        AllowSorting="true" AutoGenerateColumns="false">
                    <PagerSettings Mode="NumericFirstLast" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <Columns>
                            <asp:BoundField DataField="mensaje" HeaderText="Log Resultados" />
                        </Columns>
                </asp:GridView>
            </asp:Panel>
            
            <asp:Panel ID="pnlResultados" runat="server">
                <div style="text-align: left; clear:both">
                    <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                        CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                        EmptyDataText="<blockquote style='height:25px'>No se encontraron resultados.</blockquote>" HeaderStyle-HorizontalAlign="Center"
                        PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1"
                        AllowSorting="true" Width="100%">
                        <PagerSettings Mode="NumericFirstLast" />
                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <AlternatingRowStyle CssClass="alterColor" />
                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                        
                        <Columns>
                            <asp:TemplateField HeaderText="[+/-]" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:Image ID="imgCollapse" runat="server" ImageUrl="~/images/expandir.png" ToolTip="Ver detalle" ImageAlign="Middle" style="cursor: pointer" />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="idServicioMensajeria" HeaderText="Id" SortExpression="idServicioMensajeria">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="numeroRadicado" SortExpression="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                            <asp:BoundField DataField="NombreCliente" SortExpression="NombreCliente" HeaderText="Nombre Cliente" />
                            <asp:BoundField DataField="Identificacion" SortExpression="Identificacion" HeaderText="Identificación" />
                            <asp:BoundField DataField="nombreContacto" SortExpression="nombreContacto" HeaderText="Contacto" />
                            <asp:BoundField DataField="direccion" SortExpression="direccion" HeaderText="Dirección" />
                            <asp:BoundField DataField="telefono" SortExpression="telefono" HeaderText="Teléfono" />
                            <asp:BoundField DataField="fechaRegistro" SortExpression="fechaRegistro" HeaderText="Fecha Registro" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="fechaAgenda" SortExpression="fechaAgenda" HeaderText="Fecha Agenda" DataFormatString="{0:dd/MM/yyyy}" />
                            
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    </td></tr>
                                    <tr>
                                        <td colspan="10">
                                            <asp:Panel ID="pnlDetalle" runat="server" Style="display: none;" Width="100%">
                                                <div style="float:left; margin-right:20px;">
                                                    <asp:GridView ID="gvDatosDetalle" runat="server" AutoGenerateColumns="False"
                                                        BackColor="White" BorderColor="Gray" BorderStyle="Dashed" BorderWidth="2px"
                                                        CellPadding="4" ForeColor="Black" GridLines="Vertical" Width="50%" OnRowCommand="gvDatosDetalle_RowCommand"
                                                        OnRowDataBound="gvDatosDetalle_RowDataBound" DataKeyNames="serial" >
                                                        <RowStyle BackColor="#F7F7DE" />
                                                        <Columns>
                                                            <asp:BoundField DataField="serial" HeaderText="IMEI a Reparar"/>
                                                            <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                                            <asp:TemplateField HeaderText="IMEI Préstamo" ItemStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtImeiPrestamo" runat="server" style="text-align:center" Text='<%# Bind("serialPrestamo") %>'
                                                                    MaxLength="15" onkeypress="javascript:return ValidaNumero(event);" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <FooterStyle BackColor="#CCCC99" />
                                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                                        <AlternatingRowStyle BackColor="White" />
                                                    </asp:GridView>
                                                </div>
                                                <div style="float:left; vertical-align:middle; margin-top:20px">
                                                    <asp:LinkButton ID="lbAsignarSeriales" runat="server" CssClass="search" Font-Bold="True" OnClick="lbAsignarSeriales_Click" >
                                                        <img src="../images/engranaje.jpg" alt="Asignar Seriales" />&nbsp;Asignar Seriales
                                                    </asp:LinkButton>
                                                </div>
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
            
        </eo:CallbackPanel>
        
        <uc2:Loader ID="ldrWait" runat="server" />
    
        <!-- iframe para uso de selector de fechas -->
        <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
            position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
            frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
</body>
</html>
