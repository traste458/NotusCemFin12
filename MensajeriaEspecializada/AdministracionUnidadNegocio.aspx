<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionUnidadNegocio.aspx.vb" Inherits="BPColSysOP.AdministracionUnidadNegocio" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> ::: Administración Unidades Negocio :::</title>
</head>
<body class ="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback ="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
                cmbTipoServicio.SetText('');
                gluPerfiles.SetText('');
                LoadingPanel.Hide();
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpInformacion" runat="server" HeaderText="Administrador Unidades de Negocio" Width="70%" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="False" Width="100%"
                                    ClientInstanceName="gvDatos" KeyFieldName="IdUnidadNegocio" Theme ="SoftOrange">
                                    <ClientSideEvents EndCallback="function(s,e){ 
                                        FinalizarCallbackGeneral(s,e,'divEncabezado');
                                        LoadingPanel.Hide();
                                    }"></ClientSideEvents>
                                    <Columns>
                                        <dx:GridViewDataTextColumn Caption="Id" ShowInCustomizationForm="True"
                                            VisibleIndex="0" FieldName="IdUnidadNegocio">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Nombre Unidad Negocio" ShowInCustomizationForm="True"
                                            VisibleIndex="1" FieldName="Nombre">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Estado" ShowInCustomizationForm="True"
                                            VisibleIndex="2" FieldName="Activo" Visible ="false">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Tipo Unidad" ShowInCustomizationForm="True"
                                            VisibleIndex="3" FieldName="TipoUnidadNegocio">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="4" Width="40px">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID="lnkAgregar" runat ="server" ImageUrl="~/images/DxAdd16.png" Cursor ="pointer" 
                                                    ToolTip ="Agregar Tipo Servicio" OnInit="Link_Init">
                                                    <ClientSideEvents Click ="function(s, e){
                                                        CallbackvsShowPopup(pcTipoServicio,{0},'tipoServicio','0.3','0.5');
                                                    }" />
                                                </dx:ASPxHyperLink> 
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn> 
                                    </Columns>
                                    <Templates>
                                        <DetailRow>
                                            <dx:ASPxGridView ID="gvDetalle" ClientInstanceName="gvDetalle" runat="server" AutoGenerateColumns="false"
                                                KeyFieldName="IdTipoServicioNegocio" Width="100%" OnBeforePerformDataSelect="gvDetalle_DataSelect" Theme ="SoftOrange">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn Caption ="Id" ShowInCustomizationForm ="true"
                                                        VisibleIndex ="0" FieldName ="IdTipoServicio"> 
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption ="Tipo Servicio" ShowInCustomizationForm ="true"
                                                        VisibleIndex ="1" FieldName ="TipoServicio">
                                                    </dx:GridViewDataTextColumn> 
                                                    <dx:GridViewDataColumn Caption ="Opciones" VisibleIndex ="2">
                                                        <DataItemTemplate>
                                                            <dx:ASPxHyperLink ID ="lnkEliminar" runat ="server" ImageUrl="~/images/DXEraser16.png" Cursor ="pointer"
                                                                ToolTip ="Eliminar Tipo Servicio" OnInit ="Link_InitDetalle">
                                                                <ClientSideEvents Click ="function(s, e){
                                                                        if (confirm('Realmente desea desvincular el tipo de servicio seleccionado?')){
                                                                            EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'eliminarTipoServicio',{0})
                                                                        }
                                                                    }" />
                                                            </dx:ASPxHyperLink>
                                                            <dx:ASPxHyperLink ID ="lnkPerfiles" runat ="server" ImageUrl="~/images/DxSearch16.png" Cursor="pointer"
                                                                ToolTip ="Configurar Perfiles" OnInit ="Link_InitDetalle">
                                                                <ClientSideEvents Click ="function(s, e){
                                                                    CallbackvsShowPopup(pcPerfiles,{0},'perfiles','0.3','0.7');
                                                                }" />
                                                            </dx:ASPxHyperLink>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataColumn>
                                                </Columns>
                                                <Templates>
                                                    <DetailRow>
                                                        <dx:ASPxGridView ID="gvPerfiles" runat="server" ClientInstanceName="gvPerfiles"
                                                            Width="100%" OnBeforePerformDataSelect="gvPerfiles_DataSelect" Theme ="SoftOrange">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption ="Id Perfil" ShowInCustomizationForm ="true"
                                                                    VisibleIndex ="1" FieldName ="IdPerfil">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption ="Perfil" ShowInCustomizationForm ="true"
                                                                    VisibleIndex ="2" FieldName ="Perfil">
                                                                </dx:GridViewDataTextColumn> 
                                                            </Columns>
                                                        </dx:ASPxGridView> 
                                                    </DetailRow>
                                                </Templates>
                                                <SettingsDetail ShowDetailRow="true" />
                                            </dx:ASPxGridView> 
                                        </DetailRow> 
                                    </Templates>
                                    <Settings ShowHeaderFilterButton="True"></Settings>
                                    <SettingsDetail ShowDetailRow="true" />
                                    <Settings VerticalScrollableHeight="300"/>
                                    <SettingsPager PageSize="20">
			                            <PageSizeItemSettings Visible="true" ShowAllItem="true" />
		                            </SettingsPager>
                                    <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                    <SettingsText Title="B&#250;squeda General Unidad de Negocio" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda" CommandEdit="Editar"></SettingsText>
                                </dx:ASPxGridView> 
                                <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel> 
                    <dx:ASPxPopupControl ID="pcTipoServicio" runat="server" ClientInstanceName="pcTipoServicio" CloseAction ="CloseButton"
                        HeaderText="Lista de Tipos de Servicio Disponibles" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxLabel ID="lblIdUnidad" runat ="server" ClientInstanceName ="lblIdUnidad" ClientVisible ="false" ></dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dx:ASPxListBox ID="lbTipoServicio" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                ValueField="idTipoServicio" Height="150px" ClientInstanceName="lbTipoServicio">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="nombre" Caption="Tipo de Servicio" Width="250px" />
                                                </Columns>
                                            </dx:ASPxListBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center">
                                            <dx:ASPxImage ID="imgCrear" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                ToolTip="Agregar Tipo Servicio" Cursor ="pointer">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if (lbTipoServicio.GetSelectedValues().length==0){
                                                        alert('No ha seleccionado ningún valor de la lista.');
                                                    } else {
                                                        pcTipoServicio.Hide();
                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'adcionarTipoServicio',lblIdUnidad.GetText() + ':' + lbTipoServicio.GetSelectedValues())
                                                    }
                                                }" />
                                            </dx:ASPxImage> 
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    <dx:ASPxPopupControl ID="pcPerfiles" runat="server" ClientInstanceName="pcPerfiles" CloseAction ="CloseButton"
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
                                            <dx:ASPxListBox ID="lbPerfiles" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                ValueField="IdPerfil" Height="400px" ClientInstanceName="lbPerfiles">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Perfil" Caption="Perfil" Width="250px" />
                                                </Columns>
                                            </dx:ASPxListBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center">
                                            <dx:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                ToolTip="Agregar Tipo Servicio" Cursor ="pointer">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if (lbPerfiles.GetSelectedValues().length==0){
                                                        alert('No ha seleccionado ningún valor de la lista.');
                                                    } else {
                                                        pcPerfiles.Hide();
                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'adcionarPerfil',lbIdTipo.GetText() + ':' + lbPerfiles.GetSelectedValues())
                                                        }
                                                }" />
                                            </dx:ASPxImage> 
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl> 
                    <dx:ASPxPopupControl ID="pcCrear" runat="server" ClientInstanceName="pcCrear" CloseAction ="CloseButton"
                        HeaderText="Crear Unidad Negocio" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr>
                                        <td class ="field" style="text-align:left" >
                                            Nombre:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID ="txtNombre" runat ="server" ClientInstanceName ="txtNombre" NullText ="Digite Nombre ..." 
                                                Width ="250px" TabIndex ="1">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings> 
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" style="text-align:left" >
                                            Tipo Servicio:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbTipoServicio" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                ClientInstanceName="cmbTipoServicio" DropDownStyle="DropDownList" ValueField="IdTipoServicio"
                                                TabIndex="2">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="idTipoServicio" Width="50px" Caption="Id" />
                                                    <dx:ListBoxColumn FieldName="nombre" Width="170px" Caption="Nombre" />
                                                </Columns>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistroTr">
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings> 
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" style="text-align:left" >
                                            Perfiles:
                                        </td>
                                        <td>
                                            <dx:ASPxGridLookup ID="gluPerfiles" runat="server" KeyFieldName="IdPerfil" SelectionMode="Multiple"
                                                IncrementalFilteringMode="StartsWith" TextFormatString="{0}" Width="250px" ClientInstanceName="gluPerfiles"
                                                MultiTextSeparator=", " AllowUserInput="false" TabIndex ="3"> 
                                                <ClientSideEvents ButtonClick="function(s,e) {gluPerfiles.GetGridView().UnselectAllRowsOnPage(); gluPerfiles.HideDropDown(); }" />
                                                <Buttons>
                                                    <dx:EditButton Text="X">
                                                    </dx:EditButton>
                                                </Buttons>
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True"/>
                                                    <dx:GridViewDataTextColumn FieldName="Perfil" Caption ="Perfil"/>
                                                    <dx:GridViewDataTextColumn FieldName="IdPerfil" Caption ="IdPerfil"/>
                                                </Columns>
                                                <GridViewProperties>
                                                    <SettingsBehavior AllowDragDrop="False" EnableRowHotTrack="True" />
                                                    <SettingsPager NumericButtonCount="5" PageSize="10" />
                                                </GridViewProperties>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistroTr">
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings> 
                                            </dx:ASPxGridLookup>
                                        </td>
                                        <td>
                                            <dx:ASPxHyperLink ID ="lnkAgrega" runat ="server" ImageUrl="~/images/DxAdd32.png" Cursor ="pointer"
                                                ToolTip ="Agregar">
                                                <ClientSideEvents Click ="function(s, e){
                                                        if(ASPxClientEdit.ValidateGroup(&#39;vgRegistroTr&#39;)){
                                                            EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'adcionar',1);
                                                        }
                                                    }" />
                                            </dx:ASPxHyperLink>
                                            <dx:ASPxHyperLink ID ="lnkCrea" runat ="server" ImageUrl="~/images/DxConfirm16.png" Cursor ="pointer"
                                                ToolTip ="Crear Unidad Negocio" ClientVisible ="false">
                                                <ClientSideEvents Click ="function(s, e){
                                                        if(ASPxClientEdit.ValidateGroup(&#39;vgRegistro&#39;)){
                                                            pcCrear.Hide();
                                                            cpGeneral.PerformCallback('crearUnidad' + ':' + 1);
                                                        }
                                                    }" />
                                            </dx:ASPxHyperLink>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan ="4" style="text-align:justify" >
                                            <dx:ASPxGridView ID="gvRegistro" runat="server" AutoGenerateColumns="False" Width="100%"
                                                ClientInstanceName="gvRegistro" KeyFieldName="IdRegistro" Theme ="SoftOrange">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn Caption ="Id" ShowInCustomizationForm ="true"
                                                        VisibleIndex ="0" FieldName ="IdTipoServicio"> 
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption ="Tipo Servicio" ShowInCustomizationForm ="true"
                                                        VisibleIndex ="1" FieldName ="TipoServicio">
                                                    </dx:GridViewDataTextColumn> 
                                                    <dx:GridViewDataColumn Caption ="Opciones" VisibleIndex ="2">
                                                        <DataItemTemplate>
                                                            <dx:ASPxHyperLink ID ="lnkEliminar" runat ="server" ImageUrl="~/images/DXEraser16.png" Cursor ="pointer"
                                                                ToolTip ="Eliminar Tipo Servicio" OnInit ="Link_InitRegistro">
                                                                <ClientSideEvents Click ="function(s, e){
                                                                    if (confirm('Realmente desea desvincular el tipo de servicio seleccionado?')){
                                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'eliminarTemporal',{0})
                                                                    }
                                                                }" />
                                                            </dx:ASPxHyperLink>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataColumn>
                                                </Columns>
                                                <Templates>
                                                    <DetailRow>
                                                        <dx:ASPxGridView ID="gvPerfilesDetalle" runat="server" ClientInstanceName="gvPerfilesDetalle"
                                                            Width="100%" OnBeforePerformDataSelect="gvPerfilesDetalle_DataSelect" Theme ="SoftOrange">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption ="Id Perfil" ShowInCustomizationForm ="true"
                                                                    VisibleIndex ="1" FieldName ="IdPerfil">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption ="Perfil" ShowInCustomizationForm ="true"
                                                                    VisibleIndex ="2" FieldName ="Perfil">
                                                                </dx:GridViewDataTextColumn> 
                                                            </Columns>
                                                        </dx:ASPxGridView> 
                                                    </DetailRow>
                                                </Templates>
                                                <SettingsDetail ShowDetailRow="true" />
                                            </dx:ASPxGridView> 
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl> 
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel> 
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
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
                        <dx:ASPxImage ID="imgNew" runat ="server" ImageUrl ="../images/List.png" Cursor ="pointer">
                            <ClientSideEvents Click ="function(s, e){
                                CallbackvsShowPopup(pcCrear,1,'crear','0.6','0.7');
                            }" />
                        </dx:ASPxImage>
                    </td>
                    <td style="text-align:left"> 
                        <dx:ASPxLabel id="lblNew" runat ="server" Text ="Crear Unidad Negocio" 
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
    </form>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet"/>
    <script src="../include/jquery-1.min.js" type="text/javascript"></script> 
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script> 
</body>
</html>
