<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarPlanVenta.aspx.vb" Inherits="BPColSysOP.EditarPlanVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress" TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar Plan Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
    <script type="text/javascript">
        function FiltrarDevExpMaterial(s, e) {
            try {
                if (s.GetText().length >= 4 || cmbEquipo.GetItemCount() != 0) {
                    cpFiltroMaterial.PerformCallback(s.GetText());
                }
            }
            catch (e) { }
        }

        function LimpiarCamposProducto() {
            txtEquipoFiltro.SetValue('');
            cmbEquipo.SetValue(null);
            txtValorEquipo.SetValue(0);
            txtValorIva.SetValue(0);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>

    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { 
            LoadingPanel.Hide(); 
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }
        }" />
    </dx:ASPxCallback>

    <div style="width: 45%; float: left; margin-right: 5px;">
        <dx:ASPxRoundPanel ID="rpEncabezado" runat="server" HeaderText="Información del Plan" Width="100%">
            <PanelCollection>
                <dx:PanelContent>
                    <table width="100%">
                        <tr>
                            <td>Nombre del Plan:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtNombrePlan" runat="server">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgPlan">
                                        <RequiredField ErrorText="El nombre del plan es requerido" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                         <tr>
                            <td>
                                Cargo Fijo Mensual (Sin Impuesto):
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtCFM" runat="server" Width="120px" NullText="Valor CFM...">
                                    <MaskSettings Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol">
                                    </MaskSettings>
                                    <ValidationSettings ValidationGroup="vgPlan" ErrorDisplayMode="ImageWithTooltip">
                                        <RequiredField IsRequired="True" ErrorText="El cargo fijo mensual es requerido">
                                        </RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                             </tr>
                        <tr>
                            <td>Impuestos:</td>
                            <td>
                                <dx:ASPxTextBox ID="textImpuestos" runat="server" Width="120px" Enabled="false" NullText="Valor Impuesto">
                                    <MaskSettings Mask="<-999999999..999999999g>%" IncludeLiterals="None"></MaskSettings>                                                                       
                                </dx:ASPxTextBox> 
                            </td>
                        </tr>
                        <tr>
                            <td>Cargo Fijo Mensual Con Impuestos:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtCargoFijoMensual" runat="server" Width="120px" Enabled="false" NullText="Valor CFM...">
                                    <MaskSettings Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Descipción del Plan:</td>
                            <td>
                                <dx:ASPxMemo ID="memoDescripcionPlan" runat="server">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgPlan">
                                        <RequiredField ErrorText="La descripción del plan es requerida" 
                                            IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td>Tipo de Plan:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbTipoPlan" runat="server"></dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Activo:</td>
                            <td>
                                <dx:ASPxCheckBox ID="chbActivo" runat="server">
                                </dx:ASPxCheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <dx:ASPxButton ID="btnGuardar" runat="server" Text="Guardar Cambios" AutoPostBack="false">
                                    <Image Url="../images/save_all.png"></Image>
                                    <ClientSideEvents Click="function(s, e) {
                                        Callback.PerformCallback();
                                    }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>

    <div style="width: 40%; float: left;">
        <dx:ASPxRoundPanel ID="rpAdicionEquipo" runat="server" HeaderText="Adicionar Equipo al Plan">
            <PanelCollection>
                <dx:PanelContent>
                    <table width="100%">
                        <tr>
                            <td>Equipo:</td>
                            <td>
                                <div style="display:inline; float:left;">
                                    <dx:ASPxTextBox ID="txtEquipoFiltro" runat="server" Width="80px" MaxLength="15" ClientInstanceName="txtEquipoFiltro">
                                        <ClientSideEvents KeyUp="function(s, e) { FiltrarDevExpMaterial(s, e) }"></ClientSideEvents>
                                    </dx:ASPxTextBox>
                                </div>
                                <dx:ASPxCallbackPanel ID="cpFiltroMaterial" runat="server" RenderMode="Div" ClientInstanceName="cpFiltroMaterial">
                                    <ClientSideEvents EndCallback="function(s, e) {}"></ClientSideEvents>
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <div style="display:inline; float:left">
                                                <dx:ASPxComboBox ID="cmbEquipo" runat="server" Width="250px" IncrementalFilteringMode="Contains" 
                                                    ClientInstanceName="cmbEquipo" DropDownStyle="DropDownList">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgAdicionarEquipo">
                                                        <RequiredField IsRequired="True" ErrorText="Debe seleccionar un equipo para adicionar"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                            <div id="divResultadoMaterial">
                                                <dx:ASPxLabel ID="lblResultadoMaterial" runat="server" CssClass="comentario" Width="200px">
                                                </dx:ASPxLabel>
                                            </div>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
                            </td>
                        </tr>
                        <tr>
                            <td>Valor Equipo:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtValorEquipo" runat="server" Width="100px" ClientInstanceName="txtValorEquipo" NullText="Valor sin Iva...">
                                    <MaskSettings IncludeLiterals="DecimalSymbol" 
                                        Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" />
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgAdicionarEquipo">
                                        <RequiredField ErrorText=" El valor del equipo es requerido" 
                                            IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Valor Iva:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtValorIva" runat="server" Width="100px" ClientInstanceName="txtValorIva" NullText="Valor Iva...">
                                    <MaskSettings IncludeLiterals="DecimalSymbol" 
                                        Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" />
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgAdicionarEquipo">
                                        <RequiredField ErrorText="El valor del iva es requerido" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <dx:ASPxButton ID="btnAdicionarEquipo" runat="server" Text="Adcionar Equipo" 
                                    ValidationGroup="vgAdicionarEquipo" AutoPostBack="false">
                                    <ClientSideEvents Click="function(s, e) {
                                        if(ASPxClientEdit.ValidateGroup(&#39;vgAdicionarEquipo&#39;)) {
                                            LoadingPanel.Show();
                                            if(!grid.InCallback()) {
                                                grid.PerformCallback('0:adicionar');
                                                grid.Refresh();
                                            }
                                        }
                                    }"></ClientSideEvents>
                                    <Image Url="../images/add.png"></Image>
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>

    <dx:ASPxRoundPanel ID="rpEquipos" runat="server" HeaderText="Equipos asociados al plan" style="margin-top: 5px;"  Width="100%">
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxGridView ID="gvDatos" runat="server" KeyFieldName="IdRegistro"
                    Width="100%" ClientInstanceName="grid">
                    <ClientSideEvents EndCallback="function(s, e) {
                        LoadingPanel.Hide();
                        if (s.cpMensaje) {
                            $('#divEncabezado').html(s.cpMensaje);
                            LimpiarCamposProducto();
                        }
                    }" />
                    <Columns>
                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" VisibleIndex="0">
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Material" 
                            ShowInCustomizationForm="True" VisibleIndex="1" Caption="Material">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="DescripcionMaterial" 
                            ShowInCustomizationForm="True" VisibleIndex="2" Caption="Referencia">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="PrecioVentaEquipo" ShowInCustomizationForm="True" 
                            VisibleIndex="3" Caption="Precio Equipo">
                            <PropertiesTextEdit DisplayFormatString="{0:c}"></PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="IvaEquipo" 
                            ShowInCustomizationForm="True" VisibleIndex="4" Caption="Iva Equipo">
                            <PropertiesTextEdit DisplayFormatString="{0:c}"></PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataColumn Caption="" VisibleIndex="10">
                            <DataItemTemplate>
                                <dx:ASPxHyperLink runat="server" ID="lnkAutorizarPreventa" ImageUrl="../images/cross.png" Cursor="pointer"
                                    ToolTip="Eliminar material" OnInit="Link_Init">
                                    <ClientSideEvents Click="function(s, e) {
                                        if(confirm('¿Realmente desea eliminar la el material del Plan?')) {
                                            grid.PerformCallback('{0}'+':eliminar'); 
                                        }
                                    }" />
                                </dx:ASPxHyperLink>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <SettingsPager PageSize="5">
                    </SettingsPager>
                    <Settings ShowFilterRow="True" ShowFilterRowMenu="True" 
                        ShowFilterRowMenuLikeItem="True" ShowHeaderFilterBlankItems="False" />
                </dx:ASPxGridView>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>

    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" 
        ClientInstanceName="LoadingPanel" Modal="True">
    </dx:ASPxLoadingPanel>

    </form>
</body>
</html>
