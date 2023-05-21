<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionSites.aspx.vb" Inherits="BPColSysOP.AdministracionSites" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración de Sites</title>
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

        function Editar(element, key) {
            TamanioVentana();
            dialogoEditar.SetContentUrl("EditarSite.aspx?idSite=" + key);
            dialogoEditar.SetSize(myWidth * 0.7, myHeight * 0.9);
            dialogoEditar.ShowWindow();
        }

        function OnInitVer(s, e) {
            ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
                if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
                    dialogoEditar.Hide();
            });
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('cpRegistro');
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide(); 
            }" />
    </dx:ASPxCallback>
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 38%;">
        <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName="cpRegistro">
            <ClientSideEvents EndCallback="function(s, e) { 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();  }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpAdicionSite" runat="server" HeaderText="Adición de Site"
                        Width="100%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td>Nombre del Site:</td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombreSite" runat="server" Width="200px">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                    ValidationGroup="vgSite">
                                                    <RequiredField ErrorText="El nombre del Site es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Call Center:</td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbCallCenter" runat="server" ValueType="System.String" 
                                                Width="200px" IncrementalFilteringMode="Contains">
                                                <ValidationSettings ValidationGroup="vgSite" 
                                                    ErrorDisplayMode="ImageWithTooltip">
                                                    <RequiredField ErrorText="El call center es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Activo:</td>
                                        <td>
                                            <dx:ASPxCheckBox ID="chbEstado" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <dx:ASPxPageControl ID="pcAsociados" runat="server" ActiveTabIndex="0" 
                                                Height="250px" Width="100%">
                                                <TabPages>
                                                    <dx:TabPage Text="Bodegas">
                                                        <TabImage Url="~/images/geography.png">
                                                        </TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <dx:ASPxPanel id="pnlBodegas" runat="server" ScrollBars="Auto" Height="250px">
                                                                    <PanelCollection>
                                                                        <dx:PanelContent>
                                                                            <dx:ASPxListBox ID="lbBodegas" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                                ValueField="IdBodega" Height="100%" ClientInstanceName="bodegas">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="Codigo" Caption="Código" Width="30%" />
                                                                                    <dx:ListBoxColumn FieldName="Nombre" Caption="Nombre Bodega" Width="70%" />
                                                                                </Columns>
                                                                            </dx:ASPxListBox>
                                                                        </dx:PanelContent>
                                                                    </PanelCollection>
                                                                </dx:ASPxPanel>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Usuarios">
                                                        <TabImage Url="~/images/usuario.png">
                                                        </TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <dx:ASPxPanel ID="pnlUsuarios" runat="server" ScrollBars="Auto" Height="250px">
                                                                    <PanelCollection>
                                                                        <dx:PanelContent>
                                                                            <dx:ASPxListBox ID="lbUsuarios" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                                ValueField="IdUsuario" Height="100%" ClientInstanceName="usuarios">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="IdUsuario" Caption="Id" Width="30%" />
                                                                                    <dx:ListBoxColumn FieldName="Nombre" Caption="Nombre Usuario" Width="70%" />
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
                                        <td colspan="2" align="center">
                                            <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Adicionar" Width="110px" Style="display: inline"
                                                ValidationGroup="vgCampania" AutoPostBack="false">
                                                <Image Url="../images/add.png">
                                                </Image>
                                                <ClientSideEvents Click="function(s, e) {
                                                        if(ASPxClientEdit.ValidateGroup('vgSite')) {
                                                            if(bodegas.GetSelectedValues().length==0 || usuarios.GetSelectedValues().length==0){
                                                                alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Bodegas y Usuarios.');
                                                                e.processOnServer = false;
                                                            } else {
                                                                LoadingPanel.Show();
                                                                cpRegistro.PerformCallback();
                                                            }
                                                        }
                                                    }" />
                                            </dx:ASPxButton>
                                            &nbsp;&nbsp;
                                            <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos" Style="display: inline" AutoPostBack="false">
                                                <Image Url="../images/eraserminus.gif">
                                                </Image>
                                                <ClientSideEvents Click="function(s, e) {
                                                    LimpiaFormulario();
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
    <div style="float: right; margin-top: 5px; width: 58%;">
        <dx:ASPxCallbackPanel runat="server" ID="cpBusquedaSites" ClientInstanceName="cpBusquedaSites"
           >
            <PanelCollection>
                <dx:PanelContent>
                    <div style="margin-bottom: 15px">
                        <dx:ASPxRoundPanel ID="rpFiltroSites" runat="server" HeaderText="Filtro de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>
                                            <td>
                                                Nombre Site:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNombreSiteFiltro" runat="server" Width="200px">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Activo:
                                            </td>
                                            <td>
                                                <dx:ASPxCheckBox ID="chbEstadoFiltro" runat="server" CheckState="Checked">
                                                </dx:ASPxCheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" AutoPostBack="false">
                                                    <Image Url="../images/find.gif">
                                                    </Image>
                                                    <ClientSideEvents Click="function(s, e) {
                                                            gvSites.PerformCallback();
                                                        }"></ClientSideEvents>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                    <div style="margin-bottom: 5px;">
                        <dx:ASPxRoundPanel ID="rpResultadoSites" runat="server" HeaderText="Listado de Sites"
                            Width="100%">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gvSites" runat="server" Width="100%" ClientInstanceName="gvSites"
                                        AutoGenerateColumns="False" KeyFieldName="IdSite">
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="ID" ShowInCustomizationForm="True" VisibleIndex="0"
                                                FieldName="IdSite">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Nombre Site" ShowInCustomizationForm="True"
                                                VisibleIndex="1" FieldName="Nombre">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Call Center" ShowInCustomizationForm="True"
                                                VisibleIndex="1" FieldName="NombreCallCenter">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataCheckColumn Caption="Activo" ShowInCustomizationForm="true" VisibleIndex="3"
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
                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    <dx:ASPxPopupControl ID="pcEditar" runat="server" ClientInstanceName="dialogoEditar"
        HeaderText="Modificación del Site" AllowDragging="true" Width="400px" Height="180px"
        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
        <ClientSideEvents Init="OnInitVer"></ClientSideEvents>
        <ContentCollection>
            <dx:PopupControlContentControl ID="pccc" runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
