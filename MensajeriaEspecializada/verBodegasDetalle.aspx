<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="verBodegasDetalle.aspx.vb" Inherits="BPColSysOP.verBodegasDetalle" %>

<!DOCTYPE html>
<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Ver información de Bodega</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
</head>
<body>
    <form id="form1" runat="server">
        <div>

        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
        </div>
        <div>
            <asp:Panel ID="pnlCreacion" runat="server">
            
            <table class="tablaGris">
                <tr>
                    <td class="field">
                        Codigo :
                    </td>
                    <td>
                        <asp:Label runat="server" ID="lbCodigo"></asp:Label>
                    </td>
                    <td class="field">
                        Codigo 2 :
                    </td>
                    <td>
                        <asp:Label runat="server" ID="idBod2"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        ID :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbIdBodega"></asp:Label>
                    </td>
                    <td class="field">
                        Bodega :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbBodega"></asp:Label>
                    </td>
                </tr>
                <tr>
                     <td class="field">
                        Dirección :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbDireccion" ></asp:Label>
                    </td>
                    <td class="field">
                        Telefono :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbTelefono"></asp:Label>
                    </td>
                </tr>
                <tr>
                     <td class="field">
                        Ciudad :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbCiudad"></asp:Label>
                    </td>
                    <td class="field">
                        Estado :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbEstado"></asp:Label>
                    </td>
                </tr>
                <tr>
                     <td class="field">
                        Acepta producto sin reconocimiento :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbAcept"></asp:Label>
                    </td>
                    <td class="field">
                        Cliete Externo :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbClie"></asp:Label>
                    </td>
                </tr>
                <tr>
                     <td class="field">
                        Unidad de negocio :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbUnidNeg"></asp:Label>
                    </td>
                    <td class="field">
                        Tipo :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbTipo"></asp:Label>
                    </td>
                </tr>
                <tr>
                     <td class="field">
                        Token SimpliRoute :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lbTokenSimpliRoute"></asp:Label>
                    </td>
                    <td colspan="2" >
                    </td>
                </tr>
                <tr>
                     <td class="field">
                        codigo Sucursal InterRapidisimo :
                    </td>
                    <td>
                    <asp:Label runat="server" ID="lblcodigoSucursalInterRapidisimo"></asp:Label>
                    </td>
                    <td colspan="2" >
                    </td>
                </tr>

            </table>
           </asp:Panel>
            <br />
            <div>
                <asp:Label runat="server" ID="lbMsg"><b>Ciudades cercanas</b></asp:Label>
            </div>
            <div>
            <asp:GridView ID="gvCiudades" runat="server" CssClass="grid" PageSize="10" AutoGenerateColumns="False" CellPadding="3"
            DataKeyNames="idCiudad" Width="30%" EmptyDataText="<blockquote><p>No hay ciudades</p></blockquote>">
            <AlternatingRowStyle CssClass="alternatingItem" />
            <PagerSettings Position="Bottom" FirstPageText="|<" LastPageText=">|" NextPageText=">>"
                PreviousPageText="<<" Mode="NumericFirstLast" />
            <PagerStyle HorizontalAlign="Left" Font-Names="Arial" Font-Size="11px" />
            <Columns>


                <asp:TemplateField HeaderText="idCiudad">
                    <ItemTemplate>
                        <asp:Label ID="lbidCiudad" runat="server" Text='<%# Bind("idCiudad") %>'></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle Width="50px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="ciudad" SortExpression="ciudad">
                    <ItemTemplate>
                        <asp:Label ID="lbCiudad" runat="server" Text='<%# Bind("ciudad")%>'></asp:Label>
                    </ItemTemplate>                    
                    <ItemStyle HorizontalAlign="Center" CssClass="restablecercentro" />
                </asp:TemplateField>      
            </Columns>

            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Left" />
            <HeaderStyle CssClass="sin_orden" />
        </asp:GridView>
        </div>
        </div>
    </form>
</body>
</html>
