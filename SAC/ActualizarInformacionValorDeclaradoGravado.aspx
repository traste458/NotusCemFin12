<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ActualizarInformacionValorDeclaradoGravado.aspx.vb"
    Inherits="BPColSysOP.ActualizarInformacionValorDeclaradoGravado" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Página sin título</title>
    <link href="../include/styleBACK.css" rel="Stylesheet" type="text/css" />
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <uc1:EncabezadoPagina ID="ucEncabezado" runat="server" />
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div id="agregarMaterial" class="thGris" style="border: none 0px; width: 700px;">
        <asp:Label ID="lblblockquote" runat="server" Text="Seleccione material para adicionar a la lista de materiales con valor declarado excento de IVA"></asp:Label>&nbsp;
    </div>
    <asp:Panel ID="pnlAgregarRegistro" runat="server" Style="border: none 0px; width: 700px;"
        CssClass="tablaGris">
        <br />
        <asp:DropDownList ID="ddlMaterial" runat="server" Width="650px">
            <asp:ListItem Value="0">Seleccione material</asp:ListItem>
        </asp:DropDownList>
        <cc1:ListSearchExtender ID="ddlMaterial_ListSearchExtender" runat="server" Enabled="true"
            PromptText="Digite para filtrar..." QueryPattern="Contains" TargetControlID="ddlMaterial"
            PromptCssClass="listSearchTheme">
        </cc1:ListSearchExtender>
        <asp:ImageButton ID="imbtnAdicionar" runat="server" Style="vertical-align: middle"
            ToolTip="Agreaga material a la lista de precios excentos de Impuesto." ImageUrl="~/images/add.png"
            ValidationGroup="RegistroMaterial" />
        &nbsp;
        <asp:ImageButton ID="imbtnBuscar" runat="server" ImageUrl="~/images/find.GIF" Style="vertical-align: middle"
            ToolTip="Filtra el listado por material seleccionado." 
            ValidationGroup="RegistroMaterial" CausesValidation="False" />
        <asp:RequiredFieldValidator ID="rfvTxtMaterial" runat="server" ControlToValidate="ddlMaterial"
            InitialValue="0" Display="Dynamic" ErrorMessage="<br/>Ingrese Material." 
            ValidationGroup="RegistroMaterial"></asp:RequiredFieldValidator>
    </asp:Panel>
    <asp:Panel ID="pnlListaValorDeclaradoExcentoImpuesto" runat="server">
        <asp:GridView ID="gvDatosValorDeclaradoExcento" runat="server" AutoGenerateColumns="False"
            CssClass="grid" 
            EmptyDataText="No existen materiales excentos de impuesto." ShowFooter="True"
            Width="700px" AllowPaging="True" PageSize="15">
            <AlternatingRowStyle CssClass="alterColor" />
            <PagerSettings Mode="NumericFirstLast" />
            <FooterStyle CssClass="footerChildDG" />
            <Columns>
                <asp:BoundField DataField="material" HeaderText="Material" ItemStyle-Width="100px">
                    <ItemStyle Width="100px" />
                </asp:BoundField>
                <asp:BoundField DataField="subproducto" HeaderText="Descripción Material" ItemStyle-Width="520px">
                    <ItemStyle Width="520px" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Opciones" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="chkEliminar" />
                    </ItemTemplate>
                    <HeaderTemplate>
                        <asp:LinkButton ID="Eliminar" runat="server" CommandName="Eliminar">
                        <asp:Image runat="server" ImageAlign="Middle" ImageUrl="~/images/remove.png" />
                        Eliminar</asp:LinkButton>
                    </HeaderTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
            <PagerStyle BorderStyle="None" CssClass="celdaTitulo" />
            <HeaderStyle HorizontalAlign="Center" />
        </asp:GridView>
    </asp:Panel>
    </form>
</body>
</html>
