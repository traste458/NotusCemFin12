<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarInformacionValorDeclarado.aspx.vb" Inherits="BPColSysOP.EditarInformacionValorDeclarado" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>:: Editar información de valores declarados ::</title>
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
                    Editar valores declarados
                </th>                
            </tr>
            <tr>
                <td class = "field" width = "20%">
                    Centro:
                </td>
                <td>
                    <asp:DropDownList ID="ddlCentro" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="ddlCentro" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Es necesario especificar un centro" InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class = "field" width = "20%">
                    Material:
                </td>
                <td>
                    <asp:DropDownList ID="ddlMaterial" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="ddlMaterial" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;Es necesario especificar un material" 
                        InitialValue="0"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class = "field" width = "20%">
                    Valor declarado:
                </td>
                <td>
                    $ &nbsp; 
                    <asp:TextBox ID="txtValor" runat="server" MaxLength="10"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        Display="Dynamic" ErrorMessage="&lt;br /&gt;El valor no puede estar vacío" 
                        ControlToValidate="txtValor"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                        ControlToValidate="txtValor" Display="Dynamic" 
                        ErrorMessage="&lt;br /&gt;El valor digitado debe ser numérico" 
                        ValidationExpression="^[0-9]+$"></asp:RegularExpressionValidator>
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
