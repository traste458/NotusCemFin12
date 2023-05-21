<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarSite.aspx.vb" Inherits="BPColSysOP.EditarSite" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar Site</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { 
                LoadingPanel.Hide(); 
                document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
            }" />
    </dx:ASPxCallback>
    <dx:ASPxRoundPanel ID="rpEncabezado" runat="server" HeaderText="Información del Site"
        Width="100%">
        <PanelCollection>
            <dx:PanelContent>
                <table width="100%">
                    <tr>
                        <td>Nombre del Site:</td>
                        <td>
                            <dx:ASPxTextBox ID="txtNombreSite" runat="server" Width="250px">
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
                            <dx:ASPxComboBox ID="cmbCallCenter" runat="server" ValueType="System.Int32">
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                    ValidationGroup="vgSite">
                                    <RequiredField ErrorText="El call center es requerido" IsRequired="True" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Activo:</td>
                        <td>
                            <dx:ASPxCheckBox ID="chbEstado" runat="server" Checked="True" 
                                CheckState="Checked">
                            </dx:ASPxCheckBox>
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
                                            <dx:ContentControl ID="ContentControl1" runat="server">
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
                                            <dx:ContentControl ID="ContentControl2" runat="server">
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
                            <dx:ASPxButton ID="btnModificar" runat="server" Text="Modificar" Width="110px" Style="display: inline"
                                ValidationGroup="vgSite" AutoPostBack="false">
                                <Image Url="../images/save_all.png">
                                </Image>
                                <ClientSideEvents Click="function(s, e) {
                                            if(ASPxClientEdit.ValidateGroup('vgSite')) {
                                                if(bodegas.GetSelectedValues().length==0 || usuarios.GetSelectedValues().length==0){
                                                    alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Bodegas y Usuarios.');
                                                    e.processOnServer = false;
                                                } else {
                                                    LoadingPanel.Show();
                                                    Callback.PerformCallback();
                                                }
                                            }
                                        }" />
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
