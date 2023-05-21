<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionCampaniaFinanciero.aspx.vb"
    Inherits="BPColSysOP.AdministracionCampaniaFinanciero" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>:: Administrador Campañas Financieras ::</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function OnExpandCollapseButtonClick(s, e) {
            var isVisible = pnlDatos.GetVisible();
            s.SetText(isVisible ? "+" : "-");
            pnlDatos.SetVisible(!isVisible);
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                rblEstado.SetSelectedIndex(0);
            }
        }

        function EjecutarCallbackRegistro(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpRegistro.PerformCallback(parametro + ':' + valor);
            }
        }

        function EvaluarFiltros() {
            if (txtFiltroCampania.GetValue() == null && cmbTipoServicio.GetValue() == null && cmbCliente.GetValue() == null && cmbCiudad.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro de búsqueda.');
            } else {
                LoadingPanel.Show();
                gvCampanias.PerformCallback();
            }
        }

        function TamanioVentana() {
            if (typeof (window.innerWidth) == 'number') {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
                //IE 6+ in 'standards compliant mode'
                myWidth = document.documentElement.clientWidth;
                myHeight = document.documentElement.clientHeight;
            } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
                //IE 4 compatible
                myWidth = document.body.clientWidth;
                myHeight = document.body.clientHeight;
            }
        }

        function Editar(element, key) {
            TamanioVentana();
            dialogoVer.SetContentUrl("EditarCampaniaFinanciero.aspx?idCampania=" + key);
            dialogoVer.SetSize(myWidth * 0.9, myHeight * 0.9);
            dialogoVer.ShowWindow();
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 20%;">
        <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName ="cpRegistro">
            <ClientSideEvents EndCallback="function(s,e){ 
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide();
        }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpCampania" runat="server" HeaderText="Administración Campañas Financiero"
                        Width="100%" Theme="SoftOrange">
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="white-space: nowrap;" align="left">
                                        Administrac&oacute;n 
                                    </td> 
                                    <td style="width: 1%; padding-left: 5px;">
                                        <dx:ASPxButton ID="btnExpandCollapse" runat="server" Text="-" AllowFocus="False"
                                            AutoPostBack="False" Width="20px">
                                            <Paddings Padding="1px" />
                                            <FocusRectPaddings Padding="0" />
                                            <ClientSideEvents Click="OnExpandCollapseButtonClick" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxPanel ID="pnlDatos" runat="server" Width="100%" ClientInstanceName="pnlDatos">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table>
                                                <tr>
                                                    <td class="field" align="left">
                                                        Nombre Campaña:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxTextBox ID="txtNombreCampania" runat="server" Width="150px" TabIndex="1">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField ErrorText="El nombre de la campaña  es requerido" IsRequired="True" />
                                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </td>
                                                    <td class ="field" align ="left">
                                                        Cliente:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cmbCl" runat="server" Width="150px" IncrementalFilteringMode="Contains"
                                                            ClientInstanceName="cmbCl" DropDownStyle="DropDownList" TabIndex="2" ValueType ="System.Int32">
                                                            <Columns>
                                                                <dx:ListBoxColumn FieldName="nombre" Width="250px" Caption="Descripción" />
                                                            </Columns>
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField ErrorText="El cliente de la campaña  es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field" align="left">
                                                        Fecha Vigencia:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Inicial..." ClientInstanceName="dateFechaInicio"
                                                            Width="100px" TabIndex="3">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                            }" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                                            </ValidationSettings>
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Final..." ClientInstanceName="dateFechaFin"
                                                            Width="100px" TabIndex="4">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                            }" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                                            </ValidationSettings>
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" align="center">
                                                        <dx:ASPxPageControl ID="pcAsociadosCampania" runat="server" ActiveTabIndex="2" Width="100%">
                                                            <TabPages>
                                                                <dx:TabPage Text="Tipo Servicio">
                                                                    <TabImage Url="../images/structure.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl1" runat="server">
                                                                            <dx:ASPxPanel ID="pnlServicios" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbServicios" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdTipoServicio" Height="250px" ClientInstanceName="lbServicios">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="Nombre" Caption="Tipo Servicio" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                                <dx:TabPage Text="Bodegas CEM">
                                                                    <TabImage Url="../images/list_num.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl2" runat="server">
                                                                            <dx:ASPxPanel ID="pnlBodegas" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbBodegas" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="idbodega" Height="250px" ClientInstanceName="lbBodegas">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="bodega" Caption="Bodega" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                                <dx:TabPage Text="Producto Externo">
                                                                    <TabImage Url="../images/DxPikingList.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl3" runat="server">
                                                                            <dx:ASPxPanel ID="pnlProductoExt" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbProductoExt" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdProductoComercial" Height="250px" ClientInstanceName="lbProductoExt">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="ProductoExterno" Caption="Producto" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                                <dx:TabPage Text="Documentos">
                                                                    <TabImage Url="../images/documents_stack.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl4" runat="server">
                                                                            <dx:ASPxPanel ID="pnlDocumentos" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbDocumentos" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdProducto" Height="250px" ClientInstanceName="lbDocumentos">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="Nombre" Caption="Documentos" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                            </TabPages>
                                                        </dx:ASPxPageControl>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" align="center">
                                                        <dx:ASPxImage ID="imgCrear" runat="server" ImageUrl="../images/DxConfirm16.png"
                                                            ToolTip="Crear Campaña" Cursor ="pointer">
                                                            <ClientSideEvents Click ="function (s, e){
                                                                if(ASPxClientEdit.ValidateGroup('vgCampania')){
                                                                    if(lbServicios.GetSelectedValues().length==0 || lbBodegas.GetSelectedValues().length==0 || lbDocumentos.GetSelectedValues().length==0){
                                                                        alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Servicios, Ciudades, Productos y Documentos.');
                                                                    } else {
                                                                        EjecutarCallbackRegistro(s,e,'Registrar');
                                                                    }
                                                                }
                                                            }" />
                                                        </dx:ASPxImage> 
                                                        <dx:ASPxImage ID="imgCancelar" runat="server" ImageUrl="../images/DxCancel32.png"
                                                            ToolTip="Cancelar" Cursor ="pointer">
                                                            <ClientSideEvents Click="function(s, e){
                                                                LimpiaFormulario();
                                                            }" />
                                                        </dx:ASPxImage>
                                                    </td> 
                                                </tr>
                                            </table>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxPanel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    <div style="float:right; margin-top: 5px; width: 50%;">
        <dx:ASPxCallbackPanel runat="server" ID="cpBusquedaCampanias" ClientInstanceName="cpBusquedaCampanias"
            Theme ="SoftOrange">
            <PanelCollection>
                <dx:PanelContent>
                    <div style="margin-bottom: 15px">
                        <dx:ASPxRoundPanel ID="rpFiltroCampanias" runat="server" HeaderText="Filtro de Búsqueda" Theme ="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>
                                            <td class ="field" align ="left">
                                                Nombre Campaña:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtFiltroCampania" runat="server" Width="250px" TabIndex="5" ClientInstanceName ="txtFiltroCampania">
                                                </dx:ASPxTextBox>
                                            </td>
                                            <td class ="field">
                                                Tipo Servicio
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbTipoServicio" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                    ClientInstanceName="cmbTipoServicio" DropDownStyle="DropDownList" TabIndex="6" ValueType ="System.Int32">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="nombre" Width="250px" Caption="Descripción" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>    
                                        <tr>
                                            <td class ="field" align ="left">
                                                Cliente Externo:
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbCliente" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                    ClientInstanceName="cmbCliente" DropDownStyle="DropDownList" TabIndex="7" ValueType ="System.Int32">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="nombre" Width="250px" Caption="Descripción" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td class ="field" align ="left">
                                                Ciudad:
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbCiudad" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                    ClientInstanceName="cmbCiudad" DropDownStyle="DropDownList" TabIndex="8" ValueType ="System.Int32">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="Ciudad" Width="250px" Caption="Descripción" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class ="field" align ="left">
                                                Estado:
                                            </td>
                                            <td>
                                                <dx:ASPxRadioButtonList ID="rblEstado" runat="server" RepeatDirection="Horizontal"
                                                    ClientInstanceName="rblEstado" Font-Size ="XX-Small" TabIndex ="9">
                                                    <Items>
                                                        <dx:ListEditItem Text="Activo" Value="1" Selected="true" />
                                                        <dx:ListEditItem Text="Inactivo" Value="0" />
                                                    </Items>
                                                    <Border BorderStyle="None"></Border>
                                                </dx:ASPxRadioButtonList>
                                            </td>
                                            <td colspan="2" align="center">
                                                <dx:ASPxImage ID="imgFiltro" runat="server" ImageUrl="../images/DxAdd32.png"
                                                    ToolTip="Filtrar" Cursor ="pointer">
                                                    <ClientSideEvents Click ="function (s, e){
                                                        EvaluarFiltros();
                                                    }" />
                                                </dx:ASPxImage> 
                                                <dx:ASPxImage ID="imgCancela" runat="server" ImageUrl="../images/DxCancel32.png"
                                                    ToolTip="Cancelar" Cursor ="pointer">
                                                    <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                    }" />
                                                </dx:ASPxImage>
                                            </td> 
                                        </tr>
                                    </table> 
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel> 
                    </div>
                    <div style="margin-bottom: 5px;">
                        <dx:ASPxRoundPanel ID="rpResultadoCampanias" runat="server" HeaderText="Listado de Campañas"
                            Width="100%" Theme ="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gvCampanias" runat="server" Width="100%" ClientInstanceName="gvCampanias"
                                        AutoGenerateColumns="False" KeyFieldName="IdCampania" Theme ="SoftOrange" SettingsLoadingPanel-Mode="Disabled">
                                        <ClientSideEvents EndCallback="function(s,e){ 
                                            $('#divEncabezado').html(s.cpMensaje);
                                            LoadingPanel.Hide();
                                        }"></ClientSideEvents>
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="ID" ShowInCustomizationForm="True" VisibleIndex="0"
                                                FieldName="IdCampania">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Nombre Campaña" ShowInCustomizationForm="True"
                                                VisibleIndex="1" FieldName="Nombre">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Fecha Inicio" FieldName="FechaInicio" ShowInCustomizationForm="True"
                                                VisibleIndex="2">
                                                <PropertiesTextEdit DisplayFormatString="{0:d}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn Caption="Fecha Fin" ShowInCustomizationForm="true" VisibleIndex="3"
                                                FieldName="FechaFin">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataCheckColumn Caption="Activo" ShowInCustomizationForm="true" VisibleIndex="5"
                                                FieldName="Activo">
                                            </dx:GridViewDataCheckColumn>
                                            <dx:GridViewDataColumn Caption="" VisibleIndex="6">
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/Edit-User.png"
                                                        Cursor="pointer" ToolTip="Ver / Editar Plan" OnInit="Link_Init">
                                                        <ClientSideEvents Click="function(s, e) { Editar(this, {0}); }" />
                                                    </dx:ASPxHyperLink>
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                        </Columns>
                                        <SettingsText Title="B&#250;squeda General de Campañas" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda">
                                        </SettingsText>
                                        <SettingsLoadingPanel Mode="Disabled"></SettingsLoadingPanel>
                                    </dx:ASPxGridView> 
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel> 
                    </div>  
                </dx:PanelContent>
            </PanelCollection> 
        </dx:ASPxCallbackPanel> 
    </div> 
    <dx:ASPxPopupControl ID="pcVer" runat="server" ClientInstanceName="dialogoVer" HeaderText="Información"
        AllowDragging="true" Width="410px" Height="260px" Modal="true" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter" CloseAction="CloseButton">
        <ContentCollection>
            <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
