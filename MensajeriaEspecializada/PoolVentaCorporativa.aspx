<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolVentaCorporativa.aspx.vb" Inherits="BPColSysOP.PoolVentaCorporativa" %>

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
        <div style="width: 90%; min-width: 500px">
            <table>
                <tr>
                    <td style="text-align:left" >
                        <a style="color: Black; font-size: 15px;cursor: pointer;" id="aLecturas"
                            onclick="toggle('divFiltros');">
                            <asp:Image ID="imgFiltro" runat="server" ImageUrl="~/images/find.gif" ToolTip="Ver/Ocultar Filtros Búsqueda"
                                Width="16px" /></a>
                    </td>
                </tr>
            </table>
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdIdServicio" runat ="server" ClientInstanceName ="hdIdServicio"></dx:ASPxHiddenField>
                    <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;width: 90%;">
                        <dx:ASPxRoundPanel ID="rpFiltros" runat="server" Theme="SoftOrange" HeaderText="Filtros de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxFormLayout ID="flFiltro" runat="server" ColCount="3">
                                    <Items>
                                        <dx:LayoutItem Caption="No. Radicado:" RequiredMarkDisplayMode="Required" RowSpan="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                    <div>
                                                        <dx:ASPxRadioButtonList ID="rblTipoServicio" runat="server" RepeatDirection="Horizontal"
                                                            ClientInstanceName="rblTipoServicio" Font-Size="XX-Small" Height="10px">
                                                            <Items>
                                                                <dx:ListEditItem Text="Servicio" Value="0" Selected="true" />
                                                                <dx:ListEditItem Text="Radicado" Value="1" />
                                                            </Items>
                                                            <Border BorderStyle="None"></Border>
                                                        </dx:ASPxRadioButtonList>
                                                    </div>
                                                    <dx:ASPxMemo ID="mePedidos" runat="server" Height="71px" Width="270px" NullText="Ingrese uno o varios servicios..."
                                                        ClientInstanceName="mePedidos" TabIndex="0">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                            <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[0-9\s\-]+\s*$" />
                                                        </ValidationSettings>
                                                    </dx:ASPxMemo>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Ciudad:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                    <dx:ASPxComboBox ID="cmbCiudad" runat="server" ClientInstanceName="cmbCiudad" Width="250px"
                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idCiudad" 
                                                            CallbackPageSize="25" EnableCallbackMode="true" FilterMinLength="3" >
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="idCiudad" Caption="Id" Width="20px" Visible ="false"/>
                                                            <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblComentario" runat="server" Text="Digite parte de la ciudad."
                                                            CssClass="comentario" Width="270px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Estado:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                    <dx:ASPxComboBox ID="cmbEstado" runat="server" ClientInstanceName="cmbEstado" Width="250px"
                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idEstado">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="idEstado" Caption="Id" Width="20px" Visible ="false"/>
                                                            <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Bodega:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                    <dx:ASPxComboBox ID="cmbBodega" runat="server" ClientInstanceName="cmbBodega" Width="250px"
                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idbodega">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="idbodega" Caption="Id" Width="20px" Visible ="false"/>
                                                            <dx:ListBoxColumn FieldName="bodega" Caption="Nombre" Width="300px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Tipo Servicio:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                    <dx:ASPxComboBox ID="cmbTipoServicio" runat="server" ClientInstanceName="cmbTipoServicio" Width="250px"
                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idTipoServicio">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="idTipoServicio" Caption="Id" Width="20px" Visible ="false"/>
                                                            <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Fecha Inicial:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                    <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                        Width="100px" TabIndex="6">
                                                        <ClientSideEvents ValueChanged="function(s, e){
                                                    dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                }" />
                                                    </dx:ASPxDateEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Fecha Final:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                    <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                        Width="100px" TabIndex="7">
                                                        <ClientSideEvents ValueChanged="function(s, e){
                                                dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                }" />
                                                    </dx:ASPxDateEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Eventos">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                    <div style="float: left">
                                                        <dx:ASPxImage ID="imgBuscar" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Búsqueda"
                                                            ClientInstanceName="imgBuscar" Cursor="pointer">
                                                            <ClientSideEvents Click="function(s, e){
                                                            if(ASPxClientEdit.ValidateGroup('vgFiltro')){
                                                                     if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null && mePedidos.GetValue() == null && cmbCiudad.GetValue() == null
                                                                            && cmbEstado.GetValue() == null && cmbBodega.GetValue() == null && cmbTipoServicio.GetValue() == null) {
                                                                        alert('Debe seleccionar por lo menos un filtro de búsqueda.');
                                                                    } else {
                                                                        if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() != null) {
                                                                            alert('Debe digitar los dos rangos de fechas.');
                                                                        } else {
                                                                            if (dateFechaInicio.GetValue() != null && dateFechaFin.GetValue() == null) {
                                                                                alert('Debe digitar los dos rangos de fechas.');
                                                                            } else { EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultar', 1);}
                                                                        }
                                                                    }
                                                                }
                                                            }" />
                                                        </dx:ASPxImage>
                                                        <div>
                                                            <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="Filtrar" CssClass="comentario">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </div>
                                                    <div style="float: left">
                                                        <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Borrar Filtros"
                                                            ClientInstanceName="imgBuscar" TabIndex="10" Cursor="pointer">
                                                            <ClientSideEvents Click="function(s, e){
                                                                LimpiaFormulario('formPrincipal');
                                                                rblTipoServicio.SetSelectedIndex(0);
                                                                cbFormatoExportar.SetSelectedIndex(0);
                                                                cmbCiudad.SetSelectedIndex(-1);
                                                            }" />
                                                        </dx:ASPxImage>
                                                        <div>
                                                            <dx:ASPxLabel ID="lblComentarioBorrar" runat="server" Text="Borrar" CssClass="comentario">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </div>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel> 
                    </div>
                    <br />
                    <table>
                        <tr>
                            <td style="text-align: center">
                                <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                                    KeyFieldName="IdServicioMensajeria" Theme="SoftOrange" Width="100%">
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="1" Width="40px">
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="lnkBloqueo" runat ="server" ImageUrl="~/images/DxMarker.png" Cursor ="pointer" 
                                                ToolTip ="Bloquear Servicio" OnInit="Link_Init">
                                                <ClientSideEvents Click ="function(s, e){
                                                    if (confirm('Esta seguro de bloquear el servicio?. Esto impedirá que otro usuario pueda modificarlo. Desea continuar?')){
                                                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'bloquearServicio', {0})
                                                    }
                                                }" />
                                            </dx:ASPxHyperLink> 
                                            <dx:ASPxHyperLink ID="lnkFacturar" runat ="server" ImageUrl="~/images/DxFacturar16.png" Cursor ="pointer" 
                                                ToolTip ="Facturar Servicio" OnInit="Link_Init">
                                                <ClientSideEvents Click ="function(s, e){
                                                    PopUpSetContenUrl(pcGeneral,'FacturacionVentaCorporativa.aspx?idServicio=' + {0},'0.9','0.9');
                                                }" />
                                            </dx:ASPxHyperLink> 
                                            <dx:ASPxHyperLink ID="lnkEditarMin" runat ="server" ImageUrl="~/images/documents_stack.png" Cursor ="pointer" 
                                                ToolTip ="Editar Msisdn" OnInit="Link_Init">
                                                <ClientSideEvents Click ="function(s, e){
                                                    PopUpSetContenUrl(pcGeneral,'ModificacionMinesVentaCorporativa.aspx?idServicio=' + {0},'0.9','0.9');
                                                }" />
                                            </dx:ASPxHyperLink> 
                                            <dx:ASPxHyperLink ID="lnkEditarMinP" runat ="server" ImageUrl="~/images/documents_stack.png" Cursor ="pointer" 
                                                ToolTip ="Editar Msisdn" OnInit="Link_Init">
                                                <ClientSideEvents Click ="function(s, e){
                                                    PopUpSetContenUrl(pcGeneral,'ModificacionMinesVentaCorporativa.aspx?idServicio=' + {0},'0.9','0.9');
                                                }" />
                                            </dx:ASPxHyperLink> 
                                            <dx:ASPxHyperLink ID="lnkLiberar" runat ="server" ImageUrl="~/images/upload.png" Cursor ="pointer" 
                                                ToolTip ="Liberar Servicio" OnInit="Link_Init">
                                                <ClientSideEvents Click ="function(s, e){
                                                    PopUpSetContenUrl(pcGeneral,'LiberarServicio.aspx?idServicio=' + {0},'0.9','0.9');
                                                }" />
                                            </dx:ASPxHyperLink> 
                                            <dx:ASPxHyperLink ID="lnkVer" runat ="server" ImageUrl="~/images/DxSearch16.png" Cursor ="pointer" 
                                                ToolTip ="Ver Información Servicio" OnInit="Link_Init">
                                                <ClientSideEvents Click ="function(s, e){
                                                    //PopUpSetContenUrl(pcGeneral2,'VerInformacionServicioTipoVentaCorporativa.aspx?idServicio=' + {0},'0.9','0.9');
                                                    WindowLocation('VerInformacionServicioTipoVentaCorporativa.aspx?idServicio=' + {0} +'&flag=1');
                                                }" />
                                            </dx:ASPxHyperLink> 
                                        </DataItemTemplate>
                                        </dx:GridViewDataColumn> 
                                        <dx:GridViewDataTextColumn VisibleIndex="2" Caption="Id Servicio" FieldName="IdServicioMensajeria" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="3" Caption="Radicado" FieldName="NumeroRadicado" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="4" Caption="Tipo de Servicio" FieldName="TipoServicio" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="5" Caption="Fecha de Agenda" FieldName="FechaAgendaString" ShowInCustomizationForm="true">
                                            <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="6" Caption="Jornada" FieldName="Jornada" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="7" Caption="Estado" FieldName="Estado" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="8" Caption="Fecha De Confirmacion" FieldName="FechaConfirmacionString" ShowInCustomizationForm="true">
                                            <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="9" Caption="Responsable de Entrega" FieldName="ResponsableEntrega" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="10" Caption="Tiene Novedad" FieldName="TieneNovedad" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="11" Caption="Nombre de Cliente" FieldName="NombreCliente" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="12" Caption="Persona de Contacto" FieldName="PersonaContacto" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="13" Caption="Ciudad" FieldName="Ciudad" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="14" Caption="Bodega" FieldName="Bodega" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="15" Caption="Barrio" FieldName="Barrio" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="16" Caption="Direcci&oacute;n" FieldName="Direccion" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="17" Caption="Tel&eacute;fono" FieldName="TelefonoContacto" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn VisibleIndex="18" Caption="">
                                            <DataItemTemplate>
                                                </td> </tr>
                                                <tr>
                                                    <td class="field">Observaci&oacute;n
                                                    </td>
                                                    <td colspan="16" style="text-align: left">
                                                        <asp:Literal runat="server" ID="ltObservacion" Text='<%# Bind("Observacion") %>'></asp:Literal>
                                                    </td>
                                                </tr>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
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
                                <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                            </td>
                        </tr>
                    </table>
                    <div id="bluebar" class="menuFlotante">
                        <b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4">
                        </b></b>
                        <dx:ASPxPanel ID="pnlControles" runat ="server" ClientInstanceName ="pnlControles">
                            <PanelCollection>
                                <dx:PanelContent>
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
                                            <td>
                                                <dx:ASPxImage ID="imgVerInfoServicio" runat ="server" ImageUrl="~/images/DxView24.png" ToolTip ="Ver Información Servicio"
                                                        Cursor ="pointer" Visible ="false">
                                                    <ClientSideEvents Click ="function(s,e){
                                                        hdIdServicio.Set('aplicaFiltro',0);
                                                        var val = hdIdServicio.Get('idServicio');
                                                        PopUpSetContenUrl(pcGeneral,'VerInformacionServicio.aspx?idServicio=' + val,'0.9','0.9');
                                                    }" />
                                                </dx:ASPxImage>
                                            </td>
                                        </tr>
                                    </table> 
                                </dx:PanelContent>
                            </PanelCollection> 
                        </dx:ASPxPanel> 
                    </div>
                    <div id="div1" style="float: right; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
                        width: 2%; position: fixed; overflow: hidden; display: block; bottom: 0px">
                        <table>
                            <tr>
                                <td style="text-align:left">
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
        <dx:ASPxPopupControl ID="pcGeneral" runat="server" 
            ClientInstanceName="pcGeneral" Modal="true" CloseAction ="CloseButton" 
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter" 
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ClientSideEvents CloseUp ="function (s,e){
                EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultar', 1);
                }" />
                <ContentCollection>
                </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="pcGeneral2" runat="server" 
            ClientInstanceName="pcGeneral2" Modal="true" CloseAction ="CloseButton" 
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter" 
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
            </ContentCollection>
        </dx:ASPxPopupControl>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
    </form>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
</body>
</html>
