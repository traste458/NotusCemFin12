<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuscarActualizarProducto.aspx.vb"
    Inherits="BPColSysOP.BuscarActualizarProducto" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Busqueda / Actualización producto</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function HayProveedorSeleccionado(source, args) {
            try {
                var numProveedores = $("input[id*=hfNumProveedores]").val();
                if (numProveedores == "" || numProveedores == "0") {
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            } catch (ex) {
                args.IsValid = false;
            }
        }

        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            if (e.callbackData != null) {
                $('#divFileContainer').html(e.callbackData);
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="smAjaxManager" runat="server">
    </asp:ScriptManager>
    <%-- <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>--%>
    <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
    <table>
        <tr>
            <td>
                <asp:HyperLink ID="hlCrear" runat="server" NavigateUrl="~/Productos/CrearProducto.aspx"><img src="../images/save_all.png" alt="" />&nbsp;Crear Nuevo</asp:HyperLink>
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
                <asp:HiddenField ID="hfUpdateManager" runat="server" />
                <cc1:ModalPopupExtender ID="mpeVisualizacionImagen" runat="server" 
                    Enabled="True" TargetControlID="hfUpdateManager" BackgroundCssClass="modalBackground"
                    PopupControlID="pnlVerImagen">
                </cc1:ModalPopupExtender>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlRegistro" runat="server" Style="display: none; overflow: auto;"
                    CssClass="modalPopUp">
                    <div style="text-align: center; width: 100%;">
                        <uc1:EncabezadoPagina ID="epRegisterNotifier" runat="server" />
                    </div>
                    <dx:ASPxRoundPanel ID="rpInformacion" runat="server" HeaderText="FORMULARIO DE ACTUALIZACIÓN">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table class="tabla" align="center">
                                    <tr>
                                        <td class="field">
                                            Tipo de Producto:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlTipoProducto" runat="server" AutoPostBack="True">
                                            </asp:DropDownList>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvTipoProducto" runat="server" ControlToValidate="ddlTipoProducto"
                                                    InitialValue="0" Display="Dynamic" ErrorMessage="Escoja un Tipo de Producto, por favor"
                                                    ValidationGroup="registrar"></asp:RequiredFieldValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Código:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtCodigo" runat="server" MaxLength="10"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Nombre:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNombre" runat="server" Width="300px" MaxLength="50"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                                                    Display="Dynamic" ErrorMessage="Digite el nombre del Producto, por favor" ValidationGroup="registrar"></asp:RequiredFieldValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Código homologación
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txthomologacion" runat="server" Width="300px" MaxLength="50"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txthomologacion"
                                                    Display="Dynamic" ErrorMessage="El Codigo no es válido, por favor verifique que no se esten utilizando caracteres especiales."
                                                    ValidationGroup="registrar" ValidationExpression="^\s*[a-zA-Z_0-9-]+\s*$">
                                                </asp:RegularExpressionValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Fabricante:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlFabricante" runat="server">
                                            </asp:DropDownList>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvFabricante" runat="server" ControlToValidate="ddlFabricante"
                                                    Display="Dynamic" InitialValue="0" ErrorMessage="Escoja un Fabricante, por favor"
                                                    ValidationGroup="registrar"></asp:RequiredFieldValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="trTecnologia" runat="server">
                                        <td class="field">
                                            Tecnología
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlTecnologia" runat="server">
                                            </asp:DropDownList>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvTecnologia" runat="server" ControlToValidate="ddlTecnologia"
                                                    Display="Dynamic" InitialValue="0" ErrorMessage="Escoja una Tecnología, por favor"
                                                    ValidationGroup="registrar"></asp:RequiredFieldValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="trRequiereConsecutivo" runat="server">
                                        <td class="field">
                                            Requiere Conscutivo:
                                        </td>
                                        <td align="left">
                                            <asp:RadioButtonList ID="rblConsecutivo" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="1" Text="SI"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="NO" Selected="True"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Unidad Empaque:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlUnidadEmpaque" runat="server" Enabled="false">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
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
                                        <td class="field">
                                            Proveedor:
                                        </td>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td valign="middle" class="field">
                                                        <asp:ImageButton ID="ibAdicionar" runat="server" ImageUrl="~/images/add.png" ValidationGroup="adicionar" />&nbsp;&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlProveedor" runat="server">
                                                        </asp:DropDownList>
                                                        <div style="display: block">
                                                            <asp:RequiredFieldValidator ID="rfvProveedor" runat="server" ErrorMessage="Escoja un Proveedor, por favor"
                                                                ControlToValidate="ddlProveedor" InitialValue="0" Display="Dynamic" ValidationGroup="adicionar"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:DataGrid ID="dgProveedor" runat="server" AutoGenerateColumns="False">
                                                            <HeaderStyle CssClass="thGris" />
                                                            <Columns>
                                                                <asp:BoundColumn DataField="nombre" HeaderText="Proveedor"></asp:BoundColumn>
                                                                <asp:TemplateColumn HeaderText="Opción">
                                                                    <ItemTemplate>
                                                                        <asp:ImageButton ID="ibQuitar" runat="server" ImageUrl="~/images/remove.png" CommandName="quitar"
                                                                            CommandArgument='<%# Bind("idProveedor") %>' ValidationGroup="quitar" />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" />
                                                                </asp:TemplateColumn>
                                                            </Columns>
                                                        </asp:DataGrid>
                                                        <div style="display: block;">
                                                            <asp:CustomValidator ID="cvProveedor" runat="server" ErrorMessage="Debe especificar por lo menos un Proveedor."
                                                                ValidationGroup="registrar" ClientValidationFunction="HayProveedorSeleccionado"></asp:CustomValidator>
                                                        </div>
                                                        <asp:HiddenField ID="hfNumProveedores" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Imagen(es) del producto:
                                        </td>
                                        <td align="left">
                                            <div id="divFileContainer" style="width: auto">
                                            </div>
                                            <dx:ASPxUploadControl ID="ucImagenes" runat="server" ClientInstanceName="ucImagenes"
                                                NullText="Seleccione las imagenes del producto..." ShowProgressPanel="True" UploadMode="Advanced"
                                                Width="400px" ShowAddRemoveButtons="True" ShowUploadButton="True">
                                                <ClientSideEvents FilesUploadComplete="function(s, e) { ProcesarCarga(s, e); }" />
                                                <ValidationSettings AllowedFileExtensions=".png, .gif, .jpg" MaxFileSize="10485760">
                                                </ValidationSettings>
                                            </dx:ASPxUploadControl>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" ValidationGroup="registrar"
                                                CssClass="submit" />
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="submit" />
                                            <asp:HiddenField ID="hIdProducto" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </asp:Panel>
                <asp:Panel ID="pnlBusqueda" runat="server" Style="display: none; width: 500px;" CssClass="modalPopUp">
                    <div style="text-align: center; width: 100%;">
                        <uc1:EncabezadoPagina ID="epFindNotifier" runat="server" />
                    </div>
                    <dx:ASPxRoundPanel ID="rpBusqueda" runat="server" HeaderText="FORMULARIO DE BÚSQUEDA"
                        Width="100%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table class="tabla" align="center">
                                    <tr>
                                        <td class="field">
                                            Tipo de Producto:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlBuscarTipoProducto" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Código:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtBuscarCodigo" runat="server" MaxLength="10"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Nombre:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtBuscarNombre" runat="server" Width="300px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Fabricante:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlBuscarFabricante" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr id="tr1" runat="server">
                                        <td class="field">
                                            Tecnología
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlBuscarTecnologia" runat="server">
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
                                        <td class="field">
                                            Proveedor:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlBuscarProveedor" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="busqueda"
                                                CssClass="submit" />
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:Button ID="btnCancelarBuscar" runat="server" Text="Cancelar" CssClass="submit" />
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </asp:Panel>
                <asp:Panel ID="pnlVerImagen" runat="server">
                    <dx:ASPxImageSlider ID="isImagenes" runat="server">
                    </dx:ASPxImageSlider>
                    <asp:Button ID="btnCerrarVisualizar" runat="server" Text="Cerrar" CssClass="submit" />
                </asp:Panel>
            </td>
        </tr>
    </table>
    <br />
    <table class="tabla">
        <tr>
            <th style="text-align: center">
                LISTADO DE PRODUCTOS REGISTRADOS
            </th>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="gvListado" runat="server" EmptyDataText="<blockquote>No se encontraron registros</blockquote>"
                    AllowPaging="True" AutoGenerateColumns="False" PageSize="30" ShowFooter="True"
                    Style="margin-top: 0px" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="nombre" HeaderText="NOMBRE" />
                        <asp:BoundField DataField="codigo" HeaderText="CÓDIGO" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="tecnologia" HeaderText="TECNOLOGÍA" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="fabricante" HeaderText="FABRICANTE" />
                        <asp:BoundField DataField="tipoProducto" HeaderText="TIPO PRODUCTO" />
                        <asp:BoundField DataField="unidadEmpaque" HeaderText="UNIDAD DE EMPAQUE" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="proveedor" HeaderText="PROVEEDOR" HtmlEncode="false" />
                        <asp:BoundField DataField="descEstado" HeaderText="ESTADO" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="OPCIÓN" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="ibActualizar" ImageUrl="~/images/Edit-32.png" ToolTip="Actualizar"
                                    CommandName="actualizar" CommandArgument='<%# Bind("idProducto") %>' runat="server" />
                                <asp:ImageButton ID="ibImagen" ImageUrl="~/images/search.png" ToolTip="Ver Imagen"
                                    CommandName="visualizar" CommandArgument='<%# Bind("idProducto") %>' runat="server" />
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
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
    <uc2:ModalProgress ID="mpWait" runat="server" />
    </form>
</body>
</html>
