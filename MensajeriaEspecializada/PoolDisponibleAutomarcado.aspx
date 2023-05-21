<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolDisponibleAutomarcado.aspx.vb" Inherits="BPColSysOP.PoolDisponibleAutomarcado" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Disponibilidad Automarcado - Mesajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        function SeleccionarODesmarcarTodo(ctrl, targetName) {
            var cont = 0;
            var arrControl = document.getElementsByTagName("input");
            for (i = 0; i < arrControl.length; i++) {
                if (arrControl[i].type == "checkbox" && arrControl[i].name.indexOf(targetName) != -1 && arrControl[i].disabled == false) {
                    arrControl[i].checked = ctrl.checked;
                    cont += 1;
                }
            }
            if (ctrl.checked) {
                if (cont == 0) {
                    alert("No se encontraron registros seleccionables. Por favor verifique");
                    ctrl.checked = false;
                }
            }
        }
        
        function ValidaNumero(e) {
            var tecla= document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager" runat="server">
        </asp:ScriptManager>
    
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            UpdateMode="Group" GroupName="general" LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlFiltro" runat="server">
                <table class="tablaGris" style="width: 100%;">
                    <tr>
                        <td colspan="4" style="text-align: center" class="thGris">
                            INGRESE LOS DATOS PARA CONSULTA
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Número de Radicado:
                        </td>
                        <td style="vertical-align: middle" nowrap="nowrap">
                            <asp:TextBox ID="txtRadicado" runat="server" MaxLength="8"></asp:TextBox>
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
                    </tr>
                    
                    <tr>
                        <td class="field">Ciudad:</td>
                        <td>
                            <asp:DropDownList ID="ddlCiudad" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">&nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <br />
                            <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Buscar Rutas" src="../images/filtro.png" />Filtrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Rutas" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbMarcarDisponible" runat="server" CssClass="search" Font-Bold="true" OnClientClick="return confirm('¿Está seguro que desea marcar como disponible los ítems seleccionados?')">
                                <img alt="Marcar servicios como disponibles" src="../images/ok.png" />&nbsp;Marcar como Disponible(s)
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
                        EmptyDataText="No existen elementos disponibles." HeaderStyle-HorizontalAlign="Center"
                        PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1">
                        <PagerSettings Mode="NumericFirstLast" />
                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <AlternatingRowStyle CssClass="alterColor" />
                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                        <Columns>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Image ID="imgUrgente" runat="server" ImageUrl="../images/transparent_16.gif"
                                        ToolTip="Urgente" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Selección">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkTodos" runat="server" Text="Todos" AutoPostBack="true" onclick="SeleccionarODesmarcarTodo(this,'chkSeleccion');" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSeleccion" runat="server" >
                                    </asp:CheckBox>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="idServicioMensajeria" HeaderText="ID">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                            <asp:BoundField DataField="nombreCliente" HeaderText="Empresa" />
                            <asp:BoundField DataField="identificacionCliente" HeaderText="Identificación" />
                            <asp:BoundField DataField="personaContacto" HeaderText="Contacto" />
                            <asp:BoundField DataField="ciudadCliente" HeaderText="Ciudad" />
                            <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                            <asp:BoundField DataField="telefonoContacto" HeaderText="Teléfono" />

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
