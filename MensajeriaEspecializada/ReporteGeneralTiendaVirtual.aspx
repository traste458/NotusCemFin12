<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteGeneralTiendaVirtual.aspx.vb" Inherits="BPColSysOP.ReporteGeneralTiendaVirtual" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>.:: Reporte de General Ventas Web ::.</title>
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
                cbFormatoExportarPantalla.SetSelectedIndex(0);
            }
        }

        function EsRangoValido(s, e) {
            deFechaInicio.SetIsValid(true);
            deFechaFin.SetIsValid(true);

            var fechaInicio = deFechaInicio.date;
            var fechaFin = deFechaFin.date;

            if ((fechaInicio == null || fechaInicio == false) && (fechaFin != null && fechaFin != false)) {
                e.isValid = false;
                btnFiltrar.SetEnabled(false);
                e.errorText = "No se han proporcionado los dos valores del rango";
                return;
            }
            if ((fechaFin == null || fechaFin == false) && (fechaInicio != null && fechaInicio != false)) {
                e.isValid = false;
                btnFiltrar.SetEnabled(false);
                e.errorText = "No se han proporcionado los dos valores del rango";
                return;
            }

            if (fechaInicio > fechaFin) {
                e.isValid = false;
                btnFiltrar.SetEnabled(false);
                e.errorText = "Dato no válido. Fecha inicial menor que Fecha final"
                return;
            }
            if (fechaInicio <= fechaFin) {
                e.isValid = true;
                btnFiltrar.SetEnabled(true);
                e.errorText = ""
                return;
            }
        }

        function EsRangoValidoRegistro(s, e) {
            deFechaInicioRegistro.SetIsValid(true);
            deFechaFinRegistro.SetIsValid(true);

            var fechaInicio = deFechaInicioRegistro.date;
            var fechaFin = deFechaFinRegistro.date;

            if ((fechaInicio == null || fechaInicio == false) && (fechaFin != null && fechaFin != false)) {
                e.isValid = false;
                btnFiltrar.SetEnabled(false);
                e.errorText = "No se han proporcionado los dos valores del rango";
                return;
            }
            if ((fechaFin == null || fechaFin == false) && (fechaInicio != null && fechaInicio != false)) {
                e.isValid = false;
                btnFiltrar.SetEnabled(false);
                e.errorText = "No se han proporcionado los dos valores del rango";
                return;
            }

            if (fechaInicio > fechaFin) {
                e.isValid = false;
                btnFiltrar.SetEnabled(false);
                e.errorText = "Dato no válido. Fecha inicial menor que Fecha final"
                return;
            }
            if (fechaInicio <= fechaFin) {
                e.isValid = true;
                btnFiltrar.SetEnabled(true);
                e.errorText = ""
                return;
            }
        }

        function BuscarRegistros(s, e) {
            if (memoRadicado.GetValue() == null && memoMSISDN.GetValue() == null && txtCadena.GetValue() == null
                && cmbEstado.GetValue() == null && deFechaInicio.GetDate() == null && deFechaFin.GetDate() == null && deFechaInicioRegistro.GetDate() == null && deFechaFinRegistro.GetDate() == null) {
                alert('Por favor seleccione al menos un filtro de búsqueda.');
            } else {
                //gvDatos.PerformCallback();
                LoadingPanel.Show();
                pivotGrid.PerformCallback();
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
                ClientInstanceName="rpFiltros" Theme="SoftOrange">
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
                                            <td class="field" align="left" rowspan="2">Radicado:
                                            </td>
                                            <td rowspan="2">
                                                <dx:ASPxMemo ID="memoRadicado" runat="server" Height="50px" Width="200px" ClientInstanceName="memoRadicado">
                                                </dx:ASPxMemo>
                                            </td>
                                            <td class="field" align="left" rowspan="2">MSISDN:
                                            </td>
                                            <td rowspan="2">
                                                <dx:ASPxMemo ID="memoMSISDN" runat="server" Height="50px" Width="200px" ClientInstanceName="memoMSISDN">
                                                </dx:ASPxMemo>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="field" align="left">Cadena:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtCadena" runat="server" Width="150px" ClientInstanceName="txtCadena">
                                                </dx:ASPxTextBox>
                                            </td>
                                            <td class="field" align="left">Estado:
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbEstado" runat="server" IncrementalFilteringMode="Contains"
                                                    Width="150px" ValueField="idEstado" ClientInstanceName="cmbEstado" DropDownStyle="DropDownList">
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="field" align="left">Fecha Entrega Inicial:
                                            </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaInicio" runat="server" ClientInstanceName="deFechaInicio" Width="150px">
                                                    <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                    </CalendarProperties>
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText=""
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="EsRangoValido" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td class="field" align="left">Fecha Entrega Final:
                                            </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaFin" runat="server" ClientInstanceName="deFechaFin" Width="150px">
                                                    <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                    </CalendarProperties>
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText=""
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="EsRangoValido" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td class="field" align="left">Fecha Registro Inicial:
                                            </td>
                                            <td valign="middle">
                                                <dx:ASPxDateEdit ID="deFechaInicioRegistro" runat="server" ClientInstanceName="deFechaInicioRegistro" Width="150px">
                                                    <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                    </CalendarProperties>
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText=""
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="EsRangoValidoRegistro" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td class="field" align="left">Fecha Registro Final:
                                            </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaFinRegistro" runat="server" ClientInstanceName="deFechaFinRegistro" Width="150px">
                                                    <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                    </CalendarProperties>
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText=""
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="EsRangoValidoRegistro" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" Width="100px" AutoPostBack="false" ClientInstanceName="btnFiltrar">
                                                    <ClientSideEvents Click="function(s, e) {
                                                    BuscarRegistros(s, e);
                                                    }"></ClientSideEvents>
                                                    <Image Url="../images/filtro.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                            <td align="center">
                                                <dx:ASPxButton ID="btnLimpiar" runat="server" AutoPostBack="False" Text="Limpiar Campos"
                                                    Width="150px">
                                                    <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                        gvDatos.PerformCallback();
                                                    }" />
                                                    <Image Url="../images/unfunnel.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                            <td colspan="2" align="center">
                                                <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" AutoResizeWithContainer="True"
                                                    ClientInstanceName="cbFormatoExportar" EnableCallbackMode="True" SelectedIndex="0"
                                                    ShowImageInEditBox="True" Width="300px">
                                                    <Items>
                                                        <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                                    </Items>
                                                    <Buttons>
                                                        <dx:EditButton Text="Exportar Detallado" ToolTip="Exportar Reporte al formato seleccionado">
                                                            <Image Url="../images/upload.png">
                                                            </Image>
                                                        </dx:EditButton>
                                                    </Buttons>
                                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorText="Formato a exportar requerido"
                                                        ValidationGroup="exportar">
                                                        <RegularExpression ErrorText="Falló la validación de expresión Regular" />
                                                        <RequiredField ErrorText="Formato a exportar requerido" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td colspan="2" align="center">
                                                <dx:ASPxComboBox ID="cbFormatoExportarPantalla" runat="server" ShowImageInEditBox="true"
                                                    SelectedIndex="0" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                    AutoPostBack="false"  ClientInstanceName="cbFormatoExportarPantalla"
                                                    Width="300px">
                                                    <Items>
                                                        <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls"
                                                            Selected="true" />
                                                        <dx:ListEditItem ImageUrl="../images/pdf.png" Text="Exportar a PDF" Value="pdf" />
                                                        <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" Value="csv" />
                                                    </Items>
                                                    <Buttons>
                                                        <dx:EditButton Text="Exportar Información de Pantalla" ToolTip="Exportar Reporte al formato seleccionado">
                                                            <Image Url="../images/upload.png">
                                                            </Image>
                                                        </dx:EditButton>
                                                    </Buttons>
                                                    <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                                        Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                                        <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                                        <RequiredField IsRequired="True" ErrorText="Formato a exportar requerido"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                    </table>
                                    <div style="margin-top: 10px">
                                        <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" Width="85%" HeaderText="Resultado Búsqueda"
                                            Style="margin-bottom: 20px;" Theme="SoftOrange">
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <dx:ASPxPivotGrid ID="pivotGrid" runat="server" ClientInstanceName="pivotGrid" OptionsLoadingPanel-Enabled="false" Theme="SoftOrange">
                                                        <ClientSideEvents EndCallback="function (s, e){
                                LoadingPanel.Hide();
                                $('#divEncabezado').html(s.cpMensaje);
                            }" />
                                                        <Fields>
                                                            <dx:PivotGridField Area="RowArea" AreaIndex="0" FieldName="Ciudad" Caption="Ciudad"
                                                                ID="City">
                                                            </dx:PivotGridField>
                                                            <dx:PivotGridField Area="RowArea" AreaIndex="1" FieldName="Mes" Caption="Mes"
                                                                ID="Month">
                                                            </dx:PivotGridField>
                                                            <dx:PivotGridField Area="RowArea" AreaIndex="2" FieldName="Año" Caption="Año"
                                                                GroupInterval="DateYear" ID="Year" />
                                                            <dx:PivotGridField Area="RowArea" AreaIndex="3" FieldName="Cadena" Caption="Cadena"
                                                                ID="Store" />
                                                            <dx:PivotGridField Area="RowArea" AreaIndex="4" FieldName="Estado" Caption="Estado"
                                                                ID="Been" />
                                                            <dx:PivotGridField Area="RowArea" AreaIndex="5" FieldName="Radicado" Caption="Radicado"
                                                                ID="numeroRadicado" />
                                                            <dx:PivotGridField Area="DataArea" AllowedAreas="DataArea" AreaIndex="1" FieldName="cantidad" Caption="Total"
                                                                ID="Total" SummaryType="Count" EmptyCellText="0" EmptyValueText="0" />
                                                        </Fields>
                                                        <OptionsView ShowHorizontalScrollBar="true"></OptionsView>
                                                        <OptionsPager RowsPerPage="20" PageSizeItemSettings-Visible="true" PageSizeItemSettings-ShowAllItem="true">
                                                            <PageSizeItemSettings ShowAllItem="True" Visible="True"></PageSizeItemSettings>
                                                        </OptionsPager>

                                                        <OptionsLoadingPanel Enabled="False"></OptionsLoadingPanel>
                                                    </dx:ASPxPivotGrid>
                                                    <dx:ASPxPivotGridExporter ID="pgeExportador" runat="server" ASPxPivotGridID="pivotGrid" Visible="False"></dx:ASPxPivotGridExporter>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxRoundPanel>
                                    </div>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>
        <div style="clear: both">
        </div>

        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>

