<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionTipoSimMaterial.aspx.vb"
    Inherits="BPColSysOP.AdministracionTipoSimMaterial" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>:: Administración de Materiales Clase Sims  ::</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                cmbEquipo.SetSelectedIndex(0);
                gvMatrialClaseSim.PerformCallback(null);
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function Cargardatostiposim(s, e) {
            cpPrincipal.PerformCallback('ConsultarClaseSim' + ':' + cmbEquipo.GetValue());
        }
        function Editartiposim(s, e, parametro, valor) {
            cpPrincipal.PerformCallback(parametro + ':' + valor);
        }
        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
            }
        }
        function Actualizartiposim(s, e) {
            cpPrincipal.PerformCallback('ActualizaClaseSim' + ':' + cmbEquipo.GetValue());
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 50%;">
            <dx:ASPxRoundPanel ID="rpFiltroCampanias" runat="server" HeaderText="Filtro de Búsqueda" Theme="SoftOrange">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallbackPanel ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                            <ClientSideEvents EndCallback="MostrarInfoEncabezado" />
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>

                                            <td>Material</td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbEquipo" runat="server" ClientInstanceName="cmbEquipo" IncrementalFilteringMode="Contains"
                                                    TextFormatString="{0} ({1})" ValueField="Material" Width="400px" CallbackPageSize="20" EnableCallbackMode="True" FilterMinLength="4" IncrementalFilteringDelay="0" 
                                                    OnItemRequestedByValue="cmbEquipo_OnItemRequestedByValue_SQL" OnItemsRequestedByFilterCondition="cmbEquipo_OnItemsRequestedByFilterCondition_SQL">
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { Cargardatostiposim(s, e); }" />
                                                    <Columns>
                                                        <dx:ListBoxColumn Caption="Material" FieldName="Material" Width="60px" />
                                                        <dx:ListBoxColumn Caption="Referencia" FieldName="referencia" Width="400px" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                        ValidationGroup="vgAdicionarCombinacion">
                                                        <RequiredField ErrorText="Por favor seleccione un equipo" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="2" align="center">
                                                <dx:ASPxImage ID="imgFiltro" runat="server" ImageUrl="../images/DxAdd32.png"
                                                    ToolTip="Filtrar" Cursor="pointer">
                                                    <ClientSideEvents Click="function (s, e){
                                                        Cargardatostiposim();
                                                    }" />
                                                </dx:ASPxImage>
                                                <dx:ASPxImage ID="imgCancela" runat="server" ImageUrl="../images/DxCancel32.png"
                                                    ToolTip="Cancelar" Cursor="pointer">
                                                    <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                    }" />
                                                </dx:ASPxImage>
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <br />
                                    <div style="margin-bottom: 5px;">
                                        <dx:ASPxGridView ID="gvMatrialClaseSim" runat="server" Width="100%" ClientInstanceName="gvMatrialClaseSim"
                                            AutoGenerateColumns="False" KeyFieldName="Material" Theme="SoftOrange" SettingsLoadingPanel-Mode="Disabled">
                                            <ClientSideEvents EndCallback="function(s,e){ 
                                            $('#divEncabezado').html(s.cpMensaje);
                                            LoadingPanel.Hide();
                                        }"></ClientSideEvents>
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="Material" ShowInCustomizationForm="True"
                                                    VisibleIndex="1" FieldName="Material">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="idClase" ShowInCustomizationForm="True"
                                                    VisibleIndex="1" FieldName="idClase" Visible="false">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Referencia" FieldName="Referencia" ShowInCustomizationForm="True"
                                                    VisibleIndex="2">
                                                    <PropertiesTextEdit DisplayFormatString="{0:d}">
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataDateColumn Caption="ClaseSimCard" ShowInCustomizationForm="true" VisibleIndex="3"
                                                    FieldName="ClaseSimCard">
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataColumn Caption="" VisibleIndex="6">
                                                    <DataItemTemplate>
                                                        <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/Edit-User.png"
                                                            Cursor="pointer" ToolTip="Modificar Clase Sim Card" OnInit="Link_Init">
                                                            <ClientSideEvents Click="function(s, e) { Editartiposim(s,e,'verInfoClaseSimCard', {0}); }" />
                                                        </dx:ASPxHyperLink>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsText Title="B&#250;squeda General de Campañas" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                            <SettingsLoadingPanel Mode="Disabled"></SettingsLoadingPanel>
                                        </dx:ASPxGridView>
                                    </div>

                                    <br />
                                    <br />
                                    <dx:ASPxPopupControl ID="pcEditar" runat="server" ClientInstanceName="pcEditar" Modal="true" CloseAction="CloseButton" Theme="SoftOrange"
                                        HeaderText="Información Material Clase Sim " PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
                                        <ContentCollection>
                                            <dx:PopupControlContentControl>
                                                <fieldset>
                                                    <legend>Material </legend>
                                                    <table>
                                                        <tr>
                                                            <td>Material
                                                            </td>
                                                            <td>
                                                                <div style="width: 50px">
                                                                    <dx:ASPxTextBox ID="txCodMateri" runat="server" Visible="false" Enabled="false" Width="45px">
                                                                    </dx:ASPxTextBox>
                                                                </div>
                                                                <dx:ASPxTextBox ID="txMateri" runat="server" Enabled="false" Width="300px">
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Clase Sim Card
                                                            </td>
                                                            <td>
                                                                <dx:ASPxComboBox ID="cmClaseSimCard" runat="server" ClientInstanceName="cmClaseSimCard" Width="250px"
                                                                    IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idClase"
                                                                    CallbackPageSize="25" EnableCallbackMode="true" ValueType="System.Int32">
                                                                    <Columns>
                                                                        <dx:ListBoxColumn FieldName="idClase" Caption="idClase" Width="20px" Visible="false" />
                                                                        <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                                    </Columns>
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxImage ID="imgEdita" runat="server" ImageUrl="~/images/DxConfirm16.png" Cursor="pointer"
                                                                    ToolTip="Registrar">
                                                                    <ClientSideEvents Click="function(s, e){
                                                            if(ASPxClientEdit.ValidateGroup(&#39;vgEditar&#39;)){
                                                                pcEditar.Hide();
                                                                 Actualizartiposim(s, e); }                                                          
                                                            }" />
                                                                </dx:ASPxImage>
                                                            </td>
                                                        </tr>
                                                    </table>

                                                </fieldset>
                                            </dx:PopupControlContentControl>
                                        </ContentCollection>
                                    </dx:ASPxPopupControl>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>

        </div>

        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
