<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DetalleLogRecoleccion.aspx.vb" Inherits="BPColSysOP.DetalleLogRecoleccion" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
     <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

</head>
<body class ="cuerpo2">
    <form id="form1" runat="server">
                        <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
    <div class="thGris">Referencias y Serriales</div>
    <div class="search">
    
        <asp:UpdatePanel ID="UpdatePanelMateriales" runat="server" 
                UpdateMode="Conditional">
                <ContentTemplate>

                    <table>
                        <tr>
                            <td valign="top">
                                <div id="divReferencias">
                                    <asp:GridView ID="gvMateriales" runat="server" AutoGenerateColumns="False"  EmptyDataText="<blockquote><p>No se han registrado Referencias</p></blockquote>"
                                        BorderStyle="None" CssClass="grid" DataKeyNames="material" 
                                        ShowFooter="True" Width="440px">
                                        <FooterStyle CssClass="footerChildDG" />
                                        <SelectedRowStyle BackColor="LightSteelBlue" />
                                        <AlternatingRowStyle CssClass="alterItemChildDG" />
                                        <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="thGris" HorizontalAlign="Center" />
                                        <Columns>
                                            <asp:ButtonField CommandName="Select" DataTextField="material" 
                                                HeaderText="Material" Text="Select" />
                                            <asp:BoundField DataField="referencia" HeaderText="Referencia" />
                                            <asp:BoundField DataField="cantidad" HeaderText="Cantidad" />
                                        </Columns>
                                        <PagerStyle CssClass="pagerChildDG" />
                                    </asp:GridView>
                                </div>
                            </td>
                            <td>
                            </td>
                            <td valign="top">
                                <asp:LinkButton ID="lnkVerTodos" TabIndex="15" runat="server" Width="160px" CommandName="ver"><img src="../images/arrow_down2.gif" border="0" alt="Agregar Referencia">&nbsp;Ver todos los Seriales</asp:LinkButton>
                                <asp:Panel ID="pnlSeriales" runat="server">
                                    <asp:GridView ID="gvSeriales" runat="server" AutoGenerateColumns="False" Width="300px" EmptyDataText="<blockquote><p>No se han registrado Seriales</p></blockquote>"
                                        DataKeyField="serial" ShowFooter="True" GridLines="None">
                                        <AlternatingRowStyle CssClass="alterItemChildDG" />
                                        <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
                                        </HeaderStyle>
                                        <FooterStyle CssClass="footerChildDG" />
                                        <Columns>
                                            <asp:BoundField DataField="serial" HeaderText="Serial"></asp:BoundField>
                                            <asp:BoundField DataField="material" HeaderText="Material"></asp:BoundField>
                                             <asp:CheckBoxField DataField="CajaVacia" HeaderText="Es Caja Vacía" />
                                        </Columns>
                                        <PagerStyle CssClass="pagerChildDG" />
                                    </asp:GridView>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
    
    </div>
    <br />
    <div class="thGris">Accesorios y otros productos</div>    
      <div class="search"><asp:GridView ID="gvAccesorios" runat="server" AutoGenerateColumns="False" ShowFooter="True" EmptyDataText="<blockquote><p>No se han registrado accesorios</p></blockquote>"
                GridLines="None">
                <FooterStyle CssClass="footerChildDG" />
                <SelectedRowStyle BackColor="LightSteelBlue" />
                <AlternatingRowStyle CssClass="alterItemChildDG" />
                <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                <HeaderStyle CssClass="thGris" HorizontalAlign="Center" />
                <Columns>
                    <asp:ButtonField CommandName="Select" DataTextField="articulo" HeaderText="Articulo">
                    </asp:ButtonField>
                    <asp:BoundField DataField="cantidadPedida" HeaderText="Cantidad">
                        <HeaderStyle Width="80px" />
                    </asp:BoundField>
                </Columns>
                <PagerStyle CssClass="pagerChildDG" />
            </asp:GridView></div>
            
    </form>
</body>
</html>
