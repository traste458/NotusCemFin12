<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministrarBodegas.aspx.vb" Inherits="BPColSysOP.AdministrarBodegas" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 <title>Administrar Bodegas Ciudad Cercana</title>
    <link rel="shortcut icon" href="../images/baloons_small.png" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/animatedcollapse.js" type="text/javascript"></script>
    <script type="text/javascript">
        function verBodega(idBodega) {
             WindowLocation('verBodegasDetalle.aspx?idBodega=' + idBodega);
        }
        function editarBodega(idBodega) {
            WindowLocation('editarBodega.aspx?idBodega=' + idBodega);
        }
        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                rpDatos.SetVisible(false);
                ASPxClientEdit.ClearEditorsInContainerById('frmPrincipal');
            }
        }
        
    </script>
</head>
<body>&nbsp;<form id="frmPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:encabezadopagina ID="miEncabezado" runat="server" />
        </div>
        <div>
            <asp:LinkButton ID="lbAñadir" runat="server" CssClass="search" Font-Bold="True"
                            CausesValidation="true">
                                <img alt="Añadir bodega" src="../images/add.png" />&nbsp;Crear Bodega
                        </asp:LinkButton>
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback="function (s, e){
                 LoadingPanel.Hide();           
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpRegistro" runat="server" Theme="SoftOrange" ShowHeader="true" HeaderText="Bodegas ciudad cercana"
                        Width="95%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <div style="width: 90%; min-width: 500px">
                                    <table>
                                        <tr>
                                            <td align="left">
                                                <a style="color: Black; font-size: 10px; cursor: pointer;" id="aLecturas"
                                                    onclick="toggle('divFiltros');">
                                                    <asp:Image ID="imgFiltro" runat="server" ImageUrl="~/images/find.gif" ToolTip="Ver/Ocultar Filtros Búsqueda"
                                                        Width="16px" />
                                                    Ver/Ocultar Filtros Búsqueda</a>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 90%;">
                                    <dx:ASPxRoundPanel ID="rpFiltro" runat="server" ShowHeader="false" Width="100%">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Width="100%">
                                                    <Items>
                                                        <dx:LayoutGroup Caption="Filtros de Busqueda" ColCount="2">
                                                            <Items>
                                                                <dx:LayoutItem Caption="Tipo Bodega" HorizontalAlign="Center">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                            <dx:ASPxComboBox ID="cmbTipoBodega" ClientInstanceName="cmbTipoBodega" runat="server" Width="200px" ValueType="System.Int32">
                                                                            </dx:ASPxComboBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                    <CaptionSettings Location="Left" VerticalAlign="Middle" />
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Bodega" HorizontalAlign="Center">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                                            <dx:ASPxComboBox ID="cmbBodega" ClientInstanceName="cmbBodega" runat="server" Width="200px" ValueType="System.Int32">
                                                                            </dx:ASPxComboBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                    <CaptionSettings Location="Left" VerticalAlign="Middle" />
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Buscar" ShowCaption="False" HorizontalAlign="Center">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxImage ID="imgLimpiarFiltros" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Limpiar Filtros Aplicados"
                                                                                Cursor="pointer" TabIndex="10">
                                                                                <ClientSideEvents Click="function (s,e){
                                                                    LimpiaFormulario();
                                                                }" />
                                                                            </dx:ASPxImage>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem  ShowCaption="False" HorizontalAlign="Center">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">                                                                            
                                                                            <dx:ASPxImage ID="imgConsultarDetalle" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Búsqueda"
                                                                            ClientInstanceName="imgConsultarDetalle" Cursor="pointer">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                                    if (cmbBodega.GetValue()==null &amp;&amp; cmbTipoBodega.GetValue()==null ){ 
                                                                                        alert('Debe seleccionar un filtro para continuar con la consulta.');
                                                                                        e.processOnServer = false;                                                                                
                                                                                } else {
                                                                                    EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'ConsultarInformacion', 1);
                                                                                    }
                                                                                }" />
                                                                            </dx:ASPxImage>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                    <CaptionSettings HorizontalAlign="Center" Location="Bottom" VerticalAlign="Top" />
                                                                </dx:LayoutItem>
                                                            </Items>
                                                        </dx:LayoutGroup>
                                                    </Items>
                                                </dx:ASPxFormLayout>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </div>
                                <br />
                                <dx:ASPxRoundPanel ID="rpDatos" runat="server" ClientInstanceName="rpDatos"
                                    ShowHeader="true" HeaderText="Detalle de la Información" Width="100%" ClientVisible="true">
                                    <PanelCollection>
                                        <dx:PanelContent ID="PanelContent1" runat="server">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cbExportDetalle" runat="server" ShowImageInEditBox="true"
                                                            SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                            AutoPostBack="false" ClientInstanceName="cbExportDetalle"
                                                            Width="250px">
                                                            <Items>
                                                                <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls"
                                                                    Selected="true" />
                                                                <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                                                <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" Value="csv" />
                                                            </Items>
                                                            <Buttons>
                                                                <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                                                    <Image Url="../images/Download.png">
                                                                    </Image>
                                                                </dx:EditButton>
                                                            </Buttons>
                                                            <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                                                Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                                                <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                                                <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                </tr>
                                            </table>
                                            <dx:ASPxGridView ID="gvDetalle" runat="server" Visible="true" AutoGenerateColumns="true" KeyFieldName="idbodega" ClientInstanceName="gvDetalle" Width="95%">

                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="idbodega" ShowInCustomizationForm="False" Caption="Cod Bodega"
                                                        VisibleIndex="1">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="idTipo" ShowInCustomizationForm="False" Visible="false" Caption="Id Bodega2"
                                                        VisibleIndex="2">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="idbodega2" ShowInCustomizationForm="False" Caption="Id Bodega2"
                                                        VisibleIndex="3">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="bodega" ShowInCustomizationForm="False" Caption="Bodega"
                                                        VisibleIndex="4">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="direccion" ShowInCustomizationForm="False" Caption="Dirección"
                                                        VisibleIndex="6">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="telefonos" ShowInCustomizationForm="False" Caption="Telefons"
                                                        VisibleIndex="7">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="ciudad" ShowInCustomizationForm="False" Caption="Ciudad"
                                                        VisibleIndex="8">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="codigo" ShowInCustomizationForm="False" Caption="Codigo"
                                                        VisibleIndex="9">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                      <dx:GridViewDataTextColumn FieldName="codigoSucursalInterRapidisimo" ShowInCustomizationForm="False" Caption="codigoSucursalInterRapidisimo"
                                                        VisibleIndex="10">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="0" Width="40px">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID="lbVer" runat="server" ImageUrl="~/images/view.png" Cursor="pointer" ClientVisible="true"
                                                    ToolTip="Ver Información de la bodega" OnInit="Link_Init" Visible="true">
                                                    <ClientSideEvents Click="function(s, e){
                                                          verBodega({0}) ;                                                    
                                                }" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink ID="lnkEditar" runat="server" ImageUrl="~/images/Edit-32.png" Cursor="pointer" ClientVisible="true"
                                                    ToolTip="Actualizar bodega" Visible="true" OnInit="LinkDatos_Init">
                                                    <ClientSideEvents Click="function(s, e){
                                                          editarBodega({0}) ;                                                    
                                                }" />
                                                </dx:ASPxHyperLink>                                                
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                                </Columns>
                                                
                                                            <SettingsPager PageSize="20">
                                                            </SettingsPager>
                                            </dx:ASPxGridView>
                                            <dx:ASPxGridView runat="server" ID="gvDatos" Visible="false">
                                                <Columns>
                                                <dx:GridViewDataTextColumn FieldName="bodega" ShowInCustomizationForm="False"
                                                        VisibleIndex="0">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="ciudad" ShowInCustomizationForm="False"
                                                        VisibleIndex="1">
                                                    </dx:GridViewDataTextColumn>
                                            </Columns>
                                            </dx:ASPxGridView>
                                            <dx:ASPxGridViewExporter ID="gvDetalleExporter" runat="server" GridViewID="gvDatos">
                                            </dx:ASPxGridViewExporter>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
                    </dx:ASPxLoadingPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>

        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
        <script src="../include/jquery-1.min.js" type="text/javascript"></script>
        <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    </form>
</body>
</html>
