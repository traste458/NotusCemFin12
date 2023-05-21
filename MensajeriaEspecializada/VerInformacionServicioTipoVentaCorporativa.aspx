<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VerInformacionServicioTipoVentaCorporativa.aspx.vb" Inherits="BPColSysOP.VerInformacionServicioTipoVentaCorporativa" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPaginaSinTitulo.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<%@ Register Src="~/ControlesDeUsuario/EncabezadoServicioTipoVentaCorporativa.ascx" TagName="EncabezadoServicioTipoVentaCorporativa"
    TagPrefix="es" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Información Detallada Servicio Venta Corporativa ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
</head>
<body class="cuerpo2">
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" Modal="true" ClientInstanceName="LoadingPanel" />
    <dx:ASPxGlobalEvents ID="global" runat="server">
        <ClientSideEvents ControlsInitialized="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxGlobalEvents>
    <script type="text/javascript">
        //LoadingPanel.Show();
        //window.onbeforeunload = doBeforeUnload;
        //function doBeforeUnload() {
        //    LoadingPanel.Show();
        //}

        //function hide() { LoadingPanel.Hide(); }

        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
            //hide();
        }
    </script>
    <div>
        <dx:ASPxLabel ID="lblTitulo" runat="server" ClientInstanceName="lblTitulo" Text="Información Servicio Venta Corporativa" Font-Size="Medium" Font-Bold="True"></dx:ASPxLabel>
    </div>
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado1" runat="server" />
    </div>
    <form id="formPrincipal" runat="server">
<%--        <div style="width: 1280px; text-align: left">
             <img id="imgImprimir" runat="server" src="../images/printOrange.png" alt="Imprimir" 
                style="cursor:pointer; margin-top: 0px; margin-bottom: 5px;" />
        </div>--%>
        <es:EncabezadoServicioTipoVentaCorporativa runat="server" ID="EncabezadoServicioTipoVentaCorporativa" />
        <div style="width: 1150px;">
            <div style="margin-top: 10px; float: left; width: 43%;">
                <dx:ASPxRoundPanel ID="rpRutas" runat="server" HeaderText="Información de Rutas" Width="100%" Theme="SoftOrange">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxGridView ID="gvRutas" runat="server" AutoGenerateColumns="false" Width="100%" Theme="SoftOrange">
                                <Columns>
                                    <dx:GridViewDataTextColumn Caption="ID" FieldName="idRuta"
                                        ShowInCustomizationForm="True" VisibleIndex="0">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Tipo de Ruta" FieldName="tipoRuta"
                                        ShowInCustomizationForm="True" VisibleIndex="1">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Estado"
                                        FieldName="estado" ShowInCustomizationForm="True" VisibleIndex="2">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Fecha Creación"
                                        FieldName="fechaCreacion" ShowInCustomizationForm="True" VisibleIndex="3">
                                        <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Fecha Salida"
                                        FieldName="fechaSalida" ShowInCustomizationForm="True" VisibleIndex="4">
                                        <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Fecha Cierre"
                                        FieldName="fechaCierre" ShowInCustomizationForm="True" VisibleIndex="5">
                                        <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Responsable Entrega"
                                        FieldName="responsableEntrega" ShowInCustomizationForm="True" VisibleIndex="2">
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsPager Visible="False">
                                </SettingsPager>
                            </dx:ASPxGridView>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </div>

            <div style="margin-top: 10px; float: right; width: 43%;">
                <dx:ASPxRoundPanel ID="rpDocumentosAsociados" runat="server" HeaderText="Información de Documentos" Width="100%" Theme="SoftOrange">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table id="tblCombo" runat="server">
                                <tr>
                                    <td>
                                        <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" AutoResizeWithContainer="True"
                                            ClientInstanceName="cbFormatoExportar" EnableCallbackMode="True" SelectedIndex="0"
                                            ShowImageInEditBox="True" Width="300px">
                                            <Items>
                                                <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                            </Items>
                                            <Buttons>
                                                <dx:EditButton Text="Exportar Seriales" ToolTip="Exportar Reporte al formato seleccionado">
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
                                    <td>
                                        <dx:ASPxComboBox ID="cbFormatoExportarAdendo" runat="server" ShowImageInEditBox="true"
                                            SelectedIndex="0" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                            AutoPostBack="false"  ClientInstanceName="cbFormatoExportarPantalla"
                                            Width="300px">
                                            <Items>
                                                <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                            </Items>
                                            <Buttons>
                                                <dx:EditButton Text="Exportar Adendo" ToolTip="Exportar Reporte al formato seleccionado">
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
                            <dx:ASPxGridView ID="gvDocumentos" runat="server" AutoGenerateColumns="False" KeyFieldName="IdDocumento" Width="100%" Theme="SoftOrange">
                                <Columns>
                                    <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="IdDocumento"
                                        ReadOnly="True">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Nombre del Documento" ShowInCustomizationForm="True"
                                        VisibleIndex="1" FieldName="NombreDocumento">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Nombre del Archivo" ShowInCustomizationForm="True"
                                        VisibleIndex="1" FieldName="NombreArchivo">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Fecha de Recepción" ShowInCustomizationForm="True"
                                        VisibleIndex="2" FieldName="FechaRecepcion">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="12" Width="40px">
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink runat="server" ID="lnkVer" ImageUrl="~/images/pdf.png" Cursor="pointer"
                                                ToolTip="Descargar Archivo" OnInit="Link_Init">
                                                <ClientSideEvents Click="function(s, e) { DescargarDocumento({0}) }" />
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Center">
                                        </CellStyle>
                                    </dx:GridViewDataColumn>
                                </Columns>
                            </dx:ASPxGridView>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </div>
        </div>

        <div style="margin-top: 10px; margin-right: 10px; float: left; width: 1280px;">
            <dx:ASPxRoundPanel ID="rpAgenda" runat="server" HeaderText="Información de Agendamientos" Width="100%" Theme="SoftOrange">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvAgendamientos" runat="server" AutoGenerateColumns="false" Width="100%" Theme="SoftOrange">
                            <Columns>
                                <dx:GridViewDataTextColumn Caption="Fecha Agenda Anterior" FieldName="fechaAgendaActual"
                                    ShowInCustomizationForm="True" VisibleIndex="0">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Jornada Agenda Anterior" FieldName="jornadaActual"
                                    ShowInCustomizationForm="True" VisibleIndex="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Fecha Agenda Nueva" FieldName="fechaAgendaNueva"
                                    ShowInCustomizationForm="True" VisibleIndex="2">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Jornada Agenda Nueva" FieldName="jornadaNueva"
                                    ShowInCustomizationForm="True" VisibleIndex="3">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Tipo Agendamiento" FieldName="tipoAgenda"
                                    ShowInCustomizationForm="True" VisibleIndex="4">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Usuario Registro" FieldName="usuarioRegistro"
                                    ShowInCustomizationForm="True" VisibleIndex="5">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>

        <div style="margin-top: 10px; float: left; width: 1280px;">
            <dx:ASPxRoundPanel ID="rpNovedades" runat="server" Width="100%" HeaderText="Novedades" Theme="SoftOrange">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvNovedades" runat="server" AutoGenerateColumns="False" Width="100%" ClientInstanceName="gridNovedad" Theme="SoftOrange">
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="TipoNovedad" ShowInCustomizationForm="True" VisibleIndex="0"
                                    Caption="Tipo de Novedad">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="UsuarioRegistra" ShowInCustomizationForm="True" VisibleIndex="1"
                                    Caption="Registrada Por">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="FechaRegistro" ShowInCustomizationForm="True" VisibleIndex="2"
                                    Caption="Fecha de Registro">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="ComentarioEspecifico" ShowInCustomizationForm="True" VisibleIndex="3"
                                    Caption="Comentario Espec&iacute;fico">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Observacion" ShowInCustomizationForm="True" VisibleIndex="4"
                                    Caption="Comentario General">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <br />
        </div>
        <div>
            <asp:Panel ID="pnlCambioEstado" runat="server" Visible="true">
                <table class="tabla" style="width: 95%">
                    <tr style="background-image: url('00020311'); color: black; font-family: 'trebuchet ms'; font-size: 10pt; font-weight: bold; padding-bottom: 5px; padding-left: 8px; padding-right: 3px; padding-top: 0px;">
                        <td>Información de cambios de estado</td>
                    </tr>
                    <tr>
                        <td style="width: 45%" valign="top">

                            <asp:GridView ID="gvCambioEstado" runat="server" Width="100%" AutoGenerateColumns="false"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen registros asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="idRegistro" HeaderText="Registro No." ItemStyle-HorizontalAlign="Center" Visible="false" />
                                    <asp:BoundField DataField="estadoAnterior" HeaderText="Estado anterior" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="estadoActual" HeaderText="Estado actual" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="usuarioCambio" HeaderText="Usuario de cambio" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="hora" HeaderText="Hora" ItemStyle-HorizontalAlign="Center" />

                                </Columns>
                            </asp:GridView>

                        </td>
                    </tr>
                </table>
            </asp:Panel>

        </div>
    </form>
</body>
</html>
