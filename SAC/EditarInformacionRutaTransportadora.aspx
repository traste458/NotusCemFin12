<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarInformacionRutaTransportadora.aspx.vb" Inherits="BPColSysOP.EditarInformacionRutaTransportadora" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class = "cuerpo2">
    <form id="form1" runat="server">
    <div>
    
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        
        <table width = "750px" class = "tabla">
            <tr>
                <th colspan = "2">
                    Editar información de rutas
                </th>                
            </tr>
            <tr>
                <td class = "field" width = "20%">
                    Ciudad origen:
                </td>
                <td>
                    <asp:DropDownList ID="ddlCiudadOrigen" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="ddlCiudadOrigen" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Debe escoger una ciudad" InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class = "field" width = "20%">
                    Ciudad destino:
                </td>
                <td>
                    <asp:DropDownList ID="ddlCiudadDestino" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="ddlCiudadDestino" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Debe escoger una ciudad" InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class = "field" width = "20%">
                    Transportadora:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTransportadora" runat="server">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ControlToValidate="ddlTransportadora" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Debe escoger una transportadora" InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td class = "field" width = "20%">
                    Tipo Producto:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipoProducto" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="ddlTipoProducto" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Debe escoger un tipo de producto" InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td class = "field" width = "20%">
                    Tipo Destinatario:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipoDestinatario" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                        ControlToValidate="ddlTipoDestinatario" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Debe escoger un tipo de destinatario" 
                        InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td class = "field" width = "20%">
                    Tipo Transporte:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipoTransporte" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                        ControlToValidate="ddlTipoTransporte" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Debe escoger un tipo de transporte" InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class = "field" width = "20%">
                                        Código:</td>
                <td>
                    <asp:TextBox ID="txtCodigo" runat="server" MaxLength="20"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;El código no puede estar vacío" 
                        ControlToValidate="txtCodigo"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan = "2">
                    &nbsp;
                    <asp:Button ID="btnEditar" runat="server" CssClass="submit" Text="Editar" />
                </td>                
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
