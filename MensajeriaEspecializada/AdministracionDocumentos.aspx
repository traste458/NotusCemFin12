<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionDocumentos.aspx.vb" Inherits="BPColSysOP.AdministracionDocumentos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración de Documentos</title>
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
            dialogoEditar.SetContentUrl("EditarDocumento.aspx?idDocumento=" + key);
            dialogoEditar.SetSize(myWidth * 0.5, myHeight * 0.9);
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
                        <dx:ASPxRoundPanel ID="rpAdicionDocumentos" runat="server" HeaderText="Adición de Documentos">
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
                                                                <dx:ContentControl runat="server">
                                                                    <dx:ASPxPanel ID="pnlUnidadNegocio" runat="server" ScrollBars="Auto" Height="250px">
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
                                                                <dx:ContentControl runat="server">
                                                                    <dx:ASPxPanel ID="pnlTipoServicio" runat="server" ScrollBars="Auto" Height="250px">
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
                                                    <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Adicionar" Width="110px" Style="display: inline" AutoPostBack="false">
                                                        <Image Url="../images/add.png">
                                                        </Image>
                                                        <ClientSideEvents Click="function(s, e) {
                                                                if(ASPxClientEdit.ValidateGroup('vgDocumento')) {
                                                                    if(unidades.GetSelectedValues().length==0 || tipos.GetSelectedValues().length==0){
                                                                        alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Unidades de Negocio y Tipos De Servicio.');
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
            <dx:ASPxCallbackPanel runat="server" ID="cpBusquedaDocumentos" ClientInstanceName="cpBusquedaDocumentos"
               >
                <PanelCollection>
                    <dx:PanelContent>
                        <div style="margin-bottom: 5px">
                            <dx:ASPxRoundPanel ID="rpFiltroDocumentos" runat="server" HeaderText="Filtro de Búsqueda">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table cellpadding="1">
                                            <tr>
                                                <td>
                                                    Nombre Documentos:
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtNombreDocumentoFiltro" runat="server" Width="170px">
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
                                                                gvDocumentos.PerformCallback();
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
                            <dx:ASPxRoundPanel ID="rpResultadoDocumentos" runat="server" HeaderText="Listado de Documentos" Width="100%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxGridView ID="gvDocumentos" runat="server" Width="100%" ClientInstanceName="gvDocumentos"
                                            AutoGenerateColumns="false" KeyFieldName="IdDocumento">
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="ID" ShowInCustomizationForm="True" 
                                                    VisibleIndex="0" FieldName="IdDocumento">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Nombre Documento" 
                                                    ShowInCustomizationForm="True" VisibleIndex="1" FieldName="Nombre">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Observación" ShowInCustomizationForm="True" 
                                                    VisibleIndex="2" FieldName="Observacion">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataCheckColumn Caption="Activo" ShowInCustomizationForm="true" VisibleIndex="3"
                                                    FieldName="Activo">
                                                </dx:GridViewDataCheckColumn>
                                                <dx:GridViewDataCheckColumn Caption="Recibo" ShowInCustomizationForm="true" VisibleIndex="4"
                                                    FieldName="Recibo">
                                                </dx:GridViewDataCheckColumn>
                                                <dx:GridViewDataCheckColumn Caption="Entrega" ShowInCustomizationForm="true" VisibleIndex="5"
                                                    FieldName="Entrega">
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
            HeaderText="Modificación del Documento" AllowDragging="true" Width="400px" Height="180px"
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
