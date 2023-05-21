<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaInventario.aspx.vb"
    Inherits="BPColSysOP.ConsultaInventario1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/UcShowmessages.ascx" TagName="ShowMessage"
    TagPrefix="sm" %>
<%@ Register TagPrefix="uc1" TagName="encabezadopagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta Inventario - Mensajería Especializada</title>
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
     <asp:ScriptManager ID="smAjaxManager" runat="server" AsyncPostBackTimeout="1200">
    </asp:ScriptManager>
     <script type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        var elem;
        prm.add_initializeRequest(prm_InitializeRequest);
        prm.add_endRequest(prm_EndRequest);

        function prm_InitializeRequest(sender, args) {
            elem = args.get_postBackElement().id;
            LoadingPanel.Show();
        }
        function prm_EndRequest(sender, args) {
            LoadingPanel.Hide();
            if (elem.indexOf("lbExportarSerializado") > -1) {
                btnExportador.DoClick();
            }
        }

        function CloseGridLookup() {
            ddlBodega.ConfirmCurrentSelection();
            ddlBodega.HideDropDown();
        }
        function invocarCallBackMaterial(s, e) {

            if (txtMaterial.GetValue() != null && txtMaterial.GetValue().length > 2) {
                cpFiltroMaterial.PerformCallback(txtMaterial.GetValue());
            }
        }

        function finalizarCallBackMaterial(s, e) {

            ActualizarEncabezado(s, e);
        }


        function ActualizarEncabezado(s, e) {
            if (LoadingPanel) { LoadingPanel.Hide(); }
            if (s.cpMensaje) {
                if (document.getElementById('divEncabezado')) {
                    document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
                }
            }
            if (s.cpMensajePopUp && mensajePopUp) {
                if (s.cpTituloPopUp) { mensajePopUp.SetHeaderText(s.cpTituloPopUp); }
                if (document.getElementById(textoMensajePopUp.name)) {
                    document.getElementById(textoMensajePopUp.name).innerHTML = s.cpMensajePopUp;
                    mensajePopUp.Show();
                    s.cpMensajePopUp = null;
                    s.cpTituloPopUp = null;
                }
            }
            if (s.cpLimpiarFiltros) { LimpiarFiltros(); }
        }

        function LimpiarFiltros() {
            txtMaterial.SetText('');
            cmbMaterial.SetSelectedIndex(0);
            ddlCiudad.SetSelectedIndex(0);
            ddlBodega.GetGridView().UnselectAllRowsOnPage();
            pnlExportar.SetVisible(false);
        }
    </script>
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <div id="divEncabezado">
        <uc1:encabezadopagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxRoundPanel ID="rpFiltro" runat="server" HeaderText=" INGRESE LOS DATOS PARA CONSULTA">
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxFormLayout ID="flDatosConsultar" runat="server" AlignItemCaptionsInAllGroups="True">
                    <Items>
                        <dx:LayoutGroup ColCount="2" Caption=" ">
                            <Items>
                                <dx:LayoutItem Caption="Ciudad">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxComboBox ID="ddlCiudad" runat="server" ClientInstanceName="ddlCiudad" IncrementalFilteringMode="Contains"
                                                ValueType="System.String">
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Bodega">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxGridLookup ID="ddlBodega" runat="server" SelectionMode="Multiple" ClientInstanceName="ddlBodega"
                                                KeyFieldName="idbodega" Width="350px" TextFormatString="{0}" MultiTextSeparator=", ">
                                                <ClientSideEvents ButtonClick="function(s,e) {ddlBodega.GetGridView().UnselectAllRowsOnPage(); ddlBodega.HideDropDown(); }" />
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" />
                                                    <dx:GridViewDataTextColumn FieldName="bodega" />
                                                </Columns>
                                                <GridViewProperties>
                                                    <Templates>
                                                        <StatusBar>
                                                            <table style="float: right">
                                                                <tr>
                                                                    <td onclick="return _aspxCancelBubble(event)">
                                                                        <dx:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookup" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </StatusBar>
                                                    </Templates>
                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                                    <Settings ShowFilterRow="True" ShowStatusBar="Visible" />
                                                    <Settings ShowFilterRow="True" ShowStatusBar="Visible"></Settings>
                                                </GridViewProperties>
                                            </dx:ASPxGridLookup>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Material" ColSpan="2">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <dx:ASPxTextBox ID="txtMaterial" runat="server" ClientInstanceName="txtMaterial"
                                                            MaxLength="15" Width="100px">
                                                            <ClientSideEvents KeyUp="function (s,e){invocarCallBackMaterial(s,e);}" />
                                                        </dx:ASPxTextBox>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxCallbackPanel ID="cpFiltroMaterial" runat="server" ClientInstanceName="cpFiltroMaterial">
                                                            <ClientSideEvents EndCallback="function(s,e){  finalizarCallBackMaterial(s,e);}" />
                                                            <PanelCollection>
                                                                <dx:PanelContent runat="server">
                                                                    <dx:ASPxComboBox ID="cmbMaterial" runat="server" ClientInstanceName="cmbMaterial"
                                                                        IncrementalFilteringMode="Contains" TextField="referencia" ValueField="material"
                                                                        Width="195px">
                                                                        <ButtonStyle>
                                                                            <HoverStyle>
                                                                                <Border BorderStyle="Solid" />
                                                                            </HoverStyle>
                                                                        </ButtonStyle>
                                                                    </dx:ASPxComboBox>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxCallbackPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption=" " ColSpan="2">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:CustomValidator ID="cusFiltro" runat="server" ClientValidationFunction="ExisteSeleccion"
                                                            Display="Dynamic" ErrorMessage="Debe seleccionar por lo menos un filtro de búsqueda"
                                                            ValidationGroup="vgCliente"></asp:CustomValidator>
                                                        <dx:ASPxButton ID="btBuscar" runat="server" ClientInstanceName="btBuscar" Text="Filtrar Inventario">
                                                            <Image Url="../images/filtro.png">
                                                            </Image>
                                                        </dx:ASPxButton>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxButton ID="btQuitarFiltros" runat="server" AutoPostBack="True" ClientInstanceName="btQuitarFiltros"
                                                            Text="Quitar Filtros">
                                                            <Image Url="../images/cancelar.png">
                                                            </Image>
                                                        </dx:ASPxButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption=" " ColSpan="2">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="linccNombre" runat="server">
                                            <dx:ASPxPanel ID="pnlExportar" runat="server" ClientInstanceName="pnlExportar" ClientVisible="True">
                                                <PanelCollection>
                                                    <dx:PanelContent ID="PanelContent1" runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxButton ID="lbExportar" runat="server" ClientInstanceName="lbExportar" Text="Exportar Inventario">
                                                                        <Image Url="~/images/Excel.gif">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </td>
                                                                <td>
                                                                    <asp:UpdatePanel ID="upGeneral" runat="server" ChildrenAsTriggers="true">
                                                                        <ContentTemplate>
                                                                            <asp:LinkButton ID="lbExportarSerializado" runat="server" Font-Bold="True" Font-Size="Small"
                                                                                ForeColor="Green"><img src="../images/excel.gif" alt="" /> &nbsp;Exportar Inventario Serializado</asp:LinkButton>
                                                                            <%-- <dx:ASPxButton ID="lbExportarSerializado" runat="server" ClientInstanceName="lbExportarSerializado"
                                                                                Text="Exportar Inventario Serializado">
                                                                                <Image Url="../images/list_num.png">
                                                                                </Image>
                                                                            </dx:ASPxButton>--%>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                        CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                                                                        HeaderStyle-HorizontalAlign="Center" PageSize="200" ShowFooter="True" BorderColor="Gray"
                                                                        CellPadding="1" CellSpacing="1" AllowSorting="True" Width="100%">
                                                                        <PagerSettings Mode="NumericFirstLast" />
                                                                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                                                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <AlternatingRowStyle CssClass="alterColor" />
                                                                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="idBodega" HeaderText="Id" SortExpression="idBodega" />
                                                                            <asp:BoundField DataField="bodega" HeaderText="Bodega" SortExpression="bodega" />
                                                                            <asp:BoundField DataField="centro" HeaderText="Centro" SortExpression="centro" />
                                                                            <asp:BoundField DataField="almacen" HeaderText="Almacen" SortExpression="almacen" />
                                                                            <asp:BoundField DataField="material" HeaderText="Material" SortExpression="material" />
                                                                            <asp:BoundField DataField="subproducto" HeaderText="Descripción" SortExpression="subproducto" />
                                                                            <asp:BoundField DataField="cantidad" HeaderText="Cantidad En Inventario" SortExpression="cantidad">
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                            </asp:BoundField>
                                                                            <asp:BoundField DataField="reserva" HeaderText="Cantidad Reservada" SortExpression="reserva">
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                            </asp:BoundField>
                                                                            <asp:BoundField DataField="cantidadDisponible" HeaderText="Cantidad Disponible" SortExpression="cantidadDisponible">
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                            </asp:BoundField>
                                                                            <asp:BoundField DataField="cantidadSolicitada" HeaderText="Cantidad Solicitada" SortExpression="cantidadSolicitada">
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                            </asp:BoundField>
                                                                        </Columns>
                                                                    </asp:GridView>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxButton ID="btnExportador" runat="server" ClientInstanceName="btnExportador"
                                                                        ClientVisible="false" OnClick="btnExportador_Click" Width="0px" Height="0px">
                                                                    </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxPanel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:LayoutGroup>
                    </Items>
                </dx:ASPxFormLayout>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
    <br />
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
