<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteUnidadesDisponiblesSiembra.aspx.vb" Inherits="BPColSysOP.ReporteUnidadesDisponiblesSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Reporte de Unidades Disponibles SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
        function OnExpandCollapseButtonClick(s, e) {
            var isVisible = ContentPanel.GetVisible();

            if (s.GetImageUrl().indexOf('arrow_up2.gif') != -1) {
                s.SetImageUrl(s.GetImageUrl().replace('arrow_up2.gif', 'arrow_down2.gif'));
            } else {
                s.SetImageUrl(s.GetImageUrl().replace('arrow_down2.gif', 'arrow_up2.gif'));
            }
            ContentPanel.SetVisible(!isVisible);
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('rpFiltros');
                cbFormatoExportar.SetSelectedIndex(0);
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="float: left; margin-right: 20px; margin-bottom: 5px; margin-top: 5px;">
        <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtros de Búsqueda"
            ClientInstanceName="rpFiltros">
            <HeaderTemplate>
                <dx:ASPxImage ID="headerImage" runat="server" ImageUrl="../images/arrow_up2.gif"
                    Cursor="pointer" ImageAlign="Right">
                    <ClientSideEvents Click="OnExpandCollapseButtonClick" />
                </dx:ASPxImage>
                <dx:ASPxLabel ID="headerText" runat="server" Text='<%# Container.RoundPanel.HeaderText %>'>
                </dx:ASPxLabel>
            </HeaderTemplate>
            <PanelCollection>
                <dx:PanelContent ID="PanelContent1" runat="server">
                    <div style="width: 600px">
                    </div>
                    <dx:ASPxPanel ID="pnlContent" runat="server" Width="100%" ClientInstanceName="ContentPanel">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1">
                                    <tr>
                                        <td rowspan="2">
                                            Ciudad:
                                        </td>
                                        <td rowspan="2">
                                            <dx:ASPxComboBox ID="cmbCiudad" runat="server" DropDownStyle="DropDownList"
                                                ValueField="idCiudad" ValueType="System.String" TextFormatString="{0} ({1})"
                                                IncrementalFilteringMode="Contains" Width="300px" ClientInstanceName="cmbCiudad">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="nombreCiudad" Caption="Ciudad" Width="200px" />
                                                    <dx:ListBoxColumn FieldName="nombreDepartamento" Caption="Departamento" Width="200px" />
                                                </Columns>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            
                                            <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" Width="100px" AutoPostBack="false">
                                                <ClientSideEvents Click="function(s, e) {
                                                                gvDatos.PerformCallback();
                                                            }">
                                                </ClientSideEvents>
                                                <Image Url="../images/filtro.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                        <td align="center">
                                            <dx:ASPxButton ID="btnLimpiar" runat="server" AutoPostBack="False" 
                                                Text="Limpiar Campos" Width="150px">
                                                <ClientSideEvents Click="function(s, e){
                                                                LimpiaFormulario();
                                                                gvDatos.PerformCallback();
                                                            }" />
                                                <Image Url="../images/unfunnel.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                        <td colspan="2" align="center">
                                            <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" 
                                                AutoResizeWithContainer="True" ClientInstanceName="cbFormatoExportar" 
                                                EnableCallbackMode="True" SelectedIndex="0" ShowImageInEditBox="True" 
                                                Width="200px">
                                                <Items>
                                                    <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" 
                                                        Value="xlsx" Selected="True" />
                                                    <dx:ListEditItem ImageUrl="../images/excel.gif" 
                                                        Text="Exportar a XLS" Value="xls" />
                                                    <dx:ListEditItem ImageUrl="../images/pdf.png" Text="Exportar a PDF" 
                                                        Value="pdf" />
                                                    <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" 
                                                        Value="csv" />
                                                </Items>
                                                <Buttons>
                                                    <dx:EditButton Text="Exportar" 
                                                        ToolTip="Exportar Reporte al formato seleccionado">
                                                        <Image Url="../images/upload.png">
                                                        </Image>
                                                    </dx:EditButton>
                                                </Buttons>
                                                <ValidationSettings CausesValidation="True" Display="Dynamic" 
                                                    ErrorText="Formato a exportar requerido" ValidationGroup="exportar">
                                                    <RegularExpression ErrorText="Falló la validación de expresión Regular" />
                                                    <RequiredField ErrorText="Formato a exportar requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    <div style="clear: both">
    </div>
    <div style="margin-top: 10px">
        <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" Width="95%" HeaderText="Resultado Búsqueda"
            Style="margin-bottom: 20px;">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridView ID="gvDatos" runat="server" Width="100%" AutoGenerateColumns="False"
                        ClientInstanceName="gvDatos">
                        <Settings ShowFooter="True" ShowHeaderFilterButton="true" />
                        <ClientSideEvents EndCallback="function(s, e) {
                            $(&#39;#divEncabezado&#39;).html(s.cpMensaje);
                        }">
                        </ClientSideEvents>
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="producto" Caption="Equipo" ShowInCustomizationForm="True"
                                VisibleIndex="0">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="disponibles" Caption="Disponibles" ShowInCustomizationForm="True"
                                VisibleIndex="1">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="sembrados" Caption="Sembrados"
                                ShowInCustomizationForm="True" VisibleIndex="2">
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <SettingsPager PageSize="100" AlwaysShowPager="True">
                        </SettingsPager>
                        <Settings ShowHeaderFilterButton="True" ShowFooter="True"></Settings>
                        <SettingsLoadingPanel Delay="150" />
                    </dx:ASPxGridView>
                    <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos">
                    </dx:ASPxGridViewExporter>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    </form>
</body>
</html>
