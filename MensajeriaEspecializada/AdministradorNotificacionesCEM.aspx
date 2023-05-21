<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministradorNotificacionesCEM.aspx.vb"
    Inherits="BPColSysOP.AdministradorNotificacionesCEM" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administrador de Notificaciones CEM</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        var textSeparator = ";";
        function OnListBoxSelectionChangedBodega(listBox, args) {
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            UpdateSelectAllItemStateBodega();
            UpdateTextBodega();
        }

        function UpdateSelectAllItemStateBodega() {
            IsAllSelectedBodega() ? lbBodega.SelectIndices([0]) : lbBodega.UnselectIndices([0]);
        }

        function IsAllSelectedBodega() {
            var selectedDataItemCount = lbBodega.GetItemCount() - (lbBodega.GetItem(0).selected ? 0 : 1);
            return lbBodega.GetSelectedItems().length == selectedDataItemCount;
        }

        function UpdateTextBodega() {
            var selectedItems = lbBodega.GetSelectedItems();
            
            cmbBodegaCEM.SetText(GetSelectedItemsText(selectedItems));
        }

        function SynchronizeListBoxValuesBodega(dropDown, args) {
            //lbBodega.UnselectAll();
            var texts = dropDown.GetText().split(textSeparator);
            var values = GetValuesByTexts(texts);
            lbBodega.SelectValues(values);
            UpdateSelectAllItemStateBodega();
            UpdateTextBodega(); // for remove non-existing texts
        }

        function GetSelectedItemsText(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                if (items[i].index != 0)
                    texts.push(items[i].text);
            return texts.join(textSeparator);
        }

        function GetValuesByTexts(texts) {
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = lbBodega.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }

        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function FiltrarDevExpNombre(s, e) {
            try {
                if (s.GetText().length >= 4 || cmbNombre.GetItemCount() != 0) {
                    cpFiltroNombre.PerformCallback(s.GetText());
                } else {
                    cmbNombre.ClearItems();
                }
            }
            catch (e) { }
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                cbFormatoExportar.SetSelectedIndex(0);
                rblFiltroEstado.SetSelectedIndex(0);
                gvDatos.PerformCallback("limpiar");
            }
        }

        function EvaluarClicFiltro() {
            if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null && cmbTipo.GetValue() == null && cmbBodega.GetValue() == null
                && cmbNombre.GetValue() == null && txtMail.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro de búsqueda.');
            } else {
                if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() != null) {
                    alert('Debe digitar los dos rangos de fechas.');
                } else {
                    if (dateFechaInicio.GetValue() != null && dateFechaFin.GetValue() == null) {
                        alert('Debe digitar los dos rangos de fechas.');
                    } else { gvDatos.PerformCallback("consultar"); }
                }
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

        function ConfigurarNotificacion(element, url) {
            TamanioVentana();
            dialogoVer.SetContentUrl(url);
            dialogoVer.SetSize(myWidth * 0.9, myHeight * 0.9);
            dialogoVer.ShowWindow();
        }

        function Editar(element, key) {
            TamanioVentana();
            dialogoEdita.PerformCallback(key + ":informacion")
            dialogoEdita.SetSize(myWidth * 0.7, myHeight * 0.4);
            dialogoEdita.ShowWindow();
            txtEditNombre.Focus();
        }

        function Eliminar(element, key) {
            gvDatos.PerformCallback(key + ":eliminar")
        }

        function ValidarEnter(flag) {
            var kCode = (event.keyCode ? event.keyCode : event.which);
            if (kCode.toString() == "13") {
                if (flag == 1) {
                    btnRegistro.DoClick();
                } else {
                    btnActualiza.DoClick();
                }
            }
        }

    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) {
                $('#divEncabezado').html(s.cpMensaje);
            }" />
    </dx:ASPxCallback>
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="width: 90%; min-width: 500px">
        <table>
            <tr>
                <td align="left">
                    <a style="color: Black; font-size: 15px; cursor: hand; cursor: pointer;" id="aLecturas"
                        onclick="toggle('divFiltros');">
                        <asp:Image ID="imgFiltro" runat="server" ImageUrl="~/images/find.gif" ToolTip="Ver/Ocultar Filtros Búsqueda"
                            Width="16px" /></a>
                </td>
            </tr>
        </table>
    </div>
    <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral"
        EnableAnimation="True" >
        <ClientSideEvents EndCallback="function (s, e) {
            $('#divEncabezado').html(s.cpMensaje);
        }" />
        <PanelCollection>
            <dx:PanelContent>
                <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
                    width: 65%;">
                    <dx:ASPxCallbackPanel ID="cpFiltros" runat="server" ClientInstanceName="cpFiltros">
                        <ClientSideEvents EndCallback="function(s, e) { 
                    $('#divEncabezado').html(s.cpMensaje);
                }" />
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtros de Búsqueda"
                                    Width="100%" Theme="SoftOrange">
                                    <HeaderTemplate>
                                        <dx:ASPxImage ID="headerImage" runat="server" ImageUrl="../images/DxMarker.png" Cursor="pointer"
                                            ImageAlign="Right" ToolTip="Configurar Notificación">
                                            <ClientSideEvents Click="function (s,e){
                                        ConfigurarNotificacion(this, 'CrearNotificacionesCEM.aspx');
                                    }" />
                                        </dx:ASPxImage>
                                    </HeaderTemplate>
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table cellpadding="1" width="100%" onkeydown="ValidarEnter(1);">
                                                <tr>
                                                    <td class="field" align="left">
                                                        Tipo Notificación:
                                                    </td>
                                                    <td colspan="4">
                                                        <dx:ASPxComboBox ID="cmbTipo" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                            ClientInstanceName="cmbTipo" DropDownStyle="DropDownList" TabIndex="0">
                                                            <Columns>
                                                                <dx:ListBoxColumn FieldName="idAsuntoNotificacion" Width="50px" Caption="Id." />
                                                                <dx:ListBoxColumn FieldName="nombre" Width="300px" Caption="Estado" />
                                                            </Columns>
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                    <td class="field" align="left">
                                                        Bodega:
                                                    </td>
                                                    <td>
                                                        <div style="float: left; width: 200px">
                                                            <dx:ASPxComboBox ID="cmbBodega" runat="server" Width="100%" IncrementalFilteringMode="Contains"
                                                                ClientInstanceName="cmbBodega" DropDownStyle="DropDownList" TabIndex="1" ValueField="idBodega"
                                                                ValueType="System.String" TextFormatString="{0} ({1})">
                                                                <Columns>
                                                                    <dx:ListBoxColumn FieldName="idbodega" Width="50px" Caption="Id." />
                                                                    <dx:ListBoxColumn FieldName="bodega" Width="300px" Caption="Bodega" />
                                                                </Columns>
                                                            </dx:ASPxComboBox>
                                                        </div>
                                                    </td>
                                                    <td class="field" align="left">
                                                        E-mail:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxTextBox ID="txtMail" runat="server" NullText="Ingrese Mail..." Width="200px"
                                                            ClientInstanceName="txtMail" TabIndex="4">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                                <RegularExpression ErrorText="Formato no válido para el Mail" ValidationExpression="\S+@\S+\.\S+" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field" align="left">
                                                        Destinatario Notificación:
                                                    </td>
                                                    <td colspan="4">
                                                        <div style="display: inline; float: left;">
                                                            <dx:ASPxTextBox ID="txtNombreFiltro" runat="server" Width="50px" MaxLength="15" TabIndex="2">
                                                                <ClientSideEvents KeyUp="function(s, e) { 
                                                            FiltrarDevExpNombre(s, e) 
                                                        }"></ClientSideEvents>
                                                            </dx:ASPxTextBox>
                                                        </div>
                                                        <dx:ASPxCallbackPanel ID="cpFiltroNombre" runat="server" RenderMode="Div" ClientInstanceName="cpFiltroNombre">
                                                            <ClientSideEvents EndCallback="function(s, e) {}"></ClientSideEvents>
                                                            <PanelCollection>
                                                                <dx:PanelContent>
                                                                    <div style="display: inline; float: left">
                                                                        <dx:ASPxComboBox ID="cmbNombre" runat="server" Width="200px" IncrementalFilteringMode="Contains"
                                                                            ClientInstanceName="cmbNombre" DropDownStyle="DropDownList" TabIndex="3">
                                                                            <Columns>
                                                                                <dx:ListBoxColumn FieldName="idUsuarioNotificacion" Width="50px" Caption="Id." />
                                                                                <dx:ListBoxColumn FieldName="nombreCompuesto" Width="300px" Caption="Nombre" />
                                                                            </Columns>
                                                                        </dx:ASPxComboBox>
                                                                    </div>
                                                                    <div id="divResultadoMaterial" style="width: 250px">
                                                                        <dx:ASPxLabel ID="lblResultadoNombre" runat="server" CssClass="comentario" Width="100px"
                                                                            Font-Size="XX-Small" Font-Italic="True">
                                                                        </dx:ASPxLabel>
                                                                    </div>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxCallbackPanel>
                                                    </td>
                                                    <td class="field" align="left">
                                                        Estado:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxRadioButtonList ID="rblFiltroEstado" runat="server" ClientInstanceName="rblFiltroEstado"
                                                            RepeatDirection="Horizontal" TextAlign="Left">
                                                            <Items>
                                                                <dx:ListEditItem Text="Activo" Value="1" Selected="true" />
                                                                <dx:ListEditItem Text="Inactivo" Value="2" />
                                                                <dx:ListEditItem Text="Ambos" Value="3" />
                                                            </Items>
                                                            <Border BorderStyle="None" />
                                                        </dx:ASPxRadioButtonList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field" align="left">
                                                        Fecha Inicial:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                            Width="90px" TabIndex="5">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                    dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td class="field" align="left">
                                                        Fecha Final:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                            Width="90px" TabIndex="6">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                        if (dateFechaInicio.GetDate()==null){
                                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                        }
                                                    }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td colspan="3" align="right">
                                                        <dx:ASPxImage ID="imgFiltrar" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                            ToolTip="Filtrar" ClientInstanceName="imgFiltrar" Cursor="pointer" TabIndex="8">
                                                            <ClientSideEvents Click="function(s, e){
                                                        if(ASPxClientEdit.ValidateGroup('vgFiltro')){
                                                            btnRegistro.DoClick();
                                                            }        
                                                    }" />
                                                        </dx:ASPxImage>
                                                        <div>
                                                            <dx:ASPxLabel ID="lblComentario" runat="server" Text="Filtrar" CssClass="comentario">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                        <dx:ASPxButton ID="btnRegistro" runat="server" ClientInstanceName="btnRegistro" ClientVisible="false"
                                                            AutoPostBack="false">
                                                            <ClientSideEvents Click="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgFiltro')){
                                                            EvaluarClicFiltro();
                                                        }        
                                                }" />
                                                        </dx:ASPxButton>
                                                    </td>
                                                    <td align="center">
                                                        <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Borrar Filtros"
                                                            ClientInstanceName="imgBorrar" Cursor="pointer" TabIndex="9">
                                                            <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                    }" />
                                                        </dx:ASPxImage>
                                                        <div>
                                                            <dx:ASPxLabel ID="lblComentarioBorrar" runat="server" Text="Borrar" CssClass="comentario">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>
                </div>
                <div style="clear: both">
                </div>
                <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px; width: 60%;">
                    <dx:ASPxRoundPanel ID="rpResultado" runat="server" HeaderText="Resultados de Búsqueda"
                        Width="150%" Theme="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvDatos" runat="server" Width="100%" AutoGenerateColumns="False"
                                    ClientInstanceName="gvDatos" KeyFieldName="IdUsuarioNotificacion" Theme="SoftOrange"
                                    TabIndex="10">
                                    <ClientSideEvents EndCallback="function(s, e) {
                                        $('#divEncabezado').html(s.cpMensaje);
                                    }"></ClientSideEvents>
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="IdUsuarioNotificacion" Caption="Id." ShowInCustomizationForm="True"
                                            VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Nombres" Caption="Nombre(s)" ShowInCustomizationForm="True"
                                            VisibleIndex="1">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Apellidos" Caption="Apellido(s)" ShowInCustomizationForm="True"
                                            VisibleIndex="2">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="TipoNotificacion" Caption="Tipo Notificación"
                                            ShowInCustomizationForm="True" VisibleIndex="3">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Email" Caption="E-Mail" ShowInCustomizationForm="True"
                                            VisibleIndex="5">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="FechaCreacion" Caption="Fecha Creación" ShowInCustomizationForm="True"
                                            VisibleIndex="5">
                                            <PropertiesTextEdit DisplayFormatString="{0:d}">
                                            </PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="7">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink runat="server" ID="lnkEdit" ImageUrl="../images/DxSearch16.png"
                                                    Cursor="pointer" ToolTip="Editar" OnInit="Link_Init">
                                                    <ClientSideEvents Click="function(s, e) { Editar(this, {0}); }" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eraser_minus.png"
                                                    Cursor="pointer" ToolTip="Eliminar" OnInit="Link_Init">
                                                    <ClientSideEvents Click="function(s, e) { 
                                                        if (confirm('Esta seguro de eliminar el registro?')){
                                                            Eliminar(this, {0}); }
                                                    }" />
                                                </dx:ASPxHyperLink>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                    <SettingsPager PageSize="50">
                                        <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                    </SettingsPager>
                                    <Settings ShowFooter="false" ShowHeaderFilterButton="true" />
                                    <SettingsDetail ShowDetailRow="True"></SettingsDetail>
                                    <Templates>
                                        <DetailRow>
                                            <dx:ASPxGridView ID="gvDetalle" ClientInstanceName="gvDetalle" runat="server" AutoGenerateColumns="false"
                                                Width="100%" OnBeforePerformDataSelect="gvDetalle_DataSelect" Theme="SoftOrange">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="bodega" Caption="Bodega" ShowInCustomizationForm="True"
                                                        VisibleIndex="1">
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                                <Settings ShowFooter="false" />
                                            </dx:ASPxGridView>
                                        </DetailRow>
                                    </Templates>
                                </dx:ASPxGridView>
                                <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos">
                                </dx:ASPxGridViewExporter>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
                <dx:ASPxPopupControl ID="pcVer" runat="server" ClientInstanceName="dialogoVer" HeaderText="Información"
                    AllowDragging="true" Width="410px" Height="260px" Modal="true" PopupHorizontalAlign="WindowCenter"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton" Theme="SoftOrange">
                    <ContentCollection>
                        <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                    <ClientSideEvents Closing ="function (s, e){
                        if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null && cmbTipo.GetValue() == null && cmbBodega.GetValue() == null
                                && cmbNombre.GetValue() == null && txtMail.GetValue() == null) {} else {
                                gvDatos.PerformCallback('consultar');}
                        }" 
                    />
                </dx:ASPxPopupControl>
                <dx:ASPxPopupControl ID="pcEditar" runat="server" ClientInstanceName="dialogoEdita"
                    HeaderText="Información" AllowDragging="true" Width="410px" Height="260px" Modal="true"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    ScrollBars="Auto" Theme="SoftOrange">
                    <ClientSideEvents EndCallback="function (s,e){
                         $('#divEncabezado').html(s.cpMensaje);
                         txtEditNombre.Focus();
                         cmbBodegaCEM.ShowDropDown();
                    }" />
                    <ContentCollection>
                        <dx:PopupControlContentControl ID="pccEdita" runat="server">
                            <table cellpadding="1" width="100%" onkeydown="ValidarEnter(2);">
                                <tr>
                                    <td class="field" align="left">
                                        Nombre:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtEditNombre" runat="server" NullText="Ingrese Nombre..." Width="200px"
                                            ClientInstanceName="txtEditNombre" MaxLength="150">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                <RegularExpression ErrorText="Formato no válido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                <RequiredField ErrorText="El nombre es requerido" IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td class="field" align="left">
                                        Apellido:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtEditApellido" runat="server" NullText="Ingrese Apellido..."
                                            Width="200px" ClientInstanceName="txtEditApellido" MaxLength="150">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                <RegularExpression ErrorText="Formato no válido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                <RequiredField ErrorText="El apellido es requerido" IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field" align="left">
                                        E-mail:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtEditCorreo" runat="server" NullText="Ingrese E-mail..." Width="200px"
                                            ClientInstanceName="txtEditCorreo" MaxLength="150">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                <RegularExpression ErrorText="Formato no válido" ValidationExpression="\S+@\S+\.\S+" />
                                                <RequiredField ErrorText="El mail es requerido" IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td class="field" align="left">
                                        Tipo Notificación:
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cmbEditTipo" runat="server" Width="200px" IncrementalFilteringMode="Contains"
                                            ClientInstanceName="cmbEditTipo" DropDownStyle="DropDownList" TabIndex="1">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="idAsuntoNotificacion" Width="50px" Caption="Id." />
                                                <dx:ListBoxColumn FieldName="nombre" Width="300px" Caption="Asunto" />
                                            </Columns>
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                <RequiredField ErrorText="El mail es requerido" IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field" align="left">
                                        Bodega:
                                    </td>
                                    <td>
                                        <dx:ASPxDropDownEdit ID="cmbBodegaCEM" runat="server" ClientInstanceName="cmbBodegaCEM"
                                            Width="200px" TabIndex="3">
                                            <DropDownWindowTemplate>
                                                <dx:ASPxListBox ID="lbBodega" runat="server" TabIndex="4" ClientInstanceName="lbBodega"
                                                    SelectionMode="CheckColumn" Width="300px">
                                                    <Border BorderStyle="None" />
                                                    <ClientSideEvents SelectedIndexChanged="OnListBoxSelectionChangedBodega" 
                                                        LostFocus="function (s, e){ 
                                                            UpdateTextBodega();
                                                    }" />
                                                </dx:ASPxListBox>
                                                <table cellpadding="4" cellspacing="0" style="width: 100%">
                                                    <tr>
                                                        <td align="right">
                                                            <dx:ASPxButton ID="btnCerrar" runat="server" AutoPostBack="False" Text="Cerrar">
                                                                <ClientSideEvents Click="function(s, e){ 
                                                                    cmbBodegaCEM.HideDropDown(); 
                                                                    UpdateTextBodega();
                                                                }" />
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </DropDownWindowTemplate>
                                            <ClientSideEvents DropDown="SynchronizeListBoxValuesBodega" TextChanged="SynchronizeListBoxValuesBodega"
                                                LostFocus="function(s,e){
                                                    UpdateTextBodega();
                                                    }" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                <RequiredField ErrorText="Bodega requerida" IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxDropDownEdit>
                                    </td>
                                    <td class="field" align="left">
                                        Destino:
                                    </td>
                                    <td>
                                        <dx:ASPxRadioButtonList ID="rblDestino" runat="server" RepeatDirection="Horizontal"
                                            ClientInstanceName="rblDestino">
                                            <Items>
                                                <dx:ListEditItem Text="Principal" Value="1" />
                                                <dx:ListEditItem Text="Copia" Value="2" />
                                            </Items>
                                            <Border BorderStyle="None" />
                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxRadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field" align="left">
                                        Estado:
                                    </td>
                                    <td>
                                        <dx:ASPxRadioButtonList ID="rblEstado" runat="server" RepeatDirection="Horizontal"
                                            ClientInstanceName="rblEstado">
                                            <Items>
                                                <dx:ListEditItem Text="Activo" Value="1" />
                                                <dx:ListEditItem Text="Inactivo" Value="0" />
                                            </Items>
                                            <Border BorderStyle="None" />
                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxRadioButtonList>
                                    </td>
                                    <td colspan="2" align="center">
                                        <dx:ASPxImage ID="imgActualiza" runat="server" ImageUrl="../images/DxAdd32.png" ToolTip="Actualizar"
                                            Cursor="pointer">
                                            <ClientSideEvents Click="function (s, e){
                                                if(ASPxClientEdit.ValidateGroup('vgEdita')){
                                                    btnActualiza.DoClick();}
                                            }" />
                                        </dx:ASPxImage>
                                        <dx:ASPxImage ID="imgCancelaEdit" runat="server" ImageUrl="../images/DxCancel32.png"
                                            ToolTip="Cancelar" Cursor="pointer">
                                            <ClientSideEvents Click="function(s, e){
                                        dialogoEdita.SetVisible(false);
                                    }" />
                                        </dx:ASPxImage>
                                        <dx:ASPxButton ID="btnActualiza" runat="server" ClientInstanceName="btnActualiza"
                                            AutoPostBack="false" ClientVisible="false">
                                            <ClientSideEvents Click="function (s, e){
                                            if(ASPxClientEdit.ValidateGroup('vgEdita')){
                                                var selectValues = lbBodega.GetSelectedValues();
                                                dialogoEdita.SetVisible(false);
                                                gvDatos.PerformCallback(selectValues + ':editar');}
                                            }" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>
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
                <td valign="middle" align="right">
                    <dx:ASPxImage ID="imgNuevo" runat="server" ImageUrl="../images/List.png" ToolTip="Configurar Notificación"
                        Cursor="pointer">
                        <ClientSideEvents Click="function (s, e){
                            ConfigurarNotificacion(this, 'CrearNotificacionesCEM.aspx');
                        }" />
                    </dx:ASPxImage>
                </td>
                <td valign="middle" align="left">
                    <dx:ASPxLabel ID="lblNuevo" runat="server" Text="Crear Destinatario" CssClass="comentario"
                        ForeColor="#CCCCCC">
                    </dx:ASPxLabel>
                </td>
                <td valign="middle" align="center">
                    <dx:ASPxCheckBox ID="chkSingleExpanded" runat="server" Text="Contraer filas Extendidas"
                        AutoPostBack="false" ClientInstanceName="chkSingleExpanded" Font-Italic="True"
                        ForeColor="#CCCCCC">
                        <ClientSideEvents CheckedChanged="function (s, e) {
                        gvDatos.PerformCallback('expandir');
                        chkSingleExpanded.SetChecked(false);
                    }" />
                    </dx:ASPxCheckBox>
                </td>
            </tr>
        </table>
    </div>
    <div id="div1" style="float: right; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 2%; position: fixed; overflow: hidden; display: block; bottom: 0px">
        <table>
            <tr>
                <td align="right">
                    <a style="color: Black; font-size: 15px; cursor: hand; cursor: pointer;" id="a1"
                        onclick="toggle('bluebar');">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/structure.png" ToolTip="Ocultar/Mostrar, Menú "
                            Width="16px" /></a>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
