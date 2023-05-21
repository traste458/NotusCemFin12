<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionCallCenters.aspx.vb"
    Inherits="BPColSysOP.AdministracionCallCenters" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración Call Centers</title>
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
            dialogoEditar.SetContentUrl("EditarCallCenter.aspx?idCallCenter=" + key);
            dialogoEditar.SetSize(myWidth * 0.7, myHeight * 0.8);
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
                    <dx:ASPxRoundPanel ID="rpAdicionCallCenter" runat="server" HeaderText="Información del Call Center"
                        Width="100%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td>
                                            Nombre Call Center:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombreCallCenter" runat="server" Width="200px">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCall">
                                                    <RequiredField ErrorText="El nombre del Call Center es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Nombre Contacto:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombreContacto" runat="server" Width="200px">
                                                <ValidationSettings ValidationGroup="vgCall" 
                                                    ErrorDisplayMode="ImageWithTooltip">
                                                    <RequiredField ErrorText="El nombre del contacto es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Telefóno Contacto:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtTelefonoContacto" runat="server" Width="120px">
                                                <ValidationSettings ValidationGroup="vgCall" 
                                                    ErrorDisplayMode="ImageWithTooltip">
                                                    <RequiredField ErrorText="El teléfono es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Activo:
                                        </td>
                                        <td>
                                            <dx:ASPxCheckBox ID="chbActivo" runat="server" CheckState="Checked">
                                            </dx:ASPxCheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <dx:ASPxPageControl ID="pcAsociadosCampania" runat="server" ActiveTabIndex="2" Width="100%">
                                                <TabPages>
                                                    <dx:TabPage Text="Tipo de Servicio">
                                                        <TabImage Url="../images/element.png">
                                                        </TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl ID="ContentControl4" runat="server">
                                                                <dx:ASPxPanel ID="pnlTiposServicios" runat="server" ScrollBars="Auto" Height="250px">
                                                                    <PanelCollection>
                                                                        <dx:PanelContent>
                                                                            <dx:ASPxListBox ID="lbTiposServicios" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                                ValueField="IdTipoServicio" Height="100%" ClientInstanceName="tipoServicio">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="Nombre" Caption="TipoServicio" Width="100%" />
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
                                            <div style="text-align: center; width: 100%">
                                                <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Adicionar Call Center" Style="display: inline" AutoPostBack="false">
                                                    <Image Url="../images/add.png">
                                                    </Image>
                                                    <ClientSideEvents Click="function(s, e) {
                                                        if(ASPxClientEdit.ValidateGroup('vgCall')){
                                                            cpRegistro.PerformCallback();
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
    <div style="float: right; margin-top: 5px; width: 58%;">
        <dx:ASPxCallbackPanel runat="server" ID="cpBusquedaCalls" ClientInstanceName="cpBusquedaCalls"
           >
            <PanelCollection>
                <dx:PanelContent>
                    <div style="margin-bottom: 15px">
                        <dx:ASPxRoundPanel ID="rpFiltroCallCenters" runat="server" HeaderText="Filtro de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>
                                            <td>
                                                Nombre Call Center:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNombreCallFiltro" runat="server" Width="170px">
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
                                                        gvCallCenters.PerformCallback();
                                                    }" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                    <div style="margin-bottom: 5px;">
                        <dx:ASPxRoundPanel ID="rpResultadoCallCenters" runat="server" HeaderText="Listado de Call Centers"
                            Width="100%">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gvCallCenters" runat="server" Width="100%" AutoGenerateColumns="False"
                                        ClientInstanceName="gvCallCenters" KeyFieldName="IdCallCenter">
                                        <ClientSideEvents EndCallback="function(s, e) {
                                            $('#divEncabezado').html(s.cpMensaje);
                                        }" />
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="ID" ShowInCustomizationForm="True" VisibleIndex="0"
                                                FieldName="IdCallCenter">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Nombre Call Center" ShowInCustomizationForm="True"
                                                VisibleIndex="1" FieldName="NombreCallCenter">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Nombre Contacto" ShowInCustomizationForm="True"
                                                VisibleIndex="2" FieldName="NombreContacto">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Teléfono Contacto" ShowInCustomizationForm="True"
                                                VisibleIndex="3" FieldName="TelefonoContacto">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataCheckColumn Caption="Activo" ShowInCustomizationForm="true" VisibleIndex="4"
                                                FieldName="Activo">
                                            </dx:GridViewDataCheckColumn>
                                            <dx:GridViewDataColumn Caption="" VisibleIndex="5">
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
        HeaderText="Modificación del Call Center" AllowDragging="true" Width="400px" Height="180px"
        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
        <ClientSideEvents Init="OnInitVer" 
            CloseButtonClick="function(s, e) {
                gvCallCenters.PerformCallback();
            }">
        </ClientSideEvents>
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
