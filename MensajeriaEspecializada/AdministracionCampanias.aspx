<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionCampanias.aspx.vb"
    Inherits="BPColSysOP.AdministracionCampanias" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración de Campañas</title>
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
            dialogoEditar.SetContentUrl("EditarCampaniaVenta.aspx?idCampania=" + key);
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
                ASPxClientEdit.ClearEditorsInContainerById('pcAsociadosCampania');
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
                    <dx:ASPxRoundPanel ID="rpAdicionCampania" runat="server" HeaderText="Adición de Campaña"
                        Width="100%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td>
                                            Nombre de Campaña:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombreCampania" runat="server" Width="100%">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                    <RequiredField ErrorText="El nombre de la campaña  es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Fecha Inicio:
                                        </td>
                                        <td>
                                            <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" Width="100px" ClientInstanceName="dateFechaInicio">
                                                <ClientSideEvents ValueChanged="function(s, e){
                                                    dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                }" />
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                    <RequiredField ErrorText="La fecha inicial de la campaña es requerida" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxDateEdit>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Fecha Fin:
                                        </td>
                                        <td>
                                            <dx:ASPxDateEdit ID="dateFechaFinal" runat="server" Width="100px" ClientInstanceName="dateFechaFin">
                                                <ClientSideEvents ValueChanged="function(s, e){
                                                    if (dateFechaInicio.GetDate()==null){
                                                    dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                    }
                                                }" />
                                            </dx:ASPxDateEdit>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Activo:
                                        </td>
                                        <td>
                                            <dx:ASPxCheckBox ID="chbEstado" runat="server" CheckState="Checked">
                                            </dx:ASPxCheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <dx:ASPxPageControl ID="pcAsociadosCampania" runat="server" ActiveTabIndex="3" Width="100%">
                                                <TabPages>
                                                    <dx:TabPage Text="Planes">
                                                        <TabImage Url="../images/structure.png">
                                                        </TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <dx:ASPxPanel ID="pnlPlanes" runat="server" ScrollBars="Auto" Height="250px">
                                                                    <PanelCollection>
                                                                        <dx:PanelContent>
                                                                            <dx:ASPxListBox ID="lbPlanes" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                                ValueField="IdPlan" Height="100%" ClientInstanceName="planes">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="NombrePlan" Caption="Plan" Width="100%" />
                                                                                    <dx:ListBoxColumn FieldName="CargoFijoMensual" Caption="CFM" Width="100px" />
                                                                                </Columns>
                                                                            </dx:ASPxListBox>
                                                                        </dx:PanelContent>
                                                                    </PanelCollection>
                                                                </dx:ASPxPanel>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Call Centers">
                                                        <TabImage Url="../images/phone.png">
                                                        </TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <dx:ASPxPanel ID="pnlCallCenters" runat="server" ScrollBars="Auto" Height="250px">
                                                                    <PanelCollection>
                                                                        <dx:PanelContent>
                                                                            <dx:ASPxListBox ID="lbCallCenter" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                                ValueField="IdCallCenter" Height="100%" ClientInstanceName="calls">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="NombreCallCenter" Caption="Call Center" />
                                                                                    <dx:ListBoxColumn FieldName="NombreContacto" Caption="Contacto" />
                                                                                </Columns>
                                                                            </dx:ASPxListBox>
                                                                        </dx:PanelContent>
                                                                    </PanelCollection>
                                                                </dx:ASPxPanel>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Documentos">
                                                        <TabImage Url="../images/documents_stack.png">
                                                        </TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <dx:ASPxPanel ID="pnlDocumentos" runat="server" ScrollBars="Auto" Height="250px">
                                                                    <PanelCollection>
                                                                        <dx:PanelContent>
                                                                            <dx:ASPxListBox ID="lbDocumentos" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                                ValueField="IdDocumento" Height="100%" ClientInstanceName="documentos">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="Nombre" Caption="Documento" />
                                                                                    <dx:ListBoxColumn FieldName="Observacion" Caption="Observación" />
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
                                            <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Adicionar" Width="110px" Style="display: inline"
                                                ValidationGroup="vgCampania" AutoPostBack="false">
                                                <Image Url="../images/add.png">
                                                </Image>
                                                <ClientSideEvents Click="function(s, e) {
                                                        if(ASPxClientEdit.ValidateGroup('vgCampania')) {
                                                            if(planes.GetSelectedValues().length==0 || calls.GetSelectedValues().length==0 || documentos.GetSelectedValues().length==0 ){
                                                                alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Planes, Call Centers, Documentos y Tipos de Servicios.');
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
        <dx:ASPxCallbackPanel runat="server" ID="cpBusquedaCampanias" ClientInstanceName="cpBusquedaCampanias"
           >
            <PanelCollection>
                <dx:PanelContent>
                    <div style="margin-bottom: 15px">
                        <dx:ASPxRoundPanel ID="rpFiltroCampanias" runat="server" HeaderText="Filtro de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>
                                            <td>
                                                Nombre Campaña:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNombreCampaniaFiltro" runat="server" Width="170px">
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
                                                            gvCampanias.PerformCallback();
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
                        <dx:ASPxRoundPanel ID="rpResultadoCampanias" runat="server" HeaderText="Listado de Campañas"
                            Width="100%">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gvCampanias" runat="server" Width="100%" ClientInstanceName="gvCampanias"
                                        AutoGenerateColumns="False" KeyFieldName="IdCampania">
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="ID" ShowInCustomizationForm="True" VisibleIndex="0"
                                                FieldName="IdCampania">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Nombre Campaña" ShowInCustomizationForm="True"
                                                VisibleIndex="1" FieldName="Nombre">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Fecha Inicio" FieldName="FechaInicio" ShowInCustomizationForm="True"
                                                VisibleIndex="2">
                                                <PropertiesTextEdit DisplayFormatString="{0:d}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn Caption="Fecha Fin" ShowInCustomizationForm="true" VisibleIndex="3"
                                                FieldName="FechaFin">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataCheckColumn Caption="Activo" ShowInCustomizationForm="true" VisibleIndex="5"
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
        HeaderText="Modificación de la Campaña" AllowDragging="true" Width="400px" Height="180px"
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
