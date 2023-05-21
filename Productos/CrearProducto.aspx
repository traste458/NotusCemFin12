<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearProducto.aspx.vb"
    Inherits="BPColSysOP.CrearProducto" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Creación de Producto</title>
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
    <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            </div>
            <div>
                <asp:HyperLink ID="hlBuscar" runat="server" NavigateUrl="~/Productos/BuscarActualizarProducto.aspx"><img src="../images/find.gif" alt=""/>&nbsp;Buscar </asp:HyperLink>
                <br />
                <br />
            </div>
            <dx:ASPxRoundPanel ID="rpInformacion" runat="server" HeaderText="INFORMACIÓN DEL PRODUCTO">
                <PanelCollection>
                    <dx:PanelContent>
                        <table class="tabla">
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
                                            Display="Dynamic" ErrorMessage="Digite el nombre del Producto, por favor" ValidationGroup="registrar">
                                        </asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="revNombre" runat="server" ControlToValidate="txtNombre"
                                            Display="Dynamic" ErrorMessage="El nombre no es válido, por favor verifique que no se esten utilizando caracteres especiales."
                                            ValidationGroup="registrar" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑñÑ\-\#\[\]\(\)]+\s*$">
                                        </asp:RegularExpressionValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td  class="field">
                                    Código homologación
                                </td> 
                                <td>
                                    <asp:TextBox ID="txtCodigoHomologacion" runat="server" MaxLength="20" 
                                        Width="200px"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="revCodigoHomologacion" runat="server" ErrorMessage="El dato proporionado no es v&aacute;lido, por favor verifique que no se esten utilizando caracteres especiales no permitidos"
                                            ControlToValidate="txtCodigoHomologacion" Display="Dynamic" ValidationGroup="registrar"
                                            ValidationExpression="^[\s]{0,}[a-zA-Z0-9\-\.]+[\s]{0,}$"></asp:RegularExpressionValidator>
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
                                    <asp:DropDownList ID="ddlUnidadEmpaque" runat="server">
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
                                            <td valign="middle">
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
                                </td>
                            </tr>
                        </table>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="mpWait" runat="server" />
    </form>
</body>
</html>
