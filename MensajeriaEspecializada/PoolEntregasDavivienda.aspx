<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolEntregasDavivienda.aspx.vb" Inherits="BPColSysOP.PoolEntregasDavivienda" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        *
{
	padding: 0;
	outline: 0;
            margin-left: 0;
            margin-right: 0;
            margin-top: 0;
        }

.thRojo
{
	border-bottom-width: 2px;
	border: 1px solid #415698;
	background: #415698 url('../img/degradado.png') repeat-x bottom;
	padding-left: 2px;
	padding-right: 2px;
	padding-bottom: 2px;
	padding-top: 2px;
	color: White;
	text-align: center;
	font-weight:bold;	
}

.field
{
	background-position: #415698;
	font-weight: bold;
	background: #415698;
	color: White;
}

    </style>

    <script type="text/javascript" language="javascript">
        String.prototype.trim = function () { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }

        function EjecutarCallbackGeneral(parametro) {
            if (ASPxClientEdit.AreEditorsValid()) {
                cpResultadoReporte.PerformCallback(parametro);
            }
        }

        function EsRangoValido(s, e) {
            var fechaInicio = deFechaInicio.date;
            var fechaFin = deFechaFin.date;

            if ((fechaInicio == null || fechaInicio == false) && (fechaFin != null && fechaFin != false)) { e.isValid = false; return; }
            if ((fechaInicio == null || fechaInicio == false) && (fechaFin != null && fechaFin != false)) { e.isValid = false; return; }

            if (fechaInicio > fechaFin) { e.isValid = false; return; }
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <%--<epg:EncabezadoPagina ID="epNotificador" runat="server" />--%>
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            <br />
        </div>
        <div>
            <dx:ASPxRoundPanel runat="server" ID="rpFiltros" ShowHeader="false">
                <PanelCollection>
                    <dx:PanelContent>
                        <table width="85%">
                            <tr>
                                <th >
                                    <asp:Image ID="imgSearch" runat="server" ImageUrl="~/img/find.gif" />
                                    &nbsp;Filtros de Búsqueda </th>
                            </tr>
                            <tr>
                                <td >Fecha de Gestión 
                                    <table style="padding: 0px !important; border: none !important">
                                        <tr>
                                            <td>De:&nbsp;&nbsp; </td>
                                            <td valign="middle">
                                                <dx:ASPxDateEdit ID="deFechaInicio" runat="server" ClientInstanceName="deFechaInicio">
                                                    <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                    </CalendarProperties>
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="EsRangoValido" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td>&nbsp;-&nbsp; </td>
                                            <td>Hasta:&nbsp;&nbsp; </td>
                                            <td>
                                               <dx:ASPxDateEdit ID="deFechaFin" runat="server" ClientInstanceName="deFechaFin">
                                                    <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                    </CalendarProperties>
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="EsRangoValido" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                     <dx:ASPxButton ID="btnConsultar" runat="server" Text="Consultar Datos" AutoPostBack="True"
                                        Style="display: inline !important;" Width="133px">
                                        <%--<ClientSideEvents Click="function(s, e) { EjecutarCallbackGeneral('obtenerReporte');}" />--%>
                                    </dx:ASPxButton>
                                    &nbsp;&nbsp;&nbsp;
                                    <dx:ASPxButton ID="btnLimpiar" runat="server" AutoPostBack="True" Style="display: inline !important;" Text="Limpiar">
                                        <%--<ClientSideEvents Click="function(s, e) {EjecutarCallbackGeneral('limpiarFiltros');}" />--%>
                                    </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <dx:ASPxButton runat="server" ID="btnVerificacion" Text="Verificar" Visible ="false"></dx:ASPxButton>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <div style="height: 30px;">&nbsp;</div>
            <dx:ASPxRoundPanel runat="server" ID="rpPoolVentas" Width="90%" ShowHeader="false">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallbackPanel runat="server" ID="cbpPoolVentas" Width="100%" ClientInstanceName="cbpPoolVentas">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table>
                                        <tr>
                                            <td>
                                                <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" AutoResizeWithContainer="True" ClientInstanceName="cbFormatoExportar" 
                                                    EnableCallbackMode="True" SelectedIndex="0" ShowImageInEditBox="True" Width="233px">
                                                    <Items>
                                                        <dx:ListEditItem ImageUrl="~/img/excel.gif" Selected="True" Text="Exportar a XLS" Value="xls" />
                                                        <dx:ListEditItem ImageUrl="~/img/pdf.png" Text="Exportar a PDF" Value="pdf" />
                                                        <dx:ListEditItem ImageUrl="~/img/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                                        <dx:ListEditItem ImageUrl="~/img/csv.png" Text="Exportar a CSV" Value="csv" />
                                                    </Items>
                                                    <Buttons>
                                                        <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                                            <Image Url="~/img/Download.png">
                                                            </Image>
                                                        </dx:EditButton>
                                                    </Buttons>
                                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorText="Formato a exportar requerido" ValidationGroup="exportar">
                                                        <RegularExpression ErrorText="Falló la validación de expresión Regular" />
                                                        <RequiredField ErrorText="Formato a exportar requerido" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td>&nbsp;&nbsp;&nbsp; </td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                    </table>
                                    <dx:ASPxGridView runat="server" ID="gvReporte" ClientInstanceName="gvPoolVentas" Width="100%"
                                        AutoGenerateColumns="False" Font-Size="Small" KeyFieldName="idGestionVenta" EnableRowsCache="False">
                                        <SettingsBehavior EnableCustomizationWindow="true" AutoExpandAllGroups="true" />
                                        <Settings ShowTitlePanel="True" ShowHeaderFilterButton="True" ShowHeaderFilterBlankItems="False"
                                            ShowGroupPanel="True"></Settings>
                                        <%--<SettingsText Title="Resultado Verificación Ventas" EmptyDataRow="No se encontraron datos"
                                            CommandEdit="Editar"></SettingsText>--%>
                                        <Columns>
                                            <%--<dx:GridViewDataTextColumn Caption="rowNum" FieldName="rowNum" VisibleIndex="0" Visible="true"></dx:GridViewDataTextColumn>--%>
                                            <%--<dx:GridViewDataTextColumn Caption="ID" FieldName="ID" VisibleIndex="0"></dx:GridViewDataTextColumn>--%>
                                            <dx:GridViewDataTextColumn Caption="Identificacion" FieldName="Identificacion" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="NombreCliente" FieldName="NombreCliente"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Pseudocodigo" FieldName="Pseudocodigo"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="ProductoFinanciero" FieldName="ProductoFinanciero"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Campaña" FieldName="Campaña"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Ciudad" FieldName="Ciudad"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Estado" FieldName="Estado"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Fecha" FieldName="Fecha"></dx:GridViewDataTextColumn>
                                            <%--<dx:GridViewDataTextColumn Caption="TIPO DIRECCION" FieldName="TIPO DIRECCION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="CELULAR TITULAR" FieldName="CELULAR TITULAR"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="TELEFONO ALTERNO" FieldName="TELEFONO ALTERNO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="TIPO TARJETA" FieldName="TIPO TARJETA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="TIPO EMISION" FieldName="TIPO EMISION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="TIPO DE ENTREGA" FieldName="TIPO DE ENTREGA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="FECHA INGRESO" FieldName="FECHA INGRESO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="ESTADO" FieldName="ESTADO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="MOTIVO" FieldName="MOTIVO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="FECHA ULTIMA GESTION" FieldName="FECHA ULTIMA GESTION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="HORA ULTIMA GESTION" FieldName="HORA ULTIMA GESTION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="SUCURSAL DEVOLUCION" FieldName="SUCURSAL DEVOLUCION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="AGENDAMIENTO PRIMERA CITA" FieldName="AGENDAMIENTO PRIMERA CITA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="FECHA PRIMERA MARCACION" FieldName="FECHA PRIMERA MARCACION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="ESTADO PRIMERA MARCACION" FieldName="ESTADO PRIMERA MARCACION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="FECHA PRIMERA CITA" FieldName="FECHA PRIMERA CITA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="HORA PRIMERA CITA" FieldName="HORA PRIMERA CITA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="AGENDAMIENTO ULTIMA CITA" FieldName="AGENDAMIENTO ULTIMA CITA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="ESTADO ULTIMA MARCACION" FieldName="ESTADO ULTIMA MARCACION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="FECHA ULTIMA CITA" FieldName="FECHA ULTIMA CITA"></dx:GridViewDataTextColumn>--%>

                                            <%--<dx:GridViewDataTextColumn Caption="HORA ULTIMA CITA" FieldName="HORA ULTIMA CITA"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="NOMBRE MOTORIZADO" FieldName="NOMBRE MOTORIZADO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="CEDULA MOTORIZADO" FieldName="CEDULA MOTORIZADO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="TIPO DE ENTREGA DEFINITIVO" FieldName="TIPO DE ENTREGA DEFINITIVO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="ESTADO ARQUEO DOCUMENTACION" FieldName="ESTADO ARQUEO DOCUMENTACION"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="FECHA ESTADO ARQUEO" FieldName="FECHA ESTADO ARQUEO"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="NUMERO DE LLAMADAS" FieldName="NUMERO DE LLAMADAS"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="NUMERO DE VISITAS" FieldName="NUMERO DE VISITAS"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="OBS" FieldName="OBS"></dx:GridViewDataTextColumn>--%>

                                        </Columns>
                                    </dx:ASPxGridView>
                                    <br />
                                    <dx:ASPxGridViewExporter ID="gveExportador" runat="server" GridViewID="gvReporte">
                                    </dx:ASPxGridViewExporter>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>
    </form>
</body>
</html>
