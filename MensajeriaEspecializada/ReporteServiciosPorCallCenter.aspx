<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteServiciosPorCallCenter.aspx.vb"
    Inherits="BPColSysOP.ReporteServiciosPorCallCenter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Reporte Ventas por Call Center</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
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
        <div style="float: left; margin-right: 20px; margin-top: 15px">
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" Width="100%" ClientInstanceName="cpGeneral"
            EnableAnimation="true" >
            <ClientSideEvents EndCallback="function(s, e){
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide(); 
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <div style="float: left; margin-right: 20px; margin-top: 15px;">
                        <dx:ASPxRoundPanel ID="rpFiltroServicios" runat="server" HeaderText="Filtro de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>
                                            <td class="field">Nombre Call Center:
                                            </td>
                                            <td colspan="3">
                                                <dx:ASPxComboBox ID="cmbCallCenter" runat="server" IncrementalFilteringMode="Contains" Width="270px" ValueField="idCallCenter"
                                                    ClientInstanceName="cmbCallCenter" DropDownStyle="DropDownList" TabIndex="1">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="idCallCenter" Width="20px" Caption="Id" />
                                                        <dx:ListBoxColumn FieldName="nombre" Width="200px" Caption="CallCenter" />
                                                        <dx:ListBoxColumn FieldName="bodega" Width="300px" Caption="Bodega" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="field">Fecha Inicio:
                                            </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                    Width="100px" TabIndex="2">
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                        dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                    }" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td class="field">Fecha Fin:
                                            </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                    Width="100px" TabIndex="3">
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                    }" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="right">
                                                <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" Theme="Glass" Width="100px"
                                                    Style="display: inline" TabIndex="4" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(s, e){
                                                        //LoadingPanel.Show();
                                                        if (dateFechaInicio.GetDate()==null && dateFechaFin.GetDate()==null && cmbCallCenter.GetValue()==null){
                                                            alert('Debe seleccionar por lo menos un filtro de búsqueda.');
                                                            LoadingPanel.Hide();
                                                            } else {
                                                            if(dateFechaInicio.GetDate()==null || dateFechaFin.GetDate()==null){
                                                                if(cmbCallCenter.GetValue()==null){
                                                                alert('Debe seleccionar los dos rangos de fecha.');
                                                                LoadingPanel.Hide();
                                                                }
                                                            } else {
                                                                cpGeneral.PerformCallback('BusquedaGeneral');
                                                                }
                                                            }
                                                    } " />
                                                    <Image Url="../images/filtro.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                            <td colspan="2" align="left">
                                                <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos" Theme="Glass" Width="100px"
                                                    Style="display: inline" TabIndex="4" AutoPostBack ="false">
                                                    <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                    }" />
                                                    <Image Url="../images/unfunnel.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                    <div style="clear: both">
                    </div>
                    <div style="clear: both; margin-right: 20px; margin-top: 20px; width:65%;">
                        <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" Width="100%" HeaderText="Resultado Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gvDatos" runat="server" Width="70%" AutoGenerateColumns="False"
                                        ClientInstanceName="grid">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="id" Caption="Id." ShowInCustomizationForm="True"
                                                VisibleIndex="0">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="callCenter" Caption="Call Center" ShowInCustomizationForm="True"
                                                VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="usuario" Caption="Usuario Registro" ShowInCustomizationForm="True"
                                                VisibleIndex="2">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="fecha" Caption="Fecha Registro" ShowInCustomizationForm="True"
                                                VisibleIndex="3">
                                                <PropertiesTextEdit DisplayFormatString="{0:d}" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="nombre" Caption="Nombre Cliente" ShowInCustomizationForm="True"
                                                VisibleIndex="4">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="direccion" Caption="Dirección" ShowInCustomizationForm="True" VisibleIndex="5">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="telefono" Caption="Teléfono Móvil" ShowInCustomizationForm="True"
                                                VisibleIndex="6">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="jornada" Caption="Jornada Entrega" ShowInCustomizationForm="True"
                                                VisibleIndex="7">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="fechaEntrega" Caption="Fecha Entrega" ShowInCustomizationForm="True"
                                                VisibleIndex="8">
                                                <PropertiesTextEdit DisplayFormatString="{0:d}" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="estado" Caption="Estado" ShowInCustomizationForm="True"
                                                VisibleIndex="9">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="fechaAprobacion" Caption="Fecha Aprobación" ShowInCustomizationForm="True"
                                                VisibleIndex="10">
                                                <PropertiesTextEdit DisplayFormatString="{0:d}" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="fechaAnulacion" Caption="Fecha Anulación" ShowInCustomizationForm="True"
                                                VisibleIndex="11">
                                                <PropertiesTextEdit DisplayFormatString="{0:d}" />
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsBehavior AutoExpandAllGroups="True" EnableCustomizationWindow="True"></SettingsBehavior>
                                        <SettingsPager PageSize="50">
                                            <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                        </SettingsPager>
                                        <Settings ShowGroupPanel="false"></Settings>
                                        <Settings ShowHeaderFilterButton="True"></Settings>
                                        <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                        <SettingsText Title="Reporte Servicios CallCenter" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda" CommandEdit="Editar"></SettingsText>
                                    </dx:ASPxGridView>
                                    <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos">
                                    </dx:ASPxGridViewExporter>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
        <div id="bluebar" class="menuFlotante">
            <b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4"></b></b>
            <table style="width: 99%;">
                <tr>
                    <td>
                        <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                            SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                            AutoPostBack="false"  ClientInstanceName="cbFormatoExportar"
                            Width="250px">
                            <Items>
                                <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls"
                                    Selected="true" />
                                <dx:ListEditItem ImageUrl="../images/pdf.png" Text="Exportar a PDF" Value="pdf" />
                                <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" Value="csv" />
                            </Items>
                            <Buttons>
                                <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                    <Image Url="../images/upload.png">
                                    </Image>
                                </dx:EditButton>
                            </Buttons>
                            <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                            </ValidationSettings>
                        </dx:ASPxComboBox>
                    </td>
                </tr>
            </table>
        </div>
        <div id="div1" style="float: right; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 2%; position: fixed; overflow: hidden; display: block; bottom: 0px">
            <table>
                <tr>
                    <td align="right">
                        <a style="color: Black; font-size: 15px; cursor: hand; cursor: pointer;" id="a1"
                            onclick="toggle('bluebar');">
                            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/structure.png" ToolTip="Ocultar/Mostrar, Menú "
                                Width="16px" /></a>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
