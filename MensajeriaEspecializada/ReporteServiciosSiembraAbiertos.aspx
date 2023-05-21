<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteServiciosSiembraAbiertos.aspx.vb"
    Inherits="BPColSysOP.ReporteServiciosSiembraAbiertos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Reporte Servicios SIEMBRA Abiertos::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtro de Búsqueda"
        ClientInstanceName="rpFiltros">
        <PanelCollection>
            <dx:PanelContent>
                <table>
                    <tr>
                        <td>
                            Fecha Inicial:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                Width="100px">
                                <ClientSideEvents ValueChanged="function(s, e){
                                        dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                    }" />
                            </dx:ASPxDateEdit>
                        </td>
                        <td>
                            Fecha Final:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                Width="100px">
                                <ClientSideEvents ValueChanged="function(s, e){
                                    if (dateFechaInicio.GetDate()==null){
                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                        }
                                    }" />
                            </dx:ASPxDateEdit>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Días Abiertos:
                        </td>
                        <td>
                            <dx:ASPxSpinEdit ID="seNoDias" runat="server" Height="21px" Number="30" MaxValue="180"
                                MinValue="1" Width="100px">
                            </dx:ASPxSpinEdit>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" Width="100px" AutoPostBack="false">
                                <ClientSideEvents Click="function(s, e) {
                                        gvServicios.PerformCallback();
                                    }" />
                                <Image Url="../images/find.gif">
                                </Image>
                            </dx:ASPxButton>
                        </td>
                        <td colspan="2" align="center">
                            <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                AutoPostBack="false"  ClientInstanceName="cbFormatoExportar"
                                Width="200px">
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
                                    <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular">
                                    </RegularExpression>
                                    <RequiredField IsRequired="True" ErrorText="Formato a exportar requerido"></RequiredField>
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
    <dx:ASPxRoundPanel ID="rpResultadoServicios" runat="server" Style="margin-top: 10px;"
        EnableClientSideAPI="True" HeaderText="Listado de Serviciso Abiertos">
        <PanelCollection>
            <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">
                <dx:ASPxGridView ID="gvServicios" runat="server" AutoGenerateColumns="False" KeyFieldName="IdServicioMensajeria"
                    ClientInstanceName="gvServicios">
                    <ClientSideEvents EndCallback="function(s, e) {
                            if(s.cpMensaje) {
                                $('#divEncabezado').html(s.cpMensaje);
                            }
                        }"></ClientSideEvents>
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="idServicioMensajeria" ShowInCustomizationForm="True" VisibleIndex="0"
                            Caption="ID Servicio">
                            <EditFormSettings Visible="False" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="fechaRegistro" ShowInCustomizationForm="True"
                            VisibleIndex="1" Caption="Fecha Registro">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="fechaAgenda" ShowInCustomizationForm="True" VisibleIndex="2"
                            Caption="Fecha Agenda">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="nombreCiudad" ShowInCustomizationForm="True" VisibleIndex="3"
                            Caption="Ciudad">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="nombreCliente" ShowInCustomizationForm="True" VisibleIndex="4"
                            Caption="Cliente">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="direccionCliente" ShowInCustomizationForm="True" VisibleIndex="5"
                            Caption="Dirección">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="telefonoCliente" ShowInCustomizationForm="True" VisibleIndex="6"
                            Caption="Teléfono">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                </dx:ASPxGridView>
                <dx:ASPxGridViewExporter ID="gveServicios" runat="server" GridViewID="gvServicios">
                </dx:ASPxGridViewExporter>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
    </form>
</body>
</html>
