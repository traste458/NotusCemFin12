<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarDocumento.aspx.vb" Inherits="BPColSysOP.EditarDocumento" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar Documento</title>
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
        <dx:ASPxRoundPanel ID="rpEncabezado" runat="server" HeaderText="Información del Documento"
            Width="100%">
            <PanelCollection>
                <dx:PanelContent>
                    <table cellpadding="1">
                        <tr>
                            <td>Nombre Documento:</td>
                            <td>
                                <dx:ASPxTextBox ID="txtNombreDocumento" runat="server" Width="200px">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgDocumento">
                                        <RequiredField ErrorText="El nombre del documento es requerido" 
                                            IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Observación del documento:</td>
                            <td>
                                <dx:ASPxMemo ID="memoObservacion" runat="server" Height="60px" Width="200px">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgDocumento">
                                        <RequiredField ErrorText="La observación es requerida" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Activo:</td>
                            <td>
                                <dx:ASPxCheckBox ID="chbActivo" runat="server" CheckState="Checked">
                                </dx:ASPxCheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <dx:ASPxCheckBox ID="chbRecibo" runat="server" Text="Recibo"></dx:ASPxCheckBox>
                            </td>
                            <td align="center">
                                <dx:ASPxCheckBox ID="chbEntrega" runat="server" Text="Entrega"></dx:ASPxCheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <dx:ASPxPageControl ID="pcAsociadosDocumento" runat="server" ActiveTabIndex="0" Width="100%">
                                    <TabPages>
                                        <dx:TabPage Text="Unidad de Negocio">
                                            <TabImage Url="../images/companies.png">
                                            </TabImage>
                                            <ContentCollection>
                                                <dx:ContentControl ID="ContentControl1" runat="server">
                                                    <dx:ASPxPanel ID="pnlUnidadNegocio" runat="server" ScrollBars="Auto" Height="200px">
                                                        <PanelCollection>
                                                            <dx:PanelContent>
                                                                <dx:ASPxListBox ID="lbUnidadNegocio" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                    ValueField="IdUnidadNegocio" Height="100%" ClientInstanceName="unidades">
                                                                    <Columns>
                                                                        <dx:ListBoxColumn FieldName="Nombre" Caption="Nombre Unidad Negocio" Width="100%" />
                                                                        <dx:ListBoxColumn FieldName="Codigo" Caption="Código" Width="100px" />
                                                                    </Columns>
                                                                </dx:ASPxListBox>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxPanel>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>
                                        <dx:TabPage Text="Tipo de Servicio">
                                            <TabImage Url="../images/element.png">
                                            </TabImage>
                                            <ContentCollection>
                                                <dx:ContentControl ID="ContentControl2" runat="server">
                                                    <dx:ASPxPanel ID="pnlTipoServicio" runat="server" ScrollBars="Auto" Height="200px">
                                                        <PanelCollection>
                                                            <dx:PanelContent>
                                                                <dx:ASPxListBox ID="lbTipoServicio" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                    ValueField="IdTipoServicio" Height="100%" ClientInstanceName="tipos">
                                                                    <Columns>
                                                                        <dx:ListBoxColumn FieldName="Nombre" Caption="Nombre Tipo Servicio" Width="100%" />
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
                                    <dx:ASPxButton ID="btnModificar" runat="server" Text="Modificar" Width="110px" Style="display: inline"
                                        ValidationGroup="vgCampania" AutoPostBack="false">
                                        <Image Url="../images/save_all.png">
                                        </Image>
                                        <ClientSideEvents Click="function(s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgDocumento')) {
                                                        if(unidades.GetSelectedValues().length==0 || tipos.GetSelectedValues().length==0){
                                                            alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Unidades de negocio y Tipos de Servicio.');
                                                            e.processOnServer = false;
                                                        } else {
                                                            LoadingPanel.Show();
                                                            Callback.PerformCallback();
                                                        }
                                                    }
                                                }" />
                                    </dx:ASPxButton>
                                </div>
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
