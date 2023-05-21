<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuscarClientes.aspx.vb"
    Inherits="BPColSysOP.BuscarClientes" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Busqueda de Clientes</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
    </div>
    <table class="tablaGris">
        <tr>
            <th class="field" colspan="4">
                Datos del Cliente
            </th>
        </tr>
        <tr>
            <td class="field">
                Nombre
            </td>
            <td colspan="3">
                <asp:TextBox ID="txtNombreCliente" runat="server" Width="90%" MaxLength="70"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="field">
                NIT
            </td>
            <td>
                <asp:TextBox ID="txtNit" runat="server"></asp:TextBox>
            </td>
            <td class="field">
                Canal de Distribución
            </td>
            <td>
                <asp:DropDownList ID="ddlCanal" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="field">
                Codigo Cliente
            </td>
            <td>
                <asp:TextBox ID="txtCodigoCliente" runat="server"></asp:TextBox>
            </td>
            <td class="field">
                Centro - Almacen
            </td>
            <td>
                <asp:TextBox ID="txtCentro" runat="server" Width="80px"></asp:TextBox>
                &nbsp;-
                <asp:TextBox ID="txtAlmacen" runat="server" Width="80px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="field">
                Ciudad
            </td>
            <td>
                <asp:DropDownList ID="ddlCiudad" runat="server">
                </asp:DropDownList>
            </td>
            <td class="field">
                Región
            </td>
            <td>
                <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <center>
                    <br />
                    <asp:Button ID="btnCliente" runat="server" Text="Consultar" /></center>
            </td>
        </tr>
    </table>
    <br />
    <asp:GridView ID="gvClientes" runat="server" AutoGenerateColumns="False" CssClass="grid"
        DataKeyNames="idcliente" 
        EmptyDataText="No se encotraron registros para mostrar">
        <Columns>
            <asp:BoundField DataField="idcliente" HeaderText="ID Cliente" InsertVisible="False" 
                ReadOnly="True" SortExpression="idcliente" />
            <asp:TemplateField HeaderText="Nombre">
                <ItemTemplate>
                    <asp:LinkButton  ID="lnkEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("idCliente") %>'
                        Text='<%# Eval("cliente") %>'></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="idcliente2" HeaderText="Codigo Cliente" SortExpression="idcliente2" />
            <asp:BoundField DataField="nit" HeaderText="Nit" SortExpression="nit" />
            <asp:BoundField DataField="dealer" HeaderText="Dealer" SortExpression="dealer" />
            <asp:BoundField DataField="ciudad" HeaderText="Ciudad" SortExpression="idciudad" />
            <asp:BoundField DataField="direccion" HeaderText="Dirección" SortExpression="direccion" />
            <asp:BoundField DataField="telefonos" HeaderText="Teléfonos" SortExpression="telefonos" />
            <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
            <asp:BoundField DataField="gerente" HeaderText="Gerente" SortExpression="gerente" />
            <asp:BoundField DataField="gerente_cel" HeaderText="Celular" SortExpression="gerente_cel" />
            <asp:BoundField DataField="estado" HeaderText="Estado" SortExpression="estado" />
            <asp:BoundField DataField="region" HeaderText="Region" SortExpression="region" />
            <asp:BoundField DataField="idTipoDestinatario" HeaderText="Tipo Destinatario" SortExpression="idTipoDestinatario" />
            <asp:BoundField DataField="centro" HeaderText="Centro" SortExpression="centro" />
            <asp:BoundField DataField="almacen" HeaderText="Almacen" SortExpression="almacen" />
            <asp:BoundField DataField="ciudad" HeaderText="Ciudad" SortExpression="ciudad" />
        </Columns>
        <AlternatingRowStyle CssClass="alternatingItem" />
    </asp:GridView>
    </form>
</body>
</html>
