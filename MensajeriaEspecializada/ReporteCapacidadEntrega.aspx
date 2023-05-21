<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteCapacidadEntrega.aspx.vb"
    Inherits="BPColSysOP.ReporteCapacidadesDeEntrega" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administrar Capacidades de Entrega</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        String.prototype.trim = function () { return this.replace(/^[\s\t\n\r]+|[\s\t\n\r]+$/g, "") }

        function ProcesarCarga(s, e) {
            if (s.cpResultadoProceso != null) {
                if (s.cpResultadoProceso == 0) {

                } else {
                    LoadingPanel.Hide();
                    //btnExportador.DoClick();
                }
                LoadingPanel.Hide();
            }
        }

    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
                <ClientSideEvents CallbackComplete="function(s, e) {
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide(); 
        }" />
            </dx:ASPxCallback>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </div>
            <div style="float: left; margin-right: 20px; margin-bottom: 20px; margin-top: 15px; width: 100%;">
                <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName="cpRegistro">
                    <ClientSideEvents EndCallback="function(s, e) { ProcesarCarga(s, e);
                LoadingPanel.Hide(); }" />
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxRoundPanel ID="rpDespachosg" runat="server" HeaderText="REPORTE DE CAPACIDAD DE ENTREGA"
                                Width="70%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table cellpadding="1" width="90%">
                                            <tr>
                                                <td>Fecha Inicial:
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                        Width="100px">
                                                        <ClientSideEvents ValueChanged="function(s, e){
                                        dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                    }" />
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" ValidationGroup="Filtrado">
                                                            <RequiredField IsRequired="false" ErrorText="Fecha Inicial es Requerida" />
                                                        </ValidationSettings>
                                                    </dx:ASPxDateEdit>
                                                </td>
                                                <td>Fecha Final:
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                        Width="100px">
                                                        <ClientSideEvents ValueChanged="function(s, e){
                                    if (dateFechaInicio.GetDate()==null){
                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                        }
                                    }" />
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" ValidationGroup="Filtrado">
                                                            <RequiredField IsRequired="false" ErrorText="Fecha Final es Requerida" />
                                                        </ValidationSettings>
                                                    </dx:ASPxDateEdit>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="field">Cliente: </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlCliente" runat="server">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="field">Jornada: </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlJornada" runat="server">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="field">Agrupación de Servicios:</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAgrupacion" runat="server">
                                                    </asp:DropDownList>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td class="field">Bodega:</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBodega" runat="server">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="false" GroupName="Filtrado" Text="Consultar"
                                                            ClientInstanceName="btnUpload">
                                                            <ClientSideEvents Click="function(s, e) {  if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null) {
                                                                         alert('Debe seleccionar un rango de fechas');
                                                                             }
                                                                        else {cpRegistro.PerformCallback();}
                                                        }"></ClientSideEvents>
                                                            <Image Url="../images/DxView24.png">
                                                            </Image>
                                                        </dx:ASPxButton>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                        <fieldset>
                                                            <div id="divFileContainer" style="width: auto">
                                                            </div>
                                                        </fieldset>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                                        <dx:ASPxButton ID="btnExportador" runat="server" Text="Descargar" ClientInstanceName="btnExportador"
                                                            ClientVisible="false" OnClick="btnExportador_Click" Width="0px" Height="0px">
                                                            <Image Url="../images/upload.png">
                                                            </Image>
                                                        </dx:ASPxButton>
                                                    </div>
                                                </td>
                                                <td></td>
                                                <td>
                                                    <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                                        <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos">
                                                            <Image Url="../images/eraser_minus.png" />
                                                        </dx:ASPxButton>
                                                    </div>

                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <!-- iframe para uso de selector de fechas -->
                                                    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible; position: absolute; top: -500px"
                                                        name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
                                                        frameborder="0" width="132" scrolling="no" height="142"></iframe>
                                                </td>
                                            </tr>
                                        </table>

                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                            <table>
                                <tr>
                                    <td>
                                        <dx:ASPxGridView ID="gvdatos" runat="server" ClientVisible="false" KeyFieldName="idRegistro" AutoGenerateColumns="true" ClientInstanceName="gvdatos" SettingsBehavior-AllowFocusedRow="true">
                                            <Columns>
                                                 <dx:GridViewDataTextColumn Caption="idRegistro" FieldName="idRegistro" ShowInCustomizationForm="False" Visible="false">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Nit" FieldName="nit" ShowInCustomizationForm="False">
                                                </dx:GridViewDataTextColumn>
                                               <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" ShowInCustomizationForm="False">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="False">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Fecha" FieldName="fecha" ShowInCustomizationForm="False">
                                                    <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy"></PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Jornada" FieldName="jornada" ShowInCustomizationForm="False" Width="30px">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Num. Servicios Programados" FieldName="cantidadServicios" ShowInCustomizationForm="False" Width="30px">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Num. Servicios Utilizados" FieldName="cantidadServiciosUtilizados" ShowInCustomizationForm="False">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Num. Servicios Disponibles" FieldName="cantidadDisponible" ShowInCustomizationForm="False">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Agrupación" FieldName="nombreAgrupacion" ShowInCustomizationForm="False">
                                                </dx:GridViewDataTextColumn>                                                
                                            </Columns>
                                            <SettingsPager PageSize="20">
                                            </SettingsPager>
                                        </dx:ASPxGridView>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="true">
            </dx:ASPxLoadingPanel>
        </div>

    </form>
</body>
</html>
