<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ModificacionMinesVentaCorporativa.aspx.vb" Inherits="BPColSysOP.ModificacionMinesVentaCorporativa" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>::: Pool Venta Corporativa ::: </title>
    <link rel="shortcut icon" href ="../images/baloons_small.png"/>
</head>
<body class ="cuerpo2">
    <form id="frmPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdIdServicio" runat ="server" ClientInstanceName ="hdIdServicio"></dx:ASPxHiddenField>
                    <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                        KeyFieldName="Msisdn" Theme="SoftOrange" Width="100%">
                        <Columns>
                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="1" Width="40px">
                            <DataItemTemplate>
                                <dx:ASPxHyperLink ID="lnkEditar" runat ="server" ImageUrl="~/images/DxMarker.png" Cursor ="pointer" 
                                    ToolTip ="Editar Msisnd" OnInit="Link_Init">
                                    <ClientSideEvents Click ="function(s, e){
                                        hdIdServicio.Set('Msisdn',{0})
                                        CallbackvsShowPopup(pcGeneral,{0},'inicial','0.5','0.3');
                                    }" />
                                </dx:ASPxHyperLink> 
                            </DataItemTemplate>
                            </dx:GridViewDataColumn> 
                            <dx:GridViewDataTextColumn VisibleIndex="3" Caption="Msisdn" FieldName="Msisdn" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="4" Caption="Regional" FieldName="Regional" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="5" Caption="Material Equipo" FieldName="MaterialEquipo" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="6" Caption="Descripción Eq." FieldName="DescripcionMaterialEq" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="7" Caption="Imei" FieldName="Imei" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="8" Caption="Material SIM" FieldName="MaterialSIM" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="9" Caption="Descripción SIM" FieldName="DescripcionMaterialSIM" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="10" Caption="Iccid" FieldName="Iccid" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="11" Caption="Precio Especial" FieldName="PrecioEspecial" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn VisibleIndex="12" Caption="Valor Equipo" FieldName="ValorEquipo" ShowInCustomizationForm="true">
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <SettingsBehavior AllowSelectByRowClick="true" />
                        <Settings ShowHeaderFilterButton="True"></Settings>
                        <SettingsPager PageSize="20">
                            <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                        </SettingsPager>
                        <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                        <SettingsText Title="B&#250;squeda General"
                            EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                    </dx:ASPxGridView>
                    <dx:ASPxPopupControl ID="pcGeneral" runat="server" 
                        ClientInstanceName="pcGeneral" Modal="true" CloseAction ="CloseButton" 
                        HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter" 
                        PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <fieldset>
                                    <legend> Información Servicio: </legend>
                                    <dx:ASPxFormLayout ID="flFiltro" runat="server" ColCount="2">
                                            <Items>
                                                <dx:LayoutItem Caption="Id Servicio:" RequiredMarkDisplayMode="Required">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                            <dx:ASPxLabel ID="lblIdServicio" runat="server" Text=""
                                                                CssClass="comentario" Font-Size="X-Large" Font-Bold="False" Font-Italic="True"
                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                            </dx:ASPxLabel>
                                                        </dx:LayoutItemNestedControlContainer> 
                                                    </LayoutItemNestedControlCollection> 
                                                </dx:LayoutItem> 
                                                <dx:LayoutItem Caption="Msisdn:" RequiredMarkDisplayMode="Required">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                            <dx:ASPxTextBox ID="txtMsisdn" runat ="server" MaxLength ="12" Width ="150 px">
                                                                <ValidationSettings CausesValidation ="true" ErrorDisplayMode ="ImageWithTooltip" ValidationGroup ="vgEdita">
                                                                    <RequiredField ErrorText ="El Msisdn es requerido" IsRequired ="true" />
                                                                    <RegularExpression ErrorText ="Formato no válido" ValidationExpression ="^\s*[0-9]+\s*$"/>
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer> 
                                                    </LayoutItemNestedControlCollection> 
                                                </dx:LayoutItem> 
                                                <dx:LayoutItem Caption="Opciones:" ColSpan ="2">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                            <dx:ASPxImage ID="imgEdita" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Editar"
                                                                ClientInstanceName="imgEdita" Cursor="pointer">
                                                                <ClientSideEvents Click ="function(s,e){
                                                                    if(ASPxClientEdit.ValidateGroup('vgEdita')){
                                                                        pcGeneral.Hide();
                                                                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'editar', hdIdServicio.Get('Msisdn'));
                                                                    }
                                                                }" />
                                                            </dx:ASPxImage> 
                                                        </dx:LayoutItemNestedControlContainer> 
                                                    </LayoutItemNestedControlCollection> 
                                                </dx:LayoutItem> 
                                            </Items> 
                                        </dx:ASPxFormLayout> 
                                </fieldset> 
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel> 
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
    </form>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
</body>
</html>
