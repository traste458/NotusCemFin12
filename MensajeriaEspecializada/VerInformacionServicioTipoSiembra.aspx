<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VerInformacionServicioTipoSiembra.aspx.vb" Inherits="BPColSysOP.VerInformacionServicioTipoSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoServicioTipoSiembra.ascx" TagName="EncabezadoSiembra"
    TagPrefix="es" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>.:: Información Detallada Servicio Siembra ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        function VerImpresion(key) {
            var w = 800;
            var h = 600;
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);

            window.open('Reportes/VisorImpresionServicioSiembra.aspx?id=' + key, 'Impresión', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        }

        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
        }
    </script>
</head>
<body class="cuerpo2" >
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <form id="formPrincipal" runat="server">
        <div style="width: 100%; text-align:center";>
            <img id="imgImprimir" runat="server" src="../images/printOrange.png" alt="Imprimir" 
                style="cursor:pointer; margin-top: 5px; margin-bottom: 5px;" />
        </div>
        
        <es:EncabezadoSiembra runat="server" ID="esEncabezado" />

        <div style="margin-top: 10px; margin-right: 10px; float:left; width: 48%;">
            <dx:ASPxRoundPanel ID="rpSeriales" runat="server" HeaderText="Información de Referencias"
                Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvReferencias" runat="server" AutoGenerateColumns="false" 
                            Width="100%">
                            <Columns>
                                <dx:GridViewDataTextColumn Caption="Material" FieldName="Material" 
                                    ShowInCustomizationForm="True" VisibleIndex="0">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Descripción Material" FieldName="DescripcionMaterial" 
                                    ShowInCustomizationForm="True" VisibleIndex="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Cantidad" 
                                    FieldName="Cantidad" ShowInCustomizationForm="True" VisibleIndex="2">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                            <SettingsPager Visible="False" PageSize="20">
                            </SettingsPager>
                        </dx:ASPxGridView>

                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>

        <div style="margin-top: 10px; float:left; width: 48%;">
            <dx:ASPxRoundPanel ID="rpMins" runat="server" HeaderText="Información de MSISDNs"
                Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvMins" runat="server" AutoGenerateColumns="False" 
                            Width="100%">
                            <Columns>
                                <dx:GridViewDataTextColumn Caption="MSISDN" FieldName="MSISDN" 
                                    ShowInCustomizationForm="True" VisibleIndex="0">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Plan" FieldName="NombrePlan" 
                                    ShowInCustomizationForm="True" VisibleIndex="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Fecha Devolución" 
                                    FieldName="FechaDevolucion" ShowInCustomizationForm="True" VisibleIndex="2">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                            </Columns>
                            <SettingsPager Visible="False" PageSize="20">
                            </SettingsPager>
                        </dx:ASPxGridView>

                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>

        <div style="margin-top: 10px; float:left; width: 96%;">
            <dx:ASPxRoundPanel ID="rpRutas" runat="server" HeaderText="Información de Rutas"
                Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvRutas" runat="server" AutoGenerateColumns="false" 
                            Width="100%">
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

        <div style="margin-top: 10px; float:left; width: 96%;">
        <dx:ASPxRoundPanel ID="rpDocumentosAsociados" runat="server" HeaderText="Información de Documentos"
            Width="100%">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridView ID="gvDocumentos" runat="server" AutoGenerateColumns="False" KeyFieldName="IdDocumento">
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
        <div style="margin-top: 10px; margin-right: 10px; float:left; width: 60%;">
            <dx:ASPxRoundPanel ID="rpAgenda" runat="server" HeaderText="Información de Agendamientos" Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvAgendamientos" runat="server" AutoGenerateColumns="false" 
                            Width="100%">
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
              <asp:Panel ID="pnlCambioEstado" runat="server" Visible="true">
            <table class="tabla" style="width: 95%">
                <tr style="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
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
