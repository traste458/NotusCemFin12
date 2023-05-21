<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteCruceRealceVsFisico.aspx.vb"
    Inherits="BPColSysOP.ReporteCruceRealceVsFisico" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Reporte Cruce Solicitud Realce Vs. Fisico</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                loadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

        function OnExpandCollapseButtonClick(s, e) {
            var isVisible = pnlFiltros.GetVisible();
            s.SetText(isVisible ? "+" : "-");
            pnlFiltros.SetVisible(!isVisible);
        }

        function Seleccionar(s, e) {
            s.SelectAll();
        }

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

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function ValidarFiltros(s, e) {
            if (deFechaInicio.GetValue() == null && deFechaFin.GetValue() == null &&
                cbBodega.GetValue() == null && cbBase.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro de búsqueda.');
            } else {
                if (deFechaInicio.GetValue() == null && deFechaFin.GetValue() != null) {
                    alert('Debe digitar los dos rangos de fechas.');
                } else {
                    if (deFechaInicio.GetValue() != null && deFechaFin.GetValue() == null) {
                        alert('Debe digitar los dos rangos de fechas.');
                    } else { EjecutarCallbackGeneral(s, e, 'filtrarDatos'); }
                }
            }

        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
            <ClientSideEvents EndCallback="function(s,e){ 
                $('#divEncabezado').html(s.cpMensaje);
                loadingPanel.Hide();
            }" />
            <LoadingDivStyle CssClass="modalBackground">
            </LoadingDivStyle>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hfDimensiones" ClientInstanceName="hfDimensiones" runat="server">
                    </dx:ASPxHiddenField>
                    <div id="divEncabezado">
                        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
                        <br />
                    </div>
                    <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtros de B&uacute;squeda">
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="white-space: nowrap;" align="left">Filtros de B&uacute;squeda
                                    </td>
                                    <td style="width: 1%; padding-left: 5px;">
                                        <dx:ASPxButton ID="btnExpandCollapse" runat="server" Text="-" AllowFocus="False"
                                            AutoPostBack="False" Width="20px">
                                            <Paddings Padding="1px" />
                                            <FocusRectPaddings Padding="0" />
                                            <ClientSideEvents Click="OnExpandCollapseButtonClick" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxPanel ID="pnlFiltros" runat="server" Width="100%" ClientInstanceName="pnlFiltros">
                                    <Paddings Padding="0px" />
                                    <Paddings Padding="0px"></Paddings>
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table>
                                                <tr>
                                                    <td class="field">Bodega:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cbBodega" runat="server" ClientInstanceName="cbBodega"
                                                            TabIndex="1" Width="250px" EnableCallbackMode="false">
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                    <td class="field">Base:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cbBase" runat="server" ClientInstanceName="cbBase" ValueType="System.Int32"
                                                            TabIndex="2" Width="250px" EnableCallbackMode="false">
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field">Fecha Venta Inicial:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="deFechaInicio" runat="server" ClientInstanceName="deFechaInicio"
                                                            TabIndex="3" Width="250px">
                                                            <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                            </CalendarProperties>
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td class="field">Fecha Venta Final:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="deFechaFin" runat="server" ClientInstanceName="deFechaFin" TabIndex="4"
                                                            Width="250px">
                                                            <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                            </CalendarProperties>
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="padding-top: 8px">
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td style="white-space: nowrap;" align="center">
                                                                    <dx:ASPxButton ID="btnBuscar" runat="server" Text="Buscar" Style="display: inline!important;"
                                                                        AutoPostBack="false" ValidationGroup="Filtrado" TabIndex="6" ClientInstanceName="btnBuscar" HorizontalAlign="Justify">
                                                                        <ClientSideEvents Click="function(s, e) { ValidarFiltros(s, e); }"></ClientSideEvents>
                                                                        <Image Url="~/images/find.gif">
                                                                        </Image>
                                                                        <ClientSideEvents Click="function(s, e) { ValidarFiltros(s, e); }" />
                                                                    </dx:ASPxButton>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;<dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar"
                                                                        Style="display: inline!important;" AutoPostBack="false" TabIndex="7" HorizontalAlign="Justify">
                                                                        <ClientSideEvents Click="function(s, e) { LimpiaFormulario(); }"></ClientSideEvents>
                                                                        <Image Url="~/images/eraserminus.gif">
                                                                        </Image>
                                                                        <ClientSideEvents Click="function(s, e) { LimpiaFormulario(); }" />
                                                                    </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <div style="clear: both;">
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxPanel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                    <br />
                    <dx:ASPxRoundPanel ID="rdResultado" runat="server" HeaderText="Resultado de Búsqueda"
                        ClientInstanceName="rdResultado">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table style="width: 99%;">
                                    <tr>
                                        <td align="left">
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
                                <br />
                                <dx:ASPxGridView ID="gvDetalle" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                                    ClientInstanceName="gvDetalle" KeyFieldName="ultimosTC">
                                    <Columns>
                                        <dx:GridViewDataTextColumn Caption="Canal" FieldName="canal" VisibleIndex="0" Visible="True">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Proceso/Producto" FieldName="procesoproducto" VisibleIndex="1">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Fecha Solicitud Realce" FieldName="fechaSolicitud" VisibleIndex="2">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="idOportunidad" FieldName="idOportunidad" VisibleIndex="3">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Tipo Documento" FieldName="tipoDocumento" VisibleIndex="4">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Numero Documento" FieldName="numeroDocumento" VisibleIndex="5">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" VisibleIndex="6">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Base" FieldName="base" VisibleIndex="7">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Serial" FieldName="serial" VisibleIndex="8">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <Settings ShowFooter="false" ShowHeaderFilterButton="true" />
                                    <SettingsPager PageSize="10">
                                        <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                        <PageSizeItemSettings ShowAllItem="True" Visible="True">
                                        </PageSizeItemSettings>
                                    </SettingsPager>
                                    <Settings ShowHeaderFilterButton="True"></Settings>
                                    <SettingsText Title="Reporte Cruce Solicitud Realce Vs. Fisico" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"
                                        CommandEdit="Editar"></SettingsText>
                                    <SettingsBehavior EnableCustomizationWindow="False" AutoExpandAllGroups="False" />
                                </dx:ASPxGridView>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                    <dx:ASPxGridViewExporter ID="gveExportador" runat="server" GridViewID="gvDetalle">
                    </dx:ASPxGridViewExporter>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxLoadingPanel ID="loadingPanel" runat="server" ClientInstanceName="loadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
