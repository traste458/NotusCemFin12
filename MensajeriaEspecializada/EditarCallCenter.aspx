<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarCallCenter.aspx.vb"
    Inherits="BPColSysOP.EditarCallCenter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar Call Center</title>
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
        <dx:ASPxRoundPanel ID="rpEncabezado" runat="server" HeaderText="Información del Call Center"
            Width="100%">
            <PanelCollection>
                <dx:PanelContent>
                    
                    <table style="width:100%;">
                        <tr>
                            <td>
                                Nombre Call Center:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtNombreCallCenter" runat="server" Width="250px">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgCall">
                                        <RequiredField ErrorText="El nombre del call center es requerido" 
                                            IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Nombre Contacto:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtNombreContacto" runat="server" Width="250px">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgCall">
                                        <RequiredField ErrorText="El nombre del contacto es requerido" 
                                            IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Teléfono Contacto:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtTelefonoContacto" runat="server" Width="150px">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgCall">
                                        <RequiredField ErrorText="El teléfono es requerido" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Activo:</td>
                            <td>
                                <dx:ASPxCheckBox ID="cbActivo" runat="server" CheckState="Unchecked">
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
                                                                    ValueField="IdTipoServicio" Height="100%" ClientInstanceName="tiposServicios">
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
                                <dx:ASPxButton ID="btnModificar" runat="server" Text="Modificar" Width="110px" Style="display: inline"
                                    ValidationGroup="vgCampania" AutoPostBack="false">
                                    <Image Url="../images/save_all.png">
                                    </Image>
                                    <ClientSideEvents Click="function(s, e) {
                                        if(ASPxClientEdit.ValidateGroup('vgCall')) 
                                        {
                                             if(tiposServicios.GetSelectedValues().length==0){
                                                    alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados los Tipos de Servicios.');
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
