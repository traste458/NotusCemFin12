<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarRutaServicio.aspx.vb" Inherits="BPColSysOP.EditarRutaServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Modificar ruta - Servicio Mensajería</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function ProcesarEnter() {
            var btn = document.getElementById("lbBuscarRuta");
            var kCode = (event.keyCode ? event.keyCode : event.which);
            if (kCode.toString() == "13") {
                DetenerEvento(event)
                btn.click();
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
        
        <eo:CallbackPanel ID="pnlGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait" ChildrenAsTriggers="true" Width="100%">
        
        <asp:Panel ID="pnlFiltro" runat="server">
            <table width="100%">
                <tr>
                    <td style="width: 33%">
                        <table class="tablaGris" cellpadding="1">
                            <tr>
                                <th colspan="2">
                                    Filtro de Rutas
                                </th>
                            </tr>
                            <tr>
                                <td class="alterColor">Número de ruta:&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="txtIdRuta" runat="server" onkeydown="ProcesarEnter();" 
                                        MaxLength="5"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" style="height: 30px;">
                                    <asp:LinkButton ID="lbBuscarRuta" runat="server" CssClass="search" Font-Bold="True">
                                        <img alt="Buscar" src="../images/find.gif" />&nbsp;Buscar
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </td>
                    
                    <td style="width: 34%">
                        <asp:Panel ID="pnlAdicionARadicado" runat="server" Visible="false">
                            <table class="tablaGris" cellpadding="1">
                                <tr>
                                    <th colspan="2">Adicionar Radicado</th>
                                </tr>
                                <tr>
                                    <td class="alterColor">Número de Radicado: &nbsp;</td>
                                    <td>
                                        <asp:TextBox ID="txtRadicado" runat="server" MaxLength="7" />
                                        <div>
                                            <asp:RequiredFieldValidator ID="rfvTadicado" runat="server" ErrorMessage="Por favor digite el número de radicado"
                                                Display="Dynamic" ControlToValidate="txtRadicado" ValidationGroup="vgCargue">
                                            </asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center" style="height: 30px;">
                                        <asp:LinkButton ID="lbAgregarRadicado" runat="server" CssClass="search" Font-Bold="True">
                                            <img alt="Guardar Servicio" src="../images/add.png" />&nbsp;Agregar
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>    
                    </td>
                    
                    <td style="width: 33%">
                        <asp:Panel ID="pnlModificarResponsable" runat="server" Visible="false">
                            <table class="tablaGris" cellpadding="1">
                                <tr>
                                    <th colspan="2">Cambiar Responsable</th>
                                </tr>
                                <tr>
                                    <td class="alterColor">Responsable Entrega: &nbsp;</td>
                                    <td><asp:DropDownList ID="ddlResponsable" runat="server" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center" style="height: 30px;">
                                        <asp:LinkButton ID="lbActualizarResponsable" runat="server" CssClass="search" Font-Bold="True" OnClientClick="return confirm('¿Está seguro que desea realizar el cambio de responsable?')">
                                            <img alt="Cambiar Responsable" src="../images/Edit-User.png" />&nbsp;Cambiar Responsable
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        
            
        </asp:Panel>
        <br />
        
        <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
            <table class="tablaGris" cellpadding="1" style="width: 100%">
                <tr>
                    <th colspan="6">INFORMACIÓN DE LA RUTA</th>
                </tr>
                <tr>
                    <td class="alterColor">Número de Ruta:</td>
                    <td align="center">
                        <asp:Label ID="lblIdRuta" runat="server" Font-Bold="True"></asp:Label>
                    </td>
                    <td class="alterColor">Responsable Entrega:</td>
                    <td>
                        <asp:Label ID="lblResponsableEntrega" runat="server"></asp:Label>
                    </td>
                    <td class="alterColor">Estado:</td>
                    <td>
                        <asp:Label ID="lblEstado" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="alterColor">Fecha Creación:</td>
                    <td>
                        <asp:Label ID="lblFechaCreacion" runat="server"></asp:Label>
                    </td>
                    <td class="alterColor">Fecha Salida:</td>
                    <td>
                        <asp:Label ID="lblFechaSalida" runat="server"></asp:Label>
                    </td>
                    <td class="alterColor">Fecha Cierre:</td>
                    <td>
                        <asp:Label ID="lblFechaCierre" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                    CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                    EmptyDataText="No existen elementos disponibles." HeaderStyle-HorizontalAlign="Center"
                    PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" 
                    CellSpacing="1" Width="100%">
                    
                    <PagerSettings Mode="NumericFirstLast" />
                    <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                    <PagerStyle CssClass="field" HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <AlternatingRowStyle CssClass="alterColor" />
                    <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                    
                    <Columns>
                        <asp:BoundField DataField="idDetalle" HeaderText="ID" />
                        <asp:BoundField DataField="idServicio" HeaderText="Servicio" />
                        <asp:BoundField DataField="numeroRadicado" HeaderText="Radicado" />
                        <asp:BoundField DataField="nombre" HeaderText="Empresa" />
                        
                        <asp:BoundField DataField="identificacion" HeaderText="Identificación" />
                        <asp:BoundField DataField="nombreAutorizado" HeaderText="Contacto" />
                        <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                        <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="CantidadSIMs" HeaderText="Cant. SIMs" >
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="CantidadTelefonos" HeaderText="Cant. Teléfonos" >
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        
                        <asp:TemplateField HeaderText="Opciones" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("idDetalle") %>'
                                    ToolTip="Eliminar" ImageUrl="../images/Delete-32.png" OnClientClick="return confirm('¿Desea eliminar el ítem seleccionado?')">
                                </asp:ImageButton>&nbsp;
                                
                                <asp:ImageButton ID="btnSubir" runat="server" CommandName="subir" CommandArgument='<%# Bind("idDetalle") %>'
                                    ToolTip="Subir" ImageUrl="../images/controlUp.png" OnClientClick="return confirm('¿Desea mover el ítem seleccionado a una posición superior?')">
                                </asp:ImageButton>
                                
                                <asp:TextBox ID="txtSecuencia" runat="server" Width="30px" Enabled="false" style="text-align:center" Text='<%# Bind("secuencia") %>'>
                                </asp:TextBox>
                                
                                <asp:ImageButton ID="btnBajar" runat="server" CommandName="bajar" CommandArgument='<%# Bind("idDetalle") %>'
                                    ToolTip="Bajar" ImageUrl="../images/controlDown.png" OnClientClick="return confirm('¿Desea mover el ítem seleccionado a una posición inferior?')">
                                </asp:ImageButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
            </asp:GridView>
        </asp:Panel>
        </eo:CallbackPanel>
        
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
