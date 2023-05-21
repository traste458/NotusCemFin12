<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ActualizarClientes.aspx.vb" Inherits="BPColSysOP.ActualizarClientes" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Actualización de Clientes</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
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
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorNombre" runat="server" ErrorMessage="Debe proporcionar un nombre"
                        ControlToValidate="txtNombreCliente" Display="Dynamic"></asp:RequiredFieldValidator></div>
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
                <asp:DropDownList ID="ddlCiudad" runat="server" AutoPostBack="True">
                </asp:DropDownList>
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Debe proporcionar una ciudad"
                        ControlToValidate="ddlCiudad" Display="Dynamic"></asp:RequiredFieldValidator></div>
            </td>
            <td class="field">
                Región
            </td>
            <td>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:Label ID="lblRegion" runat="server"></asp:Label>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlCiudad" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td class="field">
                Dirección
            </td>
            <td>
                <asp:TextBox ID="txtDireccion" runat="server"></asp:TextBox>
            </td>
            <td class="field">
                Teléfono
            </td>
            <td>
                <asp:TextBox ID="txtTelefono" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="field">
                Gerente
            </td>
            <td >
                <asp:TextBox ID="txtGerente" runat="server"></asp:TextBox>
            </td>
            <td class="field">
                E-mail
            </td>
            <td >
                <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="field">
                Estado</td>
            <td >
                <asp:RadioButton ID="rdbActivo" runat="server" GroupName="estado" 
                    Text="Activo" />
                <asp:RadioButton ID="rdbInactivo" runat="server" GroupName="estado" 
                    Text="Inactivo" />
            </td>
            <td class="field">
                Dealer</td>
            <td>
                <asp:TextBox ID="txtDealer" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <center>
                    <br />
                    <asp:Button ID="btnCliente" runat="server" Text="Actualizar" /></center>
            </td>
        </tr>
    </table>
    </form>
</body>
</html> 