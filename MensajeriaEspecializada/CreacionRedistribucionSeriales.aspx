<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreacionRedistribucionSeriales.aspx.vb" Inherits="BPColSysOP.CreacionRedistribucionSeriales" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>::Creacion Redistribución Seriales::</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
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

        function GuardarProducto(s, e) {
            if (ASPxClientEdit.ValidateGroup('GuardarProducto')) {
                cpPrincipal.PerformCallback('0:200'); //Guardar Producto
            }
        }

        function GuardarOrden(s, e) {
            if (ASPxClientEdit.ValidateGroup('Guardar')) {
                cpPrincipal.PerformCallback('0:100'); //Guardar Orden
            }
        }

        function ValidarSerial(e) {
            cpPrincipal.PerformCallback('0:400'); //Validar Serial
        }

        function FuncionesBotones(s, e) {
            if (e.buttonID == "btnEliminar") {
                var idProducto = gridProductos.GetRowKey(gridProductos.GetFocusedRowIndex());
                gridProductos.PerformCallback(idProducto); //Eliminar Producto
            } else if (e.buttonID) {
                var idProducto = gridProductos.GetRowKey(gridProductos.GetFocusedRowIndex());
                gridProductos.PerformCallback(idProducto); //Editar Cantidad
            }
        }

        function FinCallbackGrid(mensajeGrid) {
            $('#divEncabezadoPrincipal').html(mensajeGrid);
            cpPrincipal.PerformCallback('0:500'); //Validar cantidad registros
        }

        function CargarArchivo() {
            var mensaje = document.getElementById('divEncabezadoPrincipal').innerHTML;
            if (mensaje != undefined) {
                if (mensaje.indexOf("tablaErrores") >= 0) {
                    gridErrores.PerformCallback();
                    VerErrores();
                }
            }
        }

        function VerErrores() {
            TamanioVentana();
            pcGridErrores.SetSize(myWidth * 0.5, myHeight * 0.3);
            pcGridErrores.ShowWindow();
        }

        function VerFallas() {
            TamanioVentana();
            pcFalla.SetSize(myWidth * 0.6, myHeight * 0.6);
            pcFalla.ShowWindow();
        }

        function VerAccesorios() {
            TamanioVentana();
            pcAccesorios.SetSize(myWidth * 0.3, myHeight * 0.6);
            pcAccesorios.ShowWindow();
        }

        function FiltroModelo(idMarca) {
            cpPrincipal.PerformCallback('0:300');
        }

        /*
        Funciones para el manejo de los combos de múltiple selección.
        */
        var textSeparator = ";";
        function OnListBoxSelectionChanged(listBox, args) {
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            UpdateSelectAllItemState();
            UpdateText();
        }

        function UpdateSelectAllItemState() {
            IsAllSelected() ? lbFalla.SelectIndices([0]) : lbFalla.UnselectIndices([0]);
        }

        function IsAllSelected() {
            var selectedDataItemCount = lbFalla.GetItemCount() - (lbFalla.GetItem(0).selected ? 0 : 1);
            return lbFalla.GetSelectedItems().length == selectedDataItemCount;
        }

        function UpdateText() {
            var selectedItems = lbFalla.GetSelectedItems();
            cmbFallas.SetText(GetSelectedItemsText(selectedItems));
        }

        function SynchronizeListBoxValues(dropDown, args) {
            lbFalla.UnselectAll();
            var texts = dropDown.GetText().split(textSeparator);
            var values = GetValuesByTexts(texts);
            lbFalla.SelectValues(values);
            UpdateSelectAllItemState();
            UpdateText(); // for remove non-existing texts
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
                item = lbFalla.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }

        /*
        Funciones para el manejo de los combos de múltiple selección Accesorios.
        */
        var textSeparator = ";";
        function OnListBoxSelectionChangedlbAccesoriosdd(listBox, args) {
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            UpdateSelectAllItemStateAccesorios();
            UpdateTextAccesorios();
        }

        function UpdateSelectAllItemStateAccesorios() {
            IsAllSelectedAccesorios() ? lbAccesoriosdd.SelectIndices([0]) : lbAccesoriosdd.UnselectIndices([0]);
        }

        function IsAllSelectedAccesorios() {
            var selectedDataItemCount = lbAccesoriosdd.GetItemCount() - (lbAccesoriosdd.GetItem(0).selected ? 0 : 1);
            return lbAccesoriosdd.GetSelectedItems().length == selectedDataItemCount;
        }

        function UpdateTextAccesorios() {
            var selectedItems = lbAccesoriosdd.GetSelectedItems();
            cmbAccesoriosdd.SetText(GetSelectedItemsTextAccesorios(selectedItems));
        }

        function SynchronizeListBoxValuescmbAccesoriosdd(dropDown, args) {
            lbAccesoriosdd.UnselectAll();
            var texts = dropDown.GetText().split(textSeparator);
            var values = GetValuesByTexts(texts);
            lbAccesoriosdd.SelectValues(values);
            UpdateSelectAllItemStateAccesorios();
            UpdateTextAccesorios(); // for remove non-existing texts
        }

        function GetSelectedItemsTextAccesorios(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                if (items[i].index != 0)
                    texts.push(items[i].text);
            return texts.join(textSeparator);
        }

        function GetValuesByTextsAccesorios(texts) {
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = lbAccesoriosdd.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }

        function DescargarDocumento(idRuta, ruta, nombre) {
            var _origen = 'RemisionSinHub';
            window.location.href = 'DescargaRemision.aspx?id=' + idRuta + '&origen=' + _origen + '&ruta=' + ruta + '&nombre=' + nombre;
        }

        function soloNumeros(e) {
            var key = window.Event ? e.which : e.keyCode;
            if (key == 13) {
                ValidarSerial(e);
                return false; //(key >= 48 && key <= 57);
            }
        }
        
    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
        <div style="padding: 1em 3em; margin: 1em 25%;">
            <dx:ASPxCallbackPanel ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="rpCrearOrden" runat="server" ClientInstanceName="rpCrearOrden" HeaderText=" " Width="650" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxFormLayout ID="flCrearOrden" runat="server" Theme="SoftOrange">
                                        <Items>
                                            <dx:LayoutGroup Caption="Información Servicio" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Origen">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="linccOrigen" runat="server">
                                                                <dx:ASPxComboBox ID="cmbOrigen" runat="server" ClientInstanceName="cmbOrigen" FilterMinLength="0" AutoPostBack="false" Width="200px" Theme="SoftOrange"
                                                                    ValueType="System.Int32" IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="1" Enabled="true">
                                                                    <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="Guardar"
                                                                        ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" RequiredField-IsRequired="True">
                                                                        <RequiredField IsRequired="True" ErrorText="Por favor seleccione el Origen"></RequiredField>
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Destino">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="linccDestino" runat="server">
                                                                <dx:ASPxComboBox ID="cmbDestino" runat="server" ClientInstanceName="cmbDestino" FilterMinLength="0" AutoPostBack="false" Width="200px" Theme="SoftOrange"
                                                                    ValueType="System.Int32" IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="2">
                                                                    <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="Guardar"
                                                                        ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" RequiredField-IsRequired="True">
                                                                        <RequiredField IsRequired="True" ErrorText="Por favor seleccione el Destino"></RequiredField>
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Tipo de Cargue" ColCount="2" Width="650">
                                                <Items>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxPageControl ID="pcProductos" runat="server" ClientInstanceName="pcProductos" ActiveTabIndex="0" Width="100%" Theme="SoftOrange" AutoPostBack="false">
                                                                    <TabPages>
                                                                        <dx:TabPage Text="Manual">
                                                                            <ContentCollection>
                                                                                <dx:ContentControl>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td>Serial:
                                                                                            </td>
                                                                                            <td>
                                                                                                <dx:ASPxTextBox ID="txtSerialNew" ClientInstanceName="txtSerialNew" runat="server" Width="250px" MaxLength="22" onkeypress="return soloNumeros(event);">
                                                                                                      <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="GuardarProducto"
                                                                                                                        ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" RequiredField-IsRequired="True">
                                                                                                                        <RequiredField IsRequired="True" ErrorText="Ingrese Serial"></RequiredField>
                                                                                                                        <RegularExpression ErrorText="Serial digitado no es válido" ValidationExpression="[a-zA-Z0-9]{14,22}" />
                                                                                                                    </ValidationSettings>
                                                                                                </dx:ASPxTextBox>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="2" style="align-items: center">
                                                                                                <dx:ASPxButton ID="btnGuardarProducto" runat="server" AutoPostBack="False" ClientInstanceName="btnGuardarProducto"  Text="Agregar serial"
                                                                                                    ValidationGroup="GuardarProducto" Width="180px" Font-Bold="true" Theme="SoftOrange" TabIndex="11">
                                                                                                    <ClientSideEvents Click="function(s,e){
                                                                                                                        GuardarProducto(s,e);
                                                                                                                        if (cmbFallas.GetValue() == null){
                                                                                                                            lblRequerido.SetVisible(true);
                                                                                                                        } else {
                                                                                                                            lblRequerido.SetVisible(false);
                                                                                                                            
                                                                                                                        }
                                                                                                                    }" />
                                                                                                    <Image Url="~/images/add.png">
                                                                                                    </Image>
                                                                                                </dx:ASPxButton>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>




                                                                                </dx:ContentControl>
                                                                            </ContentCollection>
                                                                        </dx:TabPage>
                                                                        <dx:TabPage Text="Archivo" Visible="true">
                                                                            <ContentCollection>
                                                                                <dx:ContentControl>
                                                                                    <dx:ASPxRoundPanel ID="rpArchivo" ClientInstanceName="rpArchivo" HeaderText="Archivo" runat="server" Width="100%" HeaderStyle-HorizontalAlign="Left">
                                                                                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                                                                        <PanelCollection>
                                                                                            <dx:PanelContent>
                                                                                                <table>
                                                                                                    <tr>
                                                                                                        <td class="field">Archivo:</td>
                                                                                                        <td>
                                                                                                            <asp:FileUpload ID="fUploadArchivo" runat="server" Theme="SoftOrange" Width="500px" />
                                                                                                            <div>
                                                                                                                <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="No ha seleccionado ningún archivo"
                                                                                                                    Display="Dynamic" ControlToValidate="fUploadArchivo" ValidationGroup="vgCargue"></asp:RequiredFieldValidator>
                                                                                                                <asp:RegularExpressionValidator ID="revArchivo" runat="server" ErrorMessage="Tipo de archivo incorrecto. Se espera un archivo de excel."
                                                                                                                    Display="Dynamic" ControlToValidate="fUploadArchivo" ValidationGroup="vgCargue" ValidationExpression=".+(\.[X|x][L|l][S|s][X|x])"></asp:RegularExpressionValidator>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td></td>
                                                                                                        <td valign="middle" align="Left">
                                                                                                            <asp:LinkButton ID="lbEjemplo" runat="server" Text="Ver Ejemplo"></asp:LinkButton></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" valign="middle" align="center">
                                                                                                            <dx:ASPxButton ID="btnUpload" runat="server" Text="Cargar archivo" ClientInstanceName="btnUpload" ValidationGroup="vgCargue" Theme="SoftOrange" Width="158px">
                                                                                                                <Image Url="../images/upload.png">
                                                                                                                </Image>
                                                                                                            </dx:ASPxButton>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </dx:PanelContent>
                                                                                        </PanelCollection>
                                                                                    </dx:ASPxRoundPanel>
                                                                                </dx:ContentControl>
                                                                            </ContentCollection>
                                                                        </dx:TabPage>
                                                                    </TabPages>
                                                                </dx:ASPxPageControl>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:EmptyLayoutItem ColSpan="2">
                                                    </dx:EmptyLayoutItem>
                                                    <dx:LayoutItem Caption="Productos" ShowCaption="False" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="linccGridProductos" runat="server" Theme="SoftOrange">
                                                                <dx:ASPxGridView ID="gridProductos" runat="server" ClientInstanceName="gridProductos" AutoGenerateColumns="false" Width="100%" KeyFieldName="idProducto" OnRowUpdating="gridProductos_RowUpdating" Theme="SoftOrange">
                                                                    <SettingsBehavior ColumnResizeMode="Control" AllowFocusedRow="true" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="idProducto" Caption="idProducto" VisibleIndex="0" Width="1px" EditFormSettings-Visible="False" Visible="false">
                                                                            <EditFormSettings Visible="False"></EditFormSettings>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="serial" VisibleIndex="3" EditFormSettings-Visible="True" FieldName="serial" Width="20%">
                                                                            <EditFormSettings Visible="True"></EditFormSettings>
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Producto" FieldName="producto" ShowInCustomizationForm="True" VisibleIndex="9" Width="15%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Código" FieldName="codigo" ShowInCustomizationForm="True" VisibleIndex="10" Width="10%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Bodega Origen" FieldName="bodegaOrigen" ShowInCustomizationForm="True" VisibleIndex="11" Width="30%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="14" Width="15%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <DataItemTemplate>
                                                                                <dx:ASPxHyperLink runat="server" ID="lnkFallas" ImageUrl="../images/kit_tools.png"
                                                                                    Cursor="pointer" ToolTip="Ver Fallas" OnInit="Link_Init">
                                                                                    <ClientSideEvents Click="function(s, e) { 
                                                                                        cpPrincipal.PerformCallback('{0}'+':Fallas'); 
                                                                                    }" />
                                                                                </dx:ASPxHyperLink>
                                                                                <dx:ASPxHyperLink runat="server" ID="lnkAccesorios" ImageUrl="../images/engranaje.jpg"
                                                                                    Cursor="pointer" ToolTip="Ver Accesorios" OnInit="Link_Init">
                                                                                    <ClientSideEvents Click="function(s, e) { 
                                                                                       cpPrincipal.PerformCallback('{0}'+':Accesorios'); 
                                                                                    }" />
                                                                                </dx:ASPxHyperLink>
                                                                                <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eliminar.gif"
                                                                                    Cursor="pointer" ToolTip="Eliminar" OnInit="Link_Init">
                                                                                    <ClientSideEvents Click="function(s, e) { 
                                                                                        if(confirm('¿Realmente desea eliminar el producto?')) {
                                                                                            gridProductos.PerformCallback('{0}'+':eliminar'); 
                                                                                        }
                                                                                    }" />
                                                                                </dx:ASPxHyperLink>
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="function(s,e){FuncionesBotones(s,e);}"
                                                                        EndCallback="function(s,e){ 
                                                                            FinCallbackGrid(s.cpGrMensaje);
                                                                         }" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutGroup Caption="Observacion del Servicio" ColCount="2" HorizontalAlign="Left">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Observacion">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                        <dx:ASPxMemo ID="txtObservaciones" runat="server" ClientInstanceName="txtObservaciones" Width="100%" Height="50px"
                                                                            Theme="SoftOrange" Columns="80" TabIndex="15">
                                                                        </dx:ASPxMemo>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutItem ShowCaption="False" Width="90" HorizontalAlign="Center" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="linccGuardar" runat="server" Width="90">
                                                                <dx:ASPxButton ID="btnGuardar" runat="server" AutoPostBack="False" Font-Bold="True" HorizontalAlign="Center" Text="Guardar" ValidationGroup="Guardar" Width="80" Theme="SoftOrange">
                                                                    <ClientSideEvents Click="function(s,e){GuardarOrden(s,e)}" />
                                                                    <Image Url="~/images/save_all.png">
                                                                    </Image>
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                                <SettingsItems HorizontalAlign="Center"></SettingsItems>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:ASPxFormLayout>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                        <dx:ASPxPopupControl ID="pcGridErrores" runat="server" ClientInstanceName="pcGridErrores"
                            HeaderText="Errores" AllowDragging="True" Width="400px" Height="180px" Modal="True"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto" Theme="SoftOrange">
                            <ClientSideEvents CloseButtonClick="function(s,e){
                                pcGridErrores.Hide();
                                cpPrincipal.PerformCallback('0:800'); //Borrar titulo error
                            }" />
                            <ContentCollection>
                                <dx:PopupControlContentControl ID="pcccGridErrores" runat="server" Theme="SoftOrange">
                                    <dx:ASPxRoundPanel ID="rpErrores" runat="server" Width="100%" ClientInstanceName="rpErrores" ShowHeader="false" Theme="SoftOrange">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxGridView ID="gridErrores" runat="server" ClientInstanceName="gridErrores"
                                                    KeyFieldName="Columna" Width="100%" AutoGenerateColumns="false" Theme="SoftOrange">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="Columna" FieldName="columna" ShowInCustomizationForm="True" VisibleIndex="0" Visible="true" Width="20%">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="Descripción" FieldName="descripcion" ShowInCustomizationForm="True" VisibleIndex="2" Visible="true" Width="60%">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="Fila" FieldName="fila" ShowInCustomizationForm="True" VisibleIndex="3" Visible="true" Width="10%">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center"></CellStyle>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="Hoja" FieldName="hoja" ShowInCustomizationForm="True" VisibleIndex="4" Visible="true" Width="10%">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center"></CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager PageSize="10"></SettingsPager>
                                                    <ClientSideEvents EndCallback="function(s, e){$('#divEncabezado').html(s.cpMensaje);}" />
                                                </dx:ASPxGridView>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>

                        <dx:ASPxPopupControl ID="pcFalla" runat="server" ClientInstanceName="pcFalla"
                            HeaderText="Fallas" AllowDragging="True" Width="400px" Height="180px" Modal="True"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto" Theme="SoftOrange">
                            <ContentCollection>
                                <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server" Theme="SoftOrange">
                                    <dx:ASPxRoundPanel ID="rpFallas" runat="server" Width="100%" ClientInstanceName="rpFallas" ShowHeader="false" Theme="SoftOrange">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxGridView ID="gvFallas" runat="server" ClientInstanceName="gvFallas"
                                                    KeyFieldName="idFalla" Width="100%" AutoGenerateColumns="true" Theme="SoftOrange">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="nombre" Caption="Falla" VisibleIndex="0" Width="100%" EditFormSettings-Visible="False" Visible="true">
                                                            <EditFormSettings Visible="False"></EditFormSettings>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <Settings HorizontalScrollBarMode="Auto"></Settings>
                                                </dx:ASPxGridView>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>

                        <dx:ASPxPopupControl ID="pcAccesorios" runat="server" ClientInstanceName="pcAccesorios"
                            HeaderText="Accesorios" AllowDragging="True" Width="400px" Height="180px" Modal="True"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto" Theme="SoftOrange">
                            <ContentCollection>
                                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server" Theme="SoftOrange">
                                    <dx:ASPxRoundPanel ID="rpAccesorios" runat="server" Width="100%" ClientInstanceName="rpAccesorios" ShowHeader="false" Theme="SoftOrange">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxGridView ID="gvAccesorios" runat="server" ClientInstanceName="gvAccesorios"
                                                    KeyFieldName="idAccesorio" Width="100%" AutoGenerateColumns="true" Theme="SoftOrange">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="nombre" Caption="Accesorio" VisibleIndex="0" Width="100%" EditFormSettings-Visible="False" Visible="true">
                                                            <EditFormSettings Visible="False"></EditFormSettings>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <Settings HorizontalScrollBarMode="Auto"></Settings>
                                                </dx:ASPxGridView>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>

                        <%--<msgp:MensajePopUp ID="mensajero" runat="server" />--%>
                    </dx:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="function(s,e){

                        if (s.cpMostrarMensaje==1){
                            CargarArchivo(s.cpMensaje);
                        } else {
                            pcGridErrores.Hide();
                        }

                        if (s.cpSubir=='1'){
                            $('html, body').animate({ scrollTop: 0 }, 'slow');
                        }

                        if (s.cpFalla=='1'){
                            VerFallas();
                        }
                        if (s.cpAccesorios=='1'){
                            VerAccesorios();
                        }

                        if (s.cpCreacionServicio=='1'){
                            DescargarDocumento(s.cpIdRuta,s.cpRuta,s.cpNombre)
                        }

                    }" />
            </dx:ASPxCallbackPanel>
        </div>



    </form>
</body>
</html>
