<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministrarTipoProducto.aspx.vb"
    Inherits="BPColSysOP.AdministrarTipoProducto" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Página sin título</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        /*$(document).ready(init);
        function init() {
            AdicionarEfecto('hlCrear', 'pnlRegistro');
            AdicionarEfecto('hlBuscar', 'pnlBusqueda');
        }

        function EjecutarSlideToggle(nombrePanel) {
            nombrePanel = "#" + nombrePanel;
            $(nombrePanel).slideToggle("slow");
            return (false);
        }

        function AdicionarEfecto(control, nombrePanel) {
            control = "#" + control;
            $(control).click(function() { EjecutarSlideToggle(nombrePanel); });
        }*/
    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="smAjaxManager" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            <table>
                <tr>
                    <td>
                        <asp:LinkButton ID="lbCrear" runat="server"><img src="../images/save_all.png" alt="" />&nbsp;Crear Nuevo</asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbBuscar" runat="server"><img src="../images/find.gif" alt="" />&nbsp;Buscar</asp:LinkButton>
                        <asp:HiddenField ID="hfModalManager" runat="server" />
                        <cc1:ModalPopupExtender ID="mpeFormularioModificacion" runat="server" 
                            Enabled="True" TargetControlID="hfModalManager" BackgroundCssClass="modalBackground"
                            PopupControlID="pnlRegistro">
                        </cc1:ModalPopupExtender>
                        <asp:HiddenField ID="hfFindModalManager" runat="server" />
                        <cc1:ModalPopupExtender ID="mpeFormularioBusqueda" runat="server" 
                            Enabled="True" TargetControlID="hfFindModalManager" BackgroundCssClass="modalBackground"
                            PopupControlID="pnlBusqueda">
                        </cc1:ModalPopupExtender>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Panel ID="pnlRegistro" runat="server"  Style="display: none; width: 500px;
                            height: auto;" CssClass="modalPopUp">
                            <div style="text-align: center; width: 100%;">
                                <uc1:EncabezadoPagina ID="epRegisterNotifier" runat="server" />
                            </div>
                            <br />
                            <table class="tabla" border="1" align="center">
                                <tr>
                                    <th colspan="2" style="text-align: center">
                                        <asp:Label ID="lblTituloAdm" runat="server" Text="FORMULARIO DE CREACIÓN"></asp:Label>
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        ID</td>
                                    <td>
                                        <asp:TextBox ID="txtIdTipoProducto" runat="server" MaxLength="5"></asp:TextBox>
                                        <div style="display:block;">
                                            <asp:RequiredFieldValidator ID="rfvIdTipoProducto" runat="server" 
                                                ErrorMessage="Digite el identificador del Tipo de Producto, por favor" 
                                                ControlToValidate="txtIdTipoProducto" Display="Dynamic" 
                                                ValidationGroup="registro"></asp:RequiredFieldValidator>
                                            <asp:RangeValidator ID="rvIdTipoProducto" runat="server" 
                                                ErrorMessage="Tipo o longitud de dato no válida. Se espera un valor de tipo Entero (0-32767)" 
                                                Type="Integer" MinimumValue="1" MaximumValue="32767" SetFocusOnError="True" 
                                                Display="Dynamic" ControlToValidate="txtIdTipoProducto" 
                                                ValidationGroup="registro"></asp:RangeValidator>
                                        
                                            </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Descripción:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDescripcion" runat="server" MaxLength="50" Width="300px"></asp:TextBox>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" 
                                                ControlToValidate="txtDescripcion" Display="Dynamic" 
                                                ErrorMessage="Digite la descripción del Tipo de Producto, por favor" 
                                                SetFocusOnError="True" ValidationGroup="registro"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Es Instruccionable?:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlInstruccionable" runat="server">
                                            <asp:ListItem Value="0">Escoja una Opción</asp:ListItem>
                                            <asp:ListItem Value="1">SI</asp:ListItem>
                                            <asp:ListItem Value="2">NO</asp:ListItem>
                                        </asp:DropDownList>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvInstruccionable" runat="server" 
                                                ControlToValidate="ddlInstruccionable" Display="Dynamic" 
                                                ErrorMessage="Debe especificar si el Tipo de Producto es o no instruccionable. Escoja una opción, por favor" 
                                                SetFocusOnError="True" ValidationGroup="registro" InitialValue="0"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Unidad de Empaque:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlUnidadEmpaque" runat="server">
                                        </asp:DropDownList>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvUnidadEmpaque" runat="server" ErrorMessage="Escoja una Unidad de Empaque, por favor"
                                                Display="Dynamic" ValidationGroup="registro" SetFocusOnError="True" ControlToValidate="ddlUnidadEmpaque"
                                                InitialValue="0"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Maneja Tecnología?:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlAplicaTecnologia" runat="server">
                                            <asp:ListItem Value="0">Escoja una Opción</asp:ListItem>
                                            <asp:ListItem Value="1">SI</asp:ListItem>
                                            <asp:ListItem Value="2">NO</asp:ListItem>
                                        </asp:DropDownList>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvAplicaTecnologia" runat="server" 
                                                ControlToValidate="ddlAplicaTecnologia" Display="Dynamic" 
                                                ErrorMessage="Debe especificar si el Tipo de Producto maneja o no Tecnología. Escoja una opción, por favor" 
                                                SetFocusOnError="True" ValidationGroup="registro" InitialValue="0"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="trEstado" runat="server">
                                    <td class="field">
                                        Estado:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlEstado" runat="server">
                                            <asp:ListItem Value="1">Activo</asp:ListItem>
                                            <asp:ListItem Value="2">Inactivo</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center">
                                        <br />
                                        <br />
                                        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="submit" ValidationGroup="registro" />
                                        <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" CssClass="submit"
                                            ValidationGroup="registro" />
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="submit" />
                                        <asp:HiddenField ID="hIdTipoProducto" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="pnlBusqueda" runat="server"  Style="display: none; width: 500px;
                            height: auto;" CssClass="modalPopUp">
                            <div style="text-align: center; width: 100%;">
                                <uc1:EncabezadoPagina ID="epFindNotifier" runat="server" />
                            </div>
                            <br />
                            <table class="tabla" border="1" align="center">
                                <tr>
                                    <th colspan="2" style="text-align: center">
                                        <asp:Label ID="Label1" runat="server" Text="FORMULARIO DE BÚSQUEDA"></asp:Label>
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        ID</td>
                                    <td>
                                        <asp:TextBox ID="txtBuscarId" runat="server" MaxLength="5"></asp:TextBox>
                                        <div style="display:block;">
                                            <asp:RangeValidator ID="rvBuscarId" runat="server" 
                                                ErrorMessage="Tipo o longitud de dato no válida. Se espera un valor de tipo Entero (0-32767)" 
                                                Type="Integer" MinimumValue="1" MaximumValue="32767" SetFocusOnError="True" 
                                                Display="Dynamic" ControlToValidate="txtBuscarId" 
                                                ValidationGroup="busqueda"></asp:RangeValidator>
                                        
                                            </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Descripción:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtBuscarDescripcion" runat="server" Width="300px" MaxLength="50"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Instruccionable:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBuscarInstruccionable" runat="server">
                                            <asp:ListItem Value="0">Escoja una Opción</asp:ListItem>
                                            <asp:ListItem Value="1">SI</asp:ListItem>
                                            <asp:ListItem Value="2">NO</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Estado:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBuscarEstado" runat="server">
                                            <asp:ListItem Value="0">Escoja un Estado</asp:ListItem>
                                            <asp:ListItem Value="1">Activo</asp:ListItem>
                                            <asp:ListItem Value="2">Inactivo</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center">
                                        <br />
                                        <br />
                                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="busqueda" CssClass="submit" />
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:Button ID="btnCancelarBuscar" runat="server" Text="Cancelar" CssClass="submit" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <br />
            <table class="tabla">
                <tr>
                    <th style="text-align: center">
                        LISTADO DE TIPOS DE PRODUCTO REGISTRADOS
                    </th>
                </tr>
                <tr>
                    <td>
                        <asp:GridView ID="gvListado" runat="server" EmptyDataText="<blockquote>No se encontraron registros</blockquote>"
                            AllowPaging="True" AutoGenerateColumns="False" PageSize="30" ShowFooter="True"
                            Style="margin-top: 0px">
                            <Columns>
                                <asp:BoundField DataField="idTipoProducto" HeaderText="ID"  ItemStyle-HorizontalAlign="Center"/>
                                <asp:BoundField DataField="descripcion" HeaderText="DESCRIPCIÓN" />
                                <asp:BoundField DataField="descInstruccionable" HeaderText="INSTRUCCIONABLE" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="unidadEmpaque" HeaderText="UNIDAD DE EMPAQUE" />
                                <asp:BoundField DataField="descAplicaTecnologia" HeaderText="APLICA TECNOLOGÍA" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="descEstado" HeaderText="ESTADO" />
                                <asp:TemplateField HeaderText="OPCIÓN" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibActualizar" ImageUrl="~/images/Edit-32.png" ToolTip="Actualizar"
                                            CommandName="actualizar" CommandArgument='<%# Bind("idTipoProducto") %>' runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle CssClass="thGris" />
                            <PagerStyle HorizontalAlign="Center" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="mpWait" runat="server" />
    </form>
</body>
</html>
