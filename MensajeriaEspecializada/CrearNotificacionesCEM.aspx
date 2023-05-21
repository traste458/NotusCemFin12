<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearNotificacionesCEM.aspx.vb" 
    Inherits="BPColSysOP.CrearNotificacionesCEM" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Creación Usuarios Notificaciones CEM</title>
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
            dialogoEdita.PerformCallback(key)
            dialogoEdita.SetSize(myWidth * 0.6, myHeight * 0.3);
            dialogoEdita.ShowWindow();
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
    <div id="diDatos" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 65%;">
        <dx:ASPxCallbackPanel ID="cpFiltros" runat="server" ClientInstanceName="cpFiltros">
            <ClientSideEvents EndCallback="function(s, e) { 
                    $('#divEncabezado').html(s.cpMensaje);
                    txtNombre.SetValue(null);
                    txtApellido.SetValue(null);
                    txtCorreo.SetValue(null);
                    cmbBodegaCEM.SetValue(null);
                    cmbTipo.Focus(true);
                }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpDatos" runat="server" HeaderText="Ingrese Datos del Usuario"
                        Width="100%" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td class ="field" align ="left">
                                            Tipo Notificación:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbTipo" runat="server" Width="200px" IncrementalFilteringMode="Contains"
                                                ClientInstanceName="cmbTipo" DropDownStyle="DropDownList" TabIndex="1">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="idAsuntoNotificacion" Width="50px" Caption="Id." />
                                                    <dx:ListBoxColumn FieldName="nombre" Width="300px" Caption="Estado" />
                                                </Columns>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                    <RequiredField ErrorText="Tipo notificación requerida" IsRequired="true" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td class ="field" align ="left">
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
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                    <RequiredField ErrorText="" />
                                                </ValidationSettings>
                                            </dx:ASPxDropDownEdit>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" align ="left">
                                            Nombre(s):
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombre" runat="server" NullText="Ingrese Nombre..." Width="200px" 
                                                ClientInstanceName ="txtNombre" MaxLength ="150" TabIndex ="4">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                    <RegularExpression ErrorText="Formato no válido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                    <RequiredField ErrorText ="El nombre es requerido" IsRequired ="true" />
                                                </ValidationSettings>
                                                <ClientSideEvents KeyDown="function (s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgRegistro')){
                                                        if(e.htmlEvent.keyCode == 13) {
                                                            btnRegistro.DoClick();
                                                        }
                                                    } 
                                                }" />
                                            </dx:ASPxTextBox>    
                                        </td>
                                        <td class ="field" align ="left">
                                            Apellido(s):
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtApellido" runat="server" NullText="Ingrese Apellido..." Width="200px" 
                                                ClientInstanceName ="txtApellido" MaxLength ="150" TabIndex ="5">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                    <RegularExpression ErrorText="Formato no válido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                    <RequiredField ErrorText ="El apellido es requerido" IsRequired ="true" />
                                                </ValidationSettings>
                                                <ClientSideEvents KeyDown="function (s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgRegistro')){
                                                        if(e.htmlEvent.keyCode == 13) {
                                                            btnRegistro.DoClick();
                                                        }
                                                    } 
                                                }" />
                                            </dx:ASPxTextBox>    
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" align ="left">
                                            E-mail:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtCorreo" runat="server" NullText="Ingrese E-mail..." Width="200px" 
                                                ClientInstanceName ="txtCorreo" MaxLength ="150" TabIndex ="6">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                    <RegularExpression ErrorText="Formato no válido" ValidationExpression="\S+@\S+\.\S+" />
                                                    <RequiredField ErrorText ="El mail es requerido" IsRequired ="true" />
                                                </ValidationSettings>
                                                <ClientSideEvents KeyDown="function (s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgRegistro')){
                                                        if(e.htmlEvent.keyCode == 13) {
                                                            btnRegistro.DoClick();
                                                        }
                                                    } 
                                                }" />
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" align ="left">
                                            Destino:
                                        </td>
                                        <td>
                                            <dx:ASPxRadioButtonList ID="rblDestino" runat="server" RepeatDirection="Horizontal"
                                                ClientInstanceName="rblDestino" TabIndex ="7">
                                                <Items>
                                                    <dx:ListEditItem Text="Principal" Value="1" Selected="true" />
                                                    <dx:ListEditItem Text="Copia" Value="2" />
                                                </Items>
                                                <Border BorderStyle="None"></Border>
                                            </dx:ASPxRadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan ="4" align ="center">
                                            <dx:ASPxImage ID="imgAgregar" runat="server" ImageUrl="../images/DxAdd32.png" 
                                                ToolTip="Agregar Usuario" Cursor ="pointer" TabIndex ="8">
                                                <ClientSideEvents Click="function (s, e){
                                                        if(ASPxClientEdit.ValidateGroup('vgRegistro')){
                                                            btnRegistro.DoClick();
                                                        }
                                                    }" />
                                            </dx:ASPxImage>
                                            <dx:ASPxButton ID="btnRegistro" runat ="server" ClientVisible ="false" ClientInstanceName ="btnRegistro" AutoPostBack ="false">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgRegistro')){
                                                        var selectValues = lbBodega.GetSelectedValues();
                                                        cpFiltros.PerformCallback(selectValues + ':agregar');
                                                    }
                                                }" />
                                            </dx:ASPxButton>
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
    </form>
</body>
</html>
