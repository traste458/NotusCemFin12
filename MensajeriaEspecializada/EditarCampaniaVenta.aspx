<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarCampaniaVenta.aspx.vb"
    Inherits="BPColSysOP.EditarCampaniaVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar Campaña de Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
    <script type="text/javascript">
        
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
                document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
            }" />
    </dx:ASPxCallback>
    <dx:ASPxRoundPanel ID="rpEncabezado" runat="server" HeaderText="Información de la campaña"
        Width="100%">
        <PanelCollection>
            <dx:PanelContent>
                <table width="100%">
                    <tr>
                        <td>
                            Nombre de la Campaña:
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="txtNombreCampania" runat="server" Width="300px">
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
                            <dx:ASPxDateEdit ID="dateFechaFin" runat="server" Width="100px" ClientInstanceName="dateFechaFin">
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
                            <dx:ASPxCheckBox ID="cbActivo" runat="server">
                            </dx:ASPxCheckBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <dx:ASPxPageControl ID="pcAsociadosCampania" runat="server" ActiveTabIndex="0" Width="100%">
                                <TabPages>
                                    <dx:TabPage Text="Planes">
                                        <TabImage Url="../images/structure.png">
                                        </TabImage>
                                        <ContentCollection>
                                            <dx:ContentControl ID="ContentControl1" runat="server">
                                                <dx:ASPxPanel ID="pnlPlanes" runat="server" ScrollBars="Auto" Height="250px">
                                                    <PanelCollection>
                                                        <dx:PanelContent>
                                                            <dx:ASPxListBox ID="lbPlanes" runat="server" Width="100%" SelectionMode="CheckColumn"
                                                                ValueField="IdPlan" Height="100%" ClientInstanceName="planes">
                                                                <Columns>
                                                                    <dx:ListBoxColumn FieldName="NombrePlan" Caption="Plan" />
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
                                            <dx:ContentControl ID="ContentControl2" runat="server">
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
                                            <dx:ContentControl ID="ContentControl3" runat="server">
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
                                    <dx:TabPage Text="Tipos Servicios">
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
                                            if(ASPxClientEdit.ValidateGroup('vgCampania')) {
                                                if(planes.GetSelectedValues().length==0 || calls.GetSelectedValues().length==0 || documentos.GetSelectedValues().length==0 || tiposServicios.GetSelectedValues().length==0){
                                                    alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Planes, Call Centers, Documentos y Tipos de Servicios.');
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
