<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmarDevolucionAccesorios.aspx.vb" Inherits="BPColSysOP.ConfirmarDevolucionAccesorios" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" class="cuerpo2">
    <div>
        
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
        <asp:ScriptManager runat ="server" ID="sm"/>
        <asp:HiddenField ID="hfIdDevolucion" runat="server" />
    </div>
    <div>
            <div class="izquierda">
        <asp:Button ID="btnConfirmarTop" runat="server" Text="Confirmar y Regresar" 
                    CssClass="submit" />
            
                <br />
            
                <br />
            
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvAccesorios" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                            CssClass="tabla" GridLines="None">
                            <FooterStyle CssClass="footer" />
                            <SelectedRowStyle BackColor="LightSteelBlue" />
                            <AlternatingRowStyle CssClass="alternatingRow" />
                            <HeaderStyle CssClass="thGris" HorizontalAlign="Center" />
                            <Columns>
                                <asp:BoundField DataField="articulo" HeaderText="Articulo" ReadOnly="True" />
                                <asp:BoundField DataField="cantidadRecogida" HeaderText="Cantidad Recogida" ReadOnly="True">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Cantidad Entregada">
                                    <ItemTemplate>
                                       <asp:TextBox ID="txtCantidadEntregada" runat="server" Text='<%# Bind("cantidadEntregada") %>'
                                            Width="60px" MaxLength="5"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorCantidad" 
                                            runat="server" ControlToValidate="txtCantidadEntregada" Display="Dynamic" 
                                            ErrorMessage="La cantidad debe ser numérica" ValidationExpression="\d+"></asp:RegularExpressionValidator>
                                        <div>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorcant" 
                                            runat="server" ControlToValidate="txtCantidadEntregada" Display="Dynamic" 
                                            ErrorMessage="La cantidad debe ser numérica" ValidationExpression="\d+"></asp:RegularExpressionValidator></div>
                                    </ItemTemplate>
                                    
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagerChildDG" />
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <br />
                  <asp:Button ID="btnConfirmar" runat="server" Text="Confirmar y Regresar" 
                    CssClass="submit" />
            </div>
      
        </div>
    </form>
</body>
</html>
