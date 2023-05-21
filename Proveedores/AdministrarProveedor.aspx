<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministrarProveedor.aspx.vb"
    Inherits="BPColSysOP.AdministrarProveedor" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Página sin título</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
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
                        <asp:Panel ID="pnlRegistro" runat="server" Style="display: none; width: 500px;
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
                                        Nombre:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtNombre" runat="server" Width="300px" MaxLength="70"></asp:TextBox>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ErrorMessage="Digite el nombre del fabricante, por favor"
                                                Display="Dynamic" ValidationGroup="registro" SetFocusOnError="True" ControlToValidate="txtNombre"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Dirección:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDireccion" runat="server" Width="300px" MaxLength="70"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Teléfono:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTelefono" runat="server" MaxLength="30"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Ciudad:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlCiudad" runat="server">
                                        </asp:DropDownList>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvCiudad" runat="server" ErrorMessage="Seleccione una ciudad, por favor"
                                                Display="Dynamic" ValidationGroup="registro" SetFocusOnError="True" ControlToValidate="ddlCiudad"
                                                InitialValue="0"></asp:RequiredFieldValidator>
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
                                        <asp:HiddenField ID="hIdProveedor" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="pnlBusqueda" runat="server" Style="display: inline; width: 500px;
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
                                        Nombre:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtBuscarNombre" runat="server" Width="300px" MaxLength="70"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Ciudad:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBuscarCiudad" runat="server">
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
                                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="submit" />
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
                        LISTADO DE PROVEEDORES REGISTRADOS
                    </th>
                </tr>
                <tr>
                    <td>
                        <asp:GridView ID="gvListado" runat="server" EmptyDataText="<blockquote>No se encontraron registros</blockquote>"
                            AllowPaging="True" AutoGenerateColumns="False" PageSize="30" ShowFooter="True"
                            Style="margin-top: 0px">
                            <Columns>
                                <asp:BoundField DataField="nombre" HeaderText="NOMBRE" />
                                <asp:BoundField DataField="direccion" HeaderText="DIRECCIÓN" />
                                <asp:BoundField DataField="telefono" HeaderText="TELÉFONO" />
                                <asp:BoundField DataField="ciudad" HeaderText="CIUDAD" />
                                <asp:BoundField DataField="descEstado" HeaderText="ESTADO" />
                                <asp:TemplateField HeaderText="OPCIÓN" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibActualizar" ImageUrl="~/images/Edit-32.png" ToolTip="Actualizar"
                                            CommandName="actualizar" CommandArgument='<%# Bind("idProveedor") %>' runat="server" />
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
