<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultarImagenesDeProducto.aspx.vb" Inherits="BPColSysOP.ConsultarImagenesDeProducto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <asp:GridView ID="gvImagenes" runat="server" AutoGenerateColumns="False"
            CssClass="tabla" Width="90%">
            <Columns>
                <asp:BoundField DataField="producto" HeaderText="Producto">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Imagen">
                    <ItemTemplate>
                        <asp:Image ID="imgProducto" runat="server" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
            <HeaderStyle HorizontalAlign="Center" />
        </asp:GridView>
    </form>
</body>
</html>
