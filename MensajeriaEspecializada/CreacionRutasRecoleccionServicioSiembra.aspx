<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreacionRutasRecoleccionServicioSiembra.aspx.vb" Inherits="BPColSysOP.CreacionRutasRecoleccionServicioSiembra" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Creación Rutas Recolección Seriales - Servicio Siembra</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
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

        function SeleccionarODesmarcarTodo() {
            try {
                var totalChecks = $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox').size();
                var itemsCheckeds = $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox:checked').size();
                var checkPrinciapal = $('#<%= gvDatos.ClientID %> input[id*="chkTodos"]:checkbox').attr('checked');

                if (checkPrinciapal) {
                    $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox').attr('checked', true);
                } else {
                    $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox').attr('checked', false);
                }
            } catch (e) {
                alert('Error al tratar de seleccionar ítems' + e.description);
            }
        }

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
                //alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }
        }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        function FiltrarEOPanel(idFiltro, idFlag, parametro, idCallbackPanel) {
            var filtro = document.getElementById(idFiltro).value.trim();
            if (idFlag != 0) { ObtenerIdFlagCallBackPanelFilter(idFlag); }
            var comboFiltrado = ctrIdFlagFilterFilter.value;
            try {
                if (filtro.length >= 4 || (filtro.length < 4 && comboFiltrado == "1")) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(callBackPanelFilter.id, parametro);
                    if (filtro.length >= 4) {
                        ctrIdFlagFilterFilter.value = "1";
                    } else {
                        ctrIdFlagFilterFilter.value = "0";
                    }
                }
                document.getElementById(idFiltro).focus();
            } catch (e) {
                //MostrarOcultarDivFloater(false);
                //alert("Error al tratar de filtrar Datos.\n" + e.description);
            }
        }

        function ObtenerIdFlagCallBackPanelFilter(idFlag) {

            switch (idFlag) {
                case 1:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMoto.ClientID %>');
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMoto.ClientID %>');
                    break;
                case 2:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMoto.ClientID %>')
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMoto.ClientID %>');
                    break;
                default:
                    break;
            }
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
            LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlLog" runat="server" HorizontalAlign="Right" Width="100%">
                <asp:GridView ID="gvLog" runat="server" AutoGenerateColumns="False" CssClass="grid"
                    EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                    BorderColor="Gray" CellPadding="1" CellSpacing="1" HorizontalAlign="Center">
                    <AlternatingRowStyle CssClass="alterColor" />
                    <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                    <Columns>
                        <asp:BoundField DataField="idRuta" HeaderText="Ruta" />
                        <asp:BoundField DataField="responsable" HeaderText="Responsable entrega" />
                    </Columns>
                </asp:GridView>
                <br />
            </asp:Panel>
            
            <asp:Panel ID="pnlFiltros" runat="server">
                <table class="tablaGris" cellpadding="2">
                    <tr>
                        <td colspan="2" style="text-align: center" class="thGris">
                            DATOS PARA LA ORDEN DE RECOLECCIÓN
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Responsable de Recolección:
                        </td>
                        <td valign="top">
                            <asp:TextBox ID="txtFiltroMoto" runat="server" MaxLength="15" onkeyup="FiltrarEOPanel(this.id, 1, 'filtrarMoto');"></asp:TextBox>
                            <eo:CallbackPanel ID="cpFiltroMoto" runat="server" UpdateMode="Group" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                                Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle" GroupName="general">
                                <div style="display: block">
                                    <asp:HiddenField ID="hfMoto" runat="server" />
                                </div>
                                <asp:DropDownList ID="ddlMotorizado" runat="server" Style="display: inline;">
                                </asp:DropDownList>
                                <br />
                                <asp:Label ID="lblMoto" runat="server" CssClass="comentario"></asp:Label> &nbsp;
                                <asp:RequiredFieldValidator ID="rfvddlMotorizado" runat="server" ValidationGroup="vgDespacho"
                                    ControlToValidate="ddlMotorizado" InitialValue="0" ErrorMessage="Seleccione un responsable" />
                            </eo:CallbackPanel>
                            <asp:HiddenField ID="hfFlagFiltroMoto" runat="server" />
                            <div id="divFloater" style="display: none; position: absolute; height: 35px; width: 200px;">
                                <table align="center">
                                    <tr>
                                        <td align="center" valign="middle" style="height: 100%">
                                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" ImageAlign="Middle" />
                                            <b>Procesando...</b>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>    
                        <td align="center" colspan="2" style="height: 30px;">
                            <div>
                                <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                            <img alt="Buscar Servicios" src="../images/filtro.png" />&nbsp;Buscar Servicios
                                </asp:LinkButton>
                                &nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbGenerarRuta" runat="server" CssClass="search" Font-Bold="True" CausesValidation="true" ValidationGroup="vgDespacho"
                                    OnClientClick="return confirm('¿Está seguro que desea crear la ruta de recolección para los Seriales seleccionados?')">
                                            <img alt="Generar Ruta" src="../images/trans_small.png" />&nbsp;Generar Ruta
                                </asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
            </asp:Panel> 
            
            <asp:Panel ID="pnlResultados" runat="server">
                <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                    CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                    EmptyDataText="<blockquote style='height:25px'>No existen elementos disponibles.</blockquote>" HeaderStyle-HorizontalAlign="Center"
                    PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1" Width="100%">
                    <PagerSettings Mode="NumericFirstLast" />
                    <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                    <PagerStyle CssClass="field" HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <AlternatingRowStyle CssClass="alterColor" />
                    <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                    <Columns>
                        <asp:TemplateField HeaderText="[+/-]" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkTodos" runat="server" Text="Todos" AutoPostBack="false" onclick="SeleccionarODesmarcarTodo();" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Image ID="imgCollapse" runat="server" ImageUrl="~/images/expandir.png" ToolTip="Ver detalle" ImageAlign="Middle" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="idServicioMensajeria" HeaderText="ID Servicio">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="nombreCliente" HeaderText="Empresa" />
                        <asp:BoundField DataField="identificacion" HeaderText="Identificación" />
                        <asp:BoundField DataField="nombreAutorizado" HeaderText="Contacto" />
                        <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                        <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" />
                        
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                </td></tr>
                                <tr>
                                    <td colspan="10">
                                        <asp:Panel ID="pnlDetalle" runat="server" Style="display: none;" Width="100%">
                                            <asp:GridView ID="gvDatosDetalle" runat="server" AutoGenerateColumns="False"
                                                BackColor="White" BorderColor="Gray" BorderStyle="Dashed" BorderWidth="2px"
                                                CellPadding="4" ForeColor="Black" GridLines="Vertical" OnRowCommand="gvDatosDetalle_RowCommand"
                                                OnRowDataBound="gvDatosDetalle_RowDataBound" DataKeyNames="idDetalle" >
                                                <RowStyle BackColor="#F7F7DE" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Selección">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkSeleccion" runat="server">
                                                            </asp:CheckBox>
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="idDetalle" HeaderText="ID" />
                                                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                                                    <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                                    <asp:BoundField DataField="fechaDevolucion" HeaderText="Fecha Devolucion" DataFormatString="{0:dd/MM/yyyy}" />
                                                    <asp:TemplateField HeaderText="Estado de Devolución">
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlEstadoDevolucion" runat="server">
                                                            </asp:DropDownList>
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
