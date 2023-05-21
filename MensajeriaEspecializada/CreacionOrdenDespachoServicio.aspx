<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreacionOrdenDespachoServicio.aspx.vb" Inherits="BPColSysOP.CreacionOrdenDespachoServicio" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Creación Ordenes de Despacho - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
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
        
        function SeleccionarODesmarcarTodo(){
            try {
                var totalChecks = $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox').size();
                var itemsCheckeds = $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox:checked').size();
                var checkPrinciapal = $('#<%= gvDatos.ClientID %> input[id*="chkTodos"]:checkbox').attr('checked');
                
                if (checkPrinciapal){
                    $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox').attr('checked',true);
                } else {
                    $('#<%= gvDatos.ClientID %> input[id*="chkSeleccion"]:checkbox').attr('checked',false);
                }
            } catch(e) {
                alert('Error al tratar de seleccionar ítems' + e.description);
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
            
            <asp:Panel ID="pnlFiltros" runat="server">
                <table class="tablaGris" cellpadding="2">
                    <tr>
                        <td colspan="2" style="text-align: center" class="thGris">
                            DATOS PARA LA ORDEN DE DESPACHO
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Responsable de Entrega:
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
                        <td class="field">
                            Proveedor Servicio Técnico:
                        </td>
                        <td valign="middle">
                            <asp:DropDownList ID="ddlProveedorServicioTecnico" runat="server">
                            </asp:DropDownList>
                            &nbsp;
                            <asp:RequiredFieldValidator ID="rfvddlProveedorServicioTecnico" runat="server" ValidationGroup="vgDespacho"
                                ControlToValidate="ddlProveedorServicioTecnico" InitialValue="0" ErrorMessage="Se debe seleccionar un proveedor." />
                        </td>
                    </tr>
                    <tr>    
                        <td align="center" colspan="2">
                            <div style="margin-top:15px">
                                <asp:LinkButton ID="lbGenerarRuta" runat="server" CssClass="search" Font-Bold="True" CausesValidation="true" ValidationGroup="vgDespacho"
                                    OnClientClick="return confirm('¿Está seguro que desea crear el despacho para los servicios seleccionados?')">
                                            <img alt="Generar Despacho" src="../images/trans_small.png" />&nbsp;Generar Despacho
                                </asp:LinkButton>
                                &nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                            <img alt="Cargar Servicios" src="../images/filtro.png" />&nbsp;Cargar Servicios
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
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Image ID="imgUrgente" runat="server" ImageUrl="../images/transparent_16.gif"
                                    ToolTip="Urgente" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Selección">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkTodos" runat="server" Text="Todos" AutoPostBack="false" onclick="SeleccionarODesmarcarTodo();" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSeleccion" runat="server">
                                </asp:CheckBox>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="idServicioMensajeria" HeaderText="ID">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                        <asp:BoundField DataField="nombre" HeaderText="Empresa" />
                        <asp:BoundField DataField="identificacion" HeaderText="Identificación" />
                        <asp:BoundField DataField="nombreAutorizado" HeaderText="Contacto" />
                        <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                        <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="CantidadTelefonos" HeaderText="Cant. Teléfonos">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" />
                        <asp:BoundField DataField="idJornada" HeaderText="idJornada" Visible="false" />
                        <asp:BoundField DataField="Jornada" HeaderText="Jornada" />
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
