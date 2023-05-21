<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CruceFisicoVsSolicitado.aspx.vb" Inherits="BPColSysOP.CruceFisicoVsSolicitado" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>::: Cruce Fisico Vs. Solicitado ::: </title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
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

        function VerEjemplo(ctrl) {
            window.location.href = 'Plantillas/EjemploCruceFisicoVsSolicitado.xlsx';
        }

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            LoadingPanel.Show();
            cpGeneral.PerformCallback(parametro + '|' + valor);
        }

        function MostrarErrores() {
            gvErrores.PerformCallback();
            TamanioVentana();
            dialogoErrores.SetSize(myWidth * 0.3, myHeight * 0.6);
            dialogoErrores.ShowWindow();
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function ValidarFiltros(s, e) {
            if (deFechaInicio.GetValue() == null && deFechaFin.GetValue() == null && txtSerial.GetValue() == null &&
                cmbEstado.GetValue() == null) {
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

        function solonumeros(e) {

            var key;

            if (window.event) // IE
            {
                key = e.keyCode;
            }
            else if (e.which) // Netscape/Firefox/Opera
            {
                key = e.which;
            }

            if (key < 48 || key > 57) {
                return false;
            }

            return true;
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div>
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
                <ClientSideEvents EndCallback="function(s,e){ 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            }"></ClientSideEvents>
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallback ID="callback" runat="server" ClientInstanceName="callback">
                            <ClientSideEvents EndCallback="function (s,e){
                             }" />
                        </dx:ASPxCallback>
                        <dx:ASPxPageControl ID="pcConsulta" runat="server" ActiveTabIndex="1" ClientInstanceName="pcConsulta"
                            EnableTheming="True" Height="80%" Theme="Default" Width="100%" ClientVisible="true" Visible="true">
                            <TabPages>
                                <dx:TabPage Text="Cruce de Información" Name="tbMasivo">
                                    <TabImage Url="../images/xlsx_win.png">
                                    </TabImage>
                                    <ContentCollection>
                                        <dx:ContentControl ID="ContentControl2" runat="server">
                                            <dx:ASPxRoundPanel ID="rpAdminCruce" runat="server" ClientInstanceName="rpAdminCruce" ClientVisible="true" HeaderText="Admin. Cruce de Información"
                                                Width="70%" Theme="Default">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table>
                                                            <tr>
                                                                <td>Archivo a cruzar:</td>
                                                                <td>
                                                                    <div id="cargarArchivo">
                                                                        <asp:FileUpload ID="fuArchivo" runat="server" Width="700px" />
                                                                        <asp:Label ID="lblObligatorio" runat="server" ForeColor="Red" Text="*" Width="50px" />
                                                                        <div>
                                                                            <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                                                                                CssClass="listSearchTheme" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivo" Display="Dynamic"
                                                                                ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.xls|.xlsx|.XLSX|.XLS|.Xlsx|.Xls)$" ValidationGroup="validacion"></asp:RegularExpressionValidator>
                                                                            <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                                                                                ControlToValidate="fuArchivo" Display="Dynamic" ValidationGroup="validacion" />
                                                                        </div>
                                                                        <div class="comentario" style="font-size: small">Cargar archivos con extensión (xls o xlsx)</div>

                                                                    </div>
                                                                    <%--<asp:LinkButton ID="lbVerArchivo" runat="server">(Ver Archivo Ejemplo)</asp:LinkButton>--%>
                                                                    <a href="javascript:void(0);" id="A1" onclick="javascript:VerEjemplo($(this));">(Ver Archivo Ejemplo)</a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" align="center">
                                                                    <div style="float: inherit; margin-top: 5px; margin-bottom: 5px;">
                                                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="false" Text="Procesar Cruce"
                                                                            ClientInstanceName="btnUpload" ClientEnabled="true" HorizontalAlign="Justify">
                                                                            <ClientSideEvents Click="function(s, e) { 
                                                                                LoadingPanel.Show(); 
                                                                            }"></ClientSideEvents>
                                                                            <Image Url="../images/upload.png">
                                                                            </Image>
                                                                        </dx:ASPxButton>
                                                                    </div>
                                                                    <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                        <fieldset>
                                                                            <div id="divFileContainer" style="width: auto">
                                                                            </div>
                                                                        </fieldset>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                            <br />
                                            <dx:ASPxRoundPanel ID="rdResultadoCruze" runat="server" HeaderText="Seriales Cruzados Basados en el archivo cargado"
                                                ClientInstanceName="rdResultadoCruze" ClientVisible="false">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table style="width: 99%;">
                                                            <tr>
                                                                <td align="left">
                                                                    <dx:ASPxComboBox ID="cbFormatoExportarCruzados" runat="server" ShowImageInEditBox="true"
                                                                        SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                                        AutoPostBack="false"  ClientInstanceName="cbFormatoExportarCruzados"
                                                                        Width="250px">
                                                                        <Items>
                                                                            <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls" Selected="true" />
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
                                                        <dx:ASPxGridView ID="gvDetalleCruzados" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                                                            ClientInstanceName="gvDetalleCruzados" KeyFieldName="serial">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Producto" FieldName="producto" VisibleIndex="0">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Numero Documento" FieldName="numeroDocumento" VisibleIndex="2">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" VisibleIndex="3">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Serial" FieldName="serial" VisibleIndex="4">
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
                                                            <SettingsText Title="Seriales Cruzados Basados en el archivo cargado" EmptyDataRow="No se encontraron datos acordes con los datos suministrados"
                                                                CommandEdit="Editar"></SettingsText>
                                                            <SettingsBehavior EnableCustomizationWindow="False" AutoExpandAllGroups="False" />
                                                        </dx:ASPxGridView>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                            <dx:ASPxGridViewExporter ID="gveExportadorCruzados" runat="server" GridViewID="gvDetalleCruzados">
                                            </dx:ASPxGridViewExporter>
                                            <br />
                                            <dx:ASPxRoundPanel ID="rdResultadoNoCruze" runat="server" HeaderText="Seriales No Cruzados Basados en el archivo cargado"
                                                ClientInstanceName="rdResultadoNoCruze" ClientVisible="false">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table style="width: 99%;">
                                                            <tr>
                                                                <td align="left">
                                                                    <dx:ASPxComboBox ID="cbFormatoExportarNoCruzados" runat="server" ShowImageInEditBox="true"
                                                                        SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                                        AutoPostBack="false"  ClientInstanceName="cbFormatoExportarNoCruzados"
                                                                        Width="250px">
                                                                        <Items>
                                                                            <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls" Selected="true" />
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
                                                        <dx:ASPxGridView ID="gvDetalleNoCruzados" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                                                            ClientInstanceName="gvDetalleNoCruzados" KeyFieldName="serial">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Serial" FieldName="serial" VisibleIndex="0">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                    <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <Settings ShowFooter="false" ShowHeaderFilterButton="true" />
                                                            <SettingsPager PageSize="10">
                                                                <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                                <PageSizeItemSettings ShowAllItem="True" Visible="True">
                                                                </PageSizeItemSettings>
                                                            </SettingsPager>
                                                            <Settings ShowHeaderFilterButton="True"></Settings>
                                                            <SettingsText Title="Seriales No Cruzados Basados en el archivo cargado" EmptyDataRow="No se encontraron datos acordes con los datos suministrados"
                                                                CommandEdit="Editar"></SettingsText>
                                                            <SettingsBehavior EnableCustomizationWindow="False" AutoExpandAllGroups="False" />
                                                        </dx:ASPxGridView>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                            <dx:ASPxGridViewExporter ID="gveExportadorNoCruzados" runat="server" GridViewID="gvDetalleNoCruzados">
                                            </dx:ASPxGridViewExporter>
                                            <br />
                                            <dx:ASPxPopupControl ID="pcErrores" runat="server" ClientInstanceName="dialogoErrores" ScrollBars="Auto"
                                                HeaderText="Resultado Consulta - Log de Errores" AllowDragging="true" Width="450px" Height="500px"
                                                Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl ID="pccError" runat="server">
                                                        <table>
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
                                                        <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores">
                                                            <SettingsPager PageSize="10">
                                                            </SettingsPager>
                                                        </dx:ASPxGridView>
                                                        <dx:ASPxGridViewExporter ID="gveErrores" runat="server" GridViewID="gvErrores">
                                                        </dx:ASPxGridViewExporter>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>
                                <dx:TabPage Text="Consulta de Historico de cruces" Name="tbIndividual">
                                    <TabImage Url="../images/usuario.png">
                                    </TabImage>
                                    <ContentCollection>
                                        <dx:ContentControl ID="ContentControl1" runat="server">
                                            <dx:ASPxRoundPanel ID="rpAdministradorConsulta" ClientInstanceName="rpAdministradorConsulta" ClientVisible="true" runat="server" HeaderText="Consulta Seriales Cruzados Fisicos Vs Solicitados"
                                                Width="70%" Theme="Default">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table cellpadding="1" width="100%">
                                                            <tr>
                                                                <td class="field" align="left">Serial:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtSerial" ClientInstanceName="txtSerial" runat="server" Width="250px" MaxLength="22" onkeypress="return solonumeros(event);">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </td>
                                                                <td class="field" align="left">Estado Cruce:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxComboBox ID="cmbEstado" runat="server" ClientInstanceName="cmbEstado" 
                                                                        ValueType="System.Int32"  Width="250px">
                                                                        <Items>
                                                                            <dx:ListEditItem Text="Cruzados" Value="1" Selected="false" />
                                                                            <dx:ListEditItem Text="No Cruzados" Value="0" Selected="false" />
                                                                        </Items>
                                                                    </dx:ASPxComboBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="field">Fecha cruce Inicial:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxDateEdit ID="deFechaInicio" runat="server" ClientInstanceName="deFechaInicio"
                                                                        TabIndex="3" Width="250px">
                                                                        <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                                        </CalendarProperties>
                                                                               </dx:ASPxDateEdit>
                                                                </td>
                                                                <td class="field">Fecha cruce Final:
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
                                            </dx:ASPxRoundPanel>
                                            <br />
                                            <dx:ASPxRoundPanel ID="rpConsulta" runat="server" HeaderText="Consulta Seriales cruzados y no cruzados"
                                                ClientInstanceName="rpConsulta" ClientVisible="false" Width="80%">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table style="width: 99%;">
                                                            <tr>
                                                                <td align="left">
                                                                    <dx:ASPxComboBox ID="cbFormatoExportarConsulta" runat="server" ShowImageInEditBox="true"
                                                                        SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                                        AutoPostBack="false"  ClientInstanceName="cbFormatoExportarConsulta"
                                                                        Width="250px">
                                                                        <Items>
                                                                            <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls" Selected="true" />
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
                                                        <dx:ASPxGridView ID="gvConsulta" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                                                            ClientInstanceName="gvConsulta" KeyFieldName="serial" Width="98%">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Producto" FieldName="producto" VisibleIndex="0">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Numero Documento" FieldName="numeroDocumento" VisibleIndex="2">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" VisibleIndex="3">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Serial" FieldName="serial" VisibleIndex="4">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Fecha Cruce" FieldName="fechaCruce" VisibleIndex="5">
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <Settings ShowFooter="false" ShowHeaderFilterButton="true" />
                                                            <SettingsPager PageSize="50">
                                                                <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                                <PageSizeItemSettings ShowAllItem="True" Visible="True">
                                                                </PageSizeItemSettings>
                                                            </SettingsPager>
                                                            <Settings ShowHeaderFilterButton="True"></Settings>
                                                            <SettingsText Title="Consulta de Seriales Cruzados y No Cruzados" EmptyDataRow="No se encontraron datos acordes con los datos suministrados"
                                                                CommandEdit="Editar"></SettingsText>
                                                            <SettingsBehavior EnableCustomizationWindow="False" AutoExpandAllGroups="False" />
                                                        </dx:ASPxGridView>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                            <dx:ASPxGridViewExporter ID="gveExportadorConsulta" runat="server" GridViewID="gvConsulta">
                                            </dx:ASPxGridViewExporter>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>
                            </TabPages>
                        </dx:ASPxPageControl>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
