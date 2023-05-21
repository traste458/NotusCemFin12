<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultarZonaServicio.aspx.vb"
    Inherits="BPColSysOP.ConsultarZonaServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Consultar Zona Servicio</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            width: 1px;
        }
    </style>
</head>
<body class="cuerpo2">
    <form id="form2" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <input id="hfPosFiltrado" type="hidden" value="0" runat="server" />
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%"
        ChildrenAsTriggers="true">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epPoolServicios" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpInfoPool" runat="server" UpdateMode="Group" GroupName="infoZona"
        Width="100%" ChildrenAsTriggers="true" LoadingDialogID="ldrWait_dlgWait">
        <table class="tablaGris">
            <tr>
                <td>
                    <div id="divFloater" style="display: none;">
                        <table width="98%" align="center">
                            <tr>
                                <td style="width: 40px">
                                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" />
                                </td>
                                <td valign="middle">
                                    <b>Procesando...</b>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <asp:Panel ID="panelDatosPoolServicios" runat="server" Height="111px">
                        <table class="tablaGris" style="width: auto;">
                            <tr>
                                <td colspan="6" style="text-align: center" class="thGris">
                                    INGRESE LOS DATOS PARA CONSULTA
                                </td>
                            </tr>
                            <tr>
                                <td class="field" align="left">
                                    N. Radicado:
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtNumeroRadicado" runat="server"></asp:TextBox>
                                    <div>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator" runat="server" Display="Dynamic"
                                            ControlToValidate="txtNumeroRadicado" ValidationGroup="vgCliente" ErrorMessage="El numero radicación digitado no es válido, por favor verifique"
                                            ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                                        <asp:RequiredFieldValidator ID="rfvnumeroRadicado" runat="server" ControlToValidate="txtNumeroRadicado"
                                            ErrorMessage="Número de radicado Requerido" Display="Dynamic" ValidationGroup="vgCliente"></asp:RequiredFieldValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                                    </asp:LinkButton>
                                    &nbsp;&nbsp;&nbsp;
                                    <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True"
                                        AutoPostBack="True">
                                 <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                                    </asp:LinkButton>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center" Style="margin-top: 71px"
                        Height="2100px">
                        <div style="text-align: center; height: 2237px;">
                            <b>Resultados de busqueda</b>
                            <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                                EmptyDataText="No hay pedidos pendientes" HeaderStyle-HorizontalAlign="Center"
                                PageSize="300" ShowFooter="True">
                                <PagerSettings Mode="NumericFirstLast" />
                                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                <PagerStyle CssClass="pagerChildDG" HorizontalAlign="Center" />
                                <HeaderStyle HorizontalAlign="Center" />
                                <AlternatingRowStyle CssClass="alterColor" />
                                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                                <Columns>
                                    <asp:BoundField DataField="numeroRadicado" HeaderText="Número Radicado" />
                                    <asp:BoundField DataField="zona" HeaderText="Zona" />
                                    <asp:BoundField DataField="responsableEntrega" HeaderText="Responsable Entrega" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
