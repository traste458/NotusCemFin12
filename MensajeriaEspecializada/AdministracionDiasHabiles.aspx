<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionDiasHabiles.aspx.vb" Inherits="BPColSysOP.AdministracionDiasHabiles" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración días Hábiles</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
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
                    gvDiasHabiles.PerformCallback();
                    LoadingPanel.Hide();  }" />
                    <PanelCollection>
                        <dx:PanelContent>
                            
                            <dx:ASPxRoundPanel ID="rpAdicionDiaHabil" runat="server" HeaderText="Adición día(s) No Hábil(es)" Width="100%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxPageControl ID="pcDiasNoHabiles" runat="server" ActiveTabIndex="0" 
                                            Width="100%" ClientInstanceName="tabDias">
                                            <TabPages>
                                                <dx:TabPage Text="Día Específico">
                                                    <TabImage Url="../images/calendar_day.png"></TabImage>
                                                    <ContentCollection>
                                                        <dx:ContentControl>
                                                            <table cellpadding="1">
                                                                <tr>
                                                                    <td style="width:50%">Día No Hábil:</td>
                                                                    <td style="width:50%">
                                                                        <dx:ASPxDateEdit ID="dateFecha" runat="server" UseMaskBehavior="True">
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                                                ValidationGroup="vgEspecifico">
                                                                                <RequiredField ErrorText="Debe seleccionar una día" IsRequired="True" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxDateEdit>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </dx:ContentControl>
                                                    </ContentCollection>
                                                </dx:TabPage>
                                                <dx:TabPage Text="Rango de Días">
                                                    <TabImage Url="../images/calendar-select-days.png"></TabImage>
                                                    <ContentCollection>
                                                        <dx:ContentControl>
                                                            <table cellpadding="1">
                                                                <tr>
                                                                    <td>Fecha Inicial:</td>
                                                                    <td>
                                                                        <dx:ASPxDateEdit ID="dateInicio" runat="server" ClientInstanceName="dateInicio">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                                dateFin.SetMinDate(dateInicio.GetDate());
                                                                            }" />
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                                                ValidationGroup="vgRango">
                                                                                <RequiredField ErrorText="Debe seleccionar una fecha inicial" 
                                                                                    IsRequired="True" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxDateEdit>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Fecha Final:</td>
                                                                    <td>
                                                                        <dx:ASPxDateEdit ID="dateFin" runat="server" ClientInstanceName="dateFin">
                                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                                if (dateInicio.GetDate()==null){
                                                                                    dateInicio.SetMaxDate(dateFin.GetDate());
                                                                                }
                                                                            }" />
                                                                            <ValidationSettings ValidationGroup="vgRango" 
                                                                                ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" ErrorText="La fecha final es requerida" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxDateEdit>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <dx:ASPxCheckBoxList ID="cblDiasSemana" runat="server" ValueType="System.Int32" 
                                                                            RepeatDirection="Vertical">
                                                                        <Items>
                                                                            <dx:ListEditItem Value="1" Text="Lunes" />
                                                                            <dx:ListEditItem Value="2" Text="Martes" />
                                                                            <dx:ListEditItem Value="3" Text="Miércoles" />
                                                                            <dx:ListEditItem Value="4" Text="Jueves" />
                                                                            <dx:ListEditItem Value="5" Text="Viernes" />
                                                                            <dx:ListEditItem Value="6" Text="Sábado" />
                                                                            <dx:ListEditItem Value="0" Text="Domingo" />
                                                                        </Items>
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                                                ValidationGroup="vgRango">
                                                                                <RequiredField ErrorText="Debe seleccionar al menos un día de la semana" 
                                                                                    IsRequired="True" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxCheckBoxList>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </dx:ContentControl>
                                                    </ContentCollection>
                                                </dx:TabPage>
                                            </TabPages>
                                        </dx:ASPxPageControl>
                                        <div style="margin-top: 5px;" align="center">
                                            <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Adicionar Día(s)" AutoPostBack="false">
                                                <Image Url="../images/add.png"></Image>
                                                <ClientSideEvents Click="function(s, e) {
                                                    if(tabDias.GetActiveTabIndex()==0){
                                                        if(ASPxClientEdit.ValidateGroup('vgEspecifico')) {
                                                            LoadingPanel.Show();
                                                            cpRegistro.PerformCallback('Especifico');
                                                        }
                                                    } else {
                                                        if(ASPxClientEdit.ValidateGroup('vgRango')) {
                                                            LoadingPanel.Show();
                                                            cpRegistro.PerformCallback('Rango');
                                                        }
                                                    }
                                                }" />
                                            </dx:ASPxButton>
                                        </div>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </dx:PanelContent>
                    </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>

        <div style="float: right; margin-top: 5px; width: 58%;">
            <dx:ASPxRoundPanel ID="rpListadoDiasHabiles" runat="server" HeaderText="Días No Hábiles Configurados">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvDiasHabiles" runat="server" ClientInstanceName="gvDiasHabiles"
                            AutoGenerateColumns="False" KeyFieldName="IdDia">
                            <ClientSideEvents EndCallback="function(s, e) {
                                $('#divEncabezado').html(s.cpMensaje);
                                LoadingPanel.Hide(); 
                            }" />
                            <Columns>
                                <dx:GridViewDataTextColumn Caption="ID" ShowInCustomizationForm="True" 
                                    VisibleIndex="0" FieldName="IdDia">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Fecha" ShowInCustomizationForm="True" 
                                    VisibleIndex="1" FieldName="Fecha">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Día de la Semana" ShowInCustomizationForm="True" 
                                    VisibleIndex="2" FieldName="NombreDia">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataColumn Caption="" VisibleIndex="3">
                                    <DataItemTemplate>
                                        <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/cross.png"
                                            Cursor="pointer" ToolTip="Eliminar" OnInit="Link_Init">
                                            <ClientSideEvents Click="function(s, e) { 
                                                if(confirm('¿Realmente desea eliminar el día no hábil?')) {
                                                    gvDiasHabiles.PerformCallback('{0}'+':eliminar'); 
                                                }
                                            }" />
                                        </dx:ASPxHyperLink>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>                                
                            </Columns>
                            <SettingsPager PageSize="15">
                            </SettingsPager>
                        </dx:ASPxGridView>
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
