<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RadicacionServicioTipoVenta.aspx.vb" Inherits="BPColSysOP.RadicacionServicioTipoVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Radicar Servicio Tipo Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>

        <asp:UpdatePanel ID="upEncabezado" runat="server" UpdateMode="Always">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s, e) { 
                LoadingPanel.Hide(); 
            }" />
        </dx:ASPxCallback>


        <div style="float: left; margin-right: 20px;">
            <dx:ASPxRoundPanel ID="rpBusqueda" runat="server" HeaderText="Búsqueda de Servicios">
                <PanelCollection>
                    <dx:PanelContent>
                        <table style="width: auto; height: auto">
                            <tr valign="middle">
                                <td>
                                    No Planilla:
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="txtNoPlanilla" runat="server" Width="100px" MaxLength="10">
                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                            <RequiredField ErrorText="Por favor ingrese un número de planilla" 
                                                IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxTextBox>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnBuscarPlanilla" runat="server" Text="Buscar Servicios">
                                        <Image Url="../images/find.gif"></Image>
                                        <ClientSideEvents Click="function(s, e) {
                                                    Callback.PerformCallback();
                                                    LoadingPanel.Show();
                                                }" />
                                    </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                    
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>
        
        <div style="float: left">
            <dx:ASPxRoundPanel ID="rpResultado" runat="server" HeaderText="Contratos Asociados" Visible="false">
                <PanelCollection>
                    <dx:PanelContent>
                        <table style="margin-bottom: 15px">
                            <tr>
                                <td>No. Volante</td>
                                <td>
                                    <dx:ASPxTextBox ID="txtNoVolante" runat="server" Width="100px" MaxLength="10">
                                        <MaskSettings Mask="9999999" />
                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                            ValidationGroup="vgRadicar">
                                            <RequiredField ErrorText="El número de volante es requerido." 
                                                IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Valor Total:</td>
                                <td>
                                    <dx:ASPxTextBox ID="txtValorTotal" runat="server" Width="100px">
                                        <MaskSettings Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" />
                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                            ValidationGroup="vgRadicar">
                                            <RequiredField ErrorText="El valor total es requerido" IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Fecha Radicación:</td>
                                <td>
                                    <dx:ASPxDateEdit ID="dateFechaRadicacion" runat="server" Width="100px">
                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                            ValidationGroup="vgRadicar">
                                            <RequiredField ErrorText="La fecha de radicación es requerida." 
                                                IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxDateEdit>
                                </td>
                            </tr>
                        </table>

                        <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="false" ClientInstanceName="grid">
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="NumeroRadicado" 
                                    ShowInCustomizationForm="True" VisibleIndex="0" Caption="No. Contrato">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Serial" 
                                    ShowInCustomizationForm="True" VisibleIndex="1" Caption="Serial">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Msisdn" 
                                    ShowInCustomizationForm="True" VisibleIndex="2" Caption="Msisdn">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="FechaLegalizacion" 
                                    ShowInCustomizationForm="True" VisibleIndex="3" Caption="Fecha Legalización">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>

                        <div style="margin-top: 20px">
                            <dx:ASPxButton ID="btnRadicar" runat="server" Text="Radicar Servicios" 
                                ValidationGroup="vgRadicar">
                                <Image Url="../images/finished.png" ></Image>
                                <ClientSideEvents Click="function(s, e) {
                                                    Callback.PerformCallback();
                                                    LoadingPanel.Show();
                                                }" />
                            </dx:ASPxButton>
                        </div>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>

        <dx:ASPxLoadingPanel ID="lpGlobal" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
