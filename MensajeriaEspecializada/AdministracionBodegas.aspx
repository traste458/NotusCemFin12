<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionBodegas.aspx.vb" Inherits="BPColSysOP.AdministracionBodegas" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> ::: Administración Bodegas :::</title>
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
                   <dx:ASPxHiddenField ID="hdIdGeneral" runat ="server" ClientInstanceName ="hdIdGeneral"></dx:ASPxHiddenField>
                   <dx:ASPxRoundPanel ID="rpInformacion" runat="server" HeaderText="Administrador Bodegas" Width="90%" Theme ="SoftOrange">
                       <PanelCollection>
                           <dx:PanelContent>
                               <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="False" Width="100%"
                                    ClientInstanceName="gvDatos" KeyFieldName="IdAlmacenBodega" Theme ="SoftOrange">
                                   <Columns>
                                       <dx:GridViewDataTextColumn Caption="Id" ShowInCustomizationForm="True" VisibleIndex="0" 
                                           FieldName="IdBodega"></dx:GridViewDataTextColumn> 
                                       <dx:GridViewDataTextColumn Caption="Nombre" ShowInCustomizationForm="True" VisibleIndex="1" 
                                           FieldName="Bodega"></dx:GridViewDataTextColumn> 
                                       <dx:GridViewDataTextColumn Caption="Centro" ShowInCustomizationForm="True" VisibleIndex="2" 
                                           FieldName="Centro"></dx:GridViewDataTextColumn> 
                                       <dx:GridViewDataTextColumn Caption="Almacén" ShowInCustomizationForm="True" VisibleIndex="3" 
                                           FieldName="Almacen"></dx:GridViewDataTextColumn> 
                                       <dx:GridViewDataTextColumn Caption="Ciudad" ShowInCustomizationForm="True" VisibleIndex="4" 
                                           FieldName="Ciudad"></dx:GridViewDataTextColumn> 
                                       <dx:GridViewDataTextColumn Caption="Unidad de Negocio" ShowInCustomizationForm="True" VisibleIndex="5" 
                                           FieldName="UnidadNegocio"></dx:GridViewDataTextColumn>
                                       <dx:GridViewDataCheckColumn Caption="Activo" ShowInCustomizationForm="true" VisibleIndex="6"
                                                FieldName="Activo">
                                            </dx:GridViewDataCheckColumn> 
                                       <dx:GridViewDataColumn Caption ="Opciones" VisibleIndex ="6">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID ="lnkEditar" runat ="server" ImageUrl="~/images/DxEdit.png" Cursor="pointer"
                                                    ToolTip ="Editar" OnInit ="Link_Init">
                                                    <ClientSideEvents Click ="function(s, e){
                                                        hdIdGeneral.Set('IdAlmacenBodega',{0});
                                                        CallbackvsShowPopup(pcEditar,{0},'verInfoBodega','0.9','0.4');
                                                    }" />
                                                </dx:ASPxHyperLink>
                                            </DataItemTemplate> 
                                        </dx:GridViewDataColumn> 
                                   </Columns>
                                   <SettingsDetail ShowDetailRow="true" />
                                   <Settings ShowFilterBar="Visible"  ShowHeaderFilterButton="True" ShowTitlePanel="True"/>
                                    <SettingsPager PageSize="20">
                                        <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                    </SettingsPager>
                                    <SettingsText Title="B&#250;squeda General"
                                    EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                   <Templates>
                                       <DetailRow>
                                           <dx:ASPxGridView ID="gvDetalle" ClientInstanceName="gvDetalle" runat="server" AutoGenerateColumns="false"
                                                KeyFieldName="IdPerfil" Width="100%" OnBeforePerformDataSelect="gvDetalle_DataSelect" Theme ="SoftOrange">
                                               <Columns>
                                                   <dx:GridViewDataTextColumn Caption ="Id" ShowInCustomizationForm ="true"
                                                        VisibleIndex ="0" FieldName ="IdPerfil"> 
                                                    </dx:GridViewDataTextColumn>
                                                   <dx:GridViewDataTextColumn Caption ="Nombre" ShowInCustomizationForm ="true"
                                                        VisibleIndex ="1" FieldName ="Perfil"> 
                                                    </dx:GridViewDataTextColumn>
                                                   <dx:GridViewDataColumn Caption ="Opciones" VisibleIndex ="2">
                                                       <DataItemTemplate>
                                                           <dx:ASPxHyperLink ID ="lnkPerfiles" runat ="server" ImageUrl="~/images/DxSearch16.png" Cursor="pointer"
                                                                ToolTip ="Configurar Usuarios" OnInit ="Link_InitDetalle">
                                                                <ClientSideEvents Click ="function(s, e){
                                                                    CallbackvsShowPopup(pcUsuarios,{0},'verUsuarios','0.4','0.7');
                                                                }" />
                                                            </dx:ASPxHyperLink>
                                                       </DataItemTemplate> 
                                                   </dx:GridViewDataColumn> 
                                               </Columns>
                                               <Settings ShowFilterBar="Visible"  ShowHeaderFilterButton="True" ShowTitlePanel="True"/>
                                               <SettingsPager PageSize="20">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                </SettingsPager>
                                               <SettingsText Title="Perfiles Asociados"
                                                EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                            </dx:ASPxGridView> 
                                       </DetailRow> 
                                   </Templates> 
                                </dx:ASPxGridView> 
                               <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                           </dx:PanelContent>
                       </PanelCollection>
                   </dx:ASPxRoundPanel> 
                   <dx:ASPxPopupControl ID="pcEditar" runat="server" ClientInstanceName="pcEditar" Modal="true" CloseAction ="CloseButton"  Theme ="SoftOrange"
                        HeaderText="Información de la bodega" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <fieldset>
                                    <legend> Datos de la Bodega: </legend>
                                    <dx:ASPxFormLayout ID="flInformacion" runat="server" ColCount="3">
                                    <Items>
                                        <dx:LayoutItem Caption="Nombre:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                    <dx:ASPxTextBox ID="txtEditNombre" runat ="server" NullText ="Digite el nombre..." MaxLength ="50" Width ="250px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                            <RequiredField ErrorText ="El valor es requerido" IsRequired ="true" />
                                                            <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                 </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Ciudad:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                    <dx:ASPxComboBox ID="cmbCiudad" runat="server" ClientInstanceName="cmbCiudad" Width="250px"
                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idCiudad" 
                                                            CallbackPageSize="25" EnableCallbackMode="true" FilterMinLength="3"  ValueType ="System.Int32">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="idCiudad" Caption="Id" Width="20px" Visible ="false"/>
                                                            <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                    <div>
                                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Digite parte de la ciudad."
                                                            CssClass="comentario" Width="270px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                 </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Centro:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                    <dx:ASPxTextBox ID="txtEditCentro" runat ="server" NullText ="Digite el centro..." MaxLength ="7">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                            <RequiredField ErrorText ="El valor es requerido" IsRequired ="true" />
                                                            <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                 </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Almacén:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                    <dx:ASPxTextBox ID="txtEditAlmacen" runat ="server" NullText ="Digite el almacén..." MaxLength ="7">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                            <RequiredField ErrorText ="El valor es requerido" IsRequired ="true" />
                                                            <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                 </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Unidad Negocio:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                    <dx:ASPxComboBox ID="cmbEditUnidadNegocio" runat="server" ClientInstanceName="cmbEditUnidadNegocio" Width="250px"
                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="IdUnidadNegocio" ValueType ="System.Int32">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="IdUnidadNegocio" Caption="Id" Width="20px" Visible ="false"/>
                                                            <dx:ListBoxColumn FieldName="Nombre" Caption="Nombre" Width="300px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                 </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Estado:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                    <dx:ASPxCheckBox ID="cbEditActivo" runat="server"></dx:ASPxCheckBox>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblComentario" runat="server" Text="Activo S/N."
                                                            CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                 </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Acciones:" RequiredMarkDisplayMode="Hidden" ColSpan ="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                    <dx:ASPxImage ID ="imgEdita" runat ="server" ImageUrl="~/images/DxConfirm16.png" Cursor ="pointer"
                                                    ToolTip ="Registrar">
                                                    <ClientSideEvents Click ="function(s, e){
                                                            if(ASPxClientEdit.ValidateGroup(&#39;vgEditar&#39;)){
                                                                pcEditar.Hide();
                                                                var valor = hdIdGeneral.Get('IdAlmacenBodega');
                                                                if (valor == 0){
                                                                    EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'crear',hdIdGeneral.Get('IdAlmacenBodega'));
                                                                } else {
                                                                    EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'editar',hdIdGeneral.Get('IdAlmacenBodega'));
                                                                }
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
                   <dx:ASPxPopupControl ID="pcUsuarios" runat="server" ClientInstanceName="pcUsuarios" CloseAction ="CloseButton"
                        HeaderText="Lista de perfiles permitidos" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxLabel ID="lbIdTipo" runat ="server" ClientInstanceName ="lbIdTipo" ClientVisible ="false" ></dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dx:ASPxListBox ID="lbUsuarios" runat="server" Width="350px" SelectionMode="CheckColumn"
                                                ValueField="IdTercero" Height="400px" ClientInstanceName="lbUsuarios">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Tercero" Caption="Nombre" Width="350px" />
                                                </Columns>
                                            </dx:ASPxListBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center">
                                            <dx:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                ToolTip="Agregar Tipo Servicio" Cursor ="pointer">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if (lbUsuarios.GetSelectedValues().length==0){
                                                        alert('No ha seleccionado ningún valor de la lista.');
                                                    } else {
                                                        pcUsuarios.Hide();
                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'adcionarUsuario',lbIdTipo.GetText() + ':' + lbUsuarios.GetSelectedValues())
                                                        }
                                                }" />
                                            </dx:ASPxImage> 
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                   <div id="bluebar" class="menuFlotante">
                            <b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4">
                            </b></b>
                            <table style="width: 99%;">
                                <tr>
                                    <td>
                                        <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                        SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                        AutoPostBack="false"  ClientInstanceName="cbFormatoExportar"
                                        Width="250px">
                                        <Items>
                                            <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls"
                                                Selected="true" />
                                            <dx:ListEditItem ImageUrl="../images/pdf.png" Text="Exportar a PDF" Value="pdf" />
                                            <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                            <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" Value="csv" />
                                        </Items>
                                        <Buttons>
                                            <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                                <Image Url="../images/upload.png">
                                                </Image>
                                            </dx:EditButton>
                                        </Buttons>
                                        <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                            Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                            <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular">
                                            </RegularExpression>
                                            <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                                        </ValidationSettings>
                                    </dx:ASPxComboBox>
                                    </td>
                                    <td style="text-align:right">
                                        <dx:ASPxImage ID="imgExpandir" runat="server" ClientInstanceName="imgExpandir" ToolTip="Expandir Todos Los Grupos"
                                            ImageUrl="../images/expandir.png">
                                            <ClientSideEvents Click="function (s, e){
                                                gvDatos.ExpandAllDetailRows()
                                            }" />
                                        </dx:ASPxImage>
                                    </td>
                                    <td style="text-align:left">
                                        <dx:ASPxImage ID="imgContraer" runat="server" ClientInstanceName="imgContraer" ToolTip="Contraer Todos Los Grupos"
                                            ImageUrl="../images/contraer.png">
                                            <ClientSideEvents Click="function (s, e){
                                                gvDatos.CollapseAllDetailRows()
                                            }" />
                                        </dx:ASPxImage>
                                    </td>
                                    <td style="text-align:right">
                                        <dx:ASPxImage ID="imgNew" runat ="server" ImageUrl ="../images/DxAdd32.png" Cursor ="pointer">
                                            <ClientSideEvents Click ="function(s, e){
                                                hdIdGeneral.Set('IdAlmacenBodega', 0);
                                                CallbackvsShowPopup(pcEditar,1,'crear','0.9','0.4');
                                            }" />
                                        </dx:ASPxImage>
                                    </td>
                                    <td style="text-align:left"> 
                                        <dx:ASPxLabel id="lblNew" runat ="server" Text ="Crear Bodega" 
                                        CssClass ="comentario" ForeColor ="#CCCCFF" Font-Size="XX-Small">
                                    </dx:ASPxLabel>
                                    </td>
                                </tr>
                            </table> 
                        </div> 
                   <div id="div1" style="float: right; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
                        width: 2%; position: fixed; overflow: hidden; display: block; bottom: 0px">
                        <table>
                            <tr>
                                <td style ="text-align:right">
                                    <a style="color: Black; font-size: 15px; cursor: pointer;" id="a1"
                                        onclick="toggle('bluebar');">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/structure.png" ToolTip="Ocultar/Mostrar, Menú "
                                            Width="16px" /></a>
                                </td>
                            </tr>
                        </table>
                    </div>
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
