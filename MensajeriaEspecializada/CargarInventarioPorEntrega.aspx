<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargarInventarioPorEntrega.aspx.vb" 
Inherits="BPColSysOP.CargarInventarioPorEntrega" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cargar Inventario por Entrega</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        
        function ProcesarEnter() {

            var btn = document.getElementById("lbBuscar");
            var kCode = (event.keyCode ? event.keyCode : event.which);

            if (kCode.toString() == "13") {

                DetenerEvento(event)
                btn.click();

            }

        }
       
        
    </script>
    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            width: 1px;
        }
    </style>
</head>

<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <input id="hfPosFiltrado" type="hidden" value="0" runat="server" />
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        LoadingDialogID="ldrWait_dlgWait">
        <table class="tablaGris" style="width: auto;">
        <asp:Panel ID="pnlEntrega" runat="server">
                            <tr>
                                <td colspan="4" style="text-align: center" class="thGris">
                                    INGRESE LOS DATOS PARA CARGAR EL INVENTARIO
                                </td>
                            </tr>
                            <tr>
                                <td class="field" align="left">
                                    Número de Entrega:
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtNumeroEntrega" runat="server" TabIndex = "1" MaxLength ="10" onkeydown="ProcesarEnter();"></asp:TextBox>
                                    <div>
                                    <asp:RequiredFieldValidator ID="rfvNumeroEntrega" runat="server" ErrorMessage="Numero de entrega Requerido"
                                          Display="Dynamic" ControlToValidate="txtNumeroEntrega" ValidationGroup="vgInventario"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                                            ControlToValidate="txtNumeroEntrega" ValidationGroup="vgInventario" ErrorMessage="El número de entrega digitado no es válido, por favor verifique"
                                            ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                                    </div>
                                </td>
                            </tr>
                        
                            <tr>
                                <td colspan="3" align="center">
                                    <br />
                                    <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgInventario">
                                <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                                    </asp:LinkButton>
                                    &nbsp;&nbsp;&nbsp;
                                    <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                                    </asp:LinkButton>
                                </td>
                                </tr>
                                <tr>
                                <td>
                                <br />
                                <asp:LinkButton ID="lbCargar" runat="server" CssClass="search" Font-Bold="True" Visible ="false">
                                <img alt="Filtrar Pedido" src="../images/chulito2.gif" />Cargar inventario
                                    </asp:LinkButton>
                                </td>
                            </tr>
                    </asp:Panel>
        </table>
        <table class="tablaGris" style="width: auto;">
            <tr>
                <td>
                    <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center">
                        <div style="text-align: center;">
                        <br />
                            <b>Lineas asociadas al número de entrega consultada</b>
                            <br />
                            <br />
                            <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                                EmptyDataText="No hay resultados" HeaderStyle-HorizontalAlign="Center"
                                PageSize="50" ShowFooter="True">
                                <PagerSettings Mode="NumericFirstLast" />
                                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                <PagerStyle CssClass="field" HorizontalAlign="Center" />
                                <HeaderStyle HorizontalAlign="Center" />
                                <AlternatingRowStyle CssClass="alterColor" />
                                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                                <Columns>
                                    <asp:BoundField DataField="serial" Visible ="true" HeaderText="Serial" />
                                    <asp:BoundField DataField="material" HeaderText="Material" />
                                    <asp:BoundField DataField="centro" HeaderText="Centro" />
                                    <asp:BoundField DataField="almacen" Visible ="true"  HeaderText="Almacén" />
                                    <asp:BoundField DataField="idBodega" Visible ="false" HeaderText="Bodega" />
                                    <asp:BoundField DataField="idDespacho" Visible ="false" HeaderText="Despacho" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </asp:Panel>
                </td>
                <td style="width: 5px"></td>
                <td valign="top" >
                    <asp:Panel ID="pnlErrores" runat="server"
                    HorizontalAlign="Center" >
                    <table class="tablaGris">
                    <tr>
                        <td colspan="2" style="text-align: center">
                        <br />
                           <b>Log De Resultados</b>
                        </td>
                    </tr>
                    <tr>
                 <td>
                    <br />
                         <asp:GridView ID="gvErrores" runat="server" CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG"
                            EmptyDataRowStyle-Font-Size="14px" EmptyDataText="No hay errores " HeaderStyle-HorizontalAlign="Center"
                            PageSize="20" AutoGenerateColumns="true">
                            <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                            <PagerStyle CssClass="pagerChildDG" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:GridView>
                    </td>
                    </tr>
                    </table>
                </asp:Panel> 
                </td>
            </tr>
            
        </table>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>

</html>
