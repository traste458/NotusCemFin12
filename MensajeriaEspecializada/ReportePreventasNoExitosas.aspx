<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReportePreventasNoExitosas.aspx.vb"
    Inherits="BPColSysOP.ReportePreventasNoExitosas" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte Preventas No Exitosas</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">

    <form id="formPrincipal" runat="server">
    <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    <div style="float: left; margin-right: 20px; margin-top: 15px;">
        <dx:ASPxRoundPanel ID="rpFiltroPreventas" runat="server" 
            HeaderText="Filtro de búsqueda" >
            <PanelCollection>
                <dx:panelcontent>
                    <table cellpadding="1">
                        <tr>
                            <td>
                                Nombre Call Center:
                            </td>
                            <td>
                                <dx:aspxcombobox ID="cmbCallCenter" runat="server" 
                                    IncrementalFilteringMode="Contains" Width="450px" ValueField="idCallCenter"
                                     ClientInstanceName ="cmbCallCenter">
                                    <Columns>
                                        <dx:listboxcolumn FieldName="idCallCenter" Width="5%" Caption="Id" />
                                        <dx:listboxcolumn FieldName="nombre" Width="40%" Caption="CallCenter" />
                                        <dx:listboxcolumn FieldName="bodega" Width="55%" Caption="Bodega" />
                                    </Columns>
                                </dx:aspxcombobox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Fecha Inicio:
                            </td>
                            <td>
                                <dx:aspxdateedit ID="dateFechaInicio" runat="server" NullText="Seleccione..." 
                                    ClientInstanceName="dateFechaInicio">
                                    <ClientSideEvents ValueChanged="function(s, e){
                                        dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                    }" />
                                </dx:aspxdateedit>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Fecha Fin:
                            </td>
                            <td>
                                <dx:aspxdateedit ID="dateFechaFin" runat="server" NullText="Seleccione..." 
                                    ClientInstanceName="dateFechaFin">
                                    <ClientSideEvents ValueChanged="function(s, e){
                                        if (dateFechaInicio.GetDate()==null){
                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                        }
                                    }" />
                                </dx:aspxdateedit>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                    <div style="float:left; margin-right: 15px;">
                                    <dx:aspxbutton ID="btnFiltrar" runat="server" Text="Filtrar" Theme="Glass">
                                    <ClientSideEvents Click ="function(s, e){
                                        LoadingPanel.Show();
                                        if (dateFechaInicio.GetDate()==null && dateFechaFin.GetDate()==null && cmbCallCenter.GetValue()==null){
                                            alert('Debe seleccionar por lo menos un filtro de búsqueda.');
                                            LoadingPanel.Hide();
                                             e.processOnServer = false; 
                                            } else {
                                            if(dateFechaInicio.GetDate()==null || dateFechaFin.GetDate()==null){
                                                if(cmbCallCenter.GetValue()==null){
                                                alert('Debe seleccionar los dos rangos de fecha.');
                                                e.processOnServer = false;
                                                LoadingPanel.Hide();
                                                }
                                            } else {
                                                e.processOnServer = true;        
                                                }
                                            }
                                    } "/>
                                    <Image Url="../images/filtro.png"></Image>
                                    </dx:aspxbutton>
                                </div>
                                <div style="float:left">
                                    <dx:aspxbutton ID="btnLimpiar" runat="server" Text="Limpiar Campos" 
                                        Theme="Glass">
                                        <ClientSideEvents Click ="function(s, e){
                                            LoadingPanel.Hide();
                                        }"/>
                                    <Image Url="../images/unfunnel.png"></Image>
                                    </dx:aspxbutton>
                                </div>
                            </td>
                        </tr>
                    </table>
                </dx:panelcontent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    <div style="float: right; margin-right: 20px; margin-bottom: 20px; margin-top: 15px;">
        <dx:ASPxRoundPanel ID="rpExportal" runat="server" 
            HeaderText="Opciones de exportación" >
            <PanelCollection>
                <dx:panelcontent>
                    <table cellpadding="0" cellspacing="0" style="margin-bottom: 16px">
                        <tr>
                            <td style="padding-right: 4px">
                                &nbsp;</td>
                            <td style="padding-right: 4px">
                                <dx:aspxbutton ID="btnXlsExport" runat="server" Text="Exportar a XLS" 
                                    UseSubmitBehavior="False"  OnClick ="btnXlsExport_Click" />
                            </td>
                            <td style="padding-right: 4px">
                                <dx:aspxbutton ID="btnXlsxExport" runat="server" Text="Exportar a XLSX" 
                                    UseSubmitBehavior="False"  OnClick ="btnXlsxExport_Click" />
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                    </table>
                </dx:panelcontent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    <div style="clear:both"></div>
    <div style="margin-right: 20px; margin-top: 20px">
        <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" Width="100%" 
            HeaderText="Resultado Búsqueda" >
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridView ID="gvDatos" runat="server" Width="100%" 
                        AutoGenerateColumns="False" >
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="callCenter" Caption="Call Center" ShowInCustomizationForm="True" VisibleIndex="0">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName ="fecha" Caption="Fecha Registro" ShowInCustomizationForm="True"
                                VisibleIndex="1"> <PropertiesTextEdit DisplayFormatString="{0:d}" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName ="nombre" Caption="Nombre Cliente" ShowInCustomizationForm="True"
                                VisibleIndex="2">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="direccion" Caption="Dirección" ShowInCustomizationForm="True" VisibleIndex="3">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="telefono" Caption="Teléfono Móvil" ShowInCustomizationForm="True"
                                VisibleIndex="4">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName ="novedad" Caption="Motivo cancelación" ShowInCustomizationForm="True"
                                VisibleIndex="5">
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <Settings ShowGroupPanel="True" />
                    </dx:ASPxGridView>
                    <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos">
                    </dx:ASPxGridViewExporter>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>


        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>

    </div>
    </form>
</body>
</html>
